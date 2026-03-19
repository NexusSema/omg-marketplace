---
name: jira
description: >
  Manage Jira issues, sprints, and boards via the Jira REST API v3 and Agile API. Use this skill
  whenever the user wants to create, update, transition, search, or manage Jira issues — including
  epics, stories, tasks, bugs, and sub-tasks. Trigger on any mention of Jira issues, Jira URLs
  ({instance}/browse/PROJ-123), issue keys, JQL queries, sprints, boards, backlogs, or requests
  like "create a Jira ticket", "move this to In Progress", "search for bugs in PROJ",
  "add to sprint", "link these issues", or "bulk create stories".
---

# Jira Skill

You are working with Jira Cloud via the **REST API v3** for issue management and the **Agile REST API 1.0** for board/sprint operations.

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

- Base URL (issues): `https://${ATLASSIAN_INSTANCE}/rest/api/3`
- Base URL (agile): `https://${ATLASSIAN_INSTANCE}/rest/agile/1.0`
- Auth header: `-u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN"`

## Extract Issue Key from URL

When the user pastes a Jira URL, the issue key is the last path segment:

```
https://{instance}/browse/PROJ-123
                          ^^^^^^^^
                          This is the issue key
```

---

## Core Workflows

### 1. List Projects

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/project" \
  | python3 -c "
