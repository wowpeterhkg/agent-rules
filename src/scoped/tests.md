---
paths:
  - "**/*.spec.ts"
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*_test.py"
  - "**/test_*.py"
  - "**/tests/**"
  - "**/e2e/**"
---

# Tests

- Test observable behaviour, not implementation detail. A test that breaks on a rename without a
  behaviour change is testing the wrong thing.
- One reason to fail per test. Name the test after the behaviour, not the function.
- No sleeps. Wait on a condition or a fake clock.
- No shared mutable fixtures between tests. Each test builds what it needs.
- No real network, no real cloud, no production database. Mocks and fixtures live in the project's
  mocks directory.
- Snapshot tests only for genuinely stable serialised output — never as a substitute for
  assertions.
- Fixtures use generated data. Never production rows.
- When fixing a bug, the failing test comes first and must actually fail before the fix.

Test policy beyond this file — when to write tests, how much to write, red-green-refactor — is
owned by the `tdd` skill, not by any `book-*` skill.
