# Role: reviewer (round 2, Full: a fresh review of the whole story; report only): footer-icon-list

You are a fresh reviewer who never saw the build, the plans' history or the fixes (**Opus 5.5, high**). Review only:
change no source or test, commit nothing, start no agents. Never edit the main folder
`/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them with `git show`). **Never load bdryswi.com,
B-Dry staging** or any live site (local fixture servers, the offline B-Dry stand-in site and saved files only); no
logins; never write to any WordPress site; never run `npm run site:upload` or `site:import` against anything. Nothing
may hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you
didn't start; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for bugs a real site or normal use hits, each with a concrete
real-use scenario (a real site's CSS, a real paste in Bricks); edge cases are P3. **The base's guards hold with this job
on top:** captures made before this build paste byte for byte as before; Figma designs are untouched; nothing the
capture does to a site changes (no extra request, nothing hidden).

## What the job is
B-Dry's footer icon list pasted 69 px taller than the site because the site writes one box side by two names: a reset
by physical names (`margin-top`) and a list rule by logical ones (`margin-block-start`); the paste turned the physical
one into a Bricks class control (printed as `.cls.brxe-<el>`, 0,2,0) that beat the logical one in custom CSS. A Mini
fix (choosing the winner in the conversion) failed review 1 (R1-1: "listed later" isn't the site's winner), so the job
went Full and was re-planned around the **capture's reader recording the winner**: the reader now keeps each box side
and size by one name — the one the site's cascade applied — at every width range, under hover and focus, for
`::before`/`::after` and for inline elements of words, mapping a logical name to its physical side through the
element's computed writing mode and direction (new `src/web/read/code-sides.ts`; edits in `code.ts`,
`code-states.ts`); new captures are marked `web.code.oneName: true`; the conversion no longer picks a winner
(`src/core/site/blocks.ts` back to main's text); captures made before this build paste as before (Q4 A, not yet
confirmed by Justin) with one note ("capture the page again with this build") where an element holds a top/bottom
side or a size by two names with different values (`src/core/site/sides.ts`).

## Inputs
- Approved plan (read-only, the v2 plan; the Mini copy is kept as `plan-approved-v1-mini.md` — not the one to judge
  by): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md` (AC1–AC10; AC6 live).
- Branch `footer-icon-list-fix1`, head `316c5f674888352baa292d9049d3d3237c5457e6` (the gate tree is `a7db0078`; later
  commits are docs), base main `11e885fda5d08863a5875f939085350c007ac732` (Build 2026-11-10.8). In your own worktree:
  `git checkout --detach 316c5f674888352baa292d9049d3d3237c5457e6`, confirm HEAD and a clean status. **Your scope: the
  whole story**, `git diff 11e885fd...HEAD` (the branch was moved onto main four times; only HANDOFF conflicted).
- Review 1 (of the Mini fix): `evidence/footer-icon-list/review-1/review.json` and its probes. The fixer's record (read,
  don't trust): `evidence/footer-icon-list/fixer-1/` (`acs/`, `red/`, `mutation/`, `ac10-g4.log`, `ac1-out-g4/`,
  `suites/`, `shots-final/`), the ledger, HANDOFF's section, `evidence/footer-icon-list/follow-ups.md` (recorded: the
  physical `border` shorthand vs longhand order; `site:check --whole --elementor`'s 64 px page offset;
  `capture-speed-bdry` "AC2" stale against code version 3; two hover looks missing from `site-motion-bdry`'s elementor
  paste on main too). Don't re-report what is recorded unless you rate it higher, with a scenario.
- **The fixer's deviations to judge:** a `NESTED` expansion of `border-block`/`border-inline` before the side rule
  (DevTools doesn't list them as shorthands); two new test files (`site-twice-sides-more`, `site-older-sides-count`);
  **AC10's cited test changed** (claim unchanged: `nodes` and `oneName` left out of the comparison by destructuring
  instead of zeroing; a pair of runs compared; saved captures; `F2B_ONE_SIDE_REUSE`): did the change weaken what AC10
  proves?

