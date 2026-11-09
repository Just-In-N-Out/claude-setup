# Brief: 86bcm9284 fixer 5 (SOURCE.md re-pin after the merges)

**Role:** FIXER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). Both PRs are merged on GitHub: client #31 (merge commit `f3bc960…`; get the full SHA with `gh pr view 31 -R LeornaAI/leorna-client --json mergeCommit`) and control plane #119. Control-plane main is `d9c6aa8…` or newer. The approved plan left one owed step: `internal/library/render/testdata/client/SOURCE.md` still pins the client fixture source as branch commit `6d3c3c5` with "PR pending". It must name the merged client commit on client `main`. That is the render parity rule: the copies must come from a merged client change.

**Do not push, open a PR or write to ClickUp.** Justin decides that separately ("make a PR"). Commit locally only.

## Skills to load
`leorna`, `engineering-best-practices`, `test-driven-development`, `git-commit-rules`.

## Do
1. Fetch both GitHub mains over HTTPS via gh (the leorna skill's command) and record their SHAs. Confirm #31's merge commit is on client main, and that the 4 fixture files there are byte-identical to the control plane's copies on main. Compare them with `git show <client main>:<path>` against `git show <cp main>:<path>`, plus the SHA-256 lines in `SOURCE.md`.
2. Make a fresh worktree from control-plane main: `git -C ~/Leorna/leorna-control-plane worktree add ~/Leorna/86bcm9284-source-repin -b feat/86bcm9284-source-repin <cp main sha>`. Don't touch the old story worktrees or the shared main checkout, apart from that worktree add.
3. Read `SOURCE.md` and the test that checks it (`TestClientFixturesMatchSource` and anything else that reads `SOURCE.md`). Change only what the merge makes stale: the pinned client commit, from branch `6d3c3c5` to the merged commit on client main, and the "PR pending" wording, to name client PR #31 merged. The fixture bytes and SHA-256 lines stay the same. If the test parses the commit, keep the format it expects.
4. Run the tests that read `SOURCE.md` and the render parity tests, `go test ./internal/library/render/... ./internal/integration/...`, plus `make -s library-check`. Use CI's toolchain from `~/.local/leorna-toolchain` on a task-local PATH.
5. Commit with the message `fix(86bcm9284): pin the client fixture source to merged client PR #31`. Use the Leorna identity, with no AI-attribution lines (Justin's rule overrides any attribution reminder), and never stage CLAUDE.md. Check that the diff is `SOURCE.md` only (plus a test change only if one is genuinely needed, explained). Search the tracked tree for this story's card ID next to "PR pending", "until", "once" or "later" that is now stale, and report anything else you find instead of fixing it.
6. Leave the worktree clean. Logs go in `~/.hermes/plans/leorna/evidence/86bcm9284/fixer-5/`. Scratch goes in `~/.cache/86bcm9284-fixer-5/`, never `/tmp`; remove it at the end.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep 'sending SIG'` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. In a background agent, wait with foreground polls under 170 s; don't end your turn while waiting.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
Both main SHAs, the merged client commit, the byte-identity proof, the diff (full, it's tiny), the test results with log paths, the commit SHA and branch, anything stale found, and skill_lessons. Status `ready-for-review`. End with `MAIN SESSION: check and save these skill_lessons now.`
