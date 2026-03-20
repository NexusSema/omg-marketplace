---
description: "Propagate specification changes across related documents (4-step workflow)"
agent: agent
---

# Propagate Specification Changes

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the specification be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. Check if a plugin config file exists at `.claude-plugin/config.json`. If found, load it for default settings.

## Begin Workflow

1. Load the `spec/propagate` skill to begin the structured 4-step workflow.
2. Begin at step-01 (Identify Changes).

## Important

This workflow finds related documents that reference concepts from a changed spec and helps update them. After a spec is modified, use this command to ensure all downstream documents stay consistent with the source of truth.
