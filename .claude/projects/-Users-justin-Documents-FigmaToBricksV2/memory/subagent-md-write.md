---
name: subagent-md-write
description: Background subagents' Write tool refuses .md files (even in evidence folders); briefs ask for evidence summaries as .txt/.json or a ledger section
metadata:
  type: feedback
---

A background subagent's Write tool refuses a `.md` file anywhere, evidence folders included ("Subagents should return findings as text"; site-shared-styles rebase fixer, 2026-11-14: `evidence/site-shared-styles/rebase/draw/summary.md` refused).

**Why:** a brief asking for `summary.md`, `conflicts.md` or `follow-ups.md` from an agent gets a refusal and a workaround.

**How to apply:** in briefs ask agents for evidence summaries as `.txt` or `.json`, or as a ledger section; `.md` records (follow-ups, conflicts) the main session writes itself, or the agent puts in the repo (HANDOFF, ledger). Related: [[run-without-stopping]].
