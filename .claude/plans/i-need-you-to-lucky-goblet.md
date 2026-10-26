# 86bbu3xkg: read Cursor local sessions (client)

ClickUp: https://app.clickup.com/t/90141510532/86bbu3xkg

## Context
Leorna already captures sessions from Claude Code (PR #11, `claudecode.CaptureSession`) and Codex
(`codex/capture.go`). The Cursor connector still returns `ErrUnsupported` from `CaptureSession`
(`toolconnector/cursor/cursor.go:29`). This story makes it read Cursor's chats and return normalized
`SessionEvent`s, which extends continuity to Cursor.

Your decisions: read the **Cursor editor store** (`User/globalStorage/state.vscdb`), and read only an
**explicitly selected file**, the way Codex does. Nothing gets scanned automatically.

## Step 0: branch from up-to-date main
Your local `main` is `0b453fe`. GitHub main is `189b5ff` (PR #11), and `origin/main` already matches
it (checked with `ls-remote` over HTTPS, because SSH fails with "Permission denied (publickey)" until
the key is added again).
```sh
git checkout main
git merge --ff-only origin/main        # main -> 189b5ff
git checkout -b feat/86bbu3xkg-cursor-session-capture
```
If anything new lands on GitHub before this runs, fetch over HTTPS through gh first:
`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-client.git main:refs/remotes/origin/main`

## What Cursor stores (community-documented, not an official format)
SQLite file, table `cursorDiskKV(key TEXT UNIQUE, value BLOB)`:
- `composerData:<composerId>`: one chat. JSON with `composerId`, `createdAt` (ms), `fullConversationHeadersOnly: [{bubbleId, type}]` in message order.
- `bubbleId:<composerId>:<bubbleId>`: one message. JSON with `type` (1 = user, 2 = assistant), `text`, `createdAt`, `tokenCount {inputTokens, outputTokens}`.

Checked on this Mac (Cursor 3.20.17, read-only): the table and `composerData` rows exist (181 chats,
`_v` 10–18). Every `fullConversationHeadersOnly` is empty, though, and there are no `bubbleId` rows,
because old chat data was cleaned up. The message fields are therefore **not yet proven on a real
store** (see Step 5). The store runs in WAL mode (a 4.9 MB `-wal` file), so it must be opened with
`mode=ro`, **not** `immutable=1`. `immutable=1` silently skipped the newest data during this check.

## Implementation (`toolconnector/cursor/`)
New file **`capture.go`**. `cursor.go` changes only the `Connector` struct, `Capabilities` and
`CaptureSession`. The `tc.Connector` interface and the shared `toolconnector` package stay unchanged.

- `Connector` gets two fields: `Store string` (the selected `state.vscdb`) and `Logger *slog.Logger`
  (nil means `slog.Default()`). `Capabilities` adds `CaptureSession: true`. Codex reports true with an
  empty path too.
- New sentinel `ErrStoreUnreadable` in the cursor package. Errors give the reason, never chat content
  and never the absolute path:
  - `Store` is empty: `cursor: toolconnector: invalid configuration: no session store selected` (wraps `tc.ErrInvalid`).
  - The file is missing or unreadable (`os.Stat` before opening): `…unreadable: file not found` / `permission denied`.
  - The file is not SQLite, or is corrupt: `…unreadable: not a SQLite database`.
  - The file is SQLite but has no `cursorDiskKV` table: `…unreadable: no Cursor chat table`.
- Open the file through the vendored `github.com/mattn/go-sqlite3` (already used in
  `application/application.go:52`) with a read-only DSN `file:<escaped path>?mode=ro` plus a busy
  timeout. The DSN must work for paths that contain a space (the real macOS path has
  "Application Support") and for Windows drive paths. Use `QueryContext` and check `ctx` between rows.
- Read every `composerData:%` row and sort chats by `createdAt`, then by `composerId`, so the order
  is stable. For each header, look the bubble up by its exact key (`WHERE key = ?` hits the unique
  index) and keep header order.
- Map each bubble to a `tc.SessionEvent`: `SessionID` = composerId, `Tool` = `"cursor"`, `Role`
  (1 → `user`, 2 → `assistant`, anything else → empty), `Text`, `Timestamp` (RFC 3339, zero if
  missing, like Claude), `Tokens` (Total = in + out), and `Raw` = the stored bubble JSON bytes
  unchanged.
- Bad rows are skipped, as in PR #11: invalid chat JSON, invalid bubble JSON, or a header that points
  to a missing bubble (Cursor may still be writing it). Each skip logs a structured warning with only
  the composer/bubble IDs and a reason (`invalid_json`, `missing_bubble`). The older format that keeps
  the whole conversation inside the `conversation` array is **not supported**; the README says so.

## Tests, written first (TDD); each assertion proven by a mutation
Fixture **`testdata/store.sql`** is readable SQL: a `cursorDiskKV` table, two chats with user and
assistant bubbles (one carrying `tokenCount`), one malformed bubble, one header pointing to a missing
bubble, and one unrelated key. A test helper builds it into `t.TempDir()/"Application Support"/state.vscdb`.
The space in that folder name exercises the DSN escaping. The fixture is synthetic, with no real chats.

New file `capture_test.go`, in the same package as `config_test.go` so it reuses the `update` flag:
- **AC1** `TestCaptureSessionNormalizesCursorStore`: checks event count and order, roles, session
  IDs, text, timestamps, tokens, `Raw` equal to the stored bytes, and `Tool == "cursor"`. The two bad
  rows are skipped, and a captured `slog` buffer shows the warnings with no message text.
- **AC2** `TestCaptureSessionRejectsUnreadableStore` (table-driven, the failure case): no store
  selected (`ErrInvalid`), missing file, a non-SQLite file, and SQLite without `cursorDiskKV`. Each
  case checks `errors.Is(err, ErrStoreUnreadable)`, checks that the message names the reason, and
  checks that the message does not contain the path.
- **AC3** `TestCaptureSessionMatchesGolden`: marshals the events to indented JSON and compares the
  bytes with `testdata/golden/events.json` through `toolconnector/internal/golden.Diff`. Regenerate
  with `-update`.
- `TestCaptureSessionHonoursCancellation`: a cancelled context returns an error.
- **Integration**: the golden test already uses the real SQLite driver on a real file, through the
  `tc.Connector` interface. The env-gated `TestCaptureReadsRealCursorStore` (`LEORNA_TEST_CURSOR_STORE`)
  copies a real store into a temporary directory, captures it and logs only counts. It skips in CI.

## Docs
Add a "# Cursor session capture" section to `toolconnector/cursor/README.md`. It covers: an explicit
file only, with the per-OS locations (macOS `~/Library/Application Support/Cursor/User/globalStorage/state.vscdb`,
Windows `%APPDATA%\Cursor\User\globalStorage\state.vscdb`, Linux `~/.config/Cursor/User/globalStorage/state.vscdb`);
read-only and WAL-aware; the field mapping; skip-with-warning; the older format being unsupported;
"not an official Cursor format, inspected 2026-10-03" with sources; and the exact test names and the
`go test` command. No OpenAPI change, because no API is touched.

## Assumptions to list in the PR
- `available/registry.go` still builds `&cursor.Connector{Home: …}` with no `Store`, so capture
  returns "no session store selected" until a later story adds file selection to the app.
- Bad rows are skipped with a warning (as in PR #11), not treated as fatal (as in Codex).
- The message fields come from community tools until Step 5 confirms them on a real store.

## Verification
1. `go test -mod=vendor ./toolconnector/cursor -v`, then mutate each hardened assertion, watch it fail, and restore.
2. Full gate: `make check` → `node --test scripts/*-ui.test.cjs` → `make lint audit`. Windows CI also
   runs `./toolconnector/...` with CGO, which `application` already relies on.
3. **Step 5, real store (needs you):** start one throwaway chat in Cursor ("say hi"). Then run a
   read-only query that lists only the **field names** of one `bubbleId` row, to confirm `type`/`text`/`createdAt`/`tokenCount`.
   Then run `LEORNA_TEST_CURSOR_STORE="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb" go test -mod=vendor ./toolconnector/cursor -run TestCaptureReadsRealCursorStore -v`.
   The README states only what that run proves.
4. Stop and show the diff. No push and no PR until you say so. After you merge: add `86bbu3xkg` →
   client `[PR#]` to the control plane's `delivery/stories.json`, run `check-story-shippable.py`, and
   give you the review prompt and the team message.
