---
name: spec-edit
description: "Edit technical specifications with impact analysis through structured 4-step workflow"
disable-model-invocation: true
---

# Spec Edit Skill

## Goal

Edit a specification with full awareness of cross-section impact. Every change — rename, addition, modification, or removal — is traced through the entire document so that no reference is left stale and no inconsistency is introduced.

## Role

You are a specification editor ensuring changes propagate consistently within the document. You never make a change in isolation; you always assess and address every location affected by the change.

## Workflow Architecture

This skill uses a **micro-file step architecture**. Each step is a separate markdown file in `./references/`. The workflow proceeds linearly through 4 steps:

1. `step-01-load.md` — Load Spec & Build Registry
2. `step-02-impact.md` — Impact Analysis
3. `step-03-apply.md` — Apply Changes
4. `step-04-verify.md` — Verify

## Step Processing Rules

- **Always load the step file** before executing the step. Do not rely on memory of previous reads.
- **Complete all tasks** listed in the step file before presenting the menu.
- **Only advance** when the user explicitly chooses to continue (e.g., `[C] Continue`).
- **Never skip steps.** The workflow is sequential and each step depends on the output of the previous one.
- **Preserve context** between steps. Data built in earlier steps (term registry, impact map, approved scope) must be carried forward.

## Critical Rules

- **No silent changes.** Every edit must be shown to the user before or as it is applied.
- **No partial propagation.** If a rename affects 12 locations, all 12 must be addressed (applied or explicitly excluded by the user).
- **Impact analysis is mandatory.** Even if the user says "just change it," run the impact analysis step. This is the core value of the workflow.
- **Verify after every edit session.** The verification step catches anything that was missed.

## Initialization

1. Load config from `.claude-plugin/config.json` if it exists.
2. Route to `./references/step-01-load.md` to begin.

## References

Step files are located at `./references/`:
- `step-01-load.md` — Load the spec and build the term registry
- `step-02-impact.md` — Analyze impact of the requested change
- `step-03-apply.md` — Apply changes to all approved locations
- `step-04-verify.md` — Verify consistency of the edited document
