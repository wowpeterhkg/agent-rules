---
tier: critical
codex: digest
digest: |
  # Approved technology stack

  Use without discussion. Anything else is a proposal, not a step.

  - Frontend: React 19 + strict TypeScript, Vite or Next.js, Tailwind v4 new/v3 existing, TanStack
    Query, Zod, Vitest.
  - Backend: Go by default for application APIs, modules, auth, high concurrency, and pipelines.
    For intentional TypeScript backends use Fastify or Express. Use FastAPI + Pydantic v2 only for
    AI, ML, or Python-dependent work; never use Python for a general application backend.
  - Data: PostgreSQL is the source of truth; Prisma for TypeScript; ClickHouse via PeerDB CDC for
    analytics, never application writes; Redis for reconstructible cache and ephemeral state.
  - Infra: Docker multi-stage builds, Compose, nginx, Docker Hub.

  Record the backend choice and reason in `docs/decisions/`. Never mix backend frameworks in one
  service.

  **Off-list procedure.** For any unlisted framework, ORM, database, state manager, driver, code
  generator, or major library: name it, what it replaces, why approved choices do not fit, and its
  cost; then **STOP and wait for a yes**. Do not install first. Transitive dependencies are allowed.

  **Existing code is exempt.** Projects using another stack remain as they are. Never migrate a
  project to this stack on your own initiative — suggest it once and wait for explicit approval.
---

# Approved technology stack

Use these without discussion. Anything outside them is a proposal, not a step. Language-level
conventions live in the stack rules that load when you touch matching files; this rule is only
about *what is allowed*.

| Layer | Approved |
| --- | --- |
| Frontend | React 19, strict TypeScript, Vite or Next.js, Tailwind (v4 new / v3 existing), TanStack Query, Zod, Vitest |
| Backend — Go | Default for application APIs, modules, authentication, high-concurrency cores, and pipelines |
| Backend — TypeScript | Fastify or Express |
| Backend — Python / AI | FastAPI and Pydantic v2 only for AI, ML, or Python-dependent workflows |
| Data | PostgreSQL as source of truth; Prisma for TypeScript services; ClickHouse (+ PeerDB CDC) for analytics; Redis for cache |
| Infra | Docker multi-stage builds, Docker Compose, nginx, Docker Hub |

The frontend holds no secrets and never talks to a database. ClickHouse is never written by
application code and never read for transactional queries. Anything in Redis must be
reconstructible — it is not a source of truth.

## Choosing between approved backends

The set is broad on purpose, which makes the selection criteria the part that matters.

| Workload | Choose |
| --- | --- |
| Application APIs, modules, authentication, high concurrency, pipelines | Go |
| Intentionally TypeScript backend | Fastify or Express |
| AI, ML, model orchestration, or Python-dependent workflow | FastAPI |

State which you are using and why at project start, and record it in `docs/decisions/`. Never mix
two backend frameworks inside one service.

## Anything not listed

Adding a framework, ORM, database, state manager, database driver, code generator, or major library
that is not above is a decision, not a step:

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
