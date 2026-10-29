
# FIXER 2 — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: the fixer after review 2 (`review-fix-cadence`: review 2 → **you** → review 3, a fresh review of the fix commits since `b534978` → … until the referee says MOVE ON → verifier → blind auditor). Verify the P2 finding below, fix it test-first, then do Justin's added task, commit, and stop at `ready-for-next-review`. No release, no hand-over, no rebase and no bringing `main` in (the finisher does that at the end).

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`, base `b65f797ff6cdc56a802dfaf417b0adec96463317`. Reviewed head **`b53497825caa4802b142c4844e4edab1e814cfef`**: confirm the worktree is at that head and clean before you start.
- Approved plan (read-only, never edit): `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md`. Working plan: `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`; its section "Justin's answers after review 2" records the added task below.
- Review 2's evidence: `~/.hermes/plans/leorna/evidence/86bcm901z/review-2/` (`review.json`, `probe-secret-two-fields.log`, the overlay probe `probes/zz_review2_secret_probe_test.go.txt`, `mutations-review2*.txt` with mutant N2). Reuse the reviewer's probe to prove the fix; copy what you need, don't edit that folder.
- Earlier rounds: `review-1/review.json` and `fix-1/dispositions.md` (R1-1 fixed and closed by review 2).
- The builder's and fixer 1's records: `~/.hermes/plans/leorna/evidence/86bcm901z/INVENTORY.md` (builder rulings and the "Fixer 1" section), `fix-1/mutations-b534978.txt`.

## Skills (load them first with the Skill tool and say so)
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `git-commit-rules`.

## The finding to fix (referee output, verbatim)
```
R2-1  P2  internal/web/library_variants.go:487  A suspected secret in an agent variant's description is echoed back: an agent's description is also its body's frontmatter description line, gitleaks finds it in both, and variantRefused clears only the field named by the first finding (clearText(secret.Location)), so the 422 page shows the token again in the other textarea. AC4 and the README promise a suspected secret is never echoed back. The same happens for a skill whose description and body both hold a token.
```
Reviewer's scenario: an admin edits an agent variant and puts an API token in its description (and in the matching frontmatter line, as the editor requires). The save is refused with "suspected secret in description" and the description textarea is emptied, but the main-text textarea shows the token back on the same page.
Reviewer's evidence: `review-2/probe-secret-two-fields.log` (real gitleaks 8.30.1, real Postgres): agent with the token in its description, 3 runs: 422, `bodyTextareaHasToken=true`; skill with the token in both fields: the same; control (token in the description only): no echo. `gate.CheckTenantItem` (`internal/library/gate/tenant.go:86-101`) reports one location. Mutant N2 (the "description" clearing branch made a no-op) survived all 79 TestVariant*/TestLibrary* web tests: AC4 only covers a secret in a skill's main body.
Reviewer's suggested fix (a suggestion, not an order): on a TenantSecretIssue located in "main body" or "description", clear both typed text fields (edit and resolution), like the unknown-location default.

## Justin's decisions after review 2 (2026-10-29)
Justin's words: "R2-1: Keep going (Recommended). Item editor secret echo: Fold into this fix."
1. **R2-1:** fix it (the loop continues).
2. **Added task, its own last commit after the R2-1 fix:** the existing item editor has the same defect: `internal/web/item_create.go:193-203` clears only the field the secret scanner names first, so an agent item whose description holds a token is shown back in the other field (reviewer 2's found_else, by code reading). Verify it first with a probe like the reviewer's; if it doesn't reproduce, say so with evidence and don't change that file. Otherwise fix it the same way, test-first, in a separate commit.
- **Done means:** no 422 secret refusal from the item editor or the variant pages (edit, resolve) shows any part of the token, whichever field holds it. No AC changes: AC4's wording and test name stay as approved.

## How to work
- Verify R2-1 first (`receiving-code-review`): reproduce it with the reviewer's probe on `b534978`. If it doesn't reproduce, push back with evidence and stop.
- Then failing tests: an agent variant with the token in its description and frontmatter → 422, no part of the token anywhere on the page, both textareas empty; a skill variant with the token in the description only (kills N2); a skill with the token in both fields; the same for the resolver if it can be reached with a token. Add them as subtests of AC4's test or as new tests next to it; AC test names stay exactly as the approved plan names them. Then fix.
- The item-editor task: the same shape of test for `item_create.go` (agent description token → 422, no token on the page), then the fix.
- Prove the fixes with mutation (`mutation-testing-discipline`): at least N2 and "clear only the named field again" for both pages must be killed by your new tests. Re-run the builder's M1–M18 and fixer 1's F1–F6 on the new head and record the results.
- Update any README or page text that states the clearing rule so docs and code agree.
- Commits: `fix(86bcm901z): …`, small and often, by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.
- The P3 findings (R1-2 the untested diff cap, R1-3 the migration renumber after PR #101 merged, R2-2 the rare merge loss in runs of identical lines) are **not** part of this fix: they go to the follow-up list and the finisher. Don't change them.

## Gates and evidence
- Re-run on the final head: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB `leorna_86bcm901z_fix2_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on PATH (`/usr/local/bin/gitleaks`, and `LEORNA_TEST_GITLEAKS_BIN`) and over the story range, each AC test by name, and the `go test -json` check that the Postgres tests really ran.
- Evidence: per-head logs `gates-<sha7>.txt` and `ac<n>-<sha7>.log` in `~/.hermes/plans/leorna/evidence/86bcm901z/`, plus your dispositions and probes in `~/.hermes/plans/leorna/evidence/86bcm901z/fix-2/` (create it; `dispositions.md` with R2-1's and the item-editor task's verdict, test, commit and evidence, and `mutations-<sha7>.txt`). Fixture tokens in logs must be fake and must not trip gitleaks on the evidence folder; gitleaks-scan your own folder before handing back. Never write in `review-*`, `fix-1/`, `verifier/` or `auditor/`, and never touch `plan-approved.md`. AC4's screenshot is a terminal capture of its test run: if you add AC4 subtests, re-render `ac4-refused-terminal.png` from the new head's log with the builder's recipe and look at it yourself (no domain, URL bar, tenant ID, token or email). Update `INVENTORY.md` (AC map, rulings, which head each file comes from).
- Scratch: a fresh `<scratchpad>/86bcm901z-fix2/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles and mutation copies in `~/.cache/86bcm901z-fix2/`. Mutation copies are detached worktrees removed with `git worktree remove --force` on their exact path. **Never run `git worktree prune`.** Remove only your own folders, by literal absolute path, and drop your DB at the end. Leave the worktree committed and clean.
- Never touch other stories' worktrees, branches, DBs or evidence (another session is running 86bcm902w on the same repo).
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.
- You can't ask Justin anything. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and INVENTORY.md. If the fix would need a design change beyond the approved plan and Justin's decisions above, stop with `status: stopped` and list the options.

## Rules for every role
- If you find any other bug or problem outside this finding and task, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-next-review|stopped, summary, reviewed_head, new_head, dispositions[{id, verdict: fixed|pushed-back, test, commit, evidence}], rulings[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], mutations{killed[], survived[], not_run[]}, shots[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
