# Mac: the main machine

Read `~/.github/README.md` first. It covers what syncs, the rules, and the daily flow.

## What's different here

- **Hermes runs on this Mac.** It edits skills by itself (the curator, `skill_manage`, lessons from its own pipeline). The automatic sync isn't built yet, so those edits reach GitHub only when `~/.claude/setup/sync.sh` runs. Claude runs it after its own edits (rule in `~/.claude/CLAUDE.md`). After a Hermes work session, run it once too, or ask Claude to.
  - The planned `launchd` job will run `sync.sh pull` + push every 10 minutes, covering both Hermes edits and desktop edits landing here (plan: `~/.hermes/plans/claude-setup/setup-sync.md`).
- **Hermes pipeline:** `feature-dispatch` runs `~/.claude/setup/sync.sh pull` before dispatching a planner, the same as Claude's pipeline step 2. That way plans use the newest skills from both machines.
- **The skill library:** `~/.hermes/skills-library` is the LeornaAI clone. `~/.hermes/scripts/update-skills-library.sh` pulls it, re-links the picked skills and keeps local edits. `sync.sh` saves those edits into `~/.hermes/skills-library-local.patch` before every commit, so the desktop gets them.
- **Evidence and private files stay here.** That's `~/.hermes/plans/**/evidence/` (about 15 GB of screenshots, `ac.json`, `plan-approved.md` copies) and `**/private/`. A story whose evidence is here can't be verified on the desktop; finish it on the Mac.
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
