# SDLC Plugin — Technical Specification

**Version:** 2.0
**Status:** Current
**Last updated:** 2026-03-09

---

## 1. Overview

The SDLC plugin provides structured, interactive SDLC workflows for Claude Code. Built on the BMAD-METHOD, it packages product planning and architecture methodology into composable skills, subagents, hooks, and scripts.

**Scope (v2.0):** PRD creation, validation, and editing. Architecture decision creation and validation.

---

## 2. Plugin Manifest

**Path:** `plugins/sdlc/.claude-plugin/plugin.json`

```json
{
  "name": "sdlc",
  "description": "Interactive SDLC workflows — PRD creation/validation/editing and architecture design using BMAD methodology with skills, subagents, hooks, and scripts."
}
```

The manifest registers the plugin with Claude Code and enables discovery of all components under `plugins/sdlc/`.

---

## 3. Architecture

```
plugins/sdlc/
├── .claude-plugin/plugin.json       # Plugin manifest
├── commands/                        # User-facing entry points
│   ├── prd-create.md
│   ├── prd-validate.md
│   ├── prd-edit.md
│   ├── arch-create.md
│   ├── arch-validate.md
│   └── help.md
├── skills/                          # Skills grouped by SDLC phase
│   ├── prd/                         # PRD phase
│   │   ├── standards/               # Auto-loaded BMAD reference data
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       ├── prd-purpose.md
│   │   │       ├── project-types.csv
│   │   │       └── domain-complexity.csv
│   │   ├── create/                  # 12-step creation workflow
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       ├── step-01-init.md ... step-12-complete.md
│   │   │       └── prd-template.md
│   │   ├── validate/                # 13-step validation workflow
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       └── step-v-01-discovery.md ... step-v-13-report-complete.md
│   │   └── edit/                    # 5-step edit workflow
│   │       ├── SKILL.md
│   │       └── references/
│   │           └── step-e-01-discovery.md ... step-e-04-complete.md
│   └── architecture/                # Architecture phase
│       ├── standards/               # Architecture methodology + data
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── arch-purpose.md
│       │       ├── project-types.csv
│       │       └── domain-complexity.csv
│       └── create/                  # 8-step creation workflow
│           ├── SKILL.md
│           └── references/
│               ├── step-01-init.md ... step-08-complete.md
│               ├── step-01b-continue.md
│               └── architecture-decision-template.md
├── agents/
│   ├── prd-validator.md             # Isolated PRD validation subagent
│   └── arch-validator.md            # Isolated architecture validation subagent
├── hooks/
│   └── hooks.json                   # PostToolUse + Stop hooks
└── scripts/
    ├── validate-prd-format.sh       # Shell-based PRD format checker
    └── validate-arch-format.sh      # Shell-based architecture format checker
```

**Total file count:** ~69 files.

### 3.1 Component Interaction

```
User ──> Command ──> Skill ──> Step Files (loaded one at a time)
                       │
                       ├──> Standards skill (reference data, auto-loaded)
                       │    ├── prd/standards
                       │    └── architecture/standards
                       │
                       └──> Subagent (isolated validation, optional)
                            ├── prd-validator
                            └── arch-validator

Hooks ──> PostToolUse: format validation on every PRD or architecture edit
      ──> Stop: completeness verification before session ends
```

### 3.2 Data Flow

```
PRD Phase:
  Input:  _bmad/bmm/config.yaml, product briefs, research docs
  Data:   project-types.csv, domain-complexity.csv, prd-purpose.md
  Output: {planning_artifacts}/prd.md, validation-report-*.md

Architecture Phase:
  Input:  _bmad/bmm/config.yaml, {planning_artifacts}/prd.md
  Data:   project-types.csv, domain-complexity.csv, arch-purpose.md, architecture-decision-template.md
  Output: {planning_artifacts}/architecture.md, validation-report-*.md
```

---

## 4. Commands

Six commands are exposed under the `sdlc:` namespace.

### 4.1 `/sdlc:prd-create`

**File:** `commands/prd-create.md`
**Purpose:** Launch the 12-step interactive PRD creation workflow.

**Behavior:**
1. Prompt for language preferences (communication + document output).
2. Load config from `{project-root}/_bmad/bmm/config.yaml`.
3. Load the `prd/create` skill.
4. Begin step execution at `step-01-init.md`.

