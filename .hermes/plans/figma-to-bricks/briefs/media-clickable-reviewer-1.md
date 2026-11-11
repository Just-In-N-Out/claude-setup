# Role: reviewer (Mini round 1: the one full review, plus the verifier's AC work; report only): media-clickable

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder or other worktrees (read them with `git show`). Never load
bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only); no logins; never write to any WordPress
site; touch nothing under `~/Downloads` (Justin's run is copied in `evidence/media-clickable/run/`).

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a real site's capture uploaded with `site:upload`/`site:import`, converted with its
`media.json` and pasted into Bricks 2.3.9/2.4), each with a concrete real-use scenario. Edge cases are P3; a P0–P2 with no
concrete scenario counts as P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/plan-approved.md`
  (AC1–AC7; AC7 live: `not_run`, owed). The job: a box's own media-library background photo becomes Bricks' Background →
  Image setting (`_background.image {id, filename, size, full, url}` plus its size, per Bricks breakpoint in
  `_background:<bp>`) on the box's class; `background-image`/`-size` leave the class's custom CSS; what a setting can't hold
  stays CSS, named in the notes; the test renderer prints `_background` as Bricks does.
- Branch `media-clickable-build`, head `d9a0abae` (full SHA with `git rev-parse`; code last changed `0f9079ce`), base main
  `0248176342c662b821629d462f4d15a2a2a1df98`. In your own worktree: `git checkout --detach <head>`; review `git diff
  02481763...HEAD`. Builder receipts (read, don't trust): `evidence/media-clickable/builder/` (incl. the LP6 test change
  Justin's "go with recommended" granted: Task 4 stops printing an unset `background-position`).

## Check hardest
1. Real backgrounds: Elementor container and section backgrounds (with an overlay `::before`, a slideshow, a video poster),
   a theme's hero, a background a lazy-loader swaps in, a photo with `background-attachment: fixed`, `contain` vs `cover`,
   `position` and `repeat` kept as CSS beside the control, a photo per breakpoint at Elementor's 1024/767 vs Bricks'
   991/767/478 tiers (does a change between tiers stay CSS?), a class shared by several boxes with different photos.
2. Bricks' own print: the control's selector weight (`.cls.brxe-el`) against what stays in the class's custom CSS; the
   control's defaults (`size: cover` when no size) — any box that draws differently in real Bricks 2.4.2 than in the renderer?
   Read `evidence/media-clickable/planner/bricks-2.2-assets.php` L1971–2108.
3. Class renames on the Elementor route (the fingerprint changes for the 25 classes): a re-paste over an earlier paste —
   duplicates? Bricks' "Import classes" prompt? Say what Justin will see.
4. The LP6 change: does the renderer still draw an unset position top-left everywhere it did?

## Verifier's AC work (Mini)
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it: every AC's cited
test on head (pass) and on old code (a `git archive` of `02481763` with head's test files copied in), named-only AC6 by
name with `F2B_MEDIA_RUN=/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/run`, a picture per AC, AC7
`not_run`. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/verifier/ac.json` and logs there (check
the folder is empty first). Gates: `npm run check` on head (8G scope).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/review-1/review.json` (round 1, full SHA), self-checked
with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable`. Load
`requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md` and
`references/testing-pitfalls.md`; read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/mcr/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` tree needs main's `node_modules` symlinked; piped/chained git
commands may be refused (script files, `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long
runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0`; many agents run at once: a timeout under load reruns alone before judging. Pixel checks on B-Dry pastes
need a noise floor (base against itself). SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since
"-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, the real-use scenario) or "none"; per AC: test, head, old code, evidence;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
