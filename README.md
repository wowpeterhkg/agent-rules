# agent-rules

Global engineering guardrails for AI coding agents — installed once per machine, shared across
every project, and kept in sync from a git repo.

One install covers six surfaces:

| Agent | CLI | Desktop app | VS Code |
| --- | --- | --- | --- |
| Claude Code | yes | yes (Code tab) | yes |
| Codex | yes | yes | yes |

## Why

Agents forget things between sessions and between machines. Project `CLAUDE.md` files help, but
they stop at the repo boundary, they drift, and they have to be written again for every new
project. Meanwhile the rules that matter most — don't merge that PR, don't force-push, don't
print the contents of `.env`, don't claim the tests passed without running them — are the same
everywhere.

This puts those rules in one repo, installs them into both agents' global config, and updates
them in the background so every machine agrees.

## Install

```bash
git clone https://github.com/wowpeter-idnerd/agent-rules.git ~/.local/share/airules/repo
~/.local/share/airules/repo/bin/airules install
```

Start a new session (or `/clear`) to load the rules. Add `~/.local/bin` to your `PATH` if the
installer says so — desktop apps recover `PATH` from your shell profile.

**These are one team's rules.** They are opinionated on purpose. Fork the repo, edit `src/`, and
make them yours — see [docs/CUSTOMIZING.md](docs/CUSTOMIZING.md).

## What gets installed

| Path | What |
| --- | --- |
| `~/.claude/rules/airules-*.md` | always-on core + path-scoped stack rules |
| `~/.claude/CLAUDE.md` | a small managed block; your own notes are preserved |
| `~/.claude/skills/{book,idn}-*` | on-demand skills |
| `~/.agents/skills/{book,idn}-*` | the same skills, where Codex looks |
| `~/.codex/AGENTS.md` | core rules inline + pointers to the rest |
| `~/.codex/config.toml` | a managed block raising `project_doc_max_bytes` |
| `~/.claude/settings.json` | four `SessionStart` hooks, merged — never overwritten |

Files are **copied, not symlinked**: Claude Code has documented failures loading symlinked
user-level skills, and its auto-updater has been observed removing user symlinks from
`~/.claude/skills/`.

`airules uninstall` reverses only what the ownership ledger records. Your plugins, your own
memory notes, and skills installed by other tools are left alone.

## Update

Updates apply themselves — a background check at session start (at most daily) and a scheduled
daily job both fast-forward the clone and re-copy artifacts. When one lands you are told to start
a new session to pick it up. Force it with `airules update`; inspect with `airules status` and
`airules doctor`.

## Per-project

```bash
airules init
```

Creates `AGENTS.md` (the source of truth both agents read), a two-line `CLAUDE.md` bridge, and
`.agent/` for project detail. Stack rules are copied into `.agent/rules/` so every surface can
read them without reaching outside the workspace.

Optionally, list your GitHub accounts in `~/.config/airules/owners` and the agent will offer to
run this in your own repos that lack an `AGENTS.md`. Repos belonging to anyone else are ignored,
so your conventions never end up in someone else's pull request.

## Layout

```
src/core/      always-on. Irreversible-mistake guardrails + working agreement.
src/scoped/    path-scoped conventions (TypeScript, Python, Docker, ...). Claude only.
src/skills/    house procedures, installed as idn-* skills.
vendor/books/  14 book rule sets, vendored from agent-rules-books (MIT).
dist/          GENERATED and committed. CI fails if it is stale.
```

Edit `src/`, run `python3 build.py`, commit both. Never edit `dist/` or `vendor/` by hand.

## Design notes

- **Core is a budget, not a bookshelf.** Every byte is paid on every turn of every task. The
  admission test lives in [docs/RULES.md](docs/RULES.md): would an agent, with no rule, plausibly
  do something that costs a human an hour to undo?
- **Claude and Codex are not symmetric.** Claude auto-loads `~/.claude/rules/` and supports
  `@imports` and path globs. Codex has one global file, no imports, no path scoping, and a byte
  budget shared with every project `AGENTS.md` — so its artifact inlines the critical rules and
  points at the rest.
- **Books are on-demand.** All 14 rule sets total 87 KB, more than Codex's entire budget. They
  ship as skills that cost nothing until invoked, one per task.

## Credits

The `book-*` skills are generated from **[agent-rules-books](https://github.com/ciembor/agent-rules-books)**
by **[Maciej Ciemborowicz (@ciembor)](https://github.com/ciembor)** — rule sets distilled from
classic software engineering books, MIT licensed. That project did the hard part: reading the
books and compressing them into rules an agent can actually follow.

This repo vendors those rule sets verbatim under `vendor/books/` (never edited — see
[vendor/SOURCES.md](vendor/SOURCES.md)) and adds packaging: skill frontmatter with triggers,
conflict arbitration between overlapping books, and house overrides. If the book rules are what
you want, go to the upstream project first.

Books covered: A Philosophy of Software Design, Clean Architecture, Clean Code, Code Complete,
Designing Data-Intensive Applications, Domain-Driven Design (+ Distilled, + Implementing),
Patterns of Enterprise Application Architecture, Refactoring, Refactoring Guru, Release It!,
The Pragmatic Programmer, Working Effectively with Legacy Code.

## License

MIT — see [LICENSE](LICENSE). Vendored book rule sets are MIT from the upstream project and
carry their own [LICENSE](vendor/books/LICENSE).
