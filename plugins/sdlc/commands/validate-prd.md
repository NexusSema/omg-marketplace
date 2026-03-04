---
description: "Validate a PRD against BMAD standards. Can run interactively or delegate to prd-validator subagent."
---

# Validate PRD

You are starting the **Validate PRD** workflow — a 13-step comprehensive review of an existing PRD against BMAD quality standards.

## Setup

1. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`
   - `communication_language`, `document_output_language`, `user_skill_level`
   - `date` as system-generated current datetime

2. **Ask User Preference**:

   "How would you like to run validation?

   **[A] Subagent (Recommended)** — Delegate to the prd-validator subagent for isolated execution. Returns a structured validation report without polluting your main conversation context.

   **[B] Interactive** — Run validation steps directly in this conversation. You'll see each step's results and can interact during the process."

3. **Route Based on Choice**:

   - **If A (Subagent)**: Ask for the PRD file path, then delegate to the `prd-validator` subagent with instructions to validate that PRD. Present the returned report to the user.

   - **If B (Interactive)**: Load the `validate-prd` skill. Step files are at `${CLAUDE_PLUGIN_ROOT}/skills/validate-prd/references/`. Begin with `step-v-01-discovery.md`.

## Important

- The subagent option keeps your main conversation clean (recommended for most cases)
- Interactive mode gives you step-by-step visibility and control
- Both modes execute the same 13 validation checks
- Speak in the configured `{communication_language}`
