# FIXER 2 — 86bccndx6 custom company domain

DISPATCH HOLD: main must first receive Justin’s answer to review-2 ASK JUSTIN, persist his verbatim reply in review-2/justin.json, and rerun review-check. Dispatch only if the resulting gate authorizes this fix. This is a prepared brief, not permission to start.

Fresh configured pipeline_fixer, Astra xhigh, fork_turns none. Verify each supplied finding first, fix valid findings test-first, report evidence-based rejection of invalid findings, then stop ready-for-next-review. No nested agents. You are not alone; preserve sibling work and do not revert their edits. Main routes review and verification.

Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`; branch `feat/86bccndx6-custom-company-domain`.
Approved plan `/home/justin/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`.
Evidence root `/home/justin/.hermes/plans/leorna/evidence/86bccndx6`; your writes go in `fix-2/` plus authorized product files in the worktree and owned scratch.
Current head: `24c13fd1f3908836aa2cd020eee295770913fb53`.
Base: `3aa979df41568c9039007f66d7f32193e66a8533`.
Referee records: `<evidence>/review-2/review.json`, `<evidence>/review-2/report.json`, `<evidence>/review-2/recovery_probe_test.go`, recovery-overlay.json and recovery-probe.log. Earlier records in review-1 and fix-1 establish the previous R1-1 fix; preserve it. Reproduce R2-1 in your own fix-2 folder.

Exact referee output before Justin’s answer:

R2-1  P2  internal/installer/scaleway/domain.go:382  UseGenerated requires already-working generated discovery before restoring its missing alias, so it cannot repair the inconsistent-alias state diagnosed by Status.
ASK JUSTIN: review-2: 1 P0-P2, no fewer than review-1's 1

Reviewer scenario: An operator redeploys an active custom-domain container after an environment edit omits LEORNA_GENERATED_BASE_URL. The custom origin still serves the correct tenant, but generated discovery returns 404. Reopening the installer diagnoses the inconsistent alias; clicking Use generated domain fails before any write and leaves generated access broken.

Reviewer recommendation, to verify independently before choosing a correction: Retain selected-installation and tenant guards, but establish a trustworthy baseline from the still-working selected custom origin when generated discovery is unavailable; then explicitly restore the generated URL pair, redeploy and verify. Add this inconsistent-alias recovery case and a mismatched-tenant negative control.

The main session does not adjudicate correctness. Once authorized, verify R2-1 first and repair valid behavior test-first, preserving approved selected-installation/tenant, DNS/TLS, network and discovery guards. Do not merely weaken the fixture. The prior R1-1 real probe/router checks now pass and must remain effective. No approved-plan amendment was requested by reviewer 2; if an actual conflict arises, report its exact text for the single planner rather than redefining an AC. Local AC4 remains unrun without a grant. Docker works. Use separate owned resettable DBs per process. Run module-add serially with make/image checks because it mutates go.work; serialize lint use when shared tool locks apply. Preserve failed environment receipts and qualify the final head honestly.

After this pass, fresh review round 3 normally covers fix commits from 24c13fd1f3908836aa2cd020eee295770913fb53 and the areas they touch, unless review-check demands a full review. Main runs the referee. No verifier until MOVE ON.

Actually open global CLAUDE.md and applicable project rules, then these SKILL.md files under `/home/justin/.agents/skills/`: leorna, engineering-best-practices, receiving-code-review, test-driven-development, systematic-debugging, mutation-testing-discipline, git-commit-rules, plus security-best-practices, multi-tenant-auth-management, api-contract-drift-guard, backend-data-migrations and other applicable plan specialists. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and ac-verification.md. Follow actual current shared memory/ownership without treating older server grants as this story's authority. Return read receipts; never edit skills or memory yourself.

Read the supplied review/verification report and reproduce each finding against the exact candidate. State its concrete scenario and root cause before code changes. For a valid finding, write a failing regression test that would catch the actual problem, make the smallest in-scope fix, rerun focused checks, then required full gates and affected canonical ACs. Preserve existing controls and prove critical assertions can fail using capped mutations. Do not solve a test failure by weakening the approved behavior or adding an auth bypass. If the reviewer exposed a real trade-off outside the approved plan, report it to main for the one planner's amendment/user decision; continue unrelated authorized fixes meanwhile.

Preserve all AC1–AC6 clauses and exact canonical test names from the approved plan. AC4 is live; no target/grant exists unless a specific later authorization is supplied. Never remove a failing AC, mark it live, relabel an unrun test as passing or silently narrow a previously approved requirement. Existing client production code remains read-only; real client resolver proofs use the pinned archive as planned. No cross-repo Go imports or weakened same-origin/redirect policy.

Do not rebase or bring main in during a fix pass. Commit on the existing feature branch with inherited Leorna identity; no overrides, AI trailers or CLAUDE.md staged. Batch necessary docs/records with the fix so every new commit can be reviewed. No story merge, push, PR, ClickUp write/post, evidence upload, CI workflow change, live cloud/DNS mutation/deletion, registry push or real tool-home changes.

Use exact CI-compatible tool bindings and real DB gates. Own a separate `_test` database for each parallel resettable gate invocation; do not reuse sibling DBs. Keep all receipts tagged with the actual head, own logs/screenshots, meaningful UI captures when visible behavior changes, and actual exits. Missing-DSN skips do not satisfy full DB coverage. Retain failed/baseline receipts and distinguish environment issues from regressions.

WSL mutation runs always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; consult current mutation skill if the user bus fails rather than dropping the cap. SIGTERM/137/143/Killed needs earlyoom inspection before interpretation, and any runaway must be reported/re-run under cap. Use small scalar assertions and owned disk scratch/TMPDIR/Chrome profiles under `/home/justin/.hermes/cache/scratch`, not RAM-backed /tmp. No shared worktree prune or unowned cleanup.

Return each finding ID with disposition (fixed + regression + commit, or rejected + evidence), old/new head, base, changed files, full gate outcomes, AC/evidence updates, current limitations and ready-for-next-review status. You never declare the independent review/AC gate passed yourself. Report other issues in found_else rather than silently folding them in.

Lessons: only new reusable proven `skill_lessons[{skill,lesson,evidence,enforce}]`, enforce none or a one-line hook/test/lint/script proposal stating what/where; empty normal. No shared skill/memory edits. End `MAIN SESSION: check and save these skill_lessons now.`