import json, sys
projects = json.load(sys.stdin)
for p in projects:
    print(f\"{p['key']}\t{p['name']}\t{p.get('projectTypeKey','')}\")
"
```

---

### 2. Get Create Metadata (Discover Issue Types)

Before creating an issue, discover valid issue types for a project:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/createmeta/$PROJECT_KEY/issuetypes" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for it in d.get('issueTypes', d.get('values', [])):
    print(f\"{it['id']}\t{it['name']}\t{'subtask' if it.get('subtask') else 'standard'}\")
"
```

---

### 3. Get Field Metadata (Discover Required + Custom Fields)

After selecting an issue type, discover required and available fields:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/createmeta/$PROJECT_KEY/issuetypes/$ISSUE_TYPE_ID" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for f in d.get('fields', d.get('values', [])):
    req = 'REQUIRED' if f.get('required') else 'optional'
    print(f\"{f['fieldId']}\t{f['name']}\t{req}\t{f.get('schema',{}).get('type','')}\")
"
```

Use this to discover custom field IDs (e.g., `customfield_10014` for Epic Link) before creating issues.

---

### 4. Create Issue

Supports: Epic, Story, Task, Bug, Sub-task.

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

python3 -c "
import json
payload = {
    'fields': {
        'project': {'key': '<PROJECT_KEY>'},
        'issuetype': {'name': '<Issue Type>'},   # Epic, Story, Task, Bug, Sub-task
        'summary': '<Issue summary>',
        'description': {
            'type': 'doc',
            'version': 1,
            'content': [
                {
                    'type': 'paragraph',
                    'content': [{'type': 'text', 'text': '<Description text>'}]
                }
            ]
        }
        # Add optional/custom fields as needed:
        # 'priority': {'name': 'High'},
        # 'labels': ['backend', 'sprint-12'],
        # 'assignee': {'accountId': '<account_id>'},
        # 'parent': {'key': 'PROJ-100'},          # for Sub-task
        # 'customfield_10014': 'PROJ-50',          # Epic Link (field ID varies)
    }
}
json.dump(payload, open('/tmp/jira_create.json', 'w'))
print('Payload written.')
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_create.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'key' in d:
    print(f\"Created: {d['key']}\")
    print(f\"URL: https://$ATLASSIAN_INSTANCE/browse/{d['key']}\")
    print(f\"ID: {d['id']}\")
else:
    print('Error:', json.dumps(d, indent=2))
    sys.exit(1)
"

rm -f /tmp/jira_create.json
```

---

### 5. Get Issue

```bash
ISSUE_KEY="PROJ-123"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
f = d['fields']
print(f\"Key: {d['key']}\")
print(f\"Summary: {f['summary']}\")
print(f\"Type: {f['issuetype']['name']}\")
print(f\"Status: {f['status']['name']}\")
print(f\"Priority: {f.get('priority',{}).get('name','None')}\")
print(f\"Assignee: {f.get('assignee',{}).get('displayName','Unassigned') if f.get('assignee') else 'Unassigned'}\")
print(f\"Reporter: {f.get('reporter',{}).get('displayName','Unknown')}\")
print(f\"Labels: {', '.join(f.get('labels',[])) or 'None'}\")
print(f\"Created: {f['created']}\")
print(f\"Updated: {f['updated']}\")
# Print description if present
if f.get('description'):
    print(f\"Description: (ADF document - see raw JSON for full content)\")
"
```

---

### 6. Update Issue

```bash
python3 -c "
import json
payload = {
    'fields': {
        'summary': '<New summary>',
        # 'priority': {'name': 'High'},
        # 'labels': ['updated-label'],
        # 'description': { ADF document },
    }
}
json.dump(payload, open('/tmp/jira_update.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X PUT \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_update.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY" \
  -w "\nHTTP Status: %{http_code}\n"

rm -f /tmp/jira_update.json
```

A `204 No Content` response means success.

---

### 7. Transition Issue

First, get available transitions for the issue:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/transitions" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for t in d['transitions']:
    print(f\"{t['id']}\t{t['name']}\t→ {t['to']['name']}\")
"
```

Then execute the transition:

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"transition\": {\"id\": \"$TRANSITION_ID\"}}" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/transitions" \
  -w "\nHTTP Status: %{http_code}\n"
```

A `204 No Content` response means the transition was successful.

---

### 8. Search via JQL

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

python3 -c "
import json
payload = {
    'jql': '<JQL query>',
    'maxResults': 50,
    'fields': ['summary', 'status', 'assignee', 'priority', 'issuetype', 'labels']
}
json.dump(payload, open('/tmp/jira_search.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_search.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/search" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(f\"Total: {d['total']} results\")
for issue in d['issues']:
    f = issue['fields']
    assignee = f.get('assignee',{}).get('displayName','Unassigned') if f.get('assignee') else 'Unassigned'
    print(f\"{issue['key']}\t{f['issuetype']['name']}\t{f['status']['name']}\t{f['summary']}\t{assignee}\")
"

rm -f /tmp/jira_search.json
```

**Common JQL examples:**
- `project = PROJ AND status = "In Progress"` — all in-progress issues
- `project = PROJ AND issuetype = Bug AND status != Done` — open bugs
- `assignee = currentUser() AND sprint in openSprints()` — my sprint items
- `project = PROJ AND labels = "backend" ORDER BY priority DESC` — by label
- `project = PROJ AND created >= -7d` — issues created in last 7 days
- `parent = PROJ-100` — sub-tasks of an epic/story

---

### 9. Add Comment

```bash
python3 -c "
import json
payload = {
    'body': {
        'type': 'doc',
        'version': 1,
        'content': [
            {
                'type': 'paragraph',
                'content': [{'type': 'text', 'text': '<Comment text>'}]
            }
        ]
    }
}
json.dump(payload, open('/tmp/jira_comment.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_comment.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/comment" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'id' in d:
    print(f\"Comment added (ID: {d['id']})\")
else:
    print('Error:', json.dumps(d, indent=2))
"

rm -f /tmp/jira_comment.json
```

---

### 10. Assign Issue

```bash
# First find the user's accountId
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/user/search?query=<email_or_name>" \
  | python3 -c "
import json, sys
users = json.load(sys.stdin)
for u in users:
    print(f\"{u['accountId']}\t{u['displayName']}\t{u.get('emailAddress','')}\")
"

# Then assign
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X PUT \
  -H "Content-Type: application/json" \
  -d "{\"accountId\": \"<accountId>\"}" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/assignee" \
  -w "\nHTTP Status: %{http_code}\n"
```

To unassign, use `{"accountId": null}`.

---

### 11. Link Issues

```bash
python3 -c "
import json
payload = {
    'type': {'name': '<link_type>'},
    'inwardIssue': {'key': '<PROJ-1>'},
    'outwardIssue': {'key': '<PROJ-2>'}
}
json.dump(payload, open('/tmp/jira_link.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_link.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issueLink" \
  -w "\nHTTP Status: %{http_code}\n"

rm -f /tmp/jira_link.json
```

**Common link types:** `Blocks`, `is blocked by`, `Clones`, `Duplicate`, `Relates`.

To discover available link types:
```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issueLinkType" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for lt in d['issueLinkTypes']:
    print(f\"{lt['name']}\t{lt['inward']}\t{lt['outward']}\")
"
```

---

### 12. List Boards

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/agile/1.0/board" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for b in d.get('values', []):
    print(f\"{b['id']}\t{b['name']}\t{b['type']}\")
"
```

To filter boards by project: append `?projectKeyOrId=PROJ` to the URL.

---

### 13. Sprint Management

**List sprints for a board:**

```bash
BOARD_ID="<board_id>"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/agile/1.0/board/$BOARD_ID/sprint" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for s in d.get('values', []):
    print(f\"{s['id']}\t{s['name']}\t{s['state']}\t{s.get('startDate','N/A')}\t{s.get('endDate','N/A')}\")
"
```

**Get sprint issues:**

```bash
SPRINT_ID="<sprint_id>"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/agile/1.0/sprint/$SPRINT_ID/issue" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for issue in d.get('issues', []):
    f = issue['fields']
    assignee = f.get('assignee',{}).get('displayName','Unassigned') if f.get('assignee') else 'Unassigned'
    print(f\"{issue['key']}\t{f['issuetype']['name']}\t{f['status']['name']}\t{f['summary']}\t{assignee}\")
"
```

**Move issues to a sprint:**

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"issues\": [\"PROJ-1\", \"PROJ-2\", \"PROJ-3\"]}" \
  "https://$ATLASSIAN_INSTANCE/rest/agile/1.0/sprint/$SPRINT_ID/issue" \
  -w "\nHTTP Status: %{http_code}\n"
```

---

### 14. Backlog

```bash
BOARD_ID="<board_id>"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/agile/1.0/board/$BOARD_ID/backlog?maxResults=50" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for issue in d.get('issues', []):
    f = issue['fields']
    priority = f.get('priority',{}).get('name','None') if f.get('priority') else 'None'
    print(f\"{issue['key']}\t{f['issuetype']['name']}\t{priority}\t{f['summary']}\")
"
```

---

### 15. Bulk Create Issues

```bash
python3 -c "
import json
payload = {
    'issueUpdates': [
        {
            'fields': {
                'project': {'key': '<PROJECT_KEY>'},
                'issuetype': {'name': 'Story'},
                'summary': 'Story 1 title',
                'description': {
                    'type': 'doc', 'version': 1,
                    'content': [{'type': 'paragraph', 'content': [{'type': 'text', 'text': 'Description 1'}]}]
                }
            }
        },
        {
            'fields': {
                'project': {'key': '<PROJECT_KEY>'},
                'issuetype': {'name': 'Story'},
                'summary': 'Story 2 title',
                'description': {
                    'type': 'doc', 'version': 1,
                    'content': [{'type': 'paragraph', 'content': [{'type': 'text', 'text': 'Description 2'}]}]
                }
            }
        }
    ]
}
json.dump(payload, open('/tmp/jira_bulk.json', 'w'))
print(f'Payload: {len(payload[\"issueUpdates\"])} issues')
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_bulk.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/bulk" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
for issue in d.get('issues', []):
    print(f\"Created: {issue['key']} — https://$ATLASSIAN_INSTANCE/browse/{issue['key']}\")
for err in d.get('errors', []):
    print(f\"Error: {json.dumps(err)}\")
"

rm -f /tmp/jira_bulk.json
```

---

## ADF (Atlassian Document Format) Reference

Jira v3 API uses ADF for rich-text fields (`description`, `comment body`). All ADF documents share this wrapper:

```json
{
  "type": "doc",
  "version": 1,
  "content": [ ... ]
}
```

### Common ADF Nodes

**Paragraph:**
```json
{"type": "paragraph", "content": [{"type": "text", "text": "Hello world"}]}
```

**Heading (levels 1–6):**
```json
{"type": "heading", "attrs": {"level": 2}, "content": [{"type": "text", "text": "Section Title"}]}
```

**Bold / Italic / Code:**
```json
{"type": "text", "text": "bold text", "marks": [{"type": "strong"}]}
{"type": "text", "text": "italic text", "marks": [{"type": "em"}]}
{"type": "text", "text": "inline code", "marks": [{"type": "code"}]}
```

**Bullet List:**
```json
{
  "type": "bulletList",
  "content": [
    {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Item 1"}]}]},
    {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Item 2"}]}]}
  ]
}
```

**Ordered List:**
```json
{
  "type": "orderedList",
  "content": [
    {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Step 1"}]}]},
    {"type": "listItem", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Step 2"}]}]}
  ]
}
```

**Code Block:**
```json
{
  "type": "codeBlock",
  "attrs": {"language": "python"},
  "content": [{"type": "text", "text": "print('hello')"}]
}
```

**Table:**
```json
{
  "type": "table",
  "content": [
    {
      "type": "tableRow",
      "content": [
        {"type": "tableHeader", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Header 1"}]}]},
        {"type": "tableHeader", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Header 2"}]}]}
      ]
    },
    {
      "type": "tableRow",
      "content": [
        {"type": "tableCell", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Cell 1"}]}]},
        {"type": "tableCell", "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Cell 2"}]}]}
      ]
    }
  ]
}
```

**Link:**
```json
{"type": "text", "text": "Click here", "marks": [{"type": "link", "attrs": {"href": "https://example.com"}}]}
```

**Mention (user):**
```json
{"type": "mention", "attrs": {"id": "<accountId>", "text": "@User Name"}}
```

---

### 16. My Issues (Quick Start)

Fetch all issues assigned to the current user in active sprints:

```bash
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//' || echo 'yourcompany.atlassian.net')}"

python3 -c "
import json
payload = {
    'jql': 'assignee = currentUser() AND sprint in openSprints() ORDER BY status ASC, priority DESC',
    'maxResults': 50,
    'fields': ['summary', 'status', 'priority', 'issuetype', 'labels', 'parent', 'subtasks']
}
json.dump(payload, open('/tmp/jira_my.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_my.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/search" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(f'My Issues ({d[\"total\"]} total):')
print()
for issue in d['issues']:
    f = issue['fields']
    prio = f.get('priority',{}).get('name','—') if f.get('priority') else '—'
    parent = f.get('parent',{}).get('key','') if f.get('parent') else ''
    parent_str = f' (under {parent})' if parent else ''
    subtask_count = len(f.get('subtasks', []))
    sub_str = f' [{subtask_count} sub-tasks]' if subtask_count else ''
    print(f\"{issue['key']}\t{f['issuetype']['name']}\t{f['status']['name']}\t{prio}\t{f['summary']}{parent_str}{sub_str}\")
"

rm -f /tmp/jira_my.json
```

**Variations:**
- All my issues (not just sprint): `assignee = currentUser() AND status != Done`
- My issues in a project: `assignee = currentUser() AND project = PROJ AND status != Done`

---

### 17. Get Sub-tasks of an Issue

Fetch an issue's sub-tasks to see the full breakdown:

```bash
ISSUE_KEY="PROJ-123"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY?fields=summary,status,subtasks" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
f = d['fields']
print(f\"Parent: {d['key']} — {f['summary']} [{f['status']['name']}]\")
print()
subtasks = f.get('subtasks', [])
if subtasks:
    print(f'Sub-tasks ({len(subtasks)}):')
    for st in subtasks:
        sf = st['fields']
        print(f\"  {st['key']}\t{sf['status']['name']}\t{sf['summary']}\")
else:
    print('No sub-tasks.')
"
```

### Create Sub-tasks Under a Parent

After viewing the parent, create sub-tasks referencing it:

```bash
python3 -c "
import json
payload = {
    'fields': {
        'project': {'key': '<PROJECT_KEY>'},
        'parent': {'key': '<PARENT_KEY>'},
        'issuetype': {'name': 'Sub-task'},
        'summary': '<Sub-task summary>',
        'description': {
            'type': 'doc',
            'version': 1,
            'content': [
                {
                    'type': 'heading', 'attrs': {'level': 3},
                    'content': [{'type': 'text', 'text': 'Acceptance Criteria'}]
                },
                {
                    'type': 'bulletList',
                    'content': [
                        {'type': 'listItem', 'content': [{'type': 'paragraph', 'content': [{'type': 'text', 'text': 'Criterion 1'}]}]},
                        {'type': 'listItem', 'content': [{'type': 'paragraph', 'content': [{'type': 'text', 'text': 'Criterion 2'}]}]}
                    ]
                }
            ]
        }
    }
}
json.dump(payload, open('/tmp/jira_subtask.json', 'w'))
print('Payload written.')
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_subtask.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'key' in d:
    print(f\"Created sub-task: {d['key']}\")
    print(f\"URL: https://$ATLASSIAN_INSTANCE/browse/{d['key']}\")
else:
    print('Error:', json.dumps(d, indent=2))
    sys.exit(1)
"

rm -f /tmp/jira_subtask.json
```

---

### 18. Add Remote Link (Attach Confluence URL to Issue)

Add a Confluence page URL (or any external link) as a web link on a Jira issue:

```bash
ISSUE_KEY="PROJ-123"
LINK_URL="https://yourcompany.atlassian.net/wiki/spaces/PROJ/pages/12345/Page-Title"
LINK_TITLE="Architecture Document"

python3 -c "
import json
payload = {
    'object': {
        'url': '$LINK_URL',
        'title': $(python3 -c "import json; print(json.dumps('$LINK_TITLE'))"),
        'icon': {
            'url16x16': 'https://yourcompany.atlassian.net/favicon.ico'
        }
    }
}
json.dump(payload, open('/tmp/jira_remotelink.json', 'w'))
"

curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  -d @/tmp/jira_remotelink.json \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/remotelink" \
  | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'id' in d:
    print(f\"Link added to {sys.argv[1]}: {sys.argv[2]}\")
else:
    print('Error:', json.dumps(d, indent=2))
" "$ISSUE_KEY" "$LINK_TITLE"

rm -f /tmp/jira_remotelink.json
```

### List Remote Links on an Issue

```bash
curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "https://$ATLASSIAN_INSTANCE/rest/api/3/issue/$ISSUE_KEY/remotelink" \
  | python3 -c "
import json, sys
links = json.load(sys.stdin)
if links:
    for l in links:
        obj = l.get('object', {})
        print(f\"{l['id']}\t{obj.get('title','')}\t{obj.get('url','')}\")
else:
    print('No remote links.')
"
```

---

## Custom Fields Workflow

Custom fields have instance-specific IDs (e.g., `customfield_10014`). Always discover before using:

1. **Get issue type ID** — use workflow 2 (Get Create Metadata)
2. **Get field metadata** — use workflow 3 (Get Field Metadata)
3. **Find the field** — search output for the custom field name (e.g., "Story Points", "Epic Link", "Sprint")
4. **Use the field ID** — include `customfield_XXXXX` in create/update payloads

Common custom fields (IDs vary by instance):
- **Epic Link** — `customfield_10014` (typically) — set to epic's issue key
- **Story Points** — `customfield_10016` (typically) — numeric value
- **Sprint** — `customfield_10020` (typically) — sprint ID (number)

---

## Output Conventions

- **List results** → display as a markdown table with relevant columns
- **Create issue** → confirm issue key and URL: `Created: PROJ-123 — https://instance/browse/PROJ-123`
- **Update/Transition** → confirm action: `PROJ-123: transitioned to "In Progress"`
- **Search results** → markdown table: Key | Type | Status | Summary | Assignee
- **Errors** → show the HTTP status code and the API error message
- **Bulk create** → list all created keys with URLs, then any errors

## Key Facts

- Instance: configured via `$ATLASSIAN_INSTANCE` env var (defaults to `yourcompany.atlassian.net`)
- Issue API: REST v3 (`/rest/api/3`) — uses ADF for rich text
- Agile API: REST 1.0 (`/rest/agile/1.0`) — boards, sprints, backlog
- `204 No Content` = success for update, transition, assign operations
- Always discover issue types and custom fields via createmeta before creating issues
- Sub-tasks require `parent.key` in the create payload
- Bulk create supports up to 50 issues per request
