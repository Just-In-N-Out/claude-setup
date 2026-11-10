# Role: reviewer (round 7: the move onto the newest base and the join it needed; report only): site-menu

You are a fresh reviewer who never saw the build, the rebases or the fixes (**Opus 5.5, high**). Review only: change
no source or test, commit nothing, start no agents. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry
staging, a widget vendor's host or any live site (the capture and `site:live` run only against local fixture servers;
saved files otherwise); never write to any WordPress site; no logins; never run `npm run site:upload` against
anything (its tests start only their own 127.0.0.1 stand-in). Nothing may hide that the importer's Chrome is
automated.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guard is P0/P1 when it fails: while the capture presses a page's
buttons, no data-sending request (anything but GET/HEAD/OPTIONS) and no page load a press starts may leave** — in the
pressed tab, a window a press opens, a frame or a worker — and a press never submits a form or follows a real link.
**And the base's guards hold with this job on top:** a pasted Code element runs only a widget's own code
(panel-embed-code); only `npm run site:upload` writes to WordPress, and only media (site-media-upload).

## What happened before you
The job (the capture presses a page's menu / pop-up / drawer buttons under that guard, reads what opens, and the paste
carries it as Bricks' Offcanvas) was review-clean at `70985b6ae4745bb771e3fd5493b68813bda714fc` on an earlier main
(`7eeca437`; review 6: MOVE ON). Since then site-media-upload (Build 2026-11-10.5) and staging-fit-cancels (Build
2026-11-10.6) merged (`main` is `56a9379f`), and panel-embed-code sits review-clean on that main as
`f961b365ee7305b2a48e459051f8cf4e282bd382`, next to merge. A fixer stacked this job on `f961b365`:
- the rebase: 34 commits, 2 conflicted (`convert.ts` / `kinds.ts` / `parts.ts` against the media map; HANDOFF);
- **one rule addition at the join** (`98f0bcea`, `src/core/site/parts.ts`, test `test/unit/site-opens-media.test.ts`):
  with the plain resolution a part decided `sourceUrl` and its `pictures` list from its own elements only, not from
  its Offcanvases: a drawer's photo became a library picture while its part named no site (Bricks would swap it for
  the placeholder on paste), and `site:upload` would never upload a drawer's pictures. Now a part names the map's
  site when it or any of its boxes shows a map picture, and lists its boxes' pictures after its own; without a map
  nothing changes;
- a test only (`1012346f`, `test/unit/site-opens-no-revert.test.ts`): an opened box that drops declarations on phones
  prints bounded runs, no `revert`;
