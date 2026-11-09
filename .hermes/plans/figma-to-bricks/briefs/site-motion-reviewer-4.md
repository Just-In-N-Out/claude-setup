# Role: reviewer (round 4: the rebase's conflict resolutions + fix commits, report only): site-motion

You are a fresh reviewer who never saw the build (Opus 5.5, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins. Nothing may
hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture -- <a real site>` then `npm run site` with or without `--elementor`, its
animations, hovers, focus looks and entrances in Bricks 2.3.9; captures as fast and as correct as capture-speed made them;
Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/plan-approved.md`
  (Amendments first; AC4, AC15). capture-speed's in-repo plan now has Amendment 1 on AC8 (Justin: "Count per look, speed
  later (Recommended)", `evidence/site-motion/fixer-3/justin-ac8.json`).
- Branch `site-motion-fix4`, head `325d1f8b9b045de9b7e50944c4aac640cdc7202c`, on local `main`
  `99ff06f46a53fe9f43cfa456e1d42a685bbc36c7` (Build 2026-11-08.2, capture-speed merged). In your own worktree:
  `git checkout --detach 325d1f8b…`, confirm `git rev-parse HEAD` and a clean status.
- **Scope:**
  1. The rebase of site-motion's reviewed head `85a1f2fe` (on `7ff9ba4a`) onto `99ff06f4`; its tip is `f39a2fa7`.
     `git range-diff 7ff9ba4a..85a1f2fe 99ff06f4..f39a2fa7` shows what changed in the rebase. Fixer 3 resolved conflicts
     in `src/web/capture.ts` and `docs/HANDOFF.md`, and repaired a clean-merging but broken `src/web/read/code.ts`
     (capture-speed's `askAll` slimmed answers dropped `cssKeyframesRules`, `style.range`, `selectorList.text`; fix:
     `askPlan({ animated: true })`, matched.ts `ownParts` keeps keyframes, the slimmed rules keep range and selector).
     Check every field site-motion's version 3 capture reads still arrives, and capture-speed's speed and correctness
     (AC1 equality except site-motion's own fields, AC8 asks) hold.
  2. The fix commits `git diff f39a2fa7..HEAD`: `a412b543` (auditor F1: an element that plays an entrance keeps a box —
     a `p` that plays one becomes Rich Text with `site-text`; a drawing plays from load with a note), `96caed56`,
     `2d9259c4` (records), `325d1f8b` (capture-speed AC8 counts per page state; test-only + plan + HANDOFF).
- The fixers' receipts (read, don't trust): `evidence/site-motion/fixer-3/`, `fixer-4/`; the auditor's F1 probes
  `evidence/site-motion/auditor/probe-flat-*.log`.
- Check: the F1 fix plays entrances on both routes without moving still frames (a `p` gaining a box changes margins? the
  Elementor text widget fold), the drawing rule, the rebase repair not slowing captures or losing a look, the AC8 change
  honest (not a test made unable to fail), Figma designs untouched.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion/review-4/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   99ff06f46a53fe9f43cfa456e1d42a685bbc36c7 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-motion` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-r4/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
