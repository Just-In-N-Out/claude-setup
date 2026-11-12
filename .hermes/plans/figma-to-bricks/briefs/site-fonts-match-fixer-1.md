# Role: fixer (Full fix round 1): site-fonts-match — R1-1 and R1-2 (P2)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/live-site-reading.md` fonts lines, `references/testing-pitfalls.md`). Read both `repeat-mistakes.md` files first. Never
load bdryswi.com, B-Dry staging or any live site (Google Fonts only as `site:check` does); never write to any WordPress site; touch nothing
under `~/Downloads`. Commit to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`.

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/review-1/review.json`; probes in `~/.cache/sfr/`)
- **R1-1, P2, `src/core/site/parts.ts:124`:** on the plain route the fonts class keeps the fixed name `site-fonts` (same id) while its
  `@font-face` rules now carry the page's name: two pages of one site → identical class name/id, different contents → Bricks asks
  "Import classes" and either answer leaves one page's site-served words (and icon font) in the fallback. Smallest fix: name the plain
  route's fonts class as the Elementor route does whenever it holds page-named faces.
- **R1-2, P2, `src/web/read/fonts.ts:151`:** a face whose words need two unicode-range files is carried with one file only, and the renamed
  family no longer gets Google's copy that covered the other ranges on the base (probe: Cyrillic words keep only the Latin file). Smallest
  fix: don't carry a family whose picked face group has more than one loaded face (it keeps its plain name and Google's backfill, as before).

## Do
1. Your own worktree: `git checkout -B site-fonts-match-fix1 7b3613446377d596c66a2519897ba70e9fe67bc0`.
2. RED first: R1-1 — two captures of one site (two pages, same faces) on the plain route: the fonts class differs by page (or is equal
  in both name and content) so Bricks never sees one id with two contents; R1-2 — the reviewer's subset fixture (copy from
  `~/.cache/sfr/head/test/fixtures/web/sites/rv-subsets/` into the repo's fixtures) captured fresh: Cyrillic/Latin-Extended words draw with
  the site's/Google's file, not the next font. GREEN with the smallest fixes; mutants for each guard.
3. Gates: `npm run check` (8G scope), every AC test of the plan by name (AC1, AC5 in Chrome), AC7's byte receipt still 20/20 vs base.
   Record in the ledger and HANDOFF. Stop at `ready-for-next-review` with the head SHA.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sff/t1`); scripts under `~/.cache/sff/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time, each under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool; plain `git` in your own worktree. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be
earlyoom: check first.

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; gates; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
