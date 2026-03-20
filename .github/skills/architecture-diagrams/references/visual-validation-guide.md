# Visual Validation Guide

Reference for the visual validation loop used after generating `.drawio` files.

## Visual Defect Checklist

Inspect each exported PNG for these defects:

| # | Defect | What to Look For |
|---|--------|-----------------|
| 1 | **Node overlap** | Two or more shapes stacked on each other, partially or fully obscuring content |
| 2 | **Edge-through-node** | A connector line passing through an unrelated node instead of routing around it |
| 3 | **Edge overlap** | Multiple edges running along the same path, appearing as a single thick line |
| 4 | **Label truncation** | Text cut off at shape boundaries or extending beyond the shape edge |
| 5 | **Container overflow** | Child nodes positioned partially or fully outside their parent container |
| 6 | **Cramped spacing** | Nodes or containers closer together than the minimum thresholds defined in `layout-rules.md` |
| 7 | **Excessive whitespace** | Large empty gaps between node clusters that waste canvas space |

## Fix Strategies

Apply these concrete fixes per defect type:

### Node overlap
Shift the overlapping node by `(node width + horizontal spacing gap)` in the flow direction. Cascade all downstream nodes by the same offset to maintain relative positioning.

### Edge-through-node
Add waypoints that route the edge around the obstructing node's bounding box with a 20px margin on each side. Use the node's `x, y, width, height` to calculate the detour path.

### Edge overlap
Stagger parallel edges by 20px perpendicular to their direction. Use different exit points on the source node and entry points on the target node to visually separate the edges.

### Label truncation
Increase the node width by 40px increments until the label fits. If the label is a long phrase, insert `<br>` line breaks to wrap text across multiple lines and increase node height accordingly.

### Container overflow
Recalculate the container dimensions using the formula from `layout-rules.md`:
- Container width = max child right edge − container x + horizontal padding
- Container height = max child bottom edge − container y + vertical padding + startSize

### Cramped spacing
Increase spacing to the "Preferred" column values from `layout-rules.md`. Shift affected nodes outward and cascade downstream nodes.

### Excessive whitespace
Reduce gaps between clusters to the "Preferred" spacing values. Pull isolated nodes closer to their connected neighbors.

## Iteration Protocol

- **Max 3 total renders** per diagram: 1 initial export + up to 2 correction rounds
- Each iteration **must fix at least one issue** — if no progress is made, stop to prevent infinite loops
- If issues remain after 3 iterations, note them in the summary table and move on
- Always keep the final PNG alongside the `.drawio` file regardless of pass/fail status
