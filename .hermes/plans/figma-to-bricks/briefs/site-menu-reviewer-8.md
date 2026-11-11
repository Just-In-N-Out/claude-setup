# Role: reviewer (round 8, a delta: fix pass 6 and the move onto the newest main; report only): site-menu

You are a fresh reviewer who never saw the build, the rebases or the fixes (**Opus 5.5, high**). Review only: change
no source or test, commit nothing, start no agents. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry
staging, a widget vendor's host or any live site (the capture runs only against local fixture servers; saved files
otherwise); never write to any WordPress site; no logins; never run `npm run site:upload` against anything but the
tests' own 127.0.0.1 stand-in. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guard is P0/P1 when it fails: while the capture presses a page's
buttons, no data-sending request (anything but GET/HEAD/OPTIONS), no page load a press starts, and — since this fix —
no WebSocket handshake or message may leave** — from the pressed tab, a window a press opens, a frame or a worker.
**And main's guards hold with this job on top:** a pasted Code element runs only a widget's own code; only `npm run
site:upload` writes to WordPress, only media, only after its questions. From round 3 on, the referee asks Justin when
a round leaves only P2 findings: rate each finding exactly (a P2 needs its real-use scenario; a hole only a deliberate
evasion hits, or a setup none of his machines has, is P3).

