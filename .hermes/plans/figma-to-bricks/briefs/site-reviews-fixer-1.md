# Role: fixer (round 1: R1-1 P1, R1-2, R1-3, R1-4 P2): site-reviews

You are a fresh fixer for FigmaToBricksV2 (**Fable 5.2, high**). Fix review 1's four findings test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push
or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com** or any live site
(tests use 127.0.0.1 fixtures; the named-only AC8 may reach `cdn.trustindex.io` only); no logins; never write to any
WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify each finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, `security-best-practices` (R1-2 decides what
code runs on Justin's site). Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-reviews-fix1 91a43d2d9a94b1710ea540044f9baf93b2ba7e8c` (branch `site-reviews-build2`, on local
`main` `fd1986dcdbc8cf35f114b80be456e94279346743`); confirm HEAD and a clean status (after a restart, restore tracked
files of exactly 8388608 bytes). Check `git rev-parse main` is still `fd1986dc` (if it moved, say so; don't rebase).

## Inputs
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md`.
- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-1/review.json` (R1-1 P1; R1-2…R1-4 P2;
  R1-5…R1-8 P3). Its probes and logs: `/home/justin/.cache/srv-r/probes/`, `/home/justin/.cache/srv-r/logs/`,
  fixture sites in `/home/justin/.cache/srv-r/sites/` (read only; they may be gone after a restart).
- Justin's real capture (read only): `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` — its map embed reads
  `how: "live"` and its reCAPTCHA extra's snippet is null: the served page was empty on the real site.

## Work
1. **R1-1 (P1; `src/web/read/embeds.ts:155`, `src/web/capture.ts:193`, `383-390`):** the widget is taken live only when
   a second, separate fetch of the page HTML (`servedHtml`) succeeds; on bdryswi.com that fetch was refused, so the real
   capture would paste the dead copy again. General rule: the served page comes from what the capture's own tab was
   answered (the design-width tab's document response; the separate fetch at most a fallback), and when no served page
   could be read the capture says so in a note (never silently). Test: the `live-widget` fixture captured with a fetcher
   that answers the page's `text/html` request with 403, and with a 200 check page: still one embed `how: "slot"`.
2. **R1-2 (P2; `src/core/site/live.ts:39`, `src/web/map/snippets.ts:64`):** the executed Code element holds more than the
   slot's served markup: `scriptsFor` adds tags from elsewhere in the old page (inline scripts naming the host; for
   `how: host`/`frame` every script of that host), so a Facebook box would bring the old site's Meta Pixel onto Justin's
   new page. General rule: **only the slot's own served markup is ever pasted to run** (the creating tag and what is
   served inside the slot); no tag from outside the slot, and an embed whose `how` isn't `slot` keeps today's
   behaviour (the copy / web-embeds' own route), never a live Code element built from collected scripts. Test with a
   tracking snippet of the same host in `<head>` and an inline settings script elsewhere: the pasted code equals the
   slot's served markup byte for byte.
3. **R1-3 (P2; `src/web/read/embeds.ts:77`):** a loader whose parent is painted (padding, background, border) or shared
   with other shown content is never taken: the slot climb stops at the widget's own script-made element, which has no
   served counterpart. General rule (the plan's variation): the slot is the nearest served element that holds only the
   loader's output; when the parent is painted or shared, the slot is the loader's own place (the script tag and what it
   made), pasted as one Code element at that place, the parent kept as it is. Test the review's `nowrap` cases (the
   loader beside an h2 and a p; alone in a padded box).
4. **R1-4 (P2; `src/core/site/convert.ts:120`, `tools/site-check.ts:139`):** styles on boxes inside the slot (between the
   slot and the loader tag, e.g. Elementor's `.elementor-widget-container { max-width; margin }`) are lost because only
   the slot's own class is carried, and `site:check` says 0 px because its stand-in forces the capture's height. General
   rule: every served box of the slot that the capture read keeps its look in the paste (its classes carried as the
   route carries any element's, or the Code element placed at the innermost box that holds only the widget), and
   `site:check` compares those boxes; only what the script made is stood in. Test the review's `inner` case: the paste
   holds the values and `site:check` fails when they are dropped.
   Each: RED on `91a43d2d`, then GREEN; mutate each guard under the cap.
5. Put R1-5…R1-8 in HANDOFF's site-reviews "Deferred" list (they are in `evidence/site-reviews/follow-ups.md`); correct
   HANDOFF's claims to what is now true.
6. Gates before stopping: both typechecks, `npm run check`, AC1–AC7's tests, AC7/AC8 named (the stand-in and goldens in
   `evidence/site-reviews/builder/`; 8G scope; network only to `cdn.trustindex.io`), the five replays byte-identical to
   main, `test:web` and `test:browser` file by file under the 4 GB cap compared by name with the builder's
   `evidence/site-reviews/builder/cont/gates/` (a `git archive` scratch copy with `dist/` built; rerun only differing
   files on main).
7. Commit after each passing step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines,
   `git diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/fixer-1/` (logs `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-f/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome: close every Chrome you start. One `bash <file>` per Bash call (scripts written with Write); start long drivers
  with `setsid --fork` and wait on their final marker.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill (`journalctl --user`); heavy and mutation runs under `systemd-run --user
  --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry 8G). Waits under 115 s.

## Report (as text)
`status: ready-for-review`, branch, base, last commit (full SHA), per finding: verified?, the rule, fix, tests, RED/GREEN
paths, mutation; gates; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
