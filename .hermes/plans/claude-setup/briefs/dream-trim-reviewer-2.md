# REVIEWER round 2 (delta): dream-trim (claude-setup), Mini pipeline

Role: fresh REVIEWER, report only. You never saw the build, the first review's work or the fix. Do not edit any file in the worktree or `$HOME`, don't commit, don't push, don't run `sync.sh` or `land.sh` against the real home. You may write only inside `<evidence>/review-2/` and your own scratch folder.

Inputs (only these):
- Approved plan (the contract, read-only): `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` ("Justin's answers" is binding; AC9 is `(live)`).
- Worktree: `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`), setup repo gitdir `~/.claude-setup.git`.
- head: `2bc4495d583d8b08e4d878f160084f6dcbee259a`
- base: `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (= `git -C <worktree> merge-base HEAD main`)
- previous round's head (your `from`): `bac67c3475312e50e3557495a21073b5f61d9f2d`
- Round 1's record: `~/.hermes/plans/claude-setup/evidence/dream-trim/review-1/review.json` and `review-1/probes/`.
- The fixer's records: `~/.hermes/plans/claude-setup/evidence/dream-trim/fixer-1/` (`sha-map.txt` has the commit map).

## What the story is
A one-time trim of four oversized instruction files every agent loads. Pass 1 moves whole lines into `references/` files behind pointer lines without changing a byte; pass 2 merges duplicates and never touches a protected safety line. `land.sh` lands pass 1 first, and pass 2 only after Justin says "land pass 2".

## What happened since round 1
Round 1 was a full review of `131f9b0a..bac67c34` and found two P2s (R1-1, R1-2) and nine P3s. The fixer's answer to each P2:
- **R1-1 fixed** (commits `ce13fe7b` map, `0bce3d5e` test): the Status parent anchor is now ``- **Current build ` `` (no build number). Test `map_applies_after_status_build_number_changes`, with two guards: the map just before the pass-1 commit must equal head's map, and a control map whose anchor holds the build number is refused with exit 2.
- **R1-2 fixed** (commit `41bcb24e`): `land.sh` runs the size check only on the pass-1 commit it makes in this landing; a landing that makes no pass 1 prints `check size: skipped (…)`. Tests `land_pass2_lands_after_kept_lines_grow` and `land_refuses_pass1_over_its_target`.
- **The fixer's own ruling, to judge:** a landing of pass 1 and pass 2 together is refused when the pass-1 commit is over target, even if pass 2's cut would bring the file back under (the old code accepted that).
- No P2 was rejected.

**The fixer rearranged the branch** instead of adding commits on top, so `bac67c34` is no longer an ancestor of the head. Its reasons: `land.sh` lands every commit from the merge base up to the one it is given, so a fix must sit below pass 2 to land with pass 1; and `land.sh` remakes pass 1 with the map as it stood just before the pass-1 commit, so a map fix committed after pass 1 would be ignored. Claimed mapping (old → new): `cd705d79` unchanged; new `ce13fe7b`; `31abeb33` → `d9217352` (pass 1); `67908c32` → `012551e8`; `bb47866a` → `075aa1c0`; `42e0db8f` → `a98ac1a5`; `791beb3f` → `b720864b`; `ced49711` → `6d06709b`; new `0bce3d5e`; new `41bcb24e`; `bac67c34` → `2bc4495d` (pass 2). Land commands it gives: pass 1 `land.sh 41bcb24e --map .claude/setup/trim/maps/dream-trim.json`; pass 2 `land.sh 2bc4495d --map … --ledger <evidence>/pass2-ledger.md`.

## Skills to load (Skill tool), one line each when you do
`requesting-code-review`, `code-review-practice`, `engineering-best-practices`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: base, the previous round's head, head).

## Your job: review the fix (writes `<evidence>/review-2/review.json`)
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-trim/`
- Because the branch was rearranged inside the loop, review `git -C <worktree> range-diff 131f9b0a..bac67c34 131f9b0a..2bc4495d` as `review-loop.md` says, with `from` still the previous round's head.
- **Is the rearrangement faithful?** Prove it yourself, not from the fixer's table: every replayed commit carries the same patch; pass 2's patch is unchanged; the pass-1 commit `d9217352` moves exactly the same lines to the same places as `31abeb33` (same bytes in the four files and the `references/` files); the only tree differences between `bac67c34` and the head are the fix's own (`land.sh`, the map, `move-to-references.py`, `trim.test.sh`); nothing else slipped in.
- **Do the fixes hold?** Probe R1-1 and R1-2 again on head with the round-1 probes and with variations: the build line changing more than once, a second line beginning with the same prefix, the Status line re-wrapped; pass 2 landing after growth on each of the four files; pass 1 just under, at and over its target; pass 1 and pass 2 landed in one call; a rerun after a partial landing. Do the new tests fail when the fix is removed?
- **Did the fix break anything round 1 covered?** The lock, dirty-file, moved-`main` and project-file guards in `land.sh`; the lossless check; the protected-line and ledger checks on the pass-2 landing now that the size check is skipped there.
- Judge the fixer's ruling above on its merits.
- Anything else you notice outside the fix commits and what they touch is P3.

Write `review-2/review.json`: round 2, scope "delta", from = `bac67c3475312e50e3557495a21073b5f61d9f2d`, head = the head above, findings (empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Every P0–P2 needs a concrete real-use scenario. If a finding is the same defect as a round-1 finding, set `repeats` (and `new_fact` when you have one).
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trim-reviewer-2/` (mkdir without -p); big things under `~/.cache/dream-trim-reviewer-2/`. Remove both by literal path at the end.
- Run `land.sh` only on scratch homes (the recipe is in `ac-verification.md`, "Setup-repo stories"). Take base copies with `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` first.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- `codex-parity.test.sh` fails `ac4`, `ac19` and `ac21` on the base, and its `ac7_claude_hooks_unchanged` is flaky (one cortexos-memory case): compare by name against two runs before calling it a regression.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rearrangement_faithful: yes|no with evidence, review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` here is your reading of whether the fix leaves each AC's test truthful; the fresh verifier re-runs them after you.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule (its kind, what it checks, where it runs). An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
