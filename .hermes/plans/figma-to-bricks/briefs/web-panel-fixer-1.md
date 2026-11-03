# Fixer brief: web-panel, fix 1 (after the one review)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix the
two real bugs the review found, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill tool;
read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` (the shared Chrome lock line) and `references/live-site-reading.md` ("Mapping into the
Snapshot").

## Start

Your worktree starts at `main`. `git checkout --detach 8c1e84b371d466f8e3d0ed4ac47b3b8360976674`, then
`git switch -c web-panel-fix-1`. Base stays `89022ab`. Plan: `~/.hermes/plans/figma-to-bricks/evidence/web-panel/plan-approved.md`.
Review: `~/.hermes/plans/figma-to-bricks/evidence/web-panel/review-1/review.json` and `…/verifier/` (probes in
`~/.cache/wpanel-r1/probes/` and `probe-*.txt`).

## Fix (verify each on 8c1e84b first, RED test, then the fix)

- **R1-1 (P2, makes AC7 false) `src/core/snapshot/capture-alts.ts:36`:** a description typed in the panel for a photo the
  old site gave words to (or `alt=""`) is lost on the next conversion, because the capture's `alt:`/`decorative`
  annotation outranks the file's saved description (`normalise/notes.ts:67`), and on a cached upload `uploader.ts:216`
  `syncAlts` writes the old words back to WordPress. Rule: the old site's alt is the starting value; once Justin edits
  or saves a description for that picture, his words win on every later conversion and upload (Figma designs keep their
  current order: annotation vs saved description unchanged for them). Test: the AC7 fixture with a photo that has an
  old alt, one with `alt=""`, and one without, each edited and re-converted; the real plugin-made home capture (demo-1
  `hostinger/home/capture/`) keeps all 31 typed descriptions.
- **R1-2 (P2) `src/ui/capture.ts:90`:** generated font file names lose the family's spaces and glue the style to the
  weight (`Montserrat-700Italic`, `DMSans`), and a WOFF2 is read only by its name (`font-files.ts` `nameParts`), so an
  italic woff2 goes up as family "Montserrat 700Italic", weight 400, upright. Fix the names so `nameParts` reads family,
  weight and style correctly (keep spaces; style as its own word). Test: woff2 and ttf faces, upright and italic, a
  two-word family.

**P3s R1-3 … R1-7:** don't fix. Write each as one line in `~/.hermes/plans/figma-to-bricks/evidence/web-panel/follow-ups.md`
and HANDOFF's web-panel "Deferred".

## Rules

- Commit each fix (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump
  `BUILD`, don't rebase, never bare `git stash`.
- Gates after the fixes, compared by test name with 8c1e84b: both typechecks, `npm run check`,
  `test/browser/panel-capture.test.ts`, the files the fix touches, and the AC5 byte-identity receipt for the five Figma
  files (the builder's script in `evidence/web-panel/builder/`). Don't re-run the whole test:web or test:browser suite
  unless the fix touches files they load.
- **Chrome:** every Chrome sequence under `flock ~/.cache/f2b-chrome.lock bash <steps.sh>` with a marker process
  `(exec -a 'node --test test/browser/wpanel-fix1.lock' node -e 'setTimeout(()=>{},7200e3)') &` killed at the end; back
  off if a foreign Chrome appears within 2 s. `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wpanel-fix1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`; git commands as separate plain calls.
- Never call alttext.ai or WordPress for real; no live site writes. Live reads only of the Hostinger site (`?f2b=`) and
  letsgro.ai, GET only; never bdryswi.com.
- Put any summary in your report, not in a separate summary file. Record shots only under `evidence/web-panel/fixer-1/`.

## Report

Branch, head SHA, commits; R1-1 and R1-2: fixed (test name, RED log, commit) or rejected (evidence); the follow-ups
written; gate tallies; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
