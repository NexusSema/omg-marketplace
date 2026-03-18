---
name: 'step-01-discover'
description: 'Discover context for the specification — identify subject, type, and reference materials'
nextStepFile: 'step-02-scope.md'
continueStepFile: 'step-01b-continue.md'
---

# Step 1: Discover Context

**Progress: Step 1 of 5** — Next: Define Scope

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Do NOT skip ahead to scope definition or section building.
3. Do NOT assume what the spec is about — ask the user.
4. Wait for user confirmation before proceeding.

## YOUR TASK

Discover all relevant context needed to create the specification.

### 1. Check for Existing Document

- Check if the output file already exists at the path specified during setup.
- If the file exists and has frontmatter with `stepsCompleted`, this is a **continuation** of a previous workflow.
- If continuation detected: load `step-01b-continue.md` and stop processing this file.

### 2. Fresh Spec — Gather Context

If no existing document was found, ask the user the following:

> I need to understand what we're building a spec for. Please tell me:
>
> 1. **Subject** — What system, component, or feature is this spec for?
> 2. **Spec type** — What kind of spec? (e.g., API, security, protocol, infrastructure, database, integration, data model, etc.)
> 3. **References** — Are there existing documents I should review? (design docs, PRDs, architecture docs, existing specs, etc.) Share file paths or URLs.

### 3. Load Reference Materials

- For each referenced document the user provides, read and analyze it.
- Extract key concepts, terminology, constraints, and decisions that are relevant to the new spec.
- Note any inconsistencies or gaps in the reference materials.

### 4. Report Findings

Present a summary to the user:

> **Discovery Summary**
>
> - **Subject:** {what the spec covers}
> - **Type:** {spec type}
> - **References loaded:** {count} documents
> - **Key concepts identified:** {list}
> - **Notable constraints/decisions from references:** {list}
>
> Does this look correct? Any adjustments?

### 5. Initialize Document

- Use the spec template at `${PLUGIN_ROOT}/skills/spec/create/references/spec-template.md` to create the initial document.
- Fill in the frontmatter: title, dates, author.
- Write the initialized document to the output path.
- Update `stepsCompleted` to include `"discover"`.

## NEXT STEP

Present the menu:

> **[C] Continue** to scope definition (Step 2)

When the user chooses to continue, load `step-02-scope.md`.
