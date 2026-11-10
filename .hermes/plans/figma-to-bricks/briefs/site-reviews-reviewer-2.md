# Role: reviewer (Mini, round 2: the fix commits only, report only): site-reviews

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
- Branch `site-reviews-fix1`, head `77bd97f5506cbb59c53bebffa58e0bc07dbbc1f5`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 77bd97f5…`, confirm HEAD and a
  clean status.
- **Scope (Mini round 2): only the fix commits since round 1's head and what they touch:**
  `git diff 91a43d2d9a94b1710ea540044f9baf93b2ba7e8c..HEAD` (`9bf50eed`, `812240f4`, `fef1bcae` R1-1; `8cf5362e`,
  `a2757575`, `33c31235` R1-2…R1-4; then docs), plus the code they call (`src/web/session.ts` `served()`,
  `src/web/replay.ts` `recordTo`, `src/web/served.ts`, `src/web/read/embeds.ts` `ownPlace`, `src/web/assemble.ts`,
  `src/core/site/live.ts`, `classes.ts` `ClassCss.inside`, `kinds.ts`, `test/web/lib/site-check.ts` `liveStandIn`,
  `tools/site-check.ts`).
- Round 1 (`evidence/site-reviews/review-1/review.json`) found R1-1 P1 (the widget was taken live only when a second
  fetch of the page succeeded; bdryswi.com refused it), R1-2 P2 (the executed code held tags from outside the slot: a
  tracking pixel could ride along), R1-3 P2 (a loader in a painted or shared box was never taken), R1-4 P2 (styles on
  boxes inside the slot were lost and `site:check` said 0 px). Fixer 1's rules: the served page is what the design
  width's own tab was answered (a second request only the fallback; a note when none); only `how: "slot"` embeds with
  the new `web.embeds[].slot` field are pasted to run, and only that markup; a loader in a painted or shared box is an
  embed at its own place (its tag as served, no class); the served boxes inside a slot keep their look through
  `ClassCss.inside` selectors and `site:check` compares them. It changed three assertions in existing tests
  (`capture-replay`: 2 page requests, not 3; `human-check` AC3: no separate download of the HTML). Receipts (read, don't
  trust): `evidence/site-reviews/fixer-1/`.
- Check hardest: **what can run on Justin's site** (is the pasted code only the slot's own served markup in every path;
  can `ownPlace` take a tag that isn't a widget — analytics, a consent tool, an ad — and paste it to run); the capture
  now hearing every document answer (does it change what is captured, slow it, or break the human check or the
  lost-connection rule); older captures without `slot` still pasting the copy; the changed assertions honest. Keep probe
  scripts under `~/.cache/srv-r2/`, never the `/tmp` scratchpad (the PC loses power now and then).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scoped diff for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-r2/tmp`, its
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
