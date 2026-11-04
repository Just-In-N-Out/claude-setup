# 86bccndx6 — Custom company domain for the control plane

## Approval recorded

Justin replied **"go"** after the full plan and five recommended choices were presented. Implementation is approved under choices **1A, 2A, 3A, 4A and 5A**: installer-owned configuration; one unused direct-CNAME subdomain; enable Docker Desktop's Ubuntu WSL integration for required gates; arrange the precise live grant after local review; retain existing authentication with custom OAuth callback registration where applicable. AC1–AC6, including proposed AC5/AC6 and live AC4, are approved. Docker availability must be rechecked; accepting 3A is not evidence that it is enabled. No concrete live target or cloud/DNS permission has yet been supplied. This go authorizes local implementation, testing, commits and the Full review/verification pipeline, not pushes, PRs, posts, CI workflow changes or any merge of the story into main.

## Approved choices (alternatives retained for context)

1. **Configuration surface:** **A (recommended)** — configure the domain in the existing local installer; the admin console displays the active domain, generated fallback and instructions to reopen the installer. **B** — also configure domains directly inside the hosted admin console; this needs a revised credential/authorization design before building. This plan implements A; “admin console / installer” on the card is interpreted as either surface.
2. **Supported first release:** **A (recommended)** — one unused owned subdomain, using a direct DNS CNAME; show DNS instructions first, then create the Scaleway binding and activate after the record resolves and TLS is ready. **B** — require apex domains, proxy/CDN configurations or replacing an existing production domain now; revise the plan first. A follows Scaleway's documented DNS-before-binding sequence while preserving the card's end result.
3. **WSL test prerequisite:** **A (recommended)** — start Docker Desktop on Windows and enable **Settings → Resources → WSL integration → Ubuntu**, then Apply & restart. **B** — approve planning/code work while full database/image gates remain blocked. `docker info` currently fails because WSL integration is unavailable; no dependency installation is needed for the cached Go tools.
4. **Live acceptance:** **A (recommended)** — after local review, supply privately an unused test FQDN, an approved Justin-owned Scaleway project/region/container and a feature-candidate deployment route. Explicitly authorize only that container's custom-domain create/read, nonsecret URL environment update and redeploy. Justin signs in, provisions the test installation if needed, adds its single CNAME and handles every deletion. **B** — defer live work; retain AC4 as owed to Justin. A code-plan **go** alone does not authorize these unspecified cloud/DNS operations. No real addresses, account IDs or secrets belong in chat or committed artifacts.
5. **Live login mode:** **A (recommended)** — use the approved test installation's existing authentication mode; for Google OAuth, Justin first registers the custom HTTPS callback and keeps the generated callback registered for rollback. **B** — require a new authentication setup; scope and operator ownership must be agreed first. Do not enable a new login bypass to complete this story.

The explicit go above supplies implementation approval for all A choices. A future scope change still requires a plan amendment and approval; unspecified live operations remain unauthorized. The main session records the approval and installs the immutable approved-plan copy before dispatching the builder.

## Playback and acceptance criteria

Let an admin configure an owned custom domain using the existing installer, receive its Scaleway CNAME instructions, and switch the control plane's public URL and client discovery only after DNS and TLS checks succeed. Keep the generated hostname usable, show actionable failures, and prove discovery with the real client on an approved live test subdomain. Local implementation is approved; scoped live acceptance follows local review and an explicit live grant.

- AC1: Given a domain I own, when I add it in the admin console / installer, then a Scaleway Serverless Container custom domain is created and the required DNS CNAME is shown to me — test: `TestCustomDomainRegistrationShowsCNAME`.
- AC2: Given the CNAME is in place and TLS is issued, then LEORNA_PUBLIC_BASE_URL and client discovery switch to the custom domain (old host keeps working or redirects safely) — test: `TestCustomDomainActivationPreservesGeneratedAccess`.
- AC3: Given a misconfigured / unverified domain, then a clear error is shown and the generated domain keeps working — test: `TestCustomDomainFailureKeepsGeneratedAccess`.
- AC4 (live): Live: add a test subdomain, verify https://<custom>/.well-known/leorna returns the tenant and leorna-client resolves it — test: `TestCustomDomainLiveClientDiscovery`.
- AC5 (proposed): Domain operations require the current installer session and selected Scaleway installation; forged requests, another project's resources, an unready domain, unsafe network destinations and a mismatched tenant cannot activate a domain or disclose credentials — test: `TestCustomDomainGuardsAndRetry`.
- AC6 (proposed): Reopening/resuming the installer preserves a verified active domain, reconciles an interrupted operation without duplicate bindings, rejects an incompatible old server before activation, and can explicitly restore the generated URL without deleting resources — test: `TestCustomDomainResumeAndRecovery`.

The first three lines preserve the card's wording. The fourth is its explicit Verify requirement; only that criterion needs live DNS/cloud/operator participation. The other criteria are repeatable local checks, including the simulated Scaleway service, real HTTP handlers and browser UI. Each canonical named test lives in **leorna-control-plane**, the primary repository for `ac-check.sh`. Do not replace a missing live run with a simulated success.

Card DoD remains binding: happy and failure unit/integration coverage, OpenAPI documentation where touched, formatting/lint/full applicable gates, an isolation demonstration and a short module README. DoD gates are not additional unnamed acceptance criteria.

## Current source and ownership

Planning snapshot: **2026-11-04 22:12 UTC**. Sources were inspected through immutable refs, not the stale shared checkout.

| Repository | Freshly fetched `origin/main` and GitHub main SHA | Shared checkout observed | Planned role |
|---|---|---|---|
| `/home/justin/Leorna/leorna-control-plane` | `3aa979df41568c9039007f66d7f32193e66a8533` | local main `e2254e0100a482b9201edf9b96f01936e4486d44`, behind 94; only untracked `.claude/` | All implementation, canonical tests, documentation and delivery record |
| `/home/justin/Leorna/leorna-client` | `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6` | local main `f105e27814b6efbec67059687963e722933acec2`, behind 11; only untracked `.claude/` | Read-only consumer compatibility and actual resolver execution; no production edits planned |

