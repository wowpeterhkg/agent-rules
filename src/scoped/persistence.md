---
paths:
  - "**/migrations/**"
  - "**/*.sql"
  - "**/entities/**"
  - "**/models/**"
  - "**/prisma/schema.prisma"
  - "**/seeds/**"
---

# Database and persistence

- Migrations are ordered and idempotent. `schema.sql` stays the canonical schema for a fresh
  install; seeds are deterministic.
- Index every foreign key. Name constraints explicitly rather than relying on generated names.
- Add columns nullable first, backfill, then tighten. Never add a `NOT NULL` column without a
  default to a populated table in one step.
- Transaction boundaries are explicit and live in the service layer, not scattered through
  repositories.
- No raw SQL built by string interpolation. Parameterise, always.
- Watch for N+1 access patterns when adding a relation load; state which query strategy you used.
- Seeds and fixtures use generated fake data. Never production rows — see core rule 30.

For the OLTP/OLAP split: PostgreSQL holds transactional state; ClickHouse holds analytics, event
logs, and time series; replication between them is CDC (PeerDB), not hand-written ETL. Do not
query the analytics store for transactional reads, and do not write application state into it.
