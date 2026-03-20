---
name: architecture-diagrams
description: 'Generate styled draw.io (.drawio) files from architecture shard document content with C4-appropriate shapes, colors, and layout. Use when: generating architecture diagrams, converting architecture to drawio, creating C4 diagrams, generating draw.io files from shard documents.'
disable-model-invocation: true
---

# C4 Diagram Generator Skill

**Goal:** Generate professionally styled draw.io `.drawio` files from architecture shard documents (01-07) by analyzing the document content directly. Do NOT rely on Mermaid code blocks — instead, read and understand the prose, tables, and descriptions in each document to design appropriate diagrams with C4 modeling conventions, correct XML structure, and professional layout.

## Reference File Index

All reference files are located at `./references/`:

| File | Purpose |
|------|---------|
| [c4-shape-definitions.md](./references/c4-shape-definitions.md) | draw.io XML `style` strings for every C4 element type |
| [c4-color-palettes.md](./references/c4-color-palettes.md) | Color tables per diagram type (C4, Infrastructure, ERD, etc.) |
| [layout-rules.md](./references/layout-rules.md) | Spacing, dimensions, edge routing, font sizes, grid alignment |
| [template-snippets.md](./references/template-snippets.md) | Complete `<mxGraphModel>` XML templates per diagram type |
| [mermaid-to-drawio-mapping.md](./references/mermaid-to-drawio-mapping.md) | Reference for draw.io XML element patterns |
| [visual-validation-guide.md](./references/visual-validation-guide.md) | Visual defect checklist, fix strategies, and iteration protocol for post-render QA |

## Conversion Methodology

### Step 1 — Discover & Analyze

1. Glob for `0[1-7]-*.md` files in the target directory
2. Read each file's full content — prose, tables, lists, and descriptions
3. Identify what diagrams should be generated based on the document's subject matter (see classification table below)
4. **Ignore any existing Mermaid code blocks** — they are often messy and unreliable. Generate diagrams from the document's textual content instead.

### Step 2 — Classify Diagram Type

Determine diagram types based on the document's content and purpose:

| Document Subject | Diagram Type |
|-----------------|-------------|
| System overview, actors, external systems | C4 Context (Level 1) |
| Application containers, services, databases | C4 Container (Level 2) |
| Internal component breakdown | C4 Component (Level 3) |
| Interaction flows, request/response sequences | Sequence Diagram |
| Data models, entity relationships | Entity-Relationship Diagram |
| Server infrastructure, cloud resources | Infrastructure Topology |
| Network zones, firewalls, security boundaries | Network Topology |
| Lifecycle states, transitions | State Machine |
| Build/deploy pipelines | CI/CD Pipeline |
| Data movement between systems | Data Flow |

A single document may warrant multiple diagrams. Identify all appropriate diagrams from the content.

### Step 3 — Design & Convert to draw.io XML

For each identified diagram:

1. Extract the relevant entities, relationships, and labels from the document's prose and tables
2. Design the diagram structure — determine nodes, edges, containers, and their labels
3. Load the appropriate template from [template-snippets.md](./references/template-snippets.md)
4. Apply shapes from [c4-shape-definitions.md](./references/c4-shape-definitions.md)
5. Apply colors from [c4-color-palettes.md](./references/c4-color-palettes.md)
6. Generate unique `id` attributes for every `mxCell`

### Step 4 — Layout

1. Position nodes on a grid following [layout-rules.md](./references/layout-rules.md)
2. Nest children inside container parents using `parent="{containerId}"` with relative coordinates
3. Route edges using `edgeStyle=orthogonalEdgeStyle` with `rounded=1`
4. Ensure minimum 200px horizontal and 120px vertical spacing between nodes
5. Align all coordinates to multiples of 10

### Step 4.5 — Layout Planning

Before generating coordinates, produce a brief layout plan for each diagram:

1. Identify the primary flow direction (TB or LR) based on diagram type
2. List node groups/clusters and how they should be spatially arranged
3. Identify potential edge congestion points (nodes with many connections)
4. Plan container nesting order (outer → inner)
5. Estimate canvas size needed based on node count and spacing rules
6. Note which edges may need waypoints to avoid crossings

This plan is internal (not written to a file) — it guides the coordinate generation that follows.

### Step 5 — Write Output

1. Write `.drawio` file alongside source documents
2. Naming convention: `{doc_number}-{diagram_type}.drawio`
   - Examples: `01-c4-context.drawio`, `04-seq-auth-flow.drawio`, `07-erd.drawio`
3. If multiple diagrams of the same type exist in one document, append a sequence number: `04-seq-auth-flow-1.drawio`

### Step 6 — Visual Validation & Refinement

1. Check draw.io CLI availability:
   ```bash
   which drawio || test -f /Applications/draw.io.app/Contents/MacOS/draw.io
   ```
2. If **not available** → skip visual validation, keep `.drawio` files as-is, mark Visual QA as `Skipped (no CLI)`
3. If **available** → for each `.drawio` file:
   a. Export to PNG at 2× scale for readable text:
      ```bash
      /Applications/draw.io.app/Contents/MacOS/draw.io -x -f png --scale 2 -b 10 -o {name}.drawio.png {name}.drawio
      ```
   b. Read the PNG using the read tool to visually inspect it
   c. Evaluate against the defect checklist from [visual-validation-guide.md](./references/visual-validation-guide.md)
   d. If issues found AND iteration count < 3:
      - Log the specific issues identified
      - Apply fixes per the strategy guide in [visual-validation-guide.md](./references/visual-validation-guide.md)
      - Re-write the `.drawio` file, re-export to PNG, re-inspect
   e. If clean or max iterations (3) reached → proceed
4. Keep final PNG files alongside `.drawio` files

### Step 7 — Summary

Produce a summary table:

| Source Doc | Diagram Type | Output File | Nodes | Edges | Visual QA |
|-----------|-------------|-------------|-------|-------|-----------|
| 01-high-level-design.md | C4 Context | 01-c4-context.drawio | 8 | 12 | Pass |
| ... | ... | ... | ... | ... | ... |

Visual QA column values: `Pass`, `Pass (N iterations)`, `Issues remaining: [desc]`, `Skipped (no CLI)`

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
10. **Always include** `html=1;` at the start of every `style="..."` value — required for HTML labels (`&lt;br&gt;`, `&lt;i&gt;`, `&lt;font&gt;`) to render correctly; without it tags appear as literal text