- docs (`efd50486`).
**Nobody has reviewed the rebase's resolutions or that join.**

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live).
- Branch `site-menu-stack13`, head `efd50486184b69c6f5b7556d73278c11ab162141` (the rebased head before the fixer's own
  commits: `ff417389d61be947d36407cce577ec936d8c5390`), base `f961b365ee7305b2a48e459051f8cf4e282bd382`
  (panel-embed-code's head, on `main` `56a9379f`). In your own worktree: `git checkout --detach
  efd50486184b69c6f5b7556d73278c11ab162141`, confirm HEAD and a clean status. Review `git diff f961b365...HEAD`; the
  reviewed pre-move story is `git diff 7eeca437...70985b6a`; the fixer's own work is `git diff ff417389..HEAD`.
- The move's record (read, don't trust): `evidence/site-menu/stack-13/` (`range-diff.txt`, `conflicts.md`,
  `resolutions/`, `pins.md`, `meet/README.md` and its probe runs, `ac-base/`, `logs/`, `bdry-dryrun/`). Deferred
  items: `evidence/site-menu/follow-ups.md` (review 6's R6-1 to R6-4; this move's S13-1: a picture that appears only
  inside an Elementor pop-up is listed as script-made, so `site:upload` leaves it; S13-2: the still copy of a
  pressed-open widget modal isn't counted in the "made by a script" note). Don't re-report what is recorded unless
  you rate it higher, with a scenario.
- **Known, not findings here:** the named-only B-Dry files fail on main by the footer's 69 px (job
  `footer-icon-list`); site-media-upload's env-gated story pin (`F2B_STORY_PINS=1`) is that job's receipt and moves by
  this job's reworded note and by staging-fit-cancels (four trees in `stack-13/pins.md`); Justin's 2026-11-09 capture
  is refused by `readCapture`.

## Check hardest
1. **Each hand resolution against both sides** (`resolutions/`): `convert.ts` (this job's `extra.ids` before
   `buildTree` and `pathOfId` / `pointer` after it, around the base's `buildTree(… media …)`), `kinds.ts` (the base's
   `KindContext` with `media?` and this job's `link(href, path?)`; `elementFor`: the live choice, the media choice
   and `ctx.link` in an order that keeps all three), `parts.ts` (`PartResult` with `live?`, `opens?`, `pictures?`).
   Your own `git range-diff 7eeca437..70985b6a f961b365..ff417389`: any commit whose own +/- lines changed beyond a
   both-sides line? `snapshot/web.ts` and the capture spec hold both jobs' fields, none renamed.
2. **The join (`98f0bcea`) — the one new rule.** With a hand-made media map on captures of your own shape (local
   fixtures): a drawer or pop-up holding the site's own `<img>`, a CSS background and a mask; a part that shows no
   picture itself but whose box does; a part with pictures of its own and a box with others; two boxes sharing one
   picture; a box whose picture the map doesn't name; a box holding another company's widget picture. For each:
   `sourceUrl` on exactly the parts that show a library picture (in the part or its boxes) and on no other (the
   base's rule: a part with none is byte for byte as without a map — Bricks' foreign-site check touches only Images
   with an id); each library picture once in the part's `pictures`, a box's after the part's own; what
   `site:upload`'s list would hold for it (run its list / dry-run code on your capture: **a dry run only; it sends
   nothing**; never an upload outside the tests' own 127.0.0.1 stand-in): each of the site's own pictures once,
   nothing of another company's; and without a map, both routes byte for byte the old head's (`70985b6a`) apart from
   the base's own changes. Does S13-1 (a pop-up-only picture read as script-made and left by the upload) need to be
   higher than a recorded follow-up for a real Elementor pop-up with the site's own photo in it? Say what Justin
   would see.
3. **The press guard with the three jobs under it.** `git diff 70985b6a ff417389 -- src/web/press-guard.ts` and its
   tests: nothing of this job's changed; `capture.ts`'s calls sit where they did; run `capture-opens-guards` and the
   unit `web-press-guard` yourself (alone, under the cap, low load). One probe of your own on a local page: a
   floating chat launcher (another origin), a reviews widget whose button has `aria-controls` and on click draws a
   fixed box, POSTs and beacons, beside a real menu button whose drawer holds a form, a real link and a
   `window.open`: 0 non-GET requests and no other page asked for at your servers; the widget's write named in the
   notes. **panel-embed-code's stack rule under the press step:** a box a press causes is never read as a floating
   widget whose code is pasted (the fixer says floating boxes are read before any press, and a press-made element's
   stack holds `about:inline-code`): prove it — convert your capture on both routes and list every Code element: only
   a self-drawing served widget file's own tags may be there, exactly as on the base without this job.
4. **Bounded runs in opened boxes** (staging-fit-cancels' standing rule: a website paste never cancels a declaration
   at a width range with `revert`): the site-menu fixtures' pastes and one page of your own (a drawer on phones that
   is a panel on desktops): no `revert` outside the site-reset class and that job's two named exceptions; the opened
   box draws the site's look at each range's edges ±1 px in Chrome with both Bricks samples.
5. **Nothing else moved:** captures of the merged jobs' fixtures on head equal the base's apart from timings; without
   a pop-up in the capture, pastes are byte for byte the base's apart from this job's reworded note; Figma designs
   byte for byte (`test/unit/plugin-convert.test.ts`); `npm run check` on head; three of the base's web files of your
   choice rerun alone under the cap (one of panel-embed-code's, `site-upload-page`, `site-range-cancels`).
6. The two new tests can fail (two mutants of your own under the 4 GB cap: the join's "any of its boxes" dropped; a
   box's pictures listed before the part's own or twice).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines: the last one is this
move's lesson) with `references/testing-pitfalls.md`, `references/live-site-reading.md` (the lines on a capture that
presses page controls; the embeds line) and `references/rendering-validation.md`, the repo `CLAUDE.md` in the main
folder (the Status lines of Builds 2026-11-10.5 and .6; the standing rules "One tool writes to WordPress", "A website
paste never cancels a declaration at a width range with `revert`", "Bricks swaps pasted pictures for its grey
placeholder unless the paste's `sourceUrl` is the site's own address") and `reference/bricks/README.md` ("Paste
rules"); read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-7/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   f961b365ee7305b2a48e459051f8cf4e282bd382 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
   your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r7/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: put multi-step git work in a script file
  and run `bash <file>`, with `git -C <absolute path>`). Scripts written with Write; probes and logs under
  `~/.cache/site-menu-review7/`. Any run of a tool that keeps a record uses a scratch `HOME`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Known flakes: `capture-opens-guards`' worker-capture comparison
  under load (rerun alone at low load), the code-page fixture's 5.09 px load flake, `capture-windows` AC7,
  `capture-entrances` R8-1. Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage
  limit twice: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review
saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a
one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons
now.`
