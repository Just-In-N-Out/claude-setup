# Re-review plan — 86bbu3xfw Claude Code config transformer (leorna-client)

## Context
Second review of `feat/86bbu3xfw-claude-code-transformer`, now 7 local commits on origin/main
0b453fe (fix round: 4e57d11 code+tests, 06338aa docs). Judge the whole story again, verify
each of the 7 previous findings yourself, run the commands, run the mutations, report in the
requested format. Review only: no commit/push/PR/ClickUp. Each mutated file is restored
with `git checkout -- <file>`; end with `git status --short` empty. Never `-update` golden
files, never run `claude` outside a throwaway HOME, never approve MCP servers, don't touch
the control plane's deploy/local/.

## Already verified read-only (plan mode)
- `git ls-remote origin`: only `main` = 0b453fe; branch not pushed. Tree clean.
- 7 commits, all `Justin Issa <justin@leorna.com>`; grep for Co-Authored-By/Anthropic/"Generated with"/noreply → nothing.
- Fix round touches only README.md, claudecode/README.md, config.go, config_test.go; golden dir not in `git diff --stat 58aaddd..HEAD`.
- Finding 1 (merge): both READMEs now say it; "as with Codex and Cursor" is backed by codex/README.md:61 and cursor/README.md:23.
- Finding 3 (marker): labelled "one-off manual check on 2026-09-27, not part of the test"; quote matches mcp.md ("…stays at `⏸ Pending approval` instead of being connected and health-checked").
- Finding 4 (trusted input): docs `env` = "every session and … subprocesses"; ignored-env anchor exists; BASH_ENV/NODE_OPTIONS are not in the ignored list. Accurate.
- Finding 5 (blockReads): code keeps raw `true`/`false`, else ErrInvalid naming the key; tests added (Preserves…, two RejectsPacks rows, Layout struct). Docs: Type Boolean, Any file.
- Finding 7 (null type): `!isString(extra.Value) ||` added; "type that is null" row asserts the message.
- **New nit found**: claudecode/README.md "the Claude Code docs describe `${NAME}` expansion only for MCP servers" is false as written — skills.md "Available string substitutions" documents `${CLAUDE_SKILL_DIR}`, `${CLAUDE_PROJECT_DIR}`, `${CLAUDE_SESSION_ID}` etc., and settings-reference shows `${TOKEN}` in marketplace `headers`. Fix: "the docs describe no `${NAME}` expansion for the four kept keys".
- Finding 6 (symlinks): my view — it can wait: nothing in this branch writes into a project, and the writer story must read/merge existing files anyway, which is where symlink checks belong. Record it on the writer card.

## Steps to run (after approval)
1. `git fetch origin`; `git merge-base HEAD origin/main` == `git rev-parse origin/main` == 0b453fe.
2. `make check`; `node --test scripts/*-ui.test.cjs`; `make lint audit`.
3. `go test -mod=vendor -race -count=1 -v ./toolconnector/... | grep -E -- '--- (FAIL|SKIP)|^(ok|FAIL)'` — list every skip.
4. `LEORNA_TEST_CLAUDE_BIN="$(command -v claude)" go test -mod=vendor -count=1 ./toolconnector/claudecode -run TestClaudeReadsGoldenConfig -v`.
5. `git diff --exit-code origin/main -- api/ toolconnector/testdata toolconnector/codex toolconnector/cursor toolconnector/connector.go toolconnector/claudecode/claudecode.go`; `git diff --exit-code 58aaddd..HEAD -- toolconnector/claudecode/testdata/golden`; `git log --format='%h %an <%ae> %s' origin/main..HEAD`.

## Mutations (edit → targeted `go test -run` → `git checkout -- <file>`; each must compile)
| # | Edit in toolconnector/claudecode/config.go | Expect to fail |
|---|---|---|
| A | blockReads case: drop the true/false check (keep `out[key] = rule`) | RejectsPacks/…_not_a_boolean, …_that_is_null |
| B | blockReads case → append skip warning, no `out[key]` | PreservesAuthoredSettingsValues |
| C | renderMCP: drop `!isString(extra.Value) \|\|` | TransportTypes/type_that_is_null |
| D | `"sse": "sse"` → `"sse": "http"` | TransportTypes/url_with_sse (+ real-Claude `(SSE)`) |
| E | `SetEscapeHTML(true)` | PreservesAuthoredSettingsValues |
| F | add `"bypassPermissions": true` to `defaultModes` | SkipsUnsupportedFieldsWithWarnings |

Optional real-tool check (throwaway HOME, CLAUDE_CONFIG_DIR, project in scratchpad, same env as `runClaude`): a project with only `.claude/settings.json` = `{"permissions":{"blockReadsOutsideWorkingDirectories":true}}` → `claude doctor` shows no "Invalid settings"; with `"yes"` → it does ("Expected boolean"). No `.mcp.json`, so nothing to approve.

## Report
1. Verdict line. 2. Finding → claimed fix → verified (evidence). 3. AC/DoD → test + result (AC1 Layout + real Claude; AC2 SkipsUnsupported…; AC3 MatchesGolden; failure: RejectsPacks + FailsClosedOnPackFile…; integration: BundleLandsInProject… + ClaudeReadsGoldenConfig). 4. Trimmed output + mutation table. 5. New issues (at least the `${NAME}` sentence nit), labelled, severity, file:line, fix.
