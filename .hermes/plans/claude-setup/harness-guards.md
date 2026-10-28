# harness-guards: Justin's git, orchestrator and lessons rules become checks

Planner: Opus 5.5 (Claude Code), 2026-10-28 14:40 EDT. Story `harness-guards`, project `claude-setup`. Briefed as **Mini**; this plan recommends **Full** (Q1).
Evidence folder: `~/.hermes/plans/claude-setup/evidence/harness-guards/`.
Built in a linked worktree of the setup repo: `~/.claude-setup-wt/harness-guards`, branch `harness-guards`, base = local `main` of `~/.claude-setup.git` (`be351fb` at planning time; it moves with every sync, so record the real base when the worktree is made).

## Questions for Justin (the plan is written as if every recommended option ⭐ is chosen, so "go" needs no re-plan)

1. **Pipeline size.**
   - A) ⭐ **Full.** About 30 files: 4 hook scripts, 17 small git-hook files, `settings.json`, 1 test file, 1 old test fixed, plus about 15 one-line doc edits. It also adds permission and identity guards, and Mini's rules exclude permissions.
   - B) Mini, as briefed.
2. **When the orchestrator guard asks.**
   - A) ⭐ Every main-session edit inside a code repo or a setup code path asks. It stays quiet when you have switched to accept-edits or bypass mode yourself (Shift+Tab), so a long "do it here" session doesn't prompt on every edit. The model can't change the mode.
   - B) Always, with no mode exception.
   - C) Only while `~/.hermes/plans/dispatch.json` lists a story. **Not reliable:** Claude Code skips the board, and today the file holds one stale Hermes entry (`home-paste-media`).
   - D) A marker file the orchestrator writes at the planner and removes at finish. It adds state the model itself controls.
3. **Bash writes** (`sed -i`, heredoc, `tee`, `cp`) get around the Edit/Write guard.
   - A) ⭐ Accept the gap for now. Parsing every way a shell can write a file is fragile, and a wrong deny would break the pipeline's own Bash use.
   - B) Cover the common forms in `git-guard.sh`.
4. **Codex.**
   - A) ⭐ Make wiring the Bash guard into Codex a follow-up story. Codex's PreToolUse supports deny but **not ask** (codex-parity facts), so the Leorna push prompt can't be ported as is. Codex's `pre-tool` already blocks AI trailers, and the git-level hooks here cover Codex's commits.
   - B) Wire it now and turn ask into deny for Codex.
5. **Ask on push outside Leorna.**
   - A) ⭐ Leorna only. FigmaToBricksV2's flow auto-pushes `main`.
   - B) Ask before every push.
6. **Turning on the git hooks on each machine.**
   - A) ⭐ A documented one-time command per machine: `git config --global core.hooksPath '~/.claude/githooks'`. The guard allows that exact command and denies any other change. Off is one command in a terminal. Nothing quietly turns it back on.
   - B) `sync.sh links` sets it when it isn't set.
7. **Does the lessons gate check `enforce`?**
   - A) ⭐ Check only the structured form a script can read reliably: a non-empty `skill_lessons: [{…}]` (JSON, or an unquoted key) with no `enforce` anywhere is sent back once. Markdown-only lessons aren't parsed. An empty list passes.
   - B) Change only the message, with no check.
8. **Scratch repos under the system temp folders** (`/tmp`, `/private/tmp`, `/var/folders`, `/private/var/folders`, `/var/tmp`).
   - A) ⭐ No checks there, chaining only. `ac-check.test.sh` commits in `mktemp -d` with `-c user.email=t@t`, which would fail under a global hook. Most test suites do the same.
   - B) Check everywhere and change `ac-check.test.sh` and any other suite to isolate with `GIT_CONFIG_GLOBAL`.

## Playback

Justin read about "harness engineering": write each important rule twice, once as guidance and once as a mechanical check the agent can't bypass. His git rules and the "main session only orchestrates" rule are written-only, and both have been broken (the wrong-email `filter-branch` incident; two orchestrator slips on 2026-10-23). He picked three items:
1. **Git guard:**
   - a Claude Code Bash hook that denies identity overrides, `gh auth switch`, remote URL and credential-helper changes, and ways to skip the git hooks;
   - it allows the documented Leorna HTTPS push fallback;
   - it asks before any Leorna push.
   - Git-level hooks for every commit by anyone: no `CLAUDE.md` (the setup repo excepted), the right email per folder, no AI co-author. They chain to each repo's own hooks.
2. **Orchestrator guard:** the main session gets a yes/no prompt before editing code. The orchestrator's own files stay prompt-free.
5. **Lessons that can become checks:** `skill_lessons` gains an `enforce` field (`none`, or a one-line check proposal). The main session keeps a backlog of proposals and offers each as a story, never building it itself.

## Facts checked for this plan (2026-10-28; read-only, probes in the scratchpad with `GIT_CONFIG_GLOBAL` → a temp file)

**Claude Code hooks** (official docs, `https://code.claude.com/docs/en/hooks.md`):
- "A hook's `"ask"` also forces a permission prompt in auto mode: the classifier can still deny the tool call, but it can't approve the call silently." So ask works with `defaultMode: auto`.
- `permissionDecisionReason`: "For `"ask"`, shown to the user in the permission prompt. … For `"deny"`, shown to Claude." So the deny reason reaches the model.
- Precedence across hooks: `deny` > `defer` > `ask` > `allow`.
- `subagent-handback-gate.sh` found that only the first PreToolUse **deny** is kept. The two new hooks match `Bash` and `^(Edit|Write|NotebookEdit)$`, never `SubagentHandback`, so they never share a call with that gate. Each hook prints exactly one decision, with all of its reasons joined.
- Input:
  - `agent_id` is present only in a subagent or teammate, so the main session has none.
  - `permission_mode` takes `default|plan|acceptEdits|auto|dontAsk|bypassPermissions`.
  - `scratchpad_dir` is given.
  - For Write and Edit, `tool_input.file_path` is always absolute, with `~` and relative paths already expanded.
  - NotebookEdit sends `notebook_path`.
  - The matcher `Edit.*` would also match `NotebookEdit`; anchor it with `^…$`.
- Edits to hooks in settings files are "normally picked up automatically by the file watcher", so merging `settings.json` turns the guards on in running sessions.
- Background subagents "surface every permission prompt in your main session", so an ask from a background finisher reaches Justin.

