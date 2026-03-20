# Mermaid to draw.io Mapping

Mapping table for converting Mermaid syntax elements to draw.io XML equivalents.

## Graph Directives

| Mermaid | draw.io Equivalent | Notes |
|---------|-------------------|-------|
| `graph TD` / `flowchart TD` | Top-to-bottom layout | Use `exitY=1;entryY=0` on edges |
| `graph LR` / `flowchart LR` | Left-to-right layout | Use `exitX=1;entryX=0` on edges |
| `graph BT` | Bottom-to-top layout | Use `exitY=0;entryY=1` on edges |
| `graph RL` | Right-to-left layout | Use `exitX=0;entryX=1` on edges |
| `C4Context` | C4 Context diagram | Use C4 L1 shapes and colors |
| `C4Container` | C4 Container diagram | Use C4 L2 shapes and colors |
| `C4Component` | C4 Component diagram | Use C4 L3 shapes and colors |
| `sequenceDiagram` | Sequence diagram | Use participant/lifeline/message pattern |
| `erDiagram` | ERD diagram | Use entity/field/relationship pattern |
| `stateDiagram-v2` | State machine | Use state/transition pattern |

## Node Shapes

| Mermaid Syntax | Shape | draw.io Style |
|---------------|-------|--------------|
| `A[Text]` | Rectangle | `rounded=0;whiteSpace=wrap;` |
| `A(Text)` | Rounded rectangle | `rounded=1;whiteSpace=wrap;arcSize=10;` |
| `A([Text])` | Stadium / Pill | `rounded=1;whiteSpace=wrap;arcSize=50;` |
| `A{Text}` | Diamond / Decision | `rhombus;whiteSpace=wrap;` |
| `A{{Text}}` | Hexagon | `shape=hexagon;whiteSpace=wrap;perimeter=hexagonPerimeter2;size=0.1;` |
| `A[/Text/]` | Parallelogram | `shape=parallelogram;whiteSpace=wrap;` |
| `A[(Text)]` | Cylinder / Database | `shape=cylinder3;whiteSpace=wrap;boundedLbl=1;stencilColors=1;size=15;` |
| `A((Text))` | Circle | `ellipse;whiteSpace=wrap;` |
| `A>Text]` | Flag / Asymmetric | `shape=step;whiteSpace=wrap;perimeter=stepPerimeter;size=0.2;` |
| `A:::className` | Styled node | Apply class-specific fill/stroke/font colors |

## C4 Mermaid Elements

| Mermaid C4 Macro | draw.io Element | Style Reference |
|-----------------|----------------|----------------|
| `Person(id, "name", "desc")` | Person shape | `c4-shape-definitions.md` → Person |
| `Person_Ext(id, "name", "desc")` | External person | Person shape with external colors (`#999999`) |
| `System(id, "name", "desc")` | Internal system | Software System (Internal) style |
| `System_Ext(id, "name", "desc")` | External system | Software System (External) style |
| `Container(id, "name", "tech", "desc")` | Container | Container style |
| `ContainerDb(id, "name", "tech", "desc")` | Database container | Container (Database) style |
| `ContainerQueue(id, "name", "tech", "desc")` | Queue container | Container (Queue) style |
| `Component(id, "name", "tech", "desc")` | Component | Component style |
| `Boundary(id, "name")` | Boundary container | System/Container Boundary style |
| `System_Boundary(id, "name")` | System boundary | System Boundary style |
| `Enterprise_Boundary(id, "name")` | Enterprise boundary | Enterprise Boundary style |
| `Rel(from, to, "label", "tech")` | Relationship edge | C4 Relationship style |
| `BiRel(from, to, "label", "tech")` | Bidirectional edge | C4 edge with `startArrow=block;startFill=1;` |

## Edge/Link Styles

| Mermaid Syntax | Description | draw.io Style |
|---------------|-------------|--------------|
| `A --> B` | Arrow | `edgeStyle=orthogonalEdgeStyle;rounded=1;endArrow=block;endFill=1;` |
| `A --- B` | Line (no arrow) | `edgeStyle=orthogonalEdgeStyle;rounded=1;endArrow=none;` |
| `A -.- B` | Dotted line | `edgeStyle=orthogonalEdgeStyle;rounded=1;dashed=1;endArrow=none;` |
| `A -.-> B` | Dotted arrow | `edgeStyle=orthogonalEdgeStyle;rounded=1;dashed=1;endArrow=block;endFill=1;` |
| `A ==> B` | Thick arrow | `edgeStyle=orthogonalEdgeStyle;rounded=1;endArrow=block;endFill=1;strokeWidth=2;` |
| `A --"label"--> B` | Labeled arrow | Add `value="label"` to mxCell |
| `A ~~~ B` | Invisible link | Do not render (layout only) |

