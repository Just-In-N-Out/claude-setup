# Custom company domain — 86bccndx6

Status: FIXING REVIEW 2 authorized. Justin replied "1" to continue fixing R2-1, then review and verify. Verbatim decision saved at evidence/86bccndx6/review-2/justin.json; review-check now returns REVIEW AGAIN. Fresh Astra xhigh fixer 2 dispatches from the saved fixer-2 brief at head 24c13fd1f3908836aa2cd020eee295770913fb53.

## User instruction and next action

Justin requested Full pipeline, one shared plan, and an explicit "go" before implementation. His earlier model-change pause was lifted by: "ok great continue on the user story".

Configured roles are Astra xhigh. Original plan go remains approved; review-2 brake is resolved by Justin’s explicit option 1 continuation. Main persisted his reply verbatim, reran referee and received REVIEW AGAIN: fix R2-1 then review fix commits. Fresh fixer 2 uses briefs/86bccndx6-custom-company-domain-fixer-2.md. After handback check earlyoom and lessons, dispatch fresh reviewer 3 on the exact fixed head, delta from reviewed head 24c13fd plus touched areas unless referee requests full. Continue review/fix until MOVE ON, then fresh verifier → blind auditor → ac-check --reviews → local handover. No live target/grant, publication or story merge authorized.

## Durable intake

- Full live card: evidence/86bccndx6/intake/card.json.
- Task comments: evidence/86bccndx6/intake/comments.json (none).
- Named prerequisite: evidence/86bccndx6/intake/prerequisite.json.
- Planner brief: briefs/86bccndx6-custom-company-domain-planner.md.
- Builder brief: briefs/86bccndx6-custom-company-domain-builder.md.
- Approved plan: evidence/86bccndx6/plan-approved.md; decisions: evidence/86bccndx6/approval.json.
- Completed single plan: 86bccndx6-custom-company-domain.md.
- Evidence root: evidence/86bccndx6/.

## Review 1 and required next step

Full reviewer independently checked base 3aa979df41568c9039007f66d7f32193e66a8533 through head 6125c7e4da64bafbe2f8d1ec413abb8a553f8f5a. One P1: R1-1 at internal/installer/domain/probe.go:127, production TLS readiness rejects the actual router's ordinary root 303 redirect, blocking activation and resume. Production probe/router reproduction fails with valid TLS; acceptance fixture stubs had hidden it. AC2/AC6 not accepted; AC4 live/not_run. Required local gates independently passed, source remained clean, no earlyoom kills. Review records in evidence/86bccndx6/review-1/. Main ran review-check: REVIEW AGAIN, one P0–P2; Full round 2 must review the whole story after the fix. Fixer gets the exact finding/report/probe and must preserve DNS/TLS/discovery/security contracts. Reviewer skill_lessons and found_else empty, so nothing to save. After fixer handback, check earlyoom/lessons, dispatch a fresh FULL reviewer 2 with all earlier review records and dispositions, then run review-check. Do not move to verifier before MOVE ON.

## Completed builder handback

Final builder head `6125c7e4da64bafbe2f8d1ec413abb8a553f8f5a`; full handback `evidence/86bccndx6/builder/report.md`, result.json and candidate-artifacts.json. Builder reports full make check, DB JSON (804 pass events, zero failures/missing-DSN skips), module-add, Helm, image build/Trivy/packaged scanner, Windows launcher crossbuild, delivery checks and unchanged-client full check/lint/audit/39 UI tests passed. All 13 capped guard mutations killed; restored race matrix passed; no earlyoom kills. AC1/2/3/5/6 builder_passed with current-head logs/screenshots; AC4 not_run without live grant. Independent acceptance is pending. Builder explicitly did not claim initial named-test RED for composed AC3/AC6; focused slices and additional genuine base probes are retained. Own containers stopped; disk scratch/reproduction helpers retained. Client source unchanged. One proven, new security lesson saved by main in security-best-practices Go SSRF reference: explicitly reject deprecated IPv6 site-local fec0::/10; no enforce proposal. No other findings/lessons.

