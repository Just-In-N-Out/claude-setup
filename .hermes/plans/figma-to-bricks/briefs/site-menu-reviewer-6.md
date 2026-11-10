# Role: reviewer (round 6: the move onto main and the regenerated goldens; report only): site-menu

You are a fresh reviewer who never saw the build, the rebase or the fixes (**Opus 5.5, high**). Review only: change no
source or test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or
other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (the capture and
`site:live` run only against local fixture servers; saved files otherwise); never write to any WordPress site; no
logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run capture` on a real site; its capture converted with `npm run site`, plain or
`--elementor`, and pasted into Bricks 2.3.9 / 2.4; `site:check` and `site:live` on such a paste; Figma designs
converting as before), each with a concrete real-use scenario. Edge cases are P3. **This job's guard is P0/P1 when it
fails: while the capture presses a page's buttons, no data-sending request (anything but GET/HEAD/OPTIONS) and no page
load a press starts may leave** — in the pressed tab, a window a press opens, a frame or a worker — and a press never
submits a form or follows a real link. A P0–P2 with no concrete real-use scenario counts as P3.

## What happened before you
The job (the capture presses a page's menu / pop-up / drawer buttons under that guard, reads what opens, and the paste
carries it as Bricks' Offcanvas) was reviewed clean five times on an old main (`3cfc54ac`; last reviewed head
`4dd1a275`). Four importer jobs then merged (`main` is `7eeca437ea100c821bcfb82cdbbe516a023ff097`, Build 2026-11-10.4:
site-faq, site-reviews, site-slider, staging-fit-renderer). A finisher rebased the job onto it (31 commits, 3
conflicted: `reference/bricks/frontend-2.3.9/SHA256SUMS`; `convert.ts` / `kinds.ts` / `parts.ts`;
`test/browser/render.ts` and HANDOFF), and a fixer then regenerated 16 entries of a merged job's goldens that this job
moves by design (a reworded header note). **Nobody has reviewed the rebase's resolutions or that regeneration.**

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live).
- Branch `site-menu-fix5`, head `70985b6ae4745bb771e3fd5493b68813bda714fc` (the fixtures commit is `459b1b78`; the
  rebased code head is `21b0dc975a84a3761e902824de8840e5603dce8c`), base `main`
  `7eeca437ea100c821bcfb82cdbbe516a023ff097`. In your own worktree: `git checkout --detach
  70985b6ae4745bb771e3fd5493b68813bda714fc`, confirm HEAD and a clean status. Review `git diff 7eeca437...HEAD`; the
  reviewed pre-rebase story is `git diff 3cfc54ac...4dd1a275`; the fixer's work is `git diff 803c2384..HEAD`.
- The rebase record: `evidence/site-menu/stack-6/` (`conflicts.md`, `resolutions/` — each hand resolution's combined
  diff —, `range-diff.txt`, `four-trees.md`, `meet/`, `logs/`, `bdry-dryrun/`). The fixer's receipts (read, don't
  trust): `evidence/site-menu/fixer-5/` (`proof/`, `named/`, `gates/`). Deferred items:
  `evidence/site-menu/follow-ups.md` (don't re-report what is recorded unless you rate it higher, with a scenario).
- **Known, not findings here:** the named-only `site-elementor-page-bdry` fails on main (the footer's 69 px, job
  `footer-icon-list`); site-reviews' AC7 goldens and site-motion's `F2B_SITE_MOTION_OLD` goldens kept outside the repo
  are stale on main already and move further by this job's reworded note (four-tree proofs in `fixer-5/proof/`);
  Justin's 2026-11-09 capture is refused by `readCapture` (an unstyled 768–991 range).

## Check hardest
1. **Each hand resolution against both sides** (`resolutions/`): in `convert.ts` `prepare`, this job's `opening` /
   `plays`, `extra.ids` and `pointer` around site-reviews' `liveAt` and `buildTree(… live: liveAt)`; the script-made
   count `extra.open ? 0 : <main's scriptMade && !live.has count>`; `kinds.ts` `KindContext` (main's `live?`, this
   job's `link(href, path?)`) and `elementFor` (main's live choice first, then `ctx.link(href, path)`); `parts.ts`
   `PartResult` (`live?` and `opens?`); `render.ts` (`bricksSlider` and `bricksOffcanvas` both run, in the order nav,
   accordion, offcanvas, interactions, splide, with their ready flags; main's `sliderLayerCss`); SHA256SUMS. Did a
   merged job's behaviour or this job's get dropped, doubled or reordered? Your own `git range-diff 3cfc54ac..4dd1a275
   7eeca437..21b0dc97`: any commit whose own +/- lines changed beyond a both-sides line?
2. **The press guard came through whole:** `git diff 4dd1a275 21b0dc97 -- src/web/press-guard.ts` and its tests equal
   what `git diff 3cfc54ac 7eeca437` holds for those paths (nothing); `capture.ts`'s calls into the guard sit where
   they did relative to main's new code (staging-fit-capture's styleless-range **re-read**: when a range is read again,
   is the press step run again under the guard, from its first press to its last, and is the guard always let go —
   also when the re-read throws or the capture stops with its one plain line?); site-reviews' served-page fetch
   (`servedHtml`): is it a GET made outside the guard's span or inside it, and could the guard fail it or could it be
   mistaken for a press's page load? `test/browser/chrome.ts` on head: both sides' launch code; one
   `--disable-features` switch at most. Run `capture-opens-guards` and the unit `web-press-guard` yourself (alone,
   under the cap, low load), and one probe of your own on a local page whose opened drawer holds a form, a real link
   and a `window.open`: 0 non-GET requests and no other page asked for at your server.
