# C4 Color Palettes

Color tables for each diagram type. All values are draw.io hex format.

## C4 Model Colors

### Level 1 — Context Diagram

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Person | `#08427b` | `#073b6b` | `#ffffff` |
| Internal System | `#438dd5` | `#3c7fc0` | `#ffffff` |
| External System | `#999999` | `#8a8a8a` | `#ffffff` |
| System Boundary | `none` | `#444444` | `#444444` |
| Enterprise Boundary | `none` | `#666666` | `#666666` |
| Relationship | — | `#707070` | `#707070` |

### Level 2 — Container Diagram

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Person | `#08427b` | `#073b6b` | `#ffffff` |
| Container (App) | `#438dd5` | `#3c7fc0` | `#ffffff` |
| Container (DB) | `#438dd5` | `#3c7fc0` | `#ffffff` |
| Container (Queue) | `#438dd5` | `#3c7fc0` | `#ffffff` |
| Container (Cache) | `#438dd5` | `#3c7fc0` | `#ffffff` |
| External System | `#999999` | `#8a8a8a` | `#ffffff` |
| System Boundary | `none` | `#444444` | `#444444` |
| Relationship | — | `#707070` | `#707070` |

### Level 3 — Component Diagram

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Component | `#85bbf0` | `#78aee0` | `#000000` |
| Component (Interface) | `#85bbf0` | `#78aee0` | `#000000` |
| Container Boundary | `none` | `#438dd5` | `#438dd5` |
| External System | `#999999` | `#8a8a8a` | `#ffffff` |
| Database | `#438dd5` | `#3c7fc0` | `#ffffff` |
| Relationship | — | `#707070` | `#707070` |

## Infrastructure Colors

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Server / VM | `#f5f5f5` | `#666666` | `#333333` |
| Cloud Service | `#e1d5e7` | `#9673a6` | `#333333` |
| Load Balancer | `#f58534` | `#d05c17` | `#333333` |
| Cluster Boundary | `#e6e6e6` | `#999999` | `#333333` |
| CDN | `#fff2cc` | `#d6b656` | `#333333` |
| Container Runtime | `#dae8fc` | `#6c8ebf` | `#333333` |

## Network Zone Colors

| Zone | Fill | Stroke | Font | Purpose |
|------|------|--------|------|---------|
| Public / DMZ | `#f8cecc` | `#b85450` | `#333333` | Internet-facing resources |
| Application (Private) | `#dae8fc` | `#6c8ebf` | `#333333` | App servers, APIs |
| Data (Restricted) | `#d5e8d4` | `#82b366` | `#333333` | Databases, secrets |
| Management | `#e1d5e7` | `#9673a6` | `#333333` | Monitoring, logging |
| External | `#f5f5f5` | `#999999` | `#666666` | Third-party services |

## ERD Colors

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Entity (Table) | `#dae8fc` | `#6c8ebf` | `#333333` |
| Entity (Junction) | `#fff2cc` | `#d6b656` | `#333333` |
| Field Text | `none` | `none` | `#333333` |
| PK Field Text | `none` | `none` | `#333333` (underline) |
| FK Field Text | `none` | `none` | `#6c8ebf` (italic) |
| Relationship | — | `#6c8ebf` | `#333333` |

## Sequence Diagram Colors

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Actor (Person) | `#08427b` | `#073b6b` | `#ffffff` |
| Participant (System) | `#438dd5` | `#3c7fc0` | `#ffffff` |
| Participant (External) | `#999999` | `#8a8a8a` | `#ffffff` |
| Lifeline | — | `#999999` | — |
| Activation Bar | `#438dd5` | `#3c7fc0` | — |
| Sync Message | — | `#333333` | `#333333` |
| Async Message | — | `#333333` | `#333333` |
| Return Message | — | `#999999` | `#999999` |
| Alt/Loop Frame | `#f5f5f5` | `#999999` | `#333333` |

## CI/CD Pipeline Colors

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| Source Stage | `#dae8fc` | `#6c8ebf` | `#333333` |
| Build Stage | `#d5e8d4` | `#82b366` | `#333333` |
| Test Stage | `#fff2cc` | `#d6b656` | `#333333` |
| Deploy Stage | `#e1d5e7` | `#9673a6` | `#333333` |
| Gate / Approval | `#fff2cc` | `#d6b656` | `#333333` |
| Artifact | `#f5f5f5` | `#666666` | `#333333` |
| Pipeline Flow | — | `#333333` | `#333333` |

## State Machine Colors

| Element | Fill | Stroke | Font |
|---------|------|--------|------|
| State | `#dae8fc` | `#6c8ebf` | `#333333` |
| Initial State | `#333333` | `#333333` | — |
| Final State | `#333333` | `#333333` | — |
| Active State | `#d5e8d4` | `#82b366` | `#333333` |
| Error State | `#f8cecc` | `#b85450` | `#333333` |
| Transition | — | `#6c8ebf` | `#333333` |

## Usage Notes

- All hex values include the `#` prefix — use as-is in `fillColor`, `strokeColor`, `fontColor` style properties
- `none` for fill means transparent — use `fillColor=none` in the style string
- Relationship/edge rows with `—` in Fill mean no fill applies (edges use stroke only)
- Font colors should contrast with fill: use `#ffffff` on dark fills, `#333333` or `#000000` on light fills
