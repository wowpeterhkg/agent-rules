---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript

- Strict mode is assumed (`"strict": true`). Do not relax a compiler option to make code compile.
- No `any`. Use `unknown` at boundaries and narrow it. If you genuinely cannot type something,
  say so rather than reaching for `any`.
- No non-null assertion (`!`) on anything that came from I/O, a query, or user input.
- No `@ts-expect-error` or `@ts-ignore` without a comment naming the reason and a linked issue.
- Validate payloads at API and boundary layers with `zod`. Types derive from the schema
  (`z.infer`), not the other way round.
- Prefer discriminated unions over boolean flags for state that has more than two meanings.
- Shared contracts (DTOs, schemas, constants) live in the project's shared/interfaces directory,
  not duplicated per consumer.
- 2-space indent, Prettier formatting. Do not hand-format; do not reformat files you did not
  otherwise change.
