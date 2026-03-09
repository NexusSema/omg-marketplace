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
| `/sdlc:arch-validate` | Validate architecture document against standards (subagent or interactive) |

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

### Subagents
- **prd-validator** — Runs PRD validation in an isolated context using the prd/validate skill. Returns a structured report without polluting your main conversation. Used by `/sdlc:prd-validate` when subagent mode is selected.
- **arch-validator** — Runs architecture validation in an isolated context. Checks required sections and structural quality. Used by `/sdlc:arch-validate` when subagent mode is selected.

### Hooks
- **PostToolUse[Edit|Write]** — Automatically checks PRD format and architecture document format when you edit or write relevant files.
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
└── architecture/           # Architecture phase
    ├── standards/          # Architecture methodology + data
    └── create/             # 8-step creation workflow
```

## Configuration

The plugin reads from `_bmad/bmm/config.yaml` when available for:
- `project_name`, `user_name`, `output_folder`, `planning_artifacts`
- `communication_language`, `document_output_language`
- `user_skill_level`
