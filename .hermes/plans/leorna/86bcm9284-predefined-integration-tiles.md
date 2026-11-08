# 86bcm9284 — Predefined integration tiles: GitHub, Google Workspace, ClickUp

Card: [Predefined integration tiles: GitHub, Google Workspace, ClickUp](https://app.clickup.com/t/86bcm9284) (Justin, size L, E14, "to do"). Pipeline: Full. Planned 2026-11-08T01:15Z by the Opus planner. **Approved by Justin ("go", 2026-11-07); see "Approval" at the end. The builder waits for 927y on main (Q1 A).**

## Questions for Justin (answer these with "go" or pick letters)

**Q1. 86bcm927y has to merge first. In what order?**
AC2 says "when an admin enables it". The only way an admin turns a tile on is 86bcm927y's Integrations page (`/admin/integrations`, configure → library item → pack). 927y is ALL ACCEPTED locally (`0027786`) but it has no PR and is not on GitHub main (`c8abbdd`). The card doesn't list it as a dependency, but AC2 can't be tested without it.
- ⭐ **A.** You make 927y's PR and merge it first. This story's builder branches from GitHub main after that merge.
- B. Stack this story on `feat/86bcm927y-integrations-catalog-tiles` at `0027786` now, and bring main in after 927y merges. Faster to start, but every 927y change means re-review here.

**Q2. 86bcm928h (per-user credentials) isn't built. Ship without it?**
928h is "to do": no branch or PR in either repo, and no client code reads `/v1/client/integration-tiles` yet. What each tile needs to work today:
- **ClickUp:** nothing from 928h. Claude Code, Cursor and Codex run ClickUp's browser sign-in themselves.
- **GitHub:** GitHub's hosted server takes only a personal access token in Claude Code, Codex and Cursor (GitHub's Cursor guide: "the GitHub server currently requires a Personal Access Token"). Without 928h, each engineer creates their own token once and keeps it in `GITHUB_PERSONAL_ACCESS_TOKEN`. That is their own credential, but it is a hand-copied token, which Christian's 2026-10-23 comment wants to avoid. 928h replaces this step with the desktop app's prompt and the OS keyring, with no tile change: the tile already declares `token` + `tokenEnvVar`.
- **Google:** needs client work (Q3).
- ⭐ **A.** Ship 9284 now. GitHub uses the engineer's own token from their environment (documented, with a link to create it). ClickUp uses the tool's own browser sign-in. 928h comes next and removes the manual token step.
- B. Build 928h first, then this story. This blocks 9284 for an L-sized client story.
- C. Switch github.com to GitHub's **local** server (v2.1.0 by pinned Docker digest). It signs in in the browser with GitHub's built-in OAuth app, so no token is copied. But every engineer needs Docker, the sign-in repeats each time the server starts (the token is kept in memory only, `docs/oauth-login.md`), and Docker needs a fixed callback port. Not recommended now.

**Q3. Google Workspace can't fully work in this story. What do we do with it?**
Google's MCP servers are a **Developer Preview**: you have to join the preview, and each organisation creates its own "Web application" OAuth client, marked for AI agents, **with a client secret**. The client's transformers drop OAuth client fields, so the synced config can't carry the client ID. That's why 927y deferred Google configuration (`internal/integration/configuration.go` on the 927y branch: "Google Workspace configuration is unavailable until native client setup support is released"; 927y amendment, root-cause table). Handing every engineer the organisation's client secret also clashes with 928h's "no shared secret is distributed".
- ⭐ **A.** In this story, Google stays a listed **preview** tile: vetted and documented (AC3), passing the gate (AC4), available on a fresh install (AC5), with configuration still shown as unavailable. Its share of AC2 and its live test move to a follow-up card that depends on 928h plus client support for pre-registered OAuth clients. With A, AC2 is met for GitHub and ClickUp only, so the hand-over names Google's part of AC2 as **not met** and the card can't close. I'd suggest asking Christian to split Google's AC2 into its own card (draft message below).
- B. Widen this story to both repos now: client transformers write a pre-registered OAuth client (Claude Code `oauth.clientId`/callback port, Codex's client-ID option, Cursor's `auth` block), a client-secret policy, and a live test on a Google Workspace domain. Roughly a second L story.

**Q4. ClickUp in Codex.** The tile leaves Codex out ("not on ClickUp's list of supported clients yet"). ClickUp's page now says it "supports all major MCP clients" with OAuth 2.1 + PKCE and names no list. The quality gate also fails a template that renders cleanly for a tool it doesn't list (`internal/library/gate/policy.go:411`, "works in codex but tools does not list it"), and ClickUp's URL-only config renders cleanly for Codex.
- ⭐ **A.** List Codex for ClickUp (`codex mcp login clickup` runs the browser sign-in) and confirm it in the live run (AC2). If the live run fails, we come back to you.
- B. Keep Codex out and add a tile-only gate rule, "not supported, with a reason". That's more gate code, for a claim that's probably out of date.

**Q5. GitHub Enterprise Server runs an unpinned Docker image, which the gate refuses.** The variant runs `docker run … ghcr.io/github/github-mcp-server` with no tag or digest. The gate allows only `npx name@x.y.z` (`policy.go:422-424`, "command is not npx"), and its own comment says "add another (uvx, docker by digest) here, with a test, before a template uses it".
- ⭐ **A.** Pin `ghcr.io/github/github-mcp-server@sha256:f6056fc10bfffcc8c81a6417a2e9ca12808647e8dd6049642a4feaadee0e0f8a` (tag `v2.1.0`, read from ghcr.io on 2026-11-08; the builder re-reads it). Add Docker-by-digest to the gate as a reviewed launcher with strict argument rules. The rendered output changes, and the render parity rule (`internal/library/render/testdata/client/SOURCE.md`: "copy a merged client change") means a **tiny client PR with test fixtures only** has to merge first: 4 files under `toolconnector/testdata/`. You'd merge the client PR before the control-plane PR.
- B. Leave Enterprise Server out of this story (remove the variant, follow-up card). That changes 927v/927y's design, and 927y's UI shows the variant.

