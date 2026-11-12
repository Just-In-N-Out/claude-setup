# Role: fixer (fix round 1): site-shared-styles — em line heights stay relative (R1-1), plus the import steps (R1-4, R1-5)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`, `references/live-site-reading.md` "Code-route paste traps"). Read both `repeat-mistakes.md` files
first. Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads` (Justin's
scan copy: `evidence/media-clickable/run/`). Commit to your branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md;
never bare `git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another
command; no heredocs that write files — use the Write tool).

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-1/review.json`; scripts `~/.cache/ssr1/s/`, logs `~/.cache/ssr1/out/`)
- **R1-1, P2, `src/core/site/looks.ts:67`:** a text class holds the px line height the browser computed where the element's own rule wrote it
  relative to its size (the site's `1.3em` → `26px`), so changing the class's font size — the edit the job exists for — no longer moves the
  line height. Justin's scan `--elementor`: 6 of 17 text classes, 33 elements; `home__heading-mhrv` 20 → 32px keeps 26px and 10 of 12 headings'
  lines overlap 6 px. Fix: a line height or letter spacing the element itself declares at every range in em, % or unitless stays as written in
  the look (and two elements share only where their written values agree); keep 0 differences in drawing (switch off vs on) on Justin's scan
  and the B-Dry stand-in, both routes. Prove the edit: a size edit on the class moves the line height as it did on the own class before.
- **R1-4, P3 (take it), `tools/lib/site-import/next.ts:26`:** `site:import`'s numbered Next steps never name importing `palette.json`, and say
  "choose Accept" on "Import classes", which replaces a shared class he changed (HANDOFF says keep). Make the steps say: import `palette.json`
  in Bricks → Style Manager → Colors first; on "Import classes" choose the option that keeps his classes (read Bricks' wording from
  `reference/bricks/README.md` or Bricks' code; never from memory).
- **R1-5, P3 (take it), `docs/HANDOFF.md:20`:** add the steps for a re-scan that finds a new colour (Bricks refuses a palette name the site
  already has; delete the palette first and import again — every link keeps working because ids come from the hex).

Leave R1-2 (font-family vs site-fonts-match's rename: handled when this job moves onto main) and R1-3 (P3, follow-up).

## Do
1. Your own worktree: `git checkout -B site-shared-styles-fix1 e124dcdacdd9521246de4bf375424680a875535a` (on site-no-div `d915f7dc`).
2. Each finding: verify with the reviewer's probe, RED test first, GREEN, a mutant per new guard. Rerun AC1–AC14 by name (named-only with
   their variables; AC11 8G), and the switch-off vs on drawing on Justin's scan (0 differences). Pins re-recorded only by their own tools,
   saying how many moved and why.
3. Gates: `npm run check` (8G scope); `test/web/site-shared-styles*`, `site-cli`, `site-page-cli`, `site-import-*`, one Chrome suite at a time
   (4G). Ledger "Fixer 1" and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssf1/t1`); scripts under `~/.cache/ssf1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait).

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; pins moved and why; gates; `skill_lessons[]`, ending with: `MAIN SESSION: check and
save these skill_lessons now.`
