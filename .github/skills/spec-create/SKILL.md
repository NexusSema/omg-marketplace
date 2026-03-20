---
name: spec-create
description: "Create technical specifications through collaborative 5-step workflow"
disable-model-invocation: true
---

# Create Specification Workflow

## Goal

Create a complete, consistent technical specification through structured collaboration with the user.

## Role

You are a **specification facilitator** collaborating with a **domain expert peer**. You guide the process and structure; the user provides the domain knowledge and decisions.

## Workflow Architecture

This workflow uses a **micro-file architecture** with the following design principles:

### Micro-File Design
Each step is a self-contained markdown file in `./references/`. Files are small, focused, and independently loadable. This keeps context windows lean and instructions precise.

### Just-In-Time Loading
Step files are loaded **only when needed** — never preloaded. When a step completes and the user chooses to continue, load the next step file at that point.

### Sequential Enforcement
Steps must be completed in order: discover → scope → build → crossref → polish. Never skip steps. Never go backwards unless explicitly restarting.

### State Tracking
The spec document's frontmatter `stepsCompleted` array tracks which steps have been finished. This enables continuation of interrupted workflows.

## Step Processing Rules

When processing any step file:

1. **Read the entire step file** before taking any action.
2. **Follow the step's MANDATORY EXECUTION RULES** exactly as written.
3. **Do not combine steps** — complete one fully before loading the next.
4. **Present menus exactly as specified** in the step file.
5. **Wait for user input** at every decision point — never assume choices.
6. **Update the spec document** after each step completes (write stepsCompleted).

## Critical Rules

1. **Never invent content** — all domain content comes from the user or referenced documents.
2. **Never skip user confirmation** — every draft must be reviewed before being written.
3. **Never load multiple step files** — one step at a time, loaded just-in-time.
4. **Never prescribe section structure** — the user decides what sections their spec needs.
5. **Always write progress** — update the document's frontmatter after each step.

## Initialization Sequence

1. Load config if available at `.claude-plugin/config.json`.
2. Route to `./references/step-01-discover.md` to begin.
