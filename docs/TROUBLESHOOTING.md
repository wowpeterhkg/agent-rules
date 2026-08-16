# Troubleshooting

## Rules do not seem to be applied

Rules load when a **session** starts, not when the app starts. Start a new chat, run `/clear`, or
open a new terminal session. A full app restart works but is heavier than needed.

Then: `airules doctor`.

## Stack rules do not apply to files outside the working directory

Path-scoped rules (`airules-*.md` with a `paths:` block) are matched against the **working
directory**. A file read from a scratch directory, a sibling repo, or an absolute path outside the
cwd matches nothing — only `airules-00-core.md` applies, because it has no `paths:` block.

Verified 2026-08-16 on Claude Code desktop by sealed-token probe: an identical `.sql` file pulled
`airules-persistence.md` + `airules-ai-data-schema.md` when read from inside the cwd, and nothing
at all from outside it. The probe also confirmed `**/` matches zero directories, so a root-level
`Dockerfile` does get `airules-containers.md`.

Consequence: cross-repo and scratch-directory work runs on core rules alone. The safety
constraints still hold; the language, stack, and container rules do not. Read the relevant
`airules-*.md` explicitly if it matters.

Untested: whether Edit, Write, or Grep trigger injection the way Read does, and whether Codex
scopes the same way.

## Claude: skills or rules missing after an update

Claude Code's auto-updater has been observed removing user symlinks from `~/.claude/skills/`.
This installer uses real copies for that reason, but if something is missing:

```bash
airules update
```

## Codex: global rules ignored in a project

Known upstream bug (openai/codex#27705): the Codex **app** drops the global `~/.codex/AGENTS.md`
when the project has its own `AGENTS.md`. `airules init` therefore embeds the git guardrails
directly into each project's `AGENTS.md`. If you wrote that file by hand, re-run `airules init`
or paste the guardrail section in.

Also check for `~/.codex/AGENTS.override.md` — if it exists it silently shadows the global file.
`airules doctor` warns about this.

## Codex: pointer files are not being read

Codex permits full-disk reads in its default sandbox modes, so pointers resolve. If an
enterprise config enables the restricted `[permissions]` filesystem model, out-of-workspace
reads can be blocked — in that case rely on the `.agent/rules/` copies that `airules init`
places inside the repo.

## The desktop app cannot find `airules`

Desktop apps recover `PATH` from your shell profile only. Make sure `~/.local/bin` is exported
in `~/.zshrc` (not only `~/.zprofile`), then restart the app. The hook command itself is stored
as an absolute path, so hooks keep working regardless.

## Claude Desktop "Cowork" tab has none of this

Cowork syncs skills and settings from your claude.ai account, not from `~/.claude`. Nothing
installed locally reaches it; configure it separately in that UI.

## Undo everything

```bash
airules uninstall
```
