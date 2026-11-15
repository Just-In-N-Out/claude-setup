# Role: blind AC auditor (**Opus 5.5, xhigh**): site-headline-marker
First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (ignore its review.json part). Change no source or test, commit nothing, start no
agents. Load `engineering-best-practices`, `mutation-testing-discipline` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (how ACs are proven; your ac.json format).
About 2 hours (Justin's deadline Monday 09:00 on this computer). TMPDIR ~/.cache/shm-auditor/t1. Mask and thin-stroke pictures: also at device
pixel ratios 2 and 1.5 (`Emulation.setDeviceMetricsOverride`), since `test/browser/chrome.ts` pins 1.
You never saw the build. A verifier works on the same head at the same time: read nothing under `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/` but `plan-approved.md` and your own folder (no review, verifier, builder or fixer folder or report). Prove every AC yourself from the plan and the code, with your own cases (an Animated Headline page of your own: highlight styles circle, underline, a loop, a rotating style; Justin's B-Dry scan in the namespace).
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/plan-approved.md (AC1–AC14; AC14 live: `not_run`): with --elementor, an Elementor Animated Headline in highlight
  style pastes as one Bricks Heading, the marked words in a span, a marker class drawing the shape by a CSS mask, Bricks' Interaction playing
  it, colour `--f2b-mark-color` linked to the palette; anything it can't handle pastes as before with one note.
- Head **e37e4c06239e382454a68f594ef9593c7da7f032** (branch `site-headline-marker-fix1`), base **34e02b9062596891d33377e2eb829c1ffebee046**
  (importer-parity's head on main e2fc35aa; not merged yet). `git checkout --detach e37e4c06`.
- Known not this job's: site-elementor-page-bdry (34 vs 38 widths), site-motion-bdry's Elementor hover-look test, site-live flake, standing
  story-pin reds panel-embed-unchanged, site-scroll-lock-base, site-media-unchanged; importer-app-notes.
- Each AC: a test or terminal-captured check on head and on the old code, plus one picture per AC (a drawing, or a terminal capture as .txt).
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/auditor/ac.json` (with `verdict` and `ac_status`) and its logs in `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/auditor/` (create it; it must be empty); self-check:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <your worktree> --base 34e02b9062596891d33377e2eb829c1ffebee046
  --plan /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/plan-approved.md <copy 1 of your ac.json in its own folder> <copy 2 in a second folder>` (it refuses one file passed twice); quote its last line.
Report (as text): per AC accepted or not with the evidence path; gates; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
