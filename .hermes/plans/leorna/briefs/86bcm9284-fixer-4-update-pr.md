# Brief: 86bcm9284 fixer 4 (update PR #119 with main again)

**Role:** FIXER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). Control-plane PR #119 (https://github.com/LeornaAI/leorna-control-plane/pull/119) shows "This branch is out-of-date with the base branch". Branch protection disables Merge, and `mergeStateStatus` is `BEHIND`.

## Justin's words (2026-11-09, verbatim; the first quote is from the earlier round, the second from this one)
> "please next time do not pppush and do a pr if this is the case add a note. Please fix this and do it agaiun'"
> "please update this branch so that I can merge"

So: bring main into the branch, re-check it, push the updated branch to the same PR (that push is authorized), and add a note to the PR saying main was brought in. Never merge the PR. Never change ClickUp: no new comment, and no status change. Don't touch client PR #31: it's `CLEAN` and stays as it is.

## State
- Fixer 3 brought main `8c85050` in. PR #119's head is `e4ccf16` (merge), CI is green, and its `mergeStateStatus` was CLEAN.
- GitHub main has since moved to `fcfc8cc` (#120, 86bd0e9kx installer reuse resources), so #119 is `BEHIND` again and Merge is disabled. The main session found `git merge-tree` clean against `fcfc8cc`.
- Worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`, local head `e4ccf16`, in sync with origin.
- Evidence: `~/.hermes/plans/leorna/evidence/86bcm9284/`, with fixer 3's notes and gate scripts in `fixer-3/`. The PR body file is `handover/pr-control-plane.md`.
- Client PR #31 is still OPEN, so the `internal/library/render/testdata/client/SOURCE.md` re-pin is still owed. Leave `SOURCE.md` alone.
- Note: WSL restarted earlier today. If Docker says "could not be found in this WSL 2 distro", don't start or restart Docker yourself: report it (`docker-desktop-crash-wsl.md`).

## Skills to load
`leorna` (step 7.2's bring-main-in rules, including the new line on "A clean merge-tree is not enough to push", the fixture-grep rule for runtime checks main tightened, and the stories.json rules; step 7.3 gates; steps 7.6–7.7 push and PR), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `github`.

## Do
1. Fetch main over HTTPS via gh and record the SHA; use a newer one if main moved. Merge it into the branch with a merge commit `merge(86bcm9284): bring main <sha7> into predefined integration tiles`. No rebase.
   - `delivery/stories.json`: main's entries stay unchanged and in order, and this story's entry stays last, with its PR numbers. Prove it by value.
   - Check that no migration number is duplicated.
   - Prove the merge: one-side files equal that side, both-sides files are the only ones differing from both parents, and the story's patch survived.
   - Grep the story's test files for fixture lines main changed across its own tests, as fixer 1 found with #115.
   - If anything conflicts or needs a design decision, stop and report without pushing.
2. Run the gates on the new head, logs in `~/.hermes/plans/leorna/evidence/86bcm9284/fixer-4/`:
   - `make check` (CI's linter and govulncheck from `~/.local/leorna-toolchain`, bound by absolute path; your own Postgres container and `_test` DB, never `leorna-pg` or a sibling's);
   - the DB `go test -json` stream, reading every skip reason;
   - `bash ./scripts/test-module-add.sh`, run serially;
   - `make -s library-check`;
   - each AC test by name: `TestEmbeddedTilesCoverTheFirstThreeSystems`, `TestPredefinedTilesAC2EnableAndSyncWithPostgres`, `TestTileVettingIsDocumented`, `TestShippedTilesPassTheGate`, `TestPredefinedTilesAC5FreshInstallWithPostgres`.
   If main's new code breaks a story test, fix it test-first in a separate `fix(86bcm9284): …` commit and explain why.
3. Pre-flight (step 7.2):
   - clean status;
   - branch-only commits all under the Leorna identity (print only "authors: Leorna OK");
   - no attribution lines;
   - no `.github/` changes and no CLAUDE.md in the diff;
   - `git merge-base HEAD origin/main` equals `origin/main` right before you push. If main moved meanwhile, repeat step 1.
4. Push with `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm9284-predefined-integration-tiles:refs/heads/feat/86bcm9284-predefined-integration-tiles` (a normal fast-forward push; never force). Fetch it back, then check that `rev-parse HEAD origin/<branch>` match.
5. Update the PR body (`gh pr edit 119 --body-file`). Edit `handover/pr-control-plane.md` first, adding a note in the Test Plan along these lines: "Main `<sha7>` was brought into the branch on 2026-11-09 (merge `<sha7>`), after the earlier bring-in of `8c85050`; gates and every AC test re-ran on head `<sha7>`: <results>. Review, verifier and auditor ran on `9b61ff0` (base `dadba89`); the bring-in merges were not re-reviewed (Justin's call for this story)." Update the Evidence block's head SHA. Keep the rest.
6. Wait for CI on the new head, polling `gh pr checks 119` sparingly (~15 min). Then read `gh pr view 119 --json state,mergeable,mergeStateStatus,headRefOid`. `mergeStateStatus` must no longer be `BEHIND`; if main moved again meanwhile, say so and don't loop more than once. If a check fails, read `gh run view --log-failed`, report the cause, and don't push a fix.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (8G for `make check` if needed, and say so). If Docker's socket dies, don't restart Docker: report it. Scratch goes in a fresh `~/.cache/86bcm9284-fixer-4/`, never `/tmp`; remove it at the end. Never print a token.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
Main SHA, merge commit, any fix commit, the new head; merge proofs; gate and AC results with log paths; the push and fetch-back; the PR note text; CI results; final `mergeStateStatus`. What Justin does next: merge #31, then the `SOURCE.md` re-pin push, then merge #119. `ac_status` per AC, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
