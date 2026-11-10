# Role: fixer (Full, after review 1 and the re-plan: tasks F0–F8 of the v2 plan): footer-icon-list

You are a fresh fixer for FigmaToBricksV2 (**Opus 5.5, high**). Build the re-planned fix test-first on the existing
branch, keeping its commits, then stop at `ready-for-review`. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump `BUILD`, leave other
worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site (the offline B-Dry stand-in
site served locally, saved captures and local fixtures only); no logins; never write to any WordPress site; never run
`npm run site:upload` against anything. Nothing paid. Nothing may hide that the importer's Chrome is automated.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`, `git-commit-rules`. Read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4": the stacking lines) with
`references/testing-pitfalls.md`, `references/live-site-reading.md` ("Code-route paste traps": the footer lines end
with review 1's and planner 2's lessons) and `references/rendering-validation.md`, and the repo `CLAUDE.md` in full
("Build general logic"; "Architecture rules"; "Website captures"; "The importer never hides that its Chrome is
automated"; "Code Figma runs uses only the language's built-ins").

## Inputs
- **The approved plan (v2, read-only):** `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC10, all proposed; AC6 live; its Amendments list 1–11 at the top; lines ending in ⟦v2⟧ are new or changed; the
  Mini plan it replaces is `plan-approved-v1-mini.md`). **Tasks F0–F8 are yours.** ⭐ answers taken under the standing
  auto-go: Q1 B (the inline sides come with the reader's rule), Q2 B (the capture's reader keeps each box side by one
  name, the site cascade's winner, at every range and under a hover, and marks the capture `web.code.oneName`), Q3 A,
  and **Q4 A, Justin's decision, not yet confirmed: a capture made before this build pastes exactly as before, with
  one note per affected part saying to capture the page again** (mark it "not yet confirmed" in HANDOFF).
- Review 1: `evidence/footer-icon-list/review-1/review.json` (R1-1 P2: "the name the capture lists later" is not the
  site's winner when a stronger rule writes the side again; probes in `review-1/probe/`). Planner 2's evidence and
  prototype: `evidence/footer-icon-list/planner-2/` (`notes.md`; `probe/probe2.ts`, `probe2.log`, `table.md`: 30 rows,
  all right with the new reader on staging-fit-cancels' bounded runs; `bdry/`; `red/`; **`code/` holds every file the
  plan has you write, with `SHA256SUMS`, `apply-fix.py` and `ac2-edit.py`**: read only; still write each test first
  and see it fail for the reason the plan names before the code goes in).
- **Your branch and base (Task F0).** In your own worktree: `git checkout -B footer-icon-list-fix1
  bdd3dde7dc8c06b8daa0ec442a87ae1961e469fa` (the built head, on the old main `7eeca437`), then stack it on
  staging-fit-cancels as the plan says: that job's current head is `4a352ffd1dd34210512abfc9abe3e23df3858c2f` (branch
  `staging-fit-cancels-stack10`, on `main` `f40ce6ce`, Build 2026-11-10.5; review-clean, in its final checks). `git
  rebase --onto 4a352ffd1dd34210512abfc9abe3e23df3858c2f 7eeca437ea100c821bcfb82cdbbe516a023ff097`. Check first
  whether it has merged (`git merge-base --is-ancestor 4a352ffd main`, and `git rev-parse main`): if `main` already
  holds it, rebase onto `main` instead and say so. Conflicts are expected in `docs/HANDOFF.md` only (keep both: this
  job's section first, then the base's lines exactly as the base has them; this job's `<footer-icon-list id at
  merge>` placeholders stay); a conflict in source: keep both sides' meaning, typecheck at that commit before `git
  rebase --continue`, record it. **Your review base is the commit you stacked on** (`4a352ffd`, or `main`): report it.
- Jobs moving beside you (not merged): site-menu (`site-menu-fix5`: it rewrites part of `src/web/read/code.ts` and adds
  a field in `src/core/snapshot/web.ts` after `sheets?`: keep your edits in those files to the lines the plan names,
  so the later meeting is a context conflict only); panel-embed-code (`src/web/read/tracker.ts`, `floating.ts`: no
  shared lines); control-weight (`src/core/site/inline-own.ts`, `convert.ts`'s class loop); site-native-structure.
- The paste check id: `<footer-icon-list id at merge>` in HANDOFF and the docs.

## Work
1. Follow tasks F0–F8 in order, each test first (RED proved as the plan says: on the built head and on the base you
   stacked on, by the plan's own method), one commit a task (where a task's commit would leave the suite red between
   a consumer and its producer, do the two as one commit or state the expected intermediate red in the commit message
   and the ledger). Replace the repo's plan copy `docs/plans/2026-11-10-footer-icon-list.md` with the approved v2
   copy (byte for byte) in F0; ledger `docs/plans/2026-11-10-footer-icon-list-ledger.md` ("Fix pass 1 (v2)": each
   task, RED and GREEN paths, the mutants, the gates).
2. **The capture's reader is the heart of it: prove it on shapes beyond the plan's fixture** (your own local pages):
   each side's winner by a reset, a class, `!important`, an inline `style`, a later rule of equal weight, a media
   query at one range only, a `:hover` look, `::before` / `::after`, an inline element; shorthands (`margin`,
   `margin-block`, `inset`, `border-block`), `var()` and `calc()` values; a vertical `writing-mode` declared and
   inherited, `direction: rtl`; sizes (`width` / `inline-size`, min / max). For each: the capture holds one name per
   side (the winner), and the paste drawn with both Bricks samples shows the site's value at every width. A shape the
   rule gets wrong: fix it, or record it plainly (HANDOFF "Known limits") with what the paste shows.
3. **The capture is touched as lightly as before:** no extra page round trip per element (the plan's batched call
   only for elements that declare a logical side); `npm run capture` on the offline B-Dry stand-in within the plan's
   bound against the base (AC10: four runs, base / head / head / base, under an 8G scope); the capture's file differs
   from the base's only by `oneName` and the losing names; `capture:check`, the helper and the panel's sandbox read a
   new capture; an older tool reading a new capture and this build reading an older capture both work.
4. **Older captures (Q4 A):** every saved real capture's payload byte for byte as the base's, plain and `--elementor`,
   the note only where a block pair differs; the merged jobs' recorded pins in the default suite unchanged (a merged
   job's env-gated story pin, `F2B_STORY_PINS=1`, is that job's receipt: if this job moves one by design, record the
   four-tree table and move on; never regenerate it).
5. Mutate what you add (each condition removed in turn is killed by a named assertion, never a crash: the winner by
   cascade order, the flow mapping, a name set again keeping its place, the `oneName` mark, the older-capture gate,
   the note's count), under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no
   `--setenv=PATH`).
6. Gates before stopping (on a `git archive` scratch copy of your head): both typechecks (`tsconfig.sandbox.json` too)
   and `npm run check`; every AC's test with a log starting `HEAD=` and ending with one line `EXIT=` (each cited name
   whole on one plan line; AC1 on fresh captures of the offline stand-in made by each tree's own reader, the head's
   capture kept under the evidence folder and named by its sha256; AC10 named-only); `test/unit/plugin-convert.test.ts`;
   the five Figma replays byte-identical to your base; `npm run corpus` the same as base; `test:web` and
   `test:browser` file by file under the cap (B-Dry files 8G) compared by name with your base (**this job changes
   what every new capture holds, so every test that captures a fixture fresh reads a different capture: run base's
   side yourself for every file whose result differs by name**; five browser files fail on main on this desktop:
   composition-clipping, fonts, hero-pair, peer-sides, pill-holder; known flakes: the code-page fixture's 5.09 px load
   flake, `capture-windows` AC7, `capture-entrances` R8-1, `site-elementor-button` pixels-at-rest, "Chrome didn't
   start within 20s" under load: rerun a flake alone); capture-speed's byte pins that now differ as the plan expects:
   say which and why; a screenshot per AC.
7. Records: HANDOFF's footer-icon-list section rewritten for the rule as it now is (the reader's winner; older
   captures and Q4 A "not yet confirmed"; what the built conversion rule got wrong and why it went; known limits; the
   found-elsewhere items; Justin's numbered steps for the live check, starting with the re-capture), the CLAUDE.md
   lines for the merge finisher in the ledger (the Status line; the standing rule as the plan words it), and what you
   defer appended to `evidence/footer-icon-list/follow-ups.md`.
8. Commits: plain `git commit -m` (or `-F <file>`), no author override, no AI or Co-Authored-By lines, `git diff
   --cached --name-only` without CLAUDE.md; `git ls-files .superpowers/` stays empty. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/fixer-1/`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters and a separate one
  for each script you start at the same time (`~/.cache/fil-f1/t1`, `t2`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run Chrome: close every Chrome you
  start (stop it by the PIDs of its own profile path; never `pkill -f <pattern>`: it kills the tool's own shell). A
  worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
  `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in;
  a piped, chained or redirected git command is refused in your worktree: `git archive -o <file> <sha>` in its own
  call, then untar in the next; **never chain a git command after a `cd` into a scratch folder: use `git -C <absolute
  path>`**). One `bash <file>` per Bash call (scripts written with Write, kept under `~/.cache/fil-f1/`; a restart
  empties `/tmp`); run long gates on a scratch copy, never in the worktree while you edit it.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`) or a scope oom-kill; `compare-corpus.test.ts` needs `--test-timeout=3600000`. Waits under
  115 s; wait for background drivers in the foreground with a bounded loop script (ending the turn while they run can
  end you early).
- The PC lost power twice this week, and agents were stopped by a usage limit twice: write each log's `EXIT=` line
  (wait on `^EXIT=`); after a restart check `git status` for half-written tracked files (exactly 8388608 bytes) and
  `git cat-file -t HEAD` (a commit made in the last seconds can leave empty objects: point the branch back to the last
  good commit with `git update-ref`, make the content differ, commit again); read your finished logs first and never
  start a second driver on a suite one is still working through.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, the commit you stacked on (your review base), last commit (full SHA); the rebase
(conflicts and resolutions); per AC: test, RED/GREEN paths, screenshot; the reader's rule on your own shapes (a table:
shape, the capture's names, the paste's value against the site's); the capture's cost and bytes; older captures
(payload sums against base; where the note appears); the mutation table; gates vs base (files that differ by name and
why); deviations from the plan; `found_else`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only;
empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
