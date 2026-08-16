---
tier: critical
codex: digest
digest: |
  # Approved technology stack

  Use without discussion. Anything else is a proposal, not a step.

  - Frontend: React 19 + Vite + TypeScript strict, Tailwind (v4 new / v3 existing), TanStack Query,
    zod at boundaries, Vitest.
  - Backend TS: NestJS for services with modules and an auth surface; Express or Fastify only for a
    service one endpoint deep.
  - Backend Python/AI: FastAPI + Pydantic v2.  Backend Go: high-concurrency cores and pipelines.
  - Data: PostgreSQL + Prisma as source of truth. ClickHouse for analytics fed by PeerDB CDC, never
    written by app code. Redis for cache and ephemeral state only.
  - Infra: Docker multi-stage, Compose, nginx, Docker Hub.

  Choosing a backend: NestJS when there are real modules and auth; FastAPI when the work is Python
  or ML; Go when concurrency is the constraint; Express/Fastify only when one endpoint deep. State
  which and why at project start, and record it in `docs/decisions/`. Never mix two backend
  frameworks in one service.

  **Off-list procedure.** For any framework, ORM, database, state manager, or major library not
  listed: name it, say what it replaces and why the approved option does not fit, give the cost,
  then **STOP and wait for a yes**. Do not install first and ask after. A transitive dependency of
  an approved tool is fine; a new top-level choice is not.

  **Existing code is exempt.** Projects on something else stay as they are. Never migrate a project
  to this stack on your own initiative — say it once as a suggestion and leave it.
---

# Approved technology stack

Use these without discussion. Anything outside them is a proposal, not a step. Language-level
conventions live in the stack rules that load when you touch matching files; this rule is only
about *what is allowed*.

| Layer | Approved |
| --- | --- |
| Frontend | React 19, Vite, TypeScript strict, Tailwind (v4 new / v3 existing), TanStack Query, zod, Vitest |
| Backend — TypeScript | NestJS; Express or Fastify only for a single-purpose service |
| Backend — Python / AI | FastAPI, Pydantic v2 |
| Backend — Go | high-concurrency cores, streaming pipelines |
| Data | PostgreSQL + Prisma; ClickHouse (+ PeerDB CDC) for analytics; Redis for cache |
| Infra | Docker multi-stage, Compose, nginx, Docker Hub |

The frontend holds no secrets and never talks to a database. ClickHouse is never written by
application code and never read for transactional queries. Anything in Redis must be
reconstructible — it is not a source of truth.

## Choosing between approved backends

The set is broad on purpose, which makes the selection criteria the part that matters.

| Workload | Choose |
| --- | --- |
| Modules, auth surface, several bounded areas | NestJS |
| Python, ML, model orchestration, Pydantic-heavy | FastAPI |
| High concurrency, streaming, throughput-bound | Go |
| One endpoint deep, no auth surface | Express or Fastify |

State which you are using and why at project start, and record it in `docs/decisions/`. Never mix
two backend frameworks inside one service.

## Anything not listed

Adding a framework, ORM, database, state manager, or major library that is not above is a
decision, not a step:

1. Name it.
2. Say what it replaces, and why the approved option does not fit.
3. Give the cost — operational surface, what it locks in.
4. **STOP and wait for a yes.** Do not install it first.

This extends the dependency rule in `20`. A transitive dependency of an approved tool is fine; a
new top-level choice is not.

## Existing code is exempt

Projects already built on something else stay as they are. Never migrate a project to this stack
on your own initiative, and never fold a migration into unrelated work. Say it once as a
suggestion and leave it.
