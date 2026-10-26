# REVIEWER 1 brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh, separate **full code REVIEWER** (Opus 5.5, xhigh). You have never seen this code or its build. **Report only: change no source, commit nothing, apply no fix.**

## What to review

- **Repo:** `~/Leorna/leorna-control-plane`, branch `feat/86bcm901v-catalog-browser-v3`.
- **Candidate head:** `1571fcdff758567f6bc00305e7838e3bd9e6b884`. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5` (origin/main when built). Review the whole diff `6e74ced..1571fcd` (14 files, 3 commits).
- **Work in your own detached copy**, never in the builder's worktree (which must stay clean for later checks): `git -C ~/Leorna/leorna-control-plane worktree add --detach <your scratchpad>/review-r1 1571fcd`, and remove it with `git worktree remove --force` when done.
- **Your own test DB:** `leorna_86bcm901v_v3_review1_test` in the `leorna-test-pg` container (name ends in `_test`; create it, drop it at the end). Never use another agent's or story's DB.
- **Your receipts** (logs, screenshots, notes) go only in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/review-r1/`. Don't modify anything else in the evidence folder.

## What it should do (the approved contract)

- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (read-only; all ⭐ answers Q1A–Q8A approved by Justin, see its last section).
- **ClickUp card 86bcm901v "Library catalog browser"**, ACs:
  - **AC1:** Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text.
  - **AC2:** Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview.
  - **AC3:** Given 200+ items, then filtering stays responsive (<300 ms server time).
  - **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- Builder evidence is in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/` (`EVIDENCE.md`, logs, screenshots). Treat it as claims to check, not as proof.

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (rules and the control-plane gates in Doing a story → step 4; you may skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `requesting-code-review` (security scan and quality gates) and `code-review-practice`. **Skip their "dispatch an independent reviewer subagent" and auto-fix steps:** you *are* the fresh reviewer, and you can't spawn agents.
4. `mutation-testing-discipline` for its checks on the guards (admin-only routes, tenant fail-closed store reads, HTML safety of the preview, the 300 ms bound).
5. Specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` (this story claims no API/OpenAPI change: confirm no contract drift).

## What to do

1. A full review of correctness, security (XSS through rendered library content, CSP, authz, tenant isolation, error leakage), multi-tenant behaviour, performance claims, test quality (do the AC tests really test their AC, would they catch a regression), consistency with repo patterns, README note, and whether the build matches the approved plan.
2. Re-run the project gates on the candidate in your copy, binding CI's tool versions by absolute path as the `leorna` skill says (golangci-lint and govulncheck): `make check` with Postgres, a separate verbose `go test -v` run, `bash ./scripts/test-module-add.sh`, the contracts check. Save logs with real exit codes in your folder.
3. **AC status:** for each AC, run its test alone with the plan's exact command on the candidate and look at the builder's screenshot for it. Say whether it is accepted, with the evidence.
4. Rank findings P0 (blocks, wrong/unsafe) to P3 (nit). Every finding needs file:line, a concrete failure scenario, and evidence (a command and its output, a failing input). Don't report style preferences as defects.

## Rules

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3` or the older 901v attempts, or any peer session's worktrees, branches or DBs.
- Never write a server domain, URL, tenant ID or token into your report.

## Found something else?

Any other bug or problem outside this story's diff: list it in `found_else` (one line each, with evidence and severity), don't fold it into findings.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{verdict: clean|findings, reviewed_head, findings[{id, severity, file_line, claim, failure_scenario, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit_code, log}], skills_loaded[], found_else[], skill_lessons[]}`

`clean` means no P0–P2 finding and every AC accepted. End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
