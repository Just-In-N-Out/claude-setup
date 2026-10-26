# PLANNER brief — 86bcm901v Library catalog browser [Leorna]

## Request and authorization

Plan the Library catalog browser story in `/Users/justin/Leorna/leorna-control-plane` on Opus 5.5 xhigh. This selection authorizes research and the plan artifact only, NOT implementation. Produce an implementer-ready architecture/design for a future Sol 6.1 xhigh builder. Make no branch or worktree, edit no source or repo documentation, run no application tests, commit nothing, and do not push, create a PR, merge, deploy, or change ClickUp. Stop after writing the plan and reporting it. Justin must approve the resulting plan with **go** before any build.

### Justin's words

> Ok lets start with 86bcm901v. Like I mentioned plan put it to opus make sure ir loads the right skills.

Earlier explicit instruction:

> Don't start anything until I pick. A pick only dispatches the Opus planner; nothing gets built until I say "go". Follow today's rules: Opus plans, Sol builds, two reviewers (Opus + Sol), ask me if Opus hits its limit, and collect ClickUp evidence for every story.

## First steps: explicitly load the right skills

Call `skill_view` yourself, fresh from disk, in this order and report the loaded list:

1. `leorna` — PLANNER role, including its Step 1 context-loading order.
2. `engineering-best-practices` — primary engineering workflow; project rules and the plan-only boundary take precedence.
3. `implementation-planning` — context-free builder handoff with exact real paths, interfaces, vertical tasks, tests and stop conditions.
4. Applicable specialists: `ux-frontend-workbench` for this new admin-console browsing/detail flow; `frontend-testing-workflow` for browser/UI acceptance planning; `security-best-practices` and `multi-tenant-auth-management` for existing admin authorization, tenant isolation and untrusted content/rendered previews. These skills supplement existing patterns, not authorize a redesign or implementation.
5. If investigation actually touches an OpenAPI contract or schema/migration, also load `api-contract-drift-guard` or `backend-data-migrations` respectively. Add other genuinely relevant skills discovered from the code, and explain their applicability.

Load required linked references for the aspects you use. Include `## Skills` in the saved plan: skills actually loaded, builder-role skills (including `test-driven-development`, and `mutation-testing-discipline` for guards), specialist applicability, and which skills contain the Mandatory Validation and Agent Defect Loop. Return `skills_loaded` and `defect_loop_skills`. Mentioning a skill without calling skill_view is not loading it. Child agents cannot spawn agents: required problem-finder/reviewer/verifier roles will be dispatched by the parent later, never by you.

## Context and baseline discovery

Follow `leorna` Step 1: shared memory index, current workflow, control-plane AGENTS.md, applicable notes (control-plane workflow; design/scope/auth/CI rules; ClickUp evidence). Paths are under `/Users/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`. For final delivery planning, consult `delivery/README.md`, stop-and-show-diff, review-prompt-for-agent, story-done-team-message and clickup-evidence notes. Respect the newest dated rule when old notes disagree.

Read the live card using the ClickUp connector; no ClickUp writes. The dispatcher re-read it and its prerequisite on 2026-10-22 around 13:31 EDT. Workspace `90141510532`, owner Justin Issa `240157212`, email `justin@leorna.com`. Story is to do/high, E11 Pack Builder, control-plane, size M.