**Q6. Zayd's card 86bcx2a33. Shall I give you a message for him?** It overlaps with this story only a little (see "Overlap with 86bcx2a33"). This story leaves his files alone.
- ⭐ **A.** Yes. You send the draft below (I send nothing).
- B. No message.

**Q7. Test accounts and tool homes for the live run (AC2).**
- ⭐ **A.** You provide: a test GitHub org with one test repo and a fine-grained token for that repo (read-only is enough), plus a test ClickUp workspace and account. No Google domain (Q3 A). The live run is on this desktop in Claude Code 2.1.319 and Codex 0.165.0, in scratch project folders with a scratch `CODEX_HOME`. Claude Code keeps its own sign-in, so the ClickUp sign-in and the project-server approval are written into your real `~/.claude`, and you remove them afterwards (`/mcp` → clear authentication). **Cursor isn't installed here:** its live check runs on your Mac, or it stays NOT VERIFIED.
- B. Other accounts, machines or homes (tell me which).

**Q8. Stay `preview` or promote to `stable`?** The README rule is "preview until it is checked live in every tool it lists".
- ⭐ **A.** All three stay `preview` in this story. Promoting GitHub and ClickUp is a one-line follow-up once your live run passes in every tool they list, Cursor included. That avoids a code commit after the live run, which would need another review round.
- B. Promote GitHub and ClickUp in a last commit after the live run (fresh review, verifier and auditor again).

## Playback

Make the three predefined tiles shippable. Each tile's MCP server is vetted and documented (source, licence, sign-in, scopes). Every tile variant passes the content quality gate for every tool it declares, in `make library-check`, the same command CI runs. All three tiles are present on a fresh install. An admin who enables GitHub or ClickUp (927y's page) gets a pack whose synced config works in each declared tool with the engineer's own sign-in, proven agent-side up to the written tool files and live by Justin against test accounts.

