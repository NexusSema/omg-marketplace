---
description: "SDLC plugin help and documentation — list all available SDLC prompts, skills, and agents"
---

# SDLC — Help

The SDLC plugin provides interactive SDLC workflows using BMAD methodology. Workflows are organized by phase.

## Available Prompts (type `/` in chat)

### PRD (Product Requirements Document)

| Prompt | Description |
|--------|------------|
| `/sdlc-prd-create` | Create a new PRD from scratch (12-step interactive workflow) |
| `/sdlc-prd-validate` | Validate an existing PRD against BMAD standards (13 checks) |
| `/sdlc-prd-edit` | Edit and improve an existing PRD (5-step workflow) |

### Architecture (Solution Design)

| Prompt | Description |
|--------|------------|
| `/sdlc-arch-create` | Create architecture decisions from a PRD (8-step interactive workflow) |
| `/sdlc-arch-shard` | Shard a monolithic architecture into 7 focused sub-documents (8-step workflow) |
| `/sdlc-arch-validate` | Validate architecture document against standards (subagent or interactive) |
| `/sdlc-arch-diagrams` | Generate styled draw.io files from shard docs (subagent or interactive) |

### Epics & Stories

| Prompt | Description |
|--------|------------|
| `/sdlc-epics-create` | Break requirements into epics and user stories from PRD and Architecture |
| `/sdlc-epics-gaps` | Analyze planning artifacts for implementation gaps |

### General

| Prompt | Description |
|--------|------------|
| `/sdlc-help` | Show this help information |

## Skills (auto-loaded or invoked via `/`)

**PRD:**
- `/prd-standards` — BMAD PRD methodology and quality standards
- `/prd-create` — 12-step PRD creation workflow
- `/prd-validate` — 13-step PRD validation workflow
- `/prd-edit` — 5-step PRD improvement workflow

**Architecture:**
- `/architecture-standards` — Architecture methodology and quality standards
- `/architecture-create` — 8-step architecture creation workflow
- `/architecture-shard` — 8-step architecture sharding workflow
- `/architecture-diagrams` — C4-to-draw.io conversion skill

**Epics:**
- `/epics-create` — Epics and stories creation workflow
- `/epics-gaps-analysis` — Implementation gaps analysis workflow

**Integrations:**
- `/confluence` — Manage Confluence pages via REST API

## Subagents

- **prd-validator** — Validates PRDs in isolated context, returns structured report
- **arch-validator** — Validates architecture documents in isolated context
- **c4-diagram-generator** — Generates styled draw.io files from shard documents

## Hooks

PostToolUse hooks automatically check file formats when you edit/write:
- PRD files (`*prd*.md`) — checks for required BMAD sections
- Architecture files (`*architect*.md`) — checks for required sections
- Shard documents (`01-07-*.md`) — checks for gaps, cross-refs, Mermaid diagrams
- draw.io files (`*.drawio`) — validates XML structure

## How It Works

Each workflow uses **step-file architecture**:
- One step file loaded at a time (just-in-time loading)
- Steps are executed sequentially — no skipping allowed
- Interactive menus at each checkpoint — you drive the workflow
- Progress tracked in document frontmatter