Only incoming prerequisite: `86bcm901v` depends_on `86bcm9018` (Christian's Content library format + loader), **complete** on a live GET. Other returned dependency edges describe cards that wait on this browser, not blockers. Confirm the loader's actual merged implementation and interfaces on fresh remote main before designing; card completion is not proof the old local checkout has the code.

Use lightweight read-only git/gh discovery for actual branch/head/remote main, open PR ownership and changed paths. Before fetching, read repository instructions. A non-destructive fetch that updates only remote tracking refs is permitted; do not check out another branch or change the worktree/index. If SSH is locked, use the leorna skill's gh-authenticated HTTPS main-only fetch, never print credentials. The last observed local control-plane checkout was `main` at `0ad43a3`, with existing untracked `deploy/local/`. It may be stale. Leave deploy/local/ and all unrelated work untouched. Bind the plan to the actual inspected source revision; inspect fresh remote files using git show if the local worktree is old.

Another Leorna session selected `86bcm9016-prompt-kind` concurrently; its planner brief is `/Users/justin/.hermes/plans/leorna/briefs/86bcm9016-prompt-kind-planner.md`. Preserve that independent selection and all other-session Figma work. Both planners own separate plan artifacts only; read its brief/plan as needed and report shared source/test ownership before any later builders are scheduled. Do not modify its records, branch, brief or plan. Recheck the shared board read-only for current ownership. You own only your named plan artifact; do not modify shared board, handoff or notes, and return proposed record updates to the dispatcher.

Routing recovery — current authorization: Justin chose **Repair native Opus routing here, then retry planning**. Use only the current conversation's native delegate_task rail; independent Hermes CLI/desktop chats are forbidden. Earlier independent-CLI recovery instructions are historical and withdrawn. The parent owns provider/model verification using the live child registry and configured transport; do not identify the active model from the parent's chat label, config.model.default, inherited prose or your own self-description. If actual live request/provider evidence contradicts Opus, report that concrete evidence immediately, before research. Preserve the strict plan-only boundary and never start delegates or implementation. Reuse the prior read-only research from CLI session `20261022_133852_b88c20` if available through the local session store; do not resume or launch that independent session.

## Live story contract

### User Story
As an admin, I want to browse, search and filter the content library by kind, category and tool, so that I can find what my teams need quickly.

### Context
Today there is no catalog browser; packs are edited as raw items.

### Acceptance Criteria (test-backed)
1. Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text.
2. Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview.
3. Given 200+ items, then filtering stays responsive (<300 ms server time).

### Verify
UI integration test + manual demo.

### Definition of Done
Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (including gitleaks + golangci-lint), demoable in isolation, short module README note.

## Required plan artifact

Save to `/Users/justin/.hermes/plans/leorna/86bcm901v-library-catalog-browser.md`. Future build branch is exactly `feat/86bcm901v-library-catalog-browser`, created only AFTER go from updated main in its own safe workspace.

Write a finite plan a context-free Sol builder can implement without redesigning:

- Put open questions directly below the title. Only genuine unresolved product/architecture choices: 2–4 short lettered options, recommended marked ⭐, recommended path already designed. No questions needed merely to restate existing approval or model rules.
- Play back the scope, non-goals, existing architecture and source evidence. Keep the browser read-only unless the card itself requires otherwise; adjacent pack editing, prompt-kind work, upstream sync, curation and quality-gate stories are not this task.
- Identify actual data model, loader/catalog access, web routes/templates/styles, authorization and tenant context, render/transform interfaces and tests from source. Prefer existing stack and components. Define route/data/error shapes and filter/search semantics from evidence or explicit reversible assumptions. Do not invent a second catalog, API, dependency, schema or framework when the existing one suffices.
- Cover catalog filters/search, item detail/rendered preview, empty/error states and existing admin navigation; identify safe handling of untrusted preview content and preservation of access checks. Derive exact security/testing requirements using the loaded skills, not invented dispatcher gates.
- Map each of the three ACs to concrete tests, commands, expected outcomes and evidence; include the story's happy/failure cases. Preserve the exact 200+ items and <300 ms **server time** requirement rather than silently substituting browser-only timing or relaxing it. Define a reproducible, existing-runner measurement method and honest environment assumptions.
- Use vertical TDD microtasks with actual file/test paths, complete necessary interfaces/snippets, RED/GREEN commands and scoped commit boundaries per implementation-planning. Planning may inspect, but must not run the planned application tests. Clearly label unverified snippets/unknowns rather than claiming executed proof.
- Plan control-plane project gates: `make check` with verbose proof that actual Postgres tests run and `bash ./scripts/test-module-add.sh`; use the control-plane workflow note for exact environment. Do not change `.github/workflows/*` or relax checks.
- Evidence is a mandatory build task: one screenshot per visible AC, real gate logs, and a live/manual UI demo. Save to `/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/`. Use before/after screenshots for visible UI work, captured before the first source change and after completion. Define the AC-to-evidence map and the hand-over closing-comment draft. Missing live/manual proof must be labeled NOT VERIFIED with the reason, never a fabricated pass. No real server can be used unless it is Justin's and authorized; no touching Christian's or Yan's servers. Before anything leaves the Mac, inspect/redact screenshots and logs for server domains, URL bars, tenant IDs, tokens and emails. Upload/post only on Justin's later **post**, and never update card status/checkboxes.
- List risks, assumptions, source overlaps and release/permission holds. Include an honest scope estimate and implementation slices, using a tool-observed start; unknown overall completion gets a bounded 2–5 minute discovery forecast before refinement, not a guaranteed ETA.
- End the execution tasks with **Docs & records**, naming exact repository and external record files to update during BUILD/FINISH (not by you now): module README/tests documentation, `delivery/stories.json`, the plan's answers/state, shared `leorna-workflow.md`/index if changed, Leorna handoff and evidence draft. Include other repo-required records only if discovered, not a Figma build bump or invented CLAUDE.md task. Do not add old unrelated delivery debt to this story.
- Include the future pipeline: explicit go → Sol 6.1 xhigh builder → two separate fresh full reviewers in parallel (Opus 5.5 xhigh + Sol 6.1 xhigh) → Sol finisher after both reports → independent fresh Opus verifier where the Agent Defect Loop applies → verified hand-over. Ask Justin if a held Opus role hits its limit; no silent substitution. Leorna never auto-merges; push/PR only on separate request.
- If you discover unrelated issues, do not fix or include them in scope: list severity, exact evidence and proposed owner under Other things found and return `found_else`.

Validate the saved plan's structure and snippets without implementing or running application tests. Return a concise summary, exact plan path, questions/options/recommendations, real touched paths, overlaps, risks, loaded skills and defect-loop skills. Stop at plan ready, not build ready.