**Git** (2.53.0 here; the Mac has 2.50.1):
- In `pre-commit`, `git var GIT_AUTHOR_IDENT` and `GIT_COMMITTER_IDENT` reflect `--author=`, `-c user.email=` and the env vars.
- `--amend` keeps the original author (probe).
- `git -c core.hooksPath= commit` (empty value) runs **no** hooks at all (probe), so the inline form is a full bypass.
- A no-conflict `git merge` runs `commit-msg` with `MERGE_MSG` but **not** `pre-commit` (probe); its pre-commit-style hook is `pre-merge-commit`.
- Linked worktree: `GIT_DIR` = `<common>/worktrees/<name>`, and `git rev-parse --git-common-dir` gives the main `.git`. The repo's own hooks live in `<common>/hooks`. Don't use `git rev-parse --git-path hooks`: it returns the global `core.hooksPath`.
- **A global `core.hooksPath` turns off every hook in every repo's `.git/hooks`**, not just pre-commit (git-lfs installs `pre-push`, `post-checkout`, `post-commit` and `post-merge` there). So every standard client hook name gets a pass-through wrapper.
- `core.hooksPath` is a pathname setting, so `~/` is expanded. The literal string `~/.claude/githooks` works on both machines.
- The `githook.sh` snippet below passed `bash -n`. It was also smoke-tested in a scratch copy with its temp-folder rule turned off, because the scratchpad is under `/tmp`. Refused: a staged `CLAUDE.md`, a wrong email in a personal repo and in a Leorna repo, an AI trailer. Passed: a vendored `CLAUDE.md` and a clean commit. **Test repos must sit outside the temp folders, or the checks are skipped.**

**Repos on this desktop**:
- `~/Leorna/{leorna-client, leorna-control-plane, codex-skills}`, `~/Documents/FigmaToBricksV2`: no local `core.hooksPath`, no husky or lefthook, no own hooks in `.git/hooks`. None would skip the global hooks today. The Mac's repos are checked in AC22.
- `leorna-client` tracks a **vendored** `vendor/github.com/labstack/echo/v4/CLAUDE.md`. A `go mod vendor` update would stage it, so `vendor/` and `node_modules/` paths are ignored by the CLAUDE.md check.
- `leorna-control-plane` git tests isolate with `GIT_CONFIG_GLOBAL=/dev/null`, so global hooks don't affect them.
- `~/.claude/setup/sync.test.sh` and `codex-parity.test.sh` run with a fake `HOME` (their own `.gitconfig`), so global hooks don't affect them.
- `ac-check.test.sh` commits in `mktemp -d` with `-c user.email=t@t` and the real global config. Q8's temp-folder rule keeps it passing.

**Setup repo**:
- The setup repo is the bare `~/.claude-setup.git` (`core.worktree=$HOME`, `status.showUntrackedFiles=no`, a repo-local `credential.helper` set by `sync.sh configure`). `sync.sh` runs `git commit`, so the global hooks also run on every sync. CLAUDE.md is allowed there; email and trailer are checked. Sync commits use `issajustin04@gmail.com` and no trailer, so they pass.
- `manifest.txt` matches `.claude/hooks/*.sh` and `.claude/hooks/tests/**` only. A new `.claude/githooks/` folder needs its own line.
- `sync.sh` skips symlinks (`check_staged`), so the hook wrappers are real files, not links. Their exec bit must be committed (mode 100755): git ignores a non-executable hook.
- `codex-parity.test.sh` `ac7_claude_hooks_unchanged` pins the five Claude hook files, their tests and `settings.json` to the story base, and it expects exactly five test files. This story changes the lessons gate, the nudge, `settings.json` and the test count, so that check must lose its pins (Task 9).
- Everything that defines the `skill_lessons` shape `{skill, lesson, evidence}` (grep):
  - `~/.claude/CLAUDE.md` line 80;
  - `feature-dispatch/SKILL.md` line 255 (96,046 characters now);
  - `leorna/SKILL.md` line 91;
  - `subagent-lessons-gate.sh` (reason);
  - `skill-review-nudge.sh` (subagent text);
  - the seven `~/.codex/agents/pipeline-*.toml` (synced; `build-codex.sh` rewrites only their model lines);
  - the memory notes `periodic-skill-review.md` (three copies).
  - Codex's `subagent-stop` runs the Claude gate scripts unchanged, so it inherits the new text. `~/.codex/AGENTS.md` is generated from CLAUDE.md on sync.

**Tools**: hooks run with `#!/usr/bin/env bash`. Write for macOS bash 3.2:
- no `mapfile`, no `${x,,}`, no associative arrays;
- no `sed -i`, no `readlink -f` or `realpath`: use `cd … && pwd -P`;
- no `grep -P`.

`python3` exists on both machines (3.14 on the Mac and here). `jq` is used by every existing hook.

## Approach

### 1(a) `~/.claude/hooks/git-guard.sh`: PreToolUse on `Bash`, main session and subagents alike

A bash entry point:
1. Cheap pre-filter: exit 0 unless the command contains `git`, `gh` or `GIT_`.
2. If `python3` is missing, print one `systemMessage` ("git-guard: python3 not found; git commands are not checked") and exit 0.
3. Otherwise `exec python3 -I -c "$GUARD_PY"`, with the Python held in a quoted heredoc inside the same file, so the one `*.sh` syncs.

Python reads the hook JSON from stdin and prints one PreToolUse JSON or nothing. It always exits 0: bad input means no output.

**Tokenizing:**
- Replace unquoted newlines with `;`.
- Run `shlex.shlex(cmd, posix=True, punctuation_chars=True)` with `whitespace_split=True`. On `ValueError` (an unbalanced quote), fall back to a whitespace split with the quote characters removed.
- Split into segments at `;`, `&&`, `||`, `|`, `&`, `(` and `)`.
- In each segment, take the leading `NAME=value` tokens as env assignments.
- Strip the wrappers `env` (its `-i`, `-u X` and further assignments), `command`, `exec`, `time` and `nohup`.
- Treat `export NAME=value` as an assignment.
- Recurse, at most 3 levels deep, into the string after `-c` for `bash|sh|zsh|dash -c|-lc|-ic`, and into `eval <rest>`.
- Track the folder: start at the input's `cwd`. A `cd <dir>` segment moves it for the later segments (expand `~`, `$HOME`, `${HOME}`).

**Git command model:**
- After `git` (any basename `git`), read the global options:
  - `-C <dir>`;
  - `-c <k=v>`;
  - `--config-env=<k>=<env>` (also the two-token form);
  - `--git-dir[=]`, `--work-tree[=]`, `--namespace[=]`;
  - flags like `-p`, `-P`, `--no-pager`, `--bare`.
- The first other token is the subcommand.
- In `commit` args, skip the value after `-m -F -c -C -t --message --file --reuse-message --reedit-message --template --author --date --trailer --fixup --squash --cleanup --pathspec-from-file`, and after a short cluster that ends in one of `mFcCt`. So a message is never read as flags.

**Rules.** Every matched deny reason is joined into one deny. With no deny, a matched Leorna push gives ask.

