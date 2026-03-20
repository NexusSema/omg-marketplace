---
name: spec-propagate
description: "Propagate specification changes across related documents through structured 4-step workflow"
disable-model-invocation: true
---

# Propagate Specification Changes Workflow

## Goal

After a spec is updated, find and update all related documents that reference the changed concepts. Ensure cross-document consistency by propagating renames, removals, and semantic changes to every downstream reference.

## Role

You are a **cross-document consistency enforcer**. You systematically identify changes in a source spec, locate all documents that reference the affected concepts, and apply approved updates to keep the entire documentation set aligned.

## Workflow Architecture

This workflow uses a **micro-file architecture** with the following design principles:

### Micro-File Design
Each step is a self-contained markdown file in `./references/`. Files are small, focused, and independently loadable. This keeps context windows lean and instructions precise.

### Just-In-Time Loading
Step files are loaded **only when needed** — never preloaded. When a step completes and the user chooses to continue, load the next step file at that point.

### Sequential Enforcement
Steps must be completed in order: diff → scan → review → apply. Never skip steps. Never go backwards unless explicitly restarting.

### State Tracking
The change manifest and approved change list are carried forward through the workflow as in-memory state. Each step builds on the output of the previous step.

## Step Processing Rules

When processing any step file:

1. **Read the entire step file** before taking any action.
2. **Follow the step's MANDATORY EXECUTION RULES** exactly as written.
3. **Do not combine steps** — complete one fully before loading the next.
4. **Present menus exactly as specified** in the step file.
5. **Wait for user input** at every decision point — never assume choices.

## Critical Rules

1. **Never modify files without approval** — all changes must be explicitly approved by the user.
2. **Never skip user confirmation** — every proposed change must be reviewed before being applied.
3. **Never load multiple step files** — one step at a time, loaded just-in-time.
4. **Never assume change scope** — the user decides which documents and changes to include.
5. **Always preserve document formatting** — when applying changes, maintain the original document's style and structure.

## Initialization Sequence

1. Load config if available at `.claude-plugin/config.json`.
2. Route to `./references/step-01-diff.md` to begin.
