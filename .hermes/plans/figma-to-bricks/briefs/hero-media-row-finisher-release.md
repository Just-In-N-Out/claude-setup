# hero-media-row — FINISHER release (verified clean → merge)

Role: FINISHER, ChatGPT Sol 6.1 xhigh (Justin's pick). The Agent Defect Loop is complete: **verifier-2 came back CLEAN** on tip `735e725ded9468828b976edc11668e499f9c753e` (base main `93a5d7a`). Run only the project's finish step (figma-to-bricks Step 3 item 7 + Step 4): rebase if main moved, gates, merge lock, ff-only merge, BUILD bump, build, commit, push, CLAUDE.md, verify, remove the copy.

## Release authorization (Justin, 2026-10-22, desktop app)
Justin chose: **"Release: mark Garamond UNVERIFIED, merge + build + push"**. For this release only: the Garamond Condensed font gate is released as **"UNVERIFIED — pre-existing on main, no stand-in, expected set not narrowed"** (same wording as the earlier M1A ruling). Record that in HANDOFF, the ledger and the merge report. Never substitute or narrow fonts.

## Inputs
- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, branch `worktree-hero-media-row`.
- Plan `/Users/justin/.hermes/plans/figma-to-bricks/hero-media-row.md`; verifier-2 report `/Users/justin/.hermes/plans/figma-to-bricks/evidence/hero-media-row/verifier-2/review.json`; finisher evidence `finisher-fix/`, `finisher-fix-2/`.
- Verifier-2 receipts: check 2230 + 6 perf, browser 352/352, regressions 25/25 (R1, R2, V1 closed), 50 predicate probes + 288 sizing cases with no new failures, real debug design passes at 22 widths, same-base corpus: 5 payloads/HTML/reports identical, same 18 v1 issues.

## Do
1. Load `figma-to-bricks` (FINISHER), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`.
2. If main moved past `93a5d7a`: `git rebase main` in the copy (conflicts resolved in the copy, keep both HANDOFF sections), then rerun `npm run check`, `npm run test:browser`, `npm run corpus` (same-base compare; exit 1 pre-existing) on the rebased branch. If the rebase changes any source the feature touches beyond trivial text merges, stop with `status: stopped` and name it (a new verifier would be needed). If main didn't move, still run `npm run check` + `npm run test:browser` once on the final tip.
3. Merge lock (`~/.hermes/scripts/merge_lock.sh acquire ~/Documents/FigmaToBricksV2 hero-media-row`, timeout 1300; confirm completed exit 0, poll if backgrounded), ff-only merge, bump BUILD (read it first: `YYYY-MM-DD.N`), `npm run build`, commit `Build <BUILD>: hero-media-row` with the personal identity (no CLAUDE.md or debug JSON staged), `git push` (main only), release the lock on every path.
4. **Paste check:** take the next free number on main's HANDOFF at merge time (3bd is taken by button-link-routing). The paste check covers: hero on Remanufactured Hydraulic Cylinders at 990/768/600 (picture right, text left, whole words), upright phones stacking, breadcrumb Services aligned on desktop, and the header CSS block saved into Justin's header template (logo visible, phone and button on one line at 990).
5. Update main `CLAUDE.md` "Start here" and "Where things stand" (standing permission; if the write is denied, write `~/.hermes/plans/figma-to-bricks/hero-media-row-claude-md-pending.md` instead, marked to apply after older pending files in build order; never retry or route around). Update `references/rules-summary.md` via skill_manage only if a rule changed (the one-line repair for broken single Latin words and the hero keep rule are new rules).
6. Verify: `git log --oneline -3 main`, main == origin/main, `dist/` rebuilt. Remove the copy and its branch (kill orphaned Chrome first; move a leftover `.superpowers/` to `~/.hermes/backups/figma-worktree-leftovers/`).
7. Mark the plan's found items closed if any; `found_else` for anything new.

Return `{name, status: merged|stopped, build, summary, rulings[], steps_for_justin[], paste_check, last_commit, shots[], stop_reason}`. `steps_for_justin` must include: reload plugin in Figma; Convert and copy the Remanufactured page; paste into Bricks and save; paste the header CSS block into the header template's custom CSS and save (give the block verbatim); LiteSpeed → Purge All; reply **pasted Remanufactured**. Always pass `workdir`.