3. **Where the jobs meet in the capture and the paste** (local fixtures; draw in Chrome where it matters): a page with
   a pop-up or drawer **and** a carousel, a FAQ and a live widget: is a slider's arrow, an accordion's question or a
   widget's button ever taken for an opener and pressed (what would a press on a third-party widget's button send?);
   an opened box that itself holds a carousel, a FAQ or a live widget: are they pasted as Slider (Nestable), Accordion
   and live Code element inside the Offcanvas, do they work there (Bricks' layered CSS for each: the restoring class
   this job adds for the Offcanvas against site-slider's `sliderLayerCss` and the site reset), and do `site:check
   --all`, `--whole` and `site:live`'s drawing measure them (`inClosed`)? The opener's link through `ctx.link(href,
   path)` when the element is also a live widget's slot.
4. **The regenerated goldens are honest:** re-derive the claim on two of the 16 entries yourself (four `git archive`
   trees: `3cfc54ac`, `4dd1a275`, `7eeca437`, head): they move only by the reworded header note (`UNOPENED_NOTE`), the
   other entries and the saved captures are byte for byte unchanged, and the new bytes equal the old with the note
   replaced. Is the reworded note true and useful to Justin on a capture made before this job ("a menu or pop-up button
   opens nothing: capture again with this build so the capture reads what it opens")?
5. **Nothing else moved:** captures of the merged jobs' fixtures (elementor-faq, elementor-carousels,
   elementor-slider, live-widget) on head equal main's apart from timings (no opener listed on them); without a
   pop-up in the capture, pastes are byte for byte main's apart from that note; Figma designs byte for byte
   (`test/unit/plugin-convert.test.ts`; the five replays in the finisher's receipts); `npm run check` on head; three
   of the merged jobs' web/browser files of your choice rerun, each alone under the cap.
6. Capture time: the finisher's B-Dry offline numbers (622 s on head, 655 s on main under different loads) say nothing
   either way; time `npm run capture` on a heavy local fixture site on main and on head, twice each at the same load:
   a slow-down a person would notice beyond the plan's stated cost of the guard is a finding.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4", the stacking lines) with
`references/testing-pitfalls.md`, `references/live-site-reading.md` (the lines on a capture that presses page controls
and "Holding a Chrome to read-only") and `references/rendering-validation.md`, the repo `CLAUDE.md` in the main folder
(Status lines of the four merged jobs; "Architecture rules"; "The importer never hides that its Chrome is automated")
and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-6/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7eeca437ea100c821bcfb82cdbbe516a023ff097 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means
   your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-r6/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a redirect of `git show` outside the worktree is refused: use `git archive -o <scratch>/<name>.tar
  <sha>` in its own command). Scripts written with Write; probes and logs under `~/.cache/smn-r6/` (a restart empties
  `/tmp`).
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
