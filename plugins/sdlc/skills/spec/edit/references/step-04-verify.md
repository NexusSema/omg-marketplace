---
name: 'step-04-verify'
description: 'Verify the edited document for consistency and completeness'
---

# Step 4: Verify

**Progress: Step 4 of 4** — Final Step

## Tasks

1. **Rebuild the term registry** from the updated document. Use the same extraction algorithm from Step 1 to build a fresh registry reflecting the current state.

2. **Run consistency checks** against the updated document:

   - **No remaining old term references** — For renames, verify that zero occurrences of the old term remain (unless explicitly excluded by the user in Step 2).
   - **No contradictions introduced** — Check that the new term or content does not conflict with existing descriptions elsewhere in the document.
   - **No broken cross-references** — Verify that all intra-document references (e.g., "see Section X", "as described in", "defined above/below") still point to valid targets.
   - **No contamination introduced** — Scan for planning language, status markers, or other non-spec content that may have been accidentally introduced during editing.

3. **Present verification results:**

   If all checks pass:
   > **Verification passed.** No issues found.

   If issues are found:
   > **Verification found {n} issue(s):**
   >
   > | # | Type | Location | Description |
   > |---|------|----------|-------------|
   > | 1 | Stale reference | L89 | Old term `entity_id` still present |
   > | 2 | Broken reference | L156 | "See Section Authentication" — section was renamed |
   > | ... | ... | ... | ... |

4. **Offer to fix issues** if any were found:

   > Would you like to fix these issues?
   >
   > - **[F] Fix all** — Automatically fix all issues
   > - **[S] Select** — Choose which issues to fix (enter numbers)
   > - **[I] Ignore** — Leave issues as-is

   If the user chooses to fix, apply the fixes and re-run verification.

5. **Final summary:**

   > **Edit complete!** {n} changes applied and verified. Document is consistent.
