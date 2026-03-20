---
name: 'step-05-patterns'
description: 'Define implementation patterns and consistency rules to prevent AI agent conflicts'
nextStepFile: 'step-06-structure.md'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 5: Implementation Patterns & Consistency Rules

**Progress: Step 5 of 8** — Next: Project Structure

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on patterns that prevent AI agent implementation conflicts
- EMPHASIZE what agents could decide DIFFERENTLY if not specified
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Focus on consistency, not implementation details
- Present [C] Continue menu after generating patterns content
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2, 3, 4, 5]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Define implementation patterns and consistency rules that ensure multiple AI agents write compatible, consistent code.

## PATTERNS DEFINITION SEQUENCE

### 1. Identify Potential Conflict Points

Based on the chosen technology stack, identify where AI agents could make different choices:

**Naming Conflicts:** Database naming, API endpoints, files/directories, components/functions/variables
**Structural Conflicts:** Test locations, component organization, utility placement, config organization
**Format Conflicts:** API response wrappers, error structures, date/time formats, JSON field naming
**Communication Conflicts:** Event naming, payloads, state updates, action naming, logging
**Process Conflicts:** Loading states, error recovery, retry patterns, auth flows, validation timing

### 2. Facilitate Pattern Decisions

For each conflict category, present options with trade-offs and get user decision.

### 3. Define Pattern Categories

#### Naming Patterns
- Database naming (table, column, foreign key, index conventions)
- API naming (endpoints, route params, query params, headers)
- Code naming (components, files, functions, variables)

#### Structure Patterns
- Project organization (test locations, component organization, utilities, services)
- File structure (config locations, assets, docs, env files)

#### Format Patterns
- API formats (response wrapper, error format, date format, success structure)
- Data formats (JSON field naming, boolean representation, null handling)

#### Communication Patterns
- Event systems (naming, payload structure, versioning, async handling)
- State management (update patterns, action naming, selectors, organization)

#### Process Patterns
- Error handling (global approach, boundaries, user messages, logging)
- Loading states (naming, global vs local, persistence, UI patterns)

### 4. Generate Patterns Content

```markdown
## Implementation Patterns & Consistency Rules

### Naming Patterns
{{database, API, and code naming conventions with examples}}

### Structure Patterns
{{project organization and file structure rules with examples}}

### Format Patterns
{{API response and data exchange format rules with examples}}

### Communication Patterns
{{event system and state management rules with examples}}

### Process Patterns
{{error handling and loading state rules with examples}}

### Enforcement Guidelines
**All AI Agents MUST:**
- {{mandatory rules}}

### Pattern Examples
**Good Examples:** {{correct usage}}
**Anti-Patterns:** {{what to avoid}}
```

### 5. Present Content and Menu

"I've documented implementation patterns that will prevent conflicts between AI agents.

**Here's what I'll add to the document:**

[Show content]

**What would you like to do?**
[C] Continue — Save these patterns and move to project structure"

### 6. Handle Menu Selection

**If 'C' (Continue):**
- Append content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5]`
- Load `step-06-structure.md`

## NEXT STEP

After user selects 'C' and content is saved, load `step-06-structure.md` to define the complete project structure.
