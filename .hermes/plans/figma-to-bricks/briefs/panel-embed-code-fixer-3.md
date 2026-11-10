# Role: fixer (round 3, narrow: review 3's R3-1, plus three small P3 steps): panel-embed-code

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 3's one P1 test-first, plus the small steps
named below, then stop at `ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`,
never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase (`main` is at `7eeca437`; a later step
moves the job), leave other worktrees alone, start no agents. **Never load bdryswi.com, B-Dry staging, a widget
vendor's host** or any live site (local fixture servers and saved files only); no logins; never write to any WordPress
site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**This job's guard:** a pasted Code element runs only a widget's own code. A tracking tag, a tag manager, a loader, a
shared library, another widget's script or a page script in a paste is P0/P1. Where the capture can't prove what a
widget's own code is, nothing is pasted to run. **Justin's rule (chosen in a question, 2026-11-10,
`evidence/panel-embed-code/review-2/justin.json`): paste a floating widget's code only when the exact file that drew
it is a tag the old page served [and it drew the box by itself]; anything started by a starter script, a tag manager
or the page's own script is listed with a plain note (add its install code by hand).** Keep this round small: the rule
stays as fix round 2 built it; you close one hole in how "by itself" is read.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds line, which ends with this review's lesson), and the repo `CLAUDE.md`
("Build general logic"; "Code Figma runs uses only the language's built-ins").

