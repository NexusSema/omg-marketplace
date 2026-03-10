#!/bin/bash
# Confluence XHTML Format Validator
# Runs on PostToolUse[Edit|Write] to check Confluence .html files for valid XHTML.

FILE_PATH="${CLAUDE_TOOL_USE_FILE:-}"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .html files in a Confluence/ directory
if [[ ! "$FILE_PATH" =~ Confluence/.*\.html$ ]]; then
  exit 0
fi

ISSUES=()

# Check for unclosed common tags
for TAG in p h1 h2 h3 h4 h5 h6 table tr td th ul ol li div span; do
  OPEN_COUNT=$(grep -oi "<${TAG}[ >]" "$FILE_PATH" 2>/dev/null | wc -l)
  CLOSE_COUNT=$(grep -oi "</${TAG}>" "$FILE_PATH" 2>/dev/null | wc -l)
  SELF_CLOSE=$(grep -oi "<${TAG}[^>]*/>" "$FILE_PATH" 2>/dev/null | wc -l)
  EFFECTIVE_OPEN=$((OPEN_COUNT - SELF_CLOSE))
  if [ "$EFFECTIVE_OPEN" -gt "$CLOSE_COUNT" ]; then
    DIFF=$((EFFECTIVE_OPEN - CLOSE_COUNT))
    ISSUES+=("Potentially unclosed <${TAG}> tags (${DIFF} more opens than closes)")
  fi
done

# Check for invalid Confluence macro syntax (ac:structured-macro without ac:name)
if grep -q '<ac:structured-macro' "$FILE_PATH" 2>/dev/null; then
  if grep '<ac:structured-macro' "$FILE_PATH" 2>/dev/null | grep -qv 'ac:name='; then
    ISSUES+=("Found <ac:structured-macro> without ac:name attribute")
  fi
fi

# Check for bare & (should be &amp; in XHTML)
if grep -qP '&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9a-fA-F]+;)' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Unescaped '&' found — use '&amp;' in XHTML storage format")
fi

if [ ${#ISSUES[@]} -gt 0 ]; then
  echo "Confluence XHTML check: Issues found in $(basename "$FILE_PATH"):"
  for item in "${ISSUES[@]}"; do
    echo "  - $item"
  done
fi

exit 0
