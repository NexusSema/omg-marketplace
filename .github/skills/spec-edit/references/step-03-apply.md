---
name: 'step-03-apply'
description: 'Apply the approved changes to all selected locations in the document'
nextStepFile: 'step-04-verify.md'
---

# Step 3: Apply Changes

**Progress: Step 3 of 4** — Next: Verify

## Tasks

1. **Apply the change to all approved locations** from the impact map. Process each location in document order (top to bottom).

2. **For each location**, show the before/after:

   > **Location {i}: {section} (L{line})**
   >
   > ```diff
   > - old text with original term
   > + new text with updated term
   > ```

   Then apply the edit to the document.

3. **Update the glossary** (if one exists in the document). If the change introduces new terms or renames existing ones, add or update the corresponding glossary entries.

4. **Update the revision history.** If the document has a revision history or changelog section, append an entry describing the change:
   - Date of change
   - Description of what was changed
   - Scope (number of locations affected)

5. **Update `lastUpdated` in frontmatter.** If the document has YAML frontmatter with a `lastUpdated` or `date` field, update it to today's date.

6. **Report the results:**

   > **{n} changes applied across {m} sections.**

## Menu

- **[C] Continue** — Proceed to verification
