# Skill conflict arbitration

`book-*` skills are opinionated methodologies that contradict each other by design. Core rule 60
says: load at most one per task. When two seem to apply, these verdicts decide.

| Pair | Verdict |
| --- | --- |
| `book-refactoring` ↔ `book-legacy-code` | No tests → Legacy Code wins. Green suite → Refactoring wins. |
| `book-clean-architecture` ↔ `book-enterprise-patterns` | Clean Architecture wins on dependency direction; Enterprise Patterns wins on how a mapper or repository is built inside a layer. |
| `book-clean-architecture` ↔ `book-domain-driven-design` | DDD decides what the boundary is; Clean Architecture decides which way the arrow points across it. |
| `book-domain-driven-design` ↔ `book-data-intensive` | DDD wins inside one service; Data-Intensive wins once state crosses a service or durability boundary. |
| `book-data-intensive` ↔ `book-production-reliability` | DDIA wins on correctness of the data model; Release It wins on what happens when a dependency is down. |
| `book-code-construction` ↔ anything | Always loses. It is the fallback when nothing else matches. |
| `book-pragmatic-programmer` ↔ anything | Loses to any more specific skill. It is a tiebreaker, not a tie. |
| any `book-*` ↔ `tdd` / `codebase-design` / `code-review` | The house skills win on process; the book wins on design content. Different axes. |

## Not generated

**A Philosophy of Software Design** is vendored but has no skill. The installed `codebase-design`
skill already is APOSD's vocabulary — deep modules, information hiding, interface vs
implementation — and shipping both would put two near-identical descriptions in competition for
the same trigger.

If `codebase-design` is ever removed, generate `book-software-design-philosophy` from
`vendor/books/a-philosophy-of-software-design/a-philosophy-of-software-design.mini.md` by adding
an entry to `BOOK_SKILLS` in `build.py`.
