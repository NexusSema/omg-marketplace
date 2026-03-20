#!/usr/bin/env python3
"""
Draw.io Edge Collision Checker for SDLC Plugin.

Detects edges that cross through element containers in a .drawio file.
Used as a PostToolUse hook — reads CLAUDE_TOOL_USE_FILE env var.

Exit codes:
  0 = no collisions (or not a .drawio file)
  0 = collisions found (reports to stdout for agent to act on)

Output format: structured report that the c4-diagram-generator agent
can parse and use to fix edge routing issues.
"""

import os
import sys
import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class BBox:
    x: float; y: float; w: float; h: float

    @property
    def x2(self): return self.x + self.w
    @property
    def y2(self): return self.y + self.h

    def intersects_segment(self, x1, y1, x2, y2, margin=4.0):
        bx1, by1 = self.x + margin, self.y + margin
        bx2, by2 = self.x2 - margin, self.y2 - margin
        if abs(x1 - x2) < 1:  # vertical
            if bx1 < x1 < bx2:
                if max(min(y1, y2), by1) < min(max(y1, y2), by2):
                    return True
        elif abs(y1 - y2) < 1:  # horizontal
            if by1 < y1 < by2:
                if max(min(x1, x2), bx1) < min(max(x1, x2), bx2):
                    return True
        return False


@dataclass
class CellInfo:
    cell_id: str; parent_id: str; style: str = ""; value: str = ""
    x: float = 0; y: float = 0; w: float = 0; h: float = 0
    is_vertex: bool = False; is_edge: bool = False
    source_id: Optional[str] = None; target_id: Optional[str] = None
    waypoints: list = field(default_factory=list)
    source_point: Optional[tuple] = None; target_point: Optional[tuple] = None


def parse_style(s):
    r = {}
    if not s: return r
    for p in s.split(";"):
        if "=" in p:
            k, v = p.split("=", 1)
            r[k.strip()] = v.strip()
        elif p.strip():
            r[p.strip()] = True
    return r


def clean_html(v):
    if not v: return ""
    c = re.sub(r"<[^>]+>", "", v)
    c = c.replace("&#xa;", " ").replace("&amp;", "&").replace("&bull;", "·")
    return re.sub(r"\s+", " ", c).strip()[:60]


def is_element_container(style, value, cell):
    if not value or not value.strip(): return False
    if "text" in style: return False
    if style.get("pointerEvents") == "0": return False
    if "opacity" in style and float(style.get("opacity", "100")) < 70: return False
    if cell and cell.w > 800 and cell.h > 400 and "swimlane" in style: return False
    cv = re.sub(r"<[^>]+>", "", value).strip().lower() if value else ""
    if "legend" in cv: return False
    for kw in ["nfr", "key nfr", "namespace map", "kafka topics", "hitl",
               "data sovereignty", "interaction sdk"]:
        if kw in cv: return False
    return True


def compute_absolute_bbox(cid, cells):
    c = cells.get(cid)
    if not c or not c.is_vertex: return None
    ax, ay = c.x, c.y
    pid = c.parent_id
    while pid and pid in cells:
        p = cells[pid]
        if p.is_vertex: ax += p.x; ay += p.y
        pid = p.parent_id
    return BBox(ax, ay, c.w, c.h)


def compute_parent_offset(cid, cells):
    c = cells.get(cid)
    if not c: return (0, 0)
    ax, ay = 0.0, 0.0
    pid = c.parent_id
    while pid and pid in cells:
        p = cells[pid]
        if p.is_vertex: ax += p.x; ay += p.y
        pid = p.parent_id
    return (ax, ay)


def get_edge_path(edge, cells):
    pts = []
    ox, oy = compute_parent_offset(edge.cell_id, cells)
    if edge.source_point:
        pts.append((edge.source_point[0] + ox, edge.source_point[1] + oy))
    elif edge.source_id and edge.source_id in cells:
        b = compute_absolute_bbox(edge.source_id, cells)
        if b: pts.append((b.x + b.w / 2, b.y + b.h / 2))
    for wp in edge.waypoints:
        pts.append((wp[0] + ox, wp[1] + oy))
    if edge.target_point:
        pts.append((edge.target_point[0] + ox, edge.target_point[1] + oy))
    elif edge.target_id and edge.target_id in cells:
        b = compute_absolute_bbox(edge.target_id, cells)
        if b: pts.append((b.x + b.w / 2, b.y + b.h / 2))
    return pts


