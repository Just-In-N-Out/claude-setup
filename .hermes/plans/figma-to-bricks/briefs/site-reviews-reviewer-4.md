# Role: reviewer (round 4: the rebase onto the stack only, report only): site-reviews

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging, an embed host or any live site (local stand-ins and saved
files only); never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** P0–P2 only for bugs a real
site or normal use hits, each with a concrete scenario; everything else is P3. What may run on Justin's site after a
paste, and what a capture sends to a site, stay the things to check hardest.

## What happened
site-reviews was review-clean (review 3) at `6fb06ea2b1d3f451d3a3a6c51cd53915fca0b117` on the old `main` `fd1986dc`.
`main` moved to `3cfc54ac` (Build 2026-11-09.4, staging-fit-capture: a width range read without the site's stylesheets
is read again, a capture that never gets them stops, a capture holding such a range is refused). A finisher rebased
three jobs into a stack: `main 3cfc54ac ← site-faq-stack1 (143a4e19) ← site-reviews-stack1 ← site-slider-stack1`.
This job's rebased branch: `site-reviews-stack1`, head `dec9452cbf28b25709d44e829b86bc0c7e91837e`, on
`143a4e19a6428e961c29a5f16f5cd715da91b7c1`. The finisher reports two conflicted commits, three files, plus one new last
commit adding only a "Stack 1" section to the job's ledger:
- `docs/HANDOFF.md`, two places: site-reviews' section and item first, then site-faq's and main's unchanged.
- `src/web/capture.ts`: imports only; main's three and the job's one all kept.
- `src/web/session.ts`: **one field name was used for two different facts.** Main added `Session.answered = false`
  (the tab was answered from the kept page; `styled.ts` reads it); the job had added `Session.answered: string | null`
  (the body the tab heard, read only through `served()`). Resolution: main's field stays as main has it; the job's
  field is renamed `heardBody` in its three places; the kept-page branch keeps the job's shape with main's
  `s.answered = true` inside it. One of the three places (`s.answered = mine ? mine.body : null`) had merged with no
  conflict mark and would have overwritten main's boolean; the finisher fixed it in the same commit.
- A context-only patch change in `tools/site-check.ts` (`8cf5362e` → `4275521b`).

## Scope (only this)
- In your own worktree: `git checkout --detach dec9452cbf28b25709d44e829b86bc0c7e91837e`, confirm HEAD and a clean status.
- `git range-diff fd1986dc..6fb06ea2 143a4e19..dec9452c`: read every commit whose patch changed. Outside `docs/`, the
  job's added and removed lines must be the same before and after but for the `session.ts` rename
  (`evidence/site-reviews/stack-1/changed-lines.txt`, `conflicts.txt`, `range-diff.txt`: read, don't trust).
- **`src/web/session.ts` and everything that reads either fact, in full on the head:** every use of `answered` and of
  `heardBody` across the tree (`grep`), `styled.ts`' reading of `answered`, `served()` and its callers. Is any place
  still writing a body into `answered` or a boolean into `heardBody`? Does the capture fix still re-read a range whose
  stylesheet failed, and stop when it never arrives, **with this job's "hearing every document answer" on top** — and
  does this job still hear the served page when a load is repeated by the capture fix (the re-read) or answered from
  the kept page? A served page heard from a styleless load, or the embeds read from a load the capture fix then
  discards, would be a real bug: probe it with a fixture whose stylesheet fails on chosen page loads and which holds a
  live widget (the fixtures under `test/fixtures/web/sites/` and `test/web/capture-styled-ranges.test.ts`,
  `capture-live-widget.test.ts` show how).
- `src/web/capture.ts` imports; `tools/site.ts` / `tools/site-check.ts`: main's refusal intact and this job's stand-in
  for a live widget intact.
- HANDOFF: the docs-only resolution rebuilt as `review-loop.md` "After MOVE ON" says (nothing of the three jobs lost).
- The finisher's gates (read): `evidence/site-reviews/stack-1/logs/`. Its named-only AC7 misses 1 of 80 goldens made
  from the old main, because site-faq underneath changes that one part by design
  (`evidence/site-reviews/stack-1/ac7-probe/compare.txt`): confirm that reading (site-faq's head against this head:
  every payload byte-identical) or say what else differs.
- Run on the head yourself (4 GB cap, one Chrome job at a time): both typechecks, `test/unit/web-served-page.test.ts`,
  `test/web/capture-live-widget.test.ts`, `capture-styled-ranges.test.ts`, `capture-styled-loads.test.ts`,
  `human-check.test.ts`, `capture-lost.test.ts`.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds lines); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-4/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
143a4e19a6428e961c29a5f16f5cd715da91b7c1 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews` (exit 2 means
your file is wrong: fix it; if the script objects to the base, say so and report its output).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-r4/tmp`,
its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome
you start; a worktree's `node_modules` may lack `.bin` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH). Scripts written with Write under `~/.cache/srv-r4/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u
earlyoom --since "-30 min" -o short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: unchanged by the
rebase, or what you saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
