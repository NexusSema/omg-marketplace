---
name: 'step-01b-continue'
description: 'Handle workflow continuation for interrupted architecture workflows'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 1b: Workflow Continuation Handler

**Progress: Resuming existing workflow**

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on understanding current state and getting user confirmation
- HANDLE workflow resumption smoothly and transparently
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## YOUR TASK

Handle workflow continuation by analyzing existing work and guiding the user to resume at the appropriate step.

## CONTINUATION SEQUENCE

### 1. Analyze Current Document State

Read the existing architecture document completely and analyze:

**Frontmatter Analysis:**
- `stepsCompleted`: What steps have been done
- `inputDocuments`: What documents were loaded
- `lastStep`: Last step that was executed
- `project_name`, `user_name`, `date`: Basic context

**Content Analysis:**
- What sections exist in the document
- What architectural decisions have been made
- What appears incomplete or in progress
- Any TODOs or placeholders remaining

### 2. Present Continuation Summary

"Welcome back {{user_name}}! I found your Architecture work for {{project_name}}.

**Current Progress:**
- Steps completed: {{stepsCompleted list}}
- Last step worked on: Step {{lastStep}}
- Input documents loaded: {{number of inputDocuments}} files

**Document Sections Found:**
{list all H2/H3 sections found in the document}

**What would you like to do?**
[R] Resume from where we left off
[C] Continue to next logical step
[O] Overview of all remaining steps
[X] Start over (will overwrite existing work)"

### 3. Handle User Choice

**If 'R' (Resume):** Identify the next step based on `stepsCompleted` and load the appropriate step file.

**If 'C' (Continue):** Analyze document content to determine logical next step and advance.

**If 'O' (Overview):** Provide brief description of all remaining steps and let user choose.

**If 'X' (Start over):** Confirm with user, then delete existing document and load `step-01-init.md`.

### 4. Navigate to Selected Step

After user makes choice, update frontmatter and load the selected step file. Maintain all existing content and keep `stepsCompleted` accurate.

### 5. Special Continuation Cases

- If `stepsCompleted` is empty but document has content: Ask user about recovering or starting fresh
- If document appears corrupted: Offer recovery or fresh start
- If document is complete but not marked done: Offer to finalize

## NEXT STEP

After user selects their continuation option, load the appropriate step file:
- `step-02-context.md`
- `step-03-starter.md`
- `step-04-decisions.md`
- `step-05-patterns.md`
- `step-06-structure.md`
- `step-07-validation.md`
- `step-08-complete.md`
