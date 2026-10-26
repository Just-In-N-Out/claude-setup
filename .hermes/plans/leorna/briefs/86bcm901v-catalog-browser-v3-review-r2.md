# REVIEWER 2 brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh, separate **full code REVIEWER** (Opus 5.5, xhigh), the second review in the Full pipeline. You have never seen this code or its build. **Report only: change no source, commit nothing, apply no fix.**

## What to review

- **Repo:** `~/Leorna/leorna-control-plane`, branch `feat/86bcm901v-catalog-browser-v3`.
- **Candidate head (corrected):** `266603e42a98509dd5d29a78171b03a74d277aae`. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5` (origin/main when built).
- Review the **whole story diff `6e74ced..266603e`** (7 commits) as a full review, not only the last fixes. Also check that the four review-1 findings below are really closed and that the fixes didn't break anything (commits `1571fcd..266603e`).
- **Work in your own detached copy**, never in the builder's worktree (it must stay clean for later checks): `git -C ~/Leorna/leorna-control-plane worktree add --detach <your scratchpad>/review-r2 266603e`, and remove it with `git worktree remove --force` when done.
- **Your own test DB:** `leorna_86bcm901v_v3_review2_test` in the `leorna-test-pg` container (ends in `_test`; create, drop at the end). Never use another agent's or story's DB.
- **Your receipts** go only in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/review-r2/`. Don't modify anything else in the evidence folder.

## What it should do (the approved contract)

- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (read-only; all ⭐ answers Q1A–Q8A approved by Justin). Known: its "Current context" bullet wrongly says goldmark empties every `data:` URL; the code docs were corrected in 266603e.
- **ClickUp card 86bcm901v "Library catalog browser"**, ACs:
  - **AC1:** Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text.
  - **AC2:** Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview.
  - **AC3:** Given 200+ items, then filtering stays responsive (<300 ms server time).
  - **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- Builder and fixer evidence: `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/` (root = builder on 1571fcd, `fix-r1/` = fixer on 266603e). Treat it as claims to check, not proof.

## Review 1's findings (on 1571fcd; all P3) — confirm each is closed

- **F1** docs (`internal/library/preview.go` comment, `internal/web/README.md`) claimed goldmark empties all `data:` URLs; goldmark v1.7.17 keeps `data:image/png|gif|jpeg|webp|svg+xml` in links and images.
- **F2** no test pinned trimming of the search text (`internal/web/library.go`, `strings.TrimSpace(query.Get("q"))`); mutating it to raw `q` survived.
- **F3** goldmark's table alignment used inline `style=` attributes, which the nonce-only admin CSP blocks, so alignment was silently lost.
- **F4** a 400 (bad filter) page cleared everything the admin entered, unlike the dashboards (`internal/web/costs.go` keeps input).

The fixer says it fixed all four in `8886bfc`, `3411814`, `9787a33`, `266603e`. Judge that yourself from the code and tests.

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (rules and the control-plane gates in Doing a story → step 4; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip their "dispatch an independent reviewer subagent" and auto-fix steps:** you *are* the fresh reviewer, and you can't spawn agents.
4. `mutation-testing-discipline` for the guards (admin-only routes, tenant fail-closed store reads, HTML safety of the preview, the 300 ms bound, the new 400-page refill and table alignment).
5. Specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` (no API/OpenAPI change is claimed: confirm no drift).

## What to do

1. A full review: correctness, security (XSS through rendered library content and through the refilled 400 form, CSP, authz, tenant isolation, error leakage), performance claims, test quality (do the AC tests really test their AC; would they catch a regression), repo-pattern consistency, README note, plan compliance.
2. Re-run the gates on the candidate in your copy with CI's tool versions bound by absolute path (golangci-lint and govulncheck, per the `leorna` skill): `make check` with Postgres, a separate verbose `go test -v` run, `bash ./scripts/test-module-add.sh`, `make contracts-check`. Logs with real exit codes in your folder.
3. **AC status:** run each AC test alone with the plan's exact command on the candidate, and look at the AC screenshots (`ac1-library-filtered.png`, `ac2-item-detail.png`, `ac3-timing-terminal.png` in the evidence root; the fixer says the fixes changed nothing they show). Say whether each AC is accepted, with evidence.
4. Rank findings P0 (blocks) to P3 (nit). Every finding needs file:line, a concrete failure scenario and evidence (command + output, failing input). Not style preferences.

## Rules

- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches or DBs.
- Never write a server domain, URL, tenant ID or token into your report.
- If you need a decision that isn't yours, put it in `questions` with lettered options and a recommended one (Justin is away; the orchestrator applies recommendations).

## Found something else?

Any bug or problem outside this story's diff: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{verdict: clean|findings, reviewed_head, review1_findings_closed[{id, closed, evidence}], findings[{id, severity, file_line, claim, failure_scenario, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{name, exit_code, log}], questions[], skills_loaded[], found_else[], skill_lessons[]}`

`clean` means no P0–P2 finding, every review-1 finding closed, and every AC accepted. End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
