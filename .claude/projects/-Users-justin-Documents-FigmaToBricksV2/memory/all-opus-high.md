---
name: all-opus-high
description: REVERSED 2026-11-26 — back to the original role table with Fable (planner/round-1 reviewer Fable high, builder/auditor Opus xhigh, rest Opus high); the 2026-11-18 all-Opus-high rule ended
metadata:
  type: feedback
---

From 2026-11-26 the pipeline uses the global role table again: planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer, verifier, finisher Opus 5.5 high; AC auditor Opus 5.5 xhigh. Mini and Full both run their full steps again (no more planner + builder only).

**Why:** Justin, 2026-11-26: "full for classes and mini for rest but use the original pipline with fabkle" ("we have tokens now"). This replaces his 2026-11-18 "everything opus 5.5 high, no fable no xhigh; planner + builder only".

**How to apply:** set model/effort per role from the global table on every Agent call. Related: [[review-round-cap]], [[run-without-stopping]].
