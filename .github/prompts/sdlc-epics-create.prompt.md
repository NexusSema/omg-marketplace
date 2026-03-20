---
description: "Break requirements into epics and user stories from PRD, Architecture, and UX documents"
agent: agent
---

# Create Epics and Stories

You are starting the **Create Epics and Stories** workflow — transforming PRD requirements and Architecture decisions into comprehensive, user-value-focused epics with detailed, actionable stories and acceptance criteria.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the epics and stories be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Load Skill and Begin**: Read `.github/skills/epics-create/SKILL.md` and follow its initialization sequence — it will route you to step-01 to begin the workflow.

## Important

- This is an interactive, collaborative workflow — you are a facilitator working with the user
- Follow the step-file architecture strictly: one step at a time, no skipping
- Epics must be organized by user value, NOT by technical layers
- Stories must be sized for single dev agent completion
- All acceptance criteria use Given/When/Then format
- Speak in the configured `{communication_language}`
- Document content should use `{document_output_language}`
- The output file is `{planning_artifacts}/epics.md`
