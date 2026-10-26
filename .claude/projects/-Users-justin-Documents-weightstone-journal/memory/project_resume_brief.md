---
name: resume-project-brief
description: project-brief.md + minimalog.pdf at repo root document MinimaLog with verified metrics for resume tailoring
metadata: 
  node_type: memory
  type: project
  originSessionId: ca757a5a-ddc0-4401-b8df-359fc4b8c470
  modified: 2026-07-31T08:36:29.848Z
---

On 2026-07-31 I generated `project-brief.md` and `minimalog.pdf` (repo root, deliberately untracked) documenting MinimaLog for resume tailoring. All metrics are command-verified (22 tables/100% RLS, 104 policies, 80 migrations, 53 tests, 6 edge functions, 11 IndexedDB stores). Section 11 lists claims to AVOID (stale README counts, unmeasured perf %, no CI security scanners, client-only workout limit). Regenerate the PDF via: `npx marked --gfm` → wrap in print CSS → headless Chrome `--print-to-pdf` (pandoc unavailable; Homebrew is broken on this machine by an untrusted `mongodb/brew` tap — every `brew install` fails until Justin runs `brew trust mongodb/brew` or untaps it). Constraint: [[no-ai-mentions-in-deliverables]].
