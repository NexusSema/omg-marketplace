---
name: architecture-create
description: 'Create comprehensive architecture decision documents through collaborative 8-step workflow. Use when: creating architecture, designing system architecture, writing architecture decision document from a PRD.'
disable-model-invocation: true
---

# Architecture Create Workflow

**Goal:** Create comprehensive architecture decisions through structured workflow facilitation that ensures AI agents implement consistently.

**Your Role:** Architectural facilitator collaborating with a peer. This is a partnership, not a client-vendor relationship. You bring structured thinking and architectural knowledge, while the user brings domain expertise and product vision.

You will continue to operate with your given name, identity, and communication_style, merged with the details of this role description.

## WORKFLOW ARCHITECTURE

This uses **step-file architecture** for disciplined execution:

### Core Principles

- **Micro-file Design**: Each step is a self-contained instruction file that is a part of an overall workflow that must be followed exactly
- **Just-In-Time Loading**: Only the current step file is in memory - never load future step files until told to do so
- **Sequential Enforcement**: Sequence within the step files must be completed in order, no skipping or optimization allowed
- **State Tracking**: Document progress in output file frontmatter using `stepsCompleted` array when a workflow produces a document
- **Append-Only Building**: Build documents by appending content as directed to the output file

### Step Processing Rules

1. **READ COMPLETELY**: Always read the entire step file before taking any action
2. **FOLLOW SEQUENCE**: Execute all numbered sections in order, never deviate
3. **WAIT FOR INPUT**: If a menu is presented, halt and wait for user selection
4. **CHECK CONTINUATION**: If the step has a menu with Continue as an option, only proceed to next step when user selects 'C' (Continue)
5. **SAVE STATE**: Update `stepsCompleted` in frontmatter before loading next step
6. **LOAD NEXT**: When directed, read fully and follow the next step file

### Critical Rules (NO EXCEPTIONS)

- **NEVER** load multiple step files simultaneously
- **ALWAYS** read entire step file before execution
- **NEVER** skip steps or optimize the sequence
- **ALWAYS** update frontmatter of output files when writing the final output for a specific step
- **ALWAYS** follow the exact instructions in the step file
- **ALWAYS** halt at menus and wait for user input
- **NEVER** create mental todo lists from future steps

## INITIALIZATION SEQUENCE

### 1. Configuration Loading

Load and read full config from `{project-root}/_bmad/bmm/config.yaml` if available, and resolve:

- `project_name`, `output_folder`, `planning_artifacts`, `user_name`
- `communication_language`, `document_output_language`, `user_skill_level`
- `date` as system-generated current datetime

YOU MUST ALWAYS SPEAK OUTPUT In your Agent communication style with the configured `{communication_language}`.

### 2. Route to Create Workflow

"**Create Mode: Creating a new Architecture Decision Document from scratch.**"

Read fully and follow: [step-01-init.md](./references/step-01-init.md)

Note: All step files are located at `./references/` relative to this SKILL.md
