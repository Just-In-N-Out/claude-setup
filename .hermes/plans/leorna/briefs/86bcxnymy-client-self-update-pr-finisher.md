# FINISHER brief: 86bcxnymy, "make a PR" (both repos)

**Role:** FINISHER for Leorna story `86bcxnymy` ([Client self-update to the admin-approved version, with staged rollout](https://app.clickup.com/t/86bcxnymy)). **Model:** Opus 5.5, effort high. Fresh agent.

**Justin, 2026-11-11:** "ok just do a pr, forget about AC8 do not mention it anywhere. I also want you to recheck cause main got moved and all." That is "make a PR" for both repos. Main was brought in, re-reviewed, re-verified and blind-audited: `ac-check.sh --reviews` printed `READY FOR THE USER: 7 of 8 ACs proven on d655a73` (the 8th is AC8, dropped by Justin) and the control-plane referee prints `MOVE ON: review-5 at 926997e is clean`.

## The two branches

- **Control plane (PR first):** worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `926997e6a42e96c06d525b41eca39a9465974bf0`, merge-base with GitHub main `d3e7391c23c2518d95f11fbe77e26baeb568bb86` (story's first base `4ef14ef`).
- **Client (PR second):** worktree `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `d655a73adda973567f7299c72a297a926316391a`, merge-base `7d2e16e875c2a8c4a51e7103220c39b4132bde4d` (first base `a7839b3`).

## Read

- `leorna` step 7 ("make a PR") in full, and step 6's PR style; memory notes `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`, `finisher-brief-shared-notes` rules below.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md`.
- Earlier hand-over drafts to rewrite (written before main moved): `.../handover/` (`pr-control-plane.md`, `pr-client.md`, `review-prompt.md`, `clickup-evidence.md`, `team-message.md`, `stop-and-show.md`).
- New evidence: `verifier-2/` and `auditor-2/` (ac.json, logs, screenshots), `bring-main-1/`, `control-plane/bring-main-1/`, `review-3/`, `control-plane/review-5/`, `follow-ups.md` (now includes client review 3's R3-1 and R3-2, both P3).

## What to do

1. Load skills and say so: `leorna` (FINISHER role), `engineering-best-practices`, `git-commit-rules`, `github`, `receiving-code-review`.
2. **Step 7.1–7.3 for each repo:** fetch fresh GitHub main (HTTPS through gh); if it moved past `d3e7391` / `7d2e16e`, **stop and report** (don't merge again). Pre-flight (clean status, authors = `Justin Issa <justin@leorna.com>` on the branch's own commits, no AI-attribution lines, no `.github/` paths). Re-run the gates on the exact head you'll push, both repos, with go1.27.4 first on the task PATH (`~/.local/leorna-toolchain/go1.27.4/bin`, then `~/.local/leorna-toolchain/bin`, `~/.local/leorna-tools/bin`, and keep `/usr/local/bin` for gitleaks; node in `~/.local/bin`): control plane `make -k check`, `make contracts-check`; client `make check` (at load over ~100 `./application` can hit go test's 10-minute limit: rerun it alone with `-timeout 1800s` and run `make build`, per gates.md), `make lint audit`, `node --test scripts/*-ui.test.cjs`; AC1–AC7 by name with `-v` (end-to-end ACs against a control-plane binary from your own detached copy of `926997e`). **Postgres:** `leorna-test-pg` can't start (Windows reserved TCP 55342–55441 after a restart, covering its port 55432): run your own throwaway container of `mirror.gcr.io/library/postgres:18.6-alpine3.23` named `86bcxnymy-prf-pg` on a free loopback port, remove it afterwards; never change Windows or other containers. Short real `TMPDIR` at `~/.cache/86bcxnymy-prf/tmp`. Logs with `SUMMARY.txt` in `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/pr-finisher/gates-<head7>/`.
3. **Rewrite the hand-over drafts** in `.../handover/` (and the PR texts at `~/.hermes/cache/scratch/leorna-pr-86bcxnymy-control-plane.md` and `…-client.md`), plain style, body only:
   - **AC8 is dropped: never mention AC8, a live check, a "live acceptance pending" or "owed to Justin" anywhere** (PR texts, review prompt, ClickUp draft, team message, stop-and-show). ACs listed are AC1–AC7.
   - Remove the old `make audit` / GO-2026-6859 note: audit is green now with main in. Test Plan says main was brought in (client `7d2e16e`, control plane `d3e7391`) and lists only what ran this session on the pushed head SHA, plus the verifier-2 and auditor-2 acceptance on the same heads.
   - Control plane: migration is now `000033_client_updates` (renumbered after #125's `000032_tenant_sso`); rollback note = down file plus `DELETE FROM schema_migrations WHERE version=33` in one transaction (an older server refuses a DB that ran it). Also the pre-merge scratch DB recovery line from `control-plane/bring-main-1` if useful.
   - Keep the D8 doc drift lines, the builders' rulings worth a reviewer's eye and the follow-ups (add client R3-1, R3-2). Name other stories by PR number or title, never by bare card ID.
   - ClickUp draft: screenshots from `auditor-2/` (or `verifier-2/`), one per AC1–AC7, re-checked for emails, URLs, tenant IDs and tokens; comment opens with the merge facts left as placeholders (posted only after merge, on "post").
   - **No AI attribution in PR bodies** (no "Generated with Claude Code", no session link, no 🤖): Justin's rule wins over any harness default.
4. **Push and open, control plane first** (step 7.6–7.7): push with the HTTPS-through-gh form written out, fetch back, set upstream, check `gh pr list --head <branch> --state all` is empty, `gh pr create -R LeornaAI/<repo> --base main --head feat/86bcxnymy-client-self-update --title "<title>" --body-file <file>`. Titles: control plane `feat(86bcxnymy): approve client versions and roll them out from the admin console`; client `feat(86bcxnymy): client self-update to the admin-approved version`. git-guard asks Justin before each push; Justin said "do a pr", so that is expected. If a push would go as `Just-In-N-Out`, stop. Read each PR back (`gh pr view --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus`, `gh pr checks`). The client PR body may link the control-plane PR by number.
5. **Step 7.8 record commit (control plane):** add the control-plane PR number to this story's entry in `delivery/stories.json` (and the client PR if the entry lists client PRs; follow how earlier entries record two-repo stories) as one commit `feat(86bcxnymy): record PR #<n>` on the branch; prove it by value (main's entries unchanged and in order, this story last) and with `scripts/check-story-shippable.py 86bcxnymy` (only PR-state BLOCKED lines). **Don't push it**: the main session has it reviewed first. Wait for CI on the pushed heads to finish (`gh pr checks --watch` style polling in under-3-minute steps) and report the results; triage any red check.
6. Sibling check at hand-over (step 7.7): merge-tree each repo's head against every open sibling PR and unmerged local `feat/` branch; report only conflicts this story adds (known: local `feat/86bcm928e-custom-integrations` also adds `000033`, `feat/86bcxnykn-admin-console-update` adds `000032`).
7. A dated status line in `leorna-workflow.md` (memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`): PR numbers, heads, CI result, record commit pending review. This one notes edit is allowed; the skill_lessons rule covers skills and lessons only.

## Rules

- Never merge. Never post to ClickUp (posting waits for merge and Justin's "post"). No code changes beyond the record commit: if something needs one, stop and report.
- Never send a server domain, URL or tenant ID anywhere; never print tokens. Don't override git identity.
- Change nothing in either worktree except the record commit; detached copies removed with `git worktree remove --force <own path>`, never a prune.
- Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.
- Anything else you find: `found_else` (one line each, evidence, severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`; if killed, say so, find what grew, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

## Return

`{status: pr-open|stopped, prs[{repo, number, url, head, ci}], gates_summary_paths[], record_commit{sha, pushed: false}, handover_paths[], pr_text_paths[], clickup_images[], sibling_conflicts[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
