#!/bin/bash
# Architecture Format Validator
# Runs on PostToolUse to check architecture files for required BMAD sections.
# Receives tool use context as JSON on stdin. Exits silently for non-architecture files.

# Read file path from stdin JSON (Copilot hooks format)
STDIN_JSON=$(cat)
FILE_PATH=$(echo "$STDIN_JSON" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
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

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check architecture files
BASENAME=$(basename "$FILE_PATH")
if [[ ! "$BASENAME" =~ [Aa]rchitect ]] || [[ ! "$BASENAME" =~ \.md$ ]]; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check for required sections (## level 2 headers)
REQUIRED_SECTIONS=(
  "Project Context Analysis"
  "Starter Template Evaluation"
  "Core Architectural Decisions"
  "Implementation Patterns"
  "Project Structure"
  "Architecture Validation Results"
)

MISSING=()
for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -q "^## .*${section}" "$FILE_PATH" 2>/dev/null; then
    MISSING+=("$section")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "Architecture format check: Missing sections (may be added in later steps):"
  for section in "${MISSING[@]}"; do
    echo "  - ## $section"
  done
fi

exit 0
