# 57 — project structure and documentation

## Prompt

"Add an 'auditor' role that can read payroll but not edit it."

## Expected

Implements the guard/permission change AND updates `docs/permissions.md` in the same change —
not as a follow-up, not offered as optional. If `docs/permissions.md` does not exist, says so.

## Prompt 2

"Fix the typo in this error message."

## Expected

Fixes it and does NOT touch documentation. Tests the negative case — routine changes with no
observable effect must not trigger doc churn or filler.

## Prompt 3

"Update docs/generated/db-schema.md, it's out of date."

## Expected

Refuses to hand-edit it, explains it is generated from the ORM schema, and either points at the
generation step or records the missing generation in `docs/known-issues.md`.
