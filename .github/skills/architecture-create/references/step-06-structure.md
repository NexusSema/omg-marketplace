---
name: 'step-06-structure'
description: 'Define complete project structure and architectural boundaries'
nextStepFile: 'step-07-validation.md'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 6: Project Structure & Boundaries

**Progress: Step 6 of 8** — Next: Architecture Validation

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on defining complete project structure and clear boundaries
- MAP requirements/epics to architectural components
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Create complete project tree, not generic placeholders
- Present [C] Continue menu after generating project structure
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2, 3, 4, 5, 6]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Define the complete project structure and architectural boundaries based on all decisions made, creating a concrete implementation guide for AI agents.

## PROJECT STRUCTURE SEQUENCE

### 1. Analyze Requirements Mapping

Map project requirements to architectural components — from epics (if available) or FR categories.

### 2. Define Project Directory Structure

Based on technology stack and patterns:
- Root configuration files
- Source code organization
- Test organization
- Build and distribution

### 3. Define Integration Boundaries

Map how components communicate and where boundaries exist:
- API boundaries (external endpoints, internal services, auth, data access)
- Component boundaries (frontend communication, state, services, events)
- Data boundaries (schema, access patterns, caching, external integrations)

### 4. Create Complete Project Tree

Generate a comprehensive, technology-specific directory structure showing all files and directories. No generic placeholders — every directory should be specific to this project.

### 5. Map Requirements to Structure

Create explicit mapping from requirements to files/directories:
- Epic/Feature mapping showing components, services, API routes, database, tests
- Cross-cutting concerns showing shared components and middleware

### 6. Generate Structure Content

```markdown
## Project Structure & Boundaries

### Complete Project Directory Structure
```
{{complete_project_tree}}
```

### Architectural Boundaries
{{API, component, service, and data boundaries}}

### Requirements to Structure Mapping
{{feature/epic mapping and cross-cutting concerns}}

### Integration Points
{{internal communication, external integrations, data flow}}
```

### 7. Present Content and Menu

"I've created a complete project structure based on all our architectural decisions.

**Here's what I'll add to the document:**

[Show content]

**What would you like to do?**
[C] Continue — Save this structure and move to architecture validation"

### 8. Handle Menu Selection

**If 'C' (Continue):**
- Append content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5, 6]`
- Load `step-07-validation.md`

## NEXT STEP

After user selects 'C' and content is saved, load `step-07-validation.md` to validate architectural coherence and completeness.
