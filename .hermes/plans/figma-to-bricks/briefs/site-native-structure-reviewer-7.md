# Role: reviewer (round 7, a delta: the move onto Build 2026-11-11.10 and its meet fixes; report only): site-native-structure

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree (never `git -C` the main folder). Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site;
touch nothing under `~/Downloads`. **Importer rule:** P0–P2 only for bugs a real paste hits, with a concrete scenario; edge cases P3.

## What happened
site-native-structure was accepted (READY FOR THE USER 14/15) on `f86ab19deeef19de5a9ed4a1306b0c99d94eb33e`, built on footer-icon-list's
old head `731707c5`. A finisher moved it with `git rebase --onto` onto main `5bf71692` (11.9), then onto `4f8b61165d98002e64f97aa2e4330f6cf9801c1d`
(11.10), as branch `site-native-structure-final`, head `9043fa88aea926a88e44b94510d423743de78889`. Conflicts: HANDOFF, `site-slider-unchanged`
comments, `site.code-page.sha256.json` (main's side, -elementor sums regenerated). Meet fixes: `e4f51759` (a kept-at-top header with ≥2
sections keeps its root as one Block "Header" carrying the stay class), `602aea15` (scroll lock on each top Section of a lifted part; the
scroll-lock AC1 test reads lifted parts' top Sections as roots), `de067e80` records. Pins re-recorded: AC13 (`0b56df72`), site-menu-motion's
slide pin -elementor sum (`71abfbbb`). Record: `evidence/site-native-structure/stack-8/` (`conflicts.md`, `resolutions/`, `range-diff*.txt`,
`logs/`), receipt `rebase/receipt-9043fa8.log`.

## Check hardest
1. Each hand resolution against both sides; the range-diffs.
2. Where the jobs meet, in Chrome (Bricks 2.4.2 and 2.3.9, 1440 and 390; code-page fixture, a one-section kept header, a two-section kept
   header, a non-sticky header, Justin's B-Dry stand-in): the header sticks as one; nothing moves sideways; a No-scroll Offcanvas holds the
   page; the slide script and its marker work under native structure; media-clickable's Background image settings on native Sections/Blocks;
   footer-icon-list's footer rows ≤2 px; the Header-template paste.
3. The meet fix's rule is general (any site): ≥2 sections + stay class → one labelled Block; 1 section → lifted with the class; no stay →
   lifted. One mutant of your own on it.
4. Pins moved honestly (four-tree proofs in `stack-8/logs/`); the named-only tests the finisher found broken on main too
   (`site-scroll-lock-base`, `site-opens-old`, `site-motion-old`) are main's, not this move's — confirm by running one on main.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-7/review.json` (round 7, a delta from `f86ab19d`; full SHA
`head`), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
4f8b61165d98002e64f97aa2e4330f6cf9801c1d /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`. Load
`requesting-code-review` and `code-review-practice`; read the project skill's `references/testing-pitfalls.md` and
`references/live-site-reading.md` "Code-route paste traps"; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sr7/t1`); scripts under `~/.cache/sr7/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time, each under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; each check; `verdict`; `ac_status`; `skill_lessons[]`, ending with: `MAIN
SESSION: check and save these skill_lessons now.`
