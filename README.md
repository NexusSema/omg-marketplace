# OM Nexus Official — SDLC Plugin

A Claude Code plugin that brings structured, interactive SDLC workflows to your development process. Built on the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD), the plugin packages battle-tested product planning methodology into composable skills, subagents, and hooks that run directly inside Claude Code.

**Current release: PRD Workflows v1.0** — create, validate, and edit Product Requirements Documents through guided, step-by-step conversations.

> Future releases will extend coverage across the full SDLC: UX design, architecture, epic/story breakdown, sprint planning, implementation, QA, and retrospectives.

## Quick Start

```bash
# Install the plugin
claude plugin add ./path/to/nexus-claude-plugin

# Start creating a PRD
/sdlc:create-prd

# Validate an existing PRD
/sdlc:validate-prd

# Edit and improve a PRD
/sdlc:edit-prd

# See all available commands
/sdlc:help
```

## What You Get

| Command | What it does | Steps |
|---------|-------------|-------|
| `/sdlc:create-prd` | Build a PRD from scratch through collaborative discovery | 12 |
| `/sdlc:validate-prd` | Audit a PRD against BMAD quality standards | 13 |
| `/sdlc:edit-prd` | Improve an existing PRD with structured review | 5 |
| `/sdlc:help` | Plugin documentation and architecture overview | — |

Each workflow is **interactive** — Claude facilitates, you drive. Menus at every checkpoint let you advance, dig deeper, or adjust direction. No autonomous generation; every section gets your input and approval.

## How It Works

The plugin uses four Claude Code extension types working together:

```
Commands ──> Skills ──> Step Files (references/)
                  │
                  └──> Subagent (isolated validation)
                  │
Hooks ─────────────> Format checks on every PRD edit
```

- **Skills** hold the workflow methodology — what to do and how to do it
- **Step files** break each workflow into micro-instructions loaded one at a time (just-in-time, never all at once)
- **Subagent** runs validation in an isolated context so your main conversation stays clean
- **Hooks** automatically check PRD format on every edit and verify task completeness on stop

### Context Budget

The plugin is designed to be lightweight at startup:

| Component | Count | Startup Tokens |
|-----------|-------|---------------|
| Reference skill (prd-standards) | 1 | ~80 |
| Action skills (lazy-loaded) | 3 | 0 |
| Subagent | 1 | 0 |
| Hooks | 2 | 0 |
| Commands | 4 | ~200 |
| **Total** | **11** | **~280 (<0.2% of 200K)** |

## Plugin Architecture

```
plugins/sdlc/
├── skills/
│   ├── prd-standards/        # Auto-loaded reference: BMAD methodology + data
│   ├── create-prd/           # 12-step interactive PRD creation
│   ├── validate-prd/         # 13-step PRD validation
│   └── edit-prd/             # 5-step PRD editing
├── agents/
│   └── prd-validator.md      # Isolated validation subagent
├── commands/                 # User entry points (/sdlc:*)
├── hooks/                    # PostToolUse + Stop quality checks
└── scripts/                  # PRD format validation script
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

## Optional Dependencies

Some workflow steps offer advanced features that require BMAD core:

- **Advanced Elicitation** — deeper requirement discovery techniques
- **Party Mode** — multi-agent brainstorming sessions

These are clearly marked as optional in the step files. The plugin is fully functional without them.

## Roadmap

The SDLC plugin will grow to cover the full software development lifecycle:

- [x] **PRD Workflows** — Create, validate, edit (v1.0)
- [ ] **UX Design** — Interaction flows, design specs
- [ ] **Architecture** — Technical design decisions
- [ ] **Epic & Story Breakdown** — From requirements to implementable work
- [ ] **Sprint Planning** — Sprint generation and status tracking
- [ ] **Implementation** — Story-driven development workflows
- [ ] **QA & Code Review** — Automated quality gates
- [ ] **Retrospectives** — Post-epic review and lessons learned

## License

See repository license.
