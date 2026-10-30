## Summary

Adds the client half of content usage analytics: a new `import-content-usage` command reads transcripts an engineer picks, finds uses of the skills and prompts Leorna's last Sync installed, and uploads them to the control plane's content usage page. Claude Code: each `Skill` tool call and each typed `/name` command, in sessions run in the project folder Sync wrote to. Codex: the first read of `.agents/skills/<name>/SKILL.md` per session (inferred; Codex has no skill event). Cursor and agents are not measurable, and the command says so instead of sending zeros. Only identifiers leave the machine: a stable ID derived from the transcript's own IDs (so a re-import counts nothing twice), the tool, the kind, the item name, the time and the project. Never transcript text, command arguments, paths, folder names, or the names of personal skills and commands. The command reads the desktop database read-only and never changes it. Nothing is uploaded automatically. The contract copy is refreshed from the control plane, which also brings in the pack operations the client snapshot was missing (generated code only). Needs the matching control-plane PR LeornaAI/leorna-control-plane#103 merged first. No CI change.

ClickUp: [Content usage analytics (which items get used)](https://app.clickup.com/t/90141510532/86bcm902w)

## Changes

- `api/control-plane.openapi.yaml`, `api/controlplane.gen.go`: a byte-identical copy of the control plane's spec (new `ItemUse`, `ItemUseKind`, optional `UsageBatch.itemUses`), regenerated. The copy also catches up the pack operations and schemas from earlier control-plane stories that the client never copied.
- `usage/items.go`: `ItemUse`, `Managed` (the items the last Sync installed), `Detectable()` (must equal the spike's measured rows), stable IDs, `MergeItemUses` (dedupe and sort) and `UploadItemUses` (batches of at most 1,000 with `"events": []`).
- `usage/items_claudecode.go`: the Claude Code detector: `Skill` tool calls and genuine user-typed `<command-name>/name</command-name>` lines (copies in API blobs or assistant text don't count; arguments are never read), only sessions whose `cwd` is the synced project folder.
- `usage/items_codex.go`: the Codex detector: `SKILL.md` reads under `.agents/skills/` in `custom_tool_call`, `function_call` and `local_shell_call` records, once per session per skill; bounded input.
- `application/managed_items.go`, `application/application.go`, `application/file_check.go`: `OpenReadOnly` opens the desktop database with SQLite `mode=ro` and never migrates (an older database is refused with "open the app once"); `ManagedItems` maps what the newest successful Sync per tool installed (`run_logs`) to items; `DefaultDatabasePath` is shared with `OpenDefault`.
- `cmd/import-content-usage/main.go`: flags `-tool` (`claude-code` or `codex`; `cursor` stops with "item use is not measurable for Cursor; nothing was sent"), `-transcript` (repeatable, explicit files only), `-server` (HTTPS, or HTTP only to a loopback IP), `-project` (default: the project selected in the desktop app), `-desktop-db`. Session and CSRF values come from the environment and are never printed. Output is counts only; nothing is sent when nothing matches.
- Tests:
  - `usage/items_test.go`: only synced items count, typed skill commands, every Codex call shape, bounded input, no transcript text in the output, the golden upload body, dedupe/sort, batching.
  - `usage/items_real_test.go`: env-gated, runs a real Claude Code binary in a throwaway home with a faked model API on loopback.
  - `application/managed_items_test.go`: the last successful Sync per tool, installed files only, read-only open never migrates, the default path; the stored Claude Code folder matches a session `cwd` naming it in any Windows form (8.3 short path, letter case, forward slashes), and another folder or the parent does not.
  - `cmd/import-content-usage/main_test.go`: sends only identifiers, sends nothing without uses, refuses bad flags before sending.
  - `usage/testdata/items/`: synthetic Claude Code and Codex fixtures modelled on the verified shapes, and `upload.golden.json`, byte-identical to the control plane's copy.
- `README.md`: section "Content usage import (story 86bcm902w)": command, flags, what is counted, what is sent and what never is, and what happens against an older control plane.

## Test Plan

Everything below ran on 2026-10-29 on head `cf3df7f` (base `f105e27`, which is still GitHub `main`: nothing to bring in), with the control plane at `fabbec0` (the control-plane PR's current head). Tools: Go 1.27.3, Node 22, golangci-lint 2.14.0 and govulncheck v1.7.0 (CI's pins).

- [x] `make check` (boundary check, generated API check, vet, `go test -race`, build): exit 0.
- [x] `node --test scripts/*-ui.test.cjs`: 39 of 39 pass.
- [x] `make lint audit` with golangci-lint 2.14.0 first on PATH: 0 issues, no vulnerabilities.
- [x] The story's 11 tests by name (`./usage`, `./application`, `./cmd/import-content-usage`), including the new `TestStoredClaudeRootMatchesTranscriptFolderForms`: 11 of 11 pass.
- [ ] Real Claude Code 2.1.312 (`TestRealClaudeCodeTranscriptItemUses`, env-gated): not re-run on `cf3df7f`. The two commits since `db3e6b0` change only `application/managed_items_test.go`; it passed on `db3e6b0`.
- [x] Cross-repo ties: `cmp` of `usage/testdata/items/upload.golden.json` with the control plane's `internal/web/testdata/content_usage_client_upload.json`, and of `api/control-plane.openapi.yaml` with the control plane's `contracts/control-plane.openapi.yaml`, both read from `fabbec0`: both exit 0. The control plane's AC2 test posts this golden body.
- [x] Scope: no `.github/` path and no `CLAUDE.md` in the diff; all 8 commits by the Leorna identity with no AI attribution lines.
- [x] Windows path forms, on a real Windows host (not CI): this repo's `sameFolder` and `validateClaudeProjectRoot`, copied byte for byte into a cgo-free Windows probe, match `C:\Program Files\Common Files` as `C:\PROGRA~1\COMMON~1`, in lower and upper case, with forward slashes and with a trailing separator, and reject the parent and a missing sibling: 20 of 20. Without the symlink fallback, 10 fail.
- [x] `GOOS=windows CGO_ENABLED=0 go vet ./application` fails only in `toolconnector/cursor/capture.go` (`sqlite3.Error`, `ErrNotADB`, `ErrCantOpen`: the SQLite adapter needs cgo), identically on unchanged `main` `f105e27`; this PR doesn't touch that adapter. CI builds Windows with cgo.
- [x] Hosted CI on `cf3df7f` ([run 40973788926](https://github.com/LeornaAI/leorna-client/actions/runs/40973788926)): "Go quality gates", "Windows client executable" and "Clean Windows tool installation" pass. On `db3e6b0` the Windows client job had failed in `TestManagedItemsFromLastSuccessfulSync` and `TestOpenReadOnlyNeverMigrates`: the tests compared the stored project folder, which Sync resolves (long name, on-disk case), with the runner's raw temp path, which is the 8.3 short form (`C:\Users\RUNNER~1\…`). The product was right; the tests now compare with the resolved folder and close the read-only database in cleanup.

## Assumptions

- Merge the control-plane PR (LeornaAI/leorna-control-plane#103) first. Against a control plane without it, the command fails with "usage upload rejected; verify login and server availability" and nothing is stored; `import-codex-usage` is unaffected. The README's link to the spike write-up resolves once that PR merges.
- An explicit command, not an automatic upload (approved option). The separate "Upload usage automatically after Sync" card should call these detectors and `ManagedItems` rather than add its own.
- Only items the last Sync installed can leave the machine (approved option); with no successful Sync for a tool, nothing is sent for it. A stale project selection on a read-only database is treated as no selection, so nothing extra is sent.
- Claude Code sessions started in a subfolder of the synced project don't count (same conservative rule as the chat reader). Codex is counted once per session, from the first `SKILL.md` read.
- The command authenticates like the Codex importer, with the admin console's session and CSRF values from the environment; the desktop-token route has no client caller yet.
- The Cursor error reads "item use is not measurable for Cursor; nothing was sent", because CI's staticcheck refuses an error string that starts with a capital.
- No CI change. CI doesn't compare this repo's OpenAPI snapshot with the control plane's (control-plane PR, follow-up 5).

## Follow-ups (not in this PR)

1. Codex: count only reads under the user's `$HOME/.agents/skills`; today a repository's own `.agents/skills/<name>/SKILL.md` with a synced item's name also counts (review 1 R1-5).
2. Test the `-server` path rule (review 1 R1-4); it survives a mutant today. The Claude Code folder match through symlinks (review 2 R2-2) is now pinned in the Windows client job by `TestStoredClaudeRootMatchesTranscriptFolderForms` (case and slash forms always differ from the stored folder there); on Linux it is exercised only with a symlinked `TMPDIR`.
3. `ManagedItems` reads the newest Sync per tool from `run_logs`, which records no company or server: after switching company, the earlier company's Codex Sync still marks its skills as managed until a Codex Sync for the new company runs. Scope it before "Upload usage automatically after Sync" reuses it (review 2 R2-3).
4. The real Claude Code test pins only typed `/commands`; add a model-driven `Skill` call (review 2 R2-4).
5. Test strength: two detector guards survive a mutant in review 1's receipt without being filed as findings: Claude Code lines without a `uuid` are skipped, and a Codex use needs the session ID.

## Evidence

- Head: `cf3df7f8cb2af1a6d0a2ef42a6e08b1387ca7f20` (base `f105e27`). The local gates above ran on this head.
- Earlier, on `db3e6b0` (before the two test-only fix commits for the Windows job), in the story's pipeline: the independent verifier and a blind AC auditor ran the story tests and the real Claude Code test; the builder ran it end to end on loopback (a real client Sync to Claude Code, Codex and Cursor, then the built `import-content-usage` against synthetic transcripts: Claude Code 3 uses, Codex 1, the same counts on re-import with nothing doubled, Cursor refused); mutation checks: builder 13 of 13 killed, verifier 4 of 5 (the survivor drops a record-type filter the payload-type switch already covers), the review survivors are follow-ups 2 and 5. A fresh verifier and auditor run on the PR heads next.
- Required check "Go quality gates": success on `cf3df7f`; "Windows client executable" and "Clean Windows tool installation": success.
- Actions run: https://github.com/LeornaAI/leorna-client/actions/runs/40973788926 (`cf3df7f`, success). The earlier failure on `db3e6b0`: https://github.com/LeornaAI/leorna-client/actions/runs/40968292489.
- Local receipts (one log per gate plus a summary) are kept with the story's evidence.


