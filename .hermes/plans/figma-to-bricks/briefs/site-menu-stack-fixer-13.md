# Role: fixer (the move onto the newest base, and what the move needs): site-menu

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). site-menu (the capture presses a page's menu / pop-up /
drawer buttons under a guard that lets no data-sending request and no page load leave while it presses, reads what
opens, and the paste carries it as Bricks' Offcanvas) is review-clean (review 6: MOVE ON) on an **earlier** main:
branch `site-menu-fix5`, head `70985b6ae4745bb771e3fd5493b68813bda714fc` (34 commits), base
`7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4). Since then two jobs merged and a third is in its final
checks just ahead of this one in the queue:
- `main` is `56a9379faf207c2bfa76211dff1365db7d74be37` (Build 2026-11-10.6): site-media-upload (Build 2026-11-10.5:
  `npm run site:upload`; a media map turns a page's own pictures into library pictures in Image settings and CSS
  `url()` values: `src/core/site/media.ts`, hooks in `kinds.ts`, `convert.ts`, `parts.ts`) and staging-fit-cancels
  (Build 2026-11-10.6: bounded media runs replace `revert` in `src/core/site/{blocks,classes,controls}.ts`).
- **panel-embed-code**, review-clean on that main and next to merge: branch `panel-embed-code-stack11`, head
  `f961b365ee7305b2a48e459051f8cf4e282bd382` (a pasted Code element runs only a widget's own code; the capture's
  tracker reads the whole stack at a floating box's creation: `src/web/read/{tracker,floating}.ts`,
  `src/core/snapshot/web.ts`, `docs/specs/web-capture.md`).
**Stack this job on panel-embed-code's head** (so it needs no second move when that job merges), do what the move
needs test-first, run the gates, stop at `ready-for-review`.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging, a widget vendor's
host or any live site (the capture and `site:live` run only against local fixture servers); no logins; never write to
any WordPress site; never run `npm run site:upload` against anything. Nothing paid. Nothing may hide that the
importer's Chrome is automated. **Change nothing of the job's rule or of the press guard** beyond what a conflict
forces: this round is the move, stale pins and records.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`git-commit-rules`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the stacking lines: moved code, goldens both ways, the four trees and the leaf-by-leaf
diff with notes compared by content, story pins are receipts, "run each AC's test on the new main too") with
`references/testing-pitfalls.md` and `references/live-site-reading.md` (the lines on a capture that presses page
controls; "Holding a Chrome to read-only"; the embeds line), and the repo `CLAUDE.md` in the main folder (the Status
lines of Builds 2026-11-10.5 and .6; the standing rules "One tool writes to WordPress", "A website paste never cancels
a declaration at a width range with `revert`", "The importer never hides that its Chrome is automated"). Read
HANDOFF's sections of site-media-upload, staging-fit-cancels and (on `f961b365`) panel-embed-code before resolving
anything in the shared files: you must know what each side means.

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live). Deferred items: `evidence/site-menu/follow-ups.md` (review 6's R6-1 to R6-4 among them). The
  last move's record: `evidence/site-menu/stack-6/`, `fixer-5/`.
- Files this job shares with the new base (`git diff --name-only 7eeca437 f961b365`): `docs/HANDOFF.md`,
  `docs/specs/web-capture.md`, `src/core/site/convert.ts`, `src/core/site/kinds.ts`, `src/core/site/parts.ts`,
  `src/core/snapshot/web.ts`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-stack13 70985b6ae4745bb771e3fd5493b68813bda714fc`, then `git rebase --onto
f961b365ee7305b2a48e459051f8cf4e282bd382 7eeca437ea100c821bcfb82cdbbe516a023ff097`. Check first: `git merge-base
--is-ancestor f961b365 main` (if panel-embed-code has merged, rebase onto `main` instead and say so) and `git rev-parse
main`. Your review base is the commit you stacked on. Report your branch.

## Work
1. **The rebase.** Keep both sides' meaning, commit by commit; typecheck at each conflicted commit before `git rebase
   --continue`; save each hand resolution's combined diff before `git add`.
   - `convert.ts` / `kinds.ts` / `parts.ts`: site-media-upload's media map (`media`, `toLibrary`, `sourceUrl` set only
     on a part that shows a library picture, the notes for pictures left on their address) with this job's openers
     (`opening`, `plays`, `extra.ids`, `pointer`, `ctx.link(href, path)`, `PartResult.opens`) and, already there from
     the last move, site-reviews' live widgets.
   - `snapshot/web.ts` and `docs/specs/web-capture.md`: panel-embed-code's fields (`own`, `ownWhy`, `unread`, the
     stack facts) and this job's (`CodeOpen` with `through` and `motion`, what a press opened); both in the capture's
     format, neither renamed.
   - HANDOFF: every section stays, this job's first, then the base's lines exactly as the base has them; this job's
     `<site-menu id at merge>` / `<at merge>` placeholders stay.
   - **The press guard's code and tests come through with every changed line unchanged**; if a conflict touches
     `src/web/press-guard.ts`, `capture.ts`'s calls into it or `test/browser/chrome.ts`, resolve so both sides run and
     re-run the guard's tests at that commit before continuing.
   Save `git range-diff 7eeca437..70985b6a f961b365..<new head before your own commits>`.
2. **Stale pins (default suite).** Run `npm run check` on the rebased head. Expect: this job's own regenerated
   entries in `test/fixtures/site-slider-base/` (fixer 5) against staging-fit-cancels' regenerated
   `site.elementor-stretch` sums; `test/fixtures/site-no-revert-main.json` (staging-fit-cancels' golden of main's
   hand-made pastes: this job rewords a note on purpose — does the golden hold notes, or classes only?);
   panel-embed-code's `F2B_UNCHANGED_SUMS` sums; site-motion-base and the others. For each pin that fails: prove by
   the trees (old base `7eeca437`, old head `70985b6a`, new base `f961b365`, new head; the same saved inputs; leaf by
   leaf with element arrays keyed by id and notes compared by content where both sides changed one paste) that the
   entry moves only by this job's design or only by a merged job's, then regenerate it (through the test's own
   generator on your head where it pins "nothing else changes" for a job under you; `node
   tools/site-no-revert-golden.ts .` on your own tree for that golden, as its header says), and say which entries
   moved and why. A merged job's env-gated story pin (`F2B_STORY_PINS=1`) is that job's receipt: record the table and
   move on, never regenerate. A pin that moves for any other reason is a finding: report it.
3. **Where the sides meet** (local fixtures only; draw in Chrome where it matters; say what you probed and saw):
   - **media map × opened boxes:** a capture whose drawer or pop-up holds the site's own pictures (an `<img>`, a CSS
     background), converted with a hand-made media map: the pictures inside the Offcanvas become library pictures
     like any other, `sourceUrl` is set on that part, and without a map the paste is byte for byte this job's old
     head's apart from the base's own changes.
   - **bounded runs × opened boxes:** an opened box whose look differs by width range (a drawer on phones, a panel on
     desktops): its classes print as bounded runs with no `revert` (`test/unit/site-no-revert.test.ts` on the
     site-menu fixture's pastes).
   - **panel-embed-code × the press step:** a page with a floating chat launcher and a third-party widget button
     beside a real menu button: is the launcher or the widget's button taken for an opener and pressed (review 6's
     R6-2 said a widget's button with `aria-controls` can be: unchanged?), and when a press makes a script draw a new
     fixed box (a chat window opening), what does panel-embed-code's stack rule record for it (`own`, `ownWhy`) — the
     press itself runs inside the capture's injected code: **does "code with no file on the stack" now mark every
     box a press causes as started by another script, or the capture's own press frames as the page's code?** Say
     exactly what a pressed-open widget becomes in the paste on both routes (nothing but a widget's own code may ever
     be pasted to run; an empty box or a listing is the safe side). The guard still holds on that page: 0 non-GET
     requests and no other page asked for at your server.
   - the capture's format and `capture:check` with all three jobs' fields; a capture made by the old head read by the
     new converter.
   If something fails and the cure is new logic in either job's rule, **don't write it**: report the failing run, the
   smallest repro and your reading of the cause.
4. **Each AC's test on the new base too** (`git archive` of `f961b365` with the test laid over): each AC's RED is
   still a RED there for the plan's reason; say what differs.
5. **Gates** (on a `git archive` scratch copy of your head; put
   `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
   a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar;
   never chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`; each log starts `HEAD=` and
   ends with one line `EXIT=`): both typechecks (`tsconfig.sandbox.json` too) and `npm run check` (the parallel unit
   suite may need an 8G scope): 0 failures; this job's AC tests and the guard's files (`capture-opens-guards`, the
   unit `web-press-guard`, `capture-opens`, `capture-opens-styled`, `site-opens-more`, `site-opens-proof`,
   `site-check-opens`, `capture-matched-once`, `details-open`), panel-embed-code's web files (`panel-floating-chain`,
   `floating-holds`, `tracker-stack`, `capture-floating`, `capture-embeds`, `panel-embed-code`), site-media-upload's
   (`site-upload-page`; its unit files), staging-fit-cancels' (`site-range-cancels`, `site-no-revert`, `site-runs`),
   the slider / FAQ / live-widget files the last move ran, each web/browser file alone under `systemd-run --user
   --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first, no `--setenv=PATH`), one Chrome job at a time,
   compared by name with the base (five browser files fail on main on this desktop: composition-clipping, fonts,
   hero-pair, peer-sides, pill-holder; the named-only B-Dry files fail on main by the footer's 69 px, another job's;
   known flakes: `capture-opens-guards`' worker-capture comparison under load, the code-page fixture's 5.09 px load
   flake, `capture-windows` AC7, `capture-entrances` R8-1: rerun a flake alone at low load before calling it a
   failure); `test/unit/plugin-convert.test.ts`; the five Figma replays byte-identical to the base; `npm run corpus`
   the same as the base; the offline B-Dry dry run of the press step (8G scope): the same five boxes, 0 non-GET
   requests, no other page asked for.
