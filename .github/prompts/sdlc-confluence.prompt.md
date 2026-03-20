---
description: "Manage Confluence pages — fetch, edit, push, search, create, and list pages via the Atlassian REST API."
agent: agent
---

# Confluence

You are starting the **Confluence** workflow — managing Confluence pages via the Atlassian REST API v2.

Load the `confluence` skill for API reference, auth patterns, and workflow instructions.

## Setup

1. **Verify credentials** — Check that the required environment variables are available:
   - `ATLASSIAN_EMAIL` — Atlassian account email
   - `ATLASSIAN_API_TOKEN` — API token from id.atlassian.com
   - `ATLASSIAN_INSTANCE` — Atlassian instance hostname (optional, defaults to `yourcompany.atlassian.net`)

   If not set, tell the user to configure them (see README).

2. **Present menu:**

   "What would you like to do?

   **[F] Fetch & Edit** — Fetch a Confluence page by URL or page ID, save locally, edit, and push back
   **[L] List** — List pages in a space or child pages of a page
   **[S] Search** — Search for pages by title or content (CQL)
   **[C] Create** — Create a new Confluence page
   **[P] Push** — Push a local `.html` file back to Confluence
   **[D] Delete** — Delete a Confluence page (with confirmation)"

3. **Route based on choice** — Follow the corresponding workflow from the `confluence` skill.

## SDLC Integration

You can also use Confluence with other SDLC workflows:

- **Push a local artifact to Confluence** — Convert a markdown file (PRD, architecture doc, epics) to Confluence storage XHTML and create/update a page. Use this after completing a workflow like `/sdlc:prd-create` or `/sdlc:arch-create`.

  To convert markdown to Confluence XHTML:
  1. Read the markdown file
  2. Convert headings, lists, tables, code blocks to equivalent HTML tags
  3. Write as `.html` in `Confluence/` directory
  4. Push using the push script

- **Fetch a PRD/Architecture doc from Confluence** — Fetch a page, convert storage XHTML to markdown, and save to `{planning_artifacts}/` for use with SDLC workflows.

## Important

- Always use the `confluence` skill's auth pattern to read credentials
- Local files are saved to `Confluence/` in the project root
- Storage format is XHTML — use standard HTML tags plus Confluence macros (`<ac:structured-macro>`)
- Always confirm with the user before deleting pages
- The push script auto-increments page versions
