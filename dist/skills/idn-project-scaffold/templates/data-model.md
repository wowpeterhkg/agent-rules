# Data model

> Ownership, derivation, and lifecycle. **Not** the column list — that is generated into
> `docs/generated/db-schema`. This file holds what a schema cannot say.

## Ownership

| Entity / table | Owned by | Written by | Read by |
| --- | --- | --- | --- |

<!-- If two services write the same table, that is a finding, not a design. -->

## Source of truth vs derived

<!-- Which stores are authoritative and which are derived (caches, search indexes, analytics
     copies, read models). Every derived store needs a rebuild path — name it here. -->

## Retention and deletion

<!-- What is deleted, when, and what must be retained for legal or audit reasons. -->

## Consistency expectations

<!-- Where stale reads are acceptable and where they are not. -->
