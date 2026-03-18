---
name: 'step-04-apply'
description: 'Apply all approved changes to the affected documents'
---

# Step 4: Apply Changes

**Progress: Step 4 of 4** — Final Step

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Apply ONLY the approved changes — never apply skipped changes.
3. Verify each document after modification.
4. Do NOT modify files beyond the approved changes.

## YOUR TASK

Apply all approved changes and produce a final summary report.

### 1. Apply Changes

For each document with approved changes:

**a. Apply the changes:**
- Make each approved text replacement in the document.
- Preserve the document's original formatting, indentation, and style.
- Apply changes in reverse line-number order to avoid offset issues from earlier edits.

**b. Verify the document:**
- Re-read the modified document.
- Confirm no broken references or formatting issues were introduced.
- Check that the surrounding context still reads naturally.

**c. Report per document:**

> Updated `{file_path}`: {n} changes applied successfully.

If a change fails to apply (e.g., the text was modified since scanning):

> Warning: Could not apply change {i} in `{file_path}` — the source text no longer matches. Skipping this change.

### 2. Summary Report

Present the final summary:

> **Propagation Complete!**
>
> - **Documents updated:** {n}
> - **Total changes applied:** {m}
> - **Documents skipped:** {k}
> - **Failed changes:** {f} (if any)
>
> **Updated documents:**
> - `{file_path_1}` — {n1} changes
> - `{file_path_2}` — {n2} changes
> - ...

### 3. Next Steps

Suggest follow-up actions:

> **Suggested next steps:**
> - Run `/sdlc:spec-review` on any updated specs to verify consistency.
> - Run `git diff` to review all modifications before committing.
