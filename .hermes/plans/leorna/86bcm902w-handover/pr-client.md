## Summary

Adds the client half of content usage analytics: a new `import-content-usage` command reads transcripts an engineer picks, finds uses of the skills and prompts Leorna's last Sync installed, and uploads them to the control plane's content usage page. Claude Code: each `Skill` tool call and each typed `/name` command, in sessions run in the project folder Sync wrote to. Codex: the first read of `.agents/skills/<name>/SKILL.md` per session (inferred; Codex has no skill event). Cursor and agents are not measurable, and the command says so instead of sending zeros. Only identifiers leave the machine: a stable ID derived from the transcript's own IDs (so a re-import counts nothing twice), the tool, the kind, the item name, the time and the project. Never transcript text, command arguments, paths, folder names, or the names of personal skills and commands. The command reads the desktop database read-only and never changes it. Nothing is uploaded automatically. The contract copy is refreshed from the control plane, which also brings in the pack operations the client snapshot was missing (generated code only). Needs the matching control-plane PR (same branch name) merged first. No CI change.

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
  - `application/managed_items_test.go`: the last successful Sync per tool, installed files only, read-only open never migrates, the default path.
  - `cmd/import-content-usage/main_test.go`: sends only identifiers, sends nothing without uses, refuses bad flags before sending.
  - `usage/testdata/items/`: synthetic Claude Code and Codex fixtures modelled on the verified shapes, and `upload.golden.json`, byte-identical to the control plane's copy.
- `README.md`: section "Content usage import (story 86bcm902w)": command, flags, what is counted, what is sent and what never is, and what happens against an older control plane.

## Test Plan

Everything below ran on 2026-10-29 on head `db3e6b0` (base `f105e27`, which is still GitHub `main`), with the control plane at `de5fbe0`, by the pipeline's independent verifier and then a blind AC auditor. Tools: Go 1.27.3, Node 22, golangci-lint 2.14.0 and govulncheck v1.7.0. Hosted CI has not run: nothing is pushed yet.

- [x] `make check` (boundary check, generated API check, vet, `go test -race`, build): exit 0.
- [x] `node --test scripts/*-ui.test.cjs`: 39 of 39 pass.
- [x] `make lint audit` with golangci-lint 2.14.0 first on PATH: 0 issues, no vulnerabilities.
- [x] Story tests by name (`./usage`, `./application`, `./cmd/import-content-usage`): 15 of 15 pass (verifier and auditor).
- [x] Real Claude Code 2.1.312 (`TestRealClaudeCodeTranscriptItemUses`, isolated home): pass; 3 sessions, 1 prompt use, 1 skill use. A typed `/skill` is recorded as a command line, as the write-up says.
- [x] Cross-repo ties: `cmp` of `usage/testdata/items/upload.golden.json` with the control plane's `internal/web/testdata/content_usage_client_upload.json`, and of `api/control-plane.openapi.yaml` with the control plane's `contracts/control-plane.openapi.yaml`: both exit 0. The control plane's AC2 test posts this golden body.
- [x] End to end on loopback (builder; client `db3e6b0`, control plane built from the story's earlier head `e184d9b`, `vcs.modified=false`, whose upload path the later fix commits didn't change): a real client Sync to Claude Code, Codex and Cursor, then the built `import-content-usage` against synthetic transcripts: Claude Code 3 uses (2 skill, 1 prompt), Codex 1, the same counts on re-import with nothing doubled on the page, Cursor refused with exit 1.
- [x] Mutation checks (overlay only, never the worktree):
  - builder: 13 of 13 killed (synced-items guard, identifiers only, read-only open, old-database refusal, project folder rule);
  - verifier: 4 of 5 killed; the survivor drops a record-type filter that the payload-type switch already covers;
  - reviews: the survivors are follow-ups 2 and 5.
- [x] Scope: no `.github/` path and no `CLAUDE.md` in the diff; all 6 commits by the Leorna identity with no AI attribution lines.
- [x] GitHub `main` is still `f105e27`: nothing to bring in.
- [ ] Hosted CI: not run yet (not pushed).

## Assumptions

- Merge the control-plane PR first. Against a control plane without it, the command fails with "usage upload rejected; verify login and server availability" and nothing is stored; `import-codex-usage` is unaffected. The README's link to the spike write-up resolves once that PR merges.
- An explicit command, not an automatic upload (approved option). The separate "Upload usage automatically after Sync" card should call these detectors and `ManagedItems` rather than add its own.
- Only items the last Sync installed can leave the machine (approved option); with no successful Sync for a tool, nothing is sent for it. A stale project selection on a read-only database is treated as no selection, so nothing extra is sent.
- Claude Code sessions started in a subfolder of the synced project don't count (same conservative rule as the chat reader). Codex is counted once per session, from the first `SKILL.md` read.
- The command authenticates like the Codex importer, with the admin console's session and CSRF values from the environment; the desktop-token route has no client caller yet.
- The Cursor error reads "item use is not measurable for Cursor; nothing was sent", because CI's staticcheck refuses an error string that starts with a capital.
- No CI change. CI doesn't compare this repo's OpenAPI snapshot with the control plane's (control-plane PR, follow-up 5).

## Follow-ups (not in this PR)

1. Codex: count only reads under the user's `$HOME/.agents/skills`; today a repository's own `.agents/skills/<name>/SKILL.md` with a synced item's name also counts (review 1 R1-5).
2. Test the `-server` path rule (review 1 R1-4) and the Claude Code folder match through symlinks (review 2 R2-2); each survives a mutant today.
3. `ManagedItems` reads the newest Sync per tool from `run_logs`, which records no company or server: after switching company, the earlier company's Codex Sync still marks its skills as managed until a Codex Sync for the new company runs. Scope it before "Upload usage automatically after Sync" reuses it (review 2 R2-3).
4. The real Claude Code test pins only typed `/commands`; add a model-driven `Skill` call (review 2 R2-4).
5. Test strength: two detector guards survive a mutant in review 1's receipt without being filed as findings: Claude Code lines without a `uuid` are skipped, and a Codex use needs the session ID.

## Evidence

- Head: `db3e6b0f76652088c11fafa8c3c54509f62116f7` (base `f105e27`). The local gates above ran on this head.
- CI: pending (not pushed).
- Local receipts (one log per gate plus a summary, mutation tables) are kept with the story's evidence.
