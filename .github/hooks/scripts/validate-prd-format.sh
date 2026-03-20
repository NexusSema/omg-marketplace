#!/bin/bash
# PRD Format Validator
# Runs on PostToolUse to check PRD files for required BMAD sections.
# Receives tool use context as JSON on stdin. Exits silently for non-PRD files.

# Read file path from stdin JSON (Copilot hooks format)
STDIN_JSON=$(cat)
FILE_PATH=$(echo "$STDIN_JSON" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    # Check common field names for file path in tool input
    inp = d.get('toolInput') or d.get('input') or {}
    path = inp.get('filePath') or inp.get('path') or inp.get('file') or ''
    print(path)
except Exception:
    print('')
" 2>/dev/null)

# Fall back to env var (Claude compatibility)
if [ -z "$FILE_PATH" ]; then
  FILE_PATH="${CLAUDE_TOOL_USE_FILE:-}"
fi

# Exit silently if no file path provided
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check PRD files (files matching *prd*.md pattern)
BASENAME=$(basename "$FILE_PATH")
if [[ ! "$BASENAME" =~ [Pp][Rr][Dd] ]] || [[ ! "$BASENAME" =~ \.md$ ]]; then
  exit 0
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Required BMAD PRD sections (## level 2 headers)
REQUIRED_SECTIONS=(
  "Executive Summary"
  "Success Criteria"
  "Product Scope"
  "User Journeys"
  "Functional Requirements"
  "Non-Functional Requirements"
)

MISSING_SECTIONS=()

for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -q "^## .*${section}" "$FILE_PATH" 2>/dev/null; then
    MISSING_SECTIONS+=("$section")
  fi
done

if [ ${#MISSING_SECTIONS[@]} -gt 0 ]; then
  echo "PRD Format Check: Missing required sections in $BASENAME:"
  for section in "${MISSING_SECTIONS[@]}"; do
    echo "  - ## $section"
  done
  echo ""
  echo "Note: These sections are required by BMAD PRD standards. They may be added in later workflow steps."
  exit 0
fi

echo "PRD Format Check: All required sections present in $BASENAME"
exit 0
