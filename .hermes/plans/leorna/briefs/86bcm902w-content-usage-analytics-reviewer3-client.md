
# REVIEWER 3 (review only, delta) — leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: round 3 of the review loop for the **client**: a **delta** review of the fix commits since review 2's clean client head. You are a fresh agent: you never saw the build, the earlier reviews or the fixes. Report only: change no source. Mechanics: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records"); severity scale: `review-fix-cadence`.

## What to review
- Worktree `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics` = **client PR #23** (open). Confirm the head is **`cf3df7f8cb2af1a6d0a2ef42a6e08b1387ca7f20`** (= `gh pr view 23 -R LeornaAI/leorna-client --json headRefOid`) and the worktree is clean. Base `f105e27814b6efbec67059687963e722933acec2` (= client `main`).
- Previous clean client review: review 2 at **`db3e6b0f76652088c11fafa8c3c54509f62116f7`** (full, from `f105e27`). The delta `db3e6b0..cf3df7f` is two test-only commits in `application/managed_items_test.go`:
  - `e6ce1f8`: the two tests that failed CI's "Windows client executable" job (run 40968292489: `TestManagedItemsFromLastSuccessfulSync`, `TestOpenReadOnlyNeverMigrates`) now compare against the resolved project folder, and the read-only app closes in `t.Cleanup`;
  - `cf3df7f`: new `TestStoredClaudeRootMatchesTranscriptFolderForms`, so the Windows job checks that a stored Claude Code root matches transcript folder spellings.
- **Scope:** these commits and what they touch. In particular: is the root cause right (on windows-latest `t.TempDir()` is the 8.3 short path while stored roots come back long through `filepath.EvalSymlinks`), are the tests now portable without weakening what they assert, and does the fixer's ruling of **no product change** hold, i.e. could a real Windows user's stored root and a transcript `cwd` still differ (8.3 form, case, slashes, trailing separator) so `usage/items_claudecode.go` `sameFolder` or `ManagedItems` miscounts? Anything else is P3.
- The fixer's records (claims to check, not facts): `~/.hermes/plans/leorna/evidence/86bcm902w/client/fix-2/` (`dispositions.md`, `SUMMARY.txt`, gate logs, RED/GREEN/mutant logs, the Windows-host `sameFolder` probe and its mutant). CI run on `cf3df7f`: https://github.com/LeornaAI/leorna-client/actions/runs/40973788926 (read it yourself with `gh run view … -R LeornaAI/leorna-client`).
- Earlier client rounds: `~/.hermes/plans/leorna/evidence/86bcm902w/client/review-1/review.json`, `client/review-2/review.json`; follow-ups in `…/86bcm902w/follow-ups.md` (review 2's R2-2, the untested symlink fallback in `sameFolder`, is what `cf3df7f` now covers in the Windows job). A finding that is the same defect as an earlier one sets `repeats` (with `new_fact` when you have one).
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md` (task T9).

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence`, `mutation-testing-discipline`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Gates you run yourself (on `cf3df7f`)
`make check` with a real, non-symlinked `TMPDIR`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint 2.14.0 first on PATH (echo its version), the story's client tests by name, the Windows job's packages (`go test -mod=vendor -count=1 ./application ./login ./toolconnector/...`) once with a real `TMPDIR` and once with `TMPDIR` set to a symlink to a real folder, and both `cmp` checks against the control-plane PR's files read with `git -C /home/justin/Leorna/leorna-control-plane show <cp head>:<path>` (golden upload body; OpenAPI spec). Use mutations (in your own detached copy) where a claim rests on a test.

## Your record (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm902w/client/review-3/review.json`: `"round": 3, "scope": "delta", "from": "db3e6b0f76652088c11fafa8c3c54509f62116f7", "head": "cf3df7f8cb2af1a6d0a2ef42a6e08b1387ca7f20"`, ids `R3C-<k>`, every P0–P2 with a concrete real-use `scenario` of 5+ words (an empty list when clean).
- Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics --base f105e27814b6efbec67059687963e722933acec2 ~/.hermes/plans/leorna/evidence/86bcm902w/client`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in the worktree or on GitHub: no edits, commits, pushes, PR edits, merges or ClickUp writes. Mutations only in your own detached copies (`git -C <worktree> worktree add --detach ~/.cache/86bcm902w-review3c/<name> <sha>`), each removed with `git worktree remove --force` on its exact path. **Never run `git worktree prune`.**
- Write only in `~/.hermes/plans/leorna/evidence/86bcm902w/client/review-3/` (create it) and your own scratch: a fresh `<scratchpad>/86bcm902w-review3c/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries and copies in `~/.cache/86bcm902w-review3c/` (`/tmp` is a small shared RAM tmpfs). Remove only your own folders by literal absolute path.
- The control-plane worktree is being fixed by another agent right now: read it only through `git show` of committed files; never touch it.
- Never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor`. Never touch other stories' worktrees, branches, DBs or evidence.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem outside this scope, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: P0|P1|P2|P3, file_line, claim, scenario, repeats, new_fact, evidence, suggested_fix}], root_cause_holds: true|false, no_product_change_holds: true|false, gates[{gate, exit, log}], review_json, self_check, found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
