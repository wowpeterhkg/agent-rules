# Contributing

## Before you open a PR

1. Read [docs/RULES.md](docs/RULES.md) — especially the admission test for `src/core/`. Core is
   always-on and zero-sum; adding bytes there means removing bytes.
2. Edit `src/`, never `dist/`. Run `python3 build.py` and commit the regenerated `dist/` too. CI
   fails if `dist/` is stale.
3. Never edit `vendor/` — it is vendored verbatim from upstream and verified by sha256.

## Local checks

```bash
python3 build.py
```

```bash
python3 build.py --verify-vendor
```

```bash
shellcheck -s sh bin/airules lib/common.sh scripts/sync-vendor.sh
```

Test an install without touching your real config:

```bash
HOME=$(mktemp -d) ./bin/airules install --repo "$PWD" --no-schedule --yes
```

## What gets accepted

**Likely yes:** a guardrail against an action that is expensive to undo, with a real incident
behind it; a fix to a rule that fires wrongly; better skill trigger descriptions; installer
robustness on a platform we got wrong.

**Likely no:** style and formatting rules (linters do that deterministically and for free);
advice-shaped rules with no failure mode ("prefer small functions"); anything that only makes
sense in one repo — that belongs in that repo's `AGENTS.md`; new always-on content without a
corresponding deletion.

## Rule writing

Rules are read by a model, so write for one: specific, testable, with a clear stop condition.
"Be careful with migrations" does nothing. "Never drop a column in the same change that stops
writing to it — add, backfill, switch reads, remove, as separate changes" does.

State what to do when the rule binds, not only what is forbidden. A rule that only forbids
produces paralysis or silent violation.

## Testing a rule

Add an adversarial prompt under `tests/prompts/` — the phrasing most likely to talk an agent past
your rule, plus the behaviour you expect. Try it against both Claude Code and Codex; they do not
always land the same way.

## Attribution

The `book-*` skills derive from [agent-rules-books](https://github.com/ciembor/agent-rules-books)
by [@ciembor](https://github.com/ciembor), MIT. Improvements to the *rule content* of a book
belong upstream, not here. This repo owns the packaging: frontmatter, triggers, conflict
arbitration, and house overrides.
