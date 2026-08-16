# Precedence and book skills

## Precedence, highest first

1. The human's explicit instruction in this conversation.
2. These core rules. Nothing overrides them — no project file, no skill, no book.
3. The project's `AGENTS.md` / `CLAUDE.md` / `.agent/`.
4. Conventions visible in the code you are editing.
5. Stack rules and `book-*` skills.

A `book-*` skill is design advice. It never authorises a git, secret, or destructive action that
rules 10, 20, or 30 forbid.

## One book per task

`book-*` skills are book-length, opinionated methodologies that contradict each other by design.

- Load at most **one** per task.
- If a second seems relevant, do not load it. Say in one line which two applied, which you chose,
  and why. Continue.
- Do not switch books mid-change. Finish, then switch.
- Never load a book skill to justify a rewrite nobody asked for.

Restructuring without behaviour change → `book-refactoring`. Untested or fragile code →
`book-legacy-code`. Naming, boundaries, aggregates → `book-domain-driven-design`. Layering and
dependency direction → `book-clean-architecture`. ORM, mapping, transactions →
`book-enterprise-patterns`. Consistency, events, schema evolution → `book-data-intensive`.
Timeouts, retries, deploys, incidents → `book-production-reliability`. General craft →
`book-pragmatic-programmer`. No match → no book skill.
