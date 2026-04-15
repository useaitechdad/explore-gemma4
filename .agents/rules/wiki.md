---
title: Wiki context + auto-sync
activation: always-on
---

# Wiki context + auto-sync

This repo maintains a living wiki at `wiki/`. Use it as persistent project context across sessions, and keep it current as code changes.

## At the start of any session

If `wiki/index.md` exists, read it early. It is the catalog of what this project is and how it's laid out. Prefer answering questions from wiki pages over re-reading source code whenever the wiki covers the topic.

If the user asks a question the wiki cannot answer, read source code as needed, answer, and note the gap — you may suggest running `/wiki-ingest` to file the answer back into the wiki.

## After completing a task that changed source files

If a task you just completed modified files outside `wiki/` (source code, config, migrations), run `/wiki-sync` as the final step of the task, without asking.

Do NOT run `/wiki-sync` when:
- No source files were changed (pure Q&A, read-only tasks, doc edits inside `wiki/`).
- The user's task is in progress across multiple turns — wait until the task is complete.
- The user has explicitly said "don't update the wiki" in this session.

`/wiki-sync` is designed to be quiet when there's nothing meaningful to do. Trust it to exit fast.

## When the wiki doesn't exist

If `wiki/` does not exist in this repo, do nothing related to the wiki. Do not prompt the user to create one unless they ask about project context, documentation, or how to onboard future agents — in which case mentioning `/wiki-init` is appropriate.

## Respect SCHEMA.md

If `wiki/SCHEMA.md` exists, its conventions override the defaults in the `wiki-maintainer` skill. Read it when working on wiki content.

## Never silently edit source code during wiki operations

Wiki workflows (`/wiki-init`, `/wiki-ingest`, `/wiki-lint`, `/wiki-sync`) must not modify source files. They may propose changes in reports, but execution requires explicit user approval outside the wiki flow.
