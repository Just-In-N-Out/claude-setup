# VERIFIER (read only): web-capture (J1 of the website importer, FigmaToBricksV2)

You are a fresh, independent verifier (Opus 5.5, xhigh). You never saw this build. Prove every acceptance criterion
yourself on the final code and on the old code. Read only: change no source or test, commit nothing, don't rebase or
merge, don't edit skills or memory, don't start other agents. Write only into
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/verifier/` and your own scratch folder `wcap-verifier/` (created
fresh with `mkdir`, no `-p`) under the session scratchpad
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/519648e7-1ba1-46ba-a0a3-91e300b908f4/scratchpad`. Point
`TMPDIR`, Chrome profiles and built trees at `/home/justin/.cache/wcap-verifier/` (keep `TMPDIR` short, e.g.
`/home/justin/.cache/wcap-verifier/tmp`: Chrome fails with "Socket path too long" inside the scratchpad). Copy every
scratch script into `<your evidence>/scripts/` as soon as you write it: a session restart empties the scratchpad.

Justin (2026-10-31) said to build the whole importer "straight through" with the recommended answers: never stop to
ask; report what you find.

## Step 0: your copy
You start in your own throwaway worktree (`isolation: worktree`, made from `main` at `04ab9b1`). In **your own**
worktree run `git checkout --detach 3705de1cf7a9174f189b59e42f7d70045781ffd2` and confirm `git rev-parse HEAD`, a clean
`git status --porcelain --untracked-files=all` (CLAUDE.md is excluded) and `git merge-base HEAD main` =
`3ea33bba9cf413d929923992431e0145bac07477` (the story's base; `main` has moved on since, which is the finisher's
rebase, not yours). Never write or run commands in any other worktree. The job's canonical copy is
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-aa8fc9df89fe1fe2f` (branch `web-capture-fix-8`, head
`3705de1`): your `ac.json` must name that head and base `3ea33bb`. If the checkout is refused, stop with the exact
message.

## What to verify
- **Approved plan (the oracle, read only):** `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`,
  AC1–AC14, its ⭐ answers taken under the away grant. Format spec `docs/specs/web-capture.md`. Never change an AC's
  id, oracle or live tag. The plan has no `(live)` AC.
- **What the job is:** `npm run capture -- <url>` reads a live web page (header, page, footer as tagged parts, every
  switch point, stretchy values, pictures, fonts, links, floating extras) into one capture file the plugin's
  `loadSnapshot` reads and replays like a Figma debug file. `src/web/` is never imported by `src/core`, `src/plugin`,
  `src/shared` or `src/ui`; Figma replays stay byte-identical.
- **AC14 and bdryswi.com:** bdryswi.com serves a bot-check page to automated Chrome. **Never load it** and never try to
  hide automation (Justin still owes the allow-list). Prove AC14 on what can be run: the reachable corpus homes
  (`https://www.letsgro.ai/` and the plugin-made Bricks site), `F2B_WEB_CAPTURES` set as the test expects, `skipped 0`.
  Say plainly in `ac_status` and `qualifications` what you could not run and why; judge AC14 by the plan's text.
- **Base has no `src/web`:** head's tests fail on base at import. Follow `ac-verification.md` on what a base failure
  must show; where a new-behaviour AC can only fail at import, say so, and probe the clause another way (a mutant in
  your own scratch copy) so the test is proven able to fail for the intended reason.

