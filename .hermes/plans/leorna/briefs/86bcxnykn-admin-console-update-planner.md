# PLANNER brief: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: PLANNER (a fresh general-purpose agent on Fable 5.2, high effort). Pipeline: **Full** (Justin picked it on 2026-11-10; size L, with admin-only permissions, self-redeploy, migrations, rollback, audit and an OpenAPI change).
Your job is to write the plan and nothing else. Don't create a worktree, branch, code or commit, and don't start other agents: the main session runs every role.

- Plan destination: `/home/justin/.hermes/plans/leorna/86bcxnykn-admin-console-update.md`
- Repo: `/home/justin/Leorna/leorna-control-plane`. Sibling sessions share the main checkout, so don't move its `main` and don't touch `.claude/worktrees/*` or any sibling worktree or branch.
- Evidence root (used by later roles): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`
- Read the card with the ClickUp MCP tools (`mcp__clickup__clickup_get_task`, task `86bcxnykn`, include description and dependencies). Read only: never write to ClickUp.

## The request
Plan ClickUp story 86bcxnykn, "Update the control plane in place from the admin console (with rollback)", in leorna-control-plane. The admin console should show when a newer stable Leorna release exists and let an admin update with one click. The control plane then redeploys itself to that release's image digest and runs its forward-only migrations. If the new version fails its health check, it rolls back to the previous digest automatically. Every update and rollback is audited.

Justin's words (verbatim):
> Update the control plane in place from the admin console (with rollback) do this clickup story

## Card ACs (verbatim; these are the ACs, so don't rewrite their meaning)
1. Given a newer stable release, then the admin console shows the version and its release notes, and only admins see the update action
2. Given the admin approves, then the control plane redeploys itself to that release's image digest, runs its forward-only migrations, and the console shows the new version when it is back
3. Given the new version fails its health check, then the previous digest is redeployed automatically and the admin sees why
4. Given every update or rollback, then an audit event records who, from which version, to which version, and the result

Card context: the control plane runs in the customer's own Scaleway account, so delivery is a pull the admin approves; Leorna never pushes it. The tagged release pipeline publishes versioned images and release notes. The installer can already redeploy an existing container to a new image (`redeployExisting`). The console checks the stable channel's GitHub Releases, or a small release manifest published with each release. Updates go to the image digest, never `latest`. There is no code signing; integrity comes from the registry digest (plus cosign later, from the SBOM/provenance story).
Verify (card): on the dev environment, update from vX to vX+1 from the console, then simulate a failing release and check the automatic rollback and the audit events.
DoD (card): unit and integration tests (happy path plus one failure), OpenAPI contract updated, lint/format/CI green (including gitleaks and golangci-lint), demoable in isolation, a short module README note.
Dependency: 86bcm9033 "Tagged release pipeline (both repos)" is **complete** (Yan's card). Find what it actually shipped on main: the release workflow, release-notes format, image tags, whether the notes name the digest, the stable/beta/edge channels, and any manifest. Plan on what exists. If something the story needs isn't published (for example a machine-readable manifest with the digest), either plan it inside this story, if that is small and doesn't touch `.github/workflows/*`, or raise it as a question.

## Facts the orchestrator already checked (2026-11-10)
- GitHub `main` = `4ef14efb46da789aec30fad1e5a988d8770140e2` (2026-11-10T07:54:26Z). Check it again yourself (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`, or the HTTPS fetch recipe in the `leorna` skill) and record the SHA you plan on as the plan's base. The local main checkout may be behind, so do your research at that SHA with `git show`/`git grep <sha>`, not in the working tree. Search with `git grep`, never `grep -r .` (that reads sibling worktrees).
- Open PR: #113 `feat/86bcx2a33-github-mcp-current` (GitHub MCP library item). Recent local branches include `feat/86bcm9284-*`, `feat/86bccndx6-custom-company-domain`, `feat/86bcm928t-integration-governance-usage`. Say whether this story touches the same files as any unmerged live sibling, especially migrations (next migration number), `delivery/stories.json`, the OpenAPI spec and the audit code.
- No existing plan, brief, evidence or branch for 86bcxnykn.
- earlyoom: no kills in the last 30 minutes. This machine is the Windows desktop (WSL); follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command that dies with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result.

## Skills: load each one with the Skill tool in this order, and say so in one line
1. `leorna`: follow the PLANNER role and its Step 1 context load. That covers the shared memory `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/` (MEMORY.md, leorna-workflow.md, leorna-control-plane-workflow.md, live-server-testing.md, own-control-plane-install.md, the design-call notes, no-ci-changes.md, no-auth-bypass-from-chat-guidance.md, clickup-evidence.md), plus the repo's AGENTS.md and `delivery/README.md`.
2. `engineering-best-practices`
3. `implementation-planning`
4. Control-plane specialists: `security-best-practices`, `multi-tenant-auth-management` (admin-only action), `api-contract-drift-guard` (OpenAPI change), `backend-data-migrations` (forward-only migrations during an update, plus any new table for update state or audit). Add `incident-rollback-runbook` or `release-readiness-cutover` if they help the rollback design, and `authorized-write-safety` for the code that calls the Scaleway API.
If you find a bug that needs diagnosis, load `systematic-debugging` before planning its fix, and keep unrelated findings out of this story.
Also read the "Phase 1" section of `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` and the references `ac-verification.md` and `review-loop.md`, so the plan matches how the ACs will be checked. Skip the board, WhatsApp and status parts.

## Design questions the plan must answer (with evidence from the code)
- **Who performs the redeploy.** A running container redeploying itself is the hard part: the old process may die mid-update. Find how the installer's `redeployExisting` works (Scaleway Serverless Containers API? which credentials?) and whether the running control plane has, or should get, credentials that can update its own container. Recommend the safest design, for example a deploy request recorded in Postgres and carried out through the Scaleway API with the digest pinned, with health watched by whatever survives the restart. Say where the "previous digest" and the update state are stored so a rollback still works after the old process is gone. Spell out the security boundary: the scope of the credential, that it's never logged, and that only admins can trigger an update.
- **Release discovery.** GitHub Releases API for the stable channel, or a manifest asset. Cover how the digest is obtained and checked (never `latest`), how pre-releases are excluded, offline or rate-limit behaviour, and caching. Tests use a fake HTTP server, never real GitHub.
- **Health check and rollback trigger.** What "fails its health check" means (an existing `/healthz`/`/readyz`? a version check?), the timeout, who notices, and how "the admin sees why" reaches the console.
- **Forward-only migrations.** How the new version already runs migrations on startup, and what a rollback does when the new version has already migrated (the old image must start on a newer schema, or the rollback has to say why it can't). Treat this as a real risk.
- **Audit.** Reuse the existing change-audit path. Find the current audit records and actions; don't add a second audit path. Record who, from-version, to-version and result for both update and rollback.
- **Admin console UI.** Where the version banner, release notes and update button go; how non-admins are kept from the action on the server side (not only hidden in the UI); and how release-notes markdown is rendered safely (XSS).
- **"Demoable in isolation" and the card's Verify.** A real Scaleway update needs Justin's live server. Prefer agent-run checks: a fake Scaleway API plus a fake release feed plus a local server driven through headless Chrome counts as agent-run. Tag `(live)` only the parts that truly need his real server (the card's Verify on the dev environment is probably one AC or one clause). Remember the rule: never put server domains, URLs or tenant IDs in plans that leave the machine.

## What the plan must contain
It must be self-contained, so a fresh builder with no context can build from it without redesigning:
- The title, then **Questions** (lettered options, the recommended one marked ⭐), then the playback, base SHA, approach, tasks, tests, choices, assumptions, risks, files and areas touched, and overlap with siblings.
- **Numbered ACs near the top, AC1 to AC4** (one per card AC; add more only if the card truly needs them, ids `AC5`… never `AC2a`). Each AC names its test by exact Go test name, or by an exact browser test name for UI ACs, and **each AC is on a single line** (`ac-check.sh` matches names line by line, so a wrapped name rejects that AC). Put `(live)` right after the id only for a check that only Justin can do (`- AC5 (live): …`). If you add an AC beyond the card's four, mark it **proposed**.
- One test per AC (happy path plus at least one failure each, per the DoD). Include Postgres-backed tests where they apply (`LEORNA_TEST_DATABASE_URL`, `leorna-test-pg`). Each test must fail on the base commit.
- **Evidence task:** one screenshot per AC in the evidence root (`ac<n>-<what>.png`). Use real console captures for AC1 to AC3 (the version and notes, the non-admin view, the rollback reason) and the audit view for AC4 if one is visible; otherwise use a real terminal capture of the test run rendered in headless Chrome on WSL, labelled as a terminal capture. Gate logs per head: `gates-<sha7>.txt`.
- DoD items: OpenAPI contract updated and regenerated (`api-contract-drift-guard`); migrations if any (`backend-data-migrations`; check the next migration number against main and the live sibling branches); a short module README note; a `delivery/stories.json` entry.
- Gates: `make check` with the CI-pinned golangci-lint and govulncheck bound by absolute path, `bash ./scripts/test-module-add.sh` (serially), `python3 -m unittest scripts/test_release.py`, and the Postgres no-skip check from the `leorna` skill. Check the host prerequisites now (`command -v go make gcc golangci-lint govulncheck`, `go env CGO_ENABLED`, `docker ps`, the `leorna-test-pg` container) and turn anything missing into a question rather than a surprise for the builder. Don't install or change anything.
- The future branch `feat/86bcxnykn-admin-console-update`, in a dedicated worktree at `/home/justin/Leorna/86bcxnykn-admin-console-update`, which the builder creates from fresh main.
- No CI changes (`.github/workflows/*`), no auth bypass, no repo-wide pattern changes (list those as follow-ups). If the story truly needs a workflow change (for example publishing a manifest), that's a question for Justin with a recommended non-CI alternative.
- Finish with a **Docs & records** task that names every file the build and finish update: the plan copy, story state in `leorna-workflow.md`, `delivery/stories.json`, and the module README.

## Rules for your report
- Write in plain words. You can't ask Justin anything, so put questions in `questions`, with 2–4 short options each (under about 60 characters) and the recommended one marked. Write the plan as if the recommended options were chosen, so "go" needs no re-plan.
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (its kind: Claude Code hook, git hook, test, lint or script; what it checks; where it runs). An empty list is the normal answer.
- Keep all scratch in your own `~/.cache/86bcxnykn-planner/` folder, created fresh with `mkdir` (no `-p`). The session scratchpad on `/tmp` is a small RAM tmpfs shared by every agent.
- Don't end your turn to wait for a background command: the lessons gate treats that as finishing. Wait in the foreground with bounded polls of under 3 minutes each.
- Return `{name, plan_path, base_sha, playback, summary, ac_list[], live_acs[], questions[{q, options[], recommended}], choices[], risks[], touches[], overlaps, found_else[], skill_lessons[]}`, then end the report with the line `MAIN SESSION: check and save these skill_lessons now.`
