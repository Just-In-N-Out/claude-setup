# harness-guards: follow-ups found, deliberately left out of scope

Reviewer 1 listed these, 2026-10-28. All are P3 and outside the approved plan's rules. Offer them to Justin as one follow-up story after the finish step.

## FIRST after the merge: story `review-loop` (Justin, 2026-10-28)
- **Goal:** review → fix loops until a fresh review finds no P0–P2 bug (realistic edge cases count) and every AC passes, with brakes (real-use scenario required, later reviews on the new fixes only, stop and ask if a round finds no fewer serious bugs). No more stopping at two reviews.
- **Rule text:** write the rule into CLAUDE.md, feature-dispatch (Full and Mini), `review-fix-cadence` and `ac-verification.md`. Codex picks it up through the generated AGENTS.md.
- **Check:** `ac-check.sh` refuses a head with commits since the last clean review.
- **Round referee (Justin, 2026-10-28):** a script, a review-round version of `ac-check.sh`. It reads each reviewer's structured findings (severity, real-use scenario, finding id) and prints one answer: REVIEW AGAIN (the P0–P2 list to fix), MOVE ON (clean, so the verifier runs next) or ASK JUSTIN. It applies the brakes:
  - a finding with no scenario counts as P3;
  - a round with no fewer P0–P2 than the last → ask;
  - the same finding twice with no new fact → ask.
- **Not planned (Justin passed on it, 2026-10-28):** a runner that resumes the loop by itself, a per-story budget, receipts. Don't build these unless he asks.
- **Until then:** the memory note `~/.claude/projects/-home-justin/memory/review-loop-until-clean.md` holds the rule, but only for sessions in `~/`.

- **Codex:** wire `git-guard.sh` into Codex (plan Q4). Codex's PreToolUse can deny but can't ask.
- **More git-guard rules:**
  - deny `url.*.insteadOf`/`pushInsteadOf` writes and `-c`;
  - scan inline `-c remote.<n>.url=`/`pushurl=` for LeornaAI URLs (Leorna ask);
  - deny `-c include.path=` and `includeIf.*.path` (they can load `core.hooksPath=/dev/null`);
  - deny alias definitions that contain `--no-verify`;
  - strip the `xargs`/`nice`/`stdbuf`/`sudo`/`coproc` wrappers;
  - catch `git remote remove` followed by `remote add` (a URL change in two steps);
  - cover `gh auth login/logout/refresh`.
- **Gaps the guard can't fully close:**
  - `git filter-branch --env-filter` / `filter-repo` rewrite authors without running any hook;
  - `g''it` and `g\it` skip the pre-filter;
  - variables aren't resolved (`W=~/Leorna/x; git -C "$W" push`).
- **Unknown:** something created empty `.git` folders in `~/.claude` and `~/.hermes` at 09:37 on 2026-10-28.
- **Bash writes** (`sed -i`, heredoc, `tee`) get around the orchestrator guard (plan Q3, accepted for now).

Added from fixer 1, 2026-10-28:
- **Mac check (AC22):**
  - **Problem:** if `~/Leorna` is a link there, git's own `includeIf "gitdir:~/Leorna/"` misses the physical path. pre-commit then refuses those commits.
  - **Fix:** add a second `includeIf` for the real path to `~/.gitconfig` on that machine.
- **Doc conflict:** `.hermes/skills/autonomous-ai-agents/hermes-agent/references/skill-libraries.md` step 1 clones with the inline gh credential helper and writes it into `.git/config`. git-guard now denies both under Claude Code.
- **F8 cut and git language:** the F8 cut relies on git's English cut text. Under a non-English git, `commit -v` could be refused in a rare case.
- **Heredoc gaps:**
  - `sudo bash <<EOF` and `ssh host bash <<EOF` heredocs are read as data;
  - a partly quoted delimiter like `E"OF"` is misread.

Added from reviewer 2, 2026-10-28:
- **Leorna PRs:** `gh pr create` / `gh pr merge` in Leorna repos are neither asked nor denied. The Leorna rule is "PR only when Justin says, never merge".
- **commentChar:** with a non-`#` `core.commentChar`, commit-msg falsely refuses a `commit -v` whose diff shows an AI co-author line.
- **git-lfs (Mac check):** under a global `core.hooksPath`, `git lfs install` writes into the synced `~/.claude/githooks`. Its `--force` would replace the wrappers on both machines. Check whether git-lfs is installed on the Mac.
- **Local bare remotes:** they lose their own server hooks (pre-receive, update, post-receive) under the global hooks path. None exist on the desktop.
- **`env -S '…'`:** this wrapper form joins the wrappers item above.

