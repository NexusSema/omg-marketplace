# OM Nexus Official — SDLC Plugin

A Claude Code plugin that brings structured, interactive SDLC workflows to your development process. Built on the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD), the plugin packages battle-tested product planning methodology into composable skills, subagents, and hooks that run directly inside Claude Code.

## Install

```bash
claude plugin install --scope local sdlc
```

### Verify installation

```bash
# Should list sdlc commands
/sdlc:help
```

## Usage

```bash
# PRD workflows
/sdlc:prd-create        # Create a PRD from scratch (12-step interactive workflow)
/sdlc:prd-validate      # Validate an existing PRD against BMAD standards (13 checks)
/sdlc:prd-edit          # Edit and improve an existing PRD (5-step workflow)

# Architecture workflows
/sdlc:arch-create       # Create architecture decisions from a PRD (8-step workflow)
/sdlc:arch-shard        # Shard architecture into 7 focused sub-documents (8-step workflow)
/sdlc:arch-validate     # Validate architecture document against standards
/sdlc:arch-diagrams     # Convert Mermaid diagrams to styled draw.io files

# General
/sdlc:help              # Plugin documentation and architecture overview
```

## What You Get

### PRD (Product Requirements Document)

| Command | What it does | Steps |
|---------|-------------|-------|
| `/sdlc:prd-create` | Build a PRD from scratch through collaborative discovery | 12 |
| `/sdlc:prd-validate` | Audit a PRD against BMAD quality standards | 13 |
| `/sdlc:prd-edit` | Improve an existing PRD with structured review | 5 |

### Architecture (Solution Design)

| Command | What it does | Steps |
|---------|-------------|-------|
| `/sdlc:arch-create` | Create architecture decisions from a PRD | 8 |
| `/sdlc:arch-shard` | Decompose monolithic architecture into 7 sub-documents with Mermaid diagrams | 8 |
| `/sdlc:arch-validate` | Validate architecture document against BMAD standards (subagent or interactive) | — |
| `/sdlc:arch-diagrams` | Convert Mermaid diagrams from shard docs to styled draw.io C4 files (subagent or interactive) | — |

### General

| Command | What it does |
|---------|-------------|
| `/sdlc:help` | Plugin documentation and architecture overview |

Each workflow is **interactive** — Claude facilitates, you drive. Menus at every checkpoint let you advance, dig deeper, or adjust direction. No autonomous generation; every section gets your input and approval.

## How It Works

The plugin uses four Claude Code extension types working together:

```
Commands ──> Skills ──> Step Files (references/)
                  |
                  └──> Subagents (isolated validation / batch processing)
                  |
Hooks ─────────────> Format checks on every edit
```

- **Skills** hold the workflow methodology — what to do and how to do it
- **Step files** break each workflow into micro-instructions loaded one at a time (just-in-time, never all at once)
- **Subagents** run validation and batch processing in isolated contexts so your main conversation stays clean
- **Hooks** automatically check document and diagram format on every edit and verify task completeness on stop

## Plugin Architecture

```
plugins/sdlc/
├── skills/
│   ├── prd/                    # PRD phase
│   │   ├── standards/          # Auto-loaded reference: BMAD methodology + data
│   │   ├── create/             # 12-step interactive PRD creation
│   │   ├── validate/           # 13-step PRD validation
│   │   └── edit/               # 5-step PRD editing
│   └── architecture/           # Architecture phase
│       ├── standards/          # Architecture methodology + data
│       ├── create/             # 8-step architecture creation
│       ├── shard/              # 8-step architecture sharding
│       └── diagrams/           # C4-to-draw.io conversion + references
├── agents/
│   ├── prd-validator.md        # Isolated PRD validation subagent
│   ├── arch-validator.md       # Isolated architecture validation subagent
│   └── c4-diagram-generator.md # Mermaid-to-draw.io batch conversion subagent
├── commands/                   # User entry points (/sdlc:*)
├── hooks/                      # PostToolUse + Stop quality checks
└── scripts/                    # Format validation scripts (PRD, arch, shard, draw.io)
```

## Documentation

- **[PRD Workflows — Detailed Guide](docs/prd-workflows.md)** — Step-by-step breakdown of all three PRD workflows, what each step does, quality standards, and configuration options.

## Configuration

The plugin reads from `_bmad/bmm/config.yaml` when available:

```yaml
project_name: "My Project"
user_name: "Your Name"
output_folder: "./output"
planning_artifacts: "./output/planning"
communication_language: "English"
document_output_language: "English"
user_skill_level: "expert"
```

All fields are optional. Without a config file, the plugin will prompt for what it needs.

## Roadmap

The SDLC plugin will grow to cover the full software development lifecycle:

- [x] **PRD Workflows** — Create, validate, edit
- [x] **Architecture** — Design, shard, validate, C4 diagram generation
- [ ] **UX Design** — Interaction flows, design specs
- [ ] **Epic & Story Breakdown** — From requirements to implementable work
- [ ] **Sprint Planning** — Sprint generation and status tracking
- [ ] **Implementation** — Story-driven development workflows
- [ ] **QA & Code Review** — Automated quality gates
- [ ] **Retrospectives** — Post-epic review and lessons learned

## License

See repository license.
