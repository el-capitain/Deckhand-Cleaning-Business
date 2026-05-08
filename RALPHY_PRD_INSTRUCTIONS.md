# Ralphy PRD Instructions

A complete guide for formatting, writing, and maintaining PRDs for use with [Ralphy](https://github.com/michaelshimeles/ralphy), an autonomous AI coding loop CLI. Use this document whenever you need to:

- Create a new PRD from scratch
- Add new features/phases to an existing PRD
- Convert a non-Ralphy PRD into Ralphy-compatible format
- Troubleshoot issues with Ralphy execution

---

## 1. How Ralphy Works

### The Execution Loop

1. Ralphy reads the PRD file and extracts all incomplete tasks (lines matching `- [ ]`)
2. It selects the **first** incomplete task (top-to-bottom order = priority order)
3. It builds a prompt containing:
   - The **entire PRD file** as context (via `@PRD.md`)
   - A **progress history file** (via `@.ralphy/progress.txt`) showing what was already done
   - **Project config/rules** from `.ralphy/config.yaml` (if present)
   - The instruction: "Find the highest-priority incomplete task and implement it"
   - Follow-up steps: write tests, run tests, run linting, mark task complete, commit
4. The AI agent implements the task, then changes `- [ ]` to `- [x]` in the PRD
5. The loop repeats from step 1 until no `- [ ]` tasks remain

### Key Implications

- **The agent sees the full PRD** — all your context, specifications, data models, and API contracts are available. The task title doesn't need to contain everything, but it must be specific enough to identify exactly what to build.
- **One task per loop iteration** — the agent is explicitly told "ONLY WORK ON A SINGLE TASK." If a task is too large, the agent may do it poorly or partially.
- **Order matters** — tasks are processed top-to-bottom. Earlier tasks must not depend on later ones.
- **The agent commits after each task** — each task produces one atomic commit. This means each task should leave the codebase in a working state.
- **Progress is cumulative** — the agent can see its own history of completed tasks. Later tasks benefit from knowing what was already built.
- **Task titles become the primary instruction** — while the full PRD is context, the `- [ ]` line is what the agent focuses on. Vague titles produce vague implementations.

### Supported PRD Formats

| Format | Syntax | Parallel Support | Best For |
|--------|--------|-----------------|----------|
| **Markdown** (default) | `- [ ]` / `- [x]` checkboxes | No (sequential only) | Most projects |
| **YAML** | `title` + `completed` + `parallel_group` | Yes | Parallel execution |
| **JSON** | Same fields as YAML | Yes | Programmatic generation |
| **GitHub Issues** | `ralphy --github owner/repo` | No | Issue-driven workflows |
| **Directory** | `prd/` folder with multiple `.md` files | Per-file tracking | Large projects |

This guide focuses on **Markdown format** as it's the most common.

---

## 2. PRD File Structure

A Ralphy-compatible PRD has two parts:

### Part 1: Context Sections (Reference Material)

These are NOT tasks — they are context the agent reads to understand the project. They should appear **before** the task list so the agent reads them first.

Context sections typically include:
- Product overview and problem statement
- User personas and user stories (US-01, US-02, etc.)
- Functional requirements with detailed specifications (FR-01, FR-02, etc.)
- Non-functional requirements
- Technical architecture and tech stack decisions
- Data models / database schema (Prisma models, enums, constraints)
- API contracts with request/response examples
- UI/UX specifications and design system
- Constraints, out-of-scope items, and explicit "do not" rules
- Environment variables and configuration

**These sections are critical.** The agent uses them to make implementation decisions. The richer your context, the better the output. Do not strip this material out — Ralphy passes all of it to the agent.

**When adding a new feature**, always add context FIRST (user story, functional requirement, UI spec), then add the tasks that reference that context. Tasks without corresponding context sections produce worse results.

### Part 2: Task List (The Work)

This is the section Ralphy actually parses. Every actionable item must be a markdown checkbox:

```markdown
## Tasks

- [ ] Task description here
- [ ] Another task description here
- [x] This task is already done (ralphy will skip it)
```

**Parsing rule:** Ralphy matches lines starting with `- [ ]` (incomplete) or `- [x]` (complete). Only these lines are treated as tasks. Everything else is context.

---

## 3. Writing Good Tasks

### The Micro-Task Principle

> Break large tasks into micro-tasks. Smaller tasks = better code quality.

> **Bad:** `- [ ] Implement user authentication`
> **Good:**
> ```
> - [ ] Create User model with email and password fields
> - [ ] Add password hashing utility function
> - [ ] Create signup API endpoint
> - [ ] Create login API endpoint
> - [ ] Add session/token generation
> - [ ] Create logout endpoint
> ```

Each task should be **one logical unit of work** that can be implemented, tested, and committed in a single pass.

### Task Title Guidelines

1. **Be specific and actionable** — the title should tell the agent exactly what to build
   - Bad: `- [ ] Set up the database`
   - Good: `- [ ] Write Prisma schema with User, Post, and Comment models and run initial migration`

2. **Reference your spec sections** — point the agent to the relevant context in your PRD
   - Good: `- [ ] Build POST /api/orders endpoint per FR-03 (validation: caps, allocations, window check)`
   - Good: `- [ ] Build kitchen view UI per Section 8 (dark theme, 44px touch targets, order list with action buttons)`

3. **Name the files/components** when the output is specific
   - Good: `- [ ] Create lib/allocations.ts with checkAllocation() and decrementAllocation() functions`
   - Good: `- [ ] Build BreakfastSection.tsx component with quantity stepper and egg stepper`

4. **State the expected outcome**, not just the activity
   - Bad: `- [ ] Work on authentication`
   - Good: `- [ ] Build POST /api/auth/send-link: validate email, generate token, send magic link email, return generic response`

5. **Include constraints or edge cases** that might be missed
   - Good: `- [ ] Build member ordering page — pre-populate from existing order, disable when deadline passed, show cap messages`

6. **When adding enums or roles, list ALL files that have hardcoded checks** — the agent may update the central definition but miss manual checks scattered across the codebase
   - Good: `- [ ] Add MASTER to Role enum; update requireRole in auth.ts; update manual role checks in src/app/api/kitchen/orders/route.ts (line 29) and src/app/api/kitchen/orders/[id]/route.ts (line 36) to also accept MASTER`
   - Bad: `- [ ] Add MASTER role` (agent will miss the hardcoded checks)

7. **When modifying settings that are used in code, specify which files read from those settings** — the agent may update the settings UI but leave hardcoded values in the code
   - Good: `- [ ] Make ordering deadline configurable: update POST /api/orders to read orderDeadlineHour from VenueSettings instead of the hardcoded DEADLINE_HOUR = 4 constant`
   - Bad: `- [ ] Make ordering deadline configurable` (agent will add the setting but code will still use hardcoded value)

### Task Sizing

A well-sized task:
- Touches 1-3 files (occasionally up to 5 for a feature with route + component + lib)
- Can be described in one sentence
- Produces a meaningful, testable increment
- Leaves the codebase in a buildable/runnable state after completion

Signs a task is **too large**:
- It says "implement" a whole feature area (auth, ordering, reporting)
- It would require creating more than 5 new files
- It bundles unrelated concerns (API + UI + tests + seed data)
- You'd struggle to describe what "done" looks like in one sentence

Signs a task is **too small**:
- It's just creating an empty file or directory
- It's installing a single dependency with no configuration
- It doesn't produce anything testable or meaningful on its own

---

## 4. Task Ordering

Tasks execute top-to-bottom. Order them so that:

1. **Schema changes first** — database migrations, new models, new fields
2. **Shared utilities next** — lib modules, helpers, constants that other tasks need
3. **API endpoints before UI** — build the backend endpoint before the frontend that calls it
4. **Features in dependency order** — build what other features need before the features that need it
5. **Tests alongside or after features** — not before the code they test
6. **Polish and integration last** — responsive design, error boundaries, seed data

### Dependency Chains

If Task B depends on Task A's output, Task A must appear first:

```markdown
- [ ] Write Prisma schema with all models and run initial migration
- [ ] Create Prisma client singleton in lib/db.ts
- [ ] Build POST /api/auth/send-link endpoint (needs db client + schema)
- [ ] Build login page UI (needs auth endpoint to exist)
```

Never assume the agent will figure out implicit dependencies. If the order matters, enforce it by position.

---

## 5. Task Grouping

Group tasks by logical phase or feature area using markdown headings. Headings are ignored by Ralphy's parser (only `- [ ]` lines matter) but they help both humans and the AI agent understand the structure:

```markdown
### Phase 14: Admin Settings Page

- [ ] Build GET /api/admin/settings route per FR-10
- [ ] Build PATCH /api/admin/settings route per FR-10
- [ ] Build SettingsPageClient.tsx component
- [ ] Build the admin settings page and add nav link
```

### Numbering Phases

When adding new features to an existing PRD:
- Continue the phase numbering from where the last phase left off
- Don't renumber existing completed phases — this creates confusing git diffs
- If you insert a phase between existing ones, use the next available number (don't try to wedge it in)

---

## 6. Adding New Features to an Existing PRD

This is the most common workflow after the initial build. Follow this process:

### Step 1: Add Context Sections

Before writing any tasks, add the supporting context to the PRD:

- **User Story** (e.g., US-14) — who wants what and why
- **Functional Requirement** (e.g., FR-14) — detailed specification with processing steps, validation rules, error handling
- **UI/UX Spec** (if applicable) — screen description, components, states, layout
- **Data Model Changes** (if applicable) — new fields, new models, enum additions

Place these in the appropriate existing sections of the PRD (alongside the other USs, FRs, etc.), not at the bottom.

### Step 2: Write Tasks

Add a new `### Phase N:` section at the end of the task list with `- [ ]` tasks. Follow the micro-task principle and ordering rules.

### Step 3: Cross-Reference

Each task should reference the context you added: "per FR-14", "per US-14", "per the UI spec in Section 8". This helps the agent find the relevant specification.

### Step 4: Verify Dependencies

Read through your new tasks top-to-bottom and ask: "Could the agent complete this task if only the tasks above it (including all completed tasks) were done?" If not, reorder.

---

## 7. What NOT to Put in Tasks

1. **Don't duplicate context** — the agent already sees the full PRD. Don't paste the entire FR spec into the task title.
   - Bad: `- [ ] Build POST /api/orders: validate session, check member_id from session not form, validate ordering window is open (current time < 4:00 AM on order_date), check personal daily cap if existing breakfast orders...` (50 more words)
   - Good: `- [ ] Build POST /api/orders endpoint per FR-03 (all validation: session, caps, allocations, window)`

2. **Don't include process instructions** — Ralphy already tells the agent to write tests, run linting, and commit. Don't repeat these in task titles.
   - Bad: `- [ ] Build login page and write tests and commit`
   - Good: `- [ ] Build login page UI per Section 8 (email input, loading/success/error states)`

3. **Don't add research or decision tasks** — Ralphy expects each task to produce code. "Decide on a charting library" is not a task; the decision should be made in your context sections.

4. **Don't add conditional tasks** — every `- [ ]` will be executed. Don't write "if needed" tasks.

---

## 8. Parallel Execution (Optional)

If using `ralphy --parallel`, you can run independent tasks concurrently. This requires **YAML format** with `parallel_group` fields:

```yaml
tasks:
  # Group 1: independent setup tasks run in parallel
  - title: Create database schema and run migration
    completed: false
    parallel_group: 1

  - title: Configure ESLint and Prettier
    completed: false
    parallel_group: 1

  # Group 2: depends on group 1, these run in parallel with each other
  - title: Build auth API endpoints
    completed: false
    parallel_group: 2

  - title: Build order API endpoints
    completed: false
    parallel_group: 2
```

Rules for parallel groups:
- Tasks in the same `parallel_group` number run concurrently
- Lower-numbered groups complete before higher-numbered groups start
- Tasks without a `parallel_group` run sequentially after all groups
- Each parallel agent gets an **isolated git worktree** — they cannot conflict
- Parallel tasks must be **truly independent** (no shared file modifications)

For markdown-format PRDs, all tasks run sequentially. Use YAML if you need parallelism.

---

## 9. Project Configuration (.ralphy/config.yaml)

Create this via `ralphy --init` to give the agent additional context:

```yaml
project:
  name: "my-app"
  language: "TypeScript"
  framework: "Next.js 14"
  description: "Brief project description"

commands:
  test: "pnpm test"
  lint: "pnpm lint"
  build: "pnpm build"

rules:
  - "Use App Router, not Pages Router"
  - "All times stored as UTC in database, displayed as Australia/Melbourne"
  - "Use Prisma for all database access, never raw SQL"
  - "Follow the data models exactly as specified in the PRD Section 7"

boundaries:
  never_touch:
    - "PRD.md"
    - "PRD_Original.md"
    - "CLAUDE.md"
    - "RALPHY_PRD_INSTRUCTIONS.md"
    - "*.lock"

capabilities:
  browser: "auto"  # "auto", "true", or "false"
```

- **rules** are injected into every prompt with the prefix "you MUST follow these"
- **boundaries** prevent the agent from modifying listed files
- **commands** tell the agent how to run tests and linting
- **capabilities** control browser automation for UI testing

### CLI Flags Reference

| Flag | Purpose |
|------|---------|
| `--prd PATH` | Task file or folder (default: PRD.md) |
| `--parallel` | Run parallel tasks (YAML only) |
| `--max-parallel N` | Max concurrent agents (default: 3) |
| `--branch-per-task` | Create a git branch per task |
| `--create-pr` | Create pull requests for branches |
| `--no-tests` / `--no-lint` | Skip validation |
| `--fast` | Skip tests + lint |
| `--max-iterations N` | Stop after N tasks |
| `--max-retries N` | Retries per failed task (default: 3) |
| `--dry-run` | Preview tasks without executing |
| `--init` | Setup .ralphy/ config |
| `--config` | Show current config |
| `--add-rule "rule"` | Add a rule to config |

---

## 10. Lessons Learned (Operational)

These are hard-won lessons from real Ralphy builds. They are not in the official docs but will save you time and bugs.

### 10.1: Always Include a "Boot and Verify" Task

Ralphy writes tests, but tests often mock the database and never actually run the app. After a build, the app may not boot due to:
- Missing database adapters or drivers
- Broken seed scripts
- Import path issues (especially with custom Prisma output directories)
- Configuration that exists in schema but isn't wired to code

**Fix:** Add a task at the end of each major build phase: "Verify the app boots locally: run migrations, seed the database, start the dev server, and confirm the main pages load without errors."

### 10.2: Hardcoded Values Survive New Features

When you add a new enum value (e.g., a new role like MASTER), Ralphy will:
- ✅ Add it to the schema enum
- ✅ Update the central `requireRole()` function
- ❌ Miss manual checks like `if (role !== "ADMIN" && role !== "KITCHEN")`

These hardcoded checks are scattered across API routes and layouts. Ralphy doesn't know about them unless you tell it.

**Fix:** In the task description, explicitly list every file with hardcoded checks that need updating. Search the codebase for the existing enum values before writing the task.

### 10.3: Settings in the DB ≠ Settings Used in Code

A common pattern: you add a configurable setting to VenueSettings, build a UI for it, but the code still uses a hardcoded constant. The setting is editable but does nothing.

**Fix:** When writing a task to make something configurable, name the specific file and line where the hardcoded value lives: "update POST /api/orders to read orderDeadlineHour from VenueSettings instead of the hardcoded DEADLINE_HOUR = 4 constant on line 13."

### 10.4: Route Groups Create URL Conflicts

In Next.js App Router, `(group)/page.tsx` maps to `/`, not `/group`. This means:
- `(kitchen)/page.tsx` → `/` (conflicts with root `page.tsx`)
- `(member)/order/page.tsx` → `/order` (works fine — has a path segment)

**Fix:** Always give route group pages an explicit path segment: `(kitchen)/kitchen/page.tsx` → `/kitchen`.

### 10.5: Post-Ralphy Code Review Catches Real Bugs

Every batch of Ralphy work benefits from a human or AI code review. Common issues found:
- Cache not invalidated after settings updates
- Stale copy/text that contradicts new features (e.g., "link expires in 48 hours" after making links permanent)
- Redirects pointing to pages that don't handle the error state
- Duplicated constants/types across files instead of importing from a shared module
- Missing `await` on async operations
- Role checks not updated for new roles

**Fix:** After each Ralphy run, do a review focusing on: (1) are new settings actually read by the code? (2) is old copy/text still accurate? (3) are all role checks updated? (4) are there duplicated definitions?

### 10.6: Seed Scripts Need Testing Too

The seed script is code that Ralphy writes but never runs (it runs tests, not seeds). Common seed issues:
- Import paths that work in Next.js but not in standalone Node
- Missing database adapters (Prisma 7+ requires explicit driver adapters)
- ESM/CJS incompatibilities with the Prisma client

**Fix:** Include a "verify seed script runs successfully" task after any schema changes. Or better, run `pnpm prisma db seed` manually after each Ralphy batch.

### 10.7: Test Mocks Can Hide Real Integration Issues

Ralphy's tests typically mock the database, which means:
- ✅ Tests pass even if the database schema is wrong
- ✅ Tests pass even if the Prisma client can't connect
- ❌ The app crashes when you actually try to use it

**Fix:** Include integration test tasks that hit real database operations (or at least verify the Prisma schema is valid). Don't rely solely on mocked unit tests.

---

## 11. Checklist: PRD Readiness

Before running `ralphy --prd PRD.md`, verify:

- [ ] All context/specification sections appear BEFORE the task list
- [ ] Every task is a `- [ ]` checkbox line (Ralphy ignores everything else as context)
- [ ] Tasks are ordered by dependency (schema → utilities → API → UI → tests → polish)
- [ ] Each task is a single, atomic unit of work (1-3 files, one logical change)
- [ ] Task titles are specific enough that the agent knows exactly what to build
- [ ] Task titles reference relevant spec sections (e.g., "per FR-03", "per Section 8")
- [ ] No task depends on a task that appears after it
- [ ] Each task leaves the codebase in a buildable state
- [ ] No duplicate or overlapping tasks
- [ ] No process instructions in tasks (tests/lint/commit are handled by Ralphy)
- [ ] No research, decision, or conditional tasks — only concrete implementation work
- [ ] `.ralphy/config.yaml` exists with project info, commands, rules, and boundaries
- [ ] Tasks that add new enum values list ALL files with hardcoded checks
- [ ] Tasks that add configurable settings name the files with hardcoded values to replace
- [ ] A "verify the app boots" task exists at the end of each major phase

---

## 12. Converting an Existing PRD

If you have a PRD with large phase-based tasks, convert it using this process:

1. **Keep all context sections intact** — product overview, user stories, functional requirements, data models, API contracts, UI specs, constraints. Move them above the task list if they aren't already.

2. **Decompose each phase into micro-tasks:**
   - For each phase, list every distinct piece of work (file, endpoint, component, utility)
   - Each piece becomes its own `- [ ]` line
   - Order them by internal dependencies within the phase

3. **Flatten phases into a single ordered task list** — Ralphy doesn't understand phase boundaries, only top-to-bottom order. The first `- [ ]` it finds is the next task.

4. **Add cross-references** — annotate each task with which FR, US, or Section it implements so the agent can find the relevant context in the PRD.

5. **Verify the dependency chain** — read through the task list top-to-bottom and ask: "Could the agent complete this task if only the tasks above it were done?" If not, reorder.

---

## 13. Common Mistakes

1. **Bundling API + UI in one task** — these are separate concerns. Build the endpoint first, then the page that uses it.

2. **Forgetting shared utilities** — if multiple tasks need `lib/auth.ts` or `lib/db.ts`, create those as explicit early tasks. Don't assume the agent will create them when implementing a feature.

3. **Vague "set up" tasks** — "Set up the project" could mean anything. Specify: framework, package manager, dependencies, config files.

4. **Skipping the seed/test data task** — without data, the agent can't verify its own work. Add seed tasks early.

5. **Putting tests in separate tasks from features** — Ralphy already tells the agent to write tests for each task. You only need separate test tasks for integration tests or test infrastructure setup.

6. **Ordering UI before API** — the frontend page will make API calls. If the endpoint doesn't exist yet, the agent either stubs it (creating tech debt) or builds it inline (creating a mess). Build API first.

7. **Tasks that modify the same file** — if two adjacent tasks both need to edit `schema.prisma`, consider combining them or ensuring the first task produces a complete, valid schema that the second task extends.

8. **Adding a new role/enum without listing affected files** — the agent updates the central definition but misses scattered hardcoded checks. Always search for existing values and list every file that needs updating.

9. **Making settings configurable without connecting them to code** — adding a setting to VenueSettings and a UI for it, but the code still reads from a hardcoded constant. Always name the file and constant to replace.

10. **Not reviewing after Ralphy completes** — Ralphy produces working code with passing tests, but tests often mock away real integration issues. Always review for: stale copy, missing cache invalidation, duplicated constants, and hardcoded values that should read from settings.

---

## 14. Quick Reference

### Adding a Simple Feature (1-2 tasks)

1. Add FR/US context to the PRD
2. Add `### Phase N: Feature Name` with 1-2 `- [ ]` tasks
3. Run `ralphy --prd PRD.md`

### Adding a Complex Feature (5+ tasks)

1. Add US, FR, and UI spec context to the PRD
2. Add `### Phase N: Feature Name` with tasks ordered: schema → API → UI → tests
3. Include a task to update the seed script if schema changed
4. Run `ralphy --prd PRD.md`
5. Review the output for hardcoded values, stale copy, and missing wiring

### Fixing a Bug

1. Add a single `- [ ]` task describing the bug and the fix
2. Be specific: name the file, the line, and what's wrong
3. Run `ralphy --prd PRD.md`

### Documenting Direct Fixes

If you fix something manually (not via Ralphy), add a note in the PRD:
```markdown
### Post-Review Direct Fixes (applied manually, not via Ralphy)

- [x] **Description of fix:** what was changed, why, and which files were affected
```

This keeps the PRD as the single source of truth for what was built.
