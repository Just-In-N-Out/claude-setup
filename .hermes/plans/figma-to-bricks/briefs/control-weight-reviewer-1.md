# Role: reviewer (Mini round 1, the whole story; report only): control-weight

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (saved captures and local fixtures
only); never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"; one real-bug review per job):**
report as P0–P2 only bugs a real site or normal use hits (a capture of a real site converted with `npm run site`,
plain or `--elementor`, and pasted into Bricks 2.3.9 / 2.4; Figma designs converting as before), each with a concrete
real-use scenario. Edge cases are P3. A P0–P2 with no concrete real-use scenario counts as P3. (The AC proofs on the
final base are a later step: this job is built on another job's head and is verified after it moves onto main. You
review; you write no `verifier/ac.json`.)

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md`
  (AC1–AC6, proposed; none live; ⭐ answers Q1 A – Q4 A taken under the standing auto-go; Q1 A is a small design point
  not yet confirmed by Justin: for the few elements this rule touches, a property like Display shows in the class's
  Custom CSS instead of its control). The job: on the code route, an element the capture reads as its parent's inline
  element at some widths (a link that is a word in its wrapper's line at 768–991) and as its own element elsewhere was
  pasted with two classes, and the parent's `.wrapper > :nth-child(1)` rule (0,2,0) lost to the element's own class
  control (Bricks prints `.cls.brxe-div`, 0,2,0, after it): `inline-block`, 28 px taller. The fix: the parent's inline
  readings of a pasted child move onto that child's own class for those widths, only where the paste can prove which
  child is which.
- Branch `control-weight-build`, head `a442672e0d4ad776f0269e2860eaf7af97fb0ed9` (code head `d7dc6481`; the last commit
  is the ledger), base `ce5b38acbb959c12218e319560608c660c753b70` (**another job's head**, `staging-fit-cancels-stack7`,
  itself on `main` `7eeca437`: review-clean, not merged). In your own worktree: `git checkout --detach
  a442672e0d4ad776f0269e2860eaf7af97fb0ed9`, confirm HEAD and a clean status. Review `git diff ce5b38ac...HEAD`.
- The builder's receipts (read, don't trust): `evidence/control-weight/builder/` (`logs/`, `logs/final/`, `logs/mut/`,
  `shots/`); the planner's evidence and probes: `evidence/control-weight/planner/` (`NOTES.md`, `dual.ts`,
  `contest.ts`). The builder's words: one new pure file `src/core/site/inline-own.ts` (`inlineOwners`); in
  `src/core/site/convert.ts` `prepare`'s class loop gains `owners`, `decls`, `words`, `moved`; `own` reads `decls`;
  `inline:` reads `words` without the moved keys. It moves nothing unless the capture's inline elements match the
  pasted children one for one (a space drawn between them doesn't count against that; a child hidden there does), no
  child was lifted from below, the parent is shown at those widths and the child doesn't stand alone there. The
  lifted-child condition can't be driven on this base (`lift` arrives with site-native-structure): its mutant M3 is
  equivalent here. 376 pastes of 47 captures byte for byte as base.

## Check hardest (probe with hand-made captures and fixture sites of your own shape; local servers only)
1. **Is the moved reading right at every width?** The child's own class now carries the inline reading for the
   parent's inline widths: its `display` and every other property the inline reading held (font, colour, padding,
   margins, text decoration, vertical-align, white-space) at those ranges, and its own reading elsewhere; the bounded
   runs between them (staging-fit-cancels' `runsOf` / `boundsOf` / `mediaOf`): draw the paste in Chrome with both
   Bricks samples at each range's edges ±1 px and inside (767, 768, 769, 880, 991, 992) against the site: the link's
   computed style and the line's height. A property the inline reading doesn't declare but the own reading does
   (padding, background): does the own value leak into the inline widths, or the reverse?
2. **Which child is which.** Two and three inline children; an inline child between text runs; `<br>`; a comment
   node; a child hidden at one of the widths; children reordered by `order`; a child that is itself a wrapper of
   inline children (nesting: the move applied twice?); a child that is a Bricks Button, Heading or Image on the
   `--elementor` route (their controls differ: does Display in an element that isn't a Div still print?); a child
   with hover / focus looks (`states`) at the inline widths: do they still apply; a child that plays an entrance
   (site-motion's `keep`). A wrong match moves one element's look onto another: P0–P2 if a real shape reaches it.
3. **Controls after the move.** For the moved element `controlsFor` now decides over the joined declarations: which
   properties leave the controls for custom CSS (Q1 A), and is anything that was right before now wrong at widths
   the parent never read inline (desktop, phones)? Bricks' tier cascade (tablet → sideways phones → upright phones):
   a tier that goes back to the own value writes it explicitly?
4. **Nothing else moved:** your own byte comparison, base's converter beside head's, on the saved captures you can
   convert (B-Dry's stand-in `evidence/site-native-structure/inputs/standin-capture-0581852c.json` under an 8G scope,
   the fixtures the builder lists, the five hidden-menu fixtures): identical except captures holding the shape; the
   staging-fit-cancels golden (`test/fixtures/site-no-revert-main.json`) untouched; Figma designs can't change (no
   Figma stage imports `src/core/site`: check the import graph yourself); `src/core` still uses only the language's
   built-ins (`tsconfig.sandbox.json`).
5. **The tests can fail** (read `logs/mut/`; two mutants of your own on `inline-own.ts` under the 4 GB cap). AC1's
   file holds no `todo` and its second test is a real RED on base. The builder's reworded line in
   staging-fit-cancels' HANDOFF Known limits: true.
6. **What the later moves will meet** (P3 notes for the stack step, unless wrong on this head): site-native-structure's
   `lift` (the condition that can't be driven here: say what test must be added when both are on main); site-menu's
   and site-native-structure's edits beside `convert.ts`'s class loop; footer-icon-list's `statesOf` (`sides.ts`): does
   `inline-own.ts`'s own state reader skip that rule for the moved element (a box side written by two names on an
   element that is also read inline)?

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Code-route paste traps") and `references/rendering-validation.md`, the repo
`CLAUDE.md` ("Build general logic"; "Architecture rules": CSS stays typed, never regex or string-match CSS; "Output
style: editable structure first") and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   ce5b38acbb959c12218e319560608c660c753b70 /home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-r1/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a redirect of `git show` outside the worktree is refused: use `git archive -o <scratch>/<name>.tar
  <sha>` in its own command). Scripts written with Write; probes and logs under `~/.cache/cw-r1/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G; export variables first, no `--setenv=PATH`). Waits under 115 s. The PC lost power twice this week and agents were
  stopped by a usage limit twice: keep notes and finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review
saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a
one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons
now.`
