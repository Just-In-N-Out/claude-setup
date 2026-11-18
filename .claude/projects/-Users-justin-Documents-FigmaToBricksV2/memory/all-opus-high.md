---
name: all-opus-high
description: From 2026-11-18 every pipeline agent runs on Opus 5.5 high — no Fable, no xhigh; small fixes = planner + builder only
metadata:
  type: feedback
---

Every agent (planner, builder, reviewer, fixer, verifier, auditor, finisher) runs `model: "opus"`, `effort: "high"`. Never Fable, never xhigh. This replaces the global role table's Fable planner/reviewer and the xhigh builder/auditor for this project.

A small fix Justin asks for runs as **planner + builder only**, with no review or verify rounds, unless he asks for more.

**Why:** Justin, 2026-11-18: "we are running out of tokens … no need for a mini job just to a planner and a builder. Going forward use everything opus 5.5 high ok no fable no xhigh".

**How to apply:** set model/effort on every Agent call this way. For a small fix, merge after the builder's own tests pass. Related: [[review-round-cap]], [[run-without-stopping]].
