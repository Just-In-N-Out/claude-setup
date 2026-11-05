# 86bcm927y — Proposed Google configuration amendment

## Decision for Justin — not approved

**Question: keep this story server-only and explicitly defer Google, or add the client compatibility dependency?**

- **B — Defer Google configuration/selection (recommended).** Keep all three tiles visible, label Google unavailable, and finish GitHub/ClickUp configuration, pack selection and audit. This deliberately changes the Google clauses of the approved acceptance contract. It preserves the control-plane boundary and introduces no client release, secret handling or schema migration.
- **A — Preserve Google acceptance with a client dependency.** Native tools document client-ID fields, so this is a credible development path, not an impossible feature. It needs a separately reviewed client change/release, real-tool compatibility receipts, an explicit older-client rollout policy, and Justin's client PR merge before copying its serializers into the server. This option needs its own dependency plan before building; approving this document's B implementation does not authorize A.
- **C — Export manual setup instructions.** Save the ID as metadata/instructions and ask engineers to configure tools themselves. This requires explicitly replacing the native-preview/copied-setting expectation with a manual setup expectation. It does not meet the current criterion and is not recommended: it adds another partial setup flow without resolving consumer compatibility.

The proposed executable tasks below implement **B only**. A bare **go** to this proposal approves B and the marked clauses below. An option-only answer records the choice; main records explicit build approval under the existing Leorna workflow. Until then, the original approved plan remains authoritative and the Google failure remains open.

## Amendments proposed

1. Limit company configuration and new pack selection to GitHub/ClickUp for this increment. Google remains one of the three descriptive tiles, explicitly unavailable, with no editable company form or success/connected claim. This is a capability deferral, not a repair of Google native serialization.
2. Change Google form acceptance from valid-ID save to rejection without writes; add denial of legacy Google configuration UUIDs at the common pack resolver. Preserve stored settings and immutable pack snapshots. Do not retroactively revoke old assignments, erase items or rewrite snapshots.
3. Keep criterion IDs, primary test names, one-configuration-per-company/provider, all existing GitHub/ClickUp assertions, review order, complete gates and evidence obligations. No criterion is live; every proposed check is agent-runnable locally.
4. Original text is currently `/home/justin/.hermes/plans/leorna/evidence/86bcm927y/plan-approved.md`, SHA-256 `c48d739a845ae8139440f14be0991d4cd73bda2e117a05c53da6bccfc972740f`, with the original working plan `/home/justin/.hermes/plans/leorna/86bcm927y-integrations-catalog-tiles.md`. Neither was edited. On approval main must preserve the immutable copy as `evidence/86bcm927y/plan-approved-v1-original.md`, verify that hash, then freeze this amendment as the new active `plan-approved.md`. The archived original becomes the referenced implementation/gates annex; its conflicting Google clauses are superseded only as enumerated here. Update role briefs and handover to name the approved amendment and archived annex together. Do not overwrite historical receipts or change their verdicts.

## Playback, root cause and verified identities

The catalog implementation lets an admin save a required Google OAuth client ID, then offers an MCP item whose body and native preview omit that setting. The earlier successful GitHub journey cannot establish Google acceptance. The task here is to present a concrete scope decision and its implementation consequences; it grants no implementation or acceptance.

Read-only repository observations on 2026-11-05 UTC:

| Repository/ref | Observed identity/state |
| --- | --- |
| Control-plane candidate `/home/justin/Leorna/86bcm927y-integrations-catalog-tiles` | `feat/86bcm927y-integrations-catalog-tiles`, clean at `afbc926c78a41095471468270e69b73610f9fcb3` |
| Story base and GitHub control-plane `main` | `3aa979df41568c9039007f66d7f32193e66a8533`; confirmed by `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` |
| Client checkout `/home/justin/Leorna/leorna-client` | `main` at `f105e27814b6efbec67059687963e722933acec2`, tracked clean, 11 commits behind; pre-existing untracked `.claude/worktrees/86bcm902w-content-usage-analytics/` preserved |
| Client `origin/main` and GitHub `main` | Both `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6`; `gh api repos/LeornaAI/leorna-client/commits/main --jq .sha` agrees. The `toolconnector` subtree has no diff from the checkout to this ref. No fetch/switch/merge was needed or performed. |
| Native binaries | Codex CLI `0.165.0`, Claude Code `2.1.318`; each installed `mcp add --help` exposes a pre-registered client-ID option. No `cursor` executable found on PATH. Help/version reads are not configuration/parser or OAuth qualification. |

