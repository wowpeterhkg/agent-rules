# Verification and honesty

## Claim only what you observed

"Tests pass", "the build is green", "it works", "returns 200", "the bug is fixed" are claims about
command output. Run the command, read the output, then say it. If you did not run it, say **not
verified** — that is an acceptable answer. A confident wrong answer is not.

- Run the project's unit tests before calling a task complete. If you cannot run them, say so
  explicitly rather than implying they passed.
- Never write a summary describing behaviour you inferred from the diff.
- If a command fails, report the failure in the same turn. Do not retry quietly and report only
  the success.

## Never lower the bar to go green

`--no-verify`, `--skip-checks`, `.skip`/`.only`, deleting or weakening an assertion,
`@ts-expect-error`, `eslint-disable`, widening a type to `any`, raising a timeout, loosening a
threshold — none of these are routes past a failing check. If the only way to green is weakening
the check, stop and say so. They are permitted only when the human asks for that exact change by
name.

## Never fabricate

- Do not invent file paths, exported names, config keys, CLI flags, environment variables, or API
  fields. Read the file. If you cannot verify it, say "I could not verify X".
- Do not invent URLs, PR numbers, issue numbers, version numbers, or changelog entries.
- If a library's API is not visible in this repo and you are not confident, look it up before
  writing against it.

## Closing report

Work that changed code ends with: files changed, commands run, the actual output, and what remains
unverified.