## Builder checkpoint

Verified from builder/preflight.md and git metadata: worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, base `3aa979df41568c9039007f66d7f32193e66a8533`. Shared main fast-forwarded to that upstream base only; no story merge. First commit `97588ba` adds hostname validation/readiness probes; later implementation remains in progress and is not yet reviewed/accepted. Builder scratch `/home/justin/.hermes/cache/scratch/86bccndx6-builder-SbV1af`. Preflight records required skill reads and Docker unavailable; no DB/image gate passed. Main asked Justin asynchronously to enable Docker Desktop Ubuntu WSL integration. Builder checkpoint later confirms docker info succeeds with Docker Desktop 29.0.1; that setup request is resolved. Independent implementation and full DB/image gates continue. No live target/grant. Latest builder checkpoint at head a56d171 reports focused RED/GREEN/race and first-slice regressions passed (without DSN, not DB proof), with canonical/browser/client/mutation/full gates continuing. Main has not independently judged tests.

Reviewer-2 brief is populated for the new head; verifier, auditor and finisher briefs remain dispatch-held templates with head/base placeholders. Fill exact candidate and required gate status before dispatch. Never launch auditor with earlier reports/context.

## Planner result

Control-plane-only implementation; unchanged client is the real discovery consumer. Current bases: control plane 3aa979df41568c9039007f66d7f32193e66a8533, client feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6. PR78 integrated; no duplicate story branch/PR/plan. Six ACs: registration/CNAME, verified activation/generated continuity, safe errors, live discovery/client, proposed guards, proposed resume/recovery. Questions recommend installer configuration; one unused direct-CNAME subdomain; enable Docker WSL integration; explicit live scope after local review; existing authentication mode plus OAuth callbacks as needed. Sibling 86bcm927y is also planning per fresh shared memory; pre-build overlap reconciliation remains required. No extra findings or reusable lessons.

## Verified routing facts

Latest ownership, 2026-11-04 22:52 UTC: sibling 86bcm927y is approved and its Astra xhigh /root/integrations_builder is running in a separate session. Brief: briefs/86bcm927y-integrations-catalog-tiles-builder.md. Use independent worktrees and test resources; reconcile shared files and preserve both stories. This supersedes earlier planning/awaiting-go sibling statements.

- Working directory: /home/justin/Leorna.
- Card title: Custom company domain for the control plane (leorna.<company>.com).
- Card is in progress, assigned to Justin Issa.
- Three card ACs: owned-domain registration + Scaleway CNAME display; switch public base URL/discovery only once CNAME/TLS ready while preserving old access; clear error + working generated host for misconfiguration.
- Verify requires a live test subdomain, /.well-known/leorna returning tenant, and actual client resolution.
- DoD: unit/integration happy and failure cases, OpenAPI if touched, formatting/lint/CI, isolated demo, short module README.
- No structured dependencies, linked tasks, subtasks, attachments or PR links on the card.
- Named textual prerequisite 86bccndwq (Client entry point: self-enabling discovery + admin connect card) is live-status complete, owned by Christian; its description names control-plane PR #78.
- GitHub read-only search found control-plane PR #78 merged and client PR #3 (domain wizard) merged. These are background/dependency work, not this story.
- Exact card-ID searches returned no PR in either repo.
- No local/remote-tracking branch containing the card ID or custom-domain name; no existing matching plan filename. Content search found this card only in shared leorna-workflow.md.
- gh active identity is Justin-Leorna; no identity changes made.
- Main checkout client HEAD f105e27814b6efbec67059687963e722933acec2, main with only untracked .claude/; control-plane HEAD e2254e0100a482b9201edf9b96f01936e4486d44, main behind its existing origin/main by 49 commits, only untracked .claude/. These are intake observations, not the approved current bases; planner must fetch/read current main without changing checkouts.
- Existing sibling worktrees: client content-usage-analytics; control-plane agent-definitions, prompts-collection, mcp-templates, starter-packs, create-pack, remove-reorder, customise-shipped-item, quick-start, content-usage-analytics. Do not alter them.
- Root/ancestor AGENTS.md files checked at /, /home, /home/justin and /home/justin/Leorna: absent. Both repos' root AGENTS.md read. Root CLAUDE.md absent in both repos at intake; planner must locate applicable synced instructions without inventing them.
- Rules loaded: /home/justin/.claude/CLAUDE.md; Leorna skill; feature-dispatch (routing sections), ac-verification.md, review-loop.md; github skill. Engineering specialists and shared Leorna context are the planner's work, not yet loaded by a pipeline role.
- earlyoom journal check returned no entries.

