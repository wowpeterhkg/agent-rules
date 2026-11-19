# agent-rules

Global engineering guardrails for AI coding agents — installed once per machine, shared across
every project, and kept in sync from a git repo.

One install covers two agents, both using the `AGENTS.md` convention:

| Agent | CLI | Desktop app | IDE extension |
| --- | --- | --- | --- |
| OpenCode | yes | yes | yes |
| Codex | yes | yes | yes |

## Why

Agents forget things between sessions and between machines. Project `AGENTS.md` files help, but
they stop at the repo boundary, they drift, and they have to be written again for every new
project. Meanwhile the rules that matter most — don't merge that PR, don't force-push, don't
print the contents of `.env`, don't claim the tests passed without running them — are the same
everywhere.

This puts those rules in one repo, installs them into both agents' global instructions, and updates
them in the background so every machine agrees.

## Install

```bash
git clone https://github.com/wowpeter-idnerd/agent-rules.git ~/.local/share/airules/repo
~/.local/share/airules/repo/bin/airules install
```

The installer asks once for the GitHub username label to put on planning issues and saves it in
`~/.config/airules/planning.yml`. Start a new session to load the rules. Add `~/.local/bin` to your
`PATH` if the installer says so — the scheduled updater and IDE surfaces recover `PATH` from your
shell profile.

**These are one team's rules.** They are opinionated on purpose. Fork the repo, edit `src/`, and
make them yours — see [docs/CUSTOMIZING.md](docs/CUSTOMIZING.md).

Use `--no-opencode` or `--no-codex` to install for only one of the two agents.

## What gets installed

| Path | What |
| --- | --- |
| `~/.config/opencode/AGENTS.md` | managed block with the full rules — core plus all conventions |
| `~/.codex/AGENTS.md` | managed block with the compact rules and pointers to detail files |
| `~/.config/opencode/skills/{book,idn}-*` | on-demand skills, native OpenCode location |
| `~/.agents/skills/{book,idn}-*` | the same skills, where Codex looks |
| `~/.codex/config.toml` | a managed block raising `project_doc_max_bytes` |
| `~/.config/airules/planning.yml` | the username label for planning issues, asked once at install |

Files are **copied, not symlinked**: agent auto-updaters have been observed removing user symlinks
from skills directories, and symlinked skills have a history of loading failures. The two global
`AGENTS.md` files are managed blocks rather than whole files, so anything you write outside the
fences is preserved on update and uninstall.

`airules uninstall` reverses only what the ownership ledger records. Your own notes, your plugins,
and skills installed by other tools are left alone.

## Update

Updates apply themselves — a scheduled daily job (launchd or cron) fast-forwards the clone and
re-copies the artifacts. There are no editor hooks. Force an update with `airules update`; inspect
with `airules status` and `airules doctor`. Start a new session after one lands.

## Per-project

```bash
airules init
```

Creates `AGENTS.md` with the git guardrails embedded, `.agent/` for project detail, and `docs/`
with the standard document set. Stack rules are copied into `.agent/rules/` so every surface can
read them without reaching outside the workspace.

## Layout

```
src/core/      always-on. Irreversible-mistake guardrails + working agreement.
src/scoped/    conventions for specific file types (TypeScript, Python, Docker, ...).
src/skills/    house procedures, installed as idn-* skills.
vendor/books/  14 book rule sets, vendored from agent-rules-books (MIT).
dist/          GENERATED and committed. CI fails if it is stale.
```

Edit `src/`, run `python3 build.py`, commit both. Never edit `dist/` or `vendor/` by hand.

## Design notes

- **Core is a budget, not a bookshelf.** Every byte is paid on every turn of every task. The
  admission test lives in [docs/RULES.md](docs/RULES.md): would an agent, with no rule, plausibly
  do something that costs a human an hour to undo?
- **One convention, two artifacts.** OpenCode loads a single global `AGENTS.md` with no hard cap,
  so it gets the full text including every convention. Codex shares a byte budget with project
  docs, so its `AGENTS.md` holds the critical rules and soft pointers to standalone detail files.
  Both are `AGENTS.md`; no legacy bridge file or editor config is created or depended on.
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