| # | Deny when | Not denied (examples) |
|---|---|---|
| identity | `-c`/`--config-env` key `user.email`, `user.name`, `author.email`, `author.name`, `committer.email` or `committer.name`; `git commit --author[=]`; an assignment to `GIT_AUTHOR_EMAIL`, `GIT_AUTHOR_NAME`, `GIT_COMMITTER_EMAIL` or `GIT_COMMITTER_NAME` (prefix, `env`, `export`); a `git config` **write** of those keys (any scope) | `git log --author=x`, `git shortlog -se`, `git config user.email` (read), `unset GIT_AUTHOR_EMAIL` |
| gh | `gh auth switch …`; `gh auth setup-git` (it writes a global credential helper) | `gh auth status`, `gh auth token --user X`, `gh pr list` |
| remote | `git remote set-url …`; a `git config` write of `remote.<n>.url` or `remote.<n>.pushurl` | `git remote -v`, `git remote add` (new remote; not in the rule) |
| credential | a `git config` write of any `credential.*` key; inline `-c credential.helper=…` or `-c credential.<url>.helper=…` **unless** it is the Leorna fallback (below) | `git config --get-regexp credential`, `git config --local --list` |
| hooks | `--no-verify` in any git command's args; `git commit` with `-n`, or a short cluster holding `n` before any of `mFcCtuS`; `-c`/`--config-env` key `core.hooksPath` (empty value included); a `git config` write or unset of `core.hooksPath` whose value isn't `~/.claude/githooks`, `$HOME/.claude/githooks`, `${HOME}/.claude/githooks` or `<real home>/.claude/githooks` (trailing `/` allowed) | `git commit -am x`, `git commit -m "-n"`, `git commit -m "docs: --no-verify"`, `git push -n` (dry run), `git clean -n`, `git config --global core.hooksPath ~/.claude/githooks` |

- **Reading vs writing `git config`:**
  - A **read** has `--get`, `--get-all`, `--get-regexp`, `--get-urlmatch`, `-l`/`--list`, or the subcommand `get`/`list`. A single positional key with no write flag is also a read.
  - A **write** has 2+ positionals, or one of `--add`, `--unset`, `--unset-all`, `--replace-all`, `--rename-section`, `--remove-section`, `-e`/`--edit`, or the subcommand `set`/`unset`/`rename-section`/`remove-section`/`edit`.
  - Keys are compared lowercase.
- **Leorna fallback (allowed):**
  - one git segment whose only credential `-c` entries have the value `` (empty) or `!gh auth git-credential`;
  - with subcommand `push` or `fetch`;
  - whose first positional arg starts with `https://github.com/LeornaAI/`.
  - The push form still gets the ask below.
- **Leorna push (ask):** a git `push` segment, not denied, is asked when either holds:
  - its folder (`-C` resolved against the segment folder, else the segment folder), resolved with `os.path.realpath`, is under `realpath($HOME)/Leorna/`;
  - an arg contains `LeornaAI/`, or starts with `github-leorna:` or `git@github-leorna:`.
  - Reason: "Leorna push: Justin's rule is to push only after he says "push" or "make a PR". Approve only if he did."
- **Deny reasons** name the rule and the fix, for example: "git-guard: never override commit identity (CLAUDE.md, Git Commit Authorship). Commit with plain `git commit` and let the repo's config pick the email."

### 1(b) `~/.claude/githooks/`: global git hooks for every commit

- **Wrappers:** 16 identical two-line wrapper files, mode 755, one for each client hook name:
  - `applypatch-msg`, `pre-applypatch`, `post-applypatch`;
  - `pre-commit`, `pre-merge-commit`, `prepare-commit-msg`, `commit-msg`, `post-commit`;
  - `pre-rebase`, `post-checkout`, `post-merge`, `pre-push`;
  - `pre-auto-gc`, `post-rewrite`, `sendemail-validate`, `push-to-checkout`.
- **Not wrapped**, because they fire on every ref or index change, or are server- or config-driven: `reference-transaction`, `post-index-change`, `fsmonitor-watchman`, `p4-*`, and the server hooks.
- Each wrapper contains:

```bash
#!/usr/bin/env bash
exec bash "$(dirname "$0")/githook.sh" "$(basename "$0")" "$@"
```

`githook.sh` (the one real script; the checks only, then a hand-over):

```bash
#!/usr/bin/env bash
# Justin's git hooks for every repo: global core.hooksPath = ~/.claude/githooks (one-time per machine).
# Each other file here is a wrapper: githook.sh <hook name> <git's args>.
#   pre-commit        no staged CLAUDE.md (any folder; vendor/ and node_modules/ ignored; setup repo excepted),
#                     then author and committer email by folder
#   pre-merge-commit  author and committer email by folder
#   commit-msg        no Co-authored-by trailer naming an AI
# Then it hands over to the repo's own <git common dir>/hooks/<name> when that is executable
# (exec: same args, same stdin, its exit code), because a global hooks path hides the repo's own hooks.
# Repos under the system temp folders are scratch (test suites): no checks, hand-over only.
# Off on one machine: git config --global --unset core.hooksPath (in a terminal; Claude's git-guard denies it).
# macOS bash 3.2 and Ubuntu. Tests: ~/.claude/hooks/tests/harness-guards.test.sh
set -uo pipefail
name=${1:-}; shift || true
LEORNA_EMAIL=justin@leorna.com
PERSONAL_EMAIL=issajustin04@gmail.com
AI_TRAILER='^[[:space:]]*co-authored-by:.*(claude|anthropic|codex|openai|chatgpt|gpt|copilot|gemini|hermes)'
self=$(cd "$(dirname "$0")" && pwd -P)
home=$(cd "$HOME" 2>/dev/null && pwd -P) || home=$HOME
common=$(cd "$(git rev-parse --git-common-dir 2>/dev/null)" 2>/dev/null && pwd -P) || common=""
top=$(cd "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null && pwd -P) || top=$PWD

stop() { printf 'githooks (%s): %s\n' "$name" "$*" >&2; exit 1; }
scratch() { case "$top/" in /tmp/* | /private/tmp/* | /var/tmp/* | /var/folders/* | /private/var/folders/*) return 0 ;; esac; return 1; }
setup_repo() { [ -n "$common" ] && [ "$common" = "$(cd "$home/.claude-setup.git" 2>/dev/null && pwd -P)" ]; }
email_of() { git var "GIT_$1_IDENT" 2>/dev/null | sed -n 's/.*<\([^>]*\)>.*/\1/p'; }
check_identity() {
  local want who got
  case "$common/" in "$home/Leorna/"*) want=$LEORNA_EMAIL ;; *) want=$PERSONAL_EMAIL ;; esac
  for who in AUTHOR COMMITTER; do
    got=$(email_of "$who")
    [ "$got" = "$want" ] || stop "$(echo "$who" | tr A-Z a-z) email is '$got'; this folder needs $want (CLAUDE.md, Git Commit Authorship). Don't override it: fix git config, or tell Justin (an amended commit keeps its old author)."
  done
}
check_claude_md() {
  setup_repo && return 0
  local bad
  bad=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null \
        | awk '{ n = split($0, p, "/"); if (tolower(p[n]) == "claude.md" && $0 !~ /(^|\/)(vendor|node_modules)\//) print }')
  [ -z "$bad" ] || stop "CLAUDE.md files are never committed (CLAUDE.md, Git & GitHub Privacy): $(echo $bad). Unstage with git restore --staged <path> and list it in .git/info/exclude."
}
check_trailer() { [ -f "${1:-}" ] && grep -iqE "$AI_TRAILER" "$1" && stop "no Co-authored-by line naming an AI (CLAUDE.md, Git & GitHub Privacy). Remove that trailer and commit again."; return 0; }

if ! scratch; then
  case $name in
    pre-commit) check_claude_md; check_identity ;;
    pre-merge-commit) check_identity ;;
    commit-msg) check_trailer "${1:-}" ;;
  esac
fi
own="$common/hooks/$name"
if [ -n "$common" ] && [ -f "$own" ] && [ -x "$own" ] && [ "$(cd "$common/hooks" && pwd -P)" != "$self" ]; then
  exec "$own" "$@"
fi
exit 0
```