- **Repo:** `leorna-control-plane`, plus a tiny `leorna-client` PR with test fixtures only if Q5 is A. No OpenAPI change. No CI workflow change. No migration.
- **Base:** GitHub `main` = `c8abbddf7d45099ea4023c42990334056922937e` (fetched over HTTPS via gh, 2026-11-08 01:05Z; PR #108 merge). With Q1 A, the builder re-fetches and uses main **after 927y's merge**, recording that SHA. The client's GitHub main is `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`.
- **Branch:** `feat/86bcm9284-predefined-integration-tiles` in both repos (client only for Q5 A). Commits `feat(86bcm9284): …`.
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm9284-predefined-integration-tiles` (and the same name under `leorna-client`). Don't fast-forward the shared main checkout (it is 20 behind; the builder updates its own worktree only).

## State found (evidence)

| Fact | Evidence |
|---|---|
| AC1 done | Card checkbox ticked; Christian's comment 90140272800879 (2026-10-23): "first integrations are GitHub, Google Workspace … and ClickUp". On main: `internal/integration/README.md:7-8`, `internal/integration/tiles/{github,google-workspace,clickup}.json`, `TestEmbeddedTilesCoverTheFirstThreeSystems` (`internal/integration/integration_test.go:45`), merged by PR #87 (`6e74ced`, 927v). |
| 927v tile model on main | `internal/integration/tile.go:65` (`Tile`), `:78` (`Variant`), `:105` (`SignIn`), `:417` (`Variant.Tools`); `render.go:26` (`Tile.Render`); `catalog.go:21` (`Embedded`, `go:embed tiles/*.json`); `GET /v1/client/integration-tiles` (`internal/web/client_integrations.go:19`, `contracts/control-plane.openapi.yaml:103`). All three tiles are `"stage": "preview"`, version `0.1.0`. |
| 901u gate on main | PR #90 (`044e2ad`). `make check` runs `library-check` (`Makefile:15`, `:59-60`); CI step "Check content library quality" runs `make library-check` (`.github/workflows/ci.yml:118-119`). The gate reads only a library folder (`cmd/library-gate/main.go`, `-dir`) and **never sees tiles**. `cmd/library-gate/ci_test.go:414-421` pins the Makefile block, and `:205` pins the command. |
| Tiles vs gate today (read from source, not run) | GHES: `docker` launcher → "command is not npx" (`policy.go:422-424`). ClickUp: declares claude-code and cursor, but renders cleanly for Codex → "works in codex but tools does not list it" (`policy.go:411`). github-com, ghe-com and Google look clean. The builder confirms these as the AC4 RED. |
| Render parity | `internal/library/render/render_test.go:51` (`TestIntegrationTemplatesMatchClientGoldens`) renders `internal/integration/testdata/rendered/*.json` and compares the result with the client's goldens in `testdata/client/golden/integrations/`. Those are copies of client `toolconnector/testdata/{integrations,golden/integrations}/` (`toolconnector/integration_tiles_test.go:23`). |
| 927y | Branch `feat/86bcm927y-integrations-catalog-tiles` at `0027786`, worktree `~/Leorna/86bcm927y-integrations-catalog-tiles`, base `3aa979d`, 27 files. ALL ACCEPTED 4/4, local hand-over only, no PR. Adds `/admin/integrations` (`internal/web/handler.go:297-299` on that branch), `integration.Service`, migration 28, configured items `integration-<tile>` version `1.0.<rev-1>`, and Google deferral (`internal/integration/configuration.go:16-27`). `internal/integration/service.go` imports `internal/library/gate`, so **gate must never import integration** (import cycle). |
| 928h | Card "to do", assigned to Justin. No branch or PR in either repo (`gh api …/branches`, `gh pr list --state all`). No client code reads integration tiles or OAuth fields (`git grep` on client `origin/main` `7a83443`). |
| 86bcx2a33 | Zayd's, "to do", tag `reserved-zayd`. No branch or PR. Its AC1 (current server, `Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}`, new version, lock) is **already on main** as `mcp_template/github-mcp@3.0.0`, by 901j `a096458` (PR #98; `content.lock.json:13`). Still old: the seed pack, `internal/pack/seed.json:56-59` (`npx @modelcontextprotocol/server-github`, `${GITHUB_TOKEN}`). |
| Card dependencies | 86bcm927v complete, 86bcm901u complete (both are `depends_on` edges whose `task_id` is this card). |

## Overlap with 86bcx2a33 (Zayd)

Zayd owns the **library item** `internal/library/content/items/mcp_template/github-mcp/*`, `internal/pack/seed.json`/`seed.sha256`, `content.lock.json` entries for `github-mcp`, and the client transformer golden tests for that item. 9284 owns the **tile** `internal/integration/tiles/github.json` and its rendered/golden fixtures, and touches none of Zayd's files. Neither waits for the other. The two only have to agree on one fact, which both already use: `Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}` against `https://api.githubcopilot.com/mcp/`. If both stories touch `internal/library/README.md` or `delivery/stories.json`, the second to merge appends its own entry last (normal sibling rule).

**Draft message to Zayd (Justin sends, Q6):**
> Hi Zayd, heads-up on 86bcx2a33: the library item `mcp_template/github-mcp` was already moved to GitHub's hosted server with `Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}` as version 3.0.0 in PR #98 (story 86bcm901j, read-only `/readonly` URL; 2.0.0 is kept in `content.lock.json`). What looks left on your card is the seed pack (`internal/pack/seed.json` still has the old npx server with `${GITHUB_TOKEN}`), the client golden tests and the immutability check. I'm doing 86bcm9284 (the GitHub/ClickUp/Google integration tiles) and won't touch the library item, the seed pack or the lock, only `internal/integration/tiles/github.json`. Shout if you planned to change the tile too.

**Draft message to Christian (only if Q3 is A):**
> Hi Christian, on 86bcm9284: Google Workspace's MCP servers are still a Developer Preview and need the organisation's own OAuth client with a client secret, which our client transformers can't write yet (927y deferred Google configuration for the same reason). I'm shipping GitHub and ClickUp fully, and Google as a vetted preview tile that passes the gate and shows on a fresh install. Could we split "engineers connect with their own sign-in" for Google into its own card that depends on 86bcm928h and client support for pre-registered OAuth clients?

## Acceptance criteria

The ACs are the card's own, word for word. AC1 is already done. One primary test each. Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm9284/`.

- **AC1 (done):** Given the product team's decision, then the first set of systems is recorded in this story before build starts (GitHub, Google Workspace, ClickUp).
  Test: existing `TestEmbeddedTilesCoverTheFirstThreeSystems` (`./internal/integration`), re-run only. No build work. Evidence: `ac1-first-three.png`, a terminal capture of `go test -count=1 ./internal/integration -run '^TestEmbeddedTilesCoverTheFirstThreeSystems$' -v`. It passes on base and head by design.
- **AC2 (live):** Given a predefined tile, when an admin enables it, then engineers connect with their own sign-in and a working MCP config syncs to their tools.
  Test: `TestPredefinedTilesAC2EnableAndSyncWithPostgres` (`./internal/web`), agent-run. Live check: `ac2-live.md`, run by Justin.
  - Evidence: `ac2-sync.png`, a terminal capture of the agent's headless client Sync showing the written `.mcp.json`, `config.toml` and `mcp.json` in a scratch HOME.
  - Evidence: `ac2-live-github.png` and `ac2-live-clickup.png`, Justin's sign-in and one read call per tool, with nothing identifying in the shot.
  - With Q3 A, Google's part is recorded as not met.
- **AC3:** Given each shipped tile, then its MCP server source, licence, supported sign-in and scopes are documented and vetted.
  Test: `TestTileVettingIsDocumented` (`./internal/integration`). Evidence: `ac3-vetting.png`, a local render of the README "Vetting" section.
- **AC4:** Given each shipped tile, then it passes the content quality gate (renders for every declared tool).
  Test: `TestShippedTilesPassTheGate` (`./cmd/library-gate`). Evidence: `ac4-gate.png`, a terminal capture of `make -s library-check` showing every tile variant × declared tool as `rendered`, with `EXIT=0`.
- **AC5:** Given a fresh install, then the GitHub, Google Workspace and ClickUp tiles are available.
  Test: `TestPredefinedTilesAC5FreshInstallWithPostgres` (`./internal/web`). Evidence: `ac5-fresh-install.png`, the admin Integrations page of a dev-mode server started on an empty `_test` DB, showing the 3 tiles.

**Base vs head (rule, for the verifier and auditor).** Base = `git merge-base HEAD <main after 927y>`.
- On base, AC3 and AC4 fail.
- AC2 fails on base exactly where this story changes behaviour: ClickUp in Codex is listed as unsupported, and the Enterprise Server image is unpinned.
- AC1 and AC5 may pass on base. They're characterization tests; don't invent a RED for them.

### Tests in detail

- `TestPredefinedTilesAC2EnableAndSyncWithPostgres`, modelled on `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres` (`internal/web/quick_start_test.go:394`):
  - The admin saves GitHub `github-com` and ClickUp `cloud` through 927y's `POST /admin/integrations/{tileID}` (helpers `integrationForm`/`postIntegration`, `internal/web/integrations_test.go:329,337` on 927y). Then the admin creates a pack holding both configured items through the pack builder's native preview/confirm, and assigns it to a team with a project.
  - A **member** engineer on that team fetches `GET /v1/client/projects/{projectId}/bundle` and its content with a token minted for `fixture.member`, never the admin (`internal/web/projects.go:73` skips membership for admins; 901r auditor 2).
  - For each declared tool, `render.Transform` on the delivered items gives:
    - Claude Code `.mcp.json` with `"Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"`;
    - Codex `config.toml` with `bearer_token_env_var = "GITHUB_PERSONAL_ACCESS_TOKEN"` and a `[mcp_servers.clickup]` URL;
    - Cursor `mcp.json` with `${env:GITHUB_PERSONAL_ACCESS_TOKEN}`.
  - No rendered file holds a literal credential: `gate.CheckTenantItem` on the delivered items is clean.
  - `GET /v1/client/integration-tiles` says every tool the pack targets is supported. For ClickUp, Codex is supported with OAuth (RED on base).
  - Failure cases: another team's member gets 404 for the project's bundle, and a removed tile item is no longer delivered.
- `TestPredefinedTilesAC5FreshInstallWithPostgres`, modelled on `TestQuickStartAC5FreshInstallEndToEndWithPostgres` (`quick_start_test.go:868`):
  - Throwaway schema, `ApplyMigrations`, handler wired as `cmd/control-plane` wires it (tiles from `integration.Embedded()`), no seeded integration rows.
  - The admin's `GET /admin/integrations` shows exactly three tile cards, read per card element (GitHub, Google Workspace, ClickUp), not by whole-body `Contains`.
  - The member's `GET /v1/client/integration-tiles` returns exactly `clickup,github,google-workspace`.
  - Unauthenticated `/admin/integrations` → 302 to `/v1/auth/google/login`; member → 403.
- `TestTileVettingIsDocumented`:
  - Reads `internal/integration/README.md`, finds the `## Vetting` table, and requires one row per embedded tile × variant.
  - Each row has a non-empty Source (https URL), Publisher, Licence/terms, Sign-in, Credential held by, Scopes and Checked (YYYY-MM-DD).
  - The Scopes cell equals that variant's declared `signIn` scopes joined with `, `, or `none declared` when it has none. A tile or scope change without a doc change fails.
  - Failure case: a fixture README missing a variant row fails, naming it.
- `TestShippedTilesPassTheGate`:
  - Calls `run([]string{"-dir", "../../internal/library/content", "-tiles", "../../internal/integration/tiles", "-gitleaks", <bin>, "-json", <tmp>}, …)` with the real gitleaks (`LEORNA_TEST_GITLEAKS_BIN`, else `gitleaks` on PATH; skip only if neither exists, and the builder must show it ran).
  - Expects exit 0. In the JSON report, for each of the 5 tile items (`mcp_template/tile-github-github-com`, `tile-github-ghe-com`, `tile-github-enterprise-server`, `tile-clickup-cloud`, `tile-google-workspace-cloud`), every declared tool's status is `rendered` and `declaredTools` equals the variant's `Tools()` supported list.
  - Companion failure test `TestTilesGateNamesVariantAndTool`: a fixture tile dir with an unpinned Docker image exits 1 with a `policy` failure naming `tile-…` and the server. A fixture where a variant renders for a tool it doesn't list also exits 1, naming the tool.

## MCP server vetting (goes into the README "Vetting" section, AC3)

Checked 2026-11-07/08 from the publishers' own pages and repos. Re-check dates go in the README.

| Tile / variant | Server and source | Publisher, licence | Sign-in (who holds the credential) | Scopes: declared → minimum | Tools |
|---|---|---|---|---|---|
| GitHub / github-com | Hosted `https://api.githubcopilot.com/mcp/`. Source `github.com/github/github-mcp-server` (open source, latest `v2.1.0`, 2026-11-03). | GitHub. Server code MIT; the hosted service is under GitHub's terms. Available to any GitHub account; some tools need paid features (Copilot cloud agent, Code Security); an org's PAT policy applies. | **Personal access token** in `Authorization: Bearer`. GitHub's own guides for Claude Code, Codex and Cursor document only a PAT for the hosted server (no OAuth for these hosts). The engineer holds it in their environment (`GITHUB_PERSONAL_ACCESS_TOKEN`), later in the OS keyring via 928h. | Declared: classic `repo`, `read:org` (GitHub's minimum list also has `read:packages`, but only for package tools). Documented minimum: a **fine-grained** token limited to the needed repos (Metadata read; Contents, Issues, Pull requests read, or write if they create PRs). The tile keeps its declared scopes; the README recommends fine-grained. | claude-code, codex, cursor |
| GitHub / ghe-com | Hosted `https://copilot-api.<sub>.ghe.com/mcp` (GitHub README, GHE.com section). | Same. | PAT, same as above. | Same. | claude-code, codex, cursor |
| GitHub / enterprise-server | **Local** `ghcr.io/github/github-mcp-server` with `GITHUB_HOST` (remote isn't supported on GHES: "GitHub Enterprise Server does not support remote server hosting"; HTTPS enforced). Pinned by digest (Q5). | GitHub, MIT. | PAT for the GHES instance (env, forwarded with `-e`). OAuth on GHES needs the company's own app: not used. | Same. | claude-code, codex, cursor |
| ClickUp / cloud | Hosted `https://mcp.clickup.com/mcp`. No public source. | ClickUp, proprietary hosted service; "subject to … fair use policy" (clickup.com/terms/ai). All plans; rate limits by plan (100 calls/24 h on Free Forever). No delete tools. | **OAuth only** ("We only support OAuth"; no API keys). OAuth 2.1 + PKCE, run by each tool (dynamic client). The tool keeps the token (Claude Code's credential store, Codex's `CODEX_HOME`/keyring, Cursor). | None declared; ClickUp documents none. The engineer picks the workspace at consent. | claude-code, cursor, **codex** (Q4 A, live-confirmed) |
| Google Workspace / cloud | Hosted `https://drivemcp.googleapis.com/mcp/v1`, `https://docsmcp.googleapis.com/mcp/v1`. No public source. | Google, **Developer Preview** (enrolment required); "Google API Services: User Data Policy". | OAuth with the organisation's **own Web-application client marked for AI agents, client ID + secret** (no dynamic registration). Google documents only Antigravity and Claude.ai/Desktop. Claude Code, Codex and Cursor are undocumented and their callbacks unverified. | Declared: `drive.readonly`, `drive.file`, `documents.readonly`. Google lists Drive: `drive.readonly`, `drive.file`; Docs: also `documents.readonly`, `documents`. Whether Docs works without `documents` is **unverified** (deferred with Google, Q3). | Declared all three; **not usable until client support** (Q3) |

Not used, and why (README line): `@modelcontextprotocol/server-github` (archived `modelcontextprotocol/servers-archived`, deprecated); third-party ClickUp/Google wrappers (API-key or proxy servers, not the official ones).

## Files and areas touched

Control plane (paths on main after 927y):
- `cmd/library-gate/main.go` gets the new `-tiles <dir>` flag. The new `cmd/library-gate/tiles.go` builds a synthetic in-memory library from the tiles and merges its report.
- `cmd/library-gate/tiles_test.go` (new) holds AC4's test and its failure test.
- `cmd/library-gate/ci_test.go` updates `libraryCheckText` and `gateCommand` to the new recipe. Nothing in the weakening checks is relaxed.
- `Makefile`, `library-check` block: adds `TILES_DIR ?= internal/integration/tiles` and `-tiles "$(TILES_DIR)"`. CI already runs `make library-check`, so no workflow change.
- `internal/library/gate/policy.go` and `policy_test.go`: Docker-by-digest launcher and `DOCKER_*` launch settings.
- `internal/integration/tiles/github.json`: pinned GHES image, version `0.2.0`.
- `internal/integration/tiles/clickup.json`: Codex added to sign-in tools, description updated, version `0.2.0`.
- `internal/integration/testdata/rendered/github--enterprise-server.json`, regenerated.
- `internal/integration/README.md`: "Vetting" section, gate note, stale ClickUp/Codex and GHES-pin lines fixed. Gets a story section naming the exact tests.
- `internal/integration/vetting_test.go` (new) holds AC3's test.
- `internal/web/predefined_tiles_test.go` (new) holds AC2 and AC5.
- `internal/library/render/testdata/client/golden/integrations/github--enterprise-server/{claude-code/.mcp.json,codex/config.toml,cursor/mcp.json}` and `SOURCE.md`: copied from the client PR.
- `internal/library/gate/README` or the gate's doc comment, if it lists launchers (builder checks).
- `delivery/stories.json` gets a new entry, appended last, with `prs: []`.

Client (Q5 A only): `toolconnector/testdata/integrations/github--enterprise-server.json` and `toolconnector/testdata/golden/integrations/github--enterprise-server/{claude-code/.mcp.json,codex/config.toml,cursor/mcp.json}`. Test data only, no code.

Not touched: `contracts/*` (no API change, so both repos regenerate nothing), `.github/workflows/*`, migrations, the library item `github-mcp`, `seed.json`, `content.lock.json`, `toolconnector.Connector`.

## Design choices

1. **The tiles go through the same gate code as library items.** `cmd/library-gate` (package main imports both `gate` and `integration`; gate can't import integration because of 927y's cycle) turns each tile × variant into a `library.Item`:
   - kind `mcp_template`, name `tile-<tileID>-<variantID>`, version = tile version, category `integrations`, tags `[tile]`;
   - tools = the variant's supported tools from `Variant.Tools()`;
   - body = `Tile.Render(variant, examples)`, with each declared param's `example`. A param without an example is a gate failure naming the variant;
   - example = a one-line note;
   - description = the rendered description.

   These items are written into an `fstest.MapFS` library (`library.json` + `items/mcp_template/<name>/{item.json,body.md,example.md}`) and run through **`gate.Run` unchanged**: layout, schema, render per tool, format, policy and secret scan. The tile report's `Items` and `Failures` are appended to the content report, and `Passed` is the AND of both. The JSON schema and the log/Markdown writers don't change, and CI's job summary lists the tile items too.
2. **Docker-by-digest launcher** (`launcherProblem`):
   - `command` = `docker`, `args[0]` = `run`.
   - Before the image, only `-i`/`--interactive`, `--rm`, and `-e NAME`/`--env NAME`, where `NAME` matches `variableName`, has no `=` and is a key in `env`.
   - Then exactly one image `^[a-z0-9]+([._-][a-z0-9]+)*(\.[a-z0-9-]+)*(:[0-9]+)?(/[a-z0-9]+([._-][a-z0-9]+)*)+(:[A-Za-z0-9_][A-Za-z0-9_.-]{0,127})?@sha256:[0-9a-f]{64}$`. Later args go to the server.
   - Refused, each with a reason naming the argument's position, never its value:
     - a tag-only or untagged image;
     - any other option (`-v`, `--mount`, `-p`, `--network`, `--privileged`, `--entrypoint`, `--env-file`, `--pull`, `-e NAME=value`, `--platform`);
     - an `-e NAME` with no matching env key;
     - an env key starting `DOCKER_` (added to `launchSettings`: it changes which daemon, context or config runs the image).
   - npx rules unchanged.
3. **ClickUp gets Codex** (Q4 A). This changes nothing in the rendered body or the goldens, only the sign-in tools and the description.
4. **Vetting lives in the README**, tied to tile JSON by a test (prefer-small-verified-scope): no new tile field, no API change. The README states only verified facts. Unverified facts say "unverified".
5. **Stage stays `preview`** (Q8 A). Versions `0.1.0` → `0.2.0` for GitHub and ClickUp, whose content changed. Google stays `0.1.0` (no change). 927y stores `TileVersion` in configurations, so its tests pinning `0.1.0` for GitHub/ClickUp are updated in the same commit, and an existing saved configuration keeps its stored snapshot (927y design).

## Tasks (build order, test first)

Every Go command runs with the owned toolchain bound task-locally:
`export PATH=$HOME/.local/leorna-toolchain/go/bin:$PATH`, `GOLANGCI_LINT=$HOME/.local/leorna-toolchain/bin/golangci-lint` (2.14.0 = CI), `GOVULNCHECK=$HOME/.local/leorna-toolchain/bin/govulncheck` (v1.7.0 = CI).
`TMPDIR=~/.cache/86bcm9284-builder/tmp` (never `/tmp`, a shared tmpfs). Long runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.

**T0. Set up (about 10 min).**
1. Fetch main over HTTPS via gh and record the SHA. Q1 A: it must contain 927y's merge; stop if it doesn't.
2. Create the worktree and branch.
3. Start your own Postgres: `docker run -d --rm --name 9284-builder-pg -p 127.0.0.1:0:5432 mirror.gcr.io/library/postgres:18.6-alpine3.23` with a DB ending `_test`. `leorna-test-pg` has been `Exited (255)` for 7 days: leave it alone. Read the password inside the script, never on a command line.
4. `mkdir -p ~/.hermes/plans/leorna/evidence/86bcm9284`.
5. **Baseline on base** (a detached copy, its own DB): `go test ./internal/integration ./internal/library/... ./cmd/library-gate` and `make library-check`. Record the tallies in `evidence/86bcm9284/baseline-<sha7>.txt`.
6. Capture AC1 now (`ac1-first-three.png`).

**T1. The gate reads tiles: failure path first (AC4).**
1. Write `cmd/library-gate/tiles_test.go::TestTilesGateNamesVariantAndTool` with two fixture tile dirs under `cmd/library-gate/testdata/tiles-*`:
   - an unpinned `docker run -i --rm ghcr.io/x/y` variant;
   - a URL-only variant that lists only claude-code.

   Both expect exit 1. The JSON failures must name `mcp_template/tile-<id>-<variant>@<v>` with stage `policy`, the first naming the server and the second naming `codex`.
2. RED: exit 2, "flag provided but not defined: -tiles". This is a new-feature RED. Record it.
3. Implement `tiles.go`: `integration.Parse(os.DirFS(dir))`, a synthetic MapFS, `gate.Run`, then merge into the report. Add the `-tiles` flag; empty means skip, so the existing tests are unchanged.
4. GREEN: this test, plus all existing `./cmd/library-gate` tests.
5. Commit.

**T2. Run the real tiles through the gate (AC4 RED).**
1. Write `TestShippedTilesPassTheGate` (spec above).
2. RED: exit 1 with exactly two policy failures: `tile-github-enterprise-server` "command is not npx", and `tile-clickup-cloud` "works in codex but tools does not list it". Save the log as `evidence/86bcm9284/ac4-red.log`. Any other failure means stop and report it: the plan's prediction was wrong.

**T3. Makefile and CI pins.**
1. Edit `Makefile`'s `library-check` block: `TILES_DIR ?= internal/integration/tiles`, and add `-tiles "$(TILES_DIR)"` after `-dir`.
2. Update `cmd/library-gate/ci_test.go` `libraryCheckText` and `gateCommand` (`-dir "internal/library/content" -tiles "internal/integration/tiles" -gitleaks "G" -summary "S"`). Keep every weakening check.
3. Check: `go test ./cmd/library-gate -run 'TestAC4CIRunsLibraryGateWithoutDroppingGates' -v` passes. `make -n library-check` prints the new command. A Makefile mutant without `-tiles` fails the pin test (falsification).
4. Commit.

**T4. Docker-by-digest launcher (Q5 A).**
1. `policy_test.go` table: the pinned form is accepted. Every refused form in design choice 2 fails, and its reason names the position. `DOCKER_HOST` in env fails.
2. RED: the accepted case fails with "command is not npx".
3. Implement in `launcherProblem` (dispatch on command) plus a `DOCKER_` `launchSettings` entry. Generalise the npx-only wording "so it can change what npx installs or runs" only if no existing test pins it; check with `git grep`.
4. GREEN: `go test ./internal/library/gate`.
5. Mutation, scoped to this function, under the memory cap: drop the digest check, then drop the option refusal. Each must be killed. Record the receipts.
6. Commit.

**T5. Pin GHES (Q5 A), plus the client fixture PR.**
1. Re-read the digest:

   ```
   T=$(curl -s "https://ghcr.io/token?scope=repository:github/github-mcp-server:pull" | python3 -c 'import sys,json;print(json.load(sys.stdin)["token"])')
   curl -sI -H "Authorization: Bearer $T" -H 'Accept: application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.list.v2+json' https://ghcr.io/v2/github/github-mcp-server/manifests/v2.1.0 | grep -i docker-content-digest
   ```

   If it differs from `sha256:f6056fc1…0f8a`, stop and ask.
2. Set the image to `ghcr.io/github/github-mcp-server:v2.1.0@sha256:<digest>` and bump github to `0.2.0`.
3. `go test ./internal/integration -run TestRenderMatchesGolden -update`, then review the diff: only the image string changes.
4. **Client repo:** create the worktree and branch. Copy the new `rendered/github--enterprise-server.json` to `toolconnector/testdata/integrations/`. Regenerate the 3 goldens with the client's own update path (read `toolconnector/integration_tiles_test.go:23`; if it has no `-update`, write them by hand and prove them with the test). Run the client gates (`make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's linter first on PATH, `TMPDIR` on the real disk) and commit `test(86bcm9284): pin the GitHub Enterprise Server image in the integration fixtures`.
5. **Control plane:** copy those 4 client files byte for byte into `internal/library/render/testdata/client/…`. Update `SOURCE.md`: "client branch `feat/86bcm9284-…` at `<sha>`, PR pending", with the SHA-256 lines.
6. GREEN: `TestIntegrationTemplatesMatchClientGoldens`, `TestClientFixturesMatchSource`, `./internal/integration`.
7. Commit. After Justin merges the client PR, the finisher changes `SOURCE.md` to the merged commit. That one-line commit is reviewed as a delta.

**T6. ClickUp in Codex (Q4 A).**
1. Edit `clickup.json`: `"tools": ["claude-code", "codex", "cursor"]`, description without "Codex is not yet…", version `0.2.0`.
2. Update `TestToolsReportsSupportAndSignIn` (`integration_test.go:170`) expectations for ClickUp/Codex. Its RED is the old expectation; edit it first, see it fail, then edit the JSON.
3. Update 927y tests pinning ClickUp's tools, version or description, if any (`git grep -n "0.1.0\|not yet on ClickUp" internal/web internal/integration`).
4. GREEN: `TestShippedTilesPassTheGate` now passes. Save `make -s library-check` as `ac4-gate.log` and capture `ac4-gate.png`.
5. Commit.

**T7. Vetting docs (AC3).**
1. Write `internal/integration/vetting_test.go::TestTileVettingIsDocumented` plus its fixture-README failure case.
2. RED: there's no `## Vetting` section.
3. Write the README section:
   - the vetting table above, adjusted to the final tile JSON;
   - one "Checked" date per row;
   - the "not used, and why" line;
   - the Google Developer Preview caveat;
   - the GHES pin (digest, tag, how to re-pin);
   - "Gate: tiles run through `make library-check` as `tile-<id>-<variant>` items".

   Fix the stale lines at README 52-60.
4. GREEN.
5. Render the section to HTML offline (goldmark from the module cache + Chrome for Testing, `ac-verification.md` WSL recipe) and capture `ac3-vetting.png`.
6. Commit.

**T8. Fresh install (AC5).**
1. Write `TestPredefinedTilesAC5FreshInstallWithPostgres`. It may start green on base: record that as a characterization test, and prove the assertions can fail by temporarily removing `tiles/clickup.json` in an overlay copy, which must fail naming ClickUp.
2. Capture `ac5-fresh-install.png`: a dev-mode server (`LEORNA_DEV_MODE=1`, `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, fresh `_test` DB, random encryption key; recipe in `leorna-control-plane-workflow.md`, 901j finisher), headless Chrome on `/dev/login?next=%2Fadmin%2Fintegrations`, no URL bar.
3. Commit.

**T9. Enable and sync (AC2, agent half).**
1. Write `TestPredefinedTilesAC2EnableAndSyncWithPostgres` (spec above). RED on base: ClickUp/Codex is unsupported in `/v1/client/integration-tiles`.
2. GREEN after T6. Mutation: let a literal token into the configured body, which `CheckTenantItem` must refuse; and mint the token for another team's member, which must give 404.
3. **Headless client Sync (agent-run):**
   - Reuse `~/.hermes/plans/leorna/86bcm901r-ac4/run.sh` + `client-sync.go`: dev server on a fresh DB, the admin enables GitHub and ClickUp through the console, assigns the pack to a team/project, and the client driver signs in and runs Sync.
   - Run it under `env -i` with a scratch HOME, `CLAUDE_CONFIG_DIR`, `CODEX_HOME` and `XDG_*`.
   - Show the written Claude `.mcp.json`, Codex `config.toml` and Cursor `mcp.json`, and run `CODEX_HOME=<scratch> codex mcp list`, which reads config without connecting.
   - Fingerprint the real-home tool folders before and after; they must be unchanged.
   - Capture `ac2-sync.png`.
4. Write `evidence/86bcm9284/ac2-live.md`, Justin's checklist (Q7). It holds one `!` command per step that prepares a scratch project with the synced files. Then:
   - **GitHub:** with the test token in `GITHUB_PERSONAL_ACCESS_TOKEN`, Claude Code: `/mcp` shows github connected, and "list open issues in <test repo>" returns. Codex: `codex mcp list` shows github, and one `codex exec` read returns.
   - **ClickUp:** Claude Code `/mcp` → Authenticate → browser sign-in → "list my ClickUp spaces". Codex: `codex mcp login clickup` → browser → one read.
   - **Cursor:** on the Mac, or NOT VERIFIED.
   - Afterwards: clear the Claude MCP auth, delete the scratch homes, revoke the test token.
   - Screenshots crop or avoid emails, workspace names and tokens.
5. Commit the test only. The scripts stay in evidence.

**T10. Docs and delivery.**
1. Integration README story section: the exact test names and how to run the gate on tiles.
2. `delivery/stories.json`: append the entry last, written as text.
3. Grep the tree for "Codex is not on ClickUp" and "pin the image digest when promoting", and for this card's ID next to until/once/later. Fix what's now stale.
4. Commit.

**T11. Gates (serially, real output kept, `gates-<sha7>.txt`).**
1. Control plane, under the memory cap, `make check` with:
   - `LEORNA_TEST_DATABASE_URL` set to your own `_test` DB;
   - the bound `GOLANGCI_LINT` and `GOVULNCHECK`;
   - `/usr/local/bin` (gitleaks 8.30.1) on PATH.

   Then prove the Postgres tests ran: a `go test -json` stream over `./internal/cloud/dbcheck ./internal/store/postgres ./internal/web`, read per test, failing any skip naming `LEORNA_TEST_DATABASE_URL`. Allowed skips are the ClickHouse ones with exactly "LEORNA_TEST_CLICKHOUSE_URL not set", `TestEvidenceThirdPartyContentPage` and `TestProvisionManagedPostgresLive` (exact texts, `leorna` skill step 4).
2. `bash ./scripts/test-module-add.sh`, serially and never alongside `make check`.
3. `make library-check` (AC4).
4. The production image check from PR #94: `docker build --no-cache` in a detached copy, `RUN go build` DONE, `gitleaks version` = 8.30.1, then remove the tag. Bind `DOCKER_CONFIG`/`BUILDX_CONFIG` to owned scratch.
5. Client (Q5 A): its three gates.
6. Stop at `ready-for-review`.

## Gates summary

`make check` (workspace, contracts-check, fmt, vet, test, lint, audit, secrets, library-check, build) with the DB-skip rules; `scripts/test-module-add.sh` serially; `make library-check`, which now runs **every tile variant × declared tool** (AC4); `TestShippedTilesPassTheGate`; the image build; the client gates for the fixture PR. Each AC's own test runs alone by full name with `-count=1 -v`. A skip is not a pass.

## Host prerequisites (this WSL desktop, checked 2026-11-08)

`make` and `gcc` (cgo on), `docker` (daemon reachable, `docker ps` works without sudo), gitleaks 8.30.1, Chrome for Testing, `claude` 2.1.319 and `codex` 0.165.0 are present. `go`, `golangci-lint` and `govulncheck` are **not on PATH**, but they're installed in `~/.local/leorna-toolchain`: go1.27.3 = `go.work`, golangci-lint 2.14.0 = CI, govulncheck v1.7.0 = CI. Bind them task-locally (T0). `psql` is missing (not needed). `leorna-test-pg` exited 7 days ago: use your own container. **Cursor isn't installed** (Q7). Nothing here needs Justin, except the live run.

## Assumptions

- No API change: tiles already reach the client via `GET /v1/client/integration-tiles`, and docs and vetting are server-side.
- The planned tile item names `tile-<id>-<variant>` don't collide with library items (`git grep "tile-"` under `internal/library/content`; the builder checks).
- `Param.Example` is filled for every required param on main (all 3 present). The gate fails if one is missing.
- With Q2 A, "own sign-in" for GitHub means the engineer's own token. 928h later moves it into the keyring.
- `codex mcp list` reads config without connecting: proven in 901-era runs only for listing. The builder confirms it doesn't hit the network (no auth prompt, returns instantly) before relying on it, otherwise it drops it.

## Risks

- **927y not merged** (Q1). The AC2 and AC5 admin parts depend on its routes. If it changes before merging, these tests follow it.
- **Client PR order** (Q5 A). The CP PR's `SOURCE.md` must name a merged client commit, so Justin merges the client PR first, and a one-line delta commit follows.
- **Gate pin test** (`ci_test.go`). It's a guard: the change must only add `-tiles`. A reviewer checks no weakening.
- **Docker launcher widens the policy** for library items too. The strict argument list and mutation receipts keep it narrow.
- **ClickUp/Codex** may fail live (dynamic registration refused). Then come back to Justin (Q4 B).
- **Google** remains unusable in tools (Q3). The hand-over must say so, and the card can't close on A.
- **Digest drift**: the pin is immutable. A newer server needs a deliberate re-pin (README).

## Follow-ups (not in this story)

- Promote GitHub/ClickUp to `stable` after the live run passes in every listed tool (Q8 A).
- Google: client pre-registered OAuth client support + 928h + live test on a Workspace domain (Q3 A; Christian split).
- 928h: replace the manual GitHub token with the desktop prompt and keyring.
- GitHub local server OAuth (Q2 C) as an option once Docker on laptops is acceptable.
- A shared credential-key rule between `internal/integration/tile.go` and `gate/policy.go` (`policy.go:36` comment).

## Hand-over

Hand-over only: no push, no PR, no ClickUp post or status change, no team message until Justin says "push" / "make a PR" / "post". The finisher drafts the PR texts for both repos (Christian's plain style, Assumptions incl. Google and 928h), a review prompt, the ClickUp evidence (AC → test → result, `ac1…ac5` PNGs, live AC2 owed), and the Zayd/Christian messages per Q6/Q3. Two things are named as owed to Justin: **AC2 (live)**, and Google's part of AC2 if Q3 is A.

## Skill lessons

- memory (leorna-control-plane-workflow.md): The render-parity rule ("copy a merged client change", `internal/library/render/testdata/client/SOURCE.md`) means that any change to a tile's rendered output needs a client fixture PR merged first. Check this before planning a tile edit. Enforce: none.

## Approval (Justin, 2026-11-07)
Justin replied **go**: the plan, every ⭐ answer (Q1 A … Q8 A) and AC2 as `(live)` are approved.
- Q1 A: the builder starts only after 86bcm927y is merged on GitHub main. At approval, main was `c8abbdd`, with no 927y PR yet.
- Q2 A: ship without 86bcm928h. Q3 A: Google stays a vetted preview tile and its AC2 part becomes a follow-up. Q4 A: Codex is listed for ClickUp. Q5 A: Enterprise Server is pinned by digest, with strict Docker rules plus a client fixture PR merged first. Q6 A: Justin messages Zayd. Q7 A: the live accounts are a GitHub test org and a ClickUp test workspace, with no Google domain. Q8 A: the tiles stay `preview`.
- Hand-over only: no push, PR or ClickUp post until Justin says so.
