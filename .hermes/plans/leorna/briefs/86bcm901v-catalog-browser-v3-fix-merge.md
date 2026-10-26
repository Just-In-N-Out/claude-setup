# FIXER (merge with main) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FIXER** (Opus 5.5, xhigh). PR #88 is open and now conflicts with `main`. Merge `main` into the branch, make the branch correct against what `main` now contains, fix two docs statements that `main` made untrue, and stop at `ready-for-verify`. **No push, no PR edit, no ClickUp.**

## The candidate

- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (pushed as PR #88; upstream `origin/feat/86bcm901v-catalog-browser-v3`).
- **Current head:** `2c43b3941ced883c8d4aa6f7bad7913a9043c173` (accepted 3/3 on base `6e74ced` before main moved). Clean worktree.
- **origin/main:** `6275a4e` (fetched by the main session at 2026-10-24 ~18:30Z). Re-fetch with the HTTPS-through-gh command (`leorna` step 7.1) and say whether it moved again; merge whatever `origin/main` is then and name its SHA.
- **Approved plan (read-only, never edit):** `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md`. Justin's later decisions: the working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md`, last section "Merge with main after PR #88 opened".
- **ACs (unchanged):** AC1 filter by kind, category, tag and supported tool + text search; AC2 item page with description, example, version, supported tools and a rendered preview; AC3 filtering <300 ms server time with 200+ items. Tests `TestLibraryAC1FilterAndSearchWithPostgres`, `TestLibraryAC2ItemDetailWithPostgres`, `TestLibraryAC3FilteringUnder300msWithPostgres` in `internal/web/` (exact commands in the plan).

## What landed on main since `6e74ced`

- **PR #85 (86bcm9016, prompt kind):** migration `000021_pack_prompt_kind` widens `library_items.kind` (and pack tables) to include `prompt`; a library prompt item `internal/library/content/items/prompt/pr-description/`; prompt handling in `internal/pack`, contracts and `internal/web/prompt_publish_test.go`.
- **PR #89 (86bcm945u, upstream sync):** `internal/library/upstream/*`, `cmd/library-upstream`, item sources/upstream records in `internal/library` (`library.go`, `source.go`, `upstream.go`, `lock.go`), the imported skill `internal/library/content/items/skill/debugging-and-error-recovery/` (from agent-skills, MIT), and an admin page `GET /admin/third-party-content` (`internal/web/third_party_content.go`, `SetContentLibrary`).
- **Text conflict (from `git merge-tree`):** `internal/web/handler.go` only. Both sides added the same `internal/library` import, added a `Handler` struct field next to each other (`libraryCatalog library.Catalog` vs `contentLibrary *library.Library`), and both changed the admin-home nav line (ours adds "Library" after "Packs", main adds "Third-party content" at the end). Keep both sides' meaning: both fields, both routes, both links. `cmd/control-plane/main.go` and `internal/web/packs_test.go` auto-merge; check the result is still right (both `SetLibrary(...)` and `SetContentLibrary(...)` wired).

## What to do

1. **Merge, don't rebase (Justin's choice):** `git merge --no-ff origin/main` with git's default message (or `Merge branch 'main' into feat/86bcm901v-catalog-browser-v3`). Resolve `handler.go` as above. No force-push will be needed; don't rewrite the 8 existing commits.
2. **Semantic check against the new main (look for breakage the text merge can't show):**
   - **Prompt kind:** `library_items` can now hold `prompt` items and main ships one. Check that the catalog handles it end to end: the Kind filter offers Prompt and `?kind=prompt` returns the `pr-description` item (no 400), facets/labels read well, the item page renders (body as Markdown, not as code), and nothing in `internal/library/catalog.go`, `preview.go`, the store query or the web templates hard-codes the four old kinds in a way that now breaks. If something is wrong, fix it **test first** (`test-driven-development`; failing test first, then the fix) in its own `fix(86bcm901v): …` commit.
   - **Upstream items:** check our list and item pages are correct for the imported item (it has source/licence fields now; our pages need not show them, since `/admin/third-party-content` does, but they must not break or mislabel it). Time `RenderMarkdown` on the real imported `debugging-and-error-recovery` body and example (and the prompt item) and record the numbers.
   - **Import path (for the docs fix below):** confirm, with file:line evidence, how upstream content reaches `library_items`: our understanding is that `cmd/library-upstream` writes files under `internal/library/content` that are committed (reviewed in a PR), embedded in the binary, and loaded by `EnsureLibrary`, and that no runtime path writes upstream or tenant content into `library_items`. If that's wrong, stop and report: the docs decision below depends on it.
3. **Docs fixes (Justin's choice "Follow-up, fix wording": no guard code):** one `docs(86bcm901v): …` commit.
   - `internal/web/README.md` Limits line about the preview cost: today it says the risk is acceptable because only content Leorna writes reaches `library_items` and names 86bcm945u as a future trigger. Reword it to be true now: upstream items imported by 86bcm945u do reach `library_items`, but only through a reviewed commit of files under `internal/library/content` that the binary embeds; a bound on table cells (or an escaped code view as fallback) must land before content can reach `library_items` without such a commit (e.g. tenant variants or a runtime import). Keep the measured numbers; add the real imported item's timing if it helps. No overstatement.
   - Remove or correct any README text (ours) that says the Prompt filter will be empty until a migration widens `library_items.kind`.
   - In your report, give the **replacement PR Assumptions wording** for (a) the preview-cost bullet and (b) the Prompt-kind bullet (now: the Kind filter offers Prompt and shows main's prompt item), plus any Changes/Summary line that the merge makes stale.
4. **Gates on your final head**, with CI's tool versions bound by absolute path (golangci-lint 2.14.0, govulncheck v1.7.0, per the `leorna` skill): `make check` with Postgres, a separate verbose `go test -v -count=1 ./internal/library/... ./internal/store/postgres/... ./internal/web/... ./cmd/control-plane/...`, `bash ./scripts/test-module-add.sh`, `make contracts-check`. Also `git merge-tree --write-tree --name-only HEAD origin/main` (must exit 0) and `git diff --name-only origin/main...HEAD -- .github contracts packages/contracts` (must be empty). Logs with real exit codes; read each before citing it.
5. **The three AC tests alone** with the plan's commands on your final head: logs `ac<n>-<sha7>.log` (first line `HEAD=…`, last line `EXIT=…`).

## Skills (load with the Skill tool, in this order; say so in one line each)

1. `leorna` (FINISHER role, fix pass only): Doing a story → step 4 (control-plane gates and tool binding) and step 7.1 (the fetch); skip its Step 1 load except `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` and the repo's `AGENTS.md`.
2. `engineering-best-practices`.
3. `test-driven-development` (only if step 2 finds a defect to fix).
4. `security-best-practices` (for the import-path check and the docs statement about who can write `library_items`).
5. `git-commit-rules`.

## Boundaries

- Commits: plain `git commit -m` / `git merge` (identity from git config; check `git log -3 --pretty=format:'%an <%ae>'` shows `Justin Issa <justin@leorna.com>`). No author overrides. **No AI attribution and no Co-Authored-By lines** (Leorna rule). Never commit `CLAUDE.md`.
- **No push, no PR edit, no ClickUp, no merge into main**, no server/cloud actions, no `.github/` edits. The main session pushes later, on Justin's word, after the ACs are re-proved.
- Leave the worktree committed and clean (`git status --porcelain` empty, nothing untracked); keep scratch outside it.
- **Your test DB:** `leorna_86bcm901v_v3_fixmerge_test` in `leorna-test-pg` (ends in `_test`; create, drop at the end). Read the DB password before narrowing PATH (`leorna` skill). Never use another agent's or story's DB.
- **Your receipts** go in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/fix-merge/`. Don't modify other files in the evidence folder.
- Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows. Leave the untracked `deploy/local/` in the main checkout alone.
- If a decision isn't yours (e.g. the catalog needs a design change to show prompts well), put it in `questions` with lettered options and a recommended one, and stop.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity); don't fix it.

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: ready-for-verify|stopped, prev_head, origin_main_merged, head_sha, merge_base, commits[], conflict_resolution, prompt_kind_check{ok, evidence, fix_commit}, upstream_item_check{ok, render_timings}, import_path{confirmed, evidence[]}, readme_limits_text, pr_text_updates{assumptions_preview, assumptions_prompt, other[]}, ac_status[{ac, test, result, log}], gates[{name, exit_code, log}], questions[], found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
