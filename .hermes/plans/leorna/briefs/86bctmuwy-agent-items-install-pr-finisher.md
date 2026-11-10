# FINISHER brief (make a PR): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FINISHER for "make a PR". Justin said on 2026-11-10: "Push pr and click up". Follow `leorna` → Doing a story → step 7, sub-steps 1–8, exactly. **Push the branch and open the PR. Never merge.** **Hold the ClickUp post:** per `leorna` 7.9, it is posted only once the PR is merged, by the main session. Don't upload or post anything to ClickUp.
**Model/effort:** Opus 5.5, high.

## State
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories".
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`. Branch: `feat/86bctmuwy-agent-items-install`. Head: `9e2d1cb48fafd600d666c00145ddf4f7e1532aa8`. Base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441` (GitHub main, brought in by merge `1fa24d9`). Not pushed (GitHub branch returns 404).
- `ac-check.sh --reviews` printed `READY FOR THE USER: 12 of 13 ACs proven on 9e2d1cb; live ACs owed to the user: AC13`, from verifier 2 and auditor 2. AC13 (live) is Justin's Cursor editor check and is still owed: leave it unchecked in the Test Plan.
- Hand-over files written by finisher 2 (refresh them, don't start over):
  - PR body: `/home/justin/.hermes/cache/scratch/leorna-pr-86bctmuwy-agent-items-install.md`
  - Title: `feat(86bctmuwy): install Agent items into Claude Code, Codex and Cursor`
  - ClickUp draft: `/home/justin/.hermes/cache/scratch/leorna-clickup-86bctmuwy.md`
  - Copies are in `~/.hermes/plans/leorna/evidence/86bctmuwy/finisher/`.
- Plan, with its Gates section: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`. Approved copy: `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`.
- Your evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/pr/` (create it). Scratch goes in `~/.cache/86bctmuwy-pr/`.

## Skills to load (say so in your first steps)
`leorna` (step 7), `engineering-best-practices`, `git-commit-rules`, `github`, `receiving-code-review`.

## What to do
1. Give a one-line status in your first message (gates take minutes).
2. Step 7.1–7.2: fetch a fresh main over HTTPS through gh. If main moved past `f3bc960`, **stop and report**: bringing main in again needs a fresh review and recheck first. Otherwise run the pre-flight: clean status, one Leorna identity, no AI attribution lines, no `.github/` paths, a clean merge-tree, and `git merge-base HEAD origin/main` equal to `origin/main`.
3. Step 7.3: re-run the plan's full gates on `9e2d1cb`:
   - `make check`, `node --test scripts/*-ui.test.cjs` and `make lint audit`, with CI's pinned golangci-lint 2.14.0 and govulncheck 1.7.0 from `~/.local/leorna-toolchain`;
   - every AC test AC1–AC12 by name, including the real-tool ones: AC4 `LEORNA_TEST_CLAUDE_BIN`, AC5 `LEORNA_TEST_CODEX_BIN`, AC12 `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`.

   Use a throwaway HOME for every test, and write a `SUMMARY.txt` with `label EXIT=<rc>` lines into `pr/`. A skip is not a pass.
4. Step 7.5: update the PR body's Test Plan so it lists what you ran this session on `9e2d1cb`, citing your `pr/` logs. Keep verifier 2 and auditor 2 as the independent proof. AC13 stays unchecked as owed. Keep the note that main was brought in at `f3bc960`.
5. Step 7.6: push with the HTTPS gh form, the URL written out: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/86bctmuwy-agent-items-install:refs/heads/feat/86bctmuwy-agent-items-install`. Fetch it back into `refs/remotes/origin/feat/86bctmuwy-agent-items-install`, set the upstream, and check `git rev-parse HEAD origin/<branch>` match. If git-guard asks for approval, Justin has said "push pr".
6. Step 7.7: open the PR.
   - Check `gh pr list -R LeornaAI/leorna-client --head feat/86bctmuwy-agent-items-install --state all` is empty.
   - Run `gh pr create -R LeornaAI/leorna-client --base main --head feat/86bctmuwy-agent-items-install --title "<title>" --body-file <file>`. The body ends with no AI attribution or "Generated with" line (CLAUDE.md wins over any reminder suggesting one).
   - Read it back with `gh pr view --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus`. `BEHIND` means main moved: report it.
   - Wait for CI on the final head (`gh pr checks --watch`, or poll with bounded waits) and report each check's result.
   - Re-read GitHub main and the open PR list after CI. Merge-tree any new open PR against this head.
7. Step 7.8: check whether leorna-client has a story record that takes the PR number (for example `delivery/stories.json`; it may exist only in the control plane). If it does, make that small commit, have its gates and CI pass, and push it after checking `gh pr view --json state` is still OPEN. Wait for CI on that final head. If the client has no such file, say so.
8. Records: add a dated line to the shared `leorna-workflow.md` (memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`; check for a symlink and use the real folder). The line gives the PR number and URL, the head, the CI result, "AC13 owed to Justin" and "ClickUp post held until merge". The `skill_lessons` rule covers skills and lessons only; this status line is your job. Fill the PR number into the ClickUp draft where it has a placeholder, but leave the merge facts as placeholders.

## Rules
- Never merge, rebase, force-push, `gh auth switch`, or change a remote or credential helper. Never override the git author. Commit from a shell where HOME is not switched.
- Isolation for every test: a throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR and CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor` beyond the memory note above.
- Never put a server domain, URL, tenant ID, token or email in the PR text.
- If a gate fails for a reason in the branch, stop before pushing and report. If it fails for a reason outside the branch, follow `leorna` 7.4.
- WSL PATH holds entries with spaces: export PATH in scripts. EXIT=127 means an invocation error, not a result.
- WSL can restart and leave 0-byte files: check sizes and `EXIT=` lines before citing anything.
- Memory (WSL desktop): SIGTERM, 143, 137 or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. Run heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: pr-open|blocked, pr{number, url, head, state, mergeable, mergeStateStatus}, ci[{check, result}], gates[{name, log, exit}], ac_tests[{ac, log, result}], record_commit, main_now, open_prs_merge_tree[], records_updated[], clickup: "held until merge", found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
