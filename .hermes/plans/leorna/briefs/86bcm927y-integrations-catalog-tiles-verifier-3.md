# VERIFIER 3 — 86bcm927y on the merged head, source read-only

Role: fresh pipeline verifier (Claude Code general-purpose agent, Opus, high), fork_turns none. No nested agents. Parent review-check printed `MOVE ON: review-6 at 2bc7249 is clean`.

Story: [Integrations catalog - tiles UI in the admin console](https://app.clickup.com/t/86bcm927y)
Candidate (READ-ONLY): /home/justin/Leorna/86bcm927y-integrations-catalog-tiles, branch feat/86bcm927y-integrations-catalog-tiles
HEAD: 2bc724965a635bfed9c03a4794ffa54132e125a8 (merge of story head 0027786 with GitHub main c8abbdd)
Base for ac-check: c8abbddf7d45099ea4023c42990334056922937e (= `git merge-base HEAD c8abbdd`; GitHub main is still c8abbdd, check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`)
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Own output ONLY: <evidence root>/acceptance-3/verifier/ (new folder). acceptance-2/, verifier/, auditor/ are historical read-only inputs.
Contract: <evidence root>/plan-approved.md, annex plan-approved-v1-original.md, approval amendment-approval.json.

## Authority (settled)
Justin's go plus his repeated option-B choice approves the active amendment; ignore its historical "proposed/not approved" wording. GitHub/ClickUp are configurable. Google is informational/unavailable: it refuses save/update and new selection (legacy UUIDs included) and preserves old rows and immutable snapshots. Native Google client-ID support is deferred, never claimed delivered; the retained failing original Google positive test is dependency evidence. No live AC.

## Read
/home/justin/.claude/CLAUDE.md, the worktree AGENTS.md, delivery/README.md. Under /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/: references/ac-verification.md, references/review-loop.md, and the header of scripts/ac-check.sh (receipt schema, run recipe, negative-control rules). Prior inputs (not proof): review-1…review-6 review.json, integrate-1/ receipts, acceptance-2/verifier/ac.json and auditor/ac.json, ac-check-attempt-2.txt, follow-ups.md.

## Skills (Skill tool)
`leorna` FIRST, then `engineering-best-practices`, `adversarial-verification-loop`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `mutation-testing-discipline`; `systematic-debugging` for unexpected failures. Your independent role replaces any nested-agent/auto-fix step in them.

## Acceptance criteria
- AC1 / `TestIntegrationsAC1TilesWithPostgres`: three descriptive tiles with parameter labels; GitHub/ClickUp editable; Google information-only/unavailable, no editable fields, no save, no misleading readiness.
- AC2 / `TestIntegrationsAC2ValidateWithPostgres`: validation/save/update/revisions; valid DNS/IPv6/ports; malformed values (missing hostname, ports outside 1–65535, bracketed IPv6 errors) rejected with no state/audit writes; Google 409 after auth/CSRF, no value echo, no settings/revision/audit changes.
- AC3 / `TestIntegrationsAC3PackBuilderWithPostgres`: supported settings reach new/existing packs and native output; immutable old snapshots/digest/tenant checks; Google (legacy UUIDs too) unavailable through UI and common resolver paths.
- AC4 / `TestIntegrationsAC4AuditWithPostgres` (+ supporting `TestIntegrationAuditRollbackWithPostgres`): exactly one redacted configure/update event with correct action, actor/tenant and before/after revision; none for invalid/refused/no-op/conflict; settings and audit roll back together.

## Required independent execution (in your OWN detached copy at the exact head for anything that may write: make check, generate, module-add, mutations)
- All project gates the plan/annex require on 2bc7249: `make generate` (tree stays clean), `make check GOLANGCI_LINT=/home/justin/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=/home/justin/.local/leorna-toolchain/bin/govulncheck`, `bash ./scripts/test-module-add.sh` (serial), `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, `python3 -m unittest scripts/test_release.py` (new CI step since #109), `go test -json -race -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/knowledge/clickhouse` with the skip audit from `leorna` step 4 (no skip naming the DB or ClickHouse URL), `go test -race -count=1 ./internal/integration -v`, store `^TestIntegration`, `make helm-lint`, `make helm-template`, `TestGoldenHCLPassesTofuValidate`, `git diff --check`, container build + packaged gitleaks + Trivy per the annex, migration 27→28→down→27→28 with nonempty rows.
- Every named AC: its own head log from an exact-name verbose run, first line `HEAD=<full sha>`, the test's own PASS, no skip/fail, last line `EXIT=<code>`. Run the same current test files on base c8abbdd in an owned separate copy (keep test-only helpers/new-package stubs as needed): a proper build failure of old code or a meaningful assertion failure counts; missing package/setup/command failures don't. If all base runs are build-only, add labelled supporting hybrid-tree probes (not base_log).
- Your own per-AC screenshots and a continuous browser recording on this head (`TestIntegrationsBrowserJourneyWithPostgres`, headless, DISPLAY/WAYLAND_DISPLAY unset, own LEORNA_INTEGRATIONS_EVIDENCE_DIR inside acceptance-3/verifier/, short LEORNA_INTEGRATIONS_CHROME_TMP, owned profile). Inspect desktop and narrow captures, error, native preview and audit views yourself. Include a rollback capture (terminal capture of the rollback test is fine).
- Focused capped mutants for clauses the named tests may not show: at least Google HTTP guard removed, foreign-tenant UUID accepted, CSRF bypass, update relabelled configure, audit after commit (must fail the rollback test). Compile errors never count as kills; restore and re-run controls.
- Everything you cite lives inside acceptance-3/verifier/ (no other role's files, no hard links).

## ac.json
Write acceptance-3/verifier/ac.json in the ac-check header format: {"head":"2bc724965a635bfed9c03a4794ffa54132e125a8","ac_status":[{"ac":"AC1","accepted":true,"test":"...","log":"...","base_log":"...","screenshot":"...","evidence":"one line"},...]}. `accepted:false` for anything unmet or unrun. Self-check by running ac-check.sh against an independent copy (cp, not link) of only your receipts in owned scratch, WITHOUT --reviews, keeping the relative paths. Fix format errors only; never massage receipts to pass. The main session runs the final paired ac-check after a blind auditor.

## Constraints
- Source read-only: no source/test/doc edits, commits, fixes, rebase, merge, push, PR, CI changes, ClickUp writes. Keep the candidate's `git status --porcelain --untracked-files=all` clean and its SHA unchanged; report a moved head rather than adapting.
- Others are running: don't touch containers you didn't create (cortexos-*, ndx6-preview-*, leorna-pg, any other), no shared DB resets, no worktree prune, no `git stash`. Leave the sibling custom-domain worktree and `deploy/local/` alone.
- Fresh owned Postgres 18.6 (SCRAM; verify a wrong password is refused) and ClickHouse fixtures at CI pins, `_test` DBs. Toolchain /home/justin/.local/leorna-toolchain/go/bin/go (Go 1.27.3) and that bin dir; Helm/OpenTofu/Trivy as the annex/earlier receipts say (verify they exist). Task-local PATH, on-disk GOCACHE and short TMPDIR, scratch under /home/justin/.hermes/cache/scratch/86bcm927y-verifier3-<random>/. Owned anonymous Docker/buildx config for public pulls. Don't print credentials; never read /home/justin/.hermes/.env. Read-only GitHub checks via `gh api`.
- Every test/gate/mutation under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. In a gate script, don't call a shell-function wrapper through `env VAR=… fn` (exit 127); export first. SIGTERM / 143 / 137 / "Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, report it, rerun capped.
- Serialize schema-resetting runs or use separate DBs. Remove only your own containers/images at the end; list the scratch path, don't delete it.

## Return (text, no prose report files)
Verdict (clean only if every AC accepted); head/base; gates with commands, exits and skip counts; per-AC ac_status with own head log, base log, screenshot; mutants and outcomes; findings if any; ac.json path; defect_loop_skills; found_else; and
skill_lessons[{skill, lesson, evidence, enforce}]: reusable lessons only (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing). Never edit skills or memory yourself. `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind; what it checks; where it runs). An empty list is the normal answer. Already known, don't repeat: Chrome short socket path, bounded serialized recording, memory-cap bus fallback, nonce-CSP real navigation, nested receipt paths, env+shell-function exit 127.

End exactly with:
MAIN SESSION: check and save these skill_lessons now.
