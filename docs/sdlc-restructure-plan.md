# SDLC Plugin Restructure Plan

**Goal:** Reorganize the SDLC plugin to support multiple SDLC phases (PRD, Architecture, UX, Epics, etc.) without skill sprawl.

**Problem:** Current flat `skills/` directory has 4 skills for PRD alone. Adding architecture adds 3+ more. By the time we reach full SDLC coverage (PRD, Architecture, UX, Epics, Sprint, Implementation, QA, Retro), we'd have 20+ skills in a flat folder — unmanageable.

---

## Current State

```
plugins/sdlc/
├── commands/                    # 4 commands (all PRD)
├── skills/
│   ├── prd-standards/           # Reference: BMAD methodology + data
│   ├── create-prd/              # 12 step files
│   ├── validate-prd/            # 13 step files
│   └── edit-prd/                # 5 step files
├── agents/
│   └── prd-validator.md
├── hooks/hooks.json
└── scripts/validate-prd-format.sh
```

4 skills, all PRD-related. Clean enough. But it won't scale.

---

## What Architecture Adds

Source material: `_bmad/bmm/workflows/3-solutioning/create-architecture/`

The architecture workflow is an **8-step collaborative workflow** that:
- **Requires** a PRD as input (consumes PRD output)
- Guides users through project context analysis, starter template evaluation, core architectural decisions, implementation patterns, project structure, and validation
- Produces `{planning_artifacts}/architecture.md`
- Has its own data files (`domain-complexity.csv`, `project-types.csv` — architecture-specific variants)
- Has its own template (`architecture-decision-template.md`)

### Architecture components needed:

| Component | Description |
|-----------|-------------|
| `/sdlc:create-arch` command | Entry point for architecture workflow |
| `/sdlc:validate-arch` command | Validate architecture doc (future) |
| `create-arch` skill | 8-step workflow (SKILL.md + 10 step files) |
| `arch-standards` skill | Reference data + methodology |
| `arch-validator` agent | Isolated validation subagent (future) |
| `validate-arch-format.sh` script | Format check hook |

That's 6 skills after adding architecture. With validate-arch and edit-arch, that's 8. Then UX, epics, sprint... 20+ skills in a flat list.

---

## Proposed Structure

### Option A: Phase-Prefixed Flat (Safe, guaranteed compatible)

Keep skills flat but use consistent phase prefixes for grouping.

```
plugins/sdlc/
├── commands/
│   ├── create-prd.md
│   ├── validate-prd.md
│   ├── edit-prd.md
│   ├── create-arch.md            # NEW
│   ├── validate-arch.md          # FUTURE
│   └── help.md
├── skills/
│   ├── prd-standards/            # Shared PRD reference data
│   ├── prd-create/               # RENAMED from create-prd
│   ├── prd-validate/             # RENAMED from validate-prd
│   ├── prd-edit/                 # RENAMED from edit-prd
│   ├── arch-standards/           # NEW: architecture reference data
│   ├── arch-create/              # NEW: 8-step architecture workflow
│   └── arch-validate/            # FUTURE
├── agents/
│   ├── prd-validator.md
│   └── arch-validator.md         # FUTURE
├── hooks/hooks.json              # Updated matchers
└── scripts/
    ├── validate-prd-format.sh
    └── validate-arch-format.sh   # NEW
```

**Pros:** Works with current plugin system. `ls skills/` shows grouped names.
**Cons:** Still flat. At 20+ skills, it's a long list. Skill names change (breaks existing references).

### Option B: Phase-Grouped Directories (Recommended)

Introduce phase subdirectories inside `skills/`. Each phase is a folder containing its skills.

```
plugins/sdlc/
├── commands/
│   ├── prd-create.md             # RENAMED for consistency
│   ├── prd-validate.md
│   ├── prd-edit.md
│   ├── arch-create.md            # NEW
│   ├── arch-validate.md          # FUTURE
│   └── help.md
├── skills/
│   ├── prd/                      # Phase group
│   │   ├── standards/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       ├── prd-purpose.md
│   │   │       ├── project-types.csv
│   │   │       └── domain-complexity.csv
│   │   ├── create/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       ├── step-01-init.md ... step-12-complete.md
│   │   │       └── prd-template.md
│   │   ├── validate/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   │       └── step-v-01-discovery.md ... step-v-13-report-complete.md
│   │   └── edit/
│   │       ├── SKILL.md
│   │       └── references/
│   │           └── step-e-01-discovery.md ... step-e-04-complete.md
│   │
│   └── architecture/             # Phase group — NEW
│       ├── standards/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── arch-purpose.md
│       │       ├── project-types.csv
│       │       └── domain-complexity.csv
│       └── create/
│           ├── SKILL.md
│           └── references/
│               ├── step-01-init.md ... step-08-complete.md
│               └── architecture-decision-template.md
│
├── agents/
│   ├── prd-validator.md
│   └── arch-validator.md         # FUTURE
├── hooks/hooks.json
└── scripts/
    ├── validate-prd-format.sh
    └── validate-arch-format.sh   # NEW
```

