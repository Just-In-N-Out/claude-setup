# Role: fixer (round 6: Justin's two answers after review 7 — the press guard blocks sockets; an Elementor pop-up's own pictures go up): site-menu

Review 7 ended MOVE ON with three P3s. Two of them were put to Justin as questions on 2026-11-10 (recorded in
`evidence/site-menu/review-7/justin.json`), and he chose:
1. **"Block sockets (Recommended)":** while the scan presses buttons, WebSocket connections are refused and named in
   the notes, as `site:live` already does (R7-2: a pressed button opened a socket and a 26-byte message reached the
   test server; chat widgets use sockets when their button is clicked).
2. **"Upload them too (Recommended)":** a picture the site itself put in an Elementor pop-up counts as the site's own:
   it is uploaded once and the paste points at the library; other companies' widget pictures still stay; the
   contradictory summary lines go (S13-1, R7-1: on B-Dry the menu pop-up shows the header's logo, so the dry run
   lists the logo as both "would go up" and "stays: another company's script drew it").

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Build both test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry
staging, a widget vendor's host** or any live site (the capture runs only against local fixture servers and the
offline B-Dry stand-in site); no logins. **`npm run site:upload` writes to WordPress: you never run it, or any upload,
against anything but the local WordPress stand-in the tests start on 127.0.0.1 (`test/fixtures/wp-standin.ts`); you
use no real login, password or key and never look for one.** Nothing paid. Nothing may hide that the importer's
Chrome is automated.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the lines on a capture that presses page controls; "Holding a Chrome to read-only":
it ends with this review's lesson on sockets; the embeds line), and the repo `CLAUDE.md` in the main folder ("Build
general logic": nothing keyed on Elementor's names where structure can say it, nothing keyed on B-Dry; the standing
rules "One tool writes to WordPress: `npm run site:upload`", "`npm run site:live` only reads a published page", "The
importer never hides that its Chrome is automated"; HANDOFF's site-media-upload section: Q3 A "every picture the
site's own markup shows, each file once, script-made ones and `data:` left").

## Your copy (you start in your own worktree)
`git checkout -B site-menu-fix6 efd50486184b69c6f5b7556d73278c11ab162141` (the reviewed head, branch
`site-menu-stack13`, stacked on panel-embed-code's `f961b365`). panel-embed-code is merging into `main` as you start
(`main` will be `f961b365` plus a build commit that touches only `src/shared/build.ts`, `docs/HANDOFF.md`, its plan
and ledger): **before your final gates**, `git rebase --onto <git rev-parse main> f961b365ee7305b2a48e459051f8cf4e282bd382`
(expect at most a context conflict in `docs/HANDOFF.md`: this job's section first, then main's lines exactly as main
has them; the `<site-menu id at merge>` placeholders stay), and report `main`'s SHA as your review base. Report your
branch.

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live).
- Review 7: `evidence/site-menu/review-7/review.json`; its probes and notes `~/.cache/site-menu-review7/`
  (`notes.md`, `join-probe.ts`, `probe/`: the socket probe with a local upgrade handler). The last move's record:
  `evidence/site-menu/stack-13/` (`bdry-dryrun/head1/header.json`: B-Dry's menu pop-up showing the header's logo).
  Deferred items: `evidence/site-menu/follow-ups.md`.

## 1. The press guard blocks sockets (R7-2)
- Verify it first on the reviewer's probe (a drawer button that opens a WebSocket to a local upgrade handler: the
  handshake and a frame arrive).
- Fix as a rule: **from a page load's first press to its last, no WebSocket (and no other socket-like channel the
  page can open: `WebSocket`, `EventSource` to a host other than a plain GET the design allows — say what you decide
  for EventSource and WebTransport, and why) connects from the pressed tab, a window a press opens, a frame or a
  worker**; the attempt is named in the notes like the other stopped writes (a write to another site listed apart, as
  the amended plan says); everything is undone when the guard stops, so a socket the page opens before the first
  press or after the last is untouched and the capture reads the page as before. The reviewer's idea:
  `Network.setBlockedURLs` for `ws://*` and `wss://*` on the pressed page and the windows it opens, plus
  `Network.webSocketCreated` to name the attempt; check it holds for a socket opened in a cross-site frame, a
  service worker and a dedicated worker (the guard's known limits list a dedicated worker already running: say
  whether sockets there are covered), and a socket **already open** before the press that sends a frame because of
  the press (blocking new connections doesn't stop it: close or pause it for the guard's span if you can prove a way
  that is undone after, else record it plainly as a limit with what Justin would see).
- Test first (RED on `efd50486`), in the guard's own test file (`test/web/capture-opens-guards.test.ts`) on its
  fixture: a drawer button that opens a socket and sends a message; one in a cross-site frame; one in a window a
  press opens: the local upgrade handler sees no handshake and no frame, each attempt is named in the notes, the
  drawer is still read, and the capture's other pages and ranges read as before. Unit: `web-press-guard`.
- The guard's cost: time the capture of the site-menu fixture and the offline B-Dry dry run before and after (the
  same five boxes, 0 non-GET requests, no other page asked for, **0 socket handshakes**).

## 2. An Elementor pop-up's own pictures go up (S13-1, R7-1)
- Where the rule lives: `tools/lib/site-upload/pictures.ts` (the upload list: own / stays, with reasons) and whatever
  the conversion's media map reads (`src/core/site/media.ts`, `parts.ts`'s join from the last move). Today everything
  inside a pop-up counts as script-made (the pop-up's root is drawn by the page builder's script: a `~` path), so a
  pop-up's picture is listed "another company's script drew it".
