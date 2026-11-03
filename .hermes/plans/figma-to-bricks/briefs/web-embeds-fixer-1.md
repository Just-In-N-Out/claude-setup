# Fixer brief: web-embeds, fix 1 (after the one review)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix the
two real bugs the review found, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill tool;
read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` (the shared Chrome lock line) and `references/live-site-reading.md` ("Mapping into the
Snapshot").

## Start

Your worktree starts at `main`. `git checkout --detach db801e5a6fad9ee9eb81bcb9e151c6f2147b758a`, then
`git switch -c web-embeds-fix-1`. Base stays `89022ab`. Plan: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md`.
Review: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/review-1/review.json` and `…/verifier/` (probe site in
`review-1/probe-r2/`, live captures in `verifier/live/`).

## Fix (verify each on db801e5 first with the reviewer's probe `evidence/web-embeds/review-1/probe-r2/`, RED test, then the fix)

- **R1-1 (P2) `src/web/map/snippets.ts:58`:** a frame made by another company's script that the page's own front-end
  file loads (YouTube's player API, loaded by Elementor's Video widget) is lost: its snippet is only the empty served
  placeholder, so the paste has an empty box and a wrong "add your new site's address" note. Rule: when no script is
  added for a frame the parser didn't make, fall back to the live frame's markup and fill it like a served frame. Test:
  a capture fixture with a script-made player frame in `test/web/capture-embeds.test.ts`.
- **R1-2 (P2) `src/web/map/snippets.ts:59`:** a served frame keeps `src="about:blank"` after a lazy loader swapped it
  (`data-lazy-src` WP Rocket, `data-src` LiteSpeed/Smush). Rule: write the live `src` into the snippet. Test: a lazy frame
  in the same fixture.
- **R1-3 (P2) `src/core/normalise/floating.ts:109`:** fixed boxes a site reveals with its own script are captured at
  `opacity:0; pointer-events:none` (letsgro.ai's dot nav and "scroll to continue"), so the paste writes `_opacity "0"`
  while the panel says they show on every page. ⭐ ruling (not yet confirmed): a site-own floating box captured invisible
  only because a script hadn't revealed it yet is pasted visible and clickable, with a panel note "shown by the old
  site's script after <what you can tell>; check it on the new page"; a box hidden on purpose (no script reveal, e.g.
  `display:none` or a closed menu) stays as captured. AC12 is live and its wording isn't changed (the plan copy is
  read-only); record the ruling in HANDOFF and the ledger. Test: a fixture with a script-revealed fixed box and a
  deliberately hidden one.

**P3s R1-4 … R1-6:** don't fix. Write each as one line in `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/follow-ups.md`
and HANDOFF's web-embeds "Deferred".

## Rules

- Commit each fix (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump
  `BUILD`, don't rebase, never bare `git stash`.
- Gates after the fixes, compared by test name with db801e5: both typechecks, `npm run check`,
  `test/web/capture-embeds.test.ts`, the files the fix touches, AC10's byte-identity receipt (the builder's
  `scripts/base-vs-head.ts`) and AC11's live check on fresh captures (GET only; the builder's `scripts/live-embeds.sh`). Don't re-run the whole test:web or test:browser suite.
- **Chrome:** every Chrome sequence under `flock ~/.cache/f2b-chrome.lock bash <steps.sh>` with a marker process
  `(exec -a 'node --test test/browser/wembeds-fix1.lock' node -e 'setTimeout(()=>{},7200e3)') &` killed at the end; back
  off if a foreign Chrome appears within 2 s. `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wembeds-fix1/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`; git commands as separate plain calls.
- Never write to any WordPress site. Live reads only of the Hostinger site (`?f2b=`) and
  letsgro.ai, GET only; never bdryswi.com.
- Put any summary in your report, not in a separate summary file. Evidence under `evidence/web-embeds/fixer-1/`.

## Report

Branch, head SHA, commits; R1-1, R1-2 and R1-3: fixed (test name, RED log, commit) or rejected (evidence); the follow-ups
written; gate tallies; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
