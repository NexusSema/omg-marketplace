# SDLC & Scrum Master Skills for GitHub Copilot

BMAD-METHOD SDLC workflows and Scrum Master Jira/Confluence automation migrated to GitHub Copilot. Provides interactive product planning, technical specification management, Jira issue tracking, and Confluence sync through prompts, skills, subagents, and hooks that run directly inside VS Code with Copilot.

## Setup

No installation required. The `.github/` folder is auto-discovered by Copilot when you open this workspace.

Verify by typing `/` in Copilot Chat — prompts like `/sdlc-prd-create` should appear.

## Usage

Type `/` in Copilot Chat to invoke a prompt, or type the skill name directly.

```
# PRD workflows
/sdlc-prd-create        # Create a PRD from scratch (12-step interactive workflow)
/sdlc-prd-validate      # Validate an existing PRD against BMAD standards (13 checks)
/sdlc-prd-edit          # Edit and improve an existing PRD (5-step workflow)

# Architecture workflows
/sdlc-arch-create       # Create architecture decisions from a PRD (8-step workflow)
/sdlc-arch-shard        # Shard architecture into 7 focused sub-documents
/sdlc-arch-validate     # Validate architecture document against standards
/sdlc-arch-diagrams     # Generate draw.io C4 diagrams from architecture shard documents

# Epics & Stories
/sdlc-epics-create      # Break requirements into epics and user stories (4-step workflow)
/sdlc-epics-gaps        # Find implementation gaps in epics/stories (6-step workflow)

# Technical Specifications
/sdlc-spec-create       # Create a new technical specification (5-step workflow)
/sdlc-spec-edit         # Edit a specification with impact analysis (4-step workflow)
/sdlc-spec-propagate    # Propagate spec changes across related documents (4-step workflow)
/sdlc-spec-review       # Review a specification for consistency and contamination

# Integrations
/sdlc-confluence        # Manage Confluence pages via REST API (fetch, edit, push, create)

# General
/sdlc-help              # Documentation and overview

# Scrum Master
/sm-jira                # Manage Jira issues, sprints, and boards
/sm-sync-docs           # Bidirectional markdown ↔ Confluence sync
/sm-help                # Scrum Master plugin documentation
```

> **Tip:** Skills like `/prd-standards`, `/architecture-diagrams`, `/confluence`, etc. also appear as slash commands and can be invoked directly for reference or standalone use.

## What You Get

### PRD (Product Requirements Document)

| Prompt | What it does | Steps |
|--------|-------------|-------|
| `/sdlc-prd-create` | Build a PRD from scratch through collaborative discovery | 12 |
| `/sdlc-prd-validate` | Audit a PRD against BMAD quality standards (subagent or interactive) | 13 |
| `/sdlc-prd-edit` | Improve an existing PRD with structured review | 5 |

### Architecture (Solution Design)

| Prompt | What it does | Steps |
|--------|-------------|-------|
| `/sdlc-arch-create` | Create architecture decisions from a PRD | 8 |
| `/sdlc-arch-shard` | Decompose monolithic architecture into 7 sub-documents with Mermaid diagrams | 8 |
| `/sdlc-arch-validate` | Validate architecture document against BMAD standards (subagent or interactive) | — |
| `/sdlc-arch-diagrams` | Generate styled draw.io C4 diagrams from shard doc content (sequential, parallel, or interactive) | — |

### Epics & Stories

| Prompt | What it does | Steps |
|--------|-------------|-------|
| `/sdlc-epics-create` | Break PRD/Architecture/UX requirements into user-value-focused epics with detailed stories | 4 |
| `/sdlc-epics-gaps` | Analyze epics/stories for implementation gaps — missing infra, dependencies, assumptions | 6 |

### Technical Specifications

| Prompt | What it does | Steps |
|--------|-------------|-------|
| `/sdlc-spec-create` | Create a new technical spec through collaborative 5-step workflow | 5 |
| `/sdlc-spec-edit` | Edit a spec with full impact analysis across all sections | 4 |
| `/sdlc-spec-propagate` | Propagate spec changes to all downstream documents | 4 |
| `/sdlc-spec-review` | Review a spec for consistency, contamination, and structure (subagent or interactive) | — |

### Integrations

| Prompt | What it does |
|--------|-------------|
| `/sdlc-confluence` | Fetch, edit, create, push, and delete Confluence pages via REST API v2 |

### Scrum Master

| Prompt | What it does |
|--------|-------------|
| `/sm-jira` | Manage Jira issues, sprints, and boards — create, update, transition, search, bulk operations |
| `/sm-sync-docs` | Push `.md` → Confluence or pull Confluence → `.md` with frontmatter tracking |
| `/sm-help` | Scrum Master plugin documentation and workflow overview |

---

Each workflow is **interactive** — Copilot facilitates, you drive. Menus at every checkpoint let you advance, dig deeper, or adjust direction.

## How It Works

```
Prompts ──> Skills ──> Step Files (references/)
                 |
                 └──> Subagents (isolated validation / batch processing)

Hooks ─────────────> Format checks on every file edit
```

- **Prompts** (`.github/prompts/`) — entry points, invoked via `/` in chat
- **Skills** (`.github/skills/`) — workflow methodology with step-by-step references loaded just-in-time
- **Subagents** (`.github/agents/`) — run validation and batch diagram generation in isolated contexts, keeping your main conversation clean
- **Hooks** (`.github/hooks/`) — automatically validate document and diagram format on every edit

