---
name: codex-cli-offline-checks
description: "Checking Codex CLI (and Claude Code settings) without a sign-in or quota, the $TMPDIR sandbox-test trap, and why real codex exec needs a probe home"
metadata:
  node_type: memory
  type: reference
  originSessionId: 661afd37-191a-487a-b222-38b83f19c5d5
  modified: 2026-10-29T12:37:32.000Z
---

Codex CLI 0.163 can be checked offline, with no sign-in and no quota (codex-parity planner probes, 2026-10-28):
- `codex debug prompt-input` prints the prompt Codex would send: AGENTS.md, the skills list and roots, and the permission profile, including the effective sandbox ("`sandbox_mode` is `workspace-write` … Network access is restricted"), so a shipped config can be proven applied.
- `CODEX_HOME=<scratch> codex mcp get <name> --json` prints the parsed MCP transport (type, url, `bearer_token_env_var`) (0.165, 901j planner, 2026-10-28). To see the exact bytes Codex sends to an MCP server with no sign-in: in a throwaway `CODEX_HOME`, set a custom `model_provider` whose `base_url` is a local listener answering 400 with `request_max_retries=0`, then `RUST_LOG=warn codex exec --skip-git-repo-check -s read-only x </dev/null`: it starts every MCP server before the model call and logs `codex_rmcp_client` header warnings. For Claude Code, `claude mcp add-json -s user` with an `http://` url, then `claude mcp list`, connects to each. A raw-socket listener records both tools' header bytes (901j fixer 6, 96 cases).
- `codex doctor --json` reports malformed agent role files ("Ignoring malformed agent role definition").
- Claude Code 2.1.312: `claude doctor` with a throwaway HOME validates a project's `.claude/settings.json` ("Invalid settings … permissions.allow: Expected array…") and lists `.mcp.json` `${VAR}`s that aren't set ("Missing environment variables: X"). It exits 0 either way, so read the output (901j planner).
- `codex sandbox -P <profile> -C <dir> -- cmd` runs a command under the real sandbox, and works nested inside Claude's shell.
- `codex execpolicy check --rules <file> -- <argv>` tests rules files.

Gotchas:
- **Sandbox tests need fake homes outside `$TMPDIR` and `/tmp`,** with `TMPDIR` pointed elsewhere too. The `:workspace` profile can write temp folders, so a fake home there lets every write through and the test passes for the wrong reason. The first probe allowed every write; the rerun with `TMPDIR` moved denied writes to `~/.codex`. On the WSL desktop, Justin's own Codex app-server daemon writes the real `~/.codex/*.sqlite` every few seconds, so prove a real-tool test stayed isolated by the scratch `CODEX_HOME` receiving `installation_id`/`config.toml` and the real `config.toml` being older than the run, not by whole-folder timestamps (86bcm901j review 1). Stronger: `grep -a -c <run's temp dir>` over `~/.codex/*.sqlite*` and their WAL files finds 0 matches when the run never wrote there (86bcm901j verifier 2).
- **Claude can't run `codex exec` against the real login.** Codex keeps it in the keychain, Claude Code's auto mode denies keychain lookups and the sandbox bypass, and `codex login status` from Claude's shell says "Not logged in". Real `codex exec` tests need a separate home with a file-stored login (`CODEX_HOME=~/.codex-probe`), which Justin signs in to once.
- **Codex 0.165 refuses `approval_policy = "untrusted"`** (exit 1, "is no longer supported; remove this setting") but silently ignores unknown config keys, so a typo'd key passes a load check (901j planner). **`history.persistence = "none"` stops only `~/.codex/history.jsonl`:** session transcripts still go to `~/.codex/sessions/rollout-*.jsonl` (`codex exec --help`: `--ephemeral` "Run without persisting session files to disk"), so config docs must not promise prompts leave no trace (901j fixer 1).
- **`codex exec` from a script waits forever on a non-terminal stdin** ("Reading additional input from stdin..."): always add `</dev/null`.
- **`codex exec` can't prove an execpolicy allow rule:** under approval `never` (its default) rules don't lift the sandbox, exec has no on-request mode, and `--approve-for-me`'s reviewer approves escalations with no rule at all. Test rules offline with `codex execpolicy check`, and live in the TUI (codex-parity AC11, 2026-10-28).
- **Spawn custom Codex roles with `fork_turns "none"`:** a full-history fork takes the parent's model and ignores the role file's. The spawn tool's hook `tool_name` is `collaborationspawn_agent`.

Related: [[claude-code-hook-internals]], [[zsh-bash-tool-gotchas]]
