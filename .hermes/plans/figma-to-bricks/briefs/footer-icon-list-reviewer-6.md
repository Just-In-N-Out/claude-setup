# Role: reviewer (round 6, a short delta: the move onto Build 2026-11-11.8 and two test-only pin commits; report only): footer-icon-list

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
**Time box: 20 minutes.** Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress
site. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`. The machine is loaded (another session runs
6 agents): run at most one Chrome suite at a time.

## What happened
Review 5 was clean (MOVE ON) on `c50916eaad942c55e0868626b5b5c6f7a87bf604` on main `e61c0ca0`. Main then moved to
`20ce41a83a9f30e2805e22fb2f5ee3c8c217d784` (Build 2026-11-11.7 site-sticky-header: `src/core/site/stay.ts` new, `parts.ts`,
a sums fixture, `tools/site-sticky-header-sums.ts`; 11.8 plugin-header-footer-ticks: `src/ui`, `normalise/site.ts`,
understand notes). A finisher rebased the branch `footer-icon-list-final2`, final head
`8490829d8d4124ef5a3fdacb2d806c218ce820c7`: HANDOFF-only conflicts, code identity ALL OK (its proof:
`evidence/footer-icon-list/rebase/gates/identity-20323fe.txt`). It added two **test-only** commits to
`test/unit/site-slide.test.ts` (site-menu-motion's named pin "Justin's scan of today converts byte for byte as on main",
`F2B_SITE_SLIDE_BDRY`): one strips this job's `olderSidesNote` before hashing; `8490829d` also strips 11.7's
`__site-stay-` class and its "stays at the top of the window" note, because that pin fails on main 20ce41a8 itself by
design (probes `rebase/gates/pins/probe-stay-*.txt`). Its receipt `rebase/receipt-8490829.log` ends `EXIT=0`; `npm run
check` rc=0 (`rebase/gates/check-8490829.log`). Justin's rule (memory `notes-only-rebase-rule`, extended to test-only pin
updates a merged feature forces): a short delta review + the receipt, no new verifier/auditor.

## Check (do each yourself)
1. In your own worktree: `git checkout --detach 8490829d8d4124ef5a3fdacb2d806c218ce820c7`; confirm a clean status.
2. Code identity outside HANDOFF and `test/unit/site-slide.test.ts`: the job's diff on `e61c0ca0..c50916ea` equals
   `20ce41a8..8490829d` (drop `^index `/`@@` lines); `git range-diff e61c0ca0..c50916ea 20ce41a8..8490829d`. Any file both
   sides changed: read the merged result (this job's and main's hunks both stand and fit).
3. The two pin commits: test-only, sums not re-recorded; the strips are exact (the note text as the source words it, one
   stay class asserted) and can't hide a real paste difference (payloads and every other note still compared). Run the pin
   with `F2B_SITE_SLIDE_BDRY=/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/builder/bdry-capture.json`
   (read-only) on the head: pass.
4. HANDOFF: main's sections (site-sticky-header 3eb, plugin-header-footer-ticks 3ee, and the earlier 3ea/3ed/3ec) whole and
   exactly as on main, with their check-list entries; this job's section first; no markers; only this job's placeholders.
5. Read the receipt's head line, `EXIT=0` and that no suite reports fail > 0 or a skip of an AC test; you need not rerun
   `npm run check` if its log is for 8490829d with rc=0 (say which you did).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/review-6/review.json` (round 6, a delta: the move
from `c50916ea` on `e61c0ca0` to `8490829d` on `20ce41a8`; `head` the full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
20ce41a83a9f30e2805e22fb2f5ee3c8c217d784 /home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first; load
`requesting-code-review` and `code-review-practice`. Report only bugs real use hits (the importer's one-real-bug-review
rule); edge cases are P3.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fr6/t1`). A `git
archive` scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink `node_modules` in). One plain git command per call, `git -C <absolute path>`; multi-step steps in a
script file run with `bash <file>`. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137 may be an earlyoom kill (check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`). One final report.

## Report (as text; only review.json is written)
Findings one line each or "none"; the code-identity proof; the both-sides files check; the HANDOFF check; `npm run
check`; `verdict`; `ac_status` (the move changes no AC: say so with the proof); `skill_lessons[{skill, lesson, evidence,
enforce}]`; ending with: `MAIN SESSION: check and save these skill_lessons now.`
