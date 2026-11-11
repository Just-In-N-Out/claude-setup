# 86bcm928h: Per-user credentials for integrations on the engineer's laptop

Card: [Per-user credentials for integrations on the engineer's laptop](https://app.clickup.com/t/86bcm928h) · repo `leorna-client` · Full pipeline, size L, security-sensitive · planner 2026-11-07 20:17 EST · status **APPROVED** (Justin "go", 2026-11-07: plan + every ⭐ answer = **Q1 A, Q2 A, Q3 A, Q4 A, Q5 A**). Q3 A: agents may run the Windows Credential Manager tests on this desktop's Windows side with test credentials only, deleted after each run. Q4 A: AC8 (live) waits for 86bcm927y's GitHub tile on a test server once 927y is merged; it is owed to Justin. Hand-over only: no push, PR or ClickUp post until Justin says.

## Questions for Justin (the plan is written as if the ⭐ answers were chosen)

**Q1. OAuth sign-in: who runs it?** The 927v tile format says `oauth` is "a browser sign-in run by the tool", and its templates (ClickUp) carry no `${VAR}`. A token Leorna got itself could not reach the tool.
- A ⭐ The tool runs it; Leorna prompts and opens the tool
- B Leorna runs OAuth (needs a control-plane tile change first)
- C Leorna runs OAuth and proxies every MCP server (XL)

**Q2. How does a stored token reach the tool?** Tools read `${GITHUB_PERSONAL_ACCESS_TOKEN}` from their own process environment.
- A ⭐ Leorna opens the tool with the token in that process's environment only
- B Write a credential-helper command into each tool's config
- C Leorna becomes a stdio proxy for every MCP server

**Q3. Agents run the Windows Credential Manager tests on this desktop's Windows side?** One test credential `Leorna Client:test/<uuid>` is written and deleted, and a helper console window flashes once.
- A ⭐ Yes, test credentials only, deleted after each run
- B No, the Windows proof waits for Windows CI after "push"

**Q4. Where does the live AC8 GitHub tile come from?** 927y (admin tiles UI) is not merged into control-plane main and has no PR.
- A ⭐ 927y's GitHub tile on a test server, once 927y is merged
- B A hand-made `github` MCP item on the test server, now

**Q5. Does signing out of Leorna also delete integration tokens?**
- A ⭐ Yes, sign-out removes that company's integration tokens
- B No, they stay until Disconnect

## Playback

Engineers connect the integrations their admin turned on (the 927v tiles: GitHub, Google Workspace, ClickUp) **with their own identity**. For a **personal token** tile (GitHub), the desktop app asks once for the token, stores it **only** in the OS credential store (Windows Credential Manager, DPAPI, local machine), checks it against the integration's own MCP server, and shows **Reconnect** when the server rejects it (expired or revoked). For an **OAuth** tile (ClickUp), the app prompts the engineer to sign in **in the tool** (Q1 ⭐) and opens it. The MCP config Sync writes is unchanged from 927v: it refers to the credential by variable name (`${GITHUB_PERSONAL_ACCESS_TOKEN}`, Codex `bearer_token_env_var`, Cursor `${env:…}`) and never holds it. The token reaches a tool only through the environment of a tool process Leorna starts (Q2 ⭐). Nothing secret goes to the synced config, SQLite, logs, the window's return values or the control plane, and tests grep for it.

Root cause: not a bug, so none. Today the client syncs 927v tiles' templates with `${VAR}` references but has no way to collect, store, check or deliver the engineer's credential, so a synced GitHub tile can never authenticate.

## Acceptance criteria

Card ACs 1–4 are as written. AC5–AC8 are added: AC5–AC7 are **proposed**, and AC8 comes from the card's Verify line. Each line names its tests.

- AC1: Given a synced integration needing auth, then the client prompts the engineer to sign in (OAuth) or enter a token once — `TestAC1SyncedTokenIntegrationPromptsOnce`, `TestAC1OAuthIntegrationPromptsSignInInTool`, UI test `AC1 integrations panel prompts for a token once and for tool sign-in` (scripts/integrations-ui.test.cjs)
- AC2: Given a credential, then it is stored in the OS credential store (Windows Credential Manager / DPAPI), never in the synced config or the control plane — `TestAC2TokenStoredOnlyInOSCredentialStore`, `TestIntegrationCredentialKeyAndValidation`, `TestWindowsIntegrationCredentialRoundTrip`
- AC3: Given the written MCP config, then it references the credential (env/credential helper) rather than embedding it — `TestAC3WrittenConfigsReferenceCredentialByName`, `TestAC3OpenToolPassesCredentialOnlyInEnvironment`
- AC4: Given an expired/revoked credential, then the client shows a clear reconnect action — `TestAC4RejectedTokenShowsReconnect`, `TestAC4ReconnectReplacesRejectedToken`, UI test `AC4 rejected credential shows a Reconnect action` (scripts/integrations-ui.test.cjs)
- AC5 (proposed): Given a connected token and a full connect → Sync → check → open-tool → sign-out run, then the secret appears in none of the written MCP files, any file under the profile/app-data/tool homes (SQLite db, -wal, -shm included), captured logs, any request to the control plane (URL, headers, body), or any value returned to the window, while positive controls prove the integration server and the tool process did receive it — `TestAC5SecretNeverLeavesTheCredentialStore`
- AC6 (proposed): Given Windows, then the Credential Manager and tool-launch tests run natively in packages the existing Windows CI job already runs with `LEORNA_TEST_SECURE_STORE=1` (`./login`, `./application`), and pass — `TestWindowsIntegrationCredentialRoundTrip`, `TestWindowsOpenToolPassesCredentialOnlyInEnvironment`
- AC7 (proposed): Given a token connected for one integration server, when a later Sync points that variable at a different server, then Leorna sends the token neither in a check nor to a tool until the engineer reconnects, and shows a Reconnect action — `TestAC7CredentialBoundToItsServer`
- AC8 (live): Given a clean Windows VM and the first predefined tile (GitHub, github.com variant), when the engineer signs in to Leorna, syncs, enters a personal token once and opens Claude Code from Leorna, then the GitHub MCP server works; after the token is revoked on GitHub, Check now shows Reconnect, and a new token works again; `cmdkey /list` shows the Leorna entry and no written file holds the token — `LiveAC8CleanWindowsVMGitHubTile` (manual checklist below)

Only AC8 is `(live)`: it needs a clean Windows VM, a real GitHub account and a control-plane test server. Everything else is agent-run.

## Base, repo, branch, worktree

- Repo `~/Leorna/leorna-client`. GitHub `main` fetched over HTTPS through gh at planning time: **base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`** ("Merge pull request #26 … 86bcx2a3m-getting-started"). The main checkout's `main` is **28 behind** and was not fast-forwarded (sibling sessions share it; the builder does that).
- Builder: worktree `~/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials` (or the `isolation: "worktree"` copy the orchestrator gives), branch `feat/86bcm928h-per-user-credentials` from `7a83443`. Commits `feat(86bcm928h): …` as `Justin Issa <justin@leorna.com>` (repo config, never overridden). Never push, PR, merge or post.
- Control-plane main at planning: `c8abbddf7d45099ea4023c42990334056922937e`. No control-plane change in this story (OpenAPI is untouched: the client only *uses* `GET /v1/client/integration-tiles`, which already exists in both repos).

## Current context (evidence)

| Fact | Evidence |
| --- | --- |
| 927v merged in the client as test fixtures, the OpenAPI tile schema and the Codex remote-server renderer | `git diff ea2b8ab^1 ea2b8ab`: `api/control-plane.openapi.yaml` (+89: `/v1/client/integration-tiles`, `IntegrationTile/Variant/Param/SignIn`), `api/controlplane.gen.go`, `toolconnector/codex/config.go` (`remoteTable`, `bearer_token_env_var`), `toolconnector/integration_tiles_test.go`, `toolconnector/testdata/integrations/*.json`, goldens `toolconnector/testdata/golden/integrations/*` |
| The parameterised template format: `{{param}}` is filled by the control plane, `${VAR}` is the engineer's credential, read by the tool from its environment | control-plane `internal/integration/README.md` "Two kinds of placeholder"; `tile.go:79-81` |
| Credential reference already rendered per tool | goldens: Claude Code `"Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"`; Codex `bearer_token_env_var = "GITHUB_PERSONAL_ACCESS_TOKEN"` (stdio: `env_vars = [...]`); Cursor `"Bearer ${env:GITHUB_PERSONAL_ACCESS_TOKEN}"` |
| Sign-in metadata: `method` `oauth` (tool-run; `client` dynamic/preregistered, `clientSecretEnvVar`) or `token` (`tokenEnvVar`, `helpUrl`, `scopes`), per tool | `api/control-plane.openapi.yaml` `IntegrationSignIn`; control-plane `tiles/github.json` (token, all three tools), `tiles/clickup.json` (oauth dynamic, claude-code + cursor) |
| A rendered tile is an ordinary `mcp_template` item named after the tile, described as "`<Tile> (<Variant>) integration. …`" | control-plane `internal/integration/render.go:66-70` |
| The client never calls the tiles endpoint yet | `git grep IntegrationTile origin/main -- ':!api'` finds only the spec |
| An OS-vault abstraction exists | `login/store.go`: `Vault{Get,Set,Delete}`, `OSVault` via `zalando/go-keyring`, service `"Leorna Client"`; login key `auth/<sha256(BackendURL\nTenantID)>` (`login/manager.go:68-71`) |
| go-keyring on Windows: generic credential `"<service>:<key>"`, `Persist = PersistLocalMachine` (does not roam), blob ≤ 2,560 bytes | `vendor/github.com/zalando/go-keyring/keyring_windows.go:29,44-46,97`; `vendor/github.com/danieljoos/wincred/wincred.go:40,72` |
| Windows CI already runs native secure-store tests | `.github/workflows/ci.yml` job `windows-client`: `go test -mod=vendor -count=1 ./application ./login ./toolconnector/...` with `LEORNA_TEST_SECURE_STORE: "1"`; `login/store_windows_test.go` `TestWindowsCredentialManagerRoundTrip` |
| Sync parses MCP servers with placeholders kept | `toolconnector/transform.go:38-46` `MCPServer`, `:123` `CollectMCPServers`, `:262` `WholePlaceholder`, `:271` `HasPlaceholder` |
| Sync flow and records | `application/sync.go:127-339` (`verifiedPack` → per-tool transform → `ApplyConfig`); run results store only path + SHA-256 per file |
| SQLite migrations are linear `PRAGMA user_version`; current is 8 with a downgrade guard | `application/application.go:205-222` (`if version != 8 { unsupported }`) |
| The app has no tool launcher; the handoff gives a pasteable command | `desktop/handoff.go:197-205` `inFolder` |
| Wails production log level is ERROR; trace logs bound-call **results**, never arguments | `vendor/github.com/wailsapp/wails/v2/pkg/options/options.go:153-154`; `internal/frontend/dispatcher/calls.go:62,84` |
| Frontend pattern: one script per panel plus a `node --test` VM test | `cmd/leorna-client/frontend/dist/{tools,login,sync,handoff}.js`, `scripts/*-ui.test.cjs`; events `company-changed`, `login-changed` |
| End-to-end fixture to copy | `application/sync_e2e_test.go` `TestSyncEndToEndWithLoginMockTLSAndRealWriters` (TLS fake control plane, `e2eVault`, `rewriteTransport`, real writers) |
| `make fmt` lists packages by name, so put new code in existing packages | `Makefile:10` |

**The first predefined tile** is GitHub, the github.com variant: first in [Predefined integration tiles](https://app.clickup.com/t/86bcm9284)'s list and first variant in `tiles/github.json`, token sign-in in all three tools. Assumption, listed.

## Approach and decisions

1. **Credential store (AC2, AC6).** Add `login.IntegrationCredentials` on top of the existing `Vault`/`OSVault` (same service `"Leorna Client"`, key `integration/<company digest>/<tile>/<VAR>`). It sits in `login` because that package is "OS-protected credentials" and is on the Windows CI line already, so **no CI change** is needed. Validation: tile slug ≤ 64, variable `^[A-Z][A-Z0-9_]{0,63}$` (control plane's `envVarName`), secret 1–2,048 bytes of valid UTF-8 with no whitespace or control characters. Errors never contain the secret.
2. **What needs a credential (AC1).** During Sync, after `verifiedPack`, every MCP server in the bundle is recorded in SQLite `integration_needs` (templates only: placeholders, URL, no secret). When the panel loads, Leorna matches needs to `GET /v1/client/integration-tiles`: item name = tile id; variant from the item description prefix `"<Tile> (<Variant>) integration."`, falling back to the first variant whose sign-in covers the item's variables. **Leorna only collects a credential that a tile declares** (`tokenEnvVar` of a matching token sign-in). A custom admin item with `${AWS_SECRET_ACCESS_KEY}` gets no prompt, so a pack cannot fish for arbitrary secrets.
3. **Token check, expiry and revocation (AC4).** For a remote server whose headers use the variable, Leorna sends one MCP `initialize` POST to that exact server URL with the header filled in. 2xx → `connected`, **401 → `rejected`** (Reconnect), anything else or a network error → `unchecked` ("couldn't check"). Settings: https only, no redirects followed (`ErrUseLastResponse`), 10 s timeout, ≤ 64 KiB read then discarded, no secret or URL in returned text. It runs on Connect (a 401 there → not saved, "GitHub didn't accept this token"), on panel load (at most once per 10 minutes per credential), and on **Check now**. Local stdio servers (GHES in Docker) cannot be checked, so they show "Saved; Leorna can't check this one", with Reconnect always available.
4. **Binding to the server (AC7).** A connection records the **identities** of the servers it was entered for: the origin `https://host[:port]` for remote servers, `local:<sha256 of command,args,env template>` for local ones. If a later Sync makes the variable point at an identity outside that set, the state is `server_changed`. No check is sent to the new identity and the token is not given to any tool until the engineer reconnects.
5. **Delivery (AC3, Q2 ⭐ A).** The written configs stay exactly 927v's output (no transformer change). **Open in <tool>** starts the tool with `VAR=<secret>` added to that child process's environment only; the secret is never in arguments, the working folder, files or the registry. On Windows: Claude Code and Codex open a new console window running the absolute `%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoExit -Command <constant>` (`claude` / `codex`; constant strings, no user input, so `.cmd`/`.ps1` shims work without passing anything through `cmd.exe`) in the chosen project folder. Cursor runs as the absolute `Cursor.exe` (`%LOCALAPPDATA%\Programs\cursor\Cursor.exe`, then `%ProgramFiles%\Cursor\Cursor.exe`) with the folder as its only argument. **Never `.cmd`/`.bat` through `exec`**, which avoids cmd.exe argument injection. Only `connected`/`unchecked` credentials whose sign-in lists that tool are added. Other platforms return "Opening tools from Leorna is available on Windows" (follow-up). Rejected options: writing a user environment variable (plaintext in `HKCU\Environment`, against the card).
6. **OAuth (Q1 ⭐ A).** For an OAuth tile with `client: dynamic` (ClickUp), the panel shows "Sign in to ClickUp in Claude Code: open it from Leorna, type /mcp, choose clickup and sign in in your browser" (Cursor: "Settings → MCP → Connect next to clickup"), an **Open <tool>** button and a **Sign in again** action. Leorna holds no OAuth secret, so the tool's own store applies. A `preregistered` client or a `clientSecretEnvVar` (Google) shows "Needs your organisation's OAuth client; not available in this version" (follow-up). Tool wording is unverified tool UI and is listed as an assumption.
7. **Disconnect and sign-out.** Disconnect deletes the vault entry and the row. Sign-out (Q5 ⭐ A) runs `ForgetCompany` **before** `login.Logout`: it deletes every listed entry for that company, and if a delete fails it stops with "could not remove integration sign-ins from OS secure storage; try signing out again" (existing wording style).
8. **No auth bypass, no stub in product code.** Tests use in-memory fakes (`fakeCredentialStore`, `fakeStarter`, `httptest` TLS MCP server), never a product flag.

## Interfaces and data shapes

### `login/integration.go` (new)

```go
package login

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"regexp"
	"unicode"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-client/onboarding"
)

// ErrInvalidCredential reports a tile, variable or secret Leorna will not
// store. Its text never includes the secret.
var ErrInvalidCredential = errors.New("integration credential is invalid")

// MaxIntegrationSecretBytes stays under Windows Credential Manager's
// 2,560-byte credential blob limit.
const MaxIntegrationSecretBytes = 2048

var (
	integrationTile = regexp.MustCompile(`^[a-z0-9]+(-[a-z0-9]+)*$`)
	integrationVar  = regexp.MustCompile(`^[A-Z][A-Z0-9_]{0,63}$`)
)

// IntegrationCredentials keeps each engineer's own integration secrets in the
// OS credential store, one entry per company, tile and variable. On Windows
// that is Credential Manager (DPAPI, local machine, never roaming). There is
// no file or SQLite fallback.
type IntegrationCredentials struct{ vault Vault }

func NewIntegrationCredentials(vault Vault) IntegrationCredentials {
	return IntegrationCredentials{vault: vault}
}

func integrationKey(company onboarding.Resolution, tileID, envVar string) (string, error) {
	if company.BackendURL == "" || company.TenantID == "" || len(tileID) > 64 ||
		!integrationTile.MatchString(tileID) || !integrationVar.MatchString(envVar) {
		return "", ErrInvalidCredential
	}
	digest := sha256.Sum256([]byte(company.BackendURL + "\n" + company.TenantID))
	return "integration/" + hex.EncodeToString(digest[:]) + "/" + tileID + "/" + envVar, nil
}

func validSecret(secret string) bool {
	if secret == "" || len(secret) > MaxIntegrationSecretBytes || !utf8.ValidString(secret) {
		return false
	}
	for _, r := range secret {
		if unicode.IsSpace(r) || unicode.IsControl(r) {
			return false
		}
	}
	return true
}

func (c IntegrationCredentials) SaveCredential(company onboarding.Resolution, tileID, envVar, secret string) error {
	key, err := integrationKey(company, tileID, envVar)
	if err != nil {
		return err
	}
	if !validSecret(secret) {
		return ErrInvalidCredential
	}
	if c.vault == nil || c.vault.Set(key, secret) != nil {
		return errors.New("could not save the credential in OS secure storage")
	}
	return nil
}

// LoadCredential reports found=false, with no error, when nothing is stored.
func (c IntegrationCredentials) LoadCredential(company onboarding.Resolution, tileID, envVar string) (string, bool, error) {
	key, err := integrationKey(company, tileID, envVar)
	if err != nil {
		return "", false, err
	}
	if c.vault == nil {
		return "", false, errors.New("OS secure storage is unavailable")
	}
	value, err := c.vault.Get(key)
	if errors.Is(err, ErrNotFound) {
		return "", false, nil
	}
	if err != nil {
		return "", false, errors.New("could not read the credential from OS secure storage")
	}
	return value, true, nil
}

func (c IntegrationCredentials) DeleteCredential(company onboarding.Resolution, tileID, envVar string) error {
	key, err := integrationKey(company, tileID, envVar)
	if err != nil {
		return err
	}
	if c.vault == nil || c.vault.Delete(key) != nil {
		return errors.New("could not remove the credential from OS secure storage")
	}
	return nil
}
```

### SQLite migration 8 → 9 (`application/application.go`)

Add after the `version == 7` block, and change the guard to `version != 9`:

```go
	if version == 8 {
		if _, err := tx.ExecContext(ctx, `CREATE TABLE integration_needs (
   project_id TEXT NOT NULL, server_name TEXT NOT NULL,
   item_name TEXT NOT NULL, item_description TEXT NOT NULL,
   transport TEXT NOT NULL CHECK(transport IN ('remote','local')),
   url TEXT NOT NULL DEFAULT '', identity TEXT NOT NULL,
   env_vars TEXT NOT NULL, headers TEXT NOT NULL DEFAULT '{}', synced_at TEXT NOT NULL,
   PRIMARY KEY (project_id, server_name)
  );
  CREATE TABLE integration_connections (
   tenant_id TEXT NOT NULL, backend_url TEXT NOT NULL, tile_id TEXT NOT NULL, env_var TEXT NOT NULL,
   identities TEXT NOT NULL, tools TEXT NOT NULL,
   state TEXT NOT NULL CHECK(state IN ('connected','unchecked','rejected')),
   check_code TEXT NOT NULL DEFAULT '', connected_at TEXT NOT NULL, checked_at TEXT NOT NULL DEFAULT '',
   PRIMARY KEY (tenant_id, backend_url, tile_id, env_var)
  );
  PRAGMA user_version=9;`); err != nil {
			return fmt.Errorf("create integration records: %w", err)
		}
		version = 9
	}
```

`env_vars`, `identities` and `tools` are sorted JSON string arrays; `headers` is the server's header **templates** (placeholders, as written to the tool configs). Neither table has a column that can hold a secret, and AC5 proves it.

### `application/integrations.go` (new)

```go
// CredentialStore is the OS credential store (login.IntegrationCredentials in
// the app, an in-memory fake in tests).
type CredentialStore interface {
	SaveCredential(company onboarding.Resolution, tileID, envVar, secret string) error
	LoadCredential(company onboarding.Resolution, tileID, envVar string) (string, bool, error)
	DeleteCredential(company onboarding.Resolution, tileID, envVar string) error
}

// IntegrationCatalog lists the control plane's tiles (distribution.ControlPlaneSource).
type IntegrationCatalog interface {
	IntegrationTiles(ctx context.Context) ([]api.IntegrationTile, error)
}

type ProbeOutcome string

const (
	ProbeAccepted ProbeOutcome = "accepted" // 2xx
	ProbeRejected ProbeOutcome = "rejected" // 401
	ProbeUnknown  ProbeOutcome = "unknown"  // other status, network error, local server
)

type Prober interface {
	Probe(ctx context.Context, need IntegrationNeed, envVar, secret string) (ProbeOutcome, string)
}

// StartRequest never carries the secret outside Env.
type StartRequest struct {
	Tool tc.ToolID
	Dir  string
	Env  map[string]string
}

type ToolStarter interface{ Start(ctx context.Context, request StartRequest) error }

// IntegrationNeed is one MCP server from the last successful Sync.
type IntegrationNeed struct {
	Server, Item, ItemDescription string
	Transport                     string // remote | local
	URL                           string // remote only
	Identity                      string // https origin, or local:<sha256>
	EnvVars                       []string
	Headers                       map[string]string // templates with ${VAR}
}

type IntegrationToolView struct {
	ID         tc.ToolID `json:"id"`
	Name       string    `json:"name"`
	CanOpen    bool      `json:"canOpen"`
	SignInStep string    `json:"signInStep,omitempty"` // OAuth only
}

// IntegrationView is what the window shows. It never carries a secret.
type IntegrationView struct {
	TileID    string                `json:"tileId"`
	Name      string                `json:"name"`
	Variant   string                `json:"variant,omitempty"`
	Method    string                `json:"method"` // token | oauth | unsupported
	EnvVar    string                `json:"envVar,omitempty"`
	HelpURL   string                `json:"helpUrl,omitempty"` // https only, else dropped
	Scopes    []string              `json:"scopes"`
	Tools     []IntegrationToolView `json:"tools"`
	State     string                `json:"state"`  // needs_token | connected | unchecked | rejected | server_changed | sign_in_in_tool | unsupported | details_unavailable
	Action    string                `json:"action"` // connect | reconnect | check | sign_in_again | none
	Message   string                `json:"message"`
	CheckedAt string                `json:"checkedAt,omitempty"`
}

type Integrations struct { /* app, store, prober, starter, now, minCheckInterval (10m) */ }