def check_file(filepath):
    tree = ET.parse(filepath)
    root = tree.getroot()
    gm = root.find(".//mxGraphModel")
    if gm is None: gm = root
    mr = gm.find("root")
    if mr is None: return 0

    # Parse cells
    cells = {}
    for ce in mr.findall("mxCell"):
        info = CellInfo(
            cell_id=ce.get("id", ""), parent_id=ce.get("parent", ""),
            style=ce.get("style", ""), value=ce.get("value", ""),
            is_vertex=ce.get("vertex") == "1", is_edge=ce.get("edge") == "1",
            source_id=ce.get("source"), target_id=ce.get("target"))
        geom = ce.find("mxGeometry")
        if geom is not None:
            info.x = float(geom.get("x", "0"))
            info.y = float(geom.get("y", "0"))
            info.w = float(geom.get("width", "0"))
            info.h = float(geom.get("height", "0"))
            for ch in geom:
                if ch.tag == "mxPoint":
                    a = ch.get("as", "")
                    px = float(ch.get("x", "0"))
                    py = float(ch.get("y", "0"))
                    if a == "sourcePoint": info.source_point = (px, py)
                    elif a == "targetPoint": info.target_point = (px, py)
                if ch.tag == "Array" and ch.get("as") == "points":
                    for pt in ch.findall("mxPoint"):
                        info.waypoints.append(
                            (float(pt.get("x", "0")), float(pt.get("y", "0"))))
        cells[info.cell_id] = info

    # Build element boxes
    elem_boxes = {}
    for cid, cell in cells.items():
        if not cell.is_vertex: continue
        style = parse_style(cell.style)
        if not is_element_container(style, cell.value, cell): continue
        bbox = compute_absolute_bbox(cid, cells)
        if bbox and bbox.w > 10 and bbox.h > 10:
            elem_boxes[cid] = (bbox, clean_html(cell.value))

    # Check edges
    collisions = []
    for eid, edge in cells.items():
        if not edge.is_edge or eid.startswith("leg"): continue
        path = get_edge_path(edge, cells)
        if len(path) < 2: continue

        skip = {edge.source_id, edge.target_id}
        if edge.source_id and edge.source_id in cells:
            skip.add(cells[edge.source_id].parent_id)
        if edge.target_id and edge.target_id in cells:
            skip.add(cells[edge.target_id].parent_id)

        for i in range(len(path) - 1):
            x1, y1 = path[i]
            x2, y2 = path[i + 1]
            for bid, (bbox, blbl) in elem_boxes.items():
                if bid in skip: continue
                if bbox.intersects_segment(x1, y1, x2, y2, margin=4):
                    collisions.append({
                        "edge_id": eid,
                        "edge_label": clean_html(edge.value),
                        "segment": i,
                        "box_id": bid,
                        "box_label": blbl,
                    })

    return collisions


def main():
    # Get file from environment (hook mode) or command line
    filepath = os.environ.get("CLAUDE_TOOL_USE_FILE", "")
    if not filepath and len(sys.argv) > 1:
        filepath = sys.argv[1]

    if not filepath:
        sys.exit(0)

    # Only check .drawio files
    if not filepath.endswith(".drawio"):
        sys.exit(0)

    if not os.path.exists(filepath):
        sys.exit(0)

    try:
        collisions = check_file(filepath)
    except Exception as e:
        # Don't block the agent on parse errors
        print(f"Edge collision check: parse error — {e}")
        sys.exit(0)

    if not collisions:
        sys.exit(0)

    # Group by edge
    by_edge = {}
    for c in collisions:
        eid = c["edge_id"]
        if eid not in by_edge:
            by_edge[eid] = {"label": c["edge_label"], "boxes": []}
        by_edge[eid]["boxes"].append(f"{c['box_label']}")

    # Output structured report
    print(f"Edge collision check: {len(collisions)} collision(s) in {len(by_edge)} edge(s)")
    print(f"These edges cross through element containers (Visual Defect #2: Edge-through-node):")
    for eid, info in sorted(by_edge.items()):
        boxes = ", ".join(dict.fromkeys(info["boxes"]))  # dedupe
        print(f"  - Edge \"{info['label']}\" ({eid}) crosses: {boxes}")
    print(f"Fix: Add waypoints to route edges around obstructing containers with 20px margin.")

    sys.exit(0)


if __name__ == "__main__":
    main()
