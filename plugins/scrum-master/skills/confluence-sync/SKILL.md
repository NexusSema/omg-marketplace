---
name: confluence-sync
description: >
  Bidirectional sync between local Markdown files and Confluence pages. Use this skill when the
  user wants to push a .md file to Confluence, pull a Confluence page as .md, batch-push a
  directory of markdown files, or check sync status. Trigger on requests like "push this doc
  to Confluence", "pull the PRD from Confluence as markdown", "sync docs to Confluence",
  "convert this markdown to a Confluence page", or "batch push all docs".
---

# Confluence Sync Skill

Bidirectional sync between local Markdown (`.md`) files and Confluence pages. Converts markdown ↔ Confluence storage XHTML and manages page creation/updates via the REST API v2.

## Auth

Same Atlassian credentials as all other Atlassian skills:

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"
```

## Frontmatter Convention

Every synced `.md` file uses YAML frontmatter to track its Confluence target:

```yaml
---
confluence_title: "Page Title"
confluence_space_id: "12345"
confluence_parent_id: "67890"
confluence_page_id: "11111"
confluence_version: 3
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `confluence_title` | Yes | Page title on Confluence |
| `confluence_space_id` | For create | Numeric space ID (use List Spaces to find it) |
| `confluence_parent_id` | No | Parent page ID (omit for top-level pages) |
| `confluence_page_id` | For update | Set automatically after first push; if present, updates instead of creates |
| `confluence_version` | No | Tracks the last-synced version (set by pull) |

---

## Push Workflow (.md → Confluence)

Convert a local markdown file to Confluence XHTML and create or update a page.

### Single File Push

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/push-md-to-confluence.sh <file.md> "description of changes"
```

The script:
1. Reads frontmatter from the `.md` file
2. Calls `md-to-confluence-storage.sh` to convert → XHTML
3. If `confluence_page_id` is set → fetches current version, increments, PUTs update
4. If no page ID → POSTs new page using `confluence_space_id`
5. On new page creation → writes `confluence_page_id` back into the frontmatter
6. Outputs: page title, version, and URL

### Manual Push Steps (without script)

If you need more control, you can push manually:

**Step 1 — Convert markdown to XHTML:**

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/md-to-confluence-storage.sh <file.md> /tmp/output.html
```

**Step 2 — Create or update the page using the Confluence API** (see the confluence skill in the SDLC plugin for raw API templates).

---

## Pull Workflow (Confluence → .md)

Fetch a Confluence page and convert it to a local markdown file with frontmatter.

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/pull-confluence-to-md.sh <page_id> [output.md]
```

The script:
1. Fetches the page via REST API v2 (`?body-format=storage`)
2. Converts XHTML → markdown (headings, lists, tables, code macros, links, bold/italic)
3. Injects frontmatter: `confluence_page_id`, `confluence_space_id`, `confluence_title`, `confluence_version`
4. Unknown Confluence macros → preserved as HTML comments (`<!-- Confluence macro: name -->`)
5. If no output path given, generates filename from page title

---

## Batch Push

Push all `.md` files in a directory to Confluence:

```bash
for f in <directory>/*.md; do
  echo "--- Pushing: $f ---"
  ${CLAUDE_PLUGIN_ROOT}/scripts/push-md-to-confluence.sh "$f" "Batch sync"
done
```

Each file must have frontmatter with at least `confluence_title` and `confluence_space_id` (for new pages) or `confluence_page_id` (for existing pages).

---

## Conversion Reference

### Markdown → Confluence XHTML

| Markdown | Confluence XHTML |
|----------|-----------------|
| `# Heading 1` | `<h1>Heading 1</h1>` |
| `## Heading 2` | `<h2>Heading 2</h2>` |
| `**bold**` | `<strong>bold</strong>` |
| `*italic*` | `<em>italic</em>` |
| `` `code` `` | `<code>code</code>` |
| `[text](url)` | `<a href="url">text</a>` |
| `![alt](url)` | `<ac:image><ri:url ri:value="url" /></ac:image>` |
| `---` | `<hr />` |
| `- item` | `<ul><li>item</li></ul>` |
| `1. item` | `<ol><li>item</li></ol>` |
| ` ```lang ... ``` ` | `<ac:structured-macro ac:name="code"><ac:parameter ac:name="language">lang</ac:parameter><ac:plain-text-body><![CDATA[...]]></ac:plain-text-body></ac:structured-macro>` |
| `\| a \| b \|` | `<table><tr><td>a</td><td>b</td></tr></table>` |

### Confluence XHTML → Markdown (pull)

| Confluence XHTML | Markdown |
|-----------------|----------|
| `<h1>` – `<h6>` | `#` – `######` |
| `<strong>`, `<b>` | `**text**` |
| `<em>`, `<i>` | `*text*` |
| `<code>` | `` `text` `` |
| `<a href="url">` | `[text](url)` |
| `<ac:image>` | `![image](url)` |
| `<hr />` | `---` |
| `<ul><li>` | `- item` |
| `<ol><li>` | `1. item` |
| Code macro | ` ```lang ... ``` ` |
| `<table>` | Markdown table |
| Unknown macros | `<!-- Confluence macro: name -->` |

---

## Finding Space and Page IDs

**List spaces** (to get `confluence_space_id`):

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/spaces" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for s in d.get('results', []):
    print(f\"{s['id']}\t{s['key']}\t{s['name']}\")
"
```

**Extract page ID from URL:**

```
https://{instance}/wiki/spaces/myproject/pages/3711631361/Page+Title
                                               ^^^^^^^^^^^
                                               This is the page ID
```

---

## Output Conventions

- **Push** → confirm title, version, and URL
- **Pull** → confirm title, version, and saved file path
- **Batch** → show per-file results, then summary count
- **Errors** → show HTTP status code and API error message
