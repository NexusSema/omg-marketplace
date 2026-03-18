---
name: 'step-04-crossref'
description: 'Run consistency and cross-reference verification on the drafted specification'
nextStepFile: 'step-05-polish.md'
---

# Step 4: Cross-Reference Check

**Progress: Step 4 of 5** — Next: Polish

## MANDATORY EXECUTION RULES

1. Read these instructions completely before taking any action.
2. Read the full spec document before running checks.
3. Present ALL findings to the user — do not silently fix issues.
4. Do NOT modify the document without user approval.

## YOUR TASK

Run consistency and cross-reference verification on the drafted specification.

### 1. Build Term Registry

- Scan the entire document for domain-specific terms, acronyms, and key concepts.
- For each term, record:
  - The term itself
  - Where it is defined (if anywhere)
  - All locations where it is used
  - Any variant spellings or phrasings
- Present the term registry:

> **Term Registry** ({count} terms found)
>
> | Term | Defined In | Used In | Variants |
> |------|-----------|---------|----------|
> | ... | ... | ... | ... |

### 2. Check Cross-Section Consistency

- Verify that terms are used consistently across all sections.
- Check for contradictions between sections (e.g., a limit stated as 100 in one section and 1000 in another).
- Check that concepts introduced in one section are not redefined differently elsewhere.

### 3. Check Stale/Broken Intra-Doc References

- Find any references to section names, figures, tables, or anchors within the document.
- Verify each reference points to something that actually exists.
- Flag any broken or stale references.

### 4. Check Contamination Patterns

- Scan for planning artifacts that do not belong in a spec:
  - TODO/FIXME/HACK comments
  - Status tracking language ("completed", "in progress", "blocked")
  - Temporal language ("currently", "recently", "soon", "will be")
  - Meeting notes or discussion artifacts
  - Placeholder text ("TBD", "to be determined", "placeholder")

### 5. Present Findings

Compile and present all findings:

> **Cross-Reference Check Results**
>
> **Consistency issues:** {count}
> {list each issue with section references}
>
> **Broken references:** {count}
> {list each broken reference}
>
> **Contamination patterns:** {count}
> {list each pattern match with location}
>
> **Term inconsistencies:** {count}
> {list term variants that should be unified}

### 6. Fix Issues Collaboratively

If any issues were found:

> Would you like to fix these issues now? I'll walk through each one and propose a fix for your approval.

- For each issue, propose a specific fix and wait for approval.
- Apply approved fixes to the document.

If no issues found:

> No issues found — the document is internally consistent.

### 7. Update Progress

- Update `stepsCompleted` to include `"crossref"`.
- Write the updated frontmatter.

## NEXT STEP

Present the menu:

> **[C] Continue** to polish (Step 5)

When the user chooses to continue, load `step-05-polish.md`.
