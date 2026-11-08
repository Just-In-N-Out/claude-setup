# AC AUDITOR 3 — 86bcm927y, blind, source read-only

Role: fresh blind AC auditor (Claude Code general-purpose agent, Opus, high), fork_turns none. No nested agents. You get only the approved plan, the worktree, the head, the base and your own folder. Do NOT open any other role's report or folder: no verifier/, acceptance-2/, acceptance-3/verifier/, review-*/, fixer-*/, integrate-1/, auditor/ (historical), or finisher/. Prove every AC yourself.

Story: [Integrations catalog - tiles UI in the admin console](https://app.clickup.com/t/86bcm927y)
Approved plan: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/plan-approved.md. It is the active contract; it references an original annex plan-approved-v1-original.md and the approval record amendment-approval.json in the same folder: read those three files only.
Worktree (READ-ONLY): /home/justin/Leorna/86bcm927y-integrations-catalog-tiles, branch feat/86bcm927y-integrations-catalog-tiles
HEAD: 2bc724965a635bfed9c03a4794ffa54132e125a8
Base: c8abbddf7d45099ea4023c42990334056922937e (= `git merge-base HEAD c8abbdd`, current GitHub main; check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`)
Own output ONLY: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/acceptance-3/auditor/

## Authority (settled)
Justin approved option B: GitHub and ClickUp are configurable; Google is an informational, unavailable tile (no form, no save; valid authenticated CSRF-valid Google submissions get 409 without echo or writes; new selection denied including same-tenant legacy IDs; legacy rows and snapshots preserved). Native Google client-ID support is deferred and must not be claimed delivered. Ignore historical "proposed/not approved" wording in the amendment. No AC is live.

## Read
/home/justin/.claude/CLAUDE.md, the worktree AGENTS.md, delivery/README.md, and under /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/: references/ac-verification.md (your role, receipt rules) and the header of scripts/ac-check.sh (ac.json format).

## Skills (Skill tool)
`leorna` FIRST, then `engineering-best-practices`, `adversarial-verification-loop`, `security-best-practices`, `multi-tenant-auth-management`, `mutation-testing-discipline`; `systematic-debugging` for unexpected failures.

## Acceptance criteria (read the full clauses in the plan)
- AC1 / `TestIntegrationsAC1TilesWithPostgres`: predefined integrations appear as tiles with a short description and the parameters they need.
- AC2 / `TestIntegrationsAC2ValidateWithPostgres`: required values are validated before saving.
- AC3 / `TestIntegrationsAC3PackBuilderWithPostgres`: a configured integration becomes an item addable to any pack and appears in the pack builder.
- AC4 / `TestIntegrationsAC4AuditWithPostgres`: a save or change writes a change-audit record (and settings/audit roll back together, per the plan's supporting test).

## What to do
- For each AC: read the plan clause and the test and product code, judge whether the test can actually fail for the defect the AC guards, run it on HEAD (exact-name verbose run; log first line `HEAD=<full sha>`, the test's own PASS, no skip, last line `EXIT=<code>`) and on base c8abbdd in an owned separate copy (a real build failure of old code or a meaningful assertion failure counts; missing package/setup/command failures don't). Prove the clauses yourself with your own probes, overlays or mutants where the named test may not show them. Compile errors never count as kills.
- Take your own screenshot per AC on HEAD (headless browser via the story's browser test `TestIntegrationsBrowserJourneyWithPostgres` with your own LEORNA_INTEGRATIONS_EVIDENCE_DIR inside your folder and short LEORNA_INTEGRATIONS_CHROME_TMP, DISPLAY/WAYLAND_DISPLAY unset, or your own chromedp probe; a terminal capture for a non-visual clause). Look at each image yourself.
- Anything that may write (make targets, mutations) runs only in your own detached copy under /home/justin/.hermes/cache/scratch/86bcm927y-auditor3-<random>/. Everything you cite lives inside acceptance-3/auditor/.

## ac.json
Write acceptance-3/auditor/ac.json: {"head":"2bc724965a635bfed9c03a4794ffa54132e125a8","ac_status":[{"ac":"AC1","accepted":true,"test":"...","log":"...","base_log":"...","screenshot":"...","evidence":"one line"},...]}. `accepted:false` for anything unmet or unproven. Self-check by running ac-check.sh on an independent copy (cp, not link) of your own receipts in scratch, without --reviews, keeping relative paths. Fix format errors only.

## Constraints
- Source read-only: no edits, commits, fixes, push, PR, CI changes, ClickUp writes. Keep the candidate's SHA unchanged and `git status --porcelain --untracked-files=all` empty.
- Others are running: don't touch containers you didn't create, no shared DB resets, no worktree prune, no `git stash`. Fresh owned Postgres 18.6 (SCRAM; verify a wrong password is refused) and ClickHouse at the CI image pins (read them from the repo's CI workflow), `_test` DBs, loopback only. Toolchain /home/justin/.local/leorna-toolchain/go/bin/go (Go 1.27.3) and that bin dir; task-local PATH, on-disk GOCACHE, short TMPDIR. Don't print credentials; never read /home/justin/.hermes/.env.
- Every test/mutation under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; size Go `-timeout` well above the head run's time; no docker build alongside mutations. SIGTERM / 143 / 137 / "Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, report it, rerun capped.
- Remove only your own containers at the end; list the scratch path, don't delete it.

## Return (text, no prose report files)
Verdict; head/base; per-AC ac_status with test, head log, base log, screenshot and one-line evidence; your probes/mutants and outcomes; findings with severity and file:line; unrun checks; ac.json path; and
skill_lessons[{skill, lesson, evidence, enforce}]: reusable lessons only. Never edit skills or memory yourself. `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule (kind; what; where). An empty list is the normal answer.

End exactly with:
MAIN SESSION: check and save these skill_lessons now.
