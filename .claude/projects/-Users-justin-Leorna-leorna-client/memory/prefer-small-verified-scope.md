---
name: prefer-small-verified-scope
description: "In a story design, prefer a short allow-list over an exhaustive generated table, record where output must land, and only document tool behaviour a test has proven"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a7b9b85d-7266-4004-b6d6-044cf09432a3
  modified: 2026-09-27T18:25:44.534Z
---

Justin approved the 86bbu3xfw (Claude Code transformer) plan on 2026-09-27 with three changes:
1. Drop a generated 174-key settings table; use a short allow-list (`$schema`, `permissions`, `env`, `model`) and skip everything else with a warning.
2. Write down where output must be written when it doesn't fit the existing connector (Claude's `ApplyConfig` roots at `~/.claude`; project-scoped output needs `claudecode.New(<projectDir>)`), in the README and the PR Assumptions, without changing the connector.
3. Prove real-tool claims before documenting them (e.g. "`claude mcp list` never starts servers"): use harmless fixture commands and a marker file, and only write the claim if the run shows it.

**Why:** He wants stories small enough to review and every README sentence to be backed by evidence; a large hand-maintained table is scope creep and drifts.

**How to apply:** When a design reaches for an exhaustive list of an external tool's options, propose the minimal set the pack actually needs, with a warning for the rest. Flag integration mismatches in docs + Assumptions rather than fixing them in someone else's area. Related: [[consistency-over-local-fixes]], [[infer-and-list-assumptions]], [[leorna-workflow]].
