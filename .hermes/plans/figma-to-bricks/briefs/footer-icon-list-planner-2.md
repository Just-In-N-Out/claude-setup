# Role: planner (re-plan after review 1; the job goes from Mini to Full): footer-icon-list

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Plan only: change no source or test in any worktree
or the main folder, commit nothing, start no agents. Never load bdryswi.com (it has a bot check; never without
Justin), B-Dry staging or any live site; no logins; never write to any WordPress site. Nothing paid. Nothing may hide
that the importer's Chrome is automated.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md` — "Code-route paste traps": the footer lines end
with review 1's lesson —, `references/rendering-validation.md`), `engineering-best-practices`,
`implementation-planning`, `systematic-debugging`. Read the repo `CLAUDE.md` in full ("Build general logic"; "Website
captures"; the capture format lines of site-motion: "the capture (format 3)…"; "older captures … paste byte for byte
as before"), and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the
plan-amendment paragraph: an Amendments list at the top, changed lines marked, ids and cited test names kept, each
cited name whole on one line, no Amendments-list line starting with an AC id).

## Where the job stands
- The approved plan (Mini; read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC6; AC6 live; ⭐ Q1 A, **Q2 A "fix the conversion only"**, Q3 A). The bug: a site writes one box side by two
  names (a reset's `margin-top: 0`, then a widget rule's `margin-block-start`); the capture keeps both names; the
  paste printed the physical one as a class control (0,2,0) that beat the logical one in custom CSS (0,1,0): B-Dry's
  footer contact list 69 px short.
