# Role: reviewer (round 4: fix round 3 and the rebase onto the stack; report only): staging-fit-renderer

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local stand-in servers and saved files
only); never write to any WordPress site; no logins. Nothing may hide that the tool's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run site:live -- <a published Bricks page> …` run by Justin or an agent on his
WordPress staging site; `npm run site:check` with `--whole`, `--bricks`, live widgets; the browser tests' renderer;
Figma designs converting as before), each with a concrete real-use scenario. Edge cases are P3. **Justin's rule "Never
write to any WordPress site; GET/read only" is this job's guard: anything but GET/HEAD/OPTIONS reaching the published
site in normal use of `site:live` is P0/P1.**

## What happened since review 3 (clean at `b6bccface956c47689d5f687d280a6707c489cd8`, on the old main `fd1986dc`)
1. **Fix round 3** (six commits, never reviewed): Ctrl+\ (SIGQUIT) handled like the other signals (exit 131); the
   signal handlers registered before `launchChrome`, which has a new optional `started` handing out the launch's kill
   as soon as there is a process (before the guard holds, Chrome is ended by that exit kill alone; the old
   `browser.kill()` branch of `end()` is gone); the guarded Chrome launched with
   `--disable-features=Reporting,NetworkErrorLogging,DocumentReporting` joined into one switch
   (`tools/lib/read-only.ts` `readOnlyArgs`); new tests `test/web/site-live-reports.test.ts` (a local https page, a
   control run with the switch taken off) and `test/unit/read-only-switches.test.ts`, two more cases in
   `test/web/site-live-closing.test.ts`. Receipts (read, don't trust): `evidence/staging-fit-renderer/fixer-3/`.
2. **The rebase onto a stack** (`main 3cfc54ac ← site-faq ← site-reviews ← site-slider`): branch
   `staging-fit-renderer-stack1`, head `898e0ebd71533244fe87fdc0eaf2c3c537a3ce3f` (the last commit is the ledger; code
   head `9ab92ecc`), base `7d9754ed8adb5308bd525b309e7ba4672e284104`. The finisher's conflicts (receipts:
   `evidence/staging-fit-renderer/stack-1/` — `range-diff.txt`, `changed-commits.txt`, `changed-lines.txt`,
   `conflicts.txt`, `composition.txt`, `logs/`):
   - `test/web/lib/site-check.ts`: `Locator` is now `{ path } | { id } | { css } | { tag }` (site-reviews' served box
     beside this job's `data-f2b` mark); `find()` keeps the stack's `css` branch and site-slider's "the real slide,
     never a Splide copy" rule.
   - `tools/site-check.ts`: staging-fit-capture's `unstyledLine` refusal and site-reviews' live widgets (stand-ins at
     each width, served boxes inside their slots), now on this job's `PartTally`; with `--whole`, live widgets are
     handled per part of the drawn page (each part its own stand-ins and `inside`, the stand-in CSS for all parts in
     the one page); `--bricks` imports beside the live-widget ones.
   - `tools/lib/site-measure.ts` (new in this job): edited to carry the stack's behaviour — `measure()` takes a fifth
     argument `inside` (default none), reads those items and adds their paths to the capture's boxes; `site:live`
     passes none.
   - `docs/HANDOFF.md`: this job's section and end-of-run entry first, then the stack's as it has them.
   - The finisher's `found_else`: `tools/site-live.ts` does not apply staging-fit-capture's refusal of a capture holding
     a width range read without the site's styles (`unstyledLine` is used by site, site:check, capture:check and the
     panel, not by site:live); `site:live` does not measure a live widget's served boxes (it never reads `siteParts`'
     `live`).

## Scope
- In your own worktree: `git checkout --detach 898e0ebd71533244fe87fdc0eaf2c3c537a3ce3f`, confirm HEAD and a clean status.
- **Fix round 3:** the six commits as they are on the rebased branch (`8c5f66b9..9ab92ecc`; old `b6bccfac..04392a14`).
  Check hardest: every way a `site:live` run can end still lets nothing but GET/HEAD/OPTIONS reach a stand-in server
  (OK, no paste, login, an error mid-run, Ctrl+C at 0, 1 and 3 s, Ctrl+\, SIGTERM, SIGHUP, output cut by `| head`,
  a stop while Chrome is still starting), read at least 3 s after the tool's process is gone, with no Chrome of the
  tool left; the "exit kill alone before the guard holds" simplification (is there a window where a page is open and
  the guard is not yet answering?); the Reporting switch really reaching Chrome when the launch already has a
  `--disable-features`; `chrome.ts` additive for every other caller (the new `started`, `killNow` moved); the new
  tests able to fail (try one or two mutants of your own under the 4 GB cap).
- **The rebase:** `git range-diff fd1986dc..04392a14 7d9754ed..898e0ebd`; every hunk of the three code files the
  finisher changed by hand, on the head: `site:check` on a capture with a live widget (the stand-in and the served
  boxes inside its slot) per part and with `--whole`; the capture refusal still exits 2 with its line in `site` and
  `site:check`; `find()` for a looping slider's real slide, a served box by `css` and this job's `tag`; `measure()`'s
  `inside` default leaving `site:live` unchanged. Run on the head: `test/web/site-check-live-widget.test.ts`,
  `site-widget-places`, `site-check-settle`, `site-elementor-swiper8`, `site-cli`, this job's `site-live.test.ts`,
  `site-live-closing.test.ts`, `site-live-reports.test.ts` (slow: about 90 s), the `--whole` / `--bricks` tests, both
  typechecks (4 GB cap, one Chrome job at a time).
- **Rate the finisher's two `found_else` by the importer rule and say what Justin would see:** `site:live` run on a
  capture that `site` and `site:check` refuse (a styleless range); `site:live` on a page with a live widget. If either
  makes AC5's live run (Justin's re-captured page on staging) wrong or misleading, it is P2 with the smallest fix named.
- HANDOFF: the docs-only resolution rebuilt as `review-loop.md` "After MOVE ON" says (nothing of the five jobs lost).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the line "Holding a Chrome to read-only"), the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`. Approved plan (read-only, amended
1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-4/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
7d9754ed8adb5308bd525b309e7ba4672e284104 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer` (exit
2 means your file is wrong: fix it; if the script objects to the base, say so and report its output).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-r4/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time; check with `ps` by your profile path that none is left after each probe, and never signal a
  process group other agents' Chromes are in. A worktree's `node_modules` may lack `.bin` and a scratch tree has no
  `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes and
  logs under `~/.cache/sfr-r4/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
