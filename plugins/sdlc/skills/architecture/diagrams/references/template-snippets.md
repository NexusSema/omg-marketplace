# Template Snippets

Complete `<mxGraphModel>` XML templates for each diagram type. Use these as starting points — replace placeholder elements with actual diagram content.

## C4 Context Diagram

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Title -->
    <mxCell id="title" value="System Context Diagram" style="text;align=center;verticalAlign=middle;whiteSpace=wrap;fontSize=18;fontStyle=1;fontColor=#333333;" vertex="1" parent="1">
      <mxGeometry x="300" y="10" width="400" height="30" as="geometry"/>
    </mxCell>

    <!-- Person -->
    <mxCell id="person-1" value="User&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;A user of the system&lt;/font&gt;" style="shape=mxgraph.c4.person2;whiteSpace=wrap;align=center;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=none;fillColor=#08427b;strokeColor=#073b6b;fontColor=#ffffff;fontSize=14;fontStyle=1;" vertex="1" parent="1">
      <mxGeometry x="400" y="60" width="110" height="140" as="geometry"/>
    </mxCell>

    <!-- Internal System -->
    <mxCell id="sys-1" value="System Name&lt;br&gt;&lt;i&gt;[Software System]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;Description of system&lt;/font&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=14;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="350" y="280" width="200" height="120" as="geometry"/>
    </mxCell>

    <!-- External System -->
    <mxCell id="sys-ext-1" value="External System&lt;br&gt;&lt;i&gt;[Software System]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;External dependency&lt;/font&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#999999;strokeColor=#8a8a8a;fontColor=#ffffff;fontSize=14;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="700" y="280" width="200" height="120" as="geometry"/>
    </mxCell>

    <!-- Relationships -->
    <mxCell id="edge-1" value="Uses" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;exitX=0.5;exitY=1;entryX=0.5;entryY=0;" edge="1" source="person-1" target="sys-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="edge-2" value="Sends data to&lt;br&gt;[JSON/HTTPS]" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" source="sys-1" target="sys-ext-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## C4 Container Diagram

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- System Boundary -->
    <mxCell id="boundary-1" value="System Name [Software System]" style="swimlane;startSize=30;fillColor=none;strokeColor=#444444;fontColor=#444444;fontSize=14;fontStyle=1;dashed=1;dashPattern=5 5;rounded=1;arcSize=10;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="200" width="600" height="400" as="geometry"/>
    </mxCell>

    <!-- Container: Web App -->
    <mxCell id="container-1" value="Web Application&lt;br&gt;&lt;i&gt;[Container: React]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;Delivers the UI&lt;/font&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;arcSize=10;" vertex="1" parent="boundary-1">
      <mxGeometry x="40" y="60" width="180" height="100" as="geometry"/>
    </mxCell>

    <!-- Container: API -->
    <mxCell id="container-2" value="API Application&lt;br&gt;&lt;i&gt;[Container: Node.js]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;Provides API&lt;/font&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;arcSize=10;" vertex="1" parent="boundary-1">
      <mxGeometry x="40" y="240" width="180" height="100" as="geometry"/>
    </mxCell>

    <!-- Container: Database -->
    <mxCell id="container-db-1" value="Database&lt;br&gt;&lt;i&gt;[Container: PostgreSQL]&lt;/i&gt;&lt;br&gt;&lt;font style=&quot;font-size:10px&quot;&gt;Stores data&lt;/font&gt;" style="shape=cylinder3;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=13;fontStyle=1;boundedLbl=1;stencilColors=1;size=15;" vertex="1" parent="boundary-1">
      <mxGeometry x="360" y="240" width="160" height="100" as="geometry"/>
    </mxCell>

    <!-- Edges within boundary -->
    <mxCell id="edge-c1" value="Makes API calls&lt;br&gt;[JSON/HTTPS]" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;exitX=0.5;exitY=1;entryX=0.5;entryY=0;" edge="1" source="container-1" target="container-2" parent="boundary-1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="edge-c2" value="Reads/writes&lt;br&gt;[SQL/TCP]" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" source="container-2" target="container-db-1" parent="boundary-1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## C4 Component Diagram

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Container Boundary -->
    <mxCell id="comp-boundary" value="API Application [Container: Node.js]" style="swimlane;startSize=30;fillColor=none;strokeColor=#438dd5;fontColor=#438dd5;fontSize=13;fontStyle=1;dashed=1;dashPattern=5 5;rounded=1;arcSize=10;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="100" width="700" height="400" as="geometry"/>
    </mxCell>

    <!-- Components -->
    <mxCell id="comp-1" value="Auth Controller&lt;br&gt;&lt;i&gt;[Component]&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#85bbf0;strokeColor=#78aee0;fontColor=#000000;fontSize=12;arcSize=10;" vertex="1" parent="comp-boundary">
      <mxGeometry x="40" y="60" width="160" height="80" as="geometry"/>
    </mxCell>

    <mxCell id="comp-2" value="User Service&lt;br&gt;&lt;i&gt;[Component]&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#85bbf0;strokeColor=#78aee0;fontColor=#000000;fontSize=12;arcSize=10;" vertex="1" parent="comp-boundary">
      <mxGeometry x="270" y="60" width="160" height="80" as="geometry"/>
    </mxCell>

    <mxCell id="comp-3" value="User Repository&lt;br&gt;&lt;i&gt;[Component]&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#85bbf0;strokeColor=#78aee0;fontColor=#000000;fontSize=12;arcSize=10;" vertex="1" parent="comp-boundary">
      <mxGeometry x="270" y="240" width="160" height="80" as="geometry"/>
    </mxCell>

    <!-- Edges -->
    <mxCell id="edge-comp-1" value="Uses" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;" edge="1" source="comp-1" target="comp-2" parent="comp-boundary">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="edge-comp-2" value="Reads/writes" style="edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;strokeColor=#707070;fontColor=#707070;fontSize=11;" edge="1" source="comp-2" target="comp-3" parent="comp-boundary">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## Sequence Diagram

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Participants -->
    <mxCell id="actor-1" value="User" style="shape=mxgraph.c4.person2;whiteSpace=wrap;align=center;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=none;fillColor=#08427b;strokeColor=#073b6b;fontColor=#ffffff;fontSize=12;fontStyle=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="40" width="80" height="100" as="geometry"/>
    </mxCell>

    <mxCell id="part-1" value="Web App" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="270" y="60" width="140" height="50" as="geometry"/>
    </mxCell>

    <mxCell id="part-2" value="API Server" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="490" y="60" width="140" height="50" as="geometry"/>
    </mxCell>

    <mxCell id="part-3" value="Database" style="shape=cylinder3;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;boundedLbl=1;stencilColors=1;size=15;" vertex="1" parent="1">
      <mxGeometry x="700" y="50" width="120" height="70" as="geometry"/>
    </mxCell>

    <!-- Lifelines -->
    <mxCell id="life-1" style="dashed=1;dashPattern=4 4;strokeColor=#999999;strokeWidth=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="140" y="140" as="sourcePoint"/>
        <mxPoint x="140" y="500" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="life-2" style="dashed=1;dashPattern=4 4;strokeColor=#999999;strokeWidth=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="340" y="110" as="sourcePoint"/>
        <mxPoint x="340" y="500" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="life-3" style="dashed=1;dashPattern=4 4;strokeColor=#999999;strokeWidth=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="560" y="110" as="sourcePoint"/>
        <mxPoint x="560" y="500" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="life-4" style="dashed=1;dashPattern=4 4;strokeColor=#999999;strokeWidth=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="760" y="120" as="sourcePoint"/>
        <mxPoint x="760" y="500" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <!-- Messages -->
    <mxCell id="msg-1" value="1. Login request" style="edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#333333;fontSize=11;endArrow=block;endFill=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="140" y="170" as="sourcePoint"/>
        <mxPoint x="340" y="170" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="msg-2" value="2. POST /auth/login" style="edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#333333;fontSize=11;endArrow=block;endFill=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="340" y="220" as="sourcePoint"/>
        <mxPoint x="560" y="220" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="msg-3" value="3. SELECT user" style="edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#333333;fontSize=11;endArrow=block;endFill=1;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="560" y="270" as="sourcePoint"/>
        <mxPoint x="760" y="270" as="targetPoint"/>
      </mxGeometry>
    </mxCell>

    <mxCell id="msg-4" value="User record" style="edgeStyle=orthogonalEdgeStyle;rounded=0;strokeColor=#999999;fontSize=10;endArrow=open;endFill=0;dashed=1;fontStyle=2;" edge="1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="760" y="320" as="sourcePoint"/>
        <mxPoint x="560" y="320" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
  </root>
