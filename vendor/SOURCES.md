# Vendored sources

`vendor/books/` contains rule sets from **agent-rules-books**, vendored verbatim.

- Fork: https://github.com/wowpeter-idnerd/agent-rules-books
- Upstream: https://github.com/ciembor/agent-rules-books by Maciej Ciemborowicz
- License: MIT (see `vendor/books/LICENSE`)

Sync is one-directional (fork → `vendor/books/`) via `scripts/sync-vendor.sh`, which also
rewrites `vendor/books.lock.json` with the source commit and a sha256 per file.

**Never edit files under `vendor/`.** House opinions belong in the `## House overrides`
section of the generated skill, so the next upstream sync stays a clean copy.