func NewIntegrations(app *Application, store CredentialStore, prober Prober, starter ToolStarter) (*Integrations, error)
func (s *Integrations) List(ctx context.Context, company onboarding.Resolution, catalog IntegrationCatalog) ([]IntegrationView, error)
func (s *Integrations) ConnectToken(ctx context.Context, company onboarding.Resolution, catalog IntegrationCatalog, tileID, envVar, token string) ([]IntegrationView, error)
func (s *Integrations) Check(ctx context.Context, company onboarding.Resolution, catalog IntegrationCatalog) ([]IntegrationView, error)
func (s *Integrations) Disconnect(ctx context.Context, company onboarding.Resolution, catalog IntegrationCatalog, tileID, envVar string) ([]IntegrationView, error)
func (s *Integrations) ForgetCompany(ctx context.Context, company onboarding.Resolution) error
func (s *Integrations) OpenTool(ctx context.Context, company onboarding.Resolution, catalog IntegrationCatalog, tool tc.ToolID) (string, error)

// integrationNeeds lists every MCP server of a verified pack (pure, unit-tested).
func integrationNeeds(pack tc.Pack) ([]IntegrationNeed, error)
func (a *Application) saveIntegrationNeeds(ctx context.Context, projectID string, needs []IntegrationNeed, at time.Time) error
func (a *Application) integrationNeeds(ctx context.Context, projectID string) ([]IntegrationNeed, error)
```

State rules for a token view (tile + variable), in order:
1. No vault entry → `needs_token` / `connect` ("Connect GitHub: create a personal token with repo, read:org and paste it once."). A row without a vault entry is deleted.
2. Current identities ⊄ stored identities → `server_changed` / `reconnect`.
3. Row `rejected` → `rejected` / `reconnect`: "GitHub didn't accept your token. It may have expired or been revoked. Reconnect with a new token."
4. Row `connected` → `connected` / `none`, with Open buttons. Row `unchecked` → `unchecked` / `check`: "Saved. Leorna couldn't check it right now."
5. A tile with no matching tile in the catalog → no view. Catalog unreachable → `details_unavailable` for needs that have variables ("Couldn't load sign-in details; check your connection"), with no Connect.

`ConnectToken`: trim the token; refuse when (tile, variable) is not a declared token sign-in of a current need ("This integration doesn't use a personal token"). Probe every remote need using that variable whose headers mention it, without saving first. Any 401 → nothing saved, error "GitHub didn't accept this token." Otherwise save to the vault, then upsert the row (identities = current needs' identities for the variable, tools = the sign-in's tools, state = `connected` if any probe was accepted, else `unchecked`).

### `application/integration_probe.go` (new)

```go
type HTTPProber struct{ Client *http.Client }

