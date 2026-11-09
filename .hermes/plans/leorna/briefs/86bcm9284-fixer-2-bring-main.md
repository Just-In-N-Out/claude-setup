# Brief: 86bcm9284 fixer 2 (bring both mains in again)

**Role:** FIXER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). Justin said on 2026-11-08: "update main branch and re run test here and verification and AC so that we can merge". That is his OK to bring main in. Fixer 1 brought `dadba89` in, and the story was re-verified at `9b61ff0` (READY FOR THE USER). Overnight both GitHub mains moved again, so bring them in again, in **both** repos this time. **No push, no PR, no ClickUp writes.**

## State
- **Control plane:** worktree `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`, branch `feat/86bcm9284-predefined-integration-tiles`, head `9b61ff056d191edb060ed60cd3d325d7f4ebd483` (reviewed and verified, base `dadba89`).
  - GitHub main is now `8c85050`, which adds #116 (86bcryh0w managed-config drift), #117 (86bcryh0w delivery) and #118 (86bd0dtjd reuse IAM keys).
  - `git merge-tree` against it shows no text conflict. Still check `delivery/stories.json` (this story's entry must stay last), migration numbers, and any semantic clash with integration, tile, library-gate or desktop-sync code.
- **Client:** worktree `/home/justin/Leorna/86bcm9284-client-tile-fixtures`, branch `feat/86bcm9284-predefined-integration-tiles`, head `6d3c3c5` (base `7a83443`).
  - GitHub client main is now `7a1f42d`, which adds #30 (86bcryh0w managed-config drift), also with no text conflict. Bring it in too, so the fixture change is tested on the new client main.
  - The control plane's `internal/library/render/testdata/client/SOURCE.md` pins the client fixture commit `6d3c3c5` and the files' SHA-256s. Check that it stays true: the fixture files must be unchanged by the merge. Don't change `SOURCE.md` unless that pin becomes false, and say which.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md`. Evidence: `~/.hermes/plans/leorna/evidence/86bcm9284/`. Fixer 1's notes are in `fixer-1/`.

## Skills to load
`leorna` (step 7.2's bring-main-in rules: the stories.json append-as-text rule, migration-number duplicates, merge proofs, and the sibling-test checks), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`.

## Do
1. Re-fetch both GitHub mains over HTTPS via gh and record their SHAs. If either isn't `8c85050` (control plane) or `7a1f42d` (client), use the newer one and say so.
2. In each story worktree, `git merge <main sha>` with a merge commit `merge(86bcm9284): bring main <sha7> into predefined integration tiles`. No rebase: the reviewed commits stay as they are.
   - **README:** keep both sections, main's 928t section first and this story's after it, with no wording lost.
   - **`delivery/stories.json`:** take main's file unchanged and append this story's entry last, as text. Prove every earlier entry is equal by value and in order.
   - **Any other conflict, or a semantic clash** (for example, 928t changing how configured integration items reach packs, or a test helper renamed): resolve it keeping both meanings. Report every hand-resolved file. If it needs a real design decision, stop and report.
   - Check for duplicate migration numbers: `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` must print nothing.
   - Prove the merge per the `leorna` skill: files changed on one side only equal that side's blob, and the story's own patch survived.
3. If main's new code breaks one of this story's tests (not a merge-text issue), fix it test-first in a separate `fix(86bcm9284): …` commit after the merge, and explain why.
4. Run the gates on the new head and keep the logs in `~/.hermes/plans/leorna/evidence/86bcm9284/fixer-2/` (create it):
   - control-plane `make check` (CI's linter and govulncheck from `~/.local/leorna-toolchain`, bound by absolute path; your own Postgres container and `_test` DB, never `leorna-pg` or a sibling's);
   - the `go test -json` DB stream over the DB packages plus the story's packages, reading every skip reason;
   - `bash ./scripts/test-module-add.sh`, run serially;
   - `make -s library-check`.
   Client: `go test ./toolconnector/...`, `make check`, `node --test scripts/*-ui.test.cjs` and `make lint audit` with CI's linter.
   Then run each AC's named test by name on the new control-plane head (AC1 `TestEmbeddedTilesCoverTheFirstThreeSystems`, AC2 `TestPredefinedTilesAC2EnableAndSyncWithPostgres`, AC3 `TestTileVettingIsDocumented`, AC4 `TestShippedTilesPassTheGate`, AC5 `TestPredefinedTilesAC5FreshInstallWithPostgres`).
5. Leave the worktree committed and clean. Every commit uses the Leorna identity, with no AI-attribution lines, and CLAUDE.md is never staged.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (8G for `make check` if needed, and say so). If Docker's socket dies mid-gate (a Docker Desktop crash), don't restart Docker yourself: report it. Scratch goes in a fresh `~/.cache/86bcm9284-fixer-2/`, never `/tmp`; remove it at the end.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
Both new head SHAs and main SHAs, the merge commit, the hand-resolved files and how each was resolved, the merge proofs, any fix commit, gate results with log paths, each AC test's result on the new head, and skill_lessons. Status `ready-for-next-review`. End with `MAIN SESSION: check and save these skill_lessons now.`
