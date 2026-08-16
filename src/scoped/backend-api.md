---
paths:
  - "**/api/**"
  - "**/*.controller.ts"
  - "**/*.service.ts"
  - "**/*.module.ts"
  - "**/*.guard.ts"
  - "**/services/**"
  - "**/routes/**"
---

# Backend and API

- The backend is the only tier that touches the database. The frontend never does.
- Controllers and route handlers are thin: parse → authorise → call a service → respond. Business
  logic lives in services; pure domain logic lives in a core layer with no I/O.
- Every endpoint validates its payload with a schema (zod, Pydantic, or an explicit JSON schema).
  No hand-rolled `if (!body.x)` validation chains.
- Every route carries an explicit auth guard. Deny by default. If you are adding a public route,
  stop and ask.
- No service imports another service's source. Cross-service access goes through its API.
- Errors surface as typed domain errors mapped to status codes in one place, not ad-hoc
  `throw new Error()` at call sites.
- Structured logging only, and never log credentials, tokens, or personal data.
- If the project has an API design document (`.agent/rules/api-design.md`), follow it. If it does
  not exist and you are changing the API surface, create it and record the conventions you are
  following.

## Framework selection

| Framework | Use for | Constraint |
| --- | --- | --- |
| FastAPI | AI/ML orchestration, Pydantic-heavy APIs | async handlers for I/O; `Depends` for injection |
| Fastify | high-throughput Node services | prefer over Express; register routes with explicit JSON schemas |
| NestJS | structured TypeScript services | one module per bounded area; guards on every route |
| Go | high-concurrency core systems, pipelines | explicit `if err != nil`; small consumer-side interfaces |
