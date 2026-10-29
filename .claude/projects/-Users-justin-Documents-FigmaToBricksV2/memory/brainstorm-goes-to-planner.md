---
name: brainstorm-goes-to-planner
description: "A \"brainstorm with me, then write a proposal\" request is still orchestrated: ask Justin's questions in session, a planner agent writes the proposal (2026-10-29)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 519648e7-1ba1-46ba-a0a3-91e300b908f4
  modified: 2026-10-29T23:57:02.979Z
---

On 2026-10-29 Justin pasted a brainstorm prompt ("Ask me questions one at a time … Then write a proposal") for the
website importer. I asked the questions in session but also started reading the spec and code to work out the options
myself. Justin: "aren't you supposed to be the orchestrator and give this to a plan agent".

**Why:** the global orchestrator rule covers brainstorms and proposals too, even when the prompt says "you"; reading code
to weigh options is the planner's work.

**How to apply:** ask Justin the questions only he can answer in session (that's recording answers), with no code
reading beyond routing; then dispatch a fresh Opus planner with his answers in the brief, and relay its proposal,
questions and proposed ACs. See [[run-without-stopping]].
