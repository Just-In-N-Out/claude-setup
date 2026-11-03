# Prepare branch for authorized review4 and verification; MERGE HELD

Fresh pipeline_finisher, preparation only. No agents. You are not alone: preserve others' work and accommodate it. Own W's story branch and E/integration-prep-2/private disk scratch only; main is READ ONLY.

Justin's latest instruction, verbatim: "do the 4th review then finish idnependent verification then wait for me to tell you to merge". This explicitly replaces automatic merge/release. No main merge, BUILD bump, release push, main edits, or live/Figma/media writes. Prepare current branch only; root will run review4 → verifier → blind auditor → ac-check and then STOP for Justin.

W `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/dark-structure-recognition`, branch worktree-dark-structure-recognition.
M `/home/justin/Documents/FigmaToBricksV2` READ ONLY.
E `/home/justin/.hermes/plans/figma-to-bricks/evidence/dark-structure-recognition`.
Starting clean HEAD `72dd5d549ffc89e36e6dd3f5e1207a97a76524cb`.
Old integration base `b09727fde8c2fcca2fe1b8d5a46891941a0b9dc1`; last reviewed head `dbbfe0c6f115db6110a27308758087628cf5485a`.
Observed local main `6cfd3e6681b7d0e121173ed746ab49206c672c4e` (read current main before rebase).
Approved plan E/plan-approved.md, SHA25623fe2fb95ab2311819000091925656fea9753555fe4c10ce9fa663f34078b511, unchanged.
Final repair E/fixer-3/report.md, summary.json, ac-status.json; completed review3 E/review-3/review.json/report.md. Prior integration E/integration-prep/report.md is historical reference only.

Load engineering-best-practices, git-commit-rules, project `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with relevant testing pitfalls. Confirm clean state and pin current local main, then rebase this branch onto it so conflicts are covered by the authorized fourth review. No fetch/pull/force/stash, no other worktree changes. Preserve both sides on conflicts; record precise conflicts/resolutions and expected main/story union. Main changed HANDOFF and ir.ts among other independent files. Do not add new behavior or fix unrelated defects. Preserve frozen plan/input hashes and current main's BUILD. Main itself and its status must remain unchanged.

Produce range-diffs both old-base..starting-head and old-base..last-reviewed-head against new-main..final-head. Review4 is normally a delta of the rating repair plus any integration resolution; root/reviewer own referee coverage. Never claim that rebased changes are already reviewed. Include only necessary HANDOFF/ledger integration records before review4, avoid later gratuitous record commits. Ledger already docs/plans/2026-10-31-dark-structure-recognition-ledger.md. Provisional paste3cw must be checked for collisions in current main; do not allocate final release number or bump BUILD while merge held.

Run required in-copy npm run check and npm run corpus, affected recognition tests and conflict-specific checks on the integrated branch. Preserve exact configured vs qualified results, inherited failure identities/skips and unavailable inputs/fonts. No baseline rewriting, fake green or using missing fixtures as behavioral RED. Full corrected-head browser suite remains owned by the subsequent verifier; do not launch another broad paired browser run here without a concrete new concern. No acceptance/merge eligibility claim.

All eight approved criteria remain: recognition-header-ownership; recognition-header-actions; recognition-footer-navigation; recognition-review-candidate; recognition-preservation-matrix; recognition-panel-contract; recognition-browser-matrix; recognition-installed-round-trip (live). Q1A keeps truthful static review content/counts and never fabricates runtime/content; Q2A only uniquely owned navigation omitted; Q3A existing link policy. Prior explicit actions/designs/widgets and all review fixes remain preserved. AC8 native Figma/Bricks2.3.9/Safari/iPhone remains owed; staging2.4.4 is not substitute proof.

Pin Node `/home/justin/.local/node-v22.23.3/bin/node` plus child PATH, own Chrome wrapper --use-gl=disabled, clear DISPLAY/WAYLAND. Short owned DISK scratch/TMPDIR/profiles under /home/justin/.hermes, not RAM/tmp. Latest shared user rule: no shared Chrome slot cap; ONE own Chrome job at a time, base/head sequential. Do not wait for old slot locks or foreign Chrome. Global agents8, root one role. Owned cleanup only, no denied env/private profiles/shared dependencies/config. Root owns setup sync. Never stage CLAUDE.md or override authorship/add AI trailers.

All mutation-TEST runs use systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0. SIGTERM/137/143/Killed may be earlyoom; check journalctl -u earlyoom, identify/report runaway and rerun affected check under4GB cap, never bare. Do not bypass unavailable cap prerequisites. Root checks every report/dispatch too.

Write checkpoint.json promptly. Return ready-for-review4, clean final HEAD and actual main/base, conflict/union/range-diff and gate reports, honest ac_status, no-merge confirmation and skill_lessons[{skill,lesson,evidence,enforce}] (normally empty). Never edit skills/memory. End MAIN SESSION: check and save these skill_lessons now.

## Clarification after prerequisite stop

The memory-cap instruction means mutation TESTING (deliberately altering code to prove a test fails), not Git mutations such as rebase or commit. Routine Git operations and normal checks are not required to use that executor unless rerunning a memory-killed command. The reported unavailable systemd scope blocks mutation tests and reruns of memory-killed checks; it does not block this preparation, which requires neither. Do not bypass the cap for those tests. Preserve the initial blocked report, and continue this same role from clean-state/rebase through the requested ordinary gates. Report any actual killed command or necessary mutation test requiring the unavailable executor.
