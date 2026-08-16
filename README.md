# agent-rules

Global engineering rules and guardrails for AI coding agents, installed once per machine and
kept in sync from this repo.

Works across six surfaces from one install:

| Agent | CLI | Desktop app | VS Code |
| --- | --- | --- | --- |
| Claude Code | yes | yes (Code tab) | yes |
| Codex | yes | yes | yes |

## Install

```bash
git clone https://github.com/wowpeter-idnerd/agent-rules.git ~/.local/share/airules/repo
~/.local/share/airules/repo/bin/airules install
```

Then start a new session (or `/clear`) to load the rules. Add `~/.local/bin` to your `PATH` if
the installer says so — the desktop apps recover `PATH` from your shell profile.

## Update

Updates apply themselves. A background check runs at session start (at most once a day) and a
scheduled job runs daily; both fast-forward the clone and re-copy the artifacts. When an update
lands you are told to start a new session to pick it up.

To force it:

```bash
airules update
```

```bash
airules status
```

## What gets installed

| Path | What |
| --- | --- |
| `~/.claude/rules/airules-*.md` | always-on core + path-scoped stack rules |
| `~/.claude/CLAUDE.md` | a managed block; your own notes are preserved |
| `~/.claude/skills/{book,idn}-*` | on-demand skills |
| `~/.agents/skills/{book,idn}-*` | the same skills, where Codex looks |
| `~/.codex/AGENTS.md` | core rules inline + pointers to the rest |
| `~/.codex/config.toml` | a managed block raising `project_doc_max_bytes` |
| `~/.claude/settings.json` | four `SessionStart` hooks, merged — never overwritten |

Files are **copied, not symlinked**: Claude Code has documented failures loading symlinked
user-level skills, and its auto-updater has been seen removing user symlinks from
`~/.claude/skills/`.

## Per-project setup

```bash
airules init
```

Creates `AGENTS.md` (the source of truth both agents read), a two-line `CLAUDE.md` bridge, and
`.agent/` for project detail. The stack rules are copied into `.agent/rules/` so every surface
can read them without reaching outside the workspace.

## Layout

```
src/core/      always-on. Irreversible-mistake guardrails + the working agreement.
src/scoped/    path-scoped conventions (TypeScript, Python, Docker, ...). Claude only.
src/skills/    house procedures, installed as idn-* skills.
vendor/books/  14 book rule sets, vendored MIT from ciembor/agent-rules-books.
dist/          GENERATED and committed. CI fails if it is stale.
```

Edit `src/`, run `python3 build.py`, commit both. Never edit `dist/` or `vendor/` by hand.

## Design notes

- **Core is a budget, not a bookshelf.** Every byte is paid on every turn of every task. The
  admission test is in [docs/RULES.md](docs/RULES.md).
- **Codex shares one byte budget** across its global and project docs, so its artifact inlines
  the critical rules and points at the rest.
- **Books are on-demand.** All 14 rule sets total 87 KB — more than Codex's entire budget. They
  ship as skills that cost nothing until invoked, one per task.

## Uninstall

```bash
airules uninstall
```

Reverses only what the ownership ledger records. Your plugins, your own memory notes, and any
skills installed by other tools are left alone.
