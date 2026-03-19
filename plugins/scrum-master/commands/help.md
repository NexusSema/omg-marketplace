---
description: "Scrum Master plugin help and documentation"
---

# Scrum Master Plugin — Help

The Scrum Master plugin provides Jira issue tracking, sprint management, and bidirectional markdown-to-Confluence sync via Atlassian REST APIs.

## Available Commands

### Jira

| Command | Description |
|---------|------------|
| `/sm:jira` | Manage Jira issues — auto-fetches your assigned issues, then offers create, update, transition, search, sprints, boards, bulk create, link issues, attach Confluence links |

### Confluence Sync

| Command | Description |
|---------|------------|
| `/sm:sync-docs` | Bidirectional markdown ↔ Confluence sync — push .md → Confluence, pull Confluence → .md, batch push, link back to Jira |

### General

| Command | Description |
|---------|------------|
| `/sm:help` | Show this help information |

## Typical Workflows

### "Show me my tickets, then let me work on them"
1. `/sm:jira` → auto-fetches your sprint issues
2. Pick an issue → view details, create sub-tasks, transition status

### "Create sub-tasks under a story"
1. `/sm:jira` → [C] Create sub-tasks → provide parent key
2. Each sub-task gets structured description with Acceptance Criteria

### "Push a doc to Confluence and link it to a Jira ticket"
1. `/sm:sync-docs` → [P] Push → converts .md → Confluence page
2. After push, offer to attach the URL to a Jira issue (auto-prompted)

### "Attach a Confluence page to a Jira issue"
1. `/sm:jira` → [A] Attach link → provide issue key + Confluence URL

## Skills

**jira/**
- **jira** — Reference-library skill with Jira REST API v3 and Agile API templates for full issue lifecycle management (CRUD, transitions, JQL search, sprints, boards, bulk create, issue links), My Issues quick-start, sub-task creation with structured format, remote links (attach Confluence URLs), ADF document format reference, and custom field discovery workflow.

**confluence-sync/**
- **confluence-sync** — Reference-library skill for bidirectional markdown ↔ Confluence sync with frontmatter conventions, push/pull workflows, batch operations, XHTML ↔ Markdown conversion reference, and cross-workflow Jira link-back.

## Scripts

| Script | Description |
|--------|------------|
| `md-to-confluence-storage.sh` | Convert a Markdown file to Confluence storage XHTML |
| `push-md-to-confluence.sh` | End-to-end push: convert .md → XHTML → create/update Confluence page |
| `pull-confluence-to-md.sh` | Pull a Confluence page and convert to .md with frontmatter |

## Hooks

- **Stop** — Verifies that the scrum master task completed successfully.

## Setup

All commands use the same Atlassian credentials:

```bash
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your_token_here"
export ATLASSIAN_INSTANCE="yourcompany.atlassian.net"
```

See the Jira or Confluence Sync README for detailed setup instructions.
