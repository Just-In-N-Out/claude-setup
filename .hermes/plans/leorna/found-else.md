# Leorna — other findings (unapproved follow-ups)

## 2026-10-22 — prompt-kind verifier classification

Fresh independent code/local verifier **CLEAN/no findings**, `evidence/86bcm9016/verifier-opus-1/REPORT.md`; parent admitted exact payload/log hashes, not a new product execution. Live acceptance still NOT VERIFIED/release-blocking.

- **P3 canonical sensitivity gap:** removing down-migration CHECK narrowing survives existing suites; independent corrected probe-v2 detects the break and verifies candidate narrowing is correct. Earlier ad hoc probe-v1 was masked by an invalid semver row, preserved/superseded, not a kill. No test repair requested or made.
- **Existing observations classified:** seed1.2.0 prompt loss after destructive rollback/re-upgrade matches approved plan/R7; no guarantee conflict. Tolerant fallback mutant reaches intended Codex unit assertion, E2E detects both variants; no required no-fallback coverage gap. Cursor discovery omission remains P3 doc-only. No source/docs automatically changed.
- **Environment:** verifier-imposed GOPROXY=off caused client codegen deprecation-lookup failure before candidate comparison; canonical default-proxy retry passed unchanged. Real-home config timestamps remain unknown attribution, no restoration. Public CI-only test password pattern occurs in two archived harness sources; complete evidence directory is not a clean publication subset. See full report for all disclosures.

## 2026-10-22 — prompt-kind Opus full-review observations

Full code/local verdict **approved, no introduced findings**. Source: `evidence/86bcm9016/review-opus-1/REPORT.md`; parent verified payload inventory/receipt hashes, not independently re-reviewed product source. No authorization to expand scope or silently fix/waive anything. Separate verifier receives these observations.

- **Low operational / accepted destructive rollback consequence:** after migration21 manual down then re-upgrade, library prompt returns but shared seed base1.2.0 stays without pr-description (8vs9 items), due pre-existing version-only EnsureSeedBase. Evidence actual six-phase `probe-lifecycle-attempt2-summary.json`, phase6. Prefer fix-forward; final rollback instructions/evidence must disclose this. If an independent verifier finds a conflict with approved guarantees, report it as such, not as a new implied acceptance.
- **P3 test suggestion:** no-fallback unit assertion in TestCodexSkipsPromptsWithLoggedReason is not reached by fallback mutant because a-first fixture description is missing; E2E still catches fallback with intended diagnostic. Keep intended E2E and incidental unit failures separate. `mut-O-CL4-codex-skill-fallback.json` and mutant log. No fixture repair made.
- **P3 doc:** Cursor discovery directory list omits user `~/.claude/commands`; duplicate-discovery risk was already accepted. No doc cleanup made.
- **Isolation disclosure:** reviewer ran claude/codex --version once with real HOME. Concurrent ~/.claude.json writes attribution unknown; no claim of read-only real-home effect and no restoration of shared user state. Subsequent roles must isolate HOME/config/cache before even version/help commands. Foreign other-session DB observed and untouched.
- **No new integration collision:** known CP README overlaps and prompt-capable renderer pin remain; local integration refs equalled reviewed bases at parent intake. A future writer must recheck rather than use this as permanent state.
- **Historical environment note below superseded:** GNU realpath/Bash prerequisites were resolved task-locally; both independent full reviews ran passing canonical gates. Original failure receipts remain, no global/source environment fix.


## 2026-10-22 — 86bcm901u reviewer corroboration

- **Existing advisory, not a new defect:** Sol full reviewer independently re-ran verbose govulncheck, exit0, corroborating pre-existing x/crypto/openpgp GO-2026-5932 as module-only with zero vulnerable imported packages/reachable symbols, dependency files unchanged. Evidence `evidence/86bcm901u-review-sol-r1/server-audit-verbose.log`. Current-story sol-01/sol-02 blockers are in the review report/plan, not unapproved scope additions.

## 2026-10-22 — 86bcm901u builder follow-up

- **Informational / builder-reported module-only advisory:** GO-2026-5932 concerns golang.org/x/crypto/openpgp; builder govulncheck output reports zero vulnerable imported packages and reachable symbols. x/crypto v0.57.0 was already on recorded main, dependency files unchanged. No upgrade, ignore or fix was included; independently verify applicability before any separate dependency work. Evidence: `evidence/86bcm901u/audit-verbose-3317d09.txt`.

## 2026-10-22 — prompt-kind builder environment finding

- **Pre-existing local prerequisite:** CP workspace validation requires GNU `realpath --relative-to`; inherited macOS realpath fails on both branch and main (gate exit 2). Installed Homebrew coreutils capability was independently checked; task-local gnubin PATH selected for resume1, with no source/global config fix. Full gate result remains pending. Evidence: `evidence/86bcm9016/build-20261022T183739Z/{gates-5a3b5c6.txt,baseline-main-workspace.txt}`; committed state CP `5a3b5c6`, client `1f259b0`. Original F1–F5 remain unaddressed. Two corrected test-fixture mistakes are development diagnostics, not new product defects or credited RED.


## 2026-10-22 — 86bcm901u-content-quality-gate planner

Planner findings, not independently validated by the dispatcher; no permission to expand the build. Plan: `/Users/justin/.hermes/plans/leorna/86bcm901u-content-quality-gate.md`, Other things found.

