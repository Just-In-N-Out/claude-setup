# AC5 LIVE-CHECK RUNNER brief: 86bcm901b-prompts-collection [leorna]

**Role:** AC5 live-check runner for the Leorna story "86bcm901b-prompts-collection" (ClickUp "Curate the reusable prompts collection"). You are fresh. Justin asked (2026-10-28): "cant oyu do ac5" — so an agent runs the live AC he was going to run himself. You run it, capture real evidence, and give a verdict; **Justin accepts or rejects AC5 from your screenshots**. You don't change the story's code.

**The AC (approved plan, `~/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md`):** "AC5 (live): Live run of /review and /spec in Claude Code: each runs from the rendered project files and its reply follows the prompt's own instructions."

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`). Claude Code **2.1.312** is installed (`~/.local/bin/claude`) and signed in as Justin.

## Skills to load first (say so in your first steps)

1. `leorna` (its Pitfalls include how to judge a prompt under test: it counts as run when the tool's reply follows the prompt body's own instructions, even if the session then misbehaves; confirm the installed files' bytes are unchanged afterwards).
2. `engineering-best-practices`.

## What to do

Follow `~/.hermes/plans/leorna/evidence/86bcm901b/ac5-checklist.md` step by step, as closely as this machine allows, with these changes:
- **Throwaway project:** use `~/.cache/leorna-86bcm901b/ac5-prompts` instead of `~/ac5-prompts` (same commands otherwise: `git init`, `calc.py`, commit, copy the rendered `.claude/` from `ac5-install/claude-code/`, `sha256sum -c` against `ac5-install/SHA256SUMS` → both OK, then the staged `a - b` change). Delete it at the end.
- **Running Claude Code, most faithful first:**
  1. **Interactive, preferred:** if `tmux` is available (or can be used without sudo), start `claude` interactively in a detached tmux session in the throwaway project, send keys to accept the folder-trust prompt, type `/` and capture the pane to check `review` and `spec` are listed as project commands, then run `/review`, wait for the reply to finish, capture the pane (`tmux capture-pane -p -S -<n>`), then `/spec a command-line tool that turns a CSV file into JSON`, wait, capture. Exit cleanly.
  2. **Headless fallback:** if interactive driving isn't possible, run `claude -p "/review"` and `claude -p "/spec a command-line tool that turns a CSV file into JSON"` in the throwaway project (add `--output-format stream-json --verbose` in a second run if you need to see the skill/tool calls), and say plainly that the `/` menu step was replaced by another check (e.g. the command expanding to the project command's body).
- **Permissions:** never use `--dangerously-skip-permissions` or a bypass mode. If a tool permission prompt appears, deny anything that writes outside the throwaway project; reading files in the throwaway project is fine. A prompt that wants to write code during `/spec` should not get to (the pass condition is that it asks first).
- **Justin's setup stays as it is:** use his normal login and `~/.claude` (no fake HOME, no copying or reading credential files). Claude Code will write its usual session files there; that's expected. Don't change settings, CLAUDE.md, hooks, plugins, skills or memory. His global CLAUDE.md and hooks will load as they would for him: that's part of a faithful run, but if a hook's output or his global rules visibly change the commands' behaviour, say so.
- **Judge each command against the checklist's Pass lines:**
  - `/review`: the reply reviews the staged change across correctness, readability, architecture, security and performance; labels findings Critical, Required, Optional or Nit with `calc.py:<line>`; and the session shows the `code-review-and-quality` skill being used. Also confirm it is the project command (Claude Code 2.1.312 has no built-in `/review`).
  - `/spec`: it asks about the goal and users, features and acceptance criteria, stack and boundaries before writing any code.
  - Partial matches: say exactly which part passed and which didn't. Don't round up.
- After exiting, rerun the `sha256sum -c` from the throwaway project: both OK.

## Evidence

- Folder: `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/ac5-run/` (create it). Save the full captured output as `ac5-review.log`, `ac5-spec.log` and `ac5-menu.log` (interactive only), each starting with the command and the Claude Code version and ending with the exit code or "session exited", plus `ac5-setup.log` (steps 1–3 and the before/after `sha256sum -c`).
- Screenshots `ac5-review.png` and `ac5-spec.png` (and `ac5-menu.png` if interactive) in that folder: render each log in a `<pre>` page and capture it with this desktop's Chrome recipe in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (Chrome for Testing, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, under `env -u DISPLAY -u WAYLAND_DISPLAY`; kill only your own Chrome, filtering out shells). Long output may need two images (`-1`, `-2`). Label each page as "agent-run, headless" or "agent-run, interactive via tmux".
- **Privacy:** look at every image before listing it. No email address, account name, org ID, token, server address or URL bar. Claude Code's banner can show the account email: crop it out or re-render the page without that line, and say what you removed.
- **Temp files on disk, not `/tmp`:** `/tmp` here is a small shared RAM disk. Put `TMPDIR`, Chrome profiles and any work files in `~/.cache/leorna-86bcm901b/ac5-work/` (create it; delete it at the end). Your Claude scratchpad folder (`/tmp/claude-1000/-home-justin-Leorna/77db91ea-503b-4eea-89eb-4d64d373a178/scratchpad/86bcm901b-ac5/`, created with `mkdir`, no `-p`) is only for tiny notes.

## Boundaries

- Don't touch the repo, the story worktree, the main checkout or any sibling story. No commit, push, PR or ClickUp write.
- Don't start the story's PostgreSQL; AC5 doesn't need it.
- Kill any `claude` or tmux session you started before you finish; leave every other process alone.
- You can't ask Justin anything and can't start other agents.
- Claude Code refuses report files from subagents: return your report as your final message (logs and images are receipts).
- Other problems: `found_else`. Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{verdict: pass|fail|partial, mode: interactive|headless, claude_version, model, menu{listed, evidence}, review{pass, what_it_did, skill_used, labels_seen[], evidence}, spec{pass, questions_asked[], wrote_code_first, evidence}, files_unchanged, screenshots[], logs[], redactions[], differences_from_checklist[], found_else[], skill_lessons[]}`.
