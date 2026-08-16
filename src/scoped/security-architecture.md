---
paths:
  - "**/auth/**"
  - "**/middleware/**"
  - "**/*.guard.ts"
  - "**/security/**"
  - "**/*auth*.ts"
  - "**/*auth*.py"
  - "**/package.json"
  - "**/pyproject.toml"
  - "**/requirements*.txt"
  - "**/go.mod"
---

# Security architecture

- OWASP Top 10 is the baseline. When touching auth, sessions, access control, or input handling,
  name which risks the change affects.
- Minimum three tiers: frontend → backend → database. More layers is fine; fewer is not. The
  frontend never reaches the database and never holds a secret.
- Passwords are hashed with a current memory-hard algorithm. Sensitive PII is encrypted at rest.
- Authorisation is checked server-side on every request. A hidden UI control is not access
  control.
- TLS everywhere, including between services where they cross a host boundary. Two-factor
  authentication on any human-facing admin surface.
- Tokens are short-lived and scoped. A read-only credential is used wherever a write is not
  needed — including registry pulls on servers.
- Rate-limit and log authentication failures; never log the attempted credential.
