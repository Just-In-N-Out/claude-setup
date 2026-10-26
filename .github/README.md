# claude-setup

Justin's Claude Code + Hermes setup, shared between two machines through this **private** repo:

- **Mac**: the main machine. Hermes (the agent) runs here too.
- **Windows desktop**: Claude Code runs inside **WSL2 Ubuntu**, not native Windows. It uses the same rules, pipeline, skills, hooks, memory and plans as the Mac.

This README is written for the AI agent (Claude Code) on either machine, and for Justin.

---

## If you are an AI agent, read this first

1. **Work out which machine you're on.** Run `uname -s`.
   - `Darwin` means the Mac: read `~/.claude/setup/mac.md`.
   - `Linux` means the Windows desktop (WSL): read `~/.claude/setup/desktop.md`.
   - **If `~/.claude-setup.git` doesn't exist yet,** this machine isn't set up. On the desktop, follow `desktop.md` from the top.
2. **`~/.claude/CLAUDE.md` is Justin's global rulebook.** It holds the story pipeline, git authorship, the Leorna rules and the skills to load. It's loaded at session start; follow it.
3. **Keep the two machines in step.** Sync is manual for now; the automatic version is planned, see *Status*.
   - **Before starting a plan** (pipeline step 2, right before the planner is dispatched), and at the start of a work session: run `~/.claude/setup/sync.sh pull`.
   - **After editing any synced file,** run `~/.claude/setup/sync.sh` before ending your turn. Synced files include skills (for example after saving a `skill_lessons` lesson), `CLAUDE.md`, memory notes, plans and briefs, hooks and `settings.json`.
   - **If it prints `CONFLICT`:** both machines changed the same file. Merge the two versions so both sides' meaning survives, never drop the other machine's edit, then run it again.
4. **Never:**
   - put secrets in a synced path, or weaken `exclude.txt`, the denylist in `sync.sh` or `gitleaks.toml` to let one through;
   - force-push, or rewrite this repo's history;
   - run `gh auth switch`;
   - override the git author (`--author`, `-c user.email`);
   - push a Leorna code repo unless Justin says "push".

---

## How the repo works

- It's a **bare git repo at `~/.claude-setup.git` whose work tree is your home folder (`$HOME`)**. Every file sits at its normal path (`~/.claude/CLAUDE.md`, `~/.hermes/skills/…`), so Claude Code and Hermes find them where they expect. The repo's root *is* the home folder.
- There's no `.git` folder in `~`, so other repos and tools don't see it.
- **Only paths listed in `~/.claude/setup/manifest.txt` are ever added.**
  - `exclude.txt` and a built-in denylist in `sync.sh` keep the rest out.
  - Every file is scanned with **gitleaks** before each commit, and a hit stops the sync.
  - Files over 5 MB are skipped.
  - More than 25 deletions in one go need `--allow-deletes`.
- This README lives at `~/.github/README.md`, so GitHub shows it without putting a README in the home folder.
- For raw git commands, use `git --git-dir=$HOME/.claude-setup.git` (the repo is already configured with `core.worktree=$HOME`). Prefer `sync.sh`.

### `~/.claude/setup/sync.sh`

| Command | What it does |
|---|---|
| `sync.sh` | Commits this machine's changes, pulls the other machine's (rebase), then pushes. Use it after edits. |
| `sync.sh pull` | The same, without the push. Use it before a plan or at session start. |
| `sync.sh status` | Stages, checks and secret-scans only, then shows what would be committed, by folder. |
| `sync.sh attach` | Run once on a new machine, after the bare clone (see `desktop.md`). It backs up files it would overwrite to `~/.claude-setup-backup/<time>/`. |
| `sync.sh links` | Creates the desktop memory links and writes project `CLAUDE.md` files into projects cloned on this machine. Run it after cloning a project. |
| `sync.sh init` | Mac only, already done. Creates `~/.claude-setup.git`. |

After a pull, `sync.sh` also does three things:
- copies changed project `CLAUDE.md` files into the projects;
- re-applies library skill edits (`skills-library-local.patch`);
- rebuilds the skill links when the skill lists changed.

GitHub auth: `sync.sh` sets a repo-only credential helper that asks `gh` for the **Just-In-N-Out** token (`gh auth token --user Just-In-N-Out`). The active `gh` account stays **Justin-Leorna**, and no SSH key is needed for this repo.

---

## What's in the repo

All paths are relative to `$HOME`.

| Path | What it is |
|---|---|
| `.claude/CLAUDE.md` | Global rules for every Claude Code session: the story pipeline (planner → builder → reviews → verifier → AC auditor → `ac-check.sh` → finisher), git identities, Leorna rules, which skills to load. |
| `.claude/settings.json` | Claude Code settings: the hook registrations, plugins, status line, model and effort. |
| `.claude/hooks/*.sh`, `.claude/hooks/tests/` | The pipeline's guard hooks (`subagent-ac-gate`, `subagent-lessons-gate`, `subagent-handback-gate`, `skill-review-nudge`) and their tests. They need `jq`. |
| `.claude/setup/` | This sync system: `sync.sh`, `manifest.txt`, `exclude.txt`, `gitleaks.toml`, `projects.tsv`, `mac.md`, `desktop.md`. |
| `.claude/projects/<key>/memory/` | Claude's per-project memory notes. `<key>` is the project's absolute path with every non-alphanumeric character turned into `-`. The Mac keys look like `-Users-justin-…`; the desktop links its own keys to them (see `projects.tsv`). |
| `.claude/project-docs/<name>/CLAUDE.md` | Copies of the personal projects' own `CLAUDE.md` files. Those never go in the projects' repos; `projects.tsv` maps each one to its folder. |
| `.claude/plans/*.md` | Claude Code plan-mode designs. |
| `.hermes/skills/**` | Justin's own skills (the real files): `software-development/` (engineering-best-practices, implementation-planning, systematic-debugging, test-driven-development, leorna, git-commit-rules, github, review-fix-cadence…), `autonomous-ai-agents/feature-dispatch/` (the pipeline rulebook, `references/`, and `scripts/ac-check.sh`), and others. |
| `.hermes/skills-library-keep.txt`, `-claude.txt`, `-merged.txt`, `-local.patch` | Which LeornaAI library skills each machine links in, which skills are linked into `~/.claude/skills`, and local edits to library skills. |
| `.hermes/scripts/` | Hermes helper scripts, including `update-skills-library.sh`, which builds all the skill links. |
| `.hermes/SOUL.md`, `.hermes/memories/{MEMORY,USER}.md` | Hermes's persona and memory. |
| `.hermes/plans/**/*.md`, `**/briefs/**` | Story plans and agent briefs (e.g. `~/.hermes/plans/leorna/<clickup-id>-<slug>.md`). |
| `.github/README.md` | This file. |

