# Fixer brief: web-embeds, fix 2 (after the one review)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix the one real case the verifier found, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development` and `engineering-best-practices` with the Skill tool;
read the project skill with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/testing-pitfalls.md` (the shared Chrome lock line) and `references/live-site-reading.md` ("Mapping into the
Snapshot").

## Start

Your worktree starts at `main`. `git checkout --detach 5e3fea8efa923deaa046725db5bf20b7725bbde4`, then
`git switch -c web-embeds-fix-2`. Base stays `89022ab`. Plan: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md`.
Verifier report: `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/verifier-2/` (`ac.json`, probes, the `late` fixture
runs).

## Fix (verify on 5e3fea8 first with the verifier's probe `evidence/web-embeds/verifier-2/probe-r1-pure-5e3fea8.txt`, RED test, then the fix)

- **The Yoast case (verifier 2, found_else 1):** R1-1's fallback (a player frame built by the page's own script pastes as
  its live frame) still fails when any inline script on the page names the player's host: rule (b) then wins with
  `how: "host"`, the snippet is the empty placeholder plus that inline script, the video is lost, and the old site's
  whole Yoast schema JSON-LD (whose `sameAs` lists `https://www.youtube.com/@…`) is pasted into the new page. Analytics
  data layers do the same. A business site with its YouTube channel in Yoast and a video widget is common. Rule: a
  script that isn't JavaScript (`type="application/ld+json"` or any non-JS type) is never a widget's script and never
  pasted; an inline script only counts for rule (b) when it is JavaScript that loads or calls the widget's host, not a
  mention of it in data; when no counted script is served, R1-1's live-frame fallback applies. Test: the `late`
  fixture (or a sibling) with a Yoast-style JSON-LD block and a data-layer script both naming `https://www.youtube.com/`,
  plus the player widget: the paste holds the live player frame and no schema or data-layer script.

## Rules

- Commit each fix (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump
  `BUILD`, don't rebase, never bare `git stash`.
- Gates after the fixes, compared by test name with 5e3fea8: both typechecks, `npm run check`,
  `test/web/capture-embeds.test.ts`, the files the fix touches, AC10's byte-identity receipt (the builder's
  `scripts/base-vs-head.ts`) and AC11's live check on fresh captures (GET only; the builder's `scripts/live-embeds.sh`). Don't re-run the whole test:web or test:browser suite.
- **Chrome:** every Chrome sequence under `flock ~/.cache/f2b-chrome.lock bash <steps.sh>` with a marker process
  `(exec -a 'node --test test/browser/wembeds-fix2.lock' node -e 'setTimeout(()=>{},7200e3)') &` killed at the end; back
  off if a foreign Chrome appears within 2 s. `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`, Node
  `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/wembeds-fix2/tmp`). Write multi-step
  scripts with the Write tool and run `bash <file>`; git commands as separate plain calls.
- Never write to any WordPress site. Live reads only of the Hostinger site (`?f2b=`) and
  letsgro.ai, GET only; never bdryswi.com.
- Put any summary in your report, not in a separate summary file. Evidence under `evidence/web-embeds/fixer-2/`.

## Report

Branch, head SHA, commits; The Yoast case: fixed (test name, RED log, commit) or rejected (evidence); the follow-ups
written; gate tallies; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a
one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
