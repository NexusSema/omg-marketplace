---
description: "SDLC plugin help and documentation"
---

# SDLC Plugin — Help

The SDLC plugin provides interactive SDLC workflows using BMAD methodology. Workflows are organized by phase.

## Available Commands

### PRD (Product Requirements Document)

| Command | Description |
|---------|------------|
| `/sdlc:prd-create` | Create a new PRD from scratch (12-step interactive workflow) |
| `/sdlc:prd-validate` | Validate an existing PRD against BMAD standards (13 checks) |
| `/sdlc:prd-edit` | Edit and improve an existing PRD (5-step workflow) |

### Architecture (Solution Design)

| Command | Description |
|---------|------------|
| `/sdlc:arch-create` | Create architecture decisions from a PRD (8-step interactive workflow) |
| `/sdlc:arch-shard` | Shard a monolithic architecture into 7 focused sub-documents (8-step workflow) |
| `/sdlc:arch-validate` | Validate architecture document against standards (subagent or interactive) |
| `/sdlc:arch-diagrams` | Convert Mermaid diagrams from shard docs to styled draw.io files (subagent or interactive) |

### Epics & Stories

| Command | Description |
|---------|------------|
| `/sdlc:epics-create` | Break PRD/Architecture/UX requirements into epics with detailed stories (4-step workflow) |
| `/sdlc:epics-gaps` | Analyze epics/stories for implementation gaps — missing infra, dependencies, cross-cutting concerns (6-step workflow) |

### Spec (Technical Specifications)

| Command | Description |
|---------|------------|
| `/sdlc:spec-create` | Create a technical specification from scratch (5-step interactive workflow) |
| `/sdlc:spec-edit` | Edit and improve an existing specification |
| `/sdlc:spec-review` | Review a specification for consistency, contamination, and completeness (subagent or interactive) |
| `/sdlc:spec-propagate` | Propagate changes across related specification documents |

### Confluence

| Command | Description |
|---------|------------|
| `/sdlc:confluence` | Fetch, edit, push, search, create Confluence pages |

### General

| Command | Description |
|---------|------------|
| `/sdlc:help` | Show this help information |

## Architecture

### Skills (organized by phase)

**prd/**
- **prd/standards** — Reference skill with BMAD PRD methodology, quality standards, and data files. Auto-loaded when PRD work is detected.
- **prd/create** — 12-step interactive workflow for creating PRDs from scratch.
- **prd/validate** — 13-step comprehensive validation workflow.
- **prd/edit** — 5-step workflow for improving existing PRDs.

**architecture/**
- **architecture/standards** — Reference skill with architecture methodology, required sections, project types, and domain complexity data.
- **architecture/create** — 8-step interactive workflow for creating architecture decisions from a PRD.
- **architecture/shard** — 8-step workflow for decomposing a monolithic architecture document into 7 focused sub-documents with Mermaid diagrams, gap analysis, and cross-references.
- **architecture/diagrams** — C4-to-draw.io conversion skill with shape definitions, color palettes, layout rules, XML templates, and Mermaid-to-draw.io mappings.

**spec/**
- **spec/standards** — Reference skill with specification methodology, contamination patterns, consistency rules, and report templates.
- **spec/create** — 5-step interactive workflow for creating technical specifications from scratch.
- **spec/edit** — Workflow for editing and improving existing specifications.
- **spec/review** — Review methodology for checking consistency, contamination, and completeness.
- **spec/propagate** — Cross-document change propagation with impact analysis.

### Subagents
- **prd-validator** — Runs PRD validation in an isolated context using the prd/validate skill. Returns a structured report without polluting your main conversation. Used by `/sdlc:prd-validate` when subagent mode is selected.
- **arch-validator** — Runs architecture validation in an isolated context. Checks required sections and structural quality. Used by `/sdlc:arch-validate` when subagent mode is selected.
- **c4-diagram-generator** — Converts Mermaid diagrams from shard documents into styled draw.io files with C4 shapes, colors, and layout. Used by `/sdlc:arch-diagrams` when subagent mode is selected.
- **spec-reviewer** — Reviews specifications for consistency, contamination, and completeness in an isolated context. Returns a structured findings report. Used by `/sdlc:spec-review` when subagent mode is selected.

### Hooks
- **PostToolUse[Edit|Write]** — Automatically checks PRD format, architecture document format, shard document format, draw.io file format, Confluence XHTML format, and spec format when you edit or write relevant files.
- **Stop** — Verifies workflow task completeness before ending.

## How It Works

Each workflow uses **step-file architecture**:
- One step file loaded at a time (just-in-time loading)
- Steps are executed sequentially — no skipping allowed
- Interactive menus at each checkpoint — you drive the workflow
- Progress tracked in document frontmatter

## Plugin Structure

```
skills/
├── prd/                    # PRD phase
│   ├── standards/          # BMAD methodology + data
│   ├── create/             # 12-step creation workflow
│   ├── validate/           # 13-step validation workflow
│   └── edit/               # 5-step edit workflow
├── architecture/           # Architecture phase
│   ├── standards/          # Architecture methodology + data
│   ├── create/             # 8-step creation workflow
│   ├── shard/              # 8-step architecture sharding workflow
│   └── diagrams/           # C4-to-draw.io conversion skill + references
├── epics/                  # Epics & Stories phase
│   ├── create/             # 4-step epic and story creation
│   └── gaps-analysis/      # 6-step implementation gaps analysis
├── spec/                   # Technical Specifications phase
│   ├── standards/          # Spec methodology + contamination patterns
│   ├── create/             # 5-step spec creation workflow
│   ├── edit/               # Spec editing workflow
│   ├── review/             # Review methodology + report template
│   └── propagate/          # Cross-document change propagation
└── confluence/             # Confluence page management
```

## Configuration

The plugin reads from `_bmad/bmm/config.yaml` when available for:
- `project_name`, `user_name`, `output_folder`, `planning_artifacts`
- `communication_language`, `document_output_language`
- `user_skill_level`
