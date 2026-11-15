# Role: blind AC auditor (**Opus 5.5, xhigh**): forms-wpforms
First read and follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (ignore its review.json part). Change no source or test, commit nothing, start no
agents. Load `engineering-best-practices`, `mutation-testing-discipline` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (how ACs are proven; your ac.json format).
About 2 hours (Justin's deadline Monday 09:00 on this computer). TMPDIR ~/.cache/fw-auditor/t1. Never import into or write to any WordPress
site; the WPForms file is only written locally and drawn with the stand-in.
You never saw the build. A verifier works on the same head at the same time: read nothing under `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/` but `plan-approved.md` and your own folder (no review, verifier, builder or fixer folder or report). Prove every AC yourself from the plan and the code, with your own cases (a WPForms form of your own with a title, a description, several field kinds, a shown separator line; Justin's B-Dry scan in the namespace).
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/plan-approved.md (AC1–AC18; AC17, AC18 live: `not_run`): a scanned site's WPForms form pastes as a WPForms form (a
  WPForms import file plus a Shortcode element), not a Bricks Form; the Figma plugin's "Forms become" option.
- Head **4348d16e6d8b6794bb2a19ed5a4c131b3b092653** (branch `forms-wpforms-fix1`), base **34e02b9062596891d33377e2eb829c1ffebee046**
  (importer-parity's head on main e2fc35aa; not merged yet). `git checkout --detach 4348d16e`.
- Known not this job's: site-upload-stop's "R1-1 the next run never takes another file of the same name" flakes under load (passes alone);
  standing story-pin reds panel-embed-unchanged, site-scroll-lock-base, site-media-unchanged; importer-app-notes.
- Each AC: a test or terminal-captured check on head and on the old code, plus one picture per AC (a drawing, or a terminal capture as .txt).
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/auditor/ac.json` (with `verdict` and `ac_status`) and its logs in `/home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/auditor/` (create it; it must be empty); self-check:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <your worktree> --base 34e02b9062596891d33377e2eb829c1ffebee046
  --plan /home/justin/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/plan-approved.md <copy 1 of your ac.json in its own folder> <copy 2 in a second folder>` (it refuses one file passed twice); quote its last line.
Report (as text): per AC accepted or not with the evidence path; gates; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
