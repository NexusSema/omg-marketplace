#!/bin/bash
# Push a Markdown file to Confluence — converts to XHTML and creates or updates a page.
#
# Usage: push-md-to-confluence.sh <file.md> ["description of changes"]
#
# Reads frontmatter from the .md file:
#   confluence_title:    Page title (required)
#   confluence_space_id: Space ID (required for create)
#   confluence_parent_id: Parent page ID (optional)
#   confluence_page_id:  Page ID (if set, updates existing; otherwise creates new)
#
# After creating a new page, writes confluence_page_id back into the frontmatter.
#
# Requires env vars: ATLASSIAN_EMAIL, ATLASSIAN_API_TOKEN
# Optional: ATLASSIAN_INSTANCE (defaults to yourcompany.atlassian.net)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MD_FILE="$1"
MESSAGE="${2:-Updated via Claude Code}"

if [ ! -f "$MD_FILE" ]; then
  echo "Error: File not found: $MD_FILE"
  exit 1
fi

# Resolve credentials
ATLASSIAN_EMAIL="${ATLASSIAN_EMAIL:-$(grep 'export ATLASSIAN_EMAIL' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_API_TOKEN="${ATLASSIAN_API_TOKEN:-$(grep 'export ATLASSIAN_API_TOKEN' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-$(grep 'export ATLASSIAN_INSTANCE' ~/.zshrc ~/.bashrc 2>/dev/null | head -1 | sed 's/.*=\"//;s/\".*//')}"
ATLASSIAN_INSTANCE="${ATLASSIAN_INSTANCE:-yourcompany.atlassian.net}"

if [ -z "$ATLASSIAN_EMAIL" ] || [ -z "$ATLASSIAN_API_TOKEN" ]; then
  echo "Error: ATLASSIAN_EMAIL and ATLASSIAN_API_TOKEN must be set"
  exit 1
fi

BASE_URL="https://${ATLASSIAN_INSTANCE}/wiki/api/v2"

# Extract frontmatter values
extract_fm() {
  python3 -c "
import re, sys
with open('$MD_FILE', 'r') as f:
    content = f.read()
m = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
if not m:
    sys.exit(0)
fm = m.group(1)
for line in fm.split('\n'):
    parts = line.split(':', 1)
    if len(parts) == 2:
        key = parts[0].strip()
        val = parts[1].strip().strip('\"').strip(\"'\")
        if key == '$1':
            print(val)
            break
"
}

TITLE=$(extract_fm "confluence_title")
SPACE_ID=$(extract_fm "confluence_space_id")
PARENT_ID=$(extract_fm "confluence_parent_id")
PAGE_ID=$(extract_fm "confluence_page_id")

if [ -z "$TITLE" ]; then
  echo "Error: confluence_title not found in frontmatter"
  exit 1
fi

# Convert markdown to XHTML
TEMP_HTML=$(mktemp /tmp/md_to_cf_XXXXXX.html)
"$SCRIPT_DIR/md-to-confluence-storage.sh" "$MD_FILE" "$TEMP_HTML"

BODY_CONTENT=$(cat "$TEMP_HTML")

if [ -n "$PAGE_ID" ]; then
  # UPDATE existing page
  echo "Updating existing page: $PAGE_ID"

  # Fetch current version
  CURRENT=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
    "${BASE_URL}/pages/${PAGE_ID}?body-format=storage")

  CURRENT_VERSION=$(echo "$CURRENT" | python3 -c "import json,sys; print(json.load(sys.stdin)['version']['number'])")
  NEW_VERSION=$((CURRENT_VERSION + 1))

  # Build update payload
  python3 -c "
import json
payload = {
    'id': '${PAGE_ID}',
    'status': 'current',
    'title': $(python3 -c "import json; print(json.dumps('$TITLE'))"),
    'body': {
        'representation': 'storage',
        'value': open('${TEMP_HTML}').read()
    },
    'version': {
        'number': ${NEW_VERSION},
        'message': $(python3 -c "import json; print(json.dumps('$MESSAGE'))")
    }
}
json.dump(payload, open('/tmp/cf_push_update.json', 'w'))
"

  RESULT=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
    -X PUT \
    -H "Content-Type: application/json" \
    -d @/tmp/cf_push_update.json \
    "${BASE_URL}/pages/${PAGE_ID}")

  echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'version' in d:
    print(f\"Updated: {d['title']} (v{d['version']['number']})\")
    print(f\"URL: https://${ATLASSIAN_INSTANCE}/wiki/spaces/{d.get('spaceId','')}/pages/${PAGE_ID}\")
else:
    print('Error:', json.dumps(d, indent=2))
    sys.exit(1)
"

  rm -f /tmp/cf_push_update.json

else
  # CREATE new page
  if [ -z "$SPACE_ID" ]; then
    echo "Error: confluence_space_id required in frontmatter for new page creation"
    rm -f "$TEMP_HTML"
    exit 1
  fi

  echo "Creating new page: $TITLE"

  python3 -c "
import json
payload = {
    'spaceId': '${SPACE_ID}',
    'status': 'current',
    'title': $(python3 -c "import json; print(json.dumps('$TITLE'))"),
    'body': {
        'representation': 'storage',
        'value': open('${TEMP_HTML}').read()
    }
}
parent_id = '${PARENT_ID}'
if parent_id:
    payload['parentId'] = parent_id
json.dump(payload, open('/tmp/cf_push_create.json', 'w'))
"

  RESULT=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
    -X POST \
    -H "Content-Type: application/json" \
    -d @/tmp/cf_push_create.json \
    "${BASE_URL}/pages")

  NEW_PAGE_ID=$(echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'id' in d:
    print(d['id'])
else:
    print('Error:', json.dumps(d, indent=2), file=sys.stderr)
    sys.exit(1)
")

  if [ -n "$NEW_PAGE_ID" ]; then
    echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(f\"Created: {d['title']} (ID: {d['id']})\")
print(f\"URL: https://${ATLASSIAN_INSTANCE}/wiki/spaces/{d.get('spaceId','')}/pages/{d['id']}\")
"

    # Write page_id back into frontmatter
    python3 -c "
import re
with open('$MD_FILE', 'r') as f:
    content = f.read()
m = re.match(r'^(---\s*\n)(.*?)(\n---\s*\n)', content, re.DOTALL)
if m:
    fm = m.group(2)
    if 'confluence_page_id' not in fm:
        fm += f'\nconfluence_page_id: \"${NEW_PAGE_ID}\"'
    new_content = m.group(1) + fm + m.group(3) + content[m.end():]
    with open('$MD_FILE', 'w') as f:
        f.write(new_content)
    print('Updated frontmatter with page ID.')
"
  fi

  rm -f /tmp/cf_push_create.json
fi

rm -f "$TEMP_HTML"
