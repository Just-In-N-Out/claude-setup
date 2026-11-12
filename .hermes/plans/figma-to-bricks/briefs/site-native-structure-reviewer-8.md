# Role: reviewer (round 8, a FULL review of the whole story on today's main; report only): site-native-structure

You are a fresh reviewer who never saw the build, the moves or the fixes (**Opus 5.5, high**). Review only: change nothing, commit
nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder). Never load bdryswi.com,
B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads` (Justin's 2026-11-11 scan: copies in
`evidence/media-clickable/run/` and `evidence/site-menu-motion/builder/bdry-capture.json`). **Importer rule:** P0–P2 only for bugs a real
paste hits, with a concrete scenario; edge cases P3.

## Why a full review
`review-check.sh` refused to chain delta reviews after two `--onto` moves ("review-5's from 731707c is not on --base 4f8b611's history: run
a full review from 4f8b611"). Review the **whole story**: `git diff 4f8b61165d98002e64f97aa2e4330f6cf9801c1d...HEAD`.

## Inputs
- Approved plan (amendment 2, installed): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`; and the
  **held amendment 3 v2** `…/planner-amend-3/plan-amended-v2.md` (sha 753f2745…; AC2's kept-header exception, AC15's B-Dry step) — judge
  the head against v2.
- Branch `site-native-structure-final2`, head `d6f169848744d4f23f8dd2a8b2b6787dae1872f7` (fixer 6: the kept-header root only where two
  pasted top Sections show at one width; spacer copies not counted; R7-1 pinned; HANDOFF step 5 reworded; slide pin -elementor sum
  re-recorded), on main `4f8b6116` (Build 2026-11-11.10). History and findings: `…/site-native-structure/follow-ups.md`; records
  `stack-8/`, `fixer-6/`.

## Check hardest
1. The job itself (Elementor fold to Section/Container/Block, Button, Divider, linked Image; lifted part roots; labels) on real Elementor
   pages, together with every merged job it now sits on: site-scroll-lock (lock on each top Section of a lifted part), site-sticky-header
   (stay class; the kept-header rule), site-menu-motion (slide script/marker in the Offcanvas), media-clickable (Background image settings),
   footer-icon-list (one-name sides), media-avif-alt (none expected).
2. **Amendment 3 v2's re-read list (H1–H8)** in its file: run its probes (`planner-amend-3/receipts-v2/scripts/probe-header.ts`,
   `probe-spacer.ts`) on the head and compare with its expected logs; H3 the note's sentence and N; H4 the supporting tests' cases; H5 B-Dry
   (two top Sections, the bar for each width at the top at 1440 and 390); H6 `grep -c 'both header bars stay at the top' docs/HANDOFF.md`
   is 0; H7 the sorter; H8 AC13's pins file. Say for each: holds or not.
3. In Chrome (Bricks 2.4.2 and 2.3.9, 1440 and 390, one suite at a time): the stay and lock suites, `site-native-stay`, `site-slide-proof`,
   `site-check-lifted`, and a probe of Justin's scan.
4. Pins moved honestly; named-only tests of merged jobs that fail on main too (`site-scroll-lock-base`, `site-opens-old`, `site-motion-old`)
   are main's: confirm on main.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-8/review.json` (round 8, **scope full**, from `4f8b6116`;
full SHA `head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
4f8b61165d98002e64f97aa2e4330f6cf9801c1d /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`. Load
`requesting-code-review` and `code-review-practice`; read the project skill with `references/testing-pitfalls.md` and
`references/live-site-reading.md` "Code-route paste traps"; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sr8/t1`); scripts under `~/.cache/sr8/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; each Chrome suite under `systemd-run --user
--scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry 8G). Write
scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; H1–H8 each holds or not; `verdict`; `ac_status`; `skill_lessons[]`,
ending with: `MAIN SESSION: check and save these skill_lessons now.`
