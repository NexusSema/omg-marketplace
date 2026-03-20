---
name: 'step-03-starter'
description: 'Evaluate and select starter templates based on project requirements and technical preferences'
nextStepFile: 'step-04-decisions.md'
outputFile: '{planning_artifacts}/architecture.md'
projectTypesCSV: '${PLUGIN_ROOT}/skills/architecture/standards/references/project-types.csv'
---

# Step 3: Starter Template Evaluation

**Progress: Step 3 of 8** — Next: Core Architectural Decisions

## MANDATORY EXECUTION RULES (READ FIRST)

- NEVER generate content without user input
- ALWAYS treat this as collaborative discovery between architectural peers
- YOU ARE A FACILITATOR, not a content generator
- FOCUS on evaluating starter template options with current versions
- ALWAYS use WebSearch to verify current versions — NEVER trust hardcoded versions
- ABSOLUTELY NO TIME ESTIMATES
- CRITICAL: ALWAYS read the complete step file before taking any action
- CRITICAL: When loading next step with 'C', ensure the entire file is read and understood before proceeding
- YOU MUST ALWAYS SPEAK OUTPUT in your Agent communication style with the config `{communication_language}`

### Role Reinforcement
- You are an architectural facilitator collaborating with an expert peer
- If you already have been given a name, communication_style and persona, continue to use those

## EXECUTION PROTOCOLS

- Show your analysis before taking any action
- Use WebSearch to verify current versions and options
- Present [C] Continue menu after generating starter template analysis
- ONLY save when user chooses C (Continue)
- Update frontmatter `stepsCompleted: [1, 2, 3]` before loading next step
- FORBIDDEN to load next step until C is selected

## YOUR TASK

Discover technical preferences and evaluate starter template options, leveraging existing technical preferences and establishing solid architectural foundations.

## STARTER EVALUATION SEQUENCE

### 0. Check Technical Preferences & Context

Check Project Context for existing technical preferences. If found, present them. If not, establish preferences now.

**Discover User Technical Preferences:**
- Languages (TypeScript/JavaScript, Python, Go, Rust, etc.)
- Frameworks (React, Vue, Angular, Next.js, etc.)
- Databases (PostgreSQL, MongoDB, MySQL, etc.)
- Team experience level
- Cloud providers (AWS, Vercel, Railway, etc.)
- Integrations needed

### 1. Identify Primary Technology Domain

Based on project context and preferences, identify the primary technology stack:
- **Web application** → Next.js, Vite, Remix, SvelteKit starters
- **Mobile app** → React Native, Expo, Flutter starters
- **API/Backend** → NestJS, Express, Fastify, Supabase starters
- **CLI tool** → CLI framework starters (oclif, commander, etc.)
- **Full-stack** → T3, RedwoodJS, Blitz, Next.js starters
- **Desktop** → Electron, Tauri starters

### 2. UX Requirements Consideration

If UX specification was loaded, consider UX requirements when selecting starter (rich animations, complex forms, real-time features, design system, offline capability).

### 3. Research Current Starter Options

Use WebSearch to find current, maintained starter templates. Verify maintenance status and recent updates.

### 4. Analyze What Each Starter Provides

For each viable starter, document technology decisions made, architectural patterns established, and development experience features.

### 5. Present Starter Options

Based on user skill level and project needs, present options with appropriate detail level (Expert: concise list, Intermediate: brief explanations, Beginner: analogies and friendly explanations).

### 6. Get Current CLI Commands

If user shows interest, use WebSearch to get exact current commands.

### 7. Generate Starter Template Content

```markdown
## Starter Template Evaluation

### Primary Technology Domain
{{identified_domain}} based on project requirements analysis

### Starter Options Considered
{{analysis_of_evaluated_starters}}

### Selected Starter: {{starter_name}}

**Rationale:** {{why_this_starter_was_chosen}}

**Initialization Command:**
```bash
{{full_starter_command_with_options}}
```

**Architectural Decisions Provided by Starter:**
- Language & Runtime: {{language_typescript_setup}}
- Styling Solution: {{styling_solution}}
- Build Tooling: {{build_tools}}
- Testing Framework: {{testing_setup}}
- Code Organization: {{project_structure}}
- Development Experience: {{dev_tools}}

**Note:** Project initialization using this command should be the first implementation story.
```

### 8. Present Content and Menu

"I've analyzed starter template options.

**Here's what I'll add to the document:**

[Show the complete markdown content]

**What would you like to do?**
[C] Continue — Save this decision and move to architectural decisions"

### 9. Handle Menu Selection

**If 'C' (Continue):**
- Append the final content to `{planning_artifacts}/architecture.md`
- Update frontmatter: `stepsCompleted: [1, 2, 3]`
- Load `step-04-decisions.md`

## NEXT STEP

After user selects 'C' and content is saved, load `step-04-decisions.md` to begin making specific architectural decisions.
