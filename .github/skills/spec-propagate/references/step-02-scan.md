---
name: 'step-02-scan'
description: 'Scan the project for documents that reference concepts from the change manifest'
nextStepFile: 'step-03-review.md'
---

# Step 2: Scan Related Documents

**Progress: Step 2 of 4** — Next: Review Proposed Updates

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Do NOT skip ahead to proposing or applying changes.
3. Do NOT modify any files during this step.
4. Wait for user confirmation before proceeding.

## YOUR TASK

Find all documents that reference the changed concepts from the manifest.

### 1. Determine Search Scope

Ask the user:

> Where should I search for related documents?
>
> - **[A] Default scope** — current directory and common locations (`docs/`, `specs/`, `_bmad-output/`)
> - **[B] Custom paths** — specify directories or glob patterns to search
>
> You can also exclude specific paths if needed.

If the user selects default scope, search the current working directory and the common subdirectories: `docs/`, `specs/`, `_bmad-output/`, and any other markdown-heavy directories at the project root.

### 2. Search for References

For each changed concept from the manifest (renamed terms use the old name, added terms use the new name, modified terms use the current name):

- Grep all markdown files (`*.md`) in the search scope for the concept.
- Exclude the source spec file itself from results.
- Record for each match:
  - **File path** — the document containing the reference
  - **Line number** — where the reference appears
  - **Context** — the surrounding text (a few words before and after)
  - **Reference type** — inline mention, heading, code block, table cell, link text

### 3. Build Related Document Map

Present the results as a table:

> **Found references to changed concepts in {n} documents:**
>
> | # | Document | Concept | Occurrences | Sample Context |
> |---|----------|---------|-------------|----------------|
> | 1 | `docs/api-guide.md` | `old_term` | 5 | "The old_term is used to..." |
> | 2 | `specs/auth-spec.md` | `old_term` | 3 | "Authenticate using old_term" |
> | 3 | `docs/architecture.md` | `modified_concept` | 2 | "The modified_concept handles..." |

Group results by document for clarity. Show the total number of affected documents and total occurrences.

### 4. Handle No Results

If no references are found in any documents:

> No related documents reference the changed concepts. Propagation complete!

End the workflow here — no further steps needed.

## NEXT STEP

Present the menu:

> **[C] Continue** to review proposed updates (Step 3)

When the user chooses to continue, load `step-03-review.md`.