- Fix as a general rule, by structure, not by a builder's name: **a picture inside a box the press step opened (this
  job's `opens`) that the site's own markup or the site's own script put there is the site's own**: it is in the
  upload list once (with the same file shown elsewhere on the page: once in all), mapped to the library in the
  Offcanvas's paste, with the old site's alt by the upload's alt rule (the first alt with words in page order: a
  part's own use before its boxes', as the join lists them). **Another company's picture inside an opened box still
  stays** (a widget's stars or avatars drawn by that company's script from its own host; a picture on another
  company's host): decide the test that tells the two apart from what the capture records (which file made the
  element — the tracker's `made` and the stack this job's base now records —, the host that file and the picture are
  served from, whether the box's markup was served in the page), prove it on: the site-menu fixtures' pop-up and
  drawer; a pop-up holding the site's logo, a photo only the pop-up shows, a CSS background and a mask; a drawer
  holding another company's widget with its own pictures; a pop-up whose picture is on another host though the site's
  markup names it (it "stays", as the same picture would outside a pop-up: say what the upload's rule does for it
  today and keep that). No picture is ever listed on both lists: a file that goes up is never printed as staying.
- Test first (RED on `efd50486`): unit tests beside `test/unit/site-upload-pictures.test.ts` and
  `test/unit/site-opens-media.test.ts` (the list; the paste's Images and CSS `url()`s inside the Offcanvas; `sourceUrl`
  on the part); the CLI's dry run and a real run **against the test stand-in only** (`test/unit/site-upload-cli.test.ts`'s
  pattern): the summary's lines for a pop-up's pictures; each file POSTed once. Review 7's test gap R7-3 with it: the
  box's pictures listed after the part's own (the alt rule depends on it) and never twice: assertions that kill both
  mutants.
- **The upload tool's guards are untouched** (the password in no file, output or process; requests only to the typed
  origin; only GETs and `POST wp/v2/media`; the typed `yes`, the login check and the terminal check; a dry run sends
  and writes nothing): re-run their tests and say so. site-media-upload's AC5 sentence ("the upload list holds each
  own picture once and names every picture it leaves, with the reason") must still be true: read it in
  `docs/plans/2026-11-10-site-media-upload.md` and record in the ledger the exact words a planner must amend there
  and in HANDOFF's site-media-upload section (Q3 A now reads: script-made ones left, **except the site's own pictures
  inside a box the capture opened**), marked as Justin's answer of 2026-11-10.

## Work
1. Each fix test-first, one commit each; mutate what you add (each new condition removed in turn is killed by a named
   assertion, never a crash; a mutant that lets a socket through or uploads another company's picture must die)
   under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`;
   a mutant that removes a refusal runs with networking off: `unshare -rn`).
2. Records batched into your commits: HANDOFF's site-menu section (the guard now covers sockets; what stays a limit;
   an opened box's own pictures go up) and the ledger (`docs/plans/2026-11-09-site-menu-ledger.md`, "Fix pass 6": for
   the planner, the plan lines to amend in this job's plan — the guard's rule gains sockets; known limits — and in
   site-media-upload's); append what you defer to `evidence/site-menu/follow-ups.md` (R7-3 is yours above).
3. Gates on your final head (after the rebase onto `main`): both typechecks (`tsconfig.sandbox.json` too), `npm run
   check`; the guard's files (`capture-opens-guards`, the unit `web-press-guard`, `capture-opens`,
   `capture-opens-styled`, `site-opens-more`, `site-opens-proof`, `site-check-opens`, `capture-matched-once`), the
   upload's files (`site-upload-pictures`, `site-upload-cli`, `site-upload-stop`, `site-upload-sent`,
   `site-media-convert`, `site-opens-media`, `test/web/site-upload-page.test.ts`), each web file alone under the cap,
   one Chrome job at a time; `test/unit/plugin-convert.test.ts`; without a map and without a pop-up in the capture
   every paste byte for byte your base's; the offline B-Dry dry run of the press step (8G scope) and a **dry run** of
   the upload list on B-Dry's stand-in capture (it sends nothing; a scratch `HOME`): the logo is listed once, as
   going up, and say what else changed in the list against `efd50486`. Every log starts `HEAD=` and ends with one
   line `EXIT=`. `gitleaks` (or a grep for token-shaped values) over your evidence folder. Commit after each passing
   step (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached
   --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/fixer-6/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smn-f6/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a worktree's
`node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: put multi-step git work in a script file and run `bash <file>`,
with `git -C <absolute path>`). Scripts written with Write under `~/.cache/site-menu-fixer6/`; one `bash <file>` per
Bash call. Every run of the upload tool uses a scratch `HOME`, never the real `~/.config/figma-to-bricks/`. SIGTERM /
143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits
under 115 s; wait for background drivers in the foreground with a bounded loop script. The PC lost power twice this
week and agents were stopped by a usage limit twice: write each log's `EXIT=` line (wait on `^EXIT=`); when resumed,
check `git status` (a rebase may be in progress: carry it on) and `git cat-file -t HEAD`, read your finished logs
first and never start a second driver on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, your review base (`main`'s SHA), last commit (full SHA); sockets: verified?, the
rule (what is blocked, where, what is named, what stays a limit), tests, RED/GREEN paths, the guard's cost; pop-up
pictures: the test that tells the site's own from another company's, tests, RED/GREEN paths, B-Dry's dry-run list
before and after; the upload tool's guards re-proven; the mutation table; gates; the plan lines for the planner (both
plans); `found_else`; a line confirming no upload ran against anything but the 127.0.0.1 stand-in and no real login
was used; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills
or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
