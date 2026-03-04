---
description: "SDLC plugin help and documentation"
---

# SDLC Plugin — Help

The SDLC plugin provides interactive PRD (Product Requirements Document) workflows using BMAD methodology.

## Available Commands

| Command | Description |
|---------|------------|
| `/sdlc:create-prd` | Create a new PRD from scratch (12-step interactive workflow) |
| `/sdlc:validate-prd` | Validate an existing PRD against BMAD standards (13 checks) |
| `/sdlc:edit-prd` | Edit and improve an existing PRD (5-step workflow) |
| `/sdlc:help` | Show this help information |

## Architecture

### Skills
- **prd-standards** — Reference skill with BMAD PRD methodology, quality standards, and data files. Auto-loaded when PRD work is detected.
- **create-prd** — 12-step interactive workflow for creating PRDs from scratch.
- **validate-prd** — 13-step comprehensive validation workflow.
- **edit-prd** — 5-step workflow for improving existing PRDs.

### Subagent
- **prd-validator** — Runs PRD validation in an isolated context using the validate-prd skill. Returns a structured report without polluting your main conversation. Used by `/sdlc:validate-prd` when subagent mode is selected.

### Hooks
- **PostToolUse[Edit|Write]** — Automatically checks PRD format when you edit or write PRD files.
- **Stop** — Verifies workflow task completeness before ending.

## How It Works

Each workflow uses **step-file architecture**:
- One step file loaded at a time (just-in-time loading)
- Steps are executed sequentially — no skipping allowed
- Interactive menus at each checkpoint — you drive the workflow
- Progress tracked in document frontmatter

## Configuration

The plugin reads from `_bmad/bmm/config.yaml` when available for:
- `project_name`, `user_name`, `output_folder`, `planning_artifacts`
- `communication_language`, `document_output_language`
- `user_skill_level`

