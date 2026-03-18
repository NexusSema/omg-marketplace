---
description: "Edit a technical specification with impact analysis (4-step workflow)"
---

# Edit a Specification

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the specification be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. Check if a plugin config file exists at `${PLUGIN_ROOT}/.claude-plugin/config.json`. If found, load it for default settings.

## Begin Workflow

> **Important:** This workflow's core value is **impact analysis** — showing all affected locations before making changes. Every edit, no matter how small, must go through impact analysis to prevent inconsistencies.

1. Load the `spec/edit` skill to begin the structured 4-step workflow.
2. Begin at step-01 (Load Spec & Build Registry).
