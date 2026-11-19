# Troubleshooting

## Rules do not seem to be applied

Rules load when a **session** starts, not when the app starts. Start a new chat or a new terminal
session. A full app restart works but is heavier than needed.

Then: `airules doctor`.

## Stack conventions are not being applied to a specific file

Neither OpenCode nor Codex auto-loads rules by file path. OpenCode gets every convention inline in
its global `AGENTS.md`; Codex gets a list of soft pointers to standalone files in `dist/rules/`.
If the agent has not opened the relevant one, the convention has not reached it.

Consequences:

- The safety rules always load — they are in the core layer of both artifacts.
- Language, stack, and container conventions are present in OpenCode's context but may be
  ignored. For Codex they are only reachable if the model opens the pointer.
- Scaffolded projects also hold copies in `.agent/rules/` — point the agent at those explicitly
  when it matters.

## Skills or rules missing after an update

Auto-updaters have been observed removing user-installed skills. This installer uses real copies,
but if something is missing:

```bash
airules update
```

Check `airules status` for the paths it manages and `airules doctor` for broken ones.

## OpenCode: global rules not loading

The global file must be at `~/.config/opencode/AGENTS.md` (or
`$XDG_CONFIG_HOME/opencode/AGENTS.md`). OpenCode loads it on session start, followed by every
`AGENTS.md` from the workspace directory upward. A directory's own `AGENTS.md` adds to the global
one; it does not replace it.

If you moved your XDG config directory after installing, re-run `airules install`.

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
in `~/.zshrc` (not only `~/.zprofile`).

## Undo everything

```bash
airules uninstall
```

Text you wrote outside the managed fences in the global `AGENTS.md` files is preserved.
