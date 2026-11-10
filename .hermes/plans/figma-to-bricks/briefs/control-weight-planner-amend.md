# Role: planner (plan amendments, wording only): control-weight

You are a fresh planner (**Opus 5.5, high**). Amend the approved plan's wording where the build, one fix round, one
review and the move onto main changed what an AC's words describe; change no source or test, commit nothing, start no
agents. Never edit the main folder or any worktree; never load any live site; no logins. Work under
`~/.cache/control-weight-amend/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id — check wrapped lines too —, each cited test name whole on one line;
supporting tests go on an "Also (supporting, never the cited test)" line under the AC they support, naming files, not
full test names; where an amended sentence gains clauses only supporting tests assert, report the gap for a fixer).

## Inputs
- **The approved copy** (read-only, your base text; no Amendments list yet):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md` (AC1–AC6, proposed; none live;
  ⭐ Q1 A – Q4 A taken; Q1 A is a small design point not yet confirmed by Justin: for the few elements the rule
  touches, a property like Display shows in the class's Custom CSS instead of its control).
- Head: `271e7815fe06935387bacd208ee8577ef0f0068e` (branch `control-weight-stack12`, on `main` `56a9379f`, Build
  2026-11-10.6; a reviewer is reviewing it beside you; read with `git -C /home/justin/Documents/FigmaToBricksV2 show
  271e7815:<path>`): `src/core/site/inline-own.ts`, `src/core/site/convert.ts` (`prepare`'s class loop), the AC tests
  the plan cites (`test/web/site-range-cancels.test.ts`, `test/unit/site-inline-own.test.ts`,
  `test/unit/site-inline-own-bytes.test.ts`, `test/unit/site-no-revert.test.ts`), fix pass 1's tests
  (`test/web/site-inline-nested.test.ts`; the new tests in `site-inline-own.test.ts`), `docs/HANDOFF.md` (the job's
  section; the merged bullet in staging-fit-cancels' Known limits) and the ledger
  `docs/plans/2026-11-10-control-weight-ledger.md` ("Fix pass 1", "Stack 12": the plan lines to amend).
- Review 1 (`evidence/control-weight/review-1/review.json`), the fixer's and the move's receipts (`fixer-1/`,
  `stack-12/`), `evidence/control-weight/follow-ups.md`; staging-fit-cancels' blind auditor's note recorded there (the
  limit is not specific to 768–991: its pages showed it at 600–899 and at 479 and below).

## What to amend
1. **The base** (Q3 A and every line that names it): the job was built on staging-fit-cancels' head `ce5b38ac`; that
   job merged (Build 2026-11-10.6) and this job now sits on `main` `56a9379f`. AC4's "byte for byte as the base
   tree's" base is `main` (the 47 captures' 376 pastes are equal on `ce5b38ac` and `56a9379f`: `stack-12/pins.md`);
   AC5's golden is main's.
2. **AC1's range words and the playback:** the limit holds wherever a wrapper's words hold the element at some range
   and not at others (768–991 is the fixture's range, not the rule's); state AC1 by its rule on its fixture, and say
   what its test reads (the widths; both Bricks samples). Don't claim ranges the cited test doesn't read: name the
   other ranges under known limits / the verifier's probes.
3. **The nested rule (review 1's R1-1, fix pass 1):** each element inside a moved child takes the parent's reading of
   it in its own class too, at every depth the reading nests, each level under the same proof; an unproved level
   keeps its keys in the top parent's rule as the base wrote them. Put it where the plan states the rule (Approach,
   AC2 / AC3 sentences if their cited tests assert it on the head — check: if only fixer 1's new tests assert it, it
   goes on an "Also (supporting…)" line and you report the gap).
4. **The `alone` variant** (the builder's addition under AC3) and the two gap tests (`leak`, `extra`): named under the
   AC they support.
5. **Known limits as review 1 and the move left them** (one line each with its id): words beside the element (R1-3);
   a tablet-only child never shown elsewhere can pass the count check; the lifted-child condition untested until
   site-native-structure's `lift` is on main (mutant M3 equivalent); mutant N5; the reverse shape; Bricks' Display
   control holding `inline` unverified; footer-icon-list's and the other jobs' readers must read `owners.decls` for a
   moved element. "The next free id at the merge" if the plan names a paste-check id.
- Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved copy wraps over two
  lines whole on one line (say which). Check every AC sentence against what its cited test asserts on the head.

## Output
1. `/home/justin/.hermes/plans/figma-to-bricks/control-weight-amended.md` (the whole plan). Don't touch
   `plan-approved.md`.
2. The regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, what is marked "to be confirmed with Justin", any AC whose cited test doesn't cover its
sentence, receipts that encode an old expectation (with the sorter run on the job's heads `a442672e`, `c1874614`,
`271e7815`), the regex check; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
