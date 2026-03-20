# Layout Rules

Spacing, dimensions, edge routing, fonts, and grid alignment rules for draw.io diagram generation.

## Grid & Alignment

- **Grid size**: 10px — all coordinates must be multiples of 10
- **Snap to grid**: Always align `x`, `y`, `width`, `height` to grid
- **Page size**: Default `<mxGraphModel dx="1422" dy="762"` — adjust as needed for diagram size

## Node Spacing

| Direction | Minimum | Preferred | Use Case |
|-----------|---------|-----------|----------|
| Horizontal | 80px | 200px | Between sibling nodes |
| Vertical | 60px | 120px | Between hierarchy levels |
| Container padding | 30px | 40px | Inside boundaries/containers |
| Container header | 30px | 30px | `startSize=30` for swimlanes |

### Spacing by Diagram Type

| Diagram | H Spacing | V Spacing | Notes |
|---------|-----------|-----------|-------|
| C4 Context | 200px | 150px | Wide spacing for clarity |
| C4 Container | 200px | 120px | Standard spacing |
| C4 Component | 160px | 100px | Tighter for detail |
| Sequence | 200px | — | Horizontal between participants |
| ERD | 250px | 80px | Wide H for relationship labels |
| Infrastructure | 200px | 120px | Standard |
| Network | 200px | 150px | Room for zone labels |
| State Machine | 180px | 120px | Standard |
| CI/CD Pipeline | 200px | 80px | Linear horizontal flow |

## Node Dimensions

### Standard Sizes

| Element | Width | Height |
|---------|-------|--------|
| Person | 110 | 140 |
| Software System | 200 | 120 |
| Container | 180 | 100 |
| Component | 160 | 80 |
| Database (cylinder) | 160 | 100 |
| Server / VM | 160 | 80 |
| Sequence Participant | 140 | 50 |
| Sequence Actor | 80 | 100 |
| ERD Entity | 200 | auto |
| ERD Field Row | 200 | 26 |
| State | 140 | 60 |
| Pipeline Stage | 160 | 70 |
| Firewall | 60 | 60 |
| Initial/Final State | 30 | 30 |

### Container Sizes (calculated)

Container width and height depend on children:

```
container_width  = (num_cols * child_width) + ((num_cols + 1) * h_padding)
container_height = startSize + (num_rows * child_height) + ((num_rows + 1) * v_padding)
```

Where `h_padding = 40`, `v_padding = 40`, `startSize = 30`.

## Edge Routing

### General Rules

- **Default edge style**: `edgeStyle=orthogonalEdgeStyle;rounded=1;`
- **Right-angle connectors**: Always use orthogonal routing (never straight diagonal lines)
- **Jet spacing**: `jettySize=auto;orthogonalLoop=1;`
- **Minimum final segment**: 20px straight before target (room for arrowhead)
- **Minimum node gap**: 60px between connected nodes (prevents edge overlap)

### Connection Points (exitX/exitY, entryX/entryY)

Values range from 0 to 1, representing position on the node boundary:

| Position | X | Y |
|----------|---|---|
| Top center | 0.5 | 0 |
| Bottom center | 0.5 | 1 |
| Left center | 0 | 0.5 |
| Right center | 1 | 0.5 |
| Top-left | 0 | 0 |
| Top-right | 1 | 0 |
| Bottom-left | 0 | 1 |
| Bottom-right | 1 | 1 |

### Edge Direction by Diagram Type

| Diagram | Primary Flow | Exit | Entry |
|---------|-------------|------|-------|
| C4 Context | Top to Bottom | exitY=1 | entryY=0 |
| C4 Container | Top to Bottom | exitY=1 | entryY=0 |
| C4 Component | Left to Right | exitX=1 | entryX=0 |
| Sequence | Left to Right | exitX=1 | entryX=0 |
| ERD | Varies | auto | auto |
| CI/CD Pipeline | Left to Right | exitX=1 | entryX=0 |
| State Machine | Left to Right | exitX=1 | entryX=0 |
| Infrastructure | Top to Bottom | exitY=1 | entryY=0 |

### Waypoints

Add explicit waypoints when edges would overlap:

```xml
<mxGeometry relative="1" as="geometry">
  <Array as="points">
    <mxPoint x="300" y="150"/>
    <mxPoint x="300" y="250"/>
  </Array>
</mxGeometry>
```

## Font Sizes

| Context | Size | Style |
|---------|------|-------|
| Diagram title | 18 | Bold (`fontStyle=1`) |
| System / Person label | 14 | Bold |
| Container label | 13 | Bold |
| Component label | 12 | Normal |
| Edge label | 11 | Normal |
| Technology annotation | 10 | Italic (`fontStyle=2`) |
| ERD field | 11 | Normal |
| ERD primary key | 11 | Underline (`fontStyle=4`) |
| Sequence message | 11 | Normal |
| Sequence return | 10 | Italic |
| Boundary label | 13-15 | Bold |

## Label Formatting

### Multi-line Labels

Use HTML `<br>` for line breaks in `value` attributes:

```xml
value="Web Application&lt;br&gt;&lt;i&gt;[Container: React]&lt;/i&gt;"
```

### C4 Label Convention

```
{Name}
[{Type}: {Technology}]
{Description}
```

Example:
```xml
value="API Gateway&lt;br&gt;&lt;i&gt;[Container: Kong]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;Routes and authenticates&lt;br&gt;API requests&lt;/font&gt;"
```

### Edge Label Convention

```
{verb phrase}
[{protocol}]
```

Example: `value="Makes API calls&lt;br&gt;[JSON/HTTPS]"`

## Sequence Diagram Layout

Sequence diagrams have special layout rules:

1. **Participants**: Arrange horizontally at `y=40`, spaced 200px apart
2. **Lifelines**: Vertical dashed lines from participant bottom, extending to diagram bottom
3. **Messages**: Horizontal arrows between lifelines at increasing `y` values
4. **Message vertical spacing**: 50px between consecutive messages
5. **Activation bars**: 16px wide, centered on lifeline `x`, height covers message span
6. **Alt/Loop frames**: Swimlane containers enclosing relevant messages
7. **Frame label**: Top-left with condition text (e.g., `[isAuthenticated]`)

## ERD Layout

1. **Entities**: Arrange in a grid pattern, 250px horizontal, 80px vertical gap
2. **Related entities**: Place adjacent (horizontally or vertically)
3. **Junction tables**: Place between the entities they join
4. **Field ordering**: PK fields first, then FK fields, then regular fields
5. **Relationship labels**: Centered on edge with cardinality notation