- Built on branch `footer-icon-list-build`, head `bdd3dde7dc8c06b8daa0ec442a87ae1961e469fa` (on `main` `7eeca437`):
  `src/core/site/sides.ts` `oneSide(d, before)`, called from `statesOf` (`src/core/site/blocks.ts`): for a side written
  by both names with values that draw differently, only the name **the capture lists later** stays (and, the builder's
  addition, a narrower range that adds the competing name keeps the losing name at the winner's value). B-Dry's
  footer 69 px → 1.09 px; the generic fixture 72 / 36 px → 0.
- **Review 1** (`evidence/footer-icon-list/review-1/review.json`; probes and logs in `review-1/probe/`): REVIEW AGAIN.
  - **R1-1 (P2):** "the name the capture lists later" is not always the site's winner. `src/web/read/code.ts` keeps
    each name where its first, weakest declaration put it; so a reset's physical side, a logical rule, then a
    **stronger physical rule writing that side again** (a class, `!important`, an inline `style`) leaves the physical
    name listed first with the winning value, and head pastes the logical value: 30 px against the site's 5 (class),
    40 against 4 (`!important`), 33 against 12 (inline style), 16 against 9 (a stronger physical rule on phones).
    **Base drew all four right** (its physical control wins). Real use: a WordPress block-theme page (an image block's
    own inline `margin-top` from the editor, in a flow layout whose global styles write `margin-block-start`, over
    block-library's `:where(figure)` reset). The reviewer's fix: the plan's Q2 B — the capture keeps only the
    cascade's winner per range (exact on new captures); "moving a key to the end on each write" isn't enough for
    narrower ranges (probe k).
  - R1-2 (P3): a narrower range that adds a weaker physical side beside a stronger logical one reads as the physical
    name winning (`statesOf` appends new names at the end): 7 px against 22 on phones; base wrong the same way. R1-3
    (P3): when only a middle range writes a physical side, the narrower range sends it back with `revert`, which as a
    class control beats the logical winner (0 against 14 on phones; base the same; staging-fit-cancels' bounded runs
    remove that `revert`). R1-4, R1-5: recorded limits; AC3's wording.
  - The builder's ranges addition is correct; AC1 is fixed for the right reason; AC4 re-derived.
- The main session's ruling under Justin's standing words ("whatever the plan agent recommends just go with that";
  "fix the rule, not the instance"): a conversion-only fix can't be made right (the capture doesn't hold what it
  needs), so **the job is Full from here** and the plan is re-planned around Q2 B. Justin has been told; nothing else
  about the job's goal changes.

## What the new plan must settle, with evidence (probe on `git archive` copies; local fixture servers only)
1. **What the capture must record so the conversion knows each side's winner at every range.** Read
   `src/web/read/code.ts`, `code-expand.ts`, `code-facts.ts`, `src/web/code.ts`, `src/core/snapshot/web.ts` and how
   ranges are read. Candidates to weigh by proof, not taste: the reader keeps only the winning name of a pair per
   element and range (the cascade already decided: Chrome's matched styles give origin, specificity and order; an
   inline `style` and `!important` included); or it records the pair's winner beside both names (a marker the
   conversion reads); or it reads the computed value of the physical side and keeps the name that equals it. For each:
   is it exact on the reviewer's probes a–q (`review-1/probe/`), on R1-2 and R1-3's shapes, on shorthands (the capture
   expands them in Chrome), on `var()` and `calc()` values, on a vertical `writing-mode` and `direction: rtl` (Q1: the
   inline sides — with the winner known in the capture, do left and right come for free? say yes or no with a probe;
   if yes, should this job take them), on hover and focus looks (they don't pass through `statesOf`: does the capture
   record their winner the same way?); what it costs in capture time (capture-speed's AC: matched styles asked once
   per element; no extra CDP round trip per element unless you prove the cost on the offline B-Dry stand-in); and what
   it changes in a capture file (format version, `capture:check`, the panel's sandbox, older tools reading it).
2. **Captures made before this build.** They hold both names with no winner. Decide and justify, as an open question
   for Justin with a ⭐ answer and a one-line plain-words trade-off: (A) older captures paste as on main (the 69 px
   stays on an old capture; the note says "capture the page again with this build"), exact and safe, and Justin must
   re-capture anyway (his saved 2026-11-09 capture is refused; live check 3do); or (B) older captures use the built
   rule ("listed later"), which fixes the B-Dry shape and is wrong on twice-written sides that base drew right; or
   (C) a narrower rule for older captures that you can prove never makes a paste worse than main (say what it is and
   prove it on the reviewer's probes). Say what each means for the repo's saved captures and goldens (the merged
   jobs' pins must not move for captures without a pair; B-Dry's saved stand-in capture is an older capture: how AC1
   is proved — a fresh capture of the offline B-Dry stand-in site made with the new reader, named by its sha256, the
   way site-slider's amendment 11 swapped an input).
3. **What of the built code stays.** `oneSide` and the ranges keep: still needed (for which captures), simplified, or
   removed? `statesOf`'s append order (R1-2). The conversion must never guess a winner the capture didn't record.
4. **The other jobs.** staging-fit-cancels (review-clean, queued to merge before or after this job: it edits
   `blocks.ts` — bounded runs replace `revert` — and removes R1-3's `revert`); control-weight (`inline-own.ts` rebuilds
   a moved element's ranges before `statesOf`: a moved element holding a pair); site-menu and panel-embed-code (both
   touch the capture: `src/web/capture.ts`, `src/core/snapshot/web.ts`, `src/web/read/*`): say where this job's
   capture change will meet them and in which order you would merge.

## The plan
- Write `~/.hermes/plans/figma-to-bricks/footer-icon-list-v2.md`: the whole plan again (the approved text as your
  base), with an **Amendments list at the top** and every changed line marked. Keep AC ids and cited test names where
  an AC's meaning survives; where the re-plan needs new criteria (the capture records the winner; older captures'
  policy; the reviewer's twice-written shapes drawn as the site at every width; capture time unchanged), **add them
  as new ACs after the existing ones, marked (proposed)**, each with one named test whole on one plan line; an AC
  only Justin can check tagged `(live)` right after its id; amend AC3's sentence to what the rule now is; never start
  a non-definition line with a list marker, table pipe or heading followed by `AC<n>`. Tasks test-first, each RED
  proved on the built head `bdd3dde7` (apply only the test to a clean export) and, for criteria about main's
  behaviour, on main; say which tasks a fixer does on the existing branch (keep its commits) and in what order. Open
  questions at the top with a ⭐ answer each (question 2 above is Justin's: mark it). Pipeline: Full (one more review
  of the whole story after the fix, then the verifier and the blind auditor).
- You may run tests and probes on `git archive` scratch copies of `bdd3dde7` and of main; scratch under
  `~/.cache/fil-p2/`; evidence under
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/planner-2/`. The offline B-Dry stand-in site and
  how the tests serve it: find it through the named B-Dry tests' env variables and the project skill
  (`references/testing-pitfalls.md`: "A fresh B-Dry capture under a 4G scope is killed…": use 8G).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/fil-p2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time, closed after (stop it by the
PIDs of its own profile path; never `pkill -f <pattern>`); a `git archive` scratch tree has neither `tsc` nor
`node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
`node_modules` in). B-Dry runs under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (export variables
first, no `--setenv=PATH`). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min"
-o short-iso | grep sending`). Waits under 115 s. The PC lost power twice this week and agents were stopped by a usage
limit twice: keep notes and results on disk; when resumed, read them first.

## Report (as text)
The plan's path; what the capture will record and why that candidate (the probes' table: a–q, each candidate, the
site's value); the older-captures question with its ⭐ answer and trade-off; what of the built code stays; the ACs one
line each (which are new); the tasks for the fixer; the merge order against the other jobs; what it means for
site-native-structure's AC14 (still blocked until this merges) and for Justin's re-capture; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; `enforce` is `none` or a one-line
check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