**Output:** `{planning_artifacts}/prd.md`

### 4.2 `/sdlc:prd-validate`

**File:** `commands/prd-validate.md`
**Purpose:** Validate an existing PRD against BMAD standards.

**Behavior:**
1. Prompt for language preferences.
2. Load config.
3. Present mode selection:
   - **[A] Subagent (recommended):** Delegates to `prd-validator` agent in isolated context.
   - **[B] Interactive:** Loads `prd/validate` skill inline.
4. Execute 13 validation checks.

**Output:** Structured validation report with Pass/Warning/Critical status.

### 4.3 `/sdlc:prd-edit`

**File:** `commands/prd-edit.md`
**Purpose:** Edit and improve an existing PRD.

**Behavior:**
1. Prompt for language preferences.
2. Load config.
3. Load the `prd/edit` skill.
4. Prompt user for PRD file path.
5. Begin step execution at `step-e-01-discovery.md`.

**Output:** Updated PRD with improvements applied.

### 4.4 `/sdlc:arch-create`

**File:** `commands/arch-create.md`
**Purpose:** Launch the 8-step interactive architecture creation workflow.

**Behavior:**
1. Prompt for language preferences (communication + document output).
2. Load config from `{project-root}/_bmad/bmm/config.yaml`.
3. Load the `architecture/create` skill.
4. Begin step execution at `step-01-init.md`.

**Input:** Requires a PRD (discovered automatically or prompted).
**Output:** `{planning_artifacts}/architecture.md`

### 4.5 `/sdlc:arch-validate`

**File:** `commands/arch-validate.md`
**Purpose:** Validate an existing architecture document against BMAD standards.

**Behavior:**
1. Prompt for language preferences.
2. Load config.
3. Present mode selection:
   - **[A] Subagent (recommended):** Delegates to `arch-validator` agent in isolated context.
   - **[B] Interactive:** Loads `architecture/standards` skill and runs checks inline.
4. Execute validation checks (section completeness, decision quality, pattern specificity, coherence, coverage).

**Output:** Structured validation report with Pass/Warning/Critical status.

### 4.6 `/sdlc:help`

**File:** `commands/help.md`
**Purpose:** Display plugin documentation, list commands, and explain architecture.

---

## 5. Skills

### 5.1 `prd/standards` — Reference Skill

**File:** `skills/prd/standards/SKILL.md`
**Loading:** Auto-loaded when PRD work is detected.
**Purpose:** Provides BMAD methodology, quality standards, and classification data.

**Reference files:**

| File | Format | Content |
|------|--------|---------|
| `prd-purpose.md` | Markdown | Full BMAD PRD methodology — dual-audience philosophy, FR/NFR standards, anti-patterns, downstream impact |
| `project-types.csv` | CSV | 11 project types with fields: `detection_signals`, `key_questions`, `required_sections`, `skip_sections`, `innovation_signals` |
| `domain-complexity.csv` | CSV | 15+ domains with fields: `domain`, `signals`, `complexity`, `key_concerns`, `required_knowledge`, `special_sections` |

**Quality standards enforced:**
- **Information density:** No filler, padding, or verbose patterns.
- **SMART requirements:** Specific, Measurable, Attainable, Relevant, Traceable.
- **Traceability chain:** Vision → Success Criteria → User Journeys → FRs.
- **No anti-patterns:** No subjective adjectives, implementation leakage, or vague quantifiers.

### 5.2 `prd/create` — 12-Step Creation Workflow

**File:** `skills/prd/create/SKILL.md`
**Loading:** On-demand via `/sdlc:prd-create`.
**Config:** `disable-model-invocation: true` (step files control flow).

**Steps:**