## Subgraphs to Containers

| Mermaid | draw.io |
|---------|---------|
| `subgraph Title` | `swimlane;startSize=30;container=1;` with title as `value` |
| `subgraph id [Title]` | Same — use `id` for mxCell id, `Title` for value |
| `direction TB` in subgraph | Top-to-bottom child layout |
| `direction LR` in subgraph | Left-to-right child layout |
| Nested `subgraph` | Nested container: child container's `parent` = outer container's `id` |
| `end` | Closing of container — calculate size from children + padding |

### Container Size Calculation

When converting a Mermaid subgraph to a draw.io container:

1. Count child nodes and determine grid layout (rows × columns)
2. Calculate container dimensions:
   ```
   width  = (cols × child_width) + ((cols + 1) × 40px_padding)
   height = 30px_header + (rows × child_height) + ((rows + 1) × 40px_padding)
   ```
3. Position children with relative coordinates inside the container
4. Nested containers add their own padding recursively

## Sequence Diagram Elements

| Mermaid | draw.io |
|---------|---------|
| `participant A as "Name"` | Rounded rectangle at top, lifeline below |
| `actor A as "Name"` | Person shape at top, lifeline below |
| `A->>B: Message` | Solid arrow (sync message) |
| `A-->>B: Message` | Dashed arrow (async/return message) |
| `A-xB: Message` | Arrow with X end (lost message) |
| `activate A` | Activation bar on lifeline |
| `deactivate A` | End of activation bar |
| `alt condition` | Alt frame container |
| `else condition` | Divider within alt frame |
| `loop condition` | Loop frame container |
| `opt condition` | Optional frame container |
| `par` | Parallel frame container |
| `Note right of A: text` | Note shape positioned next to lifeline |

## ERD Elements

| Mermaid | draw.io |
|---------|---------|
| `ENTITY_NAME {` | Entity table (swimlane with stackLayout) |
| `type field_name PK` | Field row with underline (`fontStyle=4`) |
| `type field_name FK` | Field row with italic blue font |
| `type field_name` | Regular field row |
| `}` | End of entity |
| `A \|\|--o{ B : "label"` | One-to-many relationship |
| `A \|\|--\|\| B : "label"` | One-to-one relationship |
| `A }o--o{ B : "label"` | Many-to-many relationship |

### ERD Cardinality Mapping

| Mermaid | draw.io startArrow | draw.io endArrow |
|---------|-------------------|-----------------|
| `\|\|` (exactly one) | `ERone` | `ERone` |
| `o\|` (zero or one) | `ERzeroToOne` | — |
| `}o` (zero or many) | `ERzeroToMany` | — |
| `}\|` (one or many) | `ERoneToMany` | — |
| `\|{` (one or many) | — | `ERoneToMany` |
| `o{` (zero or many) | — | `ERzeroToMany` |

## State Diagram Elements

| Mermaid | draw.io |
|---------|---------|
| `[*] --> State1` | Initial state (filled circle) → State |
| `State1 --> State2: event` | State transition with label |
| `State1 --> [*]` | State → Final state |
| `state "Description" as s1` | State with custom label |
| `state Fork <<fork>>` | Fork bar (horizontal black bar) |
| `state Join <<join>>` | Join bar (same as fork visually) |
| `state if_state <<choice>>` | Choice diamond |

## Styling Directives

| Mermaid | draw.io Mapping |
|---------|----------------|
| `%%{init: {'theme': 'dark'}}%%` | Ignored — use C4 color palette |
| `classDef className fill:#hex,stroke:#hex` | Map to `fillColor`, `strokeColor` in style |
| `class nodeId className` | Apply class colors to that node's mxCell |
| `style nodeId fill:#hex,stroke:#hex` | Direct style application on mxCell |
| `linkStyle N stroke:#hex` | Apply `strokeColor` to the Nth edge |

## Conversion Algorithm Summary

1. **Parse** the Mermaid block line by line
2. **Extract** the directive (`graph`, `sequenceDiagram`, etc.) to determine diagram type
3. **Collect** all nodes with their shapes, labels, and classes
4. **Collect** all edges with their sources, targets, labels, and styles
5. **Collect** all subgraphs with their children
6. **Map** each element to its draw.io XML equivalent using this table
7. **Apply** colors from `c4-color-palettes.md` based on diagram type
8. **Calculate** positions using `layout-rules.md`
9. **Generate** XML using `template-snippets.md` as the starting structure
10. **Validate** XML: unique IDs, proper parent refs, no `--` in comments, escaped special chars
