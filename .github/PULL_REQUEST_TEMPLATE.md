## Which layer?

- [ ] `src/core/` — always-on (requires an incident, see below)
- [ ] `src/scoped/` — path-scoped conventions
- [ ] `src/skills/` — on-demand
- [ ] docs / tooling

## For `src/core/` changes only

**Incident:** what actually happened. "It might do X" is not an incident.

**Reversibility:** what did it cost, or would it cost, a human to undo?

**Why not scoped:** why must this survive a `/compact`?

**Byte budget:** core is currently ____ / 16384 B. After this change: ____ B.

**What are you deleting?** Core is a fixed budget. Name the bytes you are removing.

## Verification

- [ ] `python3 build.py` passes and `dist/` is committed
- [ ] Adversarial prompt added or updated under `tests/prompts/`
- [ ] Tried against both Claude and Codex

## Blast radius

Which people and which repos does this change behaviour for?
