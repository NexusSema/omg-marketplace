---
description: "Create a PRD from scratch using BMAD methodology (12-step interactive workflow)"
---

# Create PRD

You are starting the **Create PRD** workflow — a 12-step interactive process to create a comprehensive Product Requirements Document using BMAD methodology.

## Setup

1. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`
   - `communication_language`, `document_output_language`, `user_skill_level`
   - `date` as system-generated current datetime

2. **Load Skill**: Read and follow the `create-prd` skill instructions.

3. **Establish Step File Path**: Step files for this workflow are located at:
   `${CLAUDE_PLUGIN_ROOT}/skills/create-prd/references/`

4. **Begin Workflow**: Read fully and follow `${CLAUDE_PLUGIN_ROOT}/skills/create-prd/references/step-01-init.md`

## Important

- This is an **interactive** workflow — you facilitate, the user provides domain expertise
- Follow the step-file architecture exactly: one step at a time, sequential, no skipping
- Always halt at menus and wait for user input
- Speak in the configured `{communication_language}`
