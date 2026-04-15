---
title: Wiki Schema
updated: 2026-04-15
confidence: high
---

# Wiki Schema for This Repo

> This file is the repo-specific constitution for the wiki. Edit freely.
> The wiki-maintainer skill reads this file before any operation and respects its overrides.

## Scope

**In scope** (the wiki describes these):
- Source code under: `src/`, `lib/`, `app/`, top-level `*.ts`/`*.js`/`*.py`/`*.html` — adjust per repo
- Configuration: `package.json`, `*.toml`, `*.yaml`, migrations
- Architecture-shaping documents: README, existing architecture docs

**Out of scope** (ignore these):
- `node_modules/`, `dist/`, `build/`, `.next/`, `__pycache__/`
- `outputs/`, generated artifacts, logs, fixtures
- `.git/`, `.agents/`, `wiki/` itself
- Any `*.lock` file, large binary assets

## Directory layout

Default layout from the skill applies. Override here if needed:

```
wiki/
├── SCHEMA.md           (this file)
├── index.md
├── log.md
├── overview.md
├── architecture/
│   ├── decisions.md
│   └── data-model.md
├── modules/
│   └── <one page per major area>
└── glossary.md
```

## Page granularity

- **One module page per coherent area.** A "module" is whatever unit the codebase naturally divides into — routes, services, components, workers, whatever. Err on the side of fewer, fatter pages at small scale; split when a page exceeds ~200 lines.
- **One ADR per significant decision.** Significant = "someone would ask why we did it this way."
- **Glossary entry for any domain term** that isn't obvious to a developer new to the repo.

## Decay policy

- **Fast decay** (re-verify on any source change): `modules/*`, `architecture/data-model.md`, `overview.md`
- **Slow decay** (re-verify only on major restructure): `architecture/decisions.md`, `glossary.md`
- Lint flags `modules/*` pages as `low` confidence if 5+ commits have touched their `sources:` files since `source_commit`.

## Redundant legacy docs

If any of these exist at the repo root, lint should propose retiring them after their content is absorbed:
- `context_map.md`
- `project_status.md`
- `BUILD_PHASES.md`
- `ARCHITECTURE.md` (if superseded by `wiki/architecture/`)

**Never delete automatically.** Propose, let the human decide.

## Style preferences

- Use Mermaid for: request flows, data model relationships, state machines, module dependency graphs.
- Use markdown tables for: API endpoints, config options, model/tier comparisons.
- Cross-references: standard relative markdown links (e.g. `[see decisions](architecture/decisions.md)`). Do not use `[[wikilink]]` syntax — keeps pages portable across renderers.
- Dates: ISO 8601 (`2026-04-15`).
- Headings: sentence case (`## Data model`, not `## Data Model`).

## Question-asking policy

- On `/wiki-init`: ask once to confirm the scope before writing anything.
- On `/wiki-ingest` with no path: ask what to ingest.
- On `/wiki-sync`: do not ask; just run and report.
- On `/wiki-lint`: do not ask; produce the report.

## What this repo is about

This is a lightweight, single-page web application that serves as a demonstration for Google's Gemma 4 and Gemini models via direct REST API calls, along with recorded prompts and outputs from real-world tests.
