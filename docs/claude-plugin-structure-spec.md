# Claude Code Plugin Structure — Specification

**Version:** 1.0
**Status:** Reference
**Last updated:** 2026-03-09

---

## 1. Overview

A Claude Code plugin is a self-contained package that extends Claude Code with commands, skills, subagents, hooks, and scripts. Plugins are registered via a manifest file and auto-discovered by directory convention.

---

## 2. Plugin Registration

**File:** `plugins/{plugin-name}/.claude-plugin/plugin.json`

```json
{
  "name": "sdlc",
  "description": "Description shown in plugin listings."
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Lowercase, single word. Used as command prefix (`/name:command`) |
| `description` | string | Yes | Human-readable plugin description |

The manifest triggers auto-discovery of all components in subdirectories: `commands/`, `skills/`, `agents/`, `hooks/`, `scripts/`.

---

## 3. Directory Layout

```
plugins/{plugin-name}/
├── .claude-plugin/
│   └── plugin.json              # Registration manifest
├── commands/
│   ├── command-name.md          # → /plugin:command-name
│   └── help.md                  # → /plugin:help
├── skills/
│   ├── skill-name/
│   │   ├── SKILL.md             # Skill definition (entry point)
│   │   └── references/          # Step files, templates, data
│   │       ├── step-01-init.md
│   │       ├── template.md
│   │       └── data.csv
│   └── another-skill/
│       └── SKILL.md
├── agents/
│   └── agent-name.md            # Subagent definition
├── hooks/
│   └── hooks.json               # Hook definitions
└── scripts/
    └── validator.sh             # Executable scripts for hooks
```

---

## 4. Commands

**Location:** `commands/{command-name}.md`
**Invocation:** `/{plugin-name}:{command-name}`

Commands are markdown files with YAML frontmatter. They serve as user-facing entry points that load skills or delegate to subagents.

### Format

```markdown
---
description: "Short description shown in command listings"
---

# Command Title

[Instructions for Claude — what to do when this command is invoked]
```

### Conventions

- Filename → command name: `create-prd.md` → `/sdlc:create-prd`
- Kebab-case filenames
- Commands don't execute code — they're instructional documents that route to skills/agents
- Typically: prompt for preferences → load config → load skill → begin workflow

---

## 5. Skills

**Location:** `skills/{skill-name}/SKILL.md`

Skills hold workflow methodology, reference data, or both. Two patterns:

### 5.1 Reference Skills (auto-loaded)

Provide static data and standards. Loaded automatically when relevant work is detected.

```markdown
---
name: prd-standards
description: "BMAD PRD methodology and quality standards"
---

# PRD Standards

[Methodology, quality criteria, anti-patterns...]
```

Reference files live in `references/` — CSVs, methodology docs, lookup tables.

### 5.2 Action Skills (lazy-loaded)

Facilitate interactive workflows via step-file architecture. Loaded on-demand by commands.

```markdown
---
name: create-prd
description: "12-step interactive PRD creation workflow"
disable-model-invocation: true
---

# PRD Create Workflow

[Role definition, execution rules, workflow overview...]
```

### SKILL.md Frontmatter

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Matches directory name |
| `description` | string | Yes | What the skill does |
| `disable-model-invocation` | boolean | No | `true` = step files control flow, no autonomous execution |

### References Directory

Step files, templates, and data live in `skills/{skill-name}/references/`.

Files are referenced in step frontmatter using `${PLUGIN_ROOT}`:
```yaml
projectTypesCSV: '${PLUGIN_ROOT}/skills/prd-standards/references/project-types.csv'
```

---

## 6. Step-File Architecture

The core pattern for managing long workflows without context explosion.

### 6.1 Principles

1. **Just-in-time loading** — Only the current step is in memory
2. **Sequential enforcement** — Steps execute in strict order, no skipping
3. **State tracking** — Output document frontmatter records progress via `stepsCompleted[]`
4. **Menu-driven transitions** — Every step ends with a menu; Claude waits for user input

### 6.2 Step File Format

```markdown
---
name: 'step-01-init'
description: 'Initialize the workflow'
nextStepFile: 'step-02-discovery.md'
outputFile: '{planning_artifacts}/prd.md'
---

# Step 1: Initialization

**Progress: Step 1 of N** — Next: Discovery

## MANDATORY EXECUTION RULES
[Universal + step-specific rules]

## EXECUTION PROTOCOLS
[When to save, when to show menu]

## CONTEXT BOUNDARIES
[Available context, focus areas]

