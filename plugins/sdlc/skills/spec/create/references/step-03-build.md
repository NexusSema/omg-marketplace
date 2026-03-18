---
name: 'step-03-build'
description: 'Build each section collaboratively — user provides knowledge, facilitator structures it'
nextStepFile: 'step-04-crossref.md'
---

# Step 3: Build Sections

**Progress: Step 3 of 5** — Next: Cross-Reference Check

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Work through sections **in order** — do not skip or reorder.
3. Do NOT write a section without user input — every section requires collaboration.
4. Do NOT finalize a section without user review and approval.
5. Write each section to the document **immediately after approval** — do not batch.

## YOUR TASK

Build each section of the specification collaboratively with the user.

### 1. Read Current Document

- Read the spec document to get the section outline from Step 2.
- Identify all `##` headers that need content.
- Present the build plan:

> **Sections to build:**
>
> 1. {section 1}
> 2. {section 2}
> ...
>
> We'll work through each one in order. Let's start with **{first section}**.

### 2. For Each Section (In Order)

Repeat the following cycle for every section:

#### a. Present the Section

> **Building: ## {Section Name}**
> ({current} of {total} sections)

#### b. Gather Input

> What should this section cover? Share your knowledge — key points, requirements, constraints, examples — and I'll help structure it into clear spec language.

- Listen to the user's input. Ask clarifying questions if anything is ambiguous or incomplete.
- If the user referenced documents in Step 1, draw relevant details from those references.

#### c. Draft the Section

- Write a draft of the section content based on the user's input.
- Use precise, specification-appropriate language.
- Include tables, lists, or diagrams where they improve clarity.
- Present the full draft to the user:

> **Draft for ## {Section Name}:**
>
> {draft content}
>
> How does this look? Any changes needed?

#### d. Incorporate Feedback

- Apply any changes the user requests.
- Re-present if the changes are substantial.
- Repeat until the user approves.

#### e. Write to Document

- Write the approved section content to the spec document, replacing the placeholder comment.
- Confirm the write:

> Section **{Section Name}** written. ({remaining} sections remaining)

### 3. Report Completion

After all sections are built:

> All {total} sections have been built and written to the document.

- Update `stepsCompleted` to include `"build"`.
- Write the updated frontmatter.

## NEXT STEP

Present the menu:

> **[C] Continue** to cross-reference check (Step 4)

When the user chooses to continue, load `step-04-crossref.md`.
