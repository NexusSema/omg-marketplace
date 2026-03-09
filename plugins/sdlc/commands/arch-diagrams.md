---
description: "Generate styled draw.io (.drawio) files from architecture shard document content with C4 conventions."
---

# Generate Architecture Diagrams

You are starting the **Generate Architecture Diagrams** workflow — generating professionally styled draw.io `.drawio` files by analyzing the content of architecture shard documents directly. Do NOT rely on Mermaid code blocks — they are often messy and unreliable. Instead, read the prose, tables, and descriptions to design diagrams from scratch.

## Setup

1. **Language Preferences** *(always ask before anything else)*:

   Ask the user:

   "Before we begin, let me confirm your language preferences:

   1. **Communication language** — What language should I speak to you in? (e.g. English, Vietnamese, French...)
   2. **Document output language** — What language should the diagram labels be written in? (e.g. English, Vietnamese, French...)

   *(Press Enter to use English for both, or specify your preferences.)*"

   Store the answers as `{communication_language}` and `{document_output_language}`. From this point forward, speak to the user in `{communication_language}` and write all diagram labels in `{document_output_language}`.

2. **Load Configuration**: Read `{project-root}/_bmad/bmm/config.yaml` if it exists. Resolve:
   - `project_name`, `output_folder`, `planning_artifacts`, `user_name`, `user_skill_level`
   - `date` as system-generated current datetime
   - Use language preferences from step 1 (override config values if user provided them)

3. **Locate Shard Documents**: Ask the user for the directory containing the architecture shard documents (files named `01-*.md` through `07-*.md`). If `output_folder` and `planning_artifacts` are configured, suggest the default path: `{output_folder}/{planning_artifacts}/architecture/`.

4. **Ask User Preference**:

   "How would you like to generate diagrams?

   **[A] Subagent (Recommended)** — Delegate to the c4-diagram-generator subagent for batch processing. All documents are analyzed and diagrams generated automatically. Returns a summary without polluting your main conversation context.

   **[B] Interactive** — Process documents one at a time in this conversation. You'll see the identified diagram types and generated draw.io XML before it's written. You can adjust or skip individual diagrams."

5. **Route Based on Choice**:

   - **If A (Subagent)**: Delegate to the `c4-diagram-generator` subagent with the shard document directory path. Present the returned summary table to the user.

   - **If B (Interactive)**: Load the `architecture/diagrams` skill. For each shard document:
     1. Read the document content and identify what diagrams should be generated based on the subject matter
     2. Ask the user which diagrams to generate (all, select by number, or skip)
     3. For each selected diagram:
        - Show the identified diagram type and the key entities/relationships extracted from the content
        - Generate the draw.io XML following the skill's conversion methodology
        - Write the `.drawio` file
        - Run visual validation if draw.io CLI is available:
          - Export to PNG at 2× scale
          - Inspect the PNG for visual defects (see `references/visual-validation-guide.md`)
          - If issues found, apply fixes and re-export (up to 3 iterations total)
        - Report: filename, node count, edge count, Visual QA result
     4. After all documents are processed, show the summary table (including Visual QA column)

## Important

- The subagent option processes all diagrams in batch (recommended for most cases)
- Interactive mode gives you control over which diagrams to generate and lets you review each one
- Speak in the configured `{communication_language}`
- Diagram labels should use `{document_output_language}`
- If a shard document has no diagrammable content (e.g., only comparison tables), skip it with a note
- Generated `.drawio` files are placed in the same directory as the source shard documents
