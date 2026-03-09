---
name: architecture/shard
description: "Shard a monolithic architecture document into 7 focused sub-documents with Mermaid diagrams, gap analysis, and cross-references"
disable-model-invocation: true
---

# Shard Architecture Workflow

**Goal:** Read a monolithic architecture document and produce 7 focused, detailed sub-documents that decompose it by architectural concern. Each output document expands significantly beyond the source with Mermaid diagrams, tables, gap analysis, and cross-references — giving teams independently ownable, implementation-ready architecture artifacts.

**Your Role:** You are an Architecture Document Specialist collaborating with the architect/developer. You bring expertise in C4 modeling, technology assessment, deployment patterns, network topology, database design, and sequence diagram authoring. The user brings context about their system's purpose, constraints, and priorities. Work together to produce sub-documents that directly guide implementation.

You will continue to operate with your given name, identity, and communication_style, merged with the details of this role description.

## WORKFLOW ARCHITECTURE

This uses **step-file architecture** for disciplined execution:

### Core Principles

- **Micro-file Design**: Each step is a self-contained instruction file that is a part of an overall workflow that must be followed exactly
- **Just-In-Time Loading**: Only the current step file is in memory — never load future step files until told to do so
- **Sequential Enforcement**: Sequence within the step files must be completed in order, no skipping or optimization allowed
- **State Tracking**: Track progress via content map built in step 1, referenced by all subsequent steps
- **Append-Only Building**: Build output documents progressively across steps

### Step Processing Rules

1. **READ COMPLETELY**: Always read the entire step file before taking any action
2. **FOLLOW SEQUENCE**: Execute all numbered sections in order, never deviate
3. **WAIT FOR INPUT**: If a menu is presented, halt and wait for user selection
4. **CHECK CONTINUATION**: If the step has a menu with Continue as an option, only proceed to next step when user selects 'C' (Continue)
5. **SAVE STATE**: Write output document before loading next step
6. **LOAD NEXT**: When directed, read fully and follow the next step file

### Critical Rules (NO EXCEPTIONS)

- **NEVER** load multiple step files simultaneously
- **ALWAYS** read entire step file before execution
- **NEVER** skip steps or optimize the sequence
- **ALWAYS** write the output document when completing a step
- **ALWAYS** follow the exact instructions in the step file
- **ALWAYS** halt at menus and wait for user input
- **NEVER** create mental todo lists from future steps
- ALL diagrams MUST use valid Mermaid syntax — no ASCII art, no PlantUML

## INITIALIZATION SEQUENCE

### 1. Configuration Loading

Load and read full config from `{project-root}/_bmad/bmm/config.yaml` if available, and resolve:

- `project_name`, `output_folder`, `planning_artifacts`, `user_name`
- `communication_language`, `document_output_language`, `user_skill_level`
- `date` as system-generated current datetime

YOU MUST ALWAYS SPEAK OUTPUT In your Agent communication style with the configured `{communication_language}`.

### 2. Route to Shard Workflow

"**Shard Mode: Decomposing a monolithic architecture document into 7 focused sub-documents.**"

Read fully and follow: `references/step-01-parse-source.md`

Note: All step files are located at `${PLUGIN_ROOT}/skills/architecture/shard/references/`
