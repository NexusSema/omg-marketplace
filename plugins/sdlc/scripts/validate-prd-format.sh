#!/bin/bash
# PRD Format Validator
# Runs on PostToolUse[Edit|Write] to check PRD files for required BMAD sections.
# Exits silently (exit 0) for non-PRD files.

# Get the modified file path from the tool use context
FILE_PATH="${CLAUDE_TOOL_USE_FILE:-}"

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
