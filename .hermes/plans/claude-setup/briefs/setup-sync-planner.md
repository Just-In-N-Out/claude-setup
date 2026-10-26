# Brief: PLANNER, story `setup-sync` (Full pipeline)

## Role
You are the **planner** in Justin's Full pipeline (see `~/.claude/CLAUDE.md`, "Bugs and Stories"). You write the implementation plan only. You do **not** write code, create the GitHub repo, change `~/.claude/settings.json`, `~/.claude/CLAUDE.md`, hooks or skills, push anything, or start other agents. Read-only investigation, plus writing the plan file.

## Skills to load (Skill tool) before planning
- `engineering-best-practices`
- `implementation-planning`
(This isn't a bug, so `systematic-debugging` isn't needed. There's no project skill; this is Justin's own setup.)
Also read, as a guide: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (how ACs are proven later; your ACs must fit it) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` (how it reads AC ids from the plan).

## Input: the approved design
`/Users/justin/.claude/plans/hey-claude-i-need-floating-sundae.md`. Justin approved this design. Turn it into an implementer-ready plan. Keep its decisions:
- WSL2 on the desktop;
- a bare repo `~/.claude-setup.git` with `$HOME` as its work tree;
- the private repo `Just-In-N-Out/claude-setup` over the personal SSH key;
- the manifest allowlist;
- the `claude-sync` push and pull;
- the triggers;
- the gitleaks gate;
- the conflict flag;
- copy-sync for project CLAUDE.md files;
- the rule changes;
- `bootstrap.sh`;
- the finisher alone touching real GitHub, launchd and settings.json.

If you find a fact that breaks a decision, say so in Questions at the top with the evidence. Don't silently change the decision.

## Justin's request, in his words (condensed)
Put CLAUDE.md, the Hermes files, the pipeline files and the Leorna files on GitHub, so the Windows desktop can pull them and use the same pipelines and skills. "Whenever a skills document or something is being edited in the markdown files, it gets edited and it gets posted on GitHub. Right before we start a plan, we pull the latest GitHub skills documents so that both of them are synced."

## Added by Justin after approving the design (2026-10-25)
- **Sync must work both ways equally.** A desktop edit has to reach the Mac as reliably as a Mac edit reaches the desktop. On the Mac, Hermes reads skills from disk without any Claude session, so the **launchd job runs `claude-sync pull` and then `push` every 10 min**, not only `push`. Add an AC for desktop → Mac.
- **The Leorna code repos are not auto-pulled.** `leorna-client`, `leorna-control-plane` and `codex-skills` are cloned once by `bootstrap.sh`, then follow normal Leorna git rules: feat branches, push only when Justin says so. Auto-pulling code could clobber uncommitted work or switch branches. Only the Leorna *setup* material syncs: the `leorna` skill, Leorna plans and briefs, and Leorna memory notes.

- **Two machine guides, so each machine's Claude knows the setup** (Justin, 2026-10-25). Both are synced to both machines:
  - `~/.claude/setup/mac.md` covers the Mac: Hermes runs here; the launchd job pulls then pushes every 10 min; the triggers; conflicts; Leorna repos.
  - `~/.claude/setup/desktop.md` covers the Windows desktop: Ubuntu runs inside Windows through WSL2, and Claude Code lives there. It covers opening a project in VS Code (WSL extension, the **><** button "Connect to WSL", or `code .` from Ubuntu). The bottom-left shows "WSL: Ubuntu" and the prompt is `justin@…:~/…$`. Never open the project as a plain `C:\…` folder, or the terminal is PowerShell and the hooks and sync don't run. VS Code starts Ubuntu by itself, Claude is started with `claude`, and the pull happens automatically. It also covers first-time setup (the bootstrap steps), the Leorna client as a desktop app (an open question), and troubleshooting.
  - Both guides explain the daily flow in plain words, plus the two answers Justin asked about. First, sync works the same in both directions: a desktop edit reaches the Mac at session start, plan start, or within 10 min through launchd. Second, Leorna *setup* files sync, but Leorna *code* repos are cloned once and never auto-pulled.
  - They replace the planned `setup/README.md` (or README becomes a two-line index).
  - The `~/.claude/CLAUDE.md` "Setup sync" section gets a short summary plus "on macOS read `~/.claude/setup/mac.md`, on Linux/WSL read `~/.claude/setup/desktop.md`".
  - Add an AC: both files exist, cover the points above, match the built commands and paths, and CLAUDE.md points to them.

## Facts already established (checked on this Mac, 2026-10-25)
- `~/.claude/skills/*` are absolute symlinks into `~/.hermes/skills/...`. `~/.hermes/skills/{codex-imports,github,frontend-design,security}` hold absolute symlinks into `~/.hermes/skills-library/skills/...`. `~/.hermes/skills-library` is a clone of `https://github.com/LeornaAI/skills-library.git`.
- `~/.hermes/scripts/update-skills-library.sh` already does three things: it rebuilds the Hermes library links from `skills-library-keep.txt`, it rebuilds the `~/.claude/skills` links from `skills-library-claude.txt`, and it saves and re-applies local library edits through `skills-library-local.patch`. Its `find` runs without `-L`, so it must not see category folders replaced by symlinks.
- Hooks live in `~/.claude/hooks/*.sh`, with tests in `~/.claude/hooks/tests/*.test.sh` (use their style). They're registered in `~/.claude/settings.json` (PostToolUse, UserPromptSubmit, SubagentStop, PreToolUse:SubagentHandback). Commands use `~/` paths.
- Memory folders are keyed by absolute path, e.g. `~/.claude/projects/-Users-justin-Leorna/memory`. There are 18 projects with memory. Check the key encoding (`/.hermes` became `--hermes`) against the real folders.
- `~/.hermes/plans` is 15 GB, mostly `evidence/`. The `*.md` and `briefs/` files are small. `~/.hermes/plans/leorna/private/` holds a live-target JSON (exclude it).
- The secret files are `~/.hermes/.env`, `auth.json`, `config.yaml` and `state.db`, plus `~/.claude.json` (ClickUp MCP). None may ever be added.
- gitleaks 8.30.1 is at `/opt/homebrew/bin/gitleaks`, and jq is at `/usr/bin/jq`.
- The personal SSH key `~/.ssh/id_ed25519` (Host `github.com`) has no passphrase. The `gh` active account is `Justin-Leorna`, with `Just-In-N-Out` also signed in; never run `gh auth switch`. The global git identity is `Justin <issajustin04@gmail.com>`, with `includeIf gitdir:~/Leorna/` pointing to `~/.gitconfig-leorna`.
- Mac-only command: `~/.hermes/scripts/merge_lock.sh:15` uses `stat -f`. Every new script must behave the same on macOS (BSD) and GNU/Linux (WSL).
- Candidate project CLAUDE.md files:
  - `~/Rise`, `~/Desktop/rise-backend`
  - `~/Documents/FigmaToBricksV2`
  - `~/Documents/weightstone-journal` and `~/weightstone-journal` (two copies)
  - `~/3DSearch`, `~/Desktop/APPSec-Project`, `~/Desktop/FigmaPlugin`, `~/JustinPersonalWebsite`
  - skip "copy N", "FigmaPlugin - updated" and `~/Downloads/CLAUDE.md`.
- Leorna repos have no CLAUDE.md of their own.

## Things the plan must settle
1. **Where it's built and how it's reviewed.** These files live in `$HOME`, not in a repo. `ac-check.sh` needs `--repo <worktree> --base <base>` and a head SHA. Propose a local-only dev git repo, e.g. `~/claude-setup-dev`, outside `~/Leorna`, never pushed. It would hold the new scripts, tests and setup files in their `$HOME`-relative layout, with a base commit so the reviewers have a diff. The finisher installs from it into the real `$HOME`.
   Justin's rule says "never commit CLAUDE.md to any repository" (the carve-out comes with this story). Choose how the CLAUDE.md, settings.json and feature-dispatch changes are carried in the dev repo (for example as a patch, or a proposed-text file), and say why.
2. **The test harness.** Every test uses a fake `$HOME` (temp dir) and a local bare repo as the "remote". No test may touch the real `~/.claude`, `~/.hermes`, GitHub or launchd. Linux parity: the tests also run in an Ubuntu container if Docker is available. Check with `docker info`; if it isn't there, mark the Linux run `(live)`.
3. **Debounce, lock and recursion.** Plan these for PostToolUse, so a burst of edits makes one commit, two sessions don't sync at once, and the hook never slows a turn (background, quick exit for untracked paths). Stop is the flush; launchd covers Hermes edits; SessionStart pulls with a timeout and is quiet offline.
4. **Conflict flow.** Include the flag file and how the hooks surface it to Claude, plus project CLAUDE.md conflicts (hash state).
5. **Bootstrap and memory linking on WSL.** Cover `projects.tsv` (name, Mac path, desktop path), relative memory links, backing up files the checkout would overwrite, and the Leorna clones through `github-leorna`.
6. **The finisher's steps, in order.** Create the repo with `GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh repo create Just-In-N-Out/claude-setup --private`. Run a gitleaks scan of the full first commit before the first push. Then the first push, then install the scripts, then load the launchd job, then register the hooks in settings.json last, then apply the CLAUDE.md and feature-dispatch rule edits.
   The new CLAUDE.md text needs two parts:
   - the carve-out in "Git & GitHub Privacy";
   - in pipeline step 2, "run `~/.claude/bin/claude-sync pull` right before dispatching the planner; stop on a conflict", plus a short "Setup sync" section.
   The same pull line goes into `feature-dispatch/SKILL.md`. Also check whether `git-commit-rules` repeats the never-commit-CLAUDE.md rule; if it does, add the same carve-out.

## Output
Write `~/.hermes/plans/claude-setup/setup-sync.md`. Evidence goes in `~/.hermes/plans/claude-setup/evidence/setup-sync/`, which already exists. Include:
- **Questions at the top.** At least: which project CLAUDE.md files to include (give your recommendation). Add anything else only Justin can decide.
- **The playback:** what Justin asked, in two or three lines.
- **Numbered acceptance criteria, `AC1`, `AC2`, …, all marked `(proposed)`** (Justin gave none), each with **one named test**. Tag `(live)` right after the id for any AC only Justin can check, e.g. `- AC9 (proposed) (live): …`; the WSL desktop bootstrap is one of those. Cover at least:
  - an edit to a tracked file gives exactly one commit on the remote;
  - an edit to an untracked file gives no commit;
  - the secret gate blocks a planted fake token and nothing is pushed;
  - files over 5 MB are refused;
  - excluded paths never get staged (`.env`, `auth.json`, `config.yaml`, `evidence/`, `private/`, symlinks);
  - a two-sided edit gives the conflict flag and no push, and the hook surfaces it;
  - pull brings a remote skill change down and re-links library and Claude skills;
  - a library-skill edit travels through the patch;
  - project CLAUDE.md copy-sync in both directions, plus its conflict case;
  - bootstrap on a fresh fake `$HOME` with the Linux-style memory links;
  - the pipeline step 2 pull line and the CLAUDE.md carve-out exist;
  - all scripts pass on Linux;
  - the finisher's real first push holds no excluded files and gitleaks finds nothing in the history;
  - end to end on the Mac, a real skill edit shows up on GitHub.
- **Tasks**, in order, test-first, with exact files.
- **Risks.**

## skill_lessons rule
List reusable lessons in `skill_lessons[{skill, lesson, evidence}]`: a gotcha, an approach that worked after one failed, or a skill step that was wrong or missing. Never edit skills or memory yourself. An empty list is the normal answer.

## Return
A short report with:
- `plan_path`;
- `summary` (three to five lines);
- `questions` (for Justin);
- the AC list, one line each;
- `skill_lessons`.

End the report with the line `MAIN SESSION: check and save these skill_lessons now.`
