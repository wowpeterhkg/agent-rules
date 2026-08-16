---
tier: standard
codex: digest
digest: |
  # Design defaults

  Advisory, not guardrails: rules 00-40 always win, and the human's instruction wins over these.
  Read the named skill before applying any of this at depth.

  - **Dependencies point inward.** Domain and use-case code must not import frameworks, ORMs, HTTP
    types, or vendor SDKs. Inner layers declare the interfaces they need; outer layers implement
    them; wiring happens at the composition root. → `book-clean-architecture`
  - **Do not pass framework objects across a boundary.** No request objects, ORM rows, or vendor
    payloads into or out of core logic — translate at the edge. → `book-clean-architecture`
  - **One owner per responsibility**: transport, workflow, domain logic, persistence, transactions.
    Controllers and repositories hold no business decisions. Match the pattern to the force — a
    transaction script for a simple flow, a domain model when invariants and lifecycle are real.
    → `book-enterprise-patterns`
  - **Write for local reasoning.** One level of abstraction per function; separate commands from
    queries; no boolean flag parameters; precise names, one term per concept; comments carry
    rationale, not narration. → `book-code-construction`
  - **State the data contract before changing data.** Source of truth, whether stale reads are
    allowed, when a write is durable and visible. Anything retried must be idempotent. Caches,
    read models, and search indexes are derived data and need a rebuild path. Schemas and events
    are contracts evolving across old readers and in-flight messages. → `book-data-intensive`
---

# Design defaults

These are defaults, not guardrails. Rules 00-40 always win, and an explicit instruction from the
human wins over anything here. Each entry names the skill to load when you need the full
reasoning — but load at most one per task, per rule 60.

## Dependency direction — `book-clean-architecture`

- Source dependencies point inward, toward policy. Domain and use-case code must not import
  frameworks, databases, HTTP handlers, queues, UI types, or vendor SDKs.
- Inner layers own the interfaces they need; outer layers implement them. Concrete wiring belongs
  in a composition root, not inside a use case.
- Pass plain request and response models across boundaries. Never pass a web request, an ORM row,
  or a framework response object into or out of core logic.
- Keep adapters humble: controllers, presenters, and gateways translate formats and call use
  cases. They do not make business decisions.
- Organize by feature or capability before technical buckets. A `common/` or `utils/` folder that
  becomes an escape hatch is an architecture problem, not a naming one.
- When a deadline forces a compromise, keep it at the outermost layer, say so, and leave a path
  back.

## Responsibility layering — `book-enterprise-patterns`

- Presentation, application workflow, domain logic, data access, and transaction management are
  distinct responsibilities. They may not collapse into one class.
- Match the pattern to the pressure: a transaction script for a short independent flow; a domain
  model once invariants, identity, and lifecycle are real. Escalate when duplication grows — do
  not start with ceremony.
- Repositories speak domain terms and hide SQL and mapping. DTOs are transport shapes, not domain
  objects.
- Transaction boundaries live in the service or workflow layer, are explicit, and stay short.
  Remote calls belong outside them.
- Do not distribute by default. If you must, design the remote contract separately from the local
  objects and budget latency, versioning, and partial failure.

## Readability — `book-code-construction`

- Write for local reasoning: a reader should follow the path without reconstructing hidden state.
- One level of abstraction per function. Separate setup, validation, computation, and side
  effects rather than interleaving them.
- Separate commands from queries. A function that answers should not also mutate.
- No boolean flag parameters that switch behaviour — model the concept instead.
- Precise names, one term per concept. If a comment exists to explain control flow, fix the code
  first; comments are for rationale, constraints, and contracts.
- Keep the happy path readable; make errors, invalid states, and cleanup explicit.

Note: prefer clear, cohesive units over arbitrarily small ones. A function split until it fits a
line count, at the cost of a reader following six hops, is worse than the function you started
with.

## Data semantics — `book-data-intensive`

- Before changing how data is stored or moved, state: the source of truth, whether stale reads
  are acceptable, and when a write counts as durable versus merely accepted.
- Treat crashes, timeouts, duplicates, and unknown downstream outcomes as normal inputs. Anything
  that can be retried must be idempotent — by a deduplication key or a naturally idempotent
  transition.
- Caches, search indexes, read models, and denormalized copies are **derived data**. Each needs a
  propagation path, observable lag, and a way to rebuild.
- Preserve only the ordering the business actually needs, and scope it — per key, per partition,
  per entity history.
- Schemas, events, and APIs are contracts that evolve across old readers, old writers, and
  in-flight messages. Additive changes first.
- Align service boundaries with data ownership. Do not split one tightly consistent concept
  across services, and keep cross-service joins off hot paths.