## Author leads (claims to check, not proof)
- Build: builder (`c0f0529`), nine review rounds (`review-1/` … `review-9/` under
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/`, each `review.json` and referee output; `justin.json` from
  review 5 on), eight fix passes (`fixer-1/` … `fixer-8/answers.md`). Review 9 at `3705de1`: `MOVE ON` (clean);
  its three P3s are in `follow-ups.md`. Use these only as leads; don't copy or hard-link any earlier receipt.
- **Rulings not yet confirmed by Justin** (in HANDOFF and the fixers' answers): F29 scroll-through triggers, F31 timer
  pop-ups read open, F32 the capture never moves the pointer onto the page (a `mouseWheel` only), F35 an endless
  pulse or blink holds the entrance wait to its 6 s cap (an accepted limit, with a note), F36 the listeners note leaves
  out `touchstart`. A ruling that fits the plan's text isn't a failure; one that contradicts an AC is.
- The regression corpus of rounds 2–9 (`review-*/probe/`, the fixers' `reveal/*` fixtures) is there to reuse as probes.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md`
   (VERIFIER role), `references/live-site-reading.md` and `references/testing-pitfalls.md` before any receipt,
   mutation run or browser measurement.
2. `engineering-best-practices`.
3. `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the VERIFIER step and the
   run recipe) and the ac.json schema at the top of
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.
4. `mutation-testing-discipline` where you need to test whether a check can fail.

## Independent work
1. **Gates on head:** typecheck (both configs), `npm run check`, `npm run test:web` (`skipped 0` apart from the
   env-gated AC14 test, which you run separately with its variable), the full browser suite on head and on a **built**
   base tree (`npm run build` first: panel tests read `dist/ui.html`), compared by complete test name (no new failure,
   no lost test, no new skip); corpus-backed unit tests in scratch `git archive` trees of head and base with
   `corpus.json` re-pointed to local files (memory note
   `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Record every true
   exit code.
2. **Each AC1–AC14 alone:** its named test(s) by themselves on head (Chrome tests must print `skipped 0`), then the base
   check above. Then challenge each AC's clauses with your own probes on generic fixture sites you write: other switch
   points (1024, 921, 767, 544), `clamp()`/`vw`/`%`/`var()` sizes, a failed font face, a cookie bar and a chat
   bubble, in-out-in entrances, a pulse, a page with a slider. Nothing keyed on one site's words, colours or sizes.
3. **Blast radius (AC7/AC8):** replay the five real Figma files on head and base (`corpus/files/hydraulics-home.json`,
   `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`,
   `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services via `git show 2199895:figma-to-bricks-debug-page-1.json`
   into your evidence folder): byte-identical payloads and warnings. No import of `src/web` from core/plugin/shared/ui.
4. **Live reads (GET only):** `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
   `https://www.letsgro.ai/`. Never write to any WordPress site. Justin re-pastes the plugin-made site sometimes:
   compare a live difference against a capture of base-era behaviour taken the same day before blaming the code. The
   Hostinger site can stop answering for about a minute after back-to-back reads: check with one curl and re-run.
5. **A fresh screenshot per AC in your own folder:** the real rendered page for a visual AC; for a non-visual one, a
   Chrome screenshot of your terminal output (ac-verification.md's recipe).
6. Write `<your evidence>/ac.json` (ac-check.sh's schema, head `3705de1`, base `3ea33bb`) and `<your evidence>/report.json`.
   Self-check by running `ac-check.sh` on a copy of your own files only, `--repo` your own detached worktree.
   **Clean** means AC1–AC14 accepted and every gate qualified; a valid failure gets an exact repro and evidence. Don't
   finish clean just because the named tests are green if one of your probes disproves an AC.

## This machine (WSL)
- Chrome: `CHROME_PATH=/home/justin/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  with `/home/justin/.local/node-v22.23.3/bin` first on PATH; the same wrapper on head and base. Never kill browsers
  globally; kill only processes with your own profile. A browser or web run counts only with `skipped 0`.
- `npm run corpus` finds no files here (Mac paths). Never edit `corpus/corpus.json` in any worktree.
- Worktree guard: Bash is refused when it can't be proven to stay in your worktree (shell variables or loops around
  `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text, the word
  `source` anywhere, even in a path). Write scripts with Write and run `node <absolute script> <absolute args>`, one
  plain command per call (a plain `bash <script>` in its own call is allowed). Long runs as a script with
  `exec > <log> 2>&1` and `trap 'echo EXIT=$?' EXIT`; poll in chunks under 170 s.
- Another job (`web-compare`) is being fixed in its own worktree at the same time: leave it alone.

## Return (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], ac_status[{ac, accepted,
test, evidence, screenshot}], gates[], qualifications[], found_else[], skill_lessons[{skill, lesson, evidence,
enforce}]}`. `enforce` is `none` or a one-line check proposal. An empty skill_lessons list is normal. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
