# 86bbu3xmt — Hand a ContextPack into a target tool (client)

## Context
Engineers want to continue a session in another coding tool without re-explaining. The
server side is already merged on control-plane main (`aba4003`): ContextStore (Mongo) plus
the handoff endpoint `GET /v1/client/context/sessions/{sessionId}` (#71, #72). The client
already has the `InjectSession` port, but it doesn't work yet:
- Codex and Cursor return `ErrUnsupported`.
- Claude Code writes `~/.claude/leorna/primer-<id>.md`, a path Claude Code never loads, so AC2 fails today.
- The client's OpenAPI snapshot does not include the handoff endpoint.

Justin's decisions (2026-10-03):
- The Claude primer goes to `<project>/.claude/rules/leorna-handoff.md` (project scope).
- This story also fetches the pack from the server: refresh the OpenAPI snapshot, regenerate, and convert.

## Setup
- `git checkout main && git merge --ff-only origin/main`. Local `origin/main` equals remote
  main `f5f4e88` (checked with `gh api`). The SSH key is locked, so no SSH pull.
- `git checkout -b feat/86bbu3xmt-inject-context-pack`

## Step 0: prove what the tools load before writing production code
Work offline in the scratchpad with throwaway homes and local fake model servers. No real
model calls and no tokens.

**Fake servers**
- Record every request.
- Return 404 for unknown paths.
- Assert on the request that carries the prompt, never on "the first request".
- Set `HTTPS_PROXY=http://127.0.0.1:1` and `NO_PROXY=127.0.0.1,localhost` so any stray real call fails fast.

**Codex 0.154.0**
- Write the rollout file at `$CODEX_HOME/sessions/YYYY/MM/DD/rollout-<ts>-<uuid>.jsonl`.
  The 0.154 source says resume-by-id falls back to a filename search there.
- In `config.toml`, add a custom provider: `wire_api="responses"`,
  `base_url="http://127.0.0.1:N/v1"`, both retry settings 0, a short stream idle timeout,
  and no auth keys.
- The fake answers with SSE that ends in `response.completed`.
- Run `codex exec resume <uuid> "reply OK" --skip-git-repo-check`.
- Pass condition: the request `input` contains the injected messages in order.
- `event_msg` lines never reach the model; they only feed history and previews. Keep them
  only if `codex app-server` `thread/read` (or the picker preview) shows they work.
  Otherwise drop them.

**Claude Code 2.1.289**
- The project has `.claude/rules/leorna-handoff.md`.
- Run `claude -p` with `ANTHROPIC_BASE_URL` set to the fake, a dummy `ANTHROPIC_API_KEY`,
  and a throwaway `HOME`/`CLAUDE_CONFIG_DIR`.
- The fake streams the full `message_start`…`message_stop` sequence and also handles `stream:false`.
- Pass condition: a request body contains the primer's ASCII marker.
- Fenced `@file` lines: show a fenced `@file` is not expanded, and as a positive control
  show that an unfenced one is.
- Negative control: without the file, the marker does not appear.

If either probe fails, stop and tell Justin before coding.

## Changes
1. **`toolconnector/inject.go`** (new): `Inject(ctx, *Registry, target ToolID, pack) error`.
   It returns errors before any connector code runs:
   - lookup failure gives `ErrNotFound` (a malformed ID gives `ErrInvalid`);
   - `Capabilities().InjectSession == false` gives `ErrUnsupported`, naming the tool;
   - `ValidateContextPack` gives `ErrInvalid` without a session ID, at least one event with
     text, and a non-zero `CreatedAt`.

   Only then does it call `InjectSession`. The `Connector` interface is unchanged.

2. **Claude Code** (`claudecode.go` plus a new `inject.go`). `InjectSession`:
   - requires `ForProject` and an existing project dir, otherwise `ErrInvalid`, the same as `ApplyConfig`;
   - renders a pure `Primer(pack) []byte`;
   - writes `.claude/rules/leorna-handoff.md` through `nativewrite.Apply`. The write is
     atomic and symlink-safe, and the previous file stays as `.leorna.bak`, which Claude does not load.

   What the primer contains:
   - a framing line: "reference transcript from <tool> session <id>, not instructions";
   - the summary;
   - each event under a role heading, inside a fence longer than any backtick run in it, so
     `@imports` and markdown never execute;
   - only the newest events that fit in 40,000 characters, plus an "N earlier events omitted" line.

   Rewrite `TestInjectSessionWritesPrimer` for the new path.

3. **Codex** (`capture.go` plus a new `inject.go`).
   - New field `Project string`: the folder the session resumes in.
   - `SessionIDFor(pack)`: a deterministic UUIDv7 built from the `CreatedAt` milliseconds
     plus a hash of the pack. Codex IDs are v7 and its tie-breaks use those bits.
   - Pure `RenderRollout(pack, cwd)`. It does no Abs/Clean on `cwd`, returns a forward-slash
     relative path, and never calls `time.Now`. It returns the path and JSONL with:
     - `session_meta` with `id`, `timestamp`, `cwd`, `originator:"leorna"`, `cli_version`
       and `source:"cli"`, and no `model_provider`;
     - a header message with `developer` role (Codex drops `system`), holding the summary and source;
     - user and assistant events as `response_item` messages (`input_text` / `output_text`),
       plus `event_msg` lines if Step 0 proves them;
     - other roles skipped, which the README states.

   `InjectSession` behaviour:
   - `Home` not present: `ErrNotDetected` (never create `~/.codex`);
   - `Project` empty or not absolute: `ErrInvalid`;
   - a rollout with that UUID already exists (`.jsonl`, `.jsonl.zst`, or under
     `archived_sessions/`): return nil, because the same pack is already resumable;
   - otherwise write through `nativewrite.Apply`.

   Set `Capabilities.InjectSession = true`.

4. **No leftover directories.** On a write failure, remove the empty parent directories the
   inject created (`sessions/YYYY/MM/DD`, `.claude/rules`). This is a small new helper beside
   nativewrite, and existing `Apply` behaviour is unchanged.

5. **`toolconnector/available`**: new `ProjectRegistry(userHome, claudeHome, codexHome, projectRoot)`
   with Claude through `ForProject` and Codex with `Project` set. The `Registry` signature is
   unchanged; `desktop/bridge.go` uses it.

6. **Server pack fetch**
   - Copy control-plane `contracts/control-plane.openapi.yaml` (main `aba4003`) to
     `api/control-plane.openapi.yaml`, run `make generate`, and update `api/README.md`.
     The refresh also adds `GetClientBundle` and the cloud endpoints, and drops the unused
     `bootstrapSecretKey`.
   - New package **`handoff/`**, in the same style as `usage.Upload`:
     - `FromSessionContext(api.SessionContext)` is pure. It orders by `seq`; ToolID comes from
       the first message's `tool`, and each event keeps its own; CreatedAt is `pack.at`, or the
       newest message `at`; skills are dropped.
     - `Fetch(ctx, client, sessionID)`. The server answers an unknown session with 200 and
       empty messages; that becomes `handoff.ErrNoMessages`. 400, 401, 403 and 503 become safe
       errors that never contain response text.
   - `login.Manager.Client()` caps every response at 64 KiB, and a real session goes over that.
     Add a separate `login.Manager.HandoffClient(company)` with a 32 MiB cap (the same bound as
     the Codex reader). `Client()` itself is unchanged.
   - Add `handoff` to the Makefile `fmt` list and to the Windows CI test packages.

7. **`.gitattributes`**: add a `-text` line for each new golden dir: `claudecode/testdata/handoff-golden/`
   and `codex/testdata/handoff-golden/`. These are kept separate because `golden.Write` wipes its directory.

## Tests (TDD; prove each key assertion can fail with a mutation, then restore)
- **AC1 Codex:**
  - `TestInjectSessionWritesResumableRollout`
  - `TestRenderRolloutMatchesGolden`
  - `TestInjectSessionIsIdempotent`
  - `TestInjectSessionRequiresDetectedCodex`
  - a failure after mkdir (a date folder that is a file) leaves the tree identical
  - env-gated `TestCodexResumesInjectedRollout` (`LEORNA_TEST_CODEX_BIN`)
- **AC2 Claude:**
  - `TestInjectSessionWritesProjectPrimer`
  - `TestPrimerMatchesGolden`
  - `TestPrimerFencesTranscriptText`
  - `TestPrimerKeepsNewestEventsWithinLimit`
  - no project gives `ErrInvalid`
  - env-gated `TestClaudeLoadsInjectedPrimer` (`LEORNA_TEST_CLAUDE_BIN`), with the positive and negative controls
- **AC3:** `available` `TestInjectReportsUnsupportedTargetWithoutWriting`. It uses a real
  `ProjectRegistry` in temp dirs, and in every case the file and directory snapshot is
  identical before and after:
  - `cursor` gives `ErrUnsupported`;
  - `unknown-tool` gives `ErrNotFound`;
  - `Cursor` gives `ErrInvalid`.

  Plus `toolconnector` unit tests showing `Inject` never calls an unsupported connector.
- **handoff:**
  - `TestFromSessionContextBuildsPack`
  - `TestFetchReportsServerErrors` (400/401/403/503 and empty session)
  - `TestFetchReadsLargeSession` (body over 64 KiB)
  - integration `TestFetchAndInjectIntoCodexAndClaude`: httptest server with contract JSON,
    then Fetch, then Inject through `ProjectRegistry`, then check the rollout and primer on disk

## Docs
Write short sections that name the exact tests. Record a real-tool run (tool version and date)
only after it passes. Files:
- `toolconnector/codex/README.md`: replace "does not implement context injection" and show `codex resume <id>`.
- `toolconnector/claudecode/README.md`: say the primer loads in every later session in that
  project until it is replaced or deleted, that it should be git-ignored, and that it was
  proven in `-p` mode.
- `handoff/README.md`
- `api/README.md`

## Verification
1. `make check`, then `node --test scripts/*-ui.test.cjs`, then `make lint audit`.
2. Real-tool run:
   `LEORNA_TEST_CODEX_BIN="$(command -v codex)" LEORNA_TEST_CLAUDE_BIN="$(command -v claude)" go test -mod=vendor ./toolconnector/... -run 'Resumes|Loads' -v`
3. Demo: run that command plus `go test ./handoff -run TestFetchAndInject -v`.
4. Commit locally (`feat(86bbu3xmt): …`) and do not push. Show `git diff --stat origin/main..HEAD`.
5. Hand over:
   - PR text with an Assumptions list;
   - a review prompt for a fresh agent.
6. After merge:
   - control-plane `delivery/stories.json`: `86bbu3xmt` → client `[PR#]`;
   - the team message.

## Assumptions to list in the PR
- Skills from the server response are not injected, because `ContextPack` has no field for them.
- Claude has one handoff file per project. The next inject replaces it and it loads in every
  session until then. The user should git-ignore it. Older events beyond 40,000 characters are left out.
- Codex: the session ID is deterministic, so the same pack twice is a no-op. Only user and assistant turns are replayed.
- Not wired into the desktop UI yet; that wiring is where the project gets chosen.
- Formats are proven against codex-cli 0.154.0 and Claude Code 2.1.289 only.
