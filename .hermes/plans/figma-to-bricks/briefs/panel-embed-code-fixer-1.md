# Role: fixer (round 1: review 1's R1-1 and R1-2, plus cheap wording fixes): panel-embed-code

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Fix review 1's two P2 findings test-first, plus the
small P3 steps named below, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, don't rebase
(`main` has moved to `2879e496`; a later step moves the job), leave other worktrees alone, start no agents. **Never load
bdryswi.com, B-Dry staging, a widget vendor's host** or any live site (local fixture servers and saved files only); no
logins; never write to any WordPress site. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**This job's guard, which your fixes must not weaken:** a pasted Code element runs only a widget's own code. Any path
by which a paste carries a tracking tag, a tag manager, another widget's script, a page script or a shared library is a
P0/P1. Where a capture can't prove what a widget's own code is, the safe output stays: listed (a floating one) or an
empty box of its size, named, never pasted code.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds line: "An embed's snippet is not only its slot…", which ends with this
review's lesson), the repo `CLAUDE.md` ("Build general logic": nothing keyed on a vendor's name or host; "Code Figma
runs uses only the language's built-ins"; "Website captures") and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B panel-embed-code-fix1 4d6c64031762e6ae7a1166f25d405db184457805` (the reviewed head, branch
`panel-embed-code-build`, on `f708dfb6`), confirm `git rev-parse HEAD` and a clean status. Report your branch.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; Q1 A – Q5 A taken).
- Review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-1/review.json`; its probe site,
  captures and logs: `~/.cache/pec-r1/` (read only; copy what you need).
- The builder's receipts: `evidence/panel-embed-code/builder/`; deferred items: `evidence/panel-embed-code/follow-ups.md`.

## The findings
**R1-1 (P2, `src/web/read/floating.ts:173`):** `own` keeps only the served tags of the very file that made the box.
The common chat shape is a small served bootstrap tag that injects the bundle which draws the launcher, so `own` is
null and the chat is only listed ("add its code from your <host> account by hand"), where main pasted the served
bootstrap tag and the chat worked. The reviewer's probe: `boot.js` served, `bundle.js` injected; head lists it, base
pasted `boot.js`.
- The rule to carry out (the main session's reading of Q4 A, to be confirmed by Justin): a floating widget's own code
  is **the served external script tag that starts the chain of script loads ending in the file that drew the box**.
  When the drawing file isn't itself a served tag, follow who inserted its `<script>` element, step by step, back to a
  served tag.
- What must stay out, each proven by a probe and a test of your own:
  - a chain whose root is an inline script (a vendor's inline snippet, a tracking loader): stays listed, as now;
  - **a served root that is not this widget's own**: a tag manager or loader file served as a tag that injects the chat
    among other things (other companies' scripts, a tracker, a second widget). Pasting that root would run all of it.
    Decide the structural test (for example: everything the root's chain loads belongs to the one chain that drew this
    box; a root that also starts loads outside that chain is not the widget's own) and say why it holds; it may not key
    on host names;
  - a root tag that draws two boxes, a root loaded twice, a bootstrap on one host with its bundle on another (must
    work: the two common vendors named by the reviewer serve them from different hosts);
  - the served tag itself is recorded as served (its own attributes), never rebuilt, never widened to its neighbours.
- A box whose own code still can't be proven keeps today's listing and note.

**R1-2 (P2, `src/web/read/tracker.ts:13`; pre-existing on base, but AC7's words don't hold for it):** the tracker
records the innermost script file on the stack as the maker, so a site's own fixed box drawn through a library served
from a CDN (a site script calling jQuery to make a back-to-top button or a cookie bar) is classed as another
company's: `own` is the library's tag, which pastes at the end of the footer on every page under the "its own code"
note, and a second copy of the library replaces WordPress's after its plugins attached. The reviewer's probe:
`lib.js` + `/theme.js` gave `own` = `<script src=lib.js>`.
- Fix as a rule (the reviewer's idea: record the outermost caller too): a shared library's tag is never a widget's own
  code. Two stack shapes look alike and both need a probe and a test:
  - **A, a site-own script calls a CDN library that makes the site's own box:** the box is the site's own, handled as
    every other site-own fixed box is on base; the library is never pasted;
  - **B, a site-own script (often inline) calls a vendor's API, and the vendor's file makes its launcher:** never a
    library paste either; choose between "its own tag where the R1-1 rule proves it" and "listed, named", and say what
    Justin sees. Whatever tells A from B must be structural (what the box holds, what else the file made), never a
    list of library names.
- Say plainly what changes for captures already saved (nothing may change for them except through the consumer rule)
  and for `npm run site` (the code route's floating extras): AC8's byte-for-byte holds for the saved fixtures.

## Small, each a few lines with a test, else leave recorded
- R1-6's note wordings (`src/core/normalise/floating.ts:24` and the shared rule's notes): no "your <cdn host> account"
  for a host that has no account (name the widget's host without promising an account); a box a site file made around
  another company's frame doesn't say "can't be told apart from the old page's other tags"; a capture whose served page
  couldn't be read says a new capture may paste it; a widget file that itself loads its vendor's tracker isn't called
  plainly "its own code" if you can tell. Keep each note one plain sentence Justin can act on.
- Leave R1-3, R1-4, R1-5 and R1-7 (the plan's text) alone: they are recorded; a planner amends the plan after you.

## Work
1. Verify each finding yourself first (the reviewer's probe, then your own page). Push back with evidence if one is
   wrong.
2. Test first for each (RED on `4d6c6403`, GREEN on your fix), on a fixture site of your own shape (extend
   `embeds-tracked` or add one beside it; generic, no vendor's name): a served bootstrap injecting a bundle on another
   host; a served tag-manager-like root injecting the chat and a tracker; an inline root; shapes A and B. For each:
   what the capture records in `own`, what both routes paste to run, what the fixture servers received when the paste
   is drawn (the tracker asked 0 times), and the note's words.
3. Mutate what you add (each new condition removed in turn is killed by a named assertion, never a crash), under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
4. Records batched into your commits: HANDOFF's panel-embed-code section (the rule as it now reads; "not yet
   confirmed: a bootstrap tag counts as the widget's own code"; what stays listed and why) and the ledger ("Fix pass
   1"); append what you defer to `evidence/panel-embed-code/follow-ups.md`; write in the ledger the exact plan lines
   that now read false (AC7's "the very file that made it", the plan's "rare", R1-7's code block) for the planner.
5. Gates: both typechecks (`tsconfig.sandbox.json` too), `npm run check`, the job's tests (`test/unit/embed-code.test.ts`,
   `test/unit/panel-embed-code.test.ts`, `test/web/panel-embed-code.test.ts`, `capture-embeds`, the web-embeds and
   floating tests your change touches; each web file alone under the 4 GB cap, one Chrome job at a time), the
   "unchanged sums" test, `test/unit/plugin-convert.test.ts`, the code route byte for byte against base on the widget
   fixtures, every AC's log starting `HEAD=` and ending `EXIT=`. Commit after each passing step (plain `git commit
   -m`, or `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without
   CLAUDE.md). Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/fixer-1/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-f1/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close
every Chrome you start (kill by its profile path if Node dies); a worktree's `node_modules` may lack `.bin`, and a `git
archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in).
Scripts written with Write under `~/.cache/pec-f1/` (a restart empties `/tmp`); one `bash <file>` per Bash call.
SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
sending`): say so, find what grew, rerun under the cap. Known flake: `capture-entrances` "R8-1 a page whose motion
never stops…" under load. Waits under 115 s. The PC loses power now and then and agents can be stopped by a usage
limit: write each log's `EXIT=` line; when resumed, read your finished logs first.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA); per finding: verified?, the rule, the fix, tests, RED/GREEN
paths, mutation table; the structural test that keeps a tag manager out and why it holds; A against B; the notes as
they now read; gates; what changed for saved captures and for `npm run site`; the plan lines that now read false;
`found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is
`none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
