# PLANNER brief — 86bcm927y integrations catalog tiles
Role: PLANNER. Pipeline: Full. Configured pipeline role: gpt-6-astra / xhigh.
Status: planning only. Justin has explicitly resumed after the model switch. Implementation needs a separate "go" after he sees the plan.
Plan destination: /home/justin/.hermes/plans/leorna/86bcm927y-integrations-catalog-tiles.md
Repo: /home/justin/Leorna/leorna-control-plane
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/
Intake snapshot: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/intake/clickup-snapshot.json

## Clear request
Plan the admin console integrations catalog tile UI for ClickUp story 86bcm927y. Read the complete card and its two prerequisite cards from the supplied live snapshot, follow shared project context, inspect current remote main, and produce an implementer-ready plan. Do not implement or start other agents.

## Authorization and current facts
- Justin already chose Full. Do not ask Full/Mini again.
- Setup sync pull was attempted by the orchestrator with require_escalated but failed with a read-only filesystem at /home/justin/.claude-setup.git/setup-sync.lock. Justin then ran /home/justin/.claude/setup/sync.sh pull in his own desktop terminal; it returned silently, and he confirmed he ran it. He later confirmed continuation. Treat the user-run pull as the completed prerequisite; do not reintroduce the resolved hold or bypass filesystem controls.
- Pipeline model file was read on resumption: model = "gpt-6-astra", model_reasoning_effort = "xhigh". Native pipeline_planner is configured identically. Never change model/settings.
- Global instructions and repo AGENTS.md were read. Repo CLAUDE.md is absent at the expected location, and no tracked synced copy matching the control-plane path was found. Check applicable parent instructions and shared context for an existing relocated project file; report absence honestly, never invent or create a CLAUDE.md or edit generated AGENTS.md.
- Preliminary local git snapshot: main e2254e0100a482b9201edf9b96f01936e4486d44, cached origin/main 9135f4e9b82c0d5a77b88542a1b3e8b0fb990969; main behind cached origin by 49 commits; tracked tree clean, untracked .claude/ contains sibling worktrees. These are NOT a fresh remote-main verification. Fetch and pin current main as the planner skill instructs.
- Card state in live intake: in progress; assigned to Justin. Prerequisites 86bcm927v (Integration tile model + parameterised MCP template format) and 86bcm901v (Library catalog browser) both marked complete. Snapshot contains their full descriptions. Verify their actual merged implementation in current main, without claiming ClickUp completion alone proves it.
- Main session's earlyoom check on resumption returned no entries. You are not alone in the codebase: other stories have worktrees here. Do not revert others' edits, modify their resources, move shared main, or prune worktrees.

## Required skills: actually open the SKILL.md files
Load in order, announcing use:
1. /home/justin/.agents/skills/leorna/SKILL.md — follow PLANNER and Step 1 shared-memory/project-context instructions.
2. /home/justin/.agents/skills/engineering-best-practices/SKILL.md
3. /home/justin/.agents/skills/implementation-planning/SKILL.md
4. Applicable control-plane specialists, explicitly inspect all four and identify applicable requirements:
   - /home/justin/.agents/skills/security-best-practices/SKILL.md
   - /home/justin/.agents/skills/multi-tenant-auth-management/SKILL.md
   - /home/justin/.agents/skills/api-contract-drift-guard/SKILL.md
   - /home/justin/.agents/skills/backend-data-migrations/SKILL.md
5. /home/justin/.agents/skills/github/SKILL.md and matching reference for GitHub reads; git-commit-rules only if applicable (no commits in planning).
If you discover a bug needing diagnosis, load systematic-debugging before planning its fix; don't fold unrelated findings into this story.
Read /home/justin/.claude/CLAUDE.md, current /home/justin/.codex/AGENTS.md, all applicable repo AGENTS.md and any existing project CLAUDE.md.
Read dispatcher /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md and required planning, review-loop.md, ac-verification.md references. Codex header controls model/tools. Ignore Hermes board/WhatsApp/status pings. No nested subagents: the orchestrator owns every role.
Capture a concise skills-loaded receipt in your allowed planning evidence, with actual paths and read success, and report it. Merely naming a skill in prose is not loading it; avoid output truncation.

