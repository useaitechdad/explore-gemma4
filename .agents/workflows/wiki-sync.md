---
title: Wiki Sync
description: Fast incremental update from recent diffs. Meant to run automatically after tasks that changed source files. Quiet by default — only reports what changed.
---

# /wiki-sync

Fast, low-ceremony update of the wiki based on what has changed recently.

This is the workflow that runs automatically (via the workspace rule) after tasks that touched source files. It's meant to feel invisible when there's nothing to do, and concise when there is.

**Requires**: the `wiki-maintainer` skill. Respect `wiki/SCHEMA.md`.

## Step 1 — Fast preconditions

- If `wiki/` does not exist → exit silently. No wiki = nothing to sync.
- If no source files have changed since the last sync → exit with a single line: `wiki-sync: nothing to do.`

## Step 2 — Determine what changed

The agent may have just finished a task whose changes are **uncommitted** in the working tree. Sync must detect those, not only committed changes.

**If git is available** (preferred):

1. Get the list of currently-modified files (staged + unstaged + untracked, minus ignored):
   - `git status --porcelain` — shows uncommitted changes
   - `git diff --name-only HEAD` — shows changes vs HEAD (staged + unstaged)
2. Additionally, for each wiki page, collect files in its `sources:` frontmatter whose current git hash differs from the page's `source_commit`:
   - `git log --oneline <source_commit>..HEAD -- <sources_file>` — commits that touched the file since the page was written
3. Union these two sets to get the full list of changed files (uncommitted + committed-since-last-page-update).

**If not a git repo**: use file mtimes. Find source files whose mtime is newer than the `updated` date of any wiki page that lists them in `sources:`.

Filter out files that are out of scope per SCHEMA.md (node_modules, build output, etc.) and the `wiki/` directory itself.

If the change list is empty → exit with `wiki-sync: nothing to do.`

## Step 3 — Map changed files to affected pages

For each changed source file:
- Find wiki pages whose `sources:` frontmatter includes that file.
- Also consider pages that reference that file's module in prose.

Build a dedup'd list of pages to update.

**Limit**: if more than ~10 pages would be affected, this is probably not a "sync" — it's a significant change. Exit with:

> `wiki-sync: <N> pages affected — this looks substantial. Suggest `/wiki-ingest` for a deliberate pass, or `/wiki-lint` to catch drift. Not syncing automatically.`

The goal of sync is the small-update case. Large changes deserve deliberate attention.

## Step 4 — Update affected pages

For each affected page (in the small-update case):

1. Re-read the page and the changed source files.
2. Apply **minimum edits** to keep it accurate:
   - Fix factual claims that no longer match the code.
   - Update frontmatter: `updated`, `source_commit`, possibly lower `confidence` if there's ambiguity.
   - If a claim needs correcting, add a supersession note (per skill conventions).
3. If a new file exists that has no page but belongs to an existing module, extend that module's page rather than creating a new page. (Creating new pages is `/wiki-ingest` territory.)
4. Do NOT reorganize, restructure, or rewrite broadly. Sync is surgical.

If you would need to create a new page to capture a change, **don't** — note it in the report and recommend `/wiki-ingest`.

## Step 5 — Update index.md (only if necessary)

Usually index.md doesn't change during sync. Only touch it if:
- A page's one-line summary is now misleading given the changes.
- A page was retitled.

## Step 6 — Append to log.md

```markdown
## [YYYY-MM-DD] sync | <N> pages updated
- Changed files: <short list or count>
- Pages updated: <list>
- Follow-ups: <any "recommended /wiki-ingest" or "none">
```

## Step 7 — Report briefly

One of:

- **Nothing changed**: `wiki-sync: nothing to do.` (one line, done)
- **Small update applied**: brief summary: `wiki-sync: updated <list of pages> based on changes to <files>. <one-line note of anything interesting>.`
- **Too big for sync**: as described in Step 3 — recommend `/wiki-ingest` or `/wiki-lint`, do nothing else.

Keep the report under ~5 lines whenever possible. This runs often; it should not be noisy.

## Guardrails

- **Never create new pages during sync** — that's ingest territory.
- **Never delete pages during sync.**
- **Never touch source code.**
- **Never run if the user is mid-conversation on something unrelated** — the rule should only fire sync after a task that plausibly changed code (see the workspace rule for trigger logic).
- If unsure whether a change is significant, err toward quiet — don't edit. Let `/wiki-lint` catch it later.
