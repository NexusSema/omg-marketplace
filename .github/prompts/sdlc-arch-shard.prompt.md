---
description: "Shard a monolithic architecture document into 7 focused sub-documents (8-step interactive workflow)"
agent: agent
---

# Shard Architecture

You are starting the **Shard Architecture** workflow — an 8-step interactive process to decompose a monolithic architecture document into 7 focused, production-ready sub-documents with Mermaid diagrams, gap analysis, and cross-references.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the architecture sub-documents be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Load Skill**: Read `.github/skills/architecture-shard/SKILL.md` and follow its instructions.

4. **Begin Workflow**: Read fully and follow `.github/skills/architecture-shard/references/step-01-parse-source.md`

## Important

- This is an **interactive** workflow — you facilitate, the user provides domain expertise
- Follow the step-file architecture exactly: one step at a time, sequential, no skipping
- Always halt at menus and wait for user input
- Speak in the configured `{communication_language}`
- A monolithic architecture document is required as input — the workflow will prompt for the path
