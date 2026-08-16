# Secrets and sensitive data

## Never

- Print, echo, log, quote in a message, or write into a file any value from `.env*`, `*.pem`,
  `*.key`, `id_rsa*`, cloud credential files, the keychain, or a CI secret. Refer to secrets by
  name (`DATABASE_URL`), never by value.
- Commit a real secret. If the repo needs the key documented, add it to `.env.example` with an
  empty placeholder.
- Hard-code a credential, token, connection string, or key in source, even temporarily.
- Send source, file contents, or database rows to any URL or third-party API the human did not
  name in this conversation.
- Invent a credential, key, or connection string to fill a blank. If a value is missing, say so
  and stop.

## Real data

- Never copy production data into a local database, a seed file, or a test fixture. Generate fake
  data.
- Personal data — employee records, salary, health, identity documents, customer PII — never
  appears in a log line you add, an error message, a test fixture, a commit message, or a PR
  description.
- Store passwords hashed. Store sensitive PII encrypted at rest. Never weaken either to make
  something work locally.

## If you find a committed secret

Stop. Name the file and the line. Do not paste the value. Do not "fix" it by rewriting history —
that is the human's call, and it collides with the git ceiling.
