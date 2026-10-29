
# FIXER 1 — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: the fixer after review 1 (`review-fix-cadence`: review 1 → **you** → review 2, a full fresh review of the whole story → … until the referee says MOVE ON → verifier → blind auditor). Verify the P2 finding below, fix it test-first, commit, and stop at `ready-for-next-review`. No release, no hand-over, no rebase and no bringing `main` in (the finisher does that at the end).

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`, base `b65f797ff6cdc56a802dfaf417b0adec96463317`. Reviewed head **`99382cc5a12b46aa7a682ef65e4262d68ee89bf4`**: confirm the worktree is at that head and clean before you start.
- Approved plan (read-only, never edit): `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md`. Justin approved every ⭐ answer, including Q2 A: "lines only the company changed and lines only upstream changed are both kept"; only lines both changed are conflicts.
- Review 1's evidence: `~/.hermes/plans/leorna/evidence/86bcm901z/review-1/` (`review.json`, `probe-agent-merge.log` and the overlay probe in `probes/`). Reuse the reviewer's probe to prove the fix; copy what you need, don't edit that folder.
- The builder's records: `~/.hermes/plans/leorna/evidence/86bcm901z/INVENTORY.md` (with "Builder rulings"), `mutations-99382cc.txt`.

## Skills (load them first with the Skill tool and say so)
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.

## The finding to fix (referee output, verbatim)
```
R1-1  P2  internal/variant/draft.go:99  An unedited agent variant can't merge an upstream description change cleanly: customise rewrites the frontmatter name line (line 2) and every shipped agent has its description line right below it (line 3), so Merge3 sees adjacent changes and reports a conflict although the company changed nothing
```
Reviewer's scenario: an admin keeps an unedited `code-reviewer-custom` variant. Leorna ships `code-reviewer` with a reworded description. Merge answers 409 with a frontmatter conflict, so the one-click merge never works for that agent variant.
Reviewer's evidence: `review-1/probe-agent-merge.log`: PreviewMerge gives body conflicts=1, with markers around `name: code-reviewer-custom` / `description: …` versus upstream's lines; a body-only upstream change merges cleanly. All 4 shipped agents have `name` on line 2 and `description` on line 3. `validateAgent` forces the frontmatter description to equal the description field. `code-reviewer`'s description already changed once (1.0.0 → 2.0.0, commit e02ab21).
Reviewer's suggested fix (a suggestion, not an order): in PreviewMerge, for an agent, merge against `renameAgent(Base.Body, v.Name)` and `renameAgent(Latest.Body, v.Name)`, falling back to the raw body; optionally do the same for the "Your changes" diff, which always shows the rename as a company edit.

## How to work
- Verify the finding first (`receiving-code-review`): reproduce it with the reviewer's probe on `99382cc`. If it doesn't reproduce, push back with evidence and stop.
- Then write a failing test: an unedited agent variant whose upstream changes only the description merges with 0 conflicts, keeps `name: <variant name>` and takes the new description line. Also cover: a company edit to the description plus an upstream description change still conflicts (both changed the same line), and an upstream body-only change still merges cleanly. Then fix. Any other automatic edit Customise makes to a variant's text needs the same check; say in your dispositions whether there is one.
- If you change what the "Your changes" diff shows, keep it consistent with the merge and say so.
- Prove the fix with mutation (`mutation-testing-discipline`): at least "merge against the raw upstream bodies again" must be killed by your new test. Re-run the builder's mutants M1–M18 on the new head and record the results.
- AC test names stay exactly as the approved plan names them; add subtests or new tests as needed.
- Commits: `fix(86bcm901z): …`, small and often, by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.
- The review-1 P3 findings (R1-2 the untested 2,000-line diff cap, R1-3 the migration renumber after PR #101 merged) are **not** part of this fix: they go to the follow-up list and the finisher. Don't change them.

## Gates and evidence
- Re-run on the final head: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB `leorna_86bcm901z_fix1_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on PATH (`/usr/local/bin/gitleaks`, and `LEORNA_TEST_GITLEAKS_BIN`) and over the story range, each AC test by name, and the `go test -json` check that the Postgres tests really ran.
- Evidence: per-head logs `gates-<sha7>.txt` and `ac<n>-<sha7>.log` in `~/.hermes/plans/leorna/evidence/86bcm901z/`, plus your dispositions and probes in `~/.hermes/plans/leorna/evidence/86bcm901z/fix-1/` (create it; `dispositions.md` with R1-1's verdict, test, commit and evidence, and `mutations-<sha7>.txt`). Never write in `review-*`, `verifier/` or `auditor/`, and never touch `plan-approved.md`. Re-capture a screenshot only if your fix changes what a captured page shows, with the builder's recipe; keep any old one only as clearly named history and look at each new image yourself (no domain, URL bar, tenant ID, token or email). Update `INVENTORY.md` (AC map, rulings, which head each file comes from).
- Scratch: a fresh `<scratchpad>/86bcm901z-fix1/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles and mutation copies in `~/.cache/86bcm901z-fix1/`. Mutation copies are detached worktrees removed with `git worktree remove --force` on their exact path. **Never run `git worktree prune`.** Remove only your own folders, by literal absolute path, and drop your DB at the end. Leave the worktree committed and clean.
- Never touch other stories' worktrees, branches, DBs or evidence (another session is running 86bcm902w on the same repo).
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).
- You can't ask Justin anything. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and INVENTORY.md. If the fix would need a design change beyond the approved plan, stop with `status: stopped` and list the options.

## Rules for every role
- If you find any other bug or problem outside this finding, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-next-review|stopped, summary, reviewed_head, new_head, dispositions[{id, verdict: fixed|pushed-back, test, commit, evidence}], rulings[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], mutations{killed[], survived[], not_run[]}, shots[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
