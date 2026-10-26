# FIXER (round 1) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FIXER** (Opus 5.5, xhigh). Act on review 1's findings test-first, commit, and stop at `ready-for-review` (a second fresh reviewer reviews your corrected head next). This is **not** the hand-over.

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (local only, upstream unset on purpose).
- **Reviewed head:** `1571fcdff758567f6bc00305e7838e3bd9e6b884`. **Base:** `6e74ced843642439d1dac9f25673440fb0f285f5`.
- **Approved plan (read-only, never edit):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (all ⭐ answers Q1A–Q8A approved by Justin).
- **ACs:** AC1 filter by kind, category, tag and supported tool + text search; AC2 item page with description, example, version, supported tools and a rendered preview; AC3 filtering <300 ms server time with 200+ items. Tests: `TestLibraryAC1FilterAndSearchWithPostgres`, `TestLibraryAC2ItemDetailWithPostgres`, `TestLibraryAC3FilteringUnder300msWithPostgres` in `internal/web/` (exact commands in the plan).

## Review 1 result (fresh Opus reviewer, on 1571fcd)

Verdict **clean**: no P0–P2, AC1–AC3 accepted, all gates exit 0. Four **P3** findings, written out here from its report. Its receipts are in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/review-r1/` (e.g. `mutations-r1-1571fcd.txt`).

- **F1 · P3 · Docs overstate what goldmark's safe mode removes.** `internal/library/preview.go:26-27` (comment) and `internal/web/README.md:157` say goldmark "empties … `data:` link and image URLs". goldmark v1.7.17 `IsDangerousURL` (`renderer/html/html.go:946-958`) keeps `data:image/png|gif|jpeg|webp|svg+xml` URLs. Evidence: `RenderMarkdown("![x](data:image/svg+xml;base64,PHN2Zz48L3N2Zz4=)")` → `<p><img src="data:image/svg+xml;base64,PHN2Zz48L3N2Zz4=" alt="x"></p>`. Not exploitable today (nonce-only CSP `default-src 'none'` blocks image loads; SVG in `<img>` runs no script; browsers block top-level `data:` navigation). Reviewer's suggested fix: reword both places to "`data:` URLs other than png/gif/jpeg/webp/svg images are emptied"; optionally pin the current behaviour with a test.
- **F2 · P3 · No test pins search-text trimming.** `internal/web/library.go:41` `strings.TrimSpace(query.Get("q"))`. Mutation RM3 (use raw `q`) survived: `go test -v -count=1 -run ^TestLibrary ./internal/web/` still exited 0. Scenario: an admin typing `review ` (trailing space) finds nothing. Suggested fix: add an AC1 case such as `?q=+POSTMORTEM+` → `incident-postmortem`.
- **F3 · P3 · Aligned Markdown tables lose alignment under the admin CSP.** `internal/library/preview.go:32` with `internal/web/admin_ui.go:38-39`. goldmark's table extension writes `style="text-align:…"` inline attributes; `adminCSP` allows only nonce'd styles, so alignment is silently dropped and the browser logs CSP violations. Evidence: `| a | b |\n|:--|--:|\n| 1 | 2 |` → `<th style="text-align:left">a</th> … <td style="text-align:right">2</td>`. No shipped item uses aligned tables. Suggested fix: configure the table extension to render alignment as a class/attribute instead of an inline style if goldmark offers that option, or record it as a known limit.
- **F4 · P3 (nit) · A 400 page clears what the admin entered.** `internal/web/library.go:114-120`: on error `libraryFilter` returns `library.Filter{}`, so every select resets and the search box empties. The dashboards keep input on a 400 (`internal/web/costs.go:66-71`, `invalidCostFilter` sets `page.From, page.To` from the query). Suggested fix: re-fill the search box (escaped) and any valid select values on the 400 page.

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (FINISHER role, fix pass only; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `receiving-code-review`: verify each finding yourself before acting; fix the valid ones; push back with evidence on any that is wrong.
4. `test-driven-development`: a failing test before each behaviour change (F2, F4, and F3 if you change behaviour).
5. `mutation-testing-discipline`: confirm RM3 (raw `q`) is now killed, and that your new tests can fail.
6. `security-best-practices` (F1, F3) and `git-commit-rules`.
7. `systematic-debugging` if a test fails unexpectedly.

## Boundaries

- **Stay inside the approved plan's design.** These are small corrections. If a fix would change the approved design, add scope, or need Justin's decision, don't do it: decline it with the reason and evidence, and say what decision it needs.
- Commits `fix(86bcm901v): …` or `docs(86bcm901v): …`, plain `git commit -m` (identity from git config; check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`). No author overrides, no AI attribution or Co-Authored-By lines, never commit `CLAUDE.md`.
- **Leave the worktree committed and clean** (`git status --porcelain` empty, nothing untracked); keep scratch outside it.
- **Your test DB:** `leorna_86bcm901v_v3_fix1_test` (ends in `_test`; create, drop at the end). Never use another agent's or story's DB.
- **Your receipts** go in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/fix-r1/`. Don't modify other files in the evidence folder.
- No push, PR, merge, ClickUp writes, server/cloud actions, or `.github/` edits. Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches or DBs.

## Before you stop

1. Re-run the three AC tests alone with the plan's commands on your new head (logs `ac<n>-<sha7>.log` with `HEAD=` and `EXIT=` lines in `fix-r1/`).
2. Re-run the gates on the new head with CI's tool versions bound by absolute path (golangci-lint and govulncheck, per the `leorna` skill): `make check` with Postgres, a separate verbose `go test -v` run, `bash ./scripts/test-module-add.sh`, `make contracts-check`. Logs `gates-<sha7>.txt` etc. with real exit codes; read each before citing it.
3. If a fix visibly changes a page an AC screenshot shows, retake that screenshot the same way the builder did (dev-mode binary on 127.0.0.1, headless Chrome, throwaway DB; see `EVIDENCE.md`), save it in `fix-r1/` and check it visually (no host, URL bar, tenant ID, token or email). Otherwise say it is unchanged.

## Found something else?

Any other bug or problem: list it in `found_else` (one line each, with evidence and severity); don't fix it.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: ready-for-review|stopped, prev_head, head_sha, commits[], findings[{id, decision: fixed|declined, what_changed, test, evidence}], mutations[], ac_status[{ac, test, result, log, screenshot}], gates[{name, exit_code, log}], diff_stat_since_prev, found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
