---
name: 'step-03-review'
description: 'Review and approve proposed updates for each affected document'
nextStepFile: 'step-04-apply.md'
---

# Step 3: Review Proposed Updates

**Progress: Step 3 of 4** — Next: Apply Changes

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Do NOT apply any changes during this step — review only.
3. Do NOT skip documents — present every affected document for review.
4. Wait for user approval on each change before marking it as approved.

## YOUR TASK

For each affected document, propose specific changes and get user approval.

### 1. Process Each Document

For each affected document (in the order they appeared in the scan results):

**a. Show the document header:**

> **Document: `{file_path}`** — {n} occurrences to review

**b. For each occurrence in that document, show:**

> **Change {i}/{total}** in `{file_path}` (line {line_number})
>
> **Current text:**
> ```
> {surrounding context with the matched term highlighted}
> ```
>
> **Proposed replacement:**
> ```
> {surrounding context with the updated term/content}
> ```
>
> **Type:** {Auto-applicable | Needs-review}

Mark changes as:
- **Auto-applicable** — simple renames or direct term swaps where the meaning is unambiguous
- **Needs-review** — semantic changes where the surrounding context may also need updating, or where the replacement might alter the meaning

**c. Ask for approval on each change:**

> - **[A] Approve** this change
> - **[M] Modify** — edit the proposed replacement
> - **[S] Skip** — do not apply this change

If the user chooses to modify, accept their revised text and mark it as approved with the modified content.

### 2. Build Approved Change List

After reviewing all documents, present a summary:

> **Review Summary**
>
> | Document | Approved | Skipped | Modified |
> |----------|----------|---------|----------|
> | `docs/api-guide.md` | 4 | 1 | 0 |
> | `specs/auth-spec.md` | 3 | 0 | 1 |
>
> **Total:** {n} changes approved, {m} skipped

If no changes were approved:

> No changes approved. Propagation complete — no documents will be modified.

End the workflow here.

## NEXT STEP

Present the menu:

> **[C] Continue** to apply changes (Step 4)

When the user chooses to continue, load `step-04-apply.md`.
