# PLANNER — 86bcm901u-content-quality-gate [Leorna]

## Requested outcome and authorization

Plan ClickUp story `86bcm901u`, **Content quality gate (CI)**, for the control plane. Justin selected this card and explicitly authorized a **story-specific exception** to the standing no-CI-changes rule. Necessary `.github/workflows/*` changes may be designed for this story. The exception does not apply to other stories, unrelated CI cleanup, secrets/permissions changes, publication, deployment or merge. Existing checks must not be weakened.

**Planning only.** Save the plan; do not create a branch/worktree, edit application/tests/workflows, run application tests, commit, push, open/merge a PR, trigger remote CI, or modify ClickUp. Nothing gets built until Justin says **go** after seeing your plan.

### Justin's words (verbatim)

> Ok lets start with 86bcm901u. Like I mentioned plan put it to opus make sure ir loads the right skills. And do not worry about the CI stuff make an exception for this story

## Model, role and mandatory skills

You are the **Opus 5.5 xhigh PLANNER**, responsible for architecture and implementation-ready design. Sol 6.1 xhigh will build the approved plan without redesigning it. If a fundamental choice remains unknown, mark the dependent task gated and present short options; never manufacture an interface.

Call `skill_view` separately and fresh, in this order, and include the loaded names in your result:
1. `leorna`.
2. `engineering-best-practices` (the Leorna library baseline).
3. `implementation-planning`.
4. `cicd-staging-prod-agents`, `security-best-practices`, and `qa-testing-local-cloud` for this content-validation, transformer-rendering and CI story. Apply their relevant sections proportionally: this is not authorization to redesign staging/production or create a deployment pipeline.
5. Other specialists only if discovery warrants them (e.g. `api-contract-drift-guard` if an OpenAPI change is actually required; `systematic-debugging` for a real existing bug).

Load relevant linked references. The project rules and this explicit exception win over generic defaults. Add a `## Skills` section naming builder/reviewer specialists and identifying every loaded skill with a Mandatory Validation and Agent Defect Loop section. Return those names in `defect_loop_skills[]`; the dispatcher, not you, runs independent roles. You cannot spawn children.

## Context to load and current source reality

Follow `leorna` Step 1: shared memory index, `leorna-workflow.md`, relevant AGENTS.md and topic notes. Notes live at `/Users/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory/` (shared across repos). Especially read `clickup-evidence.md`, `leorna-control-plane-workflow.md`, `consistency-over-local-fixes.md`, `prefer-small-verified-scope.md`, and `no-ci-changes.md` with its **86bcm901u exception**.

Repositories: `/Users/justin/Leorna/leorna-control-plane` (primary) and `/Users/justin/Leorna/leorna-client` (read-only transformer/contract context if useful). Verify actual roots, current branches, instructions, current remote main and overlapping open PRs read-only. Do not treat stale local main as current: at 2026-10-22T17:31Z the control-plane checkout was on `main`, head `0ad43a3`, with only untracked `deploy/local/`. **Leave `deploy/local/` untouched.** Read current GitHub main/PR data via `gh`; no checkout or source mutation in this planning role. Never claim the completed loader absent just because the local checkout is behind.

At the earlier preflight no Leorna row was present. **Concurrency update at 2026-10-22T17:36Z:** another user session has `86bcm9016-prompt-kind` in planning (agent sa-0-4bc3dd39; plan `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md`) and `86bcm901v-library-catalog-browser` stopped for a routing discrepancy. These are separate-session records, not your assignments. Preserve them and all Figma work; do not mutate shared notes/board/global config. Read available sibling plans/briefs only as needed to identify shared loader/schema/transformer/workflow paths. Return overlaps and proposed build order; independent read-only planning can continue and no builder is authorized here.

GitHub identity: Justin-Leorna; Git identity Justin Issa <justin@leorna.com>. Keep the OpenAPI-only boundary between repositories; no cross-repo Go imports and no change to `toolconnector.Connector` in this story. CI exception does not waive repository boundaries.

## Live ClickUp facts and full acceptance contract

Workspace `90141510532`, PI-2 tag `pi-2`, assignee resolved live from `justin@leorna.com` to `240157212`. Story `86bcm901u` is **to do**, high priority, size M, E10 Content Library, repo **control-plane**.

Its only incoming dependency is Christian's `86bcm9018`, **Content library format + loader (shipped with the product)**, freshly re-read as **complete** on 2026-10-22. Other dependency records whose `task_id` is another card are downstream dependants, not blockers. Re-read the story and relevant comments through the ClickUp connector if available; never write ClickUp. If your child tools lack connector access, use the complete verified card text below and say comments were not fetched; do not ask Justin to paste it.

### User story
As a product team, I want every library item validated and rendered for each tool in CI, so that we only ship content we can stand behind.

