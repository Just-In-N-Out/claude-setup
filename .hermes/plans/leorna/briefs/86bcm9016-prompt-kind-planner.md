# PLANNER — 86bcm9016-prompt-kind [Leorna]

## Authorization and output

Justin selected ClickUp story `86bcm9016`, Add 'prompt' as a content item kind (end to end). You are the **Opus 5.5 xhigh PLANNER**, not the builder. Research and write the implementation-ready plan only. Make no worktree, branch, code/test/config edit or commit. Do not build, install, run application gates, push, merge, open a PR, post ClickUp evidence or change a ClickUp status. Any later build requires Justin's **go** on your returned plan.

Save the plan to `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md`. You own only that plan and any read-only research receipts under `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/planning/`. Do not update the shared board, shared notes or handoffs; return proposed changes to the dispatcher.

## Clear request

Design the end-to-end addition of reusable `prompt` pack items across the control plane and client, including validation/versioning, native tool output or an explicit logged skip when unsupported, OpenAPI regeneration, and a publish-to-sync integration check. Investigate the actual current main branches and tool support; do not assume paths or capabilities from old notes. Produce a complete architecture/design handoff that Sol can build without redesigning.

### Justin's words

> Ok lets start with 86bcm9016. Like I mentioned plan put it to opus make sure ir loads the right skills.

Earlier session instructions still apply: a pick dispatches only the Opus planner; nothing builds until Justin says go; Opus plans, Sol builds, two independent full reviewers (Opus + Sol), ask Justin before replacing a quota-limited Opus role, and collect ClickUp evidence for every story.

## Required skill calls — load fresh and report the actual names

