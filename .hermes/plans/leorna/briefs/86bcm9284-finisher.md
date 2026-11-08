# Brief: 86bcm9284 finisher (hand-over only)

**Role:** FINISHER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). `ac-check.sh --reviews` printed **READY FOR THE USER: 4 of 5 ACs proven on beb5358; live ACs owed to the user: AC2**, and review-1 is clean in both repos. Your job is the `leorna` skill's "Doing a story" step 6 hand-over. **Never push, open a PR or write to ClickUp.** Justin hasn't said "push", "make a PR" or "post". Don't change the story's code. The accepted head must stay `beb5358`, because any new commit needs a fresh review plus verifier and auditor. If something in the hand-over seems to need a code change, report it instead of making it.

## State
- Control plane: worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`, head `beb53581bc18ab4d1a61a3a74b2330cd4110f228`, base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (GitHub main, PR #112 = 927y merge). 9 commits, 25 files.
- Client (test fixtures only): worktree `/home/justin/Leorna/86bcm9284-client-tile-fixtures`, branch `feat/86bcm9284-predefined-integration-tiles`, head `6d3c3c5fc6e49698004fa18f9f93c35f0d743ba8`, base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`. 1 commit, 4 files. **The client PR must merge before the control-plane PR.** `internal/library/render/testdata/client/SOURCE.md` pins client commit `6d3c3c5` as "PR pending". After the client merge, a one-line commit points it at the merged commit, and that commit gets a delta review.
- Evidence: `~/.hermes/plans/leorna/evidence/86bcm9284/`, with `verifier/` and `auditor/` (both READY FOR THE USER), `review-1/` and `leorna-client/review-1/` (clean), `follow-ups.md` (4 P3s), the builder's `ac*.png`, `gates-beb5358*`, `ac2-live.md` and `ac2-live/`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md`, including the approved answers Q1 A–Q8 A and the draft messages to Christian (split Google's AC2 part into its own card) and Zayd (86bcx2a33 coordination).
- Auditor note, for follow-ups: AC3's test machine-checks only the Scopes and Source cells. Sign-in, Publisher, Licence and Credential are only checked non-empty (they were hand-checked correct). A follow-up could tie the Sign-in cell to the tile's sign-in method.

## Skills to load
`leorna` (step 6 and step 4b's finisher and evidence rules, `clickup-evidence.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `stop-and-show-diff.md`, plus `~/Leorna/leorna-control-plane/delivery/README.md`), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`.

## Do
1. **Re-check reality, read-only.** Fetch both GitHub mains over HTTPS via gh (the leorna skill's command). Say whether either moved since the bases above. If one did, run `git merge-tree --write-tree --name-only HEAD origin/main` and report the result, but don't merge or rebase: bringing main in needs Justin's OK. List open PRs in both repos and merge-tree any that touch the same files. Check the pre-flight items read-only: clean status, Leorna author identity on the story's own commits, no AI-attribution lines in commit bodies, no `.github` changes, `delivery/stories.json` with this story's entry last and valid.
2. **Reconcile the evidence inventory:** each AC → test → result → artifact (the PNG to attach). Open every log you cite and read its `EXIT=`. Visually inspect every PNG you list for ClickUp, and make sure no server domain, URL bar, tenant ID, token, email or DB URL is visible. Name AC2's live part as **NOT VERIFIED, owed to Justin**, and Google's AC2 part as **not met, follow-up** (Q3 A).
3. **Write the hand-over** to `~/.hermes/plans/leorna/evidence/86bcm9284/handover/` (create it). If Claude Code refuses a file there, return that text in your report instead.
   - `pr-control-plane.md`: Christian's plain style, body only, no `Title:` line. It has a Summary, one line per file or area, a Test Plan listing only what ran on beb5358 (the verifier and auditor receipts), and short Assumptions. Add the ClickUp card link, security, migration and rollback notes, and an Evidence block (head SHA; the CI run is "not yet run, not pushed"). Name other stories by title or PR number, never by bare card ID. Say the client PR merges first.
   - `pr-client.md`: the same style for the 4-file fixture PR.
   - `review-prompt.md`: a self-contained review prompt for a fresh agent, in the `review-prompt-for-agent.md` format, covering both repos.
   - `clickup-evidence.md`: the closing comment draft (WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI "not yet run", AC2 live NOT VERIFIED, Google follow-up), plus the list of image files to attach (images only, never `.log`/`.txt`).
   - `team-message.md`: the short team message, for after merge.
   - `messages.md`: the draft messages to Christian and Zayd from the plan, updated if anything changed. Justin sends them.
   - `follow-ups.md` summary: the 4 P3s, the auditor's AC3 note, the Google AC2 follow-up card, the 86bcm928h keyring follow-up, and promoting the tiles from preview to stable after the live run.
4. Show the diff stat: `git diff --stat origin/main...HEAD` in both repos, plus the key hunks in a few lines.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Scratch goes in a fresh `~/.cache/86bcm9284-finisher/`, never `/tmp`; remove it at the end.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
Status line (`code-reviewed and AC-verified; live AC2 owed to Justin; not pushed`), whether either main moved, the merge-tree and open-PR results, the hand-over file paths, the evidence inventory table, the diff stats, the PR order (client first), what Justin must do next (the AC2 live run per `ac2-live.md`, then the words "push" / "make a PR" / "post"), and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
