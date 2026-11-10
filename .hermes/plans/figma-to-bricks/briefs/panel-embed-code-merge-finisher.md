# Finisher brief: after-merge steps for panel-embed-code (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `56a9379f`
(Build 2026-11-10.6) to `f961b365ee7305b2a48e459051f8cf4e282bd382` (`panel-embed-code-stack11`), accepted by
`ac-check.sh --reviews` (READY FOR THE USER 10/11; AC11 live, Justin's). The main session holds the merge lock
(`website-importer`); don't touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site;
no logins; never write to any WordPress site; never run `npm run site:upload` against anything. Start no agents.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `f961b365ee7305b2a48e459051f8cf4e282bd382`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it alone, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-10.6`); bump `BUILD` for today's date (`date +%F`; expect `2026-11-10.7`, or
   the next free `.N`; if the date has rolled over, `<today>.1`). Run `npm run build` and `npm run check`; both must
   exit 0 (tsc not found → testing-pitfalls). Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. (If the unit
   suite is killed for memory, check earlyoom and rerun it under `systemd-run --user --scope -p MemoryMax=8G -p
   MemorySwapMax=0`.) **This job changes the Figma panel's website route, so `dist/` changes: that is expected.**
3. Records in the same commit (docs only besides `build.ts`):
   - `git ls-files .superpowers/` must be empty (the ledger is `docs/plans/2026-11-10-panel-embed-code-ledger.md`).
   - **Paste check id:** the next free after 3du. Confirm it is free on main's HANDOFF (`command grep -rhoE
     --exclude-dir=evidence '\b3d[a-z]\b' docs/ | sort -u`) and unclaimed on every local branch's HANDOFF and in the
     plans under `~/.hermes/plans/figma-to-bricks/` (other unmerged jobs write `<… id at merge>` placeholders, so
     expect **3dv**). Replace every `<panel-embed-code id at merge>` in `docs/HANDOFF.md` (the section heading, the
     paste-check line, the end-of-run list entry) and the ledger's own placeholders for this job, and every "build set
     at the merge" / `<at merge>` placeholder of this job with the new BUILD (leave quoted history as history). Its
     live check is AC11 (Justin: a fresh capture of bdryswi.com converted in the Figma panel's website route; the
     pasted page's widgets work and no Code element holds the old site's tracking; the section's own numbered steps).
   - **The approved plan was amended (wording only, A1–A8) after the branch's plan commit:** copy
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md` over
     `docs/plans/2026-11-10-panel-embed-code.md` (byte for byte; `cmp` them).
   - **Lines elsewhere in HANDOFF that this job makes stale:** site-reviews' section (and anywhere else: grep for
     "never the panel's Convert", "the whole collected snippet", "its own job") says that until panel-embed-code
     merges a captured page is pasted with `npm run site`, never the Figma panel's Convert, because the panel's
     website route pastes the whole collected snippet. Add to each such line, in place, that this is fixed in Build
     <BUILD> (panel-embed-code): the panel's website route now pastes only a widget's own code. Reword nothing else.
   - HANDOFF's panel-embed-code section, "Known limits" / "Deferred" / "Not yet confirmed": add each of these if the
     section doesn't already say it, in the section's own style (read the section first):
     - "Not yet confirmed by Justin: (a) a served file that draws its box by itself is pasted, whatever else it does
       (a served tag-manager file that inserts a button as plain markup, or hands its own drawing function to a timer,
       is pasted with the note's closing sentence, and its own tracking runs: reviews 3 and 4, the verifier's
       `tm-markup` page): keep that, or never paste a floating widget's code (always listed); (b) with a code reading
       in the capture, an embed with no `how` is 'add it by hand', not 'capture again'."
     - "A widget served from an address holding a comma (`w.js?v=1,2`, a combined CDN bundle) reads as code with no
       file and is listed, not pasted (review 4, R4-1: the safe side)."
     - "A box whose stack holds only code with no file is rebuilt as 'the old site's own floating box' (no code is
       pasted), an untrue note for a tag manager's widget (R4-3; the same before this job)."
     - "A widget that an inline script configures loses that configuration (the inline script is the page's, not the
       widget's): it pastes without its settings on both routes (the plan's own risk; the blind auditor's page)."
     - "Test gaps (the behaviour holds): an unknown reason throwing is killed only by a supporting test, not by the
       third criterion's cited test (auditor M6); 'two frames accepted' is killed by the first criterion's test, not
       the second's (M8)."
     - "A page that leaves an `Error.prepareStackTrace` returning call sites makes `createElement` throw during
       capture (before this job too)."
4. Commit `Build <BUILD>: a pasted Code element runs only a widget's own code, on the Figma panel's website route and
   on npm run site (panel-embed-code)` (plain `git commit -m`, or `-F <file>`; no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` must not list CLAUDE.md or site-check-out), then `git push`
   (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the
   remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line (`Current build <BUILD>`) and one line at the top of the feature list in the house
     style. A draft; **check every detail against HANDOFF's section and the code
     (`src/core/snapshot/embed-code.ts`, `src/web/read/floating.ts`, `src/core/normalise/floating.ts`) and correct what
     differs**: "**<BUILD> panel-embed-code (website importer):** on both routes (the Figma panel's website route and
     `npm run site`) a pasted Code element runs only a widget's own code: the slot's own served markup, a frame's own
     markup, a frame a script made as it showed; a floating widget's code is pasted only when the file that drew it
     is a tag the old page served and it drew the box by itself (no other file, no code with no file, none of the
     page's own code on its stack: Justin's 'Safe rule'), else it is listed with one sentence saying why; a box the
     site's own script draws through another host's file is rebuilt as the site's own only when it holds just the
     site's links or pictures; what a capture can't prove is an empty box of its size, named; an older capture pastes
     nothing collected ('capture the page again with this build'); the code route's bytes and Figma designs are as
     before. Not yet confirmed: paste a self-drawing served file at all, or always list floating widgets; the
     'unproven, add it by hand' ruling. Paste check **<id>** (AC11, live)."
   - **In the 2026-11-10.2 site-reviews Status line**, the sentence "The panel's website route still pastes the whole
     collected snippet (its own job)." becomes "The panel's website route pasted the whole collected snippet until
     Build <BUILD> (panel-embed-code)."
   - **One standing rule under "Decisions the user made" → "Website captures"** (a new sub-bullet after the two
     there): "**A pasted Code element runs only a widget's own code** (panel-embed-code; Justin, 2026-11-10, 'Panel
     widget code go' and, for floating widgets, 'Safe rule'): never a tracking tag, a tag manager, a loader, a shared
     library, another widget's script or a page script. A floating widget's code is pasted only when the file that
     drew it is a tag the old page served and it drew the box by itself; anything started by a starter script, a tag
     manager or the page's own script is listed with a plain note (add its install code by hand). Where a capture
     can't prove a widget's own code nothing is pasted to run. Both routes read `src/core/snapshot/embed-code.ts`."
   If writing CLAUDE.md is refused, leave exactly those lines in
   `~/.hermes/plans/figma-to-bricks/panel-embed-code-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `f961b365`, `git status` clean but for
   `site-check-out/`, `origin/main` equals `main` after the push.

## Rules
- Never commit CLAUDE.md; never bare `git stash`; never force anything. Don't touch any worktree or other branch. Change
  no source or test file (only `src/shared/build.ts` and docs).
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls.
- SIGTERM / exit 143 / 137 may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).

## Report
The build number, the commit SHA, the push result, the paste check id, the CLAUDE.md lines written (or the pending
file), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
