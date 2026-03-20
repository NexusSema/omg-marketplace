---
description: "Create a new technical specification interactively (5-step workflow)"
agent: agent
---

# Create a Specification

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the specification be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. Check if a plugin config file exists at `.claude-plugin/config.json`. If found, load it for default settings.
3. Ask the user for the **output file path** where the spec should be written. If not provided, suggest a sensible default based on the project structure.

## Begin Workflow

1. Load the `spec/create` skill to begin the structured 5-step workflow.
2. Begin at step-01 (Discover Context).