Your first steps must call `skill_view` in this order:
1. `leorna`.
2. `engineering-best-practices` (Leorna library's primary workflow).
3. `implementation-planning` (your PLANNER role).
4. `api-contract-drift-guard` (the card explicitly requires an OpenAPI enum change and regeneration).
5. `security-best-practices` (untrusted pack content and native filesystem output).

Load `multi-tenant-auth-management` if tenant persistence/authorization is touched, and `backend-data-migrations` if you propose a schema or data migration. Load other applicable specialists if your research warrants them, naming them rather than silently omitting them. A bug uncovered while researching is investigated with `systematic-debugging` before a proposed repair; do not fold unrelated bugs into this card.

Follow each skill, with these project/user boundaries winning: planning only, no automatic merge/push/post, no CI workflow changes, no broad connector API redesign, no authentication bypass. Children cannot spawn agents: any skill's independent problem-finder/verifier steps are later dispatcher-owned roles, not steps you can waive or self-complete.

The plan must have `## Skills`, with the required builder/reviewer/finisher specialist skills and which contain the **Mandatory Validation and Agent Defect Loop**. Return `loaded_skills` and `defect_loop_skills` so the dispatcher can check the actual skill calls. Builder later loads `test-driven-development`, plus `mutation-testing-discipline` for identity/permission/data-integrity guards; both later reviewers load `requesting-code-review` + `code-review-practice` + mutation skills and do full independent reviews; finisher loads `receiving-code-review`, `git-commit-rules`, TDD; a fresh Opus verifier executes applicable loop gates after fixes.

## Context to load

Follow leorna Step 1: read `/Users/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory/MEMORY.md`, then `leorna-workflow.md`, both repos' `AGENTS.md`, and the relevant topic notes. In particular read `leorna-control-plane-workflow.md`, `consistency-over-local-fixes.md`, `prefer-small-verified-scope.md`, `infer-and-list-assumptions.md`, `no-auth-bypass-from-chat-guidance.md`, `no-ci-changes.md`, `clickup-evidence.md`, and the hand-over notes/delivery README needed to plan Docs & records. Load server/live-tool privacy notes if proposing a real integration run.

Repositories:
- `/Users/justin/Leorna/leorna-client`.
- `/Users/justin/Leorna/leorna-control-plane`.

Check current git status and remote-main facts read-only; do not check out or modify branches. Last parent check: client clean on `feat/86bbu3xmt-context-switching`, head `9c09193`; control plane on main `0ad43a3` with untracked `deploy/local/` (leave it alone). Those local refs are stale: source your plan from fresh remote main (read-only gh access or fetch refs without checkout), pin the exact main SHAs, and compare local assumptions. Client PR #19 freshly verified MERGED at `2026-10-22T17:19:17Z`, merge `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c`; three PR checks pass. Other-session Figma work exists on the shared dispatch board; it is unrelated and must not be restarted/changed. No Leorna job existed on the board at selection.

## ClickUp source — re-read the card live

Workspace `90141510532`; task `86bcm9016`. The connector is connected. Read description, acceptance criteria, Verify, DoD, dependencies and relevant comments/notes using discovered connector schemas. Do not write ClickUp. Fresh parent snapshot (2026-10-22 13:22–13:24 EDT): assigned to Justin Issa (`240157212`, `justin@leorna.com`), to do, high priority, size M, repo both. Its only incoming prerequisite is Christian's loader `86bcm9018`, which is **complete**; independently confirm current status. A task GET also returns downstream edges: only an edge whose `task_id` equals this card is an incoming dependency.

The parent-read acceptance criteria, verbatim:
1. Given a pack version containing a `prompt` item, when it is saved, then it is validated and versioned like other kinds.
2. Given a synced prompt item, when the client applies it, then it lands in each tool's native prompt/command location (Claude Code, Codex, Cursor) per the transformer.
3. Given a tool with no native prompt location, then the item is skipped with a clear, logged reason (no failure).
4. Given the OpenAPI contract, then the item kind enum includes `prompt` and clients regenerate cleanly.

Verify: unit tests per transformer + integration test publish→sync of a prompt item.

DoD: unit + integration tests (happy path + one failure), OpenAPI updated if API touched, lint/format/CI green including gitleaks and golangci-lint, demoable in isolation, short module README note.

Use live card content over this snapshot if it changed, and report the change. Verify each tool's native prompt/command support using official current documentation and installed version facts before choosing output locations; unsupported means an evidence-backed skip, not an invented native path or a silent product fallback. Do not write Justin's real `~/.codex` or `~/.claude`.

## Plan requirements

1. Play back the request and define the intended end-to-end behavior, repo ownership and exact current main SHAs.
2. Put any open questions immediately after the title, with 2–4 short lettered options per question and a ⭐ recommendation. Write the plan using recommended options so **go** needs no redesign. If no questions, say so. Do not ask Justin directly.
3. Name actual source/test/OpenAPI/generated-client paths, interfaces/data shapes, validation/versioning rules, tool output/skip behavior, risks and assumptions, and a safe order across repos. Preserve OpenAPI as the only cross-repo boundary and the current `toolconnector.Connector` API. Do not change `.github/workflows/*`.
4. Map every live-card AC to at least one named proposed test and real execution/evidence step. Include failure cases, full project gates, and relevant deliberate mutation checks. Distinguish researched behavior from tests not yet run.
5. Plan ClickUp evidence **during the build**: screenshots for every visible AC, per-head gate logs, and a live/manual publish→sync run with real tools/app/Justin's own permitted server. Durable directory `/Users/justin/.hermes/plans/leorna/evidence/86bcm9016/`; screenshots `ac<n>-<what>.png`, logs `gates-<sha7>.txt`. If the live run is unavailable, explicitly plan NOT VERIFIED and the permission/prerequisite needed. Every screenshot/log is privacy-checked before leaving the Mac; no server domain/URL bar, tenant ID, token, email or dev-login details. Evidence is drafted at hand-over, posted only after Justin says **post**. Justin explicitly reconfirmed that screenshots must be taken **as the builder works**, not reconstructed at the end. Carry this into a named build task and the later builder handoff: capture the meaningful before/after state where applicable, one screenshot per visible acceptance criterion and the actual live/manual result, save the files durably as each check runs, and privacy-check each before upload. Justin's words: "also the agent should take photos as it is building to upload to clickup yeah?"
6. Include the role sequence: approved plan → Sol 6.1 xhigh builder → two fresh full reviewers in parallel (Opus 5.5 xhigh + Sol 6.1 xhigh) → Sol finisher after both → fresh Opus xhigh verifier for applicable Agent Defect Loop → hand-over only. Behavior-changing corrections get fresh dual re-review. Never merge/push/post automatically; Justin merges PRs. Builder must stop rather than redesign if the plan is wrong/incomplete.
7. Include exact file ownership/overlaps, an M scope estimate (revise if research proves larger), dependencies, release/rollback/migration notes where applicable, and a final **Docs & records** task naming every actual file: module README(s), OpenAPI/generated artifacts, delivery/stories.json, plan/hand-over/evidence draft and shared Leorna notes/handoff updates (dispatcher-owned outside your plan). Do not invent a BUILD bump or a CLAUDE.md change that this project does not require.
8. Future build branch name in each repo: exactly `feat/86bcm9016-prompt-kind`; do not create it now. Build preflight must use clean updated main and preserve `deploy/local/`.
9. Other bugs are `found_else` with severity and file/line or concrete evidence; list in an Other things found section, never fix or quietly widen scope.

Return a concise structured summary: plan_path, summary, playback, choices, questions (q/options/recommended), risks, touches, overlaps, found_else, loaded_skills, defect_loop_skills and pinned base SHAs. Do not return a giant replay of your investigation.
