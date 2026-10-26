---
name: project-resume-brief
description: "Justin builds resume source-briefs (project-brief.md + PDF) per repo; conventions, ProjectPDF folder, and 3DSearch authorship facts"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6d64c557-d120-4903-85ee-03ec9e382c95
  modified: 2026-07-31T08:50:12.768Z
---

Justin maintains per-project resume source briefs. For 3DSearch (2026-07-31): `project-brief.md` at repo root (untracked, never commit) + `3DSearch.pdf`, copied to `~/Desktop/ProjectPDF/` alongside briefs for other projects (devsecops-pipeline, llm-vuln-scanner, minimalog). The project appears on his resume as a full Experience entry: Software Engineering Intern, LinkClicks.

Conventions he asked for: every number reproducible by a recorded command; bullet bank ~40 bullets tagged `[DOMAIN] [METRIC|QUAL]`; 4–5 alternate framings for his three headline areas (prompt-injection defense, Trivy pipeline, rate limiter); **zero mention of Claude/Anthropic/AI in the deliverables**.

Key authorship facts (3DSearch is a 5-person team repo, 589 commits, 2025-09 → 2026-06): Justin authored ~86 commits — MyMiniFactory scraper end-to-end, original ci.yml, `rate_limiters.py` (created), inbound DRF throttling, LLM description rewriter (sole author), SSR/SEO model pages, Workshop Warm redesign + compare/similar/create/draw. `container-scan.yml` (Trivy) commits are under John Rodriguez/Anthony Reed; **Justin says he co-built it and teammates pushed** — include it, with an interview-prep note rather than a contradiction flag.

**Why:** future brief updates or per-JD bullet selection should reuse these facts without re-deriving them.
**How to apply:** when tailoring bullets, pull from project-brief.md §9; keep the [[macos-toolchain-quirks]] workarounds in mind for PDF regeneration.
