---
name: confluence
description: >
  Manage Confluence pages at yourcompany.atlassian.net via the REST API v2. Use this skill
  whenever the user wants to fetch, view, search, create, edit, or update a Confluence page —
  including pasting a Confluence URL and asking to edit it, asking about page content, listing
  pages in a space, or pushing local changes back. Trigger on any mention of Confluence pages,
  Confluence URLs (yourcompany.atlassian.net/wiki), page IDs, Confluence spaces, or requests like
  "update the confluence page", "fetch the PRD from confluence", "push my changes to confluence".
  Also trigger when the user asks to create a new Confluence page or search for existing pages.
---

# Confluence Skill

You are working in an Atlassian PM workspace. Confluence is managed entirely via the **REST API v2** — ACLI does NOT support Confluence.

## Auth

Credentials and instance URL are read from environment variables. Users must set these in their shell profile (see README for setup):

```bash
# Read credentials from environment (set in ~/.zshrc, ~/.bashrc, etc.)
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-yourcompany.atlassian.net}"
```

If the env vars are not available in the subprocess, fall back to reading from the shell profile:

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc ~/.bash_profile 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"
```

- Base URL: `https://${ATLASSIAN_INSTANCE}/wiki/api/v2`
- Auth header: `-u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN"`
- **Always use v2 API** — v1 (`/wiki/rest/api`) returns 401

## Extract Page ID from URL

When the user pastes a Confluence URL, the page ID is the numeric segment:

```
https://{instance}/wiki/spaces/myproject/pages/3711631361/Page+Title
                                               ^^^^^^^^^^^
                                               This is the page ID
```

---

## Core Workflows

### 1. Fetch & Edit a Page (Most Common)

Use when the user shares a Confluence URL or page ID and wants to view or edit it.

**Step 1 — Fetch and save locally:**

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"
PAGE_ID="<id>"
SLUG="<descriptive-slug>"  # e.g. PRD-AI-Agent-Platform or Functional-Requirements

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/pages/$PAGE_ID?body-format=storage" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
body = d['body']['storage']['value']
title = d['title']
version = d['version']['number']
print(f'Title: {title}')
print(f'Version: {version}')
open(f'Confluence/$SLUG.html', 'w').write(body)
print('Saved.')
"
```

The storage XHTML is saved to `Confluence/<slug>.html` in the workspace root.

**Step 2 — Edit:**

Edit the `.html` file directly using the Edit tool. Confluence storage format is XHTML — use standard HTML tags (`<p>`, `<h1>`, `<ul>`, `<li>`, `<table>`, `<ac:structured-macro>` for Confluence macros).

**Step 3 — Push back:**

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/push-confluence-page.sh Confluence/<slug>.html <PAGE_ID> "brief description of changes"
```

The push script handles version incrementing automatically.

---

### 2. List Pages in a Space

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/spaces/<spaceId>/pages?limit=50" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for p in d.get('results', []):
    print(f\"{p['id']}\t{p['title']}\")
"
```

To get the spaceId for your confluence, use the List Spaces command below first.

---

### 3. List Spaces

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

---

### 4. Search Pages (CQL)

Use CQL (Confluence Query Language) to search by title or content. Note: search uses the v1 endpoint (the v2 search endpoint is not fully available).

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"
QUERY="<search term>"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/wiki/rest/api/content/search?cql=space=space+AND+title+~+\"$QUERY\"&limit=10" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for r in d.get('results', []):
    print(f\"{r['id']}\t{r['title']}\")
"
```

---

### 5. Get Child Pages

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/pages/<id>/children" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for p in d.get('results', []):
    print(f\"{p['id']}\t{p['title']}\")
"
```

---

### 6. Create a New Page

Build the payload and POST it:

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

python3 -c "
import json
payload = {
    'spaceId': '<spaceId>',
    'parentId': '<parent-page-id>',   # optional; omit if top-level
    'title': 'Page Title Here',
    'body': {
        'representation': 'storage',
        'value': '<p>Your HTML content here.</p>'
    }
}
json.dump(payload, open('/tmp/cf_create.json', 'w'))
print('Payload written.')
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/cf_create.json \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/pages" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'id' in d:
    print(f\"Created page ID: {d['id']}\")
    print(f\"Title: {d['title']}\")
else:
    print('Error:', json.dumps(d, indent=2))
"
```

---

### 7. Delete a Page

Always confirm with the user before deleting.

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X DELETE \
  "https://$ATLASSIAN_INSTANCE/wiki/api/v2/pages/<id>"
```

---

## Output Conventions

- **List pages/spaces** → display as a markdown table with columns: ID | Title
- **Fetch page** → confirm title, version, and local save path
- **Push page** → confirm new version number and URL
- **Create page** → confirm new page ID and URL
- **Errors** → show the HTTP status code and the API error message

## Key Facts

- Instance: configured via `$ATLASSIAN_INSTANCE` env var (defaults to `yourcompany.atlassian.net`)
- Local workspace: `Confluence/` in the project root
- Push script: `${CLAUDE_PLUGIN_ROOT}/scripts/push-confluence-page.sh <file.html> <page_id> "message"` (auto-increments version)
- Storage format is XHTML — edit with standard HTML tags
- `status: "current"` is required in update payloads — omitting it returns 400
