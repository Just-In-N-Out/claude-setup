---
name: live-server-testing
description: "Rules and how-to for agents testing the desktop client against Justin's own control-plane test server (live smoke runs, seeding sessions, real Codex/Claude checks, cleanup)"
metadata:
  node_type: memory
  type: project
  originSessionId: 748ba66f-4c02-494d-836a-b694ca1101f2
  modified: 2026-10-22T23:55:33.430Z
---

Justin's test control plane is where client stories get proven end to end; install, domain and teardown are in [[own-control-plane-install]]. On 2026-10-06 a live run caught a Codex bug that every offline test missed (86bbu3xmt, client PR #14). So any client story that talks to the server should get a live check before the PR.

**Update 2026-10-15:** Justin has a NEW live server for his admin demo video (`leornafed4e439-…`, details in [[own-control-plane-install]] → Servers). It was installed from main, not the old test branch. Ask Justin before using it for client tests.

**Status 2026-10-20 (Hermes check):** the 2026-10-15 and 2026-10-16 servers no longer resolve in DNS (Christian's still does), so they are probably torn down. Before any live test, confirm with Justin and reinstall from main (prebuilt image, [[own-control-plane-install]] step 3), then put the new server in [[own-control-plane-install]] → Servers. The test-branch rule and the fixed domain in the Rules below are obsolete; kept for history.

**Status 2026-10-06: SERVER DELETED** (instance + project Justin-test). The domain and seeded session below no longer exist. Reinstall first ([[own-control-plane-install]] steps 2–9), then replace the domain here with the new one.

## Rules
- **Obsolete since 2026-10-09 (PR #81 merged): install and read server code from main instead.** Old rule: **Server code comes from the local branch.** Before testing, go to the control-plane branch `test/own-server-dev-signin`, merge the latest origin/main into it and fix any conflicts. Install or test from that branch. It stays local; never push it. See [[control-plane-test-branch]].
- **Only Justin's server:** use his current server from [[own-control-plane-install]] → Servers (`leornacc5e1c54-…` was deleted 2026-10-06). Never call Christian's `leornaf73eb3c0-…`, Yan's, or anyone else's.
- **Keep the URL private:** the server runs in dev mode, and anyone who opens `/dev/login` becomes admin. Never paste the URL outside this Mac (no PRs, ClickUp or team chat).
- **Don't change the server side:** a client-story test never changes the server, its admin settings, Scaleway, or the leorna-control-plane repo.
- **Ask before touching Justin's real tools:**
  - Ask before writing into his real tool homes (`~/.codex`, `~/.claude`).
  - Always use a NEW scratch project folder, never one of his repos.
  - Justin runs the interactive tools (`codex`, `claude`) himself.
- **Protect the sign-in:** never print, log or save the sign-in token. Never read the Keychain any way other than `login.New(login.OSVault{}, nil)`.
  - Check that a token exists only by the exit code of `security find-generic-password -s "Leorna Client"`; never use `-w` or `-g`. If a safety check blocks the read, stop and ask Justin.
  - Never read the installer Chrome profile's storage or session (`~/Library/Caches/Leorna/chrome-profile`). This was blocked as credential access.
- **Read the server code that is deployed:** `git show test/own-server-dev-signin:<path>` in the control-plane repo, not origin/main. Server-admin rules (deletes, IAM, no in-place update, teardown order) are in [[own-control-plane-install]].
- **Clean up afterwards:**
  - List everything the run added outside the repo.
  - Back it up in the scratchpad, then remove it only with Justin's OK.
  - Delete the throwaway code.
  - Stop any Leorna client builds you started; they run from scratchpad paths (`pgrep -fl 'scratchpad.*/leorna-client$'`).
- **Tear it down after merge:** the server costs a few euros a day, so tear it down once the stories using it are merged (Christian's rule).
- **Never change CI files** ([[no-ci-changes]]).

## How a live smoke run works (proven 2026-10-06)
- **Signing in:**
  - Build and run the desktop client (step 8 in [[own-control-plane-install]]), connect to the domain, and sign in.
  - The token is kept in the macOS Keychain (service "Leorna Client") and lasts at most an hour.
  - `login.Manager.stored()` deletes an expired token, and the call then fails with "login required". At that point, ask Justin to sign in again in the app.
  - To check the token is there, run `security find-generic-password -s "Leorna Client"` and look only at the exit code.
  - **Never launch the client with a fake `HOME` for sign-in (proven 2026-10-22).** `login.OSVault` goes through go-keyring, which shells out to `/usr/bin/security`, and that finds the login keychain through `$HOME/Library/Keychains`. With an isolated HOME there is none, so macOS shows "Keychain Not Found … auth/<hash>" on every sign-in. Read-only proof: `HOME=<empty dir> security default-keychain` fails ("A default keychain could not be found") while the real HOME prints `login.keychain-db`. Click **Cancel**, never "Reset To Defaults". Sign-in needs the real HOME. Isolate the app's data and the tool folders some other way, or get Justin's OK for the real-home writes.
- **Throwaway program:**
  - Put it at `_smoke/<name>/main.go` in the client repo. The `_` keeps it out of `./...`. Never commit it, and delete it afterwards.
  - Get the company with `onboarding.NewHTTPResolver().Resolve(ctx, domain)`.
  - Create the login manager with `login.New(login.OSVault{}, nil)`. Then use `Client(company)` for responses up to 64 KiB, or `HandoffClient(company)` for up to 32 MiB.
  - macOS asks Justin to allow Keychain access for the new binary.
- **Seeding a session:** the client does not upload captured sessions yet, so seed one through `IngestContextEventsWithResponse` (`POST /v1/client/context/events`).
  - The body is `tool`, `sessionId` and `events`, each event with `seq`, `role`, `content` and `at`.
  - The server keeps messages in ClickHouse and the pack and summary in Mongo. A fetch could read the session immediately (368 ms).
- **Server behaviour to expect:**
  - An unknown session returns 200 with no messages, which `handoff.Fetch` reports as `ErrNoMessages`.
  - The server silently turns unknown roles into "user".
  - A 403 means the account lacks access. Stop and ask Justin; the admin side may need a team.
- **Reusable seeded session (until teardown):** `handoff-smoke-1791321502`.
  - Tool cursor, 5 messages, marker `SMOKE-3377A66E`.
  - Its last user message contains `@./SECRET.md` and `@../../SECRET.md`.

## Tool gotchas on Justin's Mac
- **Codex model:** `~/.codex/config.toml` asks for model gpt-5.4, which his plan no longer offers, so Codex fails with a 400. **Since 2026-10-16 gpt-5.5 is refused too; `gpt-5.6-luna` works** (Justin picked it with `/model`). Pass `-c model="gpt-5.6-luna"` or use `/model`, and don't edit his config. Codex auto-updates (0.163.0 on 2026-10-16); rerun the real Codex tests after an update.
- **Codex resume picker:**
  - Esc starts a NEW session; quit with Ctrl+C.
  - If it says "Cannot use the background server", choose "Run without daemon this time".
- **State kept outside the session file:** include it all in cleanup lists.
  - Codex: `state_5.sqlite` thread rows, `history.jsonl`, `session_index.jsonl`, and trust entries in `config.toml`.
  - Claude: trust entries in `~/.claude.json`, and transcripts under `~/.claude/projects/`.
- **Claude `@` paths:** Claude resolves `@./x` in `.claude/rules/*.md` relative to `.claude/rules/`. To point at the project root in a test, use `@../../x`.
- **Real-tool tests:** start from a tool home that has been used before, and drive the same path the UI uses. A brand-new home is what hid the Codex bug.
