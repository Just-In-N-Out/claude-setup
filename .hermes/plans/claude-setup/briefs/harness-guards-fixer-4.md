# Brief: FIXER 4, story `harness-guards` (Full pipeline)

## Role
You are **fixer 4** for Justin's setup story `harness-guards`. You close two problems that fixer 3 found, test-first, in the story's worktree, then stop at `ready-for-verify`. A fresh verifier and then a blind auditor check the result.

You don't:
- start other agents, push, merge into `main`, rebase (the finisher does that), or run the real `~/.claude/setup/sync.sh`;
- install anything into the real `$HOME`: no `git config --global` changes, and no edits to the live `~/.claude`, `~/.hermes` or `~/.hermes/skills-library`.

## Skills to load (Skill tool) first
- `engineering-best-practices`
- `receiving-code-review`: verify each problem before fixing it, and push back with evidence if it is wrong.
- `test-driven-development`
- `mutation-testing-discipline`: these are guard changes, so prove each new test can fail, including a widening mutant.
- `security-best-practices`: URL handling.
- If something fails unexpectedly, use `systematic-debugging`.

## Where you work
- **Worktree:** `/home/justin/.claude-setup-wt/harness-guards`, branch `harness-guards`. Head `d82956db4171936688ff73a5f13876fd0624229a`, base `3864d61abe128113f5fd6aeda8a55b02df46377d`.
- **Before you start,** confirm HEAD is `d82956d` and that `git status --porcelain --untracked-files=all` is empty.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md` (read-only). Justin pre-approved every recommended ⭐ option. Don't change, add or rename ACs or test names; put new cases inside the existing AC test functions.
- **Commits:** plain `git commit -m "…"`, identity `Justin <issajustin04@gmail.com>`. **No `Co-Authored-By` or any AI trailer.** No author overrides.

## Problem A (P2): the LeornaAI-only fallback can be escaped with a `..` path segment
- **Where:** `.claude/hooks/git-guard.sh`, `leorna_fallback` (about line 802). It only checks that the URL starts with `https://github.com/LeornaAI/`.
- **Evidence:** `https://github.com/LeornaAI/../Just-In-N-Out/claude-setup.git` passes the check, and git squashes the dot segment. A local `http.server` logged `GET /Just-In-N-Out/claude-setup.git/info/refs` (git 2.53, curl 8.18). So from a personal repo, a fetch by that URL is allowed silently, and a push gets "ask" instead of deny. See `evidence/harness-guards/fix-3/docs-fix-variable-url-probe.log`.
- **Fix:**
  - Refuse the fallback for a URL with any `.` or `..` path segment.
  - Check whether git/curl also decode percent-encoded dots (`%2e`, `%2E`, `.%2e`) or backslashes, and refuse those too if they reach a different path.
  - Make sure the owner segment is exactly `LeornaAI`. Test for case tricks and an empty segment, e.g. `LeornaAI//`.
- **Tests:** add AC5 cases: these URLs are denied under the credential rule (not treated as the fallback), while the real fallback forms still pass.

## Problem B (P2): the temp-folder skip ignores `$TMPDIR`, so suites that commit as a fake identity are refused once the git hooks are on
- **The conflict:**
  - Agents are told (`ac-verification.md`, "Put this line in every brief") to point `TMPDIR` at `~/.cache/<story>-<role>/`, because the WSL desktop's `/tmp` is a small shared RAM tmpfs.
  - `githook.sh` skips its checks only in system temp folders (plan Q8 A: "repos in temp folders skip the checks").
  - So with `TMPDIR` under `~/.cache`, `ac-check.test.sh`'s `mktemp -d` repos commit as `t@t` and are refused. ac19's hooks-on run had 100 failures (`fix-3/gate-ac19-d82956d-TMPDIR-in-cache-env-failure.log`).
  - After activation, the same would hit any project's test suite that makes git repos in `TMPDIR` with a fake identity, such as Go tests using `t.TempDir()`.
- **Options:**
  - ⭐ **A)** `githook.sh` also treats a repo under the current `$TMPDIR` as a temp folder, alongside the system temp folders. Only when `TMPDIR` is set to an absolute path that, once resolved, is not `$HOME`, not an ancestor of `$HOME`, and not under `~/Leorna`. Add AC12 cases:
    - a repo under a `TMPDIR` in a `~/.cache` folder skips the checks but still hands over;
    - `TMPDIR=$HOME` or `TMPDIR=/` doesn't make every repo exempt;
    - `TMPDIR` pointing inside `~/Leorna` doesn't exempt Leorna repos.
  - **B)** Change only the test: ac19's hooks-on runs use `env -u TMPDIR`, and `ac-verification.md` says fake-identity suites keep `TMPDIR` under `/tmp`. This leaves the real-world problem for future agents.
- **Recommendation:** ⭐ A, unless you find evidence that it opens a real hole. Either way, make AC19 pass whether `TMPDIR` is unset, under `/tmp` or under `~/.cache`. Show all three runs.

## Done means
- **Problems A and B:** each fixed with a test that failed first, plus a killed widening mutant for each new restriction.
- **On the new head:**
  - `harness-guards.test.sh` passes offline, plain and as `PATH=/usr/bin:/bin /bin/bash`;
  - `ac19_existing_suites_pass` passes in the three `TMPDIR` setups above.
- **Clean tree:** `git status --porcelain --untracked-files=all` is clean. Don't rebase, even if `main` moved.

## Evidence
`~/.hermes/plans/claude-setup/evidence/harness-guards/fix-4/`.

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/harness-guards-fixer4/` folder. Create it fresh with `mkdir` without `-p`, and remove only that.
- `/tmp` is a shared 7.9 GB RAM tmpfs, so keep large things in `~/.cache/harness-guards-fixer4/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep` for complex patterns.
  - Never `pkill -f`: use `pgrep -f`, drop shells, then kill the rest.
  - `$!` after `setsid … &` is setsid's own PID, so wait on the real one from `pgrep -f` or a pid file.

## Output contract
- `status`: `ready-for-verify`, or `stopped` with the reason.
- `worktree`, `branch`, `base_sha`, `head_sha`.
- `fixes[{id, action, commits, test, evidence}]`, including which option you chose for B and why.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`.
  - `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
  - An empty list is the normal answer. Never edit skills or memory yourself.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
