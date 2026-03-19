---
description: "Sync markdown documents to/from Confluence — convert .md ↔ Confluence XHTML, push and pull pages."
---

# Sync Docs

You are starting the **Sync Docs** workflow — bidirectional sync between local Markdown files and Confluence pages.

Load the `confluence-sync` skill for conversion reference, frontmatter conventions, and workflow instructions.

## Setup

1. **Verify credentials** — Check that the required environment variables are available:
   - `ATLASSIAN_EMAIL` — Atlassian account email
   - `ATLASSIAN_API_TOKEN` — API token from id.atlassian.com
   - `ATLASSIAN_INSTANCE` — Atlassian instance hostname (optional, defaults to `yourcompany.atlassian.net`)

   If not set, tell the user to configure them (see README).

2. **Present menu:**

   "What would you like to do?

   **[P] Push** — Push a local `.md` file to Confluence (create or update)
   **[U] Pull** — Pull a Confluence page and save as `.md` with frontmatter
   **[B] Batch push** — Push all `.md` files in a directory to Confluence
   **[S] Status** — List Confluence spaces and pages to find IDs for frontmatter"

3. **Route based on choice** — Follow the corresponding workflow below.

## Workflow Details

### Push ([P])

1. Ask the user for the markdown file path
2. Read the file and check for YAML frontmatter
3. If frontmatter is missing or incomplete:
   - Ask for `confluence_title`
   - Ask for `confluence_space_id` (offer to list spaces if they don't know it)
   - Optionally ask for `confluence_parent_id`
   - Write the frontmatter into the file
4. Run the push script:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/push-md-to-confluence.sh <file.md> "description"
   ```
5. Confirm: page title, version, and URL
6. If new page was created, confirm that `confluence_page_id` was written back to frontmatter
7. **Offer to link back to Jira**: "Would you like to attach this Confluence page to a Jira issue? If so, provide the issue key (e.g., PROJ-123)."
   - If yes, use the `jira` skill's workflow 18 (Add Remote Link) to attach the Confluence URL to the Jira issue
   - Confirm: "Link added to PROJ-123: {confluence_title}"

### Pull ([U])

1. Ask the user for a Confluence page ID or URL
2. If URL, extract the page ID from the URL path
3. Ask for output file path (or use default based on page title)
4. Run the pull script:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/pull-confluence-to-md.sh <page_id> [output.md]
   ```
5. Confirm: page title, version, and saved file path
6. Offer to open/display the file

### Batch Push ([B])

1. Ask the user for the directory path
2. List all `.md` files in the directory
3. Check each file for valid frontmatter — report any missing fields
4. Confirm the batch operation with the user (show file count)
5. Push each file:
   ```bash
   for f in <directory>/*.md; do
     ${CLAUDE_PLUGIN_ROOT}/scripts/push-md-to-confluence.sh "$f" "Batch sync"
   done
   ```
6. Report results: successes, failures, and URLs

### Status ([S])

1. List Confluence spaces (to help find `confluence_space_id`):
   ```bash
   curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
     "https://$ATLASSIAN_INSTANCE/wiki/api/v2/spaces" \
     | python3 -c "
   import json, sys
   d = json.load(sys.stdin)
   for s in d.get('results', []):
       print(f\"{s['id']}\t{s['key']}\t{s['name']}\")
   "
   ```
2. Optionally list pages in a space to find page IDs

## Cross-workflow: Push + Link to Jira

A common pattern is: push a doc to Confluence, then attach the URL to a Jira issue. After a successful push, this command offers to do the link-back automatically using the `jira` skill's Remote Link API. The user just provides the Jira issue key.

This also works from `/sm:jira` → [A] Attach link, where the user can manually attach any URL to an issue.

## Important

- Always use the `confluence-sync` skill's auth pattern to read credentials
- Every synced `.md` file must have YAML frontmatter with at least `confluence_title`
- New pages require `confluence_space_id` in frontmatter
- After first push, `confluence_page_id` is written back into the frontmatter automatically
- The converter uses Python3 stdlib only — no pip dependencies
- Unknown Confluence macros are preserved as HTML comments during pull
- After pushing, offer to link the Confluence page to a Jira issue
