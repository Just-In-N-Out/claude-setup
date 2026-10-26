# 86bcm901u — Content quality gate (CI) — implementation plan

**Approved by Justin 2026-10-22T18:49:04Z — explicit “go”, with 1A 2A 3A 4A 5A.** Sol 6.1 xhigh is authorized for local implementation, tests and scoped commits in isolated feature worktrees branched from freshly updated origin/main in each repo. Planner: Opus 5.5 xhigh (historical planning start 17:36Z, plan saved ~18:40Z); it executed no application tests or implementation. Push/PR, hosted CI runs, credentials/permissions and ClickUp posting remain separately gated. Card: https://app.clickup.com/t/86bcm901u (to do, high, M, E10, repo control-plane; re-read live via the ClickUp connector, 0 comments; sole incoming dependency `86bcm9018` is **complete**).

## Current review/fix order — Justin's latest explicit approval (2026-10-22T21:05:27Z)

Justin: “ok I think we have sol 6.1 fix these blockers and then we get opus 5.5 xhigh to review then get sol to fix again. Add this as a skill for future workflows”. This SUPERSEDES the earlier both-reports-before-fixes hold and the old unchanged-candidate Opus queue. The first full Sol review is already complete. **Sol 6.1 xhigh fixes sol-01/sol-02 NOW → fresh Opus 5.5 xhigh full review of the corrected candidate → Sol fixes valid Opus findings → required fresh independent re-review/Opus loop verification.** Clean reviews skip no-op changes. Planning/user-go, accepted 1A–5A and all release/live/hosted/evidence permissions remain unchanged.

**Current 901u 2026-10-23T10:09:50Z: OPUS r4 REVIEW COMPLETE — ALL7 EARLIER FINDINGS CLOSED; ONE P3 POLICY DECISION.** Native Opus sa-0-f9781f9c/deleg_57c9d65b reviewed unchanged clean CP `16fc0ab1bafcdb84159b083bf37d437b2969c2ea` / client `5544e7e9a34d3d16ca02792003cb2ce09510b52a`, full44CP/3client feature ranges+r4delta. No P0/P1/P2. Original sniff/chunk fixes independently closed, prior5mechanisms stayclosed;9required local gates actualexit0. Parent admitted70sealed payloads/2151627B/exactset+hash+size+mode,9real gate receipts/log/head/tree/clean bindings,16actualsuccessfulskills and280boundary/172sniff execution rows. NEW **opus-r4-01 P3**, present since original FEATURE commitd6f589581d818a6ac1bc81cf1f79d3f61621137a (notr3/r4 regression; NOT main-baseline claim): metadata JSON is unbounded; deliberately whitespace-padded item/libraryJSON >100000B can split a secret, actual gatePASS; libraryname token can then leak into reports. All3feature builds/rawdir miss; git scan catches, no complete hosted bypass. Comments/README incorrectly generalize64KiB body/example bound to allsources. **Need USER policy choice: Opus plans a metadata/single-read limit (new rejection; no build until approved plan/go), OR accept explicit pathological-metadata scanner/report-leak limitation and authorize docs-only correction before separate verification, OR pause.** No new worker/codechange yet; prior one-extrafix authority consumed by r4. Full report `evidence/86bcm901u-review-opus-after-fix-r4/report.json`; parent admission `evidence/86bcm901u-review-opus-after-fix-r4-parent-intake.json` outside seal. Reviewer ownDB3571405 absence recorded; held r3DB3095504+r4DB3463077 untouched/present, no cleanup consent/retry/reuse/alternate route. Separate fresh Opus verifier remains after disposition/corrected records; hosted/live/App/private fetch/published pin/workflow/prompt/refreshed pin/combined/native acceptance and push/PR/merge/remoteCI/auth/permission/cloud/deploy/ClickUp/post/status holds unchanged. Verdict remains FINDINGS, never relabel clean without disposition; accepted limit is not repaired or a passing universal-secret guarantee.

First-review blockers/proof remain immutable: `sol-01` P1 detected secret-bearing diagnostics in reports/stderr and `sol-02` P2 raw-stderr workflow-command injection. Full report `evidence/86bcm901u-review-sol-r1/report.json`, received findings `evidence/86bcm901u-sol-review-received-r1.json`, archived helper originals `evidence/86bcm901u-review-sol-r1-tools/`. Synthetic noncredentials only; no hosted exploit or passing-gate bypass claimed. Passing inherited gates never closes these adversarial findings.

Reusable `review-fix-cadence` is saved and integrated into feature-dispatch, leorna and receiving-code-review. The obsolete17:21EDT old-candidate reminder954f619260c6 was removed and absence read back; do not wait for it or relaunch the stale Opus brief. Check actual Claude quota when corrected candidate is ready; ask before replacing Opus. Sol fixes do not wait for Opus quota. Hosted CI, private App/access setup, unpushed pin reachability, prompt integration, publication and ClickUp posting remain separately held.

## Justin's answers — 2026-10-22T18:47:29Z

**Choices accepted: 1A 2A 3A 4A 5A; local build approved by Justin’s later explicit “go” (2026-10-22T18:49:04Z).** The earlier form answered options only; its no-build hold is now superseded by go. Justin additionally asked “btw it is branching off main yeah?”: use the dedicated feat/86bcm901u-content-quality-gate branch in each repo, from freshly updated origin/main, never from a sibling feature branch.

1. **Q1-A:** GitHub App limited to reading leorna-client. This accepts the design route, not creation/installation of an App, permission/secret changes or handling keys. Justin or an org owner sets it up separately; hosted CI remains gated until access is verified.
2. **Q2-A (accepted limitation, not a fix):** when a declared tool explicitly skips an item with a warning/reason, report skipped without failing CI. Agents currently fall in this category; their claimed tool support is not delivered by this choice. Actual transformer errors/panics, silent zero-file output with no reason, schema failures and secret findings still fail under the plan. Nothing here waives those independent checks.
3. **Q3-A:** include the small client renderer command in this story's implementation scope, with client PR before the control-plane PR. Publication still needs a separate request; no PR has been authorized by this answer alone.
4. **Q4-A:** pin the client commit for repeatable rendering, with the documented coordinated update/merge order.
5. **Q5-A:** use a throwaway demo branch for the deliberately broken-item hosted run once Justin separately authorizes publication/remote runs. This answer does not trigger that run.

CI exception remains 86bcm901u only. After explicit go: Sol build, fresh Sol full review, Sol fixes, fresh Opus full review of corrected candidate, Sol fixes valid Opus findings, then required independent checks/Opus loop verifier. Capture evidence while building and fixing; post only on post.

## Answered options (reference only; choices above govern)

