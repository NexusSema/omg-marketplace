# C4 Shape Definitions for draw.io

Complete `style` strings for every C4 and architecture diagram element. Use these exact strings when generating `mxCell` elements.

## C4 Model Elements

### Person

```
shape=mxgraph.c4.person2;whiteSpace=wrap;align=center;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=none;fillColor=#08427b;strokeColor=#073b6b;fontColor=#ffffff;fontSize=14;fontStyle=1;
```

Dimensions: `width="110" height="140"`

### Software System (Internal)

```
rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=14;fontStyle=1;arcSize=10;
```

Dimensions: `width="200" height="120"`

### Software System (External)

```
rounded=1;whiteSpace=wrap;fillColor=#999999;strokeColor=#8a8a8a;fontColor=#ffffff;fontSize=14;fontStyle=1;arcSize=10;
```

Dimensions: `width="200" height="120"`

### Container

```
rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;arcSize=10;
```

Dimensions: `width="180" height="100"`

### Container (Database)

```
shape=cylinder3;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;boundedLbl=1;stencilColors=1;size=15;
```

Dimensions: `width="160" height="100"`

### Container (Queue / Message Broker)

```
rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;arcSize=10;dashed=1;dashPattern=5 5;
```

Dimensions: `width="180" height="100"`

### Container (Cache)

```
shape=hexagon;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;perimeter=hexagonPerimeter2;size=0.1;
```

Dimensions: `width="180" height="90"`

### Component

```
rounded=1;whiteSpace=wrap;fillColor=#85bbf0;strokeColor=#78aee0;fontColor=#000000;fontSize=12;arcSize=10;
```

Dimensions: `width="160" height="80"`

### Component (Interface / API)

```
rounded=1;whiteSpace=wrap;fillColor=#85bbf0;strokeColor=#78aee0;fontColor=#000000;fontSize=12;arcSize=10;dashed=1;
```

Dimensions: `width="160" height="80"`

## Boundaries & Containers

### System Boundary

```
swimlane;startSize=30;fillColor=none;strokeColor=#444444;fontColor=#444444;fontSize=14;fontStyle=1;dashed=1;dashPattern=5 5;rounded=1;arcSize=10;container=1;
```

Padding: 40px inside. Children use relative coordinates.

### Container Boundary

```
swimlane;startSize=30;fillColor=none;strokeColor=#438dd5;fontColor=#438dd5;fontSize=13;fontStyle=1;dashed=1;dashPattern=5 5;rounded=1;arcSize=10;container=1;
```

### Enterprise Boundary

```
swimlane;startSize=30;fillColor=none;strokeColor=#666666;fontColor=#666666;fontSize=15;fontStyle=1;dashed=1;dashPattern=8 4;rounded=1;arcSize=6;container=1;
```

## Infrastructure Elements

### Server / VM

```
rounded=1;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=12;arcSize=6;
```

Dimensions: `width="160" height="80"`

### Cloud Service

```
ellipse;shape=cloud;whiteSpace=wrap;fillColor=#e1d5e7;strokeColor=#9673a6;fontColor=#333333;fontSize=12;
```

Dimensions: `width="180" height="100"`

### Load Balancer

```
shape=mxgraph.aws3.classic_load_balancer;whiteSpace=wrap;fillColor=#f58534;strokeColor=#d05c17;fontColor=#333333;fontSize=12;verticalLabelPosition=bottom;verticalAlign=top;
```

Dimensions: `width="80" height="80"`

### Infrastructure Cluster

```
swimlane;startSize=30;fillColor=#e6e6e6;strokeColor=#999999;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;
```

## Network Elements

### Public Zone

```
swimlane;startSize=30;fillColor=#f8cecc;strokeColor=#b85450;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;
```

### Application Zone (Private)

```
swimlane;startSize=30;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;
```

### Data Zone (Restricted)

```
swimlane;startSize=30;fillColor=#d5e8d4;strokeColor=#82b366;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;
```

