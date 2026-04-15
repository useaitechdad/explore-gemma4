---
title: Wiki Init
description: Bootstrap a living wiki in this repo. Creates wiki/ with SCHEMA.md, index.md, log.md, overview.md, and module pages, based on an initial analysis of the codebase.
---

# /wiki-init

Bootstrap the wiki for this repository. Run once per repo.

**Requires**: the `wiki-maintainer` skill. Load it and follow its conventions.

## Step 1 — Check preconditions

- If `wiki/` already exists with an `index.md`, stop and ask the user whether to (a) skip, (b) re-init (they must confirm deletion), or (c) run `/wiki-ingest` instead to refresh content.
- If the current directory does not look like a code repo (no source files, no package manifest), ask the user to confirm before proceeding.

## Step 2 — Survey the repo

Do a read-only scan to understand the shape of the codebase:

1. List the top-level directories and files.
2. Read `README.md` if present.
3. Read any obviously architecture-shaping docs (`ARCHITECTURE.md`, `context_map.md`, `project_status.md`, `BUILD_PHASES.md`, `docs/architecture/*`).
4. Read the package manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) to identify framework/stack.
5. Identify the main source directory (`src/`, `lib/`, `app/`, or the repo root if it's a flat project like a single HTML file).
6. Note any existing tests directory.

Do **not** read every source file yet — just enough to form a mental map.

## Step 3 — Propose the plan to the user

Show the user, in a concise message:

- One-sentence summary of what this project appears to be.
- The default wiki structure that will be created.
- The list of modules/areas you plan to create pages for (derived from top-level source directories or natural groupings if the repo is flat).
- Any existing root-level docs that will be superseded and proposed for retirement *after* ingest (do not delete yet).
- Ask: **"Proceed with this plan? Adjust anything?"**

Wait for confirmation before writing files.

## Step 4 — Create the wiki scaffold

After confirmation:

1. Create `wiki/` directory.
2. Locate `default-schema.md` from the `wiki-maintainer` skill and copy it to `wiki/SCHEMA.md`. The skill may be installed either at workspace level (`<repo>/.agents/skills/wiki-maintainer/`) or globally (`~/.gemini/antigravity/skills/wiki-maintainer/`). Check workspace first, fall back to global. If neither exists, stop and tell the user the skill is missing.
3. Fill the "What this repo is about" section in SCHEMA.md with the one-paragraph description from Step 3.
4. Create empty-ish stubs for:
   - `wiki/index.md` (with "# Wiki Index" heading and empty categories)
   - `wiki/log.md` (with the first log entry — see Step 7)
   - `wiki/overview.md` (write this from your Step 2 survey)
   - `wiki/architecture/decisions.md` (empty stub — ADRs will be added as you discover them)
   - `wiki/architecture/data-model.md` (empty stub, or populate if data shapes are already clear)
   - `wiki/glossary.md` (empty stub)
   - `wiki/modules/` directory (leave empty; Step 5 populates it)

Every created page gets frontmatter per the skill's conventions (`title`, `updated`, `sources`, `source_commit` if git is available, `confidence`).

## Step 5 — Write module pages

For each module/area identified in Step 3:

1. Read the files in that module.
2. Write `wiki/modules/<name>.md` covering:
   - What this module does (1-3 sentences)
   - Key files and their roles (markdown table)
   - Public interface (exported functions/classes/endpoints)
   - Dependencies (what it uses, what uses it)
   - A Mermaid diagram if a flow or structure is non-obvious
3. Set confidence based on how well the code reads (`high` if the code is clearly written, `medium` if there's meaningful ambiguity).

For flat projects (e.g. a single HTML file), create a single module page per logical concern (e.g. `modules/ui.md`, `modules/api-client.md`) if the file is large enough to warrant splitting, otherwise skip module pages and put everything in `overview.md`.

## Step 6 — Update index.md

Populate `wiki/index.md` with a navigable catalog of every page created. Group by category (Overview, Architecture, Modules, Reference). One line per entry: `- [page title](path.md) — one-line summary`.

## Step 7 — Write the initial log entry

Append to `wiki/log.md`:

```markdown
## [YYYY-MM-DD] init | bootstrapped wiki
- Scope: <one line>
- Pages created: <count>
- Modules: <list>
- Proposed for retirement: <list of legacy docs, or "none">
- Follow-up: run /wiki-lint to verify coverage
```

## Step 8 — Report to user

Reply with:

- What was created (page count, directory tree under `wiki/`)
- Any legacy root-level docs proposed for retirement (list them; do NOT delete)
- Suggested next step: **run `/wiki-lint` to verify coverage and catch gaps**
- If the skill was found at workspace level (not global), remind the user: once the wiki is working well, consider promoting the skill + workflows to `~/.gemini/antigravity/` for use across all their repos (see `.agents/README.md`).

## Guardrails

- Never modify source code during init.
- Never delete files during init, including legacy docs — only *propose* retirement.
- If the repo is huge (>500 source files), ask the user to narrow the scope before proceeding.
- Keep the initial wiki small and accurate. It's better to have 6 confident pages than 20 half-guessed ones. The wiki grows through `/wiki-ingest` and `/wiki-sync`.
