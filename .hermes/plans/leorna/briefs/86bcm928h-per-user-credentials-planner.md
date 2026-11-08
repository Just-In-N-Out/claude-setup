# PLANNER brief — Leorna story 86bcm928h-per-user-credentials

**Role:** PLANNER for Leorna (`leorna-client`) story "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h). Write a plan Justin will approve; **don't build anything**. Make no worktree, branch, code or commit.

**Pipeline:** Full (size L, security-sensitive). Every role is Opus 5.5 at effort **high** (Justin, 2026-11-07).

## The ask (rewritten)

Engineers connect integrations (the tiles from the integration tile model) on their own laptop with **their own** credentials. Credentials are stored only in the OS credential store (Windows Credential Manager / DPAPI), never in the synced config, logs or the control plane. The MCP config the client writes refers to the credential (via env or a credential helper) and never embeds the secret. Support OAuth sign-in and a personal-token path, plus a reconnect action for an expired or revoked credential.

- Read card **86bcm928h** from ClickUp (`mcp__clickup__clickup_get_task`, read-only) for its ACs, Verify, DoD and notes. Use the card's ACs; if it has none, propose your own and mark them **proposed**.
- Dependency **86bcm927v** (integration tile model) is complete: read it, find what it merged in `leorna-client`, and build on its **parameterised MCP template format**. (A related local plan exists: `~/.hermes/plans/leorna/86bcm927y-integrations-catalog-tiles.md`; check whether it is relevant, don't assume.)

### Justin's planner notes (verbatim intent, to be honoured)
- Load `security-best-practices`.
- Credentials live only in the OS credential store (Windows Credential Manager / DPAPI), never in the synced config, logs or the control plane.
- The written MCP config refers to the credential (env or credential helper) and never embeds it.
- Add tests that grep the written files and requests for the secret.
- Cover OAuth sign-in and the personal-token path, plus the reconnect action for an expired or revoked credential.
- Windows credential-store tests run on Windows CI.
- Tag the clean Windows VM test with the first predefined tile as `(live)`.
- Never add an auth bypass or stub in product code; use test fakes.
- Hand-over only: no push, PR or ClickUp post until Justin says.

### Justin's words
> Leorna story, ClickUp card 86bcm928h: "Per-user credentials for integrations on the engineer's laptop". Repo: leorna-client. Pipeline: Full (size L, security-sensitive).
> Read the card for the ACs. Its dependency 86bcm927v (integration tile model) is complete; build on its parameterised MCP template format.
> Planner notes: load security-best-practices. Credentials live only in the OS credential store (Windows Credential Manager / DPAPI), never in the synced config, logs or the control plane. The written MCP config refers to the credential (env or credential helper) and never embeds it. Add tests that grep the written files and requests for the secret. Cover OAuth sign-in and the personal-token path, plus the reconnect action for an expired or revoked credential. Windows credential-store tests run on Windows CI. Tag the clean Windows VM test with the first predefined tile (live). Never add an auth bypass or stub in product code; use test fakes.
> Hand-over only: no push, PR or ClickUp post until I say.

## Skills to load (say so in your first steps)
1. `leorna`, in the PLANNER role: do its Step 1 context load (MEM index, `leorna-workflow.md`, `~/Leorna/leorna-client/AGENTS.md`, topic notes incl. `no-auth-bypass-from-chat-guidance.md`, `no-ci-changes.md`, `prefer-small-verified-scope.md`). Step 1.5: fetch GitHub `main` over HTTPS through gh and **record the SHA as the plan's base; do not fast-forward the main checkout** (it is currently 11 behind; the builder's worktree does that).
2. `engineering-best-practices`.
3. `implementation-planning`.
4. `security-best-practices` (and any other specialist you find the build needs; name them in the plan's `## Skills` section and mark the ones with a "Mandatory Validation and Agent Defect Loop").

Search the main checkout with `git grep`, not recursive grep (sibling worktrees live under `.claude/worktrees/`).

## What the plan must contain
Save to `~/.hermes/plans/leorna/86bcm928h-per-user-credentials.md`. Self-contained, so a fresh builder can build it without redesigning:
- **Questions at the top**, right after the title: each with 2–4 lettered options (each under ~60 chars), recommended one marked ⭐. Write the plan as if the ⭐ options were chosen.
- Playback, approach, base SHA, files/areas touched, interfaces and data shapes (credential reference format in the MCP template, credential-store abstraction with an OS implementation and a test fake), decisions, risks.
- **Numbered ACs `AC1, AC2…`**, each whole on one line with its test by name (`ac-check.sh` matches names line by line). Card ACs as written; any you add marked **proposed**. Tag `(live)` right after the id for an AC only Justin can check, e.g. `- AC5 (live): …` — Justin asked that the clean Windows VM test with the first predefined tile be `(live)`. Prefer agent-run checks for anything an agent can do itself.
- Secret-leak tests: grep the written MCP config files, synced config, logs and outbound requests (control plane) for the secret.
- OAuth sign-in, personal token, and reconnect for expired/revoked credentials, each covered.
- Windows credential-store tests that run on Windows CI. If that needs a CI workflow change, it's a **question** for Justin (the `no-ci-changes` default applies; don't plan a `.github/workflows` change without a question). Check what Windows CI already runs.
- Host prerequisites for this desktop (WSL): check `command -v go make gcc golangci-lint govulncheck node` and `docker ps`; anything missing becomes a plan question.
- Evidence task: per AC, the state to show, capture point and artifact path under `~/.hermes/plans/leorna/evidence/86bcm928h/` (`ac<n>-<what>.png`; a terminal capture for non-visual ACs).
- **Docs & records** task at the end naming every file the build and finish update.
- Say whether this touches the same files as any open sibling story (check `git worktree list` in `~/Leorna/leorna-client` and open PRs read-only), so builds can run in parallel or in order.

## Boundaries
- Never write to ClickUp. Never push. Read-only on GitHub.
- No auth bypass, dev-login stub or relaxed check in product code; test fakes only.
- Don't change `toolconnector.Connector` or repo-wide patterns inside the story; list them as follow-ups.
- Never print tokens or server domains/URLs/tenant IDs.
- WSL memory: a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); check before reading it as pass/fail.

## found_else and skill_lessons
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity) and an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Return
`{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` — plain words. End the report with `MAIN SESSION: check and save these skill_lessons now.`