func NewHTTPProber() HTTPProber {
	transport := http.DefaultTransport.(*http.Transport).Clone()
	transport.TLSClientConfig = &tls.Config{MinVersion: tls.VersionTLS12}
	return HTTPProber{Client: &http.Client{
		Timeout:   10 * time.Second,
		Transport: transport,
		// Never follow a redirect: it would carry the token to another URL.
		CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse },
	}}
}
```

`Probe`: return `ProbeUnknown,"local"` unless `need.Transport=="remote"`, the URL parses as https and its origin equals `need.Identity`. Fill **only** `${envVar}` into header templates; skip (unknown) if a header still holds another placeholder. Send `POST need.URL` with body `{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"leorna-client","version":"1"}}}` and headers `Content-Type: application/json`, `Accept: application/json, text/event-stream`, `MCP-Protocol-Version: 2025-06-18`. Read `io.LimitReader(body, 64<<10)` and close. 2xx → accepted; 401 → rejected; else `unknown,"http_<code>"`; error → `unknown,"unreachable"`.

### `application/open_tool.go`, `open_tool_windows.go`, `open_tool_other.go` (new)

```go
var ErrOpenToolUnsupported = errors.New("opening tools from Leorna is available on Windows")

// toolEnv returns base without any key in add (case-insensitively on Windows),
// then add's entries sorted by key.
func toolEnv(base []string, add map[string]string, foldCase bool) []string
```

Windows `WindowsStarter{programs map[tc.ToolID]program}` (tests swap `programs`): `program{path string; args []string; console bool}`. Defaults: `claude-code` → powershell.exe abs path, args `-NoLogo -NoExit -Command claude`, console; `codex` → same with `codex`; `cursor` → first existing absolute `Cursor.exe`, args `[Dir]`, not console. `Start` builds `exec.Command(path, args...)`, sets `Dir`, sets `Env = toolEnv(os.Environ(), req.Env, true)`, uses `SysProcAttr{CreationFlags: windows.CREATE_NEW_CONSOLE}` for console programs (via `syscall.SysProcAttr`, constant `0x00000010` if `golang.org/x/sys/windows` is not vendored; check `vendor/modules.txt`, and add no new dependency), then `cmd.Start()` and `cmd.Process.Release()`. Refuse a path ending `.cmd`/`.bat`. On other platforms `Start` returns `ErrOpenToolUnsupported`.

`OpenTool` folder: the saved Sync selection's `ClaudeProjectRoot` if set (required for `claude-code`: "Choose the local project folder first"), else the user's home. Env: every `connected`/`unchecked`, not `server_changed`, token credential whose stored `tools` include the tool. Returns a message naming the integrations included and the ones skipped and why (no secrets).

### `distribution/controlplane.go`

Add `ListClientIntegrationTilesWithResponse` to the `controlPlaneClient` interface (generated client already has it) and:

```go
func (source *ControlPlaneSource) IntegrationTiles(ctx context.Context) ([]api.IntegrationTile, error)
```

200 → tiles; 404 (older control plane) → empty list, no error; other → `requestError`-style error with no body echo. Update the distribution test fake.

### `desktop/integrations.go` (new) and `desktop/bridge.go`

`Bridge` gets `integrations *application.Integrations` (built in `New` with `login.NewIntegrationCredentials(login.OSVault{})`, `application.NewHTTPProber()`, the platform starter). Bound methods return views only:

```go
func (b *Bridge) Integrations() ([]application.IntegrationView, error)
func (b *Bridge) ConnectIntegration(tileID, envVar, token string) ([]application.IntegrationView, error)
func (b *Bridge) CheckIntegrations() ([]application.IntegrationView, error)
func (b *Bridge) DisconnectIntegration(tileID, envVar string) ([]application.IntegrationView, error)
func (b *Bridge) OpenTool(toolID string) (string, error)
```

`Logout` calls `b.integrations.ForgetCompany` first (Q5 ⭐). `SyncTools` is unchanged; needs are recorded inside `SyncEngine.Run`.

### Sync hook (`application/sync.go`)

After `verifiedPack`: `needs, err := integrationNeeds(pack)`; an error → `invalid_bundle` (the transformers would refuse it anyway). After the apply loop and before the final `switch`, when `successes > 0`: `engine.app.saveIntegrationNeeds(ctx, selection.RemoteProjectID, needs, engine.now().UTC())` (replace all rows for that project in one transaction). On error: status `SyncPartial`, code `integrations_unrecorded`, message "Sync completed; integration sign-in status could not be recorded". Supporting test: `TestSyncRecordsIntegrationNeeds`.

### Frontend

`index.html`: new section after the sync panel, plus `<script src="integrations.js" defer></script>`:

```html
<section class="integrations-panel" aria-labelledby="integrations-heading">
  <div class="tools-header"><h2 id="integrations-heading">Integrations</h2><button id="integrations-check" type="button">Check now</button></div>
  <p id="integrations-message" role="status" aria-live="polite">Sync a project to see the integrations your company turned on.</p>
  <div id="integration-list"></div>
