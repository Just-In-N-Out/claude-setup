# 86bctmuwy-agent-items-install: install Agent items into Claude Code, Codex and Cursor

**Status: APPROVED by Justin ('go' 2026-11-07, Revision 1 answers 6=Add AC12, 7a, 8a, AC12+AC13 approved). Builder: Opus 5.5 high.** Hand-over only at the end: no push, PR or ClickUp post until Justin says.

ClickUp: [Install Agent items into local Claude Code, Codex and Cursor tool directories](https://app.clickup.com/t/86bctmuwy) (to do, assignee Justin, tag pi-2, list E4 - Distribution, no dependencies). Repo: `~/Leorna/leorna-client` only. Pipeline: Full.

## Questions (the plan is written as if every ⭐ answer was chosen)

1. A file Leorna didn't write already sits at an agent's path:
   - a ⭐ Leave it untouched; skip that agent with a warning
   - b Replace it, keep the old one as `.leorna.bak` (skills' rule)
2. An agent with a `tools:` limit, for Codex and Cursor (they can't limit tools per agent):
   - a ⭐ Skip it for that tool, with a warning
   - b Install it without the limit, with a warning
3. An agent body the client can't read (bad frontmatter, unknown key, bad name):
   - a ⭐ Skip only that agent, with a warning; the rest syncs
   - b Fail the tool's whole Sync before writing (prompts' rule)
4. Removing an unassigned agent file the user edited:
   - a ⭐ Existing rule: keep the file, stop that tool's update
   - b Keep the file, warn, finish the rest of the update
5. An agent named like a built-in agent (`general-purpose`, `explorer`…):
   - a ⭐ Skip it for that tool, with a warning
   - b Install it anyway
6. Proof Cursor loads the file. **Answered (Revision 1): Justin chose "Add AC12 now", replacing 6A.** The Cursor CLI is now installed (`cursor-agent` 2026.11.05-86047df).
   - ~~a Official docs + exact-byte tests; real check is a follow-up~~ (replaced)
   - ✅ Add AC12: a real-Cursor check run by an agent (see Revision 1)
7. (Revision 1) Cursor CLI 2026.11.05 never reads `~/.cursor/agents` (only project folders). **Answered: 7a.**
   - ✅ a Keep `~/.cursor/agents` (docs: editor); AC13 (live) checks the editor
   - b Also write Cursor agents into the project's `.cursor/agents`
8. (Revision 1) Cursor's own parser keeps YAML quotes in the description. **Answered: 8a.**
   - ✅ a Write Cursor's description as one plain line (skip multi-line descriptions)
   - b Keep JSON quotes (Cursor shows the quotes)

Why the ⭐s: 1a is Justin's own planner note ("never overwrite or delete a file Leorna did not write"). 2a keeps a "read-only" agent from silently getting write tools. 3a keeps every Sync that works today working (today every agent is skipped harmlessly; a hard failure would be a regression). 4a follows the existing removal rule all kinds share (consistency note). 5a: the agent would either replace the tool's own agent or be hidden by it, and Leorna can't tell which, so "installed" could be false. 6a: Cursor's docs are clear and current, but no Cursor binary exists here to load the file.

## Base

- **Base SHA (GitHub `main`, fetched over HTTPS through gh 2026-11-07 20:2x EST):** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b` (PR #26 merge). The shared main checkout `~/Leorna/leorna-client` is on `main` at `f105e27`, 28 commits behind; the planner did **not** fast-forward it (builder's task T0).
- Control plane, for reference only: GitHub main `c8abbdd`.
- **Overlap with other stories:** none. No open client PRs (`gh pr list -R LeornaAI/leorna-client --state open` → `[]`). The only client worktree, `86bcm902w-content-usage-analytics`, is already merged into main. Open control-plane worktrees are in the other repo. Justin's other client card 86bcm928h (per-user credentials) hasn't started.

## Playback

Today all three connectors write nothing for an `agent` item: each transformer adds one warning, `agent "<name>" is not installed for <tool>; skipped` (`toolconnector/transform.go:22-33`, called from `claudecode/config.go:43`, `codex/config.go:43`, `cursor/config.go:36`). This story makes Sync write each agent into the tool's own agent folder, in the tool's own format: Claude Code `<project>/.claude/agents/<name>.md`, Codex `$CODEX_HOME/agents/<name>.toml`, Cursor `~/.cursor/agents/<name>.md`. An agent a tool can't express gets a visible per-agent skip reason, never a false success. Sync never replaces a file Leorna didn't write. Updates replace only Leorna's own unchanged file. Removal follows the existing rule. No `toolconnector.Connector` change, no `ConfigBundle` change, no OpenAPI or CI change. Every test runs in throwaway homes.

Root cause (why agents are skipped): when the client was written, no tool's agent layout had been checked, so `AgentWarnings` skips every agent for every tool (`transform.go:22-24`: "native installation remains unsupported until each tool's agent layout is defined"). All three layouts are now documented and proven below.

## Acceptance criteria (all proposed; "go" approves them)

- AC1 (proposed): Given a bundle with agent items, when a confirmed Sync runs for Claude Code with a selected project, then `<project>/.claude/agents/<name>.md` holds exactly the rendered subagent (name, JSON-quoted description, the body's `tools` line when it has one, then the instructions), its path and SHA-256 are in Claude Code's Sync evidence, no warning names it, and Check files is clean — test: TestSyncInstallsAgentForClaudeCodeProject
- AC2 (proposed): Given the same bundle, when Sync runs for Codex, then `$CODEX_HOME/agents/<name>.toml` holds exactly `name`, `description` and `developer_instructions` as TOML strings, its path and SHA-256 are in Codex's Sync evidence, no warning names it, and Check files is clean — test: TestSyncInstallsAgentForCodexHome
- AC3 (proposed): Given the same bundle, when Sync runs for Cursor, then `~/.cursor/agents/<name>.md` holds exactly the rendered subagent (name, description as one plain line, instructions), its path and SHA-256 are in Cursor's Sync evidence, no warning names it, and Check files is clean — test: TestSyncInstallsAgentForCursorHome
- AC4 (proposed): Given an agent Sync wrote and then updated for Claude Code, when real Claude Code (2.1.319, throwaway HOME, local fake model API) starts in that project, then it lists the agent exactly once, sends the model the updated description and tools, and ignores the `.leorna.bak` copy — test: TestClaudeLoadsSyncedAgent
- AC5 (proposed): Given an agent Sync wrote and then updated for Codex, when real Codex (0.165.0, throwaway `CODEX_HOME`) builds its prompt, then the agent is a spawnable role exactly once with the updated description, and the `.leorna.bak` copy is not listed — test: TestCodexListsSyncedAgentRole
- AC6 (proposed): Given agents a tool can't express (a `tools` limit on Codex or Cursor, a built-in agent's name, an unsupported frontmatter key), when Sync runs, then that tool writes no file for them, reports exactly one warning per agent `agent "<name>" is not installed for <tool>: <reason>; skipped` (also kept in the run log after reopening), lists no evidence for them, and still installs its other items with status success — test: TestSyncSkipsAgentsAToolCannotExpressWithVisibleReason
- AC7 (proposed): Given a file Leorna didn't write at an agent's path (the user's own file, or a Leorna file the user edited), when Sync runs, then the file keeps its exact bytes and mode, no `.leorna.bak` is made beside it, one warning names it, the tool's other items install, and a file already holding exactly the rendered bytes is taken over without a warning — test: TestSyncKeepsAgentFileLeornaDidNotWrite
- AC8 (proposed): Given an agent installed by an earlier Sync and unchanged since, when a later bundle changes it, then Sync replaces the file with the new bytes, keeps the previous bytes as `<file>.leorna.bak`, records the new SHA-256, and Check files is clean — test: TestSyncUpdatesLeornaAgentFile
- AC9 (proposed): Given an agent installed by an earlier Sync, when a later bundle no longer has it, then Sync removes the file only while it still matches the recorded SHA-256 (keeping `<file>.leorna.bak`); a file the user changed stays byte-for-byte and that tool's update stops with `write_failed` while the other tools finish (the existing rule) — test: TestSyncRemovesUnassignedAgentOnlyWhenUnchanged
- AC10 (proposed): Given automatic updates are on, when a startup check finds a new bundle that adds an agent, then only tools a confirmed manual Sync enrolled get the agent file, and before any confirmed Sync no agent file is written anywhere — test: TestStartupSyncInstallsAgentsOnlyForConfirmedTools
- AC11 (proposed): Given HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR and the XDG folders point at an empty decoy folder, when an agent Sync runs for all three tools, then nothing appears in the decoy and the only files written are the expected ones under the test's own roots — test: TestAgentSyncTouchesNoRealHome
- AC12 (proposed): Given the exact bytes Sync renders for Cursor, written and then updated through the Cursor connector into a workspace `.cursor/agents/` folder, when the real Cursor CLI (2026.11.05-86047df, throwaway HOME and config dirs, local fake Cursor API, no sign-in) prepares a run there, then the request context it sends lists that agent exactly once with the same name, the updated description without added quotes, and the instructions, and leaves out the `.leorna.bak` copy — test: TestCursorLoadsSyncedAgentFormat
- AC13 (proposed) (live): Given a Sync that installed an agent for Cursor in `~/.cursor/agents/`, when Justin opens the Cursor editor on the same machine, then the agent appears in Cursor's subagent list with its name and description — test: TestCursorEditorShowsSyncedAgentLive (Justin's check; the verifier records it `not_run` until he confirms)

AC13 is the only `(live)` AC (Justin's Cursor editor check, Revision 1 answer 7a). AC4 and AC5 are agent-run real-tool tests, gated by `LEORNA_TEST_CLAUDE_BIN` / `LEORNA_TEST_CODEX_BIN` like the repo's other real-tool tests: they skip in CI, and the builder, verifier and auditor must run them with the variables set (commands in "Gates").

**Plan code checked (planner, 2026-11-07, throwaway `git archive` of `7a83443`, removed afterwards):** T1–T6's production code and `sync.go` change, pasted from this file's code blocks, are gofmt-clean, `go build ./...` and `go vet ./toolconnector/... ./application/` pass, T1's two tests pass, and the "Rendered bytes" and AC6 warning texts below match what that code renders. `go test ./toolconnector/... ./application/... ./usage/... ./desktop/...` (no `-race`) then fails exactly the two existing tests this plan changes, `TestTransformersSkipAgentsWithDeterministicVisibleWarnings` and `TestSyncEndToEndWithLoginMockTLSAndRealWriters`; everything else passes. No AC test was written or run.

Expected tallies, so a reviewer can count: 11 AC tests, 7 supporting unit tests (T1–T6), one changed existing test (`TestSyncEndToEndWithLoginMockTLSAndRealWriters`), one deleted test (`TestTransformersSkipAgentsWithDeterministicVisibleWarnings`, replaced by T5's test).

## Doc research (checked 2026-11-07 EST)

| Tool | Native agent format | Where Leorna writes it | Fields Leorna writes | Sources | Decision |
|---|---|---|---|---|---|
| Claude Code | Markdown + YAML frontmatter, body = system prompt. Scopes: managed > `--agents` > project `.claude/agents/` > user `~/.claude/agents/` > plugin. Scanned recursively; file name needn't match `name`; required `name` (≤256 chars, no `:`, not starting `-`) and `description`; optional `tools` (comma-separated string or list), `model`, `permissionMode`, `disallowedTools`, `hooks`, `mcpServers`…; unknown fields ignored silently. Changes are picked up live, except a brand-new `agents` folder needs a restart. | `<project>/.claude/agents/<name>.md` (the Claude Code connector is project-scoped for every kind: `claudecode/config.go:14-16`) | `name`, `description` (JSON-quoted), `tools` (JSON-quoted, only when the body has it) | https://code.claude.com/docs/en/sub-agents ; probe below | **Supported** |
| Codex | One TOML file per agent in `~/.codex/agents/` (user) or `.codex/agents/` (project). Required `name`, `description`, `developer_instructions`; optional `model`, `model_reasoning_effort`, `features.*`…; `name` is the identity, not the file name; a custom agent with a built-in's name (`default`, `worker`, `explorer`) **takes precedence** over it. Source: the user layer's folder is the config folder, `$CODEX_HOME` (`config_folder.join("agents")`), only `*.toml` files are read, unknown keys are refused (`deny_unknown_fields`), and a duplicate name in one folder is skipped with a warning. No per-agent tool list. | `$CODEX_HOME/agents/<name>.toml` (Codex connector `Home`; `agents/` is not under `skills/`, so `splitRoots` keeps it in Home: `codex/capture.go:192-201`) | `name`, `description`, `developer_instructions` | https://developers.openai.com/codex/subagents (redirects to https://learn.chatgpt.com/docs/agent-configuration/subagents); https://learn.chatgpt.com/docs/config-file/config-reference ; source `openai/codex` main `d960b366941b` (2026-11-07): `codex-rs/agent-roles/src/loader.rs` (`discover_agent_roles_in_dir`, `config_folder.join("agents")`), `discovery.rs` (`extension == "toml"`), `agent_role_config.rs` (`deny_unknown_fields`, required `name`) | **Supported**; `tools` limit → skip |
| Cursor | Markdown + YAML frontmatter, body = prompt. Project `.cursor/agents/` (also reads `.claude/agents/`, `.codex/agents/`), user `~/.cursor/agents/` (also `~/.claude/agents/`, `~/.codex/agents/`). Fields `name` (default from file name; "lowercase letters and hyphens"), `description`, `model` (default `inherit`), `readonly`, `is_background`; none required. Project wins over user; `.cursor/` wins over `.claude/`/`.codex/`. Works in editor, CLI and Cloud Agents. No per-agent tool list. | `~/.cursor/agents/<name>.md` (Cursor connector `Home` = `~/.cursor`, user scope like its skills and commands: `available/registry.go:51`) | `name`, `description` (JSON-quoted) | https://cursor.com/docs/context/subagents | **Supported** (doc + byte tests; Q6); `tools` limit → skip |

**Planner probes (2026-11-07, throwaway HOME `~/.cache/86bctmuwy-planner`, removed afterwards; the real `~/.claude`, `~/.codex`, `~/.cursor` were not used, checked: no `~/.claude/projects` entry for the probe folder, 0 matches for the probe path in `~/.codex/*.sqlite*`, real `~/.codex/config.toml` untouched since 2026-11-04):**
- Claude Code 2.1.319 (`/home/justin/.local/share/claude/versions/2.1.319`), project `.claude/agents/probe-reviewer.md` with a JSON-quoted description and `tools: "Read, Grep"`: `claude -p … --output-format stream-json --verbose --setting-sources project` emits the `system`/`init` event even with no sign-in, and its `agents` are `['claude', 'Explore', 'general-purpose', 'Plan', 'probe-reviewer', 'statusline-setup']`. With a local fake API (`ANTHROPIC_BASE_URL`), the request to the model contains `- probe-reviewer: Probe agent: reviews code. Use for: probe checks. (Tools: Read, Grep)`. A valid agent saved as `probe-backup.md.leorna.bak` was **not** loaded (0 matches). So JSON-quoted values work and `.leorna.bak` is ignored.
- Codex 0.165.0 (`codex` npm package), `$CODEX_HOME/agents/probe-reviewer.toml` with `name`, `description`, `developer_instructions`: `codex debug prompt-input x` (no sign-in) lists it in the spawn tool's `agent_type` description: `Available roles:\nprobe-reviewer: {\nProbe agent: …\n}\ndefault: …explorer: …worker: …`. `codex doctor --json` fails only on missing credentials.
- Cursor: no `cursor-agent`/`agent` binary on this desktop.

## Approach

1. **Shared parser** `toolconnector/agent.go`: `ParseAgent(item) (Agent, reason)` splits an agent body exactly as the control plane's item builder writes it (`leorna-control-plane internal/itembuilder/validate.go:170-206`, read 2026-11-07: body must start `---\n`, frontmatter closes with `\n---\n` within 4096 bytes, keys only `name`, `description`, optional `tools`, each one plain or JSON-quoted line, name and description equal to the form fields). The client trusts the item's own `Name`/`Description`, takes `tools` and the instructions from the body, and accepts a body with no frontmatter (older items) as all instructions. Anything else → a skip reason (Q3 a). Shipped library agents (`code-reviewer`, `security-auditor`, `test-engineer`, `web-performance-auditor`) have only `name`/`description`, so they install for all three tools.
2. **Each transformer renders its own file** (pure, no file reads), next to its other kinds: Claude Code writes Markdown with JSON-quoted values; Cursor writes the description as one plain line, because Cursor's line parser keeps quotes (Revision 1, 8a) (the same quoting `RenderSkill` uses, so a description can't add frontmatter keys); Codex writes three TOML basic strings with the package's existing `tomlString`. Built-in names skip (Q5 a); a `tools` limit skips for Codex and Cursor (Q2 a). A skipped agent adds one sorted warning and no file; the rest of the pack still renders. `AgentWarnings` is deleted.
3. **Existing-file guard** `application/agent_guard.go`, run by `SyncEngine.Run` after the baseline is chosen and before removals are computed. It hashes each planned agent file and asks the connector's existing `CheckConfig` (the `configChecker` interface in `application/file_check.go:59`, implemented by all three connectors; not part of `toolconnector.Connector`) what is on disk. Write only when the path is empty, already holds the same bytes, or still holds exactly what this tool's baseline Sync wrote. Otherwise drop that agent from the bundle with a warning naming the bundle-relative path, and keep a dropped baseline path out of `Remove` so a kept file never makes the tool's update fail (Q1 a). Symlinks, unreadable files and a tool that can't be checked are all "not written". Removal of unassigned agents stays the existing `Remove` rule (Q4 a).
4. **Nothing else changes:** connector `ApplyConfig`/`nativewrite` already stage, roll back, refuse symlinks/escapes and keep `.leorna.bak`; the Sync evidence, Check files, startup updates and the UI's per-tool warning list (`frontend/dist/sync.js:163-166`) already carry any bundle path and warning.

**Why not a `Connector` or `ConfigBundle` change:** bundle paths and warnings already carry everything; the guard needs only `ID()` and `CheckConfig`. Follow-up F5 records that no interface change is needed.

## Interfaces and data shapes

```go
// toolconnector (new, agent.go)
type Agent struct {
	Name, Description, Instructions string
	Tools                           string // as authored; "" = no limit
}
func ParseAgent(item PackItem) (Agent, string)                      // reason "" on success
func SkippedAgentWarning(name string, toolID ToolID, reason string) string
func QuoteYAMLLine(value string) []byte                              // JSON string + "\n"
// removed: func AgentWarnings(pack Pack, toolID ToolID) []string

// claudecode, codex, cursor (new, agent.go in each)
func AgentPath(name string) string // ".claude/agents/<n>.md" | "agents/<n>.toml" | "agents/<n>.md"

// application (new, agent_guard.go)
func guardAgentFiles(ctx context.Context, connector tc.Connector, pack tc.Pack,
	bundle *tc.ConfigBundle, baseline map[string]string) (held map[string]bool)
```

Warning text: `agent "<name>" is not installed for <tool-id>: <reason>; skipped`. Exact reasons (tests pin them):

| Where | Reason |
|---|---|
| ParseAgent: name | `its name must be 1 to 64 lowercase letters, digits and hyphens` |
| ParseAgent: empty | `it needs a description and instructions` |
| ParseAgent: frontmatter | `its frontmatter must open and close with --- lines and hold one "key: value" line per field` |
| ParseAgent: key | `its frontmatter key "<key>" is not supported` |
| Claude Code built-in | `it has the name of a built-in Claude Code agent` (`claude`, `explore`, `general-purpose`, `plan`, `statusline-setup`) |
| Codex built-in | `it has the name of a built-in Codex agent` (`default`, `explorer`, `worker`) |
| Codex tools | `Codex agent files cannot limit tools` |
| Cursor tools | `Cursor agent files cannot limit tools` |
| Cursor description | `Cursor agent descriptions must be one line` |
| Guard: foreign | `<rel path> already exists and was not written by Leorna` |
| Guard: edited | `<rel path> was changed after Leorna wrote it` |
| Guard: unknown | `<rel path> could not be checked` |

Check order in each renderer: `ParseAgent` → built-in name → tools.

Rendered bytes for the canonical fixture agent (used by T2–T4 and AC1–AC3):
- item: `Kind: agent, Name: "release-reviewer", Version: "1", Description: "Reviews a release: risks & \"blockers\""`, `Body: "---\nname: release-reviewer\ndescription: \"Reviews a release: risks & \\\"blockers\\\"\"\n---\n\n# Role\n\nReview the release.\n"`
- Claude Code, `release-reviewer.md`: `"---\nname: release-reviewer\ndescription: \"Reviews a release: risks & \\\"blockers\\\"\"\n---\n\n# Role\n\nReview the release.\n"`
- Cursor, `release-reviewer.md` (plain description, 8a): `"---\nname: release-reviewer\ndescription: Reviews a release: risks & \"blockers\"\n---\n\n# Role\n\nReview the release.\n"`
- Codex, `release-reviewer.toml`: `"name = \"release-reviewer\"\ndescription = \"Reviews a release: risks & \\\"blockers\\\"\"\ndeveloper_instructions = \"# Role\\n\\nReview the release.\"\n"`
- second agent with tools: `Name: "read-only-reviewer", Description: "Reads code and reports findings"`, `Body: "---\nname: read-only-reviewer\ndescription: Reads code and reports findings\ntools: Read, Grep\n---\n\nReport findings only.\n"` → Claude Code `"---\nname: read-only-reviewer\ndescription: \"Reads code and reports findings\"\ntools: \"Read, Grep\"\n---\n\nReport findings only.\n"`; Codex and Cursor skip it.

## Files touched

| File | Change |
|---|---|
| `toolconnector/agent.go` (new) | `Agent`, `ParseAgent`, `SkippedAgentWarning`, `QuoteYAMLLine` |
| `toolconnector/agent_test.go` (new) | T1 tests |
| `toolconnector/transform.go` | delete `AgentWarnings` (lines 22-33) |
| `toolconnector/agent_transform_test.go` | replace the old skip test with T5; keep `TestPackValidationAcceptsAgentAndStillRejectsUnknownKind` |
| `toolconnector/claudecode/agent.go` (new), `config.go` | render agents; `warnings := make([]string, 0)` |
| `toolconnector/claudecode/agent_test.go` (new), `agent_real_test.go` (new) | T2, AC4 |
| `toolconnector/codex/agent.go` (new), `config.go` | render agents; sort warnings |
| `toolconnector/codex/agent_test.go` (new), `agent_real_test.go` (new) | T3, AC5 |
| `toolconnector/cursor/agent.go` (new), `config.go` | render agents; sort warnings |
| `toolconnector/cursor/agent_test.go` (new) | T4 |
| `application/agent_guard.go` (new), `sync.go` (lines 247-266) | guard + baseline/held wiring |
| `application/agent_guard_test.go` (new) | T6 |
| `application/sync_prompt_e2e_test.go` | extract its TLS fixture into `newBundleSyncFixture` (behaviour unchanged) |
| `application/sync_agent_e2e_test.go` (new) | AC1–AC3 |
| `application/sync_agent_test.go` (new) | AC6–AC11 + `agentBundle` helper |
| `application/sync_e2e_test.go` (line 247-250) | the `tester` agent is now installed: expect 4 files, the agent file, no agent warning |
| `README.md` (~406), `application/README.md` (Sync order para), `PROJECT_MEMORY.md` (line 36), `toolconnector/{claudecode,codex,cursor}/README.md` | docs |

Not touched: `toolconnector/connector.go`, `toolconnector/types.go`, `nativewrite/*`, `api/*`, OpenAPI, `.github/*`, frontend.

## Tasks (test-first; each RED must fail on the assertion, not on a compile error, except where noted)

Builder sizing target: 2–5 minute edits; whole build forecast 3–5 h including gates, real-tool runs, mutations and evidence.

### T0. Set up (no code)

1. Fast-forward the shared main checkout (it is clean on `main`, untracked `.claude/` only): `git -C ~/Leorna/leorna-client -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-client.git main:refs/remotes/origin/main && git -C ~/Leorna/leorna-client merge --ff-only origin/main`; stop and ask if it refuses. Check `git rev-parse origin/main` is still `7a834434d00e…`; if GitHub main moved, record the new SHA as the base and tell the orchestrator.
2. Worktree: `git -C ~/Leorna/leorna-client worktree add .claude/worktrees/86bctmuwy-agent-items-install -b feat/86bctmuwy-agent-items-install origin/main`. Add `CLAUDE.md` to `.git/info/exclude` if the repo has one. Commits `feat(86bctmuwy): …`, plain `git commit`, identity from `~/.gitconfig` (`Justin Issa <justin@leorna.com>`), no AI attribution lines.
3. Owned scratch on the real disk (not `/tmp`): `mkdir ~/.cache/86bctmuwy-builder` (fails if it exists: pick `-2`), `mkdir ~/.cache/86bctmuwy-builder/tmp`, `export TMPDIR=$(cd ~/.cache/86bctmuwy-builder/tmp && pwd -P)`. Toolchain, task-local only: `export PATH=$HOME/.local/leorna-toolchain/bin:$HOME/.local/leorna-toolchain/go/bin:$PATH`; echo `go version` (go1.27.3), `golangci-lint --version` (2.14.0 = CI), `govulncheck -version` (v1.7.0 = CI). make 4.4.1 and gcc 15 are installed.
4. Baseline on the untouched worktree (base `7a83443`): run the Gates section's three gates, save `~/.hermes/plans/leorna/evidence/86bctmuwy/builder/gates-7a83443.txt` with each `EXIT=`. Any base failure is recorded by test name before editing.
5. Before-state captures (base): `go test -mod=vendor ./toolconnector -run '^TestTransformersSkipAgentsWithDeterministicVisibleWarnings$' -count=1 -v` → `before-agents-skipped.png` (every tool skips every agent today).

### T1. `ParseAgent` (toolconnector/agent.go)

RED: create `toolconnector/agent_test.go`:

```go
package toolconnector_test

import (
	"strings"
	"testing"

	tc "github.com/LeornaAI/leorna-client/toolconnector"
)

const releaseReviewerBody = "---\nname: release-reviewer\ndescription: \"Reviews a release: risks & \\\"blockers\\\"\"\n---\n\n# Role\n\nReview the release.\n"

func agentItem(name, description, body string) tc.PackItem {
	return tc.PackItem{Kind: tc.PackKindAgent, Name: name, Version: "1", Description: description, Body: body}
}

func TestParseAgentReadsBuilderFrontmatterAndPlainBodies(t *testing.T) {
	cases := []struct {
		label string
		item  tc.PackItem
		want  tc.Agent
	}{
		{"builder frontmatter, quoted description", agentItem("release-reviewer", `Reviews a release: risks & "blockers"`, releaseReviewerBody),
			tc.Agent{Name: "release-reviewer", Description: `Reviews a release: risks & "blockers"`, Instructions: "# Role\n\nReview the release."}},
		{"plain tools line", agentItem("read-only-reviewer", "Reads code and reports findings", "---\nname: read-only-reviewer\ndescription: Reads code and reports findings\ntools: Read, Grep\n---\n\nReport findings only.\n"),
			tc.Agent{Name: "read-only-reviewer", Description: "Reads code and reports findings", Tools: "Read, Grep", Instructions: "Report findings only."}},
		{"quoted tools line", agentItem("git-reader", "Reads git history", "---\nname: git-reader\ndescription: Reads git history\ntools: \"Read, Bash(git log:*)\"\n---\nRead the log.\n"),
			tc.Agent{Name: "git-reader", Description: "Reads git history", Tools: "Read, Bash(git log:*)", Instructions: "Read the log."}},
		{"shipped library agent header", agentItem("code-reviewer", "Senior code reviewer that evaluates changes across five dimensions — correctness, readability, architecture, security, and performance. Use for thorough code review before merge.",
			"---\nname: code-reviewer\ndescription: Senior code reviewer that evaluates changes across five dimensions — correctness, readability, architecture, security, and performance. Use for thorough code review before merge.\n---\n\n# Senior Code Reviewer\n\nYou are an experienced Staff Engineer.\n"),
			tc.Agent{Name: "code-reviewer", Description: "Senior code reviewer that evaluates changes across five dimensions — correctness, readability, architecture, security, and performance. Use for thorough code review before merge.", Instructions: "# Senior Code Reviewer\n\nYou are an experienced Staff Engineer."}},
		{"older body without frontmatter", agentItem("tester", " Test changes ", "agent body"),
			tc.Agent{Name: "tester", Description: "Test changes", Instructions: "agent body"}},
		{"empty frontmatter", agentItem("blank-header", "Blank header", "---\n---\nGo.\n"),
			tc.Agent{Name: "blank-header", Description: "Blank header", Instructions: "Go."}},
	}
	for _, c := range cases {
		t.Run(c.label, func(t *testing.T) {
			got, reason := tc.ParseAgent(c.item)
			if reason != "" || got != c.want {
				t.Fatalf("ParseAgent = %+v, %q; want %+v", got, reason, c.want)
			}
		})
	}
}

func TestParseAgentRefusesBodiesToolsCannotRead(t *testing.T) {
	const frontmatter = `its frontmatter must open and close with --- lines and hold one "key: value" line per field`
	cases := []struct {
		label, name, description, body, reason string
	}{
		{"name with spaces", "Release Notes", "Notes", "Go.", "its name must be 1 to 64 lowercase letters, digits and hyphens"},
		{"name too long", strings.Repeat("a", 65), "Long", "Go.", "its name must be 1 to 64 lowercase letters, digits and hyphens"},
		{"blank description", "a", "  ", "Go.", "it needs a description and instructions"},
		{"no instructions", "a", "A", "---\nname: a\ndescription: A\n---\n\n  \n", "it needs a description and instructions"},
		{"unclosed", "a", "A", "---\nname: a\ndescription: A\n", frontmatter},
		{"CRLF", "a", "A", "---\r\nname: a\r\n---\r\nGo.\r\n", frontmatter},
		{"indented opener", "a", "A", "  ---\nname: a\n---\nGo.\n", frontmatter},
		{"blank line", "a", "A", "---\nname: a\n\ndescription: A\n---\nGo.\n", frontmatter},
		{"duplicate key", "a", "A", "---\ntools: Read\ntools: Grep\n---\nGo.\n", frontmatter},
		{"empty value", "a", "A", "---\ntools:\n---\nGo.\n", frontmatter},
		{"YAML list", "a", "A", "---\ntools: [Read, Grep]\n---\nGo.\n", frontmatter},
		{"colon in plain value", "a", "A", "---\ntools: Bash: all\n---\nGo.\n", frontmatter},
		{"broken quote", "a", "A", "---\ntools: \"Read\n---\nGo.\n", frontmatter},
		{"unsupported key", "a", "A", "---\nname: a\ndescription: A\nmodel: opus\n---\nGo.\n", `its frontmatter key "model" is not supported`},
	}
	for _, c := range cases {
		t.Run(c.label, func(t *testing.T) {
			if _, reason := tc.ParseAgent(agentItem(c.name, c.description, c.body)); reason != c.reason {
				t.Fatalf("reason = %q, want %q", reason, c.reason)
			}
		})
	}
}
```

RED command: `go test -mod=vendor ./toolconnector -run 'TestParseAgent' -count=1` → fails to compile (`undefined: tc.ParseAgent`). That is expected: these are helper tests kept with the helper they introduce; the behaviour REDs are T2–T6 and the AC tests.

GREEN: create `toolconnector/agent.go`:

```go
package toolconnector

import (
	"bytes"
	"encoding/json"
	"fmt"
	"regexp"
	"strings"
)

// Agent is an agent item split into the parts every tool's native agent file
// needs. Name and Description come from the item, which the control plane
// keeps equal to the body's frontmatter; Tools and Instructions come from the
// body.
type Agent struct {
	Name         string
	Description  string
	Tools        string // as authored, such as "Read, Grep"; empty means no limit
	Instructions string
}

const malformedAgentFrontmatter = `its frontmatter must open and close with --- lines and hold one "key: value" line per field`

var agentFrontmatterKey = regexp.MustCompile(`^[A-Za-z][A-Za-z0-9_-]*$`)

// ParseAgent reads an agent item as the control plane's item builder writes
// it: an optional frontmatter block holding name, description and an optional
// tools line, then the instructions. A body with no frontmatter is all
// instructions. The reason is empty on success; otherwise it is the text of
// the item's skip warning and never names a local path.
func ParseAgent(item PackItem) (Agent, string) {
	if item.Kind != PackKindAgent {
		return Agent{}, "it is not an agent"
	}
	if len(item.Name) > maxSkillNameBytes || !skillName.MatchString(item.Name) {
		return Agent{}, "its name must be 1 to 64 lowercase letters, digits and hyphens"
	}
	agent := Agent{Name: item.Name, Description: strings.TrimSpace(item.Description)}
	body := item.Body
	if strings.HasPrefix(strings.TrimSpace(body), "---") {
		lines, rest, ok := splitAgentFrontmatter(body)
		if !ok {
			return Agent{}, malformedAgentFrontmatter
		}
		seen := map[string]bool{}
		for _, line := range lines {
			key, raw, found := strings.Cut(line, ":")
			if !found || !agentFrontmatterKey.MatchString(key) || seen[key] {
				return Agent{}, malformedAgentFrontmatter
			}
			seen[key] = true
			value, ok := agentFrontmatterValue(raw)
			if !ok {
				return Agent{}, malformedAgentFrontmatter
			}
			switch key {
			case "name", "description":
				// The item's own name and description are used.
			case "tools":
				agent.Tools = value
			default:
				return Agent{}, fmt.Sprintf("its frontmatter key %q is not supported", key)
			}
		}
		body = rest
	}
	agent.Instructions = strings.TrimSpace(body)
	if agent.Description == "" || agent.Instructions == "" {
		return Agent{}, "it needs a description and instructions"
	}
	return agent, ""
}

// splitAgentFrontmatter returns the frontmatter lines and the text after the
// closing --- line. The block must start the body and use LF line endings.
func splitAgentFrontmatter(body string) ([]string, string, bool) {
	rest, opened := strings.CutPrefix(body, "---\n")
	if !opened {
		return nil, "", false
	}
	if after, empty := strings.CutPrefix(rest, "---\n"); empty {
		return nil, after, true
	}
	end := strings.Index(rest, "\n---\n")
	if end < 0 {
		return nil, "", false
	}
	return strings.Split(rest[:end], "\n"), rest[end+len("\n---\n"):], true
}

// agentFrontmatterValue accepts the one-line values the item builder accepts:
// a JSON-quoted string, or a plain scalar YAML reads as that same string.
func agentFrontmatterValue(raw string) (string, bool) {
	value := strings.TrimSpace(raw)
	if strings.HasPrefix(value, `"`) {
		if err := json.Unmarshal([]byte(value), &value); err != nil {
			return "", false
		}
		value = strings.TrimSpace(value)
		return value, value != "" && !strings.ContainsAny(value, "\r\n")
	}
	if value == "" || strings.Contains(value, ": ") || strings.Contains(value, " #") || strings.ContainsAny(value[:1], "#'[{&*!%@`>|") {
		return "", false
	}
	return value, true
}

// SkippedAgentWarning is the one visible warning for an agent a tool did not
// install. Sync shows it with the tool's result and keeps it in the run log.
func SkippedAgentWarning(name string, toolID ToolID, reason string) string {
	return fmt.Sprintf("agent %q is not installed for %s: %s; skipped", name, toolID, reason)
}

// QuoteYAMLLine returns value as a JSON string, which YAML reads as a
// double-quoted scalar, followed by a newline, so it cannot add keys.
func QuoteYAMLLine(value string) []byte {
	var out bytes.Buffer
	encoder := json.NewEncoder(&out)
	encoder.SetEscapeHTML(false)
	_ = encoder.Encode(value) // a Go string always encodes
	return out.Bytes()
}
```

GREEN command: same `go test` → PASS. Commit `feat(86bctmuwy): parse agent items into name, description, tools and instructions` (explicit files).

### T2. Claude Code renders agents (`claudecode/agent.go`, `config.go`)

RED: `toolconnector/claudecode/agent_test.go`, `TestClaudeCodeRendersAgentsAsProjectSubagents`: transform a pack with `release-reviewer`, `read-only-reviewer` (bodies above), `general-purpose` (body `"Plain."`, description `"Built-in clash"`) and skill `review` (description `Review`, body `Review.`). Assert: `err == nil`; `bundle.Files[".claude/agents/release-reviewer.md"]` and `[".claude/agents/read-only-reviewer.md"]` equal the exact bytes in "Rendered bytes"; no `.claude/agents/general-purpose.md`; `.claude/skills/review/SKILL.md` present; `bundle.Warnings == []string{`agent "general-purpose" is not installed for claude-code: it has the name of a built-in Claude Code agent; skipped`}`; `claudecode.AgentPath("x") == ".claude/agents/x.md"`. RED: compile fails on `claudecode.AgentPath` until the file exists; create `agent.go` with `AgentPath` only first, then the byte assertions fail (no agent files) — that is the behaviour RED.

GREEN: `toolconnector/claudecode/agent.go`:

```go
package claudecode

import (
	"bytes"

	tc "github.com/LeornaAI/leorna-client/toolconnector"
)

// agentsDir holds Claude Code project subagents. Claude Code names an agent by
// its frontmatter name; Leorna also names the file after it.
const agentsDir = ".claude/agents/"

// AgentPath is the project-relative file Sync writes for an agent item.
func AgentPath(name string) string { return agentsDir + name + ".md" }

// builtInAgents are the agents Claude Code 2.1.319 lists in every session
// (stream-json init "agents", compared in lowercase). A project agent with
// one of these names would replace the built-in or be hidden by it.
var builtInAgents = map[string]bool{"claude": true, "explore": true, "general-purpose": true, "plan": true, "statusline-setup": true}

// renderAgent writes a subagent file. Description and tools are JSON-quoted,
// so neither can add frontmatter keys. reason is set when it is skipped.
func renderAgent(item tc.PackItem) (path string, content []byte, reason string) {
	agent, reason := tc.ParseAgent(item)
	if reason != "" {
		return "", nil, reason
	}
	if builtInAgents[agent.Name] {
		return "", nil, "it has the name of a built-in Claude Code agent"
	}
	var out bytes.Buffer
	out.WriteString("---\nname: " + agent.Name + "\ndescription: ")
	out.Write(tc.QuoteYAMLLine(agent.Description))
	if agent.Tools != "" {
		out.WriteString("tools: ")
		out.Write(tc.QuoteYAMLLine(agent.Tools))
	}
	out.WriteString("---\n\n" + agent.Instructions + "\n")
	return AgentPath(agent.Name), out.Bytes(), ""
}
```

`config.go`: line 43 becomes `warnings := make([]string, 0)`; add to the item switch:

```go
		case tc.PackKindAgent:
			path, content, reason := renderAgent(item)
			if reason != "" {
				warnings = append(warnings, tc.SkippedAgentWarning(item.Name, ID, reason))
				continue
			}
			files[path] = content
```

Update the doc comments on `Transformer`/bundle paths to name `.claude/agents`. GREEN: `go test -mod=vendor ./toolconnector/claudecode -run TestClaudeCodeRendersAgentsAsProjectSubagents -count=1`. (Until T5 the old cross-tool skip test fails to compile once `AgentWarnings` is gone; do T2–T5 before committing T5's deletion, or keep `AgentWarnings` until T5.)

### T3. Codex renders agents (`codex/agent.go`, `config.go`)

RED: `toolconnector/codex/agent_test.go`, `TestCodexRendersAgentsAsAgentRoleFiles`: pack with `release-reviewer`, `read-only-reviewer`, `explorer` (body `"Plain."`, description `"Built-in clash"`), skill `review`. Assert: `bundle.Files["agents/release-reviewer.toml"]` equals the exact Codex bytes above; no `agents/read-only-reviewer.toml`, no `agents/explorer.toml`; `skills/review/SKILL.md` present; warnings exactly (sorted) `agent "explorer" is not installed for codex: it has the name of a built-in Codex agent; skipped`, `agent "read-only-reviewer" is not installed for codex: Codex agent files cannot limit tools; skipped`. Also a description holding a tab and a newline round-trips as `\t`/`\n` escapes (pins `tomlString` use). And `codex.AgentPath("x") == "agents/x.toml"`.

GREEN: `toolconnector/codex/agent.go`:

```go
package codex

import toolconnectors "github.com/LeornaAI/leorna-client/toolconnector"

// agentsDir is relative to the Codex home ($CODEX_HOME): Codex reads one
// custom agent per .toml file in the agents folder beside config.toml.
const agentsDir = "agents/"

// AgentPath is the Codex-home-relative file Sync writes for an agent item.
func AgentPath(name string) string { return agentsDir + name + ".toml" }

// builtInAgents are Codex's own agents; a custom agent with one of these names
// takes precedence over it, so a pack agent must not take one.
var builtInAgents = map[string]bool{"default": true, "explorer": true, "worker": true}

// renderAgent writes an agent role file. Codex has no per-agent tool list, so
// an agent that limits its tools is skipped rather than widened.
func renderAgent(item toolconnectors.PackItem) (path string, content []byte, reason string) {
	agent, reason := toolconnectors.ParseAgent(item)
	if reason != "" {
		return "", nil, reason
	}
	if builtInAgents[agent.Name] {
		return "", nil, "it has the name of a built-in Codex agent"
	}
	if agent.Tools != "" {
		return "", nil, "Codex agent files cannot limit tools"
	}
	body := "name = " + tomlString(agent.Name) + "\n" +
		"description = " + tomlString(agent.Description) + "\n" +
		"developer_instructions = " + tomlString(agent.Instructions) + "\n"
	return AgentPath(agent.Name), []byte(body), ""
}
```

`config.go`: replace line 43 with `warnings := toolconnectors.SkippedPromptWarnings(pack, t.ID(), promptSkipReason)` (drop the `AgentWarnings` line and the following append), turn the `if item.Kind != PackKindSkill { continue }` loop into a `switch` with the existing skill case plus:

```go
		case toolconnectors.PackKindAgent:
			path, content, reason := renderAgent(item)
			if reason != "" {
				warnings = append(warnings, toolconnectors.SkippedAgentWarning(item.Name, t.ID(), reason))
				continue
			}
			files[path] = content
```

and `sort.Strings(warnings)` just before the final `return`. Update the `Transformer` comment. GREEN: `go test -mod=vendor ./toolconnector/codex -run TestCodexRendersAgentsAsAgentRoleFiles -count=1`, then the whole package (prompt skip test `TestCodexSkipsPromptsWithLoggedReason` must still pass: "agent…" sorts before "prompt…").

### T4. Cursor renders agents (`cursor/agent.go`, `config.go`)

RED: `toolconnector/cursor/agent_test.go`, `TestCursorRendersAgentsAsUserSubagents`: pack with `release-reviewer`, `read-only-reviewer`, `general-purpose` (body `"Plain."`), skill `review`, prompt `pr-description` (body `Write it.`). Assert `agents/release-reviewer.md` exact Cursor bytes, `agents/general-purpose.md` = `"---\nname: general-purpose\ndescription: Built-in clash\n---\n\nPlain.\n"` (Cursor documents no built-ins), no `agents/read-only-reviewer.md`, `skills/review/SKILL.md` and `commands/pr-description.md` present; a fourth agent `two-lines` (body `"Plain."`, description `"line one\nline two"`) writes no file; warnings exactly (sorted) `agent "read-only-reviewer" is not installed for cursor: Cursor agent files cannot limit tools; skipped`, `agent "two-lines" is not installed for cursor: Cursor agent descriptions must be one line; skipped`; `cursor.AgentPath("x") == "agents/x.md"`.

GREEN: `toolconnector/cursor/agent.go`:

```go
package cursor

import (
	"bytes"
	"strings"

	tc "github.com/LeornaAI/leorna-client/toolconnector"
)

// agentsDir is relative to the Cursor home (~/.cursor), so these are user
// subagents, like Cursor's skills and commands here.
const agentsDir = "agents/"

// AgentPath is the Cursor-home-relative file Sync writes for an agent item.
func AgentPath(name string) string { return agentsDir + name + ".md" }

// renderAgent writes a subagent file. Cursor has no per-agent tool list, so an
// agent that limits its tools is skipped rather than widened. Cursor's own
// frontmatter parser reads the rest of the line as the value and keeps
// quotes, so the description is written as one plain line.
func renderAgent(item tc.PackItem) (path string, content []byte, reason string) {
	agent, reason := tc.ParseAgent(item)
	if reason != "" {
		return "", nil, reason
	}
	if agent.Tools != "" {
		return "", nil, "Cursor agent files cannot limit tools"
	}
	if strings.ContainsAny(agent.Description, "\r\n") {
		return "", nil, "Cursor agent descriptions must be one line"
	}
	var out bytes.Buffer
	out.WriteString("---\nname: " + agent.Name + "\ndescription: " + agent.Description + "\n")
	out.WriteString("---\n\n" + agent.Instructions + "\n")
	return AgentPath(agent.Name), out.Bytes(), ""
}
```

`config.go`: `warnings := make([]string, 0)`; add the same `case tc.PackKindAgent:` block (with `t.ID()`); `sort.Strings(warnings)` before return (add `"sort"` import); update the comment. GREEN: package tests.

### T5. Cross-tool skip test; delete `AgentWarnings`

Replace `TestTransformersSkipAgentsWithDeterministicVisibleWarnings` in `toolconnector/agent_transform_test.go` with `TestTransformersSkipUnreadableAgentsWithOneSortedWarning`: pack = skill `review` + agent `zeta` (body `"---\nname: zeta\ndescription: Zeta\nmodel: opus\n---\nGo.\n"`) + agent `alpha` (body `"---\nname: alpha\n"`). For each of the three transformers: `err == nil`; the skill file is present; no file path contains `agents/`; warnings exactly `agent "alpha" is not installed for <id>: its frontmatter must open and close with --- lines and hold one "key: value" line per field; skipped` then `agent "zeta" is not installed for <id>: its frontmatter key "model" is not supported; skipped`. Keep `TestPackValidationAcceptsAgentAndStillRejectsUnknownKind`. Delete `AgentWarnings` and its comment from `transform.go` (`grep -rn AgentWarnings --include=*.go .` outside `vendor/` must print nothing). `go test -mod=vendor ./toolconnector/... -count=1` green. Commit T2–T5 as `feat(86bctmuwy): render agents for Claude Code, Codex and Cursor`.

### T6. Existing-file guard (`application/agent_guard.go`, `sync.go`)

RED: `application/agent_guard_test.go`, `TestGuardAgentFilesDecidesFromCurrentBytesAndBaseline`, with this fake (only `ID` and `CheckConfig` are called):

```go
type agentCheckConnector struct {
	tc.Connector // nil: the guard calls only ID and CheckConfig
	id     tc.ToolID
	states map[string]nativewrite.FileCheck
	err    error
	asked  map[string]string
}

func (c *agentCheckConnector) ID() tc.ToolID { return c.id }

func (c *agentCheckConnector) CheckConfig(_ context.Context, expected map[string]string) ([]nativewrite.FileCheck, error) {
	c.asked = expected
	if c.err != nil {
		return nil, c.err
	}
	var out []nativewrite.FileCheck
	for path, want := range expected {
		if check, ok := c.states[path]; ok {
			check.Path, check.Expected = path, want
			out = append(out, check)
		}
	}
	return out, nil
}
```

Cases, tool `cursor`, agents `a`…`h` all rendered into the bundle (bodies `"Go."`, description `"D"`) plus skill `review`; baseline `{agents/c.md: S_c, agents/d.md: S_d}`:
- a `FileMissing` → kept; b `FileMatch` → kept; c `FileModified`, `Actual == S_c` → kept; d `FileModified`, `Actual` ≠ `S_d` → dropped, warning `agents/d.md was changed after Leorna wrote it`, `held["agents/d.md"]`; e `FileModified`, not in baseline → dropped, `agents/e.md already exists and was not written by Leorna`, not held; f `FileUnreadable` → dropped, `agents/f.md could not be checked`; g no answer → dropped, `could not be checked`; h state `"other"` → dropped, `could not be checked`.
- `asked` holds exactly the eight agent paths with each content's SHA-256 (not the skill path).
- warnings sorted; `bundle.Executable` has no dropped path; the skill stays.
- a connector without `CheckConfig` (`struct{ tc.Connector; id }` with only `ID`) and a `CheckConfig` error both drop every agent with `… could not be checked`.
- a tool ID with no agent path (`"other-tool"`) leaves the bundle unchanged.

RED: compile error first (no `guardAgentFiles`), then add a stub returning `map[string]bool{}` so the assertions fail.

GREEN: `application/agent_guard.go`:

```go
package application

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sort"

	tc "github.com/LeornaAI/leorna-client/toolconnector"
	"github.com/LeornaAI/leorna-client/toolconnector/claudecode"
	"github.com/LeornaAI/leorna-client/toolconnector/codex"
	"github.com/LeornaAI/leorna-client/toolconnector/cursor"
	"github.com/LeornaAI/leorna-client/toolconnector/nativewrite"
)

// agentPaths gives the bundle-relative file each transformer writes for an
// agent item.
var agentPaths = map[tc.ToolID]func(string) string{
	claudecode.ID: claudecode.AgentPath,
	codex.ID:      codex.AgentPath,
	cursor.ID:     cursor.AgentPath,
}

// guardAgentFiles keeps Sync from replacing an agent file Leorna did not
// write. An agent's file is written only when its path is empty, already holds
// these bytes, or still holds exactly what the tool's baseline Sync wrote.
// Otherwise the agent leaves the bundle with one warning and the file stays as
// it is. It returns the baseline paths it left in place, which must not be
// removed either. It only reads; warnings name bundle-relative paths only.
func guardAgentFiles(ctx context.Context, connector tc.Connector, pack tc.Pack, bundle *tc.ConfigBundle, baseline map[string]string) map[string]bool {
	held := map[string]bool{}
	pathFor, known := agentPaths[connector.ID()]
	if !known {
		return held
	}
	expected := map[string]string{}
	names := map[string]string{}
	for _, item := range pack.Items {
		if item.Kind != tc.PackKindAgent {
			continue
		}
		path := pathFor(item.Name)
		content, planned := bundle.Files[path]
		if !planned {
			continue
		}
		sum := sha256.Sum256(content)
		expected[path] = hex.EncodeToString(sum[:])
		names[path] = item.Name
	}
	if len(expected) == 0 {
		return held
	}
	defer func() { sort.Strings(bundle.Warnings) }()
	skip := func(path, reason string) {
		delete(bundle.Files, path)
		delete(bundle.Executable, path)
		bundle.Warnings = append(bundle.Warnings, tc.SkippedAgentWarning(names[path], connector.ID(), reason))
		if _, recorded := baseline[path]; recorded {
			held[path] = true
		}
	}
	checker, ok := connector.(configChecker)
	var checks []nativewrite.FileCheck
	var err error
	if ok {
		checks, err = checker.CheckConfig(ctx, expected)
	}
	if !ok || err != nil {
		for path := range expected {
			skip(path, fmt.Sprintf("%s could not be checked", path))
		}
		return held
	}
	answers := make(map[string]nativewrite.FileCheck, len(checks))
	for _, check := range checks {
		answers[check.Path] = check
	}
	for path := range expected {
		check, answered := answers[path]
		recorded, inBaseline := baseline[path]
		switch {
		case !answered || check.State == nativewrite.FileUnreadable:
			skip(path, fmt.Sprintf("%s could not be checked", path))
		case check.State == nativewrite.FileMissing || check.State == nativewrite.FileMatch:
			// Nothing there yet, or exactly these bytes already.
		case check.State != nativewrite.FileModified:
			skip(path, fmt.Sprintf("%s could not be checked", path))
		case inBaseline && check.Actual == recorded:
			// Leorna's own file from the baseline Sync, unchanged since.
		case inBaseline:
			skip(path, fmt.Sprintf("%s was changed after Leorna wrote it", path))
		default:
			skip(path, fmt.Sprintf("%s already exists and was not written by Leorna", path))
		}
	}
	return held
}
```

`sync.go`: replace the baseline loop (lines 247-266) with:

```go
	for index := range plans {
		var baseline map[string]string
		for _, candidate := range baselines {
			if candidate.toolID != plans[index].connector.ID() || candidate.code != "" {
				continue
			}
			// A changed company, project or local target invalidates ownership
			// of old paths. Only a Sync after this selection can remove files.
			if candidate.startedAt.Before(selection.UpdatedAt) {
				continue
			}
			baseline = candidate.files
			break
		}
		held := guardAgentFiles(ctx, plans[index].connector, pack, &plans[index].bundle, baseline)
		if baseline == nil {
			continue
		}
		remove := make(map[string]string)
		for path, digest := range baseline {
			if _, retained := plans[index].bundle.Files[path]; !retained && !held[path] {
				remove[path] = digest
			}
		}
		plans[index].bundle.Remove = remove
	}
```

GREEN: `go test -mod=vendor ./application -run TestGuardAgentFilesDecidesFromCurrentBytesAndBaseline -count=1`, then `go test -mod=vendor ./application -count=1` (existing `TestSyncEnginePreflightsThenPersistsSuccessfulToolEvidence` keeps passing: its stub connectors can't be checked, so the `tester` agent is dropped with a warning that still names `agent "tester"`; `TestSyncEndToEndWithLoginMockTLSAndRealWriters` fails here as expected until T7). Commit `feat(86bctmuwy): never replace an agent file Leorna did not write`.

### T7. End-to-end over the TLS fixture: AC1–AC3

1. In `application/sync_prompt_e2e_test.go`, extract the body of `newPromptSyncFixture` into `newBundleSyncFixture(t *testing.T, packName string, items []bundleFixtureItem) bundleSyncFixture`, where `type bundleFixtureItem struct{ kind, name, description, body string }` and `type bundleSyncFixture` has the old fields; items are sorted by `kind + "/" + name` before building the manifest, lockfile and content (`verifiedPack` requires strictly increasing paths). `newPromptSyncFixture(t, name)` becomes `newBundleSyncFixture(t, "Prompts", []bundleFixtureItem{{"prompt", name, " Draft a PR: summary & tests ", "\nWrite it.\n\nUse $ARGUMENTS.\n\n"}, {"skill", "review", "Review", "Review."}})` and `type promptSyncFixture = bundleSyncFixture`. Keep the `LEORNA_PROMPT_EVIDENCE_DIR` behaviour for prompts; agents pass no evidence variable. The prompt tests must pass unchanged (run them before and after).
2. `application/sync_agent_e2e_test.go`: `newAgentSyncFixture(t)` = `newBundleSyncFixture(t, "Agents", {agent release-reviewer, agent read-only-reviewer, skill review})` with the canonical bodies. Three tests, each runs one confirmed Sync for all three tools (`SyncRequest{Mode: SyncConfirmed}`), requires `result.Status == SyncSuccess`, then for its own tool:
   - `TestSyncInstallsAgentForClaudeCodeProject`: `<project>/.claude/agents/release-reviewer.md` and `read-only-reviewer.md` equal the exact Claude bytes; both paths with their SHA-256 in that tool's `Files`; `Warnings` empty; `CheckSyncedFiles` → `FileCheckClean`; `t.Logf` each file's relative path and bytes (evidence).
   - `TestSyncInstallsAgentForCodexHome`: `<home>/.codex/agents/release-reviewer.toml` exact Codex bytes, in evidence; `Warnings == [agent "read-only-reviewer" … Codex agent files cannot limit tools; skipped]` (it names only the tools agent); nothing at `<home>/.agents/skills/release-reviewer`; Check files clean.
   - `TestSyncInstallsAgentForCursorHome`: `<home>/.cursor/agents/release-reviewer.md` exact Cursor bytes, in evidence; the only warning names `read-only-reviewer`; Check files clean.
   RED: these tests come after T2–T6 in build order, so prove their RED on the base instead: apply only this test file and the `newBundleSyncFixture` refactor to a clean `git archive` of `7a83443` and run them. They compile there (they call only existing APIs and the test helper) and fail on the missing agent files. Save `red-ac1-3-7a83443.txt`.
3. Update `TestSyncEndToEndWithLoginMockTLSAndRealWriters` (`sync_e2e_test.go:247-250`): each tool now has 4 files; the `tester` agent's file exists (`.claude/agents/tester.md`, `<codex home>/agents/tester.toml`, `<cursor home>/agents/tester.md`) and holds `Agent instructions`; no warning contains `agent "tester"`. Commit `test(86bctmuwy): prove agents land in each tool's folder end to end`.

### T8. Stub-source Sync tests with real writers: AC6–AC11 (`application/sync_agent_test.go`)

Helper (copy as is):

```go
type agentFixtureItem struct{ kind, name, description, body string }

// agentBundle serves items the way the control plane does: one manifest file,
// lockfile entry and content item per item, sorted by path, each with its
// body's SHA-256, bound to digest.
func agentBundle(digest string, items ...agentFixtureItem) (api.ClientBundle, api.ClientBundleContent) {
	sort.Slice(items, func(i, j int) bool { return items[i].kind+"/"+items[i].name < items[j].kind+"/"+items[j].name })
	var files []api.BundleFile
	var locks []api.LockfileEntry
	var content []api.BundleContentItem
	for _, item := range items {
		sum := sha256.Sum256([]byte(item.body))
		hash := hex.EncodeToString(sum[:])
		path := item.kind + "/" + item.name
		files = append(files, api.BundleFile{Path: path, Kind: api.BundleFileKind(item.kind), Name: item.name, Version: "1", Sha256: hash})
		locks = append(locks, api.LockfileEntry{Path: path, Sha256: hash})
		content = append(content, api.BundleContentItem{Path: path, Kind: api.BundleContentItemKind(item.kind), Name: item.name, Version: "1", Description: item.description, Body: item.body, Sha256: hash})
	}
	return api.ClientBundle{
			Status:   api.Assigned,
			Manifest: api.BundleManifest{PackName: "agents", PackVersion: "v1", Files: files},
			Lockfile: api.Lockfile{Algorithm: api.Sha256, Digest: digest, Files: locks},
		}, api.ClientBundleContent{PackName: "agents", PackVersion: "v1", BundleDigest: digest, Items: content}
}
```

Plus `agentProfile(t)` returning `root, profile, project` with `profile/.claude`, `profile/.codex`, `profile/.cursor` and `project` created, and `available.Registry(profile, profile+"/.claude", profile+"/.codex")`, and an app from `newSyncTestApplication(t)` whose selection is saved again with `project` (`app.SaveSyncSelection(ctx, "22222222-2222-4222-8222-222222222222", project)`), the same shape as `TestStartupSyncRealWritersStayInsideDisposableProfile`. Digests: `strings.Repeat("d", 64)` first, `"e"` second, `"f"` third. Paths: Claude `<project>/.claude/agents/<n>.md`, Codex `<profile>/.codex/agents/<n>.toml`, Cursor `<profile>/.cursor/agents/<n>.md`.

- **AC6 `TestSyncSkipsAgentsAToolCannotExpressWithVisibleReason`:** items: skill `review`; agents `read-only-reviewer` (tools), `explorer` (`"Plain."`, description `Explorer`), `general-purpose` (`"Plain."`, description `General`), `bad-model` (`"---\nname: bad-model\ndescription: Bad\nmodel: opus\n---\nGo.\n"`, description `Bad`). One confirmed Sync. Every tool `success`, run `success`. Warnings exactly (sorted):
  - claude-code: `agent "bad-model" … claude-code: its frontmatter key "model" is not supported; skipped`, `agent "general-purpose" … claude-code: it has the name of a built-in Claude Code agent; skipped`; files: `read-only-reviewer.md`, `explorer.md`.
  - codex: `bad-model` (key), `explorer` (`it has the name of a built-in Codex agent`), `read-only-reviewer` (`Codex agent files cannot limit tools`); files: `general-purpose.toml`.
  - cursor: `bad-model` (key), `read-only-reviewer` (`Cursor agent files cannot limit tools`); files: `explorer.md`, `general-purpose.md`.
  Skipped agents have no file on disk and no evidence entry; the skill installed everywhere. Close and reopen the app; `run_logs.files_json` for the run holds the same warnings per tool. `t.Log` the result JSON (`json.Marshal(result.Tools)`) for the AC6 UI capture.
- **AC7 `TestSyncKeepsAgentFileLeornaDidNotWrite`:** before the first Sync, write `"user's own agent\n"` with mode `0o644` at all three `release-reviewer` paths (create parent folders `0o755`), and at Cursor's `notes-writer` path write exactly the Cursor bytes Sync will render for `notes-writer` (body `"---\nname: notes-writer\ndescription: Writes notes\n---\n\nWrite notes.\n"`, description `Writes notes`). Sync 1 (digest d: skill `review`, agents `release-reviewer`, `notes-writer`): every tool success; each user file has the same bytes and mode, and `<path>.leorna.bak` does not exist; each tool's warnings are exactly `agent "release-reviewer" is not installed for <tool>: <rel path> already exists and was not written by Leorna; skipped` with rel path `.claude/agents/release-reviewer.md` / `agents/release-reviewer.toml` / `agents/release-reviewer.md`; `notes-writer` installed everywhere, Cursor's taken over with no warning and listed in evidence; the skill installed. Then edit Codex's `notes-writer.toml` (append `"# mine\n"`). Sync 2 (digest e, `notes-writer` instructions `Write short notes.`): Codex success with warning `agent "notes-writer" is not installed for codex: agents/notes-writer.toml was changed after Leorna wrote it; skipped`, the file keeps the edit, and no failure (the held path stayed out of `Remove`); Claude Code and Cursor now hold the new bytes. Sync 3 (same bundle as 2): Codex warning is now `… agents/notes-writer.toml already exists and was not written by Leorna; skipped`, file still unchanged.
- **AC8 `TestSyncUpdatesLeornaAgentFile`:** Sync 1 (digest d, `release-reviewer` canonical). Sync 2 (digest e, instructions `# Role\n\nReview the release and list blockers.`). Each tool: file = new rendered bytes; `<path>.leorna.bak` = Sync 1 bytes; evidence SHA = new bytes' SHA; no warnings about it; `CheckSyncedFiles` clean.
- **AC9 `TestSyncRemovesUnassignedAgentOnlyWhenUnchanged`:** subtest `unchanged`: Sync 1 (d: skill, `release-reviewer`, `notes-writer`); Sync 2 (e: skill, `notes-writer`): run success; all three `release-reviewer` files gone, each `<path>.leorna.bak` holds Sync 1 bytes, `notes-writer` and the skill untouched, no evidence entry for the removed path. Subtest `changed` (fresh profile/app): Sync 1 as above; append `"User note.\n"` to Cursor's `release-reviewer.md`; Sync 2: Cursor `failed` with `write_failed`, its `release-reviewer.md` holds the user's bytes and its other files are unchanged; Claude Code and Codex `success` with their files removed; run `partial`.
- **AC10 `TestStartupSyncInstallsAgentsOnlyForConfirmedTools`:** app from `newEnabledStartupTestApplication(t)` with the project selection; bundle d: skill only. `NewStartupSync(...).CheckOnce` before any manual Sync → no `agents` folder exists under any root (log the state). Confirmed manual Sync with `Tools: []tc.ToolID{"cursor"}` → success. Change the source to digest e with skill + `release-reviewer`. `CheckOnce` → state `updated`; Cursor's `release-reviewer.md` = exact bytes; `<profile>/.codex/agents` and `<project>/.claude/agents` don't exist.
- **AC11 `TestAgentSyncTouchesNoRealHome`:** `decoy := t.TempDir()`; `t.Setenv` each of `HOME`, `USERPROFILE`, `CODEX_HOME`, `CLAUDE_CONFIG_DIR`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME` to `filepath.Join(decoy, <name>)` (not created). Build the profile and registry from explicit paths as above; one confirmed Sync for all three tools with skill `review` + `release-reviewer`. Then: `os.ReadDir(decoy)` is empty; walking the test root finds exactly the expected files (the three skill `SKILL.md` files, the three agent files and the app database files, matched by relative path; list the database names the walk finds once and pin them). Never `t.Parallel()` (Setenv).

Order: write each test, run it on the T6 head; AC6–AC9 and AC11 should pass there (T2–T6 already build the behaviour), so prove each one's RED with the matching mutant in T10 instead (a test that starts green must show it can fail). Commit `test(86bctmuwy): skip, keep, update, remove and isolate agent files`.

### T9. Real-tool tests: AC4, AC5

- `toolconnector/claudecode/agent_real_test.go`, **`TestClaudeLoadsSyncedAgent`**: skip unless `LEORNA_TEST_CLAUDE_BIN`. Reuse `fakeMessages` (`handoff_real_test.go:22`) and `runClaude` (`config_test.go:212`) with the env list `prompt_real_test.go:29` uses. `home, project := t.TempDir(), t.TempDir()`; connector `claudecode.New(filepath.Join(home, ".claude")).ForProject(project)`. Apply bundle v1 (agent `leorna-agent-check`, description `LEORNA-AGENT-V1 old description`, body `"---\nname: leorna-agent-check\ndescription: LEORNA-AGENT-V1 old description\ntools: Read, Grep\n---\n\nLEORNA-AGENT-BODY reply OK.\n"`), then v2 (description `LEORNA-AGENT-V2 Checks agent install.`), both through `Transformer{}.Transform` + `ApplyConfig`, so `.claude/agents/leorna-agent-check.md.leorna.bak` exists (assert it). Claude starts only after both writes, so the new-folder restart rule doesn't apply. Run `-p "LEORNA-AGENT-PROBE reply OK" --output-format stream-json --verbose --setting-sources project --strict-mcp-config`. Assert: the `system`/`init` line's `agents` contains `leorna-agent-check` exactly once; a request body contains `- leorna-agent-check: LEORNA-AGENT-V2 Checks agent install. (Tools: Read, Grep)`; no request contains `LEORNA-AGENT-V1`. Log the Claude version.
- `toolconnector/codex/agent_real_test.go`, **`TestCodexListsSyncedAgentRole`**: skip unless `LEORNA_TEST_CODEX_BIN`. `home, project := t.TempDir(), t.TempDir()`; `&codex.Connector{Home: home, UserHome: home}`; apply v1 then v2 of `leorna-agent-check` with no tools line (descriptions as above); assert `agents/leorna-agent-check.toml.leorna.bak` exists. `out := runCodex(t, binary, home, project, nil, "debug", "prompt-input", "LEORNA-AGENT-PROBE")` (`resume_test.go:201`; its env sets `HOME` and `CODEX_HOME` to `home` and blocks the network). Assert `strings.Count(out, "leorna-agent-check: {") == 1`, `out` contains `LEORNA-AGENT-V2 Checks agent install.`, and not `LEORNA-AGENT-V1`. Log the Codex version.
- RED: these tests use only existing APIs (`Transform`, `ApplyConfig`), so apply just the two test files to a `git archive` of `7a83443` and run them with the env variables: the base transformers write no agent file, so the `.leorna.bak` and `init`/prompt assertions fail. Save `red-ac4-5-7a83443.txt`. Mutant M12 (T10) repeats the proof on the head. Commit `test(86bctmuwy): real Claude Code and Codex load the synced agent`.

### T10. Mutation receipts (`mutation-testing-discipline`)

Run each mutant under the memory cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 go test -mod=vendor <pkg> -run '<test>' -count=1`. Apply each mutation with `go test -overlay` or a scratch copy, never by editing the worktree file in place without restoring; each must turn its test red; record `mutations-<sha7>.txt` (mutant id, file:line, test, result).

| Id | Mutation | Must fail |
|---|---|---|
| M1 | guard: `default:` branch keeps the file (no skip) | AC7 |
| M2 | guard: drop `&& !held[path]` in `sync.go` | AC7 (Sync 2 Codex fails `write_failed`) |
| M3 | guard: `FileMissing` treated as foreign | AC1, AC2, AC3 |
| M4 | guard: `FileMatch` treated as foreign | AC7 (take-over case) |
| M5 | guard: `case inBaseline && check.Actual == recorded` becomes `case inBaseline` | AC7 (Sync 2) |
| M6 | guard: unreadable/unknown state kept | T6 test |
| M7 | Codex: tools check removed | AC6 |
| M8 | Cursor: tools check removed | AC6 |
| M9 | Claude: built-in check removed | AC6 |
| M10 | Codex: built-in check removed | AC6 |
| M11 | Claude: description written unquoted | T2 test and AC1 |
| M12 | Claude/Codex renderers return no file | AC4 / AC5 (real binaries) |
| M13 | `guardAgentFiles` call removed from `sync.go` | AC7 |
| M14 | Cursor transformer writes into `.cursor/agents/` (wrong root) | AC3, AC11 |
| M15 | (Revision 1) Cursor renderer writes the description JSON-quoted again | AC12, T4 test |
| M16 | (Revision 1) Cursor renderer returns no file | AC12 (real Cursor CLI) |

Also run AC6–AC9/AC11 on the base export with the new test file plus copied helper to record that they fail there (they need `newBundleSyncFixture`/`agentBundle`, which are test helpers, so they compile; the assertions fail because no agent files are written). Save `red-base-7a83443.txt`.

### T11. Docs

- `README.md` ~406: replace "Published `agent` items are retained and reported as warnings but are not installed until each tool's native agent layout is defined." with: agents install as `<project>/.claude/agents/<name>.md`, `$CODEX_HOME/agents/<name>.toml` and `~/.cursor/agents/<name>.md`; an agent a tool can't express is skipped with a persisted warning; Sync never replaces a file Leorna didn't write; Claude Code needs a restart the first time it gets an `agents` folder.
- `application/README.md`: replace "Agent items remain in the verified source pack but are skipped by all three transformers with visible, persisted warnings." with the existing-file rule (empty, identical, or the baseline's unchanged bytes; otherwise skipped with a warning and kept out of removal), naming `TestSyncKeepsAgentFileLeornaDidNotWrite`.
- `PROJECT_MEMORY.md:36`: "Agent items are installed for all three tools (86bctmuwy) …".
- `toolconnector/claudecode/README.md`, `codex/README.md`, `cursor/README.md`: add an `agent` row to each kind table with the path, fields and skip reasons; a short "Agent files (86bctmuwy)" note with the doc URL, date checked, the probed versions (Claude Code 2.1.319, Codex 0.165.0) and the test names.
Commit `docs(86bctmuwy): document agent installation`.

### T12. Gates, evidence, hand-off

Run the Gates on the final head; save `gates-<sha7>.txt`; take the AC captures (next section); stop at `ready-for-review` and report branch, head SHA, base SHA, diff stat (`git diff --stat origin/main...HEAD`), `git diff --name-only origin/main...HEAD | grep '^.github/'` (must be empty), gate results, real-tool results, mutation table and evidence inventory. No push.

## Tests per AC (one each) and failure cases

| AC | Test | Package | Failure cases inside |
|---|---|---|---|
| AC1 | TestSyncInstallsAgentForClaudeCodeProject | application (TLS e2e) | tools line kept |
| AC2 | TestSyncInstallsAgentForCodexHome | application (TLS e2e) | tools agent skipped |
| AC3 | TestSyncInstallsAgentForCursorHome | application (TLS e2e) | tools agent skipped |
| AC4 | TestClaudeLoadsSyncedAgent | toolconnector/claudecode (real, env-gated) | update + `.leorna.bak` ignored |
| AC5 | TestCodexListsSyncedAgentRole | toolconnector/codex (real, env-gated) | update + `.leorna.bak` ignored |
| AC6 | TestSyncSkipsAgentsAToolCannotExpressWithVisibleReason | application | unsupported tool format, built-in name, unknown key; persisted after reopen |
| AC7 | TestSyncKeepsAgentFileLeornaDidNotWrite | application | collision with a user file, user-edited Leorna file, identical take-over, stable on rerun |
| AC8 | TestSyncUpdatesLeornaAgentFile | application | update + backup + Check files |
| AC9 | TestSyncRemovesUnassignedAgentOnlyWhenUnchanged | application | removal, edited file kept, partial run |
| AC10 | TestStartupSyncInstallsAgentsOnlyForConfirmedTools | application | approvals/enrollment |
| AC11 | TestAgentSyncTouchesNoRealHome | application | isolation |
| AC12 | TestCursorLoadsSyncedAgentFormat | toolconnector/cursor (real, env-gated `LEORNA_TEST_CURSOR_BIN`) | update + `.leorna.bak` ignored; no added quotes |
| AC13 (live) | TestCursorEditorShowsSyncedAgentLive (Justin's editor check, no Go test) | — | owed to Justin |

Supporting: TestParseAgentReadsBuilderFrontmatterAndPlainBodies, TestParseAgentRefusesBodiesToolsCannotRead, TestClaudeCodeRendersAgentsAsProjectSubagents, TestCodexRendersAgentsAsAgentRoleFiles, TestCursorRendersAgentsAsUserSubagents, TestTransformersSkipUnreadableAgentsWithOneSortedWarning, TestGuardAgentFilesDecidesFromCurrentBytesAndBaseline.

Every test uses `t.TempDir()` roots and explicit registry paths; the real-tool tests set `HOME`/`CLAUDE_CONFIG_DIR`/`CODEX_HOME` for the child process to temp folders. No test reads or writes the real `~/.claude`, `~/.codex` or `~/.cursor`.

## Gates (exact, WSL desktop)

```sh
cd ~/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install
export PATH=$HOME/.local/leorna-toolchain/bin:$HOME/.local/leorna-toolchain/go/bin:$PATH
export TMPDIR=$(cd ~/.cache/86bctmuwy-builder/tmp && pwd -P)   # real disk, not a symlink, not /tmp
golangci-lint --version; govulncheck -version; go version
make check;                         echo "make check EXIT=$?"
node --test scripts/*-ui.test.cjs;  echo "ui EXIT=$?"
make lint audit;                    echo "lint audit EXIT=$?"
# real tools (agent-run; skip in CI):
LEORNA_TEST_CLAUDE_BIN=/home/justin/.local/share/claude/versions/2.1.319 go test -mod=vendor ./toolconnector/claudecode -run '^TestClaudeLoadsSyncedAgent$' -count=1 -v; echo "AC4 EXIT=$?"
LEORNA_TEST_CODEX_BIN=$(command -v codex) go test -mod=vendor ./toolconnector/codex -run '^TestCodexListsSyncedAgentRole$' -count=1 -v; echo "AC5 EXIT=$?"
LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent go test -mod=vendor ./toolconnector/cursor -run '^TestCursorLoadsSyncedAgentFormat$' -count=1 -v; echo "AC12 EXIT=$?"   # Revision 1
```

`codex` is `/home/justin/.nvm/versions/node/v22.23.4/bin/codex` (0.165.0); its Node launcher needs the caller's `PATH`, which `codexEnv` passes. A command that dies with SIGTERM/143/137/"Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. `GOOS=windows go vet` is not a gate here (Cursor SQLite adapter needs cgo); CI's Windows job runs `./toolconnector/...`.

## Evidence capture (named build task; folder `~/.hermes/plans/leorna/evidence/86bctmuwy/`, builder files in `builder/`)

Capture as each check runs, never reconstructed later. One PNG per AC plus its log. This is the WSL desktop: the macOS Terminal recipe doesn't apply. Method (from `feature-dispatch/references/ac-verification.md`): run the command with a `$ <command>` header line and an `EXIT=<rc>` footer into `acN-<sha7>.log`; render the log into a `<pre>` HTML page (escape `& < >`); screenshot it with Chrome for Testing: `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu ~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --disable-software-rasterizer --user-data-dir=$HOME/.cache/86bctmuwy-builder/chrome --screenshot=<png> --window-size=1400,<h> file://<html>`, with `<h>` from a `--dump-dom` pass whose inline script sets `data-h` from `document.body.getBoundingClientRect().height` (≥400). Check the PNG magic `89504e47`, view it in bands ≤1,300 px, confirm the `EXIT=` line is on screen, and grep the log for emails, URLs, tokens and absolute home paths before it leaves the machine (redact `/home/justin` paths to `~` on the rendered page only).

| AC | What the image shows | When | File |
|---|---|---|---|
| before | base: every tool skips every agent | T0 | `before-agents-skipped.png` |
| AC1 | `go test -v -run '^TestSyncInstallsAgentForClaudeCodeProject$'` PASS with the logged file bytes | T7 green | `ac1-claude-agent-files.png` |
| AC2 | same for Codex (TOML bytes) | T7 | `ac2-codex-agent-file.png` |
| AC3 | same for Cursor | T7 | `ac3-cursor-agent-file.png` |
| AC4 | real Claude Code run: version line, init `agents`, the request line with the V2 description | T9 | `ac4-claude-real-load.png` |
| AC5 | real Codex run: version, the `leorna-agent-check: {` role block | T9 | `ac5-codex-real-load.png` |
| AC6 | the AC6 run's real result JSON rendered by the shipped `sync.js` in headless Chrome (scratch harness page: `dist/style.css` + the Sync section markup from `dist/index.html` + a stub `window.go.desktop.Bridge` whose `SyncTools` returns that JSON; driven with chromedp v0.16.0 from the Go module cache in a scratch module outside the repo), labelled "local rendering of a real test result, not the app window"; plus `ac6-skip-test.png` (terminal) | T8 | `ac6-sync-panel-warnings.png`, `ac6-skip-test.png` |
| AC7 | test PASS with logged before/after bytes and the warnings | T8 | `ac7-user-file-kept.png` |
| AC8 | test PASS, new bytes + `.leorna.bak` bytes | T8 | `ac8-agent-updated.png` |
| AC9 | both subtests PASS (removed, kept + `write_failed`) | T8 | `ac9-agent-removal.png` |
| AC10 | test PASS (Cursor only) | T8 | `ac10-startup-enrolled-only.png` |
| AC11 | test PASS, plus a before/after fingerprint of the real folders (`for d in ~/.claude/agents ~/.codex/agents ~/.cursor/agents; do [ -e "$d" ] && find "$d" -printf '%P %s %T@\n' \| sort \|\| echo "$d absent"; done \| sha256sum`, read-only) taken around the full gate run; note Justin's own tools can change them | T12 | `ac11-isolation.png` |
| gates | the three gates + real-tool runs with `EXIT=` lines | T12 | `gates-<sha7>.png` + `gates-<sha7>.txt` |
| AC12 | real Cursor CLI run: version line, the decoded request-context entry for `leorna-agent-check` (path, name, V2 description, instructions), the `.leorna.bak` count 0 | T9b | `ac12-cursor-real-load.png` |
| AC13 (live) | Justin's screenshot of the Cursor editor's subagent list showing the synced agent (owed to Justin) | after review | `ac13-cursor-editor-agent.png` |
| mutants | table of M1–M16 results | T10 | `mutations-<sha7>.png` + `.txt` |

If the AC6 harness can't be made to work within 20 minutes, use the terminal capture plus a `sqlite3`-free Go snippet in the test log showing `run_logs.files_json` warnings, and say so in the inventory; never stage a fake UI image.

## Choices, assumptions, risks, follow-ups

**Choices** (beyond the ⭐ answers): Claude Code agents are project-scoped like every other Claude Code item (not `~/.claude/agents`). Item name/description win over the body's frontmatter (the control plane keeps them equal). A user file already holding exactly the rendered bytes is taken over (otherwise a project or company switch would block Leorna's own files forever). Warnings name bundle-relative paths only.

**Assumptions:** (1) Codex's user agents folder is `$CODEX_HOME/agents` (docs say `~/.codex/agents`; source and the 0.165 probe confirm the config folder). (2) Cursor accepts names with digits (docs say "lowercase letters and hyphens"; Leorna's slug rule allows digits, as Cursor skills and commands already do). (3) No control-plane change: OpenAPI already carries agents. (4) The four shipped library agents parse and install everywhere (only `name`/`description`).

**Risks:**
- Cursor also reads `.claude/agents/` (project) and `~/.claude/agents/`, `~/.codex/agents/` (user); in a project Synced for Claude Code, Cursor may use the Claude copy (project wins), including an agent Leorna skipped for Cursor because of `tools`, without the limit. Leorna can't prevent that without dropping Claude Code installs; documented in the Cursor README.
- Claude Code watches only `agents` folders that existed when the session started: the first Sync that creates `.claude/agents/` needs a Claude Code restart (docs); Codex's live pickup is undocumented (restart).
- Built-in agent lists may change between tool versions (pinned with the probed versions in comments and READMEs).
- After a project or company switch, Leorna's earlier agent files no longer count as Leorna's (existing ownership rule); unless bytes match, they're skipped with a warning until the user removes them. Conservative by design.
- `.claude/agents/*.md` and `*.leorna.bak` show up in the user's project git status, as Leorna's skills and commands already do.
- An existing removal conflict (Q4 a) stops that tool's whole update until the user resolves the edited file, as for skills today.

**Follow-ups (not in this story):**
- F1 Control plane: copy this client change into `internal/library/render` (it is a byte copy of the client transformers at `f105e27`), list the three tools in `agentInstallingTools`, and update "the desktop client does not install agents yet" (`render/render.go:105-115`, `metric/content_usage.go:33-39`, curation notes).
- F2 Apply the same "never replace a file Leorna didn't write" guard to skills, prompts and MCP/settings files (repo-wide pattern; today `nativewrite` replaces such files and keeps `.leorna.bak`).
- F3 Usage attribution for agents (`usage/`, `application/managed_items.go`, control-plane content usage).
- F4 Real Cursor load check (Q6 a), once a Cursor CLI or Justin's Cursor is available.
- F5 `toolconnector.Connector`: **no change needed** for this story; recorded so nobody adds one.
- F6 Optional: map an agent's `tools` to Cursor `readonly` or Codex `features.*` instead of skipping, if Justin wants it later.

## Skills

- Planner (done): `leorna`, `engineering-best-practices`, `implementation-planning`.
- Builder: `leorna`, `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the existing-file guard is a data-integrity guard).
- Reviewers: `leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices` (YAML/TOML injection through descriptions/tools, path safety, symlinks).
- Fixers/finisher: `leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `git-commit-rules`.
- Considered, not used: `authorized-write-safety` (it targets external API writes and publishers; these are local writes already guarded by `nativewrite` plus this guard).
- None of these SKILL.md files has a `## Mandatory Validation and Agent Defect Loop` section (checked 2026-11-07).
- Every role: keep scratch in its own `~/.cache/86bctmuwy-<role>/` (real disk), never `/tmp` for TMPDIR, Chrome profiles or binaries; report `skill_lessons`.

## Docs & records (every file the build and finish update)

- Repo: `README.md`, `application/README.md`, `PROJECT_MEMORY.md`, `toolconnector/claudecode/README.md`, `toolconnector/codex/README.md`, `toolconnector/cursor/README.md` (T11).
- Plan: this file; on "go" the orchestrator installs `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md` (read-only copy) and records Justin's answers at the top of this file.
- Briefs: `~/.hermes/plans/leorna/briefs/86bctmuwy-agent-items-install-<role>.md`.
- Evidence: `~/.hermes/plans/leorna/evidence/86bctmuwy/` (`builder/`, `review-<n>/review.json`, `verifier/ac.json`, `auditor/ac.json`, `follow-ups.md`, `finisher/`).
- Finisher drafts (desktop has no `~/.hermes/cache/scratch`): `evidence/86bctmuwy/finisher/pr.md` (body only; title `feat(86bctmuwy): install Agent items into Claude Code, Codex and Cursor`), `review-prompt.md`, `clickup-evidence.md` (AC → test → result table, image list), `team-message.md`.
- Memory (main session saves): `leorna-workflow.md` dated status lines (plan, go, build, reviews, hand-over); the planner's skill lessons below for `codex-cli-offline-checks.md` / `claude-code-headless-agent-runs.md`.
- Follow-up text for F1–F6 in `evidence/86bctmuwy/follow-ups.md`.

## Other things found

1. Medium: `nativewrite` replaces a pre-existing file Leorna never wrote at a skill, prompt or config path and keeps it only as `.leorna.bak` (`toolconnector/nativewrite/README.md`: "On success, the new file replaces the destination…"; `application/sync.go:247-266` has no existence check). That contradicts the "never overwrite a file Leorna didn't write" rule this story adds for agents → F2.
2. Low: the shared main checkout `~/Leorna/leorna-client` is 28 commits behind GitHub main (`f105e27` vs `7a83443`); T0 fast-forwards it.
3. Low/medium (product, after merge): the control plane will keep telling admins agents aren't installed (`render/render.go:105-115`, `metric/content_usage.go:33-39`) until F1.
4. Low: the Codex config reference page lists no `agents/` folder or `CODEX_HOME` rule for it; only the subagents page and source do (recorded in the research table).

## Revision 1 (2026-11-07 ~21:05 EST, after "go"): AC12 real-Cursor check — APPLIED

**Status: APPLIED (2026-11-07).** Justin answered 7a and 8a and approved AC12 and AC13 (live). The Q8 a amendments below are already merged into the main sections (AC3, Approach item 2, reasons table, rendered bytes, T4 and its `renderAgent`), so build from the main sections; this section stays as the record of the probe, the T9b task and its test code.

### What the probe proved (planner, throwaway `HOME`/`XDG_CONFIG_HOME`/`CURSOR_CONFIG_DIR` under `~/.cache/86bctmuwy-planner-r1`, removed afterwards; the real `~/.cursor` still doesn't exist)

Binary: `~/.local/bin/cursor-agent` → `~/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent` (a Node bundle; the JS is readable).

1. **No sign-in is needed, but no listing command exists.** `cursor-agent status` → `Not logged in`. `-p` needs an API key and the Cursor API. With `--api-key leorna-offline-fixture -e http://127.0.0.1:<port>`, the CLI talks to a local fake instead:
   - `POST /auth/exchange_user_api_key` must return JSON `{"accessToken": <JWT-shaped string>}`. The CLI only checks it's a non-empty string (`index.js`, `loginWithApiKey`).
   - Then unary Connect calls arrive with `application/proto` bodies: `aiserver.v1.DashboardService/*`, `ServerConfigService/GetServerConfig`, `AiService/GetUsableModels`, `AiService/GetDefaultModelForCli` and `AiService/AvailableModels`. An empty 200 body answers each one. The two model calls need one `ModelDetails{1 model_id, 3 display_model_id, 4 display_name}`, or the CLI stops with "No model found".
   - With `--model gpt-5`, stream-json prints `{"type":"system","subtype":"init",…,"model":"GPT-5"}`. It then opens `agent.v1.AgentService/RunSSE` (`application/connect+proto`) and sends the prompt through `aiserver.v1.BidiService/BidiAppend`, hex-encoded in field 1 or gzipped.
   - The scratch `cli-config.json` needs `"network":{"useHttp1ForAgent":true}` so a plain-HTTP fake works.
2. **The CLI sends its agent list only when the server asks.** The fake streams one `AgentServerMessage{2: ExecServerMessage{1 id=1, 15 exec_id="e1", 10 request_context_args={}}}`. The bytes are `12 08 08 01 7a 02 65 31 52 00`, framed `00 <u32 len>`. The CLI answers in `BidiAppend` with its `RequestContext`, whose field `22 custom_subagents` holds each agent's path, name, description, model, prompt and source. The field numbers come from the bundle's descriptors: `AgentServerMessage|1 interaction_update…|2 exec_server_message`, `ExecServerMessage|1 id 13|15 exec_id 9|…|10 request_context_args`, `RequestContext|…|22 custom_subagents`.
3. **Folders it reads (CLI 2026.11.05):** only the workspace's `.cursor/agents/`, `.claude/agents/` (source `claude`, on by default) and `.grok/agents/`, plus plugins.
   - In the decoded request context, `probe-project-agent` (in `<project>/.cursor/agents/`) appeared, and `probe-claude-agent` (in `<project>/.claude/agents/`) appeared.
   - `probe-home-agent` (in `$HOME/.cursor/agents/`) appeared **0 times**, and so did `probe-cfg-agent` (in `$CURSOR_CONFIG_DIR/agents/`).
   - The source matches: `computeAgentsDirs()` joins only `workspacePath` with `.cursor/agents`, `.claude/agents` and `.grok/agents`, and every `new VzO(...)` in `6136.index.js`, `8493.index.js` and `8952.index.js` is built from workspace paths. **So the Cursor CLI does not read `~/.cursor/agents`, which is where AC3 installs** (Cursor's docs say user agents work in "editor, CLI and Cloud Agents"; this CLI build doesn't).
4. **`*.md.leorna.bak` is ignored.** The file filter is `.md`/`.mdc`/`.markdown` (`function xo`), and `probe-proj-backup.md.leorna.bak` in `<project>/.cursor/agents/` appeared 0 times.
5. **Cursor's frontmatter parser is line-based and keeps quotes** (`function Io`: per line, key = text before the first `:`, lowercased; value = the rest, trimmed; no unquoting; `tools` is split on commas).
   - A JSON-quoted `description: "PROBE-PROJECT-DESC reviews code"` reached the request with its quotes.
   - A plain `description: PROBE-PLAIN-DESC reviews code` arrived clean.
   - The Claude file's `tools: "Read, Grep"` became the two tools `"Read` and `Grep"`.
   - So the approved Cursor bytes (JSON-quoted description) would show quotes and backslashes in Cursor. Also, Claude Code agent files Leorna writes into a project reach Cursor with broken tool names.

### New questions (also listed at the top)

- **Q7** Cursor CLI never reads `~/.cursor/agents`:
  - **a ⭐** keep the approved `~/.cursor/agents`, which Cursor's docs say the editor reads. AC12 proves the exact Cursor file is loaded and parsed right by the real CLI, from a workspace folder. AC13 `(live)` is Justin's check that the editor shows it.
  - **b** also install Cursor agents into the selected project's `.cursor/agents/`. Both CLI and editor would read that, but the Cursor connector would need the project folder (like Claude Code's `ForProject`) and Sync's Cursor preflight would change. That's a re-plan.
  - Why a: it keeps the approved design and scope, it's the documented editor location, and it proves everything an agent can prove. b changes Cursor's scope and the Sync flow.
- **Q8** Cursor keeps quotes:
  - **a ⭐** Cursor's renderer writes `description:` as one plain line, and skips an agent whose description has a line break (reason `Cursor agent descriptions must be one line`).
  - **b** keep JSON quotes (AC12's "without added quotes" would then be dropped).
  - Why a: Cursor's own parser reads the rest of the line as the value, so a plain line round-trips exactly (proven above), and `: ` inside it is fine for that parser.

### Amendments for Q8 a (applied to the main sections 2026-11-07; kept as a record)

- **AC3:** replace "(name, JSON-quoted description, instructions)" with "(name, description as one plain line, instructions)".
- **Approach item 2:** "Claude Code and Cursor write Markdown with JSON-quoted values" becomes "Claude Code writes Markdown with JSON-quoted values; Cursor writes the description as one plain line, because Cursor's line parser keeps quotes".
- **Reasons table:** add the row `| Cursor description | Cursor agent descriptions must be one line |`.
- **Rendered bytes (Cursor) and T4:** `release-reviewer.md` = `"---\nname: release-reviewer\ndescription: Reviews a release: risks & \"blockers\"\n---\n\n# Role\n\nReview the release.\n"`. `general-purpose.md` = `"---\nname: general-purpose\ndescription: Built-in clash\n---\n\nPlain.\n"`. T4 adds a case where the description holds `"line one\nline two"`: no file, and the warning `agent "<name>" is not installed for cursor: Cursor agent descriptions must be one line; skipped`.
- **`cursor/agent.go` `renderAgent`:** after the tools check, add the following. In the output, replace `out.Write(tc.QuoteYAMLLine(agent.Description))` with `out.WriteString(agent.Description + "\n")`.

  ```go
  	if strings.ContainsAny(agent.Description, "\r\n") {
  		return "", nil, "Cursor agent descriptions must be one line"
  	}
  ```
  (import `strings`).
- AC1, AC2 and Claude Code's renderer are unchanged.

### Task T9b (after T9): real Cursor CLI, AC12

`toolconnector/cursor/agent_real_test.go`. It's env-gated like AC4/AC5: it skips unless `LEORNA_TEST_CURSOR_BIN` is set, so CI skips it. Everything lives under `t.TempDir()`, and the child process gets `HOME`, `XDG_CONFIG_HOME`, `CURSOR_CONFIG_DIR`, `CURSOR_DATA_DIR` and `TMPDIR` all inside it.

```go
package cursor_test

import (
	"bytes"
	"compress/gzip"
	"context"
	"encoding/base64"
	"encoding/binary"
	"encoding/hex"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
	"sync"
	"testing"
	"time"

	tc "github.com/LeornaAI/leorna-client/toolconnector"
	"github.com/LeornaAI/leorna-client/toolconnector/cursor"
)

// fakeCursorAPI answers the Cursor CLI's private API just far enough for it
// to send its request context: an API-key exchange, empty unary replies, one
// model, and a RunSSE stream that asks for the request context once. The
// message and field numbers come from the protobuf descriptors bundled in
// cursor-agent 2026.11.05-86047df; a newer CLI may need them updated.
type fakeCursorAPI struct {
	mu       sync.Mutex
	payloads [][]byte
	got      chan struct{}
	once     sync.Once
}

var hexRun = regexp.MustCompile(`[0-9a-f]{40,}`)

func (f *fakeCursorAPI) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	if len(body) > 1 && body[0] == 0x1f && body[1] == 0x8b {
		if zr, err := gzip.NewReader(bytes.NewReader(body)); err == nil {
			if plain, err := io.ReadAll(zr); err == nil {
				body = plain
			}
		}
	}
	contentType := r.Header.Get("Content-Type")
	switch {
	case strings.HasSuffix(r.URL.Path, "/auth/exchange_user_api_key"):
		token := fakeJWT()
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]string{"accessToken": token, "refreshToken": token})
	case strings.HasSuffix(r.URL.Path, "/agent.v1.AgentService/RunSSE"):
		w.Header().Set("Content-Type", "application/connect+proto")
		// AgentServerMessage{2 exec_server_message: ExecServerMessage{1 id: 1, 15 exec_id: "e1", 10 request_context_args: {}}}
		exec := []byte{0x08, 0x01, 0x7a, 0x02, 'e', '1', 0x52, 0x00}
		writeFrame(w, 0x00, protoField(2, exec))
		w.(http.Flusher).Flush()
		select {
		case <-f.got:
		case <-time.After(15 * time.Second):
		case <-r.Context().Done():
		}
		writeFrame(w, 0x02, []byte("{}"))
	case strings.HasSuffix(r.URL.Path, "/aiserver.v1.BidiService/BidiAppend"):
		f.record(body)
		w.Header().Set("Content-Type", "application/proto")
	case contentType == "application/proto":
		w.Header().Set("Content-Type", "application/proto")
		if strings.HasSuffix(r.URL.Path, "/GetUsableModels") || strings.HasSuffix(r.URL.Path, "/GetDefaultModelForCli") {
			// {1 models|model: ModelDetails{1 model_id, 3 display_model_id, 4 display_name}}
			model := append(append(protoField(1, []byte("gpt-5")), protoField(3, []byte("gpt-5"))...), protoField(4, []byte("GPT-5"))...)
			_, _ = w.Write(protoField(1, model))
		}
	case strings.Contains(contentType, "json"):
		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte("{}"))
	default:
		http.NotFound(w, r)
	}
}

// record keeps a BidiAppend body plus every hex run in it decoded, because
// the CLI sends its client messages hex-encoded in field 1.
func (f *fakeCursorAPI) record(body []byte) {
	decoded := append([]byte(nil), body...)
	for _, run := range hexRun.FindAll(body, -1) {
		if raw, err := hex.DecodeString(string(run)); err == nil {
			decoded = append(decoded, raw...)
		}
	}
	f.mu.Lock()
	f.payloads = append(f.payloads, decoded)
	f.mu.Unlock()
	if bytes.Contains(decoded, []byte("/.cursor/agents/")) {
		f.once.Do(func() { close(f.got) })
	}
}

// requestContext returns the first client message that names a workspace
// .cursor/agents file, which is the CLI's request-context answer.
func (f *fakeCursorAPI) requestContext() []byte {
	f.mu.Lock()
	defer f.mu.Unlock()
	for _, payload := range f.payloads {
		if bytes.Contains(payload, []byte("/.cursor/agents/")) {
			return payload
		}
	}
	return nil
}

func protoField(number int, value []byte) []byte {
	out := binary.AppendUvarint([]byte{byte(number<<3 | 2)}, uint64(len(value)))
	return append(out, value...)
}

func writeFrame(w io.Writer, flags byte, message []byte) {
	header := make([]byte, 5)
	header[0] = flags
	binary.BigEndian.PutUint32(header[1:], uint32(len(message)))
	_, _ = w.Write(append(header, message...))
}

func fakeJWT() string {
	part := func(v any) string { b, _ := json.Marshal(v); return base64.RawURLEncoding.EncodeToString(b) }
	now := time.Now()
	return part(map[string]string{"alg": "HS256", "typ": "JWT"}) + "." +
		part(map[string]any{"sub": "auth0|leorna_fixture", "iat": now.Unix(), "exp": now.Add(24 * time.Hour).Unix()}) + ".c2ln"
}

// TestCursorLoadsSyncedAgentFormat runs the real Cursor CLI with no sign-in
// against a local fake API and checks the request context it builds from the
// exact file the Cursor connector writes. The CLI reads agents only from the
// workspace, so the bundle is applied below <project>/.cursor here; Sync
// itself writes the same bytes to ~/.cursor/agents (AC3).
func TestCursorLoadsSyncedAgentFormat(t *testing.T) {
	cursorBin := os.Getenv("LEORNA_TEST_CURSOR_BIN")
	if cursorBin == "" {
		t.Skip("set LEORNA_TEST_CURSOR_BIN to a cursor-agent executable to run against the real Cursor CLI")
	}
	root := t.TempDir()
	env := []string{"PATH=/usr/bin:/bin", "TERM=dumb", "NO_OPEN_BROWSER=1"}
	for name, dir := range map[string]string{"HOME": "home", "XDG_CONFIG_HOME": "xdg", "CURSOR_CONFIG_DIR": "cursor-config", "CURSOR_DATA_DIR": "cursor-data", "TMPDIR": "tmp"} {
		path := filepath.Join(root, dir)
		if err := os.MkdirAll(path, 0o700); err != nil {
			t.Fatal(err)
		}
		env = append(env, name+"="+path)
	}
	// The fake endpoint is plain HTTP, which the CLI reaches only over HTTP/1.1.
	if err := os.WriteFile(filepath.Join(root, "cursor-config", "cli-config.json"), []byte(`{"version":1,"network":{"useHttp1ForAgent":true}}`), 0o600); err != nil {
		t.Fatal(err)
	}
	project := filepath.Join(root, "project")
	connector := &cursor.Connector{Home: filepath.Join(project, ".cursor")}
	for _, description := range []string{"LEORNA-AGENT-V1 old description", "LEORNA-AGENT-V2 Checks agent install."} {
		bundle, err := (cursor.Transformer{}).Transform(tc.Pack{Name: "Agent check", Version: "1", Items: []tc.PackItem{{
			Kind: tc.PackKindAgent, Name: "leorna-agent-check", Version: "1", Description: description, Body: "LEORNA-AGENT-BODY reply OK.",
		}}})
		if err != nil {
			t.Fatal(err)
		}
		if err := connector.ApplyConfig(context.Background(), bundle); err != nil {
			t.Fatal(err)
		}
	}
	if _, err := os.Stat(filepath.Join(project, ".cursor", "agents", "leorna-agent-check.md.leorna.bak")); err != nil {
		t.Fatalf("the update left no backup: %v", err)
	}
	version := exec.Command(cursorBin, "--version")
	version.Env = env
	if out, err := version.CombinedOutput(); err == nil {
		t.Logf("cursor-agent version: %s", strings.TrimSpace(string(out)))
	}

	api := &fakeCursorAPI{got: make(chan struct{})}
	server := httptest.NewServer(api)
	defer server.Close()
	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()
	command := exec.CommandContext(ctx, cursorBin, "-p", "LEORNA-AGENT-PROBE reply OK", "--model", "gpt-5",
		"--output-format", "stream-json", "--trust", "--api-key", "leorna-offline-fixture", "-e", server.URL)
	command.Dir = project
	command.Env = env
	var output bytes.Buffer
	command.Stdout, command.Stderr = &output, &output
	if err := command.Start(); err != nil {
		t.Fatal(err)
	}
	select {
	case <-api.got:
	case <-time.After(45 * time.Second):
	}
	cancel()
	_ = command.Wait() // the fake never finishes a turn, so the exit status is not the result
	t.Logf("cursor-agent output:\n%s", output.String())

	sent := api.requestContext()
	if sent == nil {
		t.Fatal("the Cursor CLI sent no request context naming a .cursor/agents file")
	}
	path := []byte("/.cursor/agents/leorna-agent-check.md")
	switch {
	case bytes.Count(sent, path) != 1:
		t.Fatalf("agent listed %d times, want 1", bytes.Count(sent, path))
	case !bytes.Contains(sent, []byte("LEORNA-AGENT-V2 Checks agent install.")), bytes.Contains(sent, []byte(`"LEORNA-AGENT-V2`)):
		t.Fatal("the updated description is missing or carries added quotes")
	case bytes.Contains(sent, []byte("LEORNA-AGENT-V1")), bytes.Contains(sent, []byte(".leorna.bak")):
		t.Fatal("the old version or its .leorna.bak copy was loaded")
	case !bytes.Contains(sent, []byte("LEORNA-AGENT-BODY reply OK.")):
		t.Fatal("the instructions are missing")
	}
	at := bytes.Index(sent, path)
	t.Logf("request-context entry: %q", sent[at:min(len(sent), at+200)])
}
```

- **Planner validation (2026-11-07, throwaway `git archive` of `7a83443` + this plan's T1/T4 code + the Q8 a amendment, removed afterwards; the real `~/.cursor` still absent):** `go vet ./toolconnector/cursor` clean. With `LEORNA_TEST_CURSOR_BIN` set, the test **PASSED in 3.7 s** against cursor-agent `2026.11.05-86047df` (log line: `request-context entry: "/.cursor/agents/leorna-agent-check.md\x12\x12leorna-agent-check\x1a%LEORNA-AGENT-V2 Checks agent install.*\ainherit2\x1bLEORNA-AGENT-BODY reply OK.8\x01r\tworkspace…"`). With the approved quoted Cursor renderer instead, it **FAILED** with `the updated description is missing or carries added quotes` (M15's proof).
- RED: on the base the Cursor transformer writes no agent file, so the backup check fails. Apply only this file to a `git archive` of `7a83443` and run the gate command, then save `red-ac12-7a83443.txt`. With Q8 a, the approved quoted renderer (T4 before the amendment) also fails the "added quotes" case. M15/M16 repeat both proofs on the head.
- Stop condition: if the CLI on this machine is no longer `2026.11.05-86047df` (check `--version`) and the request context never arrives, don't loosen the assertions. Re-read the bundle's descriptors (`return["ExecServerMessage|…`, `RequestContext|…`), update the field numbers, and report.
- Memory: run it under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` if it's ever killed. Only Chrome-free processes are involved.
- Commit `test(86bctmuwy): real Cursor CLI loads the synced agent file`.

### AC13 (live)

Justin runs it after the reviews and the verifier. Sync from a Leorna client whose home is the one Justin's Cursor editor uses (on Windows that's `%USERPROFILE%\.cursor`, not WSL's `~/.cursor`), then open Cursor → the subagents list, and screenshot the synced agent. The verifier marks it `not_run`, and `ac-check.sh` reports it as owed (`READY FOR THE USER`). The orchestrator must not write into a real `.cursor` folder for him.

### Risks and follow-ups added by Revision 1

- The fake Cursor API reimplements a private protocol: a Cursor CLI update can break AC12 without any Leorna change. The test logs the version, and the stop condition above applies.
- F4 (real Cursor check) is now AC12 + AC13.
- New F7: Cursor reads a project's `.claude/agents/` (on by default), and its parser keeps the Claude file's JSON quotes. Descriptions show quotes, and `tools: "Read, Grep"` becomes `"Read` + `Grep"`. Fix later by writing Claude's `tools` (and the description, when it is plain-safe) unquoted, which Claude Code's YAML also reads. Not in this story unless Justin adds it.
- New F8: if Cursor ever makes its CLI read `~/.cursor/agents` (the docs already say it does), re-run AC12 against the user folder.