- **Medium — agent-support mismatch (corroborates the existing prompt-kind finding below; not a second defect):** both agent items declare all three tools, while all three transformers warn and skip agents. Evidence: `internal/library/content/items/agent/{code-reviewer,test-writer}/item.json`; client `toolconnector/transform.go` `AgentWarnings`. Proposed owner Christian / 86bcm901a. Plan Q2 makes skip-versus-fail an explicit choice, not a repair.
- **Low–medium — possible Codex MCP environment-name mismatch, code reading only:** github-mcp maps GITHUB_PERSONAL_ACCESS_TOKEN to ${GITHUB_TOKEN}, while `toolconnector/codex/config.go` serverTable writes env_vars using the key name. Codex runtime behavior is NOT VERIFIED; verify before fixing.
- **Low — skill description limit mismatch, code reading only:** library `pack.MaxDescriptionRunes` permits 2000, whereas the consulted Agent Skills format / upstream linter use 1024 and RenderSkill does not enforce that limit. Evidence: library validation, client RenderSkill, addyosmani/agent-skills `scripts/lib/skill-lint.js` @aeac41d. Verify current tool limits before a separate fix.
- **Info / prerequisite — private cross-repo CI access needs setup:** planner gh observations found org deploy keys disabled and Justin a member, not owner. Q1 proposes an org-owner-created read-only GitHub App. No credentials or permissions were changed.
- **Info / future architecture — 86bcm9021 AC3 requests per-tool render validation at save time:** planner read the card; executing client transformers on the server would cross the repository boundary. Separate design decision, not in 901u.
- **Info / publication prerequisite — gh token lacks workflow scope:** observed scopes gist/read:org/repo. Justin must authorize and perform any needed auth repair before workflow publication. This does not block local planning/building and does not authorize credential handling.

## 2026-10-22 — 86bcm9016-prompt-kind planner

Reported by the Opus planner; not independently validated by the dispatcher. These are outside the story, not fixed, and not permission to expand its build. Plan: `/Users/justin/.hermes/plans/leorna/86bcm9016-prompt-kind.md`; research: `evidence/86bcm9016/planning/`.

- **Medium — dynamic shell execution in Claude content:** synced Claude skills and proposed prompt commands can run `!` shell substitutions on invocation; no policy gate exists. Evidence: official Claude skills doc “Inject dynamic context”, saved planning/docs line 688; `toolconnector/transform.go` RenderSkill writes bodies verbatim. Pre-existing.
- **Low — unknown kind fails the whole client bundle:** adding any server kind breaks Sync for an older client. Evidence: `toolconnector/pack.go` validation kind switch; `application/sync.go` verifiedPack. The current story must document staged assignment/client rollout, not silently broaden compatibility scope.
- **Low — duplicate Cursor skills:** Cursor also loads `~/.agents/skills` and `~/.claude/skills`, so multi-tool Sync can duplicate entries. Evidence: saved `planning/docs/cursor.com_docs_skills.md`, lines 65–78.
- **Low — stale pack README:** `internal/pack/README.md` says desktop bundle serving is not included, but endpoints exist in `internal/web/client_bundle.go`.
- **Low — agent compatibility metadata disagrees with transformers:** library agents claim all three tools, but the transformers skip agents. Evidence: `internal/library/content/items/agent/code-reviewer/item.json` versus `toolconnector/transform.go` AgentWarnings.

## 2026-10-23 — 86bcm901u-quality-gate-v2 planner (Opus 5.5, Claude Code)
- low: `scripts/verify-workspace.sh:26-33` `find` excludes only `.git`/`vendor`, so `make workspace`/`make check` from the primary control-plane checkout picks up agent worktrees' `go.mod` under `.claude/worktrees/` (inferred from code, not run).
- low: library item versions have no length bound (`internal/library/library.go:52`), but the client caps pack item versions at 50 runes (client `toolconnector/pack.go` `maxPackVersionRunes`); the loader accepts items every client refuses (the v2 gate will catch them).
- medium (product): the library declares both agents for all three tools, but the client installs no agent files (client `toolconnector/transform.go` `AgentWarnings`), so the catalog promises support the desktop app can't deliver.
- medium: the client writes Codex config bodies verbatim with no TOML check (client `toolconnector/codex/config.go`), so malformed TOML would reach users.
- known: the client matches configs to a tool by name prefix and ignores the library `tools` field.
- low (memory): `leorna-workflow.md` "Start here" `local/` branch flow is obsolete; its stories.json-in-same-PR wording contradicts `leorna` step 7.8 ("after the PR exists").