Added from fixer 2, 2026-10-28:
- **pushd/popd:** the directory stack isn't modelled. `cd ~/Leorna/x; pushd /tmp; popd; git push` misses the Leorna ask.
- **Older git:** git-guard's `git config` option tables follow git 2.53. On git older than 2.30, `--fi` means `--file` and stays unexpanded.

Added from fixer 4, 2026-10-28:
- **`TMPDIR=` bypass:** `TMPDIR=<a folder holding real repos> git commit` skips the hook checks (the same class as `HOME=`). Possible fix: git-guard asks on a `TMPDIR=` prefix to `git commit`.

Added from reviewer 3 (clean review at e4469c0), 2026-10-28. All P3:
- **Deep nesting:** about 700 nested `$(` makes git-guard hit a RecursionError and fail open silently. It should print a systemMessage or deny on an exception (git-guard.sh:974-977).
- **stdin scripts:** `bash -` and `bash /dev/stdin` aren't read as stdin scripts (`shell_stdin`, git-guard.sh:430-447).
- **Test gap:** the STDIN_FILES members `-`, `/dev/fd/0` and `/proc/self/fd/0` aren't pinned by a test (mutant F4d survived).
- **Lessons gate:** an odd quote character before a real structured list hides it (subagent-lessons-gate.sh:47-52). 0 of 120 real reports are affected.
- **`git rebase --apply`:** it replays through `git am`, so applypatch-msg/pre-applypatch can stop it on a teammate's Copilot trailer or a tracked CLAUDE.md. The default rebase backend is fine.
- **Deny message:** a split value-taking option before the fallback URL (`fetch --depth 1 <url>`) gets a generic deny reason. It should say to use `--opt=value` or put the option after the URL.
- **Docs disagree:** CLAUDE.md:54 and leorna SKILL.md:133 say "never in a shell variable", while `pr-workflow.md` uses `LeornaAI/$REPO.git`, which the guard allows. Reword one side.
- **Temp worktrees:** the system-temp skip lets through a worktree of a real repo placed in `/tmp`. Apply the same common-dir test as the `$TMPDIR` rule (known item 1).
- **Leorna `ls-remote` / `clone`:** the Leorna fallback on these is now denied (AC5 as approved). Leorna sessions used them 4 times. Allow read-only `ls-remote` under the strict URL check; `fetch` works meanwhile.

Added from the blind auditor (clean at e4469c0), 2026-10-28. Both P3:
- **AC6 test gap:** the `github-leorna` alias clause is never tested on its own (mutant A6c survives). Add `git push git@github-leorna:OtherOrg/x.git main` from a non-Leorna folder.
- **orchestrator-guard `..` paths:** a path with `..` through a folder that doesn't exist yet is judged by its text (`~/.hermes/plans/nx/../../../code/app/new.go` gets no prompt). It only matters if Claude Code passes such a path un-normalized.

Added from verifier 3, 2026-10-28:
- **Agent probes after go-live:** once git-guard is on, agents' inline git-hook probes (`git -c core.hooksPath=/dev/null …`, `git config --global credential.helper` with `GIT_CONFIG_GLOBAL` pointing at scratch) get denied. Briefs for agents that probe git hooks should say so: probe through a script file in a temp `HOME`.

Added from blind auditor 2 (clean at 6b57a5b, 2026-10-28). All P3:
- **Clones in `$TMPDIR`:** a clone inside an agent's `$TMPDIR` is scratch, so a commit there with an AI trailer or wrong email passes, and the real repo could take it through `fetch` + `merge --ff-only`, which runs no commit hooks. The same exposure exists for `/tmp` clones under Q8. Fix 4's ⭐ option A widened the skip to `$TMPDIR` under Justin's "go with recommended"; tell Justin.
- **AC7 test gap:** no case trips two rules at once, so a one-JSON-per-rule mutant survives (GG8).
- **`--no-verify` in arguments:** `--no-verify` anywhere in git's arguments is denied, so `git grep -- --no-verify` and `git tag -m '--no-verify'` are refused. Plain `grep` works.
- **More bypasses:** `git config --global include.path`/`url.*.insteadOf` writes, `GIT_DIR=<Leorna repo> git push` from outside `~/Leorna`, and `ssh://git@github-leorna/...` push forms aren't caught.
- **Clean cherry-pick:** a clean `git cherry-pick` of a commit with an AI trailer keeps the trailer, because git runs no commit-msg hook there.
- **AC21's smoke folder:** if the session running it has `TMPDIR=~/.cache`, that repo counts as scratch and the check fails. Run AC21 with `TMPDIR` unset.
