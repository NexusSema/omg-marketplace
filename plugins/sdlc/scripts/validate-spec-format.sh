#!/usr/bin/env bash
# validate-spec-format.sh
# PostToolUse hook: checks spec files for contamination patterns.
# Runs on Edit|Write — exits silently for non-matching files.
# Always exits 0 so the hook never blocks the workflow.

set -euo pipefail

FILE="${CLAUDE_TOOL_USE_FILE:-}"

# Exit silently if no file provided
[[ -z "$FILE" ]] && exit 0

# Only check files matching spec naming conventions
case "$FILE" in
  *-spec.md|*spec*.md) ;;
  *) exit 0 ;;
esac

# Exit silently if file does not exist
[[ -f "$FILE" ]] || exit 0

ISSUES=()

# --- Planning reference contamination ---
if grep -Pq 'FR-\d+' "$FILE" 2>/dev/null; then
  ISSUES+=("Planning ref: found FR-nnn requirement IDs (e.g. FR-001). Specs should not reference planning tracker IDs.")
fi
if grep -Piq 'Epic\s+\d+' "$FILE" 2>/dev/null; then
  ISSUES+=("Planning ref: found 'Epic N' references. Remove epic/sprint planning language.")
fi
if grep -Pq 'Story\s+[A-Z]+-\d+' "$FILE" 2>/dev/null; then
  ISSUES+=("Planning ref: found story ticket IDs (e.g. Story PROJ-123). Specs must be self-contained.")
fi
if grep -Piq '\b(Sprint|backlog|acceptance\s+criteria)\b' "$FILE" 2>/dev/null; then
  ISSUES+=("Planning ref: found sprint/backlog/acceptance-criteria language.")
fi

# --- Status marker contamination ---
if grep -Piq '\b(TODO|FIXME)\b' "$FILE" 2>/dev/null; then
  ISSUES+=("Status marker: found TODO/FIXME. All sections should have substantive content.")
fi
if grep -Piq '\b(not yet implemented|placeholder|stub|will be added)\b' "$FILE" 2>/dev/null; then
  ISSUES+=("Status marker: found implementation-status language (placeholder/stub/not yet implemented).")
fi

# --- Temporal marker contamination ---
if grep -Piq '\b(currently|as of today|future work|planned for|post-launch)\b' "$FILE" 2>/dev/null; then
  ISSUES+=("Temporal marker: found time-relative language (currently/future work/planned for). Specs should be evergreen.")
fi

# --- Report findings ---
if [[ ${#ISSUES[@]} -gt 0 ]]; then
  echo "Spec contamination check: ${FILE}"
  echo "Found ${#ISSUES[@]} issue(s):"
  for issue in "${ISSUES[@]}"; do
    echo "  - $issue"
  done
fi

exit 0
