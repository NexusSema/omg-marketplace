#!/bin/bash
# draw.io Format Validator
# Runs on PostToolUse[Edit|Write] to check .drawio files for valid XML structure.

FILE_PATH="${CLAUDE_TOOL_USE_FILE:-}"

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only check .drawio files
if [[ ! "$FILE_PATH" =~ \.drawio$ ]]; then
  exit 0
fi

ISSUES=()

# Check for XML declaration or mxGraphModel root
if ! head -5 "$FILE_PATH" 2>/dev/null | grep -q "<mxGraphModel"; then
  ISSUES+=("Missing <mxGraphModel> root element")
fi

# Check for required root mxCell elements
if ! grep -q 'mxCell id="0"' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Missing root mxCell id=\"0\"")
fi

if ! grep -q 'mxCell id="1"' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Missing default parent mxCell id=\"1\"")
fi

# Check for double hyphens inside XML comments (illegal in XML)
if grep -q '<!--.*--.*-->' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Double hyphens (--) found inside XML comments (illegal in XML spec)")
fi

# Check for closing tags
if ! grep -q '</mxGraphModel>' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Missing closing </mxGraphModel> tag")
fi

if ! grep -q '</root>' "$FILE_PATH" 2>/dev/null; then
  ISSUES+=("Missing closing </root> tag")
fi

if [ ${#ISSUES[@]} -gt 0 ]; then
  echo "draw.io format check: Issues found:"
  for item in "${ISSUES[@]}"; do
    echo "  - $item"
  done
fi

exit 0
