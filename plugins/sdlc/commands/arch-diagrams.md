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

4. **Discover Shard Documents**:

   Glob for `0[1-7]-*.md` files in the shard directory. List them to the user with their filenames.

5. **Ask User Preference**:

   "How would you like to generate diagrams?

   **[A] Sequential** — Process one file at a time. A `c4-diagram-generator` subagent is spawned for each file sequentially. You see results per file before moving to the next. Good for reviewing output as it's produced.

   **[B] Parallel (Recommended)** — Fork a team of `c4-diagram-generator` subagents — one per file, all running simultaneously. Fastest option. Each subagent returns its own summary, which is combined into a final table.

   **[C] Interactive** — Process documents one at a time in this conversation. You'll see the identified diagram types and generated draw.io XML before it's written. You can adjust or skip individual diagrams."

6. **Route Based on Choice**:

   - **If A (Sequential)**: For each shard document found in step 4:
     1. Spawn a `c4-diagram-generator` subagent with the **single file path**
     2. Wait for it to complete and present its summary table to the user
     3. Ask user to continue to next file or stop
     4. After all files, show combined summary table

   - **If B (Parallel)**: Spawn **all** `c4-diagram-generator` subagents simultaneously — one per shard document file. Use **parallel Agent tool calls in a single message** so they run concurrently. Each subagent receives a single file path. After all complete, combine their summary tables into one final table and present to the user.

     Example orchestration (for 6 files with diagrammable content):
     ```
     # All launched in a single message with parallel tool calls:
     Agent(c4-diagram-generator, "Generate diagrams for path/to/01-high-level-design.md")
     Agent(c4-diagram-generator, "Generate diagrams for path/to/03-detailed-design.md")
     Agent(c4-diagram-generator, "Generate diagrams for path/to/04-sequence-diagrams.md")
     Agent(c4-diagram-generator, "Generate diagrams for path/to/05-deployment-architecture.md")
     Agent(c4-diagram-generator, "Generate diagrams for path/to/06-network-architecture.md")
     Agent(c4-diagram-generator, "Generate diagrams for path/to/07-database-design.md")
     ```

     Skip files that are unlikely to produce diagrams (e.g. `02-tech-stack-vendor-assessment.md` which is typically tables only), but mention them in the summary as skipped.

   - **If C (Interactive)**: Load the `architecture/diagrams` skill. For each shard document:
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

- Sequential mode gives you per-file review before proceeding
- Parallel mode is fastest — spawns all subagents at once, each handling one file
- Interactive mode gives you full control over which diagrams to generate and lets you review each one
- Speak in the configured `{communication_language}`
- Diagram labels should use `{document_output_language}`
- If a shard document has no diagrammable content (e.g., only comparison tables), skip it with a note
- Generated `.drawio` files are placed in the same directory as the source shard documents
