# FIXER (docs wording after the merge verifier) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FIXER** (Opus 5.5, xhigh). One docs-only correction, then stop at `ready-for-verify`. **No push, no PR edit, no ClickUp.**

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (PR #88 on GitHub is still at the old head `2c43b39`; the merge commits are local only).
- **Current head:** `86c16b86381e72409d393069c1b5a1726599020d`. **Base:** `6275a4e6ae4700ebd23d494bbe0990d22b879760` (= merge-base with `origin/main`). Clean worktree.
- **Approved plan (read-only):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. Justin's decisions: the working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`, section "Merge with main after PR #88 opened" (preview cost stays a follow-up; **fix the wording so it's true**; no guard code).
- **ACs (unchanged):** AC1–AC3, tests `TestLibraryAC1FilterAndSearchWithPostgres`, `TestLibraryAC2ItemDetailWithPostgres`, `TestLibraryAC3FilteringUnder300msWithPostgres` in `internal/web/` (exact commands in the plan).

## The finding (fresh verifier on 86c16b8, verdict clean, P3 V1)

The README Limits line in `internal/web/README.md` (about line 180) says content reaches `library_items` only through `EnsureLibrary` and "no API, tenant or runtime path writes the table". The first half is true; the second half overstates: the setup wizard also runs `EnsureLibrary` at runtime (`POST /admin/setup/pack` → `runPackLoad` → `EnsureLibrary`, `internal/web/setup.go:330`, route `handler.go:275`; auto-setup reaches the same call, `setup.go:356`). It still loads only `library.Embedded()` (`internal/store/postgres/library.go:15-21`), so the safety meaning holds. The verifier's suggested wording: "no API, tenant or runtime path writes anything else into it (the setup wizard re-runs the same `EnsureLibrary`)". Receipt: `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/verifier-merge/docs-claims-86c16b8.log`.

## What to do

1. Verify the finding yourself (`receiving-code-review`): confirm every runtime caller of `EnsureLibrary`/`loadLibrary` and that each loads only the embedded library.
2. Correct the sentence in `internal/web/README.md` so it's exactly true (the verifier's wording or equivalent; plain, short, no overstatement). Grep the story's other docs and comments (`internal/web/README.md`, `internal/library/preview.go`, `internal/library/catalog.go`, `internal/web/library.go`) for the same claim and correct any copy. Docs and comments only: no code, test or dependency change. If the sentence can't be made true without a code change, stop and say why.
3. One commit `docs(86bcm901v): …`, plain `git commit -m` (identity from git config; check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`). **No AI attribution, no Co-Authored-By lines.** Never commit `CLAUDE.md`.
4. In your report, give the corrected **PR Assumptions preview-cost bullet**. Start from this draft and change only what the correction needs: "The library item page's Markdown preview has no cost bound: goldmark pads every short table row to the header's column count, so a table's HTML grows with columns × rows (a 16 KB table renders to 80 MB of HTML in about 4 s and allocates 1.8 GiB; a body or example at the 64 KiB limit could need tens of GiB, extrapolated). Accepted for now because content reaches `library_items` only through `EnsureLibrary`, which loads the files under `internal/library/content` compiled into the binary; no API, tenant or runtime path writes the table, and main takes changes to those files only through a pull request. Upstream items imported by 86bcm945u (PR #89, now on main) arrive the same way: `cmd/library-upstream` writes their files, and they ship once that change is committed and merged (the imported `debugging-and-error-recovery` skill renders in about 0.1 ms). A bound on table cells, or an escaped code view as the fallback, is a follow-up that must land before content can reach `library_items` without such a commit (e.g. tenant variants or a runtime import). Recorded under Limits in `internal/web/README.md`."
5. **Before you stop**, on your new head: `make check` with Postgres and CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0, per the `leorna` skill; read the DB password before narrowing PATH), and the three AC tests alone with the plan's commands (logs `ac<n>-<sha7>.log`, first line `HEAD=…`, last line `EXIT=…`). Logs with real exit codes; read each before citing it.

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (FINISHER role, fix pass only; skip its Step 1 load except `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` and the repo's `AGENTS.md`).
2. `engineering-best-practices`.
3. `receiving-code-review`.
4. `git-commit-rules`.

## Boundaries

- No push, PR edit, merge, ClickUp writes, server/cloud actions, or `.github/` edits.
- Leave the worktree committed and clean (`git status --porcelain` empty); scratch outside it.
- **Your test DB:** `leorna_86bcm901v_v3_fixmerge2_test` in `leorna-test-pg` (ends in `_test`; create, drop at the end). Never use another agent's or story's DB.
- **Your receipts** go in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/fix-merge2/`. Don't modify other files in the evidence folder.
- Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows.
- Out of scope (logged as a follow-up, don't touch): the shared `td{overflow-wrap:anywhere}` mid-word wrapping in `adminBaseCSS`.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity); don't fix it.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: ready-for-verify|stopped, prev_head, head_sha, commits[], finding_confirmed{ok, evidence}, readme_text_before, readme_text_after, other_copies_fixed[], pr_assumptions_preview, ac_status[{ac, test, result, log}], gates[{name, exit_code, log}], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