### Context
Ties into the existing ConfigTransformer per tool. Reuse ideas (MIT) from agent-skills: scripts/lib/skill-lint.js, validate-skills/commands/reference-links/versions, and its evals (evals/cases + graders) for behavioural checks that a skill actually fires.

### Acceptance criteria (preserve exactly)
1. Given a library change, when CI runs, then every item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned.
2. Given a render failure for a declared-supported tool, then CI fails with the item and tool named.
3. Given a passing run, then a per-item compatibility report is produced.

### Verify
CI pipeline run on a deliberately broken item (fails) and the real library (passes).

### Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Design requirements for this planning artifact

Find existing loader, library schema/source and actual transformer ownership. Design the smallest complete integration using real paths/interfaces. Explicitly explain how all three real tool renders are checked within the control-plane story while preserving the repository boundary, and how unsupported tools are represented versus genuine declared-supported render failures. Don't silently substitute stub rendering or schema-only checks for real transformer coverage. If it needs another repo to change, make that an explicit decision rather than extending scope yourself.

Cover trigger/path rules, deterministic validation, secret scanning, item/tool-qualified failures and compatibility report format/artifact handling. Reuse existing CI/gates; preserve their security properties. Evaluate only the relevant upstream validators/evals and licensing with current primary sources if needed. Do not execute bundled untrusted scripts, expose credentials or create an unrelated model-evaluation platform. State which requirements are ready and which need evidence/approval.

The prior gh token had only gist/read:org/repo scopes (no workflow scope), so eventual workflow publication may need Justin's user-side auth action. Record this as a future publication prerequisite, not a blocker to planning, and never handle credentials or broaden permissions yourself. Do not publish/trigger CI now. Distinguish local proof from the card's required hosted good/broken CI runs: future push/PR/remote-run authority is still needed and unperformed remote evidence stays NOT VERIFIED.

Plan one named test/check per acceptance criterion plus happy/failure cases and deliberate-failure sensitivity proof. Include normal control-plane `make check` (real Postgres coverage) and `bash ./scripts/test-module-add.sh`, plus relevant transformer checks if required, without inventing passing results. No application test execution in this planning role.

## Evidence and later pipeline (must be carried into the plan)

After **go**: builder **Sol 6.1 xhigh**; two separate fresh full reviewers in parallel (**Opus 5.5 xhigh + Sol 6.1 xhigh**); finisher **Sol 6.1 xhigh**, after both reviews. Behaviour-changing fixes get both models again. Applicable Agent Defect Loop ends with a fresh **Opus 5.5 xhigh verifier** before hand-over. If an Opus role reaches its limit the dispatcher asks Justin whether Sol may proceed; never switch automatically. Justin's paste-ready review prompt remains the optional third check.

Every story collects evidence while building under `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u/`: one screenshot for each visible AC, gate logs tied to exact head, required good/broken CI receipts once authorized, and a live/manual invocation of the real content-quality gate. Distinguish that real CI/CLI run from unrelated deployed-app demos. Honest NOT VERIFIED entries for unavailable checks. Plan the AC -> check -> result table and closing-comment draft; inspect screenshots/logs for privacy before anything leaves this Mac. ClickUp comments/attachments are posted only on Justin's **post**; he changes status himself.

Leorna stays branch + PR on request. Future branch name is exactly `feat/86bcm901u-content-quality-gate`, created only after plan approval. No push/PR without request, never merge.

## Output ownership and structure

Write only your plan to `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`. Do not edit shared notes, board, handoff or ledger; return proposed updates to the dispatcher. Use an honest discovery/time forecast and observed start in the plan, not a guaranteed ETA.

Make the plan self-contained and build-ready for Sol: playback, current immutable source identity, approach/interfaces/data shapes, exact touched files, ordered vertical tasks with commands and meaningful RED/GREEN expectations, tests per AC, decisions, risks, assumptions, overlaps and release/evidence boundaries. Put open questions immediately after the title, each with 2–4 short lettered options and a recommended choice. Write the rest assuming recommended choices so **go** accepts them without another planning round. Don't ask again whether CI edits are permitted for this story: Justin already approved that exception, but not implementation.

End the task list with **Docs & records**, naming every record to update (module README, delivery/stories.json as applicable, this plan, shared workflow notes, this Leorna handoff and evidence/comment draft). Record the scoped CI exception in the plan so builder and both reviewers inherit it. Do not add an unrelated Figma build bump or edit its CLAUDE.md.

Other problems remain `found_else` with severity/evidence; do not fix or silently include them. End with a concise structured result: plan_path, summary, playback, choices, questions, risks, touches, overlaps, loaded_skills, defect_loop_skills and found_else. Clearly state **plan only; no implementation/tests executed**.