| # | File | Name | Type | Description |
|---|------|------|------|-------------|
| 1 | `step-01-init.md` | Initialization | Required | Detect state, discover inputs, create PRD from template |
| 1b | `step-01b-continue.md` | Continue | Conditional | Resume interrupted workflow from frontmatter state |
| 2 | `step-02-discovery.md` | Discovery | Required | Classify project type, domain, complexity |
| 2b | `step-02b-vision.md` | Vision | Required | Explore product vision through conversation |
| 2c | `step-02c-executive-summary.md` | Executive Summary | Required | Draft executive summary collaboratively |
| 3 | `step-03-success.md` | Success Criteria | Required | Define measurable SMART outcomes |
| 4 | `step-04-journeys.md` | User Journeys | Required | Map user journeys for all user types |
| 5 | `step-05-domain.md` | Domain Requirements | Optional | Industry-specific compliance (medium/high complexity only) |
| 6 | `step-06-innovation.md` | Innovation | Optional | Competitive differentiation analysis |
| 7 | `step-07-project-type.md` | Project-Type Deep Dive | Required | CSV-driven platform-specific requirements |
| 8 | `step-08-scoping.md` | Scoping | Required | MVP/Growth/Vision phase boundaries |
| 9 | `step-09-functional.md` | Functional Requirements | Required | Synthesize FRs from all discovery |
| 10 | `step-10-nonfunctional.md` | Non-Functional Requirements | Required | Define quality attributes (NFRs) |
| 11 | `step-11-polish.md` | Polish | Required | Full-document review for density and coherence |
| 12 | `step-12-complete.md` | Complete | Required | Mark done, offer next steps |

**Template:** `prd-template.md` — Minimal frontmatter with `stepsCompleted`, `inputDocuments`, `workflowType` fields.

**Interaction model:**
- **Facilitator mode** (discovery steps): Ask questions, listen, validate understanding.
- **Generator mode** (synthesis steps): Draft content, present for review, refine, append when approved.
- Every step ends with a menu; Claude waits for user input before advancing.

### 5.3 `prd/validate` — 13-Step Validation Workflow

**File:** `skills/prd/validate/SKILL.md`
**Loading:** On-demand via `/sdlc:prd-validate` or preloaded by `prd-validator` agent.
**Config:** `disable-model-invocation: true`.

**Steps:**

| # | File | Name | Checks |
|---|------|------|--------|
| V-1 | `step-v-01-discovery.md` | Discovery | Find PRD, load references, init report |
| V-2 | `step-v-02-format-detection.md` | Format Detection | BMAD vs legacy structure |
| V-2b | `step-v-02b-parity-check.md` | Parity Check | Input docs match PRD content |
| V-3 | `step-v-03-density-validation.md` | Density | Filler, verbosity, padding |
| V-4 | `step-v-04-brief-coverage-validation.md` | Brief Coverage | Product brief themes represented |
| V-5 | `step-v-05-measurability-validation.md` | Measurability | Subjective language, vague quantifiers |
| V-6 | `step-v-06-traceability-validation.md` | Traceability | Chain completeness (Vision → FRs) |
| V-7 | `step-v-07-implementation-leakage-validation.md` | Implementation Leakage | Tech names, schemas, code patterns |
| V-8 | `step-v-08-domain-compliance-validation.md` | Domain Compliance | Industry-specific requirements |
| V-9 | `step-v-09-project-type-validation.md` | Project-Type | Platform-specific sections |
| V-10 | `step-v-10-smart-validation.md` | SMART | Per-requirement quality scoring |
| V-11 | `step-v-11-holistic-quality-validation.md` | Holistic Quality | Overall document quality (1-5 rating) |
| V-12 | `step-v-12-completeness-validation.md` | Completeness | All required sections present and substantive |
| V-13 | `step-v-13-report-complete.md` | Report Complete | Compile findings, assign overall status |

**Report output structure:**
```
Overall Status: Pass | Warning | Critical
Summary: (one paragraph)
Findings by Step: [{step, status, severity, findings, recommendations}]
Statistics: {critical: N, warning: N, info: N}
Priority Fixes: [top 3-5 issues]
```

### 5.4 `prd/edit` — 5-Step Edit Workflow

**File:** `skills/prd/edit/SKILL.md`
**Loading:** On-demand via `/sdlc:prd-edit`.
**Config:** `disable-model-invocation: true`.

**Steps:**

| # | File | Name | Description |
|---|------|------|-------------|
| E-1 | `step-e-01-discovery.md` | Discovery | Get PRD path, detect format, find validation reports |
| E-1b | `step-e-01b-legacy-conversion.md` | Legacy Conversion | Conditional: convert non-BMAD PRDs to BMAD format |
| E-2 | `step-e-02-review.md` | Review | Analyze PRD, produce ordered change plan |
| E-3 | `step-e-03-edit.md` | Edit | Apply approved changes systematically |
| E-4 | `step-e-04-complete.md` | Complete | Confirm edits, offer validation |