</section>
```

`integrations.js`: loads on start, on `login-changed`, and on a new `sync-completed` event (dispatched by `sync.js` after a sync result). Per view: title, state chip, message. Token actions: a `type="password"` input with `autocomplete="off"` plus a **Save token** button. The input is cleared right after the call, whatever the result, and is never put in a message. A **Create a token** button calls `window.runtime.BrowserOpenURL(helpUrl)`; **Reconnect** reveals the same input; **Disconnect**; **Open <tool>** per tool. OAuth: the per-tool `signInStep`, **Open <tool>** and **Sign in again** (shows the steps again). Strings are set with `textContent`, never `innerHTML`.

## Files touched

New: `login/integration.go`, `login/integration_test.go`, `login/integration_windows_test.go`, `application/integrations.go`, `application/integration_probe.go`, `application/open_tool.go`, `application/open_tool_windows.go`, `application/open_tool_other.go`, `application/integrations_test.go`, `application/integration_probe_test.go`, `application/integration_secret_e2e_test.go`, `application/open_tool_windows_test.go`, `desktop/integrations.go`, `desktop/integrations_test.go`, `cmd/leorna-client/frontend/dist/integrations.js`, `scripts/integrations-ui.test.cjs`.
Changed: `application/application.go` (migration 9), `application/sync.go` (needs hook), `application/application_test.go` (migration test), `distribution/controlplane.go` + `_test.go`, `desktop/bridge.go` (field, `New`, `Logout`), `cmd/leorna-client/frontend/dist/index.html`, `sync.js` (dispatch `sync-completed`), `style.css` (panel only), docs (below).
Not touched: `toolconnector/**` (no transformer or Connector change), `api/**` (no contract change), `.github/**`.

## Tasks (test-first; one commit per task)

Run RED/GREEN with the gate PATH below: `go test -mod=vendor -count=1 -run '<name>' ./<pkg>`.

1. **Credential store.** Write `TestIntegrationCredentialKeyAndValidation` (login, memoryVault): key = `integration/<sha256(BackendURL\nTenantID)>/github/GITHUB_PERSONAL_ACCESS_TOKEN`; refuses a bad tile, lowercase variable, empty company, empty secret, a secret with a space/newline/NUL, 2,049 bytes, or invalid UTF-8; error strings never contain the secret; Load of a missing key → found=false, nil. RED (undefined) → add `login/integration.go` → GREEN. Write `login/integration_windows_test.go` `TestWindowsIntegrationCredentialRoundTrip`: skipped unless `LEORNA_TEST_SECURE_STORE=1`; uses a test-only tile `test-<8 hex>`; saves through `OSVault`; reads back; reads the raw entry with `wincred.GetGenericCredential("Leorna Client:"+key)` (vendored) and asserts `Persist == wincred.PersistLocalMachine` and blob == secret; delete → found=false; `t.Cleanup` deletes.
2. **Migration 9.** `TestMigrationCreatesIntegrationTables`: a fresh db gets user_version 9 and both tables; a v8 db file migrates; a v10 db is refused. Then edit `migrate`.
3. **Needs extraction.** `TestIntegrationNeedsFromPack` uses the 927v fixtures `toolconnector/testdata/integrations/*.json` as pack items: github-com → remote, identity `https://api.githubcopilot.com`, vars `[GITHUB_PERSONAL_ACCESS_TOKEN]`, header template kept; enterprise-server → local `local:<64 hex>`, stable across runs and changed by any command/arg/env change; clickup → remote, no vars. Then `integrationNeeds`, `saveIntegrationNeeds`, `integrationNeeds` read, plus the Sync hook with `TestSyncRecordsIntegrationNeeds` (successful sync records; a failed sync keeps the old rows).
4. **Prober.** `integration_probe_test.go` with `httptest.NewTLSServer` and its client (`Client.Transport` from the server; keep `CheckRedirect`): `TestProbeSendsOnlyTheFilledHeaderToTheExactURL` (records method, path, header, body shape), `TestProbeRejectedOn401`, `TestProbeUnknownOn403And500AndTimeout`, `TestProbeNeverFollowsRedirect` (302 to a second server that fails the test if hit), `TestProbeRefusesHTTPAndOriginMismatch` (no request), `TestProbeSkipsLocalServers`.
5. **Integrations service: AC1, AC4, AC7.** In `integrations_test.go`, use `fakeCredentialStore` (map + call log), `fakeCatalog` (tiles decoded from JSON copies of control-plane `tiles/github.json` and `tiles/clickup.json`, written into `application/testdata/integration-tiles.json` as `api.IntegrationTile` JSON), `fakeProber`, `fakeStarter`, and needs seeded through `saveIntegrationNeeds`:
   - `TestAC1SyncedTokenIntegrationPromptsOnce`: before connect, one view `needs_token`/`connect` with helpUrl, scopes and envVar; after `ConnectToken`, `connected`; a second `List` and a re-sync with the same bundle give no prompt and no new vault write. A custom item `custom` with `${AWS_SECRET_ACCESS_KEY}` gives no view, and `ConnectToken("custom", …)` is refused.
   - `TestAC1OAuthIntegrationPromptsSignInInTool`: clickup → `sign_in_in_tool`, tools Claude Code + Cursor each with `signInStep`, action `sign_in_again`, no Connect, no vault call. A preregistered OAuth tile → `unsupported`.
   - `TestAC4RejectedTokenShowsReconnect`: prober returns rejected on Check → `rejected`/`reconnect` with the "expired or been revoked" message; `OpenTool` skips it and says so.
   - `TestAC4ReconnectReplacesRejectedToken`: ConnectToken with a new token → vault holds the new value, state `connected`. A 401 at connect → error, the old vault value is unchanged, no row change.
   - `TestAC7CredentialBoundToItsServer`: connect for `https://api.githubcopilot.com`; re-save needs with the github item URL at `https://evil.example.invalid/mcp`; `List` → `server_changed`; `Check` makes **no** probe call to the new URL; `OpenTool` passes no `GITHUB_PERSONAL_ACCESS_TOKEN`; after reconnect → connected and bound to the new identity.
   - Supporting: `TestDisconnectAndForgetCompanyDeleteVaultEntries` (and a failing delete stops with the message), `TestCatalogUnavailableShowsDetailsUnavailable`, `TestPanelLoadChecksAtMostEvery10Minutes`.
6. **Open tool: AC3.** `TestAC3OpenToolPassesCredentialOnlyInEnvironment` (all OS, fakeStarter): the request has `Env{"GITHUB_PERSONAL_ACCESS_TOKEN": secret}`, Dir = project root, Tool = claude-code; the secret is not in Dir or the message; Codex/Cursor get it only when the tile lists them; `toolEnv` drops an inherited same-name variable (case-insensitive when folded). Then `application/open_tool_windows_test.go` `TestWindowsOpenToolPassesCredentialOnlyInEnvironment`: skipped unless Windows and `LEORNA_TEST_SECURE_STORE=1`. Swap `programs[claude-code]` to the test binary itself (`os.Args[0] -test.run=^TestHelperOpenTool$`, console) with `LEORNA_HELPER_OUT=<tempfile>`. The helper writes `sha256(os.Getenv(VAR))` and `windows.GetCommandLine` (or `os.Args` joined) to the file and exits. The test waits up to 20 s for the file and asserts the hash matches and the command line lacks the secret. The token comes from a real `login.NewIntegrationCredentials(login.OSVault{})` entry (cleaned up).
7. **AC3 written configs.** `TestAC3WrittenConfigsReferenceCredentialByName`: real `SyncEngine` with real transformers and writers into temp homes (Claude project dir, `CODEX_HOME`, Cursor home, as in `sync_e2e_test.go`), bundle = the github-com and enterprise-server fixtures, credential connected first. Assert that `.mcp.json` holds `Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}`, Codex `config.toml` holds `bearer_token_env_var = "GITHUB_PERSONAL_ACCESS_TOKEN"` and `env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN"]`, and Cursor `mcp.json` holds `${env:GITHUB_PERSONAL_ACCESS_TOKEN}`. The secret's bytes appear in no written file. Bytes equal the 927v goldens.
8. **AC5 secret-leak test.** `application/integration_secret_e2e_test.go` (design below).
9. **Distribution.** `TestIntegrationTilesListsTilesAnd404IsEmpty` (distribution fake client).
10. **Desktop bridge.** `desktop/integrations_test.go`: bridge methods with injected `application.Integrations` (fakes) return views; `TestLogoutForgetsIntegrationCredentialsFirst` (an order log shows forget before logout; a forget failure skips logout and returns the message). The bridge never returns or logs the token: assert on JSON-marshalled results.
11. **Frontend.** `scripts/integrations-ui.test.cjs` (pattern of `tooltiles-ui.test.cjs`): `AC1 integrations panel prompts for a token once and for tool sign-in`, `AC4 rejected credential shows a Reconnect action`, `token input is cleared after save and never shown in messages`, `Create a token opens the help URL only through BrowserOpenURL`, `Open tool calls OpenTool with the tool id`. Then `integrations.js`, the `index.html` section and the `sync.js` event.
12. **Falsification (mutation-testing-discipline).** Under a capped scope (`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`), use `-overlay` mutants and record each as killed with the killing test: (a) the Sync hook writes the token into `integration_needs.headers` → AC5 fails; (b) the prober follows redirects → `TestProbeNeverFollowsRedirect`; (c) 401 is treated as unknown → AC4; (d) the identity check is skipped → AC7; (e) `OpenTool` passes the token as an argument → AC3/AC6; (f) `validSecret` accepts whitespace → key/validation test; (g) the UI keeps the input value → UI test; (h) Logout skips forget → bridge test. Receipt `evidence/86bcm928h/mutants.txt`.
13. **Evidence task** (below), then **Docs & records** (below).

## AC5 secret-leak test design

`TestAC5SecretNeverLeavesTheCredentialStore`, modelled on `TestSyncEndToEndWithLoginMockTLSAndRealWriters`:
- **Canary:** built at runtime, `"ghp_" + base62(crypto/rand 36 bytes)`, so no literal is in the source and gitleaks stays clean. Also check its base64 and UTF-16LE forms.
- **Isolation:** `t.Setenv` HOME/USERPROFILE/APPDATA/LOCALAPPDATA/XDG_*/CODEX_HOME/CLAUDE_CONFIG_DIR to `t.TempDir()` subfolders. SQLite at `<APPDATA>/Leorna/leorna.db` via `application.Open`.
- **Control plane:** a TLS fake that records every request (method, URL, all headers, body) for device login, projects, bundle metadata/content (github-com + enterprise-server + clickup items) and `/v1/client/integration-tiles`, plus usage upload if the flow triggers it.
- **Integration server:** a second TLS fake answering MCP `initialize` with 200 when `Authorization == "Bearer "+canary`. It records requests. **Positive control:** it must have received the canary.
- **Tool start:** `fakeStarter` records requests. **Positive control:** Env holds the canary.
- **Logs:** `log.SetOutput(&buf)` for the test, restored after.
- **Flow:** sign in → Sync (all three tools) → `List` → `ConnectToken(canary)` → `Check` → Sync again → `OpenTool(claude-code)` → `Disconnect` → `ConnectToken` again → `ForgetCompany`.
- **Assertions:** walk every regular file under the temp root (configs, SQLite `.db`, `-wal`, `-shm`, run logs) → no canary form. Every recorded control-plane request → no canary in URL, headers or body. `buf` → none. Every `IntegrationView`/`SyncResult`/message JSON returned → none. `fakeStarter` args/Dir → none. After `ForgetCompany` the fake store is empty.
- **Mutation proof:** mutant (a) in task 12 must fail it.

