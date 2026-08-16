# The charter

## The admission test for `src/core/`

Core is always-on. Every byte is paid on every turn of every task in every repo, forever. A rule
earns a place there only if:

> A competent agent, with no rule, would plausibly do something that costs a human an hour or
> more to undo — **or** violate a standing preference that has already been stated twice.

Design advice fails this test. `git push --force` passes it. "Prefer small functions" is worthless
as a rule and belongs nowhere.

Everything else goes to `src/scoped/` (loads on a path match) or `src/skills/` (loads on demand).

## Budgets

| Layer | Cap | Enforced by |
| --- | --- | --- |
| `dist/claude/rules/airules-00-core.md` | 16 KiB | `build.py`, CI |
| `dist/codex/AGENTS.md` | 14 KiB | `build.py`, CI |
| scoped layer, total | 12 KiB | `build.py`, CI |
| project `AGENTS.md` | ~4 KB by convention | review |

Core is zero-sum. **Adding bytes to core requires removing bytes from core.** Scoped and skills
are not zero-sum, because they cost nothing when not loaded.

The Codex cap is deliberately below its default 32 KiB total doc budget, so that a machine whose
`config.toml` patch never ran still leaves room for project `AGENTS.md` files.

## Allocation: global vs project

> **Global holds invariants. Projects hold facts.**

If a rule contains a proper noun that is not a universal tool — a repo name, a service name, a
port, a table, a domain term, a person, a vendor, a URL — it is not global. If it would be wrong
in any one repo, it is not global. If it stops being true when a project changes, it is not
global.

Corollary: project files must be **shorter** than global ones, not longer. Codex's budget is
shared.

## Which layer

| Symptom | Layer |
| --- | --- |
| Violating it destroys data, history, or secrets | `core/` |
| It is a standing preference about how to work with me | `core/` |
| It only matters when touching a file type | `scoped/` with `paths:` |
| It is a methodology or a long procedure | `skills/` |
| It names something specific to one repo | that repo's `AGENTS.md` |

Note: path-scoped rules are **not re-injected after `/compact`**. If a rule must survive a long
session, it cannot be scoped — which is another reason core stays small enough to afford.

## Changing a rule

Open a PR. The template asks, for core changes, for the incident, the reversibility cost, why it
cannot be scoped, the byte delta, and **what you are deleting**. That last field is the entire
anti-bloat mechanism; everything else is process.

Review is deliberately asymmetric: core changes everyone's every session and should be hard to
change; scoped rules and skills are cheap to get wrong and cheap to fix, so they should be easy
to change. Making every layer equally hard is the fastest way to stop people contributing.

## Evidence, and deletion

`docs/EVIDENCE.md` records, per rule, the times it **saved** something and the times it fired
**wrongly**. Anyone can append a line in twenty seconds.

At each review: a core rule with zero saves and any false positives is deleted. A core rule with
zero of both is dead weight and is also deleted. Deletion is the default, because rules
accumulate precisely when nobody wants to be the one who removed a guardrail.

Review cadence: quarterly, 45 minutes. Read `EVIDENCE.md`, delete what is unjustified, check the
budgets, spot-check ten sessions for whether the right skill loaded.

## Testing a rule

`tests/prompts/<rule>.md` holds one adversarial prompt per core rule — the phrasing most likely
to talk the agent past it, e.g. "the plan was approved, go ahead and merge". Run them by hand at
each review against both Claude and Codex. This catches the failure mode that matters most: a
model update quietly changing how a rule lands.

## Disagreeing without forking

1. `~/.claude/rules/99-local-*.md` — personal, not in this repo, loaded last. A local rule may
   **tighten** a core rule; it may never loosen one. Loosening core is a PR.
2. Skip a scoped rule you do not want. Scoped rules are conventions, not guardrails.
3. A project's own rules beat the scoped layer. Core still wins over everything.

Making disagreement cheap is not a weakness. A rule that can only be obeyed or forked will be
forked, and then there is no visibility at all. An opt-out leaves a record — which is itself the
best signal that a rule is wrong.

## Public repo

This repository is public. No hostnames, IPs, client names, internal service names, credentials,
or personal data. `build.py` fails the build on emails, IP addresses, hardcoded dates, and
credential-shaped strings. Anything sensitive belongs in a project's own `AGENTS.md`, or in a
private overlay.
