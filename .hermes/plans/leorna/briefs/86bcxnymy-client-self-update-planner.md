# PLANNER brief: 86bcxnymy, Client self-update to the admin-approved version, with staged rollout

**Role:** PLANNER for Leorna story `86bcxnymy` (pipeline: **Full**). Write a plan Justin will approve. Don't build anything: no worktree, branch, code or commit.
**Model:** Fable 5.2, effort high.

## The ask (rewritten)

Build the client self-update feature across both repos (`~/Leorna/leorna-client` and `~/Leorna/leorna-control-plane`), based on ClickUp card `86bcxnymy`:

- **Control plane (source of truth):** a tenant admin pins an approved client version for the tenant, optionally to a percentage of clients or a group first (a staged rollout), and can roll back to an older approved version. The control plane tells each client which version it should run and gives it the release's SHA-256 checksum over TLS. The admin console shows how many clients run each version. Clients report update failures back.
- **Client:** asks its control plane which version to run, downloads that release's `leorna-client.exe` from the GitHub Release, checks it against the control plane's SHA-256, replaces itself and restarts. A checksum mismatch is refused (keep the current version, report the failure). If the new version fails to start, the client goes back to the previous version on the next launch.
- No code signing yet: the checksum is the integrity check. A later story (`86bcm9031`, Sign the engineer client) adds an Authenticode check to this same update step, so leave a clear seam for it.
- Dependency `86bcm9033` (Tagged release pipeline, both repos) is **complete**: releases publish `leorna-client.exe` plus SHA-256 checksums on `vX.Y.Z` (stable), `vX.Y.Z-rc.N` (beta pre-release) and a rolling edge pre-release. Read what it actually shipped (workflows, release asset names, checksum file format) before designing the download.

## The card, verbatim (Justin's words: he sent only "Client self-update to the admin-approved version, with staged rollout do this clickup story")

> **User Story**: As a customer admin, I want to choose which client version my engineers run and roll it out gradually, and as an engineer I want the client to update itself, so that nobody has to reinstall by hand.
>
> **Context**: The control plane is the source of truth: the admin pins an approved client version per tenant (optionally to a percentage or a group first). The client asks its control plane which version it should run, downloads that release's exe from the GitHub Release, verifies it against the SHA-256 checksum the control plane provides (served over TLS from the customer's own control plane), replaces itself and restarts. Built without code signing: the integrity check is the checksum for now; the client signing story later adds an Authenticode signature check to this same update step.
>
> **Acceptance Criteria (test-backed)**
> - Given the admin approves client vX.Y.Z for a group, then only clients in that group update, and the console shows how many clients run each version
> - Given a downloaded file whose checksum does not match, then the client refuses it, keeps the current version and reports the failure to the control plane
> - Given an update that fails to start, then the client returns to the previous version on the next launch
> - Given the admin rolls back to an older approved version, then clients move back to it
>
> **Verify**: On the dev environment with two Windows clients: staged rollout to one, tampered download refused, rollback to the previous version.
>
> **Definition of Done**: Standard: unit + integration tests (happy path + 1 failure), OpenAPI contract updated, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
>
> **Dependencies**: Tagged release pipeline (both repos) `86bcm9033` (complete). **Repo**: both. **Size**: L.

## How to work

1. Load skills in this order and say so in your first steps: `leorna` (follow it in the PLANNER role, including its Step 1 context load; the Claude Code memory folder on this Linux desktop is under `~/.claude/projects/`; find the Leorna one that holds `leorna-workflow.md`), then `engineering-best-practices`, then `implementation-planning`. Add the specialists the work needs and name them in the plan's `## Skills` section: at least `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `authorized-write-safety` (the client replaces its own executable). Mark which of them end with "Mandatory Validation and Agent Defect Loop" (`grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`). A skill's "spawn a subagent" steps are run by the main session, not you.
2. **Base:** fetch GitHub `main` for both repos over HTTPS through gh (the `leorna` skill's step 7.1 command) and record each SHA as the plan's base. Don't fast-forward the main checkouts (local client `main` is 8 behind; the builder's worktree handles that). Search with `git grep` in the main checkout, never a recursive `grep -r .` (it reads sibling worktrees under `.claude/worktrees/`).
3. Research: how the client talks to the control plane today (auth, device/client identity, any existing version reporting or heartbeat), how groups are modelled in the control plane (is there a client/engineer group concept to target, or must it be added?), the OpenAPI spec and generated code, migrations, the admin console, the Wails app's startup path (where a "previous version" fallback can run before the UI), and the release assets from `86bcm9033`.
4. The card's ACs are given, so use them, numbered AC1–AC4 in card order, each with one named test whole on one line. You may split one card AC into sub-ACs (AC1a, AC1b) if a test needs it, and you may add clearly marked **proposed** ACs for things the DoD needs (OpenAPI contract, README note) or that the card implies (percentage rollout). Tag `(live)` right after the id only for a check that truly needs Justin's two real Windows clients or his real server. Prefer agent-run checks: the `leorna` skill explains the client's sign-in and Sync run without the window against a dev server in a scratch HOME; the self-replace and roll-back-on-failed-start on Windows can likely be proven with a cross-built exe and tests on fakes. Say for each AC how it is proven without Windows, and keep the card's "Verify" (two real Windows clients on the dev environment) as a `(live)` AC owed to Justin.
5. **Size:** this is a size L story over both repos. If it is too big for one build, say so in `summary` and propose a split (separate builds per repo in one story, or a follow-up card), with your recommendation as a lettered question.
6. Name the open sibling work that might overlap (open feature branches/worktrees in both repos, open PRs: `gh pr list -R LeornaAI/<repo>`), especially anything touching the OpenAPI spec, migrations numbering, `delivery/stories.json` or the client's startup path.

## The plan

Save it to `~/.hermes/plans/leorna/86bcxnymy-client-self-update.md`. Self-contained, so a builder with no context can build it without redesigning:
- **Open questions at the top**, right after the title, each with options A, B, C… (each under ~60 characters), the recommended one marked. Write the plan as if the recommended options were chosen, so "go" needs no re-plan. Likely questions: group vs percentage targeting model, how a client is counted (last-seen window), where the client gets the download URL (control plane hands it, or the client builds it from the version), what "fails to start" means and how the client detects it, the split question above.
- Playback, approach, base SHAs, numbered ACs with one named test each, tasks per repo (test-first), the files and areas touched, the OpenAPI change, migrations, security notes (TLS, checksum source, path handling on the exe swap, tenant isolation of version pins and counts), risks, choices.
- End with a **Docs & records** task naming every file the build and finish will update (module README notes, `delivery/stories.json`, the shared Leorna notes, plan copy, evidence folder `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/`).
- An "Other things found" section for anything else you notice: don't fix or fold it in.

## Rules

- You can't ask Justin anything: questions go in `questions`.
- Never send or write a server domain, URL or tenant ID anywhere outside the local notes. Never print tokens.
- If you find another bug or problem, list it in `found_else` (one line each, with evidence and severity) and in "Other things found".
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Answer in plain words.

## Return

`{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`, plus `verdict` (`plan-ready` or `blocked`) and `ac_status` (the list of ACs with `accepted: not_run`). End your report with `MAIN SESSION: check and save these skill_lessons now.`
