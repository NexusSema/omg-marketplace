---
name: 'step-02-scope'
description: 'Define the section outline for the specification — user decides structure'
nextStepFile: 'step-03-build.md'
---

# Step 2: Define Scope

**Progress: Step 2 of 5** — Next: Build Sections

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Do NOT prescribe sections — the user decides what their spec needs.
3. Do NOT skip user confirmation of the outline.
4. Do NOT begin writing section content — that happens in Step 3.

## YOUR TASK

Work with the user to define the section structure of their specification.

### 1. Ask for Section Outline

Prompt the user:

> Now let's define the structure of your spec. What sections do you want to include?
>
> List the sections as `##` headers in the order you want them. For example:
> - ## Overview
> - ## Authentication Flow
> - ## API Endpoints
> - ## Error Handling
>
> Share your desired outline and I'll set it up.

### 2. Suggest Glossary (Optional)

- If the user's outline does **not** include a Glossary section, suggest adding one:

> I noticed there's no Glossary section. For specs with domain-specific terminology, a glossary helps keep definitions consistent. Would you like me to add a `## Glossary` section at the end?

- This is a **recommendation only** — respect the user's decision either way.

### 3. Confirm the Outline

Present the final outline back to the user for confirmation:

> **Spec Outline:**
>
> 1. {section 1}
> 2. {section 2}
> ...
>
> Does this look right? Any sections to add, remove, or reorder?

### 4. Write Outline to Document

- Read the current spec document.
- Below the Revision History table, write each section as a `##` header with a placeholder comment:
  ```
  ## {Section Name}

  <!-- Content to be developed in Step 3 -->
  ```
- Preserve all existing frontmatter and the Revision History section.
- Update `stepsCompleted` to include `"scope"`.
- Write the updated document.

**KEY PRINCIPLE:** The plugin does NOT prescribe sections. The user's outline is the source of truth.

## NEXT STEP

Present the menu:

> **[C] Continue** to building sections (Step 3)

When the user chooses to continue, load `step-03-build.md`.