</mxGraphModel>
```

## ERD (Entity-Relationship Diagram)

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Entity: Users -->
    <mxCell id="entity-users" value="users" style="swimlane;startSize=28;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;fontStyle=1;childLayout=stackLayout;horizontal=1;horizontalStack=0;resizeParent=1;resizeParentMax=0;collapsible=0;marginBottom=0;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="100" width="200" height="158" as="geometry"/>
    </mxCell>
    <mxCell id="field-u1" value="id: uuid PK" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;fontStyle=4;" vertex="1" parent="entity-users">
      <mxGeometry y="28" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-u2" value="email: varchar(255)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;" vertex="1" parent="entity-users">
      <mxGeometry y="54" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-u3" value="name: varchar(100)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;" vertex="1" parent="entity-users">
      <mxGeometry y="80" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-u4" value="org_id: uuid FK" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#6c8ebf;fontStyle=2;" vertex="1" parent="entity-users">
      <mxGeometry y="106" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-u5" value="created_at: timestamptz" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;" vertex="1" parent="entity-users">
      <mxGeometry y="132" width="200" height="26" as="geometry"/>
    </mxCell>

    <!-- Entity: Organizations -->
    <mxCell id="entity-orgs" value="organizations" style="swimlane;startSize=28;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;fontStyle=1;childLayout=stackLayout;horizontal=1;horizontalStack=0;resizeParent=1;resizeParentMax=0;collapsible=0;marginBottom=0;container=1;" vertex="1" parent="1">
      <mxGeometry x="450" y="100" width="200" height="106" as="geometry"/>
    </mxCell>
    <mxCell id="field-o1" value="id: uuid PK" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;fontStyle=4;" vertex="1" parent="entity-orgs">
      <mxGeometry y="28" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-o2" value="name: varchar(255)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;" vertex="1" parent="entity-orgs">
      <mxGeometry y="54" width="200" height="26" as="geometry"/>
    </mxCell>
    <mxCell id="field-o3" value="slug: varchar(100)" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=6;spacingRight=6;overflow=hidden;rotatable=0;whiteSpace=wrap;fontSize=11;fontColor=#333333;" vertex="1" parent="entity-orgs">
      <mxGeometry y="80" width="200" height="26" as="geometry"/>
    </mxCell>

    <!-- Relationship -->
    <mxCell id="rel-1" value="belongs to (N:1)" style="edgeStyle=entityRelationEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=ERone;endFill=0;startArrow=ERmany;startFill=0;" edge="1" source="entity-users" target="entity-orgs" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## Infrastructure Topology

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Cloud Cluster -->
    <mxCell id="cluster-1" value="Production Environment" style="swimlane;startSize=30;fillColor=#e6e6e6;strokeColor=#999999;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="100" width="800" height="500" as="geometry"/>
    </mxCell>

    <!-- Load Balancer -->
    <mxCell id="lb-1" value="Load Balancer" style="shape=mxgraph.aws3.classic_load_balancer;whiteSpace=wrap;fillColor=#f58534;strokeColor=#d05c17;fontColor=#333333;fontSize=12;verticalLabelPosition=bottom;verticalAlign=top;" vertex="1" parent="cluster-1">
      <mxGeometry x="340" y="50" width="80" height="80" as="geometry"/>
    </mxCell>

    <!-- App Servers -->
    <mxCell id="app-1" value="App Server 1" style="rounded=1;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=12;arcSize=6;" vertex="1" parent="cluster-1">
      <mxGeometry x="140" y="200" width="160" height="80" as="geometry"/>
    </mxCell>

    <mxCell id="app-2" value="App Server 2" style="rounded=1;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=12;arcSize=6;" vertex="1" parent="cluster-1">
      <mxGeometry x="460" y="200" width="160" height="80" as="geometry"/>
    </mxCell>

    <!-- Database -->
    <mxCell id="db-1" value="Primary DB&lt;br&gt;&lt;i&gt;PostgreSQL&lt;/i&gt;" style="shape=cylinder3;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;boundedLbl=1;stencilColors=1;size=15;" vertex="1" parent="cluster-1">
      <mxGeometry x="300" y="370" width="160" height="100" as="geometry"/>
    </mxCell>

    <!-- Edges -->
    <mxCell id="infra-edge-1" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontSize=10;" edge="1" source="lb-1" target="app-1" parent="cluster-1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="infra-edge-2" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontSize=10;" edge="1" source="lb-1" target="app-2" parent="cluster-1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="infra-edge-3" value="SQL" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontColor=#333333;fontSize=10;" edge="1" source="app-1" target="db-1" parent="cluster-1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## Network Topology

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Public Zone -->
    <mxCell id="zone-public" value="Public Zone (DMZ)" style="swimlane;startSize=30;fillColor=#f8cecc;strokeColor=#b85450;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="60" width="800" height="180" as="geometry"/>
    </mxCell>

    <mxCell id="cdn-1" value="CDN" style="ellipse;shape=cloud;whiteSpace=wrap;fillColor=#fff2cc;strokeColor=#d6b656;fontColor=#333333;fontSize=12;" vertex="1" parent="zone-public">
      <mxGeometry x="40" y="50" width="140" height="90" as="geometry"/>
    </mxCell>

    <mxCell id="waf-1" value="WAF" style="rounded=1;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=12;arcSize=6;" vertex="1" parent="zone-public">
      <mxGeometry x="280" y="60" width="120" height="60" as="geometry"/>
    </mxCell>

    <mxCell id="lb-pub" value="Load Balancer" style="rounded=1;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=12;arcSize=6;" vertex="1" parent="zone-public">
      <mxGeometry x="520" y="60" width="140" height="60" as="geometry"/>
    </mxCell>

    <!-- Application Zone -->
    <mxCell id="zone-app" value="Application Zone (Private)" style="swimlane;startSize=30;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="300" width="800" height="180" as="geometry"/>
    </mxCell>

    <mxCell id="api-1" value="API Gateway" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="zone-app">
      <mxGeometry x="40" y="60" width="160" height="70" as="geometry"/>
    </mxCell>

    <mxCell id="svc-1" value="App Service" style="rounded=1;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="zone-app">
      <mxGeometry x="320" y="60" width="160" height="70" as="geometry"/>
    </mxCell>

    <!-- Data Zone -->
    <mxCell id="zone-data" value="Data Zone (Restricted)" style="swimlane;startSize=30;fillColor=#d5e8d4;strokeColor=#82b366;fontColor=#333333;fontSize=13;fontStyle=1;rounded=1;arcSize=6;container=1;" vertex="1" parent="1">
      <mxGeometry x="100" y="540" width="800" height="180" as="geometry"/>
    </mxCell>

    <mxCell id="db-net" value="Primary DB" style="shape=cylinder3;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;boundedLbl=1;stencilColors=1;size=15;" vertex="1" parent="zone-data">
      <mxGeometry x="40" y="50" width="140" height="90" as="geometry"/>
    </mxCell>

    <mxCell id="cache-net" value="Redis Cache" style="shape=hexagon;whiteSpace=wrap;fillColor=#438dd5;strokeColor=#3c7fc0;fontColor=#ffffff;fontSize=12;fontStyle=1;perimeter=hexagonPerimeter2;size=0.1;" vertex="1" parent="zone-data">
      <mxGeometry x="320" y="55" width="160" height="80" as="geometry"/>
    </mxCell>

    <!-- Cross-zone edges -->
    <mxCell id="net-edge-1" value="HTTPS" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontColor=#333333;fontSize=10;" edge="1" source="lb-pub" target="api-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="net-edge-2" value="gRPC" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontColor=#333333;fontSize=10;" edge="1" source="api-1" target="svc-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="net-edge-3" value="SQL/TLS" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#666666;fontColor=#333333;fontSize=10;" edge="1" source="svc-1" target="db-net" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```

