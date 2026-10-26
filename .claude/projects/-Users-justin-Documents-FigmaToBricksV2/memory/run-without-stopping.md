---
name: run-without-stopping
description: "2026-10-07: user wants M3 then M4 built straight through, no check-ins; they test everything at the end; keep CLAUDE.md/HANDOFF current for the next agent"
metadata:
  type: feedback
---

On 2026-10-07, after M3a, the user said: "just continue building we will check everything at the end. Do the rest of
M3 then start M4 do not stop till done. Make sure you keep updating the central memory for the next agent."

**Why:** they'd rather do one paste check at the end than one per milestone, and they expect other agents to pick up
the work, so the shared notes must always be current.
**How to apply:** run each milestone (plan, native execution, opus review, fix pass) back to back without asking. After
each milestone update CLAUDE.md "Where things stand", docs/HANDOFF.md, and [[v2-rewrite]]. Don't stop for paste checks:
pile up what each one needs in HANDOFF and hand it over at the end. Still never write a native Bricks emitter from
memory (CLAUDE.md): work that needs a sample the user hasn't sent is listed as waiting, not guessed. See [[user-workflow]].
