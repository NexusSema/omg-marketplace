---
description: "Edit and improve an existing PRD using BMAD methodology"
---

# Edit PRD

You are starting the **Edit PRD** workflow — a 5-step process to review and improve an existing Product Requirements Document using BMAD methodology.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the PRD edits be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Load Skill**: Read and follow the `prd/edit` skill instructions.

4. **Establish Step File Path**: Step files for this workflow are located at:
   `${CLAUDE_PLUGIN_ROOT}/skills/prd/edit/references/`

5. **Prompt for PRD**: "Which PRD would you like to edit? Please provide the path to the PRD.md file."

6. **Begin Workflow**: Read fully and follow `${CLAUDE_PLUGIN_ROOT}/skills/prd/edit/references/step-e-01-discovery.md`

## Important

- This is an **interactive** workflow — you facilitate, the user drives improvements
- Follow the step-file architecture exactly: one step at a time, sequential, no skipping
- Always halt at menus and wait for user input
- Speak in the configured `{communication_language}`
