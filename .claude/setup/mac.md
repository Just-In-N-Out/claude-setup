# Mac: the main machine

Read `~/.github/README.md` first. It covers what syncs, the rules, and the daily flow.

## What's different here

- **Hermes runs on this Mac.** It edits skills by itself (the curator, `skill_manage`, lessons from its own pipeline). The automatic sync isn't built yet, so those edits reach GitHub only when `~/.claude/setup/sync.sh` runs. Claude runs it after its own edits (rule in `~/.claude/CLAUDE.md`). After a Hermes work session, run it once too, or ask Claude to.
  - The planned `launchd` job will run `sync.sh pull` + push every 10 minutes, covering both Hermes edits and desktop edits landing here (plan: `~/.hermes/plans/claude-setup/setup-sync.md`).
- **Hermes pipeline:** `feature-dispatch` runs `~/.claude/setup/sync.sh pull` before dispatching a planner, the same as Claude's pipeline step 2. That way plans use the newest skills from both machines.
- **The skill library:** `~/.hermes/skills-library` is the LeornaAI clone. `~/.hermes/scripts/update-skills-library.sh` pulls it, re-links the picked skills and keeps local edits. `sync.sh` saves those edits into `~/.hermes/skills-library-local.patch` before every commit, so the desktop gets them.
- **Evidence and private files stay here.** That's `~/.hermes/plans/**/evidence/` (about 15 GB of screenshots, `ac.json`, `plan-approved.md` copies) and `**/private/`. A story whose evidence is here can't be verified on the desktop; finish it on the Mac.
- **Git hooks, one time on this Mac:** `git config --global core.hooksPath '~/.claude/githooks'`, then `git config --global core.hooksPath` to read it back. From then on `~/.claude/githooks` checks every commit (no `CLAUDE.md` outside the setup repo, the right email for the folder, no AI co-author) and still runs each repo's own `.git/hooks` after its checks. `git-guard.sh` and `orchestrator-guard.sh` reach Claude Code here through the synced `settings.json` at the next session-start pull. Off switches: the git hooks, `git config --global --unset core.hooksPath` in a terminal (Claude's git-guard denies it on purpose); a Claude Code guard, delete its entry from `~/.claude/settings.json` (that syncs to the desktop; `/hooks` shows what is on).
- **Memory folders are the originals** (`~/.claude/projects/-Users-justin-…/memory`). The desktop links its own folders to these.
  - `-Users-justin-Leorna-leorna-control-plane/memory` is a symlink to `-Users-justin-Leorna-leorna-client/memory` (shared notes). Symlinks aren't synced; `projects.tsv` records the sharing.
- **Project `CLAUDE.md` files:** the nine personal projects in `projects.tsv` (`claude_md = yes`) are copied into `~/.claude/project-docs/<name>/` before each commit, and copied back out when the desktop changed them.
  - `JustinPersonalWebsite/CLAUDE.md` is also committed in that project's own repo (`Just-In-N-Out/PersonalWebsite`), which breaks the privacy rule. Removing it there is Justin's call.

## GitHub auth for this repo

- `sync.sh` pushes over HTTPS with the **Just-In-N-Out** token from `gh` (a repo-only credential helper in `~/.claude-setup.git/config`). The active `gh` account stays **Justin-Leorna**.
- The Mac's personal SSH key `~/.ssh/id_ed25519` is **not** registered on Just-In-N-Out: GitHub refuses it, and `github.com/Just-In-N-Out.keys` is empty. This repo doesn't need it. Personal repos that use SSH remotes will fail until Justin adds the key in GitHub → Settings → SSH and GPG keys.

## Commands

```bash
~/.claude/setup/sync.sh          # commit, pull, push
~/.claude/setup/sync.sh pull     # commit, pull (before plans, at session start)
~/.claude/setup/sync.sh status   # dry run: staged + checked + secret-scanned, nothing committed
git --git-dir="$HOME/.claude-setup.git" log --oneline -10   # history
```

## Codex

Codex CLI, signed in with ChatGPT, uses this same setup: the same rules and story pipeline, the same Hermes skills, Claude's memory notes, and the same sync. Story `codex-parity` built it (plan: `~/.hermes/plans/claude-setup/codex-parity.md`).

