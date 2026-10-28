---
name: run-without-stopping
description: "Build straight through without check-ins (2026-10-07); when away (2026-10-27) take the recommended options, tell lost agents to research, resume limit-stopped agents, full report on return"
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

On 2026-10-27, going to sleep mid-pipeline (label-floor), he said: keep it running whatever happens, "go with the recommended stuff" for anything the agents ask, and if an agent is lost, "tell it to go do research and try to implement its best"; resume anything a usage limit stopped; "When I'm back, I want a full report on everything that happened." So while he's away: take every ⭐/recommended option without asking, tell stuck agents to research and implement their best (recorded as rulings), resume rate-limited agents with SendMessage, run the pipeline through to the merge, and keep a running log for the full report.
