# Sync my Claude + Hermes setup through GitHub (Mac ⇄ Windows desktop)

## Context

Justin is setting up Claude Code on a Windows desktop and wants it to work like this Mac: the same global `CLAUDE.md`, pipeline, hooks, Hermes skills, Leorna skills, memory and plans. Right now that setup exists only on this Mac. The Leorna code (`leorna-client`, `leorna-control-plane`, `codex-skills`) and the skills library are already on GitHub under LeornaAI.

Justin's follow-up ask: **every edit to a skill or setup Markdown file is pushed to GitHub on its own, and the latest is pulled right before a plan starts**, so both machines stay in step.

Answers so far: the desktop runs Windows. It needs Claude Code only, not the Hermes agent. The repo is a private one on the personal account `Just-In-N-Out`. Extras to include: memory notes, plans and briefs, project CLAUDE.md files, and Hermes memory.

## Decisions

- **The desktop runs Claude Code inside WSL2 (Ubuntu, username `justin`), not native Windows.** The hooks, `ac-check.sh` and `update-skills-library.sh` are bash and rely on symlinks. WSL runs them unchanged, and native Windows would need every one of them rewritten. Projects live in the WSL home (`~/Leorna/...`), not under `/mnt/c`.
- **One private repo, `Just-In-N-Out/claude-setup`**, kept as a *bare repo with `$HOME` as its work tree* (`~/.claude-setup.git`). The files stay exactly where Claude Code and Hermes expect them, with no copies and no moved folders. There is no `.git` in `~`, so other repos and Claude Code don't notice it. It also sets `status.showUntrackedFiles=no`.
- **Auth:** the remote is `git@github.com:Just-In-N-Out/claude-setup.git`. The personal key `~/.ssh/id_ed25519` has no passphrase (checked), so automatic pushes need no prompt. The repo is created with `GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh repo create … --private`, so the active `gh` account is never switched. Commits use the personal identity because the repo isn't under `~/Leorna/`, and they carry no AI co-author lines.

## What goes in / what stays out

All paths are relative to `$HOME`. The list is kept in `.claude/setup/manifest.txt`; anything not on it is never added.

