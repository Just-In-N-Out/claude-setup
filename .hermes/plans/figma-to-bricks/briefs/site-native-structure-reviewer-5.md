# Role: reviewer (round 5: the move onto footer-icon-list and fix round 4; report only): site-native-structure

You are a fresh reviewer who never saw the build, the rebase or the fix (**Opus 5.5, high**). Review only: change no
source or test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or
other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local stand-ins and
saved files only); never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a real Elementor site's capture converted with `npm run site … --elementor` / `site:import`
and pasted into Bricks 2.3.9 / 2.4; `site:check` / `site:live` on such a paste; the plain route and Figma designs as
before), each with a concrete real-use scenario. Edge cases are P3; a P0–P2 with no concrete scenario counts as P3.

## What happened before you
The job (the website importer's `--elementor` paste becomes Bricks' Section / Container / Block, Heading, Button, Divider
and linked Image; a part's root that draws nothing is "lifted") was review-clean (review 4, MOVE ON) at `138799bb` on old
main `7eeca437`. Since then main gained control-weight, site-one-command, site-menu (menus/pop-ups as Offcanvas with
Interactions; socket gate), capture-refused-styles, and footer-icon-list (one-name capture reader; review-clean at
`731707c5e84f9495e152b60d302fe640f6f06554`, merging next as Build 2026-11-11.4). A fixer rebased the job onto `731707c5`
(36 commits, 11 conflicted) and fixed, test first: two bugs where it meets site-menu (`07a44048` outside-close
Interactions on every section of a lifted part; `e6bcfed6` + `b2435def` a folded Button/linked picture that opens a box
takes prepare's opener `#` rule), review 4's R4-1 (`b577213f`, `readSection` origin after the motion hold) and R4-2
(`4d283627`, a test killing the first-top-element-only mutant), and regenerated merged jobs' pins by design (`b23d3c97`:
site-menu AC6 hashes, site-opens roots, goldens with a four-tree proof). R1-6 (`_cssId`) not done: unverified in Bricks.
**Nobody has reviewed the resolutions or these fixes.**

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live). AC14's input is being amended by a planner to the new stand-in
  `evidence/site-native-structure/inputs/standin-capture-b2435de.json` (sha256 462f292d…0f6d) — not your concern beyond
  checking it was made by the head's own capture as claimed.
- Branch `site-native-structure-stack6`, head `2a38027faad44e16bcb885d264317d8be9df6f57` (code head `b2435def`), base
  `731707c5e84f9495e152b60d302fe640f6f06554`. In your own worktree: `git checkout --detach 2a38027f…`, confirm HEAD and a
  clean status. The whole story: `git diff 731707c5...HEAD`. The move: `git range-diff 7eeca437..138799bb
  731707c5..<the first commit after the replayed ones>` (see `stack-6/range-diff.txt`); the fixes: the commits after the
  replay (`git log 731707c5..HEAD`).
- The move record: `evidence/site-native-structure/stack-6/` (`conflicts.md`, `resolutions/`, `range-diff.txt`, `logs/`,
  `ac14/`, `page-bdry/`). Read, don't trust. Deferred items: `evidence/site-native-structure/follow-ups.md` (don't
  re-report what is recorded unless you rate it higher, with a scenario).

## Check hardest
1. **Each hand resolution against both sides** (`resolutions/`): `convert.ts` `prepare`'s `PrepareExtra` carrying the
   job's `part`, `Prepared`/`PartResult` (main's `uses`, `opens`, `pictures` with the job's `lifted`, `standsFor`),
   `tree.ts` `TreeOptions`/`TreePick`, `scopeOf`'s order, the owner declarations beside `withInherited`, main's
   closed-`<details>` rule beside `absorb`, `test/web/lib/site-check.ts` `inClosed` beside the lifted reading, HANDOFF and
   the Bricks README. Anything of site-menu, control-weight, footer-icon-list or capture-refused-styles dropped, doubled or
   reordered?
2. **Where the jobs meet in a real paste** (the B-Dry stand-in; a menu fixture; draw in Chrome where it matters): an
   Elementor header with a ☰ that opens an Offcanvas, under native structure and a lifted part — the opener (Button or
   linked picture) keeps a link a keyboard opens, the Offcanvas opens and closes (Escape, ×, the dim, a click outside in
   any section); a pop-up button; footer-icon-list's one-name sides on folded Buttons and Sections (the footer rows now
   ≤1.09 px — confirm on your own run); control-weight's inline owners next to absorbed elements.
3. **The fixes:** RED on the parent, GREEN on head, for `site-native-opens`, `site-opens-through`,
   `site-check-origin`, `site-check-lifted`; one or two mutants of your own under a 4 GB cap.
4. **Regenerated pins are honest:** re-derive the four-tree claim (`logs/opens-old-4trees.log`, `logs/goldens-4trees.log`)
   on two inputs of your choice; nothing else regenerated without proof.
5. **Nothing else moved:** without `--elementor` every paste byte for byte as `731707c5` (AC13's pins); Figma designs byte
   for byte (`test/unit/plugin-convert.test.ts`, the five replays); rerun three web files of your choice, each alone under
   the cap.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (its new "stack
move" line), `references/live-site-reading.md`, the repo `CLAUDE.md` and `reference/bricks/README.md`; read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-5/review.json` (round 5, full
SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base 731707c5e84f9495e152b60d302fe640f6f06554 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sr5/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` scratch tree needs main's `node_modules` symlinked and its
`.bin` on PATH; piped/chained git commands may be refused (script files, `bash <file>`; `git -C <absolute path>`). Use
`tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G). SIGTERM/143/137/"Killed" may be earlyoom:
check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, the real-use scenario) or "none"; the resolution check; the meet checks;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
