#!/bin/bash
# Shard Architecture Format Validator
# Runs on PostToolUse to check shard output documents for required sections.
# Receives tool use context as JSON on stdin. Exits silently for non-shard files.

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

# Only check shard output documents (numbered 01-07 architecture sub-documents)
BASENAME=$(basename "$FILE_PATH")
if [[ ! "$BASENAME" =~ ^0[1-7]- ]] || [[ ! "$BASENAME" =~ \.md$ ]]; then
  exit 0
fi

if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check for required sections
MISSING=()

if ! grep -q "^## Gaps & Open Questions" "$FILE_PATH" 2>/dev/null; then
  MISSING+=("Gaps & Open Questions")
fi

if ! grep -q "^## Cross-References" "$FILE_PATH" 2>/dev/null; then
  MISSING+=("Cross-References")
fi

# Check for frontmatter
if ! head -1 "$FILE_PATH" 2>/dev/null | grep -q "^---$"; then
  MISSING+=("YAML frontmatter")
fi

# Check for at least one Mermaid code block
if ! grep -q '```mermaid' "$FILE_PATH" 2>/dev/null; then
  MISSING+=("Mermaid diagram(s)")
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "Shard document format check: Missing elements (may be added in later steps):"
  for item in "${MISSING[@]}"; do
    echo "  - $item"
  done
fi

exit 0
