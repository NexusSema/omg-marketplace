# Architecture Workflows — Detailed Guide

This document covers the architecture workflows shipped with the SDLC plugin: **Create** and **Validate**. The architecture phase consumes a PRD and produces a comprehensive Architecture Decision Document that ensures AI agents implement consistently.

---

## Table of Contents

- [Core Concepts](#core-concepts)
- [Create Architecture Workflow (8 Steps)](#create-architecture-workflow-8-steps)
- [Validate Architecture Workflow](#validate-architecture-workflow)
- [Quality Standards](#quality-standards)
- [Project Types & Domain Data](#project-types--domain-data)
- [Hooks & Automation](#hooks--automation)
- [Subagent Validation](#subagent-validation)
- [Configuration Reference](#configuration-reference)

---

## Core Concepts

### What is a BMAD Architecture Document?

A BMAD Architecture Decision Document is a dual-audience document:

1. **For humans** — Technical leads, architects, and developers get clear decisions about technology choices, patterns, and project structure they can review and challenge.
2. **For LLMs** — Downstream AI agents (epic breakdown, story creation, implementation, QA) consume the architecture as structured input. Every decision includes versions, rationale, and concrete patterns so agents implement consistently without making ad-hoc technology choices.

The architecture document sits between the PRD and implementation. It translates "what to build" (PRD) into "how to build it" (architecture), providing the guardrails that keep all subsequent development consistent.

### Relationship to PRD

```
PRD (what to build) --> Architecture (how to build it) --> Epics & Stories --> Implementation
```

The architecture workflow requires a PRD as input. It reads the PRD's functional requirements, non-functional requirements, project type, domain complexity, and success criteria to inform every architectural decision.

### Step-File Architecture

The architecture workflow uses the same execution model as PRD workflows:

- **Micro-file design** — Each step is a self-contained instruction file. Claude loads one step at a time, never multiple simultaneously.
- **Just-in-time loading** — Future steps are never pre-read. This prevents skipping ahead and ensures each step gets full attention.
- **Sequential enforcement** — Steps must complete in order. No skipping, no optimization, no reordering.
- **State tracking** — Progress is recorded in the output document's frontmatter (`stepsCompleted` array). If a workflow is interrupted, it can resume from where it left off.
- **Interactive menus** — Every step ends with a menu. Claude halts and waits for your input before proceeding.

---

## Create Architecture Workflow (8 Steps)

**Command:** `/sdlc:arch-create`

Creates a comprehensive Architecture Decision Document from an existing PRD through guided, collaborative conversation. Claude acts as an architectural facilitator — you bring domain expertise and technical preferences.

### Step Breakdown

| Step | Name | What Happens |
|------|------|-------------|
| **1** | **Initialization** | Detects workflow state (resume or fresh start). Discovers the PRD and any existing architecture work. Loads project context from PRD frontmatter. Creates architecture document from scratch or resumes existing. |
| **1b** | **Continue** *(conditional)* | If an incomplete architecture document exists, resumes from the last completed step. Reads the `stepsCompleted` array and routes to the next pending step. |
| **2** | **Context Analysis** | Deep-reads the PRD. Extracts project type, domain, complexity, scale indicators, and integration patterns. Builds a structured context summary that informs all subsequent decisions. Writes the Project Context Analysis section. |
| **3** | **Starter Template Evaluation** | Loads `project-types.csv` to identify relevant starter templates and frameworks. Uses WebSearch to verify current versions and compatibility. Evaluates candidates against PRD requirements. Recommends a starting point with rationale. |
| **4** | **Core Architectural Decisions** | The heart of the workflow. Works through technology decisions systematically: frontend framework, backend runtime, database, authentication, hosting, CI/CD, and more. Each decision uses the architecture-decision-template format (choice, version, rationale, alternatives, affected components). |
| **5** | **Implementation Patterns** | Defines concrete coding patterns for the chosen stack: project structure conventions, naming standards (files, functions, variables, database), code organization patterns, error handling, state management, API design. Every pattern includes good and bad examples. |
| **6** | **Project Structure** | Generates the complete project directory tree — technology-specific, not generic. Includes every expected directory, key files, and brief descriptions. Also covers environment configuration and key configuration files. |
| **7** | **Architecture Validation** | Self-validates the architecture document: checks decision coherence (do all choices work together?), requirement coverage (does every PRD requirement have architectural support?), and implementation readiness (can a developer start building from this?). |
| **8** | **Completion** | Marks workflow as done. Offers validation workflow or suggests next SDLC steps (epic breakdown, story creation). |

### Output

A complete architecture document at `{planning_artifacts}/architecture.md` with:

- Frontmatter tracking `stepsCompleted`, `prdSource`, `classification`, and workflow metadata
- All 6 required sections populated
- Every technology decision with version numbers, rationale, and alternatives considered
- Concrete implementation patterns with examples
- Complete project directory structure
- Self-validation results

### Architecture Decision Format

Every technology decision follows this structured template:

```markdown
### [Decision Area]

- **Choice:** [Technology/Pattern Name]
- **Version:** [Specific version number]
- **Rationale:** [Why this choice fits the project requirements]
- **Alternatives Considered:** [What else was evaluated and why it was rejected]
- **Affected Components:** [Which parts of the system this decision impacts]
```

This format ensures downstream AI agents can parse decisions unambiguously and implement consistently.

---

## Validate Architecture Workflow

**Command:** `/sdlc:arch-validate`

Runs a comprehensive quality audit against an existing architecture document. Can execute interactively or delegate to an isolated subagent (recommended).

### Execution Modes

When you run `/sdlc:arch-validate`, you're asked to choose:

- **Subagent (recommended)** — Delegates to the `arch-validator` subagent which runs all validation checks in isolation, then returns a structured report. Keeps your main conversation clean.
- **Interactive** — Runs each validation check directly in your conversation. You see each check's results and can interact during the process.

### Validation Checks

| Check | What It Validates |
|-------|------------------|
| **Section Completeness** | All 6 required sections present and substantive (not just headers) |
| **Decision Completeness** | Every decision has version, rationale, alternatives, and affected components |
| **Pattern Specificity** | All patterns include concrete good and bad examples, not abstract descriptions |
| **Structure Concreteness** | Project directory tree is complete and technology-specific, not generic placeholders |
| **Coherence** | All decisions are compatible — no contradictions (e.g., choosing React but defining Angular patterns) |
| **Coverage** | Every PRD functional requirement has architectural support |
| **Naming Consistency** | Naming conventions are consistent across all pattern categories |

### Validation Report Structure

The output report includes:

- **Overall Status** — Pass, Warning, or Critical
- **Summary** — One-paragraph overview of architecture document quality
- **Findings by Check** — Each check's status, severity, specific issues found, recommendations
- **Statistics** — Total findings by severity (critical, warning, info)
- **Priority Fixes** — Top 3-5 most impactful issues to address first

---

## Quality Standards

### Required Architecture Sections

Every BMAD Architecture Document must include these level-2 markdown headers:

1. `## Project Context Analysis` — PRD-derived context: project type, domain, scale, complexity, integration patterns
2. `## Starter Template Evaluation` — Framework/template evaluation with version verification
3. `## Core Architectural Decisions` — All technology decisions in structured format
4. `## Implementation Patterns` — Concrete coding patterns with examples
5. `## Project Structure` — Complete directory tree with file descriptions
6. `## Architecture Validation Results` — Self-validation findings and coverage analysis

### Decision Quality Standards

**Good decision:**
```
### Database
- Choice: PostgreSQL
- Version: 16.x
- Rationale: Strong JSON support for flexible schemas, proven at scale for SaaS workloads, excellent TypeScript integration via Prisma ORM
- Alternatives Considered: MongoDB (rejected — relational integrity needed for multi-tenant data), MySQL (rejected — weaker JSON support)
- Affected Components: Data layer, migrations, backup strategy, connection pooling
```

**Bad decision:**
```
### Database
Use PostgreSQL because it's popular and well-supported.
```

### Pattern Quality Standards

**Good pattern:**
```
### File Naming
- Components: PascalCase (e.g., UserProfile.tsx, DashboardLayout.tsx)
- Utilities: camelCase (e.g., formatDate.ts, parseApiResponse.ts)
- Constants: SCREAMING_SNAKE_CASE (e.g., MAX_RETRY_COUNT, API_BASE_URL)
- Test files: [name].test.ts (e.g., UserProfile.test.tsx)
```

**Bad pattern:**
```
### File Naming
Follow standard naming conventions for the chosen framework.
```

### Anti-Patterns Detected by Validation

| Anti-Pattern | Example | Fix |
|-------------|---------|-----|
| Missing versions | "Use React" | Add version: "React 19.x" |
| No rationale | "Database: PostgreSQL" | Add why: project-specific reasoning |
| Generic structure | "src/, tests/, docs/" | Technology-specific: "app/routes/, prisma/migrations/" |
| Abstract patterns | "Follow best practices" | Concrete examples with good/bad code |
| Missing alternatives | Just the chosen option | Show what was considered and why it was rejected |
| Contradictory decisions | React frontend + Angular patterns | Ensure all patterns match chosen technologies |

---

## Project Types & Domain Data

### Project Types

The architecture workflow loads `project-types.csv` to tailor starter template evaluation and architectural decisions. The same 6 project types used in PRD classification drive architecture-specific guidance:

| Type | Architecture Focus |
|------|-------------------|
| `web_app` | Frontend framework, SSR/CSR strategy, CDN, browser compatibility |
| `api_backend` | API framework, database, auth, rate limiting, documentation |
| `mobile_app` | Native vs cross-platform, offline strategy, push notifications |
| `saas_b2b` | Multi-tenancy, RBAC, subscription billing, integration APIs |
| `developer_tool` | Language support matrix, plugin architecture, CLI framework |
| `cli_tool` | Argument parsing, output formats, config management |

### Domain Complexity

The `domain-complexity.csv` data influences architecture decisions for regulated industries:

| Domain | Architecture Impact |
|--------|-------------------|
| Healthcare | HIPAA-compliant infrastructure, audit logging, data encryption at rest |
| Fintech | PCI-DSS network segmentation, transaction integrity, fraud detection hooks |
| GovTech | FedRAMP-authorized cloud services, Section 508 accessibility patterns |
| EdTech | COPPA/FERPA data handling, content moderation, parental controls |

---

## Hooks & Automation

### PostToolUse Hook — Architecture Format Check

**Trigger:** Every time Claude uses the `Edit` or `Write` tool

**Behavior:**
1. Checks if the modified file matches `*[Aa]rchitect*.md` pattern
2. If not an architecture file, exits silently — zero overhead
3. If it is an architecture file, scans for the 6 required section headers
4. Reports any missing sections as informational warnings
5. Runs asynchronously — does not block Claude's work

**Script:** `scripts/validate-arch-format.sh`

### Stop Hook — Completeness Verification

**Trigger:** When Claude stops working on a task

**Behavior:**
1. Uses a lightweight Haiku model to check task completeness
2. Verifies: all requested steps executed, output files (PRD or architecture documents) exist and are non-empty, no TODO/FIXME markers
3. Returns pass/fail with reason

---

## Subagent Validation

The `arch-validator` subagent runs architecture validation in an isolated context:

- **Model:** Sonnet (cost-effective for systematic checking)
- **Tools:** Read, Grep, Glob, WebSearch (read-only analysis plus version verification)
- **Skills:** Preloads `architecture/standards`
- **Own Stop hook:** Verifies all validation checks completed and report has proper status

**When to use it:** The subagent is the default choice when running `/sdlc:arch-validate`. It keeps your main conversation free of detailed validation output. The structured report is returned cleanly at the end.

**When to go interactive:** Choose interactive mode when you want to watch each validation check happen, ask questions during the process, or challenge specific findings in real time.

### Differences from PRD Validator

| Aspect | PRD Validator | Architecture Validator |
|--------|--------------|----------------------|
| Tools | Read, Grep, Glob | Read, Grep, Glob, **WebSearch** |
| Skills | prd/standards, prd/validate | architecture/standards |
| Checks | 13 sequential steps | 7 validation dimensions |
| Focus | Content quality, traceability | Decision completeness, coherence |

The architecture validator has WebSearch access because it may need to verify technology versions and compatibility claims in the document.

---

## Configuration Reference

The architecture workflow reads the same `_bmad/bmm/config.yaml` as PRD workflows:

```yaml
# Project identity
project_name: "My Project"
user_name: "Your Name"

# Output paths
output_folder: "./output"
planning_artifacts: "./output/planning"

# Language settings
communication_language: "English"
document_output_language: "English"

# User context
user_skill_level: "expert"
```

| Field | Default | Architecture Usage |
|-------|---------|-------------------|
| `project_name` | *(prompted)* | Document headers |
| `planning_artifacts` | `./output/planning` | Where `architecture.md` is saved |
| `communication_language` | English | Claude's spoken language during workflow |
| `document_output_language` | English | Language for architecture document content |

### Environment Variables Used in Step Files

| Variable | Source | Used For |
|----------|--------|----------|
| `${PLUGIN_ROOT}` | Plugin system | Resolving skill reference file paths (e.g., CSV data, templates) |
| `${CLAUDE_PLUGIN_ROOT}` | Plugin system | Resolving script paths in commands |
| `{project-root}` | Working directory | Project-relative paths (config, PRD location) |
| `{planning_artifacts}` | Config | Architecture document output location |
