---
name: 'step-05-polish'
description: 'Final cleanup — glossary offer, formatting review, status promotion'
---

# Step 5: Polish

**Progress: Step 5 of 5** — Final Step

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Read the full spec document before making any changes.
3. Do NOT change substantive content — only formatting, metadata, and cleanup.
4. Get user approval before adding a glossary.

## YOUR TASK

Perform final cleanup and polish on the specification.

### 1. Glossary Offer

- Check if the document already has a `## Glossary` section.
- If no glossary exists and the term registry from Step 4 contains 5 or more terms, offer to add one:

> I identified {count} domain-specific terms during the cross-reference check. Would you like me to add a Glossary section with definitions for these terms?

- If the user agrees, generate the glossary from the term registry and append it as the last `##` section.
- If a glossary already exists, verify it is complete against the term registry and offer to add any missing terms.

### 2. Formatting Review

Review the document for:

- **Consistent heading levels** — no skipped levels (e.g., `##` jumping to `####`).
- **Consistent list formatting** — same style (bullets vs. numbers) within each section.
- **Table alignment** — all tables properly formatted.
- **Code block formatting** — all code blocks have language identifiers.
- **Whitespace** — consistent spacing between sections.

Fix any formatting issues found. Report what was fixed:

> **Formatting fixes applied:**
> {list of fixes, or "None needed"}

### 3. Metadata and Revision History

- Update frontmatter:
  - Set `lastUpdated` to today's date.
  - Set `status` from `"Draft"` to `"Review"`.
  - Set `version` to `"1.0"` if not already set.
- Verify the Revision History table is accurate and complete.

### 4. Remove Placeholder Comments

- Remove any remaining `<!-- Content to be developed in Step 3 -->` or similar placeholder comments.
- If any placeholder comments are found in sections that still lack content, flag them to the user rather than silently removing.

### 5. Update Progress

- Update `stepsCompleted` to include `"polish"`.
- Write the final document.

### 6. Present Summary

> **Spec creation complete!**
>
> **Document:** {file_path}
> **Title:** {title}
> **Status:** Review
> **Sections:** {count}
> **Steps completed:** discover, scope, build, crossref, polish
>
> Your specification is ready for review. Next steps:
> - Share with reviewers for feedback
> - Run `/sdlc:spec-review` to get an automated quality assessment
