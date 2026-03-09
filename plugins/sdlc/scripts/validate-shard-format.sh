#!/bin/bash
# Shard Architecture Format Validator
# Runs on PostToolUse[Edit|Write] to check shard output documents for required sections.

FILE_PATH="${CLAUDE_TOOL_USE_FILE:-}"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check shard output documents (numbered 01-07 architecture sub-documents)
BASENAME=$(basename "$FILE_PATH")
if [[ ! "$BASENAME" =~ ^0[1-7]- ]] || [[ ! "$BASENAME" =~ \.md$ ]]; then
  exit 0
fi

# Check for required sections
MISSING=()

# All shard output docs must have these sections
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
