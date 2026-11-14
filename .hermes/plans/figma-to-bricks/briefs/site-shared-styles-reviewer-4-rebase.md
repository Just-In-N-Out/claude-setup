# Role: reviewer (round 4, review of the REBASE RESOLUTION onto main; report only): site-shared-styles

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE` from `tools/lib/site-chrome.ts`); never write to any WordPress site; touch nothing under `~/Downloads`.
**Importer rule:** P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases are P3. Keep it to
about 40 minutes. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first (`figma-to-bricks/references/`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Keep the
standard at the top of the repo CLAUDE.md "Decisions the user made" in mind.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md` (AC1–AC15; AC15 live).
- Accepted head `7977b8f8` (full SHA: `git rev-parse 7977b8f8`) on base `84722938b32c82e2dc5041bda6383ac12bf7793d`: ac-check READY FOR THE
  USER, reviews clean. Rebased onto main `392f67e2a6b52c40a64acaf7d344a50c934dee26` (bricks-icons-site: Icons from a site's own SVGs) as
  branch `site-shared-styles-rebased`, head **`f971b30691f6c00c0580793c99c8b415ba9bebe3`** (25 rebased commits ending `b69f662e`, plus
  `f971b306` test-only: `site-icons-pin` switch-off + an on-state golden `test/fixtures/site-icons-shared-on.json`).
- Finisher's records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/rebase/` (`conflicts.txt`, `range-diff.txt`,
  `pins-*.log`, `icons-map-main-vs-head.txt`, `icons-unit-f971b30.log`, `replays-f971b30.log`; a receipt `receipt-f971b30.log` may still be
  running — don't start a Chrome suite while its `receipt.sh` runs; check `/proc/loadavg`). A head start, not proof.

## Check hardest
1. **The source resolution** (`git range-diff 84722938..7977b8f8 392f67e2..b69f662e`, and `git diff 392f67e2..b69f662e` against `git diff
   84722938..7977b8f8`): every difference outside HANDOFF and the pins is a place both jobs met. Above all `src/core/site/class-source.ts`
   `fromStates` (`inner || el === "icon"` → no controls): does an Icon's own class, and any shared-look class that holds an Icon, write no
   Bricks control on the new head as on main (an Icon's Width/Height/Fill typed in Bricks still win — bricks-icons-site's AC3), while shared
   text/button/box classes still write their controls; can two Icons with the same look share one class and draw as on main; does an Icon get a
   palette `var(--color-…)` link where main's icon look test expects a literal, and does it still draw. The auto-merged `kinds.ts`, `parts.ts`
   bodies, `tools/lib/site-write.ts`, `tools/lib/site-import/after-scan.ts`: drawings and palette/styles files both written, notes both kept.
2. **The pin change** `f971b306`: the 24 allowed switch-off sums are exactly Q6 A's Text link → Block `a` + Rich Text (classes identical); the
   on-state golden is made on this tree; a one-byte and an on-state mutant fail it.
3. **Combined behaviour:** on the new head, run `test/web/site-icons-look.test.ts` and `test/unit/site-icons*.test.ts` (Chrome one suite at a
   time, 4G, `SITE_OFFLINE`), and AC4's one-writer check and AC7's draws-the-same check on the icons fixture page
   (`test/fixtures/web/sites/icons-page/`) as well as their own fixtures if the tests allow it: no property written by two classes, 0 px moved
   with the switch on vs off.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/review-4/review.json` (round 4, scope delta, `from`
`7977b8f8` full SHA, full SHA `head`, a `note` saying it reviews the rebase resolution), in review-3's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
392f67e2a6b52c40a64acaf7d344a50c934dee26 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles` and quote its last line; if it
asks for another scope, follow it and say so. Your worktree must be at `f971b306` (`git checkout --detach f971b30691f6c00c0580793c99c8b415ba9bebe3`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sssr4/t1`); scripts under
`~/.cache/sssr4/s/`; **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f`
with a pattern in your own command line); memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'` (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on
PATH) and no repo (set `GIT_DIR`). Use `tail -n 3`. Waits under 115 s. `cancelled 1` is a timeout. SIGTERM/143/137/"Killed": check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
