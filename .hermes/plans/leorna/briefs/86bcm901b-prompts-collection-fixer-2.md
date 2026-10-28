# FIXER 2 brief: 86bcm901b-prompts-collection [leorna]

**Role:** FIXER 2 (fix pass for review 2) for the Leorna story "86bcm901b-prompts-collection", Full pipeline. You are a fresh agent. Verify each of reviewer 2's findings, fix the valid ones test-first **as a whole class**, push back with evidence on the rest, re-run the gates, commit, and **stop at `ready-for-verify`**. After you: a fresh read-only verifier, then a blind AC auditor, then the finisher's hand-over. No hand-over work in this pass.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role for the fix pass, with its Step 1 context load for the control plane).
2. `engineering-best-practices`.
3. `receiving-code-review`: verify each finding before fixing it.
4. `test-driven-development`: a failing test (or a surviving mutant) before each change.
5. `git-commit-rules`.
6. `security-best-practices` and `mutation-testing-discipline` (its common mistake 4 now says a guard over a set needs one mutant per member).

Also `systematic-debugging` whenever a test fails unexpectedly.

## Inputs

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`, reviewed head **`c889a5a168aad92b4c5463e322bd96fa3777f9ef`**, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- **Plan:** `/home/justin/.hermes/plans/leorna/86bcm901b-prompts-collection.md` (read-only approved copy: `evidence/86bcm901b/plan-approved.md`). Under "Justin's answers (2026-10-28)" it now holds the **Review 1 F4 ruling** and the **Review 2 R2-2 ruling**: every prompt's review note and `example.md` say only what the prompt body supports and what this story verified, and say plainly when tool behaviour is not verified.
- **Reports:** review 2 `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/review-2/report.md` (with probes and mutants in `review-2/` and `review-2/tools/`); for history, review 1 `review-1/report.md` and fixer 1 `fix-1/report.md`.

## Reviewer 2's findings (verify each)

**R2-1 (minor, introduced): review 1's F2 class (surviving guard mutants) is not closed.** `internal/library/upstream/layout.go:228`: the description one-line check is a `strings.ContainsAny` over CR and LF; dropping CR from it survives every test (only LF is tested), and `Item.Validate` allows CR in a description (`library.go:215-218`), so nothing downstream catches it (`review-2/probe-lone-cr-description.log`, `review-2/mutations-review2-c889a5a.txt` V1). Add the subtest reviewer 2 proposed ("an escaped lone CR in the description", expecting "the command description must be one line"; it passes on head and kills V1). **Close the class:** go through every guard this story added that checks a set of characters, keys, kinds or values (for example the CR/LF and NUL checks on the decoded prompt and description, the key set, the `requires` kinds `skill/` and `agent/`, the `commands/<name>.toml` source-path rule) and make sure each member has its own test that a one-member mutant would fail. Prove it with one `-overlay` mutant per member, each killed by its intended test; list them.

**R2-2 (nit, introduced): review 1's F4 class is closed for `/ship` only.** The `prompt/constraints` review note (`internal/library/curation/curation.json:587`) says that in Cursor "the no-argument default applies", while `internal/library/content/items/prompt/constraints/example.md:1` promises `/constraints check, guard and ratchet` in "Claude Code or Cursor"; neither is verified and they contradict each other. **Close the class (per the plan's R2-2 ruling):** read all 9 prompts' review notes and `example.md` files against their bodies, and correct every claim that goes beyond what the body says or what this story verified (for instance how a tool passes arguments or sub-commands). If an `example.md` changes, re-record that item's lock line the way fixer 1 did for `prompt/ship` (delete the line, `go test ./internal/library -run TestContentLock -update-lock`; these versions are not on main), and keep every AC test and the AC5 folder test green.

**R2-3 (nit, introduced by fix 1): README accuracy.** The Verification list (`internal/library/README.md:540-542`) omits `TestTransformAcceptsACommandDescriptionAtTheLimit` (plan B11: every added test by name). Add it, and every test you add in this pass. `README.md:276` says the prompt "must use LF line endings", yet an escaped lone CR is accepted (fixer 1's accepted ruling); reword to what the code does (no CR LF, no NUL). Check the rest of the README section this story added for any other claim the code no longer matches.

**Behaviour boundary:** these findings need tests, notes, examples and README text, not new product behaviour. If you find a fix really needs a source behaviour change, make it test-first, and say so explicitly in `behaviour_changed: true` with the reason: the main session then sends it to a fresh reviewer before the verifier.

## Notes for this pass

- Reviewer 2 accepted all five of fixer 1's rulings. It also noted that any database that loaded `78f13a7` (the builder's `leorna_86bcm901b_demo_test`) will refuse later heads at startup with `ErrChangedWithoutVersionBump` for `prompt/ship@1.0.0`, and re-capturing AC1 on a fresh database is the finisher's job. Leave the builder's databases alone.
- GitHub `main` was still `1ee7157` at about 20:27Z.

## Gates and evidence

- After the fixes, run the full gates on your final head exactly as before (`evidence/86bcm901b/builder-tools/gates.sh`, `INVENTORY.md`: `make -s check` with the `GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bindings and no cached tests, `scripts/test-module-add.sh`, the `go test -json -run WithPostgres` per-test read, the stories unittest, branch gitleaks, no `.github` change, clean tree), the two network tests, and the four AC tests on the final head. The worktree must end clean.
- Write your logs to `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/fix-2/` (`gates-<sha7>.txt`, `ac-<sha7>.log`, `mutations-fix2-<sha7>.txt`, probe logs). Keep your probe and mutant source files there too (under `fix-2/tools/`), so the verifier can re-run them. Don't edit other roles' files, and never write in `verifier/` or `auditor/`. Screenshot refresh is the finisher's job.
- **Environment:** `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. PostgreSQL 18.6 on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`); use databases named `leorna_86bcm901b_fix2_*_test` and drop any you create. Never print the password or a DB URL. Never touch any sibling story's database.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep` in gate scripts.

## Boundaries

- Commits `fix(86bcm901b): …`, `test(86bcm901b): …` or `docs(86bcm901b): …`. Let git use the repo identity (`Justin Issa <justin@leorna.com>`); never `-c user.*`, `--author` or AI attribution lines. Never commit a `CLAUDE.md`.
- Never push, open a PR, merge or write to ClickUp. Don't touch the main checkout at `~/Leorna/leorna-control-plane` or any sibling story's worktree, branch, database or evidence (86bcm901a, 86bcm901j, 86bcm901w). No hand-over work.
- Scratch: `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-fixer-2/`, created fresh with `mkdir` (no `-p`); never touch other folders there; remove yours at the end.
- You can't ask Justin anything and can't start other agents. A real trade-off: make the ruling, write "My ruling, not yet confirmed" in `rulings[]` and in your own section of `evidence/86bcm901b/INVENTORY.md`. A fix needing a design change outside the plan: stop with `status: stopped` and the options.
- Don't write a report file (Claude Code refuses report files from subagents): return the report as your final message.
- Other bugs: `found_else`. Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{status: ready-for-verify|stopped, summary, reviewed_head, new_head, behaviour_changed, commits[], dispositions[{id, verdict: fixed|pushback, test, evidence}], class_sweep[{guard, members, mutants_killed}], gates[{name, exit}], ac_logs[{ac, log, result}], mutations[], rulings[], stop_reason, found_else[], skill_lessons[]}`. `status` and `summary` are required.
