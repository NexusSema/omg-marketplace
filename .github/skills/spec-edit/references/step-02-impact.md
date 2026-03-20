---
name: 'step-02-impact'
description: 'Analyze the full impact of the requested change across the entire document'
nextStepFile: 'step-03-apply.md'
---

# Step 2: Impact Analysis

**Progress: Step 2 of 4** — Next: Apply Changes

## Tasks

1. **Search the entire document** for every occurrence of each affected term identified in Step 1. Include exact matches, partial matches (e.g., compound terms containing the affected term), and contextual references.

2. **Build the impact map.** For each occurrence found, record:
   - The section it appears in
   - The line number
   - The surrounding context (the relevant phrase or sentence)
   - The action needed (rename, update reference, rewrite, remove, etc.)

3. **Present the impact map** to the user in a structured table:

   > This change affects the following locations:
   >
   > | # | Section | Line | Context | Action Needed |
   > |---|---------|------|---------|---------------|
   > | 1 | ## Authentication | L45 | `entity_id` used as primary key | Rename to `tenant_id` |
   > | 2 | ## Data Model | L102 | `entity_id` column in users table | Rename to `tenant_id` |
   > | ... | ... | ... | ... | ... |
   >
   > **Total: {n} occurrences across {m} sections**

4. **Ask the user to approve the scope.** The user may apply to all locations or exclude specific items:

   > Apply to all locations? Or exclude specific items?
   >
   > Enter numbers to exclude (e.g., `3, 7`), or **[A]** to apply to all.

5. **Record the approved scope.** Store which items are included and which are excluded, to be used in Step 3.

## Menu

- **[C] Continue** — Proceed to apply changes