## Check hardest
1. **Is the recorded winner the site's?** The reader decides the winner in the capture, from what DevTools reports. On
   pages of your own (local fixtures), against the browser's own computed value for each side at each range and
   state: specificity beating order; `!important` in a stylesheet, in an inline style, and an `!important` losing to
   a later `!important`; `@layer` (an unlayered rule beating a layered one with higher specificity; layer order);
   `:where()` / `:is()`; a shadow-free custom element; `@media` and `@container` ranges; `@supports`; a rule from a
   `<style>` added by script; a user-agent default the site never overrides (e.g. `ul` padding, `p` margins); a
   shorthand (`margin: 0`, `inset`, `padding-inline`, `border`) after a longhand and before; `writing-mode` and
   `direction` set on an ancestor, not the element; a pseudo-element whose writing mode differs from its host's;
   hover and focus looks. For each: the captured name and value, the paste drawn as Bricks 2.4.2 and 2.3.9 print it,
   against the site at three widths. A side that ends with the loser's value in the paste is a real bug where a real
   site writes it (resets plus logical list rules are common: Elementor, Tailwind's preflight, WordPress block CSS).
2. **Older captures stay as they were:** every saved capture under `~/.hermes/plans/figma-to-bricks/evidence/` (input
   files only) and every fixture capture made by main's reader: both routes, both picture modes, both text modes,
   byte for byte main's except the note where the plan says; `oneName` absent = old path, always. A capture made by
   this build converted by main's converter (forward compatibility): what happens? The note's wording is true and
   tells Justin what to do.
3. **The capture is unchanged for a site** but the field and the winner: no extra request, no extra page load, no
   new CDP domain that changes what a page can observe; the capture's time (AC10) against main on a heavy local
   fixture at the same load, alternately, three runs each; the B-Dry stand-in's capture differs from main's only in
   `oneName` and the losing names.
4. **AC1 and AC2 for real:** B-Dry's named whole-page test against a fresh capture of the offline stand-in by head's
   reader (the footer ≤ 2 px at every width; the header and page unchanged); the generic site of AC2. Look at the
   footer pictures (`shots-final/`) yourself and at your own render at 390, 768, 1025 and 1440.
5. **Joins with jobs on main and beside it:** control-weight (on main: `src/core/site/inline-own.ts` has its own state
   reader; its tests pass on head: `site-inline-own*`, `site-inline-nested`, `site-range-cancels`); staging-fit-cancels'
   bounded runs (`site-no-revert` and its golden unchanged); the unmerged site-native-structure and site-menu (no
   shared file expected: say if you find one).
6. **Gates:** both typechecks, `npm run check` (8G scope; by name against main), `npm run corpus` (as main), the five
   Figma replays byte-identical, `test/unit/plugin-convert.test.ts`, the AC files, and the web files the reader
   reaches (`capture-*` readers, `site-code-*`, `site-elementor-*`, `site-page-*`, `site-motion-*`) each alone under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry files 8G; export variables first; no
   `--setenv=PATH`), compared by name with main; known flakes rerun alone before they are judged. Two mutants of your
   own under the cap: the winner taken by source order alone; a logical side mapped without the element's own
   direction.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` ("Writing readers"; "Code-route paste traps") and
`references/rendering-validation.md`. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-2/review.json` (round 2, a full review
from `11e885fd`; `head` the full SHA of your HEAD), then self-check:
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
11e885fda5d08863a5875f939085350c007ac732 /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list` (exit 2
means your file is wrong: fix it).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/fil-r2/t1`,
a separate one per script started at the same time; a Chrome profile under a long TMPDIR dies with "Socket path too
long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one Chrome job at a time, closed after: stop
it by the PIDs of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and
a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc or a shell function may be refused: write such steps to a script
file with Write and run `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a
test is running against. Scripts under `~/.cache/footer-icon-list-review2/`. SIGTERM / 143 / 137 may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). The machine is loaded by other jobs: time
base and head alternately at the same load. Waits under 115 s. The PC restarted three times this week: keep notes and
finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none"; the winner table (shape → captured name
and value, paste against the site at three widths); older captures (byte for byte or what moves); the capture's time
and requests; AC10's test change judged; `verdict`; `ac_status` (per AC: what the review saw); then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