## Your copy (you start in your own worktree)
`git checkout -B panel-embed-code-fix3 6b115d3fc55cf483025bf2a909c40194d0bced44` (the reviewed head, branch
`panel-embed-code-fix2`, on `f708dfb6`), confirm `git rev-parse HEAD` and a clean status. Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`.
- Review 3: `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-3/review.json`; its probes
  `~/.cache/pec-r3/scripts/` (`probe3.ts`: shapes T1, T2, T3, V1, V2, H1–H6; `stacks.ts`: TM_INLINE, TM_EVAL, TM_FN;
  `cost.ts`) and results `~/.cache/pec-r3/out/` (read only; copy what you need). Fix round 2's receipts:
  `evidence/panel-embed-code/fixer-2/`. Deferred items: `evidence/panel-embed-code/follow-ups.md`.

## The finding
**R3-1 (P1, `src/web/read/tracker.ts:28`; present on `4d6c6403` too, left open by fix 2):** a served tag manager is
pasted as a widget's own code when the box is drawn by code the tag manager runs for a rule: custom HTML's injected
inline `<script>`, `eval` or `new Function`. Chrome prints that code on the stack as `<anonymous>:L:C` or `eval at …
(tm.js)`; the stack read skips both, so only the tag manager's file is left and rule (b) "drew it by itself" passes.
The reviewer's probe (T1: an injected inline script; T3: `new Function` on window load): head pastes the tag
manager's served tag on the panel route, and drawing the paste on a fresh page sent the tracker's hits. Real use: a
site that serves its tag manager as a plain tag (Adobe Launch's standard embed, Tealium's `utag.js`, `gtm.js?id=` as a
src tag) with a rule whose custom code draws a fixed chat, call or promo button: every page of the new site would run
the tag manager and all its tags.
- **Fix as a rule: code with no file is another script.** When the stack at a box's creation holds a frame of code
  that belongs to no served file — an injected inline script, `eval`, `new Function`, a `javascript:` URL, a `blob:` or
  `data:` script, a timer given a string — the drawing file was not alone: the box is listed (`started`, or `page`
  when the site's own code is there too, as fix 2 decides). The reviewer's idea: in `files()`, count a frame at
  `<anonymous>:<line>:<col>` (and an `eval at …` frame) as another script (for example a marker such as
  `about:inline-code`); **native frames print `(<anonymous>)` with no line and must not count** (`Array.forEach`,
  `Promise.then`, `JSON.parse` revivers…: prove a self-drawing widget that draws inside `[].forEach`, a promise and a
  `setTimeout` callback still pastes). A vendor file that compiles its own templates with `eval` / `new Function` and
  draws from them is then listed too: the safe side; say so in HANDOFF's known limits.
- **Probe the stack rule the way the capture runs it:** the tracker injected by
  `Page.addScriptToEvaluateOnNewDocument` (as `capture` does), never as an inline `<script>` on the test page, which
  puts the page's own address on every stack and hides the shape.
- Test first (RED on `6b115d3f`), on the job's fixture site (`embeds-chained`; generic, no vendor's name): a served
  tag manager whose rule draws a fixed box (a) from an injected inline `<script>`, (b) from `eval`, (c) from `new
  Function` on window load, (d) from a string timer; each: `own` null, listed with the `started` note, nothing pasted
  on either route, and the tag manager and its tracker asked 0 times when the pasted footer is drawn on a fresh page
  and clicked. And the positive controls that must still paste: a served file drawing its launcher by itself at load,
  inside `forEach`, in a promise, in its own timer callback, from its own `DOMContentLoaded` handler, served twice.

## Small, each a few lines with a test, else leave recorded
- **R3-4 (`src/core/normalise/floating.ts:146`; do this one):** a capture carrying an `ownWhy` this build doesn't know
  (fix 1's `"shared"`, or a reason a later build adds, read by an older plugin) throws a TypeError that fails the
  whole panel conversion. Use a reason's note only when it is one this build knows (page / started / frame / unread);
  anything else falls through to the unproven note. Test with `"shared"` and with a made-up reason.
- **R3-6 (note wording):** the `page` note for a box drawn through another host's file by the site's own script, when
  the box holds nothing that says whose it is (a back-to-top link with `href="#"`, a cookie bar linking another
  host's policy), must not send Justin to a CDN for "install code": say what is known ("the old page's own script
  draws it through a file from <host>; it isn't pasted: if it is the site's own button, rebuild it in Bricks; if it is
  a widget, add its install code by hand"), one plain sentence.
- **R3-2 (wording only; the behaviour stays, it is the rule as chosen):** a served file that draws its box by itself is
  pasted, and that file may do more than draw the widget (a served tag manager that inserts a button as plain markup;
  a chat file that also tracks). The pasted widget's note says so truthfully in a few plain words, on every pasted
  floating widget: it runs <host>'s own file as the old page did, with whatever else that file loads; remove the Code
  element if that isn't wanted. Record in HANDOFF, "not yet confirmed by Justin": whether a floating widget's code
  should be pasted at all, or always listed.
- Leave R3-3 (a served SDK the page inits that draws after an `await`: its tag pastes without the page's init call and
  draws nothing; only the vendor's own file runs) and R3-5 (the 200-frame stack read costs 24–59 µs per created
  element against 9–25 µs; no slow-down measurable above load noise) as recorded limits — unless your R3-1 change
  makes the stack read cheaper or dearer: measure with the reviewer's `cost.ts` and say.

## Work
1. Verify R3-1 yourself first on the reviewer's probes.
2. Each fix test-first, one commit each; mutate what you add (each new condition removed in turn is killed by a named
   assertion, never a crash; above all "an anonymous frame with a line counts" and "a native frame doesn't") under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no `--setenv=PATH`).
3. Re-run on your head, and keep the outputs: review 3's `probe3` (T1, T3 listed; T2, V1 as recorded), review 2's and
   review 1's probes (nothing but self-drawing served files pasted; trackers, tag managers, SDKs and loaders asked 0
   times when the paste is drawn and clicked).
4. Records batched into your commits: HANDOFF's panel-embed-code section (the rule's "by itself" now counts code with
   no file; the known limits above; the R3-2 line "not yet confirmed") and the ledger ("Fix pass 3"; any plan line
   that now reads differently, for the planner); `docs/specs/web-capture.md` if it describes the stack read; append
   what you defer to `evidence/panel-embed-code/follow-ups.md`.
5. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's unit tests with
   `F2B_UNCHANGED_SUMS=1`, `plugin-convert`, `sandbox-convert`, the web files your change touches each alone under the
   cap (`panel-floating-chain`, `floating-holds`, `tracker-stack`, `capture-floating`, `capture-embeds`,
   `panel-embed-code`, `tracker-style`, `capture-wakers`; `capture-entrances` has a known R8-1 flake under load), the
   code route byte for byte against `6b115d3f` on the widget fixtures and the saved captures (panel route: payloads
   byte for byte except the reworded notes). Every log starts `HEAD=` and ends with one line `EXIT=`. Commit after
   each passing step (plain `git commit -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git
   diff --cached --name-only` without CLAUDE.md). Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/fixer-3/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-f3/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's
own shell); a worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). Scripts written with Write under `~/.cache/pec-f3/` (a restart empties `/tmp`); one `bash <file>`
per Bash call. SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso
| grep sending`). Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage limit twice:
write each log's `EXIT=` line (wait on `^EXIT=`); when resumed, check `git status` and `git cat-file -t HEAD` (a commit
made in the last seconds can leave empty objects: point the branch back to the last good commit, make the content
differ, commit again), read your finished logs first and never start a second driver on a suite.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); R3-1: verified?, the rule as built (which frames count,
which don't, and why), tests, RED/GREEN paths, mutation table, the three reviews' probes on your head; each small step
done or left; the notes as they now read; the stack read's cost before and after; gates; plan lines for the planner;
`found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is
`none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
