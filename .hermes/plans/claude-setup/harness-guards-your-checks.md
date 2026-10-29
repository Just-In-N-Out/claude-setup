# harness-guards: your two live checks (AC21, AC22)

The story is merged and pushed (local and GitHub `main` = `d794172`). The guards are on, on this desktop.

## AC21: this desktop (about 5 minutes)
Open a **new** Claude Code session in `~` (TMPDIR unset) and check:
1. `git config --global core.hooksPath` prints `~/.claude/githooks`.
2. Ask Claude: "make a scratch repo in `~/.cache/hg-live/` and run `git commit --allow-empty --no-verify -m t`". It should be **refused** with the guard's reason.
3. Ask Claude: "run `git push --dry-run` in `~/Leorna/leorna-client`". You should get a **yes/no prompt** naming the Leorna rule. Answer **No**.
4. Ask the main session to edit a file in `~/Documents/FigmaToBricksV2`. You should get the **orchestrator prompt**. Answer **No**.
5. In a terminal, in that scratch repo: `git -c user.email=x@example.test commit --allow-empty -m t`. It should be **refused** by `githooks (pre-commit)`.

The test prints the same steps: `bash ~/.claude/hooks/tests/harness-guards.test.sh ac21_desktop_live_smoke`.

## AC22: the Mac
1. `~/.claude/setup/sync.sh pull` (a new session also does it). Check `ls -l ~/.claude/githooks/` shows executable files.
2. Turn the git hooks on: `git config --global core.hooksPath '~/.claude/githooks'`.
3. A wrong-email commit in a scratch repo under `~/.cache/hg-live/` should be refused: `git -c user.email=x@example.test commit --allow-empty -m t`.
4. Scan the repos for their own hooks. This only reports; it changes nothing:
   ```
   for d in ~/Leorna/* $(awk -F'\t' '!/^#/{print $2}' ~/.claude/setup/projects.tsv); do [ -d "$d/.git" ] || [ -f "$d/.git" ] || continue; c=$(git -C "$d" rev-parse --git-common-dir); echo "$d hooksPath=[$(git -C "$d" config --local --get core.hooksPath)] own=[$(ls "$d/$c/hooks" 2>/dev/null | grep -v '\.sample$' | tr '\n' ' ')]"; done
   ```
5. In a Claude Code session, `git commit --no-verify` should be **denied**. That also proves python3 is found.
6. Extras the reviewers asked for:
   - `ls -ld ~/Leorna`. If it's a **link**, add a second `includeIf "gitdir:<real path>/"` to `~/.gitconfig`, or Leorna commits made from the real path get refused.
   - `git lfs version`. If git-lfs is installed, never run `git lfs install --force`: it would overwrite the shared hook files.

## Off switches
- **Git hooks:** `git config --global --unset core.hooksPath`.
- **Claude Code guards:** remove their two entries from `~/.claude/settings.json`.
