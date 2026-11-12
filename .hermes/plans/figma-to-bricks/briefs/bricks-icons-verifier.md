# Role: verifier (read-only): bricks-icons (M1, the Figma plugin half)

You are a fresh verifier who never saw the build, the fix or the reviews (**Opus 5.5, high**). Prove each acceptance criterion yourself.
Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main
folder). Never load any live site; never write to any WordPress site. The verifier folder `evidence/bricks-icons/verifier/` is empty: check
before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/rendering-validation.md` (inline-svg lines) and
`references/testing-pitfalls.md` (CHROME_PATH, renderer printer order). Read both `repeat-mistakes.md` files first. Don't read builder's,
fixer's, planner's or reviewers' reports or folders as proof.

## Inputs
- Approved plan (amendment 1 installed, read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md`
  (AC1–AC7; AC7 live; its Amendments list names which older receipts are stale).
- Head `c78fa0cfcbc7ce9a9b9689613274f633130012ef` (branch `bricks-icons-fix1`), base `0248176342c662b821629d462f4d15a2a2a1df98`. Old code: a
  `git archive` of base with head's test files and fixtures copied in. AC logs start `HEAD=<sha>` ("archive" on line 2), end `EXIT=`.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the full `test:web` and `test:browser` file by file, one
   at a time, each under a 4G scope (failures that fail on base too are base's: show both); `dist/` and the five corpus replays with Icons
   off byte for byte base's; `npm run corpus` no worse.
2. Every AC's test on head (pass) and on old code (fail, or a mutant where the AC is a "byte for byte" one); AC3's story pin with
   `F2B_STORY_PINS=1`. A picture per AC (AC4/AC5: picture vs Icon at the six widths, then the shrink edits — Width alone, Height alone, both
   — on Bricks 2.3.9 and 2.4.2 CSS).
3. Your own checks: one Figma fixture of your own (an icon in a crowded row, an icon with a hover change, a self-drawing stroke, a drawing
   with a gradient) — which become Icons, which stay pictures, and that nothing moves at paste.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/verifier/ac.json` and logs there; self-check with `ac-check.sh` on a
   copy (`--base 0248176342c662b821629d462f4d15a2a2a1df98`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/biv/t1`); scripts under `~/.cache/biv/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start
(`pgrep -f '[u]ser-data-dir=<path>'`); one Chrome suite at a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p
MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool. Use
`tail -n 3`. Waits under 115 s; long suites with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates by name; own checks; `verdict`; `ac_status`; `skill_lessons[]`, ending with:
`MAIN SESSION: check and save these skill_lessons now.`
