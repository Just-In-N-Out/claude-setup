# setup-sync: sync Justin's Claude + Hermes setup through GitHub (Mac ⇄ Windows desktop)

Status: **plan, waiting for "go"** (planner, 2026-10-25). Full pipeline. Nothing is built yet.
Design approved by Justin: `/Users/justin/.claude/plans/hey-claude-i-need-floating-sundae.md`. Every decision in it is kept; the one fact that breaks one is Q2.

## Questions for Justin (the plan is written as if the ⭐ options are chosen)

**Q1. Which project `CLAUDE.md` files sync?** Facts: the two "weightstone-journal" folders are **different repos**. `~/Documents/weightstone-journal` is `Just-In-N-Out/MinimaLog`; `~/weightstone-journal` is `Just-In-N-Out/weightstone-journal`. `~/Desktop/FigmaPlugin` isn't a git repo. `~/JustinPersonalWebsite/CLAUDE.md` is already committed in its own repo (see "Other things found").
- A) All nine: Rise, rise-backend, FigmaToBricksV2, MinimaLog, weightstone-journal, 3DSearch, APPSec-Project, FigmaPlugin, PersonalWebsite ⭐
- B) Only FigmaToBricksV2 and FigmaPlugin (the only ones edited since June)
- C) None for now (memory notes still sync)

**Q2. GitHub refuses the personal SSH key. This breaks the design's auth decision, and it blocks only the finish step.** Evidence: `ssh -v -T git@github.com` offers `~/.ssh/id_ed25519` (SHA256:AOYkzWtS…QBQ) and gets "Permission denied (publickey)". `https://github.com/Just-In-N-Out.keys` lists **no keys at all**. `gh` can't add the key for you, because the Just-In-N-Out token's scopes are `gist, read:org, repo`, with no `admin:public_key`.
- A) You add `~/.ssh/id_ed25519.pub` to Just-In-N-Out (GitHub → Settings → SSH and GPG keys) before the finish. The design stays as it is: SSH, no prompts, works from launchd ⭐
- B) Use an HTTPS remote with a credential helper that asks `gh` for the Just-In-N-Out token. No key needed, but it relies on the keychain from launchd and on `gh` being set up on the desktop.
- C) Hold the finish until you decide

**Q3. Also sync `~/.claude/plans/`?** These are Claude Code's plan-mode designs: 47 files, 584 KB. This story's approved design lives there. The design's table only listed `~/.hermes/plans`.
- A) Yes, add `:(glob).claude/plans/*.md` to the manifest ⭐
- B) No

**Q4. The desktop has no launchd. Should each prompt also start a background pull-then-push when the last one was over 10 minutes ago (on both machines)?**
- A) Yes. A Mac edit then reaches an open desktop session within about 10 minutes, the same rhythm launchd gives the Mac. It is never in the foreground and never slows a prompt ⭐
- B) No. The desktop pulls only at session start and before a plan.

## Playback

Justin wants his whole Claude Code + Hermes setup on GitHub, so the Windows desktop (Claude Code inside WSL2 Ubuntu) can pull it and run the same pipelines and skills. That setup is the global `CLAUDE.md`, settings, hooks, Hermes skills and memories, Claude memory notes, plans and briefs, Leorna setup files and project `CLAUDE.md` copies. Every edit to a synced file is pushed on its own, and the latest is pulled right before a plan starts. Sync works the same in both directions: on the Mac, launchd pulls and then pushes every 10 minutes for Hermes. The Leorna code repos are cloned once and never auto-pulled. Two machine guides (`mac.md`, `desktop.md`) tell each machine's Claude how it all works.

## Acceptance criteria (proposed: Justin gave none; "go" approves them)

ACs 1–15 run from `home/.claude/hooks/tests/setup-sync.test.sh <test>`. AC16–AC17 run from `tests/rule-edits.test.sh`, AC18 from `tests/guides.test.sh`, AC19 from `tests/linux-parity.test.sh`, and AC20 from `tests/finisher/first-push-audit.sh`. All paths are relative to the dev repo `~/claude-setup-dev`. Every test prints TAP, `ok <n> - <test name>`. Exact assertions are in "Test specs".