Both fetches used the authorized literal HTTPS recipe with `gh auth git-credential`; active GitHub account is `Justin-Leorna`. Read-only GitHub branch lookups reconfirmed the same SHAs. Shared local main was not advanced. The builder must recheck remote main and ownership after go; if it moved, record the new immutable base, assess changed owned files and obtain a plan amendment when assumptions change. Create its own worktree under `/home/justin/Leorna`, branch `feat/86bccndx6-custom-company-domain`; never reuse another story's worktree or merge into main.

The live saved intake is `evidence/86bccndx6/intake/card.json`, `comments.json`, `prerequisite.json`; card comments were empty. Named prerequisite **86bccndwq**, self-enabling client entry point, is complete. [Control-plane PR #78](https://github.com/LeornaAI/leorna-control-plane/pull/78) is merged, merge commit `0f4a9035b25698bf4093800fad26b3e1c5594f33`, and integrated in the pinned base. Its complete body/files/comments were read. Older domain-wizard work is existing infrastructure, not this custom-domain implementation.

Duplicate checks found no card/custom-domain branch in either repo, no PR referencing `86bccndx6`, no open PR in either repo and no existing plan beyond this story's brief/handoff. Existing worktrees for 901a, 901b, 901j, 901r, 901w, 901y, 901z, 902a and 902w remain owned by their stories. Shared composition files (`cmd/control-plane/main.go`, `internal/web/handler.go`, `internal/web/admin_ui.go`, contracts, README and delivery inventory) are overlap risks even without an open PR. Recheck before writing and before final qualification; do not prune, stash or reset sibling work.

Setup pull **failed** because `~/.claude-setup.git` is read-only. The main session verified local/remote setup main equality at `b56e0260bc46a40b9ff2573e571609efedabb9bc`; this is not a successful sync. Do not bypass that mount. Configured pipeline roles are Astra at xhigh.

Orchestration ownership update, 2026-11-04 22:20 UTC: fresh shared memory identifies a concurrent Full-pipeline planner for integrations catalog story `86bcm927y`, owned by that session's `/root/integrations_planner`, with brief `briefs/86bcm927y-integrations-catalog-tiles-planner.md`. No story worktree for it appeared in the refreshed worktree listing. Its planning status is separate from GitHub's open-PR result above. Before either build writes shared composition/admin/contracts/delivery files, reconcile both completed plans and current ownership; preserve the independent jobs.

### Source evidence for the minimum change

Line references below refer to the pinned base above.

| Existing owner | Relevant evidence | Consequence |
|---|---|---|
| `internal/installer/scaleway/container.go:22`, `:81`, `:126` | Installer creates the generated public URL; resume reconstructs environment from the install spec and falls back to generated | Add domain management beside this adapter and preserve an already activated custom URL during resume |
| `internal/installer/scaleway/clients.go`, `provisioners.go`, `detect.go:46` | Selected project/region and container SDK already exist; detection currently returns the first tagged container and its generated URL | Bind domain authority to the exact selected installation; refuse ambiguous target selection instead of changing the first match |
| `cmd/launcher/main.go:439`, `:447`, `:458`, `:646`; `internal/launcher/deploy.go:19` | Installer already has the project deploy credential and `ContainersFullAccess`; it has an early already-installed path | Reuse this local authority, wire domain management before that early return, and do not give broad cloud keys to the hosted web server |
| `internal/launcher/server.go:270`; `ui_installer.go:638` | Existing loopback installer routes, CSRF forms, CSP and installed dashboard | Extend those owners; no second installer app |
| `internal/web/client_discovery.go:41`, `:94`, `:132` | HTTPS origin validation, single-tenant auto-discovery, exact configured Host match | Add one explicit generated alias; preserve sole-tenant/explicit-tenant rules and unknown-host denial |
| `internal/web/client_auth.go:65` | Device grant verification URI currently derives from canonical discovery | Return the requesting allowed origin for initial client grants so an existing generated-host client keeps its same-origin contract |
| `internal/config/runtime.go:171`; `cmd/control-plane/main.go:123`, `:162`, `:176` | Google callback derives from the public URL; discovery and admin URL are wired at startup | Activation needs redeploy; browser login must start on the canonical host before setting flow cookies |
| `internal/web/handler.go:236`, `:324`; `admin_ui.go:27` | Browser login/approval routes and active-domain card already exist | Narrow safe browser redirects plus display-only configuration guidance |
| Client `onboarding/resolve.go:30`, `:49`, `:72`; `login/manager.go:117` | Client rejects redirects and a discovery backend/verification URI on another origin | Keep its security policy; serve a valid same-origin document independently on both approved hosts |

No application database table or migration is needed: Scaleway domain objects and container configuration are authoritative. Additive local installer display fields are a cache, never authorization. No new public domain-mutation API, no client source changes, no cross-repo Go import, no DNS-provider automation, no scheduled domain monitor, no apex/IDN/proxy support, no domain deletion or resource provisioning beyond an explicitly approved later live setup.

## Verified provider behavior and decisions

Scaleway documents CNAME setup **before** adding the custom domain, asynchronous certificate issuance, and continued generated-host access. This supports a DNS-instructions → create/check → activate flow, not an immediate URL switch. The UI must distinguish an entered hostname from a created binding. See [official custom-domain guide](https://www.scaleway.com/en/docs/serverless-containers/how-to/add-a-custom-domain-to-a-container/).

The [official Domains API](https://www.scaleway.com/en/developers/api/serverless-containers/domains) supplies create/list/get/delete and a tags-only update; a domain includes its container ID, hostname, status and optional error. There is no documented certificate-ready boolean or retry/revalidate action. The currently pinned SDK `v1.0.0-beta.37` already exposes those calls. Its `WaitForDomain` can return a settled error/locked status without a Go error: compare the status explicitly with `ready`.

DNS mistakes, cached records and propagation can cause an error state. Show the observed state and a repair instruction; do not promise a fixed completion time or invent a reset endpoint. If a failed provider binding cannot recover through a read/check, Justin may delete that binding himself and explicitly add it again. See [Scaleway's error-status troubleshooting](https://www.scaleway.com/en/docs/serverless-containers/troubleshooting/custom-domain-in-error-status/).

The following are design decisions, not claims made by those docs: one managed hostname at a time; direct CNAME only; independent TLS verification; no automatic resource deletion; generated-host discovery preservation; and application-level post-deploy verification before reporting success.

## Architecture and state transitions

### Authority and interfaces

Add `internal/installer/domain/domain.go` for provider-independent state and its small manager interface; add `internal/installer/domain/hostname.go` for hostname validation. Keep the Scaleway implementation in `internal/installer/scaleway/domain.go` using the existing `Clients`. Keep DNS/TLS/HTTP checks in `internal/installer/domain/probe.go`, with injected resolver/dialer/time abstractions for deterministic tests. No new SDK dependency is required.

The manager is constructed **after** sign-in/project selection from trusted `Clients`, the exact container ID/namespace and generated provider endpoint. It is replaced when the selected project changes and unavailable until selection is valid. Browser forms never supply authoritative project, region, namespace or container IDs. Before every cloud mutation, re-fetch the container and namespace, verify project/region/container membership and installation tags, and verify any reused domain's container ID/hostname. A changed or ambiguous target produces a conflict with zero writes.

The shared interface is a specification to implement after approval; imports and constructors belong in the files named in the tasks, not in a new cross-repo package:

```go
type Phase string
const (
    PhaseDNS       Phase = "dns_required"
    PhaseCreating  Phase = "creating"
    PhaseTLS       Phase = "tls_pending"
    PhaseReady     Phase = "ready_to_activate"
    PhaseUpdating  Phase = "activating"
    PhaseActive    Phase = "active"
    PhaseError     Phase = "error"
    PhaseUncertain Phase = "reconcile_required"
)
type Status struct {
    Hostname, GeneratedURL, ActiveURL, CNAME string
    Phase Phase
    Message string // safe operator text, never raw credential-bearing errors
}
type Manager interface {
    Status(context.Context) (Status, error)  // read/reconcile only
    Prepare(context.Context, string) (Status, error) // validate and show CNAME; no cloud write
    Check(context.Context) (Status, error) // explicitly requested; may create once after DNS matches
    Activate(context.Context) (Status, error)
    UseGenerated(context.Context) (Status, error)
}
```

`Prepare` and `Check` are successive steps of the user's Add flow. An unverified name shows “Create this CNAME, then check again”; it does not claim a binding exists. `Check` creates the domain only once the normalized CNAME target equals the selected generated hostname. Once provider `ready` and ordinary HTTPS certificate validation succeed, display **Activate domain**. The explicit activation separates cloud readiness from changing the running installation's advertised URL.

Use one in-flight operation per selected installation, guarded by the manager. Bind completion to a selection/operation generation so a slow result cannot update a newly selected project. The server owns the bounded operation context; closing a response or refreshing a page must not start another write. Closing the launcher cancels work and the next run reconciles provider state. Return a clear busy/conflict response for a second different operation; repeating the same completed action reads/reuses its result. This is local serialization, not a claim of distributed locking: document a single operator at a time and re-fetch before writes. Do not invent database leases or SDK compare-and-swap semantics.

### Trust and network boundaries

- Accept an ASCII DNS hostname, lowercase/trim it, validate labels and lengths consistently with the existing client's supported hostnames, and require the explicitly supported subdomain form. Reject scheme, path, port, credentials, wildcard, IP literal, localhost, empty label, Unicode and trailing-dot ambiguity. Do not silently repair an invalid name.
- Only direct CNAME to the selected container's generated hostname is accepted. Resolve DNS with a bounded timeout; normalize the provider's final trailing dot. NXDOMAIN, wrong CNAME, private addresses, TLS pending, API denied and provider error are distinct user-facing results. Escape all displayed hostname/provider text with `html/template`.
- Outbound readiness/discovery probes carry no credentials or cookies, ignore ambient proxy settings, reject redirects, bound time/body sizes and use normal x509/SNI checks. Resolve and reject non-public IPv4/IPv6 destinations, then pin the checked address in the dialer for that request to avoid DNS rebinding. A test-only injected transport may reach local TLS fixtures; production has no flag disabling these checks.
- Check CSRF and the exact bound loopback Host/Origin on new mutating installer routes, use POST, a 4 KiB form limit, and existing CSP/template patterns. Do not broaden existing sign-in or dev-login gates. Keep the installer listening only on `127.0.0.1`.
- Public discovery is metadata, never authorization. Unknown Host, forwarded-host spoofing, zero/ambiguous tenants and invalid explicit tenant configuration remain denied. Explicit configured tenant wins; aliasing must not infer a tenant from the supplied custom hostname.

### Activation, compatibility and rollback

Add optional runtime configuration `LEORNA_GENERATED_BASE_URL`. It is a strictly validated HTTPS origin provided by the trusted installer from the provider's generated endpoint. Old deployments without it keep existing single-origin behavior. When both origins exist, the allowed set is exactly canonical public origin plus generated origin; do not make arbitrary custom hostnames or suffixes acceptable.

The new server adds response header `Leorna-Custom-Domain: v1` on a successful discovery response to advertise support for this transition. Document the header in OpenAPI; preserve the discovery JSON shape. Before activation, probe the generated discovery endpoint, require this capability and a valid tenant document, and remember its tenant ID/name. An older server or not-yet-initialized tenant displays “Update/setup the control plane before activating a domain” and receives no environment write. This prevents a new installer from changing an old server that cannot preserve generated-host discovery.

Activation order is fixed:

1. Reconcile selected container, domain ownership, CNAME, provider `ready`, and TLS with hostname validation. Recheck the generated discovery capability and tenant.
2. Fetch fresh container nonsecret environment. Retain unrelated entries. Save the previous two URL entries in memory for this operation. Set `LEORNA_GENERATED_BASE_URL=https://<provider-generated-host>` and `LEORNA_PUBLIC_BASE_URL=https://<custom-host>`.
3. Send an `UpdateContainerRequest` containing only the target/region and merged **nonsecret** environment, then redeploy and explicitly require container `ready`. Do not resend secret environment, image, resources, scaling, access or unrelated configuration. No provider error text containing tokens reaches HTML/logs.
4. Probe discovery through both hosts. Custom returns its own HTTPS origin; generated returns its own HTTPS origin. Both return the baseline tenant and the unchanged schema. Require the configured container environment to match too. Then report **active**, update installer display state and advertise the custom domain in the admin console.
5. On a definitive failure after the update, re-fetch configuration. If it still equals this operation's intended URL pair, restore only the previous URL entries, redeploy and verify generated access. If the result is ambiguous or another operator changed it, stop writes, mark `reconcile_required`, and show the explicit **Use generated domain** recovery. Do not claim rollback succeeded unless its probe succeeded.

`UseGenerated` is an explicit non-destructive recovery action. It revalidates target authority, sets public URL to the generated endpoint, preserves the generated alias field, redeploys and verifies. It never deletes a domain, DNS record, certificate, container or database. Every timeout/retry first reads provider state, so a lost create response does not create a duplicate. List pages must all be read; a same-host binding on another container is a conflict, not reusable authority.

Resume/reinstall must preserve a current custom URL only when it corresponds to a domain on the selected container and the generated alias is consistent. Do not silently replace it with the generated value merely because `ContainerSpec.Env` omitted the public URL. If readiness cannot be established, stop the URL-affecting resume step with an actionable status and offer explicit recovery. An unrelated image/env update must preserve domain settings. Installer cached JSON can add `container_id`, `namespace_id` and `generated_url` for display/backward compatibility, but every action reconstructs authority from Scaleway; do not change the encrypted database-resume payload or introduce a database migration.

### Discovery and browser/client authentication

Keep the cached tenant discovery document canonical. Add a request-specific helper that validates `r.Host` against the two configured origins and returns a **copy** with `BackendUrl` set to that exact allowed origin. Do not mutate the cached pointer across requests. Use this helper in `GetClientDiscovery`, client grant/token paths and `requireClient`; keep all current tenant/token checks. Ignore `Forwarded` and `X-Forwarded-Host` for origin selection.

The initial verification URI for a generated-host client stays on generated; the corresponding custom-host URI stays on custom. The existing client therefore continues to accept both with its redirect/same-origin restrictions intact. Browser navigation may then safely canonicalize: on a known generated host, selected GET routes (`/`, `/admin` and its descendants, `/client/authorize`, `/client/login`, `/v1/auth/google/login`, gated `/dev/login`) redirect to the **configured** custom origin before creating OAuth cookies. Preserve only relative paths and validated query values; the client routes carry only a validated `user_code`. Do not redirect discovery, bearer-token API calls, POSTs or OAuth callbacks. Unknown hosts never receive an attacker-derived redirect. Use temporary redirects and `Cache-Control: no-store`, so returning to generated does not leave a permanent cached redirect.

Google callback configuration is external to this feature. With Google auth, Justin must register `https://<custom>/v1/auth/google/callback` before Activate and retain the generated callback for recovery. The UI must explain this requirement and require an operator acknowledgment for that mode; it cannot verify Google's console by guessing. Existing sessions are host-scoped; do not widen cookie Domain, transfer cookies or weaken CSRF. A sign-in in flight across a domain switch may need to restart. Mock-provider tests cover both host flows; live discovery alone is not evidence of live Google sign-in.

Generated-host API access remains available after activation. Fresh browser sign-in uses the canonical custom hostname; if its DNS later breaks, the operator can use the local installer to restore generated. Automatic ongoing DNS monitoring/failover is not part of this card.

## Ordered implementation tasks — after approval

Each numbered item is a vertical test-first slice; split its listed behavior rows into small edits rather than implementing several future states at once. Write the named failing test, run the exact package command below, verify the failure is the intended assertion or missing new symbol, make the smallest change, rerun it and the owner package. Do not claim a RED observation from this plan: no application tests were run during planning. All implementation/fixture code is written by the builder; code blocks above define interfaces, not already-existing code.

### 1. Isolate and capture the starting point

Recheck main refs, active worktrees and card branches; create the own worktree/branch from the approved remote-main base. Load Leorna, engineering-best-practices, test-driven-development, required specialists and mutation-testing-discipline for the guards. Record base, branch, cached tool versions and selected working directories in `evidence/86bccndx6/builder/preflight.md`. The main session installs this approved plan mode 444 as `evidence/86bccndx6/plan-approved.md` before dispatching the builder.

Use a disk-backed `mktemp -d /home/justin/.hermes/cache/scratch/custom-domain-builder-XXXXXX` for tool scratch, Go temporary files, test archives and browser profiles; remove only that owned folder. Do not create commits in the shared checkout. Do not touch `.claude/`, `deploy/local`, real client/tool homes or CI workflows.

### 2. Hostname and network admission, before provider writes

New files: `internal/installer/domain/hostname.go`, `hostname_test.go`, `probe.go`, `probe_test.go`, `domain.go`.

First test `TestHostname` with valid lowercase/mixed-case subdomains and rejection of empty/scheme/path/port/credentials/wildcard/IP/Unicode/overlength/empty-label/hyphen-edge inputs. Follow the consumer's label policy rather than accepting a name the real client will reject. `TestProbeRejectsUnsafeDestination` exercises all non-public address families, redirects and rebinding; `TestProbeRequiresValidTLS` covers expired/wrong-host/untrusted certs without exposing an insecure production option. `TestProbeBoundsReadAndTime` covers stalled DNS/TLS and oversize body.

```bash
go test -v -count=1 -run '^TestHostname$' ./internal/installer/domain
go test -v -count=1 -run '^TestProbe(RejectsUnsafeDestination|RequiresValidTLS|BoundsReadAndTime)$' ./internal/installer/domain
```

The complete minimal hostname implementation below is a starting task specification; its stricter subdomain requirement is the Q2 decision. Add its table test first, then this file, then the network probes independently. This uses no additional module dependency.

```go
package domain

import (
    "errors"
    "strings"
)

func NormalizeHostname(raw string) (string, error) {
    host := strings.ToLower(strings.TrimSpace(raw))
    labels := strings.Split(host, ".")
    if len(host) > 253 || len(labels) < 3 {
        return "", errors.New("enter a company subdomain such as leorna.example.com")
    }
    for _, label := range labels {
        if len(label) == 0 || len(label) > 63 || label[0] == '-' || label[len(label)-1] == '-' {
            return "", errors.New("enter a valid DNS hostname")
        }
        for _, c := range label {
            if !((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '-') {
                return "", errors.New("enter a hostname without a scheme, port or path")
            }
        }
    }
    tld := labels[len(labels)-1]
    if len(tld) < 2 {
        return "", errors.New("enter a valid public DNS hostname")
    }
    for _, c := range tld {
        if c < 'a' || c > 'z' {
            return "", errors.New("enter a valid public DNS hostname")
        }
    }
    return host, nil
}
```

Do not interpret three labels as proof of domain ownership or of a public registrable subdomain; provider/DNS checks still apply. For a multi-label public suffix, the operator must supply an actual subdomain that their DNS service permits as a CNAME. No public-suffix library or ownership claim is needed for this release.

### 3. Create/read/check the selected container's domain

New files: `internal/installer/scaleway/domain.go`, `domain_test.go`. Extend existing `container_reuse_test.go`'s SDK transport fixture patterns; use the actual pinned SDK against a fake HTTP API, not a mock of the new manager alone. Tests must inspect outgoing provider requests and retained environment.

Add one test per behavior, in this order: `TestDomainPrepareShowsGeneratedCNAME` (no write before DNS), `TestDomainCheckCreatesSelectedContainerBinding`, `TestDomainCheckReusesBindingAfterLostResponse`, `TestDomainCheckRejectsOtherContainer`, `TestDomainCheckRequiresReadyAndTLS`, `TestDomainErrorsAreSafeAndActionable`. Cover pagination, API forbidden, quota/conflict, wrong CNAME, provider `creating/error/locked`, and nil Go error with non-ready status. A persistent provider error may need operator deletion; never call DeleteDomain automatically.

```bash
go test -v -count=1 -run '^TestDomain(PrepareShowsGeneratedCNAME|CheckCreatesSelectedContainerBinding|CheckReusesBindingAfterLostResponse|CheckRejectsOtherContainer|CheckRequiresReadyAndTLS|ErrorsAreSafeAndActionable)$' ./internal/installer/scaleway
```

Manager construction must use the selected project and exact existing container, independently verify namespace membership, and refuse multiple candidate installations. Keep pending entered hostname in memory until provider creation; reopen discovers provider bindings by selected container, not arbitrary local file data. Reject more than one plausible managed candidate rather than silently selecting the first. Keep cloud request deadlines finite and use injected polling/time in tests.

### 4. Runtime origins and discovery compatibility

Tests first in `internal/config/runtime_test.go`, `internal/web/client_discovery_test.go` (new), `internal/web/client_autodiscovery_test.go`, and `internal/web/client_auth_test.go`. Implementation files: `internal/config/runtime.go`, `cmd/control-plane/main.go`, `internal/web/handler.go`, `internal/web/client_discovery.go`, `internal/web/client_auth.go`.

Add `TestGeneratedOriginConfig` for absent/configured/malformed aliases; `TestDiscoveryUsesRequestedAllowedOrigin` for both origins and capability header; `TestDiscoveryAliasKeepsTenantIsolation` for wrong Host, spoofed forwarded headers, explicit tenant and zero/multiple tenants; `TestClientGrantUsesRequestedAllowedOrigin` for the verification URI and unchanged authorization/token scope. Run concurrent custom/generated requests under `-race` to catch shared-document mutation.

```bash
go test -v -count=1 -run '^TestGeneratedOriginConfig$' ./internal/config
go test -race -v -count=1 -run '^Test(DiscoveryUsesRequestedAllowedOrigin|DiscoveryAliasKeepsTenantIsolation|ClientGrantUsesRequestedAllowedOrigin)$' ./internal/web
```

Do not add an alias from request headers, DNS lookups or a browser field. Configure both origins before serving requests. Keep the original single-tenant auto-discovery and explicit-tenant precedence tests passing. Add the header to `contracts/control-plane.openapi.yaml`; regenerate only repository-owned contracts if the established generation check requires it. No JSON field or client vendored-contract update is anticipated.

### 5. Browser login continuity and display

Tests first in new `internal/web/custom_domain_browser_test.go`, plus `internal/web/admin_ui_test.go`. Implementation: new `internal/web/custom_domain_browser.go`, `internal/web/handler.go`, `internal/web/admin_ui.go`. Add `TestGeneratedBrowserLoginRedirectsBeforeCookies`, `TestCustomDomainLoginKeepsCSRFAndTenant`, `TestCustomDomainRedirectNeverMovesAPICredentials`, `TestAdminShowsActiveAndGeneratedDomains`.

```bash
go test -v -count=1 -run '^Test(GeneratedBrowserLoginRedirectsBeforeCookies|CustomDomainLoginKeepsCSRFAndTenant|CustomDomainRedirectNeverMovesAPICredentials|AdminShowsActiveAndGeneratedDomains)$' ./internal/web
```

Use the existing auth service/fake provider and real Routes handler. Assert same-domain session/CSRF/OAuth cookies, validated user-code carryover, original generated device grant followed by canonical browser approval and generated token exchange, wrong-tenant rejection, and no arbitrary redirect destination. Preserve gated dev login rather than enabling it. The admin domain card displays active domain, generated fallback and concise installer instructions; it does not expose cloud keys or add a hosted mutation endpoint.

### 6. Activation and non-destructive recovery

Tests first in `internal/installer/scaleway/domain_test.go`, `container_reuse_test.go`, `internal/installer/state/state_test.go`, and `internal/installer/orchestrator/resume_test.go`. Implementation: `internal/installer/scaleway/domain.go`, `container.go`, `provisioners.go`, `detect.go`, `internal/installer/state/state.go`, `internal/installer/orchestrator/steps.go`.

Add `TestDomainActivationChangesOnlyURLSettings`, `TestDomainActivationRequiresCompatibleServer`, `TestDomainActivationChecksBothDiscoveryOrigins`, `TestDomainActivationCompensatesOnlyOwnWrite`, `TestDomainResumePreservesActiveURL`, `TestDomainUseGeneratedDoesNotDelete`, `TestDomainOperationsSerializeAndIgnoreStaleCompletion`. Include errors at update, redeploy, readiness and post-deploy probe, a timed-out create/update, external config change before compensation, and restart/reconcile.

```bash
go test -race -v -count=1 -run '^TestDomain(ActivationChangesOnlyURLSettings|ActivationRequiresCompatibleServer|ActivationChecksBothDiscoveryOrigins|ActivationCompensatesOnlyOwnWrite|ResumePreservesActiveURL|UseGeneratedDoesNotDelete|OperationsSerializeAndIgnoreStaleCompletion)$' ./internal/installer/scaleway
go test -count=1 ./internal/installer/state ./internal/installer/orchestrator
```

The fake provider must reject accidental secret/image/scaling updates and record every Create/Update/Redeploy/Delete call. Recovery assertions check both returned state and the actual served discovery, not just an enum. Old local JSON without additive display fields still loads; forged fields cannot select another target. The encrypted savedstate format and bootstrap RDB-only credential remain unchanged.

### 7. Installer routes, dashboard and actual browser states

Tests first: new `internal/launcher/custom_domain_test.go`, extend `cmd/launcher/main_test.go` and `cmd/launcher/installer_notice_test.go`. Implementation: new `internal/launcher/custom_domain.go`; edit `internal/launcher/server.go`, `ui_installer.go`, `installer_flow.go` as needed for state display; wire the manager in `cmd/launcher/main.go` before both existing-install and fresh-install return paths.

Use form routes `POST /install/domain/prepare`, `/install/domain/check`, `/install/domain/activate`, `/install/domain/generated`, plus `GET /install/domain/status`. Use a manager getter tied to current selection rather than a stale pointer captured at server creation. GET is read-only; POST check is the only readiness action allowed to create a binding. Status responses contain display information, never credentials or raw SDK objects. The dashboard polls bounded status or uses ordinary form reloads; no new frontend framework.

Add `TestDomainRoutesRequireInstallerSession` (CSRF, bound loopback Host/Origin, POST-only, body size, missing manager), `TestDomainDashboardShowsDNSAndFailureStates`, `TestInstallerExistingPathWiresDomainManager`, and `TestDomainUIAllowsGeneratedRecovery`. Names/UI use Add domain → CNAME instructions → Check DNS and TLS → Activate domain → Active; show Waiting/Error/Reconcile states and retry/recovery actions. No active checkmark before the final probes. Actions are disabled while an operation runs, with server-side serialization still authoritative.

```bash
go test -race -v -count=1 -run '^TestDomain(RoutesRequireInstallerSession|DashboardShowsDNSAndFailureStates|UIAllowsGeneratedRecovery)$' ./internal/launcher
go test -v -count=1 -run '^TestInstallerExistingPathWiresDomainManager$' ./cmd/launcher
```

Capture the actual new dashboard in a browser at desktop and narrow widths; check keyboard focus, labels, status announcements, long-host wrapping and copyable record target. Use fake DNS/Scaleway fixtures only behind test constructor injection. Do not put a test bypass in the shipped installer.

### 8. Canonical acceptance tests and actual-client consumer

Create `internal/web/custom_domain_acceptance_test.go` and test-only `internal/web/custom_domain_acceptance_helpers_test.go`. Keep package `web` so existing fake repository, tenant, auth and HTTP handler helpers are reusable. It may import local installer packages; first confirm no cycle. The test fixture composes the actual launcher handlers, domain manager, real Scaleway SDK against an HTTP fake, and real control-plane Routes with reload-on-fake-redeploy. Do not replace the subject with prewritten HTML or canned discovery output.

Canonical coverage:

| Criterion | Exact assertions in its one named test | Required image basename |
|---|---|---|
| First | Add flow shows exact generated CNAME; successful DNS check creates one domain with selected container ID; repeated check reuses it | `ac1-cname.png`, actual installed dashboard with DNS instructions |
| Second | No activation before CNAME/provider-ready/TLS; activation sets both URL variables; admin advertises custom; both discovery documents match their respective host and same tenant; existing generated client grant remains acceptable; browser redirect is fixed/safe | `ac2-active-domains.png`, actual active dashboard/admin domain card |
| Third | Invalid input, bad CNAME, pending/error provider and invalid TLS show distinct useful UI messages; no public-URL change; generated discovery remains valid | `ac3-unverified-domain.png`, actual failed/pending UI with generated fallback |
| Fifth | CSRF/origin/body/selected-project guards, forged target IDs, unsafe DNS/TLS, wrong tenant/Host and stale operation cannot mutate or leak; one legitimate operation proves guard isn't blanket denial | `ac5-guards.png`, capture/render of its actual named run |
| Sixth | Resume/reopen preserves active URL; lost response reconciles without duplication; old capability blocks; explicit generated recovery succeeds; update failure does not overwrite intervening config; zero deletes | `ac6-recovery.png`, actual reconciled/recovered dashboard |

Run exactly one canonical test per receipt, never accept a suite summary without that test's own PASS. New test helpers must be copied with tests in base checks. If they depend on new production APIs, an expected undefined-symbol **build** failure can prove absence on base; a missing test package/helper, empty match or setup failure cannot. When all base results are build failures, add the documented supporting hybrid/base-behavior probes without mislabelling them as pure-base evidence.

For the client consumer, create a **scratch archive** at pinned client SHA and a test-only driver under its own module, invoking the real `onboarding.HTTPResolver`; for device-grant compatibility use existing `login` tests/service entry points. Communicate over HTTP/subprocess JSON, never a Go module import from control plane into client. Put the helper template in control-plane testdata `internal/web/testdata/custom_domain_client_probe.go.txt`, then copy/build it inside the archived client module. A fixture TLS transport may be injected through the resolver's existing HTTP client seam for local tests. The live run uses normal system trust with no redirect/TLS override.

Keep this supporting consumer test distinct from the canonical acceptance assertions; a client test failure blocks acceptance, but its HEAD is the client SHA and must not be substituted for primary `HEAD=` receipts. If evidence shows a client production change is truly required, stop for a scope amendment and its own branch/review records; do not weaken `onboarding.Validate` or redirect rejection.

### 9. Full local gates, guard falsification and candidate packaging

Select cached tools with a task-local PATH; no global environment/config edits:

```bash
export PATH=/home/justin/.local/leorna-toolchain/go/bin:/home/justin/.local/leorna-toolchain/bin:$PATH
go version
golangci-lint version
govulncheck -version
make check
bash ./scripts/test-module-add.sh
```

Planning confirmed Go **1.27.3**, golangci-lint **2.14.0**, govulncheck **1.7.0**, GNU make **4.4.1**, gcc **15.2.0**. Default PATH lacked the Go tools; the exact cache paths above exist and executed. Control-plane go.mod pins 1.27.3; the client uses go1.27.0/toolchain1.27.3. Make uses selectable `GO`, `GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS`. CI pins those Go tools plus gitleaks 8.30.1 and OpenTofu 1.12.6. Confirm remaining tools on the builder before full gates; do not install/upgrade them silently.

Docker's Windows shim exists but `docker info` reports no WSL integration. Until Q3 is resolved, database tests/image builds are blocked, not passed. Run the repository's PostgreSQL and ClickHouse fixture setup using the exact image digests in `.github/workflows/ci.yml`: PostgreSQL 18.6-alpine3.23, ClickHouse 25.8. Supply scratch DB URLs through the existing test variables, not secrets in shell history or evidence. Inspect `go test -json` events for every database-dependent test across `./internal/cloud/dbcheck`, `./internal/store/postgres`, `./internal/web`; a PostgreSQL test skipped because no DSN is not full integration coverage. Run actual Docker build and applicable deployment/render checks required by current main. No CI workflow edits.

Run relevant client tests in its scratch archive: full `make check`, its lint/audit requirements and `node --test scripts/*-ui.test.cjs` with documented platform prerequisites. Native desktop-only limitations must be reported; live discovery can still use the real headless resolver. Do not use real app settings, vault entries or tool-home directories, and do not press Sync for this domain story.

Falsify the critical clauses with independent one-change mutations: bypass selected-project check, accept bad TLS, accept provider error as ready, switch PUBLIC before verification, remove generated alias, return canonical backend for generated discovery, skip tenant comparison, skip CSRF, drop unrelated env, overwrite secrets, repeat Create after timeout, and let stale completion win. Each must fail the corresponding canonical or focused test for the intended reason. Use tiny scalar assertions, not huge tree diffs. **Every mutation command on WSL** runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; retain mutation/kill evidence. Any SIGTERM/137/143/Killed requires earlyoom-log inspection before assigning test meaning, then rerun under the cap if killed.

Packaging for live use is gated on the approved route: local build and immutable digest receipt are permitted after go, but registry push/candidate deployment still needs the explicit Q4 grant. Never silently select or upload an image to a historical live server. Bind launcher artifact, control-plane image digest and source commit in the private live manifest.

### 10. Local review, independent proof, then scoped live acceptance

The builder stops at **ready-for-review**, with source committed on its feature branch, local gates and screenshots, and live work accurately pending. Commits use repo identity; no author overrides or AI trailers, no staged `CLAUDE.md`. The main session dispatches fresh reviewers/fixers; it does not inspect logs to decide correctness itself.

Use Full review rounds with `requesting-code-review`, `code-review-practice`, `review-fix-cadence`; fixes load `receiving-code-review` and TDD. Reviewer writes `evidence/86bccndx6/review-N/review.json`, returns verdict/ac_status. Run `review-check.sh --repo <own-worktree> --base <approved-base> <evidence>` until **MOVE ON**; follow its ASK JUSTIN decision, and record P3 follow-ups. If a second repo ever changes, each repo needs its own review.json and independent review-check result; one repo's clean verdict cannot cover the other.

A fresh read-only verifier then a fresh blind AC auditor independently run full gates and each local canonical test on reviewed HEAD and base, each capturing its own receipts/images in `verifier/` and `auditor/`. Auditor receives only approved plan, worktree/head/base and its own folder, never verifier output. Each report includes verdict/ac_status and lessons. Validate with `ac-check.sh --repo <own-worktree> --base <merge-base-with-origin/main> --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json`. A changed head must be reviewed and independently qualified again; no old evidence reuse by copying.

For every nonlive receipt, write first line `HEAD=<primary-full-sha>`, run only its exact named test with `go test -v -count=1 -run '^Name$' ./internal/web`, and retain the actual exit code. Base uses its own archive/copy plus head's required test-only files. Do not reset the builder worktree. Put head/base logs in each role's own folder as `acN-<head7>.log` and `acN-base-<base7>.log`, and its required screenshot basename from the table. Screenshots for visual criteria show real rendered handlers; nonvisual guard logs may be rendered to HTML and captured without inventing output. Check image readability and complete final lines. No hard links/copies between verifier and auditor evidence.

For pending live work, both reports set AC4 `accepted:false` and a truthful `not_run` reason; only the approved `(live)` marker permits **READY FOR THE USER**. Never mark it accepted from fixture HTTPS. After Q4/Q5 and local review, add/run the opt-in canonical `TestCustomDomainLiveClientDiscovery` in new `internal/web/custom_domain_live_test.go`; its presence/behavior is included in the reviewed candidate, even when no live target is supplied during local gates. A skipped live test is excluded from local per-AC logs and remains explicitly owed.

Live procedure, using only privately approved resources:

1. Justin signs into Scaleway and selects/provisions his approved test installation. He supplies the unused FQDN and scoped target in a private, mode-600 manifest outside the repo/synced/public evidence. Retain only a sanitized manifest summary, source HEAD and image digest in evidence. Do not print credentials, server URLs, project IDs or tenant personal information.
2. Deploy the reviewed feature candidate through the approved route. Verify existing generated HTTPS/discovery and tenant first. Justin completes initial setup/sign-in, and registers custom Google callback if that mode applies.
3. Open the real installer dashboard, prepare the custom hostname, and capture its CNAME instructions privately. Justin creates exactly that DNS CNAME in his DNS console. Read DNS from the test runner, then use Check; verify the new Scaleway Domain belongs to the selected container and reaches ready, and ordinary TLS validates.
4. Activate explicitly. Read the actual resulting container URL environment without logging other values. Verify `https://<custom>/.well-known/leorna` returns the expected tenant and backend origin; run the **real pinned client's HTTPResolver** against it with normal TLS and redirect rejection. The driver must assert the result, not just curl a URL. Probe generated discovery through the same real client as a supporting continuity check. No native credential store or Sync is required.
5. `TestCustomDomainLiveClientDiscovery` reads the private manifest/driver path only when `LEORNA_CUSTOM_DOMAIN_LIVE=1`, validates artifact/source binding and the preceding provider/DNS/environment facts, then executes the resolver and asserts only safe scalar outcomes. Missing opt-in is a named skip, never a pass. Capture its real terminal run as `ac4-live-client.png`; optionally capture actual client wizard success privately if available. Keep raw screenshots/logs private and use clearly marked, redacted derivatives for any shareable artifact. No upload is authorized.
6. Independent verifier and auditor rerun their own read-only live probes if permissions remain available. Do not repeat domain creation/redeploy just to make a second screenshot; they independently observe provider binding, HTTPS, environment and client resolution on the same candidate. A pure base lacking the test's new APIs can be checked locally as described above; never roll back a real cloud installation merely to manufacture a base failure. Their live provenance records must distinguish the deployment from local source-only qualification.
7. After the agreed evidence, Justin performs any domain/DNS/resource deletion or return-to-generated cleanup. A cleanup proposal is not authority to delete. If live cannot be completed, finish as **READY FOR THE USER**, naming AC4 and the remaining operator actions; do not label the story shipped.

The main session repeats review/fix → verifier → blind auditor → ac-check until **ALL ACCEPTED** or **READY FOR THE USER**. A failure with the same cause twice and no new fact goes to Justin; never silently weaken the approved criterion.

### 11. Docs and records, then handover

Write documentation after tests establish the actual final behavior: `internal/installer/README.md` (state flow, authority, retry/recovery), `cmd/launcher/README.md` (domain UI and required permissions), `internal/web/README.md` (two explicit origins and browser/API behavior), root `README.md`/`.env.example` (optional generated URL), `docs/deploy/scaleway-serverless-demo.md` (CNAME, readiness, candidate compatibility, OAuth callback and generated rollback), and `contracts/control-plane.openapi.yaml` (discovery header and per-origin response/verification-URI semantics). Keep docs concise and consistent; do not put real addresses or credentials in examples. Update generated contracts only through the existing generator and prove `contracts-check` clean.

Add `delivery/custom-company-domain.md` and the story's accurate entry in `delivery/stories.json`, following the existing schema. Reference prerequisite PR78 as already merged; leave implementation PR/deployment/live evidence fields pending where absent. Do not invent a PR number, claim main CI passed, or call the story complete. The delivery gate requires all related PRs merged plus current combined default-branch CI, which this authorized local pipeline cannot supply by itself.

The Leorna finisher produces `evidence/86bccndx6/handover.md` with final branch/head/base, changed files, exact checks, per-AC evidence, private live prerequisites, remaining AC4 debt if any, rollback instructions and copy/paste team update text **without sending it**. Record P3/unrelated findings in `follow-ups.md`. The main session alone saves any new proven memory/skill lessons and handles setup sync failure reporting. No push, PR, ClickUp status/post, evidence upload or merge is authorized by this plan.

## Risks, limitations and stop conditions

| Risk or missing fact | Handling / point that must stop |
|---|---|
| Q1/Q2 choose a different product scope | Amend/reapprove before implementation; no unplanned hosted cloud credential or DNS-provider integration |
| Docker unavailable | Block DB/image gates; never convert skipped tests into success; local pure/unit slices can proceed only after go |
| DNS/TLS/account/candidate deployment permission absent | Local work may be ready; AC4 remains live/not_run, never reuse previous server grants |
| Provider Create requires DNS first | Show CNAME before the create call; no false “created” label for a pending request |
| Certificate/provider readiness is asynchronous | Bounded checks and explicit retry; keep generated URL until all checks succeed |
| Existing server does not support aliasing | Require capability before URL mutation and deploy an approved compatible candidate first |
| OAuth callback changes with public origin | Register both callbacks before production activation; canonicalize browser GET before setting cookies; retain CSRF/tenant guards |
| Redeploy/rollback is not atomic; transient service interruption possible | Report states honestly, verify the actual running service, reconcile ambiguous operations, allow explicit generated recovery; no zero-downtime promise |
| Multiple operators or selected installation changes | Revalidate target and configuration, refuse ambiguity, serialize locally, do not overwrite a detected intervening change |
| DNS breaks after successful activation | Generated API remains available; installer recovery is explicit. Ongoing automatic failover is excluded |
| WSL native client/UI tooling limits | Actual resolver consumer is sufficient for card's resolution clause; do not claim native sign-in/UI or production Google acceptance from it |
| Sibling worktree/common-file changes | Own worktree, ownership recheck, preserve sibling meaning and requalify changed head |
| Setup repo read-only | Report failed sync and local/remote equality; do not bypass mount or claim saved plan was synchronized |

`found_else`: no additional application defect is asserted from this planning pass. Docker availability and failed setup sync are environment blockers. Generated URL reset on resume and callback/same-origin interaction are directly within this story's preservation work, not unrelated cleanup.

## Read receipts and planning validation

Actually opened required skill files: `/home/justin/.agents/skills/leorna/SKILL.md`, `engineering-best-practices/SKILL.md`, `implementation-planning/SKILL.md`, `security-best-practices/SKILL.md`, `multi-tenant-auth-management/SKILL.md`, `api-contract-drift-guard/SKILL.md`, `backend-data-migrations/SKILL.md`, `github/SKILL.md`; also feature-dispatch's full SKILL and `references/ac-verification.md`, `references/review-loop.md`, Leorna `references/live-acceptance-setup.md`, planning `references/plan-validation.md`, engineering frontend quality, tenancy architecture checklist, Go/general web security references, GitHub PR/API references.

Actually opened `/home/justin/.claude/CLAUDE.md`, both root AGENTS.md files, control-plane GLOSSARY/ADR0001, repository domain/issue-tracker/triage guidance, delivery README, current relevant source/tests/manifests/CI and client PROJECT_MEMORY. Root project CLAUDE.md files were absent; search did not locate corresponding synced copies. Client's vendored Echo CLAUDE.md is outside affected ownership. No nested affected instruction file was found. Client GLOSSARY was absent; this was not treated as known content.

Shared-memory index at `/home/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory/MEMORY.md` and applicable notes were opened: Leorna workflow/control-plane workflow, consistency/small scope/inferred assumptions, auth-bypass/CI constraints, Justin profile, live-server testing/own installation/control-plane test branch, ClickUp evidence, stop/show diff, review prompt and team handover. These are contextual guidance; live source and this story's actual grants take precedence over historical instructions and servers.

Specialist applicability: security/tenancy apply to loopback mutation authority, DNS/TLS egress and same-tenant aliasing; API drift applies to discovery/header/client compatibility; migrations skill confirms no DB migration is required and additive local cache compatibility must be tested. Systematic debugging is not invoked because this is a feature plan, not a claimed root-cause investigation. Later unexpected failures require that skill before fixes.

Planning performed read-only source/GitHub/provider research, authorized fetches and tool-version checks. No implementation, app tests, cloud operations, branch/worktree creation or commits were performed. Only this plan was written. Saved-plan validation confirmed contiguous AC1–AC6, exactly one named test per AC and live set AC4; every bash block passed `bash -n`, and both Go snippets parsed with `gofmt` (the interface fragment supplied its package/context-import wrapper). Both shared checkout status results remain the recorded main/behind state with only `.claude/` untracked. The final earlyoom journal check showed no kill entry. These syntax/read-only checks are not implementation validation.

Skill lessons: `[]`.