The brief survived the interruption, existing fixer evidence remains on disk, and no planner scratch had been created before the interruption. Parent separately checked clean head, artifact integrity and git connectivity. No assumptions about surviving services are needed for planning.

Root-cause evidence at candidate head:

| Boundary | Evidence and consequence |
| --- | --- |
| Definition | `internal/integration/tiles/google-workspace.json:17` declares `clientId`; its `signIn.clientIdParam` refers to that field, but its two `servers` contain URL only. |
| Render/save | `internal/integration/render.go:26` renders server fields, not sign-in metadata. `internal/integration/service.go:61` normalizes/stores values; `:73` constructs the selectable item from `rendered.Body`. |
| Pack copy | `internal/store/postgres/pack_builder.go:299` resolves configuration UUIDs to item fields/body. It does not copy configuration values or sign-in metadata. |
| Consumer | Client `toolconnector/transform.go:37` and its parser carry command/args/env/url/headers only. `toolconnector/claudecode/README.md:91` documents dropping `oauth` with warnings; Cursor/Codex use the strict shared parser. This remains true at remote client main. |
| Existing intended flow | `internal/web/client_integrations.go:12` returns public tile definitions/parameter names, never tenant configuration values. Client tracked-source searches found generated integration types and golden tests, but no consumer flow resolving `clientIdParam` to a tenant value. The existing endpoint cannot rescue this pack. |
| Source ownership | `internal/library/render/shared.go:1` and `internal/library/render/testdata/client/SOURCE.md:3` require mirrored rules/fixtures from a **merged client change**. A server-only serializer patch violates parity and leaves real clients unchanged. |

The precise failed oracle is retained in `evidence/86bcm927y/fixer-1/AC3-google-blocked.log`: the named pack-builder test's Google subtest reports persisted=true, copied-body=false, native-preview=false. Its source/overlay are `google_probe_test.go`, `integrations_ac3_stronger_test.go` and `ac3-stronger-overlay.json`. `google-representation-boundary.log` independently shows Claude dropping both candidate keys and Cursor/Codex rejecting them. These are existing executed receipts, not tests rerun by this planner.

The existing supported representations do not solve the problem: headers are HTTP headers, URL query parameters have no established OAuth-client meaning, and args/env belong to local processes rather than these remote servers. Converting Google to a new stdio proxy changes provider/deployment dependencies. Tool-specific `config` items do not add MCP OAuth support to the existing serializers. Instructions preserve text only. None satisfies unchanged native configuration within the approved server-only boundary.

## Native capability and the alternative client dependency

Official sources retrieved **2026-11-05 UTC** establish syntax feasibility, separately from Leorna support and provider qualification:

