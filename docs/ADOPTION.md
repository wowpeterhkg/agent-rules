# Adoption

## What this is

A set of guardrails that load automatically into Claude Code and Codex on every machine, plus
on-demand skills for design methodologies.

## What it will stop you doing

The agent will refuse to merge PRs, push to default branches, force-push, run destructive
database or docker commands, print secrets, or claim tests passed without running them. It will
ask before adding dependencies or deleting files.

These are refusals by the **agent**, not by git. You can still do all of it yourself.

## Install

```bash
git clone https://github.com/wowpeter-idnerd/agent-rules.git ~/.local/share/airules/repo
~/.local/share/airules/repo/bin/airules install
```

Start a new session to load them. Updates apply themselves after that.

## If a rule fires wrongly

**That is a bug in the rule. File it — do not work around it.**

Add a line to `docs/EVIDENCE.md` under false positives, or open an issue. Silently prefixing your
requests with "ignore the rule about X" hides the problem and leaves everyone else with it.

## If you disagree with a rule

- Personal additions: `~/.claude/rules/99-local-*.md`. These may **tighten** a global rule, never
  loosen one.
- A stack rule you do not want: delete the copy from `~/.claude/rules/`; it returns on update, so
  say something if it keeps bothering you.
- Something specific to one repo: put it in that repo's `AGENTS.md`, which wins over the global
  stack rules.

## Per-project

```bash
airules init
```

Creates `AGENTS.md`, a `CLAUDE.md` bridge, and `.agent/`. Review and commit them.