## Configuration

Workflows read `_bmad/bmm/config.yaml` when available at the project root:

```yaml
project_name: "My Project"
user_name: "Your Name"
output_folder: "./output"
planning_artifacts: "planning"
communication_language: "English"
document_output_language: "English"
user_skill_level: "intermediate"
```

Without a config file, each workflow will prompt for language preferences on first run and use sensible defaults.

## Folder Structure

```
.github/
├── prompts/                         # Entry points (type / in chat)
│   ├── sdlc-prd-create.prompt.md
│   ├── sdlc-prd-edit.prompt.md
│   ├── sdlc-prd-validate.prompt.md
│   ├── sdlc-arch-create.prompt.md
│   ├── sdlc-arch-shard.prompt.md
│   ├── sdlc-arch-validate.prompt.md
│   ├── sdlc-arch-diagrams.prompt.md
│   ├── sdlc-epics-create.prompt.md
│   ├── sdlc-epics-gaps.prompt.md
│   ├── sdlc-spec-create.prompt.md
│   ├── sdlc-spec-edit.prompt.md
│   ├── sdlc-spec-propagate.prompt.md
│   ├── sdlc-spec-review.prompt.md
│   ├── sdlc-confluence.prompt.md
│   ├── sdlc-help.prompt.md
│   ├── sm-jira.prompt.md
│   ├── sm-sync-docs.prompt.md
│   └── sm-help.prompt.md
│
├── agents/                          # Subagents (invoked automatically, not by user)
│   ├── prd-validator.agent.md       # Isolated PRD validation
│   ├── arch-validator.agent.md      # Isolated architecture validation
│   ├── c4-diagram-generator.agent.md # draw.io generation for a single shard doc
│   └── spec-reviewer.agent.md       # Isolated spec review (consistency + contamination)
│
├── skills/                          # Bundled workflow assets
│   ├── prd-standards/               # BMAD PRD methodology + data files
│   ├── prd-create/                  # 12-step PRD creation workflow
│   ├── prd-validate/                # 13-step PRD validation workflow
│   ├── prd-edit/                    # 5-step PRD editing workflow
│   ├── architecture-standards/      # Architecture methodology + data files
│   ├── architecture-create/         # 8-step architecture creation workflow
│   ├── architecture-shard/          # 8-step architecture sharding workflow
│   ├── architecture-diagrams/       # C4 draw.io generation workflow + references
│   ├── epics-create/                # 4-step epics and stories workflow
│   ├── epics-gaps-analysis/         # 6-step implementation gaps analysis
│   ├── confluence/                  # Confluence REST API v2 workflow
│   ├── spec-standards/              # Universal spec quality dimensions
│   ├── spec-create/                 # 5-step specification creation workflow
│   ├── spec-edit/                   # 4-step specification editing with impact analysis
│   ├── spec-propagate/              # 4-step specification change propagation workflow
│   ├── spec-review/                 # Spec review check categories and algorithms
│   ├── jira/                        # Jira REST API v3 patterns and workflows
│   └── confluence-sync/             # Bidirectional markdown ↔ Confluence sync workflows
│
└── hooks/                           # Automated format checks on file edits
    ├── sdlc-hooks.json              # SDLC hook configuration (PostToolUse format checks)
    ├── sm-hooks.json                # Scrum Master hook configuration (Stop verification)
    └── scripts/
        ├── validate-prd-format.sh   # Checks PRD files for required BMAD sections
        ├── validate-arch-format.sh  # Checks architecture docs for required sections
        ├── validate-shard-format.sh # Checks shard documents (01-07-*.md) structure
        └── validate-drawio-format.sh # Validates .drawio XML structure
```

## Subagents

These agents are invoked automatically by workflows — they are **not** meant to be called directly.

| Agent | Triggered by | Purpose |
|-------|-------------|---------|
| `prd-validator` | `/sdlc-prd-validate` (option A) | Validates PRD against all 13 BMAD checks in isolated context |
| `arch-validator` | `/sdlc-arch-validate` (option A) | Validates architecture document in isolated context |
| `c4-diagram-generator` | `/sdlc-arch-diagrams` (option A/B) | Generates draw.io diagrams for a single shard document || `spec-reviewer` | `/sdlc-spec-review` (option A) | Reviews spec for consistency, contamination, and structure in isolated context |
## Hooks

PostToolUse hooks run automatically when Copilot edits or writes a file:

| Script | Triggers on | What it checks |
|--------|------------|----------------|
| `validate-prd-format.sh` | `*prd*.md` files | Required BMAD sections (Executive Summary, Functional Requirements, etc.) |
| `validate-arch-format.sh` | `*architect*.md` files | Required sections (Project Context, Core Decisions, etc.) |
| `validate-shard-format.sh` | `01-*.md` – `07-*.md` files | Gaps section, Cross-References, frontmatter, Mermaid diagrams |
| `validate-drawio-format.sh` | `*.drawio` files | mxGraphModel root, required mxCell IDs, XML well-formedness |

Hooks emit warnings only — they never block writes or fail the workflow.

## Enabling Hooks

To activate the hooks, add the hook config paths to your VS Code `settings.json`:

```json
{
  "github.copilot.chat.agent.hooks": [
    ".github/hooks/sdlc-hooks.json",
    ".github/hooks/sm-hooks.json"
  ]
}
```

Or use the workspace `.vscode/settings.json` to share the setting with your team.
