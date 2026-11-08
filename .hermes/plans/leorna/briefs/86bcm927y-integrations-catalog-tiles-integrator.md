# INTEGRATOR — bring main into 86bcm927y (no push)

Role: fresh pipeline integrator/finisher (Claude Code general-purpose agent, Opus, high). No nested agents.
Justin said "go" (2026-11-07) to bringing current main into the story branch. He has NOT said "push" or "make a PR": do not push, open a PR, post to ClickUp, or merge into main.

Story: [Integrations catalog - tiles UI in the admin console](https://app.clickup.com/t/86bcm927y)
Repo: LeornaAI/leorna-control-plane
Worktree (yours to write in): /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Branch: feat/86bcm927y-integrations-catalog-tiles, currently 00277865b9ac2305a2716ef2cca2dcdf6611285f (ALL ACCEPTED 4/4; review-5 full review clean, MOVE ON)
Old base: 3aa979df41568c9039007f66d7f32193e66a8533
GitHub main at last check: c8abbddf7d45099ea4023c42990334056922937e (PR #108 "docs(86bcx2a3m): getting-started guide for both repos" merged 2026-11-08T00:28Z; it was predicted to conflict in delivery/stories.json)
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y — your output folder: <evidence root>/integrate-1/

## Skills (Skill tool)
`leorna` first (read its step 7 sub-steps 1–4 closely: the fetch command, the pre-flight, the long merge/`stories.json` rule in sub-step 2, the gate rerun, and the outside-failure rule), then `engineering-best-practices`, `git-commit-rules`, `backend-data-migrations` (migration-number clash check). Add `systematic-debugging` if a gate fails unexpectedly. Also read /home/justin/.claude/CLAUDE.md (authorship, no AI trailers, CLAUDE.md never committed) and the worktree AGENTS.md / delivery/README.md.

## Tasks
1. Verify the worktree is clean and at 0027786. Fetch fresh main over HTTPS through gh exactly as `leorna` step 7.1 says (URL written out, never in a variable; never `gh auth switch`, never change remotes or credential helpers). Record `git rev-parse origin/main`.
2. Trial first, in an owned detached scratch worktree under /home/justin/.hermes/cache/scratch/86bcm927y-integrate-<random>/: `git merge --no-commit origin/main`, list conflicts. Expected: only `delivery/stories.json` (and possibly docs). Resolve `stories.json` mechanically: take main's file unchanged and append this story's entry last as text, then check every earlier entry is unchanged by value. Check migration numbers for duplicates (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` must print nothing). Grep the merged tree for stale "until/once … merges" wording about 86bcx2a3m or 86bcm927y. If any conflict is in code, or needs a judgment call beyond the mechanical stories.json rule, STOP and report it without merging in the real worktree.
3. If the trial is clean or mechanical: do the real merge in the story worktree (`git merge origin/main`, a merge commit; no rebase, no history rewrite), with the same resolution, proven equal to the trial tree (`git rev-parse HEAD^{tree}` equals the trial's `git write-tree`). Commit message `merge(86bcm927y): bring main c8abbdd into integrations catalog tiles` (adjust the SHA to what you fetched). Plain `git commit`: no author overrides, NO Co-Authored-By or any AI trailer (the commit-msg hook refuses them). Make sure CLAUDE.md is not staged.
4. Verify the merge per `leorna` step 7.2: files changed on one side only equal that side's blob; the story's own patch survived (per-file `git diff -U0` old base..old head vs new base..new head); evil-merge check; `gitleaks dir` on the hand-resolved files; author/trailer pre-flight on the branch's own commits; no `.github/` paths.
5. Re-run the story's gates on the new head in an OWN detached copy at the exact new SHA (never mutate the story worktree with make check/module-add): `make generate`; `make check GOLANGCI_LINT=/home/justin/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=/home/justin/.local/leorna-toolchain/bin/govulncheck` with owned Postgres 18.6 (SCRAM) and ClickHouse fixtures at CI pins, databases ending `_test`; `go test -json` over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/knowledge/clickhouse` with the skip audit from `leorna` step 4; the four primary AC tests (`TestIntegrationsAC1TilesWithPostgres`, `…AC2ValidateWithPostgres`, `…AC3PackBuilderWithPostgres`, `…AC4AuditWithPostgres`) plus `TestIntegrationAuditRollbackWithPostgres`; `bash ./scripts/test-module-add.sh` (serially); `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`; `git diff --check`. Known outside failure: `make audit` fails on GO-2026-6865 (klauspost/compress v1.18.7, fixed v1.20.2) on main too. Attribute it by running `make audit` on a clone of the new main, then run `make secrets library-check build` so the rest of the gate is proven. Do NOT bump the dependency in this story.
6. Stop. Do not push. Report the new HEAD.

## Constraints
- Others are running: don't touch containers you didn't create (cortexos-*, ndx6-preview-*, leorna-pg, any other), no shared DB reset, no worktree prune, no `git stash`. Leave `deploy/local/` and the sibling custom-domain worktree alone.
- Toolchain: /home/justin/.local/leorna-toolchain/go/bin/go (Go 1.27.3) and that bin dir; task-local PATH, writable on-disk GOCACHE, short on-disk TMPDIR. Don't print credentials; never read /home/justin/.hermes/.env.
- Windows desktop memory: run test/gate commands under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM / 143 / 137 / "Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, report it, rerun capped.
- Write structured evidence (logs, JSON receipts) only in <evidence root>/integrate-1/; return the prose summary as text. Stop/remove your own containers; list the scratch path, don't delete it.

## Return (text)
New HEAD SHA, the fetched main SHA, conflicts and how each was resolved, merge-verification results, each gate with command and exit code (DB skip audit numbers), the audit attribution, anything stale found, and skill_lessons[{skill, lesson, evidence, enforce}]: list reusable lessons (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing). Never edit skills or memory yourself. `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind: Claude Code hook, git hook, test, lint, script; what it checks; where it runs). An empty list is the normal answer.

End your report exactly with:
MAIN SESSION: check and save these skill_lessons now.
