---
description: "Review a technical specification for consistency, contamination, and completeness. Can run interactively or delegate to spec-reviewer subagent."
agent: agent
---

# Review a Specification

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the review report be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all document content in `{document_output_language}`.

2. Ask the user for the **spec file path** to review. If a path was provided as an argument, use that instead.
3. Verify the file exists and is readable.

## Choose Mode

Ask the user:

> How would you like to run the review?
>
> - **[A] Subagent** (recommended) — Delegates to the `spec-reviewer` agent for a full automated review. Returns a structured report.
> - **[B] Interactive** — Loads the review skill and walks through each check category with you, discussing findings as they emerge.

## Mode A: Subagent

1. Delegate to the `spec-reviewer` subagent, passing the spec file path.
2. When the subagent returns, present the full report to the user.
3. Ask if they want to drill into any specific finding or re-run a particular check category.

## Mode B: Interactive

1. Load the `spec/review` skill for reference on check categories and algorithms.
2. Walk through each check category one at a time:
   - **Term Registry** — Build and display the term table. Ask the user to confirm or adjust.
   - **Consistency** — Run consistency checks, present findings, discuss.
   - **Stale References** — Identify and verify references, present findings.
   - **Contamination** — Run contamination patterns, present matches for user judgment.
   - **Structure** — Assess document structure, present observations.
3. After all categories, compile the final report using the report template.
4. Present the report and ask if any findings should be adjusted before finalizing.