## Sequence of Instructions
[Numbered steps — execute in exact order]
```

### 6.3 Frontmatter Fields

| Field | Description |
|-------|-------------|
| `name` | Step identifier (e.g., `step-01-init`) |
| `description` | What this step accomplishes |
| `nextStepFile` | Filename of the next step |
| `continueStepFile` | Resume point for interrupted workflows (optional) |
| `outputFile` | Where to save output (template vars allowed) |
| Additional refs | Data files, templates, other step files as needed |

### 6.4 Menu Pattern

```
Present content → Display menu → Wait for input
  [C] Continue → save state, load nextStepFile
  [Other]      → process option, redisplay menu
```

### 6.5 Output Document State

```yaml
---
stepsCompleted: ["step-01-init", "step-02-discovery"]
inputDocuments:
  - "/path/to/brief.md"
workflowType: 'prd'
---
```

The `stepsCompleted` array enables workflow continuation after interruption.

---

## 7. Subagents

**Location:** `agents/{agent-name}.md`

Subagents run in isolated context — they don't pollute the main conversation. Typically constrained to read-only tools.

### Format

```markdown
---
name: prd-validator
description: "Validates PRDs in isolated context"
model: sonnet
tools:
  - Read
  - Grep
  - Glob
skills:
  - prd-standards
  - validate-prd
hooks:
  Stop:
    - hooks:
        - type: prompt
          prompt: >
            Verify completion...
          timeout: 30
---

# Agent Title

[Agent role, responsibilities, instructions...]
```

### Frontmatter Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Agent identifier |
| `description` | string | Agent purpose |
| `model` | string | Claude model: `haiku`, `sonnet`, `opus` |
| `tools` | string[] | Available tools (e.g., `Read`, `Grep`, `Glob`, `Bash`) |
| `skills` | string[] | Skills preloaded into agent context |
| `hooks` | object | Optional stop hook for completion verification |

---

## 8. Hooks

**Location:** `hooks/hooks.json`

Hooks fire automatically on specific events.

### Schema

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "${CLAUDE_PLUGIN_ROOT}/scripts/script.sh",
        "async": true,
        "timeout": 15,
        "statusMessage": "Checking format..."
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "agent",
        "prompt": "Verify task completion...",
        "model": "haiku",
        "timeout": 60
      }]
    }]
  }
}
```

### Hook Events

| Event | Trigger | Common Use |
|-------|---------|-----------|
| `PostToolUse` | After a tool is used | Format validation on file edits |
| `Stop` | Conversation ending | Completeness verification |

### Hook Types

| Type | Description |
|------|-------------|
| `command` | Run a shell script |
| `agent` | Run a lightweight model check |
| `prompt` | Send a verification prompt |

### Hook Properties

| Property | Type | Description |
|----------|------|-------------|
| `matcher` | string | Regex matching tool name (PostToolUse only) |
| `type` | string | `command`, `agent`, or `prompt` |
| `command` | string | Shell command path (type=command) |
| `prompt` | string | Verification prompt (type=agent/prompt) |
| `model` | string | Model for agent hooks |
| `async` | boolean | Non-blocking execution |
| `timeout` | number | Seconds before timeout |
| `statusMessage` | string | UI feedback during execution |

---

## 9. Scripts

**Location:** `scripts/{script-name}.sh`

Shell scripts invoked by hooks. Receive context via environment variables.

### Environment Variables

| Variable | Description |
|----------|-------------|
| `${CLAUDE_TOOL_USE_FILE}` | File path modified by the triggering tool |
| `${CLAUDE_PLUGIN_ROOT}` | Absolute path to plugin root |
| `${PLUGIN_ROOT}` | Alias for `${CLAUDE_PLUGIN_ROOT}` |

### Conventions

- Exit `0` for success (silent pass)
- Exit non-zero for failure (triggers status message)
- Filter early: exit `0` for irrelevant files (e.g., non-PRD files)
- Keep scripts fast — they run on every matching tool use

---

## 10. Configuration

Plugins can read project config from `{project-root}/_bmad/bmm/config.yaml`:

```yaml
project_name: "My Project"
user_name: "Your Name"
output_folder: "./output"
planning_artifacts: "./output/planning"
communication_language: "English"
document_output_language: "English"
user_skill_level: "expert"
```

All fields are optional. Workflows prompt for required values when config is absent.

### Template Variables

Used in step files and templates:
- `{project-root}` — Working directory
- `{planning_artifacts}` — From config
- `{output_folder}` — From config
- `{{project_name}}`, `{{user_name}}`, `{{date}}` — Document template substitution

---

## 11. Context Budget

| Component | Loading | Token Cost |
|-----------|---------|-----------|
| Reference skills | Auto (startup) | ~80 tokens |
| Action skills | Lazy (on command) | 0 at startup |
| Subagents | On demand | 0 at startup |
| Hooks | Event-driven | 0 at startup |
| Commands | Registered at startup | ~50 tokens each |

Step files load one at a time during execution. Reference data loads only when a step requires it.
