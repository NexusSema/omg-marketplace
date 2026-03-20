---
description: "Validate a PRD against BMAD standards (13-step comprehensive review). Can run interactively or delegate to prd-validator subagent."
agent: agent
---

# Validate PRD

You are starting the **Validate PRD** workflow — a 13-step comprehensive review of an existing PRD against BMAD quality standards.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the validation report be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all report content in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Ask User Preference**:

   "How would you like to run validation?

   **[A] Subagent (Recommended)** — Delegate to the `prd-validator` subagent for isolated execution. Returns a structured validation report without polluting your main conversation context.

   **[B] Interactive** — Run validation steps directly in this conversation. You'll see each step's results and can interact during the process."

4. **Route Based on Choice**:

   - **If A (Subagent)**: Ask for the PRD file path, then delegate to the `prd-validator` subagent with instructions to validate that PRD. Present the returned report to the user.

   - **If B (Interactive)**: Read `.github/skills/prd-validate/SKILL.md` and follow its instructions. Step files are at `.github/skills/prd-validate/references/`. Begin with `step-v-01-discovery.md`.

## Important

- The subagent option keeps your main conversation clean (recommended for most cases)
- Interactive mode gives you step-by-step visibility and control
- Both modes execute the same 13 validation checks
- Speak in the configured `{communication_language}`
