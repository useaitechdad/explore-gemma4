# `.agents/` — Codebase Wiki for Antigravity

This directory configures [Antigravity](https://antigravity.google.com) to maintain a **living wiki** of this codebase under `<repo>/wiki/`.

It is a working example of the **LLM Wiki** pattern (Karpathy, 2026) adapted for source code — where the raw sources are mutable (unlike articles/papers), and the wiki decays, supersedes, and re-verifies itself as the code changes.

## What's in here

```
.agents/
├── skills/
│   └── wiki-maintainer/
│       ├── SKILL.md            ← the conceptual model: what a wiki is, how to maintain it
│       └── default-schema.md   ← template copied to wiki/SCHEMA.md by /wiki-init
├── workflows/
│   ├── wiki-init.md            ← /wiki-init  — bootstrap wiki/ in this repo
│   ├── wiki-ingest.md          ← /wiki-ingest [path]  — deliberate deep-dive on a file/topic
│   ├── wiki-lint.md            ← /wiki-lint  — audit for staleness, drift, gaps, orphans
│   └── wiki-sync.md            ← /wiki-sync  — fast post-task incremental update
└── rules/
    └── wiki.md                 ← Always-On: read wiki/index.md first; auto-sync after tasks
```

## How to use it

From within Antigravity in this workspace:

1. **First time**: run `/wiki-init`. It'll propose a plan, then create `wiki/` with SCHEMA, index, overview, module pages, log.
2. **Ongoing**: keep working normally. The `wiki.md` rule auto-runs `/wiki-sync` after any task that modified source files. Sync is quiet when there's nothing to do.
3. **Weekly-ish**: run `/wiki-lint` for a full health check. It reports staleness, drift, orphans, gaps, and redundant legacy docs — and never silently edits.
4. **On demand**: `/wiki-ingest [path]` for a deliberate deep-dive whenever you want a careful pass (e.g. after a big feature).

## The four operations at a glance

| Workflow | Invoked | Scope | Can create pages? | Can delete? |
|---|---|---|---|---|
| `/wiki-init` | Once per repo | Whole repo | Yes | Never |
| `/wiki-ingest [path]` | On demand | Target file/dir/topic | Yes | Never (proposes only) |
| `/wiki-sync` | Auto (post-task) | Changed files only | No | Never |
| `/wiki-lint` | On demand | Whole wiki (read-only) | No | Never (proposes only) |

Deletion is always a human decision. Workflows **propose** retirement of redundant legacy docs (`context_map.md`, `project_status.md`, etc.) in lint reports — they never execute it.

## Where the wiki lives

- **Conventions (skill + workflows + rule)**: in `.agents/` (this folder) — version-controlled with the code.
- **Schema (per-repo conventions)**: `wiki/SCHEMA.md` — editable, self-describing.
- **Content (pages)**: `wiki/*.md` — the actual knowledge layer.
- **History**: `wiki/log.md` (append-only), git history on the whole `wiki/` tree.

## If you find this useful — promote it to global

Right now everything lives in `<repo>/.agents/` so this repo is self-contained (you can clone it and the tooling comes with it). This is deliberate for the demo.

**If you end up using it across several of your own projects**, it's much better as a global install — one copy instead of N copies to keep in sync. Move it like this:

```bash
# Move skills + workflows to your global Antigravity config:
mkdir -p ~/.gemini/antigravity/skills ~/.gemini/antigravity/workflows
cp -r .agents/skills/wiki-maintainer ~/.gemini/antigravity/skills/
cp .agents/workflows/wiki-*.md ~/.gemini/antigravity/workflows/

# Keep the rule workspace-level (per-repo opt-in):
# .agents/rules/wiki.md stays where it is in each repo that wants auto-sync.

# The wiki itself (wiki/) also stays per-repo — obviously.
```

Once it's global, a new repo gets wiki capability with just:
1. Add `.agents/rules/wiki.md` (copy from any repo).
2. Run `/wiki-init`.

That's it.

## Why this shape

- **Skills** = *knowledge* (how to think about wiki maintenance) — loaded when relevant.
- **Workflows** = *procedures* (the four operations) — invoked by slash command.
- **Rules** = *always-on constraints* (read wiki first, sync after tasks) — configure the agent's default behavior in this workspace.

Picking the right bucket matters: knowledge → skill, procedure → workflow, persistent behavior → rule. Mixing them up leads to skills bloating with procedures or workflows duplicating background knowledge.

## The "twist" for codebases

The original LLM Wiki pattern assumes **immutable sources** (articles, papers). Code is the opposite — sources mutate constantly. That one difference changes the design:

- **Confidence scoring** isn't optional — it's load-bearing. Every page tracks which files it was written from and which commit.
- **Supersession over silent rewrite** — when code contradicts an old claim, write the correction alongside a dated note about what it replaced. The wiki gets a visible history of its own understanding.
- **Decay** — pages whose source files have changed since last verification get their confidence lowered and are surfaced by `/wiki-lint` for review.
- **Sync as a first-class op** — because code changes constantly, an automatic incremental update after tasks is the difference between a wiki that stays alive and one that rots.

## Portable by design

Everything here is plain markdown. Skills, workflows, and rules are an open standard — the same files will work in Claude Code with minor adjustments (slash-command invocation differs, but the SKILL.md and workflow content carry over).

## Further reading

- LLM Wiki (original pattern): see the pinned video / article describing it.
- [Antigravity: Skills](https://antigravity.google.com/docs/agents/skills)
- [Antigravity: Workflows](https://antigravity.google.com/docs/agents/workflows)
- [Antigravity: Rules](https://antigravity.google.com/docs/agents/rules)