**Q1 — blocker for the hosted CI part. How does control-plane CI get read-only access to `leorna-client`?** Both repos are private, the control-plane `GITHUB_TOKEN` cannot read another repo, the org has `deploy_keys_enabled_for_repositories: false`, and Justin is an org **member**, not an owner (both read live with `gh api`). Any option needs an org owner (who that is was not readable with Justin's token) or Justin's own token. This is a secrets/permissions change, which the CI exception does **not** cover, so it needs your explicit pick.
- **A ⭐ GitHub App, contents:read on leorna-client only (org owner sets it up)**
- B Your fine-grained read-only token as a secret (expires; tied to you)
- C Org owner re-enables deploy keys; read-only deploy key
- D No credential: re-plan (renders only in client CI; AC1 not met in one run)

**Q2 — A declared tool whose transformer skips the item with a reason (today: both agents, for all three tools).**
- **A ⭐ Report "skipped", don't fail (matches cards 901a/901b wording)**
- B Fail the gate (the shipped library fails until agents change)

**Q3 — The client needs a small new command (`cmd/render-bundle`), i.e. a second PR in leorna-client.**
- **A ⭐ Yes: small client PR first; control plane pins its commit**
- B No client change: re-plan (no real-transformer path is left)

**Q4 — Which client commit renders library items in CI?**
- **A ⭐ A pinned SHA in `internal/library/gate/client-renderer.ref`**
- B Always the current leorna-client `main` (non-deterministic)

**Q5 — How is the card's "deliberately broken item fails in CI" run made (only when you authorize remote runs)?**
- **A ⭐ Manual CI run on a throwaway branch with one broken item**
- B Temporary broken commit on the PR branch, then revert it

No question about the CI exception: Justin already allowed necessary workflow edits **for 86bcm901u only** (recorded below).

## Playback

Make CI prove that every content-library item can ship: validate it with the loader's schema, render it with the **real** Claude Code, Codex and Cursor transformers, and secret-scan it. A render failure for a tool the item declares fails CI with the item and tool named; every run produces a per-item compatibility report. Prove it with one CI run on a deliberately broken item (fails) and one on the real library (passes). DoD: unit + integration tests (happy + failure), lint/format/CI green including gitleaks and golangci-lint, demoable in isolation, short README note; OpenAPI only if the API changes (it does not).

The real transformers live in **leorna-client** (`toolconnector/{claudecode,codex,cursor}`). The control plane may not import client Go code (`scripts/verify-workspace.sh` enforces it), so the plan adds a tiny client command that renders one OpenAPI `ClientBundleContent` document — the exact document the desktop already downloads during Sync — and has control-plane CI build that command at a pinned client commit and run it per item. The data contract in is the existing OpenAPI schema; the answer out is a small versioned JSON document (`leorna.render-result/v1`). No OpenAPI, connector API or tenant code changes.

## Authorization and boundaries (inherited by builder, both reviewers, finisher and verifier)

- **Story-specific CI exception (Justin, 2026-10-22):** "do not worry about the CI stuff make an exception for this story". Necessary `.github/workflows/*` edits are allowed **for 86bcm901u only**. Reviewers judge workflow hunks against this plan instead of rejecting them for touching `.github/`. Existing checks must not be weakened. The exception does **not** cover secrets, permissions, credentials, publication, deployment or merge, other stories, or unrelated CI cleanup.
- **Local build approved by go on 2026-10-22:** local branches/worktrees from updated main, code, tests and scoped commits. Push, PR, remote CI runs, credential creation and ClickUp posts each still need Justin’s separate request. Never merge. Justin changes ClickUp status himself.
- Repository boundary: OpenAPI is the only code link; no cross-repo Go imports; `toolconnector.Connector` unchanged; no change to existing transformers.
- Leave the control plane's untracked `deploy/local/` untouched. Do not touch other sessions' Figma work, the shared board, notes or handoffs (Docs & records lists proposed updates for the dispatcher).
- Branch name in **both** repos: exactly `feat/86bcm901u-content-quality-gate`, created only after **go**.
- Identity `Justin Issa <justin@leorna.com>`; no AI attribution lines.

## Current source identity (pinned; build from these, not stale local checkouts)

| Repo | Remote `main` (read 2026-10-22 via `gh api`) | Local checkout | Open PRs |
| --- | --- | --- | --- |
| LeornaAI/leorna-control-plane | `0da9f5443a2a49b157cf24b5d30301345d371d3e` (PR #84 merge, 2026-10-21T21:01Z; contains loader PR #82 `e502dbb`) | 17:31Z: `main` at `0ad43a3`, **behind 11**, untracked `deploy/local/`; 18:37Z: `main` at `0da9f54` (see note) | none |
| LeornaAI/leorna-client | `8d540f1bc4e7fbedcdf00ca40f6142a425fefb1c` (PR #19 merge) | earlier `feat/86bbu3xmt-context-switching` at `9c09193`, clean; 18:37Z: `main` at `8d540f1` (see note) | none |
| addyosmani/agent-skills (idea source only) | `aeac41d4d005999432bb7312f7ff06383a91d59d`, MIT | — | — |

Source was read from `gh api …/tarball/<sha>` copies in scratch; this planner made no checkout, fetch or source change. No `86bcm901u` branch or PR exists in either repo. Both repos' `api`/`contracts` OpenAPI files are byte-identical at these SHAs.

**Changed during planning (another session, observed 18:37Z):** 86bcm9016 was approved with **go** and its build started. Both local checkouts are now on `main` at the remote SHAs above (control plane `0da9f54`, client `8d540f1`), each has a new local branch `feat/86bcm9016-prompt-kind` checked out in a worktree at `<repo>/.claude/worktrees/86bcm9016-prompt-kind`, and both show an untracked `.claude/`. Leave all of it alone; this story uses its own worktrees (T0).

## What exists (discovery)

- **Loader (86bcm9018, shipped):** `internal/library/{library.go,source.go}`. `library.Parse(fs.FS)` strictly validates `library.json` + `items/<kind>/<name>/{item.json,body.md,example.md}` (unknown fields/files rejected, errors name the item); `library.Embedded()` parses the `//go:embed all:content` copy. `Item.Tools` (`claude-code|codex|cursor`) is the item's **declared** tool list. `TestEmbeddedLibraryIsValid` and the append-only `content.lock.json` (`TestContentLockPinsEveryItemVersion`) already run in `make test`. Shipped library 0.2.0: 8 items (2 agents, 2 configs, 1 MCP template, 3 skills).
- **Bundle wire shape:** `bundle.ResolveContent(pack.PackVersion)` → `internal/web/client_bundle_content.go` `toContractBundleContent` → OpenAPI `ClientBundleContent` served at `GET /v1/client/projects/{projectId}/bundles/{bundleDigest}/content`.
- **Transformers (client):** `toolconnector.ConfigTransformer{ID; Transform(Pack) (ConfigBundle, error)}`; `claudecode.Transformer`, `codex.Transformer`, `cursor.Transformer`, wired in `application/sync.go` `NewSyncEngine`, which maps `api.ClientBundleContent` to `tc.Pack` (`verifiedPack`) and calls `Transform`. Pure, deterministic. Agents → `AgentWarnings` ("agent %q is not installed for %s; skipped", no files). Configs → only the tool whose ID prefixes the name. Codex refuses remote (URL) MCP servers with `ErrUnsupported … which Codex cannot express`. No client command renders a bundle today.
- **CI:** one workflow `ci.yml`; required status check (ruleset "Protect main") is **only** `Go quality gates` (the `quality` job). `permissions: contents: read`; actions pinned by SHA (repo has `sha_pinning_required: true`); gitleaks 8.30.1 downloaded with checksum into `$RUNNER_TEMP/gitleaks` and run as `gitleaks git` over all refs; no repo secrets exist.
- **Static expectation for the real library with the real transformers** (code reading, not a run): skills pass ×3; agents skipped ×3; `claude-code-settings` passes for Claude Code (`.claude/settings.json`); `codex-defaults` passes for Codex (`config.toml`); `github-mcp` passes ×3 (`.mcp.json`, `config.toml`, `mcp.json`). So the real library should pass under Q2-A.

## Approach

### Flow

```
CI job "Go quality gates" (required check; unchanged triggers: every PR, push to main, manual)
  │ existing steps … Verify story delivery gate
  ├─ Mint read-only leorna-client token        (actions/create-github-app-token, contents:read, leorna-client only)   [Q1-A]
  ├─ Build pinned client renderer               scripts/build-client-renderer.sh
  │     fetch leorna-client@<client-renderer.ref> into $RUNNER_TEMP (outside the workspace), token gone before build,
  │     go build -mod=vendor -buildvcs=true ./cmd/render-bundle  →  $RUNNER_TEMP/render-bundle
  ├─ Content quality gate                        go run ./cmd/content-gate …
  │     library.Parse(dir)                       → schema (AC1)
  │     gitleaks dir <library> (repo config)     → per-item secret findings (AC1)
  │     per item: bundle.ResolveContent → Content.Contract()   (the served OpenAPI document)
  │               → render-bundle (stdin JSON, empty env, 30 s, 8 MiB cap)
  │               → real claudecode/codex/cursor Transform   (AC1)
  │     classify by declared tools → fail names "<kind>/<name>@<version> [<tool>]" (AC2)
  │     write content-compatibility.{json,md}, job summary, ::error annotations (AC3)
  ├─ Upload content compatibility report        (actions/upload-artifact, 30 days)
  └─ existing Vet … Test (now with the real renderer + gitleaks env so the integration tests run) … unchanged
```

### Interfaces and data shapes

- Control plane, new package `internal/library/gate` (full code in Appendix A): `Run(ctx, Options) (Report, error)`; `Renderer` (prod `ExecRenderer`), `SecretScanner` (prod `GitleaksScanner`); `WriteReport`, `Markdown`, `Annotation`. A content problem returns a failed `Report` with nil error; an operational problem (renderer/scanner cannot run, unpinned renderer, bad answer) returns an error naming the item. The CLI exits **0** pass, **1** content failure, **2** gate could not run; CI fails on both non-zero codes.
- Control plane, `internal/bundle/contract.go`: `func (Content) Contract() contracts.ClientBundleContent` — the body of today's `toContractBundleContent`, moved so the web handler and the gate share one mapping (behaviour-preserving refactor).
- Client, new `cmd/render-bundle` (Appendix A): stdin = one `api.ClientBundleContent` (strict JSON, ≤256 MiB, body SHA-256 and `kind/name` path verified like `verifiedPack`); runs the three Sync transformers in fixed order; panics become that tool's error; stdout:

```json
{
  "format": "leorna.render-result/v1",
  "revision": "<vcs.revision from -buildvcs>",
  "modified": false,
  "tools": [
    {"tool": "claude-code", "ok": true, "files": [{"path": ".claude/skills/x/SKILL.md", "sha256": "<hex>", "bytes": 812}], "warnings": []},
    {"tool": "codex", "ok": false, "files": [], "warnings": [], "error": "toolconnector: capability not supported by connector: …"},
    {"tool": "cursor", "ok": true, "files": [], "warnings": ["agent \"x\" is not installed for cursor; skipped"]}
  ]
}
```
  Exit 0 whenever it rendered (a transformer refusal is `ok: false`), 2 for invalid input. Writes nothing to disk; needs no environment.
- Report `leorna.content-compatibility/v1` (`content-compatibility.json`): `format, result, library{name,version}, source{controlPlane, clientRenderer}, schema, secrets, items[{key, kind, name, version, declaredTools, schema, secrets, tools{claude-code|codex|cursor: {status, reason, files, warnings, error}}, result}], summary{items, passed, failed, skippedRenders, notDeclaredRenders}, failures[]`. Plus `content-compatibility.md` (one row per item, one column per tool, Failures and Skipped sections). Deterministic: no timestamps; items in loader order; tools in fixed order.

### Classification (per item × tool)

| Declared? | Renderer answer | Status | Fails? |
| --- | --- | --- | --- |
| no | anything (still rendered and recorded) | `not-declared` | no |
| yes | `ok: false` (transformer error or panic) | `fail` — `render failed: <error>` | **yes** (AC2) |
| yes | `ok: true`, ≥1 file | `pass` (warnings kept) | no |
| yes | `ok: true`, 0 files, ≥1 warning | `skipped` — transformer's reason (Q2-A) | no |
| yes | `ok: true`, 0 files, 0 warnings | `fail` — silent drop | **yes** |

Secret finding in an item folder → that item fails `[secret-scan]`; a finding anywhere else (e.g. `library.json`, unparsed folder) → library-wide fail. Schema error → library-wide fail, nothing rendered. Renderer missing a tool, answering twice, wrong format, unknown fields, other revision than the pin, or `modified: true` → operational error (exit 2).

### Trigger and path rules

No path filter: the gate runs inside the required `Go quality gates` job on every trigger the workflow already has (`pull_request`, `push` to `main`, `workflow_dispatch`). Reasons: a job- or workflow-level path filter would skip the required check entirely; a separate job joined by `needs:` would report a skipped (passing) required check when the gate fails; the gate must also run when the gate code, the pin or the transformers change, not only `internal/library/content/**`. Cost ≈ client fetch + cgo build (~1–3 min, estimate) + seconds of rendering. Placement: after "Verify story delivery gate", before `make vet`/`make test`, so (a) the env-gated integration tests can use the built renderer and (b) a broken item fails at the gate step itself.

### Secret scanning

The gate runs the **same** checksum-verified gitleaks binary and `.gitleaks.toml` as the repository scan, as `gitleaks dir` over the library directory, with `--redact`, `--ignore-gitleaks-allow` and an empty `.gitleaksignore` path (content cannot silence itself), an empty environment (no `GITLEAKS_CONFIG` override) and a JSON report decoded for RuleID/File/StartLine only — the secret is never read back. The existing `gitleaks git` step is untouched. Symlinks are rejected before parsing because gitleaks does not follow them. Tests build the fake token at run time so no secret-shaped literal is committed (the repo scan covers every branch: a committed fake would break every PR).

### Security properties kept or added

`permissions: contents: read` unchanged; no `pull_request_target`; all new actions pinned by full SHA (`actions/create-github-app-token@64ab729a6294000f5aa4a4bc0b73d1f32bc45510 # v3.3.0`, `actions/upload-artifact@cf430e030ddbb5b0abf93d22962f4752f3646cd9 # v7.0.2`, both read from GitHub on 2026-10-22; builder re-verifies). The client token is step-scoped, revoked at job end, sent only through env-scoped git config, masked, and `unset` before client code is compiled; the client source lands in `$RUNNER_TEMP`, never in the workspace (keeps `make workspace`, `make fmt`, `docker build` unaffected). The renderer and gitleaks run with an **empty environment**, bounded output and timeouts, `exec` argument lists (no shell). Fail closed everywhere: missing credential, missing binary, malformed pin, unreadable scanner report or renderer answer → non-zero exit. Residual risk (Q1): a contributor with write access to the control plane could alter a PR workflow to read the short-lived token, i.e. read leorna-client; acceptable only because that token is read-only and scoped to one repo — say so in the PR.

### Upstream reuse (agent-skills, MIT, `aeac41d`)

Read, not executed: `scripts/lib/skill-lint.js`, `scripts/validate-reference-links.js`, `evals/README.md`. Ideas adopted: errors fail CI while warnings do not (our `fail` vs `skipped`/warnings), failures that name the file/item, fail-closed exemptions owned by the validator. Not adopted (out of the ACs; follow-ups): the 1024-character skill description limit and "Use when" trigger lint, reference-link resolution, TF-IDF routing evals and headless-Claude behavioural evals (they spend tokens; no eval platform in this story). No upstream code is copied, so no notice file changes.

## Ready vs gated

| Work | State | Needs |
| --- | --- | --- |
| Client `cmd/render-bundle` + tests + README (T1) | **ready** after go | — |
| Control-plane gate, CLI, script, Makefile, fixture, report, docs (T2–T9) | **ready** after go | — |
| `ci.yml` edits (T10) | **ready** to write (story exception) | will fail in CI until Q1 credential exists |
| Local gates, mutations, real CLI runs, local evidence (T11) | **ready** | Postgres container, gitleaks, CI's golangci-lint |
| Read-only client credential (P1) | **gated** | Q1 answer + org owner action; never by an agent |
| Final `client-renderer.ref` value (P2) | **gated** | client branch pushed (Justin's "push"/"make a PR") |
| Workflow push (P3) | **gated** | Justin: `gh auth refresh -h github.com -s workflow`, or SSH push after `ssh-add` (gh token has gist/read:org/repo only) |
| Hosted good run + broken run + artifact (T13) | **gated, NOT VERIFIED until run** | P1–P3, Justin's "make a PR" and remote-run OK (Q5) |
| `delivery/stories.json` PR numbers | gated | after PRs exist |
| ClickUp closing evidence | gated | Justin says **post** |

## Files touched (exact)

**leorna-client** (`feat/86bcm901u-content-quality-gate` from `origin/main` `8d540f1`): new `cmd/render-bundle/main.go`, `cmd/render-bundle/main_test.go`, `cmd/render-bundle/README.md`. Nothing else (no toolconnector, api, vendor, go.mod or workflow change).

**leorna-control-plane** (`feat/86bcm901u-content-quality-gate` from `origin/main` `0da9f54`):
- new `internal/library/gate/{gate.go,render.go,secrets.go,report.go}`
- new `internal/library/gate/{gate_test.go,render_test.go,secrets_test.go,report_test.go,integration_test.go}`
- new `internal/library/gate/testdata/broken-library/` (library.json; items/mcp_template/remote-only/{item.json,body.md,example.md}; items/skill/fine/{item.json,body.md,example.md})
- new `internal/library/gate/testdata/golden/content-compatibility.{json,md}` (generated with `-update`, reviewed)
- new `internal/library/gate/client-renderer.ref`
- new `internal/bundle/contract.go`, `internal/bundle/contract_test.go`; edit `internal/web/client_bundle_content.go` (call `content.Contract()`, delete `toContractBundleContent`, drop the now-unused `contracts` import if nothing else uses it)
- new `cmd/content-gate/main.go`, `cmd/content-gate/main_test.go`
- new `scripts/build-client-renderer.sh`
- edit `Makefile` (`content-gate` target + `.PHONY`), `.github/workflows/ci.yml` (story exception), `internal/library/README.md`, `internal/bundle/README.md` (one sentence), `delivery/stories.json` (after PRs open)
- untouched: OpenAPI, `packages/contracts`, go.mod/go.sum, `.gitleaks.toml`, existing CI steps (only the test step gains two env vars), `deploy/local/`

## Tasks (ordered; each ends with its focused command green)

Scratch: `S=~/.hermes/cache/scratch/86bcm901u` (create), evidence `E=~/.hermes/plans/leorna/evidence/86bcm901u`. Commit only with explicit paths.

**T0 Preflight (both repos, ~10 min).**
```bash
WT=.claude/worktrees/86bcm901u-content-quality-gate   # same convention the 86bcm9016 builder uses
cd ~/Leorna/leorna-control-plane && git status --porcelain   # pre-existing untracked deploy/local/ and .claude/ belong to others: leave them
git fetch origin main && git rev-parse origin/main               # expect 0da9f54… or newer; if newer, see below
git worktree add -b feat/86bcm901u-content-quality-gate "$WT" origin/main
cd ~/Leorna/leorna-client && git status --porcelain              # only the pre-existing untracked .claude/ allowed
git fetch origin main && git worktree add -b feat/86bcm901u-content-quality-gate "$WT" origin/main
mkdir -p "$S" "$E" && date -u +%FT%TZ                            # record observed start
```
Work only inside the two new worktrees; never switch the shared checkouts' branches (other sessions use them). If SSH is locked, fetch over HTTPS via gh as in the leorna skill. Stop and ask if either main checkout has tracked uncommitted changes. If `origin/main` moved (e.g. 86bcm9016 merged), run `git diff --name-only 0da9f54..origin/main` / `8d540f1..origin/main`; a change to `internal/library/**`, `internal/bundle/**`, `internal/web/client_bundle_content.go`, `.github/workflows/ci.yml`, `toolconnector/**` or `api/**` is expected from 9016 and is fine to build on, but re-read those files first and stop if anything in this plan no longer matches the code.

**T1 Client: `cmd/render-bundle` (TDD, ~45–75 min).**
1. Write `cmd/render-bundle/main_test.go` (Appendix A.9) and a stub `main.go` with the types, `resultFormat`, `transformers`, and `run` returning 2, `render` returning `toolResult{}`.
2. RED: `GOWORK=off go test -mod=vendor ./cmd/render-bundle -count=1 -v` → assertion failures (exit 2 / empty tools / no recover), not compile errors.
3. GREEN: full `main.go` (Appendix A.8); same command passes all 6 tests.
4. `cmd/render-bundle/README.md` (Appendix A.10).
5. `make check` (real `TMPDIR`), `node --test scripts/*-ui.test.cjs`, `PATH=$S/leorna-bin:$PATH make lint audit` (golangci-lint v2.14.0 in `$S/leorna-bin`). Confirm `python3 scripts/check-boundary.py` passes (no control-plane import path string anywhere).
6. Commits: `feat(86bcm901u): render one bundle with the real transformers` (main.go, main_test.go), `docs(86bcm901u): render-bundle README`.
7. Build the local renderer for later tasks: `GOWORK=off go build -mod=vendor -buildvcs=true -o "$S/render-bundle" ./cmd/render-bundle` and record `git rev-parse HEAD`.

**T2 Control plane: shared wire mapping (~15 min).** Write `internal/bundle/contract_test.go` (A.6) + stub `Contract()` returning the zero value → RED `go test ./internal/bundle -run TestContractCarriesEveryContentField -v` (field mismatch). GREEN with A.5. Then edit `internal/web/client_bundle_content.go`: `writeClientJSON(w, http.StatusOK, content.Contract())`, delete `toContractBundleContent`, remove its now-unused import. Regression (characterization, starts green): `go test ./internal/bundle ./internal/web -run 'Bundle' -count=1 -v` with `LEORNA_TEST_DATABASE_URL` set; confirm the Postgres bundle-content tests ran, not skipped.

**T3 Gate core (TDD, ~45–60 min).** Write `gate_test.go` (A.11) and stub `gate.go` with all types and `Run` returning `Report{}, nil`. RED: `go test ./internal/library/gate -run 'TestRun' -count=1 -v` fails on assertions (not compile errors). GREEN: A.1 (it includes `sortFindings` and `orDefault`, which later files use). Then `go test ./internal/library/... -count=1`.

**T4 ExecRenderer (TDD, ~20 min).** `render_test.go` (A.12) + stub `Render` returning zero values (keep `boundedBuffer`, `firstLine`, `maxDiagnostics` from A.2 in the stub file, since T6 reuses them) → RED on assertions; GREEN with A.2. Command: `go test ./internal/library/gate -run TestExecRenderer -count=1 -v`.

**T5 Report writer (TDD, ~25 min).** `report_test.go` (A.14) + stub `WriteReport`/`Markdown`/`Annotation` returning nil/"" → RED. GREEN with A.4. Generate goldens once: `go test ./internal/library/gate -run TestWriteReportMatchesGolden -update`, read both files line by line (table shape, escaping, no timestamps), then rerun without `-update` → PASS. (Done before the scanner because `secrets_test.go` calls `Markdown`.)

**T6 GitleaksScanner (TDD, ~25 min).** `secrets_test.go` (A.13) + stub `Scan` returning `nil, nil` → RED (`TestGitleaksScannerFailsClosed`, `TestRelativeFindingsAreLibraryRelative`). GREEN with A.3. Then the real scanner: `LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)" go test ./internal/library/gate -run TestGitleaks -count=1 -v` → both real tests **PASS, not SKIP** (local gitleaks is 8.30.1, same as CI). If gitleaks reports no finding for the runtime token, stop and report the gitleaks rule behaviour instead of weakening the test.

**T7 Real-transformer integration (~20 min).** Add `testdata/broken-library/` (A.15) and `integration_test.go` (A.16). Observe first (no RED invented): with the env set, `LEORNA_TEST_RENDER_BUNDLE_BIN="$S/render-bundle" LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)" go test ./internal/library/gate -run TestQualityGate -count=1 -v` → both PASS. If the shipped-library test fails, stop: that is a real finding about content or transformers — report it with the failure lines, do not edit library content or transformers.

**T8 CLI `cmd/content-gate` (TDD, ~25 min).** `main_test.go` (A.18) + stub `run` returning 0 → RED (`TestRunFailsNamingItemAndTool`, `…BadPins`). GREEN with A.17. `go test ./cmd/content-gate -count=1 -v`.

**T9 Pin, fetch script, Makefile (~25 min).**
- `internal/library/gate/client-renderer.ref`: one line, the 40-hex SHA of the T1 client commit (placeholder until P2; the gate's own pin check is exercised by unit tests).
- `scripts/build-client-renderer.sh` (A.19), `chmod +x`. Fail-closed checks that make no network call: (W2) `env -u LEORNA_CLIENT_TOKEN bash scripts/build-client-renderer.sh "$S/c1" "$S/rb"` → exit 1 "LEORNA_CLIENT_TOKEN is empty"; (W3) `LEORNA_CLIENT_TOKEN=x bash scripts/build-client-renderer.sh ./inside "$S/rb"` → exit 1 "outside this repository"; (W4) temporarily write `main` into the pin file → exit 1 "must hold one 40-character commit SHA", then restore with `git checkout -- internal/library/gate/client-renderer.ref` (or rewrite the SHA if not yet committed). Do **not** run the fetch with a real token locally (no credential exists; never create one).
- `Makefile`: A.20 (add `content-gate` to `.PHONY`, target after `build:`). Check `make -n content-gate RENDER_BUNDLE=x`.
- Commit `feat(86bcm901u): content quality gate for every library item` (gate package, testdata, bundle/web refactor, cmd, script, pin, Makefile).

**T10 Workflow (story exception, ~15 min).** Apply A.21 to `.github/workflows/ci.yml`: four new steps after "Verify story delivery gate", and the `env` block on "Test with the race detector". Nothing else in the file changes. Static checks: `ruby -ryaml -e 'YAML.load_file(".github/workflows/ci.yml")'`; `git diff origin/main -- .github/workflows/ci.yml` shows only those hunks; every `uses:` is a full SHA; no `continue-on-error`, no `if:` on the gate step, no new `permissions:`. Optional: `actionlint` from a scratch GOBIN at a pinned version (record version or "not run"). Commit `ci(86bcm901u): run the content quality gate in Go quality gates`.

**T11 Full local gates, sensitivity proof and live run (~60–90 min including gate runtime).**
```bash
cd ~/Leorna/leorna-control-plane
docker start leorna-test-pg
export LEORNA_TEST_DATABASE_URL='postgres://leorna:<ci-only password from leorna-control-plane-workflow.md>@127.0.0.1:5432/leorna_test?sslmode=disable'
export LEORNA_TEST_RENDER_BUNDLE_BIN="$S/render-bundle" LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)"
SHA=$(git rev-parse --short=7 HEAD)
PATH="$S/leorna-bin:$PATH" make check 2>&1 | tee "$E/gates-$SHA.txt"
bash ./scripts/test-module-add.sh 2>&1 | tee -a "$E/gates-$SHA.txt"
go test ./internal/library/gate/... ./cmd/content-gate/... ./internal/bundle/... -count=1 -v 2>&1 | grep -E '^(=== RUN|--- (PASS|FAIL|SKIP))' | tee -a "$E/gates-$SHA.txt"   # zero SKIP lines required
go test ./internal/web -run 'Bundle' -count=1 -v | grep -E -- '--- (PASS|FAIL|SKIP)' | tee -a "$E/gates-$SHA.txt"                                      # Postgres ran
```
Local Go is 1.27.0 and `go.work` says 1.27.3; let the toolchain switch happen (do not edit go.work). Live/manual invocation of the real gate (this is the card's demo; screenshot the terminal):
```bash
make content-gate RENDER_BUNDLE="$S/render-bundle" CONTENT_REPORT_DIR="$E/report-real-$SHA" 2>&1 | tee "$E/live-run-$SHA.txt"   # expect exit 0, "content gate: PASS (8 items …, 6 renders skipped …)"
go run ./cmd/content-gate -library internal/library/gate/testdata/broken-library -renderer "$S/render-bundle" -gitleaks "$(command -v gitleaks)" \
  -report-dir "$E/report-broken-$SHA" -source-ref "$(git rev-parse HEAD)" 2>&1 | tee -a "$E/live-run-$SHA.txt"; echo "exit $?"   # expect exit 1 naming mcp_template/remote-only@1.0.0 [codex]
```
Mutation round (each must turn the named test red; restore with `git checkout -- <file>` after each; log to `$E/mutations-$SHA.txt`; see the Sensitivity table). Client gates were recorded in T1 as `$E/gates-client-<sha7>.txt`.

**T12 Stop and show (builder hand-off, ~10 min).** Both repos: `git diff --stat origin/main..HEAD`, key hunks, gate results; `git diff --name-only origin/main...HEAD | grep .github/` must list **only** `.github/workflows/ci.yml` in the control plane and nothing in the client. Status `ready-for-review`. No push.

**T13 Publication and hosted receipts (gated; only on Justin's requests).** Order: P1 credential exists (owner; Appendix B) → Justin "make a PR" for the **client** (push, PR) → set `client-renderer.ref` to the pushed client head SHA (reachable; it stays reachable from `main` after a merge-commit merge; if squash-merged, bump to the squash commit) → re-run T11 gates on the exact head → Justin "make a PR" for the **control plane** (P3 workflow-capable push) → read back `gh pr checks`; the PR run is the **good receipt** (gate step green, artifact `content-compatibility-<sha>`, job summary table) → if Q5-A authorized: branch `feat/86bcm901u-broken-item-demo` from the story head with one commit adding `internal/library/content/items/mcp_template/remote-only-demo/` (same three files as the broken fixture; record the lock with `go test ./internal/library -run TestContentLock -update-lock`), push, `gh workflow run CI -R LeornaAI/leorna-control-plane --ref feat/86bcm901u-broken-item-demo -f dry_run=true`, expect "Content quality gate" to fail with `mcp_template/remote-only-demo@1.0.0 [codex]: render failed: …` → **broken receipt**; run `gitleaks git --log-opts=origin/main..HEAD` before pushing it; Justin deletes the demo branch afterwards. Save `gh run view <id> --log` for the gate step and screenshots. Anything not run stays **NOT VERIFIED**.

**T14 Docs & records** — see the final section.

## Tests per acceptance criterion

| AC | Unit (fakes) | Integration (real) | CI / live |
| --- | --- | --- | --- |
| 1 schema-validated, rendered ×3, secret-scanned | `TestRunRendersEveryItemForEveryTool`, `TestRunFailsOnASchemaErrorWithoutRendering`, `TestRunFailsAnItemWithASecretFinding`, `TestRunFailsLibraryWideSecretFindings`, `TestRunRejectsSymbolicLinks`, `TestContractCarriesEveryContentField`; client `TestRenderBundleRendersAllThreeTools` | `TestQualityGatePassesTheShippedLibraryWithRealTransformers`, `TestGitleaksFindsASecretInAnItem`, `TestGitleaksFindsNothingInTheShippedLibrary` | "Content quality gate" step on the PR; `make content-gate` live run |
| 2 declared-tool render failure → CI fails naming item and tool | `TestRunFailsNamingItemAndTool`, `TestRunIgnoresRenderFailuresForUndeclaredTools`, `TestRunFailsADeclaredToolThatProducesNothing`, `TestRunReportsTransformerSkipsWithoutFailing`, cmd `TestRunFailsNamingItemAndTool`; client `TestRenderBundleReportsAToolErrorWithoutFailing`, `…AnUnknownKindPerTool` | `TestQualityGateFailsABrokenItemWithRealTransformers` | broken-library CLI run (exit 1); hosted broken-item run (gated) |
| 3 passing run → per-item compatibility report | `TestWriteReportMatchesGolden`, `TestReportJSONHasOneCellPerItemAndTool`, `TestMarkdownKeepsContentInsideCells`, cmd `TestRunPassesAndWritesTheReport` | shipped-library integration test checks every item/tool cell | artifact + job summary on the good run (gated) |

Robustness (not ACs): `TestRunRequiresThePinnedCleanRenderer`, `TestRunStopsWhenTheRendererOrScannerCannotRun`, `TestExecRendererSendsTheBundleAndDecodesTheAnswer`, `TestExecRendererRunsWithAnEmptyEnvironment`, `TestExecRendererBoundsTheChild`, `TestRelativeFindingsAreLibraryRelative`, `TestGitleaksScannerFailsClosed`, `TestAnnotationEscapesWorkflowCommands`, cmd `TestRunRejectsMissingFlagsAndBadPins`, client `TestRenderBundleReportsTheAgentSkipAsAWarning`, `TestRenderBundleRejectsBadInput`, `TestRenderRecoversATransformerPanic`. The real-binary tests skip locally without their env vars but **fail** under `GITHUB_ACTIONS=true` if unset, so CI cannot silently skip them.

## Sensitivity (deliberate-failure) checks

Use never-true comparisons rather than `false` so the build stays valid. Scope each edit to the named function.

| # | Mutation | Must fail |
| --- | --- | --- |
| M1 | `classify`: `case !render.OK:` → `case !render.OK && render.Tool == "never":` | `TestRunFailsNamingItemAndTool`, `TestQualityGateFailsABrokenItemWithRealTransformers` |
| M2 | `classify`: move `case !declared:` below `case !render.OK:` | `TestRunIgnoresRenderFailuresForUndeclaredTools` |
| M3 | `classify` default → `StatusPass` | `TestRunFailsADeclaredToolThatProducesNothing` |
| M4 | `classify` skipped case → `StatusFail` | `TestRunReportsTransformerSkipsWithoutFailing`, shipped-library integration test |
| M5 | `checkResult`: delete the missing-tool loop | `TestRunStopsWhenTheRendererOrScannerCannotRun` |
| M6 | `checkResult`: drop `|| result.Modified` | `TestRunRequiresThePinnedCleanRenderer/modified` |
| M7 | `itemRow`: failure line without `[tool]` | `TestRunFailsNamingItemAndTool` (unit and cmd) |
| M8 | `groupFindings`: send everything library-wide | `TestRunFailsAnItemWithASecretFinding` |
| M9 | `Run`: skip leftover `byItem` findings | `TestRunFailsLibraryWideSecretFindings` |
| M10 | `parse`: drop the symlink check | `TestRunRejectsSymbolicLinks` |
| M11 | `ExecRenderer`: delete `command.Env = []string{}` | `TestExecRendererRunsWithAnEmptyEnvironment` |
| M12 | `ExecRenderer`: drop the overflow check | `TestExecRendererBoundsTheChild/too_large` |
| M13 | `GitleaksScanner`: drop `--ignore-gitleaks-allow` | `TestGitleaksFindsASecretInAnItem` (real gitleaks) |
| M14 | `GitleaksScanner`: ignore the ReadFile error | `TestGitleaksScannerFailsClosed/writes_nothing` |
| M15 | `Annotation`: drop `"\n", "%0A"` | `TestAnnotationEscapesWorkflowCommands` |
| M16 | `cell`: drop the newline replacement | `TestMarkdownKeepsContentInsideCells` |
| M17 | cmd `run`: `return 0` instead of `return 1` on failure | cmd `TestRunFailsNamingItemAndTool` |
| M18 | `Content.Contract`: omit `Sha256` | `TestContractCarriesEveryContentField`, `TestRunRendersEveryItemForEveryTool` |
| M19 | client `transformers` without codex | `TestRenderBundleRendersAllThreeTools` |
| M20 | client `decode`: skip the SHA-256 check | `TestRenderBundleRejectsBadInput/body_hash_wrong` |
| M21 | client `run`: exit 1 when any tool is not OK | `TestRenderBundleReportsAToolErrorWithoutFailing` |
| M22 | client `render`: remove the `recover` | `TestRenderRecoversATransformerPanic` |
| W1 | CLI on the broken fixture | exit 1 naming the item and `codex` |
| W2–W4 | fetch script: no token / client dir inside repo / bad pin | exit 1 each, no network call |

Reviewers additionally confirm by reading `ci.yml` that the gate step is inside the required job, has no `continue-on-error`/`if:`, and that the upload step cannot turn a failure green.

## Evidence (collect while building; privacy-check before anything leaves the Mac)

Directory `/Users/justin/.hermes/plans/leorna/evidence/86bcm901u/`:
- `ac1-real-library-pass.png` — terminal of the live `make content-gate` run (PASS line + report path).
- `ac2-broken-item-fails.png` — terminal of the broken-fixture run (FAIL line `mcp_template/remote-only@1.0.0 [codex]: …`, exit 1).
- `ac3-compatibility-report.png` — the rendered `content-compatibility.md` table for the real library.
- `report-real-<sha7>/`, `report-broken-<sha7>/` (JSON + MD), `live-run-<sha7>.txt`, `gates-<sha7>.txt`, `gates-client-<sha7>.txt`, `mutations-<sha7>.txt`.
- Gated: `ci-good-<run-id>.txt/.png` (gate step log, job summary, artifact list), `ci-broken-<run-id>.txt/.png` (failed gate step with the annotation).
- Privacy: no server domain, URL bar, tenant ID, token or email in any screenshot/log; crop browser chrome on Actions pages; reports contain only SHAs, item keys and file hashes.

AC → check → result table (fill with real results only):

| Acceptance criterion | Test / evidence | Result |
| --- | --- | --- |
| Given a library change, when CI runs, then every item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned | unit + real integration tests above; live run `ac1-real-library-pass.png`; PR run gate step | ☐ |
| Given a render failure for a declared-supported tool, then CI fails with the item and tool named | `TestRunFailsNamingItemAndTool`, `TestQualityGateFailsABrokenItemWithRealTransformers`; `ac2-broken-item-fails.png`; hosted broken run | ☐ |
| Given a passing run, then a per-item compatibility report is produced | `TestWriteReportMatchesGolden`; `ac3-compatibility-report.png`; PR artifact + job summary | ☐ |

Closing-comment draft (posted only on **post**, after merge):
```
✅ Closing evidence — Content quality gate (CI) (86bcm901u)

WHAT WAS DONE
- leorna-client PR #<n> (merged <date>, merge <sha7>): cmd/render-bundle renders one OpenAPI bundle with the real Claude Code, Codex and Cursor transformers.
- leorna-control-plane PR #<m> (merged <date>, merge <sha7>): internal/library/gate + cmd/content-gate run in the required "Go quality gates" job; per-item compatibility report artifact.

WHAT WAS VERIFIED
| Acceptance criterion | Test / evidence | Result |
| … | … | … |
- Gates on <sha7>: make check ✅ (Postgres tests ran) · test-module-add ✅ · lint 0 ✅ · audit ✅ · client make check/UI/lint/audit ✅ (gates-<sha7>.txt, gates-client-<sha7>.txt)
- Mutations: <n>/<n> caught (mutations-<sha7>.txt)
- CI: good run <url> (real library passes, artifact content-compatibility-<sha>) · broken run <url> (fails naming mcp_template/remote-only-demo@1.0.0 [codex])
- Live run (<date>, real render-bundle at client <sha7>, gitleaks 8.30.1): 8 items, 0 failed, 6 renders skipped (agents) — screenshots attached.

NOT VERIFIED
- <honest list>
```

## Release, publication and rollback

- No deployment, migration or runtime behaviour change; the server binary is unchanged except the internal `Contract()` move.
- Merge order: client PR first (pin needs a reachable client commit), then control plane. Never merge either; Justin merges.
- Rollback: revert the control-plane PR (restores the previous `ci.yml`; still under this story's exception). Reverting the client PR alone breaks the pinned build, so revert control plane first.
- After merge, every control-plane PR depends on the credential and on GitHub fetch availability; if the App is removed the required check fails closed. Say this in the PR Security notes.

## Role pipeline

Approved plan → **Sol 6.1 xhigh builder** (T0–T12, stops at `ready-for-review`, never pushes) → **two fresh full reviewers in parallel: Opus 5.5 xhigh and Sol 6.1 xhigh** (report only, run gates/mutations themselves, judge the workflow hunk against this plan's exception) → **Sol 6.1 xhigh finisher** after both reviews (behaviour-changing fixes get both reviewers again) → fresh **Opus 5.5 xhigh verifier** (Agent Defect Loop applies; see Skills) → hand-over: diff stat, PR texts (plain style, Evidence block: head SHA, "Go quality gates", run URL), review prompt, team message, ClickUp evidence draft. If an Opus role hits its limit, the dispatcher asks Justin whether Sol may take it; never switch automatically. Justin's paste-ready review prompt stays the optional third check. If this plan is wrong or incomplete, the builder stops and reports instead of redesigning.

## Skills

Loaded fresh by this planner, in order: `leorna`, `engineering-best-practices`, `implementation-planning`, `cicd-staging-prod-agents`, `security-best-practices`, `qa-testing-local-cloud`; then, because discovery warranted them: `ci-failure-triage` (fail-closed required checks), `multi-repo-issue-first-execution` (two-repo merge order, immutable refs), `infra-policy-security-gates` (security-gate blocking rule). References read: `implementation-planning/references/plan-validation.md`, `security-best-practices/references/golang-general-backend-security.md`; `cicd-staging-prod-agents` and `qa-testing-local-cloud` references searched for pinning/secrets/skip guidance. Not loaded, with reason: `api-contract-drift-guard` (no OpenAPI change; the input is the existing `ClientBundleContent`), `multi-tenant-auth-management` (no tenant/auth code), `backend-data-migrations` (no schema), `systematic-debugging` (no existing bug investigated).

**Agent Defect Loop applies** — loaded skills with a "Mandatory Validation and Agent Defect Loop" section: `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`. Applicability: ci-failure-triage fully (fail-closed contracts, no zero-work passes, step guards); multi-repo-issue-first-execution for repo targeting, merge order, immutable refs and the compatibility matrix — its GitHub-issue creation/assignment steps are **N/A** (ClickUp card 86bcm901u is the single tracker; engineering-best-practices "no second tracker"; Leorna rules); infra-policy-security-gates for "block on unresolved critical security findings" (gitleaks, trivy unchanged; new gate fails closed) — IaC/Kubernetes categories N/A.

- Builder (Sol): `leorna` → `engineering-best-practices` → `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, `security-best-practices`, `cicd-staging-prod-agents`, `qa-testing-local-cloud`, `ci-failure-triage`, `multi-repo-issue-first-execution`, `github` (read-only gh); `systematic-debugging` if a test fails unexpectedly.
- Reviewers (Opus + Sol, fresh, full, report only): `leorna` → `engineering-best-practices` → `requesting-code-review` (skip its subagent and auto-fix steps), `code-review-practice`, `mutation-testing-discipline`, `security-best-practices`, `cicd-staging-prod-agents`, `ci-failure-triage`.
- Finisher (Sol): `leorna` → `engineering-best-practices` → `receiving-code-review`, `git-commit-rules`, `test-driven-development` (+ `ci-failure-triage` if a hosted run fails).
- Verifier (Opus, fresh, read only): `leorna` → `engineering-best-practices` → `ci-failure-triage`, `multi-repo-issue-first-execution`, `infra-policy-security-gates`; re-run their Required Validation Gates and the project gates (T11 commands) on the exact heads.

## Risks

1. **Credential blocker (high):** without Q1 set up by an org owner the gate cannot run in hosted CI; merging the workflow first would break every control-plane PR. Do not open the control-plane PR until the credential is verified on the story branch.
2. **Token exposure (medium):** any same-repo PR workflow can read the short-lived client token. Limited to contents:read on leorna-client, revoked at job end, never passed to child processes.
3. **Pin drift (medium):** CI renders with the pinned client, not necessarily what engineers run. Bump `client-renderer.ref` with every transformer change. With the recommended order (9016 first), 901u's T13 pin already contains the prompt transformers; later transformer stories bump the ref themselves (a non-workflow file).
4. **Required-check cost/flakiness (low–medium):** client fetch + cgo build adds minutes and a GitHub dependency to every run; failure blocks merges (fail closed by design).
5. **Toolchain coupling (low):** `GOTOOLCHAIN=local` means a client toolchain bump above `go.work` breaks the client build in control-plane CI until both align.
6. **Agents stay "skipped" (medium):** declared support no transformer delivers is visible but not blocking (Q2-A); see Other things found.
7. **Cross-repo document drift (low):** `leorna.render-result/v1` is decoded strictly; any change fails closed and needs a coordinated version bump.
8. **Demo-branch secret trap (low):** gitleaks scans every ref; the broken item must be a render failure only; scan before pushing.
9. **86bcm9021 conflict (medium, future):** its AC3 wants the same render check at item-save time on the server, which cannot run client transformers. The `Renderer` interface is reusable, but a server-side renderer is a separate architectural decision.
10. **Unverified external facts:** create-github-app-token/upload-artifact SHAs and inputs, GitHub fetch-by-SHA, App token behaviour — verified only on the hosted run.

## Assumptions (list in the PR)

1. Items render one per bundle; cross-item conflicts (two configs for one tool, duplicate MCP server names) belong to the pack builder (E11), not this gate.
2. `item.json` `tools` = declared-supported tools (loader README; card 86bcm9284 says "renders for every declared tool").
3. Sources are scanned (`library.json`, `item.json`, `body.md`, `example.md`); rendered output is derived from them and not scanned again.
4. No path filter; the gate always runs in the required job.
5. Report artifact retention 30 days.
6. PRs are merged with merge commits so a pinned client head stays reachable; otherwise bump the pin.
7. OpenAPI untouched, so that DoD item is N/A.
8. Library content is not changed by this story.

## Overlaps and proposed build order

- **86bcm9016 prompt kind (other session; approved with go, build in progress in `<repo>/.claude/worktrees/86bcm9016-prompt-kind`; plan `~/.hermes/plans/leorna/86bcm9016-prompt-kind.md`, read 18:37Z):** it modifies control-plane `internal/pack/*`, a migration, `internal/library/content/**` (new `items/prompt/pr-description`, library 0.3.0, `content.lock.json`), `internal/library/README.md`, `internal/library/library_test.go`, `internal/bundle/{bundle_test.go,README.md}`, OpenAPI + `packages/contracts`, web tests, root `README.md`, `delivery/stories.json`; client `toolconnector/{pack.go,prompt.go}`, the three `config.go` transformers, their READMEs, `api/*`, application tests, `README.md`. It does **not** touch `internal/web/client_bundle_content.go`, `cmd/`, `scripts/` or workflows. **File overlap with 901u:** only `internal/library/README.md`, `internal/bundle/README.md` and `delivery/stories.json` (text merges). **Behavioural fit (checked against its plan):** Codex skips prompts through `ConfigBundle.Warnings` (`SkippedPromptWarnings`), so this gate reports them as `skipped`/`not-declared`, never as a silent drop; `pr-description` declares `tools: [claude-code, cursor]`, rendered to `.claude/commands/pr-description.md` and `commands/pr-description.md`, so the gate should pass it once the pinned client contains 9016. 9016 renames its own unknown-kind sample from `prompt` to `future`; this plan's client test uses `not-a-kind` for the same reason.
- **Recommended order: 9016 merges first, then 901u.** At T13, 901u rebases both branches on the new mains and pins a client commit that contains both `cmd/render-bundle` and the prompt transformers; if the shipped library then has prompt items, extend `nativePaths` in the integration test with the paths the merged 9016 README documents. If 901u merged first instead, 9016's control-plane PR would fail this gate (`unknown kind` for its declared tools) until it bumps `client-renderer.ref` to a client commit with prompt support — an extra 9016 task the dispatcher would have to add (still not a workflow edit).
- **86bcm901v catalog browser (other session; its plan file is a draft in progress, read 18:40Z):** admin-console pages in `internal/web` and the Postgres `library_items` store; no code overlap with the gate. Possible text overlap only in `internal/library/README.md` and `delivery/stories.json`. No ordering constraint.
- **Downstream (wait on 901u):** 86bcm9019, 901a, 901b, 9284 (content repo) and 9021 (control plane). `-library <dir>` lets a future content repo reuse the gate; it would need the same credential.
- Parallel building is fine in separate worktrees; expected conflicts only in `internal/library/README.md`, `internal/bundle/README.md` and `delivery/stories.json`.

## Other things found (not fixed, not in scope)

1. **Medium — agents declare tools nobody installs.** `internal/library/content/items/agent/{code-reviewer,test-writer}/item.json` declare all three tools, but every client transformer only warns (`toolconnector/transform.go` `AgentWarnings`). The gate will show 6 `skipped` renders. Owner: Christian / card 86bcm901a.
2. **Low–medium — Codex forwards a different variable than the template names.** `github-mcp` maps `GITHUB_PERSONAL_ACCESS_TOKEN` to `${GITHUB_TOKEN}`; `codex/config.go` `serverTable` writes `env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN"]`, so Codex forwards the key's name while Claude Code/Cursor read `GITHUB_TOKEN`. Needs a Codex `env_vars` behaviour check before any fix (code reading only).
3. **Low — skill description limit not enforced.** Library allows 2000 runes (`library.go` via `pack.MaxDescriptionRunes`); agent-skills' linter and the Agent Skills format cap descriptions at 1024; `RenderSkill` does not check. Current descriptions are short. Follow-up for the client transformer (verify the current tool limit first).
4. **Info — CI cross-repo access is not possible today** without an org owner (deploy keys disabled org-wide; Justin is a member) — drives Q1.
5. **Info — 86bcm9021 AC3** asks for the same per-tool render check on save, which crosses the repository boundary at runtime.

## Forecast

Discovery is complete (planning ≈1 h observed). Build by Sol: **4–6.5 h active** (medium-low confidence: two repos, ~1,400 lines incl. tests, mutation round, gate runtime ~10–15 min per full run). Reviews 1–1.5 h in parallel, finisher 0.5–1.5 h, verifier 0.5–1 h. External waits not estimable: org-owner credential setup (Q1), Justin's push/PR/remote-run authority, workflow-scope auth. Size: card says M; with the second repo and credential work it is a large M.

## Docs & records (final task)

| Record | Update | Who / when |
| --- | --- | --- |
| `leorna-control-plane/internal/library/README.md` | new "Content quality gate" section (A.22) naming every test | builder, T9 |
| `leorna-control-plane/internal/bundle/README.md` | one sentence: `Content.Contract()` is the served `ClientBundleContent`, also used by the gate | builder, T2 |
| `leorna-client/cmd/render-bundle/README.md` | new (A.10) | builder, T1 |
| `leorna-control-plane/delivery/stories.json` | `"86bcm901u": {"name": "Content quality gate (CI)", "prs": {"LeornaAI/leorna-client": [<n>], "LeornaAI/leorna-control-plane": [<m>]}}` | finisher, right after both PRs open |
| This plan | append a dated status block (built heads, decisions taken, NOT VERIFIED list) | finisher |
| Evidence dir + closing-comment draft | files above; draft in the hand-over | builder collects, finisher drafts; posted on **post** |
| PR texts | plain style; Assumptions; Security notes (credential, token scope, residual risk); Evidence block | finisher |
| Shared notes (dispatcher-owned, proposed): `leorna-workflow.md` story-state line for 86bcm901u (branches, heads, PRs); `no-ci-changes.md` status line recording which workflow lines this story changed; `leorna-control-plane-workflow.md` note: the gate's real tests need `LEORNA_TEST_RENDER_BUNDLE_BIN`/`LEORNA_TEST_GITLEAKS_BIN`; `handoff-leorna-chat.md` 86bcm901u entry | dispatcher |
| Not touched | Figma CLAUDE.md / BUILD numbers, shared board rows of other sessions, `deploy/local/` | — |

---

## Appendix A — complete code

### A.1 `internal/library/gate/gate.go`
```go
// Package gate is the content quality gate (story 86bcm901u). It validates the
// library source, renders every item with the desktop client's real
// transformers, scans every item for secrets and reports the outcome per item
// and per tool.
//
// The transformers live in the leorna-client repository and are never
// imported here. The gate hands each item to the client's render-bundle
// command as the OpenAPI ClientBundleContent document the desktop already
// receives from GET /v1/client/projects/{projectId}/bundles/{bundleDigest}/content,
// and reads back what each tool would get.
package gate

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/bundle"
	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
)

// Tools are the tools every item is rendered for, in report order.
var Tools = []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}

// Document formats the gate writes and reads. A change to either shape needs a
// new version on both sides of the repository boundary.
const (
	ReportFormat = "leorna.content-compatibility/v1"
	RenderFormat = "leorna.render-result/v1"
)

// Status is one check outcome.
type Status string

// Outcomes. Only StatusFail fails the gate.
const (
	StatusPass        Status = "pass"
	StatusFail        Status = "fail"
	StatusSkipped     Status = "skipped"      // declared tool; the transformer skipped the item and said why
	StatusNotDeclared Status = "not-declared" // rendered for the report only; never fails the gate
)

var (
	// ErrRenderer reports a renderer that could not run or answered badly.
	ErrRenderer = errors.New("client renderer failed")
	// ErrRendererNotPinned reports a renderer built from another commit than the
	// pin, or from modified source.
	ErrRendererNotPinned = errors.New("client renderer is not the pinned commit")
	// ErrScanner reports a secret scanner that could not run.
	ErrScanner = errors.New("secret scanner failed")
)

// RenderedFile is one native file a transformer produced, identified by hash.
type RenderedFile struct {
	Path   string `json:"path"`
	SHA256 string `json:"sha256"`
	Bytes  int    `json:"bytes"`
}

// ToolRender is one transformer's answer, as the renderer reported it.
type ToolRender struct {
	Tool     library.Tool   `json:"tool"`
	OK       bool           `json:"ok"`
	Files    []RenderedFile `json:"files"`
	Warnings []string       `json:"warnings"`
	Error    string         `json:"error,omitempty"`
}

// RenderResult is the renderer's whole answer for one bundle.
type RenderResult struct {
	Format   string       `json:"format"`
	Revision string       `json:"revision"`
	Modified bool         `json:"modified"`
	Tools    []ToolRender `json:"tools"`
}

// Renderer renders one bundle with every tool's transformer.
type Renderer interface {
	Render(ctx context.Context, content contracts.ClientBundleContent) (RenderResult, error)
}

// Finding is one secret-scanner hit. It never carries the secret itself.
type Finding struct {
	RuleID string `json:"ruleId"`
	File   string `json:"file"` // slash-separated, relative to the library root
	Line   int    `json:"line"`
}

// SecretScanner scans every file under a library root.
type SecretScanner interface {
	Scan(ctx context.Context, root string) ([]Finding, error)
}

// Options configure one gate run.
type Options struct {
	LibraryDir string // library source on disk: library.json and items/
	Renderer   Renderer
	Scanner    SecretScanner
	SourceRef  string // control-plane commit, recorded in the report
	ClientRef  string // when set, every render must come from exactly this clean client commit
}

// Report is the per-item compatibility report.
type Report struct {
	Format   string       `json:"format"`
	Result   Status       `json:"result"`
	Library  LibraryInfo  `json:"library"`
	Source   SourceInfo   `json:"source"`
	Schema   Check        `json:"schema"`
	Secrets  Check        `json:"secrets"`
	Items    []ItemReport `json:"items"`
	Summary  Summary      `json:"summary"`
	Failures []string     `json:"failures"`
}

// LibraryInfo names the checked library.
type LibraryInfo struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

// SourceInfo records which commits were checked.
type SourceInfo struct {
	ControlPlane   string `json:"controlPlane"`
	ClientRenderer string `json:"clientRenderer"`
}

// Check is a library-wide or item-wide check outcome.
type Check struct {
	Status   Status    `json:"status"`
	Error    string    `json:"error,omitempty"`
	Findings []Finding `json:"findings,omitempty"`
}

// ItemReport is one item's row.
type ItemReport struct {
	Key           string                      `json:"key"`
	Kind          string                      `json:"kind"`
	Name          string                      `json:"name"`
	Version       string                      `json:"version"`
	DeclaredTools []library.Tool              `json:"declaredTools"`
	Schema        Status                      `json:"schema"`
	Secrets       Check                       `json:"secrets"`
	Tools         map[library.Tool]ToolReport `json:"tools"`
	Result        Status                      `json:"result"`
}

// ToolReport is one item rendered for one tool.
type ToolReport struct {
	Status   Status         `json:"status"`
	Reason   string         `json:"reason,omitempty"`
	Files    []RenderedFile `json:"files"`
	Warnings []string       `json:"warnings"`
	Error    string         `json:"error,omitempty"`
}

// Summary counts the report.
type Summary struct {
	Items       int `json:"items"`
	Passed      int `json:"passed"`
	Failed      int `json:"failed"`
	Skipped     int `json:"skippedRenders"`
	NotDeclared int `json:"notDeclaredRenders"`
}

// Run checks the library. A content problem (schema, secret or render) gives a
// failed Report and a nil error. An error means the gate itself could not run
// (options, renderer or scanner); callers must fail on both.
func Run(ctx context.Context, opts Options) (Report, error) {
	if opts.LibraryDir == "" || opts.Renderer == nil || opts.Scanner == nil {
		return Report{}, errors.New("content gate needs a library directory, a renderer and a secret scanner")
	}
	if info, err := os.Lstat(opts.LibraryDir); err != nil || !info.IsDir() {
		return Report{}, fmt.Errorf("library directory %s is not a directory", opts.LibraryDir)
	}
	report := Report{
		Format:   ReportFormat,
		Result:   StatusPass,
		Source:   SourceInfo{ControlPlane: opts.SourceRef},
		Schema:   Check{Status: StatusPass},
		Secrets:  Check{Status: StatusPass},
		Items:    []ItemReport{},
		Failures: []string{},
	}

	findings, err := opts.Scanner.Scan(ctx, opts.LibraryDir)
	if err != nil {
		return Report{}, fmt.Errorf("%w: %v", ErrScanner, err)
	}
	byItem, libraryWide := groupFindings(findings)

	lib, err := parse(opts.LibraryDir)
	if err != nil {
		report.Schema = Check{Status: StatusFail, Error: err.Error()}
		report.Failures = append(report.Failures, "library [schema]: "+err.Error())
		for _, itemFindings := range byItem {
			libraryWide = append(libraryWide, itemFindings...)
		}
		report.addLibraryFindings(libraryWide)
		report.Result = StatusFail
		return report, nil
	}
	report.Library = LibraryInfo{Name: lib.Name, Version: lib.Version}

	for index, item := range lib.Items {
		content, err := bundle.ResolveContent(pack.PackVersion{
			Name:    lib.Name,
			Version: lib.Version,
			Items: []pack.Item{{
				Kind: item.Kind, Name: item.Name, Version: item.Version,
				Description: item.Description, Body: item.Body,
			}},
		})
		if err != nil {
			return Report{}, fmt.Errorf("bundle %s: %w", item.Key(), err)
		}
		result, err := opts.Renderer.Render(ctx, content.Contract())
		if err != nil {
			return Report{}, fmt.Errorf("render %s: %w", item.Key(), err)
		}
		renders, err := checkResult(result, opts.ClientRef)
		if err != nil {
			return Report{}, fmt.Errorf("render %s: %w", item.Key(), err)
		}
		if index == 0 {
			report.Source.ClientRenderer = result.Revision
		} else if result.Revision != report.Source.ClientRenderer {
			return Report{}, fmt.Errorf("render %s: %w: revision changed from %q to %q during the run",
				item.Key(), ErrRenderer, report.Source.ClientRenderer, result.Revision)
		}

		key := string(item.Kind) + "/" + item.Name
		row, failures := itemRow(item, renders, byItem[key])
		delete(byItem, key)
		report.Items = append(report.Items, row)
		report.Failures = append(report.Failures, failures...)
		report.count(row)
	}

	// A finding in a folder that is not a parsed item still fails the gate.
	for _, itemFindings := range byItem {
		libraryWide = append(libraryWide, itemFindings...)
	}
	report.addLibraryFindings(libraryWide)
	if report.Summary.Failed > 0 || report.Secrets.Status == StatusFail {
		report.Result = StatusFail
	}
	return report, nil
}

// parse rejects symbolic links, which the secret scanner does not follow,
// before reading the library with the loader's own strict parser.
func parse(dir string) (library.Library, error) {
	err := filepath.WalkDir(dir, func(name string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.Type()&fs.ModeSymlink != 0 {
			rel, relErr := filepath.Rel(dir, name)
			if relErr != nil {
				rel = name
			}
			return fmt.Errorf("%w: %s: symbolic links are not allowed in the library", library.ErrInvalid, filepath.ToSlash(rel))
		}
		return nil
	})
	if err != nil {
		return library.Library{}, err
	}
	return library.Parse(os.DirFS(dir))
}

// checkResult indexes the renderer's answer by tool and refuses an answer
// that is not exactly one render per tool, or that came from an unpinned build.
func checkResult(result RenderResult, pin string) (map[library.Tool]ToolRender, error) {
	if result.Format != RenderFormat {
		return nil, fmt.Errorf("%w: answer format %q, want %q", ErrRenderer, result.Format, RenderFormat)
	}
	if pin != "" && (result.Revision != pin || result.Modified) {
		return nil, fmt.Errorf("%w: built from %q (modified %t), pinned %q", ErrRendererNotPinned, result.Revision, result.Modified, pin)
	}
	renders := make(map[library.Tool]ToolRender, len(Tools))
	for _, render := range result.Tools {
		if !render.Tool.Valid() {
			return nil, fmt.Errorf("%w: answered for unknown tool %q", ErrRenderer, render.Tool)
		}
		if _, duplicate := renders[render.Tool]; duplicate {
			return nil, fmt.Errorf("%w: answered twice for %s", ErrRenderer, render.Tool)
		}
		renders[render.Tool] = render
	}
	for _, tool := range Tools {
		if _, ok := renders[tool]; !ok {
			return nil, fmt.Errorf("%w: did not render for %s", ErrRenderer, tool)
		}
	}
	return renders, nil
}

// itemRow classifies one item's renders and secret findings. Every failure
// line names the item version and the tool (or "secret-scan").
func itemRow(item library.Item, renders map[library.Tool]ToolRender, findings []Finding) (ItemReport, []string) {
	declared := make(map[library.Tool]bool, len(item.Tools))
	for _, tool := range item.Tools {
		declared[tool] = true
	}
	row := ItemReport{
		Key:           item.Key(),
		Kind:          string(item.Kind),
		Name:          item.Name,
		Version:       item.Version,
		DeclaredTools: append([]library.Tool{}, item.Tools...),
		Schema:        StatusPass,
		Secrets:       Check{Status: StatusPass},
		Tools:         make(map[library.Tool]ToolReport, len(Tools)),
		Result:        StatusPass,
	}
	var failures []string
	if len(findings) > 0 {
		row.Secrets = Check{Status: StatusFail, Findings: findings}
		for _, finding := range findings {
			failures = append(failures, fmt.Sprintf("%s [secret-scan]: %s found in %s:%d", row.Key, finding.RuleID, finding.File, finding.Line))
		}
	}
	for _, tool := range Tools {
		toolReport := classify(declared[tool], renders[tool])
		row.Tools[tool] = toolReport
		if toolReport.Status == StatusFail {
			failures = append(failures, fmt.Sprintf("%s [%s]: %s", row.Key, tool, toolReport.Reason))
		}
	}
	if len(failures) > 0 {
		row.Result = StatusFail
	}
	return row, failures
}

// classify turns one render into a report cell. Only a declared tool can fail:
// a transformer error, or no files without a stated reason (a silent drop).
// A declared tool whose transformer skipped the item with a warning is
// reported as skipped, the "skipped with a reason" outcome later stories use.
func classify(declared bool, render ToolRender) ToolReport {
	out := ToolReport{Files: render.Files, Warnings: render.Warnings, Error: render.Error}
	if out.Files == nil {
		out.Files = []RenderedFile{}
	}
	if out.Warnings == nil {
		out.Warnings = []string{}
	}
	switch {
	case !declared:
		out.Status = StatusNotDeclared
	case !render.OK:
		out.Status, out.Reason = StatusFail, "render failed: "+orDefault(render.Error, "no message")
	case len(render.Files) > 0:
		out.Status = StatusPass
	case len(render.Warnings) > 0:
		out.Status, out.Reason = StatusSkipped, "skipped by the transformer: "+strings.Join(render.Warnings, "; ")
	default:
		out.Status, out.Reason = StatusFail, "declared, but the transformer produced no files and gave no reason"
	}
	return out
}

// groupFindings attributes each finding to the item folder it is in. Anything
// else (library.json, a stray file) is library-wide, so no finding is dropped.
func groupFindings(findings []Finding) (map[string][]Finding, []Finding) {
	byItem := map[string][]Finding{}
	var libraryWide []Finding
	for _, finding := range findings {
		parts := strings.Split(path.Clean(finding.File), "/")
		if len(parts) == 4 && parts[0] == "items" {
			key := parts[1] + "/" + parts[2]
			byItem[key] = append(byItem[key], finding)
			continue
		}
		libraryWide = append(libraryWide, finding)
	}
	return byItem, libraryWide
}

func (report *Report) addLibraryFindings(findings []Finding) {
	if len(findings) == 0 {
		return
	}
	sortFindings(findings)
	report.Secrets = Check{Status: StatusFail, Findings: findings}
	for _, finding := range findings {
		report.Failures = append(report.Failures, fmt.Sprintf("library [secret-scan]: %s found in %s:%d", finding.RuleID, finding.File, finding.Line))
	}
}

func (report *Report) count(row ItemReport) {
	report.Summary.Items++
	if row.Result == StatusPass {
		report.Summary.Passed++
	} else {
		report.Summary.Failed++
	}
	for _, tool := range Tools {
		switch row.Tools[tool].Status {
		case StatusSkipped:
			report.Summary.Skipped++
		case StatusNotDeclared:
			report.Summary.NotDeclared++
		}
	}
}

func orDefault(value, fallback string) string {
	if value == "" {
		return fallback
	}
	return value
}

func sortFindings(findings []Finding) {
	sort.Slice(findings, func(i, j int) bool {
		a, b := findings[i], findings[j]
		if a.File != b.File {
			return a.File < b.File
		}
		if a.Line != b.Line {
			return a.Line < b.Line
		}
		return a.RuleID < b.RuleID
	})
}
```

### A.2 `internal/library/gate/render.go`
```go
package gate

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os/exec"
	"strings"
	"time"

	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
)

// Bounds for one child process.
const (
	DefaultRenderTimeout = 30 * time.Second
	maxRenderOutput      = 8 << 20
	maxDiagnostics       = 64 << 10
)

// ExecRenderer runs the client's render-bundle command once per bundle.
type ExecRenderer struct {
	Path    string
	Timeout time.Duration // per bundle; DefaultRenderTimeout when zero
}

// Render writes the bundle to the command's stdin and decodes its answer. The
// command runs with an empty environment: the transformers are pure, and CI
// secrets must never reach code built from another repository.
func (renderer ExecRenderer) Render(ctx context.Context, content contracts.ClientBundleContent) (RenderResult, error) {
	input, err := json.Marshal(content)
	if err != nil {
		return RenderResult{}, fmt.Errorf("%w: encode bundle: %v", ErrRenderer, err)
	}
	timeout := renderer.Timeout
	if timeout <= 0 {
		timeout = DefaultRenderTimeout
	}
	ctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	command := exec.CommandContext(ctx, renderer.Path)
	command.Env = []string{}
	command.Stdin = bytes.NewReader(input)
	stdout := &boundedBuffer{limit: maxRenderOutput}
	stderr := &boundedBuffer{limit: maxDiagnostics}
	command.Stdout, command.Stderr = stdout, stderr
	command.WaitDelay = time.Second
	if err := command.Run(); err != nil {
		if ctx.Err() != nil {
			return RenderResult{}, fmt.Errorf("%w: no answer within %s", ErrRenderer, timeout)
		}
		return RenderResult{}, fmt.Errorf("%w: %v: %s", ErrRenderer, err, firstLine(stderr.String()))
	}
	if stdout.overflow {
		return RenderResult{}, fmt.Errorf("%w: answer is larger than %d bytes", ErrRenderer, maxRenderOutput)
	}
	var result RenderResult
	decoder := json.NewDecoder(bytes.NewReader(stdout.Bytes()))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&result); err != nil {
		return RenderResult{}, fmt.Errorf("%w: answer is not a render result: %v", ErrRenderer, err)
	}
	if _, err := decoder.Token(); !errors.Is(err, io.EOF) {
		return RenderResult{}, fmt.Errorf("%w: answer has trailing data", ErrRenderer)
	}
	return result, nil
}

// boundedBuffer keeps at most limit bytes and records that more arrived, so a
// runaway child can neither exhaust memory nor block on a full pipe.
type boundedBuffer struct {
	bytes.Buffer
	limit    int
	overflow bool
}

func (buffer *boundedBuffer) Write(p []byte) (int, error) {
	room := buffer.limit - buffer.Len()
	if len(p) > room {
		buffer.overflow = true
		if room > 0 {
			buffer.Buffer.Write(p[:room])
		}
		return len(p), nil
	}
	return buffer.Buffer.Write(p)
}

func firstLine(text string) string {
	line, _, _ := strings.Cut(strings.TrimSpace(text), "\n")
	if len(line) > 300 {
		line = line[:300] + "…"
	}
	return line
}
```

### A.3 `internal/library/gate/secrets.go`
```go
package gate

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

// DefaultScanTimeout bounds one secret scan of the library.
const DefaultScanTimeout = 2 * time.Minute

// GitleaksScanner scans the library directory with the gitleaks binary and
// configuration the repository-wide CI scan uses. Inside the library, inline
// gitleaks:allow comments and .gitleaksignore files are not honoured, so
// shipped content cannot silence its own findings.
type GitleaksScanner struct {
	Path    string
	Config  string // .gitleaks.toml; gitleaks defaults when empty
	Timeout time.Duration
}

// gitleaksFinding holds only what the gate needs; the redacted secret and
// match are never decoded.
type gitleaksFinding struct {
	RuleID    string `json:"RuleID"`
	File      string `json:"File"`
	StartLine int    `json:"StartLine"`
}

// Scan runs gitleaks once over root and returns library-relative findings.
func (scanner GitleaksScanner) Scan(ctx context.Context, root string) ([]Finding, error) {
	// Resolve symlinked ancestors (macOS /var is /private/var) so gitleaks'
	// paths and the root agree and every finding stays attributed to its item.
	root, err := filepath.Abs(root)
	if err == nil {
		root, err = filepath.EvalSymlinks(root)
	}
	if err != nil {
		return nil, err
	}
	work, err := os.MkdirTemp("", "content-gate-gitleaks-")
	if err != nil {
		return nil, err
	}
	defer func() { _ = os.RemoveAll(work) }()
	reportPath := filepath.Join(work, "findings.json")
	noIgnores := filepath.Join(work, "no-ignores")
	if err := os.Mkdir(noIgnores, 0o700); err != nil {
		return nil, err
	}
	timeout := scanner.Timeout
	if timeout <= 0 {
		timeout = DefaultScanTimeout
	}
	ctx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	args := []string{
		"dir", "--no-banner", "--log-level", "error", "--redact", "--ignore-gitleaks-allow",
		"--gitleaks-ignore-path", noIgnores, "--exit-code", "0",
		"--report-format", "json", "--report-path", reportPath,
	}
	if scanner.Config != "" {
		args = append(args, "--config", scanner.Config)
	}
	args = append(args, root)
	command := exec.CommandContext(ctx, scanner.Path, args...)
	command.Env = []string{} // GITLEAKS_CONFIG and friends cannot swap the configuration
	output := &boundedBuffer{limit: maxDiagnostics}
	command.Stdout, command.Stderr = output, output
	command.WaitDelay = time.Second
	if err := command.Run(); err != nil {
		return nil, fmt.Errorf("gitleaks: %v: %s", err, firstLine(output.String()))
	}
	raw, err := os.ReadFile(reportPath)
	if err != nil {
		return nil, fmt.Errorf("gitleaks wrote no report: %v", err)
	}
	var leaks []gitleaksFinding
	if err := json.Unmarshal(raw, &leaks); err != nil {
		return nil, fmt.Errorf("gitleaks report is not JSON: %v", err)
	}
	return relativeFindings(root, leaks), nil
}

// relativeFindings turns gitleaks paths into library-relative slash paths. A
// path outside root is kept as reported, which makes it library-wide.
func relativeFindings(root string, leaks []gitleaksFinding) []Finding {
	findings := make([]Finding, 0, len(leaks))
	for _, leak := range leaks {
		file := filepath.ToSlash(leak.File)
		if rel, err := filepath.Rel(root, leak.File); err == nil && filepath.IsLocal(rel) {
			file = filepath.ToSlash(rel)
		}
		findings = append(findings, Finding{RuleID: leak.RuleID, File: file, Line: leak.StartLine})
	}
	sortFindings(findings)
	return findings
}
```

### A.4 `internal/library/gate/report.go`
```go
package gate

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// Report file names inside the report directory.
const (
	JSONReportFile     = "content-compatibility.json"
	MarkdownReportFile = "content-compatibility.md"
)

// WriteReport writes the JSON and Markdown forms of the report into dir.
func WriteReport(dir string, report Report) error {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	raw, err := json.MarshalIndent(report, "", "  ")
	if err != nil {
		return err
	}
	if err := os.WriteFile(filepath.Join(dir, JSONReportFile), append(raw, '\n'), 0o644); err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(dir, MarkdownReportFile), []byte(Markdown(report)), 0o644)
}

// Markdown renders the report with one table row per item and one column per tool.
func Markdown(report Report) string {
	var out strings.Builder
	out.WriteString("# Content compatibility report\n\n")
	fmt.Fprintf(&out, "Result: **%s** · library %s %s · control plane `%s` · client renderer `%s`\n\n",
		report.Result, cell(report.Library.Name), cell(report.Library.Version),
		cell(orDefault(report.Source.ControlPlane, "unknown")), cell(orDefault(report.Source.ClientRenderer, "unknown")))
	fmt.Fprintf(&out, "Schema: %s · library-wide secret scan: %s · %d items: %d passed, %d failed · %d renders skipped by a transformer\n\n",
		report.Schema.Status, report.Secrets.Status, report.Summary.Items, report.Summary.Passed, report.Summary.Failed, report.Summary.Skipped)

	out.WriteString("| Item | Secrets |")
	for _, tool := range Tools {
		fmt.Fprintf(&out, " %s |", tool)
	}
	out.WriteString("\n| --- | --- |" + strings.Repeat(" --- |", len(Tools)) + "\n")
	for _, item := range report.Items {
		fmt.Fprintf(&out, "| `%s` | %s |", cell(item.Key), item.Secrets.Status)
		for _, tool := range Tools {
			fmt.Fprintf(&out, " %s |", toolCell(item.Tools[tool]))
		}
		out.WriteString("\n")
	}

	out.WriteString("\n## Failures\n\n")
	if len(report.Failures) == 0 {
		out.WriteString("None.\n")
	}
	for _, failure := range report.Failures {
		fmt.Fprintf(&out, "- %s\n", cell(failure))
	}

	out.WriteString("\n## Skipped by a transformer\n\n")
	skipped := false
	for _, item := range report.Items {
		for _, tool := range Tools {
			if toolReport := item.Tools[tool]; toolReport.Status == StatusSkipped {
				skipped = true
				fmt.Fprintf(&out, "- `%s` [%s]: %s\n", cell(item.Key), tool, cell(strings.Join(toolReport.Warnings, "; ")))
			}
		}
	}
	if !skipped {
		out.WriteString("None.\n")
	}
	return out.String()
}

// Annotation is a GitHub Actions error annotation for one failure. The text
// is escaped, so library content can never start another workflow command.
func Annotation(failure string) string {
	return "::error title=Content quality gate::" + strings.NewReplacer("%", "%25", "\r", "%0D", "\n", "%0A").Replace(failure)
}

func toolCell(toolReport ToolReport) string {
	switch toolReport.Status {
	case StatusPass:
		noun := "files"
		if len(toolReport.Files) == 1 {
			noun = "file"
		}
		return fmt.Sprintf("pass (%d %s)", len(toolReport.Files), noun)
	case StatusNotDeclared:
		return "not declared"
	default:
		return string(toolReport.Status)
	}
}

// cell keeps text inside its Markdown table cell or list item.
func cell(text string) string {
	return strings.NewReplacer("|", `\|`, "`", "'", "<", "&lt;", ">", "&gt;", "\r", " ", "\n", " ").Replace(text)
}
```

### A.5 `internal/bundle/contract.go` (and the web edit)
```go
package bundle

import contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"

// Contract returns the OpenAPI ClientBundleContent document the desktop client
// receives for this content. The bundle content endpoint serves it and the
// content quality gate (internal/library/gate) hands the same document to the
// client's transformers, so both always use one wire shape.
func (content Content) Contract() contracts.ClientBundleContent {
	items := make([]contracts.BundleContentItem, 0, len(content.Items))
	for _, item := range content.Items {
		items = append(items, contracts.BundleContentItem{
			Path:        item.Path,
			Kind:        contracts.BundleContentItemKind(item.Kind),
			Name:        item.Name,
			Version:     item.Version,
			Description: item.Description,
			Body:        item.Body,
			Sha256:      item.SHA256,
		})
	}
	return contracts.ClientBundleContent{
		PackName:     content.PackName,
		PackVersion:  content.PackVersion,
		BundleDigest: content.Digest,
		Items:        items,
	}
}
```
`internal/web/client_bundle_content.go`: replace `writeClientJSON(w, http.StatusOK, toContractBundleContent(content))` with `writeClientJSON(w, http.StatusOK, content.Contract())`, delete `func toContractBundleContent` (lines 20–39 at `0da9f54`), and remove the `contracts` import if the compiler reports it unused.

### A.6 `internal/bundle/contract_test.go`
```go
package bundle

import (
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
)

func TestContractCarriesEveryContentField(t *testing.T) {
	content, err := ResolveContent(pack.PackVersion{Name: "Starter", Version: "2.0.0", Items: []pack.Item{
		{Kind: pack.KindSkill, Name: "review", Version: "1.0.0", Description: "Review a diff.", Body: "# Review\n"},
		{Kind: pack.KindMCPTemplate, Name: "github", Version: "2.0.0", Description: "GitHub MCP.", Body: `{"mcpServers":{}}`},
	}})
	if err != nil {
		t.Fatal(err)
	}
	got := content.Contract()
	if got.PackName != "Starter" || got.PackVersion != "2.0.0" || got.BundleDigest != content.Digest || len(got.Items) != 2 {
		t.Fatalf("contract = %+v", got)
	}
	for index, item := range content.Items {
		want := contracts.BundleContentItem{
			Path: item.Path, Kind: contracts.BundleContentItemKind(item.Kind), Name: item.Name, Version: item.Version,
			Description: item.Description, Body: item.Body, Sha256: item.SHA256,
		}
		if got.Items[index] != want {
			t.Fatalf("item %d = %+v, want %+v", index, got.Items[index], want)
		}
	}
}
```

### A.7 `internal/library/gate/client-renderer.ref`
One line: the full 40-character leorna-client commit SHA that contains `cmd/render-bundle` (T1 head locally; the pushed head in T13).

### A.8 leorna-client `cmd/render-bundle/main.go`
```go
// Command render-bundle renders one bundle with the desktop client's real
// transformers and prints what each tool would get. It reads the OpenAPI
// ClientBundleContent document that Sync downloads, on stdin, and turns it
// into the same Pack the Sync engine transforms. The control plane's content
// quality gate runs it in CI; no server code is imported, and nothing is
// written to disk.
package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"runtime/debug"
	"sort"
	"strings"

	"github.com/LeornaAI/leorna-client/api"
	tc "github.com/LeornaAI/leorna-client/toolconnector"
	"github.com/LeornaAI/leorna-client/toolconnector/claudecode"
	"github.com/LeornaAI/leorna-client/toolconnector/codex"
	"github.com/LeornaAI/leorna-client/toolconnector/cursor"
)

const (
	resultFormat = "leorna.render-result/v1"
	// maxInput matches the client's bound for bundle content responses
	// (login.bundleContentResponseLimitBytes).
	maxInput = 256 << 20
)

type renderedFile struct {
	Path   string `json:"path"`
	SHA256 string `json:"sha256"`
	Bytes  int    `json:"bytes"`
}

type toolResult struct {
	Tool     tc.ToolID      `json:"tool"`
	OK       bool           `json:"ok"`
	Files    []renderedFile `json:"files"`
	Warnings []string       `json:"warnings"`
	Error    string         `json:"error,omitempty"`
}

type result struct {
	Format   string       `json:"format"`
	Revision string       `json:"revision"`
	Modified bool         `json:"modified"`
	Tools    []toolResult `json:"tools"`
}

// transformers are the ones the Sync engine uses (application.NewSyncEngine),
// in a fixed order.
var transformers = []tc.ConfigTransformer{claudecode.Transformer{}, codex.Transformer{}, cursor.Transformer{}}

func main() {
	os.Exit(run(os.Stdin, os.Stdout, os.Stderr))
}

// run exits 0 whenever it could render, even if a transformer refused the
// pack: that refusal is the answer. Bad input exits 2.
func run(stdin io.Reader, stdout, stderr io.Writer) int {
	pack, err := decode(stdin)
	if err != nil {
		_, _ = fmt.Fprintln(stderr, "render-bundle:", err)
		return 2
	}
	out := result{Format: resultFormat, Tools: make([]toolResult, 0, len(transformers))}
	out.Revision, out.Modified = buildRevision()
	for _, transformer := range transformers {
		out.Tools = append(out.Tools, render(transformer, pack))
	}
	encoder := json.NewEncoder(stdout)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(out); err != nil {
		_, _ = fmt.Fprintln(stderr, "render-bundle:", err)
		return 1
	}
	return 0
}

// decode reads exactly one ClientBundleContent document and maps it to the
// Pack the Sync engine builds (application.verifiedPack): the same fields,
// each body checked against its hash and each path against its kind and name.
func decode(r io.Reader) (tc.Pack, error) {
	raw, err := io.ReadAll(io.LimitReader(r, maxInput+1))
	if err != nil {
		return tc.Pack{}, fmt.Errorf("cannot read input: %w", err)
	}
	if len(raw) > maxInput {
		return tc.Pack{}, errors.New("input is larger than 256 MiB")
	}
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.DisallowUnknownFields()
	var content api.ClientBundleContent
	if err := decoder.Decode(&content); err != nil {
		return tc.Pack{}, fmt.Errorf("input is not a bundle content document: %w", err)
	}
	if _, err := decoder.Token(); !errors.Is(err, io.EOF) {
		return tc.Pack{}, errors.New("input has trailing data")
	}
	pack := tc.Pack{Name: content.PackName, Version: content.PackVersion, Items: make([]tc.PackItem, 0, len(content.Items))}
	for index, item := range content.Items {
		sum := sha256.Sum256([]byte(item.Body))
		if hex.EncodeToString(sum[:]) != item.Sha256 {
			return tc.Pack{}, fmt.Errorf("item %d body does not match its sha256", index)
		}
		if item.Path != string(item.Kind)+"/"+strings.TrimSpace(item.Name) {
			return tc.Pack{}, fmt.Errorf("item %d path does not match its kind and name", index)
		}
		pack.Items = append(pack.Items, tc.PackItem{
			Kind: tc.PackKind(item.Kind), Name: item.Name, Version: item.Version,
			Description: item.Description, Body: item.Body,
		})
	}
	return pack, nil
}

// render runs one transformer. A panic is that tool's failure, not the run's.
func render(transformer tc.ConfigTransformer, pack tc.Pack) (out toolResult) {
	id := transformer.ID()
	out = toolResult{Tool: id, Files: []renderedFile{}, Warnings: []string{}}
	defer func() {
		if recovered := recover(); recovered != nil {
			out = toolResult{Tool: id, Files: []renderedFile{}, Warnings: []string{}, Error: fmt.Sprintf("transformer panicked: %v", recovered)}
		}
	}()
	bundle, err := transformer.Transform(pack)
	if err != nil {
		out.Error = err.Error()
		return out
	}
	if err := tc.ValidateBundleFor(id, bundle); err != nil {
		out.Error = err.Error()
		return out
	}
	for path, body := range bundle.Files {
		sum := sha256.Sum256(body)
		out.Files = append(out.Files, renderedFile{Path: path, SHA256: hex.EncodeToString(sum[:]), Bytes: len(body)})
	}
	sort.Slice(out.Files, func(i, j int) bool { return out.Files[i].Path < out.Files[j].Path })
	out.Warnings = append(out.Warnings, bundle.Warnings...)
	out.OK = true
	return out
}

// buildRevision reports the commit this binary was built from, when the
// build recorded one (go build -buildvcs=true in a git checkout).
func buildRevision() (string, bool) {
	info, ok := debug.ReadBuildInfo()
	if !ok {
		return "", false
	}
	revision, modified := "", false
	for _, setting := range info.Settings {
		switch setting.Key {
		case "vcs.revision":
			revision = setting.Value
		case "vcs.modified":
			modified = setting.Value == "true"
		}
	}
	return revision, modified
}
```

### A.9 leorna-client `cmd/render-bundle/main_test.go`
```go
package main

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-client/api"
	tc "github.com/LeornaAI/leorna-client/toolconnector"
	"github.com/LeornaAI/leorna-client/toolconnector/claudecode"
	"github.com/LeornaAI/leorna-client/toolconnector/codex"
	"github.com/LeornaAI/leorna-client/toolconnector/cursor"
)

func bundleItem(kind api.BundleContentItemKind, name, description, body string) api.BundleContentItem {
	sum := sha256.Sum256([]byte(body))
	return api.BundleContentItem{
		Path: string(kind) + "/" + name, Kind: kind, Name: name, Version: "1.0.0",
		Description: description, Body: body, Sha256: hex.EncodeToString(sum[:]),
	}
}

func bundleJSON(t *testing.T, items ...api.BundleContentItem) []byte {
	t.Helper()
	raw, err := json.Marshal(api.ClientBundleContent{PackName: "Gate", PackVersion: "1.0.0", BundleDigest: strings.Repeat("a", 64), Items: items})
	if err != nil {
		t.Fatal(err)
	}
	return raw
}

func renderJSON(t *testing.T, input []byte) result {
	t.Helper()
	var stdout, stderr bytes.Buffer
	if code := run(bytes.NewReader(input), &stdout, &stderr); code != 0 {
		t.Fatalf("exit %d: %s", code, stderr.String())
	}
	decoder := json.NewDecoder(&stdout)
	decoder.DisallowUnknownFields()
	var out result
	if err := decoder.Decode(&out); err != nil {
		t.Fatal(err)
	}
	if out.Format != resultFormat || len(out.Tools) != 3 {
		t.Fatalf("result = %+v", out)
	}
	return out
}

// The renderer reports exactly what the Sync engine's transformers produce:
// same tools, same files, same bytes.
func TestRenderBundleRendersAllThreeTools(t *testing.T) {
	item := bundleItem(api.BundleContentItemKindSkill, "code-review-checklist", "Review checklist: scope and tests.", "# Review\n\nCheck the scope.\n")
	out := renderJSON(t, bundleJSON(t, item))

	pack := tc.Pack{Name: "Gate", Version: "1.0.0", Items: []tc.PackItem{{
		Kind: tc.PackKindSkill, Name: item.Name, Version: item.Version, Description: item.Description, Body: item.Body,
	}}}
	wantPaths := []string{".claude/skills/code-review-checklist/SKILL.md", "skills/code-review-checklist/SKILL.md", "skills/code-review-checklist/SKILL.md"}
	for index, transformer := range []tc.ConfigTransformer{claudecode.Transformer{}, codex.Transformer{}, cursor.Transformer{}} {
		bundle, err := transformer.Transform(pack)
		if err != nil {
			t.Fatal(err)
		}
		got := out.Tools[index]
		if got.Tool != transformer.ID() || !got.OK || len(got.Files) != len(bundle.Files) || len(got.Files) != 1 || got.Files[0].Path != wantPaths[index] {
			t.Fatalf("tool %d = %+v, want %s writing %s", index, got, transformer.ID(), wantPaths[index])
		}
		sum := sha256.Sum256(bundle.Files[got.Files[0].Path])
		if got.Files[0].SHA256 != hex.EncodeToString(sum[:]) || got.Files[0].Bytes != len(bundle.Files[got.Files[0].Path]) {
			t.Fatalf("%s file hash does not match the transformer's own output", got.Tool)
		}
	}
}

// A transformer that refuses the pack is that tool's answer, not a crash.
func TestRenderBundleReportsAToolErrorWithoutFailing(t *testing.T) {
	out := renderJSON(t, bundleJSON(t, bundleItem(api.BundleContentItemKindMcpTemplate, "remote-only", "Remote MCP.", `{"mcpServers": {"remote-only": {"url": "https://mcp.example.invalid/mcp"}}}`)))
	claude, codexResult, cursorResult := out.Tools[0], out.Tools[1], out.Tools[2]
	if !claude.OK || claude.Files[0].Path != ".mcp.json" || !cursorResult.OK || cursorResult.Files[0].Path != "mcp.json" {
		t.Fatalf("claude %+v, cursor %+v", claude, cursorResult)
	}
	if codexResult.OK || len(codexResult.Files) != 0 || !strings.Contains(codexResult.Error, "which Codex cannot express") {
		t.Fatalf("codex = %+v", codexResult)
	}
}

func TestRenderBundleReportsTheAgentSkipAsAWarning(t *testing.T) {
	out := renderJSON(t, bundleJSON(t, bundleItem(api.BundleContentItemKindAgent, "reviewer", "Reviews diffs.", "Review the diff.\n")))
	for _, tool := range out.Tools {
		if !tool.OK || len(tool.Files) != 0 || len(tool.Warnings) != 1 || !strings.Contains(tool.Warnings[0], `agent "reviewer" is not installed for `+string(tool.Tool)) {
			t.Fatalf("%s = %+v", tool.Tool, tool)
		}
	}
}

// A kind this client build does not know fails per tool, so the gate names it.
// ("prompt" is not used here: story 86bcm9016 makes it a real kind.)
func TestRenderBundleReportsAnUnknownKindPerTool(t *testing.T) {
	out := renderJSON(t, bundleJSON(t, bundleItem(api.BundleContentItemKind("not-a-kind"), "review", "Not a kind.", "Review this.\n")))
	for _, tool := range out.Tools {
		if tool.OK || !strings.Contains(tool.Error, "unknown kind") {
			t.Fatalf("%s = %+v", tool.Tool, tool)
		}
	}
}

func TestRenderBundleRejectsBadInput(t *testing.T) {
	good := bundleItem(api.BundleContentItemKindSkill, "x", "X skill.", "Body.\n")
	tampered := good
	tampered.Body = "Changed.\n"
	misplaced := good
	misplaced.Path = "skill/y"
	for name, input := range map[string][]byte{
		"not json":        []byte("nope"),
		"unknown field":   []byte(`{"packName":"Gate","packVersion":"1.0.0","bundleDigest":"x","items":[],"extra":true}`),
		"trailing data":   append(bundleJSON(t, good), []byte(" {}")...),
		"body hash wrong": bundleJSON(t, tampered),
		"path wrong":      bundleJSON(t, misplaced),
	} {
		t.Run(name, func(t *testing.T) {
			var stdout, stderr bytes.Buffer
			if code := run(bytes.NewReader(input), &stdout, &stderr); code != 2 || stdout.Len() != 0 || !strings.HasPrefix(stderr.String(), "render-bundle:") {
				t.Fatalf("exit %d, stdout %q, stderr %q", code, stdout.String(), stderr.String())
			}
		})
	}
}

type panickingTransformer struct{}

func (panickingTransformer) ID() tc.ToolID { return "panicky" }

func (panickingTransformer) Transform(tc.Pack) (tc.ConfigBundle, error) { panic("boom") }

func TestRenderRecoversATransformerPanic(t *testing.T) {
	got := render(panickingTransformer{}, tc.Pack{})
	if got.OK || got.Tool != "panicky" || got.Error != "transformer panicked: boom" || got.Files == nil || got.Warnings == nil {
		t.Fatalf("render = %+v", got)
	}
}
```

### A.10 leorna-client `cmd/render-bundle/README.md`
```markdown
# render-bundle

Story 86bcm901u. Reads one OpenAPI `ClientBundleContent` document (the bundle
content Sync downloads) on stdin, runs the Sync engine's Claude Code, Codex and
Cursor transformers on it, and prints one `leorna.render-result/v1` JSON
answer: per tool `ok`, the files it would write (path, SHA-256, size), its
warnings and its error. It writes nothing to disk and runs with an empty
environment. Exit 0 when it rendered (a transformer refusing the pack is
`ok: false`, not an exit code); exit 2 for invalid input (not JSON, unknown
fields, trailing data, a body that does not match its SHA-256, or a path that
does not match its kind and name).

The control plane's content quality gate builds and runs it in CI:

    GOWORK=off go build -mod=vendor -buildvcs=true -o render-bundle ./cmd/render-bundle

`-buildvcs=true` records the commit, which the gate checks against its pin.

Tests: `TestRenderBundleRendersAllThreeTools` (files and hashes equal the
transformers' own output), `TestRenderBundleReportsAToolErrorWithoutFailing`,
`TestRenderBundleReportsTheAgentSkipAsAWarning`,
`TestRenderBundleReportsAnUnknownKindPerTool`, `TestRenderBundleRejectsBadInput`,
`TestRenderRecoversATransformerPanic`.
```

### A.11 `internal/library/gate/gate_test.go`
```go
package gate

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
)

const (
	skillBody = "# Checklist\n\nCheck the scope.\n"
	remoteMCP = `{"mcpServers": {"remote-only": {"url": "https://mcp.example.invalid/mcp"}}}`
)

type fixtureItem struct {
	kind, name string
	tools      []string
	body       string
}

func allTools() []string { return []string{"claude-code", "codex", "cursor"} }

// writeLibrary writes a minimal valid library source tree and returns its root.
func writeLibrary(t *testing.T, items ...fixtureItem) string {
	t.Helper()
	root := t.TempDir()
	write := func(name, content string) {
		t.Helper()
		full := filepath.Join(root, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(full, []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	write("library.json", `{"name": "Gate fixture", "version": "1.0.0"}`)
	for _, item := range items {
		tools, err := json.Marshal(item.tools)
		if err != nil {
			t.Fatal(err)
		}
		dir := "items/" + item.kind + "/" + item.name + "/"
		write(dir+"item.json", `{"version": "1.0.0", "category": "testing", "tags": ["fixture"], "tools": `+string(tools)+`, "description": "Fixture item `+item.name+`."}`)
		write(dir+"body.md", item.body)
		write(dir+"example.md", "Used only by the content gate tests.\n")
	}
	return root
}

// fakeRenderer answers per item path ("kind/name") and tool. A tool without
// an entry renders one file, so a test only describes what differs.
type fakeRenderer struct {
	answers  map[string]map[library.Tool]ToolRender
	revision string
	modified bool
	drop     library.Tool // when set, the answer leaves this tool out
	err      error
	calls    []contracts.ClientBundleContent
}

func (renderer *fakeRenderer) Render(_ context.Context, content contracts.ClientBundleContent) (RenderResult, error) {
	renderer.calls = append(renderer.calls, content)
	if renderer.err != nil {
		return RenderResult{}, renderer.err
	}
	result := RenderResult{Format: RenderFormat, Revision: renderer.revision, Modified: renderer.modified}
	itemPath := content.Items[0].Path
	for _, tool := range Tools {
		if tool == renderer.drop {
			continue
		}
		answer, ok := renderer.answers[itemPath][tool]
		if !ok {
			answer = ToolRender{OK: true, Files: []RenderedFile{{Path: string(tool) + "/" + itemPath, SHA256: strings.Repeat("a", 64), Bytes: 1}}, Warnings: []string{}}
		}
		answer.Tool = tool
		result.Tools = append(result.Tools, answer)
	}
	return result, nil
}

type fakeScanner struct {
	findings []Finding
	err      error
	roots    []string
}

func (scanner *fakeScanner) Scan(_ context.Context, root string) ([]Finding, error) {
	scanner.roots = append(scanner.roots, root)
	return scanner.findings, scanner.err
}

func runGate(t *testing.T, root string, renderer *fakeRenderer, scanner *fakeScanner) Report {
	t.Helper()
	report, err := Run(context.Background(), Options{LibraryDir: root, Renderer: renderer, Scanner: scanner, SourceRef: "test-source"})
	if err != nil {
		t.Fatalf("Run: %v", err)
	}
	return report
}

// AC1: every item is schema-validated, rendered for all three tools and scanned.
func TestRunRendersEveryItemForEveryTool(t *testing.T) {
	root := writeLibrary(t,
		fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody},
		fixtureItem{kind: "config", name: "codex-defaults", tools: []string{"codex"}, body: "model = \"x\"\n"},
	)
	renderer, scanner := &fakeRenderer{}, &fakeScanner{}
	report := runGate(t, root, renderer, scanner)

	if report.Result != StatusPass || report.Schema.Status != StatusPass || report.Secrets.Status != StatusPass {
		t.Fatalf("result %s, schema %s, secrets %s; failures %v", report.Result, report.Schema.Status, report.Secrets.Status, report.Failures)
	}
	if len(scanner.roots) != 1 || scanner.roots[0] != root {
		t.Fatalf("scanned %v, want one scan of %s", scanner.roots, root)
	}
	if len(renderer.calls) != 2 {
		t.Fatalf("rendered %d bundles, want one per item (2)", len(renderer.calls))
	}
	digest := regexp.MustCompile(`^[a-f0-9]{64}$`)
	for index, want := range []string{"config/codex-defaults", "skill/checklist"} {
		content := renderer.calls[index]
		if len(content.Items) != 1 || content.Items[0].Path != want {
			t.Fatalf("bundle %d = %+v, want only %s", index, content.Items, want)
		}
		sum := sha256.Sum256([]byte(content.Items[0].Body))
		if content.Items[0].Sha256 != hex.EncodeToString(sum[:]) || !digest.MatchString(content.BundleDigest) {
			t.Fatalf("bundle %d is not a served ClientBundleContent: %+v", index, content)
		}
	}
	for _, item := range report.Items {
		if len(item.Tools) != len(Tools) {
			t.Fatalf("%s has renders for %d tools, want %d", item.Key, len(item.Tools), len(Tools))
		}
	}
	codexDefaults := report.Items[0]
	if codexDefaults.Key != "config/codex-defaults@1.0.0" ||
		codexDefaults.Tools[library.ToolCodex].Status != StatusPass ||
		codexDefaults.Tools[library.ToolClaudeCode].Status != StatusNotDeclared {
		t.Fatalf("codex-defaults row = %+v", codexDefaults)
	}
}

// AC2: a render failure for a declared tool fails, naming the item and the tool.
func TestRunFailsNamingItemAndTool(t *testing.T) {
	root := writeLibrary(t,
		fixtureItem{kind: "mcp_template", name: "remote-only", tools: allTools(), body: remoteMCP},
		fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody},
	)
	renderer := &fakeRenderer{answers: map[string]map[library.Tool]ToolRender{
		"mcp_template/remote-only": {library.ToolCodex: {OK: false, Error: `MCP server "remote-only" is a remote server, which Codex cannot express`}},
	}}
	report := runGate(t, root, renderer, &fakeScanner{})

	want := `mcp_template/remote-only@1.0.0 [codex]: render failed: MCP server "remote-only" is a remote server, which Codex cannot express`
	if report.Result != StatusFail || len(report.Failures) != 1 || report.Failures[0] != want {
		t.Fatalf("result %s, failures %q; want fail with [%q]", report.Result, report.Failures, want)
	}
	broken, fine := report.Items[0], report.Items[1]
	if broken.Result != StatusFail || broken.Tools[library.ToolCodex].Status != StatusFail ||
		broken.Tools[library.ToolClaudeCode].Status != StatusPass || broken.Tools[library.ToolCursor].Status != StatusPass {
		t.Fatalf("broken row = %+v", broken)
	}
	if fine.Result != StatusPass {
		t.Fatalf("an unrelated item failed: %+v", fine)
	}
	if report.Summary != (Summary{Items: 2, Passed: 1, Failed: 1}) {
		t.Fatalf("summary = %+v", report.Summary)
	}
}

// AC2 boundary: an undeclared tool is rendered and reported but never fails.
func TestRunIgnoresRenderFailuresForUndeclaredTools(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "config", name: "claude-code-settings", tools: []string{"claude-code"}, body: `{"permissions": {}}`})
	renderer := &fakeRenderer{answers: map[string]map[library.Tool]ToolRender{
		"config/claude-code-settings": {
			library.ToolCodex:  {OK: false, Error: "not for codex"},
			library.ToolCursor: {OK: true, Files: []RenderedFile{}, Warnings: []string{}},
		},
	}}
	report := runGate(t, root, renderer, &fakeScanner{})

	if report.Result != StatusPass {
		t.Fatalf("result %s, failures %v", report.Result, report.Failures)
	}
	tools := report.Items[0].Tools
	if tools[library.ToolCodex].Status != StatusNotDeclared || tools[library.ToolCodex].Error != "not for codex" ||
		tools[library.ToolCursor].Status != StatusNotDeclared || report.Summary.NotDeclared != 2 {
		t.Fatalf("undeclared renders = %+v, summary %+v", tools, report.Summary)
	}
}

func TestRunFailsADeclaredToolThatProducesNothing(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "config", name: "codex-defaults", tools: []string{"codex", "cursor"}, body: "model = \"x\"\n"})
	renderer := &fakeRenderer{answers: map[string]map[library.Tool]ToolRender{
		"config/codex-defaults": {library.ToolCursor: {OK: true, Files: []RenderedFile{}, Warnings: []string{}}},
	}}
	report := runGate(t, root, renderer, &fakeScanner{})

	want := "config/codex-defaults@1.0.0 [cursor]: declared, but the transformer produced no files and gave no reason"
	if report.Result != StatusFail || len(report.Failures) != 1 || report.Failures[0] != want {
		t.Fatalf("failures %q, want [%q]", report.Failures, want)
	}
}

func TestRunReportsTransformerSkipsWithoutFailing(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "agent", name: "reviewer", tools: allTools(), body: "Review the diff.\n"})
	answers := map[library.Tool]ToolRender{}
	for _, tool := range Tools {
		answers[tool] = ToolRender{OK: true, Files: []RenderedFile{}, Warnings: []string{`agent "reviewer" is not installed for ` + string(tool) + "; skipped"}}
	}
	report := runGate(t, root, &fakeRenderer{answers: map[string]map[library.Tool]ToolRender{"agent/reviewer": answers}}, &fakeScanner{})

	if report.Result != StatusPass || report.Summary.Skipped != 3 {
		t.Fatalf("result %s, summary %+v, failures %v", report.Result, report.Summary, report.Failures)
	}
	codex := report.Items[0].Tools[library.ToolCodex]
	if codex.Status != StatusSkipped || codex.Reason != `skipped by the transformer: agent "reviewer" is not installed for codex; skipped` {
		t.Fatalf("codex = %+v", codex)
	}
}

// AC1 secret scan: a finding fails its own item and names it.
func TestRunFailsAnItemWithASecretFinding(t *testing.T) {
	root := writeLibrary(t,
		fixtureItem{kind: "skill", name: "leaky", tools: allTools(), body: skillBody},
		fixtureItem{kind: "skill", name: "clean", tools: allTools(), body: skillBody},
	)
	scanner := &fakeScanner{findings: []Finding{{RuleID: "github-pat", File: "items/skill/leaky/body.md", Line: 3}}}
	report := runGate(t, root, &fakeRenderer{}, scanner)

	want := "skill/leaky@1.0.0 [secret-scan]: github-pat found in items/skill/leaky/body.md:3"
	if report.Result != StatusFail || len(report.Failures) != 1 || report.Failures[0] != want {
		t.Fatalf("failures %q, want [%q]", report.Failures, want)
	}
	clean, leaky := report.Items[0], report.Items[1]
	if leaky.Secrets.Status != StatusFail || leaky.Result != StatusFail || clean.Secrets.Status != StatusPass || clean.Result != StatusPass {
		t.Fatalf("clean %+v, leaky %+v", clean, leaky)
	}
}

func TestRunFailsLibraryWideSecretFindings(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "clean", tools: allTools(), body: skillBody})
	scanner := &fakeScanner{findings: []Finding{
		{RuleID: "generic-api-key", File: "library.json", Line: 1},
		{RuleID: "generic-api-key", File: "items/skill/not-an-item/body.md", Line: 2},
	}}
	report := runGate(t, root, &fakeRenderer{}, scanner)

	if report.Result != StatusFail || report.Secrets.Status != StatusFail || len(report.Secrets.Findings) != 2 {
		t.Fatalf("secrets = %+v, result %s", report.Secrets, report.Result)
	}
}

// AC1 schema: an invalid item fails the gate before anything is rendered.
func TestRunFailsOnASchemaErrorWithoutRendering(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody})
	meta := filepath.Join(root, "items", "skill", "checklist", "item.json")
	invalid := `{"version": "1.0.0", "category": "testing", "tags": ["fixture"], "tools": ["claude-code"], "description": "x", "owner": "nobody"}`
	if err := os.WriteFile(meta, []byte(invalid), 0o644); err != nil {
		t.Fatal(err)
	}
	renderer := &fakeRenderer{}
	report := runGate(t, root, renderer, &fakeScanner{})

	if report.Result != StatusFail || report.Schema.Status != StatusFail || !strings.Contains(report.Schema.Error, "items/skill/checklist/item.json") {
		t.Fatalf("schema = %+v", report.Schema)
	}
	if len(renderer.calls) != 0 {
		t.Fatalf("rendered %d bundles from an invalid library", len(renderer.calls))
	}
}

func TestRunRejectsSymbolicLinks(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody})
	outside := filepath.Join(t.TempDir(), "outside.md")
	if err := os.WriteFile(outside, []byte(skillBody), 0o644); err != nil {
		t.Fatal(err)
	}
	body := filepath.Join(root, "items", "skill", "checklist", "body.md")
	if err := os.Remove(body); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(outside, body); err != nil {
		t.Fatal(err)
	}
	report := runGate(t, root, &fakeRenderer{}, &fakeScanner{})

	if report.Schema.Status != StatusFail || !strings.Contains(report.Schema.Error, "items/skill/checklist/body.md: symbolic links are not allowed") {
		t.Fatalf("schema = %+v", report.Schema)
	}
}

func TestRunRequiresThePinnedCleanRenderer(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody})
	pin := strings.Repeat("1", 40)
	for name, renderer := range map[string]*fakeRenderer{
		"another commit": {revision: strings.Repeat("2", 40)},
		"modified":       {revision: pin, modified: true},
		"no revision":    {},
	} {
		t.Run(name, func(t *testing.T) {
			_, err := Run(context.Background(), Options{LibraryDir: root, Renderer: renderer, Scanner: &fakeScanner{}, ClientRef: pin})
			if !errors.Is(err, ErrRendererNotPinned) || !strings.Contains(err.Error(), "skill/checklist@1.0.0") {
				t.Fatalf("err = %v, want ErrRendererNotPinned naming the item", err)
			}
		})
	}
	report, err := Run(context.Background(), Options{LibraryDir: root, Renderer: &fakeRenderer{revision: pin}, Scanner: &fakeScanner{}, ClientRef: pin})
	if err != nil || report.Source.ClientRenderer != pin {
		t.Fatalf("pinned renderer: err %v, client renderer %q", err, report.Source.ClientRenderer)
	}
}

func TestRunStopsWhenTheRendererOrScannerCannotRun(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "checklist", tools: allTools(), body: skillBody})

	_, err := Run(context.Background(), Options{LibraryDir: root, Renderer: &fakeRenderer{err: errors.New("exec: not found")}, Scanner: &fakeScanner{}})
	if err == nil || !strings.Contains(err.Error(), "render skill/checklist@1.0.0: exec: not found") {
		t.Fatalf("renderer error = %v", err)
	}
	_, err = Run(context.Background(), Options{LibraryDir: root, Renderer: &fakeRenderer{drop: library.ToolCursor}, Scanner: &fakeScanner{}})
	if !errors.Is(err, ErrRenderer) || !strings.Contains(err.Error(), "did not render for cursor") {
		t.Fatalf("missing tool = %v", err)
	}
	_, err = Run(context.Background(), Options{LibraryDir: root, Renderer: &fakeRenderer{}, Scanner: &fakeScanner{err: errors.New("no binary")}})
	if !errors.Is(err, ErrScanner) {
		t.Fatalf("scanner error = %v", err)
	}
	_, err = Run(context.Background(), Options{LibraryDir: filepath.Join(root, "missing"), Renderer: &fakeRenderer{}, Scanner: &fakeScanner{}})
	if err == nil {
		t.Fatal("a missing library directory must stop the gate")
	}
}
```

### A.12 `internal/library/gate/render_test.go`
```go
package gate

import (
	"context"
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
	"time"

	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
)

const okAnswer = `{"format":"leorna.render-result/v1","revision":"r","modified":false,"tools":[]}`

// script writes an executable /bin/sh fake. It runs with an empty
// environment, so it calls programs by absolute path.
func script(t *testing.T, body string) string {
	t.Helper()
	name := filepath.Join(t.TempDir(), "fake")
	if err := os.WriteFile(name, []byte("#!/bin/sh\n"+body), 0o755); err != nil {
		t.Fatal(err)
	}
	return name
}

func sampleContent() contracts.ClientBundleContent {
	return contracts.ClientBundleContent{
		PackName: "p", PackVersion: "1.0.0", BundleDigest: strings.Repeat("a", 64),
		Items: []contracts.BundleContentItem{{Path: "skill/x", Kind: contracts.BundleContentItemKindSkill, Name: "x", Version: "1.0.0", Description: "d", Body: "b", Sha256: "s"}},
	}
}

func TestExecRendererSendsTheBundleAndDecodesTheAnswer(t *testing.T) {
	received := filepath.Join(t.TempDir(), "stdin.json")
	renderer := ExecRenderer{Path: script(t, "/bin/cat > '"+received+"'\nprintf '%s' '"+okAnswer+"'\n")}
	result, err := renderer.Render(context.Background(), sampleContent())
	if err != nil || result.Format != RenderFormat || result.Revision != "r" {
		t.Fatalf("result %+v, err %v", result, err)
	}
	raw, err := os.ReadFile(received)
	if err != nil {
		t.Fatal(err)
	}
	var sent contracts.ClientBundleContent
	if err := json.Unmarshal(raw, &sent); err != nil || !reflect.DeepEqual(sent, sampleContent()) {
		t.Fatalf("renderer received %s (err %v)", raw, err)
	}
}

func TestExecRendererRunsWithAnEmptyEnvironment(t *testing.T) {
	t.Setenv("LEORNA_CLIENT_TOKEN", "must-not-reach-the-child")
	renderer := ExecRenderer{Path: script(t, "/bin/cat >/dev/null\nif [ -n \"$LEORNA_CLIENT_TOKEN\" ]; then echo leaked >&2; exit 3; fi\nprintf '%s' '"+okAnswer+"'\n")}
	if _, err := renderer.Render(context.Background(), sampleContent()); err != nil {
		t.Fatalf("the renderer saw the parent environment: %v", err)
	}
}

func TestExecRendererBoundsTheChild(t *testing.T) {
	cases := []struct {
		name, body, want string
		timeout          time.Duration
	}{
		{"exits non-zero", "/bin/cat >/dev/null\necho boom >&2\nexit 1\n", "boom", 0},
		{"too slow", "/bin/sleep 5\n", "no answer within", 200 * time.Millisecond},
		{"too large", "/bin/cat >/dev/null\n/usr/bin/head -c 9000000 /dev/zero\n", "larger than", 0},
		{"not json", "/bin/cat >/dev/null\necho nope\n", "not a render result", 0},
		{"unknown field", "/bin/cat >/dev/null\nprintf '%s' '{\"format\":\"x\",\"extra\":1}'\n", "not a render result", 0},
		{"trailing data", "/bin/cat >/dev/null\nprintf '%s%s' '" + okAnswer + "' '{}'\n", "trailing data", 0},
	}
	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			started := time.Now()
			_, err := ExecRenderer{Path: script(t, c.body), Timeout: c.timeout}.Render(context.Background(), sampleContent())
			if !errors.Is(err, ErrRenderer) || !strings.Contains(err.Error(), c.want) {
				t.Fatalf("err = %v, want ErrRenderer containing %q", err, c.want)
			}
			if elapsed := time.Since(started); elapsed > 3*time.Second {
				t.Fatalf("took %s; the timeout did not stop the child", elapsed)
			}
		})
	}
}
```

### A.13 `internal/library/gate/secrets_test.go`
```go
package gate

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"math/big"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

// repoGitleaksConfig is the configuration the repository-wide scan uses.
var repoGitleaksConfig = filepath.Join("..", "..", "..", ".gitleaks.toml")

// realBinary returns a real tool for the integration tests. CI sets the
// variable, so there a missing binary fails the test instead of skipping it.
func realBinary(t *testing.T, env string) string {
	t.Helper()
	name := os.Getenv(env)
	if name == "" {
		if os.Getenv("GITHUB_ACTIONS") == "true" {
			t.Fatalf("%s must be set in CI", env)
		}
		t.Skipf("set %s to run against the real binary", env)
	}
	return name
}

// randomToken builds a GitHub-token-shaped string at run time, so no
// secret-shaped literal is ever committed.
func randomToken(t *testing.T) string {
	t.Helper()
	const alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var out strings.Builder
	out.WriteString("gh" + "p_")
	for range 36 {
		index, err := rand.Int(rand.Reader, big.NewInt(int64(len(alphabet))))
		if err != nil {
			t.Fatal(err)
		}
		out.WriteByte(alphabet[index.Int64()])
	}
	return out.String()
}

func TestRelativeFindingsAreLibraryRelative(t *testing.T) {
	root := filepath.Join(string(filepath.Separator)+"work", "library")
	got := relativeFindings(root, []gitleaksFinding{
		{RuleID: "b", File: filepath.Join(root, "items", "skill", "x", "body.md"), StartLine: 2},
		{RuleID: "a", File: filepath.Join(root, "library.json"), StartLine: 1},
		{RuleID: "c", File: filepath.Join(string(filepath.Separator)+"elsewhere", "secret.txt"), StartLine: 9},
	})
	want := []Finding{
		{RuleID: "c", File: "/elsewhere/secret.txt", Line: 9},
		{RuleID: "b", File: "items/skill/x/body.md", Line: 2},
		{RuleID: "a", File: "library.json", Line: 1},
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("findings = %+v, want %+v", got, want)
	}
}

func TestGitleaksScannerFailsClosed(t *testing.T) {
	root := writeLibrary(t, fixtureItem{kind: "skill", name: "clean", tools: allTools(), body: skillBody})
	writeReport := func(content string) string {
		return "while [ $# -gt 0 ]; do if [ \"$1\" = \"--report-path\" ]; then printf '%s' '" + content + "' > \"$2\"; fi; shift; done\n"
	}
	for name, body := range map[string]string{
		"exits non-zero":  "echo 'config is broken' >&2\nexit 1\n",
		"writes nothing":  "exit 0\n",
		"writes not json": writeReport("nope"),
	} {
		t.Run(name, func(t *testing.T) {
			if _, err := (GitleaksScanner{Path: script(t, body)}).Scan(context.Background(), root); err == nil {
				t.Fatal("the scanner must fail when gitleaks does not produce a readable report")
			}
		})
	}
	findings, err := GitleaksScanner{Path: script(t, writeReport("[]"))}.Scan(context.Background(), root)
	if err != nil || len(findings) != 0 {
		t.Fatalf("empty report: findings %v, err %v", findings, err)
	}
}

// Real gitleaks: a secret in an item is found and attributed to that item,
// an inline gitleaks:allow cannot silence it, and the report never repeats it.
func TestGitleaksFindsASecretInAnItem(t *testing.T) {
	scanner := GitleaksScanner{Path: realBinary(t, "LEORNA_TEST_GITLEAKS_BIN"), Config: repoGitleaksConfig}
	token := randomToken(t)
	root := writeLibrary(t,
		fixtureItem{kind: "skill", name: "leaky", tools: allTools(), body: "# Leaky\n\nexport GITHUB_TOKEN=" + token + " # gitleaks:allow\n"},
		fixtureItem{kind: "skill", name: "clean", tools: allTools(), body: skillBody},
	)
	findings, err := scanner.Scan(context.Background(), root)
	if err != nil {
		t.Fatal(err)
	}
	if len(findings) == 0 {
		t.Fatal("gitleaks found nothing in a body holding a GitHub token")
	}
	for _, finding := range findings {
		if finding.File != "items/skill/leaky/body.md" {
			t.Errorf("finding outside the leaky item: %+v", finding)
		}
	}
	report, err := Run(context.Background(), Options{LibraryDir: root, Renderer: &fakeRenderer{}, Scanner: scanner})
	if err != nil {
		t.Fatal(err)
	}
	raw, err := json.Marshal(report)
	if err != nil {
		t.Fatal(err)
	}
	if report.Result != StatusFail || strings.Contains(string(raw), token) || strings.Contains(Markdown(report), token) {
		t.Fatalf("the report must fail without repeating the secret: %s", raw)
	}
}

func TestGitleaksFindsNothingInTheShippedLibrary(t *testing.T) {
	scanner := GitleaksScanner{Path: realBinary(t, "LEORNA_TEST_GITLEAKS_BIN"), Config: repoGitleaksConfig}
	findings, err := scanner.Scan(context.Background(), filepath.Join("..", "content"))
	if err != nil || len(findings) != 0 {
		t.Fatalf("shipped library: findings %+v, err %v", findings, err)
	}
}
```

### A.14 `internal/library/gate/report_test.go`
```go
package gate

import (
	"bytes"
	"encoding/json"
	"flag"
	"os"
	"path/filepath"
	"reflect"
	"sort"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
)

var updateGolden = flag.Bool("update", false, "rewrite testdata/golden from the current report writer")

// goldenReport has one passing, one skipped and one failing item.
func goldenReport() Report {
	file := func(name string) []RenderedFile {
		return []RenderedFile{{Path: name, SHA256: strings.Repeat("b", 64), Bytes: 42}}
	}
	pass := func(name string) ToolReport {
		return ToolReport{Status: StatusPass, Files: file(name), Warnings: []string{}}
	}
	skip := func(tool library.Tool) ToolReport {
		warning := `agent "reviewer" is not installed for ` + string(tool) + "; skipped"
		return ToolReport{Status: StatusSkipped, Reason: "skipped by the transformer: " + warning, Files: []RenderedFile{}, Warnings: []string{warning}}
	}
	codexFailure := `toolconnector: capability not supported by connector: MCP server "remote-only" in "remote-only" is a remote server, which Codex cannot express`
	return Report{
		Format:  ReportFormat,
		Result:  StatusFail,
		Library: LibraryInfo{Name: "Gate fixture", Version: "1.0.0"},
		Source:  SourceInfo{ControlPlane: strings.Repeat("c", 40), ClientRenderer: strings.Repeat("d", 40)},
		Schema:  Check{Status: StatusPass},
		Secrets: Check{Status: StatusPass},
		Items: []ItemReport{
			{
				Key: "agent/reviewer@1.0.0", Kind: "agent", Name: "reviewer", Version: "1.0.0",
				DeclaredTools: []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor},
				Schema:        StatusPass, Secrets: Check{Status: StatusPass}, Result: StatusPass,
				Tools: map[library.Tool]ToolReport{
					library.ToolClaudeCode: skip(library.ToolClaudeCode),
					library.ToolCodex:      skip(library.ToolCodex),
					library.ToolCursor:     skip(library.ToolCursor),
				},
			},
			{
				Key: "mcp_template/remote-only@1.0.0", Kind: "mcp_template", Name: "remote-only", Version: "1.0.0",
				DeclaredTools: []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor},
				Schema:        StatusPass, Secrets: Check{Status: StatusPass}, Result: StatusFail,
				Tools: map[library.Tool]ToolReport{
					library.ToolClaudeCode: pass(".mcp.json"),
					library.ToolCodex:      {Status: StatusFail, Reason: "render failed: " + codexFailure, Files: []RenderedFile{}, Warnings: []string{}, Error: codexFailure},
					library.ToolCursor:     pass("mcp.json"),
				},
			},
			{
				Key: "skill/checklist@1.0.0", Kind: "skill", Name: "checklist", Version: "1.0.0",
				DeclaredTools: []library.Tool{library.ToolClaudeCode},
				Schema:        StatusPass, Secrets: Check{Status: StatusPass}, Result: StatusPass,
				Tools: map[library.Tool]ToolReport{
					library.ToolClaudeCode: pass(".claude/skills/checklist/SKILL.md"),
					library.ToolCodex:      {Status: StatusNotDeclared, Files: file("skills/checklist/SKILL.md"), Warnings: []string{}},
					library.ToolCursor:     {Status: StatusNotDeclared, Files: file("skills/checklist/SKILL.md"), Warnings: []string{}},
				},
			},
		},
		Summary:  Summary{Items: 3, Passed: 2, Failed: 1, Skipped: 3, NotDeclared: 2},
		Failures: []string{"mcp_template/remote-only@1.0.0 [codex]: render failed: " + codexFailure},
	}
}

// AC3: the per-item compatibility report, pinned byte for byte.
func TestWriteReportMatchesGolden(t *testing.T) {
	dir := t.TempDir()
	if err := WriteReport(dir, goldenReport()); err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{JSONReportFile, MarkdownReportFile} {
		got, err := os.ReadFile(filepath.Join(dir, name))
		if err != nil {
			t.Fatal(err)
		}
		golden := filepath.Join("testdata", "golden", name)
		if *updateGolden {
			if err := os.MkdirAll(filepath.Dir(golden), 0o755); err != nil {
				t.Fatal(err)
			}
			if err := os.WriteFile(golden, got, 0o644); err != nil {
				t.Fatal(err)
			}
			continue
		}
		want, err := os.ReadFile(golden)
		if err != nil {
			t.Fatal(err)
		}
		if !bytes.Equal(got, want) {
			t.Errorf("%s differs from %s; run go test ./internal/library/gate -run TestWriteReportMatchesGolden -update and review the diff", name, golden)
		}
	}
}

// AC3: the JSON report has exactly the documented keys and one cell per tool.
func TestReportJSONHasOneCellPerItemAndTool(t *testing.T) {
	raw, err := json.Marshal(goldenReport())
	if err != nil {
		t.Fatal(err)
	}
	var document map[string]json.RawMessage
	if err := json.Unmarshal(raw, &document); err != nil {
		t.Fatal(err)
	}
	if got, want := keys(document), []string{"failures", "format", "items", "library", "result", "schema", "secrets", "source", "summary"}; !reflect.DeepEqual(got, want) {
		t.Fatalf("report keys = %v, want %v", got, want)
	}
	var items []struct {
		Key   string                     `json:"key"`
		Tools map[string]json.RawMessage `json:"tools"`
	}
	if err := json.Unmarshal(document["items"], &items); err != nil {
		t.Fatal(err)
	}
	for _, item := range items {
		if got := keys(item.Tools); !reflect.DeepEqual(got, []string{"claude-code", "codex", "cursor"}) {
			t.Fatalf("%s tools = %v", item.Key, got)
		}
	}
}

func TestMarkdownKeepsContentInsideCells(t *testing.T) {
	report := goldenReport()
	report.Failures = []string{"skill/x@1.0.0 [codex]: render failed: a|b\n<script>"}
	markdown := Markdown(report)
	if !strings.Contains(markdown, `- skill/x@1.0.0 [codex]: render failed: a\|b &lt;script&gt;`+"\n") {
		t.Fatalf("failure line was not escaped:\n%s", markdown)
	}
}

func TestAnnotationEscapesWorkflowCommands(t *testing.T) {
	got := Annotation("skill/x@1.0.0 [codex]: bad\n::warning::injected 100%")
	want := "::error title=Content quality gate::skill/x@1.0.0 [codex]: bad%0A::warning::injected 100%25"
	if got != want {
		t.Fatalf("annotation = %q, want %q", got, want)
	}
}

func keys[V any](values map[string]V) []string {
	out := make([]string, 0, len(values))
	for key := range values {
		out = append(out, key)
	}
	sort.Strings(out)
	return out
}
```

### A.15 `internal/library/gate/testdata/broken-library/`
`library.json`
```json
{
  "name": "Content gate broken fixture",
  "version": "1.0.0"
}
```
`items/mcp_template/remote-only/item.json`
```json
{
  "version": "1.0.0",
  "category": "integrations",
  "tags": ["mcp", "fixture"],
  "tools": ["claude-code", "codex", "cursor"],
  "description": "Deliberately broken fixture: a remote MCP server, which the Codex transformer cannot express."
}
```
`items/mcp_template/remote-only/body.md`
```json
{
  "mcpServers": {
    "remote-only": {
      "url": "https://mcp.example.invalid/mcp"
    }
  }
}
```
`items/mcp_template/remote-only/example.md` and `items/skill/fine/example.md`
```text
Fixture for the content quality gate tests. Never shipped.
```
`items/skill/fine/item.json`
```json
{
  "version": "1.0.0",
  "category": "testing",
  "tags": ["fixture"],
  "tools": ["claude-code", "codex", "cursor"],
  "description": "Valid fixture skill that must keep passing beside the broken item."
}
```
`items/skill/fine/body.md`
```markdown
# Fine

A valid skill body.
```

### A.16 `internal/library/gate/integration_test.go`
```go
package gate

import (
	"context"
	"path/filepath"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
)

// realGate wires the real client renderer and the real gitleaks. CI sets both
// LEORNA_TEST_* variables, so these tests always run there.
func realGate(t *testing.T) (ExecRenderer, GitleaksScanner) {
	t.Helper()
	return ExecRenderer{Path: realBinary(t, "LEORNA_TEST_RENDER_BUNDLE_BIN")},
		GitleaksScanner{Path: realBinary(t, "LEORNA_TEST_GITLEAKS_BIN"), Config: repoGitleaksConfig}
}

// AC1 + AC3 with the client's real transformers: the shipped library passes,
// and the native paths prove the renders are the real tool layouts.
func TestQualityGatePassesTheShippedLibraryWithRealTransformers(t *testing.T) {
	renderer, scanner := realGate(t)
	report, err := Run(context.Background(), Options{LibraryDir: filepath.Join("..", "content"), Renderer: renderer, Scanner: scanner})
	if err != nil {
		t.Fatal(err)
	}
	if report.Result != StatusPass {
		t.Fatalf("the shipped library failed the gate: %v", report.Failures)
	}
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	if len(report.Items) != len(shipped.Items) {
		t.Fatalf("report has %d items, the embedded library %d", len(report.Items), len(shipped.Items))
	}
	nativePaths := map[string]map[library.Tool]string{
		"config/claude-code-settings": {library.ToolClaudeCode: ".claude/settings.json"},
		"config/codex-defaults":       {library.ToolCodex: "config.toml"},
		"mcp_template/github-mcp":     {library.ToolClaudeCode: ".mcp.json", library.ToolCodex: "config.toml", library.ToolCursor: "mcp.json"},
	}
	for _, item := range report.Items {
		want := nativePaths[item.Kind+"/"+item.Name]
		if item.Kind == "skill" {
			want = map[library.Tool]string{
				library.ToolClaudeCode: ".claude/skills/" + item.Name + "/SKILL.md",
				library.ToolCodex:      "skills/" + item.Name + "/SKILL.md",
				library.ToolCursor:     "skills/" + item.Name + "/SKILL.md",
			}
		}
		for tool, path := range want {
			got := item.Tools[tool]
			if got.Status != StatusPass || len(got.Files) != 1 || got.Files[0].Path != path {
				t.Errorf("%s [%s] = %+v, want a pass writing %s", item.Key, tool, got, path)
			}
		}
		if item.Kind == "agent" {
			for _, tool := range Tools {
				if got := item.Tools[tool]; got.Status != StatusSkipped || !strings.Contains(got.Reason, "is not installed for "+string(tool)) {
					t.Errorf("%s [%s] = %+v, want skipped with the transformer's reason", item.Key, tool, got)
				}
			}
		}
	}
}

// AC2 with the client's real transformers: the deliberately broken fixture
// fails for Codex only, and the failure names the item and the tool.
func TestQualityGateFailsABrokenItemWithRealTransformers(t *testing.T) {
	renderer, scanner := realGate(t)
	report, err := Run(context.Background(), Options{LibraryDir: filepath.Join("testdata", "broken-library"), Renderer: renderer, Scanner: scanner})
	if err != nil {
		t.Fatal(err)
	}
	if report.Result != StatusFail || len(report.Failures) != 1 {
		t.Fatalf("result %s, failures %q; want exactly one failure", report.Result, report.Failures)
	}
	failure := report.Failures[0]
	if !strings.HasPrefix(failure, "mcp_template/remote-only@1.0.0 [codex]: render failed: ") || !strings.Contains(failure, "which Codex cannot express") {
		t.Fatalf("failure = %q", failure)
	}
	for _, item := range report.Items {
		if item.Key == "skill/fine@1.0.0" && item.Result != StatusPass {
			t.Fatalf("the valid fixture item failed: %+v", item)
		}
	}
}
```

### A.17 `cmd/content-gate/main.go`
```go
// Command content-gate runs the content quality gate (story 86bcm901u) over a
// library source directory and writes the per-item compatibility report.
//
// Exit codes: 0 every item passed; 1 a content check failed (each failure is
// printed with its item and tool); 2 the gate could not run.
package main

import (
	"context"
	"flag"
	"fmt"
	"io"
	"os"
	"os/signal"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
)

var commitPattern = regexp.MustCompile(`^[0-9a-f]{40}$`)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	code := run(ctx, os.Args[1:], os.Stdout, os.Stderr, os.Getenv)
	stop()
	os.Exit(code)
}

func run(ctx context.Context, args []string, stdout, stderr io.Writer, getenv func(string) string) int {
	flags := flag.NewFlagSet("content-gate", flag.ContinueOnError)
	flags.SetOutput(stderr)
	libraryDir := flags.String("library", "internal/library/content", "library source directory")
	renderer := flags.String("renderer", "", "path to the client's render-bundle binary (required)")
	gitleaks := flags.String("gitleaks", "", "path to the gitleaks binary (required)")
	gitleaksConfig := flags.String("gitleaks-config", ".gitleaks.toml", "gitleaks configuration; the file the repository scan uses")
	reportDir := flags.String("report-dir", "", "directory for content-compatibility.json and .md (required)")
	sourceRef := flags.String("source-ref", "", "control-plane commit recorded in the report")
	clientRefFile := flags.String("client-ref-file", "", "file holding the client commit the renderer must be built from")
	timeout := flags.Duration("timeout", gate.DefaultRenderTimeout, "time limit for rendering one item")
	if err := flags.Parse(args); err != nil {
		return 2
	}
	if *renderer == "" || *gitleaks == "" || *reportDir == "" || flags.NArg() != 0 {
		_, _ = fmt.Fprintln(stderr, "content-gate: -renderer, -gitleaks and -report-dir are required")
		flags.Usage()
		return 2
	}
	clientRef := ""
	if *clientRefFile != "" {
		raw, err := os.ReadFile(*clientRefFile)
		clientRef = strings.TrimSpace(string(raw))
		if err != nil || !commitPattern.MatchString(clientRef) {
			_, _ = fmt.Fprintf(stderr, "content-gate: %s must hold one 40-character commit SHA\n", *clientRefFile)
			return 2
		}
	}
	inActions := getenv("GITHUB_ACTIONS") == "true"

	report, err := gate.Run(ctx, gate.Options{
		LibraryDir: *libraryDir,
		Renderer:   gate.ExecRenderer{Path: *renderer, Timeout: *timeout},
		Scanner:    gate.GitleaksScanner{Path: *gitleaks, Config: *gitleaksConfig},
		SourceRef:  *sourceRef,
		ClientRef:  clientRef,
	})
	if err != nil {
		_, _ = fmt.Fprintln(stderr, "content-gate:", err)
		if inActions {
			_, _ = fmt.Fprintln(stdout, gate.Annotation(err.Error()))
		}
		return 2
	}
	if err := gate.WriteReport(*reportDir, report); err != nil {
		_, _ = fmt.Fprintln(stderr, "content-gate: write report:", err)
		return 2
	}
	if summary := getenv("GITHUB_STEP_SUMMARY"); summary != "" {
		if err := appendFile(summary, gate.Markdown(report)); err != nil {
			_, _ = fmt.Fprintln(stderr, "content-gate: write step summary:", err)
			return 2
		}
	}

	markdown := filepath.Join(*reportDir, gate.MarkdownReportFile)
	if report.Result != gate.StatusPass {
		for _, failure := range report.Failures {
			_, _ = fmt.Fprintln(stderr, "content gate: FAIL", failure)
			if inActions {
				_, _ = fmt.Fprintln(stdout, gate.Annotation(failure))
			}
		}
		_, _ = fmt.Fprintf(stdout, "content gate: FAIL (%d of %d items failed); report: %s\n", report.Summary.Failed, report.Summary.Items, markdown)
		return 1
	}
	_, _ = fmt.Fprintf(stdout, "content gate: PASS (%d items rendered for %d tools, %d renders skipped by a transformer); report: %s\n",
		report.Summary.Items, len(gate.Tools), report.Summary.Skipped, markdown)
	return 0
}

func appendFile(name, text string) error {
	file, err := os.OpenFile(name, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0o644)
	if err != nil {
		return err
	}
	if _, err := io.WriteString(file, text); err != nil {
		_ = file.Close()
		return err
	}
	return file.Close()
}
```

### A.18 `cmd/content-gate/main_test.go`
```go
package main

import (
	"bytes"
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

var shippedLibrary = filepath.Join("..", "..", "internal", "library", "content")

func fakeExecutable(t *testing.T, body string) string {
	t.Helper()
	name := filepath.Join(t.TempDir(), "fake")
	if err := os.WriteFile(name, []byte("#!/bin/sh\n"+body), 0o755); err != nil {
		t.Fatal(err)
	}
	return name
}

// fakeTools returns a renderer that answers every item with one file per tool
// (Codex failing when codexFails) and a gitleaks that reports no findings.
func fakeTools(t *testing.T, codexFails bool) (renderer, gitleaks string) {
	t.Helper()
	codex := `{"tool":"codex","ok":true,"files":[{"path":"c","sha256":"s","bytes":1}],"warnings":[]}`
	if codexFails {
		codex = `{"tool":"codex","ok":false,"files":[],"warnings":[],"error":"codex refused it"}`
	}
	answer := `{"format":"leorna.render-result/v1","revision":"","modified":false,"tools":[` +
		`{"tool":"claude-code","ok":true,"files":[{"path":"a","sha256":"s","bytes":1}],"warnings":[]},` + codex + `,` +
		`{"tool":"cursor","ok":true,"files":[{"path":"b","sha256":"s","bytes":1}],"warnings":[]}]}`
	renderer = fakeExecutable(t, "/bin/cat >/dev/null\nprintf '%s' '"+answer+"'\n")
	gitleaks = fakeExecutable(t, "while [ $# -gt 0 ]; do if [ \"$1\" = \"--report-path\" ]; then printf '[]' > \"$2\"; fi; shift; done\n")
	return renderer, gitleaks
}

func environment(values map[string]string) func(string) string {
	return func(key string) string { return values[key] }
}

func TestRunPassesAndWritesTheReport(t *testing.T) {
	renderer, gitleaks := fakeTools(t, false)
	reportDir := t.TempDir()
	summary := filepath.Join(t.TempDir(), "summary.md")
	var stdout, stderr bytes.Buffer
	code := run(context.Background(), []string{
		"-library", shippedLibrary, "-renderer", renderer, "-gitleaks", gitleaks, "-gitleaks-config", "",
		"-report-dir", reportDir, "-source-ref", strings.Repeat("e", 40),
	}, &stdout, &stderr, environment(map[string]string{"GITHUB_STEP_SUMMARY": summary}))

	if code != 0 || !strings.Contains(stdout.String(), "content gate: PASS") {
		t.Fatalf("exit %d\nstdout %s\nstderr %s", code, stdout.String(), stderr.String())
	}
	for _, name := range []string{"content-compatibility.json", "content-compatibility.md"} {
		if _, err := os.Stat(filepath.Join(reportDir, name)); err != nil {
			t.Fatalf("report %s: %v", name, err)
		}
	}
	written, err := os.ReadFile(summary)
	if err != nil || !strings.Contains(string(written), "# Content compatibility report") {
		t.Fatalf("step summary = %q, err %v", written, err)
	}
}

// AC2 at the CLI: exit 1, every failure printed with item and tool, and a
// GitHub annotation in Actions.
func TestRunFailsNamingItemAndTool(t *testing.T) {
	renderer, gitleaks := fakeTools(t, true)
	var stdout, stderr bytes.Buffer
	code := run(context.Background(), []string{
		"-library", shippedLibrary, "-renderer", renderer, "-gitleaks", gitleaks, "-gitleaks-config", "", "-report-dir", t.TempDir(),
	}, &stdout, &stderr, environment(map[string]string{"GITHUB_ACTIONS": "true"}))

	if code != 1 {
		t.Fatalf("exit %d, want 1\nstdout %s\nstderr %s", code, stdout.String(), stderr.String())
	}
	if !strings.Contains(stderr.String(), "content gate: FAIL skill/code-review-checklist@1.0.0 [codex]: render failed: codex refused it") {
		t.Fatalf("stderr does not name the item and tool:\n%s", stderr.String())
	}
	if !strings.Contains(stdout.String(), "::error title=Content quality gate::skill/code-review-checklist@1.0.0 [codex]: render failed: codex refused it") {
		t.Fatalf("stdout has no annotation:\n%s", stdout.String())
	}
}

func TestRunRejectsMissingFlagsAndBadPins(t *testing.T) {
	renderer, gitleaks := fakeTools(t, false)
	badPin := filepath.Join(t.TempDir(), "client-renderer.ref")
	if err := os.WriteFile(badPin, []byte("main\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	for name, args := range map[string][]string{
		"no flags": {},
		"bad pin":  {"-renderer", renderer, "-gitleaks", gitleaks, "-report-dir", t.TempDir(), "-client-ref-file", badPin},
	} {
		t.Run(name, func(t *testing.T) {
			var stdout, stderr bytes.Buffer
			if code := run(context.Background(), args, &stdout, &stderr, environment(nil)); code != 2 {
				t.Fatalf("exit %d, want 2\nstderr %s", code, stderr.String())
			}
		})
	}
}
```

### A.19 `scripts/build-client-renderer.sh`
```bash
#!/usr/bin/env bash
# Story 86bcm901u: build the desktop client's render-bundle command at the
# pinned commit, so the content quality gate renders library items with the
# client's real transformers. The client repository is fetched read-only with a
# short-lived token and built outside this workspace; no client Go code is
# imported here (scripts/verify-workspace.sh still enforces that).
set -euo pipefail

if (( $# != 2 )); then
  printf 'usage: %s CLIENT_DIR OUTPUT_BINARY\n' "$0" >&2
  exit 2
fi

readonly repo_root="$(git rev-parse --show-toplevel)"
readonly pin_file="${repo_root}/internal/library/gate/client-renderer.ref"
readonly client_dir="$1"
readonly output="$2"

pin="$(tr -d '[:space:]' < "${pin_file}")"
if [[ ! "${pin}" =~ ^[0-9a-f]{40}$ ]]; then
  printf '%s must hold one 40-character commit SHA\n' "${pin_file}" >&2
  exit 1
fi
if [[ -e "${client_dir}" ]]; then
  printf '%s already exists\n' "${client_dir}" >&2
  exit 1
fi
parent="$(cd "$(dirname "${client_dir}")" && pwd -P)"
case "${parent}/" in
  "${repo_root}"/*)
    printf 'fetch the client outside this repository, not %s\n' "${client_dir}" >&2
    exit 1
    ;;
esac
if [[ -z "${LEORNA_CLIENT_TOKEN:-}" ]]; then
  printf 'LEORNA_CLIENT_TOKEN is empty: the read-only leorna-client credential is not configured (internal/library/README.md, "Content quality gate")\n' >&2
  exit 1
fi

auth="$(printf 'x-access-token:%s' "${LEORNA_CLIENT_TOKEN}" | base64 | tr -d '\n')"
unset LEORNA_CLIENT_TOKEN
if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  printf '::add-mask::%s\n' "${auth}"
fi

git init --quiet "${client_dir}"
# The credential travels only in environment-scoped git config: never in argv,
# never in .git/config, and it is gone before any client file is built.
GIT_CONFIG_COUNT=1 \
  GIT_CONFIG_KEY_0="http.https://github.com/.extraheader" \
  GIT_CONFIG_VALUE_0="AUTHORIZATION: basic ${auth}" \
  git -C "${client_dir}" fetch --quiet --depth=1 --no-tags \
  https://github.com/LeornaAI/leorna-client.git "${pin}"
unset auth
git -C "${client_dir}" -c advice.detachedHead=false checkout --quiet --detach FETCH_HEAD
actual="$(git -C "${client_dir}" rev-parse HEAD)"
if [[ "${actual}" != "${pin}" ]]; then
  printf 'fetched %s, expected the pinned %s\n' "${actual}" "${pin}" >&2
  exit 1
fi

(
  cd "${client_dir}"
  GOWORK=off GOFLAGS=-mod=vendor CGO_ENABLED=1 \
    go build -buildvcs=true -trimpath -o "${output}" ./cmd/render-bundle
)
printf 'client renderer built from leorna-client %s\n' "${pin}"
```

### A.20 `Makefile`
Add `content-gate` to `.PHONY` (after `build`) and insert after the `build:` target (recipe lines start with a tab):
```make
# Story 86bcm901u: run the content quality gate locally. Build the client's
# render-bundle first (internal/library/README.md, "Content quality gate").
content-gate:
	@test -n "$(RENDER_BUNDLE)" || (echo "RENDER_BUNDLE=<path to the client render-bundle binary> is required" >&2; exit 2)
	$(GO) run ./cmd/content-gate -renderer "$(RENDER_BUNDLE)" -gitleaks "$$(command -v $(GITLEAKS))" -report-dir "$(or $(CONTENT_REPORT_DIR),$(CURDIR)/out/content-report)" -source-ref "$$(git rev-parse HEAD)"
```

### A.21 `.github/workflows/ci.yml` (story exception; complete inserted hunks)
Insert immediately after the "Verify story delivery gate" step:
```yaml
      # Story 86bcm901u: content quality gate. Every library item is
      # schema-validated, rendered with the desktop client's real Claude Code,
      # Codex and Cursor transformers, and secret-scanned. The client is fetched
      # read-only at internal/library/gate/client-renderer.ref and built outside
      # the workspace; no client Go code is imported into this repository.
      - name: Mint read-only leorna-client token
        id: client_token
        uses: actions/create-github-app-token@64ab729a6294000f5aa4a4bc0b73d1f32bc45510 # v3.3.0
        with:
          client-id: ${{ vars.LEORNA_CLIENT_READER_CLIENT_ID }}
          private-key: ${{ secrets.LEORNA_CLIENT_READER_PRIVATE_KEY }}
          owner: LeornaAI
          repositories: leorna-client
          permission-contents: read

      - name: Build pinned client renderer
        env:
          LEORNA_CLIENT_TOKEN: ${{ steps.client_token.outputs.token }}
        run: bash ./scripts/build-client-renderer.sh "${RUNNER_TEMP}/leorna-client" "${RUNNER_TEMP}/render-bundle"

      - name: Content quality gate
        id: content_gate
        run: >-
          go run ./cmd/content-gate
          -library internal/library/content
          -renderer "${RUNNER_TEMP}/render-bundle"
          -gitleaks "${RUNNER_TEMP}/gitleaks"
          -gitleaks-config .gitleaks.toml
          -client-ref-file internal/library/gate/client-renderer.ref
          -source-ref "$(git rev-parse HEAD)"
          -report-dir "${RUNNER_TEMP}/content-report"

      - name: Upload content compatibility report
        if: ${{ !cancelled() && (steps.content_gate.outcome == 'success' || steps.content_gate.outcome == 'failure') }}
        uses: actions/upload-artifact@cf430e030ddbb5b0abf93d22962f4752f3646cd9 # v7.0.2
        with:
          name: content-compatibility-${{ github.sha }}
          path: ${{ runner.temp }}/content-report/
          if-no-files-found: warn
          retention-days: 30
```
Replace the "Test with the race detector" step with:
```yaml
      - name: Test with the race detector
        env:
          LEORNA_TEST_RENDER_BUNDLE_BIN: ${{ runner.temp }}/render-bundle
          LEORNA_TEST_GITLEAKS_BIN: ${{ runner.temp }}/gitleaks
        run: make test
```
Q1-B variant: delete the "Mint read-only leorna-client token" step and set `LEORNA_CLIENT_TOKEN: ${{ secrets.LEORNA_CLIENT_READ_TOKEN }}` on "Build pinned client renderer". Q1-C variant needs an SSH fetch instead (pin GitHub's ed25519 host key `github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl`, fingerprint `SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU`, read from `gh api meta` and checked with `ssh-keygen -lf` on 2026-10-22); ask the planner/dispatcher for that variant rather than improvising it.

### A.22 `internal/library/README.md` — new section (append)
```markdown
## Content quality gate

Story 86bcm901u. CI's required **Go quality gates** job runs `cmd/content-gate`
on every pull request, push to `main` and manual run. For every item it:

1. validates the source with the loader's strict parser (`library.Parse`);
2. renders the item with the desktop client's real Claude Code, Codex and
   Cursor transformers;
3. scans `library.json`, `item.json`, `body.md` and `example.md` with the same
   gitleaks binary and `.gitleaks.toml` as the repository scan. Inside the
   library, `gitleaks:allow` comments and `.gitleaksignore` are not honoured.

The transformers live in leorna-client and are not imported. CI fetches the
client read-only at the commit in `gate/client-renderer.ref`, builds its
`cmd/render-bundle` outside this workspace and gives it each item as the
OpenAPI `ClientBundleContent` document the desktop downloads during Sync
(`bundle.Content.Contract()`). Symbolic links in the library are rejected.

| Status | Meaning | Fails the gate |
| --- | --- | --- |
| `pass` | the transformer wrote files | no |
| `skipped` | a declared tool's transformer skipped the item and said why (agents today) | no |
| `not-declared` | the tool is not in the item's `tools`; rendered for the report only | no |
| `fail` | a declared tool's transformer returned an error, or wrote nothing without a reason; or a secret was found | yes |

A failure prints `<kind>/<name>@<version> [<tool>]: <reason>` (or
`[secret-scan]`) plus a GitHub error annotation and exits 1; exit 2 means the
gate itself could not run. Every run writes `content-compatibility.json` and
`content-compatibility.md`, uploads them as the `content-compatibility-<sha>`
artifact and adds the table to the job summary.

Run it locally (needs gitleaks and a leorna-client checkout):

    (cd ../leorna-client && GOWORK=off go build -mod=vendor -buildvcs=true -o "$TMPDIR/render-bundle" ./cmd/render-bundle)
    make content-gate RENDER_BUNDLE="$TMPDIR/render-bundle"

To render with newer transformers, put the new leorna-client commit (full SHA,
reachable from its `main`) in `gate/client-renderer.ref`; no workflow edit is
needed. CI reads the client with a read-only credential: repository variable
`LEORNA_CLIENT_READER_CLIENT_ID` and secret `LEORNA_CLIENT_READER_PRIVATE_KEY`
(a GitHub App with contents:read on leorna-client only).

Verification: `TestRunRendersEveryItemForEveryTool`,
`TestRunFailsNamingItemAndTool`, `TestRunIgnoresRenderFailuresForUndeclaredTools`,
`TestRunFailsADeclaredToolThatProducesNothing`,
`TestRunReportsTransformerSkipsWithoutFailing`, `TestRunFailsAnItemWithASecretFinding`,
`TestRunFailsLibraryWideSecretFindings`, `TestRunFailsOnASchemaErrorWithoutRendering`,
`TestRunRejectsSymbolicLinks`, `TestRunRequiresThePinnedCleanRenderer`,
`TestRunStopsWhenTheRendererOrScannerCannotRun`, `TestExecRenderer*`,
`TestGitleaks*`, `TestWriteReportMatchesGolden`, `TestReportJSONHasOneCellPerItemAndTool`,
`TestMarkdownKeepsContentInsideCells`, `TestAnnotationEscapesWorkflowCommands`, and
with the real client renderer and gitleaks (`LEORNA_TEST_RENDER_BUNDLE_BIN`,
`LEORNA_TEST_GITLEAKS_BIN`; set in CI, where a missing one fails):
`TestQualityGatePassesTheShippedLibraryWithRealTransformers`,
`TestQualityGateFailsABrokenItemWithRealTransformers`. CLI: `cmd/content-gate`
`TestRunPassesAndWritesTheReport`, `TestRunFailsNamingItemAndTool`,
`TestRunRejectsMissingFlagsAndBadPins`.
```
Only keep sentences the build actually proved (e.g. drop "uploads … artifact" from the README until the hosted run shows it, or mark it as configured-not-yet-observed).

## Appendix B — credential setup (Q1-A; Justin / org owner; agents never handle keys)

1. Org owner: Settings → Developer settings → GitHub Apps → New GitHub App, name e.g. "Leorna control-plane content gate", no webhook, **Repository permissions: Contents = Read-only**, nothing else; "Only on this account".
2. Install it on **LeornaAI**, "Only select repositories" → `leorna-client`.
3. Note the App's **Client ID**; generate a private key (.pem) and keep it off chat.
4. In `leorna-control-plane` → Settings → Secrets and variables → Actions: variable `LEORNA_CLIENT_READER_CLIENT_ID` = Client ID; secret `LEORNA_CLIENT_READER_PRIVATE_KEY` = the .pem contents (or `gh variable set …` / `gh secret set … < key.pem` by someone with admin on the repo — Justin has repo admin). Delete the local .pem afterwards.
5. Q1-B instead: Justin creates a fine-grained token (resource owner LeornaAI, repository leorna-client only, Contents read-only, shortest acceptable expiry; may need owner approval) and stores it as secret `LEORNA_CLIENT_READ_TOKEN`.

## Appendix C — plan validation receipt

All Go blocks were written to a scratch copy and checked with `gofmt -l -e` (parse + format only: clean). The Bash block passed `bash -n`. The modified `ci.yml` was parsed with Ruby's YAML loader (20 → 24 quality steps, new ones in the expected order; `permissions` still `contents: read`). The Makefile fragment passed `make -n content-gate`. JSON fixtures passed `python3 -m json.tool`. **Nothing was compiled, type-checked, built or tested**, so small compile fixes (a missing import, a typo) are expected and allowed without redesign; behaviour changes are not.
