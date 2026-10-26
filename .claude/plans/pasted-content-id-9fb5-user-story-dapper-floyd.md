# 86bbu3xg8 — Verify written files against the lockfile (leorna-client)

## Context
Sync (86bbu3xhc, PR #13) and startup auto-sync (86bbu3xhy, PR #16) write transformed native config files into each tool's folders through `nativewrite`. Nothing checks those files afterwards, so a user (or the tool itself) can change or delete them unnoticed. This story adds a read-only **check**. It re-hashes each written file and compares it with the lockfile. It reports drift with the file path and logs every result locally.

**Decisions (Justin, 2026-10-12):**
- **"Lockfile" means each tool's last successful Sync record in SQLite.** The server lockfile hashes the *source* pack items, which never equal the transformed files on disk.
- **A "Check files" button** in the Sync panel.

**Baseline lookup:** `auto_sync_targets` (current workspace + selected project) → `run_log_id` → `run_logs.files_json` → that tool's `success` entry → `{path, sha256}`. That table is cleared when the project changes, and its Claude row is cleared when the Claude folder changes (`application/sync_store.go:54-62`). So the baseline always matches the roots that the relative paths refer to.

Base: main `5b2615f` (equal to origin/main). Branch `feat/86bbu3xg8-verify-written-files`. No OpenAPI change, no CI change, and the `toolconnector.Connector` interface and `Capabilities` stay unchanged.

## 1. `toolconnector/nativewrite` — read-only check
**`write.go`** (Apply's behaviour is unchanged):
- Add `open func(string) (*os.File, error)` to `fileSystem`, and `os.Open` to `operatingSystem`.
- Move the text-only path checks out of `plan` (lines 209-217) into `destination(root, rel string) (string, error)`. Keep the same order and the same `ErrInvalid` messages; `plan` calls it, then `rejectSymlinks` as now.

**New `check.go`:**
```go
type FileState string // FileMatch "match", FileModified "modified", FileMissing "missing", FileUnreadable "unreadable"
type FileCheck struct{ Path string; State FileState; Expected, Actual string } // Path = recorded relative slash path
type CheckTarget struct{ Root string; Files map[string]string }               // rel -> sha256
func Check(ctx context.Context, root string, files map[string]string) ([]FileCheck, error)
func CheckAll(ctx context.Context, targets []CheckTarget) ([]FileCheck, error)
```
**Validation, before any disk read:**
- Every path goes through `destination()`, and every hash must be 64 lowercase hex characters. Anything else returns `tc.ErrInvalid`.
- Targets with no files are skipped, as in `applyAll`.

**Root:**
- `Abs` + `EvalSymlinks`, and **never `MkdirAll`**.
- Root missing: every file is `missing`. Root not a directory: every file is `modified`. Any other error: every file is `unreadable`.

**Each file:** walk the components below the resolved root with `lstat`.

| What the walk finds | State |
|---|---|
| Path not found | `missing` |
| A symlink, a non-directory in the middle of the path, or a final entry that isn't a regular file | `modified` (symlinks are never followed; same rule as `rejectSymlinks`) |
| Any other error | `unreadable` (the check carries on with the other files) |
| A regular file | streamed through SHA-256 with `io.Copy`, then `match` or `modified` |

- `ctx.Err()` is checked before each file.
- Output is sorted by path and never contains an absolute path.

## 2. Connectors — one additive method each (Connector interface unchanged)
- **`claudecode/claudecode.go`:** `CheckConfig(ctx, expected map[string]string) ([]nativewrite.FileCheck, error)`. It returns the same `ErrInvalid` as `ApplyConfig` when there is no `ForProject` root, then calls `nativewrite.Check(ctx, c.projectRoot, …)`.
- **`cursor/cursor.go`:** `CheckConfig` calls `nativewrite.Check(ctx, c.Home, …)`.
- **`codex/capture.go`:**
  - Add `splitRoots[V any](files map[string]V) (config, skills map[string]V)`. Paths starting `skills/` go to `filepath.Join(UserHome, ".agents")`, everything else to `Home`.
  - `ApplyConfig` and `CheckConfig` both use it, so writing and checking share one mapping.
  - `CheckConfig` keeps the same `UserHome` guard and calls `nativewrite.CheckAll`.

## 3. `application/file_check.go` (new)
**Types and functions:**
- `FileCheckStatus`: `clean` / `drift` / `failed`.
- `CheckedFile{Path, State, ExpectedSHA256, ActualSHA256}`.
- `FileCheckToolResult{ToolID, Status, BundleDigest, BaselineRunID, Files, ErrorCode, Message}`.
- `FileCheckResult{RunID, Status, ProjectID, Tools, Message, ErrorCode, CheckedAt}`.
- An unexported `configChecker` interface, with compile-time assertions for all three connectors. `toolconnector` itself is not touched, so there is no import cycle.
- `func (a *Application) CheckSyncedFiles(ctx context.Context, registry *tc.Registry) (FileCheckResult, error)`.

**Baselines:**
- `auto_sync_targets t LEFT JOIN run_logs r ON r.id=t.run_log_id`, for the current tenant, backend and project, ordered by `tool_id`.
- A tool gets `failed/baseline_unavailable` when any of these is true:
  - the run row is missing;
  - the operation is not `sync`;
  - the run status is not `success` or `partial`;
  - the project or digest doesn't match;
  - there is no entry for the tool, or the entry isn't `success`.
- A tool gets `failed/baseline_invalid` when `files_json` is bad: malformed, over 4 MiB, a duplicate or empty path, or a bad hash.
- In both cases the connector is never called.

**Per tool:**
- Look up the connector in the registry; Claude goes through `ForProject(selection.ClaudeProjectRoot)`.
- If there is no `CheckConfig`: `unsupported_tool`.
- If `CheckConfig` returns an error: `check_failed`, or `cancelled` when the context is done. **The raw error text is never stored**, because it can hold absolute paths.
- The connector must return one entry per baseline path, with no unknown paths. Otherwise `check_failed`, so an empty result can never pass as `clean`.
- Any file not in `match` makes the tool `drift`.

**Overall:**
- `selection_required` / `selection_unavailable` when there is no usable project selection; `no_baseline` when no Sync has been recorded yet.
- Otherwise `drift` if any tool drifted, else `failed/check_incomplete` if a tool failed, else `clean`.
- Messages say "match the last Sync", never "up to date", because nothing is fetched from the server.

**Log (AC3):**
- Exactly one `INSERT INTO run_logs` with `operation='check'`, `status`, `details=code`, `files_json=json(Tools)`, `project_id` and `trigger='manual'`, using `context.WithoutCancel`.
- There is no `running` row and no migration. Crash recovery and `AutoSyncRecoveryRequired` only read `operation='sync'`, so they are unaffected.
- Every outcome is logged. An error is returned only if the log write fails.

## 4. Desktop + UI
- **`desktop/bridge.go`:** `CheckSyncedFiles() (application.FileCheckResult, error)`. It takes `syncMu.TryLock()` (returns `ErrSyncInProgress` while a Sync runs), honours `registryError`, uses a 1-minute timeout, and needs no network or login.
- **`index.html`:** a `#sync-check` "Check files" button with the hint "Compare written files with the last Sync", plus `#sync-check-results`. Check results stay separate from `#sync-results`, so retry and `failedTools` are untouched.
- **`sync.js`:**
  - Add `renderCheck`: a heading, one `article.sync-result <clean|drift|failed>` per tool, and a list of `path — changed | missing | could not be read`. All text goes through `textContent`.
  - Busy and generation guards; the results are cleared by `run()`, `resetConfirmation` and `identityChanged`.
  - `setBusy` covers the new button.
- **`style.css`:** a `.sync-result.drift` colour.
- **`scripts/sync-ui.test.cjs`:** add the 2 new IDs to `mount()`, otherwise every existing UI test breaks.

## 5. Tests (criterion → test). Each hardened assertion is proven by a mutation, then restored.
| AC | Tests |
|---|---|
| AC1 match | `nativewrite.TestCheckConfirmsFilesWrittenByApply`, `codex.TestCheckConfigUsesApplyConfigRoots`, `application.TestCheckSyncedFilesUsesLastSuccessfulEvidenceAndLogs`, `application.TestFileCheckRealWritersConfirmThenReportDrift` (integration) |
| AC2 drift + path | `nativewrite.TestCheckReportsDriftByRelativePath` (modified / missing / replaced by a directory), `TestCheckTreatsSymlinkedPathAsModified` (skipped on Windows), `TestCheckReportsUnreadableWithoutAborting`, the integration test above, and the UI test "check files shows drifted paths" |
| AC3 logged | `TestCheckSyncedFilesUsesLastSuccessfulEvidenceAndLogs` (row survives a database reopen; `AutoSyncRecoveryRequired` stays false), `TestCheckSyncedFilesBaselineGuards` (failures logged too), the integration test (2 `check` rows, no absolute root in `files_json`) |

Supporting tests:
- `TestCheckNeverCreatesMissingRoot`
- `TestCheckRejectsUnsafeExpectations`
- `claudecode.TestCheckConfigRequiresProjectRoot`
- a cursor match test
- bridge `TestCheckSyncedFilesSharesSyncGuardAndNeedsNoLogin`
- UI rejected-call case

**What the main application tests set up and cover:**
- **Seeding:** the stub tests seed a baseline with `engine.Run(…, SyncRequest{Mode: SyncConfirmed})`. A plain `SyncRequest{}` writes no targets.
- **Guard table:** the guard tests cover these cases:
  - no selection;
  - no targets;
  - malformed JSON;
  - a failed tool entry;
  - a digest mismatch;
  - a connector without `CheckConfig`;
  - a stub that returns `[]`;
  - a stub error that contains `/Users/secret`, which must not leak.
- **Integration test:** it reuses the `TestStartupSyncRealWritersStayInsideDisposableProfile` setup (`available.Registry` in temp homes):
  1. Run a real Sync.
  2. Check: everything is clean and the files are unchanged (same content and mtime).
  3. Edit the Codex `~/.agents` skill and delete the Cursor skill.
  4. Check again: `drift`, with exactly those two paths, and Claude still clean.

## 6. Docs (short)
- **Root README:** a section `## Verify written files — 86bbu3xg8` covering:
  - what "lockfile" means here and why the server hashes can't match;
  - that the check is read-only and never repairs anything;
  - the `run_logs` `operation='check'` log;
  - demo steps;
  - an AC → test table.
- **`application/README.md`:** one paragraph on how baselines are chosen and on the check rows.
- **`toolconnector/nativewrite/README.md`:** `Check`/`CheckAll` are read-only, never create folders, use Apply's symlink rule and return relative paths.
- Write only behaviour that a test proves.

## Commits (plain `git commit`, no attribution lines, CLAUDE.md never staged)
1. `feat(86bbu3xg8): check written native files against recorded hashes`: nativewrite and connectors.
2. `feat(86bbu3xg8): check synced files from the desktop and log each result`: application, bridge and UI.
3. `docs(86bbu3xg8): document the written-file check`

## Verification
- `make check` → `node --test scripts/*-ui.test.cjs` → `make lint audit`.
- Targeted runs: `go test -mod=vendor -race -count=1 ./toolconnector/nativewrite ./toolconnector/... ./application ./desktop`.
- Mutations, each restored afterwards. Every one must be caught:
  - hash the wrong bytes;
  - `Stat` instead of `Lstat`;
  - `MkdirAll` in check;
  - accept an empty result as clean;
  - trust a `failed` tool entry;
  - store `err.Error()`;
  - skip the INSERT;
  - Codex skills checked under `Home`;
  - drop the sort.
- Windows: no Windows machine here. Paths stay relative, and the symlink test skips on Windows. The Windows CI job (`./application ./toolconnector/...`) proves it once the PR runs.
- Demo: run the app with a throwaway profile → Sync → Check files ("All N files match") → edit one written file → Check files (shows its path) → inspect the row with `sqlite3 … "SELECT operation,status,details FROM run_logs WHERE operation='check'"`.
- Stop after the gates pass. Show `git diff --stat origin/main..HEAD`, the key hunks and the results, then give:
  - PR text (Summary, files, Test Plan, Assumptions);
  - a review prompt for a fresh agent;
  - a team message.

No push and no PR until Justin says so.

## PR Assumptions (to list)
- The lockfile for written files is the last successful Sync's recorded hashes, not the server lockfile (source hashes) and not a new file on disk.
- Tool roots aren't stored. A changed `CODEX_HOME` or `HOME` between Sync and check makes the check read the new location.
- Any byte change counts as drift, including edits a tool makes to its own config. **This is not tested against real tools.** The check never repairs files, and drift doesn't block automatic updates.
- A missing Claude project folder stops the whole check (`selection_unavailable`), the same as Sync.
- Each click adds a `run_logs` row (capped at 4 MiB each, no pruning, same as Sync).
- After merge: a control-plane `delivery/stories.json` entry `86bbu3xg8` → client `[PR#]`, then `check-story-shippable.py`.
