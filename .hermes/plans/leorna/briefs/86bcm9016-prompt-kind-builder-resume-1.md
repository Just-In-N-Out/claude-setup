# BUILDER RESUME — 86bcm9016-prompt-kind [Leorna]

## Continue approved work, do not rebuild/re-plan

Justin's **go** (2026-10-22) and answers **1A 2A 3A 4A 5A** remain current. Read the approved plan `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md` and original builder brief `/Users/justin/.hermes/plans/leorna/briefs/86bcm9016-prompt-kind-builder.md`. All scope, evidence, ownership and publication boundaries still apply. You are **Sol 6.1 xhigh**, resuming committed implementation and unfinished validation, not an independent reviewer.

Fresh skills: `leorna` → `engineering-best-practices` → `test-driven-development` → `mutation-testing-discipline` → `api-contract-drift-guard` → `backend-data-migrations` → `security-best-practices` → `multi-tenant-auth-management`; also `systematic-debugging`, `concurrent-state-validation`, `git-commit-rules` before their operations, and `computer-use`/`playwright` if capturing GUI proof. Report actual loaded skills. Mandatory independent defect loops for API contract and migrations remain dispatcher-owned after build completion; never self-certify them.

## Authoritative entry state

Parent verified clean exact feature branches after builder1 returned:
- CP `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9016-prompt-kind`, branch `feat/86bcm9016-prompt-kind`, HEAD **`5a3b5c6ed26ef983d46f3e87e6c759580dbfda09`**, base `0da9f5443a2a49b157cf24b5d30301345d371d3e`.
- Client `/Users/justin/Leorna/leorna-client/.claude/worktrees/86bcm9016-prompt-kind`, same feature branch, HEAD **`1f259b0faaeb21cac0913ebb97a52d5f23bdc88b`**, base `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`.

Recheck roots, exact HEADs, index/status and current ownership before touching anything. Existing commits and evidence are valid task work, not cleanup candidates. No reset-hard, no recreation, no overwriting another worktree or sibling work. Parent makes no code/test changes while you own the worktrees.

Builder1 artifacts are durable at `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/build-20261022T183739Z/`: read `EVIDENCE.md`, `final-state.json`, `closure-check.json`, gate/mutation records and the draft hand-over files. Keep them historical and append a new run/head-scoped evidence directory; do not overwrite failed receipts or retroactively mark missing checks passing. Existing 12 PNGs are **screenshots of actual test logs**, not live product/menu proof. Parent checked all 12 files exist. Two initial failed Sync checks were fixture expiry/order mistakes, subsequently corrected and passed; not product RED. Do not reclassify them.

## Resolved invocation prerequisite — task-local change only

CP `make check` exited 2 because `scripts/verify-workspace.sh` invokes GNU `realpath --relative-to`, but inherited PATH selected macOS `/bin/realpath`. Original failure `gates-5a3b5c6.txt`; identical main script also failed (`baseline-main-workspace.txt`). No source repair was made.

Parent independently verified at 2026-10-22 15:24 EDT that **`/opt/homebrew/opt/coreutils/libexec/gnubin/realpath` exists and successfully handles `--relative-to`**, returning `leorna-control-plane` for the actual directory pair. Resolve this environmental prerequisite in **your task environment only**:

`export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"`

Confirm selected `realpath` and exercise `--relative-to` before rerunning the blocked gate. This is not permission to change global PATH, shell startup files, CI, Makefile or unrelated code. Preserve the original failure and record the exact selected tool/PATH prerequisite with new gate receipts. The parent proved tool capability only, not that the project gate now passes; you must execute the gate yourself. Honor the outside-branch stop rule for any genuinely new unresolvable outside failure; do not keep stopping on the prerequisite already resolved here.

## Finish every outstanding approved task

1. CP: rerun final-head `make check` with GNU coreutils PATH, task Go 1.27.3 and the actual task Postgres database; verify verbose real Postgres coverage. Run `bash ./scripts/test-module-add.sh`, scoped/final gitleaks and all other planned gate phases. Do not weaken/skip checks.
2. Client: final-head UI tests, separate lint/audit with CI's compatible golangci-lint, Windows vet and real Codex parse checks, and final-head real-Claude refresh. Existing client make-check exit 0 on `1f259b0` is historical valid proof; repeat if candidate bytes change or a remaining required proof needs it, not just for cosmetic status.
3. Execute **all 18 planned deliberate mutations** (none executed in builder1). Each must compile and fail the intended assertion; restore exact source/test state afterward and prove restoration. Apply test-first scoped repairs for genuinely uncovered in-scope defects; stop for Opus design changes rather than redesigning. Log tested revision, command, reason, results, restoration and final clean state. Preserve real failures; no false passing from supervisor/tee/receipt exit 0.
4. Prepare the approved install/build artifacts and independent real/menu checks. Capture evidence **during each actual check**, not a staged success image. Renew logs against final committed heads; map every AC to real test/result/artifact. No `.github/`, Connector API, auth or cross-repo import changes. Check contract snapshots byte-identical and protected fixtures unchanged.
5. Reconcile `EVIDENCE.md`, ClickUp draft, gate logs, PR/review/team drafts and Build notes against the final candidate. Do not change shared notes/handoff/board or any shared skill this pass; return proposed procedural updates to the dispatcher. Scope stays this story; unrelated findings go into `found_else`.

## Ownership, privacy and real-user boundaries

Shared board now has the separately approved **CI-gate Sol builder `sa-0-7ffe3dc2`**, worktree `.claude/worktrees/86bcm901u-content-quality-gate` in each repo. Catalog planner failed/held in its owning session; do not restart or substitute it. Preserve both rows/owners. CP README, library/bundle README and delivery/stories.json are known eventual integration overlaps. Separate worktrees permit independent checks; do not modify another owner's copy or integrate its unreviewed code. Required merge order remains prompt first, then quality gate with a prompt-capable renderer client pin. Freshly compare source/test diffs if overlap changes; coordinate an actual shared writer/test resource conflict rather than inventing a global hold. Own task Postgres database and physically resolved TMPDIR; never use or drop sibling databases. Parent measured about 23 GiB free; recheck and checkpoint/stop below ~1.5 GiB, never delete unrelated data.

Q5 still permits **one temporary real Cursor command file only**, backed up first, removed/restored afterwards and independently verified restored. No other real tool-home/config writes, especially `~/.codex`/`~/.claude`. Q4 requires a live publish→Sync run before PRs on **Justin's own server, installed by Justin from this feature branch**. Prepare the exact small user-operated prerequisite when local checks finish; do not provision cloud resources, use anyone else's server, handle secrets, or expose a server URL/tenant. If no permitted server is available, preserve committed passing local work and report **stopped: live-server prerequisite**, naming precisely what is missing. Do not mark ready-for-review/full acceptance if the approved live proof is still owed; do not silently switch to after-merge or waived proof. Any supported independent local work should be completed before that stop.

Privacy-inspect new screenshots with vision and logs before sharing. A log screenshot proves the check in that log, not installed UI/live-server behavior. Draft evidence only; no upload, comment, status/checkbox change. **No push, PR, merge or deployment.** No claims of independent review; both fresh Opus+Sol full reviewers and required fresh Opus verifier follow after build readiness.

Return concise status **ready-for-review** only when the approved build tasks/proof are complete, otherwise **stopped** with exact remaining prerequisite. Include both worktree HEADs/status, changed paths, per-gate and 18-mutation receipts, actual image/evidence paths with provenance, NOT VERIFIED, loaded_skills, defect_loop_skills, found_else and the minimal user step. Commit passing scoped work before an out-of-steps stop and retain worktrees for review.
