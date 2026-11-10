# FINISHER: dream-trim (claude-setup), Mini pipeline: land pass 1 only

Role: FINISHER. The story passed its review loop, the verifier, the blind auditor and `ac-check.sh` (`READY FOR THE USER: 8 of 9 ACs proven on 2bc4495; live ACs owed to the user: AC9`). Your job is the plan's landing step for **pass 1 only**. You fix nothing and decide nothing: if `land.sh` stops for any reason other than "main moved", report its output and stop.

- Approved plan (read-only): `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` (Task 6 is the landing; "Justin's answers" Q1 (a): a pass 1 made again on the newest `main` may land without a second verifier and auditor round when the reviewed tool and map are unchanged and the lossless check and the pins pass; `land.sh` checks exactly that).
- Worktree: `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`), head `2bc4495d583d8b08e4d878f160084f6dcbee259a`.
- **Land this commit:** `41bcb24e751161a035dbd5c51308f9473d5200ad` (everything except pass 2).
- **Never land `2bc4495d` (pass 2).** It waits for Justin to read its diff and say "land pass 2" (AC9, live).

## Skills (Skill tool), one line each
`engineering-best-practices`, `git-commit-rules`.

## Steps
1. Confirm the worktree's HEAD is the head above and `git -C <worktree> status --porcelain --untracked-files=all` is empty. If not, stop and report.
2. Read the header comment of `<worktree>/.claude/setup/trim/land.sh` (usage, exit codes).
3. `~/.claude/setup/sync.sh pull`, so every session's edits are on `main`. On `CONFLICT` or any failure, stop and report its output.
4. From the worktree, a dry run first: `bash .claude/setup/trim/land.sh 41bcb24e751161a035dbd5c51308f9473d5200ad --map .claude/setup/trim/maps/dream-trim.json --dry-run`. It runs the three existing suites, which takes several minutes. If it does not pass, stop and report.
5. The real landing: the same command without `--dry-run`.
   - Exit 3 (`main` moved during the checks): run it again. Other sessions sync every few minutes, so this can take several tries; try up to 6 times, then stop and report.
   - Exit 1 because a touched live file has an uncommitted change or a project `CLAUDE.md` differs from its copy (another session is mid-edit): run `~/.claude/setup/sync.sh pull` once and try again, up to 3 times, then stop and report which file.
   - Any other stop (a failed check, a conflict, a size over target, usage): do not work around it. Report the output verbatim.
6. After exit 0, check and report, without changing anything:
   - `git --git-dir="$HOME/.claude-setup.git" log --oneline -12 main` (the trim commits on top);
   - the character counts (Python `len()` of the text) of the four live files against their targets: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ≤ 56,000; `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` ≤ 75,000; `~/.hermes/skills/software-development/leorna/SKILL.md` ≤ 52,000; `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` ≤ 56,000;
   - `cmp ~/.claude/project-docs/figma-to-bricks/CLAUDE.md ~/Documents/FigmaToBricksV2/CLAUDE.md`;
   - that no `setup-sync.lock` is left in `~/.claude-setup.git/`;
   - that `~/.hermes/skills-library` still has zero local commits (`git -C ~/.hermes/skills-library rev-list --count origin/main..HEAD`).
7. Stop there. **Do not run `sync.sh` to push**: the main session does that and the final check.

## Hard rules
- Never stash, reset, force, rebase by hand, or edit a live file yourself. Never delete another session's lock. Never touch `~/Leorna/` or push anything.
- Never commit in the worktree or change the branch.
- `land.sh` holds `sync.sh`'s lock for a few seconds at the end; that is expected.
- Memory: run nothing heavy outside `land.sh`. If a command dies with SIGTERM, exit 143 or 137, or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading it as a result, and say so in the report.
- A foreground Bash command is moved to the background after about 180 s: start `land.sh` with its output going to a log file under `~/.cache/dream-trim-finisher-1/` (`mkdir` it first, without `-p`), then wait with repeated polls of under 3 minutes each (`timeout 165 tail --pid=<pid> -f /dev/null`, Bash `timeout` set above the bound), and read the exit code from a line the wrapper writes at the end. Don't end your turn while it runs.
- In the Bash tool `grep` is ugrep: use `command grep`.

## Report
Return `{status: landed|stopped, main_before, main_after, tries, dry_run: pass|fail, land_output_tail, sizes{file: chars}, project_file_equals_copy, lock_left, library_clone_commits, stop_reason, found_else[], skill_lessons[]}` in plain words.
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file yourself. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
