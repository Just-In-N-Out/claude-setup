# Custom company domain — 86bccndx6

Status: REVIEWING, round 1 FULL. Builder completed at 6125c7e4da64bafbe2f8d1ec413abb8a553f8f5a on feat/86bccndx6-custom-company-domain, base 3aa979df41568c9039007f66d7f32193e66a8533, clean; seven commits, 54 files +3179/-63. Fresh Astra xhigh pipeline_reviewer /root/custom_domain_reviewer_1 is running from briefs/86bccndx6-custom-company-domain-reviewer-1.md. No publication, story merge or live cloud mutation authorized.

## User instruction and next action

Justin requested Full pipeline, one shared plan, and an explicit "go" before implementation. His earlier model-change pause was lifted by: "ok great continue on the user story".

Configured file and pipeline tool declarations both specify gpt-6-astra at xhigh. Planner completed the one shared plan; main checked AC1–AC6, live marker AC4, questions, Docs and records, required-skill receipts and current worktree ownership. No earlyoom kills. Builder handback is complete and reviewer 1 is running. Next: intake review-1/review.json, run review-check.sh against this worktree/base/evidence and obey its last line. REVIEW AGAIN means fresh fixer then fresh full reviewer 2; MOVE ON means fresh verifier then blind auditor and ac-check --reviews; ASK JUSTIN means record his decision. Do not judge findings or gates yourself. Live permissions remain unspecified; Docker works and local builder gates passed. AC4 live resources remain unprovided. Do not ask for plan go again.

## Durable intake

- Full live card: evidence/86bccndx6/intake/card.json.
- Task comments: evidence/86bccndx6/intake/comments.json (none).
- Named prerequisite: evidence/86bccndx6/intake/prerequisite.json.
- Planner brief: briefs/86bccndx6-custom-company-domain-planner.md.
- Builder brief: briefs/86bccndx6-custom-company-domain-builder.md.
- Approved plan: evidence/86bccndx6/plan-approved.md; decisions: evidence/86bccndx6/approval.json.
- Completed single plan: 86bccndx6-custom-company-domain.md.
- Evidence root: evidence/86bccndx6/.

## Completed builder handback

Final builder head `6125c7e4da64bafbe2f8d1ec413abb8a553f8f5a`; full handback `evidence/86bccndx6/builder/report.md`, result.json and candidate-artifacts.json. Builder reports full make check, DB JSON (804 pass events, zero failures/missing-DSN skips), module-add, Helm, image build/Trivy/packaged scanner, Windows launcher crossbuild, delivery checks and unchanged-client full check/lint/audit/39 UI tests passed. All 13 capped guard mutations killed; restored race matrix passed; no earlyoom kills. AC1/2/3/5/6 builder_passed with current-head logs/screenshots; AC4 not_run without live grant. Independent acceptance is pending. Builder explicitly did not claim initial named-test RED for composed AC3/AC6; focused slices and additional genuine base probes are retained. Own containers stopped; disk scratch/reproduction helpers retained. Client source unchanged. One proven, new security lesson saved by main in security-best-practices Go SSRF reference: explicitly reject deprecated IPv6 site-local fec0::/10; no enforce proposal. No other findings/lessons.

## Builder checkpoint

Verified from builder/preflight.md and git metadata: worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, base `3aa979df41568c9039007f66d7f32193e66a8533`. Shared main fast-forwarded to that upstream base only; no story merge. First commit `97588ba` adds hostname validation/readiness probes; later implementation remains in progress and is not yet reviewed/accepted. Builder scratch `/home/justin/.hermes/cache/scratch/86bccndx6-builder-SbV1af`. Preflight records required skill reads and Docker unavailable; no DB/image gate passed. Main asked Justin asynchronously to enable Docker Desktop Ubuntu WSL integration. Builder checkpoint later confirms docker info succeeds with Docker Desktop 29.0.1; that setup request is resolved. Independent implementation and full DB/image gates continue. No live target/grant. Latest builder checkpoint at head a56d171 reports focused RED/GREEN/race and first-slice regressions passed (without DSN, not DB proof), with canonical/browser/client/mutation/full gates continuing. Main has not independently judged tests.

Reviewer-1 brief is populated and running; verifier, auditor and finisher briefs remain dispatch-held templates with head/base placeholders. Fill exact candidate and required gate status before dispatch. Never launch auditor with earlier reports/context.

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

Keep ClickUp read-only. Never merge into main. No project push, PR creation or evidence posting without explicit request. No .github/workflows changes without explicit permission. No live provisioning/DNS/TLS changes before the concrete approved live scope is established. No secret/token or real test-server URL in chat, PRs or ClickUp. Only Justin's approved servers. Model change is confirmed; explicit plan go remains separately required.