## 2026-10-23 — 86bcm901u-quality-gate-v2 builder (Opus 5.5, Claude Code)
- medium-low: gitleaks 8.30.1 always honours `<source>/.gitleaksignore` (probe: 3 findings → 0). If `gitleaks git` does the same (not checked), a PR adding a root `.gitleaksignore` could hide its own history findings from the repo's CI secret scan. Candidate: a CODEOWNERS rule or a CI check on that file.
- low: the repo `.gitleaks.toml` allowlist regexes (e.g. `SCW_[A-Z_]+=`, `eyJhbGciOiJIUzI1NiJ9\.`) also apply to library content scans, so matching content is allowlisted; a content-specific config is a follow-up.
- low (confirms planner #1): `scripts/verify-workspace.sh` picks up `go.mod` under `.claude/worktrees` from the main checkout; fine from inside a worktree.

## 2026-10-24 — 86bcm901v-catalog-browser-v3 planner
- (low, docs) `leorna-control-plane-workflow.md` said "No browser demo exists"; stale: with `LEORNA_DEV_MODE=1` the binary accepts `sslmode=disable` and needs no Google credentials (`internal/config/runtime.go:61-86` at 6e74ced). Memory note corrected 2026-10-24.
- (low, test-only) `internal/web/handler_test.go:308-316`: `readBody` silently truncates response bodies at 64 KiB; large-page tests need their own reader.
## 2026-10-24 — 86bcm901v-catalog-browser-v3 builder
- (low, info) GO-2026-5932 in `golang.org/x/crypto@v0.57.0`: also on base, no fix available, not called (`evidence/86bcm901v-catalog-browser-v3/audit-verbose-1571fcd.txt`).
- (info) A Terminal.app window used for the AC3 capture kept a hidden tab-less window object after `exit`; harmless, nothing running.
## 2026-10-24 — 86bcm901v-catalog-browser-v3 reviewer 1
- (low, existing code) `orgError` maps a malformed-uuid DB error (22P02) to a generic error, not not-found; every caller pre-checks with `validUUID` (the new code too), so a missing check would surface as a 500 instead of a 404.
## 2026-10-24 — 86bcm901v-catalog-browser-v3 fixer r1
- (info, story docs) The approved plan's "Current context" goldmark bullet repeats the wrong "every data: URL is emptied" claim; the plan copy is read-only, the code comment and README are now correct (266603e).
## 2026-10-24 — 86bcm901v-catalog-browser-v3 reviewer 2
- (P3, follow-up, recorded per decision (a)=A) Markdown preview worst case: goldmark pads short table rows to the header width, so a 16 KB table renders 80 MB HTML / 1.8 GiB allocated; only Leorna-authored content reaches `library_items` today; fix before 86bcm945u or tenant variants land (`review-r2/render-cost-probe-266603e.txt`).
- (P3/info) When PR #85 (`prompt` kind) merges, the Kind dropdown offers "Prompt" but migration 20's `library_items.kind` CHECK still allows 4 kinds, so filtering by Prompt shows the empty state until a migration adds it.
## 2026-10-24 — 86bcm901v-catalog-browser-v3 finisher
- (info, process) Card 86bcm901v already shows "in verification" while no PR exists and the branch is unpushed; Justin moves cards himself, and the delivery gate needs the PR merged before shipped/complete.
## 2026-10-24 — 86bcm901u-quality-gate-v3 builder, reviewers 1–2, fixer 1
- (P3, upstream/follow-up) gitleaks 8.30.1's built-in global allowlist `(?i)^true|false|null$` is unanchored in the middle, so any secret containing "false" (any case) is dropped in every default-rules scan, including CI's repository-wide `gitleaks git` step. Main session confirmed the regex in the embedded config. Follow-up: report upstream; check whether the repo `.gitleaks.toml` can override it. (reviewer 2)
- (low, client) The client's Cursor renderer accepts a `null` config body and writes `cli-config.json` = `null`; Claude Code rejects null. The gate mirrors the client by design. (reviewer 1)
- (low, base) `library.Validate` accepts control characters (newlines) in `library.json` `name` (`internal/library/library.go:169,213`); the gate's log header now uses `oneLine()`, the loader is unchanged. (reviewer 1)
- (info) govulncheck GO-2026-5932 in golang.org/x/crypto v0.57.0 (not called, no fix), present on base `6e74ced`. (builder)
- (P3, pre-existing on main, follow-up card) A Makefile `export GOFLAGS = -n` or a step writing `GOFLAGS=-n` to `$GITHUB_ENV` turns CI's Test, Vet and Build (`make test/vet/build`) into exit-0 no-ops; suggest a CI check that `go env GOFLAGS` holds only expected flags before the Go steps. (86bcm901u v3 verifier 2, `evidence/…/verifier-r2/ac4-mutations-e488a8c.log` N1–N4)
- (P3, beyond AC4's stated boundary) Swapping an earlier CI step's `uses:`/`with:` to an action calling `core.exportVariable` can set GOFLAGS without naming GITHUB_ENV; same mechanism as the GOFLAGS/GITHUB_ENV follow-up above, code-review territory. (86bcm901u v3 verifier 3)
- (P3, inside AC4's boundary, follow-up per the convergence rule) An existing earlier named CI step can still change the gate step's environment without naming GITHUB_ENV/GITHUB_PATH (e.g. `go env -w GOFLAGS=-n` in "Verify formatting", or swapping "Install Helm" to an action calling `core.exportVariable`). Closing it structurally means pinning the nine earlier steps' text against main, at the cost of a test update on every edit to them (e.g. action SHA bumps). Code reading only; not run. (86bcm901u v3 fixer 5, F5-1)
- (low, main) `delivery/stories.json` on main has no 86bcm945u entry although PR #89 merged (AGENTS.md says keep it current). (86bcm901u v3 fixer 6)
- (low, main) 86bcm9016 and 86bcm945u each bumped `content/library.json` 0.2.0 → 0.3.0 independently, so main's 0.3.0 holds 10 items while each story's own 0.3.0 had 9. (86bcm901u v3 fixer 6)
- (low, main) Main's `internal/library/README.md` (86bcm945u section, ~line 274) still says import/accept refuse prompts "until the prompt kind (86bcm9016) … exists"; 9016 is merged. (86bcm901u v3 fixer 6)
- 2026-10-24 (901v v3 merge verifier, P3 cosmetic, pre-existing): shared `td{overflow-wrap:anywhere}` in `adminBaseCSS` (`internal/web/admin_ui.go:7`) breaks words mid-word in narrow admin table columns ("Prom|pt", "integration|s" on the library page at 1440 px; `evidence/86bcm901v-catalog-browser-v3/verifier-merge/ac1-library-filtered.png`).
- 2026-10-24 (901v v3 publish-merge finisher, low): main's `delivery/stories.json` lists `86bcm9016` with empty PR arrays, so `check-story-shippable.py 86bcm9016` passes without checking PR #85; `86bcm945u` (PR #89) has no entry, so its check stops with "story is not inventoried" (`git show origin/main:delivery/stories.json`, `scripts/check-story-shippable.py`).
- (low, main, pre-existing) `scripts/check-story-shippable.py` passes vacuously when a story's `delivery/stories.json` PR list is empty (it only checks listed PRs, main's CI and open PRs naming the card): `check-story-shippable.py 86bcm901u` printed "Merge/CI gate passed" with no PR at all. Suggest refusing an empty list. (86bcm901u v3 fixer 7, `evidence/…/fix-7-story-checks-0cf18f1.txt`)
- 2026-10-25 (86bcm9019 planner, low, main, pre-existing): `library-upstream` importer flags a script only by `scripts/`, a shebang or mode 100755 (`internal/library/upstream/importer.go:147`), while `pack.IsScriptFile` (`internal/pack/pack.go:254`) also counts .sh/.ps1/.py/.bat/.cmd by extension; an upstream `tool.py` outside `scripts/` would read as adapted right after import. None of the 25 agent-skills hits it.
- 2026-10-25 (86bcm9019 planner, info, main): the gate's render copy is pinned at client `17f7c1b`, before client PR #22, so 945q's four multi-file skills shipped without the gate rendering or secret-scanning their supporting files (repo-wide gitleaks still scans them). In scope for 9019 if Q-B ⭐.
- 2026-10-25 (86bcm9019 planner, medium, main): `delivery/stories.json` on `5778350` still has no 86bcm945u entry, and 86bcm901u and 86bcm9016 list no PR, although #89/#90/#85/client #20 merged; local commits `f85b6fd` (945u) and `b13b922` (901u) were never pushed. Same class as the 2026-10-24 entries above, now confirmed after the merges.
- 2026-10-25 (86bcm9019 builder, low): ADR 0002 says to revisit Tier 2 routing evals "when the library ships ten or more skills"; library 0.5.0 ships 26 (`adr/0002-reuse-of-agent-skills-evals.md`, Tier 2 bullet). Revisit due.
- 2026-10-25 (86bcm9019 builder, low): upstream `agents/code-reviewer.md` has the same name as Leorna's own `agent/code-reviewer`; 86bcm901a's import will hit "already exists" and needs a naming/replacement decision (ls-tree at aeac41d).
- 2026-10-25 (86bcm9019 builder, low): library README's upstream Verification list names `TestNextStepForAMultiFileRootIsNotAnAccept`; the test is `TestNextStepForAMultiFileRootAcceptsTheWholeFolder` (`cmd/library-upstream/main_test.go:653`).
- 2026-10-25 (86bcm9019 builder, low): upstream content nits kept verbatim, listed in `curation.json` notes (`npm run lint --fix` needs `--`; try/catch can't catch React render errors; `npx axe-core` has no CLI, 18pt not 18px, `<dialog open>` doesn't trap focus; async/await removal changes throw/stack; `git reset --hard HEAD` discards uncommitted work). Candidates for upstream issues or a later adaptation.
- 2026-10-25 (86bcm9019 builder, info): skills name upstream slash commands (/build, /test, /review, /ship, /ideate) and `agents/` personas a Leorna install lacks until 86bcm901b/901a; noted per skill in `curation.json`. Replaced demo skills stay in `internal/pack/seed.json` and existing catalogs (86bcm901r owns the seed).
- 2026-10-25 (86bcm9019 reviewer 1, P3, pre-existing in client PR #22 `RenderSkillFolder` + 945q parser): a supporting file at `files/SKILL.md` silently replaces the rendered SKILL.md (frontmatter lost) and the gate still reports rendered/PASS (probe `evidence/86bcm9019/review-1/mutations/zz_review1_gate_test.go`). Same class: `pack.ValidSupportPath` (`internal/pack/pack.go:241`) allows case-only-different paths (overwrite each other on macOS/Windows) and Windows reserved names (`aux.md`, `con`). No shipped item hits it. Fix: reserve SKILL.md, reject case-folded duplicates in parser (`library.go:221`) and client, then copy.
- 2026-10-25 (86bcm9019 fixer 1, P3, pre-existing 945u): `gitCommand` (`internal/library/upstream/git.go:237-247`) passes the caller's whole environment (minus repo-location vars) to git clone/ls-tree/show with no `GIT_CONFIG_GLOBAL`, so `~/.gitconfig`, `GIT_CONFIG_PARAMETERS`/`COUNT` (e.g. `url.<x>.insteadOf`, `http.proxy`) reach the clone. Content stays pinned by fingerprints; low risk for a maintainer CLI.
- 2026-10-25 (86bcm9019 fixer 1, P3, pre-existing 86bcm9018 item): `internal/library/content/items/mcp_template/github-mcp/body.md` is an MCP server entry running `npx -y @modelcontextprotocol/server-github` with no version pin; under Justin's 9019 R1-4 rule (auto-running config gets a pin note) it would be adapted. Not a skill, so outside curation.json.
- 2026-10-25 (86bcm9019 reviewer 2, medium, upstream agent-skills): `npx lhci autorun` (performance-optimization) and `npx migrate-check` (deprecation-and-migration) name third-party npm packages (`lhci` = "placeholder anupamas0x1" with an `lhci` bin; `migrate-check` = reserved placeholder); main session confirmed with `npm view`. Worth an upstream issue (Justin's call). In-story handling: R2-1.
- 2026-10-25 (86bcm9019 reviewer 2, low, pre-existing 945q): executable bits differ between embedded and checked-out parsing (`source.go:233`); case-only supporting-file paths collide on case-insensitive systems (also in reviewer 1's entry above).
- 2026-10-25 (86bcm9019 fixer 2, low, pre-existing 901u `b645c0a`/`22b5303`): `internal/library/gate/scan.go:265-273` defers `RemoveAll(work)` then reassigns `work` from `EvalSymlinks`, so a failed resolve leaks the `library-gate-gitleaks-*` folder (same pattern fixed in 9019's AdaptationDiff as R2-5).
- 2026-10-25 (86bcm9019 fixer 2, info): `@lhci/cli` 0.15.1 (newest) has 16 npm audit advisories in its dependency tree (13 high, none critical); stated in the performance-optimization review note (`evidence/86bcm9019/fix-2/npm-audit-lhci-cli-0.15.1.log`).
- 2026-10-25 (86bcm9019 verifier 2, info): only the opt-in network test (`TestShippedImportsMatchTheRealUpstream`, `LEORNA_TEST_UPSTREAM_NETWORK=1`) catches a forged `upstreamSha256` plus matching lock line; CI skips it (README lines 367, 456). Running it in CI would need a CI exception, so it stays a manual pre-merge step.
- 2026-10-28 (86bcm901a planner, low, pre-existing): `delivery/stories.json` at `1ee7157` lists no PR for 86bcm901u (#90, merged) or 86bcm9019 (#92, merged), so `check-story-shippable.py` passes them vacuously (9019's `3cd9b0f` waits for "push").
- 2026-10-28 (86bcm901a planner, low, moot if replaced): the demo `test-writer` "writes tests" but `items/agent/test-writer/body.md:4` `tools: Read, Grep, Bash` has no Edit or Write.
- 2026-10-28 (86bcm901a planner, medium, environment): the Windows desktop (WSL Ubuntu) has no go, make, golangci-lint, govulncheck or Postgres, and Docker Desktop's WSL integration is off. Main session confirmed with `command -v` and `docker ps`. It blocks every control-plane gate here (901a question D).
- 2026-10-28 (86bcm901a planner, medium, product follow-up): the desktop client installs agents for no tool (`toolconnector/transform.go:28` at client `f105e27`, copied in `render/shared.go:20-31`), so library agents reach no engineer through Sync. Suggested card: the client installs agents for Claude Code at `.claude/agents/<name>.md`.
- 2026-10-28 (86bcm901b planner, adds to 901a's `stories.json` line above): `delivery/stories.json` at `1ee7157` also lists no PR for 86bcm9016 (#85, merged) and has no 86bcm945u entry at all (#89).
- 2026-10-28 (86bcm901b planner, low docs, fixed by 901b): `internal/library/README.md` at `1ee7157` says prompts (`commands/*.toml`) can now be imported, but `importer.go:156-157` refuses prompts and `library.go:255` rejects prompt sources.
- 2026-10-28 (86bcm901b planner, environment, adds to 901a's line above): Chrome for Testing 156 `--headless=new --screenshot` hung (exit 124) twice on the WSL desktop; 901b's B0 probes chromedp instead and leaves screenshots owed if nothing produces a PNG.
- 2026-10-28 (86bcm901w planner, P2, audit gap): pack versions made by Fork, SaveEditedVersion and add-library-item write no audit record (`internal/store/postgres/pack_versions.go:21-97` has no `appendAudit`), against `internal/audit/README.md` "Future domain mutation methods must call appendAudit inside their transaction"; Yan's open PR #94 (`CreateItem`) uses the same path.
- 2026-10-28 (86bcm901w planner, P3, contract trap): both repos' contract-kind tests require exactly 2 inline `kind: {type: string, enum: [...]}` lines (control plane `internal/web/contract_kinds_test.go:22`, client `application/contract_kinds_test.go:18`), so a new schema written that way breaks them even with a correct enum (saved to leorna-control-plane-workflow.md).
- 2026-10-28 (86bcm901w planner, P3, product): every new pack version gets new item ids, so script approvals never carry over, even for unchanged items (migration 22 comment; `pack_versions.go:71`).

## 2026-10-28: 86bcm901j planner
- P2 (client repo): the Codex transformer forwards env by key name and ignores the `${VAR}` name (control-plane copy `render/codex.go:121`), so Codex reads a different variable than Claude Code/Cursor; the client should refuse `KEY:${OTHER}` like the tiles (`internal/integration/tile.go:378-381`).
- P2: `internal/pack/seed.json:42-60` (seed 1.2.0) ships github-mcp 2.0.0 (unpinned deprecated npx + variable mismatch) and the old configs to every new install. Owner: 86bcm901r.
- P3: admin-edited pack versions get no secret or pin policy checks (`internal/pack`).
- P3: the GitHub tile (`internal/integration/tiles/github.json`) asks for classic `repo,read:org` scopes (write access) and uses the non-read-only address.
- P3: `delivery/stories.json` on main lists 86bcm9019 with `[]` although PR #92 merged; local commit 3cd9b0f was never pushed, so `check-story-shippable` checks nothing for it.
- P3: the credential-key regex will be duplicated between `tile.go:143` and the new `policy.go`.
- Info: `@modelcontextprotocol/server-github` (2025.4.8) and `server-postgres` (0.6.2) are deprecated on npm (confirmed by the main session with `npm view`).
- Environment: the Windows desktop has no Linux Go, golangci-lint, govulncheck or Docker inside Ubuntu, and headless Chrome screenshots hang inside the agent sandbox; sibling stories hit the same.

## 2026-10-28 — 86bcm901w builder
- P2 (environment): the WSL desktop has no C compiler, so cgo is off and control-plane `make test` (`go test -race`) can't run ("-race requires cgo"; `go env CGO_ENABLED` = 0; no gcc/cc/clang). Blocks 901a/901b/901j/901w `make check` here until `sudo apt-get install -y make gcc`.
- P3: `scripts/verify-workspace.sh:26` and `scripts/format-workspace.sh:15` `find .` excluding only `./.git` and vendor; from the main checkout they walk `.claude/worktrees/*` (`make workspace` sees extra modules, `make fmt-fix` would rewrite sibling worktrees' files).
- P4: `~/.local/leorna-toolchain/.install.lock` didn't exist until the 901w builder's `flock` created it, so the shared-install lock the plans name wasn't shared by the first installer. Tools now verified against go.dev and CI checksums.

## 2026-10-28: 86bcm901j builder
- P3 (environment): the desktop also lacked `make` and a C compiler (`go: -race requires cgo`); fixed locally under `~/.local/leorna-tools` (make via dpkg-deb, Zig as `CC`).
- P3 (Codex): `history.persistence = "none"` covers only `history.jsonl`; Codex 0.165 also writes `rollout-*.jsonl` session files, so a pasted secret can likely still reach disk (not confirmed with a signed-in run).
- P3 (docs): `internal/library/README.md`'s older gate paragraph says "Failure reasons quote the offending text"; the new policy reasons never repeat a value.
- 2026-10-28 (86bcm901b builder, low, environment): on the WSL desktop a headless Chrome capture that times out leaves its `--type=gpu-process` child running indefinitely (the builder killed its own 9). Another session's Chrome under `/tmp/f2b-chrome-*` had been running ~12 h; not this story's, left untouched.
- 2026-10-28 (86bcm901b builder, info, pre-existing on base `1ee7157`): govulncheck reports 1 vulnerability in a required module the code does not call; the gate passes.

## 2026-10-28: 86bcm901j review 1
- Info (environment): Justin's own Codex app-server daemon and interactive Codex sessions write the real `~/.codex/*.sqlite` continuously; real-tool isolation proofs must rest on the scratch `CODEX_HOME` and the real `config.toml` timestamp.
- Info: codex-cli 0.165.0 refuses a top-level `profile = "x"`, so `[profiles.*]` aren't a privilege path on 0.165.
- 2026-10-28 (86bcm901b reviewer 1, info): read-only `merge-tree` at ~19:55Z: 901a (`0ab7e6f`) conflicts with 901b in `cmd/library-upstream/main.go`, `internal/library/upstream/importer.go`, `internal/library/curation.go` (both add flags/fields: keep both) plus README, `stories.json`, `curation.json`; 901j (`7c2c35a`) in `stories.json`, README, `content.lock.json`; 901w (`18ed1b7`) clean. 901a and 901j also set `library.json` to 0.6.0: the second to merge takes the next minor.
- 2026-10-28 (86bcm901b fixer 1, low, pre-existing): `decodeStrict` (`internal/library/source.go:301-315`; item.json, library.json, upstream.json) and `ReadCuration` (`internal/library/curation.go:70-87`) use encoding/json v1, which matches keys case-insensitively: `Requires` or `Description` is accepted, and beside the exact key the last one wins (deterministic; `evidence/86bcm901b/fix-1/probe-json-78f13a7.log`). Follow-up: encoding/json/v2 with `RejectUnknownMembers(true)`, as `internal/config/manifest.go:136` does.

## 2026-10-28: 86bcm901j fixer 1
- P3 (pre-existing on main, 901u `gate.go` `checkFormats`): a rendered config.toml that doesn't parse puts BurntSushi's error text in the render-stage reason, and that text quotes the offending value (an unquoted token in a Codex body reaches the report, log and summary). Follow-up.
- P3 flake: `TestSetupWizardWithPostgres/completion_shows_the_ready_state_with_the_base_pack_available` (5 s `waitForStep`) timed out once under host load (load avg ~9); passes alone 3/3.
- Environment: `/tmp` on the desktop is a 7.9 GB tmpfs shared by all sessions (hit 98%); heavy temp files belong on the real disk.
- 2026-10-28 (86bcm901b reviewer 2, low, pre-existing 86bcm945u): a skill or agent frontmatter description can hold a raw lone CR (Transform folds only CR LF; `Item.Validate` allows CR/LF in descriptions, `internal/library/library.go:215`); renderers JSON-quote descriptions, so nothing breaks (`evidence/86bcm901b/review-2/probe-lone-cr-description.log`).
- 2026-10-28 (86bcm901b reviewer 2, low, pre-existing): no control-character guard on imported library text of any kind: a skill's raw bytes or a prompt's TOML escape can carry terminal escape sequences into shipped bodies, and the content gate doesn't check (`evidence/86bcm901b/review-2/probe-hostile-commands.log`); the shipped texts contain none.

## 2026-10-28: 86bcm901j review 2
- Minor (pre-existing on main): the copied renderers quote keys in warnings/errors (e.g. "permissions key %q is not supported"), so a token in a dropped key reaches the JSON report and summary through the render stage; fix belongs in the client renderer or the report writer.
- Info: npx reads the project's own `.npmrc`, so a cloned repo can redirect the registry for any pinned npx server regardless of the template's env (supports "prefer a hosted server").
- 2026-10-28 (86bcm901b fixer 2, info, upstream content): the agent-skills TOML bodies of `/build`, `/spec` and others have no `$ARGUMENTS`, yet `/build` picks its mode from the arguments; Claude Code 2.1.312 appears to append "ARGUMENTS: <input>" when a body has no placeholder (read from minified source, not run). 901b's AC5 step 5 (`/spec <idea>`) is the first live check.
- P3 (86bcm901w builder 2): `waitForLockWait` (`internal/store/postgres/pack_versions_test.go:325-343`) matches exact INSERT text in `pg_stat_activity`; a harmless text change to `EnsureSeedBase`'s insert makes `TestEnsureSeedBaseWithPostgres` fail with "never waited" and leaks its blocked goroutine.
- P3 (86bcm901w builder 2): `teamForm` (`internal/web/teams_view.go:151-170`) repeats `adminForm`'s content-type, body-bound and CSRF checks instead of calling it, so shared-helper changes don't reach team forms. Not a bug today.
- P3 lead, unverified (86bcm901w review 1): `internal/web/teams.go:151,188` also use the raw path id as the audit target, the same pattern as 901w R1-F1 (upper-case UUID URL filed under non-canonical text); not checked whether the HTML team routes accept upper-case ids.
- Info (86bcm901w review 1): migration 23's triggers make every pack version undeletable (like `audit_records`); a future delete or tenant-offboarding feature needs a deliberate path. Documented in the pack README.
- P3 (86bcm901w fixer 1, by code reading, not probed; extends review 1's lead above): team and project console actions file audit records under the raw path id (`validUUID` accepts A–F): `internal/web/teams_view.go:173` → `internal/store/postgres/teams.go:151,188,229,246` (team.update/delete, membership.add/remove) and `internal/web/projects_view.go:91` → `internal/store/postgres/projects.go:105,116` (project.renew/delete). Pre-existing on main.
- 2026-10-28 (86bcm901b finisher, info, cross-story): 901a's `orphanDiffs` check counts skill and agent adaptations but not prompts; harmless while every prompt is verbatim, but an adapted prompt would need it once 901a and 901b both merge.

## 2026-10-28: 86bcm901j verifier (round 1)
- Info (documented limit): credential names matching no pattern word (`DB_CREDS`, `PASSKEY`) still pass rule S; gitleaks is the backstop.
- Info (by design): the plain-name rule still quotes a human-style secret pasted into a name (letter words, ≤3 digits each); random tokens are covered.
- Process: agents twice ran `codex --version` once with the real HOME (no `~/.codex` change found); briefs now say throwaway homes even for `--version`.
- P4 (86bcm901w fixer 2): three more migration 23 constraints have no test: `pack_number >= 1` (DB5), the pack name length CHECK (DB6), `pack_lineages` → `tenants` FK (DB7). Each mutant survives all 435 tests in store/web/dbcheck; app code also guards these (defence in depth). Receipt `evidence/86bcm901w/fixer2/found-else-constraints-8a50486.txt`.

## 2026-10-28: 86bcm901j fixer 3
- Low: a template with a NUL in an env value passes the gate and counts as verified for Claude Code, but real Claude Code 2.1.312 refuses to start that server (`ERR_INVALID_ARG_VALUE`); breaks the template, not a security hole. Possible follow-up: refuse NUL in values or treat it as not verified in rule V.

## 2026-10-28: 86bcm901a finisher
- Info for 86bcm901w: `loadLibraryItems` (`internal/store/postgres/pack_builder.go`) loads library rows by ID, so on installs that loaded library 0.5.0 the retired demo rows `agent/code-reviewer@1.0.0` and `agent/test-writer@1.0.0` stay selectable unless 901w's picker lists only the newest version per kind and name.
- Nit (901a branch, doc only): `cmd/library-upstream/main.go:6` package comment omits `[--version V]` on its import line; the usage text at `:52` has it. Left out to keep the accepted head `9c13e02`; fold into the 901b merge or a later fix round.
- P4 (86bcm901w verifier, test isolation, no defect): AC4's `unknown_library_item` sends only an unknown id, so the empty-pack check masks the unknown-id guard; mutant AC4unk (unknown id silently dropped in `loadLibraryItems`) passes AC4 and is killed only by store subtest `unknown_or_malformed_library_item_is_invalid`. A valid-plus-unknown AC4 case would isolate it. Receipt `evidence/86bcm901w/verifier/mutations-verifier-8a50486.txt`.
- 2026-10-28 (86bcm901b AC5 runner, info, upstream prompt behaviour): live `/spec` (Opus 5.5, xhigh, Justin's setup) asked only about stack and features before writing `SPEC.md`, not about objective/users, acceptance criteria or boundaries as the command body says (it drafted those for approval); it listed assumptions after writing SPEC.md though the skill says before. `/review` imported `calc.py` with python3, leaving a `__pycache__/` in the user's repo. Claude Code 2.1.312's built-in `/code-review` has the alias `review` (project `/review` listed first and ran).

## 2026-10-28: 86bcm901j verifier round 2
- Nit (test coverage): AC4 has no case for a non-ASCII letter that upper-cases to ASCII (`ſHELLOPTS`, `PREFıX`); mutant M11 survives AC4; no security effect (launch list upper-cases first).
- Low (unproven): launch-settings denylist omits version-manager homes (`VOLTA_HOME`, `ASDF_*`, `NODENV_*`, `MISE_DATA_DIR`, `FNM_DIR`, `N_PREFIX`); README overclaims for shim users. Raised to Justin.
- Info: `leorna-test-pg` publishes on 127.0.0.1:55432 on the desktop; the plan's Task 8 URL says 5432.
- Low, plan text only (86bcm901w auditor): the approved plan's E1 demo-server recipe points `LEORNA_DATABASE_URL` at 127.0.0.1:5432 (Justin's `leorna-pg`) but creates the demo DB in `leorna-test-pg` on 55432; followed literally it connects to the wrong container.

## 2026-10-28: 86bcm901j auditor
- P3 (pre-existing, out of scope): the copied client renderer quotes server names and keys in render-stage reasons, so a token pasted into a server name reaches the gate's JSON report and CI log via the render stage (the policy stage never repeats it). Needs a client-side change; same follow-up as review 2's renderer note.
- Info, needs a team decision (86bcm901w finisher): the console picker offers only the newest version per kind and name (`ListLibraryItems` uses `DISTINCT ON (kind, name)`), but the JSON API (`loadLibraryItems`) accepts any stored `library_items` id, so once 901a lands the retired `agent/code-reviewer@1.0.0` row can still be put in a pack by id through `/v1/packs`. Handover `followups.md` row 8.

## 2026-10-28: 86bcm901j finisher
- P3 (cross-story, Yan's area): PR #94's `gate.CheckTenantItem` renders and secret-scans admin-made items but doesn't run this story's policy stage, so once both merge, admin-made MCP templates/configs skip rules S, P, V, L (`tenant.go` in `fd63455`).
- Info: sibling PRs #95/#96/#97 name 86bcm901j in their bodies, so `check-story-shippable.py 86bcm901j` stays BLOCKED until they merge.
- Low, noise (86bcm901w PR agent): `scripts/check-story-shippable.py` lists a story's own inventoried PR twice while it's open (as "not merged into main" and as "open follow-up references this story", since its title names the card ID); clears on merge. Receipt `evidence/86bcm901w/pr/stories-commit-5e29c56.txt`.
- Low (86bcm901a bring-main-in, 2026-10-28): on main `db3406e`, `delivery/stories.json` lists `86bcm901b` and `86bcm9019` with empty PR lists although #95 and #92 merged; `check-story-shippable` passes vacuously on an empty list. Belongs to 901b/9019 bookkeeping.
- Low, plan text only (86bcm901w auditor 2): plan E2's capture steps tick `code-review-checklist` and `commit-message-style`, which aren't in the content library this head ships (32 items); a capture followed word for word stops at the tick step.
- Low (86bcm901a push, 2026-10-28): PR #96 (901w, `8a50486`) now conflicts with main `da8a4b0` itself in `internal/web/handler.go` (from #94) and `delivery/stories.json`; for 901w's owner. Evidence: `evidence/86bcm901a/push-829fa9c/sibling-96-merge-tree.txt`.

## 86bcm901w bring-main-in fixer (2026-10-28, head 5a9aa2f)
- Medium-low: cmd/control-plane/main.go wiring is untested: dropping application.SetPackBuilder(...) (M5) or SetItemBuilder(...) (M6v2) still passes go test ./cmd/control-plane/ and every gate. Pre-existing on both sides. Evidence: evidence/86bcm901w/mainin/mutants-5a9aa2f.txt.
- Low: main's internal/library/library.go comment on Requires (#95) says the pack builder (86bcm901w) reads it through Library.Required; 901w's builder doesn't (AC1 "exactly the ticked items"). Ticking a prompt without its required skills gives a pack missing them. Product question for 901b/901r.
- Low-medium: CreateVersion paths write no audit record (fork, single-item edit, and now #94's create-from-scratch); builder saves do. Extends the earlier P2 Fork/SaveEditedVersion audit gap.
- Low: main's delivery/stories.json lists 86bcm901b with "prs": [] though #95 merged, so check-story-shippable.py 86bcm901b passes vacuously.

## 86bcm901w verifier on 5a9aa2f (2026-10-28)
- Confirms the bring-in fixer's two items: #95's library.go:85-89 Requires comment is ahead of the code (approved-plan follow-up F1; library_items has no requires column, so a pack with prompt/review saves without its 3 required skills), and main.go SetPackBuilder wiring is untested (mutant MW green).
- Info: #94's gate.CheckDerivedPack renders the whole parent pack; on newPackBuilderFixture's synthetic items create-from-scratch returns 422, with real shipped items 303. Test-fixture artifact, not a product bug.
- Info: govulncheck exit 0 but notes 1 vulnerability in a required module the code doesn't call (CI pins the same tool).

## 86bcm902a planner (2026-10-29)
- Info: 86bcm901r's card says "/plan", but library 0.7.0 ships it as prompt `planning` because Claude Code has a built-in `/plan` (library README :491-493).
- Info: 86bcm901r says "Repo: content", but every content card so far (9019, 901b, 901a, 901j) was built in leorna-control-plane's `internal/library`.

## 86bcm902a builder on 7b45d43 (2026-10-29)
- High (integration): 86bcm901r is being built on feat/86bcm901r-starter-packs (aa57092, another session) with its own 000024_starter_packs migration and real starter packs (internal/library/starter-packs.json, internal/pack/starter.go) that overlap 902a's stand-in internal/onboarding/starters.go; migration 24 is now claimed by 901y, 901r and 902a; all three touch delivery/stories.json, and 901r/902a both touch cmd/control-plane/main.go and internal/web/handler.go.
- Low, pre-existing: internal/web test helper readBody (handler_test.go:308-316) caps at 64 KiB; a starter pack's /content reply (~290 KB) decodes as "unexpected end of JSON input" (already in leorna-control-plane-workflow.md).
- Info, cosmetic: starter cards run role, pack name, item count and description together in one line (ac5-01), as the plan's CSS has it.
- Info: the plan's E1 recipe (placeholder public URL) can't do the desktop sign-in; the builder used https://demo.leorna.invalid with a loopback Host header (ruling 2).

## 86bcm902a review 1 on 7b45d43 (2026-10-29)
- Nit: the 902a approved plan's risk R1 command (plan-approved.md:1365) has no `.up.sql` filter, so it lists every migration version as duplicated; use `grep '\.up\.sql$'` (the leorna skill line is now corrected).
- Info: TrySetupLock (internal/web/setup_lock.go) returns false both for "your other step is running" and "all pool slots busy", so callers can't tell them apart.
- Info: 901r and 901y conflict with each other (delivery/stories.json, internal/pack/README.md, internal/web/library.go) and both use migration 000024 (902a too): for those stories' finishers.

## 86bcm902a fixer 1 on 707a4c0 (2026-10-29)
- Nit (UX, follows from F1): resubmitting after a pick whose browser went away shows the done sentence and, above it, the 409 "team name already exists" alert; both true, but they read oddly together.
- Info: review 1's probe file (evidence/86bcm902a/review1/tools) no longer compiles against 707a4c0 (PackMaker.Packs removed); fixer 1's two new tests replace its two scenarios.

## 86bcm901y remove-reorder (2026-10-29: planner, builder, verifier on 3e8d181)
- P3 product (pre-existing): every pack-builder save gives items new row ids, so scripts need re-approval even after a pure reorder (`internal/pack/README.md:225`).
- P3 client (pre-existing): when an edited file blocks a removal at Sync, the whole tool fails with "Native files were not changed for this tool" and no file name (leorna-client `application/sync.go:280-281`).
- P3 process: the 901y builder ran a repo-wide `git worktree prune`, which removed the stale registration of `~/.cache/86bcm901j-fixer6/head-d723e04` (folder already gone; 901j's worktree and branch intact). Rule now in the `leorna` skill.
- Nit (test gap): AC4/another_company_pack posts a current parent_version, so the new item route's 409/400 page branches for a foreign tenant are covered only through 901w's `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres/another_company_pack`; a foreign-tenant case with a stale parent_version expecting 404 would test the new route directly (`evidence/86bcm901y/verifier/mutations-summary-3e8d181.txt`).
