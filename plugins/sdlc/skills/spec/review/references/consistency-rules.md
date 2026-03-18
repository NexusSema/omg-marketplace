# Consistency Rules

Algorithmic rules for building a term registry and checking consistency across a technical specification.

## Term Registry Building

### Step 1: Extract Section Headers
Scan for lines starting with `##` or `###`. Record the header text as a term, its line number, and nesting level.

### Step 2: Extract Bold Terms
Find all `**term**` patterns. Record each unique term, all locations, and surrounding sentence for context.

### Step 3: Extract Code Identifiers
Find all `` `term` `` patterns (inline code). Record each unique identifier and all locations. These often represent API fields, config keys, or component names.

### Step 4: Extract Table Column Headers
Find markdown table header rows (`| Col1 | Col2 |`). Record column names as terms scoped to their table's section.

### Step 5: Extract Glossary Entries
If the document contains a glossary or definitions section, extract each defined term and its definition. These are the highest-authority canonical forms.

### Step 6: Build Registry Records
For each unique term, record:
- **Canonical form** — the most authoritative version (glossary > header > bold > code)
- **Location(s)** — every line number where the term appears
- **Context** — the surrounding text at each location

## Consistency Checks

### Check 1: Same Concept, Different Names
Look for terms that likely refer to the same concept but use different names. Common patterns:
- Synonyms: `entity_id` vs `tenant_id` vs `org_id` when referring to the same field
- Abbreviations: `authentication` vs `auth`, `configuration` vs `config`
- Naming convention drift: `userId` vs `user_id` vs `UserID`

Flag all variants and recommend picking one canonical form.

### Check 2: Same Name, Different Descriptions
Find terms that appear in multiple sections with different descriptions or definitions. Flag contradictions where the same term means different things in different contexts.

### Check 3: Acronym Consistency
- Verify each acronym is defined on first use: `Role-Based Access Control (RBAC)`
- After definition, verify the acronym is used consistently (not mixed with the full form)
- Flag undefined acronyms

### Check 4: Capitalization Consistency
For defined terms, verify capitalization is consistent across all occurrences. Example: `Agent Registry` should not appear as `agent registry` or `Agent registry` elsewhere.

### Check 5: Singular/Plural Consistency
When a term is defined in singular form (`Policy`), flag inconsistent plural usage that could indicate a different concept (`Policies` as a section name is fine, but `a Policies` is not).

## Cross-Reference Verification

### Step 1: Find References
Scan for patterns that indicate intra-document references:
- `see Section ...`
- `as described in ...`
- `defined above` / `defined below`
- `refer to ...`
- `(see ...)` parenthetical references
- Markdown links to anchors: `[text](#anchor)`

### Step 2: Verify Targets Exist
For each reference, verify the target section, term, or anchor exists in the document. Flag references to nonexistent targets.

### Step 3: Verify Accuracy
Where possible, verify that the referenced content still supports the claim being made. Flag references where the target content appears to contradict the referencing statement.
