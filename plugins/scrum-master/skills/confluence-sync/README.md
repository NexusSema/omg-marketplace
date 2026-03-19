# Confluence Sync Skill for Claude Code

A Claude Code skill for bidirectional sync between local Markdown files and Confluence pages — push `.md` → Confluence and pull Confluence → `.md`.

> **Requires:** Claude Code CLI installed and authenticated. Part of the Scrum Master plugin (`/sm:sync-docs`).

---

## Prerequisites

The sync skill uses the same Atlassian credentials as the Jira and Confluence skills. If you've already set up credentials for those, you're ready to go.

If not, see the [Jira README](../jira/README.md) for credential setup instructions.

**Required environment variables:**
```bash
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_token_here"
export ATLASSIAN_INSTANCE="yourcompany.atlassian.net"  # optional
```

---

## Frontmatter Format

Every markdown file that syncs with Confluence needs YAML frontmatter:

```yaml
---
confluence_title: "My Page Title"
confluence_space_id: "12345"
confluence_parent_id: "67890"
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `confluence_title` | Yes | Page title on Confluence |
| `confluence_space_id` | For new pages | Space ID — run `/sm:sync-docs` → Status to find it |
| `confluence_parent_id` | No | Parent page ID for page hierarchy |
| `confluence_page_id` | Auto-set | Added automatically after first push |
| `confluence_version` | Auto-set | Tracks last-synced version (set by pull) |

---

## Usage Examples

### Push a Markdown File to Confluence

> "Push docs/architecture.md to Confluence"

Claude will:
1. Read the frontmatter for target page info
2. Convert markdown to Confluence XHTML
3. Create a new page (or update existing if `confluence_page_id` is set)
4. Return the page URL

### Pull a Confluence Page as Markdown

> "Pull Confluence page 3711631361 as markdown"

or

> "Pull this page as .md: https://yourcompany.atlassian.net/wiki/spaces/PROJ/pages/3711631361"

Claude will:
1. Fetch the page content
2. Convert XHTML to markdown
3. Add frontmatter with page metadata
4. Save the `.md` file locally

### Batch Push

> "Push all markdown files in docs/ to Confluence"

Each file must have proper frontmatter. Claude will push them one by one and report results.

### Check Sync Status

> "List my Confluence spaces" or "What pages are in space 12345?"

Use this to find space IDs and page IDs for your frontmatter.

---

## How Conversion Works

### Push (Markdown → Confluence)

The converter handles:
- Headings (`#` → `<h1>`)
- Bold, italic, inline code
- Ordered and unordered lists (including nested)
- Tables
- Code blocks → Confluence code macros with language highlighting
- Links and images
- Horizontal rules

### Pull (Confluence → Markdown)

The converter handles:
- Headings, bold, italic, inline code
- Lists (ordered and unordered)
- Tables
- Code macros → fenced code blocks
- Links and images
- Unknown macros → HTML comments (preserved for round-trip)

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `confluence_title not found` | Add YAML frontmatter with `confluence_title` to your `.md` file |
| `confluence_space_id required` | Add `confluence_space_id` to frontmatter — use List Spaces to find it |
| `401 Unauthorized` | Check API token — regenerate at `id.atlassian.com` |
| `400 Bad Request` on update | The page may have been updated on Confluence — pull first, then push |
| Missing content after pull | Some Confluence macros (e.g., Jira issue macro) can't be converted to markdown — they're preserved as HTML comments |
| Code blocks look wrong | Ensure code is in Confluence code macros, not plain `<pre>` tags |

---

## Notes

- **Same credentials** — Uses `ATLASSIAN_EMAIL`, `ATLASSIAN_API_TOKEN`, `ATLASSIAN_INSTANCE`
- **Python3 stdlib only** — No pip dependencies needed for conversion
- **Round-trip safe** — Unknown Confluence macros are preserved as HTML comments during pull, so they won't be lost on re-push
- **API version** — Uses Confluence REST API v2 (`/wiki/api/v2`)