## State Machine

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Initial State -->
    <mxCell id="state-init" value="" style="ellipse;fillColor=#333333;strokeColor=#333333;" vertex="1" parent="1">
      <mxGeometry x="100" y="200" width="30" height="30" as="geometry"/>
    </mxCell>

    <!-- States -->
    <mxCell id="state-1" value="Idle" style="rounded=1;whiteSpace=wrap;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;arcSize=20;" vertex="1" parent="1">
      <mxGeometry x="220" y="185" width="140" height="60" as="geometry"/>
    </mxCell>

    <mxCell id="state-2" value="Processing" style="rounded=1;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontColor=#333333;fontSize=12;arcSize=20;" vertex="1" parent="1">
      <mxGeometry x="460" y="185" width="140" height="60" as="geometry"/>
    </mxCell>

    <mxCell id="state-3" value="Completed" style="rounded=1;whiteSpace=wrap;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;arcSize=20;" vertex="1" parent="1">
      <mxGeometry x="700" y="100" width="140" height="60" as="geometry"/>
    </mxCell>

    <mxCell id="state-4" value="Failed" style="rounded=1;whiteSpace=wrap;fillColor=#f8cecc;strokeColor=#b85450;fontColor=#333333;fontSize=12;arcSize=20;" vertex="1" parent="1">
      <mxGeometry x="700" y="280" width="140" height="60" as="geometry"/>
    </mxCell>

    <!-- Transitions -->
    <mxCell id="trans-0" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#6c8ebf;fontSize=10;endArrow=block;endFill=1;" edge="1" source="state-init" target="state-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="trans-1" value="start()" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="state-1" target="state-2" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="trans-2" value="success()" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="state-2" target="state-3" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="trans-3" value="error()" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#b85450;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="state-2" target="state-4" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>

    <mxCell id="trans-4" value="retry()" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#6c8ebf;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="state-4" target="state-1" parent="1">
      <mxGeometry relative="1" as="geometry">
        <Array as="points">
          <mxPoint x="770" y="400"/>
          <mxPoint x="290" y="400"/>
        </Array>
      </mxGeometry>
    </mxCell>
  </root>
