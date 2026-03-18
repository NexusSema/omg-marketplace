---
name: 'step-01b-continue'
description: 'Continue an incomplete spec creation workflow from where it left off'
---

# Step 1b: Continue Incomplete Workflow

## MANDATORY EXECUTION RULES

1. Read the existing spec document fully before taking any action.
2. Do NOT re-run steps that are already marked complete.
3. Report progress to the user before resuming.

## YOUR TASK

Resume a previously interrupted spec creation workflow.

### 1. Detect Progress

- Read the spec document at the output path.
- Extract the `stepsCompleted` array from the frontmatter.
- Determine which steps have been completed and which remain.

The step names in order are:
1. `discover` — Discover Context
2. `scope` — Define Scope
3. `build` — Build Sections
4. `crossref` — Cross-Reference Check
5. `polish` — Polish

### 2. Report Progress

Present the progress to the user:

> **Resuming spec creation for:** {title}
>
> **Completed steps:**
> {list completed steps with checkmarks}
>
> **Remaining steps:**
> {list remaining steps}
>
> Ready to resume at: **{next incomplete step name}**

### 3. Resume

- Wait for user confirmation to proceed.
- Load the step file for the next incomplete step and begin processing it.

Step file mapping:
- `scope` → `step-02-scope.md`
- `build` → `step-03-build.md`
- `crossref` → `step-04-crossref.md`
- `polish` → `step-05-polish.md`
