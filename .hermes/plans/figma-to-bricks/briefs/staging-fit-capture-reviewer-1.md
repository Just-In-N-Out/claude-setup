# Role: reviewer (Full round 1, report only): staging-fit-capture

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (`npm run capture -- <a real site>` on home wifi, with or without an "I am human" check, then `npm run site` / `site:check`;
the panel opening a capture; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/plan-approved.md`
  (AC1–AC6; AC6 live). The job: the capture never keeps a range read without the site's stylesheets (B-Dry's 768–991 was
  read styleless): it records each range's sheets, waits for pending ones (15 s), reads a range missing a sheet again
  alone (30 s, up to twice), then stops with one plain line; `unstyledRanges` flags old captures; `site`, `site:check`,
  `capture:check` and the panel refuse a flagged capture.
- Branch `staging-fit-capture-build`, head `5fa9eb82936855eafc41f1b84b8c54f8105bb84f`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 5fa9eb82…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/builder/`.
  Its deviations and rulings (HANDOFF, "not yet confirmed"): the pure compare in `src/core/site/styled-ranges.ts`; the
  fixture keyed by page load; thresholds (a range drops ≥ 40 % of its wider neighbour's declarations and a narrower range
  declares ≥ 80 % again); a missing sheet counts only if the server sent it in the reference and the range is the same
  kind of visitor; `<style>` elements recorded but never compared; a failed page exits 1 so `--all` carries on.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: a healthy real site's capture refused or stopped (a sheet that loads late, a
   print/deferred sheet, a sheet only phones get, a site whose CSS differs a lot between ranges by design, the human
   check), a styleless range still slipping through, captures much slower (the 15 s / 30 s waits), the panel or CLI
   refusing a good capture, Figma designs or clean captures no longer byte-identical, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfa-r/tmp`, its
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
