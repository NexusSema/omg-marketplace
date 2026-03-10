# Confluence Skill for Claude Code

A Claude Code skill that lets you manage Confluence pages at `onemount.atlassian.net` using plain language — no manual `curl` commands needed.

> **Requires:** Claude Code CLI installed and authenticated.

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
export ATLASSIAN_EMAIL="john.doe@onemount.com"
export ATLASSIAN_API_TOKEN="your_token_here"
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

## 3. Install the Skill

Copy the skill folder into your Claude skills directory:

```bash
cp -r confluence ~/.claude/skills/
```

Restart Claude Code (or open a new session) — the skill loads automatically.

---

## 4. Verify It Works

Run this in your terminal to confirm the credentials are correct:

```bash
ATLASSIAN_EMAIL="john.doe@onemount.com"
ATLASSIAN_API_TOKEN="$(grep ATLASSIAN_API_TOKEN ~/.zshrc | head -1 | sed 's/.*=\"//;s/\"//')"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://onemount.atlassian.net/wiki/api/v2/spaces?limit=1" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('Connected:', d['results'][0]['name'])"
```

Expected output:
```
Connected: FDP
```

If you see `401 Unauthorized`, double-check the token value in `~/.zshrc`.

---

## 5. What You Can Do

Once the skill is active, just describe what you want in Claude Code. No slash commands needed — the skill triggers automatically.

### Fetch & Edit a Page

Paste a Confluence URL and tell Claude what to change:

> "Fetch this page and update section 3 with the new requirements: https://onemount.atlassian.net/wiki/spaces/FDP/pages/3711631361/My-Page"

Claude will:
1. Extract the page ID from the URL
2. Fetch and save the page locally as `Confluence/<page-title>.html`
3. Make your edits directly to the file
4. Push the updated content back to Confluence (auto-increments version)

---

### List Pages in a Space

> "List all pages in the FDP Confluence space"

Returns a table of page IDs and titles.

---

### Search for a Page

> "Find the Confluence page about the AI Agent Platform PRD"

Uses CQL (Confluence Query Language) to search by title within the FDP space.

---

### Create a New Page

> "Create a new Confluence page under the FDP space called 'Sprint 12 Retrospective' with a template for wins, blockers, and action items"

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

## 6. Local File Workflow

When Claude fetches a page, it saves the content as Confluence storage XHTML in your workspace:

```
atlassian/
└── Confluence/
    ├── push_page.sh         ← push script (auto-increments version)
    ├── My-Page.html         ← fetched page (editable)
    └── ...
```

You can also edit `.html` files manually in VSCode, then push back with:

```bash
cd atlassian/Confluence
./push_page.sh My-Page.html 3711631361 "Updated section 3"
```

**Tip:** Install the **Live Preview** VSCode extension (`ms-vscode.live-server`) and right-click any `.html` file → **Show Preview** to see a live render before pushing.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `401 Unauthorized` | Token is wrong or expired — regenerate at `id.atlassian.com` |
| `400 Bad Request` on update | The `status: "current"` field is missing from payload (handled automatically by `push_page.sh`) |
| `curl: command not found` | Install curl: `brew install curl` |
| Skill doesn't trigger | Restart Claude Code to reload skills |
| Wrong version number on push | Always use `push_page.sh` — it fetches the current version first |

---

## Notes

- **API version:** Always v2 (`/wiki/api/v2`) — v1 returns 401 on this instance
- **Exception:** CQL search uses the v1 endpoint (`/wiki/rest/api/content/search`) — this is intentional
- **Default space:** FDP — all searches and listings scope to FDP unless you specify otherwise
- **Storage format:** Confluence pages use XHTML storage format — edit with standard HTML tags (`<p>`, `<h1>`, `<ul>`, `<table>`) plus Confluence macros (`<ac:structured-macro>`)
