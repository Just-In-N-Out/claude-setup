# FIXER brief — 86bcm928e custom integrations, fix round 2 (AC2 not accepted)

**Role:** a fresh FIXER (Opus 5.5, high effort) for Leorna card 86bcm928e "Custom integrations defined by the admin" (control plane, Full pipeline). Fix the blind AC auditor's finding on AC2's test, commit, and stop at `ready-for-next-review`. No push, PR, merge or ClickUp write; start no agents (a fresh delta reviewer, then a new verifier and auditor, come next, run by the main session).

## Where
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head `94fa2ee03ced193b65f76848e7e8ec09712f3668`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`. Confirm both and a clean `git status` first.
- Approved plan (the contract): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`. Don't change approved behaviour; if the fix needs a design decision the plan doesn't make, stop with `status: stopped` and the options.
- `ac-check.sh` printed: `AC2  NOT ACCEPTED: auditor did not accept it` / `NOT ACCEPTED: 1 of 3 ACs on 94fa2ee` (AC1, AC3 accepted; reviews clean on 94fa2ee).
- Both reports: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/auditor/ac.json` (with `auditor/mutants/`: specs `specs.py.txt`, probe sources, logs A2-2, P-A2-2, P2-head) and `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/verifier/ac.json` (and `verifier/mutants/SUMMARY.txt`). Your own evidence goes in `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/fixer-2/`.

## Skills (load each with the Skill tool, say so in one line)
`leorna` (hard rules; skip its Step 1 load except `leorna-control-plane-workflow.md` and the repo's `AGENTS.md`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `multi-tenant-auth-management`, `git-commit-rules`.

## What to fix (verify each first; push back with evidence on any that isn't real)
- **AU1-1 (P2, AC2)** `internal/web/custom_integrations_test.go:523-537`: the "another company's pack builder" clause can't fail. The other company's POST to `/admin/library/packs` has no `target_key`, so the pack builder answers 409 "Choose a team or project" for any item (its own too), and the `equal and >= 400` assertion holds with the ownership guard removed (auditor mutant A2-2: `c.tenant_id=$2` always true in `internal/store/postgres/pack_builder.go:315` → AC2 still passes). Fix, keeping the test name: give `f.other` its own team, post the foreign ids with `target_key=team:<that team>`, assert exactly 400 (INVALID_PACK) with no review page, beside a control that the other company's own configured item reaches the review (200). A direct `CreatePack` for the other tenant → `org.ErrInvalid` (as `integrations_test.go:635` does) may be added too, not instead.
- **Verifier V7 (same AC2 test, add-only)**: AC2 configures `region=eu-west`, equal to the parameter's example, so a mutant rendering the examples instead of the admin's values survives AC2. Use a configured value different from the example and assert it lands in the Claude Code, Codex and Cursor files.
- These are edits to an AC test: only add or tighten assertions, never weaken or remove one. No production code should need to change (the guard is correct on head per the auditor); if it does, stop and say why. Don't fold anything else in.

## Rules
- Prove each tightened clause: rerun the auditor's A2-2 spec and the verifier's V7 spec as `go test -overlay` mutants against the AC2 test — each must now be killed on the new assertion's own line (save logs in `fixer-2/`) — and the no-mutation control must pass. Each run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- The three AC tests and every existing integration/web/store test stay green.
- Gates once on your final head into `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/gates-<sha7>.txt` (one `label EXIT=<rc>` line each), serially, in a detached copy, with your own Postgres (`928e-fixer2-pg`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, db name ending `_test`, wait with `docker exec … pg_isready -h 127.0.0.1`), removed at the end. Toolchain `~/.local/leorna-toolchain/go/bin:~/.local/leorna-toolchain/bin` (golangci-lint 2.14.0, govulncheck 1.7.0, by absolute path). Known outside-the-story failure: `make audit` on GO-2026-6859 (base fails the same); prove the rest with `make secrets library-check build` and the other targets. Also run `gitleaks git` over base..HEAD. Under load `internal/web -race` can hit the 10-minute default: rerun before judging (`leorna/references/gates.md`). Never run your own tests alongside `make check`.
- If the AC2 screenshot's page changed, retake it (result only, no banners); a test-only change normally leaves it unchanged — say so.
- Commits: plain `git commit -m "fix(86bcm928e): …"`, never author flags, no AI attribution or Co-Authored-By lines. Don't write key-shaped values whole in test source. Remove scratch (`~/.cache/928e-fixer-2/`, never `/tmp`); deregister detached copies with `git worktree remove --force` (never `prune`).
- earlyoom: for any 143/137/"Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Don't end your turn to wait for a background command; foreground polls under 170 s with the Bash `timeout` above the bound.
- Anything else you find: `found_else` (one line each, evidence, severity), not fixed.
- Lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section (`enforce` is `none` or a one-line check proposal). An empty list is normal.

## Report back
`{status: ready-for-next-review|stopped, summary, head, commits[], dispositions[{id, action: fixed|pushed-back, evidence, test}], gates[{label, exit}], shots_changed, mutants[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