## What happened before you
The job (the capture presses a page's menu / pop-up / drawer buttons under that guard, reads what opens, and the paste
carries it as Bricks' Offcanvas) was reviewed at `efd50486184b69c6f5b7556d73278c11ab162141` (review 7: MOVE ON with
two questions for Justin). His answers (`evidence/site-menu/review-7/justin.json`): **"Block sockets"** (R7-2: a
WebSocket handshake and a 26-byte message passed the press guard) and **"Upload them too"** (R7-1 / S13-1: an
Elementor pop-up's own pictures were listed as another company's and left by the upload tool). A fixer then:
- moved the branch twice (onto `7ec16d60`, then onto main `11e885fda5d08863a5875f939085350c007ac732`, Build
  2026-11-10.8): **conflicts in `src/core/site/convert.ts`** (this job's `pointer(t)` beside main's `decls` from
  `inlineOwners`, control-weight's new code) and in HANDOFF; nobody has reviewed those resolutions;
- **sockets:** every Chrome a capture starts now goes through one launch (`launchCaptureChrome`, `src/web/capture.ts`)
  that sends WebSockets through a new **socket gate** (`src/web/socket-gate.ts`: a SOCKS5 end inside the capture's
  own process, passing connections on as Chrome would and applying the launch's `--host-resolver-rules`); the press
  guard (`src/web/press-guard.ts`) shuts the gate from a page load's first press to its last: new sockets refused,
  an open socket that sends is cut, each attempt named; the gate opens again when the guard stops. The fixer says
  `Network.setBlockedURLs` and `emulateNetworkConditionsByRule` stop no socket on Chrome 156 (its probes:
  `~/.cache/site-menu-fixer6/probe-*.log`). Decided by the fixer: EventSource passes as a read; WebTransport and
  WebRTC are not held (recorded as a limit); pages read side by side are held too while one presses; an open socket
  is cut even when it only answers a ping;
- **pop-up pictures:** the capture records, for each script-made element of an opened box, the script files on its
  stack (`CodeOpen.makers`); a picture in an opened box counts as another company's only when some script-made step
  on its path had another site's file on its stack, was made by code with no file, has a stack read only in part, or
  has no record (`madeInOpen`, `src/core/site/media.ts`); `uploadList` (`tools/lib/site-upload/pictures.ts`, the only
  upload-tool file changed) never lists an address as both going up and staying; the capture's own press now runs
  under the name `f2b-capture-press.js` (`Session.run`'s new `source` argument) and the tracker skips that frame;
- changed an existing test outside the plan: `test/unit/capture-chrome.test.ts`'s wiring pin now follows `npm run
  capture`'s launch through `launchCaptureChrome` (commit `7094a7d4`).

## Inputs
- Approved plan (read-only; amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`
  (AC1–AC8; AC8 live). The plan's words for sockets and for the pop-up pictures are not amended yet: judge the fix
  against Justin's two answers and say which plan sentences must change.
- Branch `site-menu-fix6`, head `86fc55467cb4b7892eed8f50f14fa50bf3ec042e` (last code commit `bef1b0d8`), base `main`
  `11e885fda5d08863a5875f939085350c007ac732`. In your own worktree: `git checkout --detach
  86fc55467cb4b7892eed8f50f14fa50bf3ec042e`, confirm HEAD and a clean status. **Your scope:** the fix pass (the nine
  commits titled "site-menu fixer 6": `git log --oneline 11e885fd..HEAD`; the commit before them, titled "site-menu
  stack 13: the move onto panel-embed-code…", is review 7's head as rebased) and what it touches, plus the two moves'
  resolutions (`git range-diff f961b365..efd50486 11e885fd..<that rebased stack-13 commit>`; the story is 46 commits,
  `git diff 11e885fd...HEAD`).
- The fixer's record (read, don't trust): `evidence/site-menu/fixer-6/` (`red-base.log`, the mutant tables, `cost/`,
  the B-Dry dry runs, `net-off-check.log`), the ledger's "Fix pass 6", `evidence/site-menu/follow-ups.md` (F6-1 to
  F6-6 and everything earlier: don't re-report what is recorded unless you rate it higher, with a scenario).
- **Known, not findings here:** the named-only B-Dry files fail on main by the footer's 69 px (job
  `footer-icon-list`); merged jobs' env-gated story pins (`F2B_STORY_PINS=1`) are those jobs' receipts; one recorded
  flake (F6-5: `capture-opens-guards` "…it answers every request", R4-5's boxes-equal comparison under load: rerun
  alone before judging).

## Check hardest
1. **The socket gate is a new network component in every capture: is it right, and is it harmless when nothing is
   pressed?** (a) With the gate open, does anything a normal scan does change: http and https requests go direct (not
   through the gate: prove it by the gate's own connection count on a fixture with no sockets), a site's WebSocket
   (wss to another host, to an IPv6 literal, to a host the resolver rules map away) connects and carries data both
   ways as without the gate; DNS: the gate resolves names itself — what does a site see differently (the client
   address, the order, a `Proxy-*` header? anything a server could read as a disguise or as a different visitor)?
   **Nothing may hide the automation and nothing may make the scan look like another client.** (b) Shut: your own
   page that, on a pressed button, opens a socket from the page, from a running dedicated worker, from a new worker,
   from another site's frame, from a window the press opens, and sends on a socket opened at load: 0 handshakes and 0
   message bytes at your server; each attempt named in the capture's notes; a socket to another site named under
   "sent to another site". (c) The gate's own safety: it listens on 127.0.0.1 only, on a port no other local process
   can use to reach the internet through it in a way that matters (what does a second local client get?), closes with
   the capture on every exit path (Ctrl+C, a crash, SIGTERM: no listener and no Chrome left), and a capture that
   fails to start the gate fails closed (no scan without it? or a scan that names sockets as not stopped: which, and
   is that right?). (d) The offline stand-in: with `MAP * ~NOTFOUND` the gate reaches no outside host (mutants G5, G6:
   rerun one). (e) Cost: a scan of a fixture site and of the offline B-Dry stand-in, base against head at the same
   load, twice each: a slow-down a person would notice is a finding.
2. **The launch change reaches every route:** `npm run capture`, the helper (`capture:serve`, the Figma panel's
   route), the capture's own launch in tests, `site:check` / `site:live` (unchanged? they must not gain the gate or
   lose their own read-only launch); a Chrome the capture didn't start has no gate and a socket there is named as not
   stopped. The changed pin in `test/unit/capture-chrome.test.ts`: does it still prove what it proved (capture
   launches the Chrome `findChrome` finds, with the helper's arguments, and prints the helper's line when none is
   found)? Note for the main session: another unmerged job (site-one-command) moves the same launch line into
   `tools/lib/capture-run.ts` and is held on this same test: say exactly what this branch's version of the test and of
   `tools/capture.ts`'s launch lines are, so the two can be joined.
3. **The pop-up pictures rule (`madeInOpen`) is a line between the site's own and another company's.** On captures of
   your own (local fixtures; a pop-up built by the site's own script, by the site's script through a CDN library, by
   a tag manager, by another company's widget script; a picture on the site's host and on another host): which are
   listed to go up, which stay, and why; a look-alike host (`bdryswi.com.evil.example`, a subdomain, `www.`, a port);
   an older capture (no `makers`): everything in a box stays, as before. **The upload tool's guards are untouched**
   (`git diff 11e885fd...HEAD -- tools/site-upload.ts tools/lib/site-upload/` shows only `pictures.ts`; its guard,
   prompt, scrub, stop and record tests pass). Run the upload list and a dry run on your capture (**a dry run only**;
   a real run only through the tests' own 127.0.0.1 stand-in): each of the site's own pictures once, nothing of
   another company's, no address in both lists. The fixer kept "a picture on another host that the site's own markup
   shows goes up when the capture holds its file" (site-media-upload's Q3 A outside a box, now the same inside): is
   that what the merged rule does outside a box (prove it on main), and what would Justin see?
4. **The tracker's press-source skip** (`f2b-capture-press.js`): can a page name its own script that and hide from the
   widget-code rule (a pasted Code element runs only a widget's own code; a floating widget's code is pasted only
   when the served file drew it by itself)? Probe: a page script with `//# sourceURL=f2b-capture-press.js` that draws
   a floating box or a pop-up's content: what `own`, `ownWhy` and `makers` does the capture record, and what do both
   routes paste to run? A way for a tracker or tag manager to be pasted through this is P0/P1.
5. **The moves:** your own range-diff as above; the `convert.ts` resolution keeps both jobs' behaviour (control-weight's
   AC tests pass on head: `test/unit/site-inline-own*.test.ts`, `test/web/site-inline-nested.test.ts`,
   `site-range-cancels`; this job's Offcanvas pointers as on `efd50486`: convert three opens fixtures with the old
   head's tree and this one and compare by element id); HANDOFF holds every section whole.
6. **Gates:** both typechecks and `npm run check` on head (8G scope for the parallel unit suite); `capture-opens-guards`
   (alone, low load, twice), `capture-opens`, `socket-gate`, `web-press-guard`, `site-opens-own-pictures`,
   `site-made-in-open`, `site-upload-opens`, `site-upload-page`, the tracker's readers (`tracker-stack`,
   `capture-floating`, `floating-holds`, `panel-floating-chain`, `capture-embeds`, `panel-embed-code`), each web file
   alone under the cap; `F2B_UNCHANGED_SUMS=1` sums; `test/unit/site-no-revert.test.ts`. Two mutants of your own under
   the 4 GB cap, with networking off for any that lets a socket through (`unshare -rn sh -c 'ip link set lo up && exec
   unshare --user --map-user=1000 --map-group=1000 node --test …'`): the gate never shut for an already-open socket's
   send; `madeInOpen` trusting a stack read only in part.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Holding a Chrome to read-only"; the embeds line). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/review-8/review.json` (round 8, a delta from review 7's
head `efd50486`; `head` the full SHA of your HEAD), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base 11e885fda5d08863a5875f939085350c007ac732
/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu` (exit 2 means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sm-r8/t1`, a
separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`, never a Chrome you didn't start); a worktree's
`node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`.
Scripts written with Write under `~/.cache/site-menu-review8/`. Heavy runs under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0` (B-Dry and the parallel unit suite 8G; export variables first, no `--setenv=PATH`).
SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). Waits
under 115 s. The PC restarted three times this week: keep notes and finished probe results on disk; when resumed,
read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the socket gate's table (what a site sees
with the gate open; what your server got with it shut; each exit path); the pictures table (shape → goes up / stays);
the press-source probe; the moves; the plan sentences that must be amended (this job's and site-media-upload's);
`verdict`; `ac_status` (per AC: what the review saw); then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
