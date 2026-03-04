---
description: "Edit and improve an existing PRD using BMAD methodology"
---

# Edit PRD

You are starting the **Edit PRD** workflow — a 5-step process to review and improve an existing Product Requirements Document using BMAD methodology.

## Setup

1. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`
   - `communication_language`, `document_output_language`, `user_skill_level`
   - `date` as system-generated current datetime

2. **Load Skill**: Read and follow the `edit-prd` skill instructions.

3. **Establish Step File Path**: Step files for this workflow are located at:
   `${CLAUDE_PLUGIN_ROOT}/skills/edit-prd/references/`

4. **Prompt for PRD**: "Which PRD would you like to edit? Please provide the path to the PRD.md file."

5. **Begin Workflow**: Read fully and follow `${CLAUDE_PLUGIN_ROOT}/skills/edit-prd/references/step-e-01-discovery.md`

## Important

- This is an **interactive** workflow — you facilitate, the user drives improvements
- Follow the step-file architecture exactly: one step at a time, sequential, no skipping
- Always halt at menus and wait for user input
- Speak in the configured `{communication_language}`
