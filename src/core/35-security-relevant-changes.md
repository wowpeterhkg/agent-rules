---
tier: critical
codex: digest
digest: |
  # Security-relevant changes

  Auth, sessions, crypto, input parsing, file upload, a new public route, new outbound egress, or
  a new dependency: name the change as security-relevant, name the OWASP risks, and say which
  independent gate covers it — or that none does. Never self-certify.
---

# Security-relevant changes

A change is security-relevant when it touches authentication, authorisation, sessions,
cryptography, input parsing or deserialisation, file upload, a new public route, new outbound
network egress, or adds a dependency.

For those changes:

- Say so explicitly, and name which OWASP Top 10 risks it affects.
- State which independent gate covers it — a scanner, a CI check, a required review. If nothing
  covers it, say that. An unbacked security-relevant change is accepted risk, and accepting risk
  is the human's decision, not yours.
- Never self-certify. "Reviewed", "looks fine", and "no issues found" are not gates. If you claim
  a scan ran, rule 40 applies: paste what it output.