**Pros:** Clean visual hierarchy. Each phase is self-contained. Scales to 8+ phases without clutter. Easy to navigate.
**Cons:** Requires verifying that Claude's plugin system discovers skills in nested paths (`skills/prd/create/SKILL.md`). If it only scans one level deep (`skills/*/SKILL.md`), this won't work.

**Mitigation:** If nested discovery isn't supported, we use Option A naming with the understanding that it's a flat approximation. Or we contribute a plugin system enhancement to support recursive skill discovery.

---

## Recommendation: Option B with Fallback

1. **Test nested skill discovery** — Create a test skill at `skills/prd/create/SKILL.md` and verify Claude Code finds it.
2. **If supported** → Use Option B (phase-grouped).
3. **If not supported** → Use Option A (phase-prefixed flat) and name skills as `prd-create`, `arch-create`, etc.

Either way, commands follow the same naming: `/sdlc:prd-create`, `/sdlc:arch-create`.

---

## Migration Steps

### Phase 1: Restructure existing PRD skills

1. **Create phase directory structure:**
   - `skills/prd/standards/` ← move from `skills/prd-standards/`
   - `skills/prd/create/` ← move from `skills/create-prd/`
   - `skills/prd/validate/` ← move from `skills/validate-prd/`
   - `skills/prd/edit/` ← move from `skills/edit-prd/`

2. **Update internal references:**
   - All `${PLUGIN_ROOT}/skills/prd-standards/references/...` → `${PLUGIN_ROOT}/skills/prd/standards/references/...`
   - All `${PLUGIN_ROOT}/skills/create-prd/references/...` → `${PLUGIN_ROOT}/skills/prd/create/references/...`
   - Same for validate-prd and edit-prd paths

3. **Update SKILL.md names:**
   - `prd-standards` → `prd/standards`
   - `create-prd` → `prd/create`
   - `validate-prd` → `prd/validate`
   - `edit-prd` → `prd/edit`

4. **Update command files:**
   - Rename commands to `prd-create.md`, `prd-validate.md`, `prd-edit.md` (phase-first naming)
   - Update skill loading references inside each command

5. **Update agent references:**
   - `prd-validator.md` → update preloaded skill names

6. **Update hooks.json:**
   - No structural change needed (hooks reference scripts, not skills)

7. **Verify:** Run `/sdlc:prd-create` and confirm full workflow still works.

### Phase 2: Add Architecture workflow

1. **Create architecture phase directory:**
   ```
   skills/architecture/
   ├── standards/
   │   ├── SKILL.md
   │   └── references/
   │       ├── arch-purpose.md          # Adapted from workflow.md
   │       ├── project-types.csv        # From _bmad data/
   │       └── domain-complexity.csv    # From _bmad data/
   └── create/
       ├── SKILL.md                     # Adapted from workflow.md
       └── references/
           ├── step-01-init.md          # From _bmad steps/
           ├── step-01b-continue.md
           ├── step-02-context.md
           ├── step-03-starter.md
           ├── step-04-decisions.md
           ├── step-05-patterns.md
           ├── step-06-structure.md
           ├── step-07-validation.md
           ├── step-08-complete.md
           └── architecture-decision-template.md
   ```

2. **Create command:**
   - `commands/arch-create.md` — Entry point, loads config, loads `architecture/create` skill

3. **Adapt step files from `_bmad/bmm/workflows/3-solutioning/create-architecture/`:**
   - Add proper YAML frontmatter (`name`, `nextStepFile`, `outputFile`)
   - Update `${PLUGIN_ROOT}` references for new paths
   - Replace `{workflow_root}` references with `${PLUGIN_ROOT}/skills/architecture/create/references/`
   - Ensure step files follow the same patterns as PRD steps (menu pattern, mandatory rules, etc.)

4. **Create SKILL.md files:**
   - `architecture/standards/SKILL.md` — Reference skill for architecture methodology
   - `architecture/create/SKILL.md` — 8-step workflow definition, `disable-model-invocation: true`

5. **Update hooks.json:**
   - Add PostToolUse matcher for `*arch*` files → `validate-arch-format.sh`

