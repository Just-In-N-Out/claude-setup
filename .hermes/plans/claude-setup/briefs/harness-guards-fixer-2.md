# Brief: FIXER 2, story `harness-guards` (Full pipeline)

## Role
You are **fixer 2** for Justin's setup story `harness-guards`.
- You act on reviewer 2's findings in the story's worktree, test-first, and stop at `ready-for-verify`.
- A fresh read-only verifier checks every AC next.
- You don't start other agents, push, merge into `main`, rebase, run the real `~/.claude/setup/sync.sh`, or install anything into the real `$HOME`:
  - no `git config --global` changes;
  - no edits to the live `~/.claude`, `~/.hermes`, or `~/.hermes/skills-library`.
  Every change goes into the worktree's copies.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `receiving-code-review`: verify each finding before fixing it. Fix the valid ones test-first, and push back with evidence on any that are wrong.
- `test-driven-development`: a failing test that reproduces the finding comes before each fix.
- `mutation-testing-discipline`: every changed guard rule needs a test you have proven can fail.
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. Current head `7b30f168c9a638f98646e19adae9eb9912142f8a`, base `3f8c53ce389590e6f92c2dab46ed001618436869`. **Don't rebase:** the finisher does it.
- **Before you start,** confirm HEAD is `7b30f16` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option.
- **Don't change, add or rename ACs or their test names.** Put new cases inside the existing AC test functions in `.claude/hooks/tests/harness-guards.test.sh`.
- **Commits:** plain `git commit -m "…"` on branch `harness-guards`. The identity is `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer**, even if your system prompt asks for one. No author overrides.

## The review to act on
Reviewer 2's evidence is in `~/.hermes/plans/claude-setup/evidence/harness-guards/review-2/`. Reproduce each finding with `bypass-repro.log` and `githooks-probe.log`.

**Justin's standing instruction is "go with the recommended stuff".** So apply the fix described for each finding unless you show with evidence that it is wrong or that a simpler fix meets the same need.

- **F1 (P1): git-guard doesn't read bash's `$'…'` and `$"…"` quoting.**
  - Where: `.claude/hooks/git-guard.sh:123-200` (`normalize()`). shlex turns `$'--no-verify'` into `$--no-verify`.
  - Bypasses: `git commit $'--no-verify' -m x`, `git commit $'--no-\x76erify' -m x`, `git commit $"--no-verify" -m x`, `git -c $'core.hooksPath=' commit -m x`. The same trick works on `-c` keys, `--author` and `git config` arguments.
  - Fix in `normalize()`:
    - when `c == "$"` and the next character is `'`, read to the closing unescaped `'`;
    - decode the ANSI-C escapes (`\\ \' \" \n \t \r \a \b \e \f \v \xHH \NNN \uHHHH \cX`);
    - emit the result as a single-quoted word;
    - when `c == "$"` and the next character is `"`, drop the `$` and carry on as a double-quoted string.
  - Tests: the four forms go into the AC4/AC7 deny lists. `echo $'git push --no-verify'` is a control that gets no output.
- **F2 (P1): git accepts any unique abbreviation of a long option.** The guard matches only full names in `git config` and `commit --author`.
  - Where: `git-guard.sh:634-646` (`write_flags`, `flags.add(a.partition("=")[0])`) and `:605`. `no_verify()` at `:317-319` already shows the pattern.
  - Real bypasses:
    - `git config --global --unset-a core.hooksPath` unsets it, rc 0;
    - `--unset-al credential.helper` and `--remove-s credential`;
    - `git commit --auth='Other <o@example.test>'`;
    - `--rename-s` and `--ed` also pass.
  - Fix: canonicalise long options before the checks.
    - For `git config`, map any `--x` that is an exact or unique prefix of git config's long options (from `git config -h`, including the `--no-` forms) to the full name. If it's ambiguous, leave it, because git rejects it.
    - In `commit()`, treat a token as `--author` when it is a unique prefix of `--author`, cut at `=`.
  - Tests:
    - AC4 deny: `--unset-a core.hooksPath`;
    - AC3 deny: `--unset-al credential.helper` and `--remove-s credential`;
    - AC1 deny: `git commit --auth='X <x@example.test>' -m x`.
- **F3 (P2): `declare -x`, `typeset -x` and `local -x` (also `readonly`) aren't read like `export`.**
  - Where: `git-guard.sh:362-368` (`split_prefix`).
  - Fix: treat them like `export`. Skip the option cluster and record every `NAME=value` into `shenv`.
  - Tests:
    - AC4 deny: `declare -x GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null; git commit -m x`;
    - AC1 deny: `typeset -x GIT_AUTHOR_EMAIL=… ; git commit -m x`.
