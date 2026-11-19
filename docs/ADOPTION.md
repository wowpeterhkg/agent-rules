# Adoption

## What this is

A set of guardrails that load automatically into OpenCode and Codex on every machine, plus
on-demand skills for design methodologies. Both agents use the `AGENTS.md` convention.

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

Start a new session to load them. Updates after that are applied by a daily scheduled job.

## If a rule fires wrongly

**That is a bug in the rule. File it — do not work around it.**

Add a line to `docs/EVIDENCE.md` under false positives, or open an issue. Silently prefixing your
requests with "ignore the rule about X" hides the problem and leaves everyone else with it.

## If you disagree with a rule

- Add your own text **outside** the managed fences in `~/.config/opencode/AGENTS.md` or
  `~/.codex/AGENTS.md`. It survives every update. It may **tighten** a global rule, never loosen
  one.
- A convention you do not want: fork and delete it from `src/scoped/`. It returns on update
  otherwise, so say something if it keeps bothering you.
- Something specific to one repo: put it in that repo's `AGENTS.md`, which adds to the global
  rules. Core still wins over everything.

## Per-project

```bash
airules init
```

Creates `AGENTS.md` with the git guardrails embedded, `.agent/`, and `docs/`. Review and commit
them. Run it yourself in any repo that lacks them; there is no automatic prompt.
