---
name: architecture/diagrams
description: "Convert Mermaid diagrams from architecture shard documents into styled draw.io (.drawio) files with C4-appropriate shapes, colors, and layout"
disable-model-invocation: true
---

# C4 Diagram Generator Skill

**Goal:** Convert Mermaid diagrams found in architecture shard documents (01-07) into properly styled draw.io `.drawio` files with C4 modeling conventions, correct XML structure, and professional layout.

## Reference File Index

All reference files are located at `${PLUGIN_ROOT}/skills/architecture/diagrams/references/`:

| File | Purpose |
|------|---------|
| `c4-shape-definitions.md` | draw.io XML `style` strings for every C4 element type |
| `c4-color-palettes.md` | Color tables per diagram type (C4, Infrastructure, ERD, etc.) |
| `layout-rules.md` | Spacing, dimensions, edge routing, font sizes, grid alignment |
| `template-snippets.md` | Complete `<mxGraphModel>` XML templates per diagram type |
| `mermaid-to-drawio-mapping.md` | Mapping: Mermaid syntax elements to draw.io XML equivalents |

## Conversion Methodology

### Step 1 — Discover & Extract

1. Glob for `0[1-7]-*.md` files in the target directory
2. Read each file and extract all ` ```mermaid ``` ` code blocks
3. Record the source document number, block index, and any `%%` title comments

### Step 2 — Classify Diagram Type

Determine diagram type from Mermaid syntax:

| Mermaid Directive | Diagram Type |
|-------------------|-------------|
| `C4Context` | C4 Context (Level 1) |
| `C4Container` | C4 Container (Level 2) |
| `C4Component` | C4 Component (Level 3) |
| `sequenceDiagram` | Sequence Diagram |
| `erDiagram` | Entity-Relationship Diagram |
| `graph`/`flowchart` + infrastructure keywords | Infrastructure Topology |
| `graph`/`flowchart` + network/zone keywords | Network Topology |
| `stateDiagram` | State Machine |
| `graph`/`flowchart` + CI/CD keywords | CI/CD Pipeline |
| `graph`/`flowchart` (default) | Data Flow / Generic |

### Step 3 — Convert to draw.io XML

For each classified diagram:

1. Load the template snippet for that diagram type from `references/template-snippets.md`
2. Parse the Mermaid block to extract nodes, edges, subgraphs, labels, and relationships
3. Map each element to draw.io XML using `references/c4-shape-definitions.md`
4. Apply colors from `references/c4-color-palettes.md`
5. Generate unique `id` attributes for every `mxCell`

### Step 4 — Layout

1. Position nodes on a grid following `references/layout-rules.md`
2. Nest children inside container parents using `parent="{containerId}"` with relative coordinates
3. Route edges using `edgeStyle=orthogonalEdgeStyle` with `rounded=1`
4. Ensure minimum 200px horizontal and 120px vertical spacing between nodes
5. Align all coordinates to multiples of 10

### Step 5 — Write Output

1. Write `.drawio` file alongside source documents
2. Naming convention: `{doc_number}-{diagram_type}.drawio`
   - Examples: `01-c4-context.drawio`, `04-seq-auth-flow.drawio`, `07-erd.drawio`
3. If multiple diagrams of the same type exist in one document, append a sequence number: `04-seq-auth-flow-1.drawio`

### Step 6 — Export (Optional)

If draw.io CLI is available on the system, export to PNG:

```bash
drawio -x -f png -e -b 10 -o {name}.drawio.png {name}.drawio
```

Check availability with `which drawio` first. If not available, skip this step silently.

### Step 7 — Summary

Produce a summary table:

| Source Doc | Diagram Type | Output File | Nodes | Edges |
|-----------|-------------|-------------|-------|-------|
| 01-high-level-design.md | C4 Context | 01-c4-context.drawio | 8 | 12 |
| ... | ... | ... | ... | ... |

## XML Rules (CRITICAL)

These rules must be followed for every `.drawio` file:

1. **Root structure**: `<mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/>...</root></mxGraphModel>`
2. **All diagram cells** must have `parent="1"` unless nested in a container
3. **Container children** must use `parent="{containerId}"` with relative coordinates
4. **NEVER** use `--` (double hyphens) inside XML comments
5. **Escape** special characters: `&amp;`, `&lt;`, `&gt;`, `&quot;`
6. **Unique IDs** for every `mxCell` — use descriptive prefixes (e.g., `person-1`, `sys-ext-2`, `edge-3`)
7. **Always include** `vertex="1"` on shape cells and `edge="1"` on connector cells
8. **Containers** must use `swimlane;startSize=30;` style with `container=1`
9. **Groups** (invisible containers) must include `pointerEvents=0` in style
