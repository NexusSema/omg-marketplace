#!/bin/bash
# Push a local Confluence XHTML file back to Confluence, auto-incrementing the version.
#
# Usage: push-confluence-page.sh <file.html> <page_id> "description of changes"
#
# Requires env vars: ATLASSIAN_EMAIL, ATLASSIAN_API_TOKEN
# Optional: ATLASSIAN_INSTANCE (defaults to yourcompany.atlassian.net)

set -euo pipefail

FILE="$1"
PAGE_ID="$2"
MESSAGE="${3:-Updated via Claude Code}"

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE"
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

# Fetch current version
CURRENT=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  "${BASE_URL}/pages/${PAGE_ID}?body-format=storage")

CURRENT_VERSION=$(echo "$CURRENT" | python3 -c "import json,sys; print(json.load(sys.stdin)['version']['number'])")
TITLE=$(echo "$CURRENT" | python3 -c "import json,sys; print(json.load(sys.stdin)['title'])")
NEW_VERSION=$((CURRENT_VERSION + 1))

# Read local file content
BODY_CONTENT=$(cat "$FILE")

# Build update payload
python3 -c "
import json
payload = {
    'id': '${PAGE_ID}',
    'status': 'current',
    'title': $(python3 -c "import json; print(json.dumps('$TITLE'))"),
    'body': {
        'representation': 'storage',
        'value': open('${FILE}').read()
    },
    'version': {
        'number': ${NEW_VERSION},
        'message': $(python3 -c "import json; print(json.dumps('$MESSAGE'))")
    }
}
json.dump(payload, open('/tmp/cf_update.json', 'w'))
"

# Push update
RESULT=$(curl -s -u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN" \
  -X PUT \
  -H "Content-Type: application/json" \
  -d @/tmp/cf_update.json \
  "${BASE_URL}/pages/${PAGE_ID}")

# Check result
echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'version' in d:
    print(f\"Pushed: {d['title']} (v{d['version']['number']})\")
    print(f\"URL: https://${ATLASSIAN_INSTANCE}/wiki/spaces/{d.get('spaceId','')}/pages/${PAGE_ID}\")
else:
    print('Error:', json.dumps(d, indent=2))
    sys.exit(1)
"

rm -f /tmp/cf_update.json