### Firewall

```
shape=mxgraph.cisco.firewalls.firewall;whiteSpace=wrap;fillColor=#ff6666;strokeColor=#cc0000;fontColor=#333333;fontSize=11;verticalLabelPosition=bottom;verticalAlign=top;
```

Dimensions: `width="60" height="60"`

## ERD Elements

### Entity / Table

```
swimlane;startSize=28;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;fontStyle=1;childLayout=stackLayout;horizontal=1;horizontalStack=0;resizeParent=1;resizeParentMax=0;collapsible=0;marginBottom=0;container=1;
```

Dimensions: `width="200" height="auto"` (grows with fields)

### Entity Field (Row)

```
text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;
```

Dimensions: `width="200" height="26"` — child of entity with `parent="{entityId}"`

### Entity Field (Primary Key)

```
text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;fontStyle=4;
```

`fontStyle=4` = underline (indicates PK).

## Sequence Diagram Elements

### Participant (Actor)

```
shape=mxgraph.c4.person2;whiteSpace=wrap;align=center;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=none;fillColor=#08427b;strokeColor=#073b6b;fontColor=#ffffff;fontSize=12;fontStyle=1;
```

Dimensions: `width="80" height="100"`

### Participant (System)

```
rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;arcSize=10;
```

Dimensions: `width="140" height="50"`

### Lifeline

```
dashed=1;dashPattern=4 4;strokeColor=#999999;strokeWidth=1;
```

Edge style — vertical line from participant downward.

### Activation Bar

```
fillColor=#438dd5;strokeColor=#3c7fc0;rounded=0;
```

Dimensions: `width="16" height="variable"` — centered on lifeline.

### Synchronous Message (solid arrow)

```
edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#333333;fontSize=11;endArrow=block;endFill=1;
```

### Asynchronous Message (dashed arrow)

```
edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#333333;fontSize=11;endArrow=open;endFill=0;dashed=1;
```

### Return Message (dashed, open arrow)

```
edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#999999;fontSize=10;endArrow=open;endFill=0;dashed=1;fontStyle=2;
```

## Edge Styles

### C4 Relationship (solid)

```
edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;exitX=0.5;exitY=1;entryX=0.5;entryY=0;
```

### C4 Relationship (dashed — async/optional)

```
edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;dashed=1;dashPattern=5 5;
```

### Data Flow Edge

```
edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#333333;fontColor=#333333;fontSize=11;endArrow=block;endFill=1;
```

### ERD Relationship

```
edgeStyle=entityRelationEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=ERone;endFill=0;startArrow=ERmany;startFill=0;
```

Cardinality arrows: `ERone`, `ERmany`, `ERoneToMany`, `ERzeroToOne`, `ERzeroToMany`.

### Network Connection

```
edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontColor=#333333;fontSize=10;dashed=0;
```

## CI/CD Pipeline Elements

### Pipeline Stage

```
rounded=1;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontColor=#333333;fontSize=12;fontStyle=1;arcSize=10;
```

Dimensions: `width="160" height="70"`

### Pipeline Gate / Approval

```
rhombus;whiteSpace=wrap;fillColor=#fff2cc;strokeColor=#d6b656;fontColor=#333333;fontSize=11;
```

Dimensions: `width="100" height="80"`

### Pipeline Artifact

```
shape=mxgraph.flowchart.document;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=11;
```

Dimensions: `width="120" height="70"`

## State Machine Elements

### State

```
rounded=1;whiteSpace=wrap;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;arcSize=20;
```

Dimensions: `width="140" height="60"`

### Initial State (filled circle)

```
ellipse;fillColor=#333333;strokeColor=#333333;
```

Dimensions: `width="30" height="30"`

### Final State (bullseye)

```
ellipse;fillColor=#333333;strokeColor=#333333;
```

Dimensions: `width="30" height="30"` — with inner white circle via double border or nested cells.

### State Transition

```
edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;
```