Notes for the builder:
- The snippet is the intended shape. Make the tests drive the details; for example, a path with a newline needs `-z` handling if you add it.
- Leorna is decided by the **git common dir**, the same thing `includeIf "gitdir:~/Leorna/"` uses, so a worktree of a Leorna repo counts as Leorna wherever it sits.
- The setup repo's CLAUDE.md exception covers its linked worktrees, because they share the common dir.
- Both author and committer are checked, so a commit whose identity was changed by `-c`, an env var or a repo-local `user.email` is refused. Amending someone else's commit is refused too: the skill already says "tell Justin" (risk R6).

### 2. `~/.claude/hooks/orchestrator-guard.sh`: PreToolUse on `^(Edit|Write|NotebookEdit)$`

Bash plus jq, in the existing hooks' style (a field read with a unit separator; any bad input exits 0 silently).

**Silent** (no output) when any of these holds:
- `agent_id` is non-empty;
- the tool isn't one of the three;
- `permission_mode` is `acceptEdits` or `bypassPermissions` (Q2 A);
- there is no path (`tool_input.file_path // tool_input.notebook_path`).

**Resolve the path:**
- turn `\` into `/`;
- find the nearest existing ancestor folder and run `cd … && pwd -P`;
- append the rest of the path.

The home folder is resolved the same way. A file reached through `~/.claude/skills/<name>` therefore resolves into `~/.hermes/skills/...`.

**Orchestrator's own files** (silent):
- basename `CLAUDE.md` or `CLAUDE.local.md`, anywhere;
- `~/.hermes/plans/**`: plans, briefs, evidence, `dispatch.json`;
- `~/.hermes/skills/**/*.md`: skill text and lessons;
- `~/.claude/projects/*/memory/**`;
- anything under the resolved `scratchpad_dir` from the input.

**Code** (ask), unless it is an own file:
- the file's folder, or any folder above it, holds a `.git` entry (a folder, or the `.git` file of a linked worktree);
- or the path is one of these setup code paths:
  - `~/.claude/hooks/**`, `~/.claude/githooks/**`, `~/.claude/setup/**`;
  - `~/.claude/settings.json`, `~/.claude/settings.local.json`;
  - `~/.codex/hooks/**`, `~/.codex/hooks.json`, `~/.codex/agents/**`;
  - `~/.hermes/scripts/**`;
  - non-`.md` files under `~/.hermes/skills/**` (scripts such as `ac-check.sh` are code).
- `$HOME` has no `.git` (the setup repo is bare), so a file is a "repo" file only inside a real work tree.

**Anything else** is silent: a note in `~/Documents`, `~/.claude/plans/*.md`.

**Ask output:** `{hookSpecificOutput:{hookEventName:"PreToolUse", permissionDecision:"ask", permissionDecisionReason:"Orchestrator guard: the main session is about to edit <path>, which is code. During a bug or story the main session only orchestrates (CLAUDE.md); approve only for a one-line edit or when you said \"do it here\"."}}`.

### 5. Lessons that can become checks

**Shape.** It becomes `skill_lessons[{skill, lesson, evidence, enforce}]`. This clause is folded into the existing sentence everywhere the shape is defined, never as a new paragraph:
> `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs.

**Gate** (`subagent-lessons-gate.sh`):
- The "no lessons" reason names the four fields and the clause above, and keeps its exact last line.
- **New check (Q7 A).** `missing_enforce()` joins the message onto one line (`tr '\n' ' '`). It is true when the message matches the ERE `skill_lessons"?[[:space:]]*[:=][[:space:]]*\[[[:space:]]*\{` and doesn't match `enforce` (case-insensitive).
  - The schema text `skill_lessons[{…}]` has no `:`/`=`, so it never matches.
- Order: no lessons → the old reason. Otherwise, a missing enforce → the reason below.
- Both reasons use the gate's existing once-only mechanisms: SubagentStop's `stop_hook_active`, and the per-agent `denied` marker on SubagentHandback. An agent is still sent back at most once by this gate.
- The enforce reason:
  > "Your skill_lessons entries have no enforce field. Restate your complete final report in full (the parent keeps only your newest report), adding enforce to each lesson: none, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (its kind: Claude Code hook, git hook, test, lint or script; what it checks; where it runs). Do not edit any SKILL.md, skill or memory file yourself. End with this exact last line: MAIN SESSION: check and save these skill_lessons now."
- `subagent-handback-gate.sh` needs no change: it concatenates the gates' reasons. Its test's last-line check still holds.

**Main session** (CLAUDE.md lessons bullet and feature-dispatch lesson intake, folded in):
- It saves the lesson as before.
- It appends each non-`none` `enforce` to `~/.hermes/plans/claude-setup/enforce-backlog.md` as one line: `- <date> | <story> | <skill> | <proposal> | offered`.
- It tells Justin in the same one-line lessons summary, offering to make the check a story.
- It never builds the check itself.

The backlog file is created in this story with a two-line header, so the path exists.

### Where it's built, reviewed and turned on

The approach follows `codex-parity.md` "Where it's built":

**Worktree.** Run:
```
git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/harness-guards" -b harness-guards main
```
- The worktree has the `$HOME`-relative layout, and `~/.claude-setup-wt/` is never staged by `sync.sh`.
- Commits there use the global personal identity, with no `Co-Authored-By` line.
- `status.showUntrackedFiles=no` is shared, so before any hand-over the builder and verifier check that `git -C <wt> status --porcelain --untracked-files=all` is empty.

**Tests.** They take the code from their own checkout (`SRC` = three folders above the test file), never from the live `~/.claude`. Nothing is live until the merge.

**AC tests.** Each runs as:
```
bash <wt>/.claude/hooks/tests/harness-guards.test.sh <test name>
```
It prints numbered TAP (`ok 1 - <test name>`).

**ac-check:**
```
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo ~/.claude-setup-wt/harness-guards --base "$(git -C ~/.claude-setup-wt/harness-guards merge-base HEAD main)" --plan ~/.hermes/plans/claude-setup/evidence/harness-guards/plan-approved.md <evidence>/verifier/ac.json <evidence>/auditor/ac.json
```

**Activation is last** (finish step, after `ALL ACCEPTED` or `READY FOR THE USER`):
1. The finisher rebases on local `main`, and the orchestrator runs the `--ff-only` merge into `main` (work tree `$HOME`). The merge itself is the install: it places the hooks, the githooks and `settings.json`.
2. The file watcher then turns on `git-guard.sh` and `orchestrator-guard.sh` in **every running Claude Code session on this desktop**, the orchestrator's included.
   - The orchestrator's own work stays prompt-free: plan, brief and evidence writes are own files, and `install -m 444` is Bash.
3. The finisher runs, on this desktop: `git config --global core.hooksPath '~/.claude/githooks'`, then `git config --global core.hooksPath` to read it back.
4. `sync.sh` pushes. The **Mac's Claude Code guards go live at its next session-start pull** (`settings.json` and the scripts are synced). The Mac's git hooks need the one-time command (AC22, live).
5. **Off switches**, written into `desktop.md`, `mac.md` and `README.md`:
   - git hooks: `git config --global --unset core.hooksPath` in a terminal (git-guard denies it for Claude, on purpose);
   - a Claude Code guard: delete its entry from `~/.claude/settings.json` (it syncs to the other machine; `/hooks` shows the state).

## Acceptance criteria (proposed: Justin gave none; "go" approves them)

All tests are functions in `~/.claude/hooks/tests/harness-guards.test.sh`. Run one as `bash <worktree>/.claude/hooks/tests/harness-guards.test.sh <test name>`.

- Hook tests feed JSON payloads to the checkout's scripts with `HOME` set to a fake home.
- Git tests use temp repos under `${HARNESS_GUARDS_TEST_ROOT:-$HOME/.cache/harness-guards-tests}`, outside the temp folders so the checks apply, with:
  - `GIT_CONFIG_GLOBAL` → a test file holding `user.email=issajustin04@gmail.com`;
  - `includeIf "gitdir:<fake home>/Leorna/"` → `justin@leorna.com`;
  - `core.hooksPath=<checkout>/.claude/githooks`;
  - `GIT_CONFIG_NOSYSTEM=1`.
- No test touches a real repo, the real global git config, the real `~/.claude` or GitHub.
- `ac19` (it runs other suites, one of which runs this file) and the live tests run only when named.

- AC1 (proposed): Given a Bash call from the main session or a subagent, when the command overrides commit identity (`git -c user.email=…`, `-c user.name=…`, `-c author.*`/`-c committer.*`, `--config-env=user.email=…`, `git commit --author=…`, `GIT_AUTHOR_EMAIL/NAME` or `GIT_COMMITTER_EMAIL/NAME` set as a prefix, via `env` or via `export`, or a `git config [--global|--local] user.email|user.name <value>` write), then `git-guard.sh` prints one PreToolUse JSON with `permissionDecision: "deny"` and a reason naming the identity rule; `git log --author=x`, `git shortlog -se`, `git config user.email` (read) and `unset GIT_AUTHOR_EMAIL` get no output. Test: `ac1_guard_denies_identity_override`.
- AC2 (proposed): `gh auth switch` (with or without `--user X`) and `gh auth setup-git` are denied with a reason naming the account rule; `gh auth status`, `gh auth token --user Just-In-N-Out` and `gh pr list` get no output. Test: `ac2_guard_denies_gh_account_changes`.
- AC3 (proposed): `git remote set-url origin …`, a `git config` write of `remote.origin.url` or `remote.origin.pushurl`, any `git config` write of a `credential.*` key (set, `--add`, `--replace-all`, `--unset`, `--unset-all`, and the `set`/`unset` subcommands, any scope) and an inline `-c credential.helper=…` that isn't the Leorna fallback are denied; `git remote -v`, `git config --get-regexp credential`, `git config --local --list` and `git config get credential.helper` get no output. Test: `ac3_guard_denies_remote_and_credential_changes`.
- AC4 (proposed): Hook bypasses are denied: `git commit --no-verify`, `git commit -n -m x`, `git commit -anm x`, `--no-verify` on `push`/`merge`/`rebase`/`am`/`cherry-pick`, `git -c core.hooksPath= commit`, `git -c core.hooksPath=/x commit`, `--config-env=core.hooksPath=X`, `git config --global core.hooksPath /other` and `git config --global --unset core.hooksPath`; `git commit -am x`, `git commit -m "-n"`, `git commit -m "docs: --no-verify"`, `git push -n`, `git clean -n` and `git config --global core.hooksPath ~/.claude/githooks` (also with `$HOME/…` and the real home path) are not denied. Test: `ac4_guard_denies_hook_bypass`.
- AC5 (proposed): The Leorna HTTPS fallback `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/x` is not denied (it gets AC6's ask) and the matching `fetch https://github.com/LeornaAI/leorna-client.git feat/x:refs/remotes/origin/feat/x` gets no output, while the same inline helpers with a non-`LeornaAI` URL, another helper value, or a subcommand other than push/fetch are denied. Test: `ac5_guard_allows_leorna_https_fallback`.
- AC6 (proposed): Any `git push` whose folder is under `~/Leorna/` (the hook input's `cwd`, a preceding `cd ~/Leorna/x &&`, or `git -C ~/Leorna/x`), or whose args name `LeornaAI/` or the `github-leorna` alias, gets `permissionDecision: "ask"` with a reason saying a Leorna push needs Justin's "push", for the main session and for a subagent alike; `git push` in a personal repo, and `git fetch`/`git status` in a Leorna repo, get no output. Test: `ac6_guard_asks_before_leorna_push`.
- AC7 (proposed): The rules hold through shell forms (after `;`, `&&`, `||`, `|` and a newline, inside `bash -c`, `sh -c`, `zsh -lc` and `eval` strings, behind `env`, `command` and `time`, and in a command with an unbalanced quote); non-Bash tools, invalid JSON and commands without `git`/`gh`/`GIT_` exit 0 with no output; with no `python3` on `PATH` a git command exits 0 with only a `systemMessage`; every output is a single JSON object. Test: `ac7_guard_parses_shell_forms`.
- AC8 (proposed): In a personal repo and in a Leorna repo, a commit staging `CLAUDE.md`, `docs/CLAUDE.md` or `claude.md` is refused by pre-commit with a message naming the file and `.git/info/exclude`; deleting a tracked `CLAUDE.md`, `vendor/x/CLAUDE.md` and `node_modules/x/CLAUDE.md` commit; in a fake setup repo (`$HOME/.claude-setup.git`, work tree `$HOME`) and in a linked worktree of it, staging `.claude/CLAUDE.md` and `.claude/project-docs/x/CLAUDE.md` commits. Test: `ac8_precommit_blocks_claude_md_except_setup_repo`.
- AC9 (proposed): Under `$HOME/Leorna/` a commit passes only when author and committer are `justin@leorna.com`, and elsewhere (a personal repo, and the setup repo) only when both are `issajustin04@gmail.com`; `-c user.email=`, `--author=`, `GIT_AUTHOR_EMAIL=`, `GIT_COMMITTER_EMAIL=` and a repo-local `user.email` with the other address are each refused with a message naming the expected email, and a no-conflict `git merge` making a merge commit with a wrong email is refused by pre-merge-commit. Test: `ac9_precommit_blocks_wrong_email_by_folder`.
- AC10 (proposed): commit-msg refuses a `Co-authored-by:` line naming Claude, Anthropic, Codex, OpenAI, ChatGPT, GPT, Copilot, Gemini or Hermes (any case; via `-m`, `-F`, `--amend` and a merge message), in a personal repo and in the setup repo; a human co-author trailer and the word "Claude" in the message body pass. Test: `ac10_commit_msg_blocks_ai_coauthor`.
- AC11 (proposed): A repo's own executable `.git/hooks/<name>` runs after the checks with git's args and stdin, and its exit code decides (pre-commit exit 1 blocks the commit, commit-msg gets the message file, pre-push reads the ref lines on stdin and its exit 1 blocks a push to a local bare remote, post-checkout runs); a linked worktree uses the common dir's hooks; a missing or non-executable own hook is skipped; `githook.sh` never execs itself when the repo's hooks folder is the githooks folder; the 16 wrappers exist, are identical and are mode 100755 in git. Test: `ac11_githooks_chain_repo_hooks`.
- AC12 (proposed): In a repo made with `mktemp -d` (and with `mktemp -d /tmp/hg.XXXXXX`), a commit with a staged `CLAUDE.md`, `-c user.email=t@t.test` and an AI trailer succeeds, and the repo's own `.git/hooks/pre-commit` still runs (its exit 1 still blocks). Test: `ac12_temp_repos_skip_checks_but_chain`.
- AC13 (proposed): For the main session (no `agent_id`, in `auto` and in `default` mode), Edit, Write (also a new file in a new subfolder) and NotebookEdit (`notebook_path`) on a file in a git work tree (a `.git` folder, or the `.git` file of a linked worktree) get `permissionDecision: "ask"` with a reason naming the file and the orchestrator rule; so do `~/.claude/hooks/x.sh`, `~/.claude/githooks/pre-commit`, `~/.claude/settings.json`, `~/.claude/setup/sync.sh`, `~/.codex/hooks/codex-hooks.sh`, `~/.hermes/scripts/x.sh` and `~/.hermes/skills/a/b/scripts/x.sh`. Test: `ac13_orchestrator_guard_asks_main_session_code_edit`.
- AC14 (proposed): The orchestrator guard gives no output for the same edits from a subagent (`agent_id` set), and for the main session on `~/.hermes/plans/**` (a plan, a brief, `evidence/x.png`, `dispatch.json`), `~/.hermes/skills/**/*.md` (also reached through a `~/.claude/skills/<name>` symlink), `~/.claude/projects/p/memory/x.md`, any `CLAUDE.md` (also inside a repo), a file under the input's `scratchpad_dir`, and a file outside any repo and setup code path; also in `acceptEdits` and `bypassPermissions` mode, for other tools and for invalid JSON. Test: `ac14_orchestrator_guard_quiet_for_subagents_and_own_files`.
- AC15 (proposed): The lessons gate's send-back (SubagentStop block and SubagentHandback deny, and so the handback gate's combined deny) names `skill_lessons[{skill, lesson, evidence, enforce}]`, says `enforce` is `none` or a one-line check proposal (kind, what it checks, where it runs) and still ends with `MAIN SESSION: check and save these skill_lessons now.`; the subagent nudge in `skill-review-nudge.sh` names the same four fields. Test: `ac15_lessons_gate_message_names_enforce`.
- AC16 (proposed): A report holding a non-empty structured list (`skill_lessons: [{…}]` or `"skill_lessons": [ {…} ]`, also split across lines) with no `enforce` anywhere is sent back once with a reason naming `enforce` (SubagentStop with `stop_hook_active: false`, and the first SubagentHandback per agent), a second handback from that agent passes, the same report with `enforce` passes, and `skill_lessons: []` and a markdown-only "Skill lessons" section pass. Test: `ac16_lessons_gate_sends_back_missing_enforce_once`.
- AC17 (proposed): The CLAUDE.md lessons bullet, feature-dispatch SKILL.md's lesson line, leorna SKILL.md's lessons line, the seven `.codex/agents/pipeline-*.toml` files and every `periodic-skill-review.md` memory copy name `skill_lessons[{skill, lesson, evidence, enforce}]`; CLAUDE.md and feature-dispatch also name `~/.hermes/plans/claude-setup/enforce-backlog.md`, the one-line story offer and that the main session never builds the check; the backlog file exists; no synced file outside `.hermes/plans/` still contains `{skill, lesson, evidence}]`; feature-dispatch SKILL.md is under 100,000 characters. Test: `ac17_docs_define_enforce_and_backlog`.
- AC18 (proposed): CLAUDE.md names `git-guard.sh`, `orchestrator-guard.sh` and `~/.claude/githooks` beside the rules they enforce (privacy, authorship, the Leorna push rule, "the main session only orchestrates"); `git-commit-rules` SKILL.md names the git hooks and git-guard; `desktop.md` and `mac.md` give the one-time activation command and both off switches; `README.md` lists `.claude/githooks/`; `manifest.txt` has `:(glob).claude/githooks/**` and its pathspecs pick up all 17 githooks files in a temp repo holding a copy of them. Test: `ac18_guard_docs_and_manifest`.
- AC19 (proposed): The five existing Claude hook suites, `sync.test.sh`, `ac-check.test.sh` and the `codex-parity.test.sh` offline run pass, and the five hook suites, `ac-check.test.sh` and this file's offline run also pass with the git hooks active (`GIT_CONFIG_GLOBAL` = a temp copy of `~/.gitconfig` plus `core.hooksPath` = the checkout's githooks). Test: `ac19_existing_suites_pass`.
- AC20 (proposed): `.claude/settings.json` is valid JSON, registers `~/.claude/hooks/git-guard.sh` on PreToolUse matcher `Bash` and `~/.claude/hooks/orchestrator-guard.sh` on `^(Edit|Write|NotebookEdit)$` (timeout 10 each), keeps the `SubagentHandback` entry alone in its group and every other key equal to base; both scripts are mode 100755 in git; each registered command run with `~` mapped to the checkout denies a `--no-verify` commit and asks on a main-session repo edit. Test: `ac20_settings_register_guards`.
- AC21 (proposed) (live): On the desktop after the finish, in a new Claude Code session: `git config --global core.hooksPath` prints `~/.claude/githooks`; asking Claude to `git commit --allow-empty --no-verify -m t` in a scratch repo under `~/.cache/hg-live/` is refused with the guard's reason; asking for `git push --dry-run` in `~/Leorna/leorna-client` shows a yes/no prompt naming the Leorna rule (answer No); asking the main session to edit a file in `~/Documents/FigmaToBricksV2` shows the orchestrator prompt (answer No); a terminal commit there with `-c user.email=x@example.test` is refused by pre-commit. Test: `ac21_desktop_live_smoke`.
- AC22 (proposed) (live): On the Mac after `sync.sh pull`: `~/.claude/githooks/*` are executable; after `git config --global core.hooksPath '~/.claude/githooks'`, a wrong-email commit in a scratch repo under `~/.cache/hg-live/` is refused; the scan in Task 13 shows which Mac repos have a local `core.hooksPath` or own `.git/hooks` (reported, not changed); in a Claude Code session `git commit --no-verify` is denied (so `python3` is found). Test: `ac22_mac_activation_live`.

For the base-commit check (`ac-verification.md`):
- Tests ac1–ac18 and ac20 fail on base: the scripts, wrappers, settings entries or doc text are missing, and `need` fails the test (it never skips).
- The regression test ac19 keeps existing behaviour, so it carries `base_exempt: "regression run of existing suites"`.
- The two live ACs (21 and 22): an agent marks them `not_run: "live: …"`. Their test functions check what can be checked (the config value, file modes) and print the manual steps.

## Tasks (in order; test first: write the AC's test, run it and see it fail for the stated reason, then build)

1. **Worktree and evidence.** Make the worktree (command above) and record `base=$(git -C ~/.claude-setup-wt/harness-guards merge-base HEAD main)` in the builder report. Create `~/.hermes/plans/claude-setup/evidence/harness-guards/`.
2. **Test harness.** Write `.claude/hooks/tests/harness-guards.test.sh`, with a header naming this plan and the run forms. Base it on `codex-parity.test.sh`:
   - `run`/`fail`/`need`/`done_ok`;
   - an `OFFLINE` list holding ac1–ac18 and ac20;
   - `SRC=$(cd "$HERE/../../.." && pwd)`;
   - `unset GIT_CONFIG_GLOBAL GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL SUBAGENT_LESSONS_STATE_DIR SUBAGENT_AC_STATE_DIR SKILL_NUDGE_STATE_DIR`;
   - `newroot` (makes `$S`, fake home `$H`, `$S/gitconfig` and `$S/gitconfig-leorna`);
   - `ing` (runs with `HOME=$H GIT_CONFIG_GLOBAL=$S/gitconfig GIT_CONFIG_NOSYSTEM=1`);
   - `hook <script> <json>` (sets `$out`/`$rc`);
   - `bashcall <cmd> [cwd] [agent_id]`, `editcall <tool> <path> [agent_id] [mode]`, `decision`.

   Write all 22 test functions, then run each to see RED: `not ok … missing …/git-guard.sh (not built yet)` and the like. Commit: `test(harness-guards): acceptance tests`.
3. **git-guard: identity, gh, remote and credential** (AC1, AC2, AC3). Write `.claude/hooks/git-guard.sh` (mode 755): bash entry, embedded Python, tokenizer, segment and git models, then the rules for these three ACs. GREEN on each. Commit.
4. **git-guard: hooks bypass, fallback and the Leorna ask** (AC4, AC5, AC6). GREEN. Commit.
5. **git-guard: shell forms** (AC7): recursion, the fallback tokenizer, no-python3 and the output shape. GREEN, then re-run AC1–AC6. Commit.
6. **githooks** (AC8, AC9, AC10, AC12): `.claude/githooks/githook.sh` plus the 16 wrappers, all 755 (`git add` records 100755; check with `git ls-files -s .claude/githooks`). GREEN. Commit.
7. **Chaining** (AC11). GREEN, then re-run AC8–AC12. Commit.
8. **orchestrator-guard** (AC13, AC14): `.claude/hooks/orchestrator-guard.sh` (755). GREEN. Commit.
9. **Lessons gate and nudge** (AC15, AC16):
   - Edit `subagent-lessons-gate.sh` (reason text, `missing_enforce`, the order) and the subagent text in `skill-review-nudge.sh` (four fields, one clause).
   - Run the five old hook suites. They must stay green unchanged. If an assertion pinned the old wording, update only that assertion and say so in the report.
   - In `.claude/setup/codex/codex-parity.test.sh`, change `ac7_claude_hooks_unchanged`: drop the base-equality loop and the "five test files" count; keep "every `.claude/hooks/tests/*.test.sh` passes in a fake home". Add a comment saying harness-guards removed the story-time pins. Then run `bash .claude/setup/codex/codex-parity.test.sh ac6_gates_match_claude_twins ac7_claude_hooks_unchanged`: both `ok`.
   - Commit.
10. **settings.json** (AC20): in the worktree's `.claude/settings.json`, append the two PreToolUse groups after the `SubagentHandback` group; change nothing else. GREEN. Commit.
11. **Docs and records** (AC17, AC18): the Docs & records line below. Fold text into existing lines. feature-dispatch SKILL.md grows by at most about 600 characters (check `wc -c` < 100,000). GREEN. Commit.
12. **Regression** (AC19): `bash .claude/hooks/tests/harness-guards.test.sh ac19_existing_suites_pass`. Then the full offline run (`bash .claude/hooks/tests/harness-guards.test.sh`) and `git -C <wt> status --porcelain --untracked-files=all` empty. Stop at `ready-for-review`.
13. **Finish** (finisher and orchestrator, after `ALL ACCEPTED` or `READY FOR THE USER`; activation last):
    1. rebase on local `main`; re-run task 12;
    2. `--ff-only` merge into `main` (this installs and turns on the Claude Code guards here);
    3. `git config --global core.hooksPath '~/.claude/githooks'` and read it back;
    4. `~/.claude/setup/sync.sh` (its own commit now passes the git hooks: personal email, CLAUDE.md allowed in the setup repo);
    5. append a backlog entry only if the story's agents proposed one;
    6. hand AC21 and AC22 to Justin with the Mac scan one-liner:
       ```
       for d in ~/Leorna/* $(awk -F'\t' '!/^#/{print $2}' ~/.claude/setup/projects.tsv); do [ -d "$d/.git" ] || [ -f "$d/.git" ] || continue; c=$(git -C "$d" rev-parse --git-common-dir); echo "$d hooksPath=[$(git -C "$d" config --local --get core.hooksPath)] own=[$(ls "$d/$c/hooks" 2>/dev/null | grep -v '\.sample$' | tr '\n' ' ')]"; done
       ```

**Docs & records:**
- `.claude/CLAUDE.md`: the lessons bullet (enforce and backlog); one short "enforced by" clause each on the Privacy bullets (githooks), the authorship rule (git-guard and the pre-commit email), the Leorna push bullet (git-guard deny and ask) and "The main session only orchestrates" (orchestrator-guard).
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` line 255.
- `.hermes/skills/software-development/leorna/SKILL.md` line 91.
- `.hermes/skills/software-development/git-commit-rules/SKILL.md`: one line, "enforced by `~/.claude/githooks` and `git-guard.sh`; a refusal is the rule, not a bug to work around".
- The seven `.codex/agents/pipeline-*.toml`; the `periodic-skill-review.md` memory copies.
- `.hermes/plans/claude-setup/enforce-backlog.md` (new).
- `.claude/setup/manifest.txt` (`:(glob).claude/githooks/**`).
- `.claude/setup/desktop.md` (Part 2 step and off switches), `.claude/setup/mac.md` (one-time command and off switches), `.github/README.md` (what's in the repo; troubleshooting: off switches).
- Then `~/.claude/setup/sync.sh` at the finish.

## Touched files (`$HOME`-relative; same paths in the worktree)

New:
- `.claude/hooks/git-guard.sh`, `.claude/hooks/orchestrator-guard.sh`;
- `.claude/githooks/githook.sh` plus 16 wrappers;
- `.claude/hooks/tests/harness-guards.test.sh`;
- `.hermes/plans/claude-setup/enforce-backlog.md`.

Changed:
- `.claude/hooks/subagent-lessons-gate.sh`, `.claude/hooks/skill-review-nudge.sh`;
- `.claude/settings.json`;
- `.claude/setup/codex/codex-parity.test.sh` (ac7 only);
- `.claude/setup/manifest.txt`;
- `.claude/CLAUDE.md`;
- `feature-dispatch/SKILL.md`, `leorna/SKILL.md`, `git-commit-rules/SKILL.md`;
- `.codex/agents/pipeline-*.toml` (7);
- `periodic-skill-review.md` (memory copies);
- `desktop.md`, `mac.md`, `.github/README.md`.

Unchanged by design: `subagent-handback-gate.sh`, `subagent-ac-gate.sh`, `setup-sync-*.sh`, `.codex/hooks/codex-hooks.sh` (Q4), `sync.sh`, `ac-check.sh`.

Per machine, never synced: the global `core.hooksPath` in `~/.gitconfig`.

## Risks

- **R1 (high): every repo's own `.git/hooks` stops running once the global hooks path is set**, unless it is chained. *Mitigation:* the 16 pass-through wrappers (AC11). The unwrapped names are listed above. No repo here has own hooks or a local hooks path today; the Mac is scanned in AC22.
- **R2: test suites that commit with a test identity outside temp folders would start failing.** *Mitigation:* the temp-folder skip (Q8, AC12). Known suites are checked (Facts). A suite with a fake `HOME` or `GIT_CONFIG_GLOBAL` never sees the global hooks.
- **R3: activation hits live sessions at once,** including the orchestrator and any parallel story's agents. A parallel builder doing a Leorna push or a code edit in the main session gets a prompt. *Mitigation:* activation is the last step; the off switches are one line each.
- **R4: the text guard is a seatbelt, not a sandbox.** It can't see commands run inside scripts or aliases, `HOME=`/`GIT_CONFIG_GLOBAL=` isolation, or file writes through Bash (Q3). The git hooks are the second layer for commits; the CLAUDE.md text stays as guidance. A heredoc body line that starts with `git push` can draw a needless prompt.
- **R5: a new `python3` dependency for git-guard.** If it's missing, the guard fails open with a visible `systemMessage` (AC7). The Mac is checked in AC22.
- **R6: amending a commit whose author is someone else is refused** (both identities are checked). That matches the skill ("tell Justin instead of rewriting"). Justin can override by hand in a terminal.
- **R7: the orchestrator guard prompts during legitimate "do it here" work.** Shift+Tab to accept-edits silences it (Q2 A). In a `claude -w` worktree session the main session is in a repo, so its edits ask, which is what the rule wants.
- **R8: `JustinPersonalWebsite/CLAUDE.md` is tracked in its repo** (`mac.md`). Committing a change to that file is now refused. Removing it from the repo is Justin's call (known).
- **R9: the codex-parity ac7 change.** Its story-time pins go; the hook tests themselves still run there.
- **R10: Mini → Full.** The size is about 30 files (Q1).
- **Estimate** (Full, all-Opus): build about 2–3 h of agent time (22 tests, 4 scripts); review and verify loops about 1–2 h; Justin's live checks about 10 min per machine.

## Other things found (not fixed here)

- **Medium:** `codex-parity.test.sh` `ac7_claude_hooks_unchanged` pins five Claude hook files plus `settings.json` to the story base and requires exactly five test files (lines 365–381). Any later story that touches a hook fails it. Task 9 removes the pins, because this story can't pass its own regression AC otherwise. Flagged so the pattern isn't repeated.
- **Low:** the `git-commit-rules` skill says "on Justin's Mac" and `platforms: [macos]`, but the WSL desktop now follows it too.
- **Info:** `leorna-client` tracks a vendored `vendor/github.com/labstack/echo/v4/CLAUDE.md` (a third-party file). It is handled by the `vendor/` exclusion.
- **Info:** `~/.hermes/plans/dispatch.json` holds one stale Hermes entry (`home-paste-media`), so it can't serve as a "story running" signal in Claude Code.
- **Info:** in this desktop's Bash tool shell, `grep` runs ugrep (`ugrep: error … exceeds complexity limits` on `grep -o '.\{0,140\}x.\{0,160\}'`). In a plain `bash -c`, `grep` is `/usr/bin/grep`, so hooks are unaffected. Agents should use `/usr/bin/grep` for complex `-o` patterns.
