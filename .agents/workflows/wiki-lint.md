---
title: Wiki Lint
description: Health check the wiki. Scan for staleness, drift, orphans, gaps, contradictions, and redundant legacy docs. Produces a report — does not silently edit.
---

# /wiki-lint

Audit the wiki for health. Produce a report of issues found. Do NOT fix anything automatically — let the human review and decide.

**Requires**: the `wiki-maintainer` skill. Respect `wiki/SCHEMA.md` (especially the decay policy).

## Step 1 — Preconditions

- If `wiki/` does not exist, tell the user to run `/wiki-init` first. Stop.
- If the repo is a git repo, prefer `git log` / `git diff` over filesystem mtimes for accuracy.

## Step 2 — Gather the facts

Build a mental picture:

1. List every page under `wiki/`. For each, read its frontmatter (`updated`, `sources`, `source_commit`, `confidence`).
2. Check `wiki/SCHEMA.md` for decay policy and legacy docs list.
3. Identify the current set of source files in scope (per SCHEMA.md's in-scope rules).
4. If git is available: for each page, compute how many commits have touched its `sources:` files since its `source_commit`.
5. Read `wiki/index.md` and build a list of pages referenced vs pages that exist.
6. Check for root-level legacy docs (`context_map.md`, `project_status.md`, `BUILD_PHASES.md`, any listed in SCHEMA.md).

## Step 3 — Run the seven checks

### Check 1: Staleness
A page is **stale** if any of these is true (thresholds follow the skill's confidence model; SCHEMA.md may override):
- `updated` date is more than 30 days old AND its `sources:` files have been modified since, OR
- 5+ commits have touched its `sources:` files since `source_commit` (same threshold that pushes confidence to `low`), OR
- Its `confidence` is already `low`.

### Check 2: Drift
A page **drifts** if its content makes specific claims that contradict the current code. Look for:
- Numbered lists that name fields, endpoints, or config keys — do they still exist?
- Phase/status tables — do they still match reality?
- "X uses Y" claims — still true?

Do a **targeted** drift check: don't re-read every source file. Spot-check pages with low confidence or recent source changes.

### Check 3: Orphans
A page is **orphaned** if no other wiki page or `index.md` links to it. Ignore `log.md`, `index.md`, and `SCHEMA.md` themselves.

### Check 4: Gaps
A **gap** is code that exists but no wiki page covers. Look for:
- Top-level source directories with no corresponding module page.
- Recently added files (git log, last 14 days) not mentioned anywhere in the wiki.
- Exported public APIs (functions, classes, endpoints) not referenced in any page.

### Check 5: Contradictions
Two or more pages that disagree with each other. Common: `overview.md` vs a `modules/*.md` having different descriptions of the same thing; architecture page vs actual data model page.

### Check 6: Redundant legacy docs
Root-level legacy docs (per SCHEMA.md's list) whose content is now fully absorbed into the wiki. For each, check:
- Is every significant claim in the legacy doc present in the wiki?
- If yes → **propose retirement**.
- If no → flag what's missing so an ingest can absorb it.

### Check 7: Frontmatter hygiene
- Missing required frontmatter fields.
- `updated` date format wrong.
- `sources:` pointing to files that no longer exist.

## Step 4 — Produce the report

Output a structured markdown report. Keep it scannable.

```markdown
# Wiki Lint Report — YYYY-MM-DD

## Summary
<N> issues found across <M> pages.
- Stale: <n>    Drift: <n>    Orphans: <n>    Gaps: <n>    Contradictions: <n>    Legacy redundant: <n>    Frontmatter: <n>

## Stale pages
- `modules/routes.md` — last updated 2026-03-02, 12 commits to src/routes/ since. Confidence was `high`, downgrade to `low`.
- ...

## Drift
- `architecture/decisions.md` ADR-003 claims SHA-1 hashing; code now uses SHA-256 (src/utils/id.ts:42). Needs supersession.
- ...

## Orphans
- `architecture/data-model.md` — no inbound links. Either add to index.md or consider merging into overview.md.
- ...

## Gaps
- src/services/rate_limiter.ts — no wiki page mentions this file. Added 2026-04-10.
- Public endpoint POST /v1/admin/reset — not documented in modules/routes.md.
- ...

## Contradictions
- overview.md says "3 route groups"; modules/routes.md lists 5. Reconcile.
- ...

## Redundant legacy docs (proposed retirement)
- `context_map.md` — content absorbed into overview.md + modules/. **Propose**: move to `.archive/` or delete after one more review.
- `BUILD_PHASES.md` — Phase tracking no longer reflects reality. **Propose**: retire; project-status belongs in a separate tracker.
- **Do not delete without user approval.**

## Frontmatter hygiene
- `glossary.md` — missing `updated` field.
- ...

## Suggested follow-ups
1. Run `/wiki-ingest src/services/rate_limiter.ts` to close the biggest gap.
2. Reconcile the overview vs modules/routes contradiction.
3. Decide on legacy doc retirement.
```

## Step 5 — Append to log.md

```markdown
## [YYYY-MM-DD] lint | <N> issues across <M> pages
- Stale: <n>, Drift: <n>, Orphans: <n>, Gaps: <n>, Contradictions: <n>, Legacy: <n>, Frontmatter: <n>
- Report: see chat (or wiki/lint-reports/YYYY-MM-DD.md if the user asked to save it)
```

## Step 6 — Offer next steps

End the report with a short prompt:

> "Want me to fix a specific issue? Say e.g. 'fix the gap on rate_limiter' or 'update the stale routes page'. Or 'fix all of category X' for bulk. I won't touch anything until you say so."

## Guardrails

- **Never modify the wiki during lint.** Read-only pass.
- **Never delete or move legacy docs.** Propose only.
- If the lint finds zero issues, say so plainly — don't pad the report.
- If the wiki is clearly broken (missing index, missing SCHEMA.md), flag that first and recommend `/wiki-init` or a targeted repair instead of running a full lint.