## Windows credential-store tests and CI

No workflow change is needed: the existing `windows-client` job runs `./application ./login ./toolconnector/...` with `LEORNA_TEST_SECURE_STORE=1` on `windows-latest` (a clean GitHub-hosted VM), so `TestWindowsIntegrationCredentialRoundTrip` (login) and `TestWindowsOpenToolPassesCredentialOnlyInEnvironment` (application) run there on the PR. The `.github/` diff must be empty.

Agent-run Windows proof before any push (Q3 ⭐ A), from WSL interop:
- `login`: `GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go test -mod=vendor -c -o <owned scratch>/login.test.exe ./login`, then `WSLENV=LEORNA_TEST_SECURE_STORE LEORNA_TEST_SECURE_STORE=1 <scratch>/login.test.exe -test.run '^TestWindows' -test.v -test.count=1`.
- `application` needs cgo (go-sqlite3): `CGO_ENABLED=1 CC="$HOME/.local/leorna-tools/zig-x86_64-linux-0.15.2/zig cc -target x86_64-windows-gnu" GOOS=windows GOARCH=amd64 go test -mod=vendor -c -o <scratch>/application.test.exe ./application`, with Zig caches in owned scratch. Run it the same way with `-test.run '^TestWindowsOpenTool'`.
- Afterwards run `cmdkey /list | findstr /i "Leorna Client:test"` (through `cmd.exe /c`) and expect no output. Keep the receipt `evidence/86bcm928h/ac6-windows-tests.txt`.
- If the Zig cross-build fails, keep the failure receipt; the application half of AC6 is then owed to Windows CI on push (say so). With Q3 = B, all of AC6 is owed to CI.

