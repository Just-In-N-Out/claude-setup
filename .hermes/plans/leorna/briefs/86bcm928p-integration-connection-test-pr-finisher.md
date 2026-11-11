# PR FINISHER brief ("make a PR"): 86bcm928p connection test for integrations

Role: PR FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). Justin said, 2026-11-11: "yeah sure push and make a pr and then lets post on clickup". That authorises:
- push and make a PR, following the `leorna` skill → Doing a story → step 7, sub-steps 1–8;
- bringing GitHub main into the branch;
- installing Go 1.27.4 into `~/.local/leorna-toolchain`. My hand-over message said "make a PR" includes this, and he agreed.

**Hold the ClickUp post:** it waits until the PR is merged (step 7.9; the main session posts it). **Never merge, and never write to ClickUp.** Start no other agents.

- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`. Accepted head: `ecbd6b5e6ff7eca29ef82c1763b5c2120b292a58`; story base: `4ef14efb46da789aec30fad1e5a988d8770140e2`. Not pushed yet.
- GitHub main, read at 2026-11-11: `09924b5` (re-read it yourself). The hand-over finisher saw `89cc6e8`; PR #124 (Go 1.27.4, the GO-2026-6859 fix) is in main.
- Hand-over files: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/finisher/`, and the PR text draft `~/.hermes/cache/scratch/leorna-pr-86bcm928p-integration-connection-test.md`.
- Approved plan: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`. AC tests: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` and `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` (`internal/web`).
- Write your evidence in `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/pr-finisher/` (create it). Scratch: `~/.cache/86bcm928p-pr-finisher/` (`mkdir` without `-p`), never `/tmp`.

## Steps
1. **Toolchain:** install go1.27.4 into `~/.local/leorna-toolchain` the way the existing go1.27.3 is installed there (read `references/gates.md` → host prerequisites; verify the official checksum). Leave 1.27.3 in place. Echo the versions the gates use.
2. **Bring main in** (step 7.2): fetch main over HTTPS through gh, then **merge** (never rebase) `origin/main` into the branch.
   - The expected only conflict is `delivery/stories.json`. Resolve it mechanically: take main's file and append this story's entry last, as text; then check every earlier entry is unchanged by value.
   - **Any other conflict:** run `git merge --abort` and stop with `status: stopped`, listing the paths.
   - Do the sibling checks step 7.2 lists for a moved main: grep the story's tests for fixture edits main made across `*_test.go`; check duplicate migration numbers (the story adds none); look for stale card-ID / "until … merges" wording; prove the merge per the skill's merge-verification lines; run `gitleaks dir` on the both-sides files.
3. **Gates on the merge head** (step 7.3), run with go1.27.4 first in PATH:
   - `make check` (CI-pinned golangci-lint and govulncheck from `~/.local/leorna-toolchain`), `bash ./scripts/test-module-add.sh` serially, `python3 -m unittest scripts/test_release.py`, and the Postgres no-skip check;
   - both AC tests by name, each with its own pass line and no skip.

   Use your own Postgres container (and ClickHouse if the gates need it), named `928p-prfin-*`. Remove them when done, and never print the password. `make audit` should now pass; if it fails, attribute it as step 7.4 says.
4. **PR text:** update the draft so its Test Plan lists only what ran on the merge head, and says main was brought in at `<sha>`, with the Go 1.27.4 note. Remove the "CI audit expected to fail until a toolchain bump" assumption if audit now passes. Body only, no title line. Name other stories by PR number or title, never by bare card ID.
5. **Pre-flight, push, open** (steps 7.2, 7.6, 7.7):
   - authorship of the branch's own commits is Justin's Leorna identity (say "authors: 1 identity, Leorna OK"; never print the address), with no AI attribution lines;
   - no `.github/` path;
   - `git merge-base HEAD origin/main` equals `origin/main`;
   - `gh pr list --head <branch> --state all` is empty.

   Then push over HTTPS through gh (git-guard asks Justin; that's expected), fetch it back, set the upstream, and run `gh pr create --title "feat(86bcm928p): connection test for integrations" --body-file <file>`. Read the PR back (`number,url,state,headRefOid,mergeable,mergeStateStatus`) and run `gh pr checks`.
6. **PR-number record** (step 7.8): add the PR number to this story's `delivery/stories.json` entry in one small commit, `feat(86bcm928p): record PR #<n>`.
   - Prove it by value: main's entries are equal and in order, with this story's entry last. Run `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, and `scripts/check-story-shippable.py 86bcm928p`, expecting only the PR-state BLOCKED lines.
   - **Don't push it:** it goes to a fresh review first (memory: "make a PR" = PR, record commit, review, push, CI on the final head). Report its SHA.
7. Re-read GitHub main and the open PR list at the end. If main moved again or a new sibling PR opened, run merge-tree and report it.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, "make a PR"), `engineering-best-practices`, `git-commit-rules`, `github`, `backend-data-migrations` (to check records and migrations only). Before starting, read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Rules
- Never merge a PR or write to ClickUp. Never override git authorship. Never commit CLAUDE.md. Make no CI change.
- Never put server domains, URLs, tenant IDs or tokens in the PR text or report.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`.
  - Run `make check` under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`, and other heavy runs under 4G.
  - Before reading a killed command as a result, check earlyoom: `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.
- WSL PATH has entries with spaces: export PATH in scripts, never `PATH=…:$PATH` unquoted.
- Long commands: start them with `cmd >log 2>&1 & echo pid=$!`, then wait in the foreground with `timeout 165 tail --pid=<pid> -f /dev/null`. Don't end your turn to wait.
- Other bugs go in `found_else`.
- Skill lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section. Never edit skills or memory yourself; the one exception is a dated status line in the shared `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` recording the PR. `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: pr_open|stopped, pr_number, pr_url, merge_head, main_sha_merged, record_commit (unpushed SHA), gates[{name, exit, log}], ac_tests[{ac, result, log}], pr_checks, merge_tree_siblings[], toolchain, cleanup, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