## Setup sync limitation

The required command /home/justin/.claude/setup/sync.sh pull was attempted with sandbox_permissions=require_escalated. It exited 1 because /home/justin/.claude-setup.git is mounted read-only and setup-sync.lock could not be created. This was reported to Justin. A subsequent read-only ls-remote succeeded and remote main equalled the local setup HEAD: 41216e18ffb2d82a70a8daca939d570b9585768d. This establishes commit equality at intake, not a successful pull. Do not bypass the mount or claim sync succeeded.

After resumption, sync pull first encountered a concurrent lock; after the lock cleared, an escalated retry again failed on the read-only mount. Fresh read-only comparison showed local and remote main both b56e0260bc46a40b9ff2573e571609efedabb9bc. No mount/lock bypass was attempted. The setup commit equality is current; pull itself remains unsuccessful.

## Persistent boundaries

Keep ClickUp read-only. Never merge into main. No project push, PR creation or evidence posting without explicit request. No .github/workflows changes without explicit permission. No live provisioning/DNS/TLS changes before the concrete approved live scope is established. No secret/token or real test-server URL in chat, PRs or ClickUp. Only Justin's approved servers. Model change and explicit plan go are confirmed; no additional build approval is required.

## Fix 1 completion

Fixer report: evidence/86bccndx6/fix-1/report.json. Commit 24c13fd1f3908836aa2cd020eee295770913fb53 changes TLS readiness to /.well-known/leorna and adds real probe/router tests while retaining strict redirect/trust/discovery guards. No plan amendment reported. Five touched files; worktree clean. Full required local gates passed, 804 DB pass events, 39 client UI tests, three capped mutations, current-head AC screenshots. AC4 remains not_run. Module-add temporarily changes go.work: its gate must run serially with make/image checks or isolated; learned after concurrent receipts needed clean reruns. Skill lesson saved, enforce none; found_else empty. Reviewer 2 must independently verify the entire story and fix.

## Review 2 handback — current decision

Full reviewer confirms R1-1 fixed, finds R2-1 P2 at internal/installer/scaleway/domain.go:382: generated recovery checks generated discovery before repairing a missing LEORNA_GENERATED_BASE_URL alias; custom origin still works but recovery makes zero writes. Reproduction and passing broken-custom-DNS control are in review-2/recovery-probe.log. Reviewer recommendation: retain installation/tenant guards, establish trusted baseline using still-working selected custom origin, restore generated pair and verify; fixer must independently assess. AC6 not accepted despite canonical fixture pass; AC1/2/3/5 locally accepted by reviewer, AC4 live/not_run. All required gates passed or were completed through documented serial continuation after a shared lint lock; 804 DB pass events, client39UI, five capped mutations, no earlyoom kills. Main has not judged those logs or acceptance. review-2/report.json and live-handoff.json provide exact receipts and artifact/schema paths. Current artifact bindings become stale after any source fix. No live operation, publication, merge or new branch work authorized. Fresh independent verifier/auditor have not run.
