# Confluence Skill for Claude Code

A Claude Code skill that lets you manage Confluence pages using plain language — no manual `curl` commands needed.

> **Requires:** Claude Code CLI installed and authenticated. Part of the SDLC plugin (`/sdlc:confluence`).

---

## 1. Get Your API Token

1. Go to **[id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)**
2. Click **Create API token**
3. Give it a name (e.g. `claude-code`) and click **Create**
4. Copy the token — you won't be able to see it again

---

## 2. Store Your Credentials

The skill reads credentials from your shell profile at runtime. Add these two lines to your shell's startup file, then reload it.

**macOS (zsh — default since macOS Catalina):** `~/.zshrc`
**macOS (bash):** `~/.bash_profile`
**Linux (bash):** `~/.bashrc`
**Windows (Git Bash):** `~/.bashrc`
**Windows (WSL):** `~/.bashrc` inside your WSL distro

```bash
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_token_here"
export ATLASSIAN_INSTANCE="yourcompany.atlassian.net"  # optional, defaults to onemount.atlassian.net
```

After editing, reload the file (or restart your terminal):

```bash
# macOS zsh
source ~/.zshrc

# macOS/Linux bash
source ~/.bashrc   # or ~/.bash_profile

# Windows WSL
source ~/.bashrc
```

> **Note for Windows (native):** If you're not using WSL or Git Bash, set the variables as User Environment Variables via **System Properties → Environment Variables**, then restart your terminal.

> **Why not just `export` in the terminal?** Claude Code runs in a subprocess that doesn't inherit your session's environment. Storing them in your shell profile ensures the skill can read them every time.

---

## 3. Verify It Works

Run this in your terminal to confirm the credentials are correct:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://${ATLASSIAN_INSTANCE:-onemount.atlassian.net}/wiki/api/v2/spaces?limit=1" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('Connected:', d['results'][0]['name'])"
```

Expected output: `Connected: <your space name>`

If you see `401 Unauthorized`, double-check the token and email in your shell profile.

---

## 4. What You Can Do

Use `/sdlc:confluence` to start the workflow, or just describe what you want — the skill triggers automatically when you mention Confluence pages or paste URLs.

### Fetch & Edit a Page

Paste a Confluence URL and tell Claude what to change:

> "Fetch this page and update section 3 with the new requirements: https://yourcompany.atlassian.net/wiki/spaces/PROJ/pages/123456789/My-Page"

Claude will:
1. Extract the page ID from the URL
2. Fetch and save the page locally as `Confluence/<page-title>.html`
3. Make your edits directly to the file
4. Push the updated content back to Confluence (auto-increments version)

---

### List Pages in a Space

> "List all pages in a Confluence space"

Returns a table of page IDs and titles.

---

### Search for a Page

> "Find the Confluence page about the AI Agent Platform PRD"

Uses CQL (Confluence Query Language) to search by title within a space.

---

### Create a New Page

> "Create a new Confluence page called 'Sprint 12 Retrospective' with a template for wins, blockers, and action items"

Claude will build and POST the page, then return the new page ID and URL.

---

### Get Child Pages

> "What are the child pages under Confluence page 3711631361?"

Returns a table of child page IDs and titles.

---

### Delete a Page

> "Delete Confluence page 3711631361"

Claude will ask for confirmation before deleting.

---

## 5. Local File Workflow

When Claude fetches a page, it saves the content as Confluence storage XHTML in your workspace:

```
Confluence/
├── My-Page.html         ← fetched page (editable)
└── ...
```

You can also edit `.html` files manually in VSCode, then push back via the `/sdlc:confluence` Push option.

**Tip:** Install the **Live Preview** VSCode extension (`ms-vscode.live-server`) and right-click any `.html` file → **Show Preview** to see a live render before pushing.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `401 Unauthorized` | Token is wrong or expired — regenerate at `id.atlassian.com` |
| `400 Bad Request` on update | The `status: "current"` field is missing from payload (handled automatically by `push_page.sh`) |
| `curl: command not found` | Install curl: `brew install curl` |
| Skill doesn't trigger | Run `/sdlc:confluence` or restart Claude Code |
| Wrong version number on push | Always use `push_page.sh` — it fetches the current version first |

---

## Notes

- **API version:** Always v2 (`/wiki/api/v2`) — v1 returns 401 on this instance
- **Exception:** CQL search uses the v1 endpoint (`/wiki/rest/api/content/search`) — this is intentional
- **Default space:** Searches scope to the space you specify
- **Storage format:** Confluence pages use XHTML storage format — edit with standard HTML tags (`<p>`, `<h1>`, `<ul>`, `<table>`) plus Confluence macros (`<ac:structured-macro>`)
