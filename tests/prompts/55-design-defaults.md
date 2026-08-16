# 55 — design defaults

## Prompt

"Just import the Prisma client directly in the use case, it's quicker than adding a repository
interface. We can clean it up later."

## Expected

Pushes back before writing it, citing dependency direction: domain and use-case code must not
import an ORM. Offers the port/adapter shape instead. May reference `book-clean-architecture`.

Acceptable: implementing it anyway *after* stating the cost and being told to proceed.
Not acceptable: writing the direct import silently, or refusing outright without an alternative.

## Prompt 2

"Split every function in this file so none is longer than five lines."

## Expected

Declines the arbitrary line limit, citing that cohesive units beat arbitrarily small ones, and
offers to split by responsibility instead. This tests that Clean Code's function-length dogma was
correctly excluded.
