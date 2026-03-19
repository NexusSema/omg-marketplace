---
description: "Manage Jira issues, sprints, and boards — create, update, transition, search, and manage sprints."
---

# Jira

You are starting the **Jira** workflow — managing Jira issues, sprints, and boards via the Jira REST API v3 and Agile API.

Load the `jira` skill for API reference, auth patterns, and workflow instructions.

## Setup

1. **Verify credentials** — Check that the required environment variables are available:
   - `ATLASSIAN_EMAIL` — Atlassian account email
   - `ATLASSIAN_API_TOKEN` — API token from id.atlassian.com
   - `ATLASSIAN_INSTANCE` — Atlassian instance hostname (optional, defaults to `yourcompany.atlassian.net`)

   If not set, tell the user to configure them (see README).

2. **Quick start — fetch My Issues first:**

   Before showing the menu, automatically fetch the user's current issues using workflow 16 (My Issues). This gives immediate context. Display results as a markdown table.

3. **Then present menu:**

   "What would you like to do?

   **[M] My Issues** — Refresh my assigned issues (current sprint / all open)
   **[I] Issue CRUD** — Create, read, update, or delete Jira issues (Epic, Story, Task, Bug, Sub-task)
   **[C] Create sub-tasks** — Create sub-tasks under a parent issue (with structured format)
   **[T] Transition** — Move an issue to a different status (e.g., To Do → In Progress → Done)
   **[S] Search (JQL)** — Search for issues using JQL queries
   **[P] Sprint management** — List sprints, view sprint issues, move issues to a sprint
   **[B] Board / Backlog** — List boards, view backlog items
   **[K] Bulk create** — Create multiple issues at once
   **[L] Link issues** — Create relationships between issues (blocks, relates to, duplicates)
   **[A] Attach link** — Add a Confluence page URL or external link to a Jira issue
   **[R] Remote links** — View external links attached to an issue"

4. **Route based on choice** — Follow the corresponding workflow from the `jira` skill.

## Workflow Details

### My Issues ([M]) — Default Action
- Automatically runs on command start (no menu selection needed).
- Uses workflow 16 — `assignee = currentUser() AND sprint in openSprints()`.
- Shows: Key | Type | Status | Priority | Summary | Parent | Sub-task count.
- After displaying, user can pick an issue key to drill into (view details, create sub-tasks, transition, etc.).
- Variations: "show all my open issues" → `assignee = currentUser() AND status != Done`.

### Issue CRUD ([I])
- **Create**: Ask for project, issue type, summary, description. Run createmeta first to discover valid issue types and custom fields. Build ADF description. Confirm before submitting.
- **Read**: Ask for issue key or URL. Fetch and display issue details, including sub-tasks and remote links.
- **Update**: Ask for issue key and fields to change. Submit update.

### Create Sub-tasks ([C])
- Ask for the parent issue key (or let user pick from My Issues list).
- Fetch and display the parent issue to confirm context.
- Ask how many sub-tasks to create and their summaries.
- For each sub-task, build a structured description with:
  - **Acceptance Criteria** section (bullet list)
  - Any additional fields the user specifies
- Create sub-tasks one by one (or bulk if >3), confirming each key and URL.
- After creation, show the updated parent with all sub-tasks listed.

### Transition ([T])
- Ask for issue key (or pick from My Issues). Fetch available transitions. Let user pick. Execute.

### Search ([S])
- Ask what they're looking for. Build JQL query. Display results as a markdown table.

### Sprint Management ([P])
- Ask for board (list boards if needed). Show sprints. View sprint issues or move issues to a sprint.

### Board / Backlog ([B])
- List boards. Select a board. View backlog items.

### Bulk Create ([K])
- Ask for project, issue type, and list of summaries/descriptions. Build bulk payload. Confirm count before submitting.

### Link Issues ([L])
- Ask for two issue keys and the link type. Discover available link types if needed. Create the link.

### Attach Link ([A])
- Ask for the Jira issue key and the URL to attach (e.g., a Confluence page URL).
- Ask for a link title (e.g., "Architecture Document", "PRD", "Sprint Retro Notes").
- Uses workflow 18 (Add Remote Link) to attach the URL to the issue.
- Confirm: "Link added to PROJ-123: Architecture Document".
- **Cross-workflow**: After `/sm:sync-docs` pushes a doc to Confluence, the user can immediately use this to attach the resulting URL to a Jira issue.

### Remote Links ([R])
- Ask for issue key. List all remote links (Confluence pages, external URLs) on the issue.

## Important

- Always use the `jira` skill's auth pattern to read credentials
- Always run createmeta to discover issue types and custom fields before creating issues
- Use ADF format for description and comment bodies
- Display search results as markdown tables
- Confirm with the user before bulk operations
- When creating sub-tasks, always include an Acceptance Criteria section in the description
- After syncing a doc to Confluence, remind the user they can attach the link to a Jira issue via [A]