**Format detection thresholds:**

| BMAD Headers Found | Classification | Routing |
|-------------------|---------------|---------|
| 5-6 | BMAD Standard | → E-2 Review |
| 3-4 | BMAD Variant | → E-2 Review |
| 0-2 | Legacy | → E-1b Conversion (optional) |

### 5.5 `architecture/standards` — Reference Skill

**File:** `skills/architecture/standards/SKILL.md`
**Loading:** Auto-loaded when architecture work is detected.
**Purpose:** Provides architecture methodology, required sections, quality standards, and classification data.

**Reference files:**

| File | Format | Content |
|------|--------|---------|
| `arch-purpose.md` | Markdown | Architecture methodology — why architecture documents exist, what they must contain, how they serve downstream agents |
| `project-types.csv` | CSV | 6 project types with starter template guidance, framework recommendations |
| `domain-complexity.csv` | CSV | 12 domains with complexity levels, compliance concerns, architectural implications |

**Required architecture sections enforced:**
1. `## Project Context Analysis`
2. `## Starter Template Evaluation`
3. `## Core Architectural Decisions`
4. `## Implementation Patterns`
5. `## Project Structure`
6. `## Architecture Validation Results`

### 5.6 `architecture/create` — 8-Step Creation Workflow

**File:** `skills/architecture/create/SKILL.md`
**Loading:** On-demand via `/sdlc:arch-create`.
**Config:** `disable-model-invocation: true` (step files control flow).

**Steps:**

| # | File | Name | Type | Description |
|---|------|------|------|-------------|
| 1 | `step-01-init.md` | Initialization | Required | Detect state, discover PRD, load context |
| 1b | `step-01b-continue.md` | Continue | Conditional | Resume interrupted workflow from frontmatter state |
| 2 | `step-02-context.md` | Context Analysis | Required | Deep-read PRD, extract context, write analysis section |
| 3 | `step-03-starter.md` | Starter Template | Required | Evaluate frameworks/templates, verify versions via web search |
| 4 | `step-04-decisions.md` | Core Decisions | Required | Systematic technology decisions with structured format |
| 5 | `step-05-patterns.md` | Implementation Patterns | Required | Concrete coding patterns with examples |
| 6 | `step-06-structure.md` | Project Structure | Required | Complete directory tree, config files |
| 7 | `step-07-validation.md` | Validation | Required | Self-validate coherence, coverage, readiness |
| 8 | `step-08-complete.md` | Complete | Required | Mark done, offer next steps |

**Template:** `architecture-decision-template.md` — Structured format for each technology decision (choice, version, rationale, alternatives, affected components).

**Interaction model:**
- **Facilitator mode** (context and evaluation steps): Analyze PRD, present findings, get user confirmation.
- **Collaborative mode** (decision steps): Propose options, discuss trade-offs, reach agreement on each decision.
- **Generator mode** (patterns and structure steps): Draft concrete content, present for review, refine.
- Every step ends with a menu; Claude waits for user input before advancing.

---

## 6. Subagents

### 6.1 `prd-validator`

**File:** `agents/prd-validator.md`
**Model:** Sonnet
**Tools:** Read, Grep, Glob (read-only)
**Preloaded skills:** `prd/standards`, `prd/validate`

**Purpose:** Execute the 13-step validation workflow in an isolated context, returning a structured report without polluting the main conversation.

**Stop hook:** Verifies all 13 steps executed, report has overall status, findings include severity and recommendations.

**Invocation:** From `/sdlc:prd-validate` when user selects subagent mode.

### 6.2 `arch-validator`

**File:** `agents/arch-validator.md`
**Model:** Sonnet
**Tools:** Read, Grep, Glob, WebSearch (read-only + version verification)
**Preloaded skills:** `architecture/standards`

**Purpose:** Execute architecture validation checks in an isolated context, returning a structured report without polluting the main conversation.

**Validation dimensions:**
1. Section completeness — all 6 required sections present and substantive
2. Decision completeness — versions, rationale, alternatives, affected components
3. Pattern specificity — concrete examples (good and bad)
4. Structure concreteness — complete technology-specific directory tree
5. Coherence — no contradictions between decisions
6. Coverage — every PRD requirement architecturally supported
7. Naming consistency — conventions consistent across all categories