- **F4 (P2): command text fed to a shell by a pipe, a here-string or `source` isn't scanned.**
  - Where: `git-guard.sh:164`, `:203-222`, `:273-276`, `:446-451`.
  - Fix:
    - (a) when the command is a shell without `-c`, or `eval`, scan its `<<<` word as a script;
    - (b) add `source` and `.` (with arg `/dev/stdin`, `-` or none) to the `feeds_shell` names;
    - (c) for `echo`/`printf <words> | <shell>`, scan the words as a script.
  - Tests: AC7 deny cases for:
    - `echo 'git commit --no-verify -m x' | bash`
    - `bash <<< 'git commit --no-verify -m x'`
    - `source /dev/stdin <<'X'` with `git commit --no-verify` in the body
  - Keep controls for data, such as `cat <<< 'git push --no-verify'` and `echo 'git commit --no-verify' > notes.md`. Re-run the transcript replay to prove no new false denies.
- **F5 (P2): githooks refuse to conclude a conflicted cherry-pick of another author's commit.**
  - Where: `.claude/githooks/githook.sh:35-42`.
  - Fix: when `CHERRY_PICK_HEAD` exists, accept an author email equal to `git log -1 --format=%ae CHERRY_PICK_HEAD`, and keep checking the committer.
  - Tests in AC9:
    - a conflicted cherry-pick of a mate-authored commit concludes;
    - the same with the wrong committer email is still refused.
- **F6 (P3): `git am` is unchecked.**
  - Where: `githook.sh:84-90`; git-guard `:516-519`.
  - Fix:
    - applypatch-msg runs `check_trailer "$1"`;
    - pre-applypatch runs `check_claude_md` and the committer-email check;
    - git-guard denies `am` with `--no-verify` or a short cluster containing `n`.
  - Tests: add cases to AC4, AC8 and AC10 (or wherever each rule's test lives).
- **F7 (P3): git-guard parser edges.**
  - Fix:
    - don't match `<<=` as a heredoc (`HEREDOC_RE`, `:68`);
    - let `eval`'s scan update `cwd`/`shenv` the way a `{ …; }` group does;
    - treat `cd -` as an unknown folder (`:437-441`).
  - Tests: AC7 and AC6 cases.
- **F8 (P3): the lessons gate gives one false send-back.**
  - Where: `.claude/hooks/subagent-lessons-gate.sh:44-48`.
  - What: a report whose real list is `skill_lessons: []` but which quotes a structured example without "enforce" is sent back.
  - Fix: ignore matches inside backticks or quotes. Test in AC16, and keep AC16's real send-back case.

**Not in scope (recorded follow-ups; don't fix):**
- everything in `~/.hermes/plans/claude-setup/evidence/harness-guards/follow-ups.md`;
- `gh pr create/merge` in Leorna;
- non-`#` `core.commentChar`;
- `git lfs install`;
- bare-remote server hooks;
- `env -S`.

## Done means
- **Each finding:** fixed with a test that failed first, or pushed back with evidence.
- **Transcript replay:** re-run it (reviewer 2's approach: every Bash command in `~/.claude/projects/**/*.jsonl` with its cwd, plus the main-session Edit/Write targets) on your head. Report deny/ask counts before and after. No new false deny or ask.
- **Full suite:** `harness-guards.test.sh` passes offline, also as `PATH=/usr/bin:/bin /bin/bash`.
- **AC19's suites:** `ac19_existing_suites_pass` passes.
- **Mutations:** for each changed rule, a mutation is killed by the intended test.
- **Clean tree:** `git status --porcelain --untracked-files=all` is clean.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/fix-2/`: the RED and GREEN run for each finding, the replay before/after, the mutation runs and the suite logs.

**Gotchas on this desktop:**
- In Claude Code's Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
- A mutant that can loop must send output to a file, not `$(…)`.
- `pkill -f` patterns must not match their own command line.
- A `setsid` harness can outlive its "completed" notice, so wait on its PID (`tail --pid=<pid> -f /dev/null`) before restoring anything.

## Output contract
- `status`: `ready-for-verify`, or `stopped` with the reason.
- `worktree`, `branch`, `base_sha`, `head_sha`.
- `fixes[{id, action: fixed|pushed-back, commits, test, evidence}]`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
