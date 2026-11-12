# Role: reviewer (Full round 1: the whole story; report only): site-fonts-match

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit nothing, start no
agents. Never edit the main folder or other worktrees (plain `git` in your own worktree; never `git -C` the main folder). **Never load
bdryswi.com**, B-Dry staging or any live site (local fixtures and saved files; Google Fonts only as `site:check` already does); no
logins; never write to any WordPress site; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits (a real site scanned, converted with
`npm run site …`/`site:import`, pasted into Bricks 2.3.9/2.4, its words drawn), each with a concrete scenario; edge cases are P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md` (AC1–AC9; AC9 live).
  The job: bdryswi.com's own Roboto 600/ADLaM files answer 403, so its headings show the system sans-serif while the paste showed
  Google's Roboto; fix: the scan pairs each face with its own rule and asks a failed face again at the end (`web.fontsRead: 2`); the
  paste writes a site-served family as `"<page>__<Family>"` (so Bricks' Google scan never adds it), never as a Typography control,
  declares its faces under that name, a failed face as `src: url("data:,")` so words fall to the next font as on the site (Q1 A:
  `FAILED_FACES = "as-site"` in `src/core/site/fonts.ts`), one note per failed face; `site:check` draws a failed face with the measured
  stand-in; older captures, Google-loaded families and Figma designs byte for byte as before.
- Branch `site-fonts-match-build`, head `7b361344` (full SHA with `git rev-parse`), base `e61c0ca091413adfdca3c9b3abe4757ef2fd521f`
  (Build 2026-11-11.6; main has since moved to 11.10 — review against the job's own base). Review `git diff e61c0ca0...HEAD`. Builder
  receipts (read, don't trust): `evidence/site-fonts-match/builder/` (`ac-receipts.md`, logs, AC5 pictures).
- The builder overrode one plan stop (hover/focus looks went through `looksOf(…named(rewrite(…)))`, not `fix`; it applied the same
  rename there, pinned by AC3's hover case): judge it.

## Check hardest
1. Real sites' fonts: a family served by the site in several weights and styles (some loading, some 403), unicode-range splits, a
   variable font file, `font-display`, a family used both from the site and from Google on one page, a site font inside an opened box
   (Offcanvas) or a slider, the one-section route (keeps plain names: does that leave words without a face?), `site:live` unchanged.
2. Bricks' own: the Google scan never adds a renamed family; a Typography control never names one; Theme Style fonts; a re-paste
   over an earlier paste (class names, Bricks asking "Import classes"); Bricks 2.3.9 and 2.4.2.
3. The capture side: the end-of-scan re-ask (requests only GET, under the existing press/refusal rules; time added); `fontsRead: 2` and
   older captures byte for byte (AC7).
4. Where it meets the merged jobs (scroll-lock, sticky-header, menu-motion, footer-icon-list, media-avif-alt): shared files
   `src/core/site/parts.ts`, `open-paste.ts`, `convert.ts`, `src/web/capture.ts`, `assemble.ts`, `snapshot/web.ts` — note conflicts the
   move onto main will meet.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/review-1/review.json` (round 1, full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e61c0ca091413adfdca3c9b3abe4757ef2fd521f /home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match`. Load
`requesting-code-review` and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/live-site-reading.md` (fonts lines) and `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfr/t1`); scripts under
`~/.cache/sfr/s/`; **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests SKIP and exit 0); close
every Chrome you start (`pgrep -f '[u]ser-data-dir=<path>'`); one Chrome suite at a time, each under `systemd-run --user --scope -p
MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write
tool. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o
short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; the override judged; `verdict`; `ac_status`; `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
