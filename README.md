# OM Nexus Official — SDLC Plugin

A Claude Code plugin that brings structured, interactive SDLC workflows to your development process. Built on the [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD), the plugin packages battle-tested product planning methodology into composable skills, subagents, and hooks that run directly inside Claude Code.

## Install

### Claude Code (CLI or Desktop)

1. **Add the marketplace:**

   ```
   /plugin marketplace add NexusSema/omg-marketplace
   ```

2. **Install the plugin:**

   ```
   /plugin install sdlc@om-nexus-official
   ```

   You can choose the installation scope:

   | Scope | Command | Who sees it |
   |-------|---------|-------------|
   | User (default) | `/plugin install sdlc@om-nexus-official` | You, in all projects |
   | Project (shared) | `/plugin install sdlc@om-nexus-official --scope project` | Anyone who clones the repo |
   | Local (private) | `/plugin install sdlc@om-nexus-official --scope local` | You, in this project only |

3. **Verify:**

   ```
   /sdlc:help
   ```

### Cowork (Desktop)

1. Click **"Customize"** in the left sidebar, then **"Browse plugins"**
2. Go to the **"Personal"** tab
3. Search for `NexusSema/omg-marketplace` to add the marketplace
4. Install the **sdlc** plugin from the marketplace listing

Alternatively, you can configure it at the project level so it loads automatically for all collaborators. Add to your repository's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "om-nexus-official": {
      "source": {
        "source": "github",
        "repo": "NexusSema/omg-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "sdlc@om-nexus-official": true
  }
}
```

Commit and push — anyone opening the project in Cowork will be prompted to install the plugin.

### Managing the Plugin

```
/plugin update sdlc@om-nexus-official      # Update to latest version
/plugin disable sdlc@om-nexus-official     # Disable without removing
/plugin enable sdlc@om-nexus-official      # Re-enable
/plugin uninstall sdlc@om-nexus-official   # Remove completely
/reload-plugins                             # Apply changes without restarting
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
/sdlc:arch-diagrams     # Generate draw.io diagrams from architecture shard documents

# Epics & Stories
/sdlc:epics-create      # Break requirements into epics and user stories (4-step workflow)
/sdlc:epics-gaps        # Find implementation gaps in epics/stories (6-step workflow)

# Confluence
/sdlc:confluence        # Fetch, edit, push, search, create Confluence pages

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
| `/sdlc:arch-diagrams` | Generate draw.io C4 diagrams from shard doc content (sequential, parallel, or interactive) | — |

### Epics & Stories

| Command | What it does | Steps |
|---------|-------------|-------|
| `/sdlc:epics-create` | Break PRD/Architecture/UX requirements into user-value-focused epics with detailed stories | 4 |
| `/sdlc:epics-gaps` | Analyze epics/stories for implementation gaps — missing infra, dependencies, cross-cutting concerns | 6 |

### Confluence

| Command | What it does |
|---------|-------------|
| `/sdlc:confluence` | Manage Confluence pages — fetch, edit, push, search, create, delete |

The Confluence skill also auto-triggers when you paste a Confluence URL or mention Confluence pages in conversation.

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
│   ├── architecture/           # Architecture phase
│   │   ├── standards/          # Architecture methodology + data
│   │   ├── create/             # 8-step architecture creation
│   │   ├── shard/              # 8-step architecture sharding
│   │   └── diagrams/           # draw.io generation + visual validation references
│   ├── epics/                  # Epics & Stories phase
│   │   ├── create/             # 4-step epic and story creation
│   │   └── gaps-analysis/      # 6-step implementation gaps analysis
│   └── confluence/             # Confluence page management via REST API
├── agents/
│   ├── prd-validator.md        # Isolated PRD validation subagent
│   ├── arch-validator.md       # Isolated architecture validation subagent
│   └── c4-diagram-generator.md # draw.io diagram generation subagent (single file)
├── commands/                   # User entry points (/sdlc:*)
├── hooks/                      # PostToolUse + Stop quality checks
├── scripts/                    # Format validation + push scripts
│   └── push-confluence-page.sh # Push local XHTML back to Confluence (auto-version)
└── .claude-plugin/             # Plugin manifest
```

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

### Confluence (Environment Variables)

The Confluence skill requires these environment variables in your shell profile (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_api_token_here"
export ATLASSIAN_INSTANCE="yourcompany.atlassian.net"  # optional, defaults to onemount.atlassian.net
```

To get an API token: go to [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens), create a token, and add it to your shell profile. Then `source ~/.zshrc` (or restart your terminal).

## Roadmap

- [x] **PRD Workflows** — Create, validate, edit
- [x] **Architecture** — Design, shard, validate, C4 diagram generation
- [x] **Epics & Stories** — Requirements decomposition and implementation gaps analysis
- [x] **Confluence** — Page management, SDLC artifact push/pull
- [ ] **UX Design** — Interaction flows, design specs
- [ ] **Sprint Planning** — Sprint generation and status tracking
- [ ] **Implementation** — Story-driven development workflows
- [ ] **QA & Code Review** — Automated quality gates
- [ ] **Retrospectives** — Post-epic review and lessons learned

## License

See repository license.
