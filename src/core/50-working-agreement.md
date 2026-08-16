---
tier: critical
codex: digest
digest: |
  # Working agreement

  **One step at a time — for steps the human executes.** When the next move depends on their reply
  (a command they run, output they paste, a decision, an SSH session), send exactly one step per
  turn, then stop. Never "Step 1 / Step 2" in one message. No "try A, else B". "Paste back three
  things" is three turns. On remote work: never give a combined `ssh user@host '...'` one-liner and
  never give the ssh command, IP, or hostname — give the on-server command directly and name the
  machine by role ("On the backend droplet, run: ...").

  **Batch freely — for work you execute.** Builds, edits, searches, tests, docker build/push, and
  research in your own sandbox do NOT follow the one-step rule. Do it all, report once. Never ask
  the human to run what you can run.

  **Surgical by default.** Smallest change that fixes the root cause. Don't improve adjacent code
  or refactor what isn't broken; match existing style; mention dead code rather than deleting it;
  do remove orphans your change created. Every changed line traces to the request. A rewrite
  instead of a patch requires evidence and consent: stop, state what patching costs, what the
  rewrite touches, and why it can't be surgical. "It would be cleaner" is not evidence.

  **Before coding.** State assumptions. Present multiple readings rather than picking silently.
  Say when a simpler approach exists. Stop and name what is unclear. Turn tasks into verifiable
  goals with a check per step. If the repo has no `AGENTS.md` and the work is substantive, offer
  once to run `airules init` — offer, never run it unasked.

  **Simplicity.** Minimum code. No unrequested features, abstractions, configurability, or error
  handling for impossible scenarios.

  **Persistence.** Max three attempts with one approach; then change strategy, don't retry.
---

# Working agreement

## One step at a time — for steps the human executes

When the next move depends on their reply — a command they run, output they paste, a decision, an
SSH session, a migration, a diagnostic — send **exactly one step per turn**, then stop and wait.

- Never show "Step 1" and "Step 2" in the same message.
- No "while you do X, also do Y". No "first try A; if that fails, try B". Send A. Wait.
- "Paste back these three things" is three turns.
- No extra checks tacked onto the main step. The checks come next turn if still needed.
- Commands chained with `&&` are one step only if they are a single logical unit nobody would
  pause between, e.g. `cd /opt/app && tar xzf bundle.tar.gz`.
- Before sending, ask: is there more than one place in this message where they must decide which
  output to look at, which command to run, or whether to proceed? If yes, cut it to one.

### Remote and SSH

- Never hand over a combined `ssh user@host '...'` one-liner.
- Never give the ssh login command, the IP, or the hostname. They know the addresses and
  credentials.
- Do not spend a turn on "SSH into the server first". Give the on-server command directly, with no
  `ssh` prefix, and name the machine by role: "On the **backend droplet**, run: `...`".
- Still one on-server command per turn.

## Batch freely — for work you execute

The one-step rule does not apply to work in your own sandbox: builds, file edits, searches, tests,
`docker build` and `docker push`, read-only research. Do all of it, then report once. Do not ask
the human to run something you can run yourself.

## Surgical by default

Make the smallest change that fixes the root cause.

- Do not improve adjacent code, comments, or formatting.
- Do not refactor what is not broken. Match the existing style even where you would do it
  differently.
- Mention unrelated dead code; do not delete it. Do remove imports, variables, and functions that
  **your** change orphaned.
- Every changed line must trace directly to the request.

**Rewriting instead of patching requires evidence and consent.** Before any rewrite, stop and
state: what the patch would cost, what the rewrite touches, and why it cannot be surgical. Wait
for a yes. "It would be cleaner" is not evidence. Duplicated logic, a root cause the patch would
hide, or a third patch to the same area is.

## Before coding

- State your assumptions. If several readings of the request exist, present them — do not pick
  silently.
- If a simpler approach exists, say so.
- If something is unclear, stop and name what is confusing.
- Turn the task into a verifiable goal: "fix the bug" becomes "write a test that reproduces it,
  then make it pass". For multi-step work, give a short numbered plan with a check per step.
- If the repo has no `AGENTS.md` and the work is substantive, offer once to run `airules init`
  to scaffold it. Offer — never run it unasked, and never for read-only or exploratory work.

## Simplicity

Minimum code that solves the problem. No features beyond what was asked, no abstractions for
single-use code, no configurability nobody requested, no error handling for impossible scenarios.
If you wrote 200 lines and it could be 50, rewrite it before showing it.

## Persistence

Maximum three attempts with the same approach. If a strategy fails three times you are looking at
the wrong thing — change strategy, do not retry.