- AC1 (proposed): Given a synced fake `$HOME` and a local bare "remote", when a tracked skill file is edited three times within the debounce window, each followed by the PostToolUse hook, then each hook call returns within 1.5 s with no output. Exactly **one** new commit reaches the remote, holding only that file with all three edits. Its title is `sync(<host>): <path>`, its author is the home's git identity, and it has no `Co-Authored-By` line. Test: `ac1_tracked_edit_one_commit`.
- AC2 (proposed): Given the same setup, when files outside the manifest are edited, then the hook returns within 1.5 s with no output and starts no worker. Even after a Stop flush, the remote gets no commit. The files are: a file in `~`, a plan's `evidence/` file, a `hooks/state/` file, a `.hermes/cache/` file and a file inside a Leorna clone. Test: `ac2_untracked_edit_no_commit`.
- AC3 (proposed): Given a tracked file holding a fake GitHub token built at runtime, when `claude-sync push` runs, then it exits 4. Nothing new reaches the remote, and no local commit contains the token. `setup-sync-blocked` names the file and rule without the secret, and the UserPromptSubmit hook says "setup sync blocked". After the token is removed, the next push sends everything and clears the flag. A 40-hex commit SHA next to the word "sourcegraph" passes, while a real-shaped `sgp_` token is blocked. A missing gitleaks, and a token in a commit made outside `claude-sync`, both block the push. Test: `ac3_secret_gate_blocks_push`.
- AC4 (proposed): Given a file of 5,242,881 bytes (over 5 MB) and one of exactly 5,242,880 bytes in tracked folders, plus a small tracked edit, when `claude-sync push` runs, then the larger file is never committed or pushed and is named in the blocked flag as `too-big`. The 5 MB file and the small edit are pushed, and the exit code is 0. Test: `ac4_large_file_refused`.
- AC5 (proposed): Given a fake `$HOME` holding the following, when push runs, then the remote tree and every commit contain **none** of them and no mode-120000 entry. That holds even with the manifest widened to `:(glob).hermes/**` and `:(glob).claude/**`. With `exclude.txt` also emptied, the built-in denylist unstages them, writes `denied` entries and halts the push (exit 4). The files are `.hermes/.env`, `.hermes/auth.json`, `.hermes/config.yaml`, `.hermes/state.db`, `~/.claude.json`, a nested `.env` inside a skill, `evidence/` and `private/` files in plans, `.hermes/skills/.hub/…`, `.hermes/skills/.usage.json`, `.claude/hooks/state/…`, a library-skill symlink, a `.claude/skills` symlink and a symlinked memory folder. Test: `ac5_excluded_paths_never_staged`.
- AC6 (proposed): Given 30 tracked skill files, when the `.hermes/skills` folder vanishes (moved away) and push runs, then no deletion is committed or pushed. The exit code is 4, and the blocked flag says `mass-delete 30`. When the folder comes back, the next push clears the flag. A real deletion of 30 files goes through with `claude-sync push --allow-deletes`. Test: `ac6_mass_delete_held`.
- AC7 (proposed): Given machines A and B, when both change the same line and A pushes first, then B's push exits 3. B's commit stays local and B's file keeps B's text, the remote keeps A's text, and `setup-sync-conflict` lists the path. The SessionStart and UserPromptSubmit hooks both say "setup sync conflict" with the path. After B writes merged text and runs `claude-sync resolve`, the remote and then A get the merged text, and the flag is gone. The same holds when both create the same new file with different text, and when a refused (still-dirty) file is also changed upstream. Test: `ac7_conflict_flag_no_push`.
- AC8 (proposed): Given A pushes an own-skill edit plus a new library skill `beta` added to `skills-library-keep.txt` and `skills-library-claude.txt`, when B runs `claude-sync pull`, then B's own skill has the edit. B's `.hermes/skills/software-development/beta` is a link into B's own library clone, and B's `.claude/skills/beta` links to it. Test: `ac8_pull_updates_and_relinks`.
- AC9 (proposed): Given A edits a library skill through its `~/.claude/skills/alpha/SKILL.md` path and fires the hook, then `.hermes/skills-library-local.patch` on the remote carries the edit, and after `claude-sync pull` B's library clone has it. After that, B's push makes no commit and B's next pull keeps the edit. It still makes no ping-pong commits when B's library clone is one upstream commit ahead of A's. Test: `ac9_library_edit_via_patch`.
- AC10 (proposed): Given `projects.tsv` maps a project to different paths on A (mac) and B (desktop), then an edit to A's project `CLAUDE.md` reaches B's project path, and B's edit reaches A. When both edit, neither project file is overwritten, the conflict flag names `project-doc`, the other side's text is saved under `hooks/state/setup-sync/conflicts/`, and `resolve` makes both equal. An unreadable local doc is skipped, never treated as deleted, and a deletion is never propagated. Test: `ac10_project_docs_copy_sync`.
- AC11 (proposed): Given a desktop edit already pushed and a "Hermes" edit made on the Mac with a plain shell write (no hook), when the launchd command runs once on the Mac (`/bin/bash ~/.claude/bin/claude-sync cycle` with launchd's bare environment), then the Mac has the desktop's edit and the remote has the Mac's edit, both from that one run. The rendered launchd plist runs exactly that command every 600 s with a PATH that includes `/opt/homebrew/bin`. `install-launchd.sh` loads it with `launchctl bootstrap gui/<uid>` (stubbed in the test). Test: `ac11_cycle_pulls_then_pushes`.
- AC12 (proposed): Given a fresh Linux-style fake `$HOME` with a pre-existing, different `settings.json`, when `bootstrap.sh` runs, then all of the following hold, and a second run changes nothing:
  - files are checked out and the old file is backed up to `~/.claude-setup-backup-<time>/`;
  - the global gitconfig gets the personal identity plus `includeIf gitdir:~/Leorna/`;
  - the library is cloned and skills are linked;
  - the three Leorna repos are cloned from the Leorna base URL;
  - each `projects.tsv` memory folder becomes a **relative** link, `<desktop key>/memory` → `../<mac key>/memory`, that resolves;
  - a note written through the desktop path is pushed under the Mac key;
  - a mismatched existing `user.email` stops bootstrap without changing it.

  Test: `ac12_bootstrap_fresh_home`.
- AC13 (proposed): Given a bootstrapped desktop whose `leorna-client` clone is on a feat branch with a local commit and an uncommitted change, and whose remote `main` has a new commit, when `claude-sync pull`, `push` and `cycle` run, both hooks fire, and `bootstrap.sh` runs again, then the clone's branch, HEAD, working tree and `origin/main` ref are unchanged. Test: `ac13_leorna_repos_not_auto_pulled`.
- AC14 (proposed): Given one pending change, when two pushes and a pull start at once, then exactly one commit reaches the remote, all of them exit 0, there are no `index.lock` errors, and no lock is left behind. A stale lock (dead pid) is cleared. A rebase left half-done is aborted, with the file restored and no conflict markers. The Stop hook returns within 1.5 s, and its background push still lands after the hook's whole process group is killed. With `stop_hook_active: true` the hook does nothing. Test: `ac14_lock_and_background_flush`.
- AC15 (proposed): Given a remote whose ssh hangs, the SessionStart hook returns within the fetch timeout + 3 s with exit 0 and no output, and leaves no lock, half-done rebase or ssh process. A missing remote is quiet and fast. A real remote change is pulled, and the hook prints one JSON note. The UserPromptSubmit hook returns within 1.5 s and starts a background cycle at most once per `SETUP_SYNC_CYCLE_EVERY_SECS`. Test: `ac15_pull_triggers_fast_and_quiet`.
- AC16 (proposed): Given read-only copies of the live `~/.claude/CLAUDE.md`, `feature-dispatch/SKILL.md` and `git-commit-rules/SKILL.md`, when `rules/apply-edits.sh` applies the planned edits, then the results below hold, while the live files stay byte-identical:
  - CLAUDE.md pipeline step 2 contains the `~/.claude/bin/claude-sync pull` line and says to stop on a conflict;
  - the privacy rule has the `Just-In-N-Out/claude-setup` carve-out;
  - a `## Setup sync (Mac ⇄ desktop)` section sits before the worktrees section;
  - feature-dispatch Phase 1 has the same pull line and stays under 100,000 characters;
  - git-commit-rules carries the carve-out in its three places;
  - reversing the edits restores the exact original bytes, a second apply changes nothing, and a missing or doubled anchor writes nothing.

  Test: `ac16_rule_edits_apply_cleanly`.
- AC17 (proposed): Given a copy of the live `settings.json`, when `rules/settings-hooks.jq` runs, then it adds exactly four entries:
  - PostToolUse `Edit|Write|MultiEdit|NotebookEdit` → `setup-sync-on-edit.sh`;
  - Stop → `setup-sync-on-edit.sh`;
  - SessionStart → `setup-sync-pull.sh` (timeout 20);
  - UserPromptSubmit → `setup-sync-pull.sh`.

  Every existing hook and key stays as it was, and running it twice gives the same result. Test: `ac17_settings_hooks_registration`.
- AC18 (proposed): `~/.claude/setup/mac.md` and `~/.claude/setup/desktop.md` exist and contain the required phrases (list in "Test specs"). The required points are:
  - the daily flow;
  - sync working the same in both directions;
  - Leorna setup files syncing while code repos are never auto-pulled;
  - on the desktop: WSL2/Ubuntu, VS Code through the WSL extension (never a plain `C:\` folder), first-time setup and troubleshooting.

  Every `claude-sync <subcommand>` and `~/…` path they mention exists in the build, and their numbers match it (20 s debounce, 600 s launchd, the bootstrap URL). `README.md` is a short index. The CLAUDE.md "Setup sync" text points macOS to `mac.md` and Linux/WSL to `desktop.md`. Test: `ac18_machine_guides_match_build`.
- AC19 (proposed): The full `setup-sync.test.sh` suite (AC1–AC15) passes inside an Ubuntu 24.04 container as a non-root user, with no network and gitleaks 8.30.1. It also passes on macOS under `/bin/bash` 3.2. Test: `ac19_linux_parity`.
- AC20 (proposed) (live): After the finisher's first real push, all of the following hold:
  - `Just-In-N-Out/claude-setup` is **private**;
  - a fresh bare clone from GitHub has the same HEAD as `~/.claude-setup.git`;
  - its tree has no `.env`, `auth.json`, `config.yaml`, `state.db`, `.claude.json`, `evidence/` or `private/` path, no symlink and no blob over 5 MB, but does have `.claude/CLAUDE.md`;
  - every commit is by `Justin <issajustin04@gmail.com>` with no AI co-author line;
  - `gitleaks git` over the whole history finds nothing.

  Test: `ac20_first_push_clean`.
- AC21 (proposed) (live): On the Mac, in a **new** Claude Code session, editing a line of a real skill with the Edit tool produces a commit on GitHub within about a minute. The launchd job `com.justin.claude-sync` is loaded, and its log shows a cycle at least every 10 minutes. Test: `ac21_mac_end_to_end`.
- AC22 (proposed) (live): On the desktop, after `bootstrap.sh`, a skill edit made there reaches the Mac within 10 minutes through launchd, with no Claude session open on the Mac. A Mac edit reaches the desktop at its next session start or plan start. A pipeline run there loads the same skills and hooks. Test: `ac22_desktop_round_trip`.

`(live)` ACs: AC20, AC21 and AC22 need real GitHub, a new session or the desktop, so the verifier and auditor mark them `not_run`. The finisher produces AC20's evidence. AC21 and AC22 are Justin's.

## Facts checked on this Mac (2026-10-25, read-only)

| Fact | Evidence |
|---|---|
| The personal key is **not** accepted by GitHub, and Just-In-N-Out has no SSH keys | `ssh -v -T git@github.com` → offers `id_ed25519` → "Permission denied (publickey)"; `curl https://github.com/Just-In-N-Out.keys` → empty |
| `Just-In-N-Out/claude-setup` doesn't exist yet; the token can create it | `gh repo view` → "Could not resolve"; scopes `gist, read:org, repo` |
| `LeornaAI/skills-library` is **private** (an anonymous clone fails) | `git -c credential.helper= ls-remote https://github.com/LeornaAI/skills-library.git` → "could not read Username" |
| The library clone has **8** locally edited files (24.5 KB diff), but `skills-library-local.patch` covers only 2. The patch is stale. | `git -C ~/.hermes/skills-library diff --stat`; head of the patch file |
| `update-skills-library.sh` re-applies the patch only for files the clone already has edited, so a fresh clone never gets it | script lines 28–47 (`edited=$(git diff --name-only)`) |
| Claude Code's project folder name = `path.replace(/[^a-zA-Z0-9]/g,"-")`, with a hash suffix over 200 chars | binary 2.1.310: `function M(t){let e=t.replace(/[^a-zA-Z0-9]/g,"-");if(e.length<=O)return e;…` with `O=200` |
| `-Users-justin-Leorna-leorna-control-plane/memory` is a symlink to `../-Users-justin-Leorna-leorna-client/memory` | `readlink` |
| The would-be first push is 877 files, 9.9 MB, none over 1 MB | scratch copy of the manifest set, plus `find -size` |
| gitleaks on that set: **2 false positives**, the `sourcegraph-access-token` rule matching commit SHAs in two figma-to-bricks plans. A rule-targeted allowlist clears them, and a real `sgp_` token is still caught. | `gitleaks dir --redact`; re-run with the allowlist → 0; stdin probe → exit 7 |
| gitleaks works on this layout in `git --staged`, `stdin`, `dir` and full-history modes | probes p2 (exit 7 on the planted token in each mode) |
| `git add` with several pathspecs fails **entirely** (exit 128, adds nothing) when one matches nothing; an explicit ignored path gives exit 1; glob pathspecs skip excluded files; adding a directory **stages symlinks** | probe p1 |
| A two-sided edit makes `git rebase` stop (`rebase-merge` present); `rebase --abort` restores the local commit. An untracked local file that upstream adds makes the integration fail ("would be overwritten") | probe p4 |
| Global git config has `pull.ff=only`; global excludes `~/.config/git/ignore` holds `**/.claude/settings.local.json`; there is no `core.hooksPath` | `git config --global --list` |
| Docker 28.4.0 (linux/aarch64) is available and `ubuntu:latest` is pulled. Stock Ubuntu has no git, jq or `shasum`, runs as root, and has mawk, bash 5.2, `setsid` and perl | `docker info`; probe container |
| macOS `/bin/bash` is 3.2.57. Homebrew bash 5.3 is first in the interactive PATH, but launchd's PATH is minimal. `timeout` is Homebrew-only; `/usr/bin/jq` 1.7.1, `/usr/bin/plutil` and `/usr/bin/perl` 5.34 exist | `command -v`, `--version` |
| Existing hooks have no Mac-only commands | grep for `stat -f`, `date -j`, `sed -i`, `readlink -f`… → none |
| `feature-dispatch/SKILL.md` is 95,572 chars, near Hermes' 100,000 limit | `wc -c` |
| `git-commit-rules` repeats the rule at lines 27, 44 and 90; no other skill does | `grep -rn` over `~/.hermes/skills` |
| `settings.json` hook events in use today: PostToolUse (no matcher), UserPromptSubmit, SubagentStop, PreToolUse:SubagentHandback; no SessionStart or Stop | `jq .hooks` |
| `~/.claude/skills/synced/` is a real folder (claude.ai-managed skills); every other entry is a symlink | `ls -la` |
| No skill or memory path contains `/evidence/`, `/private/`, `*.pem`, `*.key` or `id_*`, so the denylist can't hit a real skill file | `find` |
| `~/claude-setup-dev` and `~/.claude-setup.git` don't exist; the evidence folder exists | `ls` |

## Design

### Where it's built, and how the rule changes are carried

- **Dev repo `~/claude-setup-dev`:** local only, outside `~/Leorna`, no remote, never pushed. It uses the personal identity because it isn't under `~/Leorna/`.
  - Its `main` holds one **base commit**: `README.md` (what the repo is and that it's never pushed) and `home/.hermes/scripts/update-skills-library.sh`, a byte-for-byte snapshot of the current script that the tests run.
  - The builder works on `feat/setup-sync`. ac-check's base is `git -C ~/claude-setup-dev merge-base HEAD main`.
  - `home/` mirrors `$HOME`, so `home/.claude/bin/claude-sync` installs to `~/.claude/bin/claude-sync`.
  - Its `.git/info/exclude` lists `CLAUDE.md`, and a check in every test run asserts `git ls-files | grep -i claude.md` is empty.
- **Rule changes are carried as anchored edit pairs plus a jq filter, never as copies of the files.**
  - `rules/<target>/NN-name.old` and `.new` hold exact text. `rules/apply-edits.sh` applies them only if every `.old` occurs exactly once (or its `.new` already does), and writes once, atomically.
  - `rules/settings-hooks.jq` adds the hook entries structurally and idempotently.

  Why:
  1. The global rule forbids committing `CLAUDE.md` files to any repository. The carve-out arrives with this story and covers only `Just-In-N-Out/claude-setup`, not a dev repo.
  2. Other sessions edit `CLAUDE.md`, `feature-dispatch` and `settings.json` within minutes of each other (memory note "concurrent sessions share skill files"). A whole-file copy goes stale and would silently drop their edits. An exact-once anchor fails loudly instead, and jq edits only the `hooks` key.
  3. The same files that were tested are what the finisher applies.

### Files (dev repo layout; `home/…` installs to `~/…`)

| Path | Role |
|---|---|
| `README.md` (base) | dev repo note |
| `home/.hermes/scripts/update-skills-library.sh` (base) | unchanged snapshot, used by the tests; not reinstalled |
| `home/.claude/bin/claude-sync` | the sync tool (bash, macOS 3.2 + GNU) |
| `home/.claude/hooks/setup-sync-on-edit.sh` | PostToolUse + Stop (push side) |
| `home/.claude/hooks/setup-sync-pull.sh` | SessionStart + UserPromptSubmit (pull side + notices) |
| `home/.claude/hooks/tests/setup-sync.test.sh` | AC1–AC15 |
| `home/.claude/setup/manifest.txt`, `exclude.txt`, `projects.tsv`, `gitleaks.toml` | what syncs |
| `home/.claude/setup/bootstrap.sh` | desktop first-time setup |
| `home/.claude/setup/install-launchd.sh`, `home/.claude/setup/launchd/com.justin.claude-sync.plist` | Mac launchd job |
| `home/.claude/setup/mac.md`, `desktop.md`, `README.md` (2-line index) | machine guides |
| `rules/targets.tsv`, `rules/apply-edits.sh`, `rules/claude-md/*`, `rules/feature-dispatch/*`, `rules/git-commit-rules/*`, `rules/settings-hooks.jq` | one-time rule edits (dev-only) |
| `tests/rule-edits.test.sh` (AC16, AC17), `tests/guides.test.sh` (AC18), `tests/linux-parity.test.sh` + `tests/linux/Dockerfile` (AC19), `tests/finisher/first-push-audit.sh` (AC20) | dev-only tests |

Not changed: `~/.hermes/scripts/update-skills-library.sh` (reused as is) and `merge_lock.sh` (Hermes-only, Mac-only `stat -f`, out of scope; see "Other things found").

### What syncs: `home/.claude/setup/manifest.txt`

```
# Setup sync manifest: git pathspecs relative to $HOME, one per line.
# Only paths matched here are ever added. exclude.txt and claude-sync's built-in
# denylist still win. The next sync uses your edits.
.claude/CLAUDE.md
.claude/settings.json
:(glob).claude/hooks/*.sh
:(glob).claude/hooks/tests/**
.claude/bin/claude-sync
:(glob).claude/setup/**
:(glob).claude/projects/*/memory/**
:(glob).claude/project-docs/*/CLAUDE.md
:(glob).claude/plans/*.md
:(glob).hermes/skills/**
.hermes/skills-library-keep.txt
.hermes/skills-library-claude.txt
.hermes/skills-library-merged.txt
.hermes/skills-library-local.patch
:(glob).hermes/scripts/*.sh
:(glob).hermes/scripts/*.py
.hermes/SOUL.md
.hermes/memories/MEMORY.md
.hermes/memories/USER.md
:(glob).hermes/plans/**/*.md
:(glob).hermes/plans/**/briefs/**
```

`home/.claude/setup/exclude.txt` (copied into `~/.claude-setup.git/info/exclude` on every run, followed by one anchored line per symlink found under `.hermes/skills`, `.claude/skills` and `.claude/projects`):

```
# Setup sync excludes (gitignore syntax, anchored at $HOME).
/.hermes/plans/**/evidence/
/.hermes/plans/**/private/
/.hermes/skills/.hub/
/.hermes/skills/.locks/
/.hermes/skills/.curator_ledger.jsonl
/.hermes/skills/.curator_state
/.hermes/skills/.bundled_manifest
/.hermes/skills/.usage.json
/.hermes/skills/.usage.json.lock
/.hermes/skills-library/
/.claude/hooks/state/
/.claude/skills/
.DS_Store
__pycache__/
*.pyc
.env
.env.*
auth.json
config.yaml
state.db
state.db-*
*.setup-sync-tmp
```

**Built-in denylist** (inside `claude-sync`, applied to every staged path whatever the manifest or exclude file say; a hit is unstaged, recorded as `denied` and halts the push):

```bash
DENY_RE='(^|/)\.env($|\.)|(^|/)auth\.json$|(^|/)config\.yaml$|(^|/)state\.db($|-)|^\.claude\.json|(^|/)evidence/|(^|/)private/|^\.ssh/|^\.gnupg/|^\.claude-setup\.git/|^\.hermes/(cache|sessions|hermes-agent|skills-library)/|^\.claude/(history\.jsonl|sessions/|file-history/|plugins/|session-env/|shell-snapshots/|telemetry/|paste-cache/|debug/|daemon|hooks/state/|skills/)|\.(pem|key|p12|pfx)$|(^|/)id_(rsa|ed25519|ecdsa)'
```

Plus any staged entry with mode `120000` (symlink).

`home/.claude/setup/gitleaks.toml`:

```toml
# gitleaks config for setup sync (claude-sync's secret gate and the first-push audit).
# Default rules, plus narrow allowlists for proven false positives only.
[extend]
useDefault = true

[[allowlists]]
description = "git commit SHAs in plans are not Sourcegraph tokens (2 hits in figma-to-bricks plans, 2026-10-25)"
targetRules = ["sourcegraph-access-token"]
regexTarget = "secret"
regexes = ['''^[0-9a-f]{7,40}$''']
```

`home/.claude/setup/projects.tsv` (tab-separated; Q1 A). The columns are `name`, `mac_path`, `desktop_path`, `memory` and `claude_md`. `memory` is the **Mac** memory folder name under `~/.claude/projects` that this project's memory lives in (`-` for none), so the shared control-plane/client folder is explicit. `claude_md` says whether the project's `CLAUDE.md` copy-syncs. Desktop paths default to the same `$HOME`-relative layout; Justin can edit them.

```
# name	mac_path	desktop_path	memory	claude_md
leorna	/Users/justin/Leorna	/home/justin/Leorna	-Users-justin-Leorna	no
leorna-client	/Users/justin/Leorna/leorna-client	/home/justin/Leorna/leorna-client	-Users-justin-Leorna-leorna-client	no
leorna-control-plane	/Users/justin/Leorna/leorna-control-plane	/home/justin/Leorna/leorna-control-plane	-Users-justin-Leorna-leorna-client	no
figma-to-bricks	/Users/justin/Documents/FigmaToBricksV2	/home/justin/Documents/FigmaToBricksV2	-Users-justin-Documents-FigmaToBricksV2	yes
figma-plugin	/Users/justin/Desktop/FigmaPlugin	/home/justin/Desktop/FigmaPlugin	-Users-justin-Desktop-FigmaPlugin	yes
rise	/Users/justin/Rise	/home/justin/Rise	-Users-justin-Rise	yes
rise-backend	/Users/justin/Desktop/rise-backend	/home/justin/Desktop/rise-backend	-	yes
minimalog	/Users/justin/Documents/weightstone-journal	/home/justin/Documents/weightstone-journal	-Users-justin-Documents-weightstone-journal	yes
weightstone-journal	/Users/justin/weightstone-journal	/home/justin/weightstone-journal	-	yes
3dsearch	/Users/justin/3DSearch	/home/justin/3DSearch	-Users-justin-3DSearch	yes
appsec-project	/Users/justin/Desktop/APPSec-Project	/home/justin/Desktop/APPSec-Project	-Users-justin-Desktop-APPSec-Project	yes
personal-website	/Users/justin/JustinPersonalWebsite	/home/justin/JustinPersonalWebsite	-	yes
```

(Q1 B keeps only the `figma-to-bricks` and `figma-plugin` rows with `yes`; Q1 C sets every `claude_md` to `no`. Leorna rows always stay `no`.)

### `claude-sync` interface

```
claude-sync init --remote <url>        Mac, first time: create ~/.claude-setup.git, first local commit (no push)
claude-sync attach --remote <url>      second machine: configure the bare repo, back up clashing files, check out
claude-sync push [--quiet] [--allow-deletes]
claude-sync pull [--quiet|--hook]
claude-sync cycle [--quiet]            pull, then push (what launchd runs)
claude-sync status                     flags, conflicting files and where both versions are, ahead/behind
claude-sync resolve                    finish a conflict after the files hold the merged text
claude-sync is-tracked <path>          exit 0 if an edit to <path> syncs, 1 if not (fast)
claude-sync notice                     one paragraph for Claude when a conflict or block is open; empty otherwise
claude-sync maybe-cycle                start a background cycle if the last one is older than SETUP_SYNC_CYCLE_EVERY_SECS
claude-sync debounce [--now]           mark an edit pending; start the background worker (used by the hook)
claude-sync link-memory                desktop: (re)create memory links from projects.tsv
claude-sync help                       prints the usage line, listing exactly the subcommands above
```

**Exit codes:**
- 0: ok, nothing to do, or offline (one note line);
- 1: unexpected error;
- 2: usage error, or not set up (no `~/.claude-setup.git`; `--quiet`/`--hook` turn this into a quiet 0);
- 3: conflict (a new one, or the flag is still open);
- 4: push halted by a gate (`secret`, `denied`, `mass-delete`, `no-gitleaks`);
- 5: `pull` gave up waiting for the lock.

**Environment** (defaults in brackets; the tests override them):
- timing: `SETUP_SYNC_DEBOUNCE_SECS` [20], `SETUP_SYNC_MAX_WAIT_SECS` [120], `SETUP_SYNC_PULL_TIMEOUT_SECS` [10] (fetch inside SessionStart), `SETUP_SYNC_NET_TIMEOUT_SECS` [60] (fetch/push elsewhere), `SETUP_SYNC_LOCK_WAIT_SECS` [60] (pull), `SETUP_SYNC_CYCLE_EVERY_SECS` [600];
- limits: `SETUP_SYNC_MAX_BYTES` [5242880], `SETUP_SYNC_MAX_DELETES` [25];
- machine and tools: `SETUP_SYNC_MACHINE` [`mac` if `uname -s` is Darwin, else `desktop`], `SETUP_SYNC_HOST` [`uname -n | cut -d. -f1`], `SETUP_SYNC_GITLEAKS` [`command -v gitleaks`, else `/opt/homebrew/bin/gitleaks`, else `/usr/local/bin/gitleaks`], `SETUP_SYNC_SSH` [`ssh -o BatchMode=yes -o ConnectTimeout=10`], `SETUP_SYNC_BIN` (hooks only).

**State** (per machine, never synced):
- `~/.claude/hooks/state/setup-sync-conflict`, the design's path;
- `~/.claude/hooks/state/setup-sync-blocked`;
- in `~/.claude/hooks/state/setup-sync/`: `sync.lock/`, `worker.lock/`, `pending`, `flush`, `again`, `log` (trimmed to its last 1000 lines once it passes 2000), `launchd.log`, `project-docs.tsv` (name → last-synced blob hash), `library-diff.sha`, `last-cycle`, and `conflicts/` (the other side's versions).

Flag files are TSV after `#` header lines, and never contain a secret value:

```
# setup sync conflict, 2026-10-25T12:00:00Z, host Justins-MacBook-Pro, local 1a2b3c4 vs remote 5d6e7f8
file	.hermes/skills/software-development/leorna/SKILL.md
untracked	.claude/projects/-Users-justin-Leorna/memory/new-note.md
dirty	.hermes/plans/leorna/x.md
project-doc	figma-to-bricks	/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md
```
```
# setup sync blocked, 2026-10-25T12:00:00Z
secret	.hermes/plans/x.md	github-pat	12
too-big	.hermes/plans/big.md	6291456
denied	.hermes/.env
mass-delete	30
no-gitleaks
library-patch	skills/alpha/SKILL.md
```
`too-big` and `library-patch` are warnings. The others halt the push. The flag is rewritten on every push from that run's findings, and removed when a run finds nothing.

### Push and pull, step by step

Common start, for every command except `help`, `is-tracked`, `notice` and `debounce`:
1. `unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX`, then export `GIT_TERMINAL_PROMPT=0`, `GIT_EDITOR=true` and `GIT_SSH_COMMAND="$SETUP_SYNC_SSH"`.
2. Set `HOME_REAL=$(cd -P "$HOME" && pwd -P)`.
3. Every git call goes through `g() { git --git-dir="$HOME/.claude-setup.git" --work-tree="$HOME" "$@"; }`.
4. Refuse with exit 1 if `core.worktree` isn't `$HOME`/`$HOME_REAL`.
5. Take the lock. If a `rebase-merge` or `rebase-apply` folder exists and no live lock holder does, run `g rebase --abort`, log it and continue (AC14).

- **capture** (local only):
  1. project docs, both directions (see "Project CLAUDE.md files");
  2. `library_capture` (see "Library patch");
  3. `write_exclude`.
- **stage:**
  1. Run `g add -A -- "<spec>"` once **per manifest line**. Exit 128 "did not match any files" and exit 1 "ignored" are fine; log anything else.
  2. Then the gates, in this order:
     - denylist and mode-120000 entries (unstage them, add `denied` entries);
     - mass delete: more than `MAX_DELETES` staged deletions without `--allow-deletes` → `g reset -q -- <those paths>`, add a `mass-delete N` entry;
     - size: for each staged A/M path, `g cat-file -s ":<path>"` over `MAX_BYTES` → unstage (`g rm -q --cached` if new, `g reset -q --` if modified) and add a `too-big` entry;
     - **gitleaks** on the staged A/M paths: export them with `g checkout-index -z --stdin --prefix="$tmp/x/"`, run `"$GITLEAKS" dir --config "$HOME/.claude/setup/gitleaks.toml" --no-banner --redact --exit-code 7 --report-format json --report-path "$tmp/r.json" "$tmp/x"`, and map `.File` back by stripping the `$tmp/x/` prefix.
  3. Gitleaks results: 0 → clean. 7 → unstage the hit paths, add `secret` entries (rule and line from `.RuleID`/`.StartLine`), halt. Anything else, or gitleaks missing → `no-gitleaks`, halt (fail closed).
- **commit:** only if something is staged.
  - Title: `sync(<host>): <path1>[, <path2>][, <path3>][ (+N more)]`.
  - Body: up to 50 paths.
  - Plain `g commit -q -m <title> -m <body>`: no `-c user.*` and no author flags, so the home's git identity is used. No co-author line, ever.
- **integrate** (after `fetch`, which runs under `with_timeout` with git and its ssh in their own process group):
  1. If `origin/main` is an ancestor of HEAD, do nothing.
  2. Pre-checks:
     - an upstream-added path (`g diff --name-only --diff-filter=A HEAD...origin/main`) that exists locally untracked: delete it if identical (`git hash-object` == `g rev-parse origin/main:<path>`), else add an `untracked` conflict;
     - a dirty tracked path (left dirty by a gate) that upstream also changes: add a `dirty` conflict.

     Any conflict → write the flag, return 3.
  3. `g rebase -q --autostash origin/main`. If it fails, collect `g diff --name-only --diff-filter=U` → `g rebase --abort` → `file` conflicts → return 3.
  4. On success, `post_apply <old HEAD> <new HEAD>`.
  5. **Never use `git pull`.** The Mac's global `pull.ff=only` would change its behaviour.
- **post_apply OLD NEW:** `changed=$(g diff --name-only OLD NEW)`, then:
  1. project docs (copy out);
  2. if the patch changed → `library_apply`;
  3. if any of `.hermes/skills-library-{keep,claude,merged}.txt` or the patch changed → `HERMES_HOME="$HOME/.hermes" "$BASH" "$HOME/.hermes/scripts/update-skills-library.sh"` (its output goes to the log; a failure is a logged warning);
  4. if `.claude/setup/projects.tsv` changed and the machine is the desktop → `link-memory`;
  5. record the pulled paths for the summary.
- **push** = lock (if it's busy: `touch $STATE/again`, exit 0) → capture → stage → commit. Then:
  - conflict flag open → exit 3;
  - halted by a gate → exit 4;
  - otherwise, if `g rev-list --count origin/main..HEAD` > 0 (or `origin/main` doesn't exist yet):
    1. fetch (offline → log "offline", exit 0);
    2. integrate;
    3. **pre-push scan:** `GIT_DIR=… GIT_WORK_TREE=… "$GITLEAKS" git --config … --no-banner --redact --exit-code 7 --log-opts="origin/main..HEAD" "$HOME"` (all commits on the first push) → a hit adds `secret` entries and exits 4;
    4. `g push -q origin HEAD:main` (if it's rejected: fetch + integrate + push once more).

  Before releasing the lock: if `$STATE/again` exists, remove it and run the whole sequence once more.
- **pull** = lock, waiting up to `LOCK_WAIT` (5 if still busy) → capture → stage → commit (no push) → conflict open → 3 → fetch with `PULL_TIMEOUT` when `--hook` is set, else `NET_TIMEOUT` (offline → quiet 0) → integrate.
  - Output: `--hook` prints one line only when files were pulled or a conflict appeared. Otherwise it prints `setup-sync: pulled N files (…)`, `setup-sync: up to date`, `setup-sync: offline, skipped` or `setup-sync: CONFLICT in <paths>, run claude-sync status`.
- **cycle** = pull, then push unless the pull returned 3. It writes `last-cycle` and exits with the worse code.
- **init:**
  1. Refuse if `~/.claude-setup.git` exists.
  2. `git init --bare -b main`, then set `core.bare=false`, `core.worktree=$HOME`, `status.showUntrackedFiles=no`, `core.excludesFile=/dev/null` (so the global ignore file can't hide anything) and `remote add origin <url>`.
  3. capture → stage → gates (a halt → exit 4, no commit) → commit `sync(<host>): first sync of N files`. No push.
- **attach:**
  1. Run `git clone --bare <url>` unless the repo exists, then apply the same config.
  2. Set `remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*` (a bare clone has none) and fetch.
  3. For every path in `g ls-tree -r --name-only origin/main` that exists in `$HOME` as a symlink, or with a different blob hash, move it to `~/.claude-setup-backup-<UTC time>/<path>`.
  4. `g checkout -q -f -B main origin/main` → `g branch -q -u origin/main main` → `write_exclude`.
  5. Print the backup folder, if one was made.
- **status:** prints both flags in plain words. For each conflict, it names the local file and the saved other version (`$STATE/conflicts/<path>.remote`; for project docs, the project's own `CLAUDE.md` is the one to edit). It also prints ahead/behind (`g rev-list --left-right --count HEAD...origin/main` after a timed fetch) and the last log lines.
- **resolve** (exit 3 if no conflict is open):
  1. For `project-doc` entries, copy the project's `CLAUDE.md` over the repo copy. For a conflict on the patch, run `library_capture` with force, which regenerates the patch from the clone (Claude merged the library files).
  2. Refuse (exit 3) if any listed file still contains a line that starts with `<<<<<<< ` or `>>>>>>> `.
  3. Save each listed file's merged text to `$STATE/resolve/`.
  4. stage → gates → commit.
  5. `fetch`, then `g rebase -q origin/main`. At each stop:
     - if every conflicted path is a listed one: copy the saved merged text back in, `g add`, then `g rebase --continue`;
     - else: `rebase --abort`, add the new paths to the flag, exit 3.
  6. Afterwards, copy any listed file that differs from its saved merged text back in and commit.
  7. `post_apply`, then push, delete the flag and update the project-doc hashes.
- **is-tracked P** (must take well under 100 ms; no lock, no network):
  1. Canonicalize P: `cd -P` on its folder, plus the basename.
  2. A `claude_md=yes` project's `CLAUDE.md` on this machine's column → 0.
  3. Under `$HOME_REAL/.hermes/skills-library/skills/` and tracked by the library clone (`git -C "$LIB" ls-files --error-unmatch`) → 0.
  4. Outside `$HOME_REAL`/`$HOME`, or not under `.claude/` or `.hermes/`, or matching `DENY_RE` → 1.
  5. `g ls-files --error-unmatch -- <rel>` → 0.
  6. Otherwise, write `g ls-files --others --exclude-standard -- <manifest specs…>` to a temp file and `grep -Fxq` the rel path **in that file** (never `cmd | grep -q` under `pipefail`: SIGPIPE gives exit 141).

### Debounce, lock and recursion

- **The hook never slows a turn.**
  - The PostToolUse hook runs only `is-tracked` and `debounce`. Both are local and fast: no git writes, no network.
  - `debounce` writes `date +%s` into `$STATE/pending`, takes `worker.lock` with `mkdir`, and starts the worker with `detach`. It writes the worker's pid (`$!`) into `worker.lock/pid` at once. If `worker.lock` already holds a live pid, it just returns.
  - Stop runs `debounce --now`, which also touches `$STATE/flush`.
- **detach / process groups:** `new_group() { if command -v setsid >/dev/null 2>&1; then setsid "$@"; else perl -MPOSIX -e 'POSIX::setsid() >= 0 or die "setsid: $!"; exec @ARGV or die "exec: $!"' -- "$@"; fi; }` and `detach() { new_group "$@" </dev/null >>"$STATE/log" 2>&1 & }`.
  - The worker starts a new session, so a host that kills the hook's process group can't kill it (AC14).
  - Every background helper has stdin, stdout and stderr pointed away from the hook's pipes. Otherwise Claude Code waits for EOF.
- **Worker** (`_worker`, internal), as a loop:
  1. Read `pending`.
  2. Push once any of these holds:
     - `flush` exists;
     - `now - pending >= DEBOUNCE`;
     - `now - start >= MAX_WAIT` (a constant stream of edits still syncs every 2 minutes).
  3. After the push, if `pending` still holds the value read before it, remove `pending` and leave the loop. Otherwise loop again with a fresh `start`.
  4. On leaving: `rm -rf worker.lock`. If `pending` exists **after** that, re-take the lock and loop. This closes the race where an edit lands between the last check and the lock removal.
- **Sync lock:**
  - `mkdir $STATE/sync.lock` holds the holder's pid. A dead pid (`kill -0` fails), or no pid file and the folder older than 1 minute (`find -maxdepth 0 -mmin +1`), counts as stale and is removed.
  - push never waits: it sets `again`, and the holder runs once more before it releases the lock. pull waits up to `LOCK_WAIT`.
  - `trap` releases the lock on EXIT/INT/TERM.
- **with_timeout secs cmd…:**
  - It starts the command as `new_group cmd &`. A watcher `( sleep secs; …; kill -TERM -- -$pid; sleep 2; kill -KILL -- -$pid ) </dev/null >/dev/null 2>&1 &` kills git **and** its ssh child.
  - It returns 124 on timeout. It is used only around `fetch` and `push`. Local steps are never killed mid-way, so a rebase can't be cut in half.
  - The hook's own `timeout` in `settings.json` (20 s) is only a backstop, and a half-done rebase it might leave is recovered at the next start.
- **Recursion:**
  - `claude-sync` never edits files through Claude's tools, so it can't trigger PostToolUse. A pull's checkout, the patch apply and the relinking aren't tool calls either.
  - `is-tracked` refuses `.claude-setup.git/`, `.claude/hooks/state/` and `.claude/skills/` itself (the denylist), so state writes can't loop.
  - Stop fires once per main-session turn, and `stop_hook_active` is ignored.
- **Who triggers what:**
  - PostToolUse: push after 20 s of quiet.
  - Stop: an immediate background push, which catches Bash-made edits.
  - SessionStart: a pull, with the fetch bounded to 10 s, quiet offline.
  - UserPromptSubmit: notices, plus `maybe-cycle` (Q4 A).
  - launchd on the Mac: `cycle` every 600 s, for Hermes edits and to bring desktop edits down.
  - The pipeline's step 2 and feature-dispatch Phase 1: `claude-sync pull`, stopping on exit 3.

### Conflict flow

1. Every run commits local edits first (capture → stage → commit), so nothing local is ever lost. A rebase conflict is aborted at once: the local commit stays, the remote is untouched, and the push is skipped.
2. `write_conflict` writes `~/.claude/hooks/state/setup-sync-conflict` and saves the other machine's version of each path to `$STATE/conflicts/<path>.remote` (`g show origin/main:<path>`; for project docs, the repo copy).
3. **Surfacing:** while the flag exists, `claude-sync notice` prints the following, and `setup-sync-pull.sh` adds it as `additionalContext` on SessionStart **and every UserPromptSubmit** (a 4th hook entry, so the hooks "keep telling Claude"):
   > Setup sync conflict (automatic hook): both machines changed <paths>. Nothing is pushed until it's fixed. Before other work, run `~/.claude/bin/claude-sync status`, edit each file so it keeps both sides' meaning (the other machine's version is saved where status says), then run `~/.claude/bin/claude-sync resolve`. Never discard either side.

   The pipeline's step 2 pull exits 3, so the orchestrator stops before planning.
4. **Resolve:** Claude edits the local files: a tracked file in place, a project doc in the project folder, or library skill files in the clone for a patch conflict. Then `claude-sync resolve` runs the steps above.
5. **Project docs** keep a per-machine hash state (`project-docs.tsv`). A doc changed on both sides since the last sync becomes a `project-doc` conflict, so one side never silently overwrites the other.
6. **Blocks** (`setup-sync-blocked`) are surfaced the same way. They clear themselves at the next push that finds nothing.

### Library patch (skills-library edits travel; no ping-pong)

- **`library_capture`**, with `D` = `git -C "$LIB" diff --no-color --no-ext-diff` (into a temp file) and `marker` = `$STATE/library-diff.sha`:
  - No clone → nothing to do.
  - **No marker yet** (this machine hasn't synced the library):
    - if `D` is non-empty, the local edits are the truth (this is the Mac at `init`): `PATCH := D`, `marker := sha(D)`;
    - else, if `PATCH` is non-empty, it's a fresh clone (desktop): run `library_apply`;
    - else, `marker := sha(empty)`.
  - **Marker present:**
    - if `sha(D) == marker`, nothing changed here since the last write or apply. If `PATCH` is modified against HEAD (for example rewritten by `update-skills-library.sh`), restore it with `g checkout -- .hermes/skills-library-local.patch`;
    - else, `PATCH := D` (temp file + `mv`) and `marker := sha(D)`.
- **`library_apply`:**
  1. `files = (git -C LIB diff --name-only) ∪ (paths from ^diff --git a/… b/… in PATCH)`.
  2. `git -C LIB checkout -q -- <files>`. This is safe because capture always runs first.
  3. Run `git -C LIB apply --include=<f> PATCH` per file, collecting failures. On a failure: copy `PATCH` to `$STATE/skills-library-local.patch.failed-<time>` and add a `library-patch` warning. As in `update-skills-library.sh`, upstream wins for that file.
  4. Finally, `marker := sha(new D)`.

  Recording the post-apply diff, not the patch bytes, is what stops two machines whose library clones sit at different upstream commits from rewriting the patch back and forth (AC9).
- `sha()` is `git hash-object`, because stock Ubuntu has no `shasum` and stock macOS has no `sha256sum`.

### Project `CLAUDE.md` files (copy-sync, `claude_md=yes` rows)

For each row, L = the project's `CLAUDE.md` on this machine's column, and R = `~/.claude/project-docs/<name>/CLAUDE.md`. B is the last-synced hash in `project-docs.tsv`.

- The project folder is missing on this machine → skip.
- L exists but isn't readable → skip with a log line. It is **never** treated as missing. On macOS, launchd's `/bin/bash` has no TCC access to `~/Documents`/`~/Desktop`, so launchd runs skip those, and hook runs inside Claude Code handle them.
- `hash(L) == hash(R)` → record B.
- Only one side exists:
  - with no B (first time), copy it to the other side and record B;
  - with B, it is a deletion: log it and **never propagate it**.
- Both exist and differ:
  - `hash(R) == B` → copy L→R (local edit);
  - `hash(L) == B` → copy R→L through `L.setup-sync-tmp` + `mv` (remote edit);
  - otherwise → a `project-doc` conflict, saving R to `$STATE/conflicts/project-docs/<name>.CLAUDE.md.remote`.

Capture runs this before staging (L→R), and `post_apply` runs it after a rebase (R→L).

### Hooks (complete code)

`home/.claude/hooks/setup-sync-on-edit.sh`:

```bash
#!/usr/bin/env bash
# Setup sync, push side (see ~/.claude/setup/mac.md or desktop.md).
# PostToolUse (Edit|Write|MultiEdit|NotebookEdit): if the edited file syncs, mark it
#   pending; claude-sync pushes after a quiet pause, in the background.
# Stop: flush: push now, in the background (catches edits made through Bash).
# Never blocks, never prints, always exits 0 within a fraction of a second.
# Tests: tests/setup-sync.test.sh
set -uo pipefail

SYNC=${SETUP_SYNC_BIN:-$HOME/.claude/bin/claude-sync}
[[ -f $SYNC ]] || exit 0
input=$(cat) || exit 0
# separate jq calls: IFS=$'\t' read collapses empty TSV fields (tab is IFS whitespace)
event=$(jq -r '.hook_event_name // ""' <<<"$input" 2>/dev/null) || exit 0

case $event in
  PostToolUse)
    path=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // ""' <<<"$input" 2>/dev/null) || exit 0
    [[ -n $path ]] || exit 0
    "$BASH" "$SYNC" is-tracked "$path" </dev/null >/dev/null 2>&1 || exit 0
    "$BASH" "$SYNC" debounce </dev/null >/dev/null 2>&1
    ;;
  Stop)
    [[ $(jq -r '.stop_hook_active // false' <<<"$input" 2>/dev/null) == true ]] && exit 0
    "$BASH" "$SYNC" debounce --now </dev/null >/dev/null 2>&1
    ;;
esac
exit 0
```

`home/.claude/hooks/setup-sync-pull.sh`:

```bash
#!/usr/bin/env bash
# Setup sync, pull side (see ~/.claude/setup/mac.md or desktop.md).
# SessionStart: pull now; the fetch gives up after SETUP_SYNC_PULL_TIMEOUT_SECS (10);
#   quiet when up to date or offline.
# UserPromptSubmit: nothing in the foreground; starts a background pull+push when the
#   last one is older than SETUP_SYNC_CYCLE_EVERY_SECS (600).
# Both: while a setup conflict or block is open, tell Claude every time.
# Tests: tests/setup-sync.test.sh
set -uo pipefail

SYNC=${SETUP_SYNC_BIN:-$HOME/.claude/bin/claude-sync}
[[ -f $SYNC ]] || exit 0
event=$(jq -r '.hook_event_name // ""' 2>/dev/null) || exit 0

note=""
case $event in
  SessionStart)     note=$("$BASH" "$SYNC" pull --hook </dev/null 2>/dev/null) ;;
  UserPromptSubmit) "$BASH" "$SYNC" maybe-cycle </dev/null >/dev/null 2>&1 ;;
  *) exit 0 ;;
esac
msg=$("$BASH" "$SYNC" notice </dev/null 2>/dev/null)
[[ -n $note ]] && msg="$note${msg:+ $msg}"
[[ -n $msg ]] || exit 0
jq -nc --arg e "$event" --arg m "$msg" '{hookSpecificOutput: {hookEventName: $e, additionalContext: $m}}'
exit 0
```

### launchd (Mac only)

`home/.claude/setup/launchd/com.justin.claude-sync.plist` (template; `install-launchd.sh` replaces `__HOME__`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.justin.claude-sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>__HOME__/.claude/bin/claude-sync</string>
        <string>cycle</string>
        <string>--quiet</string>
    </array>
    <key>StartInterval</key>
    <integer>600</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    <key>StandardOutPath</key>
    <string>__HOME__/.claude/hooks/state/setup-sync/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>__HOME__/.claude/hooks/state/setup-sync/launchd.log</string>
    <key>ProcessType</key>
    <string>Background</string>
    <key>LowPriorityIO</key>
    <true/>
</dict>
</plist>
```

`/bin/bash` is bash 3.2 on purpose. `claude-sync cycle` trims `launchd.log` to its last 1000 lines once it passes 1 MB.

`install-launchd.sh [--dry-run]`:
1. Refuse on non-Darwin unless `SETUP_SYNC_LAUNCHCTL` is set (tests).
2. `mkdir -p ~/.claude/hooks/state/setup-sync`.
3. Render with `sed "s#__HOME__#$HOME#g"` into `${SETUP_SYNC_LAUNCH_AGENTS:-$HOME/Library/LaunchAgents}/com.justin.claude-sync.plist`.
4. `plutil -lint` it when `plutil` exists.
5. `$LAUNCHCTL bootout gui/$(id -u)/com.justin.claude-sync 2>/dev/null; $LAUNCHCTL bootstrap gui/$(id -u) <plist>`, with `LAUNCHCTL=${SETUP_SYNC_LAUNCHCTL:-launchctl}`.

`--dry-run` prints those steps and writes nothing.

### Bootstrap and memory links (desktop)

`home/.claude/setup/bootstrap.sh`, run as `bash bootstrap.sh`. It is idempotent: every step checks first. The overrides are `SETUP_SYNC_REMOTE` [`git@github.com:Just-In-N-Out/claude-setup.git`], `SETUP_SYNC_LIBRARY_URL` [`https://github.com/LeornaAI/skills-library.git`; private, so `gh` must be signed in as Justin-Leorna with `gh auth setup-git`], `SETUP_SYNC_LEORNA_BASE` [`git@github-leorna:LeornaAI`] and `SETUP_SYNC_NO_SELFTEST=1`.

0. **Preflight:** `git`, `jq` and `gitleaks` exist. On Darwin, refuse unless `--force` (the Mac uses `init`).
1. **Identity:** for each of `user.name=Justin`, `user.email=issajustin04@gmail.com`, `includeIf.gitdir:~/Leorna/.path=~/.gitconfig-leorna` and `init.defaultBranch=main`:
   - unset → set it with `git config --global`;
   - set to the same value → leave it;
   - set to a different value → print it and **exit 1 before changing anything**.

   Then write `~/.gitconfig-leorna` (`Justin Issa` / `justin@leorna.com`) with `git config -f` if it's missing.
2. If `~/.claude-setup.git` is missing, `git clone --bare "$REMOTE"` into it.
3. Run `claude-sync attach --remote "$REMOTE"`, using `~/.claude/bin/claude-sync` if present, else `git --git-dir=… show main:.claude/bin/claude-sync` extracted to a temp file.
4. Check `gitleaks dir --config ~/.claude/setup/gitleaks.toml <empty temp dir>` exits 0. This is a functional check that the installed gitleaks reads the allowlist format. Otherwise, stop with "install gitleaks 8.30.1".
5. Unless `~/.hermes/skills-library/.git` exists, `git clone "$LIBRARY_URL" ~/.hermes/skills-library`. Then:
   - `claude-sync pull --quiet` (its capture applies the patch: no marker yet + clean clone);
   - `HERMES_HOME="$HOME/.hermes" bash ~/.hermes/scripts/update-skills-library.sh` (links the Hermes and Claude skills).
6. Leorna code: for each of `leorna-client`, `leorna-control-plane` and `codex-skills`, if `~/Leorna/<r>` exists, **leave it alone**. Otherwise `git clone "$LEORNA_BASE/<r>.git" ~/Leorna/<r>`. There is **no fetch or pull**, ever, here or in `claude-sync`.
7. `claude-sync link-memory`. For each `projects.tsv` row with `memory != -`:
   - `D = encode(desktop_path)`, with `encode() { printf '%s' "$1" | LC_ALL=C tr -c 'A-Za-z0-9' '-'; }` (skip with a warning over 200 chars);
   - `mkdir -p ~/.claude/projects/$D ~/.claude/projects/<memory>/memory`;
   - the link is `~/.claude/projects/$D/memory`, and the wanted target is `../<memory>/memory`. If the link is right, leave it; if it's a wrong link, replace it. If it's an empty folder, replace it. If it's a non-empty folder, move each file into the target when there's no clash or the bytes are identical; on a real clash, move the folder into the backup folder; then link. If nothing is there, `ln -s`.
8. Unless `SETUP_SYNC_NO_SELFTEST=1`, run `bash` on each `~/.claude/hooks/tests/*.test.sh` and print passed/failed for each. A failure doesn't stop bootstrap, but it is printed loudly.
9. Print the next steps: start `claude` once, install the 4 plugins, `claude mcp add` ClickUp and sign in, and open projects through VS Code's WSL extension (desktop.md).

### Machine guides (scope added by Justin)

`home/.claude/setup/mac.md` and `desktop.md` sync to both machines, and replace the planned README. `README.md` becomes a 2-line index:

```
# Setup sync
macOS: read mac.md. Linux/WSL (the Windows desktop): read desktop.md.
```

Both guides are plain words for Justin and for Claude, short sections, with these points. AC18 checks the phrases listed in "Test specs".

- **mac.md:**
  - Hermes runs here and reads skills from disk without Claude.
  - The launchd job `com.justin.claude-sync` runs pull then push every 10 minutes: where its log is, and how to check it's loaded (`launchctl print gui/$(id -u)/com.justin.claude-sync`).
  - The triggers: an edit is pushed after about 20 seconds, the end of every turn flushes, session start pulls, and before a plan the orchestrator pulls.
  - What syncs and what never does.
  - Conflicts (`claude-sync status` / `resolve`) and blocks (gitleaks, 5 MB, mass delete).
  - Sync works the same in both directions: a desktop edit reaches the Mac at session start, at plan start, or within 10 minutes through launchd.
  - Leorna setup files sync, but the code repos (leorna-client, leorna-control-plane, codex-skills) are never auto-pulled.
  - A link to desktop.md.
- **desktop.md:**
  - Ubuntu runs inside Windows through WSL2, and Claude Code lives there.
  - Daily flow: open VS Code → the WSL extension → the **><** button "Connect to WSL", or `code .` from Ubuntu. The bottom-left shows "WSL: Ubuntu" and the prompt looks like `justin@…:~/…$`. VS Code starts Ubuntu by itself. Start Claude with `claude`; the pull happens automatically.
  - Never open a project as a plain `C:\…` folder: the terminal would be PowerShell, and the hooks and sync don't run.
  - First-time setup: `wsl --install -d Ubuntu`; apt packages; gitleaks 8.30.1 from the release with a checksum check; Claude Code; new SSH keys for both accounts plus `~/.ssh/config` with the `github-leorna` alias; `gh auth login` for both accounts (keep Justin-Leorna active, `gh auth setup-git`); the bare clone (`git clone --bare git@github.com:Just-In-N-Out/claude-setup.git ~/.claude-setup.git`); extracting and running `bootstrap.sh`; plugins; the ClickUp MCP.
  - The same both-directions answer, from the desktop's side: a Mac edit reaches the desktop at session start, at plan start, or within 10 minutes of a prompt (Q4 A).
  - The same Leorna answer.
  - The Leorna client as a desktop app (Wails) is an **open question**.
  - Troubleshooting:
    - no hooks running (a `C:\` folder, or the session started before the hooks were added);
    - `Permission denied (publickey)`;
    - gitleaks too old;
    - the conflict notice;
    - offline.
  - A link to mac.md.

### Rule edits (exact text; applied by the finisher with `rules/apply-edits.sh`)

`rules/targets.tsv`:
```
claude-md	~/.claude/CLAUDE.md
feature-dispatch	~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md
git-commit-rules	~/.hermes/skills/software-development/git-commit-rules/SKILL.md
```

**`rules/apply-edits.sh <target> <edits dir> [--check|--reverse]`** (dev-only, runs on the Mac; it uses `/usr/bin/perl` for exact multi-line substring work):
- Load every `NN-*.old`/`NN-*.new` pair in name order. The exact bytes have no trailing newline unless the text needs one.
- For each pair:
  - `count(new) == 1` → already applied, skip;
  - `count(new) == 0 && count(old) == 1` → replace;
  - anything else → print `anchor <NN> found <k> times` and exit 1 **before writing anything**.
- Write once, through a temp file in the same folder + `mv`, after checking that the target's hash is still the one read at the start (a concurrent edit → exit 1).
- `--check` reports and writes nothing. `--reverse` swaps old and new.

`rules/claude-md/01-privacy.old` → `.new`:
```
- **Never** commit or push `CLAUDE.md` files to any repository
```
```
- **Never** commit or push `CLAUDE.md` files to any project repository. The one exception is the private setup repo `Just-In-N-Out/claude-setup` (the bare repo `~/.claude-setup.git`, with `$HOME` as its work tree): `~/.claude/bin/claude-sync` commits `~/.claude/CLAUDE.md` and copies of project `CLAUDE.md` files there on purpose, so never unstage or block them there (see "Setup sync" below)
```
`rules/claude-md/02-unstage.old` → `.new`:
```
- Before any commit, verify `CLAUDE.md` is not staged. If it is, unstage it.
```
```
- Before any commit in a project repo, verify `CLAUDE.md` is not staged. If it is, unstage it.
```
`rules/claude-md/03-step2.old` → `.new`:
```
2. **Planner:** writes `~/.hermes/plans/<project>/<name>.md`
```
```
2. **Planner:** right before dispatching it, the main session runs `~/.claude/bin/claude-sync pull` so both machines plan from the same skills; if it reports a conflict (exit 3), stop and resolve that first ("Setup sync" below). The planner writes `~/.hermes/plans/<project>/<name>.md`
```
`rules/claude-md/04-setup-sync.old` → `.new` (the `.new` is the section, a blank line, then the old heading):
```
## Worktrees from `claude -w` — Finishing a Feature
```
```
## Setup sync (Mac ⇄ desktop)

This setup syncs between the Mac and the Windows desktop (Ubuntu in WSL2) through the private repo `Just-In-N-Out/claude-setup`: the bare repo `~/.claude-setup.git` with `$HOME` as its work tree. `~/.claude/setup/manifest.txt` lists what syncs: this file, `settings.json`, the hooks, Hermes skills and memories, Claude memory notes, plans and briefs, and copies of project `CLAUDE.md` files. Secret files (`.env`, `auth.json`, `config.yaml`, `state.db`, `~/.claude.json`) and evidence never sync.
- **It runs by itself:** an edit to a synced file is pushed about 20 seconds later, each turn's end flushes, and every session start pulls. On the Mac, launchd also runs `claude-sync pull` then `push` every 10 minutes, for Hermes's own edits. gitleaks checks every commit: a hit stops the push until it's fixed.
- **Before a plan:** run `~/.claude/bin/claude-sync pull` right before dispatching the planner (pipeline step 2), and stop on a conflict.
- **Conflict:** when both machines changed the same text, nothing is pushed and the hooks say "setup sync conflict" on every prompt. Run `~/.claude/bin/claude-sync status`, edit each named file so it keeps both sides' meaning, then run `~/.claude/bin/claude-sync resolve`.
- Leorna *setup* files sync; the Leorna *code* repos are never auto-pulled (normal Leorna git rules).
- **More:** on macOS read `~/.claude/setup/mac.md`; on Linux/WSL read `~/.claude/setup/desktop.md`.

## Worktrees from `claude -w` — Finishing a Feature
```
`rules/feature-dispatch/01-phase1.old` → `.new`:
```
## Phase 1: Dispatch the planner

Before dispatch, reuse the just-verified card
```
```
## Phase 1: Dispatch the planner

Right before dispatching the planner, run `terminal(command="~/.claude/bin/claude-sync pull")` so both machines plan from the same skills (it syncs `~/.claude` and `~/.hermes` through the private repo `Just-In-N-Out/claude-setup`). Exit 3 or a `CONFLICT` line means both machines changed the same file: stop and resolve it first (`claude-sync status`, keep both sides' meaning, `claude-sync resolve`).

Before dispatch, reuse the just-verified card
```
`rules/git-commit-rules/01-privacy.old` → `.new`:
```
- `CLAUDE.md` files are never committed or pushed.
```
```
- `CLAUDE.md` files are never committed or pushed to a project repo. The one exception is Justin's private setup repo `Just-In-N-Out/claude-setup` (`~/.claude-setup.git`, work tree `$HOME`), where `~/.claude/bin/claude-sync` commits them on purpose.
```
`rules/git-commit-rules/02-procedure.old` → `.new`:
```
2. `terminal(command="git diff --cached --name-only")` lists no `CLAUDE.md`.
```
```
2. In a project repo, `terminal(command="git diff --cached --name-only")` lists no `CLAUDE.md`.
```
`rules/git-commit-rules/03-verification.old` → `.new`:
```
- `git ls-files | grep -i claude.md` prints nothing.
```
```
- In a project repo, `git ls-files | grep -i claude.md` prints nothing (the setup repo `~/.claude-setup.git` tracks them on purpose).
```

`rules/settings-hooks.jq`:

```jq
# Adds the setup-sync hooks to ~/.claude/settings.json; keeps everything else; idempotent.
def add(ev; entry):
  .hooks[ev] = ((.hooks[ev] // [])
    | if any(.[]?; any(.hooks[]?; .command == entry.hooks[0].command)) then . else . + [entry] end);
.hooks //= {}
| add("PostToolUse"; {matcher: "Edit|Write|MultiEdit|NotebookEdit",
    hooks: [{type: "command", command: "~/.claude/hooks/setup-sync-on-edit.sh", timeout: 10}]})
| add("Stop"; {hooks: [{type: "command", command: "~/.claude/hooks/setup-sync-on-edit.sh", timeout: 10}]})
| add("SessionStart"; {hooks: [{type: "command", command: "~/.claude/hooks/setup-sync-pull.sh", timeout: 20}]})
| add("UserPromptSubmit"; {hooks: [{type: "command", command: "~/.claude/hooks/setup-sync-pull.sh", timeout: 10}]})
```

### Portability rules (every new script; macOS bash 3.2 + BSD tools, Ubuntu bash 5 + GNU + mawk)

- **Bash 3.2:** no `declare -A`, `mapfile`/`readarray`, `${x,,}`, `|&`, `[[ -v ]]`, `wait -n`, `local -n` or `$EPOCHSECONDS`. Under `set -u`, an empty array must be expanded as `${arr[@]+"${arr[@]}"}`.
- **No GNU-only or BSD-only flags:** no `sed -i`, `stat`, `date -d`/`-j`, `readlink -f`, `find -printf`, `xargs -r`, `grep -P`, `cp --parents`, `du -b`, `sort -V` or `timeout`/`gtimeout`.
- **Use instead:** `git hash-object` (hashes), `git cat-file -s` (sizes), `date +%s` (time), `find -maxdepth 0 -mmin +1` (age), `wc -c < f | tr -d ' '`, `LC_ALL=C tr -dc`, `sleep 0.2`, `uname -n`, POSIX awk only.
- **Never `cmd | grep -q` under `pipefail`** (SIGPIPE → 141). Write to a temp file, then grep it.
- **Never `IFS=$'\t' read` across fields that can be empty** (tabs collapse). Use separate `jq` calls or a non-whitespace separator.
- **Scripts call each other as `"$BASH" <script>`,** so the same bash runs everything (3.2 under `/bin/bash`).
- **Temp files** come from `mktemp -d "${TMPDIR:-/tmp}/setup-sync.XXXXXX"` and are removed in a trap.
- **`$HOME` may be reached through a symlink** (`/var` → `/private/var` on macOS). Compare canonical paths (`HOME_REAL`).

## Test harness: `home/.claude/hooks/tests/setup-sync.test.sh`

The rules every test follows:
- Each test builds fake homes `A` (mac) and `B` (desktop) plus a local bare `remote.git` under its own `mktemp -d` folder.
- It copies the scripts from `SRC`: the tree holding `.claude/` and `.hermes/`, which is the dev repo's `home/`, or the real `$HOME` once installed, **read only**.
- Inside every test subshell it sets `GIT_ALLOW_PROTOCOL=file`, `GIT_CONFIG_NOSYSTEM=1` and `SETUP_SYNC_LAUNCHCTL=/usr/bin/false`, and unsets `HERMES_HOME`, `GIT_DIR`, `GIT_WORK_TREE`, `GIT_INDEX_FILE`, `GIT_CONFIG_GLOBAL` and `GIT_SSH_COMMAND`.
- Nothing can reach the real `~/.claude`, `~/.hermes`, GitHub or launchd. `as()` refuses any `HOME` outside the temp root.
- Output is TAP. Diagnostics are `#   …` lines, which never use the words skip or todo.

Core (complete; the builder adds the other test functions in the same style):

```bash
#!/usr/bin/env bash
# Tests for ~/.claude/bin/claude-sync and the setup-sync hooks: AC1-AC15 of
# ~/.hermes/plans/claude-setup/setup-sync.md. Each test builds fake homes and a local
# bare "remote" in its own temp folder; nothing touches the real ~/.claude, ~/.hermes,
# GitHub or launchd. TAP output: "ok <n> - <name>".
#   bash ~/.claude/hooks/tests/setup-sync.test.sh              # all
#   bash ~/.claude/hooks/tests/setup-sync.test.sh <name> ...   # only these
set -uo pipefail

HERE=$(cd "$(dirname "$0")" && pwd -P)
SRC=$(cd "$HERE/../../.." && pwd -P)
BASH_BIN=$BASH
GITLEAKS_BIN=${SETUP_SYNC_GITLEAKS:-$(command -v gitleaks 2>/dev/null || echo /opt/homebrew/bin/gitleaks)}
ALL="ac1_tracked_edit_one_commit ac2_untracked_edit_no_commit ac3_secret_gate_blocks_push
ac4_large_file_refused ac5_excluded_paths_never_staged ac6_mass_delete_held
ac7_conflict_flag_no_push ac8_pull_updates_and_relinks ac9_library_edit_via_patch
ac10_project_docs_copy_sync ac11_cycle_pulls_then_pushes ac12_bootstrap_fresh_home
ac13_leorna_repos_not_auto_pulled ac14_lock_and_background_flush ac15_pull_triggers_fast_and_quiet"
BASE=$(mktemp -d "${TMPDIR:-/tmp}/setup-sync-test.XXXXXX") && BASE=$(cd "$BASE" && pwd -P) || { echo "Bail out! no temp dir"; exit 1; }
trap 'rm -rf "$BASE"' EXIT

# --- helpers (ROOT is the current test's folder) ---
check() { local d=$1; shift; if "$@"; then :; else echo "#   failed: $d"; FAILED=1; fi; }
match()    { [[ $1 =~ $2 ]]; }
no_match() { ! [[ $1 =~ $2 ]]; }
wait_until() { local n=$(( $1 * 5 )); shift; while ((n-- > 0)); do "$@" && return 0; sleep 0.2; done; "$@"; }
rgit() { git --git-dir="$ROOT/remote.git" "$@"; }
remote_count() { rgit rev-list --count main 2>/dev/null || echo 0; }
as() {  # as <name> <cmd...>: run in that fake home's environment
  local name=$1; shift
  case $ROOT/$name in "$BASE"/*) ;; *) echo "#   refusing HOME outside the temp root"; return 99 ;; esac
  ( export HOME="$ROOT/$name" SETUP_SYNC_MACHINE="$(cat "$ROOT/$name.machine")" SETUP_SYNC_HOST="host-$name"
    unset HERMES_HOME GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_CONFIG_GLOBAL GIT_SSH_COMMAND
    export GIT_CONFIG_NOSYSTEM=1 GIT_ALLOW_PROTOCOL=${GIT_ALLOW_PROTOCOL:-file} GIT_TERMINAL_PROMPT=0
    export SETUP_SYNC_DEBOUNCE_SECS=${SETUP_SYNC_DEBOUNCE_SECS:-2} SETUP_SYNC_MAX_WAIT_SECS=${SETUP_SYNC_MAX_WAIT_SECS:-10}
    export SETUP_SYNC_PULL_TIMEOUT_SECS=${SETUP_SYNC_PULL_TIMEOUT_SECS:-3} SETUP_SYNC_LOCK_WAIT_SECS=${SETUP_SYNC_LOCK_WAIT_SECS:-20}
    export SETUP_SYNC_GITLEAKS="$GITLEAKS_BIN" SETUP_SYNC_LAUNCHCTL=${SETUP_SYNC_LAUNCHCTL:-/usr/bin/false}
    cd "$HOME" && "$@" )
}
sync() { local name=$1; shift; as "$name" "$BASH_BIN" "$ROOT/$name/.claude/bin/claude-sync" "$@"; }
mk_remote() { git init -q --bare -b main "$ROOT/remote.git"; }
mk_home() {  # mk_home <name> <mac|desktop>: scripts + sample files, no repo yet
  local H="$ROOT/$1"
  mkdir -p "$H/.claude/bin" "$H/.claude/hooks/tests" "$H/.hermes/scripts" && echo "$2" >"$ROOT/$1.machine" || return 1
  printf '[user]\n\tname = Setup Test\n\temail = setup-test@example.invalid\n' >"$H/.gitconfig"
  cp "$SRC/.claude/bin/claude-sync" "$H/.claude/bin/" &&
    cp "$SRC/.claude/hooks/setup-sync-on-edit.sh" "$SRC/.claude/hooks/setup-sync-pull.sh" "$H/.claude/hooks/" &&
    cp "$SRC/.claude/hooks/tests/setup-sync.test.sh" "$H/.claude/hooks/tests/" &&
    cp -R "$SRC/.claude/setup" "$H/.claude/" &&
    cp "$SRC/.hermes/scripts/update-skills-library.sh" "$H/.hermes/scripts/" || return 1
  chmod 755 "$H/.claude/bin/claude-sync" "$H"/.claude/hooks/*.sh "$H/.hermes/scripts/update-skills-library.sh"
  printf '# name\tmac_path\tdesktop_path\tmemory\tclaude_md\n' >"$H/.claude/setup/projects.tsv"
  mkdir -p "$H/.hermes/skills/software-development/own" "$H/.claude/projects/-k-a/memory" "$H/.hermes/plans/p"
  printf '# test global rules\n' >"$H/.claude/CLAUDE.md"; printf '{}\n' >"$H/.claude/settings.json"
  printf 'own skill\n' >"$H/.hermes/skills/software-development/own/SKILL.md"
  printf '# keep\n' >"$H/.hermes/skills-library-keep.txt"; printf '# claude\n' >"$H/.hermes/skills-library-claude.txt"
  printf '# Memory\n' >"$H/.claude/projects/-k-a/memory/MEMORY.md"; printf 'plan\n' >"$H/.hermes/plans/p/plan.md"
}
seed_a() { mk_remote && mk_home A mac && sync A init --remote "$ROOT/remote.git" >/dev/null && sync A push >/dev/null; }
attach_b() { mk_home B desktop && sync B attach --remote "$ROOT/remote.git" >/dev/null; }
edit_json() { jq -nc --arg p "$1" '{hook_event_name: "PostToolUse", session_id: "s1", tool_name: "Edit", tool_input: {file_path: $p}}'; }
fire() {  # fire <name> <hook file> <json>: sets $out, $rc and $slow (1 if the hook ran past 1.5 s)
  local i=0 p
  ( printf '%s' "$3" | as "$1" "$BASH_BIN" "$ROOT/$1/.claude/hooks/$2" | cat >"$ROOT/hook.out"; echo $? >"$ROOT/hook.rc" ) &
  p=$!
  while kill -0 "$p" 2>/dev/null && ((i < 15)); do sleep 0.1; i=$((i + 1)); done
  if kill -0 "$p" 2>/dev/null; then slow=1; else slow=0; fi
  wait "$p"; out=$(cat "$ROOT/hook.out"); rc=$(cat "$ROOT/hook.rc")
}
settle() {  # let background workers of every fake home finish before the folder goes
  local l
  for l in "$1"/*/.claude/hooks/state/setup-sync/worker.lock "$1"/*/.claude/hooks/state/setup-sync/sync.lock; do
    [[ -e $l ]] || continue
    wait_until 30 test ! -e "$l" || kill "$(cat "$l/pid" 2>/dev/null)" 2>/dev/null
  done
}

# --- tests ---
t_ac1_tracked_edit_one_commit() {
  seed_a || { echo "#   setup failed"; return 1; }
  local f="$ROOT/A/.hermes/skills/software-development/own/SKILL.md" rel=".hermes/skills/software-development/own/SKILL.md" before after i
  before=$(remote_count)
  for i in 1 2 3; do
    printf 'edit %s\n' "$i" >>"$f"
    fire A setup-sync-on-edit.sh "$(edit_json "$f")"
    check "edit $i: the hook returned within 1.5 s" test "$slow" = 0
    check "edit $i: the hook printed nothing and exited 0" test -z "$out" -a "$rc" = 0
    sleep 0.3
  done
  wait_until 20 test "$(remote_count)" -ge $((before + 1))
  sleep 4   # past the 2 s debounce: a second commit would have landed by now
  after=$(remote_count)
  check "exactly one new commit on the remote ($before -> $after)" test "$after" -eq $((before + 1))
  check "the commit holds only the edited skill" test "$(rgit show --format= --name-only main)" = "$rel"
  check "the remote file has all three edits" match "$(rgit show "main:$rel")" 'edit 1.*edit 2.*edit 3'
  check "title is sync(host-A): <path>" test "$(rgit log -1 --format=%s main)" = "sync(host-A): $rel"
  check "author is the home's git identity" test "$(rgit log -1 --format='%an <%ae>' main)" = "Setup Test <setup-test@example.invalid>"
  check "no AI co-author line" no_match "$(rgit log -1 --format=%B main)" '[Cc]o-[Aa]uthored-[Bb]y'
  check "the worker has exited" wait_until 10 test ! -e "$ROOT/A/.claude/hooks/state/setup-sync/worker.lock"
}

# --- runner ---
want=${*:-$ALL}
n=0 fails=0
for t in $want; do
  n=$((n + 1))
  if ! declare -f "t_$t" >/dev/null; then echo "not ok $n - $t"; echo "#   no such test"; fails=$((fails + 1)); continue; fi
  # a test fails if any check failed OR the function returned non-zero (e.g. setup failed)
  if ( ROOT="$BASE/$t"; mkdir -p "$ROOT"; FAILED=0; "t_$t" || FAILED=1; exit $FAILED ); then echo "ok $n - $t"
  else echo "not ok $n - $t"; fails=$((fails + 1)); fi
  settle "$BASE/$t"; rm -rf "$BASE/$t"
done
echo "# $n tests, $fails failed"
exit $((fails > 0))
```

The `match` regex for AC1 needs the file's newlines to match `.*`. Bash `=~` uses POSIX ERE, where `.` matches newline on both platforms. The builder confirms this with the RED run and, if it doesn't hold, checks each edit with a separate `match`.

### Test specs (one test per AC; the exact assertions)

- **`ac2_untracked_edit_no_commit`:** after `seed_a`, write and `fire` PostToolUse for `$H/notes.txt`, `$H/.hermes/plans/p/evidence/shot.md`, `$H/.claude/hooks/state/x.txt`, `$H/.hermes/cache/x.md` and `$H/Leorna/leorna-client/README.md`. Each must give `slow=0`, `rc=0` and empty `out`, with no `pending` file and no `worker.lock`. Then `fire` a Stop event and wait 5 s: `remote_count` is unchanged.
- **`ac3_secret_gate_blocks_push`:** build `tok="gh""p_$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 36)"` at runtime (never a literal in the file).
  - Plant it in `own/SKILL.md` and edit `plans/p/plan.md`. `sync A push` → exit 4. `remote_count` is unchanged. `git --git-dir=A/.claude-setup.git log -p --all` contains no `$tok`. The blocked flag has `secret\t.hermes/skills/software-development/own/SKILL.md\tgithub-pat` and no `$tok`. `fire` UserPromptSubmit gives JSON whose `additionalContext` contains "setup sync blocked" and the path.
  - Remove the token → push exit 0 → the remote has both edits, and the flag is gone.
  - A plan line `sourcegraph commit 46c17a58bbb7d7959f7ffba06038e07f27b876b8` → push exit 0. The same file with `sgp_` + 40 hex chars, built at runtime → exit 4.
  - `SETUP_SYNC_GITLEAKS=$ROOT/nope` with a change → exit 4, a `no-gitleaks` entry, the remote unchanged.
  - A commit made directly (`git --git-dir=… commit`) containing a token → push exit 4 from the pre-push scan, the remote unchanged.
- **`ac4_large_file_refused`:** `head -c 5242881 /dev/zero | tr '\0' a >plans/p/big.md`, `head -c 5242880 … >plans/p/edge.md`, plus a small edit → push exit 0. The remote tree has `edge.md` and the small edit but no `big.md`. The local repo has no object for `big.md`'s path in any commit. The blocked flag has `too-big\t.hermes/plans/p/big.md\t5242881`. The notice mentions "5 MB".
- **`ac5_excluded_paths_never_staged`:** create every path in AC5 (content `x`). The symlinks are `.hermes/skills/software-development/libskill -> $ROOT/A/lib/x`, `.claude/skills/y -> …/own` and `.claude/projects/-k-b/memory -> ../-k-a/memory`.
  - (a) Append `:(glob).hermes/**` and `:(glob).claude/**` to the manifest → push exit 0. `rgit ls-tree -r --full-tree main` lists none of the AC5 paths, and `rgit ls-tree -r main | awk '$1==120000'` is empty.
  - (b) Also empty `exclude.txt` and add one more tracked edit → push exit 4. The remote is unchanged and the blocked flag lists `denied` entries for those paths. Nothing denied is in any local commit.
- **`ac6_mass_delete_held`:** create 30 files under `.hermes/skills/c/s<i>/SKILL.md` and push. Then `mv $H/.hermes/skills $ROOT/away` → push exit 4: the remote still has the 30 files, `mass-delete\t30` is in the flag, and HEAD has no deletion commit. `mv` it back → push exit 0, flag gone. `rm` 30 files → `push --allow-deletes` exit 0, and the remote no longer has them.
- **`ac7_conflict_flag_no_push`:** `seed_a`, `attach_b`.
  1. A sets line 1 of `own/SKILL.md` to `from A` and pushes. B sets it to `from B`, then `sync B push` → exit 3. The remote line is `from A`. B's file has `from B`, with no `<<<<<<<` and no `rebase-merge` dir. B is 1 ahead. The flag contains `file\t.hermes/skills/software-development/own/SKILL.md`, and `$STATE/conflicts/…SKILL.md.remote` has `from A`.
  2. `fire` SessionStart and UserPromptSubmit on B: both give JSON with "setup sync conflict" and the path.
  3. `sync B status` names the path and the `.remote` copy. B writes `from A and B` → `sync B resolve` → exit 0. The remote has `from A and B`, and B's flag is gone. `sync A pull` → A has `from A and B`.
  4. Add/add: both create `.claude/projects/-k-a/memory/same.md` with different text → the same flow (exit 3, then resolve works).
  5. Dirty overlap: B's `plan.md` gets a runtime token (refused, stays dirty) while A changes `plan.md` → `sync B pull` exit 3 with `dirty\t.hermes/plans/p/plan.md`. B's file still holds B's text.
- **`ac8_pull_updates_and_relinks`:** make a fake library `$ROOT/lib.git` with `skills/alpha/SKILL.md`, `skills/beta/SKILL.md` and `catalog.tsv` (`name\tcategory` header + 2 rows). Clone it into both homes' `.hermes/skills-library`, with keep = `alpha software-development` and claude = `alpha`, and run the update script on both (`as X env HERMES_HOME=$ROOT/X/.hermes "$BASH_BIN" …`). A adds `beta software-development` to keep and `beta` to claude, edits `own/SKILL.md`, and pushes. `sync B pull` → exit 0, and:
  - B's own skill has the edit;
  - `readlink B/.hermes/skills/software-development/beta` = `$ROOT/B/.hermes/skills-library/skills/beta`;
  - `readlink B/.claude/skills/beta` = `$ROOT/B/.hermes/skills/software-development/beta`;
  - `cat B/.claude/skills/beta/SKILL.md` works.
- **`ac9_library_edit_via_patch`:** the same library setup with `alpha` linked into `.claude/skills`. A appends `local fix` to `$ROOT/A/.claude/skills/alpha/SKILL.md` and `fire`s PostToolUse with **that** path. Wait for the remote: `rgit show main:.hermes/skills-library-local.patch` contains `+local fix`.
  - `sync B pull` → B's `skills-library/skills/alpha/SKILL.md` has `local fix`. `sync B push` → `remote_count` unchanged. `sync B pull` again → the edit is still there.
  - Add an upstream commit to `lib.git` touching `beta` only, and pull it into B's clone (`git -C … pull --ff-only`). A appends `second fix`, pushes, B pulls. Then `sync B push` and `sync A push` give `remote_count` unchanged after both (no ping-pong).
- **`ac10_project_docs_copy_sync`:** A's tsv row is `p1\t$ROOT/A/proj/p1\t$ROOT/B/proj/p1\t-\tyes`. Make both project folders, with a `CLAUDE.md` only on A. `seed_a`, `attach_b` → B's `proj/p1/CLAUDE.md` equals A's.
  - Edit on A → push; `sync B pull` → equal. Edit on B → push; `sync A pull` → equal.
  - Both edit, A pushes, B pushes → exit 3. Both project files keep their own text. The flag contains `project-doc\tp1`, and `conflicts/project-docs/p1.CLAUDE.md.remote` holds A's text. B merges into its project file → `resolve` → after `sync A pull`, both files are equal to the merged text.
  - `chmod 000` B's doc, an edit on A, `sync B pull` → exit 0, B's doc is untouched (restore with `chmod 644` and check the content), and there is no flag entry.
  - `rm` A's doc → A push → B's doc still exists.
- **`ac11_cycle_pulls_then_pushes`:**
  1. `seed_a`, `attach_b`. B edits `own/SKILL.md` and pushes. A appends `hermes edit` to `.hermes/skills/software-development/own2/SKILL.md` with `printf` only.
  2. Run `env -i HOME=$ROOT/A PATH=/usr/bin:/bin:/usr/sbin:/sbin:$(dirname "$GITLEAKS_BIN") SETUP_SYNC_MACHINE=mac SETUP_SYNC_HOST=host-A SETUP_SYNC_GITLEAKS=$GITLEAKS_BIN GIT_CONFIG_NOSYSTEM=1 GIT_ALLOW_PROTOCOL=file /bin/bash $ROOT/A/.claude/bin/claude-sync cycle --quiet` → exit 0. A has B's edit, and the remote has `hermes edit`.
  3. `SETUP_SYNC_LAUNCH_AGENTS=$ROOT/LA SETUP_SYNC_LAUNCHCTL=$ROOT/fake-launchctl` (a script appending `$*` to `$ROOT/launchctl.args`), then `as A bash $H/.claude/setup/install-launchd.sh` → exit 0. The rendered `$ROOT/LA/com.justin.claude-sync.plist` contains:
     - `<string>com.justin.claude-sync</string>` and `<string>/bin/bash</string>`;
     - `<string>$ROOT/A/.claude/bin/claude-sync</string>`, `<string>cycle</string>` and `<integer>600</integer>`;
     - a PATH string containing `/opt/homebrew/bin`;
     - no `__HOME__`.

     On Darwin, `plutil -lint` passes. `launchctl.args` contains `bootstrap gui/$(id -u) $ROOT/LA/com.justin.claude-sync.plist`.
- **`ac12_bootstrap_fresh_home`:**
  1. Setup:
     - Fake library (as in AC8) plus three fake Leorna bare repos `$ROOT/leorna/{leorna-client,leorna-control-plane,codex-skills}.git`, one commit each.
     - On A, the tsv row `leorna\t$ROOT/A/Leorna\t$ROOT/B/Leorna\t<encode($ROOT/A/Leorna)>\tno`, a memory note at `A/.claude/projects/<encode($ROOT/A/Leorna)>/memory/n.md`, and keep = `alpha software-development`. `seed_a`.
     - B is a fresh home **without** `.gitconfig`, with `B/.claude/settings.json` = `{"b":1}`.
  2. `git clone --bare $ROOT/remote.git $ROOT/B/.claude-setup.git`, extract `bootstrap.sh` from `main`, then run `as B env SETUP_SYNC_REMOTE=$ROOT/remote.git SETUP_SYNC_LIBRARY_URL=$ROOT/lib.git SETUP_SYNC_LEORNA_BASE=$ROOT/leorna SETUP_SYNC_NO_SELFTEST=1 "$BASH_BIN" $ROOT/bootstrap.sh` → exit 0, and:
     - `git --git-dir=B/.claude-setup.git status --porcelain` is empty and HEAD = remote `main`;
     - `B/.claude-setup-backup-*/.claude/settings.json` = `{"b":1}`, and B's `settings.json` = A's;
     - B's `~/.gitconfig` has `user.email = issajustin04@gmail.com` and the `includeIf` path;
     - `B/.hermes/skills/software-development/alpha` is a link into B's clone, and `B/.claude/skills/alpha` exists if listed;
     - the three clones exist with `origin` = `$ROOT/leorna/<r>.git`;
     - `readlink B/.claude/projects/<encode($ROOT/B/Leorna)>/memory` = `../<encode($ROOT/A/Leorna)>/memory`, and `cat …/memory/n.md` works;
     - `claude-sync` and both hooks are executable.
  3. A second run → exit 0, no new backup folder, clone HEADs and links unchanged.
  4. Write `n2.md` through B's link path → `sync B push` → `rgit show main:.claude/projects/<encode($ROOT/A/Leorna)>/memory/n2.md` works.
  5. Home `C` with `.gitconfig` email `other@example.invalid` → bootstrap exit ≠ 0, and the gitconfig is byte-identical.
- **`ac13_leorna_repos_not_auto_pulled`:** after the AC12 setup, in `B/Leorna/leorna-client`: `git checkout -q -b feat/x`, commit, then leave `README` modified. Push a new commit to `$ROOT/leorna/leorna-client.git` `main`. Record `git rev-parse HEAD`, `git branch --show-current`, `git rev-parse refs/remotes/origin/main` and `git status --porcelain`. Then run `sync B pull`, `push` and `cycle`, `fire` SessionStart, UserPromptSubmit, Stop and PostToolUse (on a skill), and bootstrap again. All four records are unchanged.
- **`ac14_lock_and_background_flush`:**
  - (a) One pending edit on A. Start `sync A push`, `sync A push` and `sync A pull` together, then `wait`. All three exit 0, `remote_count` is +1, `A/.claude/hooks/state/setup-sync/log` has no `index.lock`, and there is no lock folder.
  - (b) `mkdir sync.lock; echo 999999 >sync.lock/pid` + an edit → push exit 0, the remote is +1, and the lock is gone.
  - (c) Make A/B conflict, then on B run `g rebase origin/main` by hand so it stops. `sync B push` → no `rebase-merge` dir, B's file has no `<<<<<<<`, exit 3, flag written.
  - (d) A Bash-made edit (no PostToolUse). Run the Stop hook as its own process-group leader: `perl -e 'setpgrp(0,0); exec @ARGV' -- "$BASH_BIN" hook <<<json &`, measured as in `fire`. It finishes within 1.5 s. Then `kill -TERM -- -<that pid>` (ignore errors) → the remote is +1 within 15 s.
  - (e) Stop with `stop_hook_active: true` → no `pending`, no `flush`, no new commit after 5 s.
- **`ac15_pull_triggers_fast_and_quiet`:**
  - (a) Use `$ROOT/fake-ssh`: `#!/bin/sh` + `echo $$ >"$FAKE_SSH_PID"; sleep 30`. Point A's origin at it with `as A git --git-dir="$ROOT/A/.claude-setup.git" remote set-url origin ssh://example.invalid/x.git`, and export `SETUP_SYNC_SSH=$ROOT/fake-ssh GIT_ALLOW_PROTOCOL=file:ssh FAKE_SSH_PID=$ROOT/ssh.pid`. `fire` SessionStart with a 6 s budget (give `fire` an optional 4th argument, the budget in tenths of a second, default 15): it finished, `rc=0`, `out` empty. There is no `sync.lock` or `rebase-merge`, and `kill -0 $(cat $ROOT/ssh.pid)` fails.
  - (b) URL = `$ROOT/nowhere.git` → finishes within 1.5 s, quiet.
  - (c) Restore the URL, push a change from B, then `fire` SessionStart on A → A has the change, and `out` is JSON whose `additionalContext` contains "pulled".
  - (d) `SETUP_SYNC_CYCLE_EVERY_SECS=5`, write `$STATE/last-cycle` = now − 10, and push a change from B. `fire` UserPromptSubmit → `slow=0`, and A gets the change within 15 s. A second `fire` right away leaves `last-cycle` unchanged.
- **`ac16_rule_edits_apply_cleanly`** (`tests/rule-edits.test.sh`): `cp` each live target from `rules/targets.tsv` into a temp folder and record `git hash-object` of each live file. Then:
  - `rules/apply-edits.sh <copy> rules/<name>` → exit 0;
  - the CLAUDE.md copy's line starting `2. **Planner:**` contains `` `~/.claude/bin/claude-sync pull` `` and `conflict`;
  - the privacy bullet contains `Just-In-N-Out/claude-setup`;
  - `## Setup sync (Mac ⇄ desktop)` appears once and before `## Worktrees from`;
  - feature-dispatch's `## Phase 1` paragraph contains `claude-sync pull`, and `LC_ALL=en_US.UTF-8 wc -m` < 100000;
  - git-commit-rules contains `to a project repo` and `In a project repo` twice;
  - `--reverse` → `cmp` with the original copy succeeds;
  - a second forward apply leaves the file byte-identical;
  - a file with the anchor removed → exit 1 and unchanged; an anchor doubled → exit 1 and unchanged;
  - the live hashes are unchanged.
- **`ac17_settings_hooks_registration`** (`tests/rule-edits.test.sh`): `jq -f rules/settings-hooks.jq <copy of live settings.json>`, then check:
  - `del(.hooks)` is equal before and after;
  - for each event in the original, the original array is a prefix of the new one;
  - the 4 new entries are present exactly as written above;
  - a second run gives identical JSON (`jq -S`);
  - the live hash is unchanged.
- **`ac18_machine_guides_match_build`** (`tests/guides.test.sh`): `home/.claude/setup/mac.md` and `desktop.md` exist.
  - **Each contains** (case-insensitive, literal): `works the same in both directions`, `within 10 minutes through launchd`, `session start`, `before a plan`, `Leorna setup files sync`, `never auto-pulled`, `leorna-client`, `leorna-control-plane`, `codex-skills`, `claude-sync status`, `claude-sync resolve`, `setup sync conflict`, `gitleaks`.
  - **mac.md adds:** `Hermes`, `launchd`, `every 10 minutes`, `pull then push`, `com.justin.claude-sync`, `about 20 seconds`, `end of every turn` and `~/.claude/setup/desktop.md`.
  - **desktop.md adds:**
    - `WSL2`, `Ubuntu`, `wsl --install -d Ubuntu`;
    - `VS Code`, `WSL extension`, `Connect to WSL`, `code .`, `WSL: Ubuntu`, `justin@`;
    - `C:\`, `PowerShell`, `the hooks and sync don't run`, `start Claude with`;
    - `git clone --bare git@github.com:Just-In-N-Out/claude-setup.git ~/.claude-setup.git`, `bootstrap.sh`;
    - `Leorna client`, `open question`, `Troubleshooting`, `~/.claude/setup/mac.md`.
  - Every `claude-sync <word>` in either guide is listed by `bash home/.claude/bin/claude-sync help`.
  - Every `~/…` path token either exists under `home/` or is in the test's runtime allowlist:
    - `~/.claude-setup.git`, `~/.claude-setup-backup-*`;
    - `~/.claude/hooks/state/setup-sync-conflict`, `~/.claude/hooks/state/setup-sync-blocked`, `~/.claude/hooks/state/setup-sync/`, `~/.claude/hooks/state/setup-sync/log`, `~/.claude/hooks/state/setup-sync/launchd.log`;
    - `~/.claude/CLAUDE.md`, `~/.claude/settings.json`, `~/.claude/skills`, `~/.claude/projects`;
    - `~/.hermes/skills`, `~/.hermes/skills-library`, `~/.hermes/plans`;
    - `~/Library/LaunchAgents/com.justin.claude-sync.plist`;
    - `~/Leorna`, `~/Leorna/leorna-client`, `~/Leorna/leorna-control-plane`, `~/Leorna/codex-skills`;
    - `~/.ssh/id_ed25519`, `~/.ssh/id_ed25519_leorna`, `~/.ssh/config`, `~/.gitconfig`, `~/.gitconfig-leorna`.
  - The numbers match the build:
    - the plist's `StartInterval` is 600 and mac.md says `every 10 minutes`;
    - `claude-sync`'s default `SETUP_SYNC_DEBOUNCE_SECS` is 20 and the guides say `about 20 seconds`;
    - `bootstrap.sh`'s default remote equals the clone URL in desktop.md.
  - `home/.claude/setup/README.md` has ≤ 6 non-empty lines and names both guides.
  - `rules/claude-md/04-setup-sync.new` contains `` on macOS read `~/.claude/setup/mac.md` `` and `` on Linux/WSL read `~/.claude/setup/desktop.md` ``, and so does the forward-applied live CLAUDE.md copy.
- **`ac19_linux_parity`** (`tests/linux-parity.test.sh`):
  1. `docker info` must work (else `not ok` with the reason).
  2. Build `claude-setup-test:u2404-gl8.30.1` from `tests/linux/Dockerfile` if it's missing.
  3. `docker run --rm --network none -v "$DEV/home:/src/home:ro" <image> bash -c 'cp -R /src/home "$HOME/src-home" && bash "$HOME/src-home/.claude/hooks/tests/setup-sync.test.sh"' >log` → exit 0. The log has `ok <n> - <name>` for all 15 names and no `not ok`.
  4. Then (informational, never failing the AC) mount the live `~/.claude/hooks` read-only and run the existing hook tests in the same image. Print their results as `#   note:` lines, and list failures as found_else.
  5. Print `uname -a` and `bash --version` inside the container as `#` lines.

`tests/linux/Dockerfile`:

```dockerfile
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends git jq ca-certificates curl perl procps \
    && rm -rf /var/lib/apt/lists/*
ARG GITLEAKS_VERSION=8.30.1
ARG TARGETARCH
RUN set -eu; case "$TARGETARCH" in arm64) a=arm64 ;; amd64) a=x64 ;; *) echo "unsupported $TARGETARCH"; exit 1 ;; esac; \
    cd /tmp; f="gitleaks_${GITLEAKS_VERSION}_linux_${a}.tar.gz"; \
    curl -fsSLO "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/$f"; \
    curl -fsSLO "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_checksums.txt"; \
    grep " $f\$" "gitleaks_${GITLEAKS_VERSION}_checksums.txt" | sha256sum -c -; \
    tar -xzf "$f" gitleaks; install -m 755 gitleaks /usr/local/bin/gitleaks; rm -f /tmp/gitleaks*
RUN useradd -m -s /bin/bash justin
USER justin
WORKDIR /home/justin
```

The builder confirms the release asset names on the gitleaks v8.30.1 release page before relying on them. The user is non-root so `chmod 000` behaves as it does on WSL.

- **`ac20_first_push_clean`** (`tests/finisher/first-push-audit.sh [--local]`; the finisher runs it):
  - `--local` audits `~/.claude-setup.git` before the first push.
  - Without it, it also checks visibility with `GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh repo view Just-In-N-Out/claude-setup --json visibility` = `PRIVATE`. It clones `git@github.com:Just-In-N-Out/claude-setup.git` bare into a scratch folder and checks HEAD = the local HEAD.
  - Both modes then check:
    - the `ls-tree -r --full-tree HEAD` paths against `DENY_RE`, plus no mode `120000`;
    - `git cat-file --batch-check` sizes ≤ 5242880;
    - `.claude/CLAUDE.md` is present;
    - `git log --format='%an <%ae>'` gives only `Justin <issajustin04@gmail.com>`, and `--format=%B` has no co-author line;
    - `gitleaks git --config ~/.claude/setup/gitleaks.toml --no-banner --redact --exit-code 7 <repo>` → 0.
  - It prints `ok 1 - ac20_first_push_clean` or `not ok 1 - ac20_first_push_clean`.
- **`ac21_mac_end_to_end`, `ac22_desktop_round_trip`:** manual checks, written as the "Check sync works" section in mac.md and desktop.md. The finisher runs the launchd half of AC21 (see "Finisher steps") and hands Justin the session half.

## Tasks (builder, test-first; each task: write the test, see RED, implement, see GREEN, commit)

On macOS, run every `setup-sync.test.sh` command with `/bin/bash` (3.2). RED means the named test prints `not ok <n> - <name>` for the intended reason (a script missing, or an assertion `#   failed:` line). GREEN means `ok <n> - <name>`. Commit after each GREEN with explicit paths (`git add <files>`), a plain `git commit -m "feat(setup-sync): …"` and no co-author line (Justin's rule). Before every commit, check that `git ls-files | grep -i claude.md` is empty.

0. **Dev repo and base.**
   1. `mkdir ~/claude-setup-dev && git -C ~/claude-setup-dev init -b main`.
   2. Write `README.md`: purpose, "local only, never pushed", the layout.
   3. Copy `~/.hermes/scripts/update-skills-library.sh` to `home/.hermes/scripts/update-skills-library.sh` with `cp -p`. Record its `git hash-object` in the README.
   4. `printf 'CLAUDE.md\n' >>.git/info/exclude`.
   5. Commit `chore: base snapshot`, then `git checkout -b feat/setup-sync`.
1. **Harness + AC1** (`home/.claude/hooks/tests/setup-sync.test.sh`, `home/.claude/setup/{manifest.txt,exclude.txt,projects.tsv,gitleaks.toml}`, `home/.claude/bin/claude-sync`, `home/.claude/hooks/setup-sync-on-edit.sh`):
   - Write the harness and `t_ac1…` as above. RED: `/bin/bash home/.claude/hooks/tests/setup-sync.test.sh ac1_tracked_edit_one_commit` → `not ok` ("setup failed").
   - Implement claude-sync's skeleton: `g()`, `HOME_REAL`, `init`, `attach`, `write_exclude`, `stage` without gates, `commit`, `push` without integrate, `is-tracked`, `debounce`, `_worker`, `new_group`/`detach`, `log`. Then the on-edit hook.
   - GREEN.
2. **AC2:** write `t_ac2…` (RED, likely already partly green; the RED proof comes from the base run). Make sure `is-tracked`'s prefilter and denylist cover every case. GREEN.
3. **AC5** denylist + symlink excludes + `denied` halting. RED → GREEN.
4. **AC4** size gate + blocked flag + `notice`. RED → GREEN.
5. **AC3** gitleaks gate (staged export, JSON mapping, fail closed, pre-push scan) + `gitleaks.toml`. RED → GREEN.
6. **AC6** mass-delete gate + `--allow-deletes`. RED → GREEN.
7. **AC14** lock (`sync.lock`, `again`, stale pid, half-done rebase recovery), Stop path (`debounce --now`, `flush`), process-group detachment. RED → GREEN.
8. **AC7** `fetch` + `with_timeout`, `integrate` (pre-checks, `rebase --autostash`, abort), `write_conflict`, `pull`, `status`, `resolve`, and `setup-sync-pull.sh` (SessionStart/UserPromptSubmit notices). RED → GREEN.
9. **AC15** `pull --hook` output, `PULL_TIMEOUT`, `maybe-cycle`, `last-cycle`. RED → GREEN.
10. **AC8** `post_apply` (relink via the update script with `HERMES_HOME` forced). RED → GREEN.
11. **AC9** `library_capture`/`library_apply` with the marker. RED → GREEN.
12. **AC10** project docs (hash state, unreadable skip, no deletion propagation, `project-doc` conflicts in `resolve`). RED → GREEN.
13. **AC11** `cycle`, `home/.claude/setup/launchd/com.justin.claude-sync.plist`, `home/.claude/setup/install-launchd.sh`. RED → GREEN.
14. **AC12** `home/.claude/setup/bootstrap.sh`, `link-memory`, and the real `projects.tsv` (rows above, per Q1). RED → GREEN.
15. **AC13** Leorna isolation test (it should pass once AC12 does; its RED proof is the base run). Make sure no code path runs git in `~/Leorna`. GREEN.
16. **AC16 + AC17:** `rules/targets.tsv`, `rules/apply-edits.sh`, all `rules/*/NN-*.{old,new}` exactly as above, `rules/settings-hooks.jq`, `tests/rule-edits.test.sh`. RED → GREEN with `bash tests/rule-edits.test.sh ac16_rule_edits_apply_cleanly` and `… ac17_settings_hooks_registration`.
17. **AC18:** `home/.claude/setup/mac.md`, `home/.claude/setup/desktop.md`, `home/.claude/setup/README.md` (index), `tests/guides.test.sh`. RED → GREEN with `bash tests/guides.test.sh ac18_machine_guides_match_build`.
18. **AC19:** `tests/linux/Dockerfile`, `tests/linux-parity.test.sh`. RED → GREEN with `bash tests/linux-parity.test.sh ac19_linux_parity`. The first image build needs network; the test run itself uses `--network none`.
19. **AC20 tool:** `tests/finisher/first-push-audit.sh`. Exercise its `--local` mode against a fake bare repo seeded by the harness: a clean one passes, one with a planted `.env` fails. It can't be fully run before the finish, because the AC is live.
20. **Whole run:** `/bin/bash home/.claude/hooks/tests/setup-sync.test.sh` (all 15), the three dev test files, the Linux test, and `bash -n` on every script. Capture one terminal screenshot per AC into the builder's evidence notes. Stop at `ready-for-review`.

Builder skills: `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`. The gates in AC3, AC4, AC5 and AC6 are data-integrity guards: for each, prove the test fails when the guard line is deleted (mutation), and note it in the handoff.

## Finisher steps (after `ac-check.sh` says READY FOR THE USER; only the finisher touches real GitHub, launchd and settings.json)

Preconditions:
- Q2 is answered and done. `ssh -o BatchMode=yes -T git@github.com` prints `Hi Just-In-N-Out!`, or stop.
- `~/.claude-setup.git` doesn't exist.
- `gh repo view Just-In-N-Out/claude-setup` says it doesn't exist (with `GH_TOKEN` for Just-In-N-Out).
- Record `git hash-object` of `~/.claude/CLAUDE.md`, `~/.claude/settings.json` and the two SKILL.md files.

1. **Copy the built files in (inert: nothing calls them yet).** For each file under the dev repo's `home/` except `home/.hermes/scripts/update-skills-library.sh`, run `install -m 755` for the scripts and `install -m 644` for everything else into the same path under `$HOME` (`mkdir -p` the parents). Refuse to overwrite any existing file whose bytes differ. Confirm the real `update-skills-library.sh` hash equals the base snapshot's, or note the difference.
2. **Create the repo:** `GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh repo create Just-In-N-Out/claude-setup --private --description "Justin's Claude Code + Hermes setup (synced by claude-sync)"`. Never `gh auth switch`.
3. **First local commit:** `~/.claude/bin/claude-sync init --remote git@github.com:Just-In-N-Out/claude-setup.git` → exit 0.
4. **Audit before the push:** `bash ~/claude-setup-dev/tests/finisher/first-push-audit.sh --local` → `ok`. This is the full gitleaks scan of the first commit, plus the tree checks. Any finding → stop and report.
5. **First push:** `~/.claude/bin/claude-sync push` → exit 0. `git --git-dir="$HOME/.claude-setup.git" ls-remote origin main` = local HEAD.
6. **launchd:** `bash ~/.claude/setup/install-launchd.sh`. `launchctl print gui/$(id -u)/com.justin.claude-sync` shows it loaded, and `~/.claude/hooks/state/setup-sync/launchd.log` shows the RunAtLoad cycle.
7. **Hooks last:** re-read `~/.claude/settings.json`, check its hash equals the one recorded (else re-read and continue from the fresh copy), then `jq -f ~/claude-setup-dev/rules/settings-hooks.jq` into `settings.json.setup-sync-tmp`. Validate it with `jq -e .`, check the hash again (unchanged since the read), and `mv` it into place.
8. **Rule edits:** `rules/apply-edits.sh` on each target in `rules/targets.tsv`. A concurrent-edit or anchor error stops the finish and goes back to a fixer; never edit by hand.
9. **Push the activation:** `claude-sync push` → `settings.json` and the three rule files reach GitHub.
10. **launchd end to end (half of AC21):** append the dated line `- Sync check <UTC time>` to `~/.claude/setup/mac.md` with the shell (no hook), run `launchctl kickstart gui/$(id -u)/com.justin.claude-sync`, and within 60 s the commit is on GitHub (`git ls-remote`).
11. **AC20 audit:** `bash ~/claude-setup-dev/tests/finisher/first-push-audit.sh` (GitHub mode) → `ok 1 - ac20_first_push_clean`. Save the output and screenshots into `~/.hermes/plans/claude-setup/evidence/setup-sync/finisher/`.
12. **Report:**
    - the repo URL and the HEAD SHA;
    - the live ACs owed to Justin: AC21's new-session half and AC22;
    - that **running sessions keep the old `CLAUDE.md` and hooks until restarted** (Claude Code loads both at start);
    - which sessions to restart;
    - the desktop steps (desktop.md).

The dev repo stays local; nothing from it is pushed.

## Docs & records

- New guides synced to both machines: `~/.claude/setup/mac.md`, `~/.claude/setup/desktop.md`, `~/.claude/setup/README.md` (index).
- `~/.claude/CLAUDE.md`: the privacy carve-out, pipeline step 2's pull line, and the new "Setup sync" section pointing to the guides.
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`: the Phase 1 pull line.
- `~/.hermes/skills/software-development/git-commit-rules/SKILL.md`: the carve-out in 3 places.
- `~/.claude/settings.json`: 4 hook entries.
- `~/Library/LaunchAgents/com.justin.claude-sync.plist`: new.
- Evidence: `~/.hermes/plans/claude-setup/evidence/setup-sync/` (`plan-approved.md` at go; `verifier/`, `auditor/`, `finisher/`). Evidence folders never sync.
- Dev repo `~/claude-setup-dev/README.md`: what it is, never pushed.
- No project `CLAUDE.md` or HANDOFF file changes. Skill lessons are saved by the main session.

## Risks

1. **The first push publishes Leorna material (plans, briefs, memory notes, the `leorna` skill) to a personal account's private repo.** Justin approved this in the design. The gitleaks gate, the denylist and the AC20 audit limit the damage; the `private/` live-target JSON and evidence never go.
2. **Concurrent sessions edit `CLAUDE.md`/`feature-dispatch`.**
   - An anchor can change between "go" and the finish. `apply-edits.sh` then fails loudly and a fixer updates the `.old` text.
   - AC16 can also flip between the verifier's and auditor's runs. If it does, that's a new fact, not a repeat failure.
3. **The host killing hook children.** Detachment uses `setsid` or perl's `POSIX::setsid`, and AC14 kills the hook's process group to prove the push survives. AC21 confirms this in real Claude Code.
4. **Hooks and `CLAUDE.md` load at session start**, so nothing changes in sessions that are already open. Restarting is part of the finisher's report.
5. **launchd and macOS privacy (TCC):** `/bin/bash` from launchd can't read `~/Documents` or `~/Desktop`. Project docs there sync only from hook runs. This is handled (unreadable → skip, never a deletion) and documented in mac.md.
6. **Library clones at different upstream commits** could rewrite the patch back and forth. The post-apply marker prevents it (AC9). At worst one extra commit follows a library update.
7. **gitleaks false positives** stop sync until someone acts. The notice says how; allowlists stay rule-targeted in `gitleaks.toml`, which syncs and can be reviewed.
8. **Wrong-place git:** anything that exports `GIT_DIR` globally would make `~` look like a repo. `claude-sync` never exports it, and the guides say to use `claude-sync status` rather than raw git in `~`.
9. **A mass deletion** (a moved skills folder, a bad update) would propagate. It is held above 25 deletions (AC6).
10. **`settings.json` is shared verbatim,** so the Mac paths inside it (autoMode text naming `/Users/justin/Leorna/leorna-client`) are wrong on the desktop. That's cosmetic, and listed below.
11. **The desktop's gitleaks must read the allowlist format.** Bootstrap checks it works rather than guessing a version (8.30.1 is what was tested).
12. **The private skills library** needs `gh auth setup-git` as Justin-Leorna on the desktop, or the library clone fails. desktop.md covers it.

## Other things found (not fixed; for Justin)

- **Privacy rule broken in PersonalWebsite (medium):** `~/JustinPersonalWebsite/CLAUDE.md` is committed (3 commits, latest `79fe8dd`) and is on `origin/main` of `Just-In-N-Out/PersonalWebsite` and two `claude/*` branches. That breaks the "never commit CLAUDE.md" rule.
- **Stale library patch (low; the build fixes it going forward):** `~/.hermes/skills-library-local.patch` covers 2 of the 8 locally edited library files. Until the first `claude-sync push`, a fresh clone elsewhere would lose 6 files' edits.
- **Mac paths in `settings.json` (low):** the autoMode text at line 107 names `/Users/justin/Leorna/leorna-client`, which is wrong on the desktop once synced.
- **`merge_lock.sh` is Mac-only (low, known):** `~/.hermes/scripts/merge_lock.sh:15` uses `stat -f`. Only Hermes uses it, and Hermes doesn't run on the desktop.
- **`git-commit-rules` repeats the rule (info):** it repeats the never-commit-CLAUDE.md rule at lines 27, 44 and 90, so all three get the carve-out (rule edits above).

## Skills

- Builder: `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (secret, size, denylist and mass-delete gates).
- Reviewers: `requesting-code-review`, `code-review-practice`, `security-best-practices` (secret handling, push to GitHub).
- Fixers: `receiving-code-review`.
- Verifier and auditor: `engineering-best-practices`, plus this plan's run commands. On macOS use `/bin/bash`, and run every AC test command from the dev repo root.
