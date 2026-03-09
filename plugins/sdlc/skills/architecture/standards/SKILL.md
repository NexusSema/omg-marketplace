---
name: architecture/standards
description: "BMAD Architecture methodology, quality standards, and reference data for creating architecture decision documents"
---

# BMAD Architecture Standards

## Philosophy: Architecture for AI Agent Consistency

A BMAD Architecture Document serves two audiences simultaneously:
1. **Human stakeholders** - Technical leads, architects, and developers who need clear architectural guidance and rationale
2. **LLM downstream consumers** - AI agents handling implementation, code generation, and development who need precise, unambiguous patterns to follow

The architecture document ensures all AI agents implement consistently — preventing conflicts in naming, structure, communication patterns, and process decisions.

## Core Quality Standards

### Decision Completeness
Every architectural decision must be:
- **Explicit** - No implicit assumptions or "standard practice" shortcuts
- **Versioned** - Specific technology versions, not "latest"
- **Rationale-backed** - Why this choice was made
- **Scoped** - What components/areas it affects

### Pattern Specificity
Implementation patterns must be concrete enough that two independent AI agents would produce compatible code:
- Naming conventions with examples (good and bad)
- Structure patterns with exact file/directory paths
- Communication patterns with payload formats
- Process patterns with error handling approaches

### Structure Concreteness
Project structure must be:
- Complete directory trees, not generic placeholders
- Technology-specific, not abstract
- Mapped to requirements/epics
- Include all configuration, source, test, and build files

## What Makes a Good Architecture Document

### Required Document Sections
1. Project Context Analysis - Requirements overview, scale assessment, constraints
2. Starter Template Evaluation - Technology domain, starter selection, rationale
3. Core Architectural Decisions - Data, auth, API, frontend, infrastructure decisions with versions
4. Implementation Patterns - Naming, structure, format, communication, process patterns
5. Project Structure - Complete directory tree, boundaries, requirement mapping
6. Architecture Validation Results - Coherence, coverage, readiness assessment

### Anti-Patterns to Detect and Fix
- Decisions without version numbers
- Generic structure placeholders instead of specific trees
- Missing rationale for technology choices
- Patterns without concrete examples
- Inconsistent naming across different pattern categories
- Requirements not mapped to architectural components

## Reference Data

For project classification and starter template guidance:
- `references/project-types.csv` - Project type detection signals and typical starters
- `references/domain-complexity.csv` - Domain complexity levels and suggested workflows
