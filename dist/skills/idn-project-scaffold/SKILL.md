---
name: idn-project-scaffold
description: The standard repository structure and the ten-document documentation set. Use when starting a new project, when a repo has no AGENTS.md or docs/ directory, when asked what documentation a project should have or where something belongs, when writing or updating architecture, domain, data-model, security, permissions, operations, known-issues, testing-strategy or api-design docs, or when recording an architectural decision as an ADR. Also use when deciding whether a document is needed at all. Do NOT use for writing the content of one specific document you already know the location of, and do NOT use to restructure an existing repo unasked.
---

# Project structure and documentation

> **House-specific.** This encodes one team's conventions. If you installed this repo without
> forking it, treat the structure as an example and the documentation set as a starting point.

`airules init` scaffolds all of this. Use this skill when you need to know what belongs where, or
to write a document from scratch.

## Repository structure

```
AGENTS.md                    entry point — what is true of THIS repo
CLAUDE.md                    two lines: a comment plus @AGENTS.md
.agent/                      agent-facing operational context
  context/tech-stack.md      runtimes, key dependencies, quirks
  rules/                     copies of the global stack rules, for sandboxed surfaces
  task_history.md            major architectural changes, newest first
docs/                        see the ten documents below
  decisions/                 numbered ADRs
  generated/                 CI output — NEVER hand-edit
src/
  frontend/                  presentation. No secrets, no database access.
  backend/                   the only tier that touches the database
    api/                     thin handlers: parse -> authorise -> service -> respond
    core/                    pure domain logic, no I/O
    services/                orchestration and external integrations
    middleware/              auth, validation, error handling
  database/                  migrations, models, schema, seeds
  shared/                    cross-tier contracts: types, DTOs, schemas
tests/
  unit/  integration/  mocks/
.docker/                     Dockerfiles and container assets
```

Adapt where a project genuinely differs — a single-purpose service does not need four `src/`
tiers. Say what you changed and why; do not silently invent a different layout.

## The ten documents

Each answers a distinct question and has a distinct reason to be touched. If one does not apply
to a project, say so in one line inside the file — **"Not applicable: this service has no auth
surface"** is a complete and correct document. An honest empty is better than filler.

| File | Answers | Update when |
| --- | --- | --- |
| `architecture.md` | What are the services and boundaries, and how does data flow? | a boundary changes |
| `decisions/NNN-*.md` | Why is it this way, and what was rejected? | any architectural choice |
| `domain.md` | What do our terms mean, and what are the business rules? | a concept or rule changes |
| `data-model.md` | What owns what, what is derived, what is the lifecycle? | ownership changes |
| `security.md` | Threat model, auth mechanism, data classification | rarely, by design |
| `permissions.md` | Who can do what, and why? | a role changes |
| `operations.md` | How do I run, deploy, back up, restore? | infra changes |
| `known-issues.md` | What will bite me? What debt did we accept? | on discovery |
| `testing-strategy.md` | This project's testing decisions | strategy changes |
| `api-design.md` | This project's API conventions | conventions change |

### Generated, never hand-written

- `docs/generated/api-reference.*` — from OpenAPI, decorators, or route definitions.
- `docs/generated/db-schema.*` — from the ORM schema and migrations.

Hand-maintaining either guarantees drift, and a stale schema document is worse than none: an
agent reads it and confidently writes wrong code. If these are not generated in CI yet, that is a
known issue to record, not a reason to write them by hand.

### Avoiding duplication

- `testing-strategy.md` and `api-design.md` hold **this project's** decisions only — what this
  repo does differently and why. General standards live in the global rules
  (`airules-tests.md`, `airules-backend-api.md`); point at them rather than restating them.
- The domain glossary lives in `docs/domain.md`, not in `.agent/`. One home per fact.
- `AGENTS.md` is short and imperative — what to do. `docs/` is explanatory — why it is like this.
  When the same fact appears in both, they drift and nobody can tell which is right.

## Writing an ADR

One file per decision, numbered sequentially, never edited after acceptance — supersede instead.

```markdown
# 007 — Use Prisma rather than Drizzle

**Status:** accepted (YYYY-MM-DD)

## Context
What forced a decision. Constraints that were real at the time.

## Decision
What we chose, stated plainly.

## Alternatives
What else was considered, and the specific reason each was rejected.

## Consequences
What this makes easy, what it makes hard, and what we accept as a cost.
```

The alternatives section is the part with lasting value. A decision without its rejected
alternatives reads later as arbitrary, and someone re-opens it.

To supersede: add a new ADR, and add one line to the old one — `Superseded by 012`. Do not
delete or rewrite the original.

## When a project has none of this

Run `airules init`. It is idempotent and never overwrites an existing file. Offer it — do not run
it unasked, and never in a repo belonging to someone else.