## Shared context and git
Resolve shared memory as directed by leorna: /home/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory (the -home-justin repo memory paths link here). Read MEMORY.md, leorna-workflow.md, leorna-control-plane-workflow.md, task-topic notes, design rules, no-ci-changes.md, and clickup-evidence.md. Read repo delivery/README.md and AGENTS-linked docs.
A planner fetches main and records the exact SHA but does NOT fast-forward the main checkout, create a story branch/worktree or commit. Follow the explicit HTTPS/gh fetch recipe, without switching auth, remotes or credential configuration. Verify gh identity once. Research the fresh pinned remote main (git show/git grep at that ref) rather than silently researching the stale checkout. Use scoped git searches; avoid sibling .claude/worktrees.
Specify the future branch feat/86bcm927y-integrations-catalog-tiles and a dedicated worktree under /home/justin/Leorna, created only by the builder after go. Builder must recheck/freshen main according to Leorna rules before branching and preserve sibling work.
Inspect host prerequisites per skill: command -v go make gcc golangci-lint govulncheck, cgo, Docker availability; check current CI-pinned tool versions. Identify missing prerequisites as plan questions, not builder surprises. Don't install or change host configuration in planning.

## Card requirements (verbatim, already read live)
Title: Integrations catalog - tiles UI in the admin console
As an admin, I want a tile grid of available integrations where I pick a service and fill in only what's specific to my company, so that setup is fast and obvious.
Context: Reuse the existing tile-grid UI pattern (cloud / catalog tiles).
Acceptance Criteria (test-backed):
- Given the admin console, then predefined integrations appear as tiles with a short description and the parameters they need
- Given a tile, when I enter the required values (e.g. my company CRM's URL), then the form validates them before saving
- Given a configured integration, then it becomes an item I can add to any pack (and appears in the pack builder)
- Given a save or change, then a change-audit record is written
Verify: UI integration test + recorded demo
Definition of Done: Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
Dependencies: 86bcm927v, 86bcm901v. Repo: control-plane. Size M.
No comments, subtasks, attachments, or additional checklists were present in the live card.

## Plan requirements
- Questions first, near title; each real decision has 2–4 short lettered options and a recommended choice. Draft against recommendations so go can approve it. If none, say no blocking product questions. Do not ask Justin directly.
- Number acceptance criteria AC1, AC2, etc. Preserve the card's meaning; explicitly mark additional proposed criteria if needed. Each AC must name a concrete test (whole name on one line), actual command, negative controls and evidence capture requirement.
- Tag (live) immediately after AC id only if Justin alone can run it. Investigate an agent-run isolated browser demo before calling it live. A recorded demo is explicitly required, so give its real capture format, capture point, durable path, and method; screenshots alone do not silently replace the demo.
- Include scope/exclusions, assumptions, risks, open questions, dependency verification, pinned current-main SHA, exact affected files/areas with evidence, design/data/API/auth decisions, implementation steps and named test-first tasks.
- Name evidence capture as a build task: before-state captures before visible changes, one genuine screenshot per AC, UI captures for visible behavior and actual terminal-run captures for nonvisual behavior; evidence under the root above. Head/base AC receipts and independent screenshots will be collected separately by verifier and blind auditor.
- Plan complete project gates from leorna, not just focused tests. Include Postgres-backed test execution proof/no accidental env skips, canonical make check with verified CI-compatible tools, module-add check, appropriate UI/browser tests, gitleaks/lint/format and API regeneration if touched. Hosted CI remains unrun until a separately authorized push.
- List applicable Agent Defect Loop skills. Full pipeline after go: builder test-first; fresh independent reviewer(s), fixer(s) and review-check.sh loop; only after MOVE ON fresh verifier, then blind AC auditor, then ac-check.sh --reviews; handover after ALL ACCEPTED or READY FOR THE USER, retaining owed live checks.
- Include role skills for later briefs: all roles leorna + engineering-best-practices + relevant specialists; builder TDD and mutation-testing-discipline for guards; reviewers requesting-code-review + code-review-practice + review-fix-cadence; fixers receiving-code-review + TDD + systematic-debugging as applicable; verification relevant loop skills and ac-verification reference.
- End with a named Docs & records task with exact README, plan/approval copy, delivery record and handover artifacts applicable to this repo. No CI changes; no generated AGENTS edits; no project CLAUDE commits.
- Inspect overlap risks from actual git/worktree and current shared story notes, without reserving or changing sibling work.
- Other problems go in found_else with severity/evidence, never silently expand scope.

## Boundaries
Planning artifacts only. No branch, worktree, implementation, test edits, source commits, repo-wide fixes, CI workflow edits, push, PR, merge, ClickUp mutations, evidence posting, cloud provisioning, live-server writes or real tool-home writes. Read-only ClickUp/GitHub calls are authorized. Never read /home/justin/.hermes/.env. Do not expose credentials, server domains or tenant identifiers. Do not write skills or shared memory; give lessons to the main session.

## WSL memory and scratch
A command killed with SIGTERM/143/137/Killed may be earlyoom, not a test result. Check journalctl -u earlyoom since the run before classifying it; if killed, report command/time/memory and use systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 for reruns. Mutation runs always use the cap. Use unique role-owned scratch; /tmp is shared RAM-backed storage, so keep it small and put large temporary builds/browser profiles under an owned writable disk folder in /home/justin/.hermes. Do not delete shared resources. Pass explicit workdir to commands.

## Report contract
Return plan_path, playback, short summary, AC list, choices/questions/recommendations, risks, touched areas, overlaps, current-main verification, skill-read receipts, found_else, and skill_lessons.
skill_lessons is [{skill, lesson, evidence, enforce}], where enforce is "none" or a one-line proposed check (kind, what, where). Empty is normal. Only new, reusable, proven lessons; never edit skills/memory yourself. End exactly: MAIN SESSION: check and save these skill_lessons now.

## Justin's words (original request)
Work on ClickUp story 86bcm927y:
“Integrations catalog - tiles UI in the admin console”
https://app.clickup.com/t/86bcm927y

Expected repo: ~/Leorna/leorna-control-plane.

Follow Justin’s existing rules and the Full pipeline. Start with planning only; show me the plan and wait for “go” before implementation.

Before proceeding:
- Read the applicable AGENTS.md files, ~/.claude/CLAUDE.md, and the project’s CLAUDE.md. Never edit generated AGENTS.md.
- Read ~/.agents/skills/leorna/SKILL.md and follow its shared-memory and project-context instructions.
- Read the dispatcher rulebook at ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md and its required references.
- Actually open and follow the relevant Hermes SKILL.md files; merely mentioning a skill does not count.
- Run setup sync pull before dispatching the planner. Report any sync failure.
- Read the live ClickUp card, including its full description, acceptance criteria, verification requirements and dependencies.

The main session must orchestrate. Use fresh configured pipeline agents with fork_turns="none", and save each role’s brief before dispatching it. Put the required skills in each brief:
- Planner: leorna, engineering-best-practices, implementation-planning, and applicable control-plane specialists.
- Builder: required engineering skills and test-driven-development.
- Reviewers/fixers: the required review and receiving-code-review skills.
- Verification: fresh verifier, blind AC auditor, and the required review-check/ac-check gates.
Follow the configured review/fix loop and skill_lessons rules.

The plan must include numbered acceptance criteria, a test and evidence requirement for each, scope, assumptions, risks and open questions. Verify the current main branch and follow Leorna’s branch/worktree rules.

After I approve the plan, carry the authorized work through implementation, review, verification and handover.

Keep ClickUp read-only. Do not push, open a PR, post evidence, or merge without the authorization required by Justin’s rules. Do not change CI workflows without explicit permission.

Latest steering: "ok great continyue working on the user story". This resumes PLANNING after the Astra xhigh setting confirmation, not implementation approval.