| Tool | Documented representation | Version/qualification limit |
| --- | --- | --- |
| Claude Code | Remote MCP entry `oauth.clientId`; `oauth.callbackPort` for a fixed registered callback. Secret entry is a separate CLI action. [Official MCP documentation](https://code.claude.com/docs/en/mcp#use-pre-configured-oauth-credentials). | Installed 2.1.318 help has `--client-id`/`--callback-port`; docs note the 2.1.229 redirect-host regression and its restoration in 2.1.231. No isolated native parse test was run in this planning turn. |
| Codex | `[mcp_servers.<name>.oauth]` with `client_id`; current docs also define callback settings and optional client secret. [MCP guide](https://learn.chatgpt.com/docs/extend/mcp?surface=cli), [configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference). | Installed 0.165.0 help has `--oauth-client-id`; rolling docs are not proof every current callback field exists in this build. Actual serializer acceptance still needs a version-pinned isolated-home check. |
| Cursor | Remote `mcp.json` entry `auth.CLIENT_ID`; optional secret/scopes. Desktop uses its documented callback. [Official static OAuth documentation](https://cursor.com/docs/mcp#static-oauth-for-remote-servers). | Official docs establish the format; installed desktop/CLI version and minimum compatible release were not established. No native Cursor check ran. |

Google still describes Workspace MCP as developer preview and documents OAuth client setup including a secret and registered callback. Its Claude example targets Claude.ai/Desktop, not proof of Claude Code interoperability. [Google's official configuration guide](https://developers.google.com/workspace/guides/configure-mcp-servers). Keep sign-in/secret provisioning/provider access outside this catalog amendment. A client-ID serializer alone does not make the complete Google connection ready.

If Justin selects A, the smallest next dependency is a **client-owned, non-secret pre-registered-client-ID transport/serialization change**, followed by this server's mirror import. Do not invent a new ClickUp ID; main must confirm the owning card or authorize a cardless dependency. Proposed narrow common representation is an optional remote-server `oauth` object containing `clientId` only; parse closed fields/types and reject it on stdio. Map it to the three documented native forms above. Do not collect a secret, assume `GOOGLE_OAUTH_CLIENT_SECRET` is automatically consumed by every tool, add callback/registration fields without proven need, or declare live sign-in qualified. The existing Google secret-env guidance needs owner qualification before any connection claim.

Affected files for A: client `toolconnector/transform.go`, `toolconnector/{claudecode,codex,cursor}/config.go`, their `config_test.go`/goldens, `toolconnector/integration_tiles_test.go`, `toolconnector/testdata/integrations/google-workspace--cloud.json` and per-tool integration goldens; server `internal/integration/tile.go`, `tiles/google-workspace.json`, render tests/goldens and `internal/library/render/{shared,claudecode,codex,cursor}.go`, parity fixtures/SOURCE.md, plus this story's primary HTTP/browser test. Exact field shape, unsupported-value behavior and old-client delivery policy must be approved in that dependency plan before it is called build-ready.

Old-client policy is a real gate: current Claude serializers silently omit the new field with a warning; current Cursor/Codex reject it. The pack body is opaque in OpenAPI, but its internal format is a consumer contract. No existing version/capability negotiation was found in the client pack routes. An additive JSON field and a warning do not establish backwards compatibility. Either enforce capability-aware delivery in a separately approved contract change, or approve a controlled deployment whose enrolled clients are all demonstrably on the new release before any Google item is enabled. No current evidence proves that latter inventory. Do not turn a release note into an enforcement claim.

For A, sequence client tests/full review/verification → separately authorized push/PR → **Justin merges client** → copy only that merged source/fixtures into server → add Google body/three native-output assertions → full review 2 and acceptance. Keep all four primary acceptance tests in the control-plane repo because `ac-check.sh` accepts one `--repo`; client tests/native checks are supporting receipts. Each repo needs its own review records/referee. A branch receipt does not waive the merged-source rule or authorize merging. These dependencies make A larger than the remaining server-only repair. B is recommended for bounded scope, not because current native tools fundamentally cannot carry a client ID.

## Proposed acceptance criteria for option B

- AC1 (proposed amendment): Given the admin console, all three predefined integrations appear with description and declared parameter labels; GitHub/ClickUp expose configuration, while Google explicitly says unavailable and offers information only, with no editable fields, save control or misleading ready/connected claim. Test: `TestIntegrationsAC1TilesWithPostgres`. Evidence: `AC1/tiles-desktop.png`, `AC1/tiles-mobile.png`, `AC1/google-unavailable.png` and the named test log.
- AC2 (proposed amendment): GitHub/ClickUp values retain every approved validation/save/update rule; Google configuration creates/updates are refused with HTTP 409 after existing auth/CSRF checks, regardless of submitted client ID, with settings/revisions/audit unchanged and no submitted value echoed. Test: `TestIntegrationsAC2ValidateWithPostgres`. Evidence: `AC2/invalid-field.png`, `AC2/saved-settings.png`, `AC2/google-refused.png` and the named test log with row/revision checks.
- AC3 (proposed amendment): Configured GitHub/ClickUp items are visible/filterable and addable to new/existing packs with their actual supported native output; company settings survive copied MCP body/preview, prior snapshots and confirmation checks remain intact, foreign UUIDs are denied, and Google configurations—including pre-amendment rows—cannot be newly selected through UI or common pack resolution. Test: `TestIntegrationsAC3PackBuilderWithPostgres`. Evidence: `AC3/builder-selection.png`, `AC3/native-preview.png`, `AC3/google-not-selectable.png` and named snapshot/isolation/denial test log.
- AC4: Given a save or change, then a change-audit record is written. Test: `TestIntegrationsAC4AuditWithPostgres`. Evidence: `AC4/audit.png`, genuine terminal capture for rollback, and the named test log; proposed supporting addition proves a rejected Google submission writes no event.

These are **explicit changed expectations for approval**, not a claim that the card was originally limited to two providers. The fourth criterion's original words/test remain unchanged. Its no-write-on-rejection/atomicity obligations still apply. No added AC number and no live tag are needed. The original plan's required-assertions table, host/gates/browser procedure and handover rules apply except for the enumerated Google changes and obsolete initial-environment observations. Missing local evidence cannot become live acceptance.

## Reconcile every affected assertion and earlier receipt

At `afbc926`, the four primary functions live in `internal/web/integrations_test.go`. Read their entire diff from story base before changing assertions. The pre-amendment expectations reconcile as follows:

| Test/assertion location | Retained or explicitly changed expectation |
| --- | --- |
| Tiles function, lines 24–95 | Keep exact three-card count, correct names/descriptions/stages/variant labels, declared parameter labels, navigation, member 403 and unauthenticated redirect. Change Google's detail input/help assertions at 58 and ready-looking per-tool OAuth strings at 65–79 to unavailable/read-only guidance. Keep GitHub/ClickUp's editable labels, tool guidance and device wording unchanged. Google still exposes its OAuth client-ID label as informational text. |
| Validation function, lines 97–227 | Keep IPv6 bracket/port round trips; ports 1/65535 accepted and 0/65536/overflow refused; all required/scheme/credentials/path/query/fragment/host/length/control/duplicate/undeclared/CSRF/revision checks and zero write counts. Keep normalized saved value, prepopulation, stable UUID/revision, no-op 400, stale 409, valid update 303 and GitHub zero-param 303. **Change Google's invalid-ID 400 and valid-ID 303 at 205–206 to deferral 409 for both**, and add empty ID/update rejection and zero-delta row/audit checks. Keep member 403, anonymous 401, unknown tile 404 and invalid request 400. Google definition-level format tests remain intact; a disabled save form is no longer their runtime entry point. |
| Pack-builder function, lines 304–402 | Keep GitHub catalog checkbox, target requirement 409, actual `.mcp.json` review/settings, no pre-confirmation pack, confirmed 303, new/existing copied body, stale digest 409, immutable earlier snapshot, remove/re-add current revision and foreign-ID denial. Add ClickUp zero-param save/catalog/pack/native checks for its declared supported tools. Add legacy Google UUID absence and direct resolver denial. The prior Google positive preservation obligation is explicitly deferred; never replace its historical failed result with a pass. |
| Audit function, lines 416–494 | Keep exactly one create/one update event, correct actor/tenant/target, create null-before, redacted metadata field set, changed parameter name, revisions 1→2, no foreign audit, and zero events on denied/no-op/stale/invalid requests. Add Google rejection without events. Preserve independent forced-audit-failure rollback coverage in `internal/store/postgres/integrations_test.go`. |
| Supporting tests/definitions | Preserve `TestConfiguredIntegrationCatalogWithPostgres`, namespace-collision behavior, `TestIntegrationCatalogResolutionWithPostgres`, tenant/membership/security tests, definition validation/render goldens and mirrored client parity. Add service/store and selection-denial regression cases. No reason to alter existing Google definition-only rendered URL fixtures: they document the pre-existing definition, not enabled company configuration. |
| Browser journey | Keep actual GitHub/ClickUp journey, desktop/narrow/keyboard checks and genuine recorded demo. Add Google unavailable detail visit and server-refused forged POST receipt; no enabled Google form or connection demonstration. Existing UI capture paths remain; add the three Google-specific captures above. |

Earlier receipt families, all retained under `/home/justin/.hermes/plans/leorna/evidence/86bcm927y/`:

- `builder/gates/{ac1-*,ac2-*,ac3-*,ac4-*,head-ac*,final-ac*}.{log,json}`, `builder/builder-report.json`, `builder/evidence-manifest.json`, `builder/AC1/`, `builder/AC2/`, `builder/AC3/`, `builder/AC4/`, `builder/demo/manifest.json` and its GIF: original all-tiles/form expectations, Google valid-ID save coverage, GitHub-only native proof. These remain historical at their recorded heads, not amendment acceptance.
- `review-1/AC1Tiles.{log,json}`, `AC2Validate.{log,json}`, `AC3PackBuilder.{log,json}`, `AC4Audit.{log,json}`, `review.json`, `review-report.json`, `browser-retry/` and original `AC3/`: same old expectations; Google false acceptance explicitly rejected by the review. `google-copy-probe.{log,json}`, `google_probe_test.go`, `google-overlay.json` remain evidence of the actual defect.
- `fixer-1/AC1.{log,json}`, `AC2.{log,json}`, `AC3-existing-coverage.{log,json}`, `AC4.{log,json}`, the matching `.patch` receipts, `browser/`, `browser-qualified/`, `browser-png/` and each demo manifest: same old acceptance semantics with URL fixes. Do not rename the GitHub preview into a Google proof. The authoritative fixer handback is `fix-report.json`; older browser attempts retain their own limitations.
- `fixer-1/AC3-google-blocked.{log,json,patch}`, `integrations_ac3_stronger_test.go`, `google_probe_test.go`, `ac3-stronger-overlay.json`, `google-representation-boundary.log`, `google_representation_probe_test.go`, `google-scope-decision.json`: remain failed Google preservation / successful incompatibility diagnostics. After B, a new test proves refusal, not preservation. The original positive oracle remains unfulfilled and deferred by approval.
- `builder/mutations.json`, `fixer-1/mutations.json`, IPv6/port RED/GREEN receipts and `required-validation-replay.log`: assertions about validation, tenant isolation/audit and ports remain valid historical sensitivity evidence where unchanged. They cannot cover new Google refusal or selection guards. Rerun targeted new guard mutants on the final candidate; do not relabel old mutants.

Each role produces new logs/screenshots/manifest on its own tested head. A new green suite does not erase the old failed Google contract. Existing full-gate receipts are baseline context only.

## Exact implementation scope and policy

Only the control-plane worktree changes for B. No OpenAPI property, native serializer, tile definition, generated contract, migration, client source or Connector API change is needed. The same tenant/admin/CSRF/secret-scanner paths remain. The only behavior change is availability of company Google configuration/selection.

Use one explicit policy constant and error in `internal/integration/configuration.go`, with a helper suitable for UI/service use:

```go
// Fragment inside package integration, using the existing errors import.
const DeferredGoogleTileID = "google-workspace"
const GoogleConfigurationDeferred = "Google Workspace configuration is unavailable until native client setup support is released."
var ErrDeferred = errors.New("integration configuration is deferred")

func ConfigurationDeferral(tileID string) string {
	if tileID == DeferredGoogleTileID {
		return GoogleConfigurationDeferred
	}
	return ""
}
```

This is a scoped temporary availability rule, not a generic capability framework. Service `Save` checks it after identifying the embedded tile and before resolving/scanning/writing values. `SaveSpec.Validate` returns `ErrDeferred` for the same tile so direct store calls cannot create/update it. Existing repository reads still return stored data for ownership checks/read-only status; do not delete/mutate rows or return submitted data in errors.

`internal/web/integrations.go`: add `UnavailableReason string` to card/page view models. Populate via the helper. For a deferred card replace Configure/Edit with a clearly labelled information link and visible unavailable status; preserve its description/parameter label. Its detail page is informational, with no `<form method="post">`, named parameter input, Save button or success banner even with `?saved=1`. Show stored-settings-retained wording if a legacy row exists without exposing its values. Do not show the existing generic secret-env or ready-looking per-tool instructions on this unavailable page. Other cards/forms stay unchanged. After `adminFormLimit` and page ownership loading, reject a Google POST with 409 and the constant explanation. Map `ErrDeferred` to 409 as defense in depth. Preserve auth/CSRF/body-limit response precedence.

`internal/web/library_variants.go`: skip configured rows whose tile has a deferral in `catalogEntries`; do not filter all `mcp_template` content or remove the three definition tiles. `internal/store/postgres/pack_builder.go`: add `AND c.tile_id <> $3` only to the `integration_configurations` branch of `loadCatalogItems`, passing `integration.DeferredGoogleTileID` as the third query argument. Import the existing integration package. This keeps tenant predicates/collision checks and blocks a forged same-tenant UUID through every draft/create/new-version caller. Missing/foreign/deferred UUIDs retain `org.ErrInvalid`, avoiding a new enumeration signal. Shared library content and immutable existing pack versions are outside this specific configuration availability rule.

Legacy policy: keep rows readable by their owning admin, hide them from new catalog selection, deny edits, and leave old pack bytes/digests unchanged. Existing assigned packs are not revoked or repaired by B. The feature has not been deployed in this pipeline; test legacy behavior using synthetic pre-amendment rows, never production mutation. If rollout discovers real previously published Google snapshots, report them to the owner before enabling the release; do not silently delete or migrate them. Re-enabling Google requires its own reviewed compatibility work, not removal of a guard without the positive preservation tests.

## Ordered test-first tasks after approval

All files below are relative to `/home/justin/Leorna/86bcm927y-integrations-catalog-tiles`. Use the candidate `afbc926` as the amendment RED baseline while retaining original story base `3aa979d` for full review/AC checking. Never reset the shared checkout. Preflight fresh owned services after the host interruption; do not reuse sibling processes/databases.

1. **Availability refusal, approximately 5–10 minutes editing plus test time.** In `internal/web/integrations_test.go`, replace only the two Google status expectations identified above, add absent/malformed/valid client-ID and revision-1 refusal checks, and compare integration/audit row counts and existing row revision before/after. Add the complete service regression below to `internal/integration/service_test.go` using its existing imports/fakes; it compiles before production changes. Add direct store rejection to `internal/store/postgres/integrations_test.go` without weakening its existing auth cases. Run RED with the named validation test; on current code the valid-ID case wrongly returns 303. Implement the policy/service/SaveSpec/HTTP checks above. Rerun the same checks GREEN; then also assert the new typed `ErrDeferred` in supporting tests. No scan/provider call should be needed for a deferred save.

2. **Honest tile/detail UI, approximately 5–10 minutes editing plus test time.** Change only Google's branch inside `TestIntegrationsAC1TilesWithPostgres`: assert unavailable text and informational client-ID label; no parameter control/POST form/Save/false success, including direct `?saved=1`. Keep the three-card count and the other two providers' assertions. RED sees the enabled form; implement the card/page models and conditional template in `internal/web/integrations.go`; rerun the exact named test GREEN. Check normal member/anonymous handling on the Google detail route too.

3. **Legacy selection denial, approximately 10–15 minutes editing plus test time.** Add subtests to `TestIntegrationsAC3PackBuilderWithPostgres` and `TestIntegrationCatalogResolutionWithPostgres`. Seed a synthetic legacy Google row using the existing fixture pool: create a normal GitHub configuration through the real handler/store, then update that row's `tile_id`, variant, item name, values and body to the pre-amendment Google values/URL-only body. Test-only SQL represents old persisted data; it is not a product import path or new permission. Snapshot its ID/revision/body and audit count. Assert absence of its checkbox under all current catalog filters, then submit that UUID through draft preview, create and existing-pack version selection and call the store directly: refusal, zero new pack versions/audit, unchanged row. Also exercise another tenant's UUID. RED sees the row selected; add the web filter and common resolver predicate above, then GREEN. Preserve all existing GitHub/snapshot/digest assertions and add ClickUp successful pack/native coverage for its declared supported tools; do not broaden a variant's supported-tool list.

4. **Snapshot preservation and audit, approximately 5–10 minutes editing plus test time.** Use a disposable baseline database filled by `afbc926` with Google row plus confirmed pack, then start the amended candidate against that same owned schema/data, or insert equivalent historical pack rows through existing test fixture SQL. Assert exact old pack body/version/digest and configuration row are unchanged, GET/history still works, and new selection/edit is refused. In the named audit test add rejection/no-event cases; retain rollback test and useful redacted metadata assertions. No migration change or checksum update. Run relevant store/pack suites and each named criterion separately.

5. **Browser/demo and guard sensitivity, approximately 10–20 minutes plus execution.** Extend `internal/web/integrations_browser_test.go` to visit the unavailable Google detail, including mobile, and retain real GitHub/ClickUp input→validation→save→preview→confirm→edit→audit journey. Add the specified screenshots; record a new genuine GIF on the final head, with manifest and action times. Use a direct HTTP companion request with fixture cookies for forged Google POST (existing CSP blocks injected fetch); render its real response for the refusal capture. Mutate service/store save guard, UI deferral branch and resolver predicate separately in owned overlays/copies under the required 4 GiB memory cap; corresponding named tests must fail on their actual assertion, not compilation/setup. Keep assertions concise rather than diffing huge trees. Restore only owned scratch edits.

6. **Docs, records and final local gates.** Update `internal/integration/README.md` and `internal/web/README.md` to state two configurable providers plus visible deferred Google, immutable legacy behavior and the named tests. Update only an existing relevant story section in `delivery/stories.json` if a real dependency/status field needs correction; no guessed PR/card numbers. Main owns amendment approval copies/briefs/shared memory; later finisher prepares handover/evidence/PR and ClickUp drafts under this story's evidence folder. Include all source/test/doc changes before the next review; do not tack on an unchecked final commit. Preserve c39aa3f/afbc926 URL fixes, earlier commit history and sibling custom-domain work.

Complete service regression for task 1 (append in the existing test file; no new imports):

```go
func TestConfigurationServiceDefersGoogleBeforeWriting(t *testing.T) {
	tiles, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	repository := &configurationStore{}
	scanner := &configurationScanner{}
	_, err = NewService(repository, tiles, scanner).Save(context.Background(), store.Principal{}, Configure{
		TileID: "google-workspace", VariantID: "cloud",
		Values: map[string]string{"clientId": "123456789012-abc123def456.apps.googleusercontent.com"},
	})
	if err == nil {
		t.Fatal("deferred Google configuration was accepted")
	}
	if repository.writes != 0 || scanner.calls != 0 {
		t.Fatalf("deferred configuration reached writes=%d scans=%d", repository.writes, scanner.calls)
	}
}
```

Run its RED/GREEN command as `go test -race -count=1 ./internal/integration -run '^TestConfigurationServiceDefersGoogleBeforeWriting$' -v`. The expected RED is the explicit accepted-configuration assertion, not a missing symbol or unavailable database.

The exact local commands for the four primary tests remain:

```bash
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC1TilesWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC2ValidateWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC3PackBuilderWithPostgres$' -v
go test -race -count=1 ./internal/web -run '^TestIntegrationsAC4AuditWithPostgres$' -v
go test -race -count=1 ./internal/integration -v
go test -race -count=1 ./internal/store/postgres -run '^TestIntegration' -v
git diff --check
```

Use the approved plan annex's pinned Go/tool PATH, gitleaks and owned `_test` Postgres/ClickHouse environment. These snippets require that preflight; they are not authorization to run tests during planning. No required DB skips count as passes. Primary tests must fail on original base through the already-approved narrow HTTP-fixture adapter, and new deferral subtests must fail on `afbc926` for the old success/selection behavior. Keep both distinctions in receipts.

## Gates, rollout and remaining approval boundaries

Run the original complete local gate list: generation, `make check`, DB skip audit, module-add, story-shippable unit tests, container build/packaged gitleaks/Trivy, Helm/OpenTofu checks and the real browser demo. The prior fixer's `gates-final.json` is a baseline receipt, not a waiver or proof of the new head. Serialize resource-heavy gates and recording; create owned services/cache/profile paths under disk-backed scratch. Mutation commands always use `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; verify the same-user session bus after the restart, or use the already documented same-user fallback. Never rerun a killed process bare; inspect earlyoom for 137/143/SIGTERM/Killed.

After the remaining implementation: fresh **full review 2 from original story base**, review/fix until `review-check.sh` says MOVE ON on the candidate; fresh read-only verifier reruns gates and all four criteria on head/base; fresh blind auditor receives approved amendment plus old-plan annex, repo/head/base and only its own evidence folder, and proves them independently; main runs `ac-check.sh --repo <control-plane-worktree> --base <merge-base> --plan <active-approved-plan> --reviews <evidence> <verifier/ac.json> <auditor/ac.json>`. Actual values are filled by main, never inferred from placeholders. Later changes require review and fresh acceptance again. No finish based on an unreviewed final commit.

B changes no serialized pack format and requires no client deployment. Existing accepted GitHub/ClickUp bodies and mirrored serializer goldens must remain byte-compatible. Rollout is the normal separately authorized server release; this plan authorizes no deployment. Rolling back to the preceding candidate would re-enable the known Google defect, so it is not a recommended mitigation; retain deferral until the compatibility dependency is qualified. Local handover is not shipped/card-complete; Leorna's normal PR/merge/combined-default-CI requirements still apply, and Justin alone merges.

## Assumptions, risks, unresolved facts and found_else

- Scope reduction is material: this document cannot clear R1-1 or original Google acceptance without Justin approving B. If he wants all three providers now, choose A and retain the positive Google failure as the dependency's target.
- No native tool parser/OAuth flow was exercised here. Official syntax and installed CLI help support feasibility; they do not prove deployed Leorna/native versions or Google callback/secret compatibility. Cursor version and all-client rollout inventory remain unresolved for A, irrelevant to B's no-new-format path.
- The temporary deferral must cover both the form/service/store and common resolver; UI-only disabling would leave a real bypass. Named tests plus capped mutants must prove both boundaries.
- Legacy rows/snapshots are retained, not repaired. This avoids data loss and schema work; any actual published broken Google pack needs explicit owner handling before rollout. Local fixture evidence does not prove production inventory.
- No migration is needed for this amendment; the story's existing migration and original round-trip/rollback gates remain. No new provider, OAuth flow, secret storage, native tool-home write, auth bypass, deployment, CI edit, push/PR/post/merge or unrelated repair is authorized.
- Sibling `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain` remains independent. B avoids shared composition/migration files; preserve all sibling work and resources. Recheck touched-path overlap before later integration.
- Setup sync remains blocked by the known read-only setup gitdir, including escalated attempts reported by main. No successful fresh pull/push is claimed, no mount bypass attempted; this proposal is local.
- `found_else: []`. The unqualified generic Google secret-env guidance and missing compatibility mechanism are documented dependencies of the same blocker, not new repairs smuggled into this amendment. Prior P3 R1-4 commit-subject follow-up stays in handover.

## Skills and planning receipt

Loaded: `leorna`, `engineering-best-practices`, `implementation-planning`, `systematic-debugging`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `github`, and `openai-docs`. Read the requested global/generated/project rules, shared workflow/approval/native-boundary notes, original plan/reviewer/fixer evidence, relevant dispatcher/AC/review references and planning validation/security/tenant references. No project CLAUDE.md was found in the inspected ancestor/candidate/client roots. Backend-data-migrations applicability: no amendment schema change; preserve the original migration checks. API-contract-drift-guard and the original migration work retain their required independent review/verifier loops, orchestrated only by main.

Planning start clock: 2026-11-05 01:03:10 UTC. Initial estimate 15–25 minutes; a session/host interruption occurred before the parent resume at approximately 01:41 UTC. The estimate was exceeded in wall time; no unsupported active-effort split is claimed. Existing evidence was reused rather than replayed, and the only authored artifact is this proposal. No application tests, provider calls, native config writes, source edits, commits or acceptance checks ran during planning. Final plan syntax/criterion-parser inspection is reported in the handback separately from product verification.

Skill lessons: `skill_lessons: []`.