| In | Out |
|---|---|
| `.claude/CLAUDE.md`, `.claude/settings.json` | `~/.claude.json` (ClickUp MCP login), history, sessions, file-history, plugins cache |
| `.claude/hooks/*.sh` + `hooks/tests/` | `hooks/state/` |
| `.claude/bin/claude-sync`, `.claude/setup/*` (new) | |
| `.claude/projects/*/memory/` | everything else under `projects/` (transcripts) |
| `.claude/project-docs/<name>/CLAUDE.md` + `projects.tsv` (copies of personal projects' CLAUDE.md, see below) | |
| `.hermes/skills/**` (Justin's own skills) | every symlink in `.hermes/skills` and `.claude/skills` (each machine rebuilds them), `.curator_ledger.jsonl`, `.usage.json`, `.locks/`, `.hub/` |
| `.hermes/skills-library-{keep,claude,merged}.txt`, `skills-library-local.patch` | the `skills-library` clone (LeornaAI's repo, cloned separately) |
| `.hermes/scripts/*.{sh,py}`, `.hermes/SOUL.md`, `.hermes/memories/{MEMORY,USER}.md` | `.env`, `auth.json`, `config.yaml`, `state.db`, `cache/` (39 GB), `sessions/`, `hermes-agent/` |
| `.hermes/plans/**/*.md` and `**/briefs/**` | `**/evidence/**` (15 GB of screenshots), `**/private/**` (live-target JSON), other JSON |

Excluded folders go in the repo's `info/exclude`. `claude-sync` rewrites that file on every run from `.claude/setup/exclude.txt` plus the current list of symlinks, so large folders are pruned before git walks them.

## How sync works: one script, `~/.claude/bin/claude-sync`

- **`claude-sync push`** is run automatically. It takes a lock (`mkdir`-based, because macOS has no `flock`), then:
  1. Copies changed project CLAUDE.md files into `.claude/project-docs/`.
  2. Regenerates `skills-library-local.patch` with `git -C ~/.hermes/skills-library diff`, so edits to library skills (`code-review-practice` and others) travel too.
  3. Stages the files on the manifest and runs **gitleaks on the staged files**. On a hit it unstages the file, skips the push and warns loudly. It also refuses any file over 5 MB.
  4. Commits `sync(<host>): <files>`, runs `git pull --rebase`, then pushes.
- **`claude-sync pull`** fetches and rebases. It then copies newer project CLAUDE.md files out, re-applies the library patch, and runs `update-skills-library.sh` when the keep lists changed. Offline, it does nothing quietly.
- **Conflicts:** when both machines changed the same file, the rebase is aborted and the local commit is kept, but nothing is pushed. The script writes `~/.claude/hooks/state/setup-sync-conflict`, and the hooks keep telling Claude "resolve the setup conflict in X first" until it's fixed. The fix keeps both sides' meaning, as in the memory note on concurrent sessions sharing skill files.
- **Project CLAUDE.md files** live inside other projects, so they're copied rather than tracked. `projects.tsv` maps each project's name to its path on the Mac and on the desktop. A hash file records the last synced version, so a change on both sides counts as a conflict instead of one side overwriting the other.

### When it runs (Justin's ask)

| Trigger | What happens |
|---|---|
| **PostToolUse on `Edit`, `Write`, `MultiEdit`, `NotebookEdit`** (new hook `setup-sync-on-edit.sh`) | If the edited file is a tracked one (after resolving `~/.claude/skills/x` to the real Hermes path), it starts `claude-sync push` in the background after a 20 s pause, so a burst of edits makes one commit. |
| **Stop** (end of each turn) | `claude-sync push`, which picks up edits made through Bash (`sed`, `cp`) |
| **macOS launchd, every 10 min** (Mac only) | `claude-sync push`, which picks up Hermes's own skill edits (curator, `skill_manage`) |
| **SessionStart** (new hook `setup-sync-pull.sh`) | `claude-sync pull` (15 s timeout) |
| **Pipeline step 2, right before the planner is dispatched** | the orchestrator runs `claude-sync pull` and stops if it reports a conflict. A new line goes into `~/.claude/CLAUDE.md` step 2, and the same line into `feature-dispatch/SKILL.md` so Hermes pulls too. |

## Rule changes

- `~/.claude/CLAUDE.md`, the Git & GitHub Privacy section: "never commit `CLAUDE.md` to any repository" becomes "…to any **project** repository; the private `Just-In-N-Out/claude-setup` repo is the exception, and `claude-sync` commits to it automatically". Without this, a later session would unstage the file or refuse to commit it. The same carve-out goes in `git-commit-rules` if that skill repeats the rule.
- `~/.claude/CLAUDE.md` pipeline step 2: add the pull line. A short "Setup sync" section says what is synced and how conflicts are handled.

## Desktop setup (Justin does this on Windows; Claude in WSL does the rest)

1. In PowerShell as admin, run `wsl --install -d Ubuntu`, reboot, and create the user `justin`.
2. In WSL: `sudo apt install -y git jq gh unzip`, install gitleaks from the GitHub release, then install Claude Code with `curl -fsSL https://claude.ai/install.sh | bash`.
3. Create new SSH keys for the desktop: the personal key goes on `Just-In-N-Out`, and the Leorna key (`~/.ssh/id_ed25519_leorna`, host alias `github-leorna`) goes on `Justin-Leorna`. Then sign in `gh` with both accounts.
4. Run `curl`/`git clone --bare` on the repo, then `~/.claude/setup/bootstrap.sh`. It:
   - checks the files out into `$HOME`, backing up any it would overwrite;
   - writes the global gitconfig (personal identity, plus `includeIf gitdir:~/Leorna/` pointing to `~/.gitconfig-leorna`);
   - clones `LeornaAI/skills-library` to `~/.hermes/skills-library` and runs `update-skills-library.sh`, which rebuilds every skill link for this machine;
   - clones the three Leorna repos into `~/Leorna` through `github-leorna`;
   - links each desktop memory folder to the Mac one using `projects.tsv`, with relative links (for example `-home-justin-Leorna/memory` → `../-Users-justin-Leorna/memory`), so both machines write the same notes;
   - runs every hook test.
5. Start `claude` once. Install the four plugins (superpowers, frontend-design, context7, claude-md-management), then add the ClickUp MCP again with `claude mcp add` and sign in. The MCP login never goes in the repo.

Note: the Leorna client is a Wails desktop app. Building or running it from WSL is a separate question and isn't covered here.

## Files to create or change

- New: `~/.claude/bin/claude-sync`, `~/.claude/hooks/setup-sync-on-edit.sh`, `~/.claude/hooks/setup-sync-pull.sh` and tests in `~/.claude/hooks/tests/` (same style as `subagent-ac-gate.test.sh`), `~/.claude/setup/{manifest.txt,exclude.txt,projects.tsv,bootstrap.sh,README.md}`, `~/Library/LaunchAgents/com.justin.claude-sync.plist`.
- Changed: `~/.claude/settings.json` (three hook entries; added last, so running sessions aren't affected mid-build), `~/.claude/CLAUDE.md`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`.
- Reused: `~/.hermes/scripts/update-skills-library.sh` (already rebuilds the Hermes and Claude skill links from the keep lists), gitleaks 8.30.1 (`/opt/homebrew/bin/gitleaks`).
- To fix for Linux: `~/.hermes/scripts/merge_lock.sh:15` uses the Mac-only `stat -f`. Only Hermes uses it, so this is low priority. Every hook must use commands that behave the same on macOS and GNU.

## How it gets built: the pipeline, **Full** (recommended)

It touches hooks that every session runs and pushes Leorna material to GitHub automatically, so a secret-leak bug would be costly. It is also more than three files. On approval:
1. I save the brief and dispatch the **planner**, which turns this design into `~/.hermes/plans/claude-setup/setup-sync.md` with numbered ACs.
2. I show you the ACs and wait for "go".
3. Then the builder, review → fix → review → fix, the verifier, the AC auditor and `ac-check.sh`.

All tests run against a fake `$HOME` and a local bare "remote", never the real GitHub repo. Only the finisher, once the ACs are accepted, creates `Just-In-N-Out/claude-setup`, makes the first push (gitleaks-clean), loads the launchd job and registers the hooks.

Questions the planner raises: which project CLAUDE.md files to include. The candidates are Rise, rise-backend, FigmaToBricksV2, weightstone-journal (it exists in two places), 3DSearch, APPSec-Project, FigmaPlugin and JustinPersonalWebsite. The plan is to skip the "copy N", "- updated" and `~/Downloads` duplicates.

## Verification

- Hook and sync tests pass on macOS and in a Linux container (`docker run ubuntu`, or WSL when it's ready). They cover:
  - an edit to a tracked skill becomes exactly one commit on the fake remote within the debounce;
  - an edit to an untracked file makes no commit;
  - a planted fake token blocks the push;
  - a two-sided edit produces the conflict flag and no push;
  - `pull` brings a remote skill change down and re-links.
- First real push: `git ls-tree -r` on GitHub shows no `.env`, `auth.json`, `config.yaml`, evidence or private files, and gitleaks reports the whole history clean.
- End to end on the Mac: edit a skill line, then check that the commit appears on GitHub within about a minute.
- **(live, only Justin can check)** On the desktop, after the bootstrap, the same skill edit made there appears on the Mac after `claude-sync pull`, and a pipeline run there loads the same skills and hooks.