6. Records batched into your commits: the ledger (`docs/plans/2026-11-09-site-menu-ledger.md`, "stack 13": the rebase,
   each conflict and resolution, the pins with their proofs, the meet probes, the gates) and HANDOFF where a line
   needs it; append what you defer to `evidence/site-menu/follow-ups.md`. Commits: plain `git commit -m` (or `-F
   <file>`), no author override, no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md; `git
   ls-files .superpowers/` stays empty. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/stack-13/` (`range-diff.txt`, `conflicts.md`,
   `resolutions/`, `pins.md`, `meet/`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-s13/t1`,
a separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`;
close every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`). Scripts written
with Write under `~/.cache/site-menu-stack13/` (a restart empties `/tmp`); one `bash <file>` per Bash call; long gates
on a scratch copy, never in the worktree while you edit it. SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`): say so, find what grew, rerun under the cap.
Waits under 115 s; wait for background drivers in the foreground with a bounded loop script. The PC lost power twice
this week and agents were stopped by a usage limit twice: write each log's `EXIT=` line (wait on `^EXIT=`); when
resumed, check `git status` (a rebase may be in progress: carry it on, never start it again) and `git cat-file -t
HEAD`, read your finished logs first and never start a second driver on a suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, the commit you stacked on (your review base), the head before your own commits
and the last commit (full SHAs); the rebase (conflicts and resolutions); the guard's tests at each conflicted commit
and on the new head; each pin: what moved, which job moved it, the proof; where the sides meet: what you probed and
saw (above all what a pressed-open widget becomes); each AC's RED on the new base; each gate against the base;
anything you stopped on; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty
is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
