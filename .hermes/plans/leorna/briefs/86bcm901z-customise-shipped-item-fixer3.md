
# FIXER 3 — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: the fixer after review 3 (`review-fix-cadence`: review 3 → **you** → review 4, a fresh review of the fix commits since `08c09b8` → … until the referee says MOVE ON → verifier → blind auditor). Verify the P2 finding below, fix it the way Justin chose, test-first, commit, and stop at `ready-for-next-review`. No release, no hand-over, no rebase and no bringing `main` in (the finisher does that at the end).

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`, base `b65f797ff6cdc56a802dfaf417b0adec96463317`. Reviewed head **`08c09b883b1817adf9ae773b7afcf697397b03f2`**: confirm the worktree is at that head and clean before you start.
- Approved plan (read-only, never edit): `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md`. Working plan: `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`; its section "Justin's answers after review 2" records the item-editor fold-in and his ruling-3 choice below.
- Review 3's evidence: `~/.hermes/plans/leorna/evidence/86bcm901z/review-3/` (`review.json`, `probe-item-editor-3trees.log` and its probe). Reuse the reviewer's probe to prove the fix; copy what you need, don't edit that folder.
- Earlier rounds: `review-1/`, `fix-1/`, `review-2/` (with `justin.json`), `fix-2/` (dispositions, `mutations-08c09b8.txt`, `probe-empty-file-08c09b8.log`), `review-3/justin.json`. `INVENTORY.md` has the builder's, fixer 1's and fixer 2's sections.

## Skills (load them first with the Skill tool and say so)
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `git-commit-rules`.

## The finding to fix (referee output, verbatim)
```
R3-1  P2  internal/web/pack_versions.go:230 (also item_create.go:198-199)  A secret refusal in the item editor now clears every supporting file's text. The paths stay, and the file text boxes have no required attribute (description and main body do). So resubmitting the refused form after re-entering the two required fields saves every supporting file with 0 bytes: the save returns 303 with no warning. Before 08c09b8, a token in the main body or description left clean files untouched.
```
Reviewer's scenario: an admin edits a skill that has supporting files and pastes an API token into the main body by mistake. They get the 422, re-type the emptied description and main body, and save. The new pack version stores every supporting file empty, and teams assigned that version sync empty files.
Reviewer's evidence: `review-3/probe-item-editor-3trees.log`: on `b65f797` and `b534978` the resubmit saves the files at 40/48 bytes; on `08c09b8` it saves `{checklist:0, guide:0}`. No tree showed the token.
Note the referee line's path: the reviewer's text says `pack_versions.go:230`; check where the file boxes are actually rendered for create and edit, and fix every place.

## Justin's decision (2026-10-29, fixer 2's ruling 3, which is exactly R3-1)
Justin's words: "Mark cleared file boxes required (Recommended)".
- A supporting-file text box that a secret refusal emptied gets the `required` attribute, so the browser won't send the form with it empty. This applies wherever the refusal clears file text: the item editor's create and edit modes, and the variant pages if they render any file text box (Q4 A says a variant's supporting files follow upstream and are read-only, so check, and say so).
- Clearing stays as fixer 2 built it: no part of a suspected secret is ever shown back, whichever field holds it.
- **Done means:** after a secret refusal, the admin can't resubmit the page with a cleared file box left empty from the browser, and no token is shown back. Boxes that were not cleared keep their current behaviour.

## How to work
- Verify R3-1 first (`receiving-code-review`): reproduce it with the reviewer's probe on `08c09b8`. If it doesn't reproduce, push back with evidence and stop.
- Then failing tests: after a secret refusal with supporting files, every cleared file text box on the 422 page carries `required` (match the markup of that element, not a whole-page substring, so CSS can't satisfy it); a page with no refusal renders the file boxes as before (no new `required`); the token is still absent from the page. Cover create and edit modes. Then fix.
- A server-side check is not required by Justin's choice. If you judge one necessary (the `required` attribute is a browser guard only), write it as "My ruling, not yet confirmed" with the reason, and keep it small; don't redesign.
- Prove the fix with mutation (`mutation-testing-discipline`): "drop `required` from cleared file boxes" in each mode must be killed by your new tests. Re-run the earlier mutant sets (builder M1–M18, fixer 1 F1–F6, fixer 2's N2-v2, R1–R5, IE1–IE8) on the new head and record the results.
- Update any README text that describes the refusal behaviour so docs and code agree.
- Commits: `fix(86bcm901z): …`, by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.
- The P3 findings (R1-2, R1-3, R2-2, R3-2 a token typed as a file path is shown back) are **not** part of this fix. Don't change them.

## Gates and evidence
- Re-run on the final head: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB `leorna_86bcm901z_fix3_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on PATH (`/usr/local/bin/gitleaks`, and `LEORNA_TEST_GITLEAKS_BIN`) and over the story range, each AC test by name, and the `go test -json` check that the Postgres tests really ran.
- Evidence: per-head logs `gates-<sha7>.txt` and `ac<n>-<sha7>.log` in `~/.hermes/plans/leorna/evidence/86bcm901z/`, plus your dispositions and probes in `~/.hermes/plans/leorna/evidence/86bcm901z/fix-3/` (create it; `dispositions.md` with R3-1's verdict, test, commit and evidence, and `mutations-<sha7>.txt`). Fixture tokens must be fake; tests and probes print byte counts or booleans, never a token; gitleaks-scan your folder before handing back. Never write in `review-*`, `fix-1/`, `fix-2/`, `verifier/` or `auditor/`, and never touch `plan-approved.md`. If an AC test's subtests change, re-render that AC's terminal screenshot from the new head's log with the builder's recipe and look at it yourself. Update `INVENTORY.md` (AC map, rulings, which head each file comes from).
- Scratch: a fresh `<scratchpad>/86bcm901z-fix3/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles and mutation copies in `~/.cache/86bcm901z-fix3/`. Mutation copies are detached worktrees removed with `git worktree remove --force` on their exact path. **Never run `git worktree prune`.** Remove only your own folders, by literal absolute path, and drop your DB at the end. Leave the worktree committed and clean.
- Never touch other stories' worktrees, branches, DBs or evidence (another session is running 86bcm902w on the same repo).
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.
- You can't ask Justin anything. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and INVENTORY.md. If the fix would need a design change beyond Justin's choice, stop with `status: stopped` and list the options.

## Rules for every role
- If you find any other bug or problem outside this finding, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-next-review|stopped, summary, reviewed_head, new_head, dispositions[{id, verdict: fixed|pushed-back, test, commit, evidence}], rulings[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], mutations{killed[], survived[], not_run[]}, shots[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
