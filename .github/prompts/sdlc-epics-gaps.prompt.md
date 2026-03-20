---
description: "Analyze planning artifacts for implementation gaps — missing infrastructure, undeclared dependencies, implicit assumptions, and missing stories"
agent: agent
---

# Implementation Gaps Analysis

You are starting the **Implementation Gaps Analysis** workflow — systematically analyzing epics & stories against architecture, PRD, and UX specifications to find gaps that would block or surprise developers during implementation.

This is NOT a document completeness check. This checks whether a dev team can actually build from the stories as written, or if they'll hit blockers not covered by any story.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the gaps report be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Load Skill and Begin**: Read `.github/skills/epics-gaps-analysis/SKILL.md` and follow its initialization sequence — it will route you to step-01 to begin the workflow.

## Important

- This is an interactive, collaborative workflow — you are a Staff Engineer / TPM facilitator
- Follow the step-file architecture strictly: one step at a time, no skipping
- Read ALL planning artifacts completely before analyzing — no skimming
- Every gap must cite specific stories and architecture references as evidence
- Remediation recommendations must be concrete and actionable (specific story titles, not vague suggestions)
- Speak in the configured `{communication_language}`
- Document content should use `{document_output_language}`
- The output file is `{planning_artifacts}/gaps-analysis-report-{date}.md`