**Stop hook:** Verifies all checks executed, report has overall status, findings include severity and recommendations.

**Invocation:** From `/sdlc:arch-validate` when user selects subagent mode.

---

## 7. Hooks

**File:** `hooks/hooks.json`

### 7.1 PostToolUse — PRD Format Check

| Property | Value |
|----------|-------|
| Trigger | `Edit` or `Write` tool use |
| Type | Shell command |
| Script | `scripts/validate-prd-format.sh` |
| Async | `true` |
| Timeout | 15s |

**Script behavior:**
1. Read modified file path from `$CLAUDE_TOOL_USE_FILE`.
2. Exit silently if file doesn't match `*prd*.md`.
3. Check for 6 required BMAD PRD section headers.
4. Report missing sections as warnings.

### 7.2 PostToolUse — Architecture Format Check

| Property | Value |
|----------|-------|
| Trigger | `Edit` or `Write` tool use |
| Type | Shell command |
| Script | `scripts/validate-arch-format.sh` |
| Async | `true` |
| Timeout | 15s |

**Script behavior:**
1. Read modified file path from `$CLAUDE_TOOL_USE_FILE`.
2. Exit silently if file doesn't match `*[Aa]rchitect*.md`.
3. Check for 6 required architecture section headers.
4. Report missing sections as informational warnings.

### 7.3 Stop — Completeness Verification

| Property | Value |
|----------|-------|
| Trigger | Conversation stop |
| Type | Agent |
| Model | Haiku |
| Timeout | 60s |

**Checks:**
1. All requested steps executed.
2. Output files (PRD or architecture documents) exist and are non-empty.
3. No `TODO`/`FIXME` markers in modified PRD or architecture files.

**Returns:** `{"ok": true}` or `{"ok": false, "reason": "..."}`.

---

## 8. Step-File Execution Model

All workflows share a common step-file architecture.

### 8.1 Step File Structure

```yaml
---
name: 'step-XX-name'
description: 'Brief description'
nextStepFile: 'step-XX+1-name.md'
outputFile: '{planning_artifacts}/prd.md'
---
```

Each step file contains:
- **Mandatory Execution Rules** — Universal rules, role reinforcement, step-specific constraints.
- **Execution Protocols** — When to save, when to present menus.
- **Context Boundaries** — What's available, what to focus on.
- **Sequence of Instructions** — Ordered execution steps.

### 8.2 Execution Rules

1. **Just-in-time loading:** Only the current step is in memory. No look-ahead.
2. **Sequential enforcement:** Steps execute in strict order. No skipping or reordering.
3. **State tracking:** `stepsCompleted` array in document frontmatter records progress.
4. **Continuation:** Interrupted workflows resume from the last completed step.
5. **Menu pattern:** Every step ends with a menu. Claude halts until user responds.

### 8.3 Menu Flow

```
Present content for review
  ↓
Display menu options (always includes [C] Continue)
  ↓
Wait for user input
  ↓
[C] → Save state, read next step file, follow it
[Other] → Process option, redisplay menu
```

---

## 9. Configuration

**File:** `{project-root}/_bmad/bmm/config.yaml`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `project_name` | string | *(prompted)* | Document headers and templates |
| `user_name` | string | *(prompted)* | Author attribution |
| `output_folder` | path | `./output` | Base output directory |
| `planning_artifacts` | path | `./output/planning` | PRD and report output location |
| `product_knowledge` | path | `./docs` | Existing project documentation |
| `communication_language` | string | `English` | Language Claude speaks to user |
| `document_output_language` | string | `English` | Language for generated documents |
| `user_skill_level` | enum | `expert` | `expert` / `intermediate` / `beginner` |

All fields are optional. Commands prompt for language preferences at startup (overriding config values). Without a config file, workflows prompt for required values.

### 9.1 Environment Variables

| Variable | Source | Usage |
|----------|--------|-------|
| `${PLUGIN_ROOT}` | Plugin system | Resolve skill reference file paths |
| `${CLAUDE_PLUGIN_ROOT}` | Plugin system | Resolve script paths in hooks |
| `${CLAUDE_TOOL_USE_FILE}` | Hook system | Modified file path in PostToolUse hooks |
| `{project-root}` | Working directory | Project-relative paths |
| `{planning_artifacts}` | Config | PRD output location |