</mxGraphModel>
```

## CI/CD Pipeline

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" parent="0"/>

    <!-- Source -->
    <mxCell id="stage-1" value="Source&lt;br&gt;&lt;i&gt;Git Push&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#dae8fc;strokeColor=#6c8ebf;fontColor=#333333;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="60" y="150" width="160" height="70" as="geometry"/>
    </mxCell>

    <!-- Build -->
    <mxCell id="stage-2" value="Build&lt;br&gt;&lt;i&gt;Docker Build&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontColor=#333333;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="300" y="150" width="160" height="70" as="geometry"/>
    </mxCell>

    <!-- Test -->
    <mxCell id="stage-3" value="Test&lt;br&gt;&lt;i&gt;Unit + Integration&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#fff2cc;strokeColor=#d6b656;fontColor=#333333;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="540" y="150" width="160" height="70" as="geometry"/>
    </mxCell>

    <!-- Approval Gate -->
    <mxCell id="gate-1" value="Approve?" style="rhombus;whiteSpace=wrap;fillColor=#fff2cc;strokeColor=#d6b656;fontColor=#333333;fontSize=11;" vertex="1" parent="1">
      <mxGeometry x="770" y="145" width="100" height="80" as="geometry"/>
    </mxCell>

    <!-- Deploy -->
    <mxCell id="stage-4" value="Deploy&lt;br&gt;&lt;i&gt;K8s Rollout&lt;/i&gt;" style="rounded=1;whiteSpace=wrap;fillColor=#e1d5e7;strokeColor=#9673a6;fontColor=#333333;fontSize=12;fontStyle=1;arcSize=10;" vertex="1" parent="1">
      <mxGeometry x="950" y="150" width="160" height="70" as="geometry"/>
    </mxCell>

    <!-- Artifact -->
    <mxCell id="artifact-1" value="Docker Image" style="shape=mxgraph.flowchart.document;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;fontSize=11;" vertex="1" parent="1">
      <mxGeometry x="320" y="280" width="120" height="70" as="geometry"/>
    </mxCell>

    <!-- Pipeline flow edges -->
    <mxCell id="pipe-1" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="stage-1" target="stage-2" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="pipe-2" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="stage-2" target="stage-3" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="pipe-3" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="stage-3" target="gate-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="pipe-4" value="Yes" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#333333;fontColor=#333333;fontSize=10;endArrow=block;endFill=1;" edge="1" source="gate-1" target="stage-4" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="pipe-5" value="produces" style="edgeStyle=orthogonalEdgeStyle;rounded=1;strokeColor=#999999;fontColor=#999999;fontSize=10;dashed=1;endArrow=open;endFill=0;" edge="1" source="stage-2" target="artifact-1" parent="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>
```