6. **Create validation script:**
   - `scripts/validate-arch-format.sh` — Check architecture doc for required sections

7. **Update help command:**
   - Add architecture commands to `/sdlc:help`

### Phase 3: Shared data consolidation (optional optimization)

If PRD and architecture share identical CSV data:

1. Create `skills/shared/` or `data/` at plugin root
2. Move shared CSVs there
3. Update all `${PLUGIN_ROOT}` references
4. Keep phase-specific data in phase directories

Skip this if CSV files differ between phases (architecture's `project-types.csv` has different columns than PRD's).

---

## Architecture Workflow Adaptation Notes

The `_bmad` workflow needs these adaptations to become a plugin skill:

### Step file frontmatter additions

Each step file needs standardized frontmatter:

```yaml
---
name: 'step-01-init'
description: 'Initialize architecture workflow'
nextStepFile: 'step-01b-continue.md'
outputFile: '{planning_artifacts}/architecture.md'
templateFile: 'architecture-decision-template.md'
---
```

### Key differences from PRD workflow

| Aspect | PRD Workflow | Architecture Workflow |
|--------|-------------|----------------------|
| Steps | 12 | 8 |
| Input dependency | None (standalone) | Requires PRD |
| Web search | Not used | Used in steps 3-4 (starter templates, version checks) |
| Data files | project-types.csv, domain-complexity.csv | Own variants of both |
| Output | `prd.md` | `architecture.md` |
| Optional steps | Domain (5), Innovation (6) | None — all steps execute |
| Menu style | Standard C menu | A/P/C menu (Advanced/Party/Continue) — simplify to C menu for plugin |

### Menu simplification

The `_bmad` workflow uses an A/P/C menu pattern (Advanced Elicitation, Party Mode, Continue). For the plugin, simplify to the standard menu pattern used by PRD workflows (Continue + contextual options). Advanced Elicitation and Party Mode are separate BMAD concerns, not plugin features.

### Web search dependency

Steps 3 (starter template evaluation) and 4 (architectural decisions) use web search to verify current technology versions. The subagent and skill need `WebSearch` in their tool list if this is preserved.

---

## Future Phase Slots

The restructured plugin accommodates future SDLC phases cleanly:

```
skills/
├── prd/                  # v1.0 ✓
├── architecture/         # v1.1 (this plan)
├── ux/                   # FUTURE
├── epics/                # FUTURE
├── sprint/               # FUTURE
├── implementation/       # FUTURE
├── qa/                   # FUTURE
└── retro/                # FUTURE
```

Each phase follows the same pattern:
- `{phase}/standards/` — Reference skill with methodology + data
- `{phase}/create/` — Primary workflow
- `{phase}/validate/` — Quality audit workflow
- `{phase}/edit/` — Improvement workflow

Commands follow `/{plugin}:{phase}-{action}` pattern: `/sdlc:arch-create`, `/sdlc:ux-create`, `/sdlc:epics-create`.

---

## Command Naming Convention

Shift from action-first to phase-first naming for consistency:

| Current | Proposed | Rationale |
|---------|----------|-----------|
| `/sdlc:create-prd` | `/sdlc:prd-create` | Groups by phase when listing |
| `/sdlc:validate-prd` | `/sdlc:prd-validate` | Groups by phase when listing |
| `/sdlc:edit-prd` | `/sdlc:prd-edit` | Groups by phase when listing |
| — | `/sdlc:arch-create` | NEW |
| — | `/sdlc:arch-validate` | FUTURE |
| `/sdlc:help` | `/sdlc:help` | Unchanged |

Phase-first naming means `ls commands/` and tab-completion naturally groups related commands together.

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Nested skill discovery not supported | High — Option B fails | Test first. Fallback to Option A (flat + prefixes) |
| Breaking existing users on rename | Medium — `/sdlc:create-prd` stops working | Keep old commands as aliases (one-line redirects to new names) for one release |
| Architecture step files need heavy adaptation | Low — structure is similar | Follow PRD step files as template, mostly frontmatter + path changes |
| Shared CSV divergence | Low — data may differ | Keep separate copies per phase, consolidate only if identical |

---

## Success Criteria

1. `ls skills/` shows 2 phase directories (prd, architecture) instead of 7+ flat skill folders
2. `/sdlc:prd-create` works identically to current `/sdlc:create-prd`
3. `/sdlc:arch-create` runs the 8-step architecture workflow end-to-end
4. Architecture workflow correctly discovers and uses PRD output as input
5. Hooks validate both PRD and architecture file formats
6. `/sdlc:help` documents all commands across both phases
