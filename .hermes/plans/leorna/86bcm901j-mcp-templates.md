# 86bcm901j: Baseline MCP templates + secure tool configs (plan)

Card: [Baseline MCP templates + secure tool configs](https://app.clickup.com/t/86bcm901j) (PI-2, E10 Content Library, Size M, to do, Justin). Repo: `leorna-control-plane` ("content" = `internal/library/content/`). Pipeline: **Full**. Status: **Approved 2026-10-28** under Justin's standing "go with the recommended" grant; answers in `## Justin's answers (2026-10-28)` at the end (Q6 held for Justin). Planner: Opus 5.5 xhigh, 2026-10-28, read-only, on worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates`, HEAD `1ee7157` (= origin/main when read).

## Questions (answer before "go"; ⭐ = recommended; the plan below assumes every ⭐)

**Q1. The GitHub template runs `npx -y @modelcontextprotocol/server-github` unpinned (PR #92 follow-up), and that npm package is deprecated ("Package no longer supported"). What should it become?**
- A ⭐ GitHub's hosted server, read-only, nothing runs locally
- B Pin the deprecated npm package at `@2025.4.8`
- C GitHub's Docker image pinned by digest (needs Docker)
- D Leave it; the pin stays a follow-up

If B: body keeps `command`/`args` with `@2025.4.8` and the env key fixed to `"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"`; AC4's shipped subtest asserts the pin instead of the URL. If C: the pin rule must also accept `docker run … image@sha256:<64 hex>` (new test cases) and the example tells engineers to install Docker. If D: AC4 is dropped and the follow-up stays in the PR's Assumptions.

**Q2. How strict should the two tool configs be?**
- A ⭐ Nothing pre-approved; deny secrets; Codex history off
- B Keep today's Go allow rules; add the deny rules
- C Strictest: Codex read-only sandbox, Claude plan mode

If B: the Claude Code floor allows `permissions.allow` entries that name one exact command (no bare tool, no `*` alone); AC2's shipped subtest expects `Bash(go test:*)` and `Bash(make check)` and the Codex history stays `save-all`. If C: `sandbox_mode = "read-only"`, `defaultMode = "plan"`, and AC5 expects Codex to report a read-only sandbox.

**Q3. The starter seed (`internal/pack/seed.json:42-60`) still ships github-mcp 2.0.0 and the old configs to every new install. Update it here?**
- A ⭐ No: role packs story 86bcm901r owns the seed
- B Yes: seed 1.3.0 with the new item versions

If B: add a task to replace the three seed items, bump the seed to 1.3.0, regenerate `seed.sha256`, update `TestDefaultSeedExcludesPostgresMCP`'s version pin, and add an AC proving the seed's items equal the library's.

**Q4. Prove the rendered files in the real tools too (proposed AC5)?**
- A ⭐ Yes: agents run real Codex 0.165 + Claude Code 2.1 locally
- B No: the content gate is enough (the card's Verify)

If B: drop AC5 and Task 5; README says the files are checked by the copied client renderers only.

**Q5. This desktop has no Linux Go, golangci-lint or govulncheck, and `docker` is not available inside Ubuntu (WSL), so there is no `leorna-test-pg`. How do the gates run?**
- A ⭐ Agent installs Go + CI tools; you turn on Docker in WSL
- B Agent installs Go + CI tools; skip local Postgres (CI runs it)
- C Build on the Mac instead

"Turn on Docker in WSL" = Docker Desktop → Settings → Resources → WSL integration → enable for Ubuntu (one switch, once). If B: Postgres tests are reported NOT RUN locally with the reason, the catalog screenshots for AC2/AC3 become owed, and nothing else changes. If C: paths, Chrome and the capture recipe change to the Mac ones in the `leorna` skill.

**Q6. Headless Chrome renders pages here but no screenshot came back inside the agent sandbox (planner probes, below). If the builder's capture check also fails:**
- A ⭐ You allow Chrome-only capture runs outside the sandbox
- B Attach logs now; screenshots owed until fixed
- C Take the screenshots on the Mac

## Acceptance criteria

AC1–AC3 are the card's own criteria, word for word. AC4 and AC5 are proposed. No AC is `(live)`: agents can run every check.

- AC1: Given each MCP template, then secrets are never embedded (supplied via the user's environment) and gitleaks passes. Test: `TestAC1_MCPTemplatesTakeSecretsOnlyFromTheEngineersEnvironment`
  - Command: `go test -v -count=1 -run '^TestAC1_MCPTemplatesTakeSecretsOnlyFromTheEngineersEnvironment$' ./internal/library/gate/` with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks` (8.30.1, same as CI).
  - Proves: every shipped template passes the gate with real gitleaks; every credential-like `env`/header value is `${VAR}` (or `Bearer ${VAR}`); the item's `example.md` names each variable the engineer must set; a written-in credential, a password in the URL or a plain `http://` URL fails the new `policy` stage without repeating the value; a token-shaped secret fails both the policy and gitleaks.
- AC2: Given each tool config, then defaults are conservative (least-privilege permissions) and documented. Test: `TestAC2_ToolConfigsAreLeastPrivilegeAndDocumented`
  - Command: `go test -v -count=1 -run '^TestAC2_ToolConfigsAreLeastPrivilegeAndDocumented$' ./internal/library/gate/`
  - Proves: the rendered Claude Code settings pre-approve nothing, keep bypass and auto modes off and deny the six baseline rules; the rendered Codex config uses `on-request`, `workspace-write`, no sandbox network, no prompt history; each shipped config's `example.md` (the catalog's Example) names every setting it sets; nine looser configs and one Cursor config each fail the policy for that tool.
- AC3: Given each template, then its supported tools are declared and verified. Test: `TestAC3_TemplatesDeclareExactlyTheToolsTheyAreVerifiedFor`
  - Command: `go test -v -count=1 -run '^TestAC3_TemplatesDeclareExactlyTheToolsTheyAreVerifiedFor$' ./internal/library/gate/`
  - Proves: the shipped GitHub template declares Claude Code, Codex and Cursor and each renders it whole and reads `GITHUB_PERSONAL_ACCESS_TOKEN`; a template whose tools read different variables (today's 2.0.0 body) fails for Codex; a declared tool that drops part of a template fails; a postgres-style template that leaves Codex out passes and the report says why; a template that works in a tool it does not declare fails.
- AC4 (proposed): Given each MCP template, then it runs no unpinned code on the engineer's machine: github-mcp uses GitHub's hosted read-only server, and a local server must run `npx` with an exact package version. Test: `TestAC4_TemplatesRunNoUnpinnedCode`
  - Command: `go test -v -count=1 -run '^TestAC4_TemplatesRunNoUnpinnedCode$' ./internal/library/gate/`
  - This is PR #92's "github-mcp npx pin" follow-up (decision below).
- AC5 (proposed): Given the shipped configs and GitHub template rendered as the desktop client renders them, then real Codex 0.165 and Claude Code 2.1 load them from throwaway homes: Codex shows GitHub's read-only server with the token variable and a network-less workspace sandbox, and Claude Code accepts the settings and asks for `GITHUB_PERSONAL_ACCESS_TOKEN` from the environment. Test: `TestAC5_RealCodexAndClaudeCodeLoadTheShippedFiles`
  - Command: `LEORNA_TEST_CODEX_BIN="$(command -v codex)" LEORNA_TEST_CLAUDE_BIN="$HOME/.local/bin/claude" go test -v -count=1 -run '^TestAC5_RealCodexAndClaudeCodeLoadTheShippedFiles$' ./internal/library/gate/` (skips without both variables, so CI skips it; the verifier and auditor must set them). Cursor is not installed on this machine: its real-tool check is NOT VERIFIED and the PR says so.

Base-commit check (for the verifier and auditor): base = `git -C <worktree> merge-base HEAD origin/main` (expected `1ee7157`). AC1–AC4: copy `internal/library/gate/policy_test.go` and `internal/library/gate/shipped_test.go`; on base they fail to build (`StagePolicy` and the policy code are new), which counts. AC5: copy `internal/library/gate/realtools_test.go` and `internal/library/gate/shipped_test.go`; on base they build and fail by assertion (Codex sees the old `npx` stdio server; Claude Code asks for `GITHUB_TOKEN`).

## Playback

Make the content library's MCP template and tool configs safe by default and prove it with tests the CI gate runs. Today the library ships one MCP template (`github-mcp`) and two configs (`claude-code-settings`, `codex-defaults`). A postgres template was removed earlier because Codex could not use it, so the library must record which tools each template supports, and the content quality gate must verify those claims. Secrets never live in the content (each engineer's own environment supplies them) and gitleaks must pass. Config defaults must be least-privilege and documented. Decide whether PR #92's "github-mcp npx pin" follow-up belongs here (it does: AC4).

## Current state (evidence)

- **Content** (`internal/library/content/`, embedded by `//go:embed all:content`, `internal/library/source.go:44`), library `0.5.0` (`library.json`):
  - `items/mcp_template/github-mcp/` 2.0.0: `body.md:4-6` runs `"command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"]` (no version) with `"env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"}`; `item.json:8-12` declares `claude-code`, `codex`, `cursor`.
  - `items/config/claude-code-settings/` 1.0.0: `body.md` allows `Bash(go test:*)` and `Bash(make check)` without asking (both run arbitrary repo code) and denies only `Bash(git push --force:*)`. Its `example.md` is one sentence; no setting is explained.
  - `items/config/codex-defaults/` 1.1.0: `approval_policy = "on-request"`, `sandbox_mode = "workspace-write"`, `[history] persistence = "save-all"`. One-sentence `example.md`.
- **Where admins see it:** the catalog item page shows "Supported tools" chips from `tools` and the rendered `example.md` as "Example" (`internal/web/library.go:166,270,273`); the catalog filters by tool (`?tool=codex`, `internal/web/library.go:234`). So `tools` and `example.md` are the declaration and the documentation admins read.
- **How it is validated today:** `library.Parse` checks the schema (`internal/library/library.go:178-260`); `make library-check` runs `cmd/library-gate` (CI step "Check content library quality", `.github/workflows/ci.yml:106-107`), which renders each item for all three tools with copies of the client transformers (`internal/library/render/`) and fails only when a **declared** tool fails to render (`internal/library/gate/gate.go:159`), plus a gitleaks scan of sources and rendered files with default rules (`gate/scan.go`). Warnings (a tool silently dropping part of an item) never fail (`internal/library/README.md:130-136`). There are no rules about literal credentials, pinned launchers, permissive config values or cross-tool consistency.
- **A live cross-tool bug in the shipped template:** the Codex renderer forwards an env variable **under the env key's name** (`internal/library/render/codex.go:121,145`: `env_vars = ["GITHUB_PERSONAL_ACCESS_TOKEN"]`), while Claude Code keeps `${GITHUB_TOKEN}` and Cursor writes `${env:GITHUB_TOKEN}` (`render/claudecode.go:116`, `render/cursor.go:111-117`). So with github-mcp 2.0.0, Claude Code and Cursor read `GITHUB_TOKEN` and Codex reads `GITHUB_PERSONAL_ACCESS_TOKEN`. The gate passes it, because each tool "renders". The integration tiles already refuse exactly this (`internal/integration/tile.go:378-381`: "Codex forwards a variable under the env key's own name") and literal credentials (`tile.go:143`, `secretKey`).
- **The postgres template:** removed by Yan in `22de93f` "fix(packs): remove incompatible postgres MCP" (2026-10-05, landed with PR #81's era). Its body was `npx -y @modelcontextprotocol/server-postgres ${DATABASE_URL}`; Codex cannot put a variable in `args` (`render/codex.go:96-103`), proven by `TestTransformRejectsWhatTheClientRejects` case "codex: placeholder in args (client)" (`render/render_test.go:363-364`) and pinned out of the seed by `TestDefaultSeedExcludesPostgresMCP` (`internal/pack/seed_test.go:31`). Both upstream npm packages are now deprecated (`npm view … deprecated`: "Package no longer supported", 2026-10-28).
- **The starter seed** (`internal/pack/seed.json`, version 1.2.0) carries its own copies of github-mcp 2.0.0 and both configs (`seed.json:42-60`); it is separate from the library and owned by 86bcm901r (9019 decision F).
- **GitHub's hosted MCP server** (official docs, fetched 2026-10-28): `https://api.githubcopilot.com/mcp/`; "Add `/readonly` to the end of any URL to restrict the tools … to only those that enable read access"; Claude Code uses `Authorization: Bearer <PAT>`; Codex uses `url` + `bearer_token_env_var`. The control plane's GitHub tile already renders this server for all three tools (`internal/integration/tiles/github.json`, goldens `render/testdata/client/golden/integrations/github--github-com/`).
- **Real tools on this desktop** (planner probes in a scratch home, 2026-10-28): Codex `codex-cli 0.165.0` and Claude Code `2.1.312`. Codex 0.165 **refuses `approval_policy = "untrusted"`** ("is no longer supported; remove this setting") and silently ignores unknown keys; `CODEX_HOME=<scratch> codex mcp get github --json` printed `transport.type "streamable_http"`, the `/mcp/readonly` URL and `bearer_token_env_var "GITHUB_PERSONAL_ACCESS_TOKEN"` for the planned body; `codex debug prompt-input` printed "`sandbox_mode` is `workspace-write` … Network access is restricted" for the planned config. `claude doctor` (throwaway HOME) accepted the planned settings with no "Invalid settings" line for them, flagged a broken one (`settings.json › permissions.allow: Expected array`), and reported `.mcp.json › mcpServers.github: Missing environment variables: GITHUB_PERSONAL_ACCESS_TOKEN`.
- **Machine:** no Linux Go (Windows has one under `/mnt/c`, not usable), no golangci-lint or govulncheck, `docker` not integrated into Ubuntu; gitleaks 8.30.1 at `/usr/local/bin/gitleaks`; Node 22 and Chrome for Testing 156 at `~/.cache/chrome-for-testing/chrome-linux64/chrome` (needs `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`). In the planner's sandbox `--dump-dom` worked but `--screenshot` and a CDP `Page.captureScreenshot` both hung (30–60 s); running outside the sandbox was denied by auto mode. Another session's Chrome on this machine runs with `--headless=new --remote-debugging-port=0 --ozone-platform=headless --use-angle=swiftshader-webgl`.

## Approach and decisions

1. **One new gate stage, `policy`, in a new file `internal/library/gate/policy.go`,** called from `gate.Run` for every item. It applies only to `mcp_template` and `config` items and checks both the source and **what each tool receives** (the rendered files), so a rule can't be passed by a body a tool would rewrite. Each problem is a `Failure{Stage: "policy"}` (with `Tool` when it is one tool's problem) and prints as `FAIL <item>[ <tool>]: policy: <reason>`. Reasons never repeat a value.
   - **Rule S, secrets (AC1):** in a template, an `env` key or header whose name matches the tiles' credential pattern holds only `${VAR}` (header: or `Bearer ${VAR}`); a server `url` is `https://` with a host and no user info. gitleaks still scans everything.
   - **Rule V, verified tools (AC3):** a tool is *verified* for a template when it renders the template with no warnings and, for every server, reads exactly the variables the template names (Claude Code: `${VAR}` in its `.mcp.json`; Cursor: `${env:VAR}` in `mcp.json`; Codex: `env_vars`, `bearer_token_env_var` and `env_http_headers` in `config.toml`). `tools` must list exactly the verified tools: a declared tool that is not verified fails, and an undeclared tool that is verified fails ("add it to tools"). A declared tool whose render failed is already reported by the render stage.
   - **Rule P, pinned launchers (AC4):** a stdio server's `command` must be `npx`, and its first non-flag argument must be `name@MAJOR.MINOR.PATCH` (optional prerelease). Any other command fails until the policy adds it with a test (fail closed). npm never reuses a published version, so a pin always runs the same top-level package (its dependencies still resolve at install: see Risks).
   - **Rule L, least-privilege floor for configs (AC2):** per declared tool, on the rendered file. Claude Code `.claude/settings.json`: no `permissions.allow` entries, no `permissions.additionalDirectories`, `permissions.defaultMode` (if set) only `default`, `plan` or `dontAsk`, no credential-like key in `env`. Codex `config.toml`: `approval_policy` (if set) only `on-request`; `sandbox_mode` (if set) only `workspace-write` or `read-only`; `sandbox_workspace_write.network_access` not `true`; no `sandbox_workspace_write.writable_roots`; no `mcp_servers` (servers belong in templates, where rules S/V/P apply). Cursor: any declared Cursor config fails ("no least-privilege rules for cursor configs yet") until rules exist.
   - The floor forbids loosening; the AC2 test pins the shipped baseline (what must be on) and the documentation. Documentation stays a content test rather than a gate rule so the 901u gate fixtures don't all need prose.
   - 901u's rule "warnings never fail" stays for skills, prompts and configs; for templates, a warning on a declared tool now fails (rule V). README says so.
   - The credential pattern is duplicated from `internal/integration/tile.go:143` with a comment naming it (exporting it would change another module; listed as a follow-up).
2. **Content (Q1 A, Q2 A):** github-mcp 3.0.0 = GitHub's hosted read-only server; claude-code-settings 2.0.0 and codex-defaults 2.0.0 = least-privilege baselines; each `example.md` documents every setting and how to loosen it; library `0.6.0`; three new lines in `content.lock.json`. The variable becomes `GITHUB_PERSONAL_ACCESS_TOKEN` (the tile's and GitHub's name, and a dedicated read-only token instead of a broad `GITHUB_TOKEN` an engineer may already hold): engineers must set it, so github-mcp is a major bump.
3. **npx pin decision:** it belongs in this card. The card asks for "vetted" templates "secure by default", and PR #92's own ruling says auto-running config gets a pin. Pinning the current package is not vetting (deprecated, no fixes), so Q1 A removes the local code entirely and rule P keeps any future local server pinned. AC4 proves both.
4. **Compatibility record:** `tools` is the declaration; rule V verifies it on every CI run; the gate's job summary already shows one row per item and one column per tool with the reason a tool fails; the README gets a table of the shipped template/configs and the removed postgres-mcp with its reason, each row citing its test.
5. **No change** to `internal/library/render/*` (must stay identical to the client), OpenAPI, migrations, the seed (Q3 A), `THIRD_PARTY_NOTICES.md` (no upstream content; GitHub's hosted server isn't shipped code), CI workflows, or the Makefile.

## Tasks (test-first; builder does them in order)

Estimate: 3–4 h of focused work plus tool installs (≈20 min) and gate runs (≈15 min each). Commits `feat(86bcm901j): …` / `test(86bcm901j): …` / `docs(86bcm901j): …`, as the repo's identity (never override), no AI attribution lines, `CLAUDE.md` never staged.

### Task 0: Start (prerequisites, ≤40 min; stop and report on any failure)

1. Worktree and base: in `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, `git status --porcelain` empty, branch `feat/86bcm901j-mcp-templates`, HEAD `1ee7157`. Fetch a fresh main over HTTPS through gh (`git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`), check `git rev-parse origin/main` equals `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`. If main moved past `1ee7157`, list `git diff --name-only 1ee7157 origin/main`; if any path below under "Parts it touches" changed, stop and report; otherwise rebase onto it before the first commit. Never touch the main checkout's branch or the sibling stories' worktrees, branches, databases or evidence.
2. Tools (Q5 A), task-local, nothing added to any profile or global PATH. Shared folder `TOOLS=$HOME/.local/leorna-tools` (sibling stories may reuse it): take a lock with `mkdir "$TOOLS/.install-lock"` (wait and re-check if it exists), install only what is missing, verify, then `rmdir` the lock.
   - Go 1.27.3 (`go.work`): download `https://go.dev/dl/go1.27.3.linux-amd64.tar.gz`, verify its SHA-256 against `https://go.dev/dl/?mode=json&include=all` (`files[].sha256` for that filename) with `sha256sum --check --strict`, extract to `$TOOLS/go`. Check `$TOOLS/go/bin/go version` = `go1.27.3 linux/amd64`.
   - golangci-lint 2.14.0: CI's exact archive and checksum (`.github/workflows/ci.yml:124-131`, `GOLANGCI_LINT_SHA256=ab90aeb7…032ab`), extract to `$TOOLS/`, binary `$TOOLS/golangci-lint-2.14.0-linux-amd64/golangci-lint`; check `--version`.
   - govulncheck v1.7.0: `GOBIN=$TOOLS/bin GOTOOLCHAIN=local $TOOLS/go/bin/go install golang.org/x/vuln/cmd/govulncheck@v1.7.0`.
   - gitleaks: use `/usr/local/bin/gitleaks` after checking `gitleaks version` = `8.30.1` (CI's version).
   - Every Go command in this story runs with `PATH="$TOOLS/go/bin:$PATH" GOTOOLCHAIN=local`.
3. Postgres (Q5 A): if `docker version` works in Ubuntu, reuse or start the shared container (`docker ps -a --filter name=^leorna-test-pg$`): create it only if missing with CI's image `mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f`, user `leorna`, db `leorna_test`, the CI-only password from `.github/workflows/ci.yml:30`, bound to `127.0.0.1:5432`. Create **this story's database `leorna_86bcm901j_test`** (`docker exec leorna-test-pg createdb -U leorna leorna_86bcm901j_test`, only if missing). Its name ends in `_test`, which the fixtures' reset guard requires (`internal/store/postgres/store_test.go:496`, `internal/web/teams_test.go:51`). Later roles use their own: `leorna_86bcm901j_review1_test`, `_fix1_test`, `_review2_test`, `_fix2_test`, `_verify<n>_test`, `_audit<n>_test`, `_demo_test` (catalog screenshots), `_pr_test`. Never drop or share another story's database. Read the password into a variable from the CI file; abort if it is empty (an empty password fails every Postgres test with SQLSTATE 28P01). If docker is not available, record "Postgres: NOT RUN (docker not available in WSL)" and continue (Q5 B behaviour).
4. Screenshot check (Task E0 below) before writing code, so a capture blocker surfaces early.
5. Baseline: `go test -count=1 ./internal/library/... ./cmd/library-gate/...` on the untouched HEAD (with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`) → `evidence/86bcm901j/baseline-1ee7157.txt`, so later failures are compared by test name.

### Task 1: Test helpers for the shipped library (new file `internal/library/gate/shipped_test.go`)

```go
package gate

import (
	"os"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/render"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

const (
	// shippedLibrary is the content the control plane embeds.
	shippedLibrary = "../content"
	// The shipped GitHub template's address and token variable (AC3, AC4, AC5).
	readOnlyGitHub = "https://api.githubcopilot.com/mcp/readonly"
	githubToken    = "GITHUB_PERSONAL_ACCESS_TOKEN"
)

func parseShipped(t *testing.T) library.Library {
	t.Helper()
	lib, err := library.Parse(os.DirFS(shippedLibrary))
	if err != nil {
		t.Fatalf("parse the shipped library: %v", err)
	}
	return lib
}

func shippedItem(t *testing.T, kind pack.Kind, name string) library.Item {
	t.Helper()
	for _, item := range parseShipped(t).Items {
		if item.Kind == kind && item.Name == name {
			return item
		}
	}
	t.Fatalf("the shipped library has no %s/%s", kind, name)
	return library.Item{}
}

// renderShipped renders items together for one tool, as the desktop client renders a pack.
func renderShipped(t *testing.T, tool library.Tool, items ...library.Item) map[string][]byte {
	t.Helper()
	packItems := make([]render.Item, 0, len(items))
	for _, item := range items {
		packItems = append(packItems, render.FromLibrary(item))
	}
	bundle, err := render.Transform(tool, render.Pack{Name: "shipped", Version: "1.0.0", Items: packItems})
	if err != nil {
		t.Fatalf("render for %s: %v", tool, err)
	}
	return bundle.Files
}
```

### Task 2: RED, the four policy AC tests (new file `internal/library/gate/policy_test.go`)

Write all four tests now; run each and record the RED reason (`undefined: StagePolicy` etc. is a build failure at first; after Task 3 the shipped-content subtests must still fail until Task 4). Keep every name and assertion; fix only compile slips.

```go
package gate

import (
	"context"
	"encoding/json"
	"os"
	"regexp"
	"slices"
	"sort"
	"strings"
	"testing"

	"github.com/BurntSushi/toml"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

const (
	sampleTemplate    = "items/mcp_template/github-mcp/body.md"
	sampleTemplateKey = "mcp_template/github-mcp@1.0.0"
)

// Written here, independent of policy.go: what a reference looks like.
var (
	testCredential = regexp.MustCompile(`(?i)(token|secret|password|passwd|api[_-]?key|authorization|credential)`)
	testReference  = regexp.MustCompile(`^\$\{[A-Za-z_][A-Za-z0-9_]*\}$`)
	testBearer     = regexp.MustCompile(`^Bearer \$\{[A-Za-z_][A-Za-z0-9_]*\}$`)
	testVariable   = regexp.MustCompile(`\$\{([A-Za-z_][A-Za-z0-9_]*)\}`)
)

// The deny rules the shipped Claude Code settings keep.
var baselineClaudeDeny = []string{
	"Bash(git push --force:*)", "Bash(git push -f:*)",
	"Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)", "Read(~/.ssh/**)",
}

func policyFailures(report Report) []Failure {
	var out []Failure
	for _, failure := range report.Failures {
		if failure.Stage == StagePolicy {
			out = append(out, failure)
		}
	}
	return out
}

// onlyPolicyFailure requires exactly one failure: a policy failure for item and
// tool whose reason contains want.
func onlyPolicyFailure(t *testing.T, report Report, item string, tool library.Tool, want string) Failure {
	t.Helper()
	if report.Passed || len(report.Failures) != 1 {
		t.Fatalf("failures = %+v, want exactly one policy failure", report.Failures)
	}
	failure := report.Failures[0]
	if failure.Stage != StagePolicy || failure.Item != item || failure.Tool != tool || !strings.Contains(failure.Reason, want) {
		t.Fatalf("failure = %+v, want a policy failure for %s %q containing %q", failure, item, tool, want)
	}
	return failure
}

func TestAC1_MCPTemplatesTakeSecretsOnlyFromTheEngineersEnvironment(t *testing.T) {
	t.Run("every shipped template references its credentials, names them in its example and passes gitleaks", func(t *testing.T) {
		bin := gitleaksForTest(t)
		report, err := Run(context.Background(), os.DirFS(shippedLibrary), NewGitleaks(bin))
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if !report.Passed {
			t.Fatalf("the shipped library fails the gate: %+v", report.Failures)
		}
		templates := 0
		for _, item := range parseShipped(t).Items {
			if item.Kind != pack.KindMCPTemplate {
				continue
			}
			templates++
			if result := findItem(t, report, item.Key()); len(result.Secrets) != 0 {
				t.Errorf("%s: gitleaks found %+v", item.Key(), result.Secrets)
			}
			var document struct {
				MCPServers map[string]struct {
					Env     map[string]string `json:"env"`
					Headers map[string]string `json:"headers"`
				} `json:"mcpServers"`
			}
			if err := json.Unmarshal([]byte(item.Body), &document); err != nil || len(document.MCPServers) == 0 {
				t.Fatalf("%s is not an MCP template: %v", item.Key(), err)
			}
			for name, server := range document.MCPServers {
				for key, value := range server.Env {
					if testCredential.MatchString(key) && !testReference.MatchString(value) {
						t.Errorf("%s server %s env %s is not a ${VARIABLE} reference", item.Key(), name, key)
					}
				}
				for key, value := range server.Headers {
					if testCredential.MatchString(key) && !testReference.MatchString(value) && !testBearer.MatchString(value) {
						t.Errorf("%s server %s header %s is not a reference", item.Key(), name, key)
					}
				}
			}
			for _, match := range testVariable.FindAllStringSubmatch(item.Body, -1) {
				if !strings.Contains(item.Example, "`"+match[1]+"`") {
					t.Errorf("%s reads %s, but example.md does not tell the engineer to set it", item.Key(), match[1])
				}
			}
		}
		if templates == 0 {
			t.Fatal("the shipped library has no MCP template")
		}
	})

	for _, tc := range []struct{ name, body, want string }{
		{"a credential written into env", `{"mcpServers":{"api":{"command":"npx","args":["-y","api-mcp@1.0.0"],"env":{"API_TOKEN":"not-a-reference"}}}}`, `server "api" env "API_TOKEN" holds a value`},
		{"a credential written into a header", `{"mcpServers":{"api":{"url":"https://mcp.example.com/mcp","headers":{"Authorization":"Bearer not-a-reference"}}}}`, `server "api" header "Authorization" holds a value`},
		{"a password in the url", `{"mcpServers":{"api":{"url":"https://agent:not-a-reference@mcp.example.com/mcp"}}}`, `server "api" url must be https:// with no user name or password`},
		{"a plain http url", `{"mcpServers":{"api":{"url":"http://mcp.example.com/mcp"}}}`, `server "api" url must be https://`},
	} {
		t.Run(tc.name+" fails the policy without repeating the value", func(t *testing.T) {
			files := sampleLibrary()
			files[sampleTemplate] = tc.body + "\n"
			failure := onlyPolicyFailure(t, runSample(t, files), sampleTemplateKey, "", tc.want)
			if strings.Contains(failure.Reason, "not-a-reference") {
				t.Fatalf("the reason repeats the value: %s", failure.Reason)
			}
		})
	}

	t.Run("a real-looking token fails the policy and the secret scan", func(t *testing.T) {
		bin := gitleaksForTest(t)
		token := fakeGitHubToken()
		files := sampleLibrary()
		files[sampleTemplate] = `{"mcpServers":{"github":{"url":"` + readOnlyGitHub + `","headers":{"Authorization":"Bearer ` + token + `"}}}}` + "\n"
		report, err := Run(context.Background(), writeLibrary(t, files), NewGitleaks(bin))
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		var policy, secret bool
		for _, failure := range report.Failures {
			policy = policy || failure.Stage == StagePolicy && failure.Item == sampleTemplateKey && strings.Contains(failure.Reason, `header "Authorization" holds a value`)
			secret = secret || failure.Stage == StageSecrets && failure.Item == sampleTemplateKey && strings.HasPrefix(failure.Reason, "body.md: secret rule ")
		}
		if report.Passed || !policy || !secret {
			t.Fatalf("failures = %+v, want a policy failure and a body.md secret failure", report.Failures)
		}
		raw, err := json.Marshal(report)
		if err != nil {
			t.Fatal(err)
		}
		if strings.Contains(string(raw), token) {
			t.Fatal("the report repeats the token")
		}
	})
}

func TestAC2_ToolConfigsAreLeastPrivilegeAndDocumented(t *testing.T) {
	t.Run("Claude Code settings pre-approve nothing, keep bypass and auto modes off and deny secrets and force pushes", func(t *testing.T) {
		raw := renderShipped(t, library.ToolClaudeCode, shippedItem(t, pack.KindConfig, "claude-code-settings"))[".claude/settings.json"]
		var settings map[string]map[string]json.RawMessage
		if err := json.Unmarshal(raw, &settings); err != nil {
			t.Fatalf(".claude/settings.json: %v", err)
		}
		permissions := settings["permissions"]
		if len(settings) != 1 || permissions == nil {
			t.Fatalf("settings = %s, want only permissions", raw)
		}
		for key, want := range map[string]string{"defaultMode": `"default"`, "disableBypassPermissionsMode": `"disable"`, "disableAutoMode": `"disable"`} {
			if got := string(permissions[key]); got != want {
				t.Errorf("permissions.%s = %s, want %s", key, got, want)
			}
		}
		for _, loose := range []string{"allow", "additionalDirectories"} {
			if _, present := permissions[loose]; present {
				t.Errorf("permissions.%s is set; the baseline pre-approves nothing", loose)
			}
		}
		var deny []string
		if err := json.Unmarshal(permissions["deny"], &deny); err != nil {
			t.Fatalf("permissions.deny: %v", err)
		}
		for _, rule := range baselineClaudeDeny {
			if !slices.Contains(deny, rule) {
				t.Errorf("permissions.deny is missing %s", rule)
			}
		}
	})

	t.Run("Codex sandboxes commands in the workspace without network, asks before leaving it and keeps no prompt history", func(t *testing.T) {
		raw := renderShipped(t, library.ToolCodex, shippedItem(t, pack.KindConfig, "codex-defaults"))["config.toml"]
		var config struct {
			ApprovalPolicy string `toml:"approval_policy"`
			SandboxMode    string `toml:"sandbox_mode"`
			Workspace      struct {
				NetworkAccess *bool `toml:"network_access"`
			} `toml:"sandbox_workspace_write"`
			History struct {
				Persistence string `toml:"persistence"`
			} `toml:"history"`
			MCPServers map[string]any `toml:"mcp_servers"`
		}
		if _, err := toml.Decode(string(raw), &config); err != nil {
			t.Fatalf("config.toml: %v", err)
		}
		if config.ApprovalPolicy != "on-request" || config.SandboxMode != "workspace-write" ||
			config.Workspace.NetworkAccess == nil || *config.Workspace.NetworkAccess ||
			config.History.Persistence != "none" || len(config.MCPServers) != 0 {
			t.Fatalf("config.toml =\n%s\nwant on-request, workspace-write, network_access = false, history none, no MCP servers", raw)
		}
	})

	t.Run("every shipped config names each setting it sets in its example", func(t *testing.T) {
		configs := 0
		for _, item := range parseShipped(t).Items {
			if item.Kind != pack.KindConfig {
				continue
			}
			configs++
			for _, tool := range item.Tools {
				for file, content := range renderShipped(t, tool, item) {
					for _, setting := range settingNames(t, file, content) {
						if !strings.Contains(item.Example, "`"+setting+"`") {
							t.Errorf("%s: example.md does not document %s (set in %s)", item.Key(), setting, file)
						}
					}
				}
			}
		}
		if configs == 0 {
			t.Fatal("the shipped library has no config")
		}
	})

	for _, tc := range []struct {
		name, item, body string
		tool             library.Tool
		want             string
	}{
		{"a pre-approved tool", "claude-code-settings", `{"permissions":{"allow":["Bash(go test:*)"]}}`, library.ToolClaudeCode, `permissions.allow pre-approves "Bash(go test:*)"`},
		{"a mode that skips questions", "claude-code-settings", `{"permissions":{"defaultMode":"acceptEdits"}}`, library.ToolClaudeCode, `permissions.defaultMode "acceptEdits"`},
		{"an extra folder", "claude-code-settings", `{"permissions":{"additionalDirectories":["../shared"]}}`, library.ToolClaudeCode, "permissions.additionalDirectories"},
		{"a credential in the settings", "claude-code-settings", `{"env":{"ANTHROPIC_API_KEY":"not-a-reference"}}`, library.ToolClaudeCode, `env "ANTHROPIC_API_KEY" sets a credential`},
		{"approval never", "codex-defaults", `approval_policy = "never"`, library.ToolCodex, `approval_policy "never"`},
		{"no sandbox", "codex-defaults", `sandbox_mode = "danger-full-access"`, library.ToolCodex, `sandbox_mode "danger-full-access"`},
		{"network in the sandbox", "codex-defaults", "[sandbox_workspace_write]\nnetwork_access = true", library.ToolCodex, "sandbox_workspace_write.network_access is true"},
		{"extra writable folders", "codex-defaults", "[sandbox_workspace_write]\nwritable_roots = [\"/\"]", library.ToolCodex, "sandbox_workspace_write.writable_roots"},
		{"an MCP server in a config", "codex-defaults", "[mcp_servers.api]\ncommand = \"api-mcp\"", library.ToolCodex, "declares MCP servers"},
	} {
		t.Run(tc.name+" fails the policy for "+string(tc.tool), func(t *testing.T) {
			files := sampleLibrary()
			files["items/config/"+tc.item+"/body.md"] = tc.body + "\n"
			onlyPolicyFailure(t, runSample(t, files), "config/"+tc.item+"@1.0.0", tc.tool, tc.want)
		})
	}

	t.Run("a Cursor config fails until Cursor has least-privilege rules", func(t *testing.T) {
		files := sampleLibrary()
		files["items/config/cursor-cli/item.json"] = `{"version":"1.0.0","category":"testing","tags":["gate"],"tools":["cursor"],"description":"Gate test item."}`
		files["items/config/cursor-cli/body.md"] = `{"permissions":{"deny":["Shell(rm)"]}}` + "\n"
		files["items/config/cursor-cli/example.md"] = "Copy into cli-config.json.\n"
		onlyPolicyFailure(t, runSample(t, files), "config/cursor-cli@1.0.0", library.ToolCursor, "no least-privilege rules for cursor configs")
	})
}

// settingNames lists what a rendered config sets: the dotted path of every value
// and every string in a list (each permission rule is a setting of its own).
func settingNames(t *testing.T, file string, content []byte) []string {
	t.Helper()
	var document map[string]any
	var err error
	switch {
	case strings.HasSuffix(file, ".json"):
		err = json.Unmarshal(content, &document)
	case strings.HasSuffix(file, ".toml"):
		_, err = toml.Decode(string(content), &document)
	default:
		t.Fatalf("no setting reader for %s", file)
	}
	if err != nil {
		t.Fatalf("%s: %v", file, err)
	}
	var names []string
	var walk func(prefix string, value any)
	walk = func(prefix string, value any) {
		switch typed := value.(type) {
		case map[string]any:
			for key, inner := range typed {
				path := key
				if prefix != "" {
					path = prefix + "." + key
				}
				walk(path, inner)
			}
		case []any:
			names = append(names, prefix)
			for _, entry := range typed {
				if text, ok := entry.(string); ok {
					names = append(names, text)
				}
			}
		default:
			names = append(names, prefix)
		}
	}
	walk("", document)
	sort.Strings(names)
	return names
}

func TestAC3_TemplatesDeclareExactlyTheToolsTheyAreVerifiedFor(t *testing.T) {
	t.Run("the shipped GitHub template is verified for Claude Code, Codex and Cursor, each reading GITHUB_PERSONAL_ACCESS_TOKEN", func(t *testing.T) {
		github := shippedItem(t, pack.KindMCPTemplate, "github-mcp")
		report, err := Run(context.Background(), os.DirFS(shippedLibrary), &recordingScanner{})
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if failures := policyFailures(report); len(failures) != 0 {
			t.Fatalf("policy failures on the shipped library: %+v", failures)
		}
		want := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
		result := findItem(t, report, github.Key())
		if len(result.Tools) != len(want) {
			t.Fatalf("%s has %d tool results, want %d", github.Key(), len(result.Tools), len(want))
		}
		for index, tool := range result.Tools {
			if tool.Tool != want[index] || !tool.Declared || tool.Status != StatusRendered {
				t.Errorf("%s: declared %v, status %s, warnings %v; want declared and rendered whole", tool.Tool, tool.Declared, tool.Status, tool.Warnings)
			}
		}
		type jsonServers struct {
			MCPServers map[string]struct {
				URL     string            `json:"url"`
				Headers map[string]string `json:"headers"`
			} `json:"mcpServers"`
		}
		var claude, cursor jsonServers
		if err := json.Unmarshal(renderShipped(t, library.ToolClaudeCode, github)[".mcp.json"], &claude); err != nil {
			t.Fatalf(".mcp.json: %v", err)
		}
		if err := json.Unmarshal(renderShipped(t, library.ToolCursor, github)["mcp.json"], &cursor); err != nil {
			t.Fatalf("mcp.json: %v", err)
		}
		var codex struct {
			MCPServers map[string]struct {
				URL    string `toml:"url"`
				Bearer string `toml:"bearer_token_env_var"`
			} `toml:"mcp_servers"`
		}
		if _, err := toml.Decode(string(renderShipped(t, library.ToolCodex, github)["config.toml"]), &codex); err != nil {
			t.Fatalf("config.toml: %v", err)
		}
		if got := claude.MCPServers["github"]; got.URL != readOnlyGitHub || got.Headers["Authorization"] != "Bearer ${"+githubToken+"}" {
			t.Errorf("Claude Code gets %+v", got)
		}
		if got := cursor.MCPServers["github"]; got.URL != readOnlyGitHub || got.Headers["Authorization"] != "Bearer ${env:"+githubToken+"}" {
			t.Errorf("Cursor gets %+v", got)
		}
		if got := codex.MCPServers["github"]; got.URL != readOnlyGitHub || got.Bearer != githubToken {
			t.Errorf("Codex gets %+v", got)
		}
	})

	t.Run("a tool that reads a different variable from the others fails for that tool", func(t *testing.T) {
		files := sampleLibrary()
		// github-mcp 2.0.0, pinned: Claude Code and Cursor read GITHUB_TOKEN; Codex forwards GITHUB_PERSONAL_ACCESS_TOKEN.
		files[sampleTemplate] = `{"mcpServers":{"github":{"command":"npx","args":["-y","@modelcontextprotocol/server-github@2025.4.8"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":"${GITHUB_TOKEN}"}}}}` + "\n"
		onlyPolicyFailure(t, runSample(t, files), sampleTemplateKey, library.ToolCodex,
			`codex reads GITHUB_PERSONAL_ACCESS_TOKEN for server "github", but the template names GITHUB_TOKEN`)
	})

	t.Run("a declared tool that drops part of the template fails", func(t *testing.T) {
		files := sampleLibrary()
		files[sampleTemplate] = `{"mcpServers":{"api":{"url":"https://mcp.example.com/mcp","timeout":30}}}` + "\n"
		files["items/mcp_template/github-mcp/item.json"] = strings.Replace(files["items/mcp_template/github-mcp/item.json"], `["claude-code","codex","cursor"]`, `["claude-code"]`, 1)
		onlyPolicyFailure(t, runSample(t, files), sampleTemplateKey, library.ToolClaudeCode, "claude-code drops part of the template")
	})

	t.Run("a template that leaves out the tool it cannot work in passes and the report says why", func(t *testing.T) {
		files := sampleLibrary()
		// Like postgres-mcp (removed in 22de93f): a ${DATABASE_URL} argument, which Codex cannot express.
		files[sampleTemplate] = `{"mcpServers":{"postgres":{"command":"npx","args":["-y","@example/postgres-mcp@1.0.0","${DATABASE_URL}"]}}}` + "\n"
		files["items/mcp_template/github-mcp/item.json"] = strings.Replace(files["items/mcp_template/github-mcp/item.json"], `["claude-code","codex","cursor"]`, `["claude-code","cursor"]`, 1)
		report := runSample(t, files)
		if !report.Passed {
			t.Fatalf("failures = %+v, want a pass", report.Failures)
		}
		codex := findItem(t, report, sampleTemplateKey).Tools[1]
		if codex.Tool != library.ToolCodex || codex.Declared || codex.Status != StatusFailed ||
			!strings.Contains(codex.Reason, "has a placeholder in its args, which Codex cannot express") {
			t.Fatalf("codex result = %+v, want undeclared and failed with the args reason", codex)
		}
	})

	t.Run("a template that works in a tool it does not declare fails", func(t *testing.T) {
		files := sampleLibrary()
		files["items/mcp_template/github-mcp/item.json"] = strings.Replace(files["items/mcp_template/github-mcp/item.json"], `["claude-code","codex","cursor"]`, `["claude-code","codex"]`, 1)
		onlyPolicyFailure(t, runSample(t, files), sampleTemplateKey, library.ToolCursor, "works in cursor but tools does not list it")
	})
}

func TestAC4_TemplatesRunNoUnpinnedCode(t *testing.T) {
	t.Run("the shipped GitHub template uses GitHub's hosted read-only server and runs nothing on the engineer's machine", func(t *testing.T) {
		var document struct {
			MCPServers map[string]map[string]json.RawMessage `json:"mcpServers"`
		}
		if err := json.Unmarshal([]byte(shippedItem(t, pack.KindMCPTemplate, "github-mcp").Body), &document); err != nil {
			t.Fatal(err)
		}
		server, ok := document.MCPServers["github"]
		if len(document.MCPServers) != 1 || !ok {
			t.Fatalf("servers = %v, want only github", document.MCPServers)
		}
		if _, local := server["command"]; local || server["args"] != nil || string(server["url"]) != `"`+readOnlyGitHub+`"` {
			t.Fatalf("github server = %v, want url %s and no command or args", document.MCPServers, readOnlyGitHub)
		}
		report, err := Run(context.Background(), os.DirFS(shippedLibrary), &recordingScanner{})
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if failures := policyFailures(report); len(failures) != 0 {
			t.Fatalf("policy failures on the shipped library: %+v", failures)
		}
	})

	for _, tc := range []struct{ name, server, want string }{
		{"npx without a version", `{"command":"npx","args":["-y","@modelcontextprotocol/server-github"]}`, `runs npx package "@modelcontextprotocol/server-github" without an exact version`},
		{"npx at latest", `{"command":"npx","args":["-y","api-mcp@latest"]}`, `runs npx package "api-mcp@latest" without an exact version`},
		{"npx with a version range", `{"command":"npx","args":["-y","api-mcp@^1.2.0"]}`, `runs npx package "api-mcp@^1.2.0" without an exact version`},
		{"a container image", `{"command":"docker","args":["run","-i","--rm","ghcr.io/github/github-mcp-server"]}`, `runs "docker"; only npx with an exact package version is a reviewed launcher`},
		{"a program already on the machine", `{"command":"github-mcp-server","args":["stdio"]}`, `runs "github-mcp-server"; only npx`},
	} {
		t.Run(tc.name+" fails the policy", func(t *testing.T) {
			files := sampleLibrary()
			files[sampleTemplate] = `{"mcpServers":{"api":` + tc.server + `}}` + "\n"
			onlyPolicyFailure(t, runSample(t, files), sampleTemplateKey, "", tc.want)
		})
	}

	t.Run("npx with an exact version passes", func(t *testing.T) {
		for _, spec := range []string{"api-mcp@1.2.3", "@scope/api-mcp@1.2.3-beta.1"} {
			files := sampleLibrary()
			files[sampleTemplate] = `{"mcpServers":{"api":{"command":"npx","args":["-y","` + spec + `"]}}}` + "\n"
			if report := runSample(t, files); !report.Passed {
				t.Errorf("%s: failures %+v", spec, report.Failures)
			}
		}
	})
}
```

### Task 3: GREEN, the policy stage (new `internal/library/gate/policy.go`, hook in `gate.go`)

1. `gate.go`: in `Run`'s per-item loop (`gate.go:151-167`), after the render-failure loop and before the secrets loop, add:
   ```go
   		for _, failure := range checkPolicy(lib.Items[index], item.Tools, outputs[item.Key]) {
   			item.Passed = false
   			report.Failures = append(report.Failures, failure)
   		}
   ```
   (`report.Items` and `lib.Items` are built in the same order at `gate.go:136-139`.) Update the package comment to mention the policy rules for templates and configs.
2. `policy.go` (complete; keep messages exactly, the tests match them):

```go
package gate

// Story 86bcm901j: rules for MCP templates and tool configs. They check the
// template source and what each declared tool receives, so an item ships only if
// its secrets come from the engineer's environment, it runs no unpinned code, it
// works the same way in every tool it lists, and a config grants nothing a tool
// would not grant by default.

import (
	"encoding/json"
	"fmt"
	"net/url"
	"regexp"
	"sort"
	"strings"

	"github.com/BurntSushi/toml"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// StagePolicy reports a broken MCP template or tool config rule.
const StagePolicy Stage = "policy"

var (
	// credentialKey matches env keys and headers whose value is a credential. It
	// is the integration tiles' rule (internal/integration/tile.go, secretKey):
	// change both together.
	credentialKey = regexp.MustCompile(`(?i)(token|secret|password|passwd|api[_-]?key|authorization|credential)`)
	variableRef   = regexp.MustCompile(`\$\{([A-Za-z_][A-Za-z0-9_]*)\}`)
	cursorEnvRef  = regexp.MustCompile(`\$\{env:([A-Za-z_][A-Za-z0-9_]*)\}`)
	bearerRef     = regexp.MustCompile(`^Bearer \$\{[A-Za-z_][A-Za-z0-9_]*\}$`)
	// exactNPMPackage is name@MAJOR.MINOR.PATCH (optional prerelease). npm never
	// reuses a published version, so the same package runs every time.
	exactNPMPackage = regexp.MustCompile(`^(@[a-z0-9][a-z0-9._~-]*/)?[a-z0-9][a-z0-9._~-]*@(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?$`)
	// Claude Code modes that never answer a question for the engineer.
	conservativeClaudeModes = map[string]bool{"default": true, "plan": true, "dontAsk": true}
)

// templateServer is the part of an MCP server every tool renderer reads.
type templateServer struct {
	Command string            `json:"command"`
	Args    []string          `json:"args"`
	Env     map[string]string `json:"env"`
	URL     string            `json:"url"`
	Headers map[string]string `json:"headers"`
}

// templateServers decodes a template's servers. ok is false for a body no tool
// can render; the render stage reports that.
func templateServers(body string) (map[string]templateServer, bool) {
	var document struct {
		MCPServers map[string]json.RawMessage `json:"mcpServers"`
	}
	if json.Unmarshal([]byte(body), &document) != nil || len(document.MCPServers) == 0 {
		return nil, false
	}
	servers := make(map[string]templateServer, len(document.MCPServers))
	for name, raw := range document.MCPServers {
		var server templateServer
		if json.Unmarshal(raw, &server) != nil {
			return nil, false
		}
		servers[name] = server
	}
	return servers, true
}

// checkPolicy returns an item's policy failures in a stable order. tools are its
// render results in report order; rendered holds the files each tool got.
func checkPolicy(item library.Item, tools []ToolResult, rendered map[library.Tool]map[string][]byte) []Failure {
	switch item.Kind {
	case pack.KindMCPTemplate:
		return checkTemplate(item, tools, rendered)
	case pack.KindConfig:
		return checkConfig(item, tools, rendered)
	default:
		return nil
	}
}

func checkTemplate(item library.Item, tools []ToolResult, rendered map[library.Tool]map[string][]byte) []Failure {
	servers, ok := templateServers(item.Body)
	if !ok {
		return nil
	}
	var failures []Failure
	fail := func(tool library.Tool, format string, args ...any) {
		failures = append(failures, Failure{Item: item.Key(), Tool: tool, Stage: StagePolicy, Reason: fmt.Sprintf(format, args...)})
	}
	for _, name := range sortedKeys(servers) {
		server := servers[name]
		for _, key := range sortedKeys(server.Env) {
			if credentialKey.MatchString(key) && !wholeRef(server.Env[key]) {
				fail("", "server %q env %q holds a value; a credential must be ${VARIABLE}, read from the engineer's environment", name, key)
			}
		}
		for _, key := range sortedKeys(server.Headers) {
			value := server.Headers[key]
			if credentialKey.MatchString(key) && !wholeRef(value) && !bearerRef.MatchString(value) {
				fail("", "server %q header %q holds a value; a credential must be ${VARIABLE} or Bearer ${VARIABLE}, read from the engineer's environment", name, key)
			}
		}
		if server.URL != "" {
			if parsed, err := url.Parse(server.URL); err != nil || parsed.Scheme != "https" || parsed.Host == "" || parsed.User != nil {
				fail("", "server %q url must be https:// with no user name or password in it", name)
			}
		}
		if server.Command != "" {
			if problem := launcherProblem(server); problem != "" {
				fail("", "server %q %s", name, problem)
			}
		}
	}
	for _, result := range tools {
		verified, reason := templateVerdict(servers, result, rendered[result.Tool])
		switch {
		case result.Declared && !verified && reason != "":
			fail(result.Tool, "%s", reason)
		case !result.Declared && verified:
			fail(result.Tool, "works in %s but tools does not list it; add %q to tools in item.json", result.Tool, result.Tool)
		}
	}
	return failures
}

// launcherProblem explains why a stdio server could run code that is not pinned.
// npx is the one reviewed launcher; add another (uvx, docker by digest) here,
// with a test, before a template uses it.
func launcherProblem(server templateServer) string {
	if server.Command != "npx" {
		return fmt.Sprintf("runs %q; only npx with an exact package version is a reviewed launcher", server.Command)
	}
	for _, arg := range server.Args {
		if strings.HasPrefix(arg, "-") {
			continue
		}
		if !exactNPMPackage.MatchString(arg) {
			return fmt.Sprintf("runs npx package %q without an exact version (write name@MAJOR.MINOR.PATCH)", arg)
		}
		return ""
	}
	return "runs npx without a package"
}

// templateVerdict says whether a tool gets the whole template and reads exactly
// the variables the template names. reason is empty when the render stage
// already reports the tool.
func templateVerdict(servers map[string]templateServer, result ToolResult, files map[string][]byte) (bool, string) {
	switch result.Status {
	case StatusRendered:
	case StatusRenderedWithWarnings:
		return false, fmt.Sprintf("%s drops part of the template: %s", result.Tool, strings.Join(result.Warnings, "; "))
	default:
		return false, ""
	}
	got, err := renderedVariables(result.Tool, files)
	if err != nil {
		return false, err.Error()
	}
	for _, name := range sortedKeys(servers) {
		reads, present := got[name]
		if !present {
			return false, fmt.Sprintf("%s gets no server %q", result.Tool, name)
		}
		if want := serverVariables(servers[name]); strings.Join(reads, ",") != strings.Join(want, ",") {
			return false, fmt.Sprintf("%s reads %s for server %q, but the template names %s; Codex forwards an env variable under its key, so write \"KEY\": \"${KEY}\"",
				result.Tool, names(reads), name, names(want))
		}
	}
	return true, ""
}

// serverVariables lists the variables a template server names, sorted.
func serverVariables(server templateServer) []string {
	return refsIn(variableRef, server)
}

// renderedVariables lists, per server, the environment variables a tool reads.
func renderedVariables(tool library.Tool, files map[string][]byte) (map[string][]string, error) {
	switch tool {
	case library.ToolClaudeCode, library.ToolCursor:
		file, ref := ".mcp.json", variableRef
		if tool == library.ToolCursor {
			file, ref = "mcp.json", cursorEnvRef
		}
		var document struct {
			MCPServers map[string]templateServer `json:"mcpServers"`
		}
		if err := json.Unmarshal(files[file], &document); err != nil {
			return nil, fmt.Errorf("%s: %s cannot be read: %v", tool, file, err)
		}
		out := make(map[string][]string, len(document.MCPServers))
		for name, server := range document.MCPServers {
			out[name] = refsIn(ref, server)
		}
		return out, nil
	case library.ToolCodex:
		var document struct {
			MCPServers map[string]struct {
				EnvVars        []string          `toml:"env_vars"`
				BearerTokenEnv string            `toml:"bearer_token_env_var"`
				EnvHTTPHeaders map[string]string `toml:"env_http_headers"`
			} `toml:"mcp_servers"`
		}
		if _, err := toml.Decode(string(files["config.toml"]), &document); err != nil {
			return nil, fmt.Errorf("%s: config.toml cannot be read: %v", tool, err)
		}
		out := make(map[string][]string, len(document.MCPServers))
		for name, server := range document.MCPServers {
			reads := append([]string{}, server.EnvVars...)
			if server.BearerTokenEnv != "" {
				reads = append(reads, server.BearerTokenEnv)
			}
			for _, variable := range server.EnvHTTPHeaders {
				reads = append(reads, variable)
			}
			out[name] = uniqueSorted(reads)
		}
		return out, nil
	default:
		return nil, fmt.Errorf("%s: no MCP file layout is known", tool)
	}
}

// refsIn lists, sorted and unique, the variables ref finds in a server's fields.
func refsIn(ref *regexp.Regexp, server templateServer) []string {
	fields := append([]string{server.Command, server.URL}, server.Args...)
	for _, value := range server.Env {
		fields = append(fields, value)
	}
	for _, value := range server.Headers {
		fields = append(fields, value)
	}
	var found []string
	for _, field := range fields {
		for _, match := range ref.FindAllStringSubmatch(field, -1) {
			found = append(found, match[1])
		}
	}
	return uniqueSorted(found)
}

func checkConfig(item library.Item, tools []ToolResult, rendered map[library.Tool]map[string][]byte) []Failure {
	var failures []Failure
	for _, result := range tools {
		if !result.Declared || (result.Status != StatusRendered && result.Status != StatusRenderedWithWarnings) {
			continue // the render stage reports a declared tool that failed
		}
		var problems []string
		switch result.Tool {
		case library.ToolClaudeCode:
			problems = claudeSettingsProblems(rendered[result.Tool][".claude/settings.json"])
		case library.ToolCodex:
			problems = codexConfigProblems(rendered[result.Tool]["config.toml"])
		default:
			problems = []string{fmt.Sprintf("there are no least-privilege rules for %s configs yet; add them, with a test, before shipping one", result.Tool)}
		}
		for _, problem := range problems {
			failures = append(failures, Failure{Item: item.Key(), Tool: result.Tool, Stage: StagePolicy, Reason: problem})
		}
	}
	return failures
}

func claudeSettingsProblems(raw []byte) []string {
	var settings struct {
		Env         map[string]string `json:"env"`
		Permissions struct {
			Allow                 []string `json:"allow"`
			AdditionalDirectories []string `json:"additionalDirectories"`
			DefaultMode           *string  `json:"defaultMode"`
		} `json:"permissions"`
	}
	if err := json.Unmarshal(raw, &settings); err != nil {
		return []string{".claude/settings.json cannot be read: " + err.Error()}
	}
	var problems []string
	if allow := settings.Permissions.Allow; len(allow) > 0 {
		quoted := make([]string, len(allow))
		for index, rule := range allow {
			quoted[index] = fmt.Sprintf("%q", rule)
		}
		problems = append(problems, "permissions.allow pre-approves "+strings.Join(quoted, ", ")+"; a library config pre-approves nothing")
	}
	if len(settings.Permissions.AdditionalDirectories) > 0 {
		problems = append(problems, "permissions.additionalDirectories opens folders outside the project")
	}
	if mode := settings.Permissions.DefaultMode; mode != nil && !conservativeClaudeModes[*mode] {
		problems = append(problems, fmt.Sprintf("permissions.defaultMode %q answers questions for the engineer; use default, plan or dontAsk", *mode))
	}
	for _, key := range sortedKeys(settings.Env) {
		if credentialKey.MatchString(key) {
			problems = append(problems, fmt.Sprintf("env %q sets a credential; credentials stay in the engineer's own environment", key))
		}
	}
	return problems
}

func codexConfigProblems(raw []byte) []string {
	var config struct {
		ApprovalPolicy *string `toml:"approval_policy"`
		SandboxMode    *string `toml:"sandbox_mode"`
		Workspace      struct {
			NetworkAccess *bool    `toml:"network_access"`
			WritableRoots []string `toml:"writable_roots"`
		} `toml:"sandbox_workspace_write"`
		MCPServers map[string]any `toml:"mcp_servers"`
	}
	if _, err := toml.Decode(string(raw), &config); err != nil {
		return []string{"config.toml cannot be read as a least-privilege config: " + err.Error()}
	}
	var problems []string
	if policy := config.ApprovalPolicy; policy != nil && *policy != "on-request" {
		problems = append(problems, fmt.Sprintf("approval_policy %q; use \"on-request\", so Codex asks before leaving the sandbox", *policy))
	}
	if mode := config.SandboxMode; mode != nil && *mode != "workspace-write" && *mode != "read-only" {
		problems = append(problems, fmt.Sprintf("sandbox_mode %q; use \"workspace-write\" or \"read-only\"", *mode))
	}
	if network := config.Workspace.NetworkAccess; network != nil && *network {
		problems = append(problems, "sandbox_workspace_write.network_access is true; commands in the sandbox get no network")
	}
	if len(config.Workspace.WritableRoots) > 0 {
		problems = append(problems, "sandbox_workspace_write.writable_roots lets commands write outside the project")
	}
	if len(config.MCPServers) > 0 {
		problems = append(problems, "the config declares MCP servers; put them in an mcp_template item, where the template rules check them")
	}
	return problems
}

func wholeRef(value string) bool {
	match := variableRef.FindStringSubmatch(value)
	return match != nil && match[0] == value
}

func names(variables []string) string {
	if len(variables) == 0 {
		return "no variable"
	}
	return strings.Join(variables, ", ")
}

func uniqueSorted(values []string) []string {
	sort.Strings(values)
	out := values[:0]
	for index, value := range values {
		if index == 0 || value != values[index-1] {
			out = append(out, value)
		}
	}
	return out
}

func sortedKeys[V any](values map[string]V) []string {
	keys := make([]string, 0, len(values))
	for key := range values {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	return keys
}
```

   Note for the reviewer: `uniqueSorted` reuses its input's backing array; every caller passes a slice it owns. If lint flags anything (e.g. `gocritic`), fix the style, not the behaviour.
3. Run AC1–AC4: the fixture subtests pass; the shipped-content subtests still fail (old content) until Task 4. Mutation checks (restore each): drop the env credential check → AC1 fails; make `wholeRef` always true → AC1 fails; skip the `!result.Declared && verified` case → AC3 "works in a tool it does not declare" fails; skip the variable comparison → AC3 "different variable" fails; accept any npx argument → AC4 fails; drop the Codex `network_access` check → AC2 fails; remove the hook in `gate.go` → all four fail. Save a `mutations-<sha7>.txt` summary with each mutant's failing test.

### Task 4: Existing 901u tests that see the new rules (same commit as Task 3 or right after)

These fixtures break under rules L and P on purpose; change only what is listed:
- `internal/library/gate/gate_test.go` `sampleLibrary()`: `items/config/claude-code-settings/body.md` → `` `{"permissions":{"deny":["Bash(git push --force:*)"]}}` + "\n" ``; `items/mcp_template/github-mcp/body.md` → pin `"@modelcontextprotocol/server-github@2025.4.8"` (keep `"env":{"GITHUB_TOKEN":"${GITHUB_TOKEN}"}`).
- `internal/library/gate/gate_more_test.go` `TestWarningsPassAndAreReported`: body → `` `{"permissions":{"deny":["Bash(git push --force:*)"]},"vimMode":true}` + "\n" ``; expected warning unchanged.
- `cmd/library-gate/main_test.go`: `brokenArgs` → `` `{"mcpServers":{"api":{"command":"npx","args":["-y","api-mcp@1.0.0","--token","${API_TOKEN}"]}}}` `` (update its comment: pinned so only Codex's render fails); `TestRenderedFileTooBigToScanNamesItemToolAndSize`'s regex `github-mcp@2\.0\.0` → `github-mcp@[0-9.]+`.
- Run `go test -count=1 ./internal/library/... ./cmd/library-gate/...` and compare with the baseline by test name: no other test may change.

### Task 5: Content (Q1 A, Q2 A)

Write these files exactly (then `go test ./internal/library -run TestContentLock -update-lock`, which appends three lines to `internal/library/content.lock.json` and changes no existing one; check with `git diff` that only `+` lines appear apart from the comma on the line before each insert, and compare old entries by value).

`internal/library/content/library.json`: `"version": "0.6.0"`.

`items/mcp_template/github-mcp/item.json`:
```json
{
  "version": "3.0.0",
  "category": "integrations",
  "tags": [
    "github",
    "mcp",
    "read-only"
  ],
  "tools": [
    "claude-code",
    "codex",
    "cursor"
  ],
  "description": "GitHub's hosted MCP server, read-only. Each engineer's token comes from their own environment (GITHUB_PERSONAL_ACCESS_TOKEN); nothing runs on their machine."
}
```
`items/mcp_template/github-mcp/body.md`:
```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/readonly",
      "headers": {"Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"}
    }
  }
}
```
`items/mcp_template/github-mcp/example.md`:
```markdown
Ask: "List the open pull requests assigned to me."
The assistant calls GitHub's hosted MCP server with the engineer's own token.

**Set up once.** Create a fine-grained personal access token limited to the repositories you
need, with read-only access (Metadata, Contents, Issues and Pull requests: read), and keep it in
your own environment as `GITHUB_PERSONAL_ACCESS_TOKEN`. It never goes into this template, a pack
or a file Leorna writes.

**Read-only by default.** The address ends in `/readonly`, so the assistant can read repositories,
issues and pull requests but not change them. For write access, an admin forks this item and
drops `/readonly`; engineers then need a token with the write permissions they use.

**Works with**
- Claude Code: `.mcp.json` sends `Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}`; approve the project server once when Claude Code asks.
- Codex: `config.toml` sets `bearer_token_env_var = "GITHUB_PERSONAL_ACCESS_TOKEN"`.
- Cursor: `mcp.json` sends `Authorization: Bearer ${env:GITHUB_PERSONAL_ACCESS_TOKEN}`.

GitHub Enterprise Server or GHE.com: use the GitHub integration tile instead.
```
`items/config/claude-code-settings/item.json`: version `2.0.0`, tags `["claude-code", "permissions", "least-privilege"]`, tools `["claude-code"]`, description "Least-privilege Claude Code project settings: nothing is pre-approved, bypass and auto modes are off, and secret files and force pushes are denied." (same layout as today's file).

`items/config/claude-code-settings/body.md`:
```json
{
  "permissions": {
    "defaultMode": "default",
    "disableBypassPermissionsMode": "disable",
    "disableAutoMode": "disable",
    "deny": [
      "Bash(git push --force:*)",
      "Bash(git push -f:*)",
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(~/.ssh/**)"
    ]
  }
}
```
`items/config/claude-code-settings/example.md`:
```markdown
Synced into the project's `.claude/settings.json`, so Claude Code asks before it acts and never
reads secret files.

**Settings**
- `permissions.defaultMode`: `default`. Claude Code asks the first time it uses each tool; nothing is pre-approved (there is no `allow` list).
- `permissions.disableBypassPermissionsMode`: `disable`, so `--dangerously-skip-permissions` cannot turn the questions off.
- `permissions.disableAutoMode`: `disable`, so auto mode cannot approve actions without asking.
- `permissions.deny`: refused even when someone approves them.
  - `Bash(git push --force:*)` and `Bash(git push -f:*)`: no force pushes that rewrite shared history.
  - `Read(./.env)` and `Read(./.env.*)`: environment files usually hold credentials.
  - `Read(./secrets/**)`: the project's secrets folder.
  - `Read(~/.ssh/**)`: the engineer's SSH keys.

Deny rules are guard rails, not a sandbox: a command written another way can slip past a `Bash`
pattern, so the questions stay on. An engineer who wants fewer questions adds rules to their own
`.claude/settings.local.json`; an admin who wants different team defaults forks this item.
```
`items/config/codex-defaults/item.json`: version `2.0.0`, tags `["codex", "workstation", "least-privilege"]`, tools `["codex"]`, description "Least-privilege Codex CLI defaults: commands run in a workspace sandbox without network, Codex asks before leaving it, and no prompt history is kept."

`items/config/codex-defaults/body.md`:
```toml
# ~/.codex/config.toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = false

[history]
persistence = "none"
```
`items/config/codex-defaults/example.md`:
```markdown
Synced into the engineer's `~/.codex/config.toml`, so every workstation starts from the same safe
defaults.

**Settings**
- `approval_policy`: `on-request`. Codex asks before it runs a command outside the sandbox.
- `sandbox_mode`: `workspace-write`. Commands read files and write only inside the project and temporary folders.
- `sandbox_workspace_write.network_access`: `false`. Commands in the sandbox get no network, so nothing is sent anywhere without asking first.
- `history.persistence`: `none`. Codex keeps no copy of prompts in `~/.codex/history.jsonl`, where a pasted secret would stay in plain text.

Codex 0.165 refuses the older `approval_policy = "untrusted"`, so it is not used. An engineer who
wants more freedom changes their own config; an admin who wants different team defaults forks
this item.
```
Before committing, check each sentence of the two config examples against the tools' own docs (Claude Code settings/permissions reference; Codex config reference) and AC5's real output; drop any claim you cannot confirm rather than guessing. Then AC1–AC4 pass, plus `go test -count=1 ./internal/library/... ./cmd/library-gate/...`.

### Task 6: AC5, real tools (new `internal/library/gate/realtools_test.go`; skip in CI)

```go
package gate

import (
	"bytes"
	"context"
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// runTool runs a real AI tool from dir with only env (no inherited HOME, tokens
// or config) and no input.
func runTool(t *testing.T, dir string, env []string, bin string, args ...string) (string, string, error) {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
	defer cancel()
	command := exec.CommandContext(ctx, bin, args...)
	var stdout, stderr bytes.Buffer
	command.Dir, command.Env, command.Stdout, command.Stderr = dir, env, &stdout, &stderr
	err := command.Run()
	return stdout.String(), stderr.String(), err
}

func writeTree(t *testing.T, root string, files map[string][]byte) {
	t.Helper()
	for name, content := range files {
		full := filepath.Join(root, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(full), 0o700); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(full, content, 0o600); err != nil {
			t.Fatal(err)
		}
	}
}

func TestAC5_RealCodexAndClaudeCodeLoadTheShippedFiles(t *testing.T) {
	codex, claude := os.Getenv("LEORNA_TEST_CODEX_BIN"), os.Getenv("LEORNA_TEST_CLAUDE_BIN")
	if codex == "" || claude == "" {
		t.Skip("set LEORNA_TEST_CODEX_BIN and LEORNA_TEST_CLAUDE_BIN to check the rendered files with the real tools")
	}
	github := shippedItem(t, pack.KindMCPTemplate, "github-mcp")

	t.Run("Codex loads the config, lists GitHub's hosted read-only server with the token variable and sandboxes commands without network", func(t *testing.T) {
		home, project := t.TempDir(), t.TempDir()
		codexHome := filepath.Join(home, "codex")
		env := []string{"HOME=" + home, "CODEX_HOME=" + codexHome, "PATH=" + filepath.Dir(codex) + ":/usr/bin:/bin"}
		version, _, _ := runTool(t, project, env, codex, "--version")
		t.Logf("real tool: %s", strings.TrimSpace(version))
		// The check can fail: Codex refuses a setting it no longer supports.
		writeTree(t, codexHome, map[string][]byte{"config.toml": []byte("approval_policy = \"untrusted\"\n")})
		if out, errOut, err := runTool(t, project, env, codex, "mcp", "list"); err == nil || !strings.Contains(out+errOut, "failed to load configuration") {
			t.Fatalf("codex accepted a config it should refuse (err %v):\n%s%s", err, out, errOut)
		}
		writeTree(t, codexHome, map[string][]byte{"config.toml": renderShipped(t, library.ToolCodex, shippedItem(t, pack.KindConfig, "codex-defaults"), github)["config.toml"]})
		out, errOut, err := runTool(t, project, env, codex, "mcp", "get", "github", "--json")
		if err != nil {
			t.Fatalf("codex mcp get github: %v\n%s", err, errOut)
		}
		var server struct {
			Transport struct {
				Type   string `json:"type"`
				URL    string `json:"url"`
				Bearer string `json:"bearer_token_env_var"`
			} `json:"transport"`
		}
		if err := json.Unmarshal([]byte(out), &server); err != nil {
			t.Fatalf("codex mcp get github --json: %v\n%s", err, out)
		}
		if server.Transport.Type != "streamable_http" || server.Transport.URL != readOnlyGitHub || server.Transport.Bearer != githubToken {
			t.Fatalf("codex sees %+v, want streamable_http %s with bearer_token_env_var %s", server.Transport, readOnlyGitHub, githubToken)
		}
		prompt, errOut, err := runTool(t, project, env, codex, "debug", "prompt-input")
		if err != nil {
			t.Fatalf("codex debug prompt-input: %v\n%s", err, errOut)
		}
		for _, want := range []string{"`sandbox_mode` is `workspace-write`", "Network access is restricted"} {
			if !strings.Contains(prompt, want) {
				t.Errorf("codex's permissions do not say %q", want)
			}
		}
	})

	t.Run("Claude Code accepts the settings and reads the GitHub token from the engineer's environment", func(t *testing.T) {
		home, project, broken := t.TempDir(), t.TempDir(), t.TempDir()
		env := []string{"HOME=" + home, "PATH=" + filepath.Dir(claude) + ":/usr/bin:/bin", "TERM=dumb"}
		version, _, _ := runTool(t, project, env, claude, "--version")
		t.Logf("real tool: %s", strings.TrimSpace(version))
		// The check can fail: doctor names a settings file Claude Code rejects.
		writeTree(t, broken, map[string][]byte{".claude/settings.json": []byte(`{"permissions":{"allow":"not a list"}}`)})
		if out, errOut, _ := runTool(t, broken, env, claude, "doctor"); !strings.Contains(out+errOut, "settings.json ›") {
			t.Fatalf("claude doctor did not flag a broken settings file:\n%s%s", out, errOut)
		}
		writeTree(t, project, renderShipped(t, library.ToolClaudeCode, shippedItem(t, pack.KindConfig, "claude-code-settings"), github))
		out, errOut, _ := runTool(t, project, env, claude, "doctor")
		doctor := out + errOut
		if strings.Contains(doctor, "settings.json ›") {
			t.Fatalf("Claude Code rejects the shipped settings:\n%s", doctor)
		}
		if !strings.Contains(doctor, "Missing environment variables: "+githubToken) {
			t.Fatalf("Claude Code does not ask for %s from the environment:\n%s", githubToken, doctor)
		}
		out, errOut, err := runTool(t, project, env, claude, "mcp", "get", "github")
		if err != nil {
			t.Fatalf("claude mcp get github: %v\n%s", err, errOut)
		}
		for _, want := range []string{"URL: " + readOnlyGitHub, "Authorization: Bearer ${" + githubToken + "}"} {
			if !strings.Contains(out, want) {
				t.Errorf("claude mcp get github does not show %q:\n%s", want, out)
			}
		}
	})
}
```
The test never reads or writes the real `~/.codex` or `~/.claude` (every run has its own HOME). Planner probes used exactly these commands; if a tool version prints them differently, keep the assertions' meaning and adjust only the matched text, noting the version in the log.

### Task 7: Docs (README)

`internal/library/README.md`:
- "Loading": add after the 0.5.0 paragraph: "Library **0.6.0** (story 86bcm901j) replaces github-mcp's unpinned `npx` server with GitHub's hosted read-only server (3.0.0, variable `GITHUB_PERSONAL_ACCESS_TOKEN`) and ships least-privilege claude-code-settings 2.0.0 and codex-defaults 2.0.0. See [MCP templates and tool configs](#mcp-templates-and-tool-configs-86bcm901j)."
- "Quality gate (CI)": add step 5 "checks the **policy** for MCP templates and tool configs (story 86bcm901j, below)"; in "What fails CI" add "a policy problem"; change "What does not: … warnings" to say warnings still pass except on a tool an MCP template declares; add the log line form `FAIL <item>[ <tool>]: policy: <reason>`.
- New section `## MCP templates and tool configs (86bcm901j)`: the four rules (S, P, V, L) in plain words, as in "Approach" above; why the rules check rendered files; how to add a template (hosted `url` preferred; stdio only via `npx name@x.y.z`; `"KEY": "${KEY}"`; list exactly the tools the gate verifies; `example.md` names every variable); a table:

  | Item | Claude Code | Codex | Cursor |
  | --- | --- | --- | --- |
  | `mcp_template/github-mcp` 3.0.0 | `.mcp.json`, `Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}` | `config.toml`, `bearer_token_env_var` | `mcp.json`, `Bearer ${env:GITHUB_PERSONAL_ACCESS_TOKEN}` |
  | `config/claude-code-settings` 2.0.0 | `.claude/settings.json` | not declared | not declared |
  | `config/codex-defaults` 2.0.0 | not declared | `config.toml` | not declared |
  | `postgres-mcp` (removed 2026-10-05, `22de93f`) | renders | **not supported**: the connection string was a `${DATABASE_URL}` argument, and Codex cannot put a variable in `args` | renders |

  with a "Proven by" line under it naming `TestAC3_TemplatesDeclareExactlyTheToolsTheyAreVerifiedFor` and `TestAC5_RealCodexAndClaudeCodeLoadTheShippedFiles` (github-mcp, Claude Code and Codex; Cursor by the renderer only) and `TestTransformRejectsWhatTheClientRejects` case "codex: placeholder in args (client)" plus the AC3 postgres subtest (postgres row). Note that both upstream npm packages (`@modelcontextprotocol/server-github`, `server-postgres`) are deprecated, and that the starter seed still carries github-mcp 2.0.0 until 86bcm901r.
- "Verification" list: the five AC tests, the four changed 901u fixtures, and AC5's two variables.

### Task E: Evidence capture (named build task; one screenshot per AC)

Folder: `~/.hermes/plans/leorna/evidence/86bcm901j/` (builder files at the top level; verifier only in `verifier/`, auditor only in `auditor/`). Never put a server URL, token, tenant ID or email on screen; the logs hold none (the AC5 runs use empty throwaway homes and no token).

- **E0 (Task 0, before code): prove one capture.** Write a 3-line `<pre>` HTML page into your own scratch folder and capture it to PNG with Chrome for Testing (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, a throwaway `--user-data-dir` in your scratch). Try, in order, with a 60 s timeout each: (1) `--headless=new --no-sandbox --disable-gpu --hide-scrollbars --ozone-platform=headless --use-angle=swiftshader-webgl --window-size=1400,900 --screenshot=<png> file://<page>`; (2) the same flags plus `--remote-debugging-port=0` driven over CDP (`Page.navigate`, then `Page.captureScreenshot` with `captureBeyondViewport`), from a small Node 22 script (built-in `fetch` and `WebSocket`, no packages) or a scratch Go module using chromedp v0.16.0 (the repo's version). Check the PNG's first bytes (`89 50 4E 47`). After a timeout, kill only processes whose command line holds your own profile folder (`pkill -f -- "--user-data-dir=<your profile>"`); other sessions' Chrome (for example `/tmp/f2b-chrome-*`) is not yours. If nothing works in 10 minutes, stop and report "capture blocked" to the main session (Q6).
- **Per AC**, after the code is final: run the AC's command into a log with the recipe (`( set -o pipefail; echo "HEAD=$(git rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > <evidence>/ac<n>-<sha7>.log 2>&1`), render the log in a dark `<pre>` page (HTML-escaped, the command line on top) and capture:
  - `ac1-secrets-from-environment.png`, `ac2-least-privilege-configs.png`, `ac3-tools-verified.png`, `ac4-no-unpinned-code.png`, `ac5-real-codex-claude.png`. Before accepting a PNG, look at it: the command line and the `--- PASS` lines must be on screen (split a long log into `-1`/`-2` pages rather than shrinking text).
- **Demo captures (UI, for ClickUp; needs Postgres):** run the control plane locally as `leorna-control-plane-workflow.md` describes (dev mode, 127.0.0.1, placeholder `https://` public URL, random encryption key, throwaway DB `leorna_86bcm901j_demo_test`), sign in through `/dev/login?next=<encoded path>` and capture the catalog item pages: `ac2-catalog-claude-code-settings.png` and `ac2-catalog-codex-defaults.png` (Example section with every setting), `ac3-catalog-github-mcp.png` (Supported tools chips and the Example). Crop or check that no URL bar is in the frame. Without Postgres, list these three as owed; never replace them with a log capture.
- **Gate summary:** render `library-summary-<sha7>.md` (from `make library-check … LIBRARY_SUMMARY=…`) to HTML offline (goldmark from the module cache) and capture `gate-summary-<sha7>.png`, labelled a local rendering.
- **Gate logs:** `gates-<sha7>.txt` per head (plus `SUMMARY.txt` with one `label EXIT=<rc>` line per gate); open each log and read its exit code before citing it.

### Task 8: Gates (exact commands; run on the final head, logs into the evidence folder)

Run from the worktree with `TOOLS=$HOME/.local/leorna-tools`, `export PATH="$TOOLS/go/bin:$PATH" GOTOOLCHAIN=local`, `LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPASS}@127.0.0.1:5432/leorna_86bcm901j_test?sslmode=disable"` (`PGPASS` read from `.github/workflows/ci.yml:30`, abort if empty) and `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`:

1. `make check GOLANGCI_LINT="$TOOLS/golangci-lint-2.14.0-linux-amd64/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS=/usr/local/bin/gitleaks` (workspace, contracts-check, fmt, vet, test, lint, audit, secrets, library-check, build). Echo each tool's `--version`/`version` from the same environment first. `make check` and step 2 briefly write into the tree: reviewers, the verifier and the auditor run them in a detached copy at the same SHA.
2. `bash ./scripts/test-module-add.sh`
3. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` (the `delivery/stories.json` check, as CI runs it)
4. `make library-check GITLEAKS=/usr/local/bin/gitleaks LIBRARY_SUMMARY=<evidence>/library-summary-<sha7>.md LIBRARY_REPORT=<evidence>/library-report-<sha7>.json` (the content gate, for its report)
5. `gitleaks git --redact --no-banner --exit-code 1 --log-opts="origin/main..HEAD"` (this branch's commits; `make secrets` above scans every local ref, and a sibling branch's commit can fail it: if so, keep that log, show this command passes, and report it, never fix another branch)
6. Postgres proof: `go test -json -count=1 -run 'WithPostgres' ./... > <evidence>/postgres-<sha7>.json`; read it per test (Action plus that test's own Output) and confirm `TestEnsureLibraryWithPostgres` passed (it loads library 0.6.0's new versions); TestTeamsAPIWithPostgres's two ClickHouse subtests rightly skip without `LEORNA_TEST_CLICKHOUSE_URL`. Filter `.claude` on repo-relative paths when listing tests.
7. AC5 with the real tools (command in the AC list). CI skips it; say so in the PR.
8. Known, unrelated skips: `iac_tofu_test.go` and `provision_live_test.go` need `tofu` and Scaleway credentials; record them as pre-existing skips (OpenTofu 1.12.6 is optional here).
9. `git diff --name-only origin/main...HEAD -- .github` must be empty; `git log --format='%an <%ae>' origin/main..HEAD` all `Justin Issa <justin@leorna.com>`; `git status --porcelain` empty.

### Task 9: Docs & records (last)

- Code-side (builder): `internal/library/README.md` (Task 7); the three items, `library.json`, `content.lock.json`; `delivery/stories.json`: append, as text after the last entry, `"86bcm901j": {"name": "Baseline MCP templates + secure tool configs", "prs": {"LeornaAI/leorna-control-plane": []}}` and run gate 3. No `THIRD_PARTY_NOTICES.md` change (no upstream content; GitHub's hosted server isn't shipped).
- Evidence (builder → finisher): `evidence/86bcm901j/` as in Task E; `handover/` (finisher): stop-and-show (`git diff --stat origin/main..HEAD`, key hunks, gate results), PR text in Christian's plain style (Summary, one line per file/area, Test Plan with this head's results, Assumptions incl. the follow-ups below and "engineers must set `GITHUB_PERSONAL_ACCESS_TOKEN`", ClickUp link, Security/migration/rollback, Evidence block), the review prompt for a fresh agent, the ClickUp evidence draft (comment with an AC → test → result table and the file list; images only), and the team message. Never push, open a PR or post without Justin's word.
- Records (main session / finisher): plan copy `evidence/86bcm901j/plan-approved.md` (at "go"); `$MEM/leorna-workflow.md` status lines for 86bcm901j; `$MEM/leorna-control-plane-workflow.md` a dated line with this desktop's tool paths (`~/.local/leorna-tools`), the Postgres/Docker state and the capture method that worked; the brief files under `~/.hermes/plans/leorna/briefs/`.

## Gates summary

`make check` (CI-pinned golangci-lint 2.14.0 and govulncheck v1.7.0 by absolute path, gitleaks 8.30.1), `bash ./scripts/test-module-add.sh`, `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, `make library-check` (the content gate with the new policy stage), branch `gitleaks git`, the Postgres JSON proof, and AC5 with the real tools. The card's "quality-gate CI" is the PR's "Go quality gates" run, which only happens after "make a PR": until then it is NOT VERIFIED and the local gates stand in for it.

## Risks

- **Sibling stories (86bcm901a agents, 86bcm901b prompts) editing the same files.** Resolve at hand-over, never by waiting:
  - `delivery/stories.json`: every story appends at the end. Take main's file unchanged, append this entry last as text, check every earlier entry is unchanged by value, run gate 3.
  - `internal/library/content/library.json`: all three bump `0.5.0` → `0.6.0`. Take main's version and bump the next minor (e.g. `0.7.0`), and make the README's "Library **0.x.0** (story 86bcm901j)" line match.
  - `internal/library/content.lock.json`: sorted keys; their `agent/…`/`prompt/…` lines may sit next to this story's `config/…`/`mcp_template/…` lines and conflict. Keep both sides' lines (union), rerun `go test ./internal/library -run TestContentLock -update-lock` on the merged tree, and confirm every pre-existing entry is unchanged by value.
  - `internal/library/README.md`: each story adds a section and touches the "Loading" version paragraph and the "Verification"/gate lists. Keep both sides' text.
  - `internal/library/gate/gate.go`, `gate_test.go` (`sampleLibrary`, `TestAC1ValidatesRendersAndScansEveryItem`), `gate_more_test.go`, `cmd/library-gate/main_test.go`: 901a may change how agents render or are skipped (its card asks agents to render "for every tool that supports agents"), which touches `renderFor`, the agent fixture and the expected statuses. Keep both changes; re-run all gate tests on the merged tree (a sibling can add content a strict rule refuses with no text conflict: run this story's gates on main's new content).
  - `THIRD_PARTY_NOTICES.md` and the 945u upstream records: the siblings import upstream content; this story does not touch them, so no overlap.
  - ADR numbers: this story adds no ADR (rules live in the README), so no `adr/0004` clash.
- **Behaviour change for 901u's gate:** a warning on a tool an MCP template declares now fails, and templates/configs must pass the policy. Four 901u fixtures change (Task 4). Reviewers should confirm no other gate test changed result (baseline comparison by name).
- **Security:**
  - The credential-key pattern is a heuristic (same as the tiles): a secret under an innocent key (`DB_URL=postgres://u:p@h`) is caught only by gitleaks or review.
  - Deny rules in Claude Code are guard rails: another spelling of a command can pass a `Bash` pattern; project settings can be overridden by an engineer's `.claude/settings.local.json` (enforcement would need managed settings). The example says so.
  - The hosted GitHub server sends requests to GitHub's own service with the engineer's token (the same trust as using GitHub); an org policy can block it or fine-grained tokens. A live call with a real token is not part of this card's Verify and is NOT VERIFIED; GHES/GHE.com users use the tile.
  - `/readonly` relies on GitHub's documented behaviour (fetched 2026-10-28); if GitHub changes it, the template still needs a read-only token, which the example asks for.
- **Supply chain:** rule P pins the top-level npm package only; its dependencies still resolve by range at install (npx uses no lockfile). That is why github-mcp moves to the hosted server; any future stdio template carries that risk and should note it.
- **npx pin decision:** done here (AC4) via Q1 A. If Justin picks B/C/D, AC4 changes as listed under Q1.
- **Engineers must act:** after sync, github-mcp needs `GITHUB_PERSONAL_ACCESS_TOKEN` (new name); Claude Code users approve the project server once; Codex users lose up-arrow history across sessions (history `none`). PR and team message say so.
- **Environment:** tool installs (≈1 GB disk, 944 GB free), Docker WSL integration (Justin's switch), and the unproven screenshot path (Task E0, Q6) can each stall the build: Task 0 surfaces them before code is written.
- **Seed (Q3 A):** new installs' starter pack keeps github-mcp 2.0.0 (unpinned, Codex reads a different variable) until 86bcm901r.

## Assumptions

- The card's three ACs stand as written; "content" = `internal/library/content/` (Justin). The card and Justin's summary agree; nothing differs.
- "Baseline MCP templates" means the existing template made safe and verified, not new templates: business systems come through the integration tiles (GitHub, ClickUp, Google Workspace). A Cursor CLI config is a follow-up (no Cursor CLI on this machine and the renderer copies its JSON unchecked).
- Semver for content: github-mcp 3.0.0 (engineers must set a new variable), both configs 2.0.0 (behaviour changes engineers notice), library 0.6.0.
- Codex 0.165 and Claude Code 2.1.312 are the versions AC5 proves; other versions may print differently.
- The client's Codex renderer behaviour (forwarding by key) stays as is; the gate compensates. Changing the client is a separate story.
- No OpenAPI, migration, CI or Makefile change; no seed change (Q3 A).

## Parts of the code it touches

- New: `internal/library/gate/policy.go`, `internal/library/gate/policy_test.go`, `internal/library/gate/shipped_test.go`, `internal/library/gate/realtools_test.go`.
- Changed code: `internal/library/gate/gate.go` (hook + package comment).
- Changed tests (fixtures only): `internal/library/gate/gate_test.go`, `internal/library/gate/gate_more_test.go`, `cmd/library-gate/main_test.go`.
- Content: `internal/library/content/library.json`, `items/mcp_template/github-mcp/{item.json,body.md,example.md}`, `items/config/claude-code-settings/{item.json,body.md,example.md}`, `items/config/codex-defaults/{item.json,body.md,example.md}`, `internal/library/content.lock.json`.
- Docs/records: `internal/library/README.md`, `delivery/stories.json`.
- Not touched: `internal/library/render/**`, `internal/integration/**`, `internal/pack/**`, `api/`/contracts, migrations, `.github/**`, `Makefile`, `THIRD_PARTY_NOTICES.md`.

## Skills

- Every role: `leorna` (role rules), `engineering-best-practices`, **`security-best-practices`** (Justin: every role, this story handles secrets and ships to every install; Go backend reference `references/golang-general-backend-security.md`; its gitleaks and `npx` notes apply).
- Builder: `test-driven-development`, `mutation-testing-discipline` (the policy rules are security guards).
- Reviewers: `requesting-code-review` + `code-review-practice` (report only). Fixers/finisher: `receiving-code-review`, `git-commit-rules`, `test-driven-development`.
- Not needed: `multi-tenant-auth-management` (no tenant, auth or session code), `api-contract-drift-guard` (no OpenAPI or client contract; the gate's JSON report only gains a stage value, a CI artifact), `backend-data-migrations` (no migration; the loader adds item versions as before). None of the skills this build uses ends with "Mandatory Validation and Agent Defect Loop" (only `api-contract-drift-guard` and `backend-data-migrations` do, and they are not used), so the standard review → fix → verifier → auditor loop applies.

## Other things found (not fixed, not folded in)

1. **P2, client repo:** the client's Codex transformer forwards an env variable under the env **key's** name and ignores the placeholder's variable (`render/codex.go:121` is the copy). A template like github-mcp 2.0.0 silently reads a different variable in Codex than in Claude Code and Cursor. The client should refuse `KEY: ${OTHER}` the way the tiles do (`internal/integration/tile.go:378-381`). This story's gate compensates for library content.
2. **P2:** the starter seed (`internal/pack/seed.json:42-60`, 1.2.0) ships github-mcp 2.0.0 (unpinned deprecated `npx`, the Codex variable mismatch) and the old configs to every new install's starter pack. Owner 86bcm901r (Q3).
3. **P3:** pack versions that admins edit (fork/version) can hold MCP templates and configs with literal credentials or unpinned launchers; `internal/pack` has no such rules (no secret/placeholder checks outside tests). Follow-up to apply the same policy when an admin saves a pack version.
4. **P3:** the GitHub integration tile asks for classic token scopes `repo, read:org` (`internal/integration/tiles/github.json`), which grant write access, and uses the full (not `/readonly`) address. A least-privilege variant would use fine-grained read-only tokens. Tile is "preview".
5. **P3, records:** `delivery/stories.json` on main lists `86bcm9019` with an empty PR list although PR #92 merged (`1ee7157`'s parent `022283b`); the local commit `3cd9b0f` that adds `[92]` was never pushed, so `check-story-shippable.py 86bcm9019` passes vacuously.
6. **P3:** `credentialKey` is duplicated between `internal/integration/tile.go:143` and the new `gate/policy.go`; sharing one exported rule is a small follow-up.
7. **Info:** both upstream npm packages, `@modelcontextprotocol/server-github` (2025.4.8) and `@modelcontextprotocol/server-postgres` (0.6.2), are deprecated on npm ("Package no longer supported").
8. **Environment (desktop):** no Linux Go/golangci-lint/govulncheck, no Docker inside Ubuntu, and headless Chrome screenshots hang inside the agent sandbox (`--dump-dom` works). Sibling stories on this machine hit the same (Q5, Q6).

## Justin's answers (2026-10-28)

Justin's words: "Okay, look, I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?" The main session recorded this as **go** on this plan, with every ⭐ answer and the proposed AC4 and AC5 approved as written. Grant scope and end: `~/.hermes/plans/leorna/86bcm901j-handoff.md`. Push, PR, ClickUp posts and merges stay forbidden.

- **Q1: A ⭐.** GitHub's hosted read-only server.
- **Q2: A ⭐.** Nothing pre-approved; deny secrets; Codex history off.
- **Q3: A ⭐.** The seed stays with 86bcm901r.
- **Q4: A ⭐.** AC5 runs real Codex and Claude Code in throwaway homes only, never Justin's real `~/.codex` or `~/.claude`.
- **Q5: A ⭐.** The agent installs Go and CI's tools under `~/.local/leorna-tools`. **Justin's step, owed:** Docker Desktop → Settings → Resources → WSL integration → enable for Ubuntu. Until he does it, the build continues and the Postgres gates (and anything needing `leorna-test-pg`) are recorded **NOT RUN, owed**, as option B describes; they run once Docker is on, before hand-over. Other sessions (86bcm901a, 86bcm901b) may install the same tools at the same path: check first, never overwrite or delete another session's working install, and install atomically.
- **Q6: held for Justin.** Option A means running Chrome outside the agent sandbox, a permission change only Justin can grant, so the standing grant doesn't cover it. Until he answers, **option B applies:** take screenshots by any route that works inside the current sandbox without changing permissions or settings; if none works, save the logs and mark those screenshots **owed**.

## Justin's answers (2026-10-28, after hand-over)

Justin's words: "For thirteen decisions, just ask an agent and tell it to choose the best ones. Once I recommend it, I'd create a PR, but we need to run audit checks and verification checks again because something's going to emerge, so yeah."

- **The 13 rulings** (`evidence/86bcm901j/handover/rulings-for-justin.md`): delegated to a fresh decision agent, which picks the best option for each. The main session also gave it the version-manager question (A add the names / B soften the README), so nothing waits on Justin.
- **Bring main in:** OK. GitHub main is now `db3406e` (PR #95, 86bcm901b, merged). A fixer merges it in using `handover/sibling-merge-plan.md` and applies the decided changes.
- **Re-verify:** verifier → blind AC auditor → `ac-check.sh` again on the new head; then the finisher refreshes the hand-over.
- **PR:** not opened automatically; the main session asks for "make a PR" once the checks pass.
- **Update (Justin, same evening):** "We're gonna have to move it twice, so honestly, don't run it again if you already ran it before, like the fixers and the Auditors and all that. If you didn't run them at least once, just run them again. We're gonna have to move main twice." Reading recorded by the main session: main will move twice (siblings 901a #97 and 901w #96 still to merge), so the verifier, the blind AC auditor and `ac-check.sh`, which already passed once on `66449af`, are **not** re-run. The decider runs (first time). One fixer applies the decided changes, brings main in, and runs the gates plus the five AC tests by name on its head itself; the same again when main moves the second time. The "make a PR" step re-runs the gates on the exact head pushed (`leorna` 7.3).

## Justin's answers (2026-10-29, PR #98)

- **"make a pr" → bring main in first, then PR.** Done: merges `31be4f8` (main `a8d1465`: #95, #94, #97) and `17f2ccf` (main `6c1709e`: #96); ruling 13 and README B on top; PR #98 opened at `17f2ccf`.
- **"After you put out the PR, run verifications to make sure everything's good."** Verifier round 3 on `17f2ccf`: all 5 ACs accepted, gates and hosted CI green, one Low finding V3-1 (header names and values that real Claude Code refuses are counted as verified).
- **V3-1: fix it, then push** (Justin chose the recommended option; this OKs pushing the fix to PR #98). Header names must be RFC 9110 tokens; header values may not hold CR, LF, NUL or a character above U+00FF; each fails at template level naming the header, never the value, with AC3 subtests. The same round records PR #98 in `delivery/stories.json`. Then verifier → blind auditor → `ac-check.sh` on the new head, then push.
