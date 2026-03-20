---
name: 'step-01-diff'
description: 'Identify what changed in the source specification by analyzing git diffs or user input'
nextStepFile: 'step-02-scan.md'
---

# Step 1: Identify Changes

**Progress: Step 1 of 4** — Next: Scan Related Documents

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Do NOT skip ahead to scanning or applying changes.
3. Do NOT assume what changed — verify with git diff or ask the user.
4. Wait for user confirmation of the change manifest before proceeding.

## YOUR TASK

Identify exactly what changed in the source specification.

### 1. Get the Source Spec

Ask the user:

> Which specification was changed? Please provide the **file path**.

### 2. Auto-Detect Changes via Git Diff

Try to detect changes automatically:

- Run `git diff` on the specified file to find recent unstaged changes.
- If no unstaged changes, try `git diff HEAD` to find staged changes.
- If no staged changes, try `git diff HEAD~1` to compare against the last commit.

If git diff is available, parse the diff to extract:

- **Added terms/concepts** — new definitions, new sections, new terminology
- **Removed terms/concepts** — deleted definitions, removed sections
- **Renamed terms** — old name → new name mappings
- **Modified descriptions** — existing concepts with changed definitions or details

### 3. Manual Fallback

If git diff is not available or insufficient (e.g., file is new, changes are too old, or user says the diff is incomplete):

Ask the user:

> I couldn't fully detect the changes from git. Please describe what changed:
>
> - Any **renamed** terms? (old name → new name)
> - Any **added** concepts or terms?
> - Any **removed** concepts or terms?
> - Any **modified** descriptions or definitions?

Parse the user's response into the same categories: added, removed, renamed, modified.

### 4. Build Change Manifest

Present the change manifest to the user:

> **Change Manifest**
>
> Source: `{file_path}`
>
> - **Renamed:** `old_term` → `new_term`
> - **Added:** `new_concept`
> - **Removed:** `removed_concept`
> - **Modified:** `existing_concept` (description changed)
>
> Does this look correct? Any adjustments?

Allow the user to add, remove, or modify entries in the manifest until they confirm it is complete.

### 5. Confirm Manifest

Once the user confirms:

> Change manifest confirmed with {n} changes across {m} concepts.

## NEXT STEP

Present the menu:

> **[C] Continue** to scan related documents (Step 2)

When the user chooses to continue, load `step-02-scan.md`.
