# Making these rules yours

The rules in this repo are one team's opinions. Some are near-universal ("don't print secrets");
others encode specific conventions you may disagree with. This page marks which is which and how
to change them.

## Start by forking

```bash
gh repo fork wowpeter-idnerd/agent-rules --clone ~/.local/share/airules/repo
~/.local/share/airules/repo/bin/airules install
```

Then edit `src/`, run `python3 build.py`, and commit both `src/` and `dist/`. Your machines pull
from your fork.

## What is opinionated, and how strongly

| Content | Opinion level | Notes |
| --- | --- | --- |
| `src/core/10-git-ceiling.md` | **Strong** | "Never merge, human merges" suits teams with review. If you work solo, you may want the agent to merge its own PRs. |
| `src/core/50-working-agreement.md` | **Strong** | One-step-at-a-time, surgical-by-default, tone. This is personal working style — expect to rewrite it. |
| `src/core/00-prime-directives.md` | **Strong** | Tone rules (no flattery, no emojis, dry). Purely preference. |
| `src/core/20-destructive-actions.md` | Moderate | Mostly universal; the specific thresholds ("more than five files") are arbitrary. |
| `src/core/30-secrets-and-data.md` | Weak | Close to universal. Change only to add your own data classes. |
| `src/core/40-verification.md` | Weak | Close to universal. |
| `src/core/56-approved-stack.md` | **House-specific** | One team's approved technology list. A fork should replace this wholesale, not inherit it. |
| `src/core/57-project-structure.md` | **Strong** | The ten-document set and the same-commit update obligation. Keep the obligation; change the document list to suit. |
| `src/core/55-design-defaults.md` | Moderate | Distilled from four books, organized by decision. Advisory rather than a guardrail — and the first thing to move into a skill if the always-on layer gets too heavy. |
| `src/scoped/*` | Moderate | Stack conventions. Delete the languages you do not use. |
| `src/scoped/ai-data-schema.md` | Moderate | Embedding, RAG, and LLM-interaction schema rules. Delete it if you do no AI data work. |
| `src/skills/idn-*` | **House-specific** | Procedures for one team's infrastructure. See below. |
| `vendor/books/*` | Third-party | Never edit. See `vendor/SOURCES.md`. |

## The `idn-*` skills are examples, not defaults

`idn-cloud-deploy` encodes one team's deployment procedure: app directories at `/opt/<name>`,
images in a single private Docker Hub repo with per-workload tag suffixes, config delivered by
`scp` rather than a git clone on the server. It is a worked example of the *shape* a deployment
skill should take, not advice about how you should deploy.

Either delete `src/skills/idn-cloud-deploy/` or rewrite it for your own infrastructure. Keeping
it unchanged means your agent will confidently follow someone else's runbook.

## Adding a rule

Decide which layer it belongs to:

- **Violating it destroys data, history, or secrets** → `src/core/`. Note the budget: core is
  zero-sum, so adding bytes means removing bytes.
- **It only matters for one file type** → `src/scoped/` with `paths:` globs. OpenCode ships all
  of them inline in the full `AGENTS.md`; Codex gets standalone files in `dist/rules/` that its
  global file points to, plus copies in each scaffolded project's `.agent/rules/`.
- **It is a long procedure or a methodology** → `src/skills/`.
- **It names something specific to one repo** → that repo's `AGENTS.md`, not this repo.

## Adding or removing a book skill

`BOOK_SKILLS` in `build.py` maps skill names to vendored sources. Each entry declares the body
(a `mini` ruleset), reference files (`full` rulesets), and conflict verdicts against rival
skills. Remove an entry to stop shipping that skill; add one to ship a book that is currently
vendored but unused.

Keep the conflict verdicts honest — they are what stops two contradictory methodologies being
applied to the same change.

## Configuration that is not in the repo

| File | Purpose |
| --- | --- |
| `~/.config/opencode/AGENTS.md` | Text outside the airules managed block is yours and survives updates. May tighten a global rule, never loosen one. |
| `~/.codex/AGENTS.md` | Same, for Codex. |
| `~/.config/airules/planning.yml` | Username label for planning issues, asked once at install. Edit it to change the label. |

## Byte budgets

Enforced by `build.py` and CI: 25 KiB for the core layer, 20 KiB for the Codex AGENTS.md, 24 KiB
for the scoped layer in total. Raise them in the constants at the top of `build.py` if you must,
but read the reasoning first — particularly for Codex, where the budget is shared with every
project `AGENTS.md` and overrunning it silently starves them.
