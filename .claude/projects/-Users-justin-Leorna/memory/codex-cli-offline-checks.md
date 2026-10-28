---
name: codex-cli-offline-checks
description: "Checking Codex CLI setup without a sign-in or quota, the $TMPDIR sandbox-test trap, and why real codex exec needs a probe home"
metadata:
  node_type: memory
  type: reference
  originSessionId: 661afd37-191a-487a-b222-38b83f19c5d5
  modified: 2026-10-28T07:27:20.690Z
---

Codex CLI 0.163 can be checked offline, with no sign-in and no quota (codex-parity planner probes, 2026-10-28):
- `codex debug prompt-input` prints the prompt Codex would send: AGENTS.md, the skills list and roots, and the permission profile.
- `codex doctor --json` reports malformed agent role files ("Ignoring malformed agent role definition").
- `codex sandbox -P <profile> -C <dir> -- cmd` runs a command under the real sandbox, and works nested inside Claude's shell.
- `codex execpolicy check --rules <file> -- <argv>` tests rules files.

Gotchas:
- **Sandbox tests need fake homes outside `$TMPDIR` and `/tmp`,** with `TMPDIR` pointed elsewhere too. The `:workspace` profile can write temp folders, so a fake home there lets every write through and the test passes for the wrong reason. The first probe allowed every write; the rerun with `TMPDIR` moved denied writes to `~/.codex`.
- **Claude can't run `codex exec` against the real login.** Codex keeps it in the keychain, Claude Code's auto mode denies keychain lookups and the sandbox bypass, and `codex login status` from Claude's shell says "Not logged in". Real `codex exec` tests need a separate home with a file-stored login (`CODEX_HOME=~/.codex-probe`), which Justin signs in to once.
- **`codex exec` from a script waits forever on a non-terminal stdin** ("Reading additional input from stdin..."): always add `</dev/null`.
- **`codex exec` can't prove an execpolicy allow rule:** under approval `never` (its default) rules don't lift the sandbox, exec has no on-request mode, and `--approve-for-me`'s reviewer approves escalations with no rule at all. Test rules offline with `codex execpolicy check`, and live in the TUI (codex-parity AC11, 2026-10-28).
- **Spawn custom Codex roles with `fork_turns "none"`:** a full-history fork takes the parent's model and ignores the role file's. The spawn tool's hook `tool_name` is `collaborationspawn_agent`.

Related: [[claude-code-hook-internals]], [[zsh-bash-tool-gotchas]]
