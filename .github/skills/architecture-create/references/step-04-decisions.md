---
name: 'step-04-decisions'
description: 'Facilitate collaborative architectural decision making across all critical categories'
nextStepFile: 'step-05-patterns.md'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 4: Core Architectural Decisions

**Progress: Step 4 of 8** — Next: Implementation Patterns

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on making critical architectural decisions collaboratively
- ALWAYS use WebSearch to verify current technology versions
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Use WebSearch to verify technology versions and options
- Present [C] Continue menu after generating all decisions content
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2, 3, 4]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Facilitate collaborative architectural decision making, leveraging existing technical preferences and starter template decisions, focusing on remaining choices critical to the project's success.

## DECISION MAKING SEQUENCE

### 1. Review Existing Decisions

Review starter template decisions, user technical preferences, and project context technical rules. Identify what's already decided vs what remains.

**Already Decided (Don't re-decide):**
- Starter template decisions
- User technology preferences
- Project context technical rules

**Remaining decisions classified by priority:**
- **Critical**: Must be decided before implementation
- **Important**: Shape the architecture significantly
- **Nice-to-Have**: Can be deferred

### 2. Decision Categories

#### Category 1: Data Architecture
Database choice, data modeling, validation strategy, migration approach, caching strategy

#### Category 2: Authentication & Security
Auth method, authorization patterns, security middleware, encryption, API security

#### Category 3: API & Communication
API design patterns (REST/GraphQL), documentation, error handling, rate limiting

#### Category 4: Frontend Architecture (if applicable)
State management, component architecture, routing, performance, bundle optimization

#### Category 5: Infrastructure & Deployment
Hosting, CI/CD pipeline, environment config, monitoring/logging, scaling

### 3. Facilitate Each Decision

For each category, adapt explanation to user skill level. Verify technology versions via WebSearch. Record each decision with: category, choice, version, rationale, affected components.

### 4. Check Cascading Implications

After each major decision, identify related decisions that follow.

### 5. Generate Decisions Content

```markdown
## Core Architectural Decisions

### Decision Priority Analysis
**Critical:** {{critical_decisions}}
**Important:** {{important_decisions}}
**Deferred:** {{deferred_decisions}}

### Data Architecture
{{data_decisions_with_versions_and_rationale}}

### Authentication & Security
{{security_decisions}}

### API & Communication Patterns
{{api_decisions}}

### Frontend Architecture
{{frontend_decisions}}

### Infrastructure & Deployment
{{infrastructure_decisions}}

### Decision Impact Analysis
**Implementation Sequence:** {{ordered_list}}
**Cross-Component Dependencies:** {{dependencies}}
```

### 6. Present Content and Menu

"I've documented all the core architectural decisions.

**Here's what I'll add to the document:**

[Show content]

**What would you like to do?**
[C] Continue — Save these decisions and move to implementation patterns"

### 7. Handle Menu Selection

**If 'C' (Continue):**
- Append content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2, 3, 4]`
- Load `step-05-patterns.md`

## NEXT STEP

After user selects 'C' and content is saved, load `step-05-patterns.md` to define implementation patterns.
