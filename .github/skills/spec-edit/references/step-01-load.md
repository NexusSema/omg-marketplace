---
name: 'step-01-load'
description: 'Load the specification document and build a term registry for impact tracking'
nextStepFile: 'step-02-impact.md'
---

# Step 1: Load Spec & Build Registry

**Progress: Step 1 of 4** — Next: Impact Analysis

## Tasks

1. **Get the spec file path.** Ask the user for the path to the specification file they want to edit. If no path is provided, discover `*-spec.md` files in the current project and present them as options.

2. **Read the complete spec document.** Load the entire file contents so every section is available for analysis.

3. **Build the term registry.** Scan the document and extract all defined terms using this algorithm:
   - **Section headers** — Every `#`, `##`, `###`, etc. heading
   - **Bold terms** — Text wrapped in `**bold**`
   - **Code identifiers** — Text wrapped in `` `backticks` `` (field names, endpoints, types, etc.)
   - **Table columns** — Header cells in markdown tables
   - **Glossary entries** — Terms defined in any glossary or definitions section

   For each term, record:
   - **Canonical form** — The exact text as first defined
   - **All locations** — Every line/section where it appears
   - **Context** — The surrounding text for disambiguation

4. **Ask the user what change they want to make.** Prompt with examples to guide the request:
   > What change do you want to make?
   >
   > Examples:
   > - "Rename field `entity_id` to `tenant_id`"
   > - "Add a new section about rate limiting"
   > - "Update the authentication flow to use OAuth2"
   > - "Remove the deprecated `/v1/users` endpoint"

5. **Parse the change request.** Break it down into:
   - **Affected terms** — Which terms from the registry are involved
   - **Type of change** — One of: `rename`, `add`, `modify`, `remove`
   - **Scope description** — A human-readable summary of what will change

## Menu

- **[C] Continue** — Proceed to impact analysis
