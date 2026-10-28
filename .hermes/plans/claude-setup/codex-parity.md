# codex-parity: Codex works like Justin's Claude Code setup, on both machines

Planner: Opus 5.5 (Claude Code), 2026-10-28. Story: `codex-parity`, Full pipeline, project `claude-setup`.
Evidence folder: `~/.hermes/plans/claude-setup/evidence/codex-parity/`.
Built in a worktree of the setup repo: `~/.claude-setup-wt/codex-parity`, branch `codex-parity`, base = local `main` of `~/.claude-setup.git` (it was `1e11f0f` at planning time and moves with every sync; record the real base when the worktree is made).

## Questions for Justin (pre-approved: the orchestrator applies each default without asking)

Each default is chosen so Codex behaves the way Claude Code does here.

1. **Codex pipeline model (one setting).** Default: every Codex role (planner, builder, reviewers, fixers, verifier, auditor, finisher) runs on **`gpt-6.1-sol` at `xhigh`**, mirroring all-Opus-5.5-xhigh. The one setting is `~/.claude/setup/codex/pipeline-model.toml` (synced). To switch, say "switch the Codex pipeline model to X" to Claude or Codex: the agent runs `~/.claude/setup/codex/set-pipeline-model.sh X [effort]`, which checks X against `~/.codex/models_cache.json` (refusing with the valid list), edits the setting, rebuilds the role files and runs `sync.sh`. The switch holds on both machines.
2. **Codex main-session model.** Default: the setup does **not** set it. It stays what you pick with `/model` or in each machine's `config.toml` (now `gpt-5.6-luna`, medium). Recommendation, one line: pick `gpt-6.1-sol` yourself for the main session if you want the orchestrator to match the roles; the setup leaves it to you because the orchestrator does little thinking and the choice is per machine.
3. **Memory.** Default: Codex's own memories stay **off** (the current default). Codex uses Claude's memory notes only: a session-start hook shows the project's `MEMORY.md` index, and Codex saves notes in the same folder and format. One store, synced, shared by both tools.
4. **Sandbox (7b).** Default: a permission profile `claude-setup` (extends `:workspace`):
   - writes to `~/.hermes` and `~/.claude`, but `~/.claude/setup`, `~/.claude/hooks`, `~/.claude/settings.json`, `~/.hermes/scripts` stay read-only and `~/.hermes/.env` is denied;
   - a workspace's own `.git` is writable, so Codex can commit like Claude;
   - command network on (Claude's Bash reaches the network here too).

   Plus an execpolicy allow rule for exactly `<home>/.claude/setup/sync.sh` and `<home>/.claude/setup/codex/set-pipeline-model.sh`. These two run **outside** the sandbox without a prompt, so sync can write every synced path, use `gh`'s token and push. Codex itself can't edit the sync machinery, the secret gate or the manifest without asking you. The narrower alternative is network off for sandboxed commands; then package installs and `gh` calls need an approval each time.
5. **Project `CLAUDE.md` files.** Default: Codex loads a project's `CLAUDE.md` when it has no `AGENTS.md` (`project_doc_fallback_filenames = ["CLAUDE.md"]`). The cap is raised to 256 KiB (`project_doc_max_bytes = 262144`), because FigmaToBricksV2's `CLAUDE.md` is 141 KB and Claude Code loads it whole.
6. **Codex's "Co-authored-by: Codex" trailer.** Default: **blocked**. Codex 0.163.0 carries a `<git_attribution>` instruction that appends that trailer when the account setting is on, and it tells Codex to ignore instructions that disable it. A text rule isn't enough, so a hook denies such commits and makes Codex amend one that slipped through.
7. **Hook trust.** Default: you trust the hooks once per machine in Codex's `/hooks` screen, and again after any change to `~/.codex/hooks.json`. Codex requires a human review of each hook definition. Trust is stored per machine in `config.toml` as `[hooks.state."…"] trusted_hash`. The setup never auto-trusts.
8. **Probe home for real `codex exec` tests.** Default: a sign-in-only Codex home, `~/.codex-probe` (file credential store, never synced). You sign in there once on the Mac. The probe tests and the payload recording need it, because a temp `CODEX_HOME` can't see the Mac keychain login: `codex login status` from Claude's shell reports "Not logged in" even for the real `~/.codex`. Exact command in Task 2.
9. **A push hook for Claude too?** Recommendation, one line: yes, in a later story. Register the same tool-neutral `~/.claude/hooks/setup-sync-push.sh` (built here, registered only for Codex) on Claude's `Stop` and `UserPromptSubmit`, so both tools push the same way. This story doesn't change Claude.
10. **Codex plugin skills with Hermes names.** Default: when a Codex plugin bundles a skill whose name a Hermes skill also has, the Hermes one wins: `setup-codex.sh` disables the plugin copy. Example: the enabled `github@openai-curated` plugin ships a `github` skill, and Hermes has `github`. This follows CLAUDE.md's "use the Hermes one" rule.

## Playback

Justin wants Codex CLI, signed in with ChatGPT, to work like his Claude Code setup on the Mac and in WSL Ubuntu:
- it knows the same rules and the full story pipeline;
- it uses the same Hermes skills and Claude's memory notes;
- it runs the gate hooks (adapted, the Claude scripts unchanged) and `ac-check.sh` unchanged;
- it edits the same real files and syncs them through `Just-In-N-Out/claude-setup`, pulling at session start (reusing Claude's pull hook) and pushing in the background after edits.

The pipeline roles run on one Codex model that Justin sets in one synced place and can switch by asking any agent.

## Acceptance criteria (proposed: Justin gave none; "go" approves them)

All tests are functions in `~/.claude/setup/codex/codex-parity.test.sh`, run one at a time as `bash <worktree>/.claude/setup/codex/codex-parity.test.sh <test name>`, which prints numbered TAP (`ok 1 - <test name>`).

The tests marked **probe** make a real `codex exec` call through the probe home (Q8), with the cheapest settings that still prove the point. Every other test is offline: no sign-in, no network, no quota.

Fake homes live outside `$TMPDIR` and `/tmp`, so Codex's sandbox treats them like a real home. No test writes to the real `~/.codex`, `~/.claude`, `~/.hermes`, the real setup repo or GitHub.

- AC1 (proposed): Given the worktree's `agents-header.md`, `pipeline-model.toml` and a copy of the real `CLAUDE.md`, when `build-codex.sh` runs in a fake HOME, then all of the following hold. Test: `ac1_agents_md_loaded`.
  - `~/.codex/AGENTS.md` is the header with the current pipeline model filled in, a `git-hash` marker line, and `CLAUDE.md` byte-identical.
  - A second run doesn't rewrite it (same inode and mtime).
  - `--check` exits 1 after `CLAUDE.md` changes and 0 after a rebuild.
  - `codex debug prompt-input` in that fake HOME shows the header's first line, the `CLAUDE.md` sentence "**The main session only orchestrates.**" and the `~/.agents/skills` skill root, inside the user-instructions block.
- AC2 (proposed): Given the built `AGENTS.md`, hooks and skills in a fake HOME, when a fresh **probe** `codex exec` gets one prompt asking three things, then its first-turn answer covers all three and the JSON event stream shows **no** command or file-read tool call. Test: `ac2_first_turn_knows_rules`.
  - The question: may a commit carry an AI `Co-Authored-By` line? The answer must say no or never.
  - The question: what does the main session do for a bug or story? The answer must say it orchestrates.
  - The question: where are Justin's Hermes skills? The answer must say `~/.hermes/skills`.
- AC3 (proposed): Given a recorded Codex SessionStart payload, `codex-hooks.sh session-start` sends the right rules text in each case. Test: `ac3_session_start_rules_fresh`.
  - When `AGENTS.md` is current, the additionalContext holds the short pointer: the rules path, `~/.agents/skills` and `~/.hermes/skills`.
  - When `CLAUDE.md` changed after the build, it holds the full current `CLAUDE.md` with the word "supersedes", and `AGENTS.md` is rebuilt (`--check` is 0 afterwards).
  - When `AGENTS.md` is missing, it holds the full `CLAUDE.md`.
  - The output is valid JSON with only keys that Codex's SessionStart output schema allows.
- AC4 (proposed): Given a fake `HERMES_HOME` and `~/.codex/skills/.system`, when `update-skills-library.sh` runs (default mode with a local upstream clone, and `--links-only`), then all of the following hold. Test: `ac4_codex_sees_claude_skills`.
  - The fake `HERMES_HOME` has: own skills copied from the worktree, a fake library for the library skills, the worktree's `skills-library-claude.txt`, a stale and a broken link in `~/.agents/skills`, a non-link folder there, and a Hermes name also present in `.system`.
  - `~/.agents/skills/<n>` exists for exactly the names linked into `~/.claude/skills`, pointing at the same targets.
  - Stale and broken links it made are gone. Non-link folders are untouched.
  - The `.system` clash is skipped with a message.
  - A second run changes nothing.
  - `codex debug prompt-input` lists every one of the 17 Claude-linked names exactly once, and no skill name twice across all roots.
- AC5 (proposed): Given the seven role files `pipeline-{planner,builder,reviewer,fixer,verifier,auditor,finisher}.toml` copied into a fake `CODEX_HOME`, the role files are valid and load. Test: `ac5_roles_valid_and_load`.
  - `codex doctor --json` reports no "malformed agent role" startup warning, while a deliberately broken copy does produce one.
  - Each file has `name = "pipeline_<role>"`, a description and `developer_instructions`. Each sets `model` and `model_reasoning_effort` equal to `pipeline-model.toml`.
  - Each holds the contract phrases: "brief", "skill_lessons", "MAIN SESSION: check and save these skill_lessons now.", "Never spawn".
  - The reviewer, verifier and auditor files also hold "verdict" and "ac_status" and say they never edit source files.
- AC6 (proposed): Given the Codex payloads recorded in Task 2, `codex-hooks.sh` blocks and allows exactly like the Claude gates it reuses. Test: `ac6_gates_match_claude_twins`.
  - **SubagentStop:** for each report text (verdict without `ac_status`, verdict with it, no lessons, lessons, builder report, null message, `stop_hook_active: true`), `subagent-stop` blocks exactly when `subagent-ac-gate.sh` or `subagent-lessons-gate.sh` blocks on the Claude-shaped payload with the same text. Its reason is the Claude reasons joined, AC reason first. The exit is 0 and the output is empty or valid Codex SubagentStop JSON.
  - **Nudges:** over recorded PostToolUse payloads, the main session gets the main nudge text on the 15th call, a subagent payload (with `agent_id`) gets the subagent text, and UserPromptSubmit gets it on the 10th prompt. The text is identical to `skill-review-nudge.sh`'s for the same counts.
- AC7 (proposed): The five Claude hook scripts, their five test files and `~/.claude/settings.json` are byte-identical to the base commit, and all five Claude hook test files pass. Test: `ac7_claude_hooks_unchanged`.
- AC8 (proposed): The commit guard (`pre-tool`, `post-tool`) blocks AI co-author trailers. Test: `ac8_commit_guard_blocks_ai_trailer`.
  - `pre-tool` denies a Bash `git commit` whose message carries `Co-authored-by:` naming Codex, OpenAI, ChatGPT, GPT, Claude, Anthropic, Copilot or Gemini, in any case, inline or in a `-F` file. It allows other commits and other commands.
  - `post-tool`, after a `git commit` in a temp repo whose fresh HEAD carries such a trailer, returns a block whose reason says to amend without it. A clean HEAD, or an old HEAD from another committer, produces no block.
- AC9 (proposed): Given a fake HOME whose `.gitconfig` has a personal test identity plus `includeIf "gitdir:~/Leorna/"` with a Leorna test identity, a **probe** `codex exec` commits one file in `~/Leorna/repo1` and one in `~/proj/repo2` (added with `--add-dir`). Repo1's commit is authored by the Leorna test identity and repo2's by the personal one, and neither message has a `Co-authored-by` line. Test: `ac9_codex_commit_identity_no_trailer`.
- AC10 (proposed): Given the managed config in a fake `CODEX_HOME`, `codex sandbox -P claude-setup` and `codex execpolicy check` enforce exactly the Q4 boundaries. Test: `ac10_sandbox_profile_and_rules`.
  - Writes are allowed to `~/.hermes/skills/x`, `~/.hermes/plans/x`, `~/.claude/CLAUDE.md` and `~/.claude/projects/k/memory/n.md`, and `git commit` works in the workspace repo.
  - Writes are denied to `~/.claude/setup/sync.sh`, `~/.claude/settings.json`, `~/.claude/hooks/x`, `~/.hermes/scripts/x`, `~/.claude-setup.git/x`, `~/.codex/config.toml`, `~/.codex/hooks.json`, `~/.codex/rules/x` and `~/other/x`. Reading `~/.hermes/.env` is denied.
  - `codex execpolicy check --rules setup-sync.rules` returns `allow` for these:
    - `/Users/justin/.claude/setup/sync.sh`;
    - `/home/justin/.claude/setup/sync.sh pull`;
    - `/Users/justin/.claude/setup/codex/set-pipeline-model.sh gpt-6-luna`.

    It matches nothing for `bash /Users/justin/.claude/setup/sync.sh`, `/tmp/sync.sh` or `rm -rf /`.
- AC11 (proposed): Given a fake HOME with an attached setup repo, a local bare remote, a tracked skill edit, the rules file rewritten to the fake home's absolute paths and **no** hooks, a **probe** `codex exec` (approval `never`) asked to run the setup sync runs it. Afterwards the remote has a commit holding the edit and no lock is left. The same sync can't work inside the sandbox, because AC10 shows `~/.claude-setup.git` writes are denied, so the commit proves the allow rule ran it outside. Test: `ac11_codex_runs_sync_outside_sandbox`.
- AC12 (proposed): The extended `sync.test.sh` passes its new Codex checks. Test: `ac12_sync_codex_paths`.
  - `.codex/hooks.json`, `.codex/hooks/*.sh`, `.codex/hooks/tests/**`, `.codex/agents/*.toml`, `.codex/rules/setup-sync.rules`, `.claude/hooks/setup-sync-push.sh` and `.claude/setup/codex/**` reach the remote.
  - None of these is ever staged, even with the manifest widened to `:(glob).codex/**` and `:(glob).agents/**`: `.codex/{auth.json, config.toml, AGENTS.md, history.jsonl, session_index.jsonl, models_cache.json, version.json, installation_id, state_5.sqlite, logs_2.sqlite-wal, sessions/x, log/x, cache/x, .tmp/x, tmp/x, skills/.system/x, plugins/x, memories/x, rules/default.rules, hooks/state/x}`, `.agents/skills/<link>` or `.codex-probe/auth.json`.
- AC13 (proposed): `bash .claude/setup/sync.test.sh` in the worktree ends with `failed 0`. It passes every one of the 28 old checks plus the new ones (at least 32 in total), and its `SYNC` path is the test file's own checkout, not `$HOME`. Test: `ac13_sync_suite_green`.
- AC14 (proposed): The sync lock holds when Claude and Codex sync at the same moment, in two scenarios. Test: `ac14_lock_claude_and_codex_same_moment`.
  - A Claude-style manual `sync.sh` and a Codex push worker (`setup-sync-push.sh worker`, fast retry settings) start at the same instant on a fake home with two pending edits.
  - A sync is already holding `setup-sync.lock` when the worker starts, and the lock is released two seconds later.

  In both:
  - every edit reaches the remote exactly once;
  - each process exits 0, or the manual one prints "another sync is running" and its retry makes no new commit;
  - no `setup-sync.lock`, `worker.lock`, `index.lock` or half-done rebase is left;
  - no failure flag is left.
- AC15 (proposed): Given a recorded Codex SessionStart payload and a stub `sync.sh` (the stub style of `setup-sync-pull.test.sh`), `codex-hooks.sh session-start` reuses Claude's `setup-sync-pull.sh` unchanged. Test: `ac15_session_start_reuses_claude_pull`.
  - For each case (up to date, pulled, CONFLICT, unreachable, failed, busy), the `systemMessage` equals the Claude script's own for the same stub, and the Claude script's additionalContext appears verbatim at the start of the Codex additionalContext.
  - The hook runs the pull before reading `CLAUDE.md`: a stub that rewrites `CLAUDE.md` makes the full new text appear.
  - The output passes the SessionStart output-schema check.
- AC16 (proposed): The Stop push hook works in the background. Test: `ac16_stop_hook_pushes_in_background`.
  - After a tracked edit in a fake home, `codex-hooks.sh stop` returns within 1 s with no output. A detached worker pushes one commit to the local remote within 30 s, even after the hook's process group is killed right after it returns.
  - With nothing changed and nothing unpushed, the worker runs no `sync.sh` (no fetch, no new log line).
  - A gitleaks block or a CONFLICT leaves a flag. The next `prompt` call puts it in additionalContext. A later clean sync clears it.
- AC17 (proposed): Given a fake HOME with an attached setup repo, a local remote, the hooks, the managed config and skill `foo` linked at `~/.agents/skills/foo` to `~/.hermes/skills/sd/foo`, a **probe** `codex exec` is told to change `Version: v1` to `Version: v2` in skill foo and not to run any sync itself. Within 90 s after it exits, the remote's `main` holds `.hermes/skills/sd/foo/SKILL.md` with `v2`, in a commit by the fake home's identity with no `Co-authored-by` line, and no worker lock or flag is left. Test: `ac17_codex_skill_edit_reaches_remote`.
- AC18 (proposed): Given recorded SessionStart payloads, `codex-hooks.sh session-start` finds Claude's memory index the way Claude names the folder. Test: `ac18_memory_index_injected`.
  - The cwd `/x/proj/sub` finds `~/.claude/projects/-x-proj/memory/MEMORY.md` through the git root or a parent folder.
  - A desktop-style symlinked memory folder works.
  - The additionalContext includes the folder path, the first 200 lines of the index and the save instructions.
  - A cwd with no memory gets no memory text.
  - Neither `features.memories` nor any `memories.*` key is set by the managed config.
- AC19 (proposed): Given a copy of a `config.toml` shaped like Justin's, `setup-codex.sh` merges the managed config safely. Test: `ac19_config_merge_idempotent`.
  - The copy holds `model`, `model_reasoning_effort`, `personality`, a `[projects."…"]` trust table, the plugin table, a `[hooks.state."x"]` `trusted_hash` and an `[mcp_servers.x.env]` secret.
  - The script writes a backup, puts the managed top-level keys before the first table and the managed tables at the end, and keeps every other key and value (compared with `tomllib`).
  - A second run is byte-identical.
  - An unmanaged `project_doc_max_bytes` or `sandbox_mode` makes it exit 3 with the file untouched.
  - `codex debug prompt-input` with the result shows the `claude-setup` permission entries.
- AC20 (proposed): Given fake homes A (mac) and B (desk) on one local remote, edits on A reach B. Test: `ac20_codex_edit_reaches_other_machine`.
  - A changes a skill file, `CLAUDE.md` and a memory note, then runs `codex-hooks.sh stop`, and the worker finishes.
  - Then B runs `codex-hooks.sh session-start` with a recorded payload. B has all three edits. B's `~/.codex/AGENTS.md` holds the new `CLAUDE.md` line. The hook's additionalContext carries the new `CLAUDE.md` in full.
- AC21 (proposed): Given fake homes A and B, a fixture `models_cache.json` and the documented switch procedure, all of the following hold. Test: `ac21_pipeline_model_switch`.
  - `set-pipeline-model.sh gpt-nope` exits 2, prints the valid model list and changes no file or commit.
  - `set-pipeline-model.sh gpt-6-luna ultra` exits 2 and lists luna's efforts.
  - `set-pipeline-model.sh gpt-6-luna low` sets all seven role files and `AGENTS.md` to `gpt-6-luna`/`low`, and leaves one commit on the remote holding `pipeline-model.toml` and the seven role files. After `sync.sh pull`, B's role files say `gpt-6-luna`.
  - Editing `pipeline-model.toml` by hand to `gpt-6.1-sol`/`xhigh` and running `sync.sh` also rewrites and commits all seven role files.
- AC22 (proposed): After the setting is switched to `gpt-6-luna`/`low`, a **probe** `codex exec` spawns a `pipeline_planner` agent with a one-line probe brief. The recorded SubagentStop payload for that agent has `agent_type` `pipeline_planner` and `model` `gpt-6-luna`, while the parent runs on a different model. Test: `ac22_roles_use_switched_model`.
- AC23 (proposed): The docs are updated. Test: `ac23_docs_updated`.
  - `mac.md`, `desktop.md` and `~/.github/README.md` each have a "Codex" section naming: the install command, sign-in, `setup-codex.sh`, `/hooks` trust, the pipeline-model file and the three switch steps, what syncs and what never does, and "don't use `/import`".
  - `desktop.md`'s expected count reads `passed 32` (or the new total).
  - `~/.claude/CLAUDE.md` differs from base by exactly one added line in its Setup Sync section, mentioning Codex.
- AC24 (proposed) (live): In an `ubuntu:24.04` Docker container on the Mac, as a non-root user, every offline suite passes: `codex-parity.test.sh` (offline tests), `sync.test.sh` and the five Claude hook tests. The container has Codex 0.163.0 Linux, gitleaks 8.30.1, bubblewrap and `--privileged`. It is live because Docker isn't running now; if Docker is up when the verifier runs, it runs it, and otherwise Justin runs it in WSL. Test: `ac24_linux_suites`.
- AC25 (proposed) (live): On the desktop (WSL Ubuntu), after `sync.sh pull`, installing Codex, `setup-codex.sh` and trusting the hooks in `/hooks`, the real checks pass. Test: `ac25_desktop_codex_parity`.
  - `build-codex.sh --check` is 0.
  - `codex debug prompt-input` shows the header line and all 17 skills.
  - `codex doctor --json` shows no malformed roles.
  - A real `codex exec` answers the AC2 questions correctly on its first turn.
  - The session start printed a "Setup sync:" line.
- AC26 (proposed) (live): On the Mac, after the finisher's install, the same real checks as AC25 pass. Justin has trusted the six hooks in `/hooks`, and `codex debug prompt-input` with the real `~/.codex` shows no skill name twice, plugin skills included. Test: `ac26_mac_install_smoke`.
- AC27 (proposed) (live): A small real story run in Codex goes planner → builder → reviewer → fixer → reviewer → fixer → verifier → auditor → `ac-check.sh`, ending with `ALL ACCEPTED` or `READY FOR THE USER`. Every role is spawned as a `pipeline_*` agent, and the SubagentStop gate sends at least one report back once (seen in `~/.codex/hooks/state/` or the transcript). Test: `ac27_codex_story_run`.

## Facts checked for this plan (2026-10-28, read-only probes in temp folders)

Sources:
- the official Codex manual, fetched with the `openai-docs` system skill's `fetch-codex-manual.mjs`: sections "Custom instructions with AGENTS.md", "Build skills", "Hooks", "Multi-agent operations / Custom agents", "Permissions", "Rules", "Memories", "WSL", "Authentication";
- the hook JSON schemas in `openai/codex` `codex-rs/hooks/schema/generated`;
- offline probes with Codex 0.163.0.

**Rules files and instructions**
- **Global `AGENTS.md`** is read from `$CODEX_HOME/AGENTS.md` (`AGENTS.override.md` wins). Only that name works at the global level. A **symlinked** `AGENTS.md` is followed.
- **The size cap doesn't touch the global file.** A 40 KB global `AGENTS.md` was included in full alongside a project `AGENTS.md`. `project_doc_max_bytes` (32 KiB default) caps project docs only. Probe: `codex debug prompt-input`.
- **Project `CLAUDE.md` fallback:** `project_doc_fallback_filenames = ["CLAUDE.md"]` makes Codex load a project's `CLAUDE.md` when the folder has no `AGENTS.md` (probe). `leorna-client` and `leorna-control-plane` have their own `AGENTS.md`. FigmaToBricksV2's `CLAUDE.md` is 140,980 bytes.
- **`codex debug prompt-input`** renders the model-visible prompt offline, with no sign-in and no quota. It shows `AGENTS.md`, project docs, the skills list with its roots, and the active permission profile.
- **`codex doctor --json`** reports "Ignoring malformed agent role definition …" startup warnings offline. It does not validate `hooks.json`.

**Skills**
- User skills are read from **`$HOME/.agents/skills`**. The docs' table and the probe agree: the roots were `~/.agents/skills` and `$CODEX_HOME/skills/.system`. Symlinked skill folders are followed, and a broken link is silently ignored.
- Two skills with the same `name` both appear; Codex doesn't merge them.
- Hermes front matter with a `metadata.hermes` block is accepted. Descriptions over about 1,024 characters are cut with "…". The 17 Claude-linked Hermes skills have 45 to 62 character descriptions, and each one's `name` equals its folder.
- There's no name clash between those 17 and `.system` (imagegen, openai-docs, plugin-creator, review-agent, skill-creator, skill-installer). The `github@openai-curated` plugin bundles a `github` skill, which clashes with Hermes `github` (Q10). How plugin skills are listed couldn't be checked offline; AC26 checks it on the real config.

**Custom agents (roles)**
- Standalone files in `~/.codex/agents/*.toml` are auto-discovered. Each needs `name`, `description` and `developer_instructions`. `model` and `model_reasoning_effort` in the file take precedence over spawn values and `[agents]` defaults.
- Custom agents inherit the parent's sandbox and approval policy, and can't change them.
- Skills are inherited from the parent.
- Built-in agent types: `default`, `worker`, `explorer`.

**Hooks**
- `~/.codex/hooks.json` holds these events: SessionStart (matcher on `source`), UserPromptSubmit, PreToolUse and PostToolUse (shell commands match `Bash`, edits `apply_patch`/`Edit`/`Write`, `spawn_agent` also matches `Agent`), SubagentStart, SubagentStop (matcher on `agent_type`), Stop, PreCompact, PostCompact, SessionEnd and Interrupt.
- Matching command hooks run **concurrently**. Hooks need `/hooks` trust per definition hash. `--dangerously-bypass-hook-trust` skips trust for one run.
- Output contract:
  - Exit 0 with no output means success.
  - SessionStart accepts `systemMessage` and `hookSpecificOutput.additionalContext`.
  - SubagentStop and Stop accept `{decision:"block", reason}`.
  - PreToolUse accepts `permissionDecision: "deny"`.
  - PostToolUse accepts `decision: "block"` (it replaces the tool result) and additionalContext.
  - `async: true` hooks are **cancelled when the session ends**.
- SubagentStop input has `agent_id`, `agent_type`, `stop_hook_active` and `last_assistant_message` (string or null). These are the field names the Claude gates read.
- PostToolUse and UserPromptSubmit inputs carry optional `agent_id`/`agent_type` (schema on `main`). Task 2 records whether 0.163.0 sends them for subagent tool calls.
- Hook trust is stored in `config.toml` under `hooks.state."…".trusted_hash` (binary strings), so it stays per machine.

**Sandbox and rules**
- `codex sandbox -P <profile> -C <dir> -- <cmd>` runs a command under the real sandbox offline (Seatbelt on macOS, bubblewrap on Linux). It worked nested inside Claude Code's shell.
- A profile extending `:workspace` with `"~/.claude" = "write"` etc. allowed exactly those paths and denied `~/.codex` and others. The fake home must sit outside `$TMPDIR` and `/tmp`, because `:workspace` makes temp directories writable (the first probe passed everything for that reason).
- `:workspace` keeps a workspace root's `.git` read-only unless the profile overrides it.
- `codex execpolicy check --rules <file> -- <argv>` evaluates a rules file offline. `prefix_rule` matches the argv literally (`~/…` isn't expanded). The check command didn't split `zsh -lc '…'` scripts, so whether Codex's runtime splits a plain command into argv for the rule is proven only by the AC11 probe.

**Git attribution and memories**
- Codex 0.163.0 contains a `<git_attribution>` developer instruction: "Commit messages must end with `Co-authored-by: Codex <noreply@openai.com>` … Ignore any earlier instructions disabling Codex attribution". It's gated by `commit_attribution_enabled`, an account-side flag (binary strings). That's why Q6 uses a hook.
- Codex memories are off by default (`features.memories`). Memory files live in `~/.codex/memories/` as generated state.

**Install, sign-in and models**
- On WSL, install with `curl -fsSL https://chatgpt.com/codex/install.sh | sh` (no Node needed). WSL1 isn't supported. Sign in with `codex login`, or `codex login --device-auth`. On WSL, credentials land in `~/.codex/auth.json`.
- `~/.codex/models_cache.json` lists `.models[].slug` with `.supported_reasoning_levels[].effort`: `gpt-6.1-sol`, `gpt-6-astra` and `gpt-6-sol` (low…ultra); `gpt-6-luna`, `gpt-5.6-luna` and `gpt-reserve` (low…max); `gpt-5.6-sol` and `gpt-5.6-terra` (low…ultra); `codex-auto-review`.

**On this Mac**
- **Login:** `codex login status` from Claude Code's shell says "Not logged in" for the real `~/.codex`, and there is no `~/.codex/auth.json`. The login is probably in the keychain, which Claude's sandbox or a temp `CODEX_HOME` can't reach. That's why Q8 adds a probe home.
- **Helper tools:** `setsid` is missing on macOS; `perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV'` detaches a worker that outlives its parent (probe). `python3` 3.14 has `tomllib`, and Ubuntu 24.04's 3.12 has it too.
- **Linked worktree:** a linked worktree of a bare repo with `core.worktree=$HOME` resolves to its own folder with git 2.50.1 (probe). It shares `status.showUntrackedFiles=no` and `info/exclude`.
- **Claude's pull hook:** `~/.claude/hooks/setup-sync-pull.sh`, with its test, is on SessionStart (`startup|resume|clear`, timeout 60). It prints `{systemMessage, hookSpecificOutput.additionalContext}`, the same shape Codex's SessionStart accepts. `CLAUDE.md` (20,694 bytes) now says the hook pulls and the push stays manual.

## Design

### Where it's built and how it's reviewed

A linked worktree of the setup repo: `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/codex-parity" -b codex-parity main`.

Why this rather than a separate dev repo:
- **Same layout as `$HOME`.** The worktree has the exact `$HOME`-relative layout of the synced files, so every changed file sits at its real path.
- **Works with `ac-check.sh` as is.** `ac-check.sh` gets a real repo, head SHA and base (`git -C <worktree> merge-base HEAD main`).
- **One diff to review.** Reviewers see one diff against `main`.
- **The merge is the install.** The finisher's `merge --ff-only` into `main`, whose work tree is `$HOME`, places every synced file.
- **Nothing synced by accident.** `~/.claude-setup-wt/` matches no manifest pathspec, and git won't descend into it because it holds a `.git` file, so `sync.sh` never stages it.

Things the builder and verifier must know:
- `status.showUntrackedFiles=no` is shared config, and `ac-check.sh`'s dirty check uses plain `git status --porcelain`. Always check `git -C <wt> status --porcelain --untracked-files=all` is empty before handing over. A new test file not added to git would otherwise be invisible.
- Tests use the checkout they live in (paths relative to the test file), never `$HOME/.claude/...`. `sync.test.sh` changes its `SYNC`/`REAL_SETUP` lines accordingly; run from `$HOME` it still tests the live copy.
- Commits in the worktree use the global personal identity, with no `Co-Authored-By` line (CLAUDE.md rule).
- `main` keeps moving while the story runs, because syncs commit on it. The finisher rebases.

### Files (paths are `$HOME`-relative; they live at the same path in the worktree)

New:
- `.claude/setup/codex/agents-header.md`: the Codex adapter (where things are, tool map, pipeline model, Codex-only rules).
- `.claude/setup/codex/pipeline-model.toml`: **the one model setting**.
- `.claude/setup/codex/build-codex.sh`: builds `~/.codex/AGENTS.md` and the role files' model lines from the sources.
- `.claude/setup/codex/set-pipeline-model.sh`: the switch procedure (check, edit, sync).
- `.claude/setup/codex/config.managed.toml`: the managed `config.toml` blocks.
- `.claude/setup/codex/setup-codex.sh`: the per-machine installer. It merges the config, builds the files, links the skills and checks the result.
- `.claude/setup/codex/codex-parity.test.sh`: all AC tests.
- `.claude/setup/codex/probe-lib.sh`: runs a real `codex exec` through the probe home.
- `.claude/setup/codex/capture-payloads.sh`: records real hook payloads (Task 2).
- `.claude/hooks/setup-sync-push.sh`: the tool-neutral push worker (registered only for Codex now).
- `.codex/agents/pipeline-{planner,builder,reviewer,fixer,verifier,auditor,finisher}.toml`.
- `.codex/hooks.json`.
- `.codex/hooks/codex-hooks.sh`: the one Codex hook dispatcher, which reuses the Claude scripts.
- `.codex/hooks/tests/fixtures/*.json`: recorded payloads plus a trimmed `models_cache.sample.json` and the SessionStart, SubagentStop and PreToolUse output schemas.
- `.codex/rules/setup-sync.rules`.

Changed:
- `.claude/setup/sync.sh`: `DENY_RE` additions, a `changed` command, rebuilding the Codex files on sync and after a pull.
- `.claude/setup/sync.test.sh`: path fix and the new checks.
- `.claude/setup/manifest.txt`, `.claude/setup/exclude.txt`.
- `.hermes/scripts/update-skills-library.sh`: the `~/.agents/skills` links and `--links-only`.
- `.claude/setup/mac.md`, `.claude/setup/desktop.md`, `.github/README.md`: Codex sections.
- `.claude/CLAUDE.md`: one line.

Unchanged by design: the five Claude hook scripts and tests, `settings.json`, `ac-check.sh`, `feature-dispatch`, every skill.

Generated per machine, never synced: `~/.codex/AGENTS.md`, `~/.agents/skills/*` links, `~/.codex/config.toml`, hook state.

### AGENTS.md: a generated adapter, one source of truth

The three options:
- **A pointer** ("read `~/.claude/CLAUDE.md`") depends on the model choosing to read a file on turn one. Requirement 2 needs the rules loaded before turn one, so it fails that test.
- **A copy** would drift.
- **A symlink** to `CLAUDE.md` gives Codex Claude's tool names with no map, unless `CLAUDE.md` grows a Codex section that every Claude session would then load.

So `~/.codex/AGENTS.md` is **generated**: `agents-header.md` (about 5 KB, with the pipeline model filled in), then a marker carrying `CLAUDE.md`'s `git hash-object`, then `CLAUDE.md` verbatim. That's about 26 KB, and global files aren't capped (probe).

How it stays current:
- **One source of truth.** The two sources are synced; the output is not.
- **Rebuilt on every sync.** `sync.sh` rebuilds it on every run (`stage`) and after a pull that changed a source. `setup-codex.sh` builds it on install.
- **A last line of defence.** The SessionStart hook compares the marker with the live `CLAUDE.md` after its pull. If they differ, for example because Claude edited `CLAUDE.md` without syncing or the pull just brought a new one, it puts the full current `CLAUDE.md` in the session as "supersedes" and rebuilds the file for the next session (AC3, AC20).

What Codex loads at session start:
- base instructions;
- the skills list (name, description, path, with roots `~/.agents/skills` and `.system`);
- multi-agent instructions;
- the user-instructions block: global `AGENTS.md`, then project docs from the git root down to the cwd;
- the SessionStart hook's context.

How Codex loads a skill by name: it opens `<root>/<name>/SKILL.md` from that list, or Justin types `$name`. The header maps "load skill X / the Skill tool" to exactly that.

`agents-header.md` (complete text; `@PIPELINE_MODEL@` and `@PIPELINE_EFFORT@` are filled by `build-codex.sh`). After Task 2, the builder replaces the `spawn_agent` parameter wording with the exact field names recorded in the PreToolUse fixture for `spawn_agent`.

```markdown
# Justin's rules, for Codex (generated file: never edit it)

Built by `~/.claude/setup/codex/build-codex.sh` from `~/.claude/setup/codex/agents-header.md` (this part) and Justin's rulebook `~/.claude/CLAUDE.md` (copied verbatim below). To change a rule, edit those sources; `~/.claude/setup/sync.sh` rebuilds this file on every sync, and the session-start hook rebuilds it when it is stale.

CLAUDE.md is written for Claude Code. You are Codex: follow every rule in it, translating Claude Code's tools with the map below. "The user" is Justin. Where this header and CLAUDE.md disagree about a Codex detail, this header wins; on everything else CLAUDE.md wins.

## Where things are
- **Rules:** `~/.claude/CLAUDE.md` (below). A project's own rules: its `AGENTS.md`, or else its `CLAUDE.md` (Codex loads either).
- **Skills:** Justin's Hermes skills, the same set Claude Code uses, are linked at `~/.agents/skills/<name>` (your skills list). Their real files are in `~/.hermes/skills/<category>/<name>/`; library skills in `~/.hermes/skills-library/skills/<name>/`. "Load skill X", or "invoke X with the Skill tool", means: open X's `SKILL.md` from your skills list, follow it, and say so in one line.
- **Memory:** Claude Code's notes for the project, in `~/.claude/projects/<key>/memory/` (key: the project path with every character that is not a letter or digit turned into `-`). The session-start note shows the index. Codex's own memories are off: save notes there, the way Claude does (one `.md` file with name/description/metadata front matter, plus a one-line link in `MEMORY.md`).
- **Plans, briefs, evidence:** `~/.hermes/plans/…`, exactly as CLAUDE.md says.
- **Setup sync:** `~/.claude/setup/sync.sh`. Hooks pull at session start and push in the background after a turn that changed synced files; you may also run it yourself, as CLAUDE.md says.

## Tool map
| CLAUDE.md says | In Codex |
|---|---|
| the Agent tool; "a fresh general-purpose agent with model opus, effort xhigh"; dispatch a planner, builder, reviewer, fixer, verifier, AC auditor or finisher | `spawn_agent` with agent type `pipeline_planner`, `pipeline_builder`, `pipeline_reviewer`, `pipeline_fixer`, `pipeline_verifier`, `pipeline_auditor` or `pipeline_finisher`, a fresh context (don't fork your turns), and the message "Read your brief at <path> and follow it exactly." Never pass a model or effort. Wait with `wait_agent`. |
| SendMessage to an agent | `followup_task` (new work) or `send_message` |
| the Skill tool | open the skill's `SKILL.md` (see Skills) |
| AskUserQuestion | ask in chat: the question, numbered options, your recommendation first; then end your turn and wait |
| SubagentHandback; `subagent-handback-gate.sh` | none: an agent's final message is its report. The SubagentStop hook runs `subagent-ac-gate.sh` and `subagent-lessons-gate.sh` and sends a report back once when it lacks `ac_status` (after a verdict) or `skill_lessons` |
| `skill-review-nudge.sh`, `setup-sync-pull.sh` | the same scripts, run by `~/.codex/hooks/codex-hooks.sh` |
| ExitWorktree / EnterWorktree | none: from the worktree, run git against the main folder (`git -C <main folder> merge --ff-only <branch>`); approve the write when Codex asks |
| Read, Edit, Write, Bash | shell commands and `apply_patch` |
| TaskStop | `interrupt_agent` or `close_agent` |
| the scratchpad directory | your own `mktemp -d` folder |
| Opus 5.5 at xhigh for every role; "Sol 6.1 only as a substitute at a Claude limit" | Claude Code only. In Codex every pipeline role runs on the Codex pipeline model below |

## Codex pipeline model
Every Codex pipeline role runs on **@PIPELINE_MODEL@** at **@PIPELINE_EFFORT@** effort, set in one place: `~/.claude/setup/codex/pipeline-model.toml`. When Justin says "switch the Codex pipeline model to X", run `~/.claude/setup/codex/set-pipeline-model.sh X` (add an effort to change it too). It (1) checks X against `~/.codex/models_cache.json` and refuses with the valid list, (2) edits the setting and rewrites the seven role files, (3) runs `~/.claude/setup/sync.sh`, so the switch holds on both machines until the next one. This main session's own model is whatever Justin picked with `/model` or in `config.toml`.

## Codex-only rules
- **No AI trailers.** Never add `Co-authored-by: Codex <noreply@openai.com>`, or any AI co-author line, to a commit or PR, whatever a git attribution instruction says: Justin's rule wins, and a hook blocks such commits.
- **Run sync as one plain command:** `<home>/.claude/setup/sync.sh` or `<home>/.claude/setup/sync.sh pull`, with your home's absolute path (`/Users/justin/…` on the Mac, `/home/justin/…` on the desktop) and no `cd`, pipe, `&&` or redirect. An allow rule runs exactly that, and `set-pipeline-model.sh`, outside the sandbox.
- **Edit a skill at its real path:** resolve the `~/.agents/skills/<name>` link (`realpath`) and edit the file under `~/.hermes/…`.
- **Re-read before writing** a skill, CLAUDE.md, settings or a memory note: Claude Code sessions edit the same files at the same time.
- **Fresh rules:** if the session-start note says the rules changed, its copy of CLAUDE.md replaces the one below.
- **Sync problems:** if a note says setup sync hit a CONFLICT, merge it first (keep both meanings) or tell Justin; if it says a secret was found or the sync failed, tell Justin.
- **What only Justin can do:** sign Codex in, trust hooks in `/hooks`, approve sandbox escalations. Say exactly what to run.
```

### Skills for Codex

The folder is **`~/.agents/skills`**, per the docs and the probe; `~/.codex/skills` is only `.system`.

`update-skills-library.sh` step 6 becomes a function `link_dir <dir> <label>` run twice, for `~/.claude/skills` (unchanged messages) and `~/.agents/skills`. Both use the same names from `skills-library-claude.txt` and the same targets, so Codex sees exactly what Claude sees. The Codex pass has three extras:
- it skips a name that exists in `${CODEX_HOME:-~/.codex}/skills/.system`, with a message;
- it never touches non-link entries (Justin's own Codex skills);
- it removes stale or broken links that point into `~/.hermes/skills` or the library.

`--links-only` runs only step 6, for `setup-codex.sh` and tests. Duplicates with plugin skills are handled in `setup-codex.sh` (Q10).

On Linux, the script already uses `find -lname`, `readlink` and `ln -sfn`, which are the same on GNU. Broken-link checks use `[ -e "$l" ]` per link (BSD `find` has no `-xtype`).

Change to the summary line: `… claude links: +a -r   codex links: +a -r`.

### Pipeline roles in Codex

**The role files.** Seven standalone files in `~/.codex/agents/`, auto-discovered (no `config.toml` entries), synced. They're validated offline with `codex doctor --json` and checked for loading in AC27. The model is in each file (a file's value beats spawn values). `build-codex.sh` rewrites only the `model =` and `model_reasoning_effort =` lines from `pipeline-model.toml`.

**Why not one `config.toml` setting.** `[agents] default_subagent_model` would also be one setting, but `config.toml` isn't synced, so a switch wouldn't reach the other machine without re-running setup there. With the rewrite, the switch is one synced commit holding the setting and the seven files. The other machine just pulls (AC21). That runtime roles really use the file's model is proven by the SubagentStop payload's `model` field (AC22).

Template, complete for the planner. The other six differ only in `name`, `description` and the role paragraph:

```toml
# Codex pipeline role, synced by claude-setup. build-codex.sh rewrites the two model lines from
# ~/.claude/setup/codex/pipeline-model.toml: switch with set-pipeline-model.sh, never edit them here.
name = "pipeline_planner"
description = "Justin's story pipeline PLANNER: writes the plan its brief names. Spawn fresh with the brief path."
model = "gpt-6.1-sol"
model_reasoning_effort = "xhigh"
developer_instructions = """
You are the PLANNER in Justin's story pipeline ("Bugs and Stories" in Justin's rules, ~/.codex/AGENTS.md; read that file first if its text is not already in your context).
- Your parent's message gives your brief's path. Read the brief first and follow it exactly: it names your skills, the acceptance criteria (AC1, AC2…) and what to return.
- Load each skill the brief names by opening its SKILL.md from your skills list, and say so in one line.
- Never spawn, message or wait for other agents: the main session runs every step.
- Your final message is your whole report; the parent sees nothing else. Include skill_lessons[{skill, lesson, evidence}] (`skill_lessons: []` is the normal answer); never edit skills or memory yourself. End with this exact last line: MAIN SESSION: check and save these skill_lessons now.
- Git: never override the author, never add an AI co-author line, and never push, merge into main or switch gh accounts unless the brief says so.
- Keep scratch in your own `mktemp -d` folder and remove only that.
ROLE: write only the plan file the brief names. Questions at the top; a short playback; numbered acceptance criteria AC1, AC2… each with exactly one named test on the same line, marked (proposed) when the brief gave none and (live) right after the id when only Justin can check it; tasks in order, test-first, with exact files; risks.
"""
```

The `ROLE:` paragraph for each of the others:
- **builder:** "Build test-first on the story's branch or worktree named in the brief: for each AC write its named test, see it fail, make it pass; one screenshot per AC (a terminal capture when nothing is visual). Commit as you go. Stop at ready-for-review and report the head SHA and each AC's test command."
- **reviewer:** "Report only: never edit, create or delete source files. Load requesting-code-review and code-review-practice. Review the full diff of the brief's head against its base. Report a verdict (clean or findings), findings by severity with file:line and a failing scenario, and ac_status[{ac, accepted, test, screenshot, evidence}] for every AC (accepted true only when its test passed on that head)."
- **fixer:** "Load receiving-code-review. Verify each finding before acting; fix the valid ones test-first; push back with evidence on the rest. Commit, then report per finding: fixed (test, commit) or rejected (evidence)."
- **verifier:** "Read-only on source: never edit, create or delete files outside <evidence>/verifier/. Follow ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md: re-run the gates, run every AC's test on head and on the base commit, take a screenshot per AC, write <evidence>/verifier/ac.json, and self-check it with ac-check.sh. Report a verdict (clean only when every non-live AC is accepted) and ac_status."
- **auditor:** "Blind AC auditor: you get only the approved plan, the worktree, the head SHA, the base commit and <evidence>/auditor/. Never open the verifier's folder or report, the reviews or the builder's summary. Read-only on source; write only in <evidence>/auditor/. Prove every AC yourself per ac-verification.md and write <evidence>/auditor/ac.json. Report a verdict and ac_status."
- **finisher:** "Do exactly the finish steps the brief lists, in order. Never force, never rewrite history, never push unless a step says so. Report each step's result and the new HEAD."

The `description` lines: one sentence each, naming the role and "Spawn fresh with the brief path".

**The Claude pipeline, mapped onto Codex.**

| Claude pipeline step | In Codex |
|---|---|
| Agent tool → a fresh agent | `spawn_agent` with type `pipeline_<role>`, fresh context, message with the brief path; `wait_agent` |
| AskUserQuestion (step 1, decisions) | a plain question in chat, then end the turn |
| The plan-approval stop | the turn ends; "go" arrives as Justin's next message; then `install -m 444 <plan> <evidence>/plan-approved.md` |
| Briefs | saved to `~/.hermes/plans/<project>/briefs/<name>-<role>.md` before spawning (that path is writable) |
| `ac-check.sh` | run unchanged by the main session (read-only command) |
| `sync.sh pull` before the planner | the SessionStart hook already pulled; step 2 runs `sync.sh pull` again via the allow rule |
| SubagentHandback gates | the SubagentStop gate |
| Sol 6.1 at a Claude limit | n/a: the roles use the Codex pipeline model |

Sandbox and approval are the parent's. Read-only roles are read-only by instruction, the same as Claude's.

### Hooks for Codex

There is **one handler per event**, all going through `~/.codex/hooks/codex-hooks.sh <mode>`. Codex runs matching hooks concurrently, so one handler per event keeps the order fixed and merges the output deterministically. In particular, the rules check must run after the pull.

| Event (matcher) | Mode | What it does | Reuses |
|---|---|---|---|
| SessionStart (`startup\|resume\|clear`, timeout 60, `additionalContextLimit` 12000) | `session-start` | Records the `AGENTS.md` marker; runs Claude's pull hook on the same stdin; keeps its `systemMessage` and puts its additionalContext first; then adds the rules (pointer, or full `CLAUDE.md` + rebuild when stale), open push problems and the memory index | `~/.claude/hooks/setup-sync-pull.sh` unchanged |
| UserPromptSubmit (timeout 10) | `prompt` | Nudge text + open push problems | `skill-review-nudge.sh`, `setup-sync-push.sh notes` |
| PreToolUse (`^Bash$`, timeout 10) | `pre-tool` | Denies a `git commit` with an AI trailer | none (Codex-only) |
| PostToolUse (all, timeout 10) | `post-tool` | Nudge; after a `git commit`, a block if fresh HEAD has an AI trailer | `skill-review-nudge.sh` |
| SubagentStop (all, timeout 20) | `subagent-stop` | Runs the AC gate then the lessons gate on the same stdin; one `{decision:block}` with both reasons, AC first | `subagent-ac-gate.sh`, `subagent-lessons-gate.sh` unchanged |
| Stop (timeout 10) | `stop` | Starts the detached push worker and returns at once with no output | `setup-sync-push.sh` |

Claude events with no Codex counterpart:
- **PreToolUse on SubagentHandback**, and so `subagent-handback-gate.sh`: Codex has no handback tool. Every spawned agent ends through SubagentStop, whose `decision: block` continues that agent with the reason, and `stop_hook_active` makes it once only, as in Claude. The combining that `subagent-handback-gate.sh` did happens in `subagent-stop`.
- **Claude's native `MEMORY.md` loading:** replaced by the session-start memory index.

The gates keep separate state from Claude's: `SUBAGENT_AC_STATE_DIR`, `SUBAGENT_LESSONS_STATE_DIR` and `SKILL_NUDGE_STATE_DIR` point under `~/.codex/hooks/state/`.

Pull and push events, justified:
- **SessionStart** is the only hook that runs before the first model request of every session. Claude uses the same event and matcher (`compact` and `fork` are excluded: no network on compaction).
- **Stop** fires once per main-thread turn, after all its edits, including edits made through Bash or by subagents. PostToolUse(apply_patch) would fire per edit and miss shell edits.
- The handler forks a worker (perl `POSIX::setsid`) instead of using `async: true`, because async hooks are cancelled when the session ends. A `codex exec` ends right after its last turn, which would kill a half-done push and leave the lock for ten minutes.
- The worker, not the hook, decides whether anything changed (`sync.sh changed`), so the turn never waits on git.
- SessionEnd isn't used: the next Stop or session catches anything an interrupted turn left.

`hooks.json` (complete):

```json
{
  "description": "Justin's Codex hooks, synced by claude-setup. One handler per event; see ~/.codex/hooks/codex-hooks.sh. Trust them in /hooks after any change to this file.",
  "hooks": {
    "SessionStart": [{"matcher": "startup|resume|clear", "hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh session-start", "timeout": 60, "statusMessage": "Pulling setup files from GitHub", "additionalContextLimit": 12000}]}],
    "UserPromptSubmit": [{"hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh prompt", "timeout": 10}]}],
    "PreToolUse": [{"matcher": "^Bash$", "hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh pre-tool", "timeout": 10}]}],
    "PostToolUse": [{"hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh post-tool", "timeout": 10}]}],
    "SubagentStop": [{"hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh subagent-stop", "timeout": 20}]}],
    "Stop": [{"hooks": [{"type": "command", "command": "bash ~/.codex/hooks/codex-hooks.sh stop", "timeout": 10}]}]
  }
}
```

`~/.codex/hooks/codex-hooks.sh` (complete starting code; the builder adjusts only to pass the tests, and must keep bash 3.2 compatibility):

```bash
#!/usr/bin/env bash
# Justin's Codex hooks: one handler per event, registered in ~/.codex/hooks.json.
# Claude Code's own hook scripts in ~/.claude/hooks run unchanged; this adds what Codex needs:
#   session-start  Claude's setup-sync-pull.sh, then the rules (a pointer, or the full CLAUDE.md
#                  when ~/.codex/AGENTS.md is stale), open push problems, the Claude memory index
#   prompt         skill-review nudge + open push problems
#   pre-tool       (Bash) deny a git commit whose message has an AI co-author trailer
#   post-tool      skill-review nudge; after a git commit, block when the new HEAD has one
#   subagent-stop  AC gate + lessons gate, both reasons in one block (Codex has no handback tool)
#   stop           start the detached setup push worker; returns at once, prints nothing
# Bad input exits 0 silently: a hook must never trap Codex.
# Tests: ~/.claude/setup/codex/codex-parity.test.sh
set -uo pipefail

CLAUDE_HOOKS=${CODEX_HOOKS_CLAUDE_DIR:-$HOME/.claude/hooks}
BUILD=${CODEX_HOOKS_BUILD:-$HOME/.claude/setup/codex/build-codex.sh}
RULES=${CODEX_HOOKS_RULES:-$HOME/.claude/CLAUDE.md}
STATE=${CODEX_HOOKS_STATE_DIR:-$HOME/.codex/hooks/state}
PUSH="$CLAUDE_HOOKS/setup-sync-push.sh"
AI_TRAILER='co-authored-by:.*(codex|openai|chatgpt|gpt|claude|anthropic|copilot|gemini)'
POINTER="Justin's rules: ~/.claude/CLAUDE.md, loaded in full through ~/.codex/AGENTS.md (current). Skills: the Hermes skills, linked at ~/.agents/skills/<name>/SKILL.md (real files in ~/.hermes/skills/<category>/<name>/, library skills in ~/.hermes/skills-library/skills/<name>/); open a skill's SKILL.md before using it. Setup sync: pulled at session start, pushed in the background after turns that change synced files."

mode=${1:-}
input=$(cat) || exit 0
field() { jq -r "$1 // empty | tostring" <<<"$input" 2>/dev/null; }
join() { local out="" p; for p in "$@"; do [ -n "$p" ] && out="${out:+$out

}$p"; done; printf '%s' "$out"; }
context() { [ -n "$2" ] && jq -nc --arg e "$1" --arg c "$2" '{hookSpecificOutput: {hookEventName: $e, additionalContext: $c}}'; return 0; }
nudge() {
  [ -f "$CLAUDE_HOOKS/skill-review-nudge.sh" ] || return 0
  printf '%s' "$input" | SKILL_NUDGE_STATE_DIR="$STATE/skill-review-nudge" bash "$CLAUDE_HOOKS/skill-review-nudge.sh" 2>/dev/null \
    | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null
}
push_notes() { [ -f "$PUSH" ] && bash "$PUSH" notes </dev/null 2>/dev/null; return 0; }
commit_cmd() { grep -qE '(^|[;&|(]|[[:space:]])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)' <<<"$1"; }

memory_note() {
  local cwd root d key f
  cwd=$(field .cwd); [ -n "$cwd" ] || return 0
  root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  { echo "$cwd"; [ -n "$root" ] && echo "$root"; d=$cwd
    while d=$(dirname "$d") && [ "$d" != / ] && [ "$d" != . ]; do echo "$d"; done; } |
  while IFS= read -r d; do
    key=$(printf '%s' "$d" | sed 's/[^a-zA-Z0-9]/-/g')
    f="$HOME/.claude/projects/$key/memory/MEMORY.md"
    [ -f "$f" ] || continue
    printf 'Claude memory for this project (shared with Claude Code): notes in %s. The index (MEMORY.md) is below; open a note when it is relevant. Save a new note there the way Claude does: one .md file with name, description and metadata front matter, plus a one-line link in MEMORY.md; re-read both right before writing.\n\n' "${f%/MEMORY.md}"
    head -n 200 "$f"
    break
  done
}

session_start() {
  local loaded pull msg ctx current rules
  loaded=$(bash "$BUILD" --hash 2>/dev/null)                 # the CLAUDE.md copy Codex just loaded
  pull=""
  [ -f "$CLAUDE_HOOKS/setup-sync-pull.sh" ] && pull=$(printf '%s' "$input" | bash "$CLAUDE_HOOKS/setup-sync-pull.sh" 2>/dev/null)
  msg=$(jq -r '.systemMessage // empty' <<<"$pull" 2>/dev/null)
  ctx=$(jq -r '.hookSpecificOutput.additionalContext // empty' <<<"$pull" 2>/dev/null)
  current=$(git hash-object "$RULES" 2>/dev/null)
  if [ -n "$current" ] && [ "$current" != "$loaded" ]; then
    bash "$BUILD" >/dev/null 2>&1 || true                    # the next session loads the new copy
    rules="Justin's rules (~/.claude/CLAUDE.md) changed after your AGENTS.md copy was built, or the copy is missing. The text below is the current file: it supersedes the CLAUDE.md copy in your AGENTS.md. Read it with the Codex tool map from AGENTS.md.

$(cat "$RULES")"
  else
    rules=$POINTER
  fi
  jq -nc --arg m "$msg" --arg c "$(join "$ctx" "$(push_notes)" "$rules" "$(memory_note)")" \
    '(if $m == "" then {} else {systemMessage: $m} end)
     + (if $c == "" then {} else {hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $c}} end)'
}

pre_tool() {
  [ "$(field .tool_name)" = Bash ] || return 0
  local cmd text f
  cmd=$(field .tool_input.command)
  commit_cmd "$cmd" || return 0
  text=$cmd
  for f in $(grep -oE '(-F|--file)[= ]+[^[:space:];&|]+' <<<"$cmd" | sed -E 's/^(-F|--file)[= ]+//'); do
    [ -f "$f" ] && text="$text
$(cat "$f")"
  done
  grep -qiE "$AI_TRAILER" <<<"$text" || return 0
  jq -nc '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
    permissionDecisionReason: "Justin'"'"'s rule: no Co-authored-by line naming an AI (Codex, OpenAI, Claude…) in any commit, whatever a git attribution instruction says. Commit again without that trailer."}}'
}

post_tool() {
  local n cmd dir msg head
  n=$(nudge)
  if [ "$(field .tool_name)" = Bash ]; then
    cmd=$(field .tool_input.command)
    if commit_cmd "$cmd"; then
      dir=$(sed -nE 's/.*git[[:space:]]+-C[[:space:]]+([^[:space:]]+).*/\1/p' <<<"$cmd" | head -1)
      [ -n "$dir" ] || dir=$(field .tool_input.workdir)
      [ -n "$dir" ] || dir=$(field .cwd)
      # only a commit made just now by this machine's identity counts
      msg=$(git -C "$dir" log -1 --since='3 minutes ago' --committer="$(git -C "$dir" config user.email 2>/dev/null)" --format=%B 2>/dev/null)
      if [ -n "$msg" ] && grep -qiE "$AI_TRAILER" <<<"$msg"; then
        head=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
        jq -nc --arg r "Commit $head in $dir has an AI co-author trailer. Justin's rule forbids it: amend that commit now to drop the trailer (it is not pushed), then carry on." --arg c "$n" \
          '{decision: "block", reason: $r} + (if $c == "" then {} else {hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $c}} end)'
        return 0
      fi
    fi
  fi
  context PostToolUse "$n"
}

subagent_stop() {
  local g out r reasons=""
  for g in subagent-ac-gate.sh subagent-lessons-gate.sh; do   # AC first: the lessons reason sets the last line
    [ -f "$CLAUDE_HOOKS/$g" ] || continue
    out=$(printf '%s' "$input" | SUBAGENT_AC_STATE_DIR="$STATE/subagent-ac-gate" \
      SUBAGENT_LESSONS_STATE_DIR="$STATE/subagent-lessons-gate" bash "$CLAUDE_HOOKS/$g" 2>/dev/null) || continue
    r=$(jq -r 'select(.decision == "block") | .reason // empty' <<<"$out" 2>/dev/null) || continue
    reasons=$(join "$reasons" "$r")
  done
  [ -n "$reasons" ] && jq -nc --arg r "$reasons" '{decision: "block", reason: $r}'
  return 0
}

case $mode in
  session-start) session_start ;;
  prompt) context UserPromptSubmit "$(join "$(push_notes)" "$(nudge)")" ;;
  pre-tool) pre_tool ;;
  post-tool) post_tool ;;
  subagent-stop) subagent_stop ;;
  stop) [ -f "$PUSH" ] && printf '%s' "$input" | bash "$PUSH" stop >/dev/null 2>&1 ;;
esac
exit 0
```

`~/.claude/hooks/setup-sync-push.sh` (complete starting code; tool-neutral; it uses the same env names as `setup-sync-pull.sh`):

```bash
#!/usr/bin/env bash
# Pushes setup edits after a turn, in the background, so a turn never waits on the network.
# Tool-neutral: Codex runs it today (through ~/.codex/hooks/codex-hooks.sh); Claude Code can
# register the same script on Stop later. sync.sh's lock keeps it safe when another session
# syncs at the same moment: the worker waits and retries.
#   setup-sync-push.sh stop     start the detached worker and return at once, printing nothing
#   setup-sync-push.sh notes    print open problems (CONFLICT, secret found, failed, busy), or nothing
#   setup-sync-push.sh worker   (internal) if `sync.sh changed`, run sync.sh; retry while another
#                               sync holds the lock; record the outcome as flags
# State: ~/.claude/hooks/state/setup-sync-push/ (never synced). Always exits 0.
# Tests: ~/.claude/setup/codex/codex-parity.test.sh (ac14, ac16, ac20)
set -uo pipefail
SYNC=${SETUP_SYNC_SCRIPT:-$HOME/.claude/setup/sync.sh}
GD=${SETUP_SYNC_GIT_DIR:-$HOME/.claude-setup.git}
STATE=${SETUP_SYNC_PUSH_STATE:-$HOME/.claude/hooks/state/setup-sync-push}
TRIES=${SETUP_SYNC_PUSH_TRIES:-8}   # retries while another sync holds the lock
WAIT=${SETUP_SYNC_PUSH_WAIT:-15}    # seconds between them
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

record() { # record <rc> <output> <tries>: one flag file per open problem
  local tail when; tail=$(printf '%s\n' "$2" | tail -n 15); when=$(date '+%F %T')
  if [ "$1" = 0 ]; then rm -f "$STATE"/*.flag; return 0; fi
  case $2 in
    *CONFLICT*) printf 'Setup sync CONFLICT (%s) while pushing edits:\n%s\nMerge both versions so both meanings survive (never drop the other machine'"'"'s edit), then run ~/.claude/setup/sync.sh. If you cannot merge safely, tell Justin first.\n' "$when" "$tail" >"$STATE/conflict.flag" ;;
    *"gitleaks found"*) printf 'Setup sync BLOCKED (%s): gitleaks found what looks like a secret; nothing was pushed.\n%s\nTell Justin; remove the secret, then run ~/.claude/setup/sync.sh.\n' "$when" "$tail" >"$STATE/blocked.flag" ;;
    *"another sync is running"*) printf 'Setup sync skipped (%s): another sync held the lock through %s tries. Run ~/.claude/setup/sync.sh when it has finished.\n' "$when" "$3" >"$STATE/busy.flag" ;;
    *) printf 'Setup sync FAILED (%s, exit %s):\n%s\nTell Justin; the edits are safe on this machine.\n' "$when" "$1" "$tail" >"$STATE/failed.flag" ;;
  esac
}

LOCK="$STATE/worker.lock"   # global on purpose: the EXIT trap runs after worker() has returned
worker() {
  local out rc tries
  mkdir -p "$STATE" || return 0
  if ! mkdir "$LOCK" 2>/dev/null; then
    if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +15 2>/dev/null)" ]; then rm -rf "$LOCK"; mkdir "$LOCK" || return 0
    else : >"$STATE/rerun"; return 0; fi   # a worker is running: it goes round once more
  fi
  trap 'rm -rf "$LOCK"' EXIT
  while :; do
    rm -f "$STATE/rerun"
    if bash "$SYNC" changed >/dev/null 2>&1; then
      tries=0
      while :; do
        out=$(bash "$SYNC" 2>&1); rc=$?
        case $rc in 0) break ;; esac
        case $out in *"another sync is running"*) ;; *) break ;; esac
        [ "$tries" -lt "$TRIES" ] || break
        tries=$((tries + 1)); sleep "$WAIT"
      done
      record "$rc" "$out" "$tries"
      printf '%s rc=%s\n%s\n' "$(date '+%F %T')" "$rc" "$out" >>"$STATE/worker.log"
    fi
    [ -e "$STATE/rerun" ] || break
  done
  if [ "$(wc -c <"$STATE/worker.log" 2>/dev/null || echo 0)" -gt 1048576 ]; then   # keep the log small
    tail -n 200 "$STATE/worker.log" >"$STATE/worker.log.tmp" && mv -f "$STATE/worker.log.tmp" "$STATE/worker.log"
  fi
}

case ${1:-} in
  stop)
    cat >/dev/null 2>&1
    [ -d "$GD" ] && [ -f "$SYNC" ] && mkdir -p "$STATE" 2>/dev/null || exit 0
    perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV or exit 127' bash "$self" worker </dev/null >>"$STATE/worker.log" 2>&1 &
    ;;
  notes) for f in "$STATE"/*.flag; do [ -f "$f" ] && { cat "$f"; echo; }; done ;;
  worker) worker ;;
esac
exit 0
```

The lock path is a global on purpose. A planning smoke run found that with `local lock`, the EXIT trap ran after `worker()` returned, with `$lock` empty, and left `worker.lock` behind. AC16 asserts no lock is left.

### Recording real Codex payloads (Task 2)

`capture-payloads.sh` does one tiny `codex exec` through the probe home, with `-m gpt-6-luna` at `low` and `--dangerously-bypass-hook-trust`.

Setup:
- A logging hook on every event saves stdin to `<n>-<Event>.json` and writes `$HOME/hook-wrote-here` (the fake HOME is outside the workspace root, so this proves hooks run outside the sandbox).
- Two SubagentStop loggers each block once with a different word, which shows how Codex merges two blocks.
- A `capture_role` agent file with `model = "gpt-5.6-luna"`.
- An `AGENTS.md` holding `Marker word: AGENTS-MARK-5521`.

Prompt:
> Spawn one capture_role agent with the task: 'Run the shell command `echo sub-ran`, then reply DONE and the marker word from your global instructions.' Wait for it. Then run `echo main-ran` and reply with the agent's final answer word for word.

`findings.txt` must answer:
- **F1.** Does SubagentStop fire for `capture_role` with `last_assistant_message`? Does a block continue the agent, and does the parent get the corrected answer?
- **F2.** Do both blocking reasons reach the agent?
- **F3.** Do subagent PostToolUse payloads carry `agent_id`?
- **F4.** Do hooks run outside the sandbox?
- **F5.** Do subagents get the global `AGENTS.md` (the marker in the answer)?
- **F6.** What are the `spawn_agent` tool name and `tool_input` fields?
- **F7.** Does the SubagentStop or SubagentStart `model` show `gpt-5.6-luna` (the role file's model) rather than the parent's?
- **F8.** `codex --version`.

Sanitizing: replace the fake home prefix with `/FAKEHOME`, the run root with `/FAKEROOT`, the probe home with `/CODEXHOME`. Keep session ids.

**Decision gates (stop and report to the orchestrator if any fails; don't invent a workaround):**
- If F1 shows SubagentStop doesn't fire for spawned agents, or a block doesn't continue the agent, the SubagentStop gate design fails.
- If F3 shows no `agent_id`, the nudge can't tell subagents apart.
- If F4 shows hooks are sandboxed, the push worker can't write `~/.claude-setup.git`.
- If F7 shows the role file's model isn't applied, the pipeline-model design fails.
- If F5 shows subagents don't get `AGENTS.md`, that is *not* a stop: the role files already say "read ~/.codex/AGENTS.md first if its text is not in your context". Just note it.

### Sandbox profile and rules

`config.managed.toml` (complete):

```toml
# >>> claude-setup managed: top-level >>>
# Managed by ~/.claude/setup/codex/setup-codex.sh from ~/.claude/setup/codex/config.managed.toml (synced).
# Edit that file and rerun the script; edits made here are replaced.
default_permissions = "claude-setup"
project_doc_fallback_filenames = ["CLAUDE.md"]
project_doc_max_bytes = 262144
# <<< claude-setup managed: top-level <<<
# >>> claude-setup managed: tables >>>
[permissions.claude-setup]
description = "Justin's setup: the workspace, plus Hermes skills, plans and memory and Claude's rules and memory notes. The sync machinery stays read-only; sync.sh runs outside the sandbox through ~/.codex/rules/setup-sync.rules."
extends = ":workspace"

[permissions.claude-setup.filesystem]
"~/.hermes" = "write"
"~/.hermes/scripts" = "read"
"~/.hermes/.env" = "deny"
"~/.claude" = "write"
"~/.claude/setup" = "read"
"~/.claude/hooks" = "read"
"~/.claude/settings.json" = "read"

[permissions.claude-setup.filesystem.":workspace_roots"]
".git" = "write"

[permissions.claude-setup.network]
enabled = true
# <<< claude-setup managed: tables <<<
```

`~/.codex/rules/setup-sync.rules` (complete; the same file works on both machines):

```python
# Setup sync and the pipeline-model switch run outside Codex's sandbox: they write every synced
# path, read gh's token and push. Only these exact scripts, called directly with their absolute
# path; the scripts themselves are read-only to sandboxed commands (permissions.claude-setup).
prefix_rule(
    pattern = [["/Users/justin/.claude/setup/sync.sh", "/home/justin/.claude/setup/sync.sh"]],
    decision = "allow",
    justification = "Justin's setup sync (~/.claude/setup/sync.sh) commits, pulls and pushes the synced setup files.",
    match = ["/Users/justin/.claude/setup/sync.sh", "/Users/justin/.claude/setup/sync.sh pull", "/home/justin/.claude/setup/sync.sh status"],
    not_match = ["bash /Users/justin/.claude/setup/sync.sh", "/tmp/sync.sh", "sync.sh"],
)
prefix_rule(
    pattern = [["/Users/justin/.claude/setup/codex/set-pipeline-model.sh", "/home/justin/.claude/setup/codex/set-pipeline-model.sh"]],
    decision = "allow",
    justification = "Switches the Codex pipeline model: checks the name, edits the one setting, runs sync.sh.",
    match = ["/Users/justin/.claude/setup/codex/set-pipeline-model.sh gpt-6.1-sol xhigh"],
    not_match = ["/tmp/set-pipeline-model.sh gpt-6.1-sol"],
)
```

`setup-codex.sh` (behaviour; the builder writes it test-first against AC19 and the AC26 smoke):

1. `umask 077`. Read `${CODEX_HOME:-~/.codex}/config.toml`, or empty if missing.
2. **Refuse (exit 3, no write)** in any of these cases:
   - the config outside the managed blocks sets `default_permissions`, `project_doc_fallback_filenames`, `project_doc_max_bytes` or `sandbox_mode`;
   - it has a `[sandbox_workspace_write]` or `[permissions.claude-setup…]` table.

   Tell Justin which key to remove or move.
3. **Render.**
   - Strip the old managed blocks: the lines between and including each BEGIN/END marker, plus one blank line right after the top-level END.
   - Strip trailing blank lines.
   - Insert the top-level block (from `config.managed.toml`, passed through `ENVIRON` because BSD awk can't take newlines in `-v`) plus one blank line before the first line matching `^[[:space:]]*\[`, or at the end when there's no table.
   - Then one blank line and the tables block.
4. **Validate** with `python3 -c 'import sys,tomllib; d=tomllib.load(open(sys.argv[1],"rb")); assert d["default_permissions"]=="claude-setup" and "claude-setup" in d["permissions"]' <tmp>`. Python ≥ 3.11 is required, and its absence is an error.
5. If the render differs, copy the current file to `<CODEX_HOME>/backups/config.toml.<YYYYmmdd-HHMMSS>` (mode 600), then `mv` the render in.
6. Run `bash build-codex.sh`, then `~/.hermes/scripts/update-skills-library.sh --links-only`, reporting its failure without aborting.
7. **Plugin duplicates (Q10).**
   - For each enabled plugin's skill folder found under `<CODEX_HOME>/plugins/cache/*/*/*/skills/<name>/SKILL.md` whose `<name>` is also linked in `~/.agents/skills`, add a `[[skills.config]] path = "<that SKILL.md>" enabled = false` entry inside the managed tables block. Generate this part, never hand-write it.
   - Report each one.
   - `--check` flags drift after a plugin update.
8. **Checks.**
   - `codex doctor --json` must have no "malformed agent role" warning.
   - `codex debug prompt-input` must contain the header's first line and every name in `skills-library-claude.txt` exactly once.
   - Print the next steps: "Open codex, type /hooks and trust the 6 hooks (again after any hooks.json change)." On a fresh machine add "and sign in: codex login".
9. `--check` performs steps 1–4 and 8 without writing, and exits 0 only when current.

### Sync changes (`.claude/setup/*`)

`manifest.txt`: add these lines. `.claude/setup/codex/**` is already covered by `:(glob).claude/setup/**`, and `.claude/hooks/setup-sync-push.sh` by `:(glob).claude/hooks/*.sh`.

```
.codex/hooks.json
:(glob).codex/hooks/*.sh
:(glob).codex/hooks/tests/**
:(glob).codex/agents/*.toml
.codex/rules/setup-sync.rules
```

`exclude.txt`: add these lines.

```
/.codex/hooks/state/
/.codex/AGENTS.md
/.codex/AGENTS.override.md
/.codex/config.toml
/.codex/backups/
/.codex/rules/default.rules
/.codex-probe/
/.agents/
```

In `sync.sh`:

1. Append to the `DENY_RE` alternation, inside the existing quotes:

   ```
   |^\.codex/(auth\.json|config\.toml|AGENTS(\.override)?\.md$|backups/|history\.jsonl|session_index\.jsonl|models_cache\.json|version\.json|installation_id|.*\.sqlite|sessions/|log/|logs|cache/|\.tmp/|tmp/|skills/|plugins/|memories/|packages/|shell_snapshots/|app-server|ipc/|thread-writer-locks/|tui-|\.personality|\.sandbox|rules/default\.rules|hooks/state/)|^\.codex-probe/|^\.agents/
   ```

2. Rebuild the Codex files:

   ```bash
   CODEX_BUILD="$SETUP/codex/build-codex.sh"
   rebuild_codex() { # ~/.codex/AGENTS.md and the role files' model lines, from their synced sources
     [ -d "${CODEX_HOME:-$HOME/.codex}" ] && [ -f "$CODEX_BUILD" ] || return 0
     bash "$CODEX_BUILD" >/dev/null 2>&1 || say "WARNING: could not rebuild the Codex files; run $CODEX_BUILD"
   }
   ```

   Call it:
   - first in `stage()`, before the manifest loop, so a changed `pipeline-model.toml` rewrites the role files that same commit picks up;
   - in `do_sync` after a pull whose `changed` list matches `^\.claude/(CLAUDE\.md|setup/codex/(agents-header\.md|pipeline-model\.toml))$`;
   - at the end of `do_attach`.
3. A new command `changed` (no lock, no network, no staging) that the push worker uses:

   ```bash
   # Anything to sync? For the push worker: no lock, no network, no staging.
   # Exit 0 when a manifest path changed (new files included), library edits differ from
   # skills-library-local.patch, or this machine has commits GitHub hasn't; 1 when there's nothing.
   do_changed() {
     [ -d "$GD" ] || exit 1
     local specs=() spec
     while IFS= read -r spec || [ -n "$spec" ]; do
       case "$spec" in '' | '#'*) continue ;; esac
       specs+=("$spec")
     done <"$SETUP/manifest.txt"
     if g status --porcelain --untracked-files=all -- "${specs[@]}" 2>/dev/null | cut -c4- | grep -vE "$DENY_RE" | grep -q .; then exit 0; fi
     if [ -d "$LIB/.git" ] && [ -n "$(git -C "$LIB" diff --name-only)" ] && ! git -C "$LIB" diff | cmp -s - "$PATCHF"; then exit 0; fi
     [ -n "$(g rev-list -1 refs/remotes/origin/main..HEAD 2>/dev/null)" ] && exit 0
     exit 1
   }
   ```

   Add `changed` to the argument `case`, the `--help` lines and the dispatch `case`. One caveat: a changed `pipeline-model.toml` is itself a manifest path, so `changed` sees it, and `stage()` rewrites the role files.

`sync.test.sh`:
- Change these two lines:
  - `SYNC=` becomes `SYNC="$(cd "$(dirname "$0")" && pwd)/sync.sh"`;
  - `REAL_SETUP=` becomes `REAL_SETUP="$(cd "$(dirname "$0")" && pwd)"`.
- Copy `codex/` into the fake setup as well.
- Add these checks, each printing `ok - <text>` or `NOT OK - <text>` like the others:
  - "codex files synced";
  - "codex state never synced, even with a widened manifest";
  - "AGENTS.md and role models rebuilt on sync and after a pull";
  - "sync.sh changed: 1 when clean, 0 after an edit, a new file, a library edit, or an unpushed commit".
- The final line must read `passed 32, failed 0`. Update `desktop.md` to match.

### Working hand in hand with Claude on one machine

- **(a) Pull and push.** Codex pulls through the same `setup-sync-pull.sh` at every session start, and pushes through `setup-sync-push.sh` after any turn that changed synced files. It can also run `sync.sh` itself, as `CLAUDE.md` says, through the allow rule (AC11, AC15–AC17).
- **(b) Sandbox.** The Q4 profile plus two allow rules (AC10, AC11). Hooks run outside the sandbox (Task 2, F4). That's what lets the pull and push hooks write any synced path.
- **(c) Re-read before writing.** Both tools' rules say re-read before writing: `CLAUDE.md` already does (through the memory note), and the header adds it for Codex. Hooks and scripts write atomically (temp file + `mv`). `build-codex.sh` writes only derived files.
- **(d) The lock.** `sync.sh`'s `mkdir` lock is shared by every caller. The push worker retries for up to 2 minutes, and the pull hook reports "skipped, another session is syncing" (AC14).
- **(e) Lessons and memory.** Lessons and memory work the same way:
  - the lean-skills rule and `skill_lessons` come from `CLAUDE.md`, enforced by the same lessons gate;
  - memory lives in Claude's folder, with the same format and index, and the session-start hook shows it (AC18);
  - Codex finds the folder by turning the cwd, its git root, then each parent into Claude's key (`[^a-zA-Z0-9]` → `-`). On the desktop, `sync.sh links` symlinks `-home-justin-…/memory` to the Mac's folder, and the hook reads through the link.
- **(f) Commits.** Codex commits use the folder's identity, because Codex runs plain `git commit` and `includeIf` applies. AI trailers are blocked by the guard (AC8, AC9).

### The desktop (WSL Ubuntu)

Install the standalone binary (no Node needed): `curl -fsSL https://chatgpt.com/codex/install.sh | sh`, then `codex --version`, which must be ≥ 0.163.0. Run `sudo apt install -y bubblewrap` if `codex doctor` reports the sandbox helper missing.

Sign in with `codex login`; WSL2 forwards the localhost callback to the Windows browser. If that fails, use `codex login --device-auth`. Credentials land in `~/.codex/auth.json`, which is denied by `DENY_RE`.

Then:
1. `~/.claude/setup/sync.sh pull`;
2. `bash ~/.claude/setup/codex/setup-codex.sh`;
3. `codex`, then `/hooks` → trust all six;
4. the AC25 check.

`desktop.md`, `mac.md` and the README get a **Codex** section. It covers:
- install and sign-in;
- `setup-codex.sh`;
- the `/hooks` trust, needed again after any `hooks.json` change;
- how Codex finds the rules, skills and memory;
- what syncs and what never does;
- the push and pull hooks;
- the pipeline model: "File: `~/.claude/setup/codex/pipeline-model.toml`; value: `model` and `model_reasoning_effort`. To switch, tell any agent 'switch the Codex pipeline model to X': it runs `~/.claude/setup/codex/set-pipeline-model.sh X`, which (1) checks X against `~/.codex/models_cache.json`, (2) edits that file and rewrites the role files, (3) runs `sync.sh`";
- don't use Codex's `/import` from Claude Code (it would make a second, drifting copy of the setup);
- the probe home (optional; only for running the probe tests);
- troubleshooting: "hooks need review", "Not logged in", a stale `AGENTS.md` → `build-codex.sh`.

`~/.claude/CLAUDE.md` gets exactly one added line in "Setup Sync":
> - **Codex shares this setup:** `~/.codex/AGENTS.md` is generated from this file (edit this file, never that one), Codex's hooks pull at session start and push after its edits through the same `sync.sh` lock, and "switch the Codex pipeline model to X" means running `~/.claude/setup/codex/set-pipeline-model.sh X` (guides: `mac.md`/`desktop.md` "Codex").

## Test harness: `.claude/setup/codex/codex-parity.test.sh`

Code for the harness and helpers is complete below. Each test function's assertions are specified exactly in its AC above. The builder writes each function first, sees it fail, then builds.

```bash
#!/usr/bin/env bash
# Acceptance tests for story codex-parity (~/.hermes/plans/claude-setup/codex-parity.md).
#   bash codex-parity.test.sh                     every offline test (no Codex sign-in, no quota)
#   bash codex-parity.test.sh <test> [<test>…]    just those, numbered TAP: "ok 1 - <test>"
# Probe tests (real `codex exec`) run only when named; they need CODEX_PROBE_HOME signed in.
# Live tests (ac24-ac27) check a real machine and run only when named.
# Everything under test comes from this file's own checkout (the codex-parity worktree, or $HOME
# itself once merged), never from the real ~/.codex, ~/.claude or ~/.hermes. Fake homes live under
# ${CODEX_PARITY_TEST_ROOT:-$HOME/.cache/codex-parity-tests}, outside $TMPDIR and /tmp, so Codex's
# sandbox treats them like a real home.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../.." && pwd)             # the checkout root ($HOME-relative layout)
REAL_HOME=$HOME
ROOT=${CODEX_PARITY_TEST_ROOT:-$REAL_HOME/.cache/codex-parity-tests}
FIX="$SRC/.codex/hooks/tests/fixtures"
mkdir -p "$ROOT"
. "$HERE/probe-lib.sh" 2>/dev/null || true   # missing on the base commit: probe tests then fail, never skip

OFFLINE="ac1_agents_md_loaded ac3_session_start_rules_fresh ac4_codex_sees_claude_skills ac5_roles_valid_and_load
ac6_gates_match_claude_twins ac7_claude_hooks_unchanged ac8_commit_guard_blocks_ai_trailer ac10_sandbox_profile_and_rules
ac12_sync_codex_paths ac13_sync_suite_green ac14_lock_claude_and_codex_same_moment ac15_session_start_reuses_claude_pull
ac16_stop_hook_pushes_in_background ac18_memory_index_injected ac19_config_merge_idempotent
ac20_codex_edit_reaches_other_machine ac21_pipeline_model_switch ac23_docs_updated"

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { # newroot: a fresh test folder in $S, a fake home in $H; TMPDIR inside it, away from $H
  S=$(mktemp -d "$ROOT/t.XXXXXX"); H="$S/home"; mkdir -p "$H/.codex" "$S/tmp"
  printf '[user]\n\tname = Test Personal\n\temail = personal@example.test\n[includeIf "gitdir:~/Leorna/"]\n\tpath = ~/.gitconfig-leorna\n' >"$H/.gitconfig"
  printf '[user]\n\tname = Test Leorna\n\temail = leorna@example.test\n' >"$H/.gitconfig-leorna"
}
inhome() { HOME="$H" CODEX_HOME="${CH:-$H/.codex}" TMPDIR="$S/tmp" GIT_CONFIG_NOSYSTEM=1 "$@"; }
install_setup() { # copies the checkout's setup files into the fake home (never symlinks into the checkout)
  mkdir -p "$H/.claude/setup" "$H/.claude/hooks" "$H/.codex/hooks" "$H/.codex/agents" "$H/.codex/rules" "$H/.hermes/scripts"
  cp -R "$SRC/.claude/setup/." "$H/.claude/setup/"
  cp "$SRC"/.claude/hooks/*.sh "$H/.claude/hooks/"
  cp "$SRC/.claude/CLAUDE.md" "$H/.claude/CLAUDE.md"
  cp "$SRC"/.codex/hooks/*.sh "$H/.codex/hooks/" 2>/dev/null
  cp "$SRC"/.codex/agents/*.toml "$H/.codex/agents/" 2>/dev/null
  cp "$SRC/.codex/hooks.json" "$H/.codex/" 2>/dev/null
  cp "$SRC/.codex/rules/setup-sync.rules" "$H/.codex/rules/" 2>/dev/null
  cp "$SRC/.hermes/scripts/update-skills-library.sh" "$H/.hermes/scripts/"
}
attach_repo() { # a setup repo for the fake home with a local bare remote at $S/remote.git (sync.test.sh's way)
  git init -q --bare -b main "$S/remote.git"
  (cd "$H" && inhome env SETUP_SYNC_URL="$S/remote.git" bash "$H/.claude/setup/sync.sh" init >/dev/null &&
   inhome env SETUP_SYNC_URL="$S/remote.git" bash "$H/.claude/setup/sync.sh" >/dev/null 2>&1)
}
payload() { jq -c --arg cwd "${2:-$H}" '.cwd = $cwd' "$FIX/$1"; }   # a recorded payload, cwd moved into the fake home

n=0; failed=0
run() {
  local t=$1 out rc
  n=$((n + 1))
  if [ "$(type -t "$t")" != function ]; then echo "not ok $n - $t"; echo "# no such test"; failed=$((failed + 1)); return; fi
  out=$( ( "$t" ) 2>&1 ); rc=$?
  printf '%s\n' "$out" | sed 's/^/#  /'
  if [ $rc -eq 0 ]; then echo "ok $n - $t"; else echo "not ok $n - $t"; failed=$((failed + 1)); fi
}

# ---- tests: one function per AC (ac1_agents_md_loaded … ac27_codex_story_run), each in a ( subshell ) via run ----

if [ $# -gt 0 ]; then for t in "$@"; do run "$t"; done; else for t in $OFFLINE; do run "$t"; done; fi
echo "# passed $((n - failed)), failed $failed"
[ "$failed" -eq 0 ]
```

Rules for the test bodies (they follow from `ac-check.sh`):
- **Output:** never print the words `SKIPPED`, `skipped 1`, `# skip`, `# TODO` or `○`, and never a line starting `ok <n> -` except the runner's own. Diagnostic lines are prefixed `#  `.
- **Exit code:** a missing prerequisite returns 1 with a message, never exit 127.
- **The base commit:** each test checks its head-only files first with `need`, so it fails fast before any `codex exec`.
- **Probe tests:** they call `probe_ready || return 1` first, then `probe_begin`, then `trap probe_end EXIT`.
- **Cleanup:** each test removes its own `$S` on success. Keep it on failure and print its path.

`probe-lib.sh` (complete):

```bash
# probe-lib.sh: run a real `codex exec` without touching ~/.codex.
# CODEX_PROBE_HOME (default ~/.codex-probe) is a Codex home that holds only a ChatGPT sign-in
# (auth.json, file store). A probe copies its AGENTS.md, hooks.json, agents/ and rules/ in, runs,
# then removes them again. One probe at a time (mkdir lock). Never synced (sync.sh DENY_RE).
PROBE=${CODEX_PROBE_HOME:-$REAL_HOME/.codex-probe}
PROBE_MODEL=${CODEX_PROBE_MODEL:-gpt-6.1-sol}
PROBE_EFFORT=${CODEX_PROBE_EFFORT:-low}
probe_ready() {
  [ -s "$PROBE/auth.json" ] && return 0
  echo "# no ChatGPT sign-in in $PROBE. Justin runs once:"
  echo "#   mkdir -p $PROBE && printf 'cli_auth_credentials_store = \"file\"\\n' > $PROBE/config.toml && CODEX_HOME=$PROBE codex login"
  return 1
}
probe_clean() {
  rm -rf "${PROBE:?}/AGENTS.md" "${PROBE:?}/AGENTS.override.md" "${PROBE:?}/hooks.json" "${PROBE:?}/agents" "${PROBE:?}/rules"
  printf 'cli_auth_credentials_store = "file"\n' >"$PROBE/config.toml"
}
probe_begin() { # probe_begin <fake home>: stage that home's Codex files into the probe home
  mkdir "$PROBE/.probe.lock" 2>/dev/null || { echo "# another probe is running ($PROBE/.probe.lock)"; return 1; }
  probe_clean
  [ -f "$1/.codex/AGENTS.md" ] && cp "$1/.codex/AGENTS.md" "$PROBE/"
  [ -f "$1/.codex/hooks.json" ] && cp "$1/.codex/hooks.json" "$PROBE/"
  [ -d "$1/.codex/agents" ] && cp -R "$1/.codex/agents" "$PROBE/"
  [ -d "$1/.codex/rules" ] && cp -R "$1/.codex/rules" "$PROBE/"
  [ -f "$1/.codex/config.toml" ] && { printf 'cli_auth_credentials_store = "file"\n'; cat "$1/.codex/config.toml"; } >"$PROBE/config.toml"
  return 0
}
probe_end() { probe_clean; rmdir "$PROBE/.probe.lock" 2>/dev/null; }
probe_exec() { # probe_exec <fake home> <cwd> <out dir> <prompt> [extra codex args…]
  local h=$1 cwd=$2 out=$3 prompt=$4; shift 4
  HOME="$h" CODEX_HOME="$PROBE" TMPDIR="$(dirname "$h")/tmp" codex exec --ephemeral --skip-git-repo-check \
    --dangerously-bypass-hook-trust -m "$PROBE_MODEL" -c "model_reasoning_effort=\"$PROBE_EFFORT\"" \
    -C "$cwd" --json -o "$out/last.txt" "$@" "$prompt" >"$out/events.jsonl" 2>"$out/stderr.txt"
}
```

Note: when `setup-codex.sh` writes `config.toml` it starts with top-level keys, so `probe_begin`'s prepended `cli_auth_credentials_store` line stays top-level.

## Tasks (in order; test first; a "check" means run the named test and see the stated result)

Each task commits its files in the worktree with a clear message and no AI trailer. Before every hand-over, `git -C ~/.claude-setup-wt/codex-parity status --porcelain --untracked-files=all` must be empty.

1. **Worktree.**
   - `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/codex-parity" -b codex-parity main`.
   - Record `BASE=$(git -C ~/.claude-setup-wt/codex-parity rev-parse HEAD)` in the build notes.
   - Check `git -C <wt> rev-parse --show-toplevel` is the worktree, not `$HOME`. Stop if it isn't.
   - Confirm `docker info` (Docker up or not) for Task 17.
2. **Probe home and real payloads.**
   - Check `CODEX_HOME=~/.codex-probe codex login status`. If it isn't "Logged in", stop and ask the orchestrator to have Justin run the `probe_ready` command (Q8). Don't use the real `~/.codex`.
   - Write `probe-lib.sh` and `capture-payloads.sh`, and run the capture into `.codex/hooks/tests/fixtures/`.
   - Write `fixtures/findings.txt` (F1–F8).
   - Fetch the SessionStart, SubagentStop and PreToolUse output schemas (raw GitHub, `openai/codex`, `codex-rs/hooks/schema/generated`) into fixtures.
   - Add `models_cache.sample.json` made with `jq '{models: [.models[] | {slug, supported_reasoning_levels}]}' ~/.codex/models_cache.json` (read-only).
   - Apply the decision gates. Commit the fixtures.
3. **Harness.** Write `codex-parity.test.sh` (harness above) with empty AC functions returning `fail "not written"`. Check: `bash .claude/setup/codex/codex-parity.test.sh` prints `not ok` lines and exits 1.
4. **AC1 and AC3 (rules part).**
   - Write `ac1_agents_md_loaded`, then `agents-header.md`, `pipeline-model.toml` (`model = "gpt-6.1-sol"`, `model_reasoning_effort = "xhigh"`, with a comment naming the switch script) and `build-codex.sh` (below). Check AC1 goes from `not ok` to `ok`.
   - Write the rules half of `ac3_session_start_rules_fresh` later, in Task 9.
5. **AC5.** Write `ac5_roles_valid_and_load`, then the seven role files. Use the template and role paragraphs above, and the `spawn_agent` field names from F6 in the header. Check `ok`.
6. **AC4.**
   - Write `ac4_codex_sees_claude_skills`.
   - Then change `update-skills-library.sh`:
     - `--links-only`;
     - `LIB_REAL` tolerant of a missing clone (`LIB_REAL=$(cd "$LIB" 2>/dev/null && pwd -P || echo "$LIB")`, and the `[[ -d "$LIB/.git" ]]` check applies only outside `--links-only`);
     - `link_dir` for both folders;
     - the `.system` skip and the summary line.
   - Check `ok`. Also run the script with `--dry-run` on a fake home and confirm "would:" lines appear for codex links.
7. **AC6 and AC7.**
   - Write both tests, then `codex-hooks.sh` (the `subagent-stop`, `prompt`, `post-tool` nudge parts) and `hooks.json`.
   - Check both `ok`.
   - Run `bash .claude/hooks/tests/<each>.test.sh` in the worktree, five files, all passing.
8. **AC8.** Write `ac8_commit_guard_blocks_ai_trailer`, then the `pre-tool` and `post-tool` guard parts. Check `ok`, including a case where `-F msg.txt` holds the trailer.
9. **AC15, AC3 and AC18.**
   - Write `ac15_session_start_reuses_claude_pull`. For each case, compare against `setup-sync-pull.sh` run directly on the same stub (`SETUP_SYNC_SCRIPT`, `SETUP_SYNC_GIT_DIR`, as `setup-sync-pull.test.sh` does).
   - Then write `ac3_…` and `ac18_memory_index_injected`, then `session_start` and `memory_note`.
   - Check all three `ok`.
   - Validate every output with `jq -e 'keys - ["continue","stopReason","systemMessage","suppressOutput","hookSpecificOutput"] == []'` and `.hookSpecificOutput.hookEventName == "SessionStart"`.
10. **`sync.sh` and `sync.test.sh` (AC12, AC13, AC20 groundwork).**
    - Write the new `sync.test.sh` checks and the path fix, and see the new checks fail.
    - Then make the `sync.sh` changes (`DENY_RE`, `rebuild_codex`, `changed`) and the `manifest.txt` / `exclude.txt` additions.
    - Write `ac12_sync_codex_paths` (it runs `sync.test.sh` and greps its four new `ok -` lines) and `ac13_sync_suite_green`. Check both `ok`, and the suite ends `passed 32, failed 0` (or the new total, which then goes in the docs).
11. **AC16, AC14 and AC20.**
    - Write the three tests, then `setup-sync-push.sh` (and the `stop` mode in `codex-hooks.sh`).
    - In tests, set `SETUP_SYNC_PUSH_WAIT=1 SETUP_SYNC_PUSH_TRIES=8`.
    - "Process group killed" means: start the hook with `perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV' bash codex-hooks.sh stop &`, then `kill -TERM -<pgid>` right after it returns. The worker must still push.
    - Check all `ok`.
12. **AC19 and AC10.**
    - Write both tests, then `config.managed.toml`, `setup-codex.sh` and `setup-sync.rules`.
    - For AC10, use `inhome codex sandbox -P claude-setup -C "$H/work" -- /bin/sh -c 'echo x > <path>'` for each path, plus `git commit` in `$H/work`, and `codex execpolicy check --rules … -- <argv>` for each command.
    - Check both `ok`.
13. **AC21.**
    - Write `ac21_pipeline_model_switch`, then `set-pipeline-model.sh` (below).
    - The test copies `models_cache.sample.json` to `$H/.codex/models_cache.json`.
    - Check `ok`.
14. **Probes (AC2, AC9, AC11, AC17, AC22).**
    - Write each test, run it once (it costs quota), and fix until `ok`.
    - AC11's rules file is the real one with `/Users/justin` and `/home/justin` replaced by the fake home's absolute path (`sed`), copied into the probe home.
    - If AC17 shows Codex can't write through the `~/.agents/skills` link, check whether the header's "edit at the real path" was followed. Fix the header wording, not the profile, unless the probe shows the profile blocks the real path.
15. **Docs (AC23).** Write `ac23_docs_updated`, then the three Codex sections and the one `CLAUDE.md` line. Check `ok`.
16. **Live test functions (AC25, AC26, AC27).**
    - Each runs against the real machine only when named and `CODEX_PARITY_REAL=1` is set, and otherwise fails with "live: run on the real machine".
    - `ac25`/`ac26`: `build-codex.sh --check`, `codex debug prompt-input` (header line, 17 skills, no duplicate names), `codex doctor --json` (no malformed roles), `grep -c 'trusted_hash' ~/.codex/config.toml` ≥ 6, and a real `codex exec` with the AC2 questions.
    - `ac27`: reads `CODEX_STORY_EVIDENCE=<dir>` and checks it holds `ac-check.log` whose last line starts `ALL ACCEPTED` or `READY FOR THE USER`, and a `gate.log` showing one SubagentStop block.
17. **Linux (AC24).** Write `ac24_linux_suites`, which runs the container below. If Docker is down, it fails with "live: Docker is not running", and the verifier marks the AC `not_run`.
    ```bash
    docker run --rm --privileged -v "$HOME/.claude-setup.git:/repo.git:ro" ubuntu:24.04 bash -lc '
      set -e; apt-get update -qq; apt-get install -y -qq git jq curl perl python3 bubblewrap ca-certificates >/dev/null
      curl -fsSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_arm64.tar.gz | tar -xz -C /usr/local/bin gitleaks
      # Codex 0.163.0 Linux: verify the asset name first with: gh release view rust-v0.163.0 -R openai/codex
      curl -fsSL https://github.com/openai/codex/releases/download/rust-v0.163.0/codex-aarch64-unknown-linux-musl.tar.gz | tar -xz -C /tmp && install /tmp/codex-aarch64-unknown-linux-musl /usr/local/bin/codex
      useradd -m t; su t -c "git config --global user.name T && git config --global user.email t@example.test &&
        git clone -q -b codex-parity /repo.git ~/wt && cd ~/wt &&
        bash .claude/setup/codex/codex-parity.test.sh && bash .claude/setup/sync.test.sh &&
        for f in .claude/hooks/tests/*.test.sh; do bash \$f || exit 1; done"'
    ```
    `ac7` needs the base commit: in the container it uses `git merge-base HEAD origin/main` of the clone.
18. **Hand-over.** Run every offline test (`bash codex-parity.test.sh`), `sync.test.sh` and the five Claude hook tests. Report `ready-for-review` with the head SHA, base SHA, each AC's command, and the probe quota used.

`build-codex.sh` (complete):

```bash
#!/usr/bin/env bash
# Builds the Codex files that come from synced sources, so each has one source of truth:
#   ~/.codex/AGENTS.md                agents-header.md (pipeline model filled in) + ~/.claude/CLAUDE.md verbatim
#   ~/.codex/agents/pipeline-*.toml   their model lines, from pipeline-model.toml
# Edit the sources, never the outputs. sync.sh runs this on every sync and after a pull; the Codex
# session-start hook runs it when AGENTS.md is stale.
#   build-codex.sh           write whatever differs; silent when current
#   build-codex.sh --check   exit 0 when everything is current, 1 when not (no writes)
#   build-codex.sh --hash    print the CLAUDE.md git hash recorded in AGENTS.md (empty if none)
# Env: CODEX_HOME (default ~/.codex). Tests: codex-parity.test.sh (ac1, ac3, ac21).
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
CH=${CODEX_HOME:-$HOME/.codex}
HEADER="$DIR/agents-header.md"
SETTING="$DIR/pipeline-model.toml"
RULES=${CODEX_BUILD_RULES:-$HOME/.claude/CLAUDE.md}
OUT="$CH/AGENTS.md"
MARK='<!-- BEGIN ~/.claude/CLAUDE.md verbatim, git-hash '
if [ "${1:-}" = --hash ]; then
  sed -n "s|^$MARK\\([0-9a-f]*\\) -->\$|\\1|p" "$OUT" 2>/dev/null | head -1; exit 0
fi
setting() { sed -n "s/^$1 = \"\\(.*\\)\"\$/\\1/p" "$SETTING" | head -1; }
MODEL=$(setting model); EFFORT=$(setting model_reasoning_effort)
[ -n "$MODEL" ] && [ -n "$EFFORT" ] && [ -f "$HEADER" ] && [ -f "$RULES" ] \
  || { echo "build-codex: need $HEADER, $RULES and model + model_reasoning_effort in $SETTING" >&2; exit 2; }
agents_md() {
  sed -e "s/@PIPELINE_MODEL@/$MODEL/g" -e "s/@PIPELINE_EFFORT@/$EFFORT/g" "$HEADER"
  printf '\n%s%s -->\n\n' "$MARK" "$(git hash-object "$RULES")"
  cat "$RULES"
  printf '\n<!-- END ~/.claude/CLAUDE.md -->\n'
}
role() { sed -e "s/^model = \".*\"\$/model = \"$MODEL\"/" -e "s/^model_reasoning_effort = \".*\"\$/model_reasoning_effort = \"$EFFORT\"/" "$1"; }
write() { local tmp; tmp=$(mktemp "$1.XXXXXX"); cat >"$tmp"; mv -f "$tmp" "$1"; }
stale=0
agents_md | cmp -s - "$OUT" 2>/dev/null || stale=1
for f in "$CH"/agents/pipeline-*.toml; do [ -f "$f" ] || continue; role "$f" | cmp -s - "$f" || stale=1; done
case ${1:-} in
  --check) exit "$stale" ;;
  '') ;;
  *) echo "usage: build-codex.sh [--check|--hash]" >&2; exit 2 ;;
esac
[ "$stale" = 1 ] || exit 0
mkdir -p "$CH"
agents_md | cmp -s - "$OUT" 2>/dev/null || agents_md | write "$OUT"
for f in "$CH"/agents/pipeline-*.toml; do [ -f "$f" ] || continue; role "$f" | cmp -s - "$f" || role "$f" | write "$f"; done
```

`set-pipeline-model.sh` (complete):

```bash
#!/usr/bin/env bash
# Switch the model every Codex pipeline role runs on (planner, builder, reviewers, fixers,
# verifier, auditor, finisher), on both machines, until the next switch.
#   set-pipeline-model.sh <model> [effort]    the effort defaults to the current one
# 1. checks <model> and the effort against ~/.codex/models_cache.json, refusing with the valid list;
# 2. writes ~/.claude/setup/codex/pipeline-model.toml (the one setting) and rewrites the role files
#    and ~/.codex/AGENTS.md from it (build-codex.sh);
# 3. runs ~/.claude/setup/sync.sh, which commits and pushes; the other machine gets it at its next pull.
# Exit 0 switched, 2 refused (unknown model or effort, no models list), 1 the sync failed.
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
SETTING="$DIR/pipeline-model.toml"
CACHE="${CODEX_HOME:-$HOME/.codex}/models_cache.json"
SYNC=${SETUP_SYNC_SCRIPT:-$HOME/.claude/setup/sync.sh}
model=${1:-}; effort=${2:-}
[ -n "$model" ] || { echo "usage: set-pipeline-model.sh <model> [effort]" >&2; exit 2; }
[ -f "$CACHE" ] || { echo "set-pipeline-model: no $CACHE; run codex once on this machine so it lists your models" >&2; exit 2; }
models=$(jq -r '.models[].slug' "$CACHE")
if ! grep -qxF -- "$model" <<<"$models"; then
  echo "set-pipeline-model: unknown model '$model'. Valid models (from $CACHE):" >&2
  sed 's/^/  /' <<<"$models" >&2; exit 2
fi
current=$(sed -n 's/^model_reasoning_effort = "\(.*\)"$/\1/p' "$SETTING" 2>/dev/null | head -1)
effort=${effort:-${current:-xhigh}}
efforts=$(jq -r --arg m "$model" '.models[] | select(.slug == $m) | .supported_reasoning_levels[]?.effort' "$CACHE")
if ! grep -qxF -- "$effort" <<<"$efforts"; then
  echo "set-pipeline-model: $model has no '$effort' effort. Valid: $(tr '\n' ' ' <<<"$efforts")" >&2; exit 2
fi
tmp=$(mktemp "$SETTING.XXXXXX")
{ grep '^#' "$SETTING" 2>/dev/null || true; printf 'model = "%s"\nmodel_reasoning_effort = "%s"\n' "$model" "$effort"; } >"$tmp"
mv -f "$tmp" "$SETTING"
bash "$DIR/build-codex.sh"
echo "set-pipeline-model: Codex pipeline roles now run on $model at $effort"
bash "$SYNC" || exit 1
```

## Finisher steps (in order; never `--force`, never rewrite history)

1. **In the worktree:**
   - Commit everything, then run `~/.claude/setup/sync.sh pull`. That commits and pulls the real `main`.
   - `git -C ~/.claude-setup-wt/codex-parity rebase main`, keeping both sides' meaning on any conflict. `CLAUDE.md`, the README and `desktop.md` may have moved.
   - Rerun every offline suite. Report the new HEAD.
   - If HEAD differs from the head `ac-check.sh` accepted, the orchestrator reruns verifier → auditor → `ac-check.sh` on it before step 2.
2. **Merge into `main` under the sync lock:**
   - `mkdir ~/.claude-setup.git/setup-sync.lock`; wait and retry if it exists.
   - Back up every file in `$HOME` that the merge will overwrite (`git --git-dir=$HOME/.claude-setup.git diff --name-only main codex-parity`) to `~/.claude-setup-backup/<time>/`.
   - `git --git-dir="$HOME/.claude-setup.git" --work-tree="$HOME" merge --ff-only codex-parity`.
   - `rmdir` the lock.
   - Check that `git log --oneline -3 main` shows the story's commits, and that `~/.codex/hooks.json` and `~/.codex/agents/pipeline-planner.toml` exist.
3. **Install:** `bash ~/.claude/setup/codex/setup-codex.sh`. It backs up `~/.codex/config.toml` to `~/.codex/backups/`, merges the managed blocks, builds `AGENTS.md` and runs the checks. Report its output.
4. **Links:** `~/.hermes/scripts/update-skills-library.sh`, the full run. Check `ls -l ~/.agents/skills` shows 17 links and none broken (`for l in ~/.agents/skills/*; do [ -e "$l" ] || echo "broken $l"; done` prints nothing).
5. **Push:** `~/.claude/setup/sync.sh`, through the gitleaks gate. Then `git --git-dir=$HOME/.claude-setup.git log origin/main -1` equals local `main`.
6. **Smoke (live part, AC26):**
   - `codex doctor --json` must show no malformed role.
   - `codex debug prompt-input` must show the header and the 17 skills.
   - Then one tiny `codex exec --ephemeral -m gpt-6.1-sol -c 'model_reasoning_effort="low"' "<the AC2 questions>"`. If Codex isn't reachable from the agent's shell ("Not logged in"), hand Justin that exact command to run with `!`.
   - Justin opens `codex`, types `/hooks` and trusts the six hooks.
7. Remove the worktree folder (`git --git-dir=$HOME/.claude-setup.git worktree remove ~/.claude-setup-wt/codex-parity`); keep the branch. Don't push the branch.
8. **Desktop (AC25):** the hand-over names the desktop steps from `desktop.md` "Codex" for Justin.

## Risks

- **Real payloads might differ from the docs.** Examples: no `agent_id` on subagent tool calls, SubagentStop not firing for spawned agents, hooks sandboxed, role model ignored. Task 2 records them before any hook code, and its decision gates stop the build instead of guessing.
- **Plain-command matching is unproven offline.** Whether Codex's runtime splits `zsh -lc '<abs>/sync.sh'` into argv for the allow rule can only be shown live (AC11). If it doesn't, the sync still runs through the hooks; Codex's own manual sync then asks for approval in the TUI. Fall back by documenting the approval, not by widening the profile.
- **Hook trust can lag.** Hooks need `/hooks` trust per machine and after each `hooks.json` change. Until trusted they are silently skipped, and Codex prints a "needs review" warning at start. The docs and AC25/AC26 cover it.
- **The probe home holds a ChatGPT credential.** It lives at `~/.codex-probe/auth.json` (file store). It's excluded by `DENY_RE`, `exclude.txt` and the manifest. Probe tests never print tokens.
- **The base keeps moving.** `main` moves with every sync during the story. The finisher rebases and reruns, and ac-check reruns if HEAD changes.
- **Untracked files hide in the worktree.** `status.showUntrackedFiles=no` hides them from plain `git status` and from `ac-check.sh`'s dirty check. Always use `--untracked-files=all`.
- **A large rules injection.** Injecting the full `CLAUDE.md` (about 5.5k tokens) at session start when stale is bounded by `additionalContextLimit` 12000. A much larger `CLAUDE.md` would spill to a file preview: raise the limit then.
- **Network on is broader than strictly needed for sync.** Sync doesn't need it (it runs outside the sandbox). It's on for parity with Claude (Q4). The off alternative is one line in `config.managed.toml`.
- **Writable rules files.** `~/.claude` and `~/.hermes` are writable by Codex, as they are by Claude. A prompt-injected Codex could edit rules or skills, but not the sync machinery, the secret gate, the hooks or settings. Those are read-only, and `sync.sh` still scans every commit.
- **`project_doc_max_bytes` = 256 KiB costs context.** That is the price of FigmaToBricksV2's 141 KB `CLAUDE.md` in Codex sessions in that repo, the same as Claude's.
- **Plugin skill duplicates** (Q10) depend on plugin cache paths that change on plugin updates. `setup-codex.sh --check` flags drift. Rerun it after updating plugins.
- **`/import`.** Codex's `/import` from Claude Code would create a second copy of rules, skills and hooks. The docs say never to use it.
- **Codex version drift between machines.** Desktop installs get the latest. The tests record `codex --version`, and the docs say to update both machines together.

## Completion and reporting contract

- **Builder:** stops at `ready-for-review` and reports:
  - the worktree, branch, base SHA and head SHA;
  - each AC's exact test command;
  - offline suite results;
  - which probes ran and their outcome;
  - the F1–F8 findings;
  - `skill_lessons`.
- **Verifier and auditor:** follow `ac-verification.md`, with the test commands above. Probe ACs run for real, through the probe home. AC24–AC27 are `(live)`: `not_run` unless they could run them (AC24 when Docker is up).
- **`ac-check.sh`:** expected outcomes are `ALL ACCEPTED` or `READY FOR THE USER` with the live ACs owed: AC24 (unless run), AC25, AC26, AC27.
- **Milestones are separate.** Merged into local `main`, installed into `~/.codex`, pushed to GitHub and verified on the desktop are reported separately; none implies the next.
