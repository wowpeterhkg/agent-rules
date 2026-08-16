---
name: book-domain-driven-design
description: Use when business software has enough domain complexity, language ambiguity, strategic differentiation, or integration risk that modeling changes implementation decisions, but the project still needs the smallest effective DDD practice rather than ceremony. Do NOT use for unrelated work, and never load a second book-* skill in the same task.
---

# Domain-driven design

> Distilled from *Domain-Driven Design Distilled by Vaughn Vernon*. MIT-licensed ruleset vendored from
> ciembor/agent-rules-books.

## Conflicts

Mutually exclusive with other `book-*` skills — one per task (core rule 60).

- **`book-clean-architecture`** — DDD decides what the boundary is; Clean Architecture decides which way the arrow points across it.
- **`book-data-intensive`** — Once state crosses a service or durability boundary, that skill wins.

## Primary bias to correct

Use DDD selectively, but seriously. Start from business capability, subdomain importance, bounded context, and local language before tactical patterns, frameworks, persistence, APIs, or class shapes.

## Decision rules

- Before designing code, identify the business capability, classify the subdomain as Core, Supporting, or Generic, define the Bounded Context, use its Ubiquitous Language, and choose only tactical patterns that earn their cost.
- Put the most modeling effort into the Core Domain. Keep Supporting and Generic Subdomains simpler unless their own complexity proves otherwise.
- Do not apply full tactical DDD to simple CRUD, generic subsystems, or mainly technical problems; strengthen the model only when invariants, lifecycle, language complexity, or integration risk justify it.
- Give every meaningful model one explicit Bounded Context. The context owns its language, rules, semantics, code structure, tests, and integration contracts.
- Treat the same word in different contexts as potentially different concepts. Translate at context boundaries instead of sharing domain classes or leaking foreign language into the local model.
- Choose context relationships deliberately: Partnership, Shared Kernel, Customer/Supplier, Conformist, Anticorruption Layer, Open Host Service, Published Language, Separate Ways, or Big Ball of Mud containment all imply different ownership and translation duties.
- Select integration style from business coupling and failure semantics: RPC requires acceptable request/response coupling; REST resources must not expose Aggregate internals; messaging must tolerate lag, duplicates, and ordering limits.
- Keep integration contracts separate from internal models and test translations wherever meanings cross a boundary.
- Use local domain terms in code, tests, Commands, Domain Events, APIs, and conversations. One concept gets one term, one term does not carry multiple meanings inside a context, and code is renamed when understanding improves.
- Use Entities when identity and lifecycle matter; make identity explicit and protect meaningful state transitions rather than exposing unrestricted setters.
- Use immutable, self-validating Value Objects when primitives hide domain meaning.
- Use Aggregates only as invariant and transactional consistency boundaries. Keep them small, modify through the root, reference other Aggregates by identity, avoid large object graphs, and usually change one Aggregate per transaction.
- Use Domain Events for meaningful past-tense business facts that clarify collaboration or integration; do not publish noisy field-change events.
- Application Services coordinate use cases by loading Aggregates, invoking domain behavior, saving results, and triggering integration work. They must not become the real domain model.
- Keep frameworks, persistence mechanics, transport formats, REST representations, and infrastructure types out of the domain model. Translate external data at the boundary and persist Aggregates without letting storage define the model.
- Prefer code that teaches the model: make domain assumptions explicit in names, tests, and events; expose richer concepts instead of hiding meaning behind flags, status codes, booleans, enums, helpers, or utilities.
- Use Event Storming, scenarios, acceptance tests, modeling spikes, and domain-expert walkthroughs when workflow, terminology, policies, or acceptance criteria are unclear. Timebox modeling and track modeling debt instead of drifting into detached analysis.
- Estimate and plan DDD work from modeling uncertainty, integration risk, implementation cost, team skill, and access to domain experts, not only from feature count.

## Trigger rules

- When language is fuzzy, generic, overloaded, or imported from another context, pause coding and sharpen the local Ubiquitous Language.
- When the core concern drifts, terms stop matching code, or supporting complexity hides the core, reassess subdomains, boundaries, and modeling investment.
- When one model spreads across billing, identity, catalog, fulfillment, support, permissions, or other separate concerns, split or translate instead of reusing shared domain classes.
- When an upstream model, schema, UI, framework, API payload, transport object, or database shape starts defining the domain model, restore boundary translation.
- When using Shared Kernel, require small stable overlap, joint ownership, and tests; without governance, choose another relationship.
- When calling something an Anticorruption Layer, verify that real translation exists.
- When a request wants to load and mutate a large graph or several Aggregate roots, revisit the invariant boundary and ask whether eventual consistency is acceptable.
- When controllers, helpers, services, or transport-shaped application services contain business decisions, move behavior into the domain model or name the missing concept.
- When a Domain Event is command-like, vague, trivial, or emitted for every field change, redesign it as a specific business fact or remove it.
- When a concept is represented as a primitive, flag, status code, enum, or boolean but carries domain rules, promote it to a richer concept or Value Object.
- When delivery pressure tempts the team to skip design, use a short modeling spike, scenario, or acceptance test and record known modeling debt.

## Final checklist

- Correct subdomain and Core Domain investment?
- Explicit Bounded Context and relationship to neighboring contexts?
- Ubiquitous Language visible in code, tests, Commands, Events, APIs, and conversations?
- Translation tested where external or foreign meanings cross boundaries?
- Tactical patterns used only where they clarify meaning or protect invariants?
- Aggregates small, root-protected, identity-referenced, and not graph-shaped?
- Application Services coordinating rather than owning business logic?
- Infrastructure, persistence, REST, and transport details kept out of the domain model?
- Modeling discoveries, acceptance tests, expert input, and modeling debt captured before shipping?

## House overrides

These outrank anything above and are not from the book.

- Core rules 00-60 always win. This skill never authorises a merge, a force-push, a destructive
  command, or a "tests pass" claim you did not run.
- Never refactor or restructure code the user did not ask you to touch. If it is needed to make
  the requested change safely, say so and get a yes first.
- Test policy — when to write tests and how — belongs to the `tdd` skill, not to this one.
- Load at most one `book-*` skill per task. If a second seems relevant, name both, choose, say why
  in one line, and continue.

If you notice you have already applied guidance from another `book-*` skill in this session, say
so, name which one governs the file you are in, and stop applying the other.


## Deeper reference

- `strategic.md` — open for one entry; do not read whole.
- `tactical.md` — open for one entry; do not read whole.