## What is NOT in the repo, and where it comes from

| Not synced | Why | On a new machine |
|---|---|---|
| Skill links: `~/.claude/skills/*`, and `~/.hermes/skills/{codex-imports,github,frontend-design,security}/*` | Symlinks to paths on the machine | Built by `~/.hermes/scripts/update-skills-library.sh` from the keep lists |
| Library skills (`code-review-practice`, `security-best-practices`, `api-contract-drift-guard`…) | They live in **LeornaAI/skills-library** | Clone it to `~/.hermes/skills-library` with the Leorna account. Justin's edits come with it through `skills-library-local.patch`. |
| Leorna code: `leorna-client`, `leorna-control-plane`, `codex-skills` | Already on GitHub (LeornaAI) | Clone once into `~/Leorna` through `git@github-leorna:…`. **Never auto-pulled**: use normal git on feature branches, and push only when Justin says so. |
| Secrets: `~/.hermes/.env`, `auth.json`, `config.yaml`, `~/.claude.json` (MCP logins), SSH keys | Secrets | Set up by hand on each machine |
| Hermes agent, its database, cache and sessions | Mac only, and huge (about 40 GB) | Not on the desktop |
| `~/.hermes/plans/**/evidence/` (screenshots, about 15 GB), `**/private/` | Size and privacy | Stay on the machine that made them |
| Claude Code plugins, history, transcripts | Per machine | Plugins are installed on each machine (see `desktop.md`) |

## Accounts and identities

| | Personal | Leorna |
|---|---|---|
| GitHub | `Just-In-N-Out` (owns this repo) | `Justin-Leorna` (LeornaAI org) |
| Git author | `Justin <issajustin04@gmail.com>`, the global default | `Justin Issa <justin@leorna.com>`, for any repo under `~/Leorna/` (`includeIf "gitdir:~/Leorna/"` → `~/.gitconfig-leorna`) |
| Remotes | this repo: HTTPS plus the gh token | `git@github-leorna:LeornaAI/<repo>.git` (SSH alias, Leorna key) |

`gh` is signed in to both accounts, with **Justin-Leorna active**. Never switch it. To act as the other account, use `GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh …`.

## Daily flow

1. **Open Claude Code.**
   - Mac: in Terminal or VS Code.
   - Desktop: in VS Code connected to WSL (bottom-left says **WSL: Ubuntu**), or the Ubuntu terminal. Type `claude`.
2. Run `~/.claude/setup/sync.sh pull` at the start of a session, or ask Claude to.
3. **Start a story** as usual. The pipeline's step 2 runs `sync.sh pull` before the planner.
4. **When Claude edits a skill, CLAUDE.md, memory or a plan,** it runs `~/.claude/setup/sync.sh`, and the change is on GitHub.
5. **The other machine gets it** at its next `sync.sh pull`.
6. **Leorna code** moves between machines only through its own branches: push when Justin says "push", then fetch on the other machine.

## Troubleshooting

| Message | Fix |
|---|---|
| `CONFLICT` | Both machines changed one file, or a file from GitHub already exists here untracked. Merge by hand, keeping both meanings, or move the untracked file aside. Then `sync.sh` again. |
| `gitleaks found what looks like a secret` | Remove the secret from the file. For a *proven* false positive, add a narrow allowlist to `~/.claude/setup/gitleaks.toml`. Nothing was committed. |
| `another sync is running` | Wait a minute. A lock older than 10 minutes is cleared automatically. |
| `push to GitHub failed` | `gh auth status` must list **Just-In-N-Out**, and `gh auth token --user Just-In-N-Out` must print a token. If it doesn't, ask Justin to sign that account in again (`desktop.md`, step 5). Don't switch accounts yourself. |
| Skills missing in Claude | `~/.hermes/scripts/update-skills-library.sh` (needs `~/.hermes/skills-library`). |
| Memory not shared between machines | `~/.claude/setup/sync.sh links` |
| `git has no user.email` | Set the identity: `desktop.md`, step 3. |

## Status

- **Done (2026-10-26):** the repo, the first snapshot, manual sync with `sync.sh` (tested on macOS and Ubuntu), these guides, and the `CLAUDE.md` rules that tell Claude to pull before plans and sync after edits.
- **Planned, not built yet: automatic sync.**
  - a hook that pushes about 20 s after any edit to a synced file;
  - a pull at every session start;
  - a Mac `launchd` job that pulls and pushes every 10 minutes, for Hermes's own edits.

  Plan: `~/.hermes/plans/claude-setup/setup-sync.md` (22 acceptance criteria). Approved design: `~/.claude/plans/hey-claude-i-need-floating-sundae.md`. The planned `claude-sync` replaces `sync.sh` and keeps this repo and layout.
