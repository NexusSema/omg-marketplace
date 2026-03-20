---
name: 'step-02-context'
description: 'Analyze loaded project documents to understand architectural scope and requirements'
nextStepFile: 'step-03-starter.md'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 2: Project Context Analysis

**Progress: Step 2 of 8** — Next: Starter Template Evaluation

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on understanding project scope and requirements for architecture
- ANALYZE loaded documents, don't assume or generate requirements
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Present [C] Continue menu after generating project context analysis
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Fully read and analyze the loaded project documents to understand architectural scope, requirements, and constraints before beginning decision making.

## CONTEXT ANALYSIS SEQUENCE

### 1. Review Project Requirements

**From PRD Analysis:**
- Extract and analyze Functional Requirements (FRs)
- Identify Non-Functional Requirements (NFRs) like performance, security, compliance
- Note any technical constraints or dependencies mentioned
- Count and categorize requirements to understand project scale

**From Epics/Stories (if available):**
- Map epic structure and user stories to architectural components
- Extract acceptance criteria for technical implications
- Identify cross-cutting concerns that span multiple epics

**From UX Design (if available):**
- Extract architectural implications from UX requirements:
  - Component complexity (simple forms vs rich interactions)
  - Real-time update needs (live data, collaborative features)
  - Accessibility standards (WCAG compliance level)
  - Performance expectations (load times, interaction responsiveness)

### 2. Project Scale Assessment

Calculate and present project complexity:

**Complexity Indicators:**
- Real-time features requirements
- Multi-tenancy needs
- Regulatory compliance requirements
- Integration complexity
- User interaction complexity
- Data complexity and volume

### 3. Reflect Understanding

Present your analysis back to user for validation:

"I'm reviewing your project documentation for {{project_name}}.

**Key architectural aspects I notice:**
- [Summarize core functionality from FRs]
- [Note critical NFRs that will shape architecture]
- [Identify unique technical challenges or constraints]
- [Highlight any regulatory or compliance requirements]

**Scale indicators:**
- Project complexity appears to be: [low/medium/high/enterprise]
- Primary technical domain: [web/mobile/api/backend/full-stack/etc]
- Cross-cutting concerns identified: [list major ones]

Does this match your understanding of the project scope and requirements?"

### 4. Generate Project Context Content

Prepare the content to append to the document:

```markdown
## Project Context Analysis

### Requirements Overview

**Functional Requirements:**
{{analysis of FRs and what they mean architecturally}}

**Non-Functional Requirements:**
{{NFRs that will drive architectural decisions}}

**Scale & Complexity:**
{{project_scale_assessment}}

### Technical Constraints & Dependencies

{{known_constraints_dependencies}}

### Cross-Cutting Concerns Identified

{{concerns_that_will_affect_multiple_components}}
```

### 5. Present Content and Menu

Show the generated content and present:

"I've drafted the Project Context Analysis based on your requirements.

**Here's what I'll add to the document:**

[Show the complete markdown content]

**What would you like to do?**
[C] Continue — Save this analysis and begin starter template evaluation"

### 6. Handle Menu Selection

**If 'C' (Continue):**
- Append the final content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2]`
- Load `step-03-starter.md`

## NEXT STEP

After user selects 'C' and content is saved to document, load `step-03-starter.md` to evaluate starter template options.

Remember: Do NOT proceed to step-03 until user explicitly selects 'C' and content is saved!
