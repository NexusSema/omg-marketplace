---
name: 'step-07-validation'
description: 'Validate the complete architecture for coherence, completeness, and implementation readiness'
nextStepFile: 'step-08-complete.md'
outputFile: '{planning_artifacts}/architecture.md'
---

# Step 7: Architecture Validation & Completion

**Progress: Step 7 of 8** — Next: Completion & Handoff

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on validating architectural coherence and completeness
- VALIDATE all requirements are covered by architectural decisions
- ABSOLUTELY NO TIME ESTIMATES
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Run comprehensive validation checks on the complete architecture
- Present [C] Continue menu after generating validation results
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2, 3, 4, 5, 6, 7]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Validate the complete architecture for coherence, completeness, and readiness to guide AI agents through consistent implementation.

## VALIDATION SEQUENCE

### 1. Coherence Validation

- **Decision Compatibility**: Do all technology choices work together? Are versions compatible? Any contradictions?
- **Pattern Consistency**: Do patterns support the decisions? Naming consistent across areas?
- **Structure Alignment**: Does structure support all decisions? Boundaries properly defined?

### 2. Requirements Coverage Validation

- **Epic/Feature Coverage**: Every epic architecturally supported? Cross-epic dependencies handled?
- **FR Coverage**: Every functional requirement supported? Cross-cutting concerns addressed?
- **NFR Coverage**: Performance, security, scalability, compliance all addressed?

### 3. Implementation Readiness Validation

- **Decision Completeness**: All documented with versions? Patterns comprehensive? Examples provided?
- **Structure Completeness**: Complete and specific? All files defined? Integration points clear?
- **Pattern Completeness**: All conflict points addressed? Process patterns complete?

### 4. Gap Analysis

Identify and categorize:
- **Critical gaps**: Block implementation
- **Important gaps**: Need more detail
- **Nice-to-have gaps**: Additional improvements

### 5. Address Validation Issues

Present critical issues for resolution. Note important improvements. Suggest minor refinements.

### 6. Generate Validation Content

```markdown
## Architecture Validation Results

### Coherence Validation
{{decision compatibility, pattern consistency, structure alignment}}

### Requirements Coverage Validation
{{epic/feature coverage, FR coverage, NFR coverage}}

### Implementation Readiness Validation
{{decision completeness, structure completeness, pattern completeness}}

### Gap Analysis Results
{{findings with priority levels}}

### Architecture Completeness Checklist
- [x] Requirements Analysis complete
- [x] Architectural Decisions documented with versions
- [x] Implementation Patterns defined
- [x] Project Structure complete

### Architecture Readiness Assessment
**Overall Status:** READY FOR IMPLEMENTATION
**Confidence Level:** {{high/medium/low}}
**Key Strengths:** {{list}}
**Areas for Future Enhancement:** {{list}}
```

### 7. Present Content and Menu

"I've completed a comprehensive validation of your architecture.

**Here's what I'll add to the document:**

[Show content]

**What would you like to do?**
[C] Continue — Complete the architecture and finish workflow"

### 8. Handle Menu Selection

**If 'C' (Continue):**
- Append content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2, 3, 4, 5, 6, 7]`
- Load `step-08-complete.md`

## NEXT STEP

After user selects 'C' and content is saved, load `step-08-complete.md` to complete the workflow.
