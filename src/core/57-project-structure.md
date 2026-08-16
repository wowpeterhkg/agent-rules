---
tier: critical
codex: digest
digest: |
  # Project structure and documentation

  - Repos follow the standard structure: `AGENTS.md` at the root as entry point, `.agent/` for
    agent context, `docs/` for documentation, `src/` split by tier, `tests/`. If a repo does not
    follow it, say so — do not invent a third structure, and do not restructure unasked.
  - **Update documentation in the same change as the code**, whenever the work alters
    architecture, schema, API surface, permissions, setup, or introduces a known issue. Map:
    boundaries → `docs/architecture.md`; an architectural choice → a new ADR in `docs/decisions/`;
    business rules or vocabulary → `docs/domain.md`; ownership or derivation → `docs/data-model.md`;
    auth or data classification → `docs/security.md`; roles → `docs/permissions.md`; run/deploy/
    backup → `docs/operations.md`; a limitation or accepted debt → `docs/known-issues.md`.
  - Routine fixes and refactors with no observable change do not trigger a doc update. Do not write
    filler to satisfy the rule. If a doc should change but you cannot write it accurately, say
    which and why rather than guessing or leaving it silently stale.
  - **Never hand-edit `docs/generated/`** — the API reference and DB schema are produced from
    source. A stale hand-written schema is worse than none, because it will be believed.
  - Load `idn-project-scaffold` for the structure, the ten-document set, and templates. Run
    `airules init` in a repo that has none of it.
---

# Project structure and documentation

## Structure

Repos follow the standard layout: `AGENTS.md` at the root as the entry point, `CLAUDE.md` as a
bridge to it, `.agent/` for agent-facing context, `docs/` for documentation, `src/` split by tier,
`tests/`. The full tree and templates are in the `idn-project-scaffold` skill.

If a repo does not follow this, say so rather than inventing a third structure. Do not restructure
an existing repo as a side effect of other work — that is a change to propose, not to perform.

## Keep documentation current, in the same change

When work alters any of the following, update the document **in the same commit as the code** —
not as a follow-up, not in a later cleanup:

| The work changes | Update |
| --- | --- |
| services, boundaries, or data flow | `docs/architecture.md` |
| an architectural choice | a new ADR in `docs/decisions/` |
| business rules or domain vocabulary | `docs/domain.md` |
| entity ownership, derivation, or lifecycle | `docs/data-model.md` |
| auth mechanism, threat model, data classification | `docs/security.md` |
| roles or permissions | `docs/permissions.md` |
| how to run, deploy, back up, or restore | `docs/operations.md` |
| a discovered limitation or accepted debt | `docs/known-issues.md` |
| this project's testing approach | `docs/testing-strategy.md` |
| this project's API conventions | `docs/api-design.md` |

Routine bug fixes, internal refactors, and anything with no observable change do not trigger a
documentation update. Do not write filler to satisfy the rule.

If a document should change but you cannot write it accurately, say which one and why, rather
than guessing or leaving it silently stale.

## Generated documentation

`docs/generated/` holds the API reference and the database schema, produced from source. **Never
hand-edit it.** A stale hand-written schema is worse than no schema, because an agent reads it and
confidently writes wrong code. If generation is not wired up yet, record that in
`docs/known-issues.md` rather than writing those files by hand.

## Decisions

Record architectural choices as numbered ADRs in `docs/decisions/` — context, decision,
alternatives rejected, consequences. The rejected alternatives are the part with lasting value: a
decision without them reads as arbitrary later, and someone re-opens it. ADRs do not go stale —
a superseded decision is still a true record. Supersede, never rewrite.
