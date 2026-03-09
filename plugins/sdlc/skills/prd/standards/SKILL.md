---
name: prd/standards
description: "BMAD PRD methodology, quality standards, and reference data for creating, validating, and editing Product Requirements Documents"
---

# BMAD PRD Standards

## Philosophy: Dual-Audience Documents

A BMAD PRD serves two audiences simultaneously:
1. **Human stakeholders** - Product managers, executives, and builders who need vision, strategy, and clear communication
2. **LLM downstream consumers** - AI agents handling UX design, architecture, epic breakdown, and development

The PRD is the top of the funnel feeding all subsequent product development work. Quality here ripples through every phase.

## Core Quality Standards

### Information Density
Every sentence must carry information weight. Eliminate filler, padding, and verbose patterns.
- "The system will allow users to..." becomes "Users can..."
- "In order to..." becomes "To..."
- Zero fluff. Maximum information per word.

### SMART Requirements
All functional and non-functional requirements must be:
- **Specific** - Clear, precisely defined capability
- **Measurable** - Quantifiable with test criteria
- **Attainable** - Realistic within constraints
- **Relevant** - Aligned with business objectives
- **Traceable** - Links to source (executive summary, user journey, or business need)

### Traceability Chain
The PRD establishes the chain that all downstream artifacts depend on:
```
Vision -> Success Criteria -> User Journeys -> Functional Requirements -> (future: User Stories)
```
Every requirement must trace back to documented user needs and business objectives.

## What Makes a Good PRD

### Functional Requirements (FRs)
- Describe **capabilities**, not implementation details
- Include measurable test criteria
- Avoid subjective adjectives ("easy", "fast", "intuitive")
- Avoid implementation leakage (no technology names or library references)
- Use specific quantifiers, not vague ones ("up to 100 users" not "multiple users")

### Non-Functional Requirements (NFRs)
- Must be measurable: "The system shall [metric] [condition] [measurement method]"
- Include percentile targets and measurement approach
- Avoid unmeasurable claims ("scalable", "high availability" without metrics)

### Required Document Sections
1. Executive Summary - Vision, differentiator, target users
2. Success Criteria - Measurable outcomes (SMART)
3. Product Scope - MVP, Growth, Vision phases
4. User Journeys - Comprehensive coverage
5. Domain Requirements - Industry-specific compliance (if applicable)
6. Innovation Analysis - Competitive differentiation (if applicable)
7. Project-Type Requirements - Platform-specific needs
8. Functional Requirements - Capability contract
9. Non-Functional Requirements - Quality attributes

### Formatting for Dual Consumption
- Use ## Level 2 headers for main sections (enables LLM extraction)
- Consistent structure and patterns throughout
- Precise, testable language for AI consumption
- Clear, professional language for human review

## Anti-Patterns to Detect and Fix
- Subjective adjectives without metrics
- Implementation details leaking into requirements
- Vague quantifiers ("several", "various", "multiple")
- Missing test criteria on requirements
- Requirements not traceable to user needs
- Missing domain-specific compliance requirements

## Reference Data

For detailed methodology and rationale, see:
- `references/prd-purpose.md` - Full BMAD PRD methodology, anti-pattern examples, and downstream impact analysis

For project classification and domain-specific requirements, see:
- `references/project-types.csv` - Project type detection signals, key questions, required/skip sections, and innovation signals
- `references/domain-complexity.csv` - Domain complexity levels, compliance concerns, required knowledge, and special sections
