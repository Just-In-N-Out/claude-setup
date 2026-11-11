# Role: reviewer (Mini round 1: the one full review, plus the verifier's AC work; report only): site-sticky-header

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder or other worktrees (read them with `git show`). Never load
bdryswi.com, B-Dry staging or any live site (local fixtures and saved files only); no logins; never write to any WordPress
site; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (a real site's capture converted with `npm run site …`/`site:import` and pasted into Bricks
2.3.9/2.4, in the page or in a Header template), each with a concrete real-use scenario. Edge cases are P3; a P0–P2 with no
concrete scenario counts as P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`
  (AC1–AC9; AC9 live: `not_run`, owed). The job: a scanned header that the site's script keeps at the top (capture mark
  `web.position: "fixed"`, not fixed by the site's own CSS) gets one class `<page>__site-stay-<4>` on the header root:
  `.N.N { position: sticky; top: var(--wp-admin--admin-bar--height, 0px); z-index: 100 }`, `#brx-header:has(.N) {…}`,
  `html:root, html:root > body { overflow-x: clip }`; one note; nothing else changes.
- Branch `site-sticky-header-build`, head `ad041d3d` (get the full SHA with `git rev-parse`), base main
  `0248176342c662b821629d462f4d15a2a2a1df98`. In your own worktree: `git checkout --detach <head>`; review `git diff
  02481763...HEAD`. Builder receipts (read, don't trust): `evidence/site-sticky-header/builder/` (`AC-evidence.md`,
  `mutants/`, `logs/`, `shots/`).
- Shares `src/core/site/parts.ts` with site-scroll-lock (branch `site-scroll-lock-build`, a lock class second on each part
  root with `html, body { overflow-x: clip }` and Bricks `no-scroll` rules): read both; say whether the two meet cleanly and
  whether the header still sticks with both classes (AC2 claims it).

## Check hardest
1. Real headers: Elementor Pro sticky (script `position: fixed` + spacer), a theme's JS sticky, a header the site's CSS makes
   sticky or fixed (must stay as before), a header that only sticks after scrolling a while, a header with a top bar above
   the sticky bar (two bars: which one sticks?), a transparent header over the hero. Pasted in the page and in a Header
   template, with and without the WordPress admin bar (logged in), at 1440 and 390.
2. `z-index: 100` against the paste's Offcanvas/pop-ups (site-menu: menus at 9999?), the ☰ drawer opening over the stuck
   header; the page's own anchors (`#section`) landing under the header.
3. The `overflow-x: clip` guard: does it change anything else on a page (a wide slider, a hero image meant to bleed)?
4. The sums regenerated for the code-page fixture: honest (each variant differs only by the class and note)?

## Verifier's AC work (Mini)
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it: every AC's cited
test on head (pass) and on old code (a `git archive` of `02481763` with head's test files copied in), a picture per AC,
AC9 `not_run`. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/verifier/ac.json` and logs
there (check the folder is empty first). Gates: `npm run check` on head (8G scope).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-1/review.json` (round 1, full SHA), self-checked
with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header`. Load
`requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/live-site-reading.md` and
`references/testing-pitfalls.md`; read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/shr/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` tree needs main's `node_modules` symlinked; piped/chained git
commands may be refused (script files, `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long
runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run --user --scope -p MemoryMax=4G -p
MemorySwapMax=0`; many agents run at once: a page-load timeout under load reruns alone before judging.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, the real-use scenario) or "none"; per AC: test, head, old code, evidence;
`verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
