---
title: Wiki Ingest
description: Deliberate deep-dive into a file, directory, or topic. Reads the target, updates or creates affected wiki pages, updates index.md, and logs the operation. Use when you've added or substantially changed a feature and want the wiki to reflect it properly.
---

# /wiki-ingest [path]

Deliberate, focused update of the wiki based on a specific file, directory, or topic.

Argument:
- `[path]` — optional. A file path, directory, or a short topic description (e.g. "the new rate limiter", "src/routes/search.ts").
- If omitted, ask the user what to ingest.

**Requires**: the `wiki-maintainer` skill. Load it and follow its conventions. Respect `wiki/SCHEMA.md`.

## Step 1 — Preconditions

- If `wiki/` does not exist, tell the user to run `/wiki-init` first. Stop.
- If `wiki/SCHEMA.md` does not exist, use the defaults from the skill and warn the user.

## Step 2 — Resolve the target

- If `[path]` is a file or directory that exists: that's the target.
- If it's a topic description: scan the repo to identify the relevant files (grep for keywords, look at recent git log, ask the user if ambiguous).
- If no path was given: ask the user which area of the code to ingest.

Announce the resolved target to the user before proceeding.

## Step 3 — Read the target

Read every relevant source file in scope. For large directories, read selectively:
- All files directly in the target directory
- Files imported/required by those files, one level deep (if needed for understanding)
- Related test files

Note what you learn — key functions, types, flows, decisions, dependencies.

## Step 4 — Determine affected wiki pages

A single ingest typically affects 5–15 pages. For each page below, decide whether it needs updating:

- **`overview.md`** — does the high-level description need adjustment?
- **`modules/<relevant>.md`** — likely the primary target; create if missing.
- **Other `modules/*.md`** — does anything cross-reference the target?
- **`architecture/decisions.md`** — was there a design choice worth recording as an ADR?
- **`architecture/data-model.md`** — did data shapes change or get introduced?
- **`glossary.md`** — any new domain terms to define?
- **`index.md`** — always updated if pages were added/renamed/removed.
- **`log.md`** — always appended.

List these affected pages to yourself before editing.

## Step 5 — Update the pages

For each affected page:

1. Read the current version.
2. Make the minimum edit that keeps the page accurate. Do not rewrite sections that are still correct.
3. Update frontmatter: `updated`, `sources`, `source_commit` (if git available), `confidence`.
4. If you are correcting a previous claim, add a **supersession note**:
   > **Superseded YYYY-MM-DD**: previously said "...", replaced because <reason>.
5. Preserve wikilinks and cross-references. Add new ones where helpful.

If a page needs to be created:
1. Give it proper frontmatter.
2. Write it following the schema's style rules (Mermaid, tables, short focused sections).
3. Add a link to it from `index.md`.

## Step 6 — Update index.md

If pages were added, renamed, or removed, update `index.md`. Keep the one-line summaries fresh — if a module's description has shifted, update its index line even if the page itself wasn't a focus of this ingest.

## Step 7 — Append to log.md

```markdown
## [YYYY-MM-DD] ingest | <short description of what was ingested>
- Target: <path or topic>
- Pages touched: <count>
- Pages created: <list>
- Pages updated: <list>
- Notable changes: <one or two bullets on what meaningfully changed>
- Follow-up: <anything that needs user attention, or "none">
```

## Step 8 — Report to user

Reply concisely:

- What was ingested (one line)
- Which pages were touched, grouped by created/updated
- Any notable findings (e.g. "Noted the new auth middleware as ADR-005", "Flagged that the old SHA-1 claim is now superseded")
- Anything that should prompt a follow-up (e.g. "Consider running `/wiki-lint` to check for related drift")

## Guardrails

- Never modify source code.
- Never delete pages during ingest — if a page seems redundant, flag it for `/wiki-lint` instead.
- If you find you'd need to rewrite more than half the wiki to accommodate this ingest, stop and tell the user — they probably want `/wiki-lint` or a deliberate reorganization, not an ingest.
- Keep confidence honest. If you're extrapolating beyond what the code clearly shows, mark it `medium` or `low` and say so in the page.
