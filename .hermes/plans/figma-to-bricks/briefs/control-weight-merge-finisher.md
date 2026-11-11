# Finisher brief: after-merge steps for control-weight (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `7ec16d60`
(Build 2026-11-10.7) to `90437f41fe20826125d376821cbabf41d861db54` (`control-weight-stack14`), accepted by
`ac-check.sh --reviews` (ALL ACCEPTED 6/6; no live AC). The main session holds the merge lock (`website-importer`);
don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site; no logins; never
write to any WordPress site; never run `npm run site:upload` against anything. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `90437f41fe20826125d376821cbabf41d861db54`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.7`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.8`, or
   the next free `.N`; if the date has rolled over, `<today>.1`). Run `npm run build` and `npm run check`; both must
   exit 0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit
   suite is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.) Several other agents are running tests and Chrome on this machine: touch none of their
   processes.
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-10-control-weight-ledger.md`).
   - **No paste check is owed** (no live AC; no page Justin has holds the shape): HANDOFF's section must say so and
     must hold no `<… id at merge>` placeholder of this job; every "build set at the merge" / `<at merge>` placeholder
     of this job in HANDOFF and the ledger becomes the new BUILD (leave quoted history as history). Don't take a paste
     check id.
   - **The approved plan was amended (wording only, A1–A14) after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/plan-approved.md` over
     `docs/plans/2026-11-10-control-weight.md` (byte for byte; `cmp` them).
   - **Lines elsewhere in HANDOFF that this job makes stale:** staging-fit-cancels' section (and anywhere else: grep
     for "inline word", "paints `inline-block`", "control-weight") names as a known limit that a link its wrapper
     reads as an inline word at some widths paints `inline-block` there. Add to each such line, in place, that this is
     fixed in Build <BUILD> (control-weight). Reword nothing else.
   - HANDOFF's control-weight section, "Known limits" / "Deferred" / "Not yet confirmed": add each of these if the
     section doesn't already say it, in the section's own style (read the section first):
     - "Not yet confirmed by Justin: Q1 A (for these few elements a property such as Display shows in the class's
       Custom CSS at its width ranges instead of a control) and Q2 A."
     - "A surviving mutant outside the plan (the verifier's `count-size-only`: the count proof without its
       `kids.every(steps.has(i))` check): it differs only inside the 'empty readings' limit; no cited test kills it."
     - "Test gaps (the behaviour holds): the class criterion's cited test runs the `space` variant with Rich Text only
       (Basic Text read directly by the blind auditor: it holds); the fixture criterion's cited test asserts what its
       sibling test collects, so it proves nothing run alone by name: run the whole file; the no-revert criterion's
       receipt must be run with its named-only variables set."
     - "Where the paste can't prove which child is which, the wrapper's kept rule can land on the wrong element (a dot
       hidden in the range drawn with the link's look; a tag shown only in the range giving its look to the link):
       the same on the build before, the plan's known limit (the verifier's `phid`, `pextra`; the auditor's
       `aud-unproved`)."
4. Commit `Build <BUILD>: an element its parent reads as an inline word at some widths carries those widths in its own
   class, so Bricks' class controls can't out-weigh the parent's rule (control-weight)` (plain `git commit -m`, or `-F
   <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md
   or site-check-out), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never
   switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line (`Current build <BUILD>`) and one line at the top of the feature list in the house
     style. A draft; **check every detail against HANDOFF's section and the code (`src/core/site/inline-own.ts`) and
     correct what differs**: "**<BUILD> control-weight (website importer):** on the code route an element its parent
     reads as an inline word at some widths (a link that is a word of its wrapper's line on tablets, its own painted
     button elsewhere) carries those widths in its own class, at every depth the reading nests and across two
     parents' moves, so Bricks' class control (printed as `.cls.brxe-<el>`) no longer out-weighs the parent's rule
     (the link was `inline-block` and its line 28 px taller in the range); where the paste can't prove which child is
     which (a hidden child before it, a hidden wrapper, an element the paste doesn't hold) the parent's rule stays as
     before; pastes without the shape and Figma designs are byte for byte as before. Q1 A (Display in the class's
     Custom CSS for these elements) and Q2 A not yet confirmed. No paste check owed (no page of Justin's holds the
     shape)."
   - **In the 2026-11-10.6 staging-fit-cancels Status line**, the sentence "Known limit: a link its wrapper reads as an
     inline word at some widths paints `inline-block` there (control-weight)." becomes "The link a wrapper reads as an
     inline word at some widths painted `inline-block` there until Build <BUILD> (control-weight)."
   - No new standing rule unless the ledger's "CLAUDE.md lines for the merge finisher" names one (read it; copy what
     it says, checked against the code).
   - The Status list keeps about ten builds: move the oldest line's build into "Older builds" as the house style does
     only if the section says so (read its last bullet); otherwise leave the list.
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/control-weight-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `90437f41`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the CLAUDE.md lines written (or the pending file), then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
