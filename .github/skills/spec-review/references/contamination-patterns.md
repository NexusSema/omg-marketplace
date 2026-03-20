# Contamination Patterns

Configurable regex patterns for detecting content that does not belong in a finished technical specification. Each pattern includes the regex, a label, and guidance on when a match is a true positive.

## Planning Language

| Pattern | Label | Notes |
|---------|-------|-------|
| `FR-\d+` | Functional requirement ID | Specs should define behavior, not reference requirement tracking IDs |
| `NFR-\d+` | Non-functional requirement ID | Same as above |
| `Epic \d+` | Epic reference | Project management artifact |
| `Story [A-Z]+-\d+` | Story/ticket reference | Jira-style ticket IDs do not belong in specs |
| `Sprint \d+` | Sprint reference | Delivery cadence artifact |
| `\b(backlog\|acceptance criteria\|user story\|use case)\b` | Planning terms | Review in context — "use case" may be legitimate in some specs |

## Implementation Status

| Pattern | Label | Notes |
|---------|-------|-------|
| `\b(TODO\|FIXME\|HACK\|XXX)\b` | Code markers | Unfinished work markers left in document |
| `\b(MVP\|Phase \d+)\b` | Phasing language | Specs should describe the target state, not delivery phases |
| `not yet implemented\|placeholder\|stub\|will be added\|to be determined\|TBD` | Incomplete markers | Signals the spec is not finished |

## Temporal Markers

| Pattern | Label | Notes |
|---------|-------|-------|
| `\b(currently\|as of today\|at the time of writing)\b` | Time-bound statements | Specs should be timeless; these become stale |
| `future work\|planned for\|post-launch\|next sprint\|upcoming` | Future references | Indicates spec is mixed with roadmap |
| `\d{4}-\d{2}-\d{2}` | Specific dates | Flag for review — may be valid (e.g., protocol versions) or stale |

## Environment Leakage

| Pattern | Label | Notes |
|---------|-------|-------|
| `localhost:\d+` | Local URLs | Development environment artifact |
| `\b(dev mode\|debug mode\|staging)\b` | Environment references | Spec should describe production behavior |
| `ENVIRONMENT=\|API_KEY=\|SECRET` | Configuration/secrets | Sensitive values or config fragments |
| `\b(mock\|stub\|fake)\b` | Test doubles | Test infrastructure language in spec content |

## Custom Patterns

Users can add project-specific patterns below this line. Follow the same table format: pattern, label, notes.

<!-- Add project-specific patterns here -->
