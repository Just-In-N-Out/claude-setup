# Role: reviewer (round 4: the moves onto the new main and one small fix; report only): site-slider

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only);
never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** P0–P2 only for bugs a real
site or normal use hits (`npm run capture -- <a real Elementor site>` then `npm run site -- … --elementor`, its
carousels and hero sliders pasted on Bricks 2.3.9 / 2.4 as Slider (Nestable); pastes without a slider and the plain
route as before; Figma designs converting as before), each with a concrete real-use scenario; everything else is P3.

## What happened since review 3 (clean at `a97b102c3e8325394bb9bf9d554245b13fa3d9a8`, on the old main `fd1986dc`)
Three other jobs merged under this one; `main` is now `f708dfb659049db50bb45df8026faabee2ee0ad7` (Build 2026-11-10.2):
staging-fit-capture (a width range read without the site's stylesheets is read again; a capture holding such a range is
refused by `npm run site` / `site:check`), site-faq (a pasted Elementor FAQ opens what the site opens) and site-reviews
(a third-party widget pastes as one live Code element; `siteParts` returns `live`; `site:check` stands in for it). The
job was moved in three steps; the branch to review is `site-slider-stack3`, head
`8a13b71c46b26864e2b29ab08fae5f941c7b040e` (code head `b24c5e4e`; the last commit is the ledger), on `f708dfb6`.
1. **Stack 1** (onto staging-fit-capture + site-faq + site-reviews; receipts
   `evidence/site-slider/stack-1/`: `range-diff.txt`, `changed-commits.txt`, `changed-lines.txt`, `conflicts.txt`):
   three conflicted commits, three files —
   - `src/core/site/convert.ts`: site-reviews' `live?` and this job's `sliders?` were added on the same lines of
     `Prepared` and of `prepare()`'s return; both kept (the return ends `…, elementor, live: liveIds.map((t) => t.id),
     sliders }`);
   - `test/web/lib/site-check.ts` `find()`: site-reviews' `"css" in l` locator line first, then this job's id lookup
     that skips Splide's copies;
   - `docs/HANDOFF.md`: this job's section and end-of-run item first, then the others unchanged.
2. **Fix round 3** (`evidence/site-slider/fixer-3/`): `test/unit/site-slider-unchanged.test.ts` (AC8, "pastes without
   an Elementor slider are byte-identical") missed 12 of 84 comparisons on the stack because its committed sums were the
   old main's output and site-reviews underneath rewords the copied-elements note by design; the fixer regenerated
   `test/fixtures/site-slider-base/site.code-page.sha256.json` and `site.elementor-slider.sha256.json` from the base
   tree's conversion of the saved captures (base and head 28 of 28 byte-identical; a mutant brings back the 12 misses).
   The test is unchanged.
3. **Stack 2** (onto site-faq's build commit and site-reviews' moved head): a pure rebase, 31 of 31 patch-ids equal.
   **Stack 3** (onto site-reviews' build commit; `evidence/site-slider/stack-3/`): one context-only conflict in
   `docs/HANDOFF.md` (this job's lines inserted beside lines main reworded), plus a ledger-only commit.
The approved plan was amended three times, wording only (amendments 1–11 at its top; AC9 now reads a clean B-Dry
capture: the saved stand-in named there until Justin's re-capture exists):
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/plan-approved.md`.

## Scope
- In your own worktree: `git checkout --detach 8a13b71c46b26864e2b29ab08fae5f941c7b040e`, confirm HEAD and a clean status.
- `git range-diff fd1986dc..a97b102c f708dfb6..8a13b71c`: read every commit whose patch changed and the two new commits
  (the sums; the ledgers). Outside `docs/`, the job's own added and removed lines must be the same before and after but
  for the resolved hunks and the two sums files; say so with the commands' output.
- **The two code resolutions, on the head, in full:**
  - `src/core/site/convert.ts`: every reader of `Prepared.live` and `Prepared.sliders` (grep), `siteParts`' return,
    `tools/site.ts`, `tools/site-check.ts`: a page with **both** a live widget and a slider (build a fixture page from
    the repo's `live-widget` and `elementor-slider` / `elementor-swiper8` fixtures, or convert one capture holding
    both) — the slider is one Slider (Nestable), the widget one live Code element, `site:check` holds the slider on
    its first slide **and** stands in for the widget, within 2 px; a live widget inside a slide (what happens, and is
    it sane);
  - `test/web/lib/site-check.ts` `find()`: a served box by `css`, an element by `id` inside a looping slider (never a
    Splide copy), and both on one page.
- **The sums:** regenerate them yourself from a `git archive` of the job's base at the time (`dec9452c`) or of today's
  base `f708dfb6` (say which, and whether they agree) through the conversion of the saved captures, and compare with
  the committed files; the test must still fail when a non-slider paste changes (one mutant on a scratch copy).
- **What the three merged jobs change for this job's own behaviour:** the capture fix's re-read (does a range read
  again still record the slider's settings and slides); site-faq's accordion on a page with a slider; the refusal
  (AC9's named-only test now runs on the stand-in the plan names: run it, 8G, and say what its three tests do).
- HANDOFF: the docs-only resolutions rebuilt as `review-loop.md` "After MOVE ON" says (nothing of the four jobs lost;
  note that two whole-branch `-U0` diffs compare equal only after `index` and `@@` lines are removed).
- Run on the head (4 GB cap, one Chrome job at a time): both typechecks, `test/unit/site-slider.test.ts`,
  `site-slider-unchanged.test.ts`, `site-elementor-unchanged.test.ts`, `test/web/site-elementor-slider.test.ts`,
  `site-elementor-carousels.test.ts`, `site-elementor-swiper8.test.ts`, `site-slider-reset.test.ts`,
  `site-check-settle.test.ts`, and site-reviews' `site-check-live-widget.test.ts` and `site-widget-places.test.ts`.
- A plan line the head makes false is a finding (P3 if the head is right and only the words are behind; say what the
  plan must say).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Site sliders"; the embeds lines) and `references/rendering-validation.md`, the repo
`CLAUDE.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider/review-4/review.json`, then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
f708dfb659049db50bb45df8026faabee2ee0ad7 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-slider` (exit 2 means
your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ssl-r4/tmp`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin` and a scratch tree has
  no `tsc` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). Scripts written with Write; probes
  and logs under `~/.cache/ssl-r4/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