**Install and sign in (once):**
1. Install or update: `npm install -g @openai/codex`, then `codex --version` (0.163.0 or newer; keep both machines on the same version).
2. Sign in: run `codex login` in your own terminal. Claude Code's shell can't reach the Mac keychain, so `codex login status` there says "Not logged in" even when you are.
3. `bash ~/.claude/setup/codex/setup-codex.sh`. It builds `~/.codex/AGENTS.md`, links the skills into `~/.agents/skills`, merges its managed blocks into `~/.codex/config.toml` (backup in `~/.codex/backups/`), turns off plugin skills that duplicate a Hermes skill, and checks what Codex loads. Rerun it after updating Codex or its plugins; `--check` only checks.
4. Open `codex`, type `/hooks` and trust the six hooks. Do it again after any change to `~/.codex/hooks.json`: until then Codex skips them and warns that they need review.

**How Codex finds the setup:**
- **Rules:** `~/.codex/AGENTS.md` is generated from `~/.claude/CLAUDE.md` plus a Codex header with a tool map (`~/.claude/setup/codex/agents-header.md`). Edit those two, never `AGENTS.md`; every sync rebuilds it. A project's own `AGENTS.md`, or else its `CLAUDE.md`, loads too.
- **Skills:** the Hermes skills Claude uses, linked at `~/.agents/skills/<name>` by `~/.hermes/scripts/update-skills-library.sh`.
- **Memory:** Claude's notes in `~/.claude/projects/<key>/memory/`; the session-start hook shows the index and Codex saves notes there the same way. Codex's own memories stay off.
- **Pipeline:** the seven `pipeline_*` roles in `~/.codex/agents/` (planner, builder, reviewer, fixer, verifier, auditor, finisher).

**Hooks** (`~/.codex/hooks.json`, all through `~/.codex/hooks/codex-hooks.sh`): session start pulls with Claude's own `setup-sync-pull.sh` and refreshes the rules; after each turn the Stop hook pushes in the background (`~/.claude/hooks/setup-sync-push.sh`) through the same `sync.sh` lock Claude uses; SubagentStop runs Claude's AC and lessons gates; a commit guard blocks AI co-author trailers. Codex can also run `~/.claude/setup/sync.sh` itself: `~/.codex/rules/setup-sync.rules` lets exactly that script, and `set-pipeline-model.sh`, run outside the sandbox.

**The pipeline model:** File: `~/.claude/setup/codex/pipeline-model.toml`; value: `model` and `model_reasoning_effort` (`gpt-6.1-sol` at `xhigh` to start). To switch, tell any agent "switch the Codex pipeline model to X": it runs `~/.claude/setup/codex/set-pipeline-model.sh X`, which (1) checks X against `~/.codex/models_cache.json`, (2) edits that file and rewrites the role files, (3) runs `sync.sh`. The desktop gets it at its next pull. The main session's own model is whatever you pick with `/model`.

**What syncs and what never does:**
- Synced: `~/.codex/hooks.json`, `~/.codex/hooks/`, `~/.codex/agents/*.toml`, `~/.codex/rules/setup-sync.rules`, `~/.claude/setup/codex/`, `~/.claude/hooks/setup-sync-push.sh`.
- Never synced, per machine: `~/.codex/auth.json`, `~/.codex/config.toml` (and its hook trust), the generated `~/.codex/AGENTS.md`, sessions, history, logs, caches, plugins, `~/.agents/skills` links, and `~/.codex-probe/`.

**Don't use Codex's `/import` from Claude Code.** It would make a second copy of the rules, skills and hooks that drifts from these.

**Probe home (optional, only for the probe tests in `codex-parity.test.sh`):** a separate home with a file-stored sign-in, because tests can't use the keychain login: `mkdir -p ~/.codex-probe && printf 'cli_auth_credentials_store = "file"\n' > ~/.codex-probe/config.toml && CODEX_HOME=~/.codex-probe codex login`. Never synced.

**Troubleshooting:**
- "hooks need review": open `codex`, `/hooks`, trust them.
- "Not logged in" from Claude's shell: expected here; run Codex from your own terminal.
- Codex follows old rules: `bash ~/.claude/setup/codex/build-codex.sh` (`--check` exits 1 when `AGENTS.md` is stale).
- Tests: `bash ~/.claude/setup/codex/codex-parity.test.sh` (offline, no sign-in).
