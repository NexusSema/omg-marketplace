# Jira Skill for Claude Code

A Claude Code skill that lets you manage Jira issues, sprints, and boards using plain language — no manual `curl` commands needed.

> **Requires:** Claude Code CLI installed and authenticated. Part of the Scrum Master plugin (`/sm:jira`).

---

## 1. Get Your API Token

The Jira skill uses the same Atlassian credentials as the Confluence skill.

1. Go to **[id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens)**
2. Click **Create API token**
3. Give it a name (e.g. `claude-code`) and click **Create**
4. Copy the token — you won't be able to see it again

---

## 2. Store Your Credentials

Add these lines to your shell's startup file, then reload it.

**macOS (zsh — default since macOS Catalina):** `~/.zshrc`
**macOS (bash):** `~/.bash_profile`
**Linux (bash):** `~/.bashrc`
**Windows (Git Bash):** `~/.bashrc`
**Windows (WSL):** `~/.bashrc` inside your WSL distro

```bash
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_token_here"
export ATLASSIAN_INSTANCE="yourcompany.atlassian.net"  # optional, defaults to yourcompany.atlassian.net
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

> **Why not just `export` in the terminal?** Claude Code runs in a subprocess that doesn't inherit your session's environment. Storing them in your shell profile ensures the skill can read them every time.

---

## 3. Verify It Works

Run this in your terminal to confirm the credentials are correct:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://${ATLASSIAN_INSTANCE:-yourcompany.atlassian.net}/rest/api/3/myself" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'Connected as: {d[\"displayName\"]} ({d[\"emailAddress\"]})')"
```

Expected output: `Connected as: Your Name (your.email@company.com)`

If you see `401 Unauthorized`, double-check the token and email in your shell profile.

---

## 4. What You Can Do

Use `/sm:jira` to start the workflow, or just describe what you want — the skill triggers automatically when you mention Jira issues or paste URLs.

### Create Issues

> "Create a Jira Story in project PROJ: Implement user authentication flow"

Claude will discover valid issue types, build the payload, and create the issue. Returns the issue key and URL.

### Search Issues

> "Find all open bugs in project PROJ"

Uses JQL to search and returns a formatted table of results.

### Update & Transition

> "Move PROJ-123 to In Progress"

Claude will fetch available transitions and execute the right one.

### Sprint Management

> "Show me the current sprint for board 42"
> "Move PROJ-123, PROJ-124, PROJ-125 to sprint 78"

### Bulk Create

> "Create 5 stories for the authentication epic with these titles: ..."

Creates multiple issues in a single API call.

### Link Issues

> "Link PROJ-123 blocks PROJ-456"

Creates issue links with the specified relationship type.

---

## 5. JQL Quick Reference

| Query | Description |
|-------|------------|
| `project = PROJ` | All issues in project |
| `status = "In Progress"` | By status |
| `issuetype = Bug` | By type |
| `assignee = currentUser()` | My issues |
| `sprint in openSprints()` | Current sprint |
| `labels = "backend"` | By label |
| `created >= -7d` | Last 7 days |
| `parent = PROJ-100` | Sub-tasks of issue |
| `priority = High ORDER BY created DESC` | Sorted results |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `401 Unauthorized` | Token is wrong or expired — regenerate at `id.atlassian.com` |
| `400 Bad Request` on create | Run createmeta first to discover valid issue types and required fields |
| `Field 'customfield_XXXXX' cannot be set` | The field doesn't exist or isn't on the create screen — check field metadata |
| `Issue type is not valid` | Use createmeta to discover valid issue types for the project |
| Skill doesn't trigger | Run `/sm:jira` or restart Claude Code |
| `curl: command not found` | Install curl: `brew install curl` |

---

## Notes

- **API version:** REST v3 (`/rest/api/3`) for issue management, Agile 1.0 (`/rest/agile/1.0`) for boards/sprints
- **Rich text:** Jira v3 uses Atlassian Document Format (ADF) for description and comment fields — the skill handles this automatically
- **Custom fields:** Field IDs are instance-specific — always discover via createmeta before using
- **Same credentials:** Uses the same `ATLASSIAN_EMAIL`, `ATLASSIAN_API_TOKEN`, `ATLASSIAN_INSTANCE` as the Confluence skill
