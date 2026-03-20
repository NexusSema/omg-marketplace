# Spec Quality Criteria

Detailed evaluation rubrics for the six universal quality dimensions. Use these criteria when reviewing, creating, or editing any technical specification.

---

## 1. Completeness

Every section of the spec must contain substantive, actionable content.

**Pass criteria:**
- All declared sections have meaningful prose or structured data (tables, diagrams, lists).
- No headers followed by empty content or whitespace-only blocks.
- No "TBD", "TODO", "To be determined", or "See later" placeholders.
- All referenced items (APIs, schemas, flows) are defined or linked.

**Common violations:**
- Empty "Error Handling" or "Security" sections left as stubs.
- Sections containing only "Same as above" without elaboration.
- References to external documents that do not exist.

---

## 2. Consistency

Terminology and definitions must be used identically throughout the document.

**Pass criteria:**
- Each concept has one name used everywhere (e.g., do not alternate between "user", "account holder", and "customer" for the same entity).
- Data types, field names, and enum values match between prose and schema definitions.
- Numeric values (limits, thresholds, timeouts) are identical wherever they appear.
- Cross-referenced section numbers and names are accurate.

**Common violations:**
- Prose says "retry 3 times" but the config table says `max_retries: 5`.
- API section uses `userId` but data model section uses `user_id`.
- Glossary defines a term differently than the body text uses it.

---

## 3. Precision

Language must be specific and measurable. Avoid ambiguity.

**Pass criteria:**
- Quantitative requirements use exact numbers or ranges (e.g., "responds within 200ms at p99" not "responds quickly").
- Behavioral descriptions use unambiguous verbs (e.g., "rejects the request with HTTP 403" not "handles the error appropriately").
- Edge cases are addressed explicitly rather than deferred with "as appropriate" or "as needed".
- Conditional logic uses clear if/then/else structures.

**Common violations:**
- "The system should be performant" (vague adjective).
- "Handles large payloads gracefully" (undefined threshold, undefined behavior).
- "Appropriate logging" (what is logged, at what level, where?).

---

## 4. Structure

The document must have a clear hierarchy with logical information flow.

**Pass criteria:**
- Heading levels follow a strict hierarchy (no skipping from H2 to H4).
- Information flows from general to specific (overview before detail).
- Related topics are grouped together; no scattered treatment of the same concept.
- Cross-references between sections use anchors or explicit section names.
- Tables and lists are used for structured data rather than inline prose.

**Common violations:**
- Implementation details appearing before the problem statement.
- The same constraint described in three different sections with slight variations.
- A flat list of H2 headings with no logical grouping.

---

## 5. Contamination-free

Specs must contain no planning artifacts, status tracking, or temporal language.

**Pass criteria:**
- No requirement tracker IDs (FR-001, PROJ-123, Epic 4, Story ABC-456).
- No sprint, backlog, or acceptance-criteria language.
- No TODO, FIXME, or implementation-status markers.
- No temporal phrases: "currently", "as of today", "future work", "planned for Q3", "post-launch".
- No references to team members, meetings, or organizational structure.

**Common violations:**
- "This addresses FR-042 from the product backlog."
- "TODO: confirm with the security team."
- "Currently we use v1, but v2 is planned for next sprint."

---

## 6. Self-contained

The spec must be readable and understandable without external context.

**Pass criteria:**
- All domain-specific terms are defined in a glossary or on first use.
- Acronyms are expanded on first occurrence.
- Referenced standards or protocols include version numbers and links.
- The reader does not need access to meeting notes, Slack threads, or other ephemeral sources to understand the spec.
- Assumptions are stated explicitly rather than implied.

**Common violations:**
- "As discussed in the architecture review..." (reader was not in the meeting).
- "Uses the standard auth flow" (which standard? whose auth flow?).
- Unexpanded acronyms: "The DLP checks the PII before forwarding to the LLM gateway."