## Gates and host prerequisites (WSL desktop, checked 2026-11-07)

`command -v` found `make` (/usr/bin), `gcc` 15.2 (cgo works, no Zig needed for Linux), `node` v22.23.3 and `gitleaks` (/usr/local/bin), and Docker is running (not needed). It reported **`go`, `golangci-lint` and `govulncheck` missing from PATH, but they are installed**: `~/.local/leorna-tools/go/bin/go` (go1.27.3 = go.mod toolchain), `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/golangci-lint` (2.14.0 = CI pin), `~/.local/leorna-tools/bin/govulncheck` (v1.7.0 = CI pin). No question is needed. Every role uses:

```bash
export PATH="$HOME/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64:$HOME/.local/leorna-tools/bin:$HOME/.local/leorna-tools/go/bin:$PATH"
mkdir -p "$HOME/.cache/86bcm928h-<role>/tmp" && export TMPDIR="$(cd "$HOME/.cache/86bcm928h-<role>/tmp" && pwd -P)"
export CGO_ENABLED=1
golangci-lint --version; go version; govulncheck -version
make check && node --test scripts/*-ui.test.cjs && make lint audit
gitleaks git --log-opts="7a83443..HEAD" --redact --no-banner .
```

Use `make -s` in captures. Logs go to `evidence/86bcm928h/gates-<sha7>.txt` with an `EXIT=` line. Keep TMPDIR off the shared `/tmp` tmpfs. A SIGTERM/137/143/"Killed" means checking `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading a result.

## Evidence (`~/.hermes/plans/leorna/evidence/86bcm928h/`)

| AC | State to show | Capture point | Artifact |
| --- | --- | --- | --- |
| AC1 | The panel with GitHub "Connect" (token input, Create a token) and ClickUp "Sign in in Claude Code / Cursor" | Headless Chrome (`~/.cache/chrome-for-testing/...`, owned profile) rendering the real `frontend/dist/index.html` with a `window.go.desktop.Bridge` stub replaying the JSON views that `TestAC1*` wrote under `-evidence` (labelled "real frontend, recorded bridge data") | `ac1-prompt.png` |
| AC2 | Windows Credential Manager entry `Leorna Client:integration/…` (Persist local machine) and the test output | Terminal capture of the Windows test run plus `cmdkey /list` filtered to the test target **while it exists** (test pauses with `LEORNA_TEST_PAUSE=1`, test-only); no secret printed | `ac2-credential-store.png` + log |
| AC3 | The three written configs showing the variable name and grep returning nothing for the canary | Terminal capture of `TestAC3*` -v plus `cat` of the temp configs | `ac3-config-reference.png` |
| AC4 | The panel with GitHub "Reconnect" and the expired/revoked message | Same Chrome replay from `TestAC4*` views | `ac4-reconnect.png` |
| AC5 | The leak test run with each grep target counted (0 hits) and the positive controls (≥1) | Terminal capture of `go test -v -run TestAC5` | `ac5-secret-grep.png` + log |
| AC6 | Native Windows test pass for both tests | Terminal capture of the interop run | `ac6-windows-tests.png` + `ac6-windows-tests.txt` |
| AC7 | `server_changed` view and the test showing no probe to the new origin | Chrome replay plus terminal capture | `ac7-server-binding.png` |
| AC8 (live) | Justin's VM: Leorna connected, Claude Code `/mcp` github connected, Reconnect after revoke | Justin's screenshots (URL/tenant/token cropped) | `ac8-live-*.png` (owed) |

Every screenshot is checked visually for URLs, tenant IDs, emails and tokens before it leaves the machine. The canary is printed only as a hash.

## Live AC8 checklist (Justin, after the reviewed head is accepted)

Prerequisites: a control-plane test server with 927y merged and the GitHub tile (github.com variant) enabled in a pack assigned to a project (Q4 ⭐ A; with B, a library MCP item named `github` whose body is `toolconnector/testdata/integrations/github--github-com.json` and whose description starts "GitHub (GitHub.com) integration."), a clean Windows VM, the built `leorna-client.exe` from the accepted head, Claude Code installed (Leorna's install tile), and a GitHub fine-grained or classic token with `repo`, `read:org`.
1. Connect the company and sign in. Pick the project and folder, then Sync Claude Code. The Integrations panel shows "Connect GitHub".
2. Paste the token once and click Save token → "Connected".
3. Click Open Claude Code → in the new window, `/mcp` lists `github` connected; ask "list my GitHub repositories" → tool call succeeds.
4. `cmdkey /list` shows `Leorna Client:integration/…`; `findstr /s /m <first 8 token chars>` over `%USERPROFILE%\.claude*`, the project's `.mcp.json`, `%USERPROFILE%\.codex`, `%USERPROFILE%\.cursor` and `%APPDATA%\Leorna` finds nothing.
5. Revoke the token on GitHub → Check now → "GitHub didn't accept your token… Reconnect". Reconnect with a new token → Connected; step 3 works again.
Until Justin runs it, AC8 is **NOT VERIFIED** and acceptance-blocking for "ready", and `ac-check.sh` reports READY FOR THE USER.

## Risks

- **Environment delivery exposes the token to the tool process and to every MCP server the tool runs that references the variable**, including servers the engineer added by hand outside Leorna. Leorna-synced servers are guarded by AC7; user-added ones are documented in the README. A same-user process can read another's environment on Windows (standard for env-based MCP).
- **Tools not started from Leorna lack the token**, so GitHub MCP fails with 401. The panel says "Start Claude Code from Leorna so it can use your GitHub sign-in". A Cursor that is already running keeps its old environment, and the button text says "Close Cursor first". Q2 B/C are the alternatives.
- **OAuth is tool-run (Q1 ⭐)**: Leorna can't see when a tool's OAuth token expires; the tool shows its own "needs authentication" and Leorna offers Sign in again. Where the tool keeps OAuth tokens (e.g. Claude Code on Windows) is the tool's choice, not Credential Manager. AC2 is proven for credentials Leorna holds.
- **Variant matching relies on the control plane's description text** (`render.go:70`). A wording change falls back to the first covering variant (worst case: a different help link). Follow-up: carry tile/variant ids in bundle items (contract change).
- **The probe's 401 reading is generic MCP, unverified live against GitHub's hosted server** until AC8. A 403 is treated as "couldn't check", never as revoked.
- **Windows console behaviour** (Windows Terminal as default host) keeps env inheritance; it is unproven until AC6/AC8.
- **Migration 9 numbering** collides if the in-flight sibling client story adds one too; the second to merge renumbers.
- Wails trace logging in a dev build logs call results; results never hold the token (AC5 asserts on results).

## Overlaps with sibling stories

- Client worktrees: only `86bcm902w` (merged into main). Open client PRs: none (`gh pr list` → `[]`).
- **86bctmuwy Agent items install** (client, being planned now): likely shares `application/sync.go`, `README.md`, maybe `application/application.go` migrations and the frontend `sync.js`. It can **build in parallel**; whichever merges second rebases (migration renumber, `sync.js` event line, README sections).
- **86bcm9284 Predefined tiles** (control plane): no shared files. Its AC2 ("engineers connect with their own sign-in") needs this story, so 928h should merge first.
- **86bcm927y** (control plane): not merged, no PR. AC8 (Q4 ⭐ A) waits for it. Its branch base `3aa979d` is now behind control-plane main `c8abbdd`.

## Follow-ups (not in this story)

1. Carry tile and variant ids in bundle items (OpenAPI change in both repos), so the client doesn't match on description text.
2. Leorna-run OAuth with tokens in Credential Manager (Q1 B), which needs a tile format change so OAuth templates reference `${VAR}` and Leorna refreshes before launch.
3. Opening tools from Leorna on macOS/Linux.
4. Preregistered OAuth / `clientSecretEnvVar` (Google Workspace) collection.
5. A bridge/credential helper so tools started outside Leorna also get the token (Q2 B/C).

## Docs & records (last build task; the finisher updates what it owns)

- `README.md`: new section "Per-user integration credentials — 86bcm928h" (what is stored where, the Open-from-Leorna rule, tool-run OAuth, limits), with the AC → test table.
- `application/README.md`: Integrations section (needs, states, probe rules, server binding, open tool).
- `GLOSSARY.md`: "integration credential", "credential reference", "server identity".
- `SECURITY.md`: one paragraph on integration tokens being only in the OS credential store (local machine, not roaming), checks only to the server they were entered for, and env delivery.
- `PROJECT_MEMORY.md`: progress line (finisher).
- Finisher only, never pushed or posted unasked: PR text `~/.hermes/cache/scratch/leorna-pr-86bcm928h-per-user-credentials.md`, review prompt, ClickUp evidence draft, team message, `evidence/86bcm928h/follow-ups.md`, the `leorna-workflow.md` status line.

## Skills (every role loads `leorna` first, then `engineering-best-practices`)

- Planner: `implementation-planning`, `security-best-practices` (Go reference `golang-general-backend-security.md`: GO-CONFIG-001, GO-SSRF-001, GO-HTTPCLIENT-001, GO-INJECT-002).
- Builder: `test-driven-development`, `security-best-practices`, `mutation-testing-discipline` (guards: identity binding, redirect refusal, secret validation, sign-out order), `frontend-testing-workflow` for the panel test.
- Reviewers: `requesting-code-review` + `code-review-practice` (report only), plus `security-best-practices`. Fixers: `receiving-code-review`. Verifier/auditor: `adversarial-verification-loop` (security-critical change; it ends with a **Mandatory Validation and Agent Defect Loop**, so run it). `multi-tenant-auth-management` is not needed (no server auth change); company scoping is covered by the per-company key.
- Every brief carries the `skill_lessons` rule and the earlyoom rule.

## Assumptions

- The first predefined tile is GitHub, github.com variant.
- Claude Code/Cursor sign-in step wording is unverified tool UI; it is checked only if Justin runs a ClickUp live check (not an AC).
- `GET /v1/client/integration-tiles` answering 404 means an older control plane: no tiles, no prompts.
- One token per (company, tile, variable). Variants of one tile share the token, as GitHub's do.

## Other things found (not fixed, not folded in)

- The 927y handover in `leorna-workflow.md` says "Open PR #108 conflicts in delivery records". #108 (getting started) is now merged into control-plane main `c8abbdd`, and 927y itself has no PR, so 927y needs main brought in before its PR. Info.
- Memory says the desktop has no go/make/gcc (2026-10-28). Now `make` and `gcc` are on PATH and go/golangci-lint/govulncheck sit under `~/.local/leorna-tools`, off PATH. Info.
- The Windows CI job lists packages by name, so `./desktop`, `./distribution`, `./usage` and `./handoff` tests never run on Windows (known gap, `no-ci-changes`). P3.
- `Makefile:10` `fmt` lists top-level packages by name, so a future new top-level package would skip the gofmt check silently. P3.

## Hand-over state (main session, 2026-11-08)
READY FOR THE USER on 1f98596 (ac-check.sh --reviews); hand-over drafted, nothing committed after 1f98596, not pushed, no PR, nothing posted. Waiting on Justin: AC8 (live, now unblocked: 927y merged as CP #112), the "renderings OK for ClickUp?" question, and the words push / make a PR / post. Justin, 2026-11-08: "keep this chat going as I will not be on it" — read as: keep the session open and idle; no new agents, push, PR or post while he's away.

## Hand-over state (main session, 2026-11-10), replaces the 2026-11-08 state
- Main a7839b3 (#30, #31, #32) brought in: merge a608c1d; story migration renumbered 9 → 10 (main's 9 = managed_drift_queue); 9b35bbb (generated-constant rename); 0af4471 (R4-1: unknown-version test on a real database; Justin said "fix").
- review-4 (R4-1 P2, Justin: fix) → review-5 clean (MOVE ON at 0af4471). verifier/ and auditor/ fresh on 0af4471 (old ones kept as verifier-1f98596/, auditor-1f98596/).
- ac-check.sh --reviews: READY FOR THE USER: 7 of 8 ACs proven on 0af4471; AC8 (live) owed to Justin.
- Hand-over drafts refreshed by finisher 2 in ~/.hermes/cache/scratch/ (PR text, review prompt, ClickUp draft "post after merge", team message "send after merge"); AC2/AC6 images re-rendered without notes.
- Waiting on Justin: AC8 live; "make a PR" (commit the PROJECT_MEMORY.md line, gates, push, PR, PR-number record, PR-head verifier → auditor → ac-check); post only after merge. Still owed before post: gates screenshot of the pushed head, AC8 screenshots.

## Done (main session, 2026-11-11)
- PR #33 merged by Justin 2026-11-11 16:31Z (merge 7d2e16e) at head eef72c7 (main 3f4bad7, Go 1.27.4, brought in; review-7 clean). Verifier 3 + auditor 3 clean on eef72c7; ac-check READY FOR THE USER (AC8 live not run; Justin said not to mention AC8 in outgoing text).
- ClickUp closing comment and 7 AC images (verifier/ on eef72c7) posted 2026-11-11. Card status not changed.
