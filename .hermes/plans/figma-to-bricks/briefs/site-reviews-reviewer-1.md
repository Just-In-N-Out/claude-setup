# Role: reviewer (Mini, round 1, the one full review, report only): site-reviews

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (`npm run capture` on a real site with another company's widget (reviews, booking, chat), then `npm run site` pasted
into Bricks 2.3.9 or 2.4.2 with code signatures regenerated; `site:check`; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`
  (AC1–AC9; AC9 live). The job: a third-party widget whose loader replaces its own `<script>` tag (Trustindex's hosted
  reviews) is captured as one embed (`how: "slot"`, the slot's served markup byte for byte), and the code route pastes
  it as one live Bricks Code element at the slot (Execute code on, the captured copy left out, a `live` list, notes);
  `site:check` stands in at the captured size per width and compares nothing inside; older captures paste the copy as
  before with a "capture again" note; Figma designs and other pastes byte-identical. Q1–Q6 A taken.
- Branch `site-reviews-build2`, head `91a43d2d9a94b1710ea540044f9baf93b2ba7e8c`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 91a43d2d…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/builder/`
  (the second builder's in `cont/`). Their deviations (ledger, HANDOFF): AC7's goldens live outside the repo; a result's
  `live` list exists only with a live widget; `runsScript` in `src/core/site/live.ts` repeats `map/snippets.ts`'s reading
  (Figma's sandbox can't import `src/web`); at 390 Trustindex draws no arrows, so AC8 swipes; mutant C6 (the
  `pasteHidden` filter) is equivalent. Never load bdryswi.com; the only outside host any test may reach is
  `cdn.trustindex.io` in the named-only AC8.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: a real site's widget pasted wrong or twice (the copy and the live one), a
   script of the site's own or an analytics/ads script wrongly pasted as a live widget (pasted code runs on Justin's
   site: what exactly can end up in a Code element with Execute code on, and is it only the slot's served markup?),
   a widget that needs its host page's id or domain, the capture missing or mis-attributing a slot, `site:check` hiding
   a real difference around the slot, an older capture changing bytes, Figma designs no longer byte-identical, tests
   that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-r/tmp`, its
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
