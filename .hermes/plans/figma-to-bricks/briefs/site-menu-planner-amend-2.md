# Role: planner (a plan amendment, wording only): site-menu after fix passes 6 and 7; site-media-upload's Q3 A lines

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan's wording where fix passes 6 and 7 changed what
it states and reviews 8 and 9 found the head right; write the exact lines the merge finisher puts into the merged
site-media-upload job's HANDOFF section and the repo `CLAUDE.md`. Change no source or test, commit nothing, start no
agents. Never edit the main folder or any worktree (read code with `git -C /home/justin/Documents/FigmaToBricksV2
show <sha>:<path>`); never load any live site. Work under `~/.cache/site-menu-planner-amend2/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked `[amended A<n>]`, receipts encoding
an old expectation named with a sorter that really separates old heads from new, where the pre-amendment text lives,
`ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names
unchanged, no line that isn't an AC's definition starting with a list marker followed by `AC<n>`, each cited test
name whole on one line; a reviewer's suggested wording is set against the head's real behaviour before it is adopted).

## Inputs
- **The approved copy** (read-only, your base text; already amended once — keep its Amendments list and add after it):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md` (AC1–AC8, AC8 live).
- **Head** `058ec3ea04203d4793e862b1f882c7a1fdbb7695` (branch `site-menu-fix7`, on main
  `11e885fda5d08863a5875f939085350c007ac732`, Build 2026-11-10.8): `src/web/socket-gate.ts`, `src/web/press-guard.ts`,
  `src/web/capture.ts` (`launchCaptureChrome`), `src/web/read/opens.ts`, `src/web/read/tracker.ts` (the press source
  `f2b-capture-press.js`), `src/core/site/media.ts` (`madeInOpen`), `tools/lib/site-upload/pictures.ts`
  (`uploadList`), the capture spec (`CodeOpen.makers`), `test/unit/capture-chrome.test.ts`, and the ledger
  `docs/plans/2026-11-09-site-menu-ledger.md` ("Fix pass 6" and "Fix pass 7", each with a "For the planner" bullet
  holding drafted sentences).
- **Justin's answers** this round: `evidence/site-menu/review-7/justin.json` ("Block sockets (Recommended)" — R7-2;
  "Upload them too (Recommended)" — R7-1 / S13-1) and `evidence/site-menu/review-8/justin.json` ("Fix it
  (Recommended)" — R8-1).
- **Reviews:** `evidence/site-menu/review-8/review.json` and `review-9/review.json` (R8-2 … R8-4 and R9-1 … R9-6 are
  P3s, recorded in `evidence/site-menu/follow-ups.md`; review 9 measured F7-1's real rates). The site-media-upload
  plan as merged: `git show 11e885fd:docs/plans/2026-11-10-site-media-upload.md`, its HANDOFF section on main, and
  the repo `CLAUDE.md` decision bullet "A scanned page's pictures go to WordPress from the command line" (Q3 A:
  "every picture the site's own markup shows, each file once, script-made ones and `data:` left").

## What to write
1. `~/.hermes/plans/figma-to-bricks/site-menu-amended-2.md`: the whole plan, the Amendments list extended (A<next>…),
   each changed line tagged. Cover, checked against the head's code (not the ledger's words):
   - "What the capture may press, and the press guard": the **Sockets** paragraph (fix 6: one launch for every Chrome
     a capture starts, the SOCKS5 gate in the capture's own process applying the launch's resolver rules, shut from a
     page load's first press to its last: new sockets refused before their host hears of them, an open socket that
     sends cut before the bytes leave, what a host sends still comes in, each attempt named, one to another site in
     the "sent to another site" note; EventSource is a GET and passes as a read; WebTransport and WebRTC aren't held;
     a Chrome the capture didn't start has no gate and a socket opened during a press is named as not stopped) and
     **how a refusal is charged** (fix 7, R8-1: counted against a press only when that pressing page's own sessions
     reported it, paired by kind and host:port within 2 s in either order, a known address before none; an unclaimed
     refusal blames no press and is listed apart; a page with a child it couldn't watch is charged every unclaimed
     refusal, saying so); "the socket gate open again" in the undo list.
   - **Limits**, each one line with its id and the measured numbers, not estimates: F6-1 … F6-6 as still true; F7-1
     with review 9's rates (a page's own same-host heartbeat or reconnect inside its own presses costs those presses —
     15 s beat, 25 s beat, the Socket.IO-like reconnect, base the same; sockets to another site never cost a press);
     F7-2, F7-3; R9-1 (SharedWorker), R9-2 (IPv6 literal), R9-3 (a worker inside a window the press opened), R9-4
     (Chrome's per-renderer throttle beyond 2 s): refused, but blame no press; R8-2 (the fixed press-source name a
     page could borrow; what it can and can't reach); R8-3 (no test pins the helper route's launch); R8-4 (a Chrome
     without the gate names only sockets created during a press). Correct the head's own untrue words where review 9
     says so (HANDOFF:356 and `press-guard.ts:88` on IPv6) by naming them for the finisher's records — never edit code.
   - **The pop-up pictures:** the rule (`CodeOpen.makers`; a picture inside an opened box counts as another company's
     only when some script-made step on its path had another site's file on its stack, was made by code with no file,
     has a stack read only in part, or has no record; an older capture keeps everything in a box as another's; the
     capture's own press runs under a source name the tracker skips; an address never listed both as going up and as
     staying), and that a picture on another host that the site's own markup shows goes up when its file is held,
     inside a box as outside (Q3 A as merged).
   - The ACs' "Also (supporting, never the cited test)" lines gain the new test files (`socket-gate`,
     `press-guard-sockets`, `capture-opens-guards`' new cases by name, `site-made-in-open`, `site-opens-own-pictures`,
     `site-upload-opens`); the `capture-chrome` pin's change (it follows `launchCaptureChrome`) named; no AC added,
     removed or renumbered; every cited test name unchanged and whole on one line.
   - **The join with site-one-command** (unmerged, review-clean, being rechecked; it moves the launch into
     `tools/lib/capture-run.ts`, a new file, so git shows no conflict there): whichever job merges second must make
     `capture-run.ts` call `launchCaptureChrome({ path: chrome.path, args: chrome.args, visible })`, keep `tools/capture.ts`
     calling only `captureRun`, and make `test/unit/capture-chrome.test.ts`'s case pin `launchCaptureChrome` in
     `capture-run.ts` with site-one-command's `doesNotMatch(/launch\w*Chrome\(/)` for both commands; check after the
     join: `git grep -n -E 'launch(Capture)?Chrome\(' -- tools/capture.ts tools/site-import.ts` prints nothing. Read
     site-one-command's plan (`evidence/site-one-command/plan-approved.md`, "Overlaps with unmerged jobs") so the two
     plans say the same.
2. In the same file, a section **"For the merge finisher: site-media-upload's records"** with the exact replacement
   lines: HANDOFF's site-media-upload section (Q3 A: "… script-made ones and `data:` left, **except the site's own
   pictures inside a box the capture opened** (every script-made step made by the site's own files; Justin,
   2026-11-10, "Upload them too"); an address that goes up is never also listed as staying"), its AC5's supporting
   tests, and the repo `CLAUDE.md` decision bullet's matching words — checked against `uploadList` and `madeInOpen`
   on the head.

## Proofs
Run `ac-check.sh`'s `ac_start`, `bad_id` and `live` regexes on the old and new plan (ids, live set, cited names
unchanged); grep every cited test name in the head's tests; diff old and new plans and confirm every changed line
carries its tag. Evidence under `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/planner-amend-2/`.

## Report (as text)
The amendments one line each; the site-media-upload lines for the finisher; the join paragraph; the proofs' results;
then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
