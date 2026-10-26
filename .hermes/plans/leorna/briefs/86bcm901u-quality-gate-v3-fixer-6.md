# FIXER 6 (integration) brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 6** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Your job is **integration**: bring the branch onto the new GitHub `main`, run the approved plan's task **T7**, re-check the render port against the client's new `main`, re-run everything, and stop at **`ready-for-verify`**. No hand-over, push or PR.

## What happened

At 14:17 EDT today two sibling PRs merged:
- **Control plane PR #85** (`86bcm9016` prompt kind). CP GitHub `main` moved from `6e74ced` (this branch's base) to **`58d1095`**: 5 commits adding the `prompt/pr-description` library item (`internal/library/content/items/prompt/pr-description/{item.json,body.md,example.md}`, `library.json`, `content.lock.json`), `pack.KindPrompt` (`internal/pack/pack.go`), migration `000021_pack_prompt_kind`, contract changes, and edits to `README.md`, `internal/library/README.md`, `delivery/stories.json`.
- **Client PR #20** (prompt sync). Client `main` is now **`17f7c1b`** = `ea2b8ab` + PR #20 at its unchanged head `1f259b0`. This branch's `internal/library/render` port is pinned to client `ea2b8ab` + PR #20 `1f259b0` (see `internal/library/render/testdata/client/SOURCE.md`).

The approved plan foresaw this: "if #85 merges first, the rebase conflicts are text-only and T7 swaps in `pack.KindPrompt`".

## 0. Disk and shared machine

About 7 GB free. Run `df -h /` before heavy gates; under 3 GB, stop with `status: stopped`, `stop_reason: disk`. Never run `go clean -cache`. A gate failing with "open …/go-build/…: no such file or directory" across unrelated packages is a host problem: keep the log under a suffixed name and rerun the unchanged gate. Delete your own scratch and any container you start when done.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer rules, gates, step 7.1's HTTPS fetch through `gh`; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `git-commit-rules`: before rebasing or committing.
4. `test-driven-development`
5. `mutation-testing-discipline`
6. `api-contract-drift-guard` and `backend-data-migrations`: main brought a migration and contract change; confirm this story still adds none of its own.

## 2. Steps

1. **Fetch** CP `main` over HTTPS through `gh` (`leorna` step 7.1): `git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`; confirm `origin/main` = `58d1095…` (if it moved further, use the new tip, record it, and say so). Don't touch local `main`.
2. **Preview**: `git merge-tree --write-tree --name-only HEAD origin/main` to list conflicts.
3. **Rebase** `feat/86bcm901u-quality-gate-v3` (worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, head `90407b34d8043d8e7a78ba91a7caf62d39830976`) onto `origin/main`. The branch is local only (never pushed), so rewriting its commits is fine. Resolve conflicts keeping **both sides' meaning**: `internal/library/README.md` (both add a section), `delivery/stories.json` (both add an entry; keep 86bcm9016's entry exactly as main has it and this story's entry with an empty PR list), root `README.md`. Expected to be text-only; **if a conflict is semantic** (code, not prose), resolve conservatively in favour of main's behaviour and record it as a ruling; stop only if no safe resolution exists. Keep commit messages and authorship as they are (author from git config only; no `Co-Authored-By` or AI attribution lines). Before rebasing, note the old head so it stays reachable (`git branch backup/86bcm901u-v3-pre-rebase 90407b3` is fine; it stays local).
4. **T7** (approved plan, verbatim): "Replace `kindPrompt` with `pack.KindPrompt` in `render.go` (delete the constant), run `go test ./internal/library/... ./cmd/library-gate`, and make sure AC3 passes with the real `prompt/pr-description` item (Claude Code and Cursor rendered, Codex not declared). Commit `feat(86bcm901u): use pack.KindPrompt now that 86bcm9016 is merged`." Test first where a behaviour changes; if the real prompt item exposes a gate bug, fix it test first and record it.
5. **Re-check the render port against client `main` `17f7c1b`.** Fetch the client into scratch over HTTPS (never the real client checkout), and compare each ported file and every copied golden with `17f7c1b`. If the port's behaviour is identical (only the plan's renames), update `SOURCE.md` to name `17f7c1b` with fresh SHA-256s and say so in a commit (`chore(86bcm901u): pin the render port to client main 17f7c1b`). If client `main` differs (e.g. the PR #20 merge changed `codex/config.go`), follow the render README's refresh steps to match client `main`, test first against the client's own goldens, and record it.
6. **Re-run everything on the new head** as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; main's migration 21 runs on it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check` (now with 9 items incl. the prompt), every AC command, the AC4 test under GNU Make 4.3 as fixer 5 did if disk allows). Save `gates-<sha7>.txt` + `.json`; no email in them.
7. **Base-run sanity**: each AC test must still fail (or fail to build) on the new base `58d1095` with head's test files copied in; save `base-ac-runs-58d1095.txt`.
8. **Mutations**: re-run the full recorded set (fixer 5's 48 entries) on the new head and save `mutations-fix-6-<sha7>.txt`, plus a mutant for T7 if one makes sense (e.g. prompt rendering dropped → AC3 with the real prompt item fails).
9. **Screenshots (Justin's one-per-AC rule):** retake **all four** AC1–AC4 captures on your final head as real Terminal captures (the `leorna` recipe: clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, nothing secret on the launch line, count `EXIT=` markers after `clear`, close the window by id in a trap, pipe any `docker exec` step through `| cat` with pipefail). AC3's capture should show the real library passing **with the prompt item**. Inspect each image. Update `INVENTORY.md`, marking older captures superseded.

## 3. Boundaries

- Story-only CI exception: `ci.yml` keeps only its one added step and env block vs the new base; no existing step removed, reordered or weakened. Makefile: only this story's `library-check` additions vs the new base.
- No push, PR, merge into `main`, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts, the `86bcm9016-prompt-kind` worktree (now merged; leave it), other stories' worktrees, DBs and scratch, `deploy/local/`, the real client checkout.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `verifier-r*/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- **Justin is away (away grant):** on a real trade-off, pick your recommended option and record it as "My ruling (away grant), not yet confirmed". Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list options with your recommended one marked.
- **Found something else?** `found_else`; don't fold it in.
- **Skill lessons:** don't edit any skill or memory file; list reusable lessons in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## 4. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, old_head: "90407b3", new_base, last_commit, commits[], conflicts[{file, resolution}], t7, client_repin, rulings[], gates[{name, log, exit_code}], base_runs, mutations, ac_evidence[{ac, test, log, screenshot}], disk_free_at_end, stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
