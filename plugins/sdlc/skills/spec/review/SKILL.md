---
name: spec/review
description: "Review check categories and algorithms for technical specification analysis"
---

# Spec Review Skill

This skill defines the check categories and algorithms used to review technical specifications for quality, consistency, and contamination.

## Review Check Categories

### 1. Term Registry
Build a vocabulary from the document itself. Extract defined terms from section headers, bold text, code identifiers, table columns, and glossary entries. Record each term's canonical form, every location where it appears, and surrounding context. This registry is the foundation for all other checks.

### 2. Cross-section Consistency
Using the term registry, verify that every term is used consistently throughout the document. Detect: same concept with different names, same name with conflicting descriptions, acronym misuse, capitalization drift, and singular/plural inconsistency. See `references/consistency-rules.md` for the full algorithm.

### 3. Stale Reference Detection
Find all intra-document references (e.g., "see Section X", "as described in", "defined above/below") and verify that each target exists and the reference remains accurate. Flag broken links, renamed sections, and references to removed content.

### 4. Contamination Scan
Apply configurable regex patterns to detect content that does not belong in a finished specification: planning language, implementation status markers, temporal statements, and environment leakage. See `references/contamination-patterns.md` for the full pattern library.

### 5. Structure Check
Verify the document's organizational integrity: sections have substance (not just headers), no orphaned references exist, the hierarchy is logical, and required sections are present.

## Report Format

All findings are compiled into a structured report. See `references/report-template.md` for the output format.

## References

- `references/contamination-patterns.md` — Regex patterns for detecting non-spec content
- `references/consistency-rules.md` — Algorithmic rules for term consistency checking
- `references/report-template.md` — Structured output format for review reports