---

## 10. Context Budget

| Component | Count | Startup Tokens | Loading |
|-----------|-------|---------------|---------|
| Reference skills (`prd/standards`, `architecture/standards`) | 2 | ~160 | Auto |
| Action skills (prd/create, prd/validate, prd/edit, architecture/create) | 4 | 0 | Lazy (on command invocation) |
| Subagents (prd-validator, arch-validator) | 2 | 0 | On demand |
| Hooks (2 PostToolUse + 1 Stop) | 3 | 0 | Event-driven |
| Commands | 6 | ~300 | Registered at startup |
| **Total** | **17** | **~460 (~0.23% of 200K)** | — |

Step files are loaded one at a time during workflow execution. Reference data (CSVs, methodology docs) is loaded only when the relevant step requires it.

---

## 11. Project Classification Data

### 11.1 Project Types (11)

`api_backend`, `mobile_app`, `saas_b2b`, `developer_tool`, `cli_tool`, `web_app`, `game`, `desktop_app`, `iot_embedded`, `blockchain_web3`

Each type defines:
- **Detection signals** — Keywords that trigger classification.
- **Key questions** — Type-specific discovery questions for step 7.
- **Required sections** — Additional PRD sections to include.
- **Skip sections** — Sections not applicable to this type.
- **Innovation signals** — Type-specific innovation indicators for step 6.

### 11.2 Domain Complexity (15+ domains)

`healthcare`, `fintech`, `govtech`, `edtech`, `aerospace`, `automotive`, `scientific`, `legaltech`, `insuretech`, `energy`, `process_control`, `building_automation`, `gaming`, `general`

Each domain defines:
- **Signals** — Keywords that trigger domain detection.
- **Complexity** — `low`, `medium`, or `high`.
- **Key concerns** — Domain-specific quality and compliance issues.
- **Required knowledge** — Regulations and standards (e.g., HIPAA, PCI-DSS).
- **Special sections** — Additional PRD sections for compliance.

---

## 12. Quality Standards Summary

### 12.0 Required Architecture Sections

1. `## Project Context Analysis`
2. `## Starter Template Evaluation`
3. `## Core Architectural Decisions`
4. `## Implementation Patterns`
5. `## Project Structure`
6. `## Architecture Validation Results`

### 12.1 Required PRD Sections

1. `## Executive Summary`
2. `## Success Criteria`
3. `## Product Scope`
4. `## User Journeys`
5. `## Functional Requirements`
6. `## Non-Functional Requirements`

Optional (added by classification):
- `## Domain Requirements`
- `## Innovation Analysis`
- `## Project-Type Requirements`

### 12.2 Anti-Patterns Detected

| Category | Example | Resolution |
|----------|---------|------------|
| Subjective adjectives | "easy to use", "intuitive" | Add metrics: "completes in under 3 clicks" |
| Implementation leakage | "uses React and PostgreSQL" | State capability: "renders interactive dashboard" |
| Vague quantifiers | "supports multiple users" | Be specific: "supports up to 100 concurrent users" |
| Missing test criteria | "provides notifications" | Add measurement: "sends email within 30s of trigger" |
| Verbose patterns | "The system will allow users to..." | Condense: "Users can..." |
| Filler phrases | "It is important to note that..." | State the fact directly |

### 12.3 Architecture Anti-Patterns Detected

| Category | Example | Resolution |
|----------|---------|------------|
| Missing versions | "Use React" | Add version: "React 19.x" |
| No rationale | "Database: PostgreSQL" | Add project-specific reasoning |
| Generic structure | "src/, tests/, docs/" | Technology-specific: "app/routes/, prisma/migrations/" |
| Abstract patterns | "Follow best practices" | Concrete examples with good/bad code |
| Missing alternatives | Just the chosen option | Show what was considered and why rejected |
| Contradictory decisions | React frontend + Angular patterns | Ensure all patterns match chosen technologies |

### 12.4 Traceability Chain

```
Vision → Success Criteria → User Journeys → Functional Requirements → Architecture Decisions → User Stories
```

Every FR must trace back to a user journey. Every journey must connect to a success criterion. Every architecture decision must support PRD requirements. The validation workflows check these chains at step V-6 (PRD) and architecture validation (coverage check).
