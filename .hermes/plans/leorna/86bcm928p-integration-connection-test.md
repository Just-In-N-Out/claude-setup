# 86bcm928p — Connection test for integrations (plan)

Card: [Connection test for integrations](https://app.clickup.com/t/86bcm928p) (Justin, E14 Integrations, size S, tags pi-2, p2-medium). Repo: `leorna-control-plane` only (the card says "both"; see Q1 and "What each repo needs"). Pipeline: Full. Planned 2026-11-11T01:25Z (2026-11-10 evening EST) by the planner.

**Approval:** the planner brief records that Justin pre-approved this plan with its recommended options on 2026-11-10 ("start the planner when the planner comes back go with recommended and go"). The plan is written as if every ⭐ option was chosen. **No question below blocks the build.** Hand-over only: no push, PR or ClickUp post until Justin says so.

**Everything in "Code" below was built and run by the planner in a scratch copy of base `4ef14ef`** (never in a repo): the 19 unit tests, the three Postgres-backed web tests, the browser pictures, the 19 mutants and both old-code runs. The builder still works test-first, task by task, but should not need to redesign anything.

## Justin's answers (2026-11-10)
Approved by Justin on 2026-11-10 with every ⭐ option: **Q1 A, Q2 A, Q3 A**. His words: "start the planner when the planner comes back go with recommended and go". The questions below are answered; the builder builds the plan as written.

## Questions (answered by the ⭐ options; none blocks the build)

**Q1. Where does Test live: only in the admin console, or also as a JSON API in the OpenAPI contract?**
The Integrations pages are HTML routes of the control plane (`/admin/integrations…`, `internal/web/handler.go:306-308`). None of them is in the OpenAPI contract, which holds only `/v1/…` operations; 927y's Save is a browser form too, and its plan ruled "Browser POST form bodies are not silently added to the public API". The desktop client has no admin console code and nothing that would call a test.
- ⭐ **A.** A console form route only: `POST /admin/integrations/{tileID}/test`. No OpenAPI change, nothing regenerated, the client repo untouched.
- B. Also add a `/v1` JSON operation (OpenAPI, generated code, the client's spec copy). A second surface with no caller today.
- C. Split a JSON API into its own card later, if a caller appears (same as A now; listed as follow-up F1).

**Q2. An address on a private network (a self-hosted GitHub Enterprise Server is often one): refuse it, or let the server connect to it?**
The server fetching an admin-typed address is the classic way to reach things only the server can see (cloud metadata, the database, internal services). Two precedents on main disagree: the custom-domain probe is public-only (`internal/installer/domain/probe.go:68`), the database check allows private ranges (`internal/cloud/dbcheck/check.go:148`).
- ⭐ **A.** Public internet addresses only. A private, loopback, link-local or metadata address is never dialled and shows "Not checked: … is not a public internet address … engineers' devices may still reach it." Safe default; reversible.
- B. Allow private ranges like the database check (still refusing loopback, link-local and metadata). Lets a compromised admin session probe the server's own network.
- C. An operator setting that lists the private ranges allowed (follow-up F2).

**Q3. What does Test check: the saved settings, or whatever is typed in the form?**
The card says "Given a configured integration". Testing typed values would send an address in the request, which is exactly the input a server-side fetch should not take.
- ⭐ **A.** The saved settings only. The button appears once the integration is saved; the form carries nothing but the CSRF token.
- B. Also a "test before saving" button that sends the typed values. More input to validate and guard.

## Acceptance criteria

The card's two criteria, word for word, each with the one test that proves it (`internal/web`, Postgres-backed, stub MCP servers on a fake network). Supporting tests are under Tests. No criterion needs Justin: every check runs on this desktop.

- AC1: Given a configured integration, when I click Test, then reachability of the URL / MCP endpoint is checked and the result shown (without needing a user's credentials) — proven by `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`: the saved integration's page has a Test connection button whose POST shows a result panel; a stub MCP server that answers `initialize` is "Connected"; an endpoint that answers 401 is "Reachable … asks for sign-in" and passes, with no `Authorization`, cookie or credential reference sent; an entered address and its hosted MCP endpoint are both checked; a server that runs on the engineer's device is listed as not tested from the server; before anything is saved there is no button and a test is refused; the test changes no saved settings and writes no change record.
- AC2: Given a failure, then the message says what failed (DNS, TLS, unreachable, not an MCP endpoint) — proven by `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`: one subtest per kind against a controlled failure (a name the resolver does not know, a certificate from an unknown authority, a closed port, an HTTPS page that is not MCP); each shows its own exact message starting with its step ("DNS failed:", "TLS failed:", "Unreachable:", "Not an MCP endpoint:"), names the host, names no other step, differs from the other three, leaves the healthy address line "Reachable", and the same test passes once the endpoint is fixed.

**Old-code behaviour the verifier and auditor should expect** (base = `4ef14efb46da789aec30fad1e5a988d8770140e2`), both proven by the planner:
- Base plus head's `internal/web/integration_connection_test.go` and the whole new package `internal/integration/connectiontest/` (the AC test imports it): both tests end `[build failed]` with `f.handler.SetIntegrationConnectionTest undefined` (a build failure of the new code, which `ac-check.sh` accepts). Without the new package copied in, Go prints `[setup failed]`, which counts as never run.
- Better, so each criterion fails on its own line: also add a one-function shim file to the base copy's `internal/web` (say so in the log's second line): `func (handler *Handler) SetIntegrationConnectionTest(*connectiontest.Tester) {}`. Then the first test fails with `connection test POST clickup status=405 want=404`, `the saved integration's page has no Test connection button` and `connection test POST github status=405 want=200`; the second with `connection test POST github status=405 want=200` in all four kinds and `saw 0 distinct failure messages, want 4`. (405 because base has no such POST route and `GET /` catches the path.)

## Playback

An admin who has just saved an integration's company settings (a tile from 927y's catalog) wants to know it works before rolling it out. On the tile's page they click **Test connection**. The Leorna server checks, with nobody's credentials, that what was saved can be reached, and shows one plain line per thing it checked. When something fails, the line says which step failed: DNS, TLS, unreachable, or "not an MCP endpoint". Nothing is saved or changed by a test.

## Base, dependencies and host

- **Base:** control plane GitHub `main` = `4ef14efb46da789aec30fad1e5a988d8770140e2` (read 2026-11-11T00:52Z and again at 01:30Z; the main checkout's `origin/main` and local `main` both equal it). The builder re-reads GitHub main in Task 0 and uses what it finds.
- **Client:** not touched. For the record, client GitHub `main` moved during planning from `f3bc960` to `a7839b3af664efcfa59eb1ed3fe276ec1262a4de` (PR #32 merged 2026-11-11T00:49Z).
- **Dependency:** 86bcm927y (tiles UI) is merged (PR #112). This story builds on its page (`internal/web/integrations.go`), its saved configuration (`integration.Configuration`, migration 28) and 927v's tile format (`internal/integration/tile.go`).
- **Host (checked 2026-11-10, nothing installed or changed):** `make` 4.4.1 and `gcc` on PATH; Go 1.27.3 at `~/.local/leorna-toolchain/go/bin` (off PATH; `CGO_ENABLED=1`); `golangci-lint` 2.14.0 and `govulncheck` v1.7.0 at `~/.local/leorna-toolchain/bin` (both CI's pins, `.github/workflows/ci.yml:137,151`); gitleaks 8.30.1 at `/usr/local/bin`; Docker running; images `mirror.gcr.io/library/postgres:18.6-alpine3.23` and `mirror.gcr.io/clickhouse/clickhouse-server:25.8` already local; Chrome for Testing at `~/.cache/chrome-for-testing/chrome-linux64/chrome` with `~/.cache/chrome-libs`; `tofu` is not on PATH but good 115,019,938-byte copies sit in `~/.cache/*/bin/tofu`. The shared `leorna-test-pg` container is stopped (Exited 255, 10 days ago); this plan uses owned containers, so nothing is missing. earlyoom: no kills during planning.

## What each repo needs (the card says "both")

- **Control plane:** everything. The admin console is served by the control plane; the test runs on the server.
- **Client: nothing.** Evidence: the client's only integration code is the generated API for `GET /v1/client/integration-tiles` and the `toolconnector` fixtures; it has no admin console (`git grep -i 'admin/'` over its Go code finds nothing outside tests and vendor). With Q1 ⭐A there is no OpenAPI change, so no contract copy to regenerate. Rendered tile output does not change, so no client fixture PR (`internal/integration/testdata/rendered/` is untouched).
- `ac-check.sh` runs with `--repo` = the control-plane worktree; both AC tests live there.

## What Test checks, and what counts as a pass

A saved configuration gives the server a short list of **targets** (`connectiontest.Targets`):

| Target | Where it comes from | What the server does | Pass |
| --- | --- | --- | --- |
| Address | every `url` parameter the admin entered (GHE.com address, Enterprise Server address), in the tile's order | look the name up once, connect, verify the certificate. No HTTP request | "Reachable: … was found, accepted a connection and has a valid certificate." |
| MCP endpoint | every hosted server (`url`) of the saved rendered template, by name | the same, then **one** MCP `initialize` request | "Connected: … answered the MCP handshake." or "Reachable: … asks for sign-in (HTTP 401)…" |
| Local MCP server | every command server (`command`) of the template, e.g. Enterprise Server's Docker server | nothing: it starts on the engineer's device | listed as "Not tested: this server is started on the engineer's device…" (not a failure, not a gap) |

**"MCP endpoint" for a pass** means the Streamable HTTP transport, the only remote transport 927v's format renders (Claude Code gets `"type": "http"`, `internal/library/render/testdata/client/golden/integrations/clickup--cloud/claude-code/.mcp.json`): an HTTPS POST of a JSON-RPC `initialize` request (`protocolVersion` `2025-06-18`, `Accept: application/json, text/event-stream`), answered with HTTP 200 and a JSON-RPC 2.0 result for our id that names a `protocolVersion`, either as `application/json` or as the first matching event of a `text/event-stream`.

**When the endpoint needs sign-in:** HTTP 401 is a pass, shown as "Reachable: <host> answered and asks for sign-in (HTTP 401). This test uses nobody's credentials, so it stops here. Engineers sign in on their own devices." Proven live by the planner on 2026-11-10 with the production prober: both shipped hosted endpoints (`https://api.githubcopilot.com/mcp/`, `https://mcp.clickup.com/mcp`) answer an unauthenticated `initialize` with 401 and `WWW-Authenticate: Bearer … resource_metadata=…`. So for today's GitHub.com and ClickUp tiles the real result is this line; "Connected" appears for servers that allow an anonymous handshake (the stub, future tiles, custom integrations). The test never retries with credentials and never reads the token template.

**Failures, one per step** (AC2), each with its own message:

| Step | When | Message |
| --- | --- | --- |
| DNS | the name does not resolve (or the lookup times out) | "DNS failed: the name <host> could not be found. Check the address for typos." |
| Unreachable | no checked address accepts a TCP connection (refused or timed out) | "Unreachable: <host> did not accept a connection on port <port> (refused or timed out)." |
| TLS | connected, but the handshake or certificate check fails (unknown authority, wrong name, expired, not TLS) | "TLS failed: <host> accepted a connection, but a secure connection with a valid certificate for that name could not be set up." |
| Not MCP | a verified connection, but no MCP reply: any other status (3xx, 403, 404, 5xx), a web page, other JSON, a JSON-RPC error, a reply to another id, an oversized or endless reply, or silence | "Not an MCP endpoint: <host> answered (HTTP <status>), but not with an MCP reply." (or "… accepted a secure connection but sent no MCP reply.") |

**Not attempted** (neither pass nor failure): "Not checked: <host> is not a public internet address…" (Q2), "Not tested: this server is started on the engineer's device…", and "Not checked: this address could not be tested this time." (the 15 s budget ran out, or a stored address is malformed).

**The verdict line** above the lines: "Connection test passed." (nothing failed, at least one pass, nothing left unchecked; a local server is not a gap), "Connection test failed. The lines below say which step failed." (any of the four failures), or "Connection test incomplete: nothing failed, but the Leorna server could not check everything." A finished test always answers HTTP 200.

## Security design (`security-best-practices`: GO-SSRF-001, GO-HTTPCLIENT-001)

The server connects to an address an admin typed, so every guard has a test and a mutant (Task 9).

| Guard | How | Test | Mutant |
| --- | --- | --- | --- |
| Public addresses only: private, loopback, link-local (cloud metadata), CGNAT, unspecified, IPv6 unique-local, site-local, IPv4-mapped and NAT64 forms are never dialled | `domain.PublicAddress` (the custom-domain probe's rule, reused, not copied) on every resolved address and on IP literals; no switch turns it off, in tests either | `TestProbeRefusesAddressesThatAreNotPublic` (13 answers + 5 literals, zero dials), guards subtest "a private address is never dialled…" | M1, M2, W4 |
| A name that answers with one public and one private address is refused | every address must pass, not just the one dialled | same test, "one public and one private" | M2 |
| DNS rebinding | the name is looked up once; the connection goes to the checked IP, with the name used only for the certificate check | `TestProbeResolvesOnceAndDialsOnlyTheCheckedAddress` | M4 |
| Redirects are never followed (a public host cannot bounce the server inside) | `CheckRedirect` returns the 3xx as the answer; the probe owns exactly one connection | `TestProbeNeverFollowsARedirect` | M3 |
| No credentials or secrets leave | a fixed request: three headers, the `initialize` body. No proxy, cookie jar, `Authorization`, or anything from the template (its `Bearer ${VAR}` header is never read) | `TestProbeSendsNoCredentialsAndKeepsNothingFromTheReply`, AC1 sign-in subtest | M5 |
| Nothing from a reply is shown or stored | a result holds only the saved host, the port and the HTTP status number; messages are fixed sentences; `html/template` escapes the host | same test (marker in body, headers and server name), guards subtest "nothing a server replies with reaches the page" | by construction (no text field); M9 for the reply check |
| Time and size bounds | 6 s per target, 15 s per test (under the server's 30 s write timeout), 3 s per dial, at most 3 addresses, 16 KiB of headers, 64 KiB of body | `TestProbeBoundsTimeAndReplySize` | M6 |
| Certificates are verified (system roots, TLS 1.2+) | `tls.Config` with the host as `ServerName`; no skip-verify | `TestProbeNamesTheStepThatFailed` (unknown authority, wrong name) | M13 |
| The request cannot name an address | the form may carry only `csrfToken`; anything else is 400 before any lookup; what is tested is the stored, already validated configuration | guards subtest "the form cannot name an address to test" | W2 |
| Bounded load | at most 2 tests run at once per server; a third is refused with 429 | `TestTesterRunsAtMostTwoTestsAtOnce` | M11 |
| HTTPS only | a target must be an `https://` URL with a host and no user info (tile validation already guarantees it; rechecked) | `TestProbeLeavesOutWhatItCannotTest`, `TestTargetsRefuseSettingsThatDoNotFitTheDefinition` | covered by the tests' cases |

Accepted and stated: an admin can make the server open a TLS connection to any public host and port their tile validation accepts and learn which step failed (that is the feature). It is admin-only, CSRF-checked, two at a time, 6 s each.

## Who can run a test (`multi-tenant-auth-management`)

- The route is `requireSession` + `requireAdmin` + the shared form/CSRF helper `adminFormLimit` (`internal/web/cloud_plan.go:99`): a signed-out visitor gets 401, a member 403 `ADMIN_REQUIRED`, a wrong CSRF token 403.
- The tester reads the configuration through `integration.Service.Configuration(ctx, actor, tileID)` → `GetIntegrationConfiguration` → `beginOrg(ctx, actor, true)`, which re-checks the persisted administrator role and scopes the row by `tenant_id` (`internal/store/postgres/integrations.go:144-152`). A tile is addressed by its shipped id (`github`), never by a row id, so one company cannot name another company's row: its own test reads its own row or gets "not found".
- Tests: guards subtests "a member…", "a signed-out visitor…", "a wrong CSRF token…", "another company's administrator cannot test this company's integration" (404, zero connections, the other company's address not shown) and "another company's test checks only its own saved address"; `TestTesterChecksOnlyTheActorsOwnCompanyConfiguration` (M10); W1 for the route guard (the test tells the route's `ADMIN_REQUIRED` from the store's second check).
- Google Workspace (configuration unavailable, 927y) cannot be tested, legacy rows included: 409 with the existing reason, before any read or connection (M12).

## Change audit: a test run is not recorded

The change history (`/admin/audit`) records changes to company data with before and after values. A test changes nothing and stores nothing, so there is no before or after to record, and a record per click would bury real changes. AC1's test pins it: the configuration rows and the audit rows are byte-equal before and after a test. No new server log line either: no admin handler logs successful actions today, and a story should not start that pattern (follow-up F7).

## Approach

One new package and a small page change, no migration, no OpenAPI change:

- `internal/integration/connectiontest` (new): `Prober` (the network part: resolve once, check addresses, connect, verify the certificate, one `initialize`), `Targets` (what a saved configuration gives to check), `Tester` (reads the actor's own configuration through `integration.Service`, bounds concurrency and time, returns a `Report`), and the messages. The zero-value `Prober{}` is production; its exported `Resolver`, `DialContext`, `RootCAs` and `Timeout` fields let tests stand in a fake internet, as `dbcheck.Checker` does (`internal/cloud/dbcheck/check.go:35-44`). None of them turns the address rule off.
- `internal/web`: `POST /admin/integrations/{tileID}/test` → `integrationTest` (new file), which reuses `loadIntegrationPage` and `renderIntegration`; the page template gains a "Test connection" panel (only when settings are saved, the tile is configurable and the tester is wired) and a "Connection test result" panel. The result is rendered in the POST's own response; nothing is stored.
- `cmd/control-plane/main.go`: wire `connectiontest.New(integrations, &connectiontest.Prober{})`.
- `integration.NewService`'s signature and the `integration` package's code are unchanged (only its README).

**How tests avoid the real internet while keeping the address rule on:** a fake network is the prober's resolver and dialer. Names resolve to made-up public addresses (`93.184.216.x`); a dial to one of those is routed to a loopback `httptest` TLS stub; a test authority signs a certificate per host name, and the prober trusts only that authority. A name the fake does not know does not exist; an address with no route cannot be dialled. So the AC tests can use the real tiles' real host names (`mcp.clickup.com`, `api.githubcopilot.com`, `copilot-api.acme.ghe.com`) without one packet leaving the machine.

## Choices

1. Console form route only; no OpenAPI change; client untouched (Q1 ⭐A; 927y's precedent).
2. Public addresses only, reusing `domain.PublicAddress` (Q2 ⭐A).
3. Test the saved settings; the form carries only the CSRF token (Q3 ⭐A).
4. 401 is a pass ("Reachable … asks for sign-in"); 403 and every other status are "Not an MCP endpoint (HTTP <status>)". Only 401 was proven against real servers, so only 401 is treated as sign-in.
5. An address target stops after the certificate check (no HTTP request): fewer bytes sent to an arbitrary host, and "reachable" needs no more.
6. The result is shown in the POST's response and not stored: no migration, no "last tested" state to go stale (follow-up F5).
7. No audit record and no new log line (see Change audit).
8. HTTP/1.1 only for the one request (simplest client that still reaches every HTTPS server; proven against GitHub's and ClickUp's endpoints).
9. No `notifications/initialized` and no session `DELETE` after a successful handshake: the test sends exactly one request (follow-up F6).
10. The browser pictures come from an opt-in test in the repo (like 927y's `TestIntegrationsBrowserJourneyWithPostgres`), so the verifier and auditor can each take their own into their own folder.

## Assumptions

- The card's "URL / MCP endpoint" means: the addresses the admin entered, and the hosted MCP endpoints of the saved template. A local command server has nothing to reach from the server.
- "Without needing a user's credentials" means the test sends none and still gives a useful answer; it does not mean it can prove MCP behind sign-in.
- One deployment is one company's server, so a process-wide limit of two concurrent tests is enough.
- The control plane can make outbound HTTPS connections directly (no egress proxy): the custom-domain probe already assumes this (`probe.go:93`, `Proxy: nil`).

## Files and areas touched

| File | Change |
| --- | --- |
| `internal/integration/connectiontest/prober.go` | new: targets, outcomes, messages, the prober |
| `internal/integration/connectiontest/tester.go` | new: `Targets`, `Report`, `Tester` |
| `internal/integration/connectiontest/network_test.go`, `prober_test.go`, `tester_test.go`, `live_test.go` | new: fake network, 19 tests, one opt-in live test |
| `internal/web/integration_connection.go` | new: `SetIntegrationConnectionTest`, `integrationTest` |
| `internal/web/integration_connection_test.go` | new: fake network for the fixture, the two AC tests, the guards test |
| `internal/web/integration_connection_browser_test.go` | new: opt-in browser pictures |
| `internal/web/handler.go` | one field, one import, one route |
| `internal/web/integrations.go` | two page fields, one line in `loadIntegrationPage`, two template panels |
| `cmd/control-plane/main.go` | wiring (4 lines) |
| `internal/integration/README.md`, `internal/web/README.md` | a section and a paragraph |
| `delivery/stories.json` | the story's entry, appended last |

Not touched: `contracts/`, `packages/contracts/`, migrations, `.github/`, the `integration` package's Go code, tiles and rendered testdata, the client repo.

## Overlap with sibling work (checked 2026-11-11T00:5xZ)

- **Control-plane PR #113** (86bcx2a33, GitHub MCP library item): shares only `delivery/stories.json` (both append at the end; the second to merge keeps both entries). It adds `internal/integration/library_template_test.go` (a new file in the parent package; no conflict) and edits `internal/web/packs_test.go` (not edited here; this story only calls its fixture).
- **Local unmerged branches** `feat/86bcm928t-…` (`a6378b0`), `feat/86bcm927y-…` (`9bffa93`), `feat/86bccndx6-…` (`ec30165`), `feat/86bcm901b-…` (`1c1d276`): each differs from main only in `delivery/stories.json` (PR-number records, and one delivery note for ndx6). `feat/86bcm9284-source-repin` touches only `internal/library/render/testdata/client/SOURCE.md`. None touches this story's files.
- **Client** PR #29 (GitHub MCP fixture) and branch 86bcm928h (per-user credentials): no overlap; the client is untouched.
- **Migrations:** none here. For the record the next free number on main is 32 (`000031_cost_alert_refresh` is the last).
- So this story can be built in parallel with all of them.

## Tasks

Estimate: about 2.5 hours for the builder (the code is given; most time is gates). Every role keeps its scratch in its own new folder (`mkdir` without `-p`): builder `~/.cache/86bcm928p-builder/`. Every `go test` that runs Postgres or a mutant runs under a memory cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (8G for `make check`). A command that dies with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. Don't end a turn to wait for a background command: wait in the foreground with bounded polls under 3 minutes.

### Task 0 — Worktree, tools and owned databases (≈10 min)

1. `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` → record as `BASE` (expected `4ef14ef…`; if main moved, use the new SHA and say so). Fetch it: `git -C /home/justin/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, then check `git -C /home/justin/Leorna/leorna-control-plane rev-parse origin/main` equals `BASE`. If the main checkout is on `main` with no tracked changes (`git status -sb`; an untracked `.claude/` is only worktrees), run `git -C /home/justin/Leorna/leorna-control-plane merge --ff-only origin/main`; if it refuses, stop and report.
2. `git -C /home/justin/Leorna/leorna-control-plane worktree add -b feat/86bcm928p-integration-connection-test /home/justin/Leorna/86bcm928p-integration-connection-test "$BASE"`. If a `CLAUDE.md` exists there, add it to that repo's `.git/info/exclude` (never commit it). Run every workspace gate from this worktree, never the main checkout.
3. `mkdir ~/.cache/86bcm928p-builder ~/.cache/86bcm928p-builder/tmp ~/.cache/86bcm928p-builder/bin`. Copy one existing `~/.cache/*/bin/tofu` of 115,019,938 bytes into `bin/` and check `~/.cache/86bcm928p-builder/bin/tofu version` (unpiped) prints 1.12.6. Start the databases, the password in a 600 env file, never on a command line:
   ```bash
   umask 077; B=~/.cache/86bcm928p-builder
   printf 'POSTGRES_PASSWORD=%s\nPOSTGRES_USER=leorna\nPOSTGRES_DB=leorna_928p_builder_test\n' "$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')" > "$B/pg.env"
   docker run -d --rm --name 928p-builder-pg --memory 1g --env-file "$B/pg.env" -p 127.0.0.1::5432 \
     mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f
   docker run -d --rm --name 928p-builder-ch --memory 2g -e CLICKHOUSE_DB=leorna_metrics -e CLICKHOUSE_USER=leorna_test -e CLICKHOUSE_PASSWORD=local-integration-only -p 127.0.0.1::8123 \
     mirror.gcr.io/clickhouse/clickhouse-server:25.8@sha256:0152dd511befe6a2c2ef53e930726179669b08116da78500b37c51c96ff5ee77
   ```
   (Images and settings are CI's, `.github/workflows/ci.yml:31-60`; the ClickHouse password is CI's public test value; if Docker has only the untagged digest, the pull is a no-op.) Wait for `docker exec 928p-builder-pg pg_isready -h 127.0.0.1 -U leorna -d leorna_928p_builder_test` (TCP, not the socket) and `curl -s http://127.0.0.1:<chport>/ping`. Create the old-code DB: `docker exec 928p-builder-pg createdb -U leorna leorna_928p_base_test`.
4. Write `~/.cache/86bcm928p-builder/env.sh` and `source` it in every shell:
   ```bash
   B=$HOME/.cache/86bcm928p-builder
   export PATH=$B/bin:$HOME/.local/leorna-toolchain/go/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local TMPDIR=$B/tmp
   export LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
   export GOLANGCI_LINT=$HOME/.local/leorna-toolchain/bin/golangci-lint GOVULNCHECK=$HOME/.local/leorna-toolchain/bin/govulncheck
   pw=$(sed -n 's/^POSTGRES_PASSWORD=//p' "$B/pg.env"); [ -n "$pw" ] || { echo "empty Postgres password" >&2; return 1; }
   pgport=$(docker port 928p-builder-pg 5432/tcp | sed 's/.*://'); chport=$(docker port 928p-builder-ch 8123/tcp | sed 's/.*://')
   export LEORNA_TEST_DATABASE_URL="postgres://leorna:${pw}@127.0.0.1:${pgport}/leorna_928p_builder_test?sslmode=disable"
   export LEORNA_TEST_BASE_DATABASE_URL="postgres://leorna:${pw}@127.0.0.1:${pgport}/leorna_928p_base_test?sslmode=disable"
   export LEORNA_TEST_CLICKHOUSE_URL="http://127.0.0.1:${chport}"
   ```
   Check `go version` (go1.27.3), `go env CGO_ENABLED` (1), `"$GOLANGCI_LINT" --version` (2.14.0) and `"$GOVULNCHECK" -version` (v1.7.0). Never print the DB URL; logs say "Postgres: owned container". Commit from a shell where `HOME` is the real home (the Leorna identity and hooks come from `~/.gitconfig`).
5. **Done:** worktree on `BASE`, two containers healthy, env file sourced.

### Task 1 — The prober, test first (≈15 min)

1. Create `internal/integration/connectiontest/network_test.go` and `prober_test.go` from "Code" below.
2. RED: `go test -count=1 ./internal/integration/connectiontest/` → `[build failed]` (`undefined: Prober`, `Target`, …). That is the only possible RED for a new package.
3. Create `prober.go` from "Code".
4. GREEN: `go test -count=1 -v -run 'TestProbe' ./internal/integration/connectiontest/` → 11 tests pass in under 2 s (`TestProbeBoundsTimeAndReplySize` takes about 0.7 s by design). Then `go test -race -count=3 ./internal/integration/connectiontest/`.
5. If a test hangs, it is a stub handler that never returns: `httptest.Server.Close` waits for it ("httptest.Server blocked in Close after 5 seconds"). The given "silent" stub waits on `r.Context().Done()` for that reason; keep it.
6. Commit: `feat(86bcm928p): probe an address or MCP endpoint without credentials`.

### Task 2 — Targets, report and tester, test first (≈10 min)

1. Create `tester_test.go` and `live_test.go` from "Code". RED: `[build failed]` (`undefined: Targets`, `Tester`, `Report`, `ErrStale`, …).
2. Create `tester.go` from "Code". GREEN: `go test -race -count=1 -v ./internal/integration/connectiontest/` → 19 tests pass, `TestProbeShippedHostedEndpointsLive` skips ("set LEORNA_CONNECTION_TEST_LIVE=1 …").
3. `"$GOLANGCI_LINT" run --timeout=5m ./internal/integration/connectiontest/...` → `0 issues.`
4. Commit: `feat(86bcm928p): connection test targets, verdict and tenant-scoped tester`.

### Task 3 — Old-code check of the two AC tests (≈10 min)

1. Create `internal/web/integration_connection_test.go` from "Code" in the worktree (it does not build yet).
2. `git worktree add --detach ~/.cache/86bcm928p-builder/base "$BASE"`; copy into it `internal/integration/connectiontest/` (all of it) and `internal/web/integration_connection_test.go`.
3. From the base copy, with `LEORNA_TEST_DATABASE_URL="$LEORNA_TEST_BASE_DATABASE_URL"`, under the cap: `( set -o pipefail; echo "HEAD=$(git rev-parse HEAD)"; go test -count=1 -v -run '^TestIntegrationConnectionTestAC1ReachabilityWithPostgres$' ./internal/web; echo "EXIT=$?" ) > ~/.hermes/plans/leorna/evidence/86bcm928p/builder/red-ac1-base.log 2>&1` (same for the AC2 test → `red-ac2-base.log`). Expected: `[build failed]`, `SetIntegrationConnectionTest undefined`.
4. Add the shim file from "Old-code behaviour" to the base copy as `internal/web/zz_base_shim.go`, rerun both into `red-ac1-base-shim.log` and `red-ac2-base-shim.log` (second line of each log: `shim: SetIntegrationConnectionTest does nothing, as on base`). Expected: the 405 and "no Test connection button" lines listed there.
5. **Stop condition:** if either test passes on base, or fails for a fixture reason (a helper behaves differently than this plan assumes), stop and report the log; don't patch around it.
6. `git worktree remove --force ~/.cache/86bcm928p-builder/base`.

### Task 4 — The Test connection button and result (≈15 min)

1. RED in the worktree: `go test -count=1 -run '^TestIntegrationConnectionTest' ./internal/web` → `[build failed]`, `SetIntegrationConnectionTest undefined`.
2. Save "Code: Production patch" as `~/.cache/86bcm928p-builder/production.patch`, run `git apply --check` then `git apply` on it, and create `internal/web/integration_connection.go` from "Code". If main moved and the patch no longer applies, make the same six edits by hand (they are listed in the patch's hunks).
3. GREEN, under the cap: `go test -count=1 -v -run '^TestIntegrationConnectionTest(AC1ReachabilityWithPostgres|AC2FailureMessagesWithPostgres|GuardsWithPostgres)$' ./internal/web` → AC1 5 subtests, AC2 5, guards 11, all pass (about 10 s).
4. Regression family: `go test -count=1 -run 'TestIntegrations|TestIntegrationGovernance|TestPredefinedTiles|TestConfiguredIntegration' ./internal/web` → all pass (927y, 928t and 9284's tests render the same page; about 60 s). Fixture note: the guards test saves `alpha.ghe.com` and `beta.ghe.com`, not `acme.ghe.com`, because the GHE.com tile's own example placeholder puts `https://acme.ghe.com` on every page of that variant, which would defeat a "the other company's address is not shown" check.
5. `go build ./cmd/control-plane ./packages/contracts/... && go vet ./internal/web ./cmd/control-plane`; `gofmt -l internal cmd` prints nothing.
6. Commit: `feat(86bcm928p): Test connection on the Integrations page`.

### Task 5 — Browser pictures, test first (≈15 min; this is the evidence task)

1. Create `internal/web/integration_connection_browser_test.go` from "Code". Without its two env vars it skips; `go vet ./internal/web` must pass.
2. Run it (Chrome needs its library path, no display, and a short profile path):
   ```bash
   mkdir -p ~/.hermes/plans/leorna/evidence/86bcm928p ~/.cache/86bcm928p-builder/ct
   env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu \
     LEORNA_CONNECTION_TEST_EVIDENCE_DIR=$HOME/.hermes/plans/leorna/evidence/86bcm928p \
     LEORNA_INTEGRATIONS_CHROME_BIN=$HOME/.cache/chrome-for-testing/chrome-linux64/chrome \
     LEORNA_INTEGRATIONS_CHROME_TMP=$HOME/.cache/86bcm928p-builder/ct \
     systemd-run --user --scope -q -p MemoryMax=4G -p MemorySwapMax=0 \
     go test -count=1 -v -run '^TestIntegrationConnectionTestBrowserEvidenceWithPostgres$' ./internal/web
   ```
   It clicks the real button in headless Chrome on the real handlers and Postgres, checks the result panel's text, and writes eight PNGs (about 6 s).
3. **One screenshot per criterion, in the evidence root:**

   | Criterion | File | What it shows |
   | --- | --- | --- |
   | 1 | `ac1-connected.png` | ClickUp: "Connection test passed." and "Connected: mcp.clickup.com answered the MCP handshake." |
   | 1 | `ac1-sign-in-required.png` | GitHub.com: passed, "Reachable: … asks for sign-in (HTTP 401)…" |
   | 1 | `ac1-address-and-endpoint.png` | GHE.com: the entered address "Reachable" and its MCP endpoint "Connected" |
   | 1 | `ac1-address-and-local-server.png` | Enterprise Server: address "Reachable", the Docker server "Not tested…" |
   | 2 | `ac2-dns-failed.png`, `ac2-tls-failed.png`, `ac2-unreachable.png`, `ac2-not-an-mcp-endpoint.png` | "Connection test failed…" with that step's message; the address line still "Reachable" |

4. **No banner on evidence images (Justin, 2026-11-10).** An image shows the result only: the admin console page as the browser drew it. It carries no caption, label or note about how it was made: no "terminal capture", "local rendering", test name, stub, SHA, "lines elided" or redaction note. Those facts go in the local receipt (`builder/evidence-<sha7>.log`: the command, the head, the file list with byte counts). The same rule holds for any image a later role makes, a rendered log included.
5. Look at every PNG (Read; in bands of ≤1,300 px if tall) before listing it. Nothing private may show: the pictures have no URL bar, and the hosts on them are the tiles' public vendor names and `acme` examples; there must be no server domain, tenant ID, token or email. Retake after any change to the page or messages.
6. Gate logs per head go to the evidence root as `gates-<sha7>.txt` (Task 7).
7. Commit: `test(86bcm928p): opt-in browser pictures of connection test results`.

### Task 6 — Docs and delivery record (≈10 min)

1. `internal/integration/README.md`: in the "Company configuration (86bcm927y)" section replace the sentence `This does not test provider connectivity or perform sign-in.` with `Saving does not test provider connectivity or perform sign-in; **Test connection** (below) checks reachability on request.` Then append the section in "Docs text: integration README" below, at the end of the file. `go test ./internal/integration` must still pass (`TestTileVettingIsDocumented` reads this file).
2. `internal/web/README.md`: append the paragraph in "Docs text: web README" to the "Configured integrations (86bcm927y)" section, before "## Custom and generated origins".
3. `delivery/stories.json`: append the entry as text, last (replace the final `  }\n}` by `  },\n  "86bcm928p": {\n    "name": "Connection test for integrations",\n    "prs": {\n      "LeornaAI/leorna-control-plane": []\n    }\n  }\n}`). Don't re-dump the file. Check: `python3 -c 'import json;d=json.load(open("delivery/stories.json"));assert list(d)[-1]=="86bcm928p"'`, every earlier entry equal by value to `git show "$BASE":delivery/stories.json`, and `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`. No PR number is added until a PR exists and Justin says so.
4. Every README sentence must be true as written: reread the section against the final messages and limits.
5. Commit: `docs(86bcm928p): connection test notes and delivery record`.

### Task 7 — Gates on the final head (≈30 min, serial)

From the worktree, `source ~/.cache/86bcm928p-builder/env.sh`, one script writing each gate's own log plus one `label EXIT=<rc>` line per gate into `SUMMARY.txt`, all collected in `evidence/86bcm928p/gates-<sha7>.txt`:
1. `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 make check` (env.sh binds `GOLANGCI_LINT` and `GOVULNCHECK` by absolute path; `tofu` is on PATH from `$B/bin`). It must leave `git status --porcelain` empty. Run nothing else of yours beside it. `contracts-check` must regenerate nothing (this story has no contract change).
2. `bash ./scripts/test-module-add.sh` (after `make check`, never alongside it).
3. `python3 -m unittest scripts/test_release.py`.
4. **Postgres + ClickHouse no-skip check:** `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web > pg-<sha7>.json`, then read it per test (Action plus that test's own Output; never `-v` text):
   ```bash
   python3 -I - pg-<sha7>.json <<'PY'
   import json, sys
   out, last = {}, {}
   for line in open(sys.argv[1]):
       try: e = json.loads(line)
       except ValueError: continue
       if not e.get("Test"): continue
       key = (e["Package"], e["Test"])
       if e["Action"] == "output": out.setdefault(key, []).append(e["Output"])
       elif e["Action"] in ("pass", "fail", "skip"): last[key] = e["Action"]
   fails = sorted(k for k, a in last.items() if a == "fail")
   skips = {k: "".join(out.get(k, [])) for k, a in last.items() if a == "skip"}
   env = sorted(k for k, o in skips.items() if "LEORNA_TEST_DATABASE_URL" in o or "LEORNA_TEST_CLICKHOUSE_URL" in o)
   need = ["TestIntegrationConnectionTestAC1ReachabilityWithPostgres", "TestIntegrationConnectionTestAC2FailureMessagesWithPostgres", "TestIntegrationConnectionTestGuardsWithPostgres"]
   missing = [n for n in need if last.get(("github.com/LeornaAI/leorna-control-plane/internal/web", n)) != "pass"]
   for k, o in sorted(skips.items()): print("SKIP", k[1], "|", " ".join(o.split())[-160:])
   print("FAILS", fails); print("ENV-SKIPS", env); print("MISSING", missing)
   sys.exit(1 if fails or env or missing else 0)
   PY
   ```
   Allowed skips are only opt-in live or evidence tests with their own reason; list each in the log. This story adds one in these packages: `TestIntegrationConnectionTestBrowserEvidenceWithPostgres` ("set LEORNA_CONNECTION_TEST_EVIDENCE_DIR and LEORNA_INTEGRATIONS_CHROME_BIN for the connection test screenshots"). With ClickHouse set, no skip may name `LEORNA_TEST_CLICKHOUSE_URL`.
5. **Live run (agent-run, needs the internet; not an acceptance criterion):** `LEORNA_CONNECTION_TEST_LIVE=1 go test -count=1 -v -run '^TestProbeShippedHostedEndpointsLive$' ./internal/integration/connectiontest/ > evidence/86bcm928p/builder/live-<sha7>.log`. Expected: both subtests pass, each logging "Reachable: … asks for sign-in (HTTP 401)…". This is the production prober (system DNS, dialer and certificate roots) against GitHub's and ClickUp's hosted endpoints, sending one unauthenticated `initialize` each. If the network is down, record it as not run; it does not gate the build.
6. Container image (CI's quality job also does it): in a detached copy, `DOCKER_CONFIG=<scratch>/docker BUILDX_CONFIG=<scratch>/buildx docker build --no-cache --file Containerfile --tag 928p-builder:<sha7> .`, then `docker run --rm --entrypoint /usr/local/bin/gitleaks 928p-builder:<sha7> version` prints `8.30.1`; remove the tag after.
7. `git diff --name-only "$BASE"...HEAD` lists only the files in "Files and areas touched": no `.github/`, `contracts/`, `packages/contracts/` or migration path. `git log --format='%an <%ae>' "$BASE"..HEAD` is only Justin's Leorna identity (print "authors: 1 identity, Leorna OK", comparing against `$(git config user.email)`; never print the address); no commit body matches `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive).

### Task 8 — Mutation proofs (≈15 min)

Load `mutation-testing-discipline`. Save "Code: mutants.py" outside the repo (`~/.cache/86bcm928p-builder/mutants.py`) and run, with env.sh sourced and nothing else of yours running: `MUT_REPO=/home/justin/Leorna/86bcm928p-integration-connection-test MUT_OUT=$HOME/.hermes/plans/leorna/evidence/86bcm928p/builder/mutation python3 -I ~/.cache/86bcm928p-builder/mutants.py`. It runs 19 one-line mutants through `go test -overlay` under the 4G cap (the worktree stays clean) and must print `KILLED` for each (about 5 minutes; run it in chunks of ids if a turn limit needs it). The planner's run killed all 19; the first assertion each failed on is in the table.

| Mutant | Guard removed | Test that fails |
| --- | --- | --- |
| M1 | the public-address rule | `TestProbeRefusesAddressesThatAreNotPublic` |
| M2 | "every resolved address must be public" (first only) | `TestProbeRefusesAddressesThatAreNotPublic` |
| M3 | "never follow a redirect" | `TestProbeNeverFollowsARedirect` |
| M4 | "resolve once" (a second lookup, the rebinding answer) | `TestProbeResolvesOnceAndDialsOnlyTheCheckedAddress` |
| M5 | "send no credentials" (an `Authorization` header) | `TestProbeSendsNoCredentialsAndKeepsNothingFromTheReply` |
| M6 | the 64 KiB reply bound | `TestProbeBoundsTimeAndReplySize` |
| M7 | "401 is a pass" | `TestProbeSignInRequiredIsReachableNotAFailure` |
| M8 | "an address check sends no HTTP request" | `TestProbeAddressStopsAfterTheCertificateCheck` |
| M9 | "the reply must answer our request id" | `TestProbeNamesTheStepThatFailed` |
| M10 | "read the actor's own company's settings" | `TestTesterChecksOnlyTheActorsOwnCompanyConfiguration` |
| M11 | "at most two tests at once" | `TestTesterRunsAtMostTwoTestsAtOnce` |
| M12 | "a deferred tile is not tested" | `TestTesterRefusesADeferredTileWithoutReadingOrConnecting` |
| M13 | certificate verification | `TestProbeNamesTheStepThatFailed` |
| W1 | the route's administrator guard | `TestIntegrationConnectionTestGuardsWithPostgres` |
| W2 | "the form carries only the CSRF token" | `TestIntegrationConnectionTestGuardsWithPostgres` |
| W3 | "no button before anything is saved" | `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` |
| W4 | the public-address rule, seen from the page | `TestIntegrationConnectionTestGuardsWithPostgres` |
| W5 | "401 is a pass", seen from the page | `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` |
| W6 | "a TLS failure says TLS" | `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` |

A mutant that survives is a test gap to fix before ready-for-review. A mutant whose anchor no longer matches (`ANCHOR-NOT-UNIQUE`) means the code drifted from this plan: re-point the anchor at the same guard, don't drop the mutant. Count mutants by id with their final outcome.

### Task 9 — Ready for review

Report to the orchestrator: branch, head SHA, base SHA, commits, `git diff --stat "$BASE"...HEAD`, the old-code and head logs per criterion, the gate SUMMARY, the mutation table, the evidence list (each PNG looked at), the skips list, the live run's result, and anything that differed from this plan. Stop at `ready-for-review`. Leave both containers running for the review and verification roles; the finisher removes them (`docker stop 928p-builder-pg 928p-builder-ch`) and `~/.cache/86bcm928p-builder/` after the hand-over. List reusable lessons in `skill_lessons`; edit no skill or memory file.

## Tests

| Proves | Test (exact name) | Package | Kind | Base | Head |
| --- | --- | --- | --- | --- | --- |
| criterion 1 | `TestIntegrationConnectionTestAC1ReachabilityWithPostgres` | `internal/web` | Postgres, real page + stub MCP servers | build fails; with the shim: 405 / no button | pass |
| criterion 2 | `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` | `internal/web` | Postgres, four controlled failures | build fails; with the shim: 405 | pass |
| guards | `TestIntegrationConnectionTestGuardsWithPostgres` | `internal/web` | Postgres: member, signed-out, CSRF, GET, smuggled address, other company (two ways), private address, reply text, Google, unwired | build fails | pass |
| prober | `TestProbeMCPEndpointAnswersTheHandshake`, `TestProbeSignInRequiredIsReachableNotAFailure`, `TestProbeAddressStopsAfterTheCertificateCheck`, `TestProbeNamesTheStepThatFailed`, `TestProbeRefusesAddressesThatAreNotPublic`, `TestProbeResolvesOnceAndDialsOnlyTheCheckedAddress`, `TestProbeNeverFollowsARedirect`, `TestProbeSendsNoCredentialsAndKeepsNothingFromTheReply`, `TestProbeBoundsTimeAndReplySize`, `TestProbeTriesTheNextCheckedAddress`, `TestProbeLeavesOutWhatItCannotTest` | `internal/integration/connectiontest` | unit, fake network, no DB | package missing | pass |
| tester | `TestTargetsFromEachShippedVariant`, `TestTargetsRefuseSettingsThatDoNotFitTheDefinition`, `TestTesterChecksOnlyTheActorsOwnCompanyConfiguration`, `TestTesterRefusesADeferredTileWithoutReadingOrConnecting`, `TestTesterRefusesStaleSettingsWithoutConnecting`, `TestTesterRunsAtMostTwoTestsAtOnce`, `TestReportVerdict`, `TestEveryOutcomeHasItsOwnMessage` | `internal/integration/connectiontest` | unit, fake store and prober | package missing | pass |
| opt-in | `TestIntegrationConnectionTestBrowserEvidenceWithPostgres` | `internal/web` | Chrome + Postgres, writes the pictures | — | pass when its env is set, else skip |
| opt-in | `TestProbeShippedHostedEndpointsLive` | `internal/integration/connectiontest` | real internet, production prober | — | pass when `LEORNA_CONNECTION_TEST_LIVE=1`, else skip |

DoD "happy path + 1 failure": criterion 1 has four happy paths (Connected as JSON and as an event stream, sign-in, address) and the "nothing saved" refusal; criterion 2 is four failures plus the pass after the fix. "Integration tests with a stub MCP server" (the card's Verify): both AC tests drive the real HTTP route and page against `httptest` TLS stubs. The Postgres tests need `LEORNA_TEST_DATABASE_URL` (a database ending `_test`; the owned `928p-builder-pg`, not the stopped `leorna-test-pg`) and gitleaks (`LEORNA_TEST_GITLEAKS_BIN` or PATH), because saving an integration runs the tenant gate. They don't need ClickHouse; the full gate does (five content-usage tests skip without it). No test uses `/dev/login`: sessions come from the fixture's `login`.

For the verifier and auditor: run each AC's test alone by name (`go test -v -count=1 -run '^<name>$' ./internal/web`); take your own pictures by running the opt-in browser test with `LEORNA_CONNECTION_TEST_EVIDENCE_DIR` pointed at your own folder (the worktree stays clean); cite `ac1-connected.png` for the first criterion and one `ac2-…png` for the second.

## DoD

- Unit + integration tests per criterion with a failure case: above.
- OpenAPI: no API change (Q1 ⭐A: an admin HTML form route, like 927y's Save). `make contracts-check` proves nothing regenerates (`api-contract-drift-guard`: the contract diff is empty, nothing to version, no consumer to check).
- Migrations: none (nothing is stored; `backend-data-migrations` not needed).
- Lint/format/CI: `make check` (gitleaks, golangci-lint 2.14.0, govulncheck v1.7.0), the module-add script, the release unittest, the Postgres/ClickHouse no-skip check, the image build. No workflow file changes.
- Demoable in isolation: the browser test's real pages on a local fixture server; the live run against the real hosted endpoints.
- Short module README note and `delivery/stories.json` entry: Task 6.
- No CI change, no auth bypass, no `/dev/login` in tests, no repo-wide pattern change, no `toolconnector.Connector` change.

## Docs & records

Files the build and finish update:
- Plan: this file; the orchestrator's read-only copy `evidence/86bcm928p/plan-approved.md`.
- `internal/integration/README.md` and `internal/web/README.md` (Task 6).
- `delivery/stories.json` (Task 6; the PR number only once a PR exists and Justin says so).
- Evidence: `evidence/86bcm928p/` (`ac1-*.png`, `ac2-*.png`, `gates-<sha7>.txt`), `builder/` (old-code logs, live log, mutation receipts, the evidence receipt), `review-<n>/review.json`, `verifier/ac.json`, `auditor/ac.json`, `follow-ups.md` (F1–F7 below plus review P3s).
- Shared notes (finisher / orchestrator): `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` story state line (card title and id, branch, head, base, not pushed, no PR); hand-over drafts in `evidence/86bcm928p/handover/` (PR text in the plain style, review prompt, ClickUp evidence draft, team message), posted only on Justin's words, the ClickUp comment only after the PR is merged.

## Risks

- **Real tiles show "asks for sign-in", not "Connected".** True and honest, but a wrong path on a host that also answers 401 everywhere would pass. Without credentials nothing more can be proven; the line says so.
- **A private Enterprise Server shows "Not checked".** The most common self-hosted case cannot be tested from the server (Q2). The message says engineers' devices may still reach it; F2 and F3 are the ways forward.
- **False "Not an MCP endpoint".** A firewall or bot filter that answers 403 or a challenge page to an unknown client reads as not MCP, with the HTTP status shown.
- **No egress proxy support.** A deployment that can only reach the internet through `HTTPS_PROXY` shows every target "Unreachable" (same as the custom-domain probe).
- **Up to 15 s for a click.** A black-holed host takes 6 s per target. An operator who set the manifest's write timeout below 15 s could cut the response.
- **Port-scan oracle on public hosts** for an admin, bounded as stated under Security design.
- **Timing in tests.** The bounded-time test allows 3 s for a 700 ms timeout, and fake-network probes get 5 s; under very heavy load rerun a failing timing test alone before calling it a regression.
- **Sibling merge order.** `delivery/stories.json` conflicts textually with whichever story merges first (#113 today); mechanical.
- **Page tests of siblings.** Any future test that counts forms or buttons on a saved tile's page now sees one more form; none on main does (the 927y, 928t and 9284 suites pass).

## Follow-ups (named, not built)

- **F1 JSON API for the test** (`/v1`, OpenAPI, both repos), if a caller appears (Q1 C).
- **F2 Operator setting for private ranges** the server may test (Q2 C).
- **F3 Test from the engineer's device** (client): reaches private servers and, with the engineer's own sign-in, can prove MCP behind 401. Belongs with 86bcm928h's per-user credentials.
- **F4 Other transports** (legacy HTTP+SSE) if a tile ever needs one.
- **F5 Remember the last result** (time and verdict on the tile card): needs storage and a migration.
- **F6 End the MCP session** (`DELETE` with `Mcp-Session-Id`) after a successful handshake, if a server's operators ask.
- **F7 A record of test runs** (audit or server log) if operators want a trail of outbound checks.

## Other things found

- Info: the brief's client main (`f3bc960`) is stale: client PR #32 merged at 2026-11-11T00:49Z, GitHub main is `a7839b3`. No effect here (client untouched).
- Info: the control-plane main checkout's local `main` was 4 commits behind `origin/main` (`d9c6aa8`) when planning began and was fast-forwarded to `4ef14ef` by another session during it; Task 0 still checks.
- Info: the shared `leorna-test-pg` container is stopped (Exited 255, 10 days ago); this plan uses owned containers.
- P3: `docker ps -a` holds 17 exited containers from finished stories and CortexOS (`pma-ndx6-*`, `nf8-*`, `ndx6-f6-*`, `leorna-domain-review1-*`, `leorna-86bccndx6-*`, `ndx6-preview-*`, `cortexos-*`). Not this story's; Justin's to remove.
- P3 (known, Justin's call): `delivery/stories.json` on main lists 86bcm927y and 86bcm928t with empty PR lists (#112 and #114 are recorded only on branch-only commits).

## Completion contract

The builder stops at `ready-for-review` with the Task 9 report. Review → fix rounds follow `review-fix-cadence` until `review-check.sh` prints MOVE ON; then a fresh verifier and a blind auditor prove both criteria on the reviewed head (`ac-check.sh --reviews` must print ALL ACCEPTED; there is no live criterion). Then the finisher prepares the hand-over. Nothing is pushed, no PR is opened and nothing is posted until Justin says "push", "make a PR" or "post".

## Docs text

### Docs text: integration README

```markdown
## Connection test (86bcm928p)

After saving a tile's company settings, an administrator clicks **Test connection** on
the tile's page (`POST /admin/integrations/{tileID}/test`). The Leorna server checks
what was saved, with nobody's credentials, and shows one line per target:

- every address the administrator entered (`url` parameters): the name is looked up,
  a connection is opened and the certificate is verified. No HTTP request is sent.
- every hosted server of the saved template (`url`): the same, then one MCP
  `initialize` request (Streamable HTTP: a JSON-RPC POST that accepts
  `application/json` or `text/event-stream`). A valid `initialize` result is
  **Connected**. HTTP 401 is **Reachable … asks for sign-in**, a pass, because the
  test has no credentials; GitHub's and ClickUp's hosted servers both answer this
  way (checked 2026-11-10).
- every command server (GitHub Enterprise Server's Docker server): **Not tested**,
  because it starts on the engineer's device.

A failure names its step: **DNS failed**, **Unreachable** (refused or timed out),
**TLS failed** (no secure connection with a valid certificate) or **Not an MCP
endpoint** (it answered, but not with an MCP reply; redirects are not followed).

Limits (`internal/integration/connectiontest`): only public internet addresses are
tested (`domain.PublicAddress`); a private, loopback, link-local or metadata address
is "Not checked" and never dialled. The name is resolved once and only the checked
addresses are dialled. No proxy, cookie, `Authorization` header or template header
is sent. Nothing from a reply is shown or stored: a result holds the saved host, the
port and the HTTP status. A target gets 6 seconds, a test 15, a reply 64 KiB, and two
tests run at a time per server. Only an administrator of the company that saved the
settings can run a test, from a CSRF-checked form that carries no address. A test
stores nothing, so it is not in the change history. Google Workspace (configuration
unavailable) cannot be tested.

Tests: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`,
`TestIntegrationConnectionTestAC2FailureMessagesWithPostgres` and
`TestIntegrationConnectionTestGuardsWithPostgres` in `internal/web`, and the `TestProbe…`,
`TestTargets…` and `TestTester…` tests in `internal/integration/connectiontest`. They
run on a fake network, so none reaches a real host. Two opt-in checks:
`TestIntegrationConnectionTestBrowserEvidenceWithPostgres` (set
`LEORNA_CONNECTION_TEST_EVIDENCE_DIR` and `LEORNA_INTEGRATIONS_CHROME_BIN`) clicks the
button in Chrome and saves a picture of the page per result, and
`TestProbeShippedHostedEndpointsLive` (`LEORNA_CONNECTION_TEST_LIVE=1`) probes GitHub's
and ClickUp's hosted endpoints over the real internet.
```

### Docs text: web README

```markdown
`POST /admin/integrations/{tileID}/test` (86bcm928p) runs a connection test for the
administrator's saved settings and renders the result on the same page. It has the
same session, administrator and CSRF checks as a save, and a 4 KiB form that may
carry only `csrfToken`: any other field is 400, so a request cannot name an address.
It answers 404 before anything is saved, 409 for Google Workspace or for settings
that no longer fit the shipped definition, 429 while two tests are already running,
503 when no tester is wired, and 200 with the result otherwise (also when a check
failed). Details and limits are in `internal/integration/README.md`.
```

## Code

Each block is the whole file, byte for byte what the planner ran. Paths are relative to the worktree.

### Code: internal/integration/connectiontest/prober.go (new)

```go
// Package connectiontest checks, from the control plane and without anyone's
// credentials, that a configured integration's addresses can be reached and
// that its hosted MCP endpoints answer the MCP handshake (story 86bcm928p).
package connectiontest

import (
	"bufio"
	"bytes"
	"context"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"errors"
	"io"
	"mime"
	"net"
	"net/http"
	"net/netip"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/installer/domain"
)

// Kind is what a target is, which decides how far the test can go.
type Kind string

// Target kinds.
const (
	// KindAddress is an address the administrator entered: resolve it, connect
	// and verify its certificate. No HTTP request is sent.
	KindAddress Kind = "address"
	// KindMCP is a hosted MCP endpoint in the rendered configuration: as an
	// address, then one MCP initialize request.
	KindMCP Kind = "mcp"
	// KindLocal is a server the engineer's tool starts on their own device.
	// The control plane has nothing to reach.
	KindLocal Kind = "local"
)

// Target is one thing a connection test checks.
type Target struct {
	Kind Kind
	// Label is the parameter's label (address) or the server's name.
	Label string
	// URL is an https URL. It is empty for KindLocal.
	URL string
}

// Title names the target for the administrator.
func (target Target) Title() string {
	switch target.Kind {
	case KindMCP:
		return "MCP endpoint (" + target.Label + ")"
	case KindLocal:
		return "Local MCP server (" + target.Label + ")"
	default:
		return target.Label
	}
}

// Outcome is how one target's check ended.
type Outcome string

// Outcomes. The first three are passes; the next four are the failures the
// administrator can act on, one per step; the rest were never attempted.
const (
	Connected      Outcome = "connected"
	Reachable      Outcome = "reachable"
	SignInRequired Outcome = "sign_in_required"
	DNSFailed      Outcome = "dns_failed"
	Unreachable    Outcome = "unreachable"
	TLSFailed      Outcome = "tls_failed"
	NotMCP         Outcome = "not_mcp"
	AddressRefused Outcome = "address_refused"
	NotTestable    Outcome = "not_testable"
	NotChecked     Outcome = "not_checked"
)

// Result is one target's outcome. Host and Port come from the saved
// configuration and Status is a number: nothing a remote server sent is ever
// copied into a result.
type Result struct {
	Target  Target
	Outcome Outcome
	Host    string
	Port    string
	// Status is the HTTP status of the reply, 0 when there was none.
	Status int
}

// OK reports a pass.
func (result Result) OK() bool {
	return result.Outcome == Connected || result.Outcome == Reachable || result.Outcome == SignInRequired
}

// Failed reports one of the four failures the administrator can act on.
func (result Result) Failed() bool {
	switch result.Outcome {
	case DNSFailed, Unreachable, TLSFailed, NotMCP:
		return true
	}
	return false
}

// Message says in plain words what happened, naming the step that failed.
func (result Result) Message() string {
	host := result.Host
	switch result.Outcome {
	case Connected:
		return "Connected: " + host + " answered the MCP handshake."
	case Reachable:
		return "Reachable: " + host + " was found, accepted a connection and has a valid certificate."
	case SignInRequired:
		return "Reachable: " + host + " answered and asks for sign-in (HTTP 401). This test uses nobody's credentials, so it stops here. Engineers sign in on their own devices."
	case DNSFailed:
		return "DNS failed: the name " + host + " could not be found. Check the address for typos."
	case Unreachable:
		return "Unreachable: " + host + " did not accept a connection on port " + result.Port + " (refused or timed out)."
	case TLSFailed:
		return "TLS failed: " + host + " accepted a connection, but a secure connection with a valid certificate for that name could not be set up."
	case NotMCP:
		if result.Status == 0 {
			return "Not an MCP endpoint: " + host + " accepted a secure connection but sent no MCP reply."
		}
		return "Not an MCP endpoint: " + host + " answered (HTTP " + strconv.Itoa(result.Status) + "), but not with an MCP reply."
	case AddressRefused:
		return "Not checked: " + host + " is not a public internet address. The Leorna server only tests public addresses; engineers' devices may still reach it."
	case NotTestable:
		return "Not tested: this server is started on the engineer's device, so the Leorna server has no address to reach."
	default:
		return "Not checked: this address could not be tested this time."
	}
}

// Resolver looks a host name up. *net.Resolver implements it.
type Resolver interface {
	LookupNetIP(ctx context.Context, network, host string) ([]netip.Addr, error)
}

// Prober runs the checks. The zero value is what production uses: Go's
// resolver, a plain dialer, the system certificate roots and 6 seconds per
// target. The fields exist so tests can stand in a resolver, a network and a
// certificate authority; none of them turns the public-address rule off.
//
// A probe never follows a redirect, never uses a proxy, never sends a cookie,
// an Authorization header or anything from the integration's template, and
// dials only addresses it resolved once and checked with domain.PublicAddress.
type Prober struct {
	Resolver    Resolver
	DialContext func(ctx context.Context, network, address string) (net.Conn, error)
	RootCAs     *x509.CertPool
	Timeout     time.Duration
}

const (
	defaultTimeout = 6 * time.Second
	dialTimeout    = 3 * time.Second
	maxAddresses   = 3
	maxHeaderBytes = 16 << 10
	maxBodyBytes   = 64 << 10
	// requestID is the JSON-RPC id of the one request a probe sends.
	requestID = "1"
)

// initializeRequest is the MCP initialize request (Streamable HTTP transport).
const initializeRequest = `{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"leorna-connection-test","version":"1"}}}`

// Probe checks one target.
func (prober *Prober) Probe(ctx context.Context, target Target) Result {
	result := Result{Target: target}
	if target.Kind == KindLocal {
		result.Outcome = NotTestable
		return result
	}
	parsed, err := url.Parse(target.URL)
	if err != nil || parsed.Scheme != "https" || parsed.Hostname() == "" || parsed.User != nil || (target.Kind != KindAddress && target.Kind != KindMCP) {
		result.Outcome = NotChecked
		return result
	}
	result.Host, result.Port = parsed.Hostname(), parsed.Port()
	if result.Port == "" {
		result.Port = "443"
	}
	if ctx.Err() != nil {
		result.Outcome = NotChecked
		return result
	}
	timeout := prober.Timeout
	if timeout <= 0 {
		timeout = defaultTimeout
	}
	ctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	addresses, outcome := prober.resolve(ctx, result.Host)
	if outcome != "" {
		result.Outcome = outcome
		return result
	}
	conn := prober.connect(ctx, addresses, result.Port)
	if conn == nil {
		result.Outcome = Unreachable
		return result
	}
	defer func() { _ = conn.Close() }()
	if deadline, ok := ctx.Deadline(); ok {
		_ = conn.SetDeadline(deadline)
	}
	secure := tls.Client(conn, &tls.Config{ServerName: result.Host, RootCAs: prober.RootCAs, MinVersion: tls.VersionTLS12, NextProtos: []string{"http/1.1"}})
	if err := secure.HandshakeContext(ctx); err != nil {
		result.Outcome = TLSFailed
		return result
	}
	if target.Kind == KindAddress {
		result.Outcome = Reachable
		return result
	}
	result.Outcome, result.Status = initialize(ctx, secure, target.URL)
	return result
}

// resolve returns the addresses to dial, or the outcome that ends the check.
// The name is looked up once; every address must be public, or none is dialled
// (a name that answers with one public and one private address is refused).
func (prober *Prober) resolve(ctx context.Context, host string) ([]netip.Addr, Outcome) {
	var addresses []netip.Addr
	if literal, err := netip.ParseAddr(host); err == nil {
		addresses = []netip.Addr{literal}
	} else {
		resolver := prober.Resolver
		if resolver == nil {
			resolver = &net.Resolver{PreferGo: true}
		}
		found, err := resolver.LookupNetIP(ctx, "ip", host)
		if err != nil || len(found) == 0 {
			return nil, DNSFailed
		}
		addresses = found
	}
	for index, address := range addresses {
		address = address.Unmap()
		if address.Zone() != "" || !domain.PublicAddress(address) {
			return nil, AddressRefused
		}
		addresses[index] = address
	}
	if len(addresses) > maxAddresses {
		addresses = addresses[:maxAddresses]
	}
	return addresses, ""
}

// connect dials the checked addresses in turn, by IP, and returns the first
// connection. The host name is never resolved a second time.
func (prober *Prober) connect(ctx context.Context, addresses []netip.Addr, port string) net.Conn {
	dial := prober.DialContext
	if dial == nil {
		dial = (&net.Dialer{}).DialContext
	}
	for _, address := range addresses {
		attempt, cancel := context.WithTimeout(ctx, dialTimeout)
		conn, err := dial(attempt, "tcp", net.JoinHostPort(address.String(), port))
		cancel()
		if err == nil {
			return conn
		}
	}
	return nil
}

// initialize sends one MCP initialize request over the verified connection and
// classifies the reply. It reads at most maxBodyBytes of the body.
func initialize(ctx context.Context, conn net.Conn, endpoint string) (Outcome, int) {
	used := false
	transport := &http.Transport{
		Proxy:                  nil,
		DisableKeepAlives:      true,
		MaxResponseHeaderBytes: maxHeaderBytes,
		DialTLSContext: func(context.Context, string, string) (net.Conn, error) {
			if used {
				return nil, errors.New("connection test uses one connection")
			}
			used = true
			return conn, nil
		},
	}
	defer transport.CloseIdleConnections()
	client := &http.Client{Transport: transport, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}
	request, err := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, strings.NewReader(initializeRequest))
	if err != nil {
		return NotMCP, 0
	}
	request.Header.Set("Content-Type", "application/json")
	request.Header.Set("Accept", "application/json, text/event-stream")
	request.Header.Set("User-Agent", "Leorna-Connection-Test")
	response, err := client.Do(request)
	if err != nil {
		return NotMCP, 0
	}
	defer func() { _ = response.Body.Close() }()
	if response.StatusCode == http.StatusUnauthorized {
		return SignInRequired, response.StatusCode
	}
	if response.StatusCode != http.StatusOK {
		return NotMCP, response.StatusCode
	}
	media, _, _ := mime.ParseMediaType(response.Header.Get("Content-Type"))
	body := io.LimitReader(response.Body, maxBodyBytes)
	switch media {
	case "application/json":
		data, err := io.ReadAll(body)
		if err == nil && initializeResult(data) {
			return Connected, response.StatusCode
		}
	case "text/event-stream":
		if eventStreamResult(body) {
			return Connected, response.StatusCode
		}
	}
	return NotMCP, response.StatusCode
}

// initializeResult reports whether data is the JSON-RPC result of our
// initialize request: version 2.0, our id, and a result naming a protocol
// version. Nothing from it is kept.
func initializeResult(data []byte) bool {
	var reply struct {
		JSONRPC string          `json:"jsonrpc"`
		ID      json.RawMessage `json:"id"`
		Result  *struct {
			ProtocolVersion string `json:"protocolVersion"`
		} `json:"result"`
	}
	if json.Unmarshal(data, &reply) != nil {
		return false
	}
	return reply.JSONRPC == "2.0" && string(bytes.TrimSpace(reply.ID)) == requestID && reply.Result != nil && reply.Result.ProtocolVersion != ""
}

// eventStreamResult reads server-sent events until one carries the initialize
// result. Other messages a server may send first are skipped.
func eventStreamResult(body io.Reader) bool {
	scanner := bufio.NewScanner(body)
	scanner.Buffer(make([]byte, 0, 4<<10), maxBodyBytes)
	var data []byte
	for scanner.Scan() {
		line := scanner.Text()
		if line == "" {
			if initializeResult(data) {
				return true
			}
			data = data[:0]
			continue
		}
		if value, found := strings.CutPrefix(line, "data:"); found {
			data = append(data, strings.TrimPrefix(value, " ")...)
			data = append(data, '\n')
		}
	}
	return initializeResult(data)
}
```

### Code: internal/integration/connectiontest/tester.go (new)

```go
package connectiontest

import (
	"context"
	"encoding/json"
	"errors"
	"net/url"
	"slices"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/integration"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// Errors a test run can end with before anything is contacted.
var (
	// ErrBusy means too many connection tests are already running.
	ErrBusy = errors.New("connection tests are busy")
	// ErrStale means the saved settings no longer fit the shipped definition.
	ErrStale = errors.New("saved integration settings do not fit the current definition")
)

const (
	// maxConcurrent bounds how many tests run at once in this process, so the
	// server cannot be made to open connections without limit.
	maxConcurrent = 2
	// overallTimeout bounds one whole test, below the server's 30 s write timeout.
	overallTimeout = 15 * time.Second
)

// Targets lists what a saved configuration gives the control plane to check:
// every address the administrator entered (url parameters, in the tile's
// order), then every server of the rendered template by name: a hosted server
// is an MCP endpoint, a command server runs on the engineer's device. It
// returns the saved variant's name for display.
func Targets(tile integration.Tile, config integration.Configuration) ([]Target, string, error) {
	variant, ok := tile.Variant(config.VariantID)
	if !ok {
		return nil, "", ErrStale
	}
	var targets []Target
	for _, param := range variant.Params {
		value := config.Values[param.Name]
		if param.Type != integration.ParamURL || value == "" {
			continue
		}
		if !httpsURL(value) {
			return nil, "", ErrStale
		}
		targets = append(targets, Target{Kind: KindAddress, Label: param.Label, URL: value})
	}
	var body struct {
		Servers map[string]struct {
			Command string `json:"command"`
			URL     string `json:"url"`
		} `json:"mcpServers"`
	}
	if err := json.Unmarshal([]byte(config.Item.Body), &body); err != nil || len(body.Servers) == 0 {
		return nil, "", ErrStale
	}
	names := make([]string, 0, len(body.Servers))
	for name := range body.Servers {
		names = append(names, name)
	}
	slices.Sort(names)
	for _, name := range names {
		server := body.Servers[name]
		switch {
		case server.URL != "" && server.Command == "" && httpsURL(server.URL):
			targets = append(targets, Target{Kind: KindMCP, Label: name, URL: server.URL})
		case server.Command != "" && server.URL == "":
			targets = append(targets, Target{Kind: KindLocal, Label: name})
		default:
			return nil, "", ErrStale
		}
	}
	return targets, variant.Name, nil
}

func httpsURL(value string) bool {
	parsed, err := url.Parse(value)
	return err == nil && parsed.Scheme == "https" && parsed.Hostname() != "" && parsed.User == nil
}

// Report is one finished connection test.
type Report struct {
	// VariantName is the saved hosting variant the test ran for.
	VariantName string
	Results     []Result
}

// Failed reports that a check failed at DNS, connection, TLS or MCP.
func (report Report) Failed() bool {
	return slices.ContainsFunc(report.Results, Result.Failed)
}

// Passed reports that nothing failed, at least one check passed and nothing
// was left unchecked. A server that runs on the engineer's device is not a gap.
func (report Report) Passed() bool {
	passed := false
	for _, result := range report.Results {
		switch {
		case result.OK():
			passed = true
		case result.Outcome != NotTestable:
			return false
		}
	}
	return passed
}

// Summary is the one-line verdict above the per-target lines.
func (report Report) Summary() string {
	switch {
	case report.Failed():
		return "Connection test failed. The lines below say which step failed."
	case report.Passed():
		return "Connection test passed."
	default:
		return "Connection test incomplete: nothing failed, but the Leorna server could not check everything."
	}
}

type prober interface {
	Probe(context.Context, Target) Result
}

// Tester runs connection tests for saved company configurations.
type Tester struct {
	service *integration.Service
	prober  prober
	slots   chan struct{}
}

// New binds the tester to the configuration service, which scopes every read
// to the administrator's own company. Production passes &Prober{}.
func New(service *integration.Service, prober *Prober) *Tester {
	return &Tester{service: service, prober: prober, slots: make(chan struct{}, maxConcurrent)}
}

// Run tests the actor's company's saved configuration of one tile. It reads
// the configuration through the service (persisted administrator and company
// checks), stores nothing and changes nothing.
func (tester *Tester) Run(ctx context.Context, actor store.Principal, tileID string) (Report, error) {
	if integration.ConfigurationDeferral(tileID) != "" {
		return Report{}, integration.ErrDeferred
	}
	config, err := tester.service.Configuration(ctx, actor, tileID)
	if err != nil {
		return Report{}, err
	}
	index := slices.IndexFunc(tester.service.Tiles(), func(tile integration.Tile) bool { return tile.ID == config.TileID })
	if index < 0 || config.TileID != tileID {
		return Report{}, ErrStale
	}
	targets, variantName, err := Targets(tester.service.Tiles()[index], config)
	if err != nil {
		return Report{}, err
	}
	select {
	case tester.slots <- struct{}{}:
		defer func() { <-tester.slots }()
	default:
		return Report{}, ErrBusy
	}
	ctx, cancel := context.WithTimeout(ctx, overallTimeout)
	defer cancel()
	report := Report{VariantName: variantName, Results: make([]Result, 0, len(targets))}
	for _, target := range targets {
		report.Results = append(report.Results, tester.prober.Probe(ctx, target))
	}
	return report, nil
}
```

### Code: internal/integration/connectiontest/network_test.go (new)

```go
package connectiontest

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"io"
	"log"
	"math/big"
	"net"
	"net/http"
	"net/http/httptest"
	"net/netip"
	"sync"
	"testing"
	"time"
)

// fakeNetwork is the whole internet a test prober can see: names resolve to
// made-up public addresses, and a dial to one of those lands on a loopback
// stub. A name it does not know does not exist, and an address it has no route
// for cannot be dialled, so no test reaches a loopback host.
type fakeNetwork struct {
	t       *testing.T
	trusted authority

	mu      sync.Mutex
	names   map[string][]netip.Addr
	routes  map[string]string
	lookups map[string]int
	dials   []string
	next    byte
}

type authority struct {
	certificate *x509.Certificate
	key         *ecdsa.PrivateKey
	pool        *x509.CertPool
}

func newAuthority(t *testing.T) authority {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	template := &x509.Certificate{SerialNumber: big.NewInt(1), Subject: pkix.Name{CommonName: "connection test authority"}, NotBefore: time.Now().Add(-time.Hour), NotAfter: time.Now().Add(time.Hour), IsCA: true, BasicConstraintsValid: true, KeyUsage: x509.KeyUsageCertSign}
	der, err := x509.CreateCertificate(rand.Reader, template, template, &key.PublicKey, key)
	if err != nil {
		t.Fatal(err)
	}
	certificate, err := x509.ParseCertificate(der)
	if err != nil {
		t.Fatal(err)
	}
	pool := x509.NewCertPool()
	pool.AddCert(certificate)
	return authority{certificate: certificate, key: key, pool: pool}
}

// leaf signs a server certificate for one host name.
func (issuer authority) leaf(t *testing.T, host string) tls.Certificate {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	template := &x509.Certificate{SerialNumber: big.NewInt(2), Subject: pkix.Name{CommonName: host}, DNSNames: []string{host}, NotBefore: time.Now().Add(-time.Hour), NotAfter: time.Now().Add(time.Hour), KeyUsage: x509.KeyUsageDigitalSignature, ExtKeyUsage: []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth}}
	der, err := x509.CreateCertificate(rand.Reader, template, issuer.certificate, &key.PublicKey, issuer.key)
	if err != nil {
		t.Fatal(err)
	}
	return tls.Certificate{Certificate: [][]byte{der}, PrivateKey: key}
}

func newFakeNetwork(t *testing.T) *fakeNetwork {
	t.Helper()
	return &fakeNetwork{t: t, trusted: newAuthority(t), names: map[string][]netip.Addr{}, routes: map[string]string{}, lookups: map[string]int{}}
}

// prober is a production prober whose resolver, dialer and certificate roots
// are this network. The public-address rule stays on.
func (network *fakeNetwork) prober() *Prober {
	return &Prober{Resolver: network, DialContext: network.dial, RootCAs: network.trusted.pool, Timeout: 5 * time.Second}
}

func (network *fakeNetwork) LookupNetIP(_ context.Context, _ string, host string) ([]netip.Addr, error) {
	network.mu.Lock()
	defer network.mu.Unlock()
	network.lookups[host]++
	addresses, ok := network.names[host]
	if !ok {
		return nil, &net.DNSError{Err: "no such host", Name: host, IsNotFound: true}
	}
	return append([]netip.Addr(nil), addresses...), nil
}

func (network *fakeNetwork) dial(ctx context.Context, _ string, address string) (net.Conn, error) {
	network.mu.Lock()
	network.dials = append(network.dials, address)
	loopback, ok := network.routes[address]
	network.mu.Unlock()
	if !ok {
		return nil, &net.OpError{Op: "dial", Net: "tcp", Err: io.ErrUnexpectedEOF}
	}
	return (&net.Dialer{}).DialContext(ctx, "tcp", loopback)
}

// publicAddress hands out a fresh made-up public address.
func (network *fakeNetwork) publicAddress() netip.Addr {
	network.mu.Lock()
	defer network.mu.Unlock()
	network.next++
	return netip.AddrFrom4([4]byte{93, 184, 216, network.next})
}

// resolve makes a name answer with the given addresses, with no route to them.
func (network *fakeNetwork) resolve(host string, addresses ...string) {
	network.mu.Lock()
	defer network.mu.Unlock()
	parsed := make([]netip.Addr, 0, len(addresses))
	for _, address := range addresses {
		parsed = append(parsed, netip.MustParseAddr(address))
	}
	network.names[host] = parsed
}

func (network *fakeNetwork) route(host, port, loopback string) {
	address := network.publicAddress()
	network.mu.Lock()
	defer network.mu.Unlock()
	network.names[host] = append(network.names[host], address)
	network.routes[net.JoinHostPort(address.String(), port)] = loopback
}

// stub is one HTTPS server on the fake network and what it was sent.
type stub struct {
	mu       sync.Mutex
	requests []recorded
}

type recorded struct {
	Method, Path, Body string
	Header             http.Header
}

func (server *stub) seen() []recorded {
	server.mu.Lock()
	defer server.mu.Unlock()
	return append([]recorded(nil), server.requests...)
}

// serve starts an HTTPS stub for host on port 443 with a certificate the
// prober trusts.
func (network *fakeNetwork) serve(host string, handler http.HandlerFunc) *stub {
	return network.serveWith(network.trusted, host, "443", handler)
}

func (network *fakeNetwork) serveWith(issuer authority, host, port string, handler http.HandlerFunc) *stub {
	network.t.Helper()
	server := &stub{}
	listener := httptest.NewUnstartedServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, _ := io.ReadAll(io.LimitReader(r.Body, 1<<20))
		server.mu.Lock()
		server.requests = append(server.requests, recorded{Method: r.Method, Path: r.URL.Path, Body: string(body), Header: r.Header.Clone()})
		server.mu.Unlock()
		handler(w, r)
	}))
	listener.Config.ErrorLog = log.New(io.Discard, "", 0)
	listener.TLS = &tls.Config{Certificates: []tls.Certificate{issuer.leaf(network.t, host)}, MinVersion: tls.VersionTLS12}
	listener.StartTLS()
	network.t.Cleanup(listener.Close)
	network.route(host, port, listener.Listener.Addr().String())
	return server
}

// closedPort makes host resolve to an address whose port refuses connections.
func (network *fakeNetwork) closedPort(host string) {
	network.t.Helper()
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		network.t.Fatal(err)
	}
	loopback := listener.Addr().String()
	if err := listener.Close(); err != nil {
		network.t.Fatal(err)
	}
	network.route(host, "443", loopback)
}

func (network *fakeNetwork) lookupCount(host string) int {
	network.mu.Lock()
	defer network.mu.Unlock()
	return network.lookups[host]
}

func (network *fakeNetwork) dialled() []string {
	network.mu.Lock()
	defer network.mu.Unlock()
	return append([]string(nil), network.dials...)
}

// MCP replies a stub can give.

const initializeReply = `{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2025-06-18","capabilities":{},"serverInfo":{"name":"stub","version":"1"}}}`

func mcpJSON(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	_, _ = io.WriteString(w, initializeReply)
}

func mcpEventStream(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/event-stream")
	_, _ = io.WriteString(w, ": keep-alive\n\nevent: message\ndata: {\"jsonrpc\":\"2.0\",\"method\":\"notifications/message\",\"params\":{}}\n\nevent: message\ndata: "+initializeReply+"\n\n")
}

func signInRequired(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("WWW-Authenticate", `Bearer error="invalid_request", resource_metadata="https://stub.example/.well-known/oauth-protected-resource"`)
	http.Error(w, "missing required Authorization header", http.StatusUnauthorized)
}

func webPage(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_, _ = io.WriteString(w, "<!doctype html><title>Welcome</title><p>Not an MCP server.</p>")
}
```

### Code: internal/integration/connectiontest/prober_test.go (new)

```go
package connectiontest

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/netip"
	"slices"
	"strings"
	"testing"
	"time"
)

func mcpTarget(host string) Target {
	return Target{Kind: KindMCP, Label: "stub", URL: "https://" + host + "/mcp"}
}

func TestProbeMCPEndpointAnswersTheHandshake(t *testing.T) {
	for name, reply := range map[string]http.HandlerFunc{"JSON reply": mcpJSON, "event stream reply": mcpEventStream} {
		t.Run(name, func(t *testing.T) {
			network := newFakeNetwork(t)
			server := network.serve("mcp.stub.test", reply)
			result := network.prober().Probe(context.Background(), mcpTarget("mcp.stub.test"))
			if result.Outcome != Connected || !result.OK() || result.Failed() || result.Host != "mcp.stub.test" || result.Port != "443" || result.Status != http.StatusOK {
				t.Fatalf("result = %+v, want connected", result)
			}
			requests := server.seen()
			if len(requests) != 1 {
				t.Fatalf("stub got %d requests, want 1", len(requests))
			}
			got := requests[0]
			var sent struct {
				JSONRPC string `json:"jsonrpc"`
				ID      int    `json:"id"`
				Method  string `json:"method"`
				Params  struct {
					ProtocolVersion string `json:"protocolVersion"`
				} `json:"params"`
			}
			if err := json.Unmarshal([]byte(got.Body), &sent); err != nil {
				t.Fatalf("request body is not JSON: %v", err)
			}
			if got.Method != http.MethodPost || got.Path != "/mcp" || sent.JSONRPC != "2.0" || sent.ID != 1 || sent.Method != "initialize" || sent.Params.ProtocolVersion == "" {
				t.Fatalf("request = %s %s %+v, want one MCP initialize POST", got.Method, got.Path, sent)
			}
			accept := got.Header.Get("Accept")
			if !strings.Contains(accept, "application/json") || !strings.Contains(accept, "text/event-stream") || got.Header.Get("Content-Type") != "application/json" {
				t.Fatalf("Accept=%q Content-Type=%q, want the Streamable HTTP headers", accept, got.Header.Get("Content-Type"))
			}
			if !strings.Contains(result.Message(), "Connected") || !strings.Contains(result.Message(), "mcp.stub.test") {
				t.Fatalf("message = %q", result.Message())
			}
		})
	}
}

func TestProbeSignInRequiredIsReachableNotAFailure(t *testing.T) {
	network := newFakeNetwork(t)
	server := network.serve("mcp.stub.test", signInRequired)
	result := network.prober().Probe(context.Background(), mcpTarget("mcp.stub.test"))
	if result.Outcome != SignInRequired || !result.OK() || result.Failed() || result.Status != http.StatusUnauthorized {
		t.Fatalf("result = %+v, want sign-in required as a pass", result)
	}
	if len(server.seen()) != 1 {
		t.Fatalf("stub got %d requests, want 1 (no retry with or without credentials)", len(server.seen()))
	}
	for _, want := range []string{"Reachable", "asks for sign-in", "nobody's credentials"} {
		if !strings.Contains(result.Message(), want) {
			t.Fatalf("message %q missing %q", result.Message(), want)
		}
	}
}

func TestProbeAddressStopsAfterTheCertificateCheck(t *testing.T) {
	network := newFakeNetwork(t)
	server := network.serve("git.stub.test", webPage)
	result := network.prober().Probe(context.Background(), Target{Kind: KindAddress, Label: "Server address", URL: "https://git.stub.test"})
	if result.Outcome != Reachable || !result.OK() {
		t.Fatalf("result = %+v, want reachable", result)
	}
	if len(server.seen()) != 0 {
		t.Fatalf("an address check sent %d HTTP requests, want none", len(server.seen()))
	}
}

func TestProbeNamesTheStepThatFailed(t *testing.T) {
	network := newFakeNetwork(t)
	network.serveWith(newAuthority(t), "untrusted.stub.test", "443", mcpJSON)
	network.serveWith(network.trusted, "othername.stub.test", "443", mcpJSON)
	network.mu.Lock()
	network.names["wrongname.stub.test"] = network.names["othername.stub.test"]
	network.mu.Unlock()
	network.closedPort("closed.stub.test")
	network.serve("web.stub.test", webPage)
	network.serve("missing.stub.test.example", func(w http.ResponseWriter, _ *http.Request) { http.NotFound(w, nil) })
	network.serve("rpcerror.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, `{"jsonrpc":"2.0","id":1,"error":{"code":-32601,"message":"Method not found"}}`)
	})
	network.serve("otherid.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, strings.Replace(initializeReply, `"id":1`, `"id":2`, 1))
	})
	network.serve("jsonpage.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, `{"status":"ok"}`)
	})
	network.serve("plaintext.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		_, _ = io.WriteString(w, initializeReply)
	})

	cases := []struct {
		name, host string
		want       Outcome
		status     int
		step       string
	}{
		{"DNS: the name does not exist", "nowhere.stub.test", DNSFailed, 0, "DNS failed"},
		{"TLS: certificate from an unknown authority", "untrusted.stub.test", TLSFailed, 0, "TLS failed"},
		{"TLS: certificate for another name", "wrongname.stub.test", TLSFailed, 0, "TLS failed"},
		{"unreachable: connection refused", "closed.stub.test", Unreachable, 0, "Unreachable"},
		{"not MCP: a web page", "web.stub.test", NotMCP, 200, "Not an MCP endpoint"},
		{"not MCP: 404", "missing.stub.test.example", NotMCP, 404, "Not an MCP endpoint"},
		{"not MCP: a JSON-RPC error", "rpcerror.stub.test", NotMCP, 200, "Not an MCP endpoint"},
		{"not MCP: a reply to another request", "otherid.stub.test", NotMCP, 200, "Not an MCP endpoint"},
		{"not MCP: other JSON", "jsonpage.stub.test", NotMCP, 200, "Not an MCP endpoint"},
		{"not MCP: the right JSON as plain text", "plaintext.stub.test", NotMCP, 200, "Not an MCP endpoint"},
	}
	steps := []string{"DNS failed", "TLS failed", "Unreachable", "Not an MCP endpoint"}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			result := network.prober().Probe(context.Background(), mcpTarget(tc.host))
			if result.Outcome != tc.want || result.Status != tc.status || !result.Failed() || result.OK() {
				t.Fatalf("result = %+v, want %s with status %d", result, tc.want, tc.status)
			}
			message := result.Message()
			if !strings.HasPrefix(message, tc.step+":") || !strings.Contains(message, tc.host) {
				t.Fatalf("message %q does not start with %q and name the host", message, tc.step)
			}
			for _, other := range steps {
				if other != tc.step && strings.Contains(message, other) {
					t.Fatalf("message %q also names another step %q", message, other)
				}
			}
		})
	}
}

func TestProbeRefusesAddressesThatAreNotPublic(t *testing.T) {
	cases := map[string][]string{
		"loopback":                         {"127.0.0.1"},
		"private":                          {"10.0.0.5"},
		"private 192.168":                  {"192.168.1.10"},
		"cloud metadata (link-local)":      {"169.254.169.254"},
		"carrier-grade NAT":                {"100.64.0.1"},
		"unspecified":                      {"0.0.0.0"},
		"IPv6 loopback":                    {"::1"},
		"IPv6 unique local (AWS metadata)": {"fd00:ec2::254"},
		"IPv6 site-local":                  {"fec0::1"},
		"IPv6 link-local":                  {"fe80::1"},
		"IPv4-mapped private":              {"::ffff:10.0.0.1"},
		"NAT64 of a private address":       {"64:ff9b::a00:1"},
		"one public and one private":       {"93.184.216.200", "10.0.0.5"},
	}
	for name, addresses := range cases {
		t.Run(name, func(t *testing.T) {
			network := newFakeNetwork(t)
			network.resolve("inside.stub.test", addresses...)
			result := network.prober().Probe(context.Background(), mcpTarget("inside.stub.test"))
			if result.Outcome != AddressRefused || result.OK() || result.Failed() {
				t.Fatalf("result = %+v, want address refused", result)
			}
			if dials := network.dialled(); len(dials) != 0 {
				t.Fatalf("dialled %v, want nothing dialled", dials)
			}
			if !strings.Contains(result.Message(), "not a public internet address") {
				t.Fatalf("message = %q", result.Message())
			}
		})
	}
	for _, literal := range []string{"https://127.0.0.1:8443/mcp", "https://[::1]/mcp", "https://10.1.2.3/mcp", "https://169.254.169.254/mcp", "https://[fd00:ec2::254]/mcp"} {
		t.Run("literal "+literal, func(t *testing.T) {
			network := newFakeNetwork(t)
			result := network.prober().Probe(context.Background(), Target{Kind: KindMCP, Label: "stub", URL: literal})
			if result.Outcome != AddressRefused {
				t.Fatalf("result = %+v, want address refused", result)
			}
			if len(network.dialled()) != 0 || len(network.lookups) != 0 {
				t.Fatalf("dialled %v, looked up %v; want neither", network.dialled(), network.lookups)
			}
		})
	}
}

func TestProbeResolvesOnceAndDialsOnlyTheCheckedAddress(t *testing.T) {
	network := newFakeNetwork(t)
	network.serve("mcp.stub.test", mcpJSON)
	checked := network.names["mcp.stub.test"][0]
	rebinding := &rebindingResolver{network: network, later: netip.MustParseAddr("127.0.0.1")}
	prober := network.prober()
	prober.Resolver = rebinding
	result := prober.Probe(context.Background(), mcpTarget("mcp.stub.test"))
	if result.Outcome != Connected {
		t.Fatalf("result = %+v, want connected", result)
	}
	if rebinding.calls != 1 {
		t.Fatalf("the name was looked up %d times, want exactly once", rebinding.calls)
	}
	if dials := network.dialled(); !slices.Equal(dials, []string{checked.String() + ":443"}) {
		t.Fatalf("dialled %v, want only the checked address %s:443", dials, checked)
	}
}

// rebindingResolver answers with the public address first and a loopback
// address on every later lookup, as a DNS rebinding attack does.
type rebindingResolver struct {
	network *fakeNetwork
	later   netip.Addr
	calls   int
}

func (resolver *rebindingResolver) LookupNetIP(ctx context.Context, family, host string) ([]netip.Addr, error) {
	resolver.calls++
	if resolver.calls > 1 {
		return []netip.Addr{resolver.later}, nil
	}
	return resolver.network.LookupNetIP(ctx, family, host)
}

func TestProbeNeverFollowsARedirect(t *testing.T) {
	network := newFakeNetwork(t)
	elsewhere := network.serve("elsewhere.stub.test", mcpJSON)
	network.resolve("inside.stub.test", "10.0.0.5")
	cases := []struct{ name, host, location string }{
		{"to another public host", "public.redirect.stub.test", "https://elsewhere.stub.test/mcp"},
		{"to a private host", "private.redirect.stub.test", "https://inside.stub.test/mcp"},
		{"to a loopback address", "loopback.redirect.stub.test", "https://127.0.0.1/mcp"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			redirector := network.serve(tc.host, func(w http.ResponseWriter, r *http.Request) {
				http.Redirect(w, r, tc.location, http.StatusTemporaryRedirect)
			})
			before := len(network.dialled())
			result := network.prober().Probe(context.Background(), mcpTarget(tc.host))
			if result.Outcome != NotMCP || result.Status != http.StatusTemporaryRedirect {
				t.Fatalf("result = %+v, want not MCP with status 307", result)
			}
			if len(redirector.seen()) != 1 || len(elsewhere.seen()) != 0 || len(network.dialled()) != before+1 || network.lookupCount("elsewhere.stub.test")+network.lookupCount("inside.stub.test") != 0 {
				t.Fatalf("redirector got %d, the redirect target got %d, dials grew by %d; want 1, 0 and 1, and no lookup of the target", len(redirector.seen()), len(elsewhere.seen()), len(network.dialled())-before)
			}
		})
	}
}

func TestProbeSendsNoCredentialsAndKeepsNothingFromTheReply(t *testing.T) {
	const marker = "MARKER-7f3a"
	network := newFakeNetwork(t)
	replies := map[string]http.HandlerFunc{
		"connected.stub.test": func(w http.ResponseWriter, _ *http.Request) {
			w.Header().Set("Content-Type", "application/json")
			w.Header().Set("Mcp-Session-Id", marker)
			_, _ = io.WriteString(w, strings.Replace(initializeReply, `"name":"stub"`, `"name":"<script>`+marker+`</script>"`, 1))
		},
		"signin.stub.test": func(w http.ResponseWriter, _ *http.Request) {
			w.Header().Set("WWW-Authenticate", `Bearer realm="`+marker+`"`)
			http.Error(w, marker, http.StatusUnauthorized)
		},
		"web.stub.test": func(w http.ResponseWriter, _ *http.Request) {
			w.Header().Set("Content-Type", "text/html")
			_, _ = io.WriteString(w, "<h1>"+marker+"</h1>")
		},
	}
	for host, reply := range replies {
		t.Run(host, func(t *testing.T) {
			server := network.serve(host, reply)
			result := network.prober().Probe(context.Background(), mcpTarget(host))
			encoded, err := json.Marshal(result)
			if err != nil {
				t.Fatal(err)
			}
			if strings.Contains(string(encoded), marker) || strings.Contains(result.Message(), marker) {
				t.Fatalf("the result carries text from the reply: %s / %q", encoded, result.Message())
			}
			requests := server.seen()
			if len(requests) != 1 {
				t.Fatalf("stub got %d requests, want 1", len(requests))
			}
			for name, values := range requests[0].Header {
				switch name {
				case "Accept", "Content-Type", "Content-Length", "User-Agent", "Accept-Encoding", "Connection":
				default:
					t.Errorf("request carried header %s: %v", name, values)
				}
			}
			if strings.Contains(requests[0].Body, "${") || strings.Contains(requests[0].Body, "Bearer") {
				t.Errorf("request body carries a credential reference: %s", requests[0].Body)
			}
		})
	}
}

func TestProbeBoundsTimeAndReplySize(t *testing.T) {
	network := newFakeNetwork(t)
	// The silent server holds the request until the prober gives up and closes it.
	network.serve("silent.stub.test", func(_ http.ResponseWriter, r *http.Request) { <-r.Context().Done() })
	network.serve("endless.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "text/event-stream")
		chunk := ": " + strings.Repeat("x", 1022) + "\n"
		for written := 0; written < 4<<20; written += len(chunk) {
			if _, err := io.WriteString(w, chunk); err != nil {
				return
			}
		}
		_, _ = io.WriteString(w, "\ndata: "+initializeReply+"\n\n")
	})
	network.serve("huge.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_, _ = io.WriteString(w, `{"jsonrpc":"2.0","id":1,"padding":"`+strings.Repeat("x", 1<<20)+`","result":{"protocolVersion":"2025-06-18"}}`)
	})
	network.serve("bigheader.stub.test", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("X-Padding", strings.Repeat("x", 64<<10))
		_, _ = io.WriteString(w, initializeReply)
	})
	prober := network.prober()
	prober.Timeout = 700 * time.Millisecond
	for host, status := range map[string]int{"silent.stub.test": 0, "endless.stub.test": 200, "huge.stub.test": 200, "bigheader.stub.test": 0} {
		t.Run(host, func(t *testing.T) {
			started := time.Now()
			result := prober.Probe(context.Background(), mcpTarget(host))
			if result.Outcome != NotMCP || result.Status != status {
				t.Fatalf("result = %+v, want not MCP with status %d", result, status)
			}
			if elapsed := time.Since(started); elapsed > 3*time.Second {
				t.Fatalf("probe took %s, want it bounded by its 700 ms timeout", elapsed)
			}
		})
	}
}

func TestProbeTriesTheNextCheckedAddress(t *testing.T) {
	network := newFakeNetwork(t)
	network.closedPort("mcp.stub.test")
	network.serve("mcp.stub.test", mcpJSON)
	result := network.prober().Probe(context.Background(), mcpTarget("mcp.stub.test"))
	if result.Outcome != Connected || len(network.dialled()) != 2 {
		t.Fatalf("result = %+v after dials %v, want connected on the second address", result, network.dialled())
	}
}

func TestProbeLeavesOutWhatItCannotTest(t *testing.T) {
	network := newFakeNetwork(t)
	network.serve("mcp.stub.test", mcpJSON)
	cancelled, cancel := context.WithCancel(context.Background())
	cancel()
	cases := []struct {
		name   string
		ctx    context.Context
		target Target
		want   Outcome
	}{
		{"a local command server", context.Background(), Target{Kind: KindLocal, Label: "github"}, NotTestable},
		{"plain http", context.Background(), Target{Kind: KindMCP, Label: "stub", URL: "http://mcp.stub.test/mcp"}, NotChecked},
		{"credentials in the address", context.Background(), Target{Kind: KindMCP, Label: "stub", URL: "https://user:pass@mcp.stub.test/mcp"}, NotChecked},
		{"no host", context.Background(), Target{Kind: KindMCP, Label: "stub", URL: "https:///mcp"}, NotChecked},
		{"an unknown kind", context.Background(), Target{Kind: "other", Label: "stub", URL: "https://mcp.stub.test/mcp"}, NotChecked},
		{"time already ran out", cancelled, mcpTarget("mcp.stub.test"), NotChecked},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			result := network.prober().Probe(tc.ctx, tc.target)
			if result.Outcome != tc.want || result.OK() || result.Failed() {
				t.Fatalf("result = %+v, want %s", result, tc.want)
			}
			if len(network.dialled()) != 0 || len(network.lookups) != 0 {
				t.Fatalf("dialled %v, looked up %v; want neither", network.dialled(), network.lookups)
			}
		})
	}
}
```

### Code: internal/integration/connectiontest/tester_test.go (new)

```go
package connectiontest

import (
	"context"
	"errors"
	"slices"
	"sync"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/integration"
	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

func shippedTile(t *testing.T, id string) integration.Tile {
	t.Helper()
	tiles, err := integration.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	for _, tile := range tiles {
		if tile.ID == id {
			return tile
		}
	}
	t.Fatalf("no shipped tile %q", id)
	return integration.Tile{}
}

// savedConfiguration is what the Integrations page stores for these choices:
// the values and the template rendered from them.
func savedConfiguration(t *testing.T, tile integration.Tile, variantID string, values map[string]string) integration.Configuration {
	t.Helper()
	rendered, err := tile.Render(variantID, values)
	if err != nil {
		t.Fatal(err)
	}
	return integration.Configuration{ID: "config-" + tile.ID, TileID: tile.ID, TileVersion: tile.Version, VariantID: variantID, Revision: 1, Values: values, Item: library.Item{Body: rendered.Body}}
}

func TestTargetsFromEachShippedVariant(t *testing.T) {
	cases := []struct {
		tile, variant string
		values        map[string]string
		want          []Target
	}{
		{"clickup", "cloud", map[string]string{}, []Target{{KindMCP, "clickup", "https://mcp.clickup.com/mcp"}}},
		{"github", "github-com", map[string]string{}, []Target{{KindMCP, "github", "https://api.githubcopilot.com/mcp/"}}},
		{"github", "ghe-com", map[string]string{"instance": "https://acme.ghe.com"}, []Target{{KindAddress, "GHE.com address", "https://acme.ghe.com"}, {KindMCP, "github", "https://copilot-api.acme.ghe.com/mcp"}}},
		{"github", "enterprise-server", map[string]string{"server": "https://github.acme.example:8443"}, []Target{{KindAddress, "Server address", "https://github.acme.example:8443"}, {KindLocal, "github", ""}}},
	}
	for _, tc := range cases {
		t.Run(tc.tile+"/"+tc.variant, func(t *testing.T) {
			tile := shippedTile(t, tc.tile)
			targets, variantName, err := Targets(tile, savedConfiguration(t, tile, tc.variant, tc.values))
			if err != nil {
				t.Fatal(err)
			}
			variant, _ := tile.Variant(tc.variant)
			if !slices.Equal(targets, tc.want) || variantName != variant.Name {
				t.Fatalf("targets = %+v (%q), want %+v (%q)", targets, variantName, tc.want, variant.Name)
			}
		})
	}
}

func TestTargetsRefuseSettingsThatDoNotFitTheDefinition(t *testing.T) {
	tile := shippedTile(t, "github")
	good := savedConfiguration(t, tile, "ghe-com", map[string]string{"instance": "https://acme.ghe.com"})
	cases := map[string]func(*integration.Configuration){
		"a variant the tile no longer has": func(c *integration.Configuration) { c.VariantID = "retired" },
		"an address that is not https":     func(c *integration.Configuration) { c.Values = map[string]string{"instance": "http://acme.ghe.com"} },
		"an address with credentials": func(c *integration.Configuration) {
			c.Values = map[string]string{"instance": "https://user:pass@acme.ghe.com"}
		},
		"a template that is not JSON": func(c *integration.Configuration) { c.Item.Body = "not json" },
		"a template with no servers":  func(c *integration.Configuration) { c.Item.Body = `{"mcpServers":{}}` },
		"a hosted server over plain http": func(c *integration.Configuration) {
			c.Item.Body = `{"mcpServers":{"x":{"url":"http://acme.ghe.com/mcp"}}}`
		},
		"a server that is both kinds": func(c *integration.Configuration) {
			c.Item.Body = `{"mcpServers":{"x":{"url":"https://acme.ghe.com/mcp","command":"docker"}}}`
		},
		"a server that is neither kind": func(c *integration.Configuration) { c.Item.Body = `{"mcpServers":{"x":{}}}` },
	}
	for name, change := range cases {
		t.Run(name, func(t *testing.T) {
			config := good
			change(&config)
			if targets, _, err := Targets(tile, config); !errors.Is(err, ErrStale) {
				t.Fatalf("targets = %+v, err = %v; want ErrStale", targets, err)
			}
		})
	}
}

// companyStore holds one configuration per company and records who asked.
type companyStore struct {
	mu      sync.Mutex
	configs map[store.TenantID]integration.Configuration
	readers []store.Principal
}

func (s *companyStore) ListIntegrationConfigurations(context.Context, store.Principal) ([]integration.Configuration, error) {
	return nil, errors.New("not used")
}

func (s *companyStore) GetIntegrationConfiguration(_ context.Context, actor store.Principal, tileID string) (integration.Configuration, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.readers = append(s.readers, actor)
	config, ok := s.configs[actor.TenantID]
	if !ok || config.TileID != tileID {
		return integration.Configuration{}, store.ErrNotFound
	}
	return config, nil
}

func (s *companyStore) SaveIntegrationConfiguration(context.Context, store.Principal, integration.SaveSpec) (integration.Configuration, error) {
	return integration.Configuration{}, errors.New("a connection test must never save")
}

// recordingProber stands in for the network and records what it was asked.
type recordingProber struct {
	mu      sync.Mutex
	targets []Target
	entered chan struct{}
	release chan struct{}
}

func (p *recordingProber) Probe(ctx context.Context, target Target) Result {
	p.mu.Lock()
	p.targets = append(p.targets, target)
	p.mu.Unlock()
	if p.entered != nil {
		p.entered <- struct{}{}
		<-p.release
	}
	if ctx.Err() != nil {
		return Result{Target: target, Outcome: NotChecked}
	}
	return Result{Target: target, Outcome: Reachable, Host: "stub"}
}

func (p *recordingProber) probed() []Target {
	p.mu.Lock()
	defer p.mu.Unlock()
	return append([]Target(nil), p.targets...)
}

func newTestTester(t *testing.T, configs map[store.TenantID]integration.Configuration, probe prober) (*Tester, *companyStore) {
	t.Helper()
	tiles, err := integration.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	repository := &companyStore{configs: configs}
	return &Tester{service: integration.NewService(repository, tiles, nil), prober: probe, slots: make(chan struct{}, maxConcurrent)}, repository
}

func TestTesterChecksOnlyTheActorsOwnCompanyConfiguration(t *testing.T) {
	github := shippedTile(t, "github")
	companyA := store.Principal{UserID: "admin-a", TenantID: "tenant-a"}
	companyB := store.Principal{UserID: "admin-b", TenantID: "tenant-b"}
	probe := &recordingProber{}
	tester, repository := newTestTester(t, map[store.TenantID]integration.Configuration{
		companyA.TenantID: savedConfiguration(t, github, "ghe-com", map[string]string{"instance": "https://alpha.ghe.com"}),
	}, probe)

	report, err := tester.Run(context.Background(), companyA, "github")
	if err != nil {
		t.Fatal(err)
	}
	want := []Target{{KindAddress, "GHE.com address", "https://alpha.ghe.com"}, {KindMCP, "github", "https://copilot-api.alpha.ghe.com/mcp"}}
	if !slices.Equal(probe.probed(), want) || len(report.Results) != 2 || !report.Passed() || report.VariantName == "" {
		t.Fatalf("probed %+v, report %+v; want company A's two targets, passed", probe.probed(), report)
	}

	if _, err := tester.Run(context.Background(), companyB, "github"); !errors.Is(err, store.ErrNotFound) {
		t.Fatalf("company B's test of an integration it never saved: err = %v, want not found", err)
	}
	if _, err := tester.Run(context.Background(), companyA, "clickup"); !errors.Is(err, store.ErrNotFound) {
		t.Fatalf("company A's test of a tile it never saved: err = %v, want not found", err)
	}
	if !slices.Equal(probe.probed(), want) {
		t.Fatalf("after the refused runs, probed = %+v; want nothing more than company A's targets", probe.probed())
	}
	if !slices.Equal(repository.readers, []store.Principal{companyA, companyB, companyA}) {
		t.Fatalf("configurations were read as %+v; want each run to read as its own actor", repository.readers)
	}
}

func TestTesterRefusesADeferredTileWithoutReadingOrConnecting(t *testing.T) {
	google := shippedTile(t, integration.DeferredGoogleTileID)
	actor := store.Principal{UserID: "admin-a", TenantID: "tenant-a"}
	probe := &recordingProber{}
	tester, repository := newTestTester(t, map[store.TenantID]integration.Configuration{
		actor.TenantID: {ID: "legacy", TileID: google.ID, VariantID: google.Variants[0].ID, Revision: 1, Item: library.Item{Body: `{"mcpServers":{"drive":{"url":"https://drivemcp.googleapis.com/mcp/v1"}}}`}},
	}, probe)
	if _, err := tester.Run(context.Background(), actor, google.ID); !errors.Is(err, integration.ErrDeferred) {
		t.Fatalf("err = %v, want ErrDeferred", err)
	}
	if len(probe.probed()) != 0 || len(repository.readers) != 0 {
		t.Fatalf("a deferred tile was read %d times and probed %d times; want neither", len(repository.readers), len(probe.probed()))
	}
}

func TestTesterRefusesStaleSettingsWithoutConnecting(t *testing.T) {
	github := shippedTile(t, "github")
	actor := store.Principal{UserID: "admin-a", TenantID: "tenant-a"}
	stale := savedConfiguration(t, github, "ghe-com", map[string]string{"instance": "https://alpha.ghe.com"})
	stale.VariantID = "retired"
	probe := &recordingProber{}
	tester, _ := newTestTester(t, map[store.TenantID]integration.Configuration{actor.TenantID: stale}, probe)
	if _, err := tester.Run(context.Background(), actor, "github"); !errors.Is(err, ErrStale) {
		t.Fatalf("err = %v, want ErrStale", err)
	}
	if len(probe.probed()) != 0 {
		t.Fatalf("stale settings were probed: %+v", probe.probed())
	}
}

func TestTesterRunsAtMostTwoTestsAtOnce(t *testing.T) {
	clickup := shippedTile(t, "clickup")
	actor := store.Principal{UserID: "admin-a", TenantID: "tenant-a"}
	probe := &recordingProber{entered: make(chan struct{}), release: make(chan struct{})}
	tester, _ := newTestTester(t, map[store.TenantID]integration.Configuration{actor.TenantID: savedConfiguration(t, clickup, "cloud", map[string]string{})}, probe)

	finished := make(chan error, maxConcurrent)
	for range maxConcurrent {
		go func() {
			_, err := tester.Run(context.Background(), actor, "clickup")
			finished <- err
		}()
	}
	for range maxConcurrent {
		select {
		case <-probe.entered:
		case <-time.After(5 * time.Second):
			t.Fatal("the first runs never reached the network")
		}
	}
	refused := make(chan error, 1)
	go func() {
		_, err := tester.Run(context.Background(), actor, "clickup")
		refused <- err
	}()
	select {
	case err := <-refused:
		if !errors.Is(err, ErrBusy) {
			t.Fatalf("one run too many: err = %v, want ErrBusy", err)
		}
	case <-time.After(5 * time.Second):
		t.Fatal("one run too many waited instead of being refused")
	}
	if len(probe.probed()) != maxConcurrent {
		t.Fatalf("probed %d targets, want only the %d running tests'", len(probe.probed()), maxConcurrent)
	}
	close(probe.release)
	for range maxConcurrent {
		if err := <-finished; err != nil {
			t.Fatal(err)
		}
	}
	probe.entered = nil
	if _, err := tester.Run(context.Background(), actor, "clickup"); err != nil {
		t.Fatalf("a run after the others finished: %v", err)
	}
}

func TestReportVerdict(t *testing.T) {
	result := func(outcome Outcome) Result { return Result{Outcome: outcome} }
	cases := []struct {
		name           string
		results        []Result
		passed, failed bool
		summary        string
	}{
		{"an MCP endpoint that answers", []Result{result(Connected)}, true, false, "Connection test passed."},
		{"an address and an endpoint that asks for sign-in", []Result{result(Reachable), result(SignInRequired)}, true, false, "Connection test passed."},
		{"a reachable address and a server on the engineer's device", []Result{result(Reachable), result(NotTestable)}, true, false, "Connection test passed."},
		{"one failure among passes", []Result{result(Reachable), result(NotMCP)}, false, true, "Connection test failed. The lines below say which step failed."},
		{"a DNS failure", []Result{result(DNSFailed)}, false, true, "Connection test failed. The lines below say which step failed."},
		{"a private address and a local server", []Result{result(AddressRefused), result(NotTestable)}, false, false, "Connection test incomplete: nothing failed, but the Leorna server could not check everything."},
		{"only a local server", []Result{result(NotTestable)}, false, false, "Connection test incomplete: nothing failed, but the Leorna server could not check everything."},
		{"a pass and an unchecked address", []Result{result(Reachable), result(NotChecked)}, false, false, "Connection test incomplete: nothing failed, but the Leorna server could not check everything."},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			report := Report{Results: tc.results}
			if report.Passed() != tc.passed || report.Failed() != tc.failed || report.Summary() != tc.summary {
				t.Fatalf("passed=%v failed=%v summary=%q; want %v, %v, %q", report.Passed(), report.Failed(), report.Summary(), tc.passed, tc.failed, tc.summary)
			}
		})
	}
}

func TestEveryOutcomeHasItsOwnMessage(t *testing.T) {
	seen := map[string]Outcome{}
	for _, outcome := range []Outcome{Connected, Reachable, SignInRequired, DNSFailed, Unreachable, TLSFailed, NotMCP, AddressRefused, NotTestable, NotChecked} {
		message := Result{Outcome: outcome, Host: "host.example", Port: "443", Status: 200}.Message()
		if other, repeated := seen[message]; repeated || message == "" {
			t.Fatalf("%s and %s share the message %q", outcome, other, message)
		}
		seen[message] = outcome
	}
}
```

### Code: internal/integration/connectiontest/live_test.go (new)

```go
package connectiontest

import (
	"context"
	"os"
	"testing"
)

// This opt-in is the one check that uses the real internet: the production
// prober (system resolver, dialer and certificate roots) against the hosted
// MCP endpoints of the shipped tiles that need no company address. Both ask
// for sign-in, so the expected result is a pass without anyone's credentials.
func TestProbeShippedHostedEndpointsLive(t *testing.T) {
	if os.Getenv("LEORNA_CONNECTION_TEST_LIVE") != "1" {
		t.Skip("set LEORNA_CONNECTION_TEST_LIVE=1 to probe the shipped hosted MCP endpoints over the real internet")
	}
	for _, tc := range []struct{ tile, variant string }{{"github", "github-com"}, {"clickup", "cloud"}} {
		t.Run(tc.tile+"/"+tc.variant, func(t *testing.T) {
			tile := shippedTile(t, tc.tile)
			targets, _, err := Targets(tile, savedConfiguration(t, tile, tc.variant, map[string]string{}))
			if err != nil || len(targets) != 1 || targets[0].Kind != KindMCP {
				t.Fatalf("targets = %+v, err = %v; want one hosted MCP endpoint", targets, err)
			}
			result := (&Prober{}).Probe(context.Background(), targets[0])
			t.Logf("%s: %s", targets[0].URL, result.Message())
			if !result.OK() {
				t.Fatalf("result = %+v, want a pass (connected or sign-in required)", result)
			}
		})
	}
}
```

### Code: internal/web/integration_connection.go (new)

```go
package web

import (
	"errors"
	"net/http"

	"github.com/LeornaAI/leorna-control-plane/internal/integration"
	"github.com/LeornaAI/leorna-control-plane/internal/integration/connectiontest"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// SetIntegrationConnectionTest binds the connection test behind the
// Integrations page's Test connection button (86bcm928p).
func (handler *Handler) SetIntegrationConnectionTest(tester *connectiontest.Tester) {
	handler.connectionTest = tester
}

// integrationTest runs a connection test for the administrator's own saved
// settings and shows the result on the tile's page. The form carries only the
// CSRF token: what is tested is what was saved, never a submitted address.
// Nothing is stored, so the run is not in the change history.
func (handler *Handler) integrationTest(w http.ResponseWriter, r *http.Request) {
	session, form, ok := handler.adminFormLimit(w, r, 4<<10)
	if !ok {
		return
	}
	page, status, message := handler.loadIntegrationPage(r)
	if status != http.StatusOK {
		handler.writeProblem(w, r, status, "INTEGRATION_UNAVAILABLE", message)
		return
	}
	page.Saved = false
	reject := func(status int, message string) { page.Error = message; handler.renderIntegration(w, r, status, page) }
	for key, values := range form {
		if key != "csrfToken" || len(values) != 1 {
			reject(http.StatusBadRequest, "A connection test takes no settings. Reload the page and try again.")
			return
		}
	}
	if handler.connectionTest == nil {
		reject(http.StatusServiceUnavailable, "Connection tests are unavailable on this server.")
		return
	}
	report, err := handler.connectionTest.Run(r.Context(), session.Principal, page.Tile.ID)
	switch {
	case err == nil:
	case errors.Is(err, integration.ErrDeferred):
		reject(http.StatusConflict, integration.ConfigurationDeferral(page.Tile.ID))
		return
	case errors.Is(err, store.ErrNotFound):
		reject(http.StatusNotFound, "Save this integration before testing it.")
		return
	case errors.Is(err, connectiontest.ErrStale):
		reject(http.StatusConflict, "This integration's definition changed since it was saved. Save the settings again, then test.")
		return
	case errors.Is(err, connectiontest.ErrBusy):
		reject(http.StatusTooManyRequests, "Other connection tests are running. Try again in a moment.")
		return
	case errors.Is(err, org.ErrForbidden):
		handler.writeProblem(w, r, http.StatusForbidden, "ADMIN_REQUIRED", "Administration rights are required")
		return
	default:
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "INTEGRATION_TEST_FAILED", "The connection test could not run", err)
		return
	}
	page.Test = &report
	handler.renderIntegration(w, r, http.StatusOK, page)
}
```

### Code: internal/web/integration_connection_test.go (new)

```go
package web

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/json"
	"html"
	"io"
	"log"
	"math/big"
	"net"
	"net/http"
	"net/http/httptest"
	"net/netip"
	"net/url"
	"regexp"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/integration/connectiontest"
)

// connectionNetwork is the whole internet the fixture's connection test can
// see. Names resolve to made-up public addresses and a dial to one of those
// lands on a loopback stub; a name it does not know does not exist. The real
// prober runs with its public-address rule on, so no test reaches a real host.
type connectionNetwork struct {
	t       *testing.T
	trusted connectionAuthority

	mu     sync.Mutex
	names  map[string][]netip.Addr
	routes map[string]string
	dials  int
	next   byte
}

type connectionAuthority struct {
	certificate *x509.Certificate
	key         *ecdsa.PrivateKey
	pool        *x509.CertPool
}

func newConnectionAuthority(t *testing.T) connectionAuthority {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	template := &x509.Certificate{SerialNumber: big.NewInt(1), Subject: pkix.Name{CommonName: "connection test authority"}, NotBefore: time.Now().Add(-time.Hour), NotAfter: time.Now().Add(time.Hour), IsCA: true, BasicConstraintsValid: true, KeyUsage: x509.KeyUsageCertSign}
	der, err := x509.CreateCertificate(rand.Reader, template, template, &key.PublicKey, key)
	if err != nil {
		t.Fatal(err)
	}
	certificate, err := x509.ParseCertificate(der)
	if err != nil {
		t.Fatal(err)
	}
	pool := x509.NewCertPool()
	pool.AddCert(certificate)
	return connectionAuthority{certificate: certificate, key: key, pool: pool}
}

func (issuer connectionAuthority) leaf(t *testing.T, host string) tls.Certificate {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	template := &x509.Certificate{SerialNumber: big.NewInt(2), Subject: pkix.Name{CommonName: host}, DNSNames: []string{host}, NotBefore: time.Now().Add(-time.Hour), NotAfter: time.Now().Add(time.Hour), KeyUsage: x509.KeyUsageDigitalSignature, ExtKeyUsage: []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth}}
	der, err := x509.CreateCertificate(rand.Reader, template, issuer.certificate, &key.PublicKey, issuer.key)
	if err != nil {
		t.Fatal(err)
	}
	return tls.Certificate{Certificate: [][]byte{der}, PrivateKey: key}
}

func (network *connectionNetwork) LookupNetIP(_ context.Context, _ string, host string) ([]netip.Addr, error) {
	network.mu.Lock()
	defer network.mu.Unlock()
	addresses, ok := network.names[host]
	if !ok {
		return nil, &net.DNSError{Err: "no such host", Name: host, IsNotFound: true}
	}
	return append([]netip.Addr(nil), addresses...), nil
}

func (network *connectionNetwork) dial(ctx context.Context, _ string, address string) (net.Conn, error) {
	network.mu.Lock()
	network.dials++
	loopback, ok := network.routes[address]
	network.mu.Unlock()
	if !ok {
		return nil, &net.OpError{Op: "dial", Net: "tcp", Err: io.ErrUnexpectedEOF}
	}
	return (&net.Dialer{}).DialContext(ctx, "tcp", loopback)
}

func (network *connectionNetwork) dialCount() int {
	network.mu.Lock()
	defer network.mu.Unlock()
	return network.dials
}

// point makes host resolve to one fresh made-up public address that leads to
// the loopback address, replacing whatever the name was before.
func (network *connectionNetwork) point(host, loopback string) {
	network.mu.Lock()
	defer network.mu.Unlock()
	network.next++
	address := netip.AddrFrom4([4]byte{93, 184, 216, network.next})
	network.names[host] = []netip.Addr{address}
	network.routes[net.JoinHostPort(address.String(), "443")] = loopback
}

// resolve makes host answer with the given addresses, with no route to them.
func (network *connectionNetwork) resolve(host string, addresses ...string) {
	network.mu.Lock()
	defer network.mu.Unlock()
	parsed := make([]netip.Addr, 0, len(addresses))
	for _, address := range addresses {
		parsed = append(parsed, netip.MustParseAddr(address))
	}
	network.names[host] = parsed
}

// forget makes the name not exist.
func (network *connectionNetwork) forget(host string) {
	network.mu.Lock()
	defer network.mu.Unlock()
	delete(network.names, host)
}

// connectionStub is one HTTPS server on the fake network and what it was sent.
type connectionStub struct {
	mu       sync.Mutex
	requests []connectionRequest
}

type connectionRequest struct {
	Method, Path, Body string
	Header             http.Header
}

func (stub *connectionStub) seen() []connectionRequest {
	stub.mu.Lock()
	defer stub.mu.Unlock()
	return append([]connectionRequest(nil), stub.requests...)
}

// serve starts an HTTPS stub for host with a certificate the prober trusts.
func (network *connectionNetwork) serve(host string, handler http.HandlerFunc) *connectionStub {
	return network.serveWith(network.trusted, host, handler)
}

func (network *connectionNetwork) serveWith(issuer connectionAuthority, host string, handler http.HandlerFunc) *connectionStub {
	network.t.Helper()
	stub := &connectionStub{}
	server := httptest.NewUnstartedServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, _ := io.ReadAll(io.LimitReader(r.Body, 1<<20))
		stub.mu.Lock()
		stub.requests = append(stub.requests, connectionRequest{Method: r.Method, Path: r.URL.Path, Body: string(body), Header: r.Header.Clone()})
		stub.mu.Unlock()
		handler(w, r)
	}))
	server.Config.ErrorLog = log.New(io.Discard, "", 0)
	server.TLS = &tls.Config{Certificates: []tls.Certificate{issuer.leaf(network.t, host)}, MinVersion: tls.VersionTLS12}
	server.StartTLS()
	network.t.Cleanup(server.Close)
	network.point(host, server.Listener.Addr().String())
	return stub
}

// closedPort makes host resolve to an address that refuses connections.
func (network *connectionNetwork) closedPort(host string) {
	network.t.Helper()
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		network.t.Fatal(err)
	}
	loopback := listener.Addr().String()
	if err := listener.Close(); err != nil {
		network.t.Fatal(err)
	}
	network.point(host, loopback)
}

const connectionInitializeReply = `{"jsonrpc":"2.0","id":1,"result":{"protocolVersion":"2025-06-18","capabilities":{},"serverInfo":{"name":"stub","version":"1"}}}`

func connectionMCPJSON(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	_, _ = io.WriteString(w, connectionInitializeReply)
}

func connectionMCPEventStream(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/event-stream")
	_, _ = io.WriteString(w, "event: message\ndata: "+connectionInitializeReply+"\n\n")
}

func connectionSignIn(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("WWW-Authenticate", `Bearer error="invalid_request", resource_metadata="https://stub.example/.well-known/oauth-protected-resource"`)
	http.Error(w, "missing required Authorization header", http.StatusUnauthorized)
}

func connectionWebPage(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_, _ = io.WriteString(w, "<!doctype html><title>Welcome</title><p>Not an MCP server.</p>")
}

// newConnectionFixture is the integrations fixture with the real connection
// tester wired to a fake network.
func newConnectionFixture(t *testing.T) (packFixture, *connectionNetwork) {
	t.Helper()
	f := newIntegrationFixture(t)
	network := &connectionNetwork{t: t, trusted: newConnectionAuthority(t), names: map[string][]netip.Addr{}, routes: map[string]string{}}
	prober := &connectiontest.Prober{Resolver: network, DialContext: network.dial, RootCAs: network.trusted.pool, Timeout: 5 * time.Second}
	f.handler.SetIntegrationConnectionTest(connectiontest.New(f.handler.integrations, prober))
	return f, network
}

func postConnectionTest(t *testing.T, f packFixture, client *http.Client, tile string, form url.Values, status int) string {
	t.Helper()
	response, err := client.PostForm(f.server.URL+"/admin/integrations/"+tile+"/test", form)
	if err != nil {
		t.Fatal(err)
	}
	defer func() { _ = response.Body.Close() }()
	body := html.UnescapeString(readBody(t, response))
	if response.StatusCode != status {
		t.Fatalf("connection test POST %s status=%d want=%d", tile, response.StatusCode, status)
	}
	return body
}

var (
	connectionResultRow = regexp.MustCompile(`(?s)<li data-target-kind="([^"]+)" data-outcome="([^"]+)"><strong>(.*?)</strong><br>(.*?)</li>`)
	connectionSummary   = regexp.MustCompile(`(?s)<p class="([^"]+)" role="status" id="connection-test-summary">(.*?)</p>`)
)

type connectionRow struct{ Kind, Outcome, Title, Message string }

// connectionResult reads the result panel of a rendered page.
func connectionResult(t *testing.T, body string) (summaryClass, summary string, rows []connectionRow) {
	t.Helper()
	match := connectionSummary.FindStringSubmatch(body)
	if match == nil {
		t.Fatalf("page has no connection test result")
	}
	for _, row := range connectionResultRow.FindAllStringSubmatch(body, -1) {
		rows = append(rows, connectionRow{Kind: row[1], Outcome: row[2], Title: row[3], Message: row[4]})
	}
	return match[1], match[2], rows
}

func hasConnectionTestButton(body, tile string) bool {
	return strings.Contains(body, `action="/admin/integrations/`+tile+`/test"`) && strings.Contains(body, ">Test connection</button>")
}

// AC1 (86bcm928p): Given a configured integration, when I click Test, then
// reachability of the URL / MCP endpoint is checked and the result shown
// (without needing a user's credentials).
func TestIntegrationConnectionTestAC1ReachabilityWithPostgres(t *testing.T) {
	f, network := newConnectionFixture(t)
	client := f.login(t, f.admin, strings.Repeat("a", 43))
	form := url.Values{"csrfToken": {f.csrf}}

	t.Run("before anything is saved there is no Test button and a test is refused", func(t *testing.T) {
		if hasConnectionTestButton(f.get(t, client, "/admin/integrations/clickup", http.StatusOK), "clickup") {
			t.Fatal("an integration that was never saved offers Test connection")
		}
		body := postConnectionTest(t, f, client, "clickup", form, http.StatusNotFound)
		if !strings.Contains(body, "Save this integration before testing it.") || strings.Contains(body, `id="connection-test-result"`) {
			t.Fatal("an unsaved integration's test did not say to save first")
		}
		if network.dialCount() != 0 {
			t.Fatalf("an unsaved integration's test dialled %d times", network.dialCount())
		}
	})

	t.Run("a hosted MCP endpoint that answers the handshake is Connected", func(t *testing.T) {
		clickup := network.serve("mcp.clickup.com", connectionMCPJSON)
		postIntegration(t, f, client, "clickup", integrationForm(f, "cloud", "0", ""), http.StatusSeeOther)
		if !hasConnectionTestButton(f.get(t, client, "/admin/integrations/clickup", http.StatusOK), "clickup") {
			t.Fatal("the saved integration's page has no Test connection button")
		}
		before := integrationPersistenceSnapshot(t, f)
		class, summary, rows := connectionResult(t, postConnectionTest(t, f, client, "clickup", form, http.StatusOK))
		if class != "success" || summary != "Connection test passed." || len(rows) != 1 {
			t.Fatalf("summary = %q (%s) with %d rows, want one passed row", summary, class, len(rows))
		}
		if rows[0].Kind != "mcp" || rows[0].Outcome != "connected" || rows[0].Message != "Connected: mcp.clickup.com answered the MCP handshake." {
			t.Fatalf("row = %+v, want the MCP endpoint connected", rows[0])
		}
		requests := clickup.seen()
		if len(requests) != 1 {
			t.Fatalf("the stub MCP server got %d requests, want 1", len(requests))
		}
		var sent struct {
			JSONRPC, Method string
			ID              int
		}
		if err := json.Unmarshal([]byte(requests[0].Body), &sent); err != nil || requests[0].Method != http.MethodPost || requests[0].Path != "/mcp" || sent.JSONRPC != "2.0" || sent.Method != "initialize" || sent.ID != 1 {
			t.Fatalf("the stub got %s %s %q, want one MCP initialize POST to /mcp", requests[0].Method, requests[0].Path, requests[0].Body)
		}
		if after := integrationPersistenceSnapshot(t, f); after != before {
			t.Fatal("a connection test changed the saved configuration or wrote a change record")
		}
	})

	t.Run("an endpoint that asks for sign-in is Reachable, with no credentials sent", func(t *testing.T) {
		github := network.serve("api.githubcopilot.com", connectionSignIn)
		postIntegration(t, f, client, "github", integrationForm(f, "github-com", "0", ""), http.StatusSeeOther)
		if saved := integrationState(t, f).Item.Body; !strings.Contains(saved, `"Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"`) {
			t.Fatalf("fixture: the saved template no longer carries the engineer's credential reference: %s", saved)
		}
		class, summary, rows := connectionResult(t, postConnectionTest(t, f, client, "github", form, http.StatusOK))
		if class != "success" || summary != "Connection test passed." || len(rows) != 1 || rows[0].Outcome != "sign_in_required" {
			t.Fatalf("summary = %q (%s), rows = %+v; want one sign-in-required row that passes", summary, class, rows)
		}
		for _, want := range []string{"Reachable: api.githubcopilot.com answered and asks for sign-in (HTTP 401)", "nobody's credentials", "Engineers sign in on their own devices."} {
			if !strings.Contains(rows[0].Message, want) {
				t.Fatalf("message %q missing %q", rows[0].Message, want)
			}
		}
		requests := github.seen()
		if len(requests) != 1 {
			t.Fatalf("the stub got %d requests, want 1", len(requests))
		}
		for _, name := range []string{"Authorization", "Cookie", "X-Csrf-Token"} {
			if values := requests[0].Header.Values(name); len(values) != 0 {
				t.Fatalf("the test sent %s: %v", name, values)
			}
		}
		if strings.Contains(requests[0].Body, "GITHUB_PERSONAL_ACCESS_TOKEN") || strings.Contains(requests[0].Body, strings.Repeat("a", 43)) {
			t.Fatal("the test sent a credential reference or the administrator's session")
		}
	})

	t.Run("an entered address and its hosted MCP endpoint are both checked", func(t *testing.T) {
		address := network.serve("acme.ghe.com", connectionWebPage)
		endpoint := network.serve("copilot-api.acme.ghe.com", connectionMCPEventStream)
		form := integrationForm(f, "ghe-com", "1", "")
		form.Set("param.instance", "https://acme.ghe.com")
		postIntegration(t, f, client, "github", form, http.StatusSeeOther)
		body := postConnectionTest(t, f, client, "github", url.Values{"csrfToken": {f.csrf}}, http.StatusOK)
		class, summary, rows := connectionResult(t, body)
		if class != "success" || summary != "Connection test passed." || len(rows) != 2 {
			t.Fatalf("summary = %q (%s) with rows %+v, want two passed rows", summary, class, rows)
		}
		if rows[0] != (connectionRow{"address", "reachable", "GHE.com address", "Reachable: acme.ghe.com was found, accepted a connection and has a valid certificate."}) {
			t.Fatalf("address row = %+v", rows[0])
		}
		if rows[1] != (connectionRow{"mcp", "connected", "MCP endpoint (github)", "Connected: copilot-api.acme.ghe.com answered the MCP handshake."}) {
			t.Fatalf("endpoint row = %+v", rows[1])
		}
		if len(address.seen()) != 0 || len(endpoint.seen()) != 1 {
			t.Fatalf("the address got %d HTTP requests and the endpoint %d; want 0 and 1", len(address.seen()), len(endpoint.seen()))
		}
		if !strings.Contains(body, "Tested from the Leorna server with the saved GitHub Enterprise Cloud with data residency (GHE.com) settings and nobody's credentials. Nothing was saved or changed.") {
			t.Fatal("the result does not say which saved settings were tested")
		}
	})

	t.Run("a server that runs on the engineer's device is shown as not tested from the server", func(t *testing.T) {
		network.serve("github.acme.example", connectionWebPage)
		postIntegration(t, f, client, "github", integrationForm(f, "enterprise-server", "2", "https://github.acme.example"), http.StatusSeeOther)
		class, summary, rows := connectionResult(t, postConnectionTest(t, f, client, "github", form, http.StatusOK))
		if class != "success" || summary != "Connection test passed." || len(rows) != 2 {
			t.Fatalf("summary = %q (%s) with rows %+v, want the address passed and the local server listed", summary, class, rows)
		}
		if rows[0].Kind != "address" || rows[0].Outcome != "reachable" || rows[0].Title != "Server address" || !strings.Contains(rows[0].Message, "github.acme.example") {
			t.Fatalf("address row = %+v", rows[0])
		}
		if rows[1] != (connectionRow{"local", "not_testable", "Local MCP server (github)", "Not tested: this server is started on the engineer's device, so the Leorna server has no address to reach."}) {
			t.Fatalf("local server row = %+v", rows[1])
		}
	})
}

// AC2 (86bcm928p): Given a failure, then the message says what failed (DNS,
// TLS, unreachable, not an MCP endpoint).
func TestIntegrationConnectionTestAC2FailureMessagesWithPostgres(t *testing.T) {
	f, network := newConnectionFixture(t)
	client := f.login(t, f.admin, strings.Repeat("a", 43))
	saved := integrationForm(f, "ghe-com", "0", "")
	saved.Set("param.instance", "https://acme.ghe.com")
	postIntegration(t, f, client, "github", saved, http.StatusSeeOther)
	network.serve("acme.ghe.com", connectionWebPage)
	const endpoint = "copilot-api.acme.ghe.com"

	cases := []struct {
		name, outcome, message string
		arrange                func()
	}{
		{"DNS failure", "dns_failed", "DNS failed: the name copilot-api.acme.ghe.com could not be found. Check the address for typos.", func() { network.forget(endpoint) }},
		{"TLS failure", "tls_failed", "TLS failed: copilot-api.acme.ghe.com accepted a connection, but a secure connection with a valid certificate for that name could not be set up.", func() { network.serveWith(newConnectionAuthority(t), endpoint, connectionMCPJSON) }},
		{"unreachable", "unreachable", "Unreachable: copilot-api.acme.ghe.com did not accept a connection on port 443 (refused or timed out).", func() { network.closedPort(endpoint) }},
		{"not an MCP endpoint", "not_mcp", "Not an MCP endpoint: copilot-api.acme.ghe.com answered (HTTP 200), but not with an MCP reply.", func() { network.serve(endpoint, connectionWebPage) }},
	}
	steps := []string{"DNS failed", "TLS failed", "Unreachable", "Not an MCP endpoint"}
	messages := map[string]string{}
	for index, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			tc.arrange()
			class, summary, rows := connectionResult(t, postConnectionTest(t, f, client, "github", url.Values{"csrfToken": {f.csrf}}, http.StatusOK))
			if class != "alert" || summary != "Connection test failed. The lines below say which step failed." || len(rows) != 2 {
				t.Fatalf("summary = %q (%s) with rows %+v, want a failed test with two rows", summary, class, rows)
			}
			if rows[0].Outcome != "reachable" {
				t.Fatalf("the healthy address row = %+v, want it still reachable", rows[0])
			}
			failed := rows[1]
			if failed.Kind != "mcp" || failed.Outcome != tc.outcome || failed.Message != tc.message {
				t.Fatalf("failed row = %+v, want %s: %q", failed, tc.outcome, tc.message)
			}
			if !strings.HasPrefix(failed.Message, steps[index]+":") {
				t.Fatalf("message %q does not start by naming the step %q", failed.Message, steps[index])
			}
			for other, step := range steps {
				if other != index && strings.Contains(failed.Message, step) {
					t.Fatalf("message %q also names the step %q", failed.Message, step)
				}
			}
			if previous, repeated := messages[failed.Message]; repeated {
				t.Fatalf("%s and %s show the same message", tc.name, previous)
			}
			messages[failed.Message] = tc.name
		})
	}
	if len(messages) != len(cases) {
		t.Fatalf("saw %d distinct failure messages, want %d", len(messages), len(cases))
	}

	t.Run("after the endpoint is fixed the same test passes", func(t *testing.T) {
		network.serve(endpoint, connectionMCPJSON)
		class, summary, _ := connectionResult(t, postConnectionTest(t, f, client, "github", url.Values{"csrfToken": {f.csrf}}, http.StatusOK))
		if class != "success" || summary != "Connection test passed." {
			t.Fatalf("summary = %q (%s), want passed", summary, class)
		}
	})
}

// Guards: only an administrator of the integration's own company can run a
// test, it can only test what was saved, and it never reaches inside.
func TestIntegrationConnectionTestGuardsWithPostgres(t *testing.T) {
	f, network := newConnectionFixture(t)
	admin := f.login(t, f.admin, strings.Repeat("a", 43))
	form := url.Values{"csrfToken": {f.csrf}}
	saved := integrationForm(f, "ghe-com", "0", "")
	saved.Set("param.instance", "https://alpha.ghe.com")
	postIntegration(t, f, admin, "github", saved, http.StatusSeeOther)
	address := network.serve("alpha.ghe.com", connectionWebPage)
	endpoint := network.serve("copilot-api.alpha.ghe.com", connectionMCPJSON)
	untouched := func(t *testing.T, who string) {
		t.Helper()
		if network.dialCount() != 0 || len(address.seen())+len(endpoint.seen()) != 0 {
			t.Fatalf("%s made the server connect (%d dials)", who, network.dialCount())
		}
	}

	t.Run("a member cannot run a test", func(t *testing.T) {
		member := f.login(t, f.member, strings.Repeat("m", 43))
		// ADMIN_REQUIRED is the route's own guard; the store's second check
		// would answer INTEGRATION_UNAVAILABLE.
		if body := postConnectionTest(t, f, member, "github", form, http.StatusForbidden); !strings.Contains(body, "ADMIN_REQUIRED") {
			t.Fatal("the member was not refused by the route's administrator guard")
		}
		untouched(t, "a member")
	})
	t.Run("a signed-out visitor cannot run a test", func(t *testing.T) {
		postConnectionTest(t, f, newTestClient(t, f.server), "github", form, http.StatusUnauthorized)
		untouched(t, "a signed-out visitor")
	})
	t.Run("a wrong CSRF token is refused", func(t *testing.T) {
		postConnectionTest(t, f, admin, "github", url.Values{"csrfToken": {strings.Repeat("x", 43)}}, http.StatusForbidden)
		untouched(t, "a forged request")
	})
	t.Run("a GET does not run a test", func(t *testing.T) {
		response := request(t, admin, http.MethodGet, f.server.URL+"/admin/integrations/github/test", "", "")
		closeBody(t, response)
		if response.StatusCode == http.StatusOK {
			t.Fatal("GET /admin/integrations/github/test answered 200")
		}
		untouched(t, "a GET")
	})
	t.Run("the form cannot name an address to test", func(t *testing.T) {
		for _, field := range []string{"param.instance", "url", "variant", "target"} {
			smuggled := url.Values{"csrfToken": {f.csrf}, field: {"https://inside.example"}}
			body := postConnectionTest(t, f, admin, "github", smuggled, http.StatusBadRequest)
			if !strings.Contains(body, "A connection test takes no settings.") || strings.Contains(body, "inside.example") {
				t.Fatalf("a submitted %s was not refused plainly", field)
			}
		}
		untouched(t, "a submitted address")
	})
	t.Run("another company's administrator cannot test this company's integration", func(t *testing.T) {
		other := f.login(t, f.other, strings.Repeat("o", 43))
		body := postConnectionTest(t, f, other, "github", form, http.StatusNotFound)
		if strings.Contains(body, "alpha.ghe.com") || !strings.Contains(body, "Save this integration before testing it.") {
			t.Fatal("another company's administrator saw this company's address or ran its test")
		}
		if hasConnectionTestButton(f.get(t, other, "/admin/integrations/github", http.StatusOK), "github") {
			t.Fatal("another company's page offers Test connection for an integration it never saved")
		}
		untouched(t, "another company's administrator")
	})
	t.Run("another company's test checks only its own saved address", func(t *testing.T) {
		other := f.login(t, f.other, strings.Repeat("p", 43))
		theirs := network.serve("copilot-api.beta.ghe.com", connectionMCPJSON)
		network.serve("beta.ghe.com", connectionWebPage)
		otherForm := integrationForm(f, "ghe-com", "0", "")
		otherForm.Set("param.instance", "https://beta.ghe.com")
		postIntegration(t, f, other, "github", otherForm, http.StatusSeeOther)
		body := postConnectionTest(t, f, other, "github", form, http.StatusOK)
		if strings.Contains(body, "alpha.ghe.com") || !strings.Contains(body, "copilot-api.beta.ghe.com") {
			t.Fatal("another company's result names the wrong company's address")
		}
		if len(theirs.seen()) != 1 || len(address.seen())+len(endpoint.seen()) != 0 {
			t.Fatalf("their endpoint got %d requests and this company's stubs %d; want 1 and 0", len(theirs.seen()), len(address.seen())+len(endpoint.seen()))
		}
	})
	t.Run("a private address is never dialled and is reported honestly", func(t *testing.T) {
		before := network.dialCount()
		network.resolve("github.inside.example", "10.20.30.40")
		postIntegration(t, f, admin, "github", integrationForm(f, "enterprise-server", "1", "https://github.inside.example"), http.StatusSeeOther)
		class, summary, rows := connectionResult(t, postConnectionTest(t, f, admin, "github", form, http.StatusOK))
		if class != "alert" || summary != "Connection test incomplete: nothing failed, but the Leorna server could not check everything." || len(rows) != 2 {
			t.Fatalf("summary = %q (%s) with rows %+v", summary, class, rows)
		}
		if rows[0].Outcome != "address_refused" || rows[0].Message != "Not checked: github.inside.example is not a public internet address. The Leorna server only tests public addresses; engineers' devices may still reach it." {
			t.Fatalf("private address row = %+v", rows[0])
		}
		if network.dialCount() != before {
			t.Fatalf("a private address was dialled (%d dials)", network.dialCount()-before)
		}
	})
	t.Run("nothing a server replies with reaches the page", func(t *testing.T) {
		const marker = "MARKER-7f3a"
		markerForm := integrationForm(f, "ghe-com", "2", "")
		markerForm.Set("param.instance", "https://marker.ghe.com")
		postIntegration(t, f, admin, "github", markerForm, http.StatusSeeOther)
		network.serve("marker.ghe.com", connectionWebPage)
		for name, reply := range map[string]http.HandlerFunc{
			"a handshake reply": func(w http.ResponseWriter, _ *http.Request) {
				w.Header().Set("Content-Type", "application/json")
				_, _ = io.WriteString(w, strings.Replace(connectionInitializeReply, `"name":"stub"`, `"name":"<script>`+marker+`</script>"`, 1))
			},
			"a sign-in challenge": func(w http.ResponseWriter, _ *http.Request) {
				w.Header().Set("WWW-Authenticate", `Bearer realm="`+marker+`"`)
				http.Error(w, marker, http.StatusUnauthorized)
			},
			"a web page": func(w http.ResponseWriter, _ *http.Request) {
				w.Header().Set("Content-Type", "text/html")
				_, _ = io.WriteString(w, "<h1>"+marker+"</h1>")
			},
		} {
			network.serve("copilot-api.marker.ghe.com", reply)
			if body := postConnectionTest(t, f, admin, "github", form, http.StatusOK); strings.Contains(body, marker) || !strings.Contains(body, `id="connection-test-result"`) {
				t.Fatalf("%s: the page shows text from the server's reply, or no result", name)
			}
		}
	})
	t.Run("a Google configuration is refused without connecting", func(t *testing.T) {
		g, googleNetwork := newConnectionFixture(t)
		googleAdmin := g.login(t, g.admin, strings.Repeat("a", 43))
		seedLegacyGoogleConfiguration(t, g, googleAdmin)
		body := postConnectionTest(t, g, googleAdmin, "google-workspace", url.Values{"csrfToken": {g.csrf}}, http.StatusConflict)
		if !strings.Contains(body, "Google Workspace configuration is unavailable until native client setup support is released.") || strings.Contains(body, ">Test connection</button>") || googleNetwork.dialCount() != 0 {
			t.Fatal("a deferred Google configuration was testable")
		}
	})
	t.Run("without a tester there is no button and a test says so", func(t *testing.T) {
		f.handler.SetIntegrationConnectionTest(nil)
		if hasConnectionTestButton(f.get(t, admin, "/admin/integrations/github", http.StatusOK), "github") {
			t.Fatal("a server without the tester offers Test connection")
		}
		if body := postConnectionTest(t, f, admin, "github", form, http.StatusServiceUnavailable); !strings.Contains(body, "Connection tests are unavailable on this server.") {
			t.Fatal("a server without the tester did not say so")
		}
	})
}
```

### Code: internal/web/integration_connection_browser_test.go (new)

```go
package web

import (
	"bytes"
	"context"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/chromedp/cdproto/network"
	"github.com/chromedp/chromedp"
)

// This opt-in clicks the real Test connection button in a real browser, on the
// real TLS admin handlers and Postgres, and saves one picture of the page per
// result into LEORNA_CONNECTION_TEST_EVIDENCE_DIR. The fake network stands in
// for the internet, so no request leaves this machine.
func TestIntegrationConnectionTestBrowserEvidenceWithPostgres(t *testing.T) {
	output, chrome := os.Getenv("LEORNA_CONNECTION_TEST_EVIDENCE_DIR"), os.Getenv("LEORNA_INTEGRATIONS_CHROME_BIN")
	if output == "" || chrome == "" {
		t.Skip("set LEORNA_CONNECTION_TEST_EVIDENCE_DIR and LEORNA_INTEGRATIONS_CHROME_BIN for the connection test screenshots")
	}
	f, fake := newConnectionFixture(t)
	token := strings.Repeat("a", 43)
	client := f.login(t, f.admin, token)
	if directory := os.Getenv("LEORNA_INTEGRATIONS_CHROME_TMP"); directory != "" {
		t.Setenv("TMPDIR", directory)
	}
	profile, err := os.MkdirTemp("", "ct-")
	if err != nil {
		t.Fatal(err)
	}
	defer func() { _ = os.RemoveAll(profile) }()
	ctx, cancel := context.WithTimeout(context.Background(), 150*time.Second)
	defer cancel()
	opts := append(chromedp.DefaultExecAllocatorOptions[:], chromedp.ExecPath(chrome), chromedp.UserDataDir(profile), chromedp.Flag("no-sandbox", true), chromedp.Flag("no-zygote", true), chromedp.Flag("disable-gpu", true), chromedp.Flag("disable-software-rasterizer", true), chromedp.Flag("disable-dev-shm-usage", true), chromedp.Flag("ignore-certificate-errors", true))
	allocator, stop := chromedp.NewExecAllocator(ctx, opts...)
	defer stop()
	browser, closeBrowser := chromedp.NewContext(allocator)
	defer closeBrowser()
	if err := chromedp.Run(browser, chromedp.EmulateViewport(1280, 900), network.Enable(), network.SetCookie(sessionCookieName, token).WithURL(f.server.URL).WithPath("/").WithSecure(true), network.SetCookie(csrfCookieName, f.csrf).WithURL(f.server.URL).WithPath("/").WithSecure(true)); err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(output, 0o700); err != nil {
		t.Fatal(err)
	}
	// shoot opens the tile's page (which has no result yet), clicks the button,
	// waits for the result page and saves it once it shows the expected lines.
	shoot := func(file, tile, summary string, lines ...string) {
		t.Helper()
		var shown string
		var picture []byte
		err := chromedp.Run(browser,
			chromedp.Navigate(f.server.URL+"/admin/integrations/"+tile),
			chromedp.WaitVisible(`#connection-test button`, chromedp.ByQuery),
			chromedp.Click(`#connection-test button`, chromedp.ByQuery),
			chromedp.WaitVisible(`#connection-test-result`, chromedp.ByQuery),
			chromedp.Text(`#connection-test-result`, &shown, chromedp.ByQuery),
			chromedp.FullScreenshot(&picture, 100),
		)
		if err != nil {
			t.Fatalf("%s: %v", file, err)
		}
		for _, want := range append([]string{summary}, lines...) {
			if !strings.Contains(shown, want) {
				t.Fatalf("%s: the result panel does not show %q:\n%s", file, want, shown)
			}
		}
		if !bytes.HasPrefix(picture, []byte("\x89PNG\r\n\x1a\n")) {
			t.Fatalf("%s: the capture is not a PNG", file)
		}
		if err := os.WriteFile(filepath.Join(output, file), picture, 0o600); err != nil {
			t.Fatal(err)
		}
	}
	const passed, failed = "Connection test passed.", "Connection test failed. The lines below say which step failed."

	fake.serve("mcp.clickup.com", connectionMCPJSON)
	postIntegration(t, f, client, "clickup", integrationForm(f, "cloud", "0", ""), http.StatusSeeOther)
	shoot("ac1-connected.png", "clickup", passed, "Connected: mcp.clickup.com answered the MCP handshake.")

	fake.serve("api.githubcopilot.com", connectionSignIn)
	postIntegration(t, f, client, "github", integrationForm(f, "github-com", "0", ""), http.StatusSeeOther)
	shoot("ac1-sign-in-required.png", "github", passed, "Reachable: api.githubcopilot.com answered and asks for sign-in (HTTP 401).")

	fake.serve("github.acme.example", connectionWebPage)
	postIntegration(t, f, client, "github", integrationForm(f, "enterprise-server", "1", "https://github.acme.example"), http.StatusSeeOther)
	shoot("ac1-address-and-local-server.png", "github", passed, "Reachable: github.acme.example was found, accepted a connection and has a valid certificate.", "Not tested: this server is started on the engineer's device")

	const endpoint = "copilot-api.acme.ghe.com"
	fake.serve("acme.ghe.com", connectionWebPage)
	fake.serve(endpoint, connectionMCPEventStream)
	ghe := integrationForm(f, "ghe-com", "2", "")
	ghe.Set("param.instance", "https://acme.ghe.com")
	postIntegration(t, f, client, "github", ghe, http.StatusSeeOther)
	shoot("ac1-address-and-endpoint.png", "github", passed, "Reachable: acme.ghe.com was found", "Connected: "+endpoint+" answered the MCP handshake.")

	fake.forget(endpoint)
	shoot("ac2-dns-failed.png", "github", failed, "DNS failed: the name "+endpoint+" could not be found.")
	fake.serveWith(newConnectionAuthority(t), endpoint, connectionMCPJSON)
	shoot("ac2-tls-failed.png", "github", failed, "TLS failed: "+endpoint+" accepted a connection")
	fake.closedPort(endpoint)
	shoot("ac2-unreachable.png", "github", failed, "Unreachable: "+endpoint+" did not accept a connection on port 443")
	fake.serve(endpoint, connectionWebPage)
	shoot("ac2-not-an-mcp-endpoint.png", "github", failed, "Not an MCP endpoint: "+endpoint+" answered (HTTP 200), but not with an MCP reply.")
}
```

### Code: Production patch for internal/web/handler.go, internal/web/integrations.go and cmd/control-plane/main.go (apply with `git apply`; checked with `git apply --check` on base `4ef14ef`)

```diff
--- a/internal/web/handler.go
+++ b/internal/web/handler.go
@@ -27,6 +27,7 @@
 	"github.com/LeornaAI/leorna-control-plane/internal/cloud"
 	"github.com/LeornaAI/leorna-control-plane/internal/console"
 	"github.com/LeornaAI/leorna-control-plane/internal/integration"
+	"github.com/LeornaAI/leorna-control-plane/internal/integration/connectiontest"
 	"github.com/LeornaAI/leorna-control-plane/internal/library"
 	"github.com/LeornaAI/leorna-control-plane/internal/metric"
 	"github.com/LeornaAI/leorna-control-plane/internal/onboarding"
@@ -78,6 +79,7 @@
 	packOverviewActors            packOverviewActorReader
 	libraryCatalog                library.Catalog
 	integrations                  *integration.Service
+	connectionTest                *connectiontest.Tester
 	audit                         audit.Repository
 	contentLibrary                *library.Library // the shipped content library, for the Third-party content page
 	teams                         org.Repository
@@ -306,6 +308,7 @@
 	routes.Handle("GET /admin/integrations", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.integrationView)), true))
 	routes.Handle("GET /admin/integrations/{tileID}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.integrationView)), true))
 	routes.Handle("POST /admin/integrations/{tileID}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.integrationSave)), false))
+	routes.Handle("POST /admin/integrations/{tileID}/test", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.integrationTest)), false))
 	routes.Handle("GET /admin/library", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryView)), true))
 	routes.Handle("GET /admin/library/items/{itemId}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryItemView)), true))
 	routes.Handle("POST /admin/library/items/{itemId}/customise", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryCustomiseForm)), false))
--- a/internal/web/integrations.go
+++ b/internal/web/integrations.go
@@ -10,6 +10,7 @@
 
 	"github.com/LeornaAI/leorna-control-plane/internal/auth"
 	"github.com/LeornaAI/leorna-control-plane/internal/integration"
+	"github.com/LeornaAI/leorna-control-plane/internal/integration/connectiontest"
 	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
 	"github.com/LeornaAI/leorna-control-plane/internal/org"
 	"github.com/LeornaAI/leorna-control-plane/internal/store"
@@ -33,6 +34,10 @@
 	Values             map[string]string
 	Revision           int64
 	Saved              bool
+	// CanTest shows the Test connection button: saved settings exist for a
+	// configurable tile and the tester is wired. Test is one finished run.
+	CanTest bool
+	Test    *connectiontest.Report
 }
 
 func (handler *Handler) integrationView(w http.ResponseWriter, r *http.Request) {
@@ -105,6 +110,7 @@
 			page.Values = config.Values
 		}
 		page.Saved = page.UnavailableReason == "" && r.URL.Query().Get("saved") == "1"
+		page.CanTest = handler.connectionTest != nil && page.UnavailableReason == "" && config.Revision > 0
 	}
 	return page, http.StatusOK, ""
 }
@@ -226,6 +232,10 @@
 <h3>Declared company parameters</h3><ul>{{range .Variant.Params}}<li>{{.Label}}</li>{{else}}<li>No company parameters</li>{{end}}</ul>
 {{if .Revision}}<p class="muted">Previously saved settings are retained. Existing pack versions keep their saved snapshots; no values have been changed.</p>{{end}}</section>
 {{else}}
+{{if .Test}}<section class="panel" id="connection-test-result" aria-labelledby="connection-test-result-title"><h2 id="connection-test-result-title">Connection test result</h2>
+<p class="{{if .Test.Passed}}success{{else}}alert{{end}}" role="status" id="connection-test-summary">{{.Test.Summary}}</p>
+<ul>{{range .Test.Results}}<li data-target-kind="{{.Target.Kind}}" data-outcome="{{.Outcome}}"><strong>{{.Target.Title}}</strong><br>{{.Message}}</li>{{end}}</ul>
+<p class="muted">Tested from the Leorna server with the saved {{.Test.VariantName}} settings and nobody's credentials. Nothing was saved or changed.</p></section>{{end}}
 <section class="panel" aria-labelledby="settings-title"><h2 id="settings-title">Company settings</h2>
 <form method="get"><label for="hosting">Hosting</label><select id="hosting" name="variant">{{range .Tile.Variants}}<option value="{{.ID}}"{{if eq .ID $.Variant.ID}} selected{{end}}>{{.Name}}</option>{{end}}</select><button type="submit">Choose variant</button></form>
 <h3>{{.Variant.Name}}</h3><p class="muted">{{.Variant.Description}}</p>
@@ -234,6 +244,8 @@
 {{range .Variant.Params}}<label for="param-{{.Name}}">{{.Label}}{{if .Required}} (required){{end}}</label><input id="param-{{.Name}}" name="param.{{.Name}}" type="{{.Type}}" value="{{index $.Values .Name}}" maxlength="2048"{{if .Required}} required{{end}} aria-describedby="help-{{.Name}}" placeholder="{{.Example}}"><p class="help" id="help-{{.Name}}">{{.Help}}</p>{{else}}<p>No company parameters are needed for this variant.</p>{{end}}
 <button type="submit">Save integration</button></form>
 <p class="muted">Existing pack versions keep their saved settings. After editing an integration, remove and re-add its item when creating a new pack version.</p></section>
+{{if .CanTest}}<section class="panel" id="connection-test" aria-labelledby="connection-test-title"><h2 id="connection-test-title">Test connection</h2><p class="muted">Checks from the Leorna server that the saved addresses and hosted MCP endpoints can be reached. It uses nobody's credentials and changes nothing.</p>
+<form method="post" action="/admin/integrations/{{.Tile.ID}}/test"><input type="hidden" name="csrfToken" value="{{.CSRF}}"><button type="submit">Test connection</button></form></section>{{end}}
 <section class="panel" aria-labelledby="tools-title"><h2 id="tools-title">Tools and sign-in</h2><p class="muted">Sign-in happens on the engineer's device. Saving these settings does not connect to the provider or collect credentials.</p>
 <ul>{{range .Variant.Tools}}<li>{{.Tool.Label}}: {{if .Supported}}{{.SignIn.Method}}{{if .SignIn.TokenEnvVar}} · environment variable <code>{{.SignIn.TokenEnvVar}}</code>{{end}}{{if .SignIn.ClientSecretEnvVar}} · client secret in <code>{{.SignIn.ClientSecretEnvVar}}</code>{{end}}{{if .SignIn.HelpURL}} · <a href="{{.SignIn.HelpURL}}">Provider guidance</a>{{end}}{{else}}not supported{{end}}</li>{{end}}</ul>
 <p class="muted">{{.Tile.Stage}} definition — review the provider's requirements before use.</p></section>
--- a/cmd/control-plane/main.go
+++ b/cmd/control-plane/main.go
@@ -24,6 +24,7 @@
 	"github.com/LeornaAI/leorna-control-plane/internal/genai"
 	"github.com/LeornaAI/leorna-control-plane/internal/health"
 	"github.com/LeornaAI/leorna-control-plane/internal/integration"
+	"github.com/LeornaAI/leorna-control-plane/internal/integration/connectiontest"
 	"github.com/LeornaAI/leorna-control-plane/internal/itembuilder"
 	knowledgeclickhouse "github.com/LeornaAI/leorna-control-plane/internal/knowledge/clickhouse"
 	"github.com/LeornaAI/leorna-control-plane/internal/knowledge/compaction"
@@ -215,7 +216,10 @@
 	if err != nil {
 		return err
 	}
-	application.SetIntegrations(integration.NewService(repository, integrationTiles, gate.NewGitleaks("gitleaks")))
+	integrations := integration.NewService(repository, integrationTiles, gate.NewGitleaks("gitleaks"))
+	application.SetIntegrations(integrations)
+	// Connection tests (86bcm928p) use the production prober: public addresses only.
+	application.SetIntegrationConnectionTest(connectiontest.New(integrations, &connectiontest.Prober{}))
 	starterPacks, err := library.EmbeddedStarterPacks()
 	if err != nil {
 		return err
```

### Code: mutants.py (kept outside the repo)

```python
#!/usr/bin/env python3
"""86bcm928p mutation proofs: one-line mutants run through `go test -overlay`.

A mutant is KILLED when its named test fails on an assertion. The worktree is
never edited: each mutant is a scratch copy of one file, mapped in by overlay.

  MUT_REPO=<worktree> MUT_OUT=<receipts folder> python3 -I mutants.py [M1 W3 ...]

Run it with env.sh sourced (Go on PATH, LEORNA_TEST_DATABASE_URL set). Each
`go test` runs under a 4G memory cap. Exit 1 unless every chosen mutant is killed.
"""
import json
import os
import subprocess
import sys

REPO = os.environ["MUT_REPO"]
OUT = os.environ["MUT_OUT"]
P = "internal/integration/connectiontest/prober.go"
T = "internal/integration/connectiontest/tester.go"
H = "internal/web/handler.go"
W = "internal/web/integration_connection.go"
I = "internal/web/integrations.go"
CT = "./internal/integration/connectiontest/"
WEB = "./internal/web/"
PUBLIC = 'if address.Zone() != "" || !domain.PublicAddress(address) {'
SIGN_IN = "if response.StatusCode == http.StatusUnauthorized {"
# (id, what the mutant removes, file, old text (must occur once), new text, package, test that must fail)
MUTANTS = [
    ("M1", "public-address rule off", P, PUBLIC, 'if address.Zone() != "" || !domain.PublicAddress(address) && index < 0 {', CT, "TestProbeRefusesAddressesThatAreNotPublic"),
    ("M2", "only the first resolved address is checked", P, PUBLIC, 'if index == 0 && (address.Zone() != "" || !domain.PublicAddress(address)) {', CT, "TestProbeRefusesAddressesThatAreNotPublic"),
    ("M3", "redirects are followed", P, "CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }", "CheckRedirect: nil", CT, "TestProbeNeverFollowsARedirect"),
    ("M4", "the name is resolved a second time", P, "\t\tif err != nil || len(found) == 0 {\n\t\t\treturn nil, DNSFailed\n\t\t}\n", '\t\tfound, err = resolver.LookupNetIP(ctx, "ip", host)\n\t\tif err != nil || len(found) == 0 {\n\t\t\treturn nil, DNSFailed\n\t\t}\n', CT, "TestProbeResolvesOnceAndDialsOnlyTheCheckedAddress"),
    ("M5", "a credential header is sent", P, '\trequest.Header.Set("User-Agent", "Leorna-Connection-Test")\n', '\trequest.Header.Set("User-Agent", "Leorna-Connection-Test")\n\trequest.Header.Set("Authorization", "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}")\n', CT, "TestProbeSendsNoCredentialsAndKeepsNothingFromTheReply"),
    ("M6", "the reply size bound is gone", P, "body := io.LimitReader(response.Body, maxBodyBytes)", "body := io.LimitReader(response.Body, 64<<20)", CT, "TestProbeBoundsTimeAndReplySize"),
    ("M7", "401 is a failure", P, SIGN_IN, "if response.StatusCode == 4010 {", CT, "TestProbeSignInRequiredIsReachableNotAFailure"),
    ("M8", "an address check sends an HTTP request", P, "if target.Kind == KindAddress {\n\t\tresult.Outcome = Reachable", 'if target.Kind == KindAddress && result.Host == "" {\n\t\tresult.Outcome = Reachable', CT, "TestProbeAddressStopsAfterTheCertificateCheck"),
    ("M9", "a reply to another request counts", P, "string(bytes.TrimSpace(reply.ID)) == requestID && ", 'string(bytes.TrimSpace(reply.ID)) != requestID+"x" && ', CT, "TestProbeNamesTheStepThatFailed"),
    ("M10", "another company's settings are read", T, "config, err := tester.service.Configuration(ctx, actor, tileID)", 'config, err := tester.service.Configuration(ctx, store.Principal{UserID: "admin-a", TenantID: "tenant-a"}, tileID)', CT, "TestTesterChecksOnlyTheActorsOwnCompanyConfiguration"),
    ("M11", "no bound on tests running at once", T, "\tdefault:\n\t\treturn Report{}, ErrBusy\n\t}", "\t}", CT, "TestTesterRunsAtMostTwoTestsAtOnce"),
    ("M12", "a deferred tile is tested", T, 'if integration.ConfigurationDeferral(tileID) != "" {', 'if integration.ConfigurationDeferral(tileID) == "never" {', CT, "TestTesterRefusesADeferredTileWithoutReadingOrConnecting"),
    ("M13", "certificates are not verified", P, "secure := tls.Client(conn, &tls.Config{ServerName: result.Host, RootCAs: prober.RootCAs,", "secure := tls.Client(conn, &tls.Config{ServerName: result.Host, RootCAs: prober.RootCAs, InsecureSkipVerify: true,", CT, "TestProbeNamesTheStepThatFailed"),
    ("W1", "the route has no administrator guard", H, 'routes.Handle("POST /admin/integrations/{tileID}/test", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.integrationTest)), false))', 'routes.Handle("POST /admin/integrations/{tileID}/test", handler.requireSession(http.HandlerFunc(handler.integrationTest), false))', WEB, "TestIntegrationConnectionTestGuardsWithPostgres"),
    ("W2", "the form may carry other fields", W, '\t\tif key != "csrfToken" || len(values) != 1 {', '\t\tif key == "never" || len(values) != 1 {', WEB, "TestIntegrationConnectionTestGuardsWithPostgres"),
    ("W3", "the button shows before anything is saved", I, 'page.CanTest = handler.connectionTest != nil && page.UnavailableReason == "" && config.Revision > 0', 'page.CanTest = handler.connectionTest != nil && page.UnavailableReason == ""', WEB, "TestIntegrationConnectionTestAC1ReachabilityWithPostgres"),
    ("W4", "public-address rule off, seen from the page", P, PUBLIC, 'if address.Zone() != "" || !domain.PublicAddress(address) && index < 0 {', WEB, "TestIntegrationConnectionTestGuardsWithPostgres"),
    ("W5", "401 is a failure, seen from the page", P, SIGN_IN, "if response.StatusCode == 4010 {", WEB, "TestIntegrationConnectionTestAC1ReachabilityWithPostgres"),
    ("W6", "a TLS failure is reported as unreachable", P, "\t\tresult.Outcome = TLSFailed\n", "\t\tresult.Outcome = Unreachable\n", WEB, "TestIntegrationConnectionTestAC2FailureMessagesWithPostgres"),
]

os.makedirs(OUT, exist_ok=True)
chosen = set(sys.argv[1:])
survivors = 0
for name, what, path, old, new, package, test in MUTANTS:
    if chosen and name not in chosen:
        continue
    source = open(os.path.join(REPO, path), encoding="utf-8").read()
    if source.count(old) != 1:
        print(f"{name} ANCHOR-NOT-UNIQUE ({source.count(old)} matches) :: {what}", flush=True)
        survivors += 1
        continue
    mutated = os.path.join(OUT, f"{name}.go.txt")
    with open(mutated, "w", encoding="utf-8") as handle:
        handle.write(source.replace(old, new))
    overlay = os.path.join(OUT, f"{name}.overlay.json")
    with open(overlay, "w", encoding="utf-8") as handle:
        json.dump({"Replace": {os.path.join(REPO, path): mutated}}, handle)
    command = ["systemd-run", "--user", "--scope", "-q", "-p", "MemoryMax=4G", "-p", "MemorySwapMax=0",
               "go", "test", "-count=1", "-timeout", "120s", "-overlay", overlay, "-run", f"^{test}$", package]
    run = subprocess.run(command, cwd=REPO, capture_output=True, text=True)
    output = run.stdout + run.stderr
    with open(os.path.join(OUT, f"{name}.log"), "w", encoding="utf-8") as handle:
        handle.write(f"MUTANT={name} :: {what}\n{output}EXIT={run.returncode}\n")
    if "[build failed]" in output or "[setup failed]" in output:
        verdict = "BUILD-FAILED"
    elif run.returncode != 0 and "--- FAIL" in output:
        verdict = "KILLED"
    elif run.returncode == 0:
        verdict = "SURVIVED"
    else:
        verdict = f"OTHER(rc={run.returncode})"
    if verdict != "KILLED":
        survivors += 1
    first = next((line.strip() for line in output.splitlines() if "_test.go:" in line), "")
    print(f"{name} {verdict} :: {what} :: {test} :: {first[:150]}", flush=True)
sys.exit(1 if survivors else 0)
```
