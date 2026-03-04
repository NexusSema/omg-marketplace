# PRD Workflows — Detailed Guide

This document covers the three PRD workflows shipped with the SDLC plugin: **Create**, **Validate**, and **Edit**. All three follow the BMAD-METHOD's approach to producing high-quality, dual-audience Product Requirements Documents.

---

## Table of Contents

- [Core Concepts](#core-concepts)
- [Create PRD Workflow (12 Steps)](#create-prd-workflow-12-steps)
- [Validate PRD Workflow (13 Steps)](#validate-prd-workflow-13-steps)
- [Edit PRD Workflow (5 Steps)](#edit-prd-workflow-5-steps)
- [Quality Standards](#quality-standards)
- [Project Types & Domain Detection](#project-types--domain-detection)
- [Hooks & Automation](#hooks--automation)
- [Subagent Validation](#subagent-validation)
- [Configuration Reference](#configuration-reference)

---

## Core Concepts

### What is a BMAD PRD?

A BMAD PRD is a dual-audience document:

1. **For humans** — Product managers, executives, and stakeholders get a clear vision, strategy, and requirement set they can review and approve.
2. **For LLMs** — Downstream AI agents (UX design, architecture, epic breakdown, development) consume the PRD as structured input. Every requirement is precise, measurable, and traceable.

The PRD sits at the top of the development funnel. Everything downstream — UX specs, architecture decisions, user stories, code — traces back to what's written here.

### Step-File Architecture

All three workflows use the same execution model:

- **Micro-file design** — Each step is a self-contained instruction file. Claude loads one step at a time, never multiple simultaneously.
- **Just-in-time loading** — Future steps are never pre-read. This prevents skipping ahead and ensures each step gets full attention.
- **Sequential enforcement** — Steps must complete in order. No skipping, no optimization, no reordering.
- **State tracking** — Progress is recorded in the output document's frontmatter (`stepsCompleted` array). If a workflow is interrupted, it can resume from where it left off.
- **Interactive menus** — Every step ends with a menu. Claude halts and waits for your input before proceeding. Common options:
  - **[C] Continue** — Advance to the next step
  - **[A] Advanced Elicitation** — Deeper requirement discovery (optional, requires BMAD core)
  - **[P] Party Mode** — Multi-agent brainstorming (optional, requires BMAD core)

### The Traceability Chain

Requirements must trace through a connected chain:

```
Vision --> Success Criteria --> User Journeys --> Functional Requirements --> User Stories
```

Every functional requirement should link back to a user journey. Every user journey should connect to a success criterion. Every success criterion should support the vision. The validation workflow checks this chain rigorously.

---

## Create PRD Workflow (12 Steps)

**Command:** `/sdlc:create-prd`

Creates a comprehensive PRD from scratch through guided, collaborative conversation. Claude acts as a PM facilitator — you bring the domain expertise and product vision.

### Step Breakdown

| Step | Name | What Happens |
|------|------|-------------|
| **1** | **Initialization** | Detects existing workflow state (resume or fresh start). Discovers input documents — product briefs, research, project docs. Creates PRD from template. Detects brownfield vs greenfield. |
| **1b** | **Continue** *(conditional)* | If an incomplete PRD exists, resumes from the last completed step. Reads the `stepsCompleted` array and routes to the next pending step. |
| **2** | **Discovery** | Classifies the project: type (web app, API, mobile, etc.), domain (healthcare, fintech, etc.), complexity level, and greenfield/brownfield status. Loads project-types and domain-complexity data. |
| **2b** | **Vision** | Explores product vision through conversation. What problem does this solve? Who is it for? What makes it different? Captures vision notes without generating document content yet. |
| **2c** | **Executive Summary** | Collaboratively drafts the Executive Summary section. Synthesizes vision, target users, differentiators, and core value proposition into dense, precise prose. |
| **3** | **Success Criteria** | Defines measurable success outcomes. Each criterion must be SMART: specific, measurable, attainable, relevant, and traceable to the vision. |
| **4** | **User Journeys** | Maps comprehensive user journeys covering all key user types and scenarios. Each journey traces through the product experience from trigger to outcome. |
| **5** | **Domain Requirements** | *(If applicable)* Identifies industry-specific compliance requirements. Auto-detected from project domain — HIPAA for healthcare, PCI-DSS for fintech, FedRAMP for govtech, etc. Skipped for general-domain projects. |
| **6** | **Innovation Analysis** | *(If applicable)* Analyzes competitive differentiation and innovation opportunities based on project type. Skipped when not relevant to the project. |
| **7** | **Project-Type Requirements** | Deep-dive into platform-specific needs based on the detected project type. API projects get endpoint specs, mobile apps get platform requirements, SaaS gets multi-tenancy considerations, etc. |
| **8** | **Scoping** | Defines product scope across MVP, Growth, and Vision phases. Prioritizes features and draws clear phase boundaries. |
| **9** | **Functional Requirements** | Synthesizes all previous work into a capability contract. Each FR is a testable capability statement — no implementation details, no subjective language, no vague quantifiers. |
| **10** | **Non-Functional Requirements** | Defines quality attributes: performance, scalability, security, reliability, accessibility. Every NFR follows the template: "The system shall [metric] [condition] [measurement method]." |
| **11** | **Polish** | Full-document review for flow, coherence, information density, and consistency. Eliminates filler, tightens language, ensures all sections connect. |
| **12** | **Complete** | Marks workflow as done. Offers validation workflow or suggests next SDLC steps (architecture, UX design, epic breakdown). |

### Output

A complete PRD at `{planning_artifacts}/prd.md` with:

- Frontmatter tracking `stepsCompleted`, `inputDocuments`, `classification`, and `documentCounts`
- All 9 required sections populated
- High information density, zero filler
- Measurable requirements with test criteria
- Full traceability chain

---

## Validate PRD Workflow (13 Steps)

**Command:** `/sdlc:validate-prd`

Runs a comprehensive quality audit against an existing PRD. Can execute interactively in your conversation or delegate to an isolated subagent (recommended).

### Execution Modes

When you run `/sdlc:validate-prd`, you're asked to choose:

- **Subagent (recommended)** — Delegates to the `prd-validator` subagent which runs all 13 checks in isolation, then returns a structured report. Keeps your main conversation clean.
- **Interactive** — Runs each validation step directly in your conversation. You see each check's results and can interact during the process.

Both modes execute the same 13 validation checks.

### Step Breakdown

| Step | Name | What It Checks |
|------|------|---------------|
| **V-1** | **Discovery** | Finds the PRD, loads reference documents, initializes validation report. |
| **V-2** | **Format Detection** | Checks document structure — is it BMAD-standard format? Detects section headers, frontmatter, markdown formatting. |
| **V-2b** | **Parity Check** *(conditional)* | If non-standard format detected, compares against BMAD template and reports structural differences. |
| **V-3** | **Density Validation** | Scans for information density issues — filler phrases, verbose patterns, conversational language, padding. Flags anti-patterns like "the system will allow users to..." or "it is important to note that..." |
| **V-4** | **Brief Coverage** | Cross-references PRD against the product brief (if available). Checks that all brief themes and requirements are represented in the PRD. |
| **V-5** | **Measurability** | Audits every FR and NFR for measurability. Flags subjective adjectives ("easy to use", "fast", "intuitive"), vague quantifiers ("multiple", "several"), and requirements missing test criteria. |
| **V-6** | **Traceability** | Validates the traceability chain: Vision -> Success Criteria -> User Journeys -> FRs. Identifies orphaned requirements (no trace to user need) and uncovered journeys (no implementing FR). |
| **V-7** | **Implementation Leakage** | Detects implementation details that don't belong in a PRD: technology names, library references, database schemas, API designs, code patterns. Requirements should describe capabilities, not implementations. |
| **V-8** | **Domain Compliance** | Loads `domain-complexity.csv` and checks domain-specific requirements. Healthcare PRD missing HIPAA? Fintech PRD without PCI-DSS? This step catches those gaps. |
| **V-9** | **Project-Type Validation** | Loads `project-types.csv` and validates project-type-specific sections. API backends need endpoint specs. Mobile apps need platform requirements. SaaS needs multi-tenancy. |
| **V-10** | **SMART Validation** | Deep audit of every requirement against SMART criteria (Specific, Measurable, Attainable, Relevant, Traceable). Produces per-requirement quality scores. |
| **V-11** | **Holistic Quality** | Overall document quality assessment: consistency between sections, logical flow, completeness of coverage, professional tone, dual-audience optimization. Assigns a 1-5 quality rating. |
| **V-12** | **Completeness** | Final check that all required sections exist and are substantive (not just headers). Verifies frontmatter integrity and document metadata. |
| **V-13** | **Report Complete** | Compiles all findings into a structured validation report with overall status (Pass/Warning/Critical), findings by step, severity classifications, and prioritized recommendations. |

### Validation Report Structure

The output validation report includes:

- **Overall Status** — Pass, Warning, or Critical
- **Quick Results Table** — All 12 validation dimensions at a glance
- **Findings by Step** — Each check's status, severity, specific issues found
- **Statistics** — Total findings by severity (critical, warning, info)
- **Holistic Quality Rating** — 1-5 score with explanation
- **Top 3 Improvements** — Most impactful issues to fix first
- **Recommendation** — Next action (proceed, fix issues, major revision needed)

### After Validation

The report completion step offers:

| Option | What it does |
|--------|-------------|
| **[R] Review** | Walk through detailed findings interactively |
| **[E] Edit Workflow** | Launch the edit-prd workflow to fix issues systematically |
| **[F] Fix Simple Items** | Immediate inline fixes for easy wins (filler removal, template vars, missing headers) |
| **[X] Exit** | Done — see next SDLC steps |

---

## Edit PRD Workflow (5 Steps)

**Command:** `/sdlc:edit-prd`

Structured workflow for improving an existing PRD. Works with both BMAD-standard PRDs and legacy (non-standard) documents.

### Step Breakdown

| Step | Name | What Happens |
|------|------|-------------|
| **E-1** | **Discovery** | Prompts for PRD path. Auto-detects validation reports in the same folder. Discovers edit requirements from you. Detects PRD format (BMAD standard, BMAD variant, or legacy). Routes legacy PRDs to conversion step. |
| **E-1b** | **Legacy Conversion** *(conditional)* | Analyzes legacy PRD against BMAD standards. Proposes a conversion strategy — what sections to add, restructure, or rewrite. You choose: full conversion or edit as-is. |
| **E-2** | **Deep Review** | Thorough analysis of the PRD using BMAD quality standards. If a validation report is available, incorporates its findings. Produces a detailed change plan with specific proposed edits, ordered by impact. Presents the plan for your approval. |
| **E-3** | **Edit & Apply** | Applies approved changes to the PRD. Works through the change plan systematically — content updates, structure improvements, format conversion if needed. Each change is shown for your review. |
| **E-4** | **Complete** | Confirms all edits are applied. Offers to run validation on the updated PRD. Suggests next steps. |

### Format Detection

The edit workflow auto-detects PRD format by checking for these BMAD section headers:

- `## Executive Summary`
- `## Success Criteria`
- `## Product Scope`
- `## User Journeys`
- `## Functional Requirements`
- `## Non-Functional Requirements`

| Headers Found | Classification | Routing |
|--------------|---------------|---------|
| 5-6 | BMAD Standard | Direct to review (E-2) |
| 3-4 | BMAD Variant | Direct to review (E-2) |
| 0-2 | Legacy | Offer conversion (E-1b) or edit as-is |

---

## Quality Standards

### Required PRD Sections

Every BMAD PRD must include these level-2 markdown headers:

1. `## Executive Summary` — Vision, differentiator, target users
2. `## Success Criteria` — Measurable outcomes (SMART)
3. `## Product Scope` — MVP, Growth, Vision phases
4. `## User Journeys` — Comprehensive user experience flows
5. `## Functional Requirements` — Capability contract (FRs)
6. `## Non-Functional Requirements` — Quality attributes (NFRs)

Optional sections added based on project classification:

7. `## Domain Requirements` — Industry-specific compliance
8. `## Innovation Analysis` — Competitive differentiation
9. `## Project-Type Requirements` — Platform-specific needs

### Functional Requirement Standards

**Good FR:** States a testable capability
```
Users can reset their password via email link within 30 seconds of request.
```

**Bad FR:** Contains implementation details
```
System sends JWT token via SendGrid email API and validates against PostgreSQL database.
```

**Anti-patterns flagged by validation:**

| Anti-Pattern | Example | Fix |
|-------------|---------|-----|
| Subjective adjectives | "easy to use", "intuitive" | Add metrics: "completes in under 3 clicks" |
| Implementation leakage | "uses React and PostgreSQL" | State capability: "renders interactive dashboard" |
| Vague quantifiers | "supports multiple users" | Be specific: "supports up to 100 concurrent users" |
| Missing test criteria | "provides notifications" | Add measurement: "sends email within 30 seconds of trigger" |

### Non-Functional Requirement Standards

Every NFR follows the template:

```
"The system shall [metric] [condition] [measurement method]"
```

**Examples:**
- "The system shall respond to API requests in under 200ms for 95th percentile as measured by APM monitoring"
- "The system shall maintain 99.9% uptime during business hours as measured by cloud provider SLA"
- "The system shall support 10,000 concurrent users as measured by load testing"

### Information Density

Every sentence must carry information weight. The validation workflow flags these filler patterns:

| Verbose | Dense |
|---------|-------|
| "The system will allow users to..." | "Users can..." |
| "It is important to note that..." | *(state the fact directly)* |
| "In order to..." | "To..." |
| Conversational filler and padding | Direct, concise statements |

---

## Project Types & Domain Detection

### Project Types

The create workflow classifies projects into one of 11 types, each with tailored questions and required sections:

| Type | Signals | Key Additions |
|------|---------|--------------|
| `web_app` | website, webapp, SPA, PWA | Browser matrix, responsive design, SEO, accessibility |
| `api_backend` | API, REST, GraphQL, backend | Endpoint specs, auth model, data schemas, rate limits |
| `mobile_app` | iOS, Android, mobile | Platform reqs, offline mode, push strategy, store compliance |
| `saas_b2b` | SaaS, B2B, platform, enterprise | Tenant model, RBAC, subscription tiers, integrations |
| `developer_tool` | SDK, library, npm, pip | Language matrix, API surface, code examples, migration guide |
| `cli_tool` | CLI, terminal, bash | Command structure, output formats, config schema |
| `desktop_app` | desktop, Windows, Mac, Linux | Platform support, system integration, update strategy |
| `iot_embedded` | IoT, embedded, sensor, hardware | Hardware reqs, connectivity, power profile, OTA updates |
| `blockchain_web3` | blockchain, crypto, DeFi, NFT | Chain specs, wallet support, smart contracts, gas optimization |
| `game` | game, player, gameplay | Redirects to BMAD Game Module |

### Domain Complexity

The workflow detects domains requiring specialized compliance:

| Domain | Complexity | Key Concerns |
|--------|-----------|-------------|
| Healthcare | High | HIPAA, FDA, clinical validation, patient safety |
| Fintech | High | PCI-DSS, AML/KYC, SOX, fraud prevention |
| GovTech | High | FedRAMP, Section 508, NIST, procurement rules |
| EdTech | Medium | COPPA/FERPA, accessibility, content moderation |
| Aerospace | High | DO-178C, safety certification, ITAR |
| Automotive | High | ISO 26262, V2X, functional safety |
| Energy | High | NERC standards, grid compliance, SCADA |
| LegalTech | High | Legal ethics, bar regulations, attorney-client privilege |
| General | Low | Standard requirements, basic security |

Detected domains automatically add compliance sections to the PRD and validation checks.

---

## Hooks & Automation

### PostToolUse Hook — PRD Format Check

**Trigger:** Every time Claude uses the `Edit` or `Write` tool

**Behavior:**
1. Checks if the modified file is a PRD (`*prd*.md` pattern)
2. If not a PRD file, exits silently — zero overhead
3. If it is a PRD, scans for the 6 required BMAD section headers
4. Reports any missing sections
5. Runs asynchronously — does not block Claude's work

### Stop Hook — Completeness Verification

**Trigger:** When Claude stops working on a task

**Behavior:**
1. Uses a lightweight Haiku model to check task completeness
2. Verifies: all requested steps executed, output files exist and are non-empty, no TODO/FIXME markers in modified PRD files
3. Returns pass/fail with reason

---

## Subagent Validation

The `prd-validator` subagent runs the 13-step validation workflow in an isolated context:

- **Model:** Sonnet (cost-effective for systematic checking)
- **Tools:** Read, Grep, Glob only (read-only — diagnoses, doesn't fix)
- **Skills:** Preloads `prd-standards` and `validate-prd`
- **Own Stop hook:** Verifies all 13 steps completed and report has proper status

**When to use it:** The subagent is the default choice when running `/sdlc:validate-prd`. It keeps your main conversation free of 13 steps of validation output. The structured report is returned cleanly at the end.

**When to go interactive:** Choose interactive mode when you want to watch each validation check happen, ask questions during the process, or intervene mid-validation.

---

## Configuration Reference

The plugin reads from `_bmad/bmm/config.yaml` when present in your project root:

```yaml
# Project identity
project_name: "My Project"
user_name: "Your Name"

# Output paths
output_folder: "./output"
planning_artifacts: "./output/planning"
product_knowledge: "./docs"

# Language settings
communication_language: "English"      # Language Claude speaks to you
document_output_language: "English"    # Language for generated documents

# User context
user_skill_level: "expert"             # expert | intermediate | beginner
```

| Field | Default | Description |
|-------|---------|-------------|
| `project_name` | *(prompted)* | Used in document headers and templates |
| `user_name` | *(prompted)* | Author attribution in PRD |
| `output_folder` | `./output` | Base output directory |
| `planning_artifacts` | `./output/planning` | Where PRDs and reports are saved |
| `product_knowledge` | `./docs` | Existing project documentation |
| `communication_language` | English | Claude's spoken language |
| `document_output_language` | English | Generated document language |
| `user_skill_level` | expert | Adjusts explanation depth |

All fields are optional. Without a config file, workflows will prompt for required values.

### Environment Variables Used in Step Files

| Variable | Source | Used For |
|----------|--------|----------|
| `${PLUGIN_ROOT}` | Plugin system | Resolving skill reference file paths |
| `${CLAUDE_PLUGIN_ROOT}` | Plugin system | Same as PLUGIN_ROOT, used in commands |
| `{project-root}` | Working directory | Project-relative paths (config, output) |
| `{planning_artifacts}` | Config | PRD output location |
| `{output_folder}` | Config | General output location |
| `{communication_language}` | Config | Claude's spoken language |
