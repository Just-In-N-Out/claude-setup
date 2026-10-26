# Plan: Library catalog browser (control plane) — `86bcm901v-catalog-browser-v3`

ClickUp card `86bcm901v` "Library catalog browser" (E11 Pack Builder, PI-2, size M, repo control-plane). Planned 2026-10-24 by the Opus 5.5 PLANNER, from scratch and blind to the v1/v2 attempts, against GitHub `origin/main` `6e74ced` (PR #87 merged). Nothing is built yet.

## Questions (each ⭐ is pre-accepted by Justin for this story: "Keep going like v2")

The rest of the plan assumes every ⭐ answer. None of these needs a product decision beyond the card.

1. **What does the "rendered preview" show?**
   - A ⭐ The body as formatted Markdown; configs and MCP templates as code
   - B The per-tool output files (needs 901u's renderer, not on main)
   - C The raw body text only
2. **How is Markdown turned into HTML safely?**
   - A ⭐ goldmark v1.7.17 (MIT, no dependencies), raw HTML off
   - B A small hand-written renderer, no new dependency
3. **Which versions does the list show?**
   - A ⭐ The newest version of each item only
   - B Every stored version as its own row
4. **What does text search look at?**
   - A ⭐ Name, description, category and tags
   - B Also the full body and example
5. **Is there a JSON API too?**
   - A ⭐ No: HTML admin pages only, OpenAPI unchanged
   - B Also `GET /v1/library/items` with an OpenAPI change
6. **How are filters picked?**
   - A ⭐ One value per filter (dropdowns), all combined with AND
   - B Several values per filter (checkboxes)
7. **How are the admin-console screenshots taken?**
   - A ⭐ Real binary in its existing dev mode, 127.0.0.1, headless Chrome
   - B An env-gated chromedp test added to the repo
8. **How is "<300 ms server time" proven?**
   - A ⭐ Timing every request in the test (median of 3, 240 items)
   - B Also add a `Server-Timing` response header

Two things to make visible to Justin (both are ⭐ answers, neither is a product decision): the story adds **one new Go dependency** (`github.com/yuin/goldmark` v1.7.17, Q2), and the screenshots use the **existing, gated dev-mode demo login on loopback only** with a throwaway database (Q7). No code adds or relaxes any auth.

## Acceptance criteria (the card's three ACs; none is live, all are agent-checkable locally)

- AC1: Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text.
- AC2: Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview.
- AC3: Given 200+ items, then filtering stays responsive (<300 ms server time).

| AC | Test (exact name) | File | Single-test command (run from the worktree) |
| --- | --- | --- | --- |
| AC1 | `TestLibraryAC1FilterAndSearchWithPostgres` | `internal/web/library_test.go` | `LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/<your DB>?sslmode=disable' go test -v -count=1 -run '^TestLibraryAC1FilterAndSearchWithPostgres$' ./internal/web/` |
| AC2 | `TestLibraryAC2ItemDetailWithPostgres` | `internal/web/library_test.go` | `LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/<your DB>?sslmode=disable' go test -v -count=1 -run '^TestLibraryAC2ItemDetailWithPostgres$' ./internal/web/` |
| AC3 | `TestLibraryAC3FilteringUnder300msWithPostgres` | `internal/web/library_test.go` | `LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/<your DB>?sslmode=disable' go test -v -count=1 -run '^TestLibraryAC3FilteringUnder300msWithPostgres$' ./internal/web/` |

- **Postgres:** the tests need the local `leorna-test-pg` container (`docker start leorna-test-pg`; start Docker Desktop first after a restart) and a database **you own whose name ends in `_test`**. Builder: `leorna_86bcm901v_v3_test`. Verifier: `leorna_86bcm901v_v3_verifier_test`. AC auditor: `leorna_86bcm901v_v3_auditor_test`. Create yours if missing: `docker exec leorna-test-pg psql -U leorna -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='<name>'"` and, if that prints nothing, `docker exec leorna-test-pg createdb -U leorna <name>`. Never use, reset or drop `leorna_test` or another session's database (the store tests drop every table in the database they run against). Without `LEORNA_TEST_DATABASE_URL` the tests print `--- SKIP`, which does not count.
- **Base-commit run (ac-verification.md recipe):** for every AC, "this AC's test files" are **`internal/web/library_test.go` and `internal/web/packs_test.go`** (the second one only gains a variadic hook on `newPackFixture`). On the base commit with those two files copied in, the package fails to build because the new production code is missing (`handler.SetLibrary undefined (type *Handler has no field or method SetLibrary)`, `undefined: library.Entry`, and `FAIL …/internal/web [build failed]`). That is the expected failure; it is a build failure of the new code, not a missing test file.
- On head each test prints `--- PASS: <name>` with no `--- SKIP` line; AC3 also logs one timing line per filter.
- Screenshots: `ac1-library-filtered.png`, `ac2-item-detail.png`, `ac3-timing-terminal.png` (task B12).

## Playback

Justin asked for the **Library catalog browser** story (v3, Full pipeline, a photo for every AC for ClickUp). In the control plane's admin console, an admin opens a new **Library** page that lists the shared content library (skills, agents, configs, MCP templates loaded by story 86bcm9018), filters it by kind, category, tag and supported tool, and searches it by text. Clicking an item opens a page with its description, example, version, supported tools and a rendered preview of its body. Filtering stays under 300 ms with 200+ items. Done = AC1–AC3 each pass their named test, one screenshot per AC, the card's DoD met (unit + integration tests with a failure case, OpenAPI only if the API changes — it doesn't, lint/format/gitleaks/golangci-lint green, demoable in isolation, short README note) and the project gates green.

## Current context (verified 2026-10-24)

- Repo `~/Leorna/leorna-control-plane`; local `main` is 8 commits behind; fresh GitHub `origin/main` = `6e74ced` (fetched over HTTPS through `gh`). The main working tree has untracked `.claude/` and `deploy/local/`: leave both alone and never check out or switch branches there.
- Dependency `86bcm9018` (Content library format + loader, PR #82) is merged and complete:
  - `internal/library/library.go`: `Item{Kind pack.Kind; Name, Version, Category string; Tags []string; Tools []Tool; Description, Example, Body string}`, `Tool` (`claude-code`, `codex`, `cursor`), `ErrInvalid`, `invalid()`, `validSlug()`.
  - `internal/library/source.go`: `Embedded()` parses the embedded `content/` tree (8 items today).
  - `internal/store/postgres/library.go`: `EnsureLibrary` writes immutable rows into the shared table `library_items` (migration 20: `id uuid, kind, name, version, category, tags text[], tools text[], description, example, body, content_sha256, library_version, created_at`, `UNIQUE(kind,name,version)`). An upgrade adds new versions and keeps old ones, so one `(kind, name)` can have several rows. The table is **not tenant-scoped** (shared product content).
- Admin console = Go `html/template` pages in `internal/web`, routes in `handler.go` `Routes()`, each admin page wrapped `requireSession(requireAdmin(...), true)`. Pages set `Cache-Control: no-store` and the nonce-only CSP via `writeHTMLPage` (`packs.go`). Dashboard filters (`costs.go`, `dashboard_filter.go`) are GET forms whose bad values give a 400 page with an inline `role="alert"` message. Shared list/form styles: `adminBaseCSS` (`admin_ui.go`). The admin home links every page from one line in `adminTemplate` (`handler.go`, "Current session" card).
- Postgres-backed web tests: `newPackFixture` (`internal/web/packs_test.go`) gives a throwaway schema, admin/member/other-tenant principals, `login`, `pool`, `repository`. Helpers `request`, `closeBody`, `newTestClient`, `discardLogger`, `fakeProvider` live in `handler_test.go`. **`readBody` stops at 64 KiB** (`handler_test.go:308-316`); a 240-row library page is bigger, so the new tests use their own `readPage`.
- Pack kinds come from `pack.Kinds()` (skill, agent, config, mcp_template). Open PR #85 (story 86bcm9016) adds a `prompt` kind; the new code reads kinds from `pack.Kinds()`/`Kind.Valid()` and renders unknown Markdown kinds as Markdown, so it keeps working whichever merges first. Tests use explicit kinds.
- No Markdown renderer exists in the repo. `github.com/yuin/goldmark` v1.7.17 (2026-03-19, MIT, no dependencies of its own) is in the local module cache. A scratch probe this session confirmed that with default options it renders headings, lists, code, tables and strikethrough, omits raw HTML (`<!-- raw HTML omitted -->`) and empties `javascript:` (any case, entity-encoded, leading space), `vbscript:`, `file:` and `data:` link/image URLs; without the Linkify extension `name@1.0.0` stays plain text. YAML front matter is mis-rendered as `<hr>` + `<h2>`, so the plan splits it off first.
- Local run for screenshots (proven parts): `internal/config/runtime.go:61-86` — with `LEORNA_DEV_MODE=1` Google OAuth is optional and the database URL may use `sslmode=disable`; `LEORNA_PUBLIC_BASE_URL` must still be `https://…` (the placeholder `https://pending.leorna.invalid` is accepted and hides the client card, `admin_ui.go`); `LEORNA_SECRET_ENCRYPTION_KEY` (base64 32 bytes) is required; Mongo/ClickHouse are optional. `config/manifest.example.json` listens on `127.0.0.1:8080`. A probe this session showed headless Chrome 155 keeps `__Host-` `Secure` cookies on `http://127.0.0.1` and `http://localhost`, and a one-shot `--screenshot` follows a cookie-setting 302 and captures the final page. The full binary run itself has not been executed yet (the builder does it in B12).
- CI (`.github/workflows/ci.yml`): Go from `go.work` (1.27.3), golangci-lint **2.14.0**, gitleaks 8.30.1, govulncheck v1.7.0, Postgres 18.6. Local Homebrew golangci-lint is 2.13.2 (wrong); local `go` is 1.27.1 (the `go.work` toolchain line makes it fetch 1.27.3).

## Approach

One vertical slice in three layers, no schema change, no API change:

1. **Domain (`internal/library`)** — pure, unit-tested:
   - `catalog.go`: `Entry{ID, Item}`, the `Catalog` port, `Filter{Kind, Category, Tag, Tool, Text}` with `Validate`, `Matches`, `Apply`; `Facets(entries)` (sorted distinct categories and tags); `Tools()` and `Tool.Label()`.
   - `preview.go`: `RenderMarkdown(source) (template.HTML, error)` (goldmark, safe defaults, tables + strikethrough, no Linkify, never `WithUnsafe`) and `Item.Preview()`: configs and MCP templates → the body verbatim as code; every other kind → front matter split off and shown verbatim, the rest rendered as Markdown.
2. **Store (`internal/store/postgres/library_catalog.go`)** — `ListLibraryItems` (newest version of each `(kind, name)`, numeric version order, metadata only, sorted in Go by kind then name) and `GetLibraryItem` (one row by id with example and body). Both run inside `beginOrg(ctx, actor, false)` like `GetCatalog`, so a call without the actor's tenant context or with an unknown user fails closed with `store.ErrNotFound`. No migration: the table and its unique index exist; ≤2000 items needs no new index.
3. **Admin console (`internal/web/library.go`)** — `GET /admin/library` (filter form + results table, filtering done in Go on the newest-version list) and `GET /admin/library/items/{itemId}` (detail page). Both admin-only, no-store, nonce CSP, no scripts. Bad filters → 400 page with an inline alert and no rows. Unknown or malformed item id → 404 problem. Store failure → generic 500 problem with a trace id (cause only in the log). A **Library** link is added to the admin home. `cmd/control-plane/main.go` wires `application.SetLibrary(repository)`.

Why filter in Go: the newest-version list is at most `library.MaxItems` (2000) rows of metadata, one indexed query; filtering in Go keeps the rules in one pure, unit-tested function (`Filter.Matches`) and the facets come from the same list. AC3 measures the whole request (query + filter + render).

## Decisions and why

- HTML pages only, no JSON API, OpenAPI untouched (Q5): matches the pack and dashboard pages and Justin's earlier "wizard only, no JSON API" call (86bbu3xew). The client has no use for the library. `make contracts-check` must stay green with no diff under `contracts/` or `packages/contracts/`.
- Newest version only (Q3): admins browse what ships now; older versions stay readable by id (the pack builder 86bcm901w and company variants 86bcm901z own version workflows later).
- Text search over name, description, category and tags (Q4): fast and predictable; bodies are up to 64 KiB each.
- Single-value filters combined with AND (Q6): the dashboards' pattern; empty form fields mean "any". Each query key may appear once; unknown keys and impossible values (unknown kind/tool, non-slug category/tag, search over 100 characters or with control characters) are rejected with 400, like `costFilter`.
- Preview by kind (Q1): configs (`config`) and MCP templates (`mcp_template`) are JSON/TOML files, so they show verbatim in `<pre><code>` (escaped by `html/template`); skills, agents and any future Markdown kind (e.g. `prompt`) render as Markdown, with agent front matter shown separately. The example (always prose) is rendered as Markdown too.
- goldmark (Q2): CommonMark-correct, safe by default, one small pinned dependency, better than hand-writing a parser. `RenderMarkdown` is the only place library content becomes `template.HTML`; tests pin the unsafe-input behaviour; the page CSP (`default-src 'none'`, nonce-only scripts) blocks images, scripts and `javascript:` navigation even if a renderer bug slipped through.
- Store reads require the actor's tenant context (fail closed) even though the table is shared; the routes enforce admin (`requireAdmin`), like the pack pages.
- No CSRF-cookie requirement on these GET pages (the newer dashboards don't require it; the pages have no state-changing form).
- No pagination: ≤2000 items render on one page; listed as a follow-up.
- The browser reads the database (what this install loaded), not the embedded files, so it shows exactly what pack building will pick from.

## Parts of the code it touches

New files:
- `internal/library/catalog.go`, `internal/library/catalog_test.go`
- `internal/library/preview.go`, `internal/library/preview_test.go`
- `internal/store/postgres/library_catalog.go`, `internal/store/postgres/library_catalog_test.go`
- `internal/web/library.go`, `internal/web/library_test.go`

Edited files:
- `internal/web/handler.go`: `Handler.libraryCatalog` field + `library` import; two routes; one link in `adminTemplate`.
- `internal/web/packs_test.go`: `newPackFixture` gains a variadic `configure` hook (existing callers unchanged).
- `cmd/control-plane/main.go`: one line `application.SetLibrary(repository)`.
- `go.mod`, `go.sum`: `github.com/yuin/goldmark v1.7.17`.
- `internal/web/README.md`: a "Library catalog browser" section.

Not touched: `contracts/`, `packages/contracts/`, migrations, `.github/` (no CI exception for this story), `delivery/stories.json` (only after a PR exists), `internal/library/README.md`, `internal/library/content/`, `content.lock.json`, `internal/library/library.go`, `source.go`, `toolconnector` (client repo).

Data shapes: no API or schema change. New Go API: `library.Entry`, `library.Catalog`, `library.Filter`, `library.Facets`, `library.Tools`, `library.Tool.Label`, `library.Preview`, `library.Item.Preview`, `library.RenderMarkdown`, `library.MaxQueryRunes`, `(*postgres.Store).ListLibraryItems`, `(*postgres.Store).GetLibraryItem`, `(*web.Handler).SetLibrary`.

## Risks

- **AC3 timing flake on a slow CI runner under `-race`.** Mitigation: one warm-up request, median of 3 runs per filter, the whole round trip measured (an upper bound on server time), 240 items with metadata-only list queries; expected medians are a few tens of ms. If CI ever flakes, the logged timings show it.
- **New dependency.** goldmark v1.7.17 pinned; `make audit` (govulncheck) must pass. If govulncheck flags it, bump to the lowest fixed release at least two weeks old and record it; if none exists, stop and report.
- **XSS through library content** (upstream sync and tenant variants will later feed the same preview). Mitigated by goldmark safe mode, tests with hostile input, `html/template` escaping elsewhere, and the CSP.
- **Parallel 901u v3 work** in the same repo (see Overlaps).
- **Dev-mode screenshot route.** Uses the existing gated demo login only on `127.0.0.1` against a throwaway database, never on a server; no URL bar, email or tenant ID appears in the captured pages.
- **64 KiB `readBody` truncation** in the existing web helpers: the new tests use `readPage` (4 MiB).
- **DB collation:** names are sorted in Go after the query, so the order never depends on the container's locale.

## Assumptions (for the PR's Assumptions list)

- The browser is admin-only (card: "As an admin"); members get 403.
- The library is shared product content: every tenant's admin sees the same list; tenant packs never appear in it.
- Only the newest version of each item is listed; older versions remain readable by id.
- Text search covers name, description, category and tags, not bodies.
- "Rendered preview" = the body rendered as Markdown (configs/MCP templates shown as their file). Per-tool output previews can follow once 901u's renderer lands.
- "<300 ms server time" is proven by in-process request timing in `TestLibraryAC3FilteringUnder300msWithPostgres` (240 items, median of 3 per filter); no Server-Timing header.
- No OpenAPI change: the API is not touched.

## Skills

- Builder: `leorna` (BUILDER), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (admin route guard, store fail-closed, unsafe-HTML guard), `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`.
- Reviewers (both rounds): `leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, plus the same specialists.
- Fixers: `leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`.
- Verifier and AC auditor: `leorna`, `engineering-best-practices` (verifier also the specialists).
- Skipped: `backend-data-migrations` (no storage or schema change: read queries on an existing table only); `frontend-ui-repair` (exists in Hermes but is not linked for Claude Code, and it repairs broken UI rather than building a new server-rendered page); `systematic-debugging` (not a bug).
- **Skills with a "Mandatory Validation and Agent Defect Loop":** `api-contract-drift-guard` (verified with `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`). Its loop applies to the verifier: confirm no contract drift (`make contracts-check` green, empty `git diff --name-only <base>...HEAD -- contracts packages/contracts`).

## Build setup (B0)

Variables used below (bash; run `/opt/homebrew/bin/bash`, not macOS bash 3.2):

```bash
CP=~/Leorna/leorna-control-plane
WT=$CP/.claude/worktrees/86bcm901v-catalog-browser-v3
SCR=~/.hermes/cache/scratch/86bcm901v-catalog-browser-v3
EVID=~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3
export PATH="$SCR/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:$PATH"
export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901v_v3_test?sslmode=disable'
```

1. `mkdir -p "$SCR/bin" "$EVID"`.
2. Fresh base: `git -C $CP -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`.
3. Stop if the branch exists: `git -C $CP rev-parse --verify -q refs/heads/feat/86bcm901v-catalog-browser-v3` must print nothing. Then `git -C $CP worktree add -b feat/86bcm901v-catalog-browser-v3 "$WT" origin/main`. Record `BASE=$(git -C $WT rev-parse HEAD)` (expected `6e74ced…` unless main moved).
4. Identity check: `git -C $WT config user.email` is `justin@leorna.com`. Never pass `-c user.*` or `--author`. No AI attribution or `Co-Authored-By` lines in commits.
5. Tools: `GOBIN=$SCR/bin go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.14.0`; `"$SCR/bin/golangci-lint" --version` must say 2.14.0. `realpath --relative-to=/ /tmp` must work (gnubin) and `bash --version` must be 5.x. Record `go version` (inside `$WT`), `gitleaks version`, `govulncheck -version` in `$EVID/tools.txt`.
6. Database: `docker ps --filter name=leorna-test-pg --format '{{.Status}}'` shows Up (else `docker start leorna-test-pg`); create `leorna_86bcm901v_v3_test` if missing (commands in the AC section).
7. Baseline on the untouched base (separates old failures from new ones): `cd $WT && GOLANGCI_LINT="$SCR/bin/golangci-lint" make check > "$EVID/gates-base-${BASE:0:7}.txt" 2>&1; echo "EXIT=$?" >> "$EVID/gates-base-${BASE:0:7}.txt"`. A failure here is pre-existing: note it, never fix it in this story. (If `make secrets` fails on other local branches' history, also run the story-range scan in B11 and say so.)

Stop conditions for the whole build: the branch or worktree already exists; Postgres can't be reached; a gate fails for a reason outside the branch that also fails on base (record, don't fix); govulncheck flags goldmark with no fixed release ≥ two weeks old; any need to touch `.github/`, `contracts/`, migrations, another story's worktree, branch or database.

## Tasks

Each task: write the test, run it and see it fail for the stated reason (save the output as `$EVID/red-<task>.log`), write the code, run the same command green, then the package's tests. Commit at the end of B3, B8 and B9 with explicit file paths (`git add <files>`; never `git add -A`).

The code below was type-checked (`go vet`) and linted (golangci-lint 2.14.0, 0 issues) against `origin/main` `6e74ced` in a scratch copy during planning; the tests were not run. If a test's expected literal turns out to differ from the real output only in escaping or whitespace, correct the literal to the real output without weakening the assertion (same scope, same exactness) and list it under deviations in your report. Any other mismatch is a code bug: fix the code, not the test.

### B1 — Filter, facets and tool labels (unit)

Create `internal/library/catalog_test.go`:

```go
package library

import (
	"errors"
	"slices"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

func catalogEntries() []Entry {
	return []Entry{
		{ID: "a1", Item: Item{Kind: pack.KindAgent, Name: "code-reviewer", Version: "1.10.0", Category: "code-quality", Tags: []string{"code-review", "security"}, Tools: []Tool{ToolClaudeCode, ToolCursor}, Description: "Reviews a diff for correctness."}},
		{ID: "c1", Item: Item{Kind: pack.KindConfig, Name: "codex-defaults", Version: "1.1.0", Category: "configuration", Tags: []string{"codex", "sandbox"}, Tools: []Tool{ToolCodex}, Description: "Codex defaults with a workspace-write sandbox."}},
		{ID: "s1", Item: Item{Kind: pack.KindSkill, Name: "incident-postmortem", Version: "1.0.0", Category: "incident-response", Tags: []string{"incidents", "writing"}, Tools: []Tool{ToolClaudeCode}, Description: "Blameless postmortem template."}},
		{ID: "s2", Item: Item{Kind: pack.KindSkill, Name: "code-review-checklist", Version: "1.0.0", Category: "code-quality", Tags: []string{"code-review", "pull-requests"}, Tools: []Tool{ToolClaudeCode, ToolCodex, ToolCursor}, Description: "Checklist for pull requests."}},
	}
}

func entryIDs(entries []Entry) []string {
	ids := make([]string, 0, len(entries))
	for _, entry := range entries {
		ids = append(ids, entry.ID)
	}
	return ids
}

func TestFilterMatchesEachField(t *testing.T) {
	entries := catalogEntries()
	cases := []struct {
		name   string
		filter Filter
		want   []string
	}{
		{"empty filter keeps everything in order", Filter{}, []string{"a1", "c1", "s1", "s2"}},
		{"kind", Filter{Kind: pack.KindSkill}, []string{"s1", "s2"}},
		{"category", Filter{Category: "code-quality"}, []string{"a1", "s2"}},
		{"tag", Filter{Tag: "code-review"}, []string{"a1", "s2"}},
		{"tool", Filter{Tool: ToolCodex}, []string{"c1", "s2"}},
		{"text in the name in any case", Filter{Text: "POSTMORTEM"}, []string{"s1"}},
		{"text in the description", Filter{Text: "workspace-write"}, []string{"c1"}},
		{"text in a tag", Filter{Text: "security"}, []string{"a1"}},
		{"text in the category", Filter{Text: "incident-resp"}, []string{"s1"}},
		{"fields combine with AND", Filter{Kind: pack.KindSkill, Tool: ToolCodex, Text: "review"}, []string{"s2"}},
		{"nothing matches", Filter{Kind: pack.KindConfig, Tag: "code-review"}, []string{}},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := entryIDs(tc.filter.Apply(entries)); !slices.Equal(got, tc.want) {
				t.Fatalf("Apply(%+v) = %v, want %v", tc.filter, got, tc.want)
			}
		})
	}
}

func TestFilterValidateRejectsImpossibleValues(t *testing.T) {
	valid := []Filter{
		{},
		{Kind: pack.KindMCPTemplate, Category: "code-quality", Tag: "pull-requests", Tool: ToolCursor, Text: "review checklist"},
		{Text: strings.Repeat("é", MaxQueryRunes)},
	}
	for _, filter := range valid {
		if err := filter.Validate(); err != nil {
			t.Fatalf("Validate(%+v) = %v, want nil", filter, err)
		}
	}
	invalid := map[string]Filter{
		"unknown kind":                    {Kind: "widget"},
		"unknown tool":                    {Tool: "vim"},
		"category is not a slug":          {Category: "Code Quality"},
		"tag is not a slug":               {Tag: "code_review"},
		"search too long":                 {Text: strings.Repeat("a", MaxQueryRunes+1)},
		"search with a control character": {Text: "review\x01"},
		"search with a newline":           {Text: "a\nb"},
		"search is not UTF-8":             {Text: "\xff"},
	}
	for name, filter := range invalid {
		if err := filter.Validate(); !errors.Is(err, ErrInvalid) {
			t.Fatalf("%s: Validate = %v, want ErrInvalid", name, err)
		}
	}
}

func TestFacetsAreSortedAndDistinct(t *testing.T) {
	categories, tags := Facets(catalogEntries())
	if want := []string{"code-quality", "configuration", "incident-response"}; !slices.Equal(categories, want) {
		t.Fatalf("categories = %v, want %v", categories, want)
	}
	if want := []string{"code-review", "codex", "incidents", "pull-requests", "sandbox", "security", "writing"}; !slices.Equal(tags, want) {
		t.Fatalf("tags = %v, want %v", tags, want)
	}
	if categories, tags := Facets(nil); len(categories) != 0 || len(tags) != 0 {
		t.Fatalf("empty library facets = %v %v", categories, tags)
	}
}

func TestToolsHaveDisplayLabels(t *testing.T) {
	if got := Tools(); !slices.Equal(got, []Tool{ToolClaudeCode, ToolCodex, ToolCursor}) {
		t.Fatalf("Tools() = %v", got)
	}
	for tool, want := range map[Tool]string{ToolClaudeCode: "Claude Code", ToolCodex: "Codex", ToolCursor: "Cursor", "vim": "vim"} {
		if got := tool.Label(); got != want {
			t.Fatalf("%q.Label() = %q, want %q", tool, got, want)
		}
	}
}
```

RED: `go test -count=1 -run 'TestFilter|TestFacets|TestTools' ./internal/library/` → build failure (`undefined: Entry`, `undefined: Filter`, …).

Create `internal/library/catalog.go`:

```go
package library

import (
	"context"
	"fmt"
	"slices"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// MaxQueryRunes bounds the catalog browser's text search.
const MaxQueryRunes = 100

// Entry is one stored item version as the catalog browser shows it. Entries
// from ListLibraryItems carry metadata only (Example and Body are empty);
// GetLibraryItem fills every field.
type Entry struct {
	ID   string
	Item Item
}

// Catalog reads the stored library for the admin console. The library is
// shared product content, not tenant data, but every read runs as a signed-in
// user of the tenant in the context, so a call without one fails closed. The
// routes add the admin check.
type Catalog interface {
	// ListLibraryItems returns the newest stored version of every item,
	// ordered by kind and then name.
	ListLibraryItems(ctx context.Context, actor store.Principal) ([]Entry, error)
	// GetLibraryItem returns one stored item version with its example and
	// body. Unknown and malformed IDs return store.ErrNotFound.
	GetLibraryItem(ctx context.Context, actor store.Principal, id string) (Entry, error)
}

// Filter narrows the catalog. An empty field matches everything; set fields
// combine with AND.
type Filter struct {
	Kind     pack.Kind
	Category string
	Tag      string
	Tool     Tool
	// Text matches case-insensitively anywhere in the name, description,
	// category or a tag. Callers trim surrounding spaces.
	Text string
}

// Validate rejects values no library item can have, so the console can say
// the filter is wrong instead of showing an empty list.
func (filter Filter) Validate() error {
	if filter.Kind != "" && !filter.Kind.Valid() {
		return invalid("filter", "kind is not supported")
	}
	if filter.Category != "" && !validSlug(filter.Category) {
		return invalid("filter", "category must be lowercase words joined by hyphens")
	}
	if filter.Tag != "" && !validSlug(filter.Tag) {
		return invalid("filter", "tag must be lowercase words joined by hyphens")
	}
	if filter.Tool != "" && !filter.Tool.Valid() {
		return invalid("filter", "tool is not supported")
	}
	if !utf8.ValidString(filter.Text) || utf8.RuneCountInString(filter.Text) > MaxQueryRunes ||
		strings.IndexFunc(filter.Text, unicode.IsControl) >= 0 {
		return invalid("filter", fmt.Sprintf("search must be at most %d characters of plain text", MaxQueryRunes))
	}
	return nil
}

// Matches reports whether the item passes every set field of the filter.
func (filter Filter) Matches(item Item) bool {
	if filter.Kind != "" && item.Kind != filter.Kind {
		return false
	}
	if filter.Category != "" && item.Category != filter.Category {
		return false
	}
	if filter.Tag != "" && !slices.Contains(item.Tags, filter.Tag) {
		return false
	}
	if filter.Tool != "" && !slices.Contains(item.Tools, filter.Tool) {
		return false
	}
	text := strings.ToLower(filter.Text)
	if text == "" {
		return true
	}
	if strings.Contains(strings.ToLower(item.Name), text) ||
		strings.Contains(strings.ToLower(item.Description), text) ||
		strings.Contains(strings.ToLower(item.Category), text) {
		return true
	}
	for _, tag := range item.Tags {
		if strings.Contains(strings.ToLower(tag), text) {
			return true
		}
	}
	return false
}

// Apply returns the entries that match the filter, in their original order.
func (filter Filter) Apply(entries []Entry) []Entry {
	matched := make([]Entry, 0, len(entries))
	for _, entry := range entries {
		if filter.Matches(entry.Item) {
			matched = append(matched, entry)
		}
	}
	return matched
}

// Facets returns the distinct categories and tags of the entries, sorted, for
// the console's filter lists.
func Facets(entries []Entry) (categories, tags []string) {
	seenCategories := make(map[string]struct{})
	seenTags := make(map[string]struct{})
	categories, tags = make([]string, 0), make([]string, 0)
	for _, entry := range entries {
		if _, seen := seenCategories[entry.Item.Category]; !seen {
			seenCategories[entry.Item.Category] = struct{}{}
			categories = append(categories, entry.Item.Category)
		}
		for _, tag := range entry.Item.Tags {
			if _, seen := seenTags[tag]; !seen {
				seenTags[tag] = struct{}{}
				tags = append(tags, tag)
			}
		}
	}
	slices.Sort(categories)
	slices.Sort(tags)
	return categories, tags
}

// Tools returns every supported tool in display order.
func Tools() []Tool { return []Tool{ToolClaudeCode, ToolCodex, ToolCursor} }

// Label is the tool's display name.
func (tool Tool) Label() string {
	switch tool {
	case ToolClaudeCode:
		return "Claude Code"
	case ToolCodex:
		return "Codex"
	case ToolCursor:
		return "Cursor"
	default:
		return string(tool)
	}
}
```

GREEN: the same command, then `go test -count=1 ./internal/library/`.

### B2 — Markdown preview (unit) + the goldmark dependency

Create `internal/library/preview_test.go`:

```go
package library

import (
	"regexp"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// unsafeURL finds a link or image whose URL could run code or load content.
var unsafeURL = regexp.MustCompile(`(?i)(href|src)="\s*(javascript|vbscript|data|file):`)

func TestRenderMarkdownFormatsCommonMarkdown(t *testing.T) {
	got, err := RenderMarkdown("# Release checklist\n\nSteps before **every** release:\n\n- Run `make check`\n- Tag the commit\n\n| Step | Owner |\n| --- | --- |\n| Tag | Lead |\n\n~~old~~\n")
	if err != nil {
		t.Fatal(err)
	}
	for _, want := range []string{"<h1>Release checklist</h1>", "<strong>every</strong>", "<li>Run <code>make check</code></li>", "<table>", "<th>Step</th>", "<del>old</del>"} {
		if !strings.Contains(string(got), want) {
			t.Fatalf("rendered Markdown missing %q: %s", want, got)
		}
	}
}

func TestRenderMarkdownDropsRawHTMLAndUnsafeLinks(t *testing.T) {
	got, err := RenderMarkdown("<script>alert(1)</script>\n\n<div onclick=\"x()\">block</div>\n\nInline <img src=x onerror=alert(1)> html\n\n" +
		"[a](javascript:alert(1)) [b](JaVaScRiPt:alert(1)) [c](&#106;avascript:alert(1)) [d](vbscript:x) [e](data:text/html,x) [f](file:///etc/passwd) [ok](https://example.com/ok)\n\n" +
		"![img](javascript:alert(1))\n\nname@1.0.0\n")
	if err != nil {
		t.Fatal(err)
	}
	lower := strings.ToLower(string(got))
	for _, banned := range []string{"<script", "onclick", "onerror", "<div", "src=x", "mailto:"} {
		if strings.Contains(lower, banned) {
			t.Fatalf("rendered Markdown kept %q: %s", banned, got)
		}
	}
	if unsafeURL.MatchString(string(got)) {
		t.Fatalf("rendered Markdown kept an unsafe URL: %s", got)
	}
	if !strings.Contains(string(got), `<a href="https://example.com/ok">ok</a>`) {
		t.Fatalf("a safe link was lost: %s", got)
	}
}

func TestPreviewShowsToolFilesAsCode(t *testing.T) {
	for _, kind := range []pack.Kind{pack.KindConfig, pack.KindMCPTemplate} {
		item := Item{Kind: kind, Body: "# ~/.codex/config.toml\napproval_policy = \"on-request\"\n"}
		preview, err := item.Preview()
		if err != nil {
			t.Fatal(err)
		}
		if preview.Code != item.Body || preview.HTML != "" || preview.FrontMatter != "" {
			t.Fatalf("%s preview = %+v, want the body as code", kind, preview)
		}
	}
}

func TestPreviewSplitsFrontMatter(t *testing.T) {
	cases := []struct {
		name, body, frontMatter, wantHTML, bannedHTML string
	}{
		{"agent front matter", "---\nname: doc-writer\ntools: Read, Grep\n---\n\nYou write **clear** docs.\n", "name: doc-writer\ntools: Read, Grep", "<p>You write <strong>clear</strong> docs.</p>", "<hr>"},
		{"empty front matter", "---\n---\nBody\n", "", "<p>Body</p>", "<hr>"},
		{"front matter only", "---\nname: x\n---", "name: x", "", "<h2>"},
		{"no closing line means no front matter", "---\nname: x\nno end\n", "", "", ""},
		{"plain Markdown", "# Title\n", "", "<h1>Title</h1>", "<hr>"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			preview, err := Item{Kind: pack.KindAgent, Body: tc.body}.Preview()
			if err != nil {
				t.Fatal(err)
			}
			if preview.FrontMatter != tc.frontMatter || preview.Code != "" {
				t.Fatalf("preview = %+v, want front matter %q", preview, tc.frontMatter)
			}
			if tc.wantHTML != "" && !strings.Contains(string(preview.HTML), tc.wantHTML) {
				t.Fatalf("HTML = %s, want %q", preview.HTML, tc.wantHTML)
			}
			if tc.bannedHTML != "" && strings.Contains(string(preview.HTML), tc.bannedHTML) {
				t.Fatalf("HTML = %s, must not contain %q", preview.HTML, tc.bannedHTML)
			}
		})
	}
}

func TestPreviewOfEveryShippedItem(t *testing.T) {
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	for _, item := range shipped.Items {
		preview, err := item.Preview()
		if err != nil {
			t.Fatalf("%s: %v", item.Key(), err)
		}
		if preview.Code == "" && strings.TrimSpace(string(preview.HTML)) == "" {
			t.Fatalf("%s has an empty preview", item.Key())
		}
		example, err := RenderMarkdown(item.Example)
		if err != nil || strings.TrimSpace(string(example)) == "" {
			t.Fatalf("%s example = %q, %v", item.Key(), example, err)
		}
	}
}
```

RED: `go test -count=1 -run 'TestRenderMarkdown|TestPreview' ./internal/library/` → `undefined: RenderMarkdown`.

Add the dependency: `cd $WT && go get github.com/yuin/goldmark@v1.7.17` (offline is fine: the zip is in the module cache), then create `internal/library/preview.go`:

```go
package library

import (
	"bytes"
	"fmt"
	"html/template"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
)

// Preview is how the admin console shows an item's body.
type Preview struct {
	// Code is the body shown verbatim, for kinds whose body is a tool file
	// (configs and MCP templates are JSON or TOML, not Markdown).
	Code string
	// FrontMatter is YAML front matter at the top of a Markdown body (agents
	// have it), shown verbatim above the rendered Markdown.
	FrontMatter string
	// HTML is the rest of a Markdown body, rendered by RenderMarkdown.
	HTML template.HTML
}

// markdownRenderer renders CommonMark plus tables and strikethrough. goldmark
// drops raw HTML and empties javascript:, vbscript:, file: and data: link and
// image URLs unless html.WithUnsafe is set. Never set it, and never add the
// Linkify extension (it turns text such as name@1.0.0 into mailto: links):
// library content is shown to administrators and will later include upstream
// and tenant-authored items.
var markdownRenderer = goldmark.New(goldmark.WithExtensions(extension.Table, extension.Strikethrough))

// RenderMarkdown renders Markdown to HTML that is safe to place in an admin page.
func RenderMarkdown(source string) (template.HTML, error) {
	var out bytes.Buffer
	if err := markdownRenderer.Convert([]byte(source), &out); err != nil {
		return "", fmt.Errorf("render markdown: %w", err)
	}
	// Trusted by construction: the renderer escapes text and omits raw HTML and
	// unsafe URLs (security-best-practices GO-XSS-001). This is the only place
	// library content becomes template.HTML.
	return template.HTML(out.String()), nil
}

// Preview renders the item's body for the catalog browser.
func (item Item) Preview() (Preview, error) {
	if item.Kind == pack.KindConfig || item.Kind == pack.KindMCPTemplate {
		return Preview{Code: item.Body}, nil
	}
	frontMatter, markdown := splitFrontMatter(item.Body)
	rendered, err := RenderMarkdown(markdown)
	if err != nil {
		return Preview{}, err
	}
	return Preview{FrontMatter: frontMatter, HTML: rendered}, nil
}

// splitFrontMatter separates YAML front matter (between "---" lines at the very
// top) from the Markdown after it. Without a closing "---" there is no front
// matter. Bodies are already LF-only (the loader normalises line endings).
func splitFrontMatter(body string) (frontMatter, markdown string) {
	const delimiter = "---\n"
	if !strings.HasPrefix(body, delimiter) {
		return "", body
	}
	rest := body[len(delimiter):]
	if strings.HasPrefix(rest, delimiter) {
		return "", rest[len(delimiter):]
	}
	if end := strings.Index(rest, "\n"+delimiter); end >= 0 {
		return rest[:end], rest[end+1+len(delimiter):]
	}
	if strings.HasSuffix(rest, "\n---") {
		return strings.TrimSuffix(rest, "\n---"), ""
	}
	return "", body
}
```

Then `go mod tidy`. `git -C $WT diff --stat` must show only `go.mod` and `go.sum` besides the new files (if `go.work.sum` changes, keep it and say why in the report). GREEN: the same command, then `go test -count=1 ./internal/library/`.

### B3 — Store: newest versions and one item

Create `internal/store/postgres/library_catalog_test.go`:

```go
package postgres

import (
	"context"
	"errors"
	"slices"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/google/uuid"
)

func TestLibraryCatalogWithPostgres(t *testing.T) {
	pool := testPool(t)

	setup := func(t *testing.T) (*Store, store.Principal, context.Context) {
		t.Helper()
		repository := seedBaseStore(t, pool)
		admin, err := repository.ResolveOrCreateGoogleUser(context.Background(), store.GoogleIdentity{Subject: "catalog-admin", Email: "admin@example.com", DisplayName: "Admin"})
		if err != nil {
			t.Fatal(err)
		}
		return repository, admin, store.WithTenant(context.Background(), admin.TenantID)
	}
	// loadTwoVersions stores write-tests 1.9.0 and debugging 1.0.0, then
	// write-tests 1.10.0 with different metadata, the way an upgrade does.
	loadTwoVersions := func(t *testing.T, repository *Store) library.Item {
		t.Helper()
		ctx := context.Background()
		if _, err := repository.loadLibrary(ctx, testLibrary("1.0.0", libraryItem("write-tests", "1.9.0", "Old rules.\n"), libraryItem("debugging", "1.0.0", "Reproduce first.\n"))); err != nil {
			t.Fatal(err)
		}
		newer := libraryItem("write-tests", "1.10.0", "New rules.\n")
		newer.Category = "quality"
		newer.Description = "Newest rules."
		newer.Tags = []string{"tests", "refactoring"}
		newer.Tools = []library.Tool{library.ToolClaudeCode, library.ToolCodex}
		if _, err := repository.loadLibrary(ctx, testLibrary("1.1.0", newer)); err != nil {
			t.Fatal(err)
		}
		return newer
	}

	t.Run("lists the newest version of every item with metadata only", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		newer := loadTwoVersions(t, repository)
		entries, err := repository.ListLibraryItems(scoped, admin)
		if err != nil {
			t.Fatalf("ListLibraryItems: %v", err)
		}
		keys := make([]string, 0, len(entries))
		for _, entry := range entries {
			keys = append(keys, entry.Item.Key())
			if entry.Item.Body != "" || entry.Item.Example != "" {
				t.Fatalf("%s: list rows must not carry the example or body", entry.Item.Key())
			}
			if !validUUID(entry.ID) {
				t.Fatalf("%s: id = %q", entry.Item.Key(), entry.ID)
			}
		}
		// 1.10.0 is newer than 1.9.0: versions compare as numbers, not text.
		if want := []string{"skill/debugging@1.0.0", "skill/write-tests@1.10.0"}; !slices.Equal(keys, want) {
			t.Fatalf("entries = %v, want %v", keys, want)
		}
		got := entries[1].Item
		if got.Category != newer.Category || got.Description != newer.Description || !slices.Equal(got.Tags, newer.Tags) || !slices.Equal(got.Tools, newer.Tools) {
			t.Fatalf("metadata = %+v, want the newest version's", got)
		}
	})

	t.Run("gets any stored version by id with its example and body", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		loadTwoVersions(t, repository)
		var oldID string
		if err := pool.QueryRow(context.Background(), `SELECT id FROM library_items WHERE name='write-tests' AND version='1.9.0'`).Scan(&oldID); err != nil {
			t.Fatal(err)
		}
		entry, err := repository.GetLibraryItem(scoped, admin, oldID)
		if err != nil {
			t.Fatalf("GetLibraryItem: %v", err)
		}
		if entry.ID != oldID || entry.Item.Version != "1.9.0" || entry.Item.Body != "Old rules.\n" || entry.Item.Example != "Ask for it.\n" || entry.Item.Category != "testing" {
			t.Fatalf("entry = %+v", entry)
		}
	})

	t.Run("unknown and malformed ids are not found", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		loadTwoVersions(t, repository)
		for _, id := range []string{uuid.NewString(), "not-a-uuid", ""} {
			if _, err := repository.GetLibraryItem(scoped, admin, id); !errors.Is(err, store.ErrNotFound) {
				t.Fatalf("GetLibraryItem(%q) = %v, want ErrNotFound", id, err)
			}
		}
	})

	t.Run("reads fail closed without the actor's tenant context", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		loadTwoVersions(t, repository)
		other, err := repository.ResolveOrCreateGoogleUser(context.Background(), store.GoogleIdentity{Subject: "catalog-other", Email: "other@example.com", DisplayName: "Other"})
		if err != nil {
			t.Fatal(err)
		}
		var id string
		if err := pool.QueryRow(context.Background(), `SELECT id FROM library_items WHERE name='debugging'`).Scan(&id); err != nil {
			t.Fatal(err)
		}
		stranger := store.Principal{UserID: store.UserID(uuid.NewString()), TenantID: admin.TenantID}
		attempts := map[string]struct {
			ctx   context.Context
			actor store.Principal
		}{
			"no tenant in the context":        {context.Background(), admin},
			"another tenant's context":        {store.WithTenant(context.Background(), other.TenantID), admin},
			"a user who is not in the tenant": {scoped, stranger},
		}
		for name, attempt := range attempts {
			if _, err := repository.ListLibraryItems(attempt.ctx, attempt.actor); !errors.Is(err, store.ErrNotFound) {
				t.Fatalf("%s: ListLibraryItems = %v, want ErrNotFound", name, err)
			}
			if _, err := repository.GetLibraryItem(attempt.ctx, attempt.actor, id); !errors.Is(err, store.ErrNotFound) {
				t.Fatalf("%s: GetLibraryItem = %v, want ErrNotFound", name, err)
			}
		}
	})

	t.Run("every tenant sees the same shared library", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		loadTwoVersions(t, repository)
		other, err := repository.ResolveOrCreateGoogleUser(context.Background(), store.GoogleIdentity{Subject: "catalog-other", Email: "other@example.com", DisplayName: "Other"})
		if err != nil {
			t.Fatal(err)
		}
		mine, err := repository.ListLibraryItems(scoped, admin)
		if err != nil {
			t.Fatal(err)
		}
		theirs, err := repository.ListLibraryItems(store.WithTenant(context.Background(), other.TenantID), other)
		if err != nil {
			t.Fatal(err)
		}
		if len(mine) != 2 || !slices.EqualFunc(mine, theirs, func(a, b library.Entry) bool { return a.ID == b.ID }) {
			t.Fatalf("tenants see different libraries: %v vs %v", mine, theirs)
		}
	})

	t.Run("an empty library lists nothing", func(t *testing.T) {
		repository, admin, scoped := setup(t)
		entries, err := repository.ListLibraryItems(scoped, admin)
		if err != nil || entries == nil || len(entries) != 0 {
			t.Fatalf("entries = %#v, %v; want an empty, non-nil list", entries, err)
		}
	})
}
```

(`testPool`, `seedBaseStore`, `testLibrary`, `libraryItem`, `validUUID` already exist in this package; `libraryItem` gives category `testing`, tags `[tests]`, tools `[claude-code]`, description `A test skill.`, example `Ask for it.\n`.)

RED: `go test -v -count=1 -run '^TestLibraryCatalogWithPostgres$' ./internal/store/postgres/` → `ListLibraryItems undefined`.

Create `internal/store/postgres/library_catalog.go`:

```go
package postgres

import (
	"context"
	"slices"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

var _ library.Catalog = (*Store)(nil)

// ListLibraryItems returns the newest stored version of every library item,
// metadata only, ordered by kind and then name (byte order, so the result does
// not depend on the database collation). Versions compare number by number, so
// 1.10.0 is newer than 1.9.0. The library is shared product content, but the
// read runs as a user of the actor's tenant (beginOrg), so a call without that
// context fails closed.
func (database *Store) ListLibraryItems(ctx context.Context, actor store.Principal) ([]library.Entry, error) {
	tx, _, err := database.beginOrg(ctx, actor, false)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	rows, err := tx.Query(ctx,
		`SELECT DISTINCT ON (kind, name) id, kind, name, version, category, tags, tools, description
		 FROM library_items
		 ORDER BY kind, name, string_to_array(version, '.')::numeric[] DESC`)
	if err != nil {
		return nil, orgError(err)
	}
	defer rows.Close()
	entries := make([]library.Entry, 0)
	for rows.Next() {
		var entry library.Entry
		var kind string
		var tools []string
		if err := rows.Scan(&entry.ID, &kind, &entry.Item.Name, &entry.Item.Version, &entry.Item.Category, &entry.Item.Tags, &tools, &entry.Item.Description); err != nil {
			return nil, orgError(err)
		}
		entry.Item.Kind = pack.Kind(kind)
		entry.Item.Tools = libraryTools(tools)
		entries = append(entries, entry)
	}
	if err := rows.Err(); err != nil {
		return nil, orgError(err)
	}
	slices.SortFunc(entries, func(a, b library.Entry) int {
		if order := strings.Compare(string(a.Item.Kind), string(b.Item.Kind)); order != 0 {
			return order
		}
		return strings.Compare(a.Item.Name, b.Item.Name)
	})
	return entries, nil
}

// GetLibraryItem returns one stored library item version, any version, with
// its example and body. Unknown and malformed IDs return store.ErrNotFound.
func (database *Store) GetLibraryItem(ctx context.Context, actor store.Principal, id string) (library.Entry, error) {
	if !validUUID(id) {
		return library.Entry{}, store.ErrNotFound
	}
	tx, _, err := database.beginOrg(ctx, actor, false)
	if err != nil {
		return library.Entry{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	var entry library.Entry
	var kind string
	var tools []string
	err = tx.QueryRow(ctx,
		`SELECT id, kind, name, version, category, tags, tools, description, example, body FROM library_items WHERE id=$1`, id,
	).Scan(&entry.ID, &kind, &entry.Item.Name, &entry.Item.Version, &entry.Item.Category, &entry.Item.Tags, &tools, &entry.Item.Description, &entry.Item.Example, &entry.Item.Body)
	if err != nil {
		return library.Entry{}, orgError(err)
	}
	entry.Item.Kind = pack.Kind(kind)
	entry.Item.Tools = libraryTools(tools)
	return entry, nil
}

func libraryTools(values []string) []library.Tool {
	tools := make([]library.Tool, 0, len(values))
	for _, value := range values {
		tools = append(tools, library.Tool(value))
	}
	return tools
}
```

GREEN: the same command; regression: `go test -v -count=1 -run '^TestEnsureLibraryWithPostgres$' ./internal/store/postgres/`.

Commit 1 (B1–B3): `git add internal/library/catalog.go internal/library/catalog_test.go internal/library/preview.go internal/library/preview_test.go internal/store/postgres/library_catalog.go internal/store/postgres/library_catalog_test.go go.mod go.sum && git commit -m "feat(86bcm901v): filter, preview and read the content library"`.

### B4 — AC1: the library page with filters and search (+ access tests, written first)

1. In `internal/web/packs_test.go`, give `newPackFixture` a hook that runs before the server starts (existing callers don't change):
   - signature: `func newPackFixture(t *testing.T, configure ...func(*Handler, *postgres.Store)) packFixture {`
   - add a comment line above it: `// configure runs before the server starts, so a test can wire more of the handler.`
   - right after `handler.SetPacks(repository, seed)` insert:
     ```go
     for _, apply := range configure {
     	apply(handler, repository)
     }
     ```
2. Create `internal/web/library_test.go` with the helpers, `TestLibraryAC1FilterAndSearchWithPostgres` and `TestLibraryAccessWithPostgres` (AC2/AC3/shipped tests are appended in B5–B7):

```go
package web

import (
	"context"
	"errors"
	"fmt"
	"html"
	"io"
	"net/http"
	"regexp"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/LeornaAI/leorna-control-plane/internal/store/postgres"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

// newLibraryFixture is the pack fixture with the catalog browser wired to the
// real Postgres store. Its library starts empty; tests insert what they need.
func newLibraryFixture(t *testing.T) packFixture {
	t.Helper()
	return newPackFixture(t, func(handler *Handler, repository *postgres.Store) { handler.SetLibrary(repository) })
}

// insertLibraryItems stores items straight into library_items, the rows the
// startup loader writes, so a test controls exactly what the library holds.
// It returns each item's row id keyed by "kind/name@version".
func insertLibraryItems(t *testing.T, pool *pgxpool.Pool, items ...library.Item) map[string]string {
	t.Helper()
	ids := make(map[string]string, len(items))
	for _, item := range items {
		if err := item.Validate(); err != nil {
			t.Fatalf("fixture item %s: %v", item.Key(), err)
		}
		id := uuid.NewString()
		tools := make([]string, 0, len(item.Tools))
		for _, tool := range item.Tools {
			tools = append(tools, string(tool))
		}
		if _, err := pool.Exec(context.Background(),
			`INSERT INTO library_items(id,kind,name,version,category,tags,tools,description,example,body,content_sha256,library_version)
			 VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,'9.9.9')`,
			id, string(item.Kind), item.Name, item.Version, item.Category, item.Tags, tools,
			item.Description, item.Example, item.Body, item.Checksum()); err != nil {
			t.Fatalf("insert %s: %v", item.Key(), err)
		}
		ids[item.Key()] = id
	}
	return ids
}

// catalogFixtureItems is a small library with every kind, overlapping
// categories, tags and tools, and two versions of code-reviewer.
func catalogFixtureItems() []library.Item {
	item := func(kind pack.Kind, name, version, category string, tags []string, tools []library.Tool, description string) library.Item {
		return library.Item{Kind: kind, Name: name, Version: version, Category: category, Tags: tags, Tools: tools,
			Description: description, Example: "Ask for " + name + ".\n", Body: "# " + name + "\n\nUse it well.\n"}
	}
	all := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
	return []library.Item{
		item(pack.KindSkill, "code-review-checklist", "1.0.0", "code-quality", []string{"code-review", "pull-requests"}, all, "Checklist for pull requests."),
		item(pack.KindSkill, "commit-message-style", "1.2.0", "code-quality", []string{"git", "conventions"}, []library.Tool{library.ToolClaudeCode, library.ToolCodex}, "Conventional commit messages."),
		item(pack.KindSkill, "incident-postmortem", "1.0.0", "incident-response", []string{"incidents", "writing"}, []library.Tool{library.ToolClaudeCode}, "Blameless postmortem template."),
		item(pack.KindAgent, "code-reviewer", "1.9.0", "code-quality", []string{"code-review", "security"}, []library.Tool{library.ToolClaudeCode, library.ToolCursor}, "Reviews a diff for correctness and security."),
		item(pack.KindAgent, "code-reviewer", "1.10.0", "code-quality", []string{"code-review", "security"}, []library.Tool{library.ToolClaudeCode, library.ToolCursor}, "Reviews a diff for correctness and security."),
		item(pack.KindAgent, "test-writer", "2.0.0", "testing", []string{"tests", "tdd"}, all, "Writes focused, behaviour-driven tests."),
		item(pack.KindConfig, "codex-defaults", "1.1.0", "configuration", []string{"codex", "sandbox"}, []library.Tool{library.ToolCodex}, "Codex defaults with a workspace-write sandbox."),
		item(pack.KindConfig, "claude-code-settings", "1.0.0", "configuration", []string{"permissions"}, []library.Tool{library.ToolClaudeCode}, "Baseline Claude Code settings."),
		item(pack.KindMCPTemplate, "github-mcp", "2.0.0", "integrations", []string{"github", "mcp"}, all, "GitHub MCP server template."),
	}
}

// allCatalogNames is every fixture item once, in page order (kind, then name).
var allCatalogNames = []string{"code-reviewer", "test-writer", "claude-code-settings", "codex-defaults", "github-mcp", "code-review-checklist", "commit-message-style", "incident-postmortem"}

var (
	libraryRowPattern  = regexp.MustCompile(`(?s)<tr class="item">.*?</tr>`)
	libraryLinkPattern = regexp.MustCompile(`<a class="item-name" href="/admin/library/items/([0-9a-f-]{36})">([^<]+)</a><div class="muted">[^<]*</div></td><td>([^<]+)</td>`)
	optionValuePattern = regexp.MustCompile(`<option value="([^"]+)"`)
	unsafeLinkPattern  = regexp.MustCompile(`(?i)(href|src)="\s*(javascript|vbscript|data|file):`)
)

// readPage reads a whole page. readBody stops at 64 KiB, and a 240-row
// library page is larger than that.
func readPage(t *testing.T, response *http.Response) string {
	t.Helper()
	body, err := io.ReadAll(io.LimitReader(response.Body, 4<<20))
	if err != nil {
		t.Fatalf("read page: %v", err)
	}
	closeBody(t, response)
	return string(body)
}

// fetchPage GETs a page, checks its status and returns the whole body.
func fetchPage(t *testing.T, client *http.Client, target string, want int) (string, http.Header) {
	t.Helper()
	response := request(t, client, http.MethodGet, target, "", "")
	body := readPage(t, response)
	if response.StatusCode != want {
		t.Fatalf("GET %s status = %d, want %d; body=%q", target, response.StatusCode, want, body)
	}
	return body, response.Header
}

// libraryNames lists the item names on a library page, in page order.
func libraryNames(body string) []string {
	names := []string{}
	for _, match := range libraryLinkPattern.FindAllStringSubmatch(body, -1) {
		names = append(names, match[2])
	}
	return names
}

// libraryLinks maps "<kind label>/<name>" to the item id linked from the list.
func libraryLinks(body string) map[string]string {
	links := map[string]string{}
	for _, match := range libraryLinkPattern.FindAllStringSubmatch(body, -1) {
		links[match[3]+"/"+match[2]] = match[1]
	}
	return links
}

// libraryRowFor returns the table row of the named item.
func libraryRowFor(t *testing.T, body, name string) string {
	t.Helper()
	for _, row := range libraryRowPattern.FindAllString(body, -1) {
		if strings.Contains(row, ">"+name+"</a>") {
			return row
		}
	}
	t.Fatalf("no row for %s: %s", name, body)
	return ""
}

// selectOptions lists the non-empty option values of the named select.
func selectOptions(t *testing.T, body, name string) []string {
	t.Helper()
	start := strings.Index(body, `<select name="`+name+`">`)
	if start < 0 {
		t.Fatalf("page has no %s select: %s", name, body)
	}
	end := strings.Index(body[start:], "</select>")
	if end < 0 {
		t.Fatalf("unterminated %s select", name)
	}
	values := []string{}
	for _, match := range optionValuePattern.FindAllStringSubmatch(body[start:start+end], -1) {
		values = append(values, match[1])
	}
	return values
}

// fragment returns the page from marker to the end of its section, so an
// assertion only looks at one part of the page.
func fragment(t *testing.T, body, marker string) string {
	t.Helper()
	start := strings.Index(body, marker)
	if start < 0 {
		t.Fatalf("page has no %q: %s", marker, body)
	}
	end := strings.Index(body[start:], "</section>")
	if end < 0 {
		end = len(body) - start
	}
	return body[start : start+end]
}

// ddByID returns the contents of <dd id="...">.
func ddByID(t *testing.T, body, id string) string {
	t.Helper()
	match := regexp.MustCompile(`(?s)<dd id="` + regexp.QuoteMeta(id) + `">(.*?)</dd>`).FindStringSubmatch(body)
	if match == nil {
		t.Fatalf("page has no dd#%s: %s", id, body)
	}
	return match[1]
}

// failingCatalog stands in for a store that cannot answer.
type failingCatalog struct{}

func (failingCatalog) ListLibraryItems(context.Context, store.Principal) ([]library.Entry, error) {
	return nil, errors.New("connection refused by db-internal-host")
}

func (failingCatalog) GetLibraryItem(context.Context, store.Principal, string) (library.Entry, error) {
	return library.Entry{}, errors.New("connection refused by db-internal-host")
}

func TestLibraryAC1FilterAndSearchWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	insertLibraryItems(t, fixture.pool, catalogFixtureItems()...)
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	libraryURL := fixture.server.URL + "/admin/library"

	t.Run("admin_console_links_to_the_library", func(t *testing.T) {
		body, _ := fetchPage(t, adminClient, fixture.server.URL+"/admin", http.StatusOK)
		if !strings.Contains(body, `<a href="/admin/library">Library</a>`) {
			t.Fatalf("admin console has no library link: %s", body)
		}
	})

	t.Run("library_lists_every_item_with_filter_controls", func(t *testing.T) {
		body, header := fetchPage(t, adminClient, libraryURL, http.StatusOK)
		if header.Get("Cache-Control") != "no-store" || !strings.Contains(header.Get("Content-Security-Policy"), "default-src 'none'") {
			t.Fatalf("headers = %v", header)
		}
		if got := libraryNames(body); !slices.Equal(got, allCatalogNames) {
			t.Fatalf("items = %v, want %v", got, allCatalogNames)
		}
		for _, want := range []string{"Showing 8 of 8 items", `<form class="filters" method="get" action="/admin/library"`, `<input type="search" name="q"`} {
			if !strings.Contains(body, want) {
				t.Fatalf("library page missing %q: %s", want, body)
			}
		}
		wantKinds := []string{}
		for _, kind := range pack.Kinds() {
			wantKinds = append(wantKinds, string(kind))
		}
		for name, want := range map[string][]string{
			"kind":     wantKinds,
			"category": {"code-quality", "configuration", "incident-response", "integrations", "testing"},
			"tag":      {"code-review", "codex", "conventions", "git", "github", "incidents", "mcp", "permissions", "pull-requests", "sandbox", "security", "tdd", "tests", "writing"},
			"tool":     {"claude-code", "codex", "cursor"},
		} {
			if got := selectOptions(t, body, name); !slices.Equal(got, want) {
				t.Fatalf("%s options = %v, want %v", name, got, want)
			}
		}
		// One row per item, and the newest version wins: 1.10.0 beats 1.9.0.
		row := libraryRowFor(t, body, "code-reviewer")
		if !strings.Contains(row, "<td>1.10.0</td>") || strings.Contains(row, "1.9.0") {
			t.Fatalf("code-reviewer row = %s, want only version 1.10.0", row)
		}
		if len(libraryRowPattern.FindAllString(body, -1)) != len(allCatalogNames) {
			t.Fatalf("row count differs from the item count: %s", body)
		}
	})

	cases := []struct {
		name, query string
		want        []string
	}{
		{"filter_by_kind", "?kind=skill", []string{"code-review-checklist", "commit-message-style", "incident-postmortem"}},
		{"filter_by_category", "?category=code-quality", []string{"code-reviewer", "code-review-checklist", "commit-message-style"}},
		{"filter_by_tag", "?tag=code-review", []string{"code-reviewer", "code-review-checklist"}},
		{"filter_by_supported_tool", "?tool=codex", []string{"test-writer", "codex-defaults", "github-mcp", "code-review-checklist", "commit-message-style"}},
		{"search_by_text_in_the_name_in_any_case", "?q=POSTMORTEM", []string{"incident-postmortem"}},
		{"search_by_text_in_the_description_or_a_tag", "?q=sandbox", []string{"codex-defaults"}},
		{"filters_and_search_combine", "?kind=skill&tool=codex&q=review", []string{"code-review-checklist"}},
		{"empty_form_fields_mean_any", "?kind=&category=&tag=&tool=&q=", allCatalogNames},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			body, _ := fetchPage(t, adminClient, libraryURL+tc.query, http.StatusOK)
			if got := libraryNames(body); !slices.Equal(got, tc.want) {
				t.Fatalf("%s items = %v, want %v", tc.query, got, tc.want)
			}
			if want := fmt.Sprintf("Showing %d of 8 items", len(tc.want)); !strings.Contains(body, want) {
				t.Fatalf("%s page missing %q", tc.query, want)
			}
		})
	}

	t.Run("chosen_filters_stay_selected", func(t *testing.T) {
		body, _ := fetchPage(t, adminClient, libraryURL+"?kind=skill&tool=codex&q=review", http.StatusOK)
		for _, want := range []string{`<option value="skill" selected>Skill</option>`, `<option value="codex" selected>Codex</option>`, `name="q" value="review"`} {
			if !strings.Contains(body, want) {
				t.Fatalf("page missing %q: %s", want, body)
			}
		}
	})

	t.Run("no_match_shows_an_empty_state", func(t *testing.T) {
		body, _ := fetchPage(t, adminClient, libraryURL+"?kind=config&tag=github", http.StatusOK)
		if names := libraryNames(body); len(names) != 0 {
			t.Fatalf("items = %v, want none", names)
		}
		for _, want := range []string{"Showing 0 of 8 items", "No items match these filters", `<a href="/admin/library">Clear filters</a>`} {
			if !strings.Contains(body, want) {
				t.Fatalf("empty state missing %q: %s", want, body)
			}
		}
	})

	t.Run("impossible_filters_are_rejected", func(t *testing.T) {
		for _, query := range []string{
			"?kind=widget", "?tool=vim", "?category=Not+A+Slug", "?tag=%3Cscript%3E",
			"?q=" + strings.Repeat("a", library.MaxQueryRunes+1), "?q=%01",
			"?kind=skill&kind=agent", "?colour=red",
		} {
			body, header := fetchPage(t, adminClient, libraryURL+query, http.StatusBadRequest)
			if !strings.Contains(header.Get("Content-Type"), "text/html") || !strings.Contains(body, `role="alert"`) || !strings.Contains(body, "Check the filters") {
				t.Fatalf("%s: no inline filter error: %s", query, body)
			}
			if names := libraryNames(body); len(names) != 0 {
				t.Fatalf("%s: rejected filter still listed %v", query, names)
			}
			if strings.Contains(body, "<script>") {
				t.Fatalf("%s: input reflected unescaped: %s", query, body)
			}
		}
	})
}

func TestLibraryAccessWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	ids := insertLibraryItems(t, fixture.pool, catalogFixtureItems()[:2]...)
	listURL := fixture.server.URL + "/admin/library"
	itemURL := fixture.server.URL + "/admin/library/items/" + ids["skill/code-review-checklist@1.0.0"]
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	memberClient := fixture.login(t, fixture.member, strings.Repeat("b", 43))
	otherClient := fixture.login(t, fixture.other, strings.Repeat("d", 43))

	t.Run("members_are_refused", func(t *testing.T) {
		for _, target := range []string{listURL, itemURL} {
			if body, _ := fetchPage(t, memberClient, target, http.StatusForbidden); !strings.Contains(body, "ADMIN_REQUIRED") {
				t.Fatalf("member %s body = %s", target, body)
			}
		}
	})

	t.Run("signed_out_visitors_are_sent_to_sign_in", func(t *testing.T) {
		signedOut := newTestClient(t, fixture.server)
		for _, target := range []string{listURL, itemURL} {
			response := request(t, signedOut, http.MethodGet, target, "", "")
			closeBody(t, response)
			if response.StatusCode != http.StatusFound || response.Header.Get("Location") != "/v1/auth/google/login" {
				t.Fatalf("signed out %s = %d %q", target, response.StatusCode, response.Header.Get("Location"))
			}
		}
	})

	t.Run("every_tenant_admin_sees_the_same_shared_library", func(t *testing.T) {
		mine, _ := fetchPage(t, adminClient, listURL, http.StatusOK)
		theirs, _ := fetchPage(t, otherClient, listURL, http.StatusOK)
		want := []string{"code-review-checklist", "commit-message-style"}
		if !slices.Equal(libraryNames(mine), want) || !slices.Equal(libraryNames(theirs), want) {
			t.Fatalf("libraries differ: %v vs %v", libraryNames(mine), libraryNames(theirs))
		}
	})

	t.Run("tenant_pack_content_never_appears_in_the_library", func(t *testing.T) {
		scoped := store.WithTenant(context.Background(), fixture.admin.TenantID)
		if _, err := fixture.repository.CreateVersion(scoped, fixture.admin, pack.NewPackVersion{
			Name: "Team pack", Version: "team-1",
			Items: []pack.SeedItem{{Kind: pack.KindSkill, Name: "tenant-only-skill", Version: "1.0.0", Description: "Private to tenant A", Body: "Our rules.\n"}},
		}); err != nil {
			t.Fatalf("CreateVersion: %v", err)
		}
		for _, client := range []*http.Client{adminClient, otherClient} {
			if body, _ := fetchPage(t, client, listURL, http.StatusOK); strings.Contains(body, "tenant-only-skill") {
				t.Fatalf("tenant pack item leaked into the library: %s", body)
			}
		}
	})

	t.Run("an_unwired_library_is_unavailable", func(t *testing.T) {
		bare := newPackFixture(t)
		client := bare.login(t, bare.admin, strings.Repeat("e", 43))
		if body, _ := fetchPage(t, client, bare.server.URL+"/admin/library", http.StatusServiceUnavailable); !strings.Contains(body, "LIBRARY_UNAVAILABLE") {
			t.Fatalf("body = %s", body)
		}
	})

	t.Run("a_store_failure_is_a_generic_problem", func(t *testing.T) {
		failing := newPackFixture(t, func(handler *Handler, _ *postgres.Store) { handler.SetLibrary(failingCatalog{}) })
		client := failing.login(t, failing.admin, strings.Repeat("f", 43))
		for _, path := range []string{"/admin/library", "/admin/library/items/" + uuid.NewString()} {
			body, header := fetchPage(t, client, failing.server.URL+path, http.StatusInternalServerError)
			if !strings.Contains(body, "LIBRARY_FAILED") || strings.Contains(body, "db-internal-host") || header.Get("X-Trace-ID") == "" {
				t.Fatalf("%s problem = %s", path, body)
			}
		}
	})
}
```

(Imports `html` and `time` are used by B6/B7; if you run B4 before appending them, temporarily drop those two imports, then restore them.)

RED: `go test -v -count=1 -run '^(TestLibraryAC1FilterAndSearchWithPostgres|TestLibraryAccessWithPostgres)$' ./internal/web/` → build failure: `handler.SetLibrary undefined (type *Handler has no field or method SetLibrary)` and `FAIL …/internal/web [build failed]`.

3. `internal/web/handler.go`:
   - import `"github.com/LeornaAI/leorna-control-plane/internal/library"` in the internal block;
   - add to `Handler` after `packSeed pack.Seed`: `libraryCatalog library.Catalog` (keep gofmt alignment);
   - in `Routes()`, right after the `POST /admin/packs/assignments/project` line:
     ```go
     routes.Handle("GET /admin/library", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryView)), true))
     routes.Handle("GET /admin/library/items/{itemId}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryItemView)), true))
     ```
     Register both routes now: the access test opens the item page too, so B4 writes both handlers and both templates (all of `library.go` below). B5 then records AC2's RED by commenting out the item route once.
   - in `adminTemplate`, replace `<a href="/admin/packs">Packs</a> · <a href="/admin/setup">Setup</a>` with `<a href="/admin/packs">Packs</a> · <a href="/admin/library">Library</a> · <a href="/admin/setup">Setup</a>`.
4. Create `internal/web/library.go` (list and item pages):

```go
package web

import (
	"bytes"
	"errors"
	"html/template"
	"net/http"
	"net/url"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// libraryFilterHelp is shown when a filter value is impossible.
const libraryFilterHelp = "Check the filters: pick kind, category, tag and tool from the lists, and keep the search to 100 characters of plain text."

// SetLibrary binds the stored content library that the catalog browser reads.
func (handler *Handler) SetLibrary(catalog library.Catalog) { handler.libraryCatalog = catalog }

// libraryFilter reads the catalog filters from the query. Each key may appear
// once and unknown keys are rejected, like the dashboards' filters.
func libraryFilter(query url.Values) (library.Filter, error) {
	for key, values := range query {
		switch key {
		case "kind", "category", "tag", "tool", "q":
		default:
			return library.Filter{}, library.ErrInvalid
		}
		if len(values) != 1 {
			return library.Filter{}, library.ErrInvalid
		}
	}
	filter := library.Filter{
		Kind:     pack.Kind(query.Get("kind")),
		Category: query.Get("category"),
		Tag:      query.Get("tag"),
		Tool:     library.Tool(query.Get("tool")),
		Text:     strings.TrimSpace(query.Get("q")),
	}
	if err := filter.Validate(); err != nil {
		return library.Filter{}, err
	}
	return filter, nil
}

type libraryOption struct {
	Value, Label string
	Selected     bool
}

type libraryRow struct {
	ID, Name, KindLabel, Version, Category, Description string
	Tags, Tools                                         []string
}

type libraryPageData struct {
	Nonce                          string
	Kinds, Categories, Tags, Tools []libraryOption
	Query                          string
	Items                          []libraryRow
	Total                          int
	FilterError                    string
}

type libraryItemPageData struct {
	Nonce     string
	KindLabel string
	Item      library.Item
	Tools     []string
	Example   template.HTML
	Preview   library.Preview
}

// newLibraryPage builds the list page: the filter lists come from the whole
// library and the rows from the entries that match.
func newLibraryPage(entries []library.Entry, filter library.Filter) libraryPageData {
	categories, tags := library.Facets(entries)
	page := libraryPageData{Query: filter.Text, Total: len(entries)}
	for _, kind := range pack.Kinds() {
		page.Kinds = append(page.Kinds, libraryOption{Value: string(kind), Label: kind.Label(), Selected: kind == filter.Kind})
	}
	for _, category := range categories {
		page.Categories = append(page.Categories, libraryOption{Value: category, Label: category, Selected: category == filter.Category})
	}
	for _, tag := range tags {
		page.Tags = append(page.Tags, libraryOption{Value: tag, Label: tag, Selected: tag == filter.Tag})
	}
	for _, tool := range library.Tools() {
		page.Tools = append(page.Tools, libraryOption{Value: string(tool), Label: tool.Label(), Selected: tool == filter.Tool})
	}
	for _, entry := range filter.Apply(entries) {
		page.Items = append(page.Items, libraryRow{
			ID: entry.ID, Name: entry.Item.Name, KindLabel: entry.Item.Kind.Label(), Version: entry.Item.Version,
			Category: entry.Item.Category, Description: entry.Item.Description, Tags: entry.Item.Tags, Tools: toolLabels(entry.Item.Tools),
		})
	}
	return page
}

func (handler *Handler) libraryView(w http.ResponseWriter, r *http.Request) {
	if handler.libraryCatalog == nil {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "LIBRARY_UNAVAILABLE", "The content library is unavailable")
		return
	}
	entries, err := handler.libraryCatalog.ListLibraryItems(r.Context(), teamActor(r))
	if err != nil {
		handler.libraryResult(w, r, err)
		return
	}
	status := http.StatusOK
	filter, err := libraryFilter(r.URL.Query())
	page := newLibraryPage(entries, filter)
	if err != nil {
		status = http.StatusBadRequest
		page.Items = nil
		page.FilterError = libraryFilterHelp
	}
	nonce, err := handler.randomHex(16)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library could not be rendered", err)
		return
	}
	page.Nonce = nonce
	var body bytes.Buffer
	if err := libraryTemplate.Execute(&body, page); err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library could not be rendered", err)
		return
	}
	handler.writeHTMLPage(w, nonce, status, &body)
}

func (handler *Handler) libraryItemView(w http.ResponseWriter, r *http.Request) {
	if handler.libraryCatalog == nil {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "LIBRARY_UNAVAILABLE", "The content library is unavailable")
		return
	}
	entry, err := handler.libraryCatalog.GetLibraryItem(r.Context(), teamActor(r), r.PathValue("itemId"))
	if err != nil {
		handler.libraryResult(w, r, err)
		return
	}
	example, err := library.RenderMarkdown(entry.Item.Example)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library item could not be rendered", err)
		return
	}
	preview, err := entry.Item.Preview()
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library item could not be rendered", err)
		return
	}
	nonce, err := handler.randomHex(16)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library item could not be rendered", err)
		return
	}
	var body bytes.Buffer
	if err := libraryItemTemplate.Execute(&body, libraryItemPageData{
		Nonce: nonce, KindLabel: entry.Item.Kind.Label(), Item: entry.Item,
		Tools: toolLabels(entry.Item.Tools), Example: example, Preview: preview,
	}); err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library item could not be rendered", err)
		return
	}
	handler.writeHTMLPage(w, nonce, http.StatusOK, &body)
}

func (handler *Handler) libraryResult(w http.ResponseWriter, r *http.Request, err error) {
	switch {
	case errors.Is(err, org.ErrForbidden):
		handler.writeProblem(w, r, http.StatusForbidden, "ADMIN_REQUIRED", "Administration rights are required")
	case errors.Is(err, store.ErrNotFound):
		handler.writeProblem(w, r, http.StatusNotFound, "NOT_FOUND", "The requested library item is unavailable")
	default:
		handler.writeProblem(w, r, http.StatusInternalServerError, "LIBRARY_FAILED", "The content library could not be read", err)
	}
}

func toolLabels(tools []library.Tool) []string {
	labels := make([]string, 0, len(tools))
	for _, tool := range tools {
		labels = append(labels, tool.Label())
	}
	return labels
}

// libraryCSS adds the catalog's filter bar, chips, alert and rendered-Markdown
// styles to adminBaseCSS.
const libraryCSS = `h1{margin:.5rem 0}.lede{color:#9db0c7;max-width:48rem}.filters{display:flex;flex-wrap:wrap;align-items:end;gap:.5rem;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}.filters label{display:grid;gap:.35rem}.chip{display:inline-block;margin:.1rem .25rem .1rem 0;padding:.15rem .5rem;border-radius:.5rem;background:#1b2c42;color:#70d6c7;font-size:.8rem}.item-name{font-weight:700}.alert{padding:1rem 1.25rem;background:#2a1620;border:1px solid #7a3446;border-radius:.75rem}.empty{padding:1.5rem;background:#101d2e;border-radius:1rem}.eyebrow{color:#70d6c7;font-weight:700;letter-spacing:.08em;text-transform:uppercase;font-size:.8rem;margin:1.5rem 0 0}.facts{display:grid;grid-template-columns:10rem 1fr;gap:.6rem}.facts dt{color:#9db0c7}.facts dd{margin:0}.markdown{line-height:1.55}.markdown h1,.markdown h2,.markdown h3{margin:1rem 0 .5rem}.markdown code{font:13px ui-monospace,SFMono-Regular,Menlo,monospace;background:#07111f;border:1px solid #2b4058;border-radius:.3rem;padding:0 .25rem}.markdown pre code{border:0;padding:0}.markdown table{width:auto}.markdown th,.markdown td{padding:.4rem .75rem;border:1px solid #2b4058}`

var libraryTemplate = template.Must(template.New("library").Parse(`<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Leorna — Content library</title>
  <style nonce="{{.Nonce}}">` + adminBaseCSS + libraryCSS + `</style>
</head>
<body>
<main>
  <p><a href="/admin">Admin workspace</a> · <a href="/admin/packs">Packs</a></p>
  <h1>Content library</h1>
  <p class="lede">Skills, agents, configs and MCP templates shipped with Leorna. Filter or search to find what your teams need, then open an item for its details and a preview.</p>
  <form class="filters" method="get" action="/admin/library" role="search" aria-label="Filter the library">
    <label>Kind<select name="kind"><option value="">All kinds</option>{{range .Kinds}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></label>
    <label>Category<select name="category"><option value="">All categories</option>{{range .Categories}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></label>
    <label>Tag<select name="tag"><option value="">All tags</option>{{range .Tags}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></label>
    <label>Supported tool<select name="tool"><option value="">All tools</option>{{range .Tools}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></label>
    <label>Search<input type="search" name="q" value="{{.Query}}" maxlength="100" placeholder="Name, description, category or tag"></label>
    <button type="submit">Apply filters</button>
    <a href="/admin/library">Clear filters</a>
  </form>
  {{if .FilterError}}<p role="alert" class="alert">{{.FilterError}}</p>{{else}}
  <p class="muted" id="result-count">Showing {{len .Items}} of {{.Total}} items</p>
  {{if .Items}}<section aria-labelledby="result-count">
  <table>
    <thead><tr><th scope="col">Item</th><th scope="col">Kind</th><th scope="col">Category</th><th scope="col">Tags</th><th scope="col">Supported tools</th><th scope="col">Version</th></tr></thead>
    <tbody>{{range .Items}}
      <tr class="item"><td><a class="item-name" href="/admin/library/items/{{.ID}}">{{.Name}}</a><div class="muted">{{.Description}}</div></td><td>{{.KindLabel}}</td><td>{{.Category}}</td><td>{{range .Tags}}<span class="chip">{{.}}</span>{{end}}</td><td>{{range .Tools}}<span class="chip">{{.}}</span>{{end}}</td><td>{{.Version}}</td></tr>{{end}}
    </tbody>
  </table>
  </section>{{else}}<section class="empty"><h2>No items match these filters</h2><p><a href="/admin/library">Clear filters</a> to see the whole library.</p></section>{{end}}{{end}}
</main>
</body>
</html>`))

var libraryItemTemplate = template.Must(template.New("libraryItem").Parse(`<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Leorna — {{.Item.Name}}</title>
  <style nonce="{{.Nonce}}">` + adminBaseCSS + libraryCSS + `</style>
</head>
<body>
<main>
  <p><a href="/admin/library">Back to the library</a></p>
  <p class="eyebrow">{{.KindLabel}}</p>
  <h1>{{.Item.Name}}</h1>
  <dl class="facts">
    <dt>Version</dt><dd id="item-version">{{.Item.Version}}</dd>
    <dt>Category</dt><dd id="item-category">{{.Item.Category}}</dd>
    <dt>Tags</dt><dd id="item-tags">{{range .Item.Tags}}<span class="chip">{{.}}</span>{{end}}</dd>
    <dt>Supported tools</dt><dd id="item-tools">{{range .Tools}}<span class="chip">{{.}}</span>{{end}}</dd>
  </dl>
  <section aria-labelledby="description-title"><h2 id="description-title">Description</h2><p id="item-description">{{.Item.Description}}</p></section>
  <section aria-labelledby="example-title"><h2 id="example-title">Example</h2><div class="markdown" id="item-example">{{.Example}}</div></section>
  <section aria-labelledby="preview-title"><h2 id="preview-title">Preview</h2>{{if .Preview.Code}}
    <p class="muted">The file as it is synced into the tool.</p>
    <pre id="item-preview"><code>{{.Preview.Code}}</code></pre>{{else}}{{if .Preview.FrontMatter}}
    <p class="muted">Front matter</p>
    <pre class="front-matter"><code>{{.Preview.FrontMatter}}</code></pre>{{end}}
    <div class="markdown" id="item-preview">{{.Preview.HTML}}</div>{{end}}
  </section>
</main>
</body>
</html>`))
```

GREEN: the RED command passes (both tests). Regression: `go test -count=1 ./internal/web/` (with the DB env) — every existing web test still passes, including `TestAdminHomeShowsClientDomainAndStatus` and `TestPackCatalogWithPostgres`.

### B5 — AC2: the item page

Append to `internal/web/library_test.go`:

```go
// detailFixtureItems has one item per preview style: Markdown with hostile
// HTML and links (skill), a JSON tool file (config) and front matter (agent).
func detailFixtureItems() []library.Item {
	return []library.Item{
		{Kind: pack.KindSkill, Name: "release-checklist", Version: "2.3.1", Category: "release", Tags: []string{"release", "checklist"},
			Tools: []library.Tool{library.ToolClaudeCode, library.ToolCursor}, Description: "Pre-release checklist for tagged builds.",
			Example: "Ask: \"Run the **release** checklist before tagging.\"\n",
			Body: "# Release checklist\n\nSteps before **every** release:\n\n- Run `make check`\n- Tag the commit\n\n| Step | Owner |\n| --- | --- |\n| Tag | Lead |\n\n" +
				"<script>alert(1)</script>\n\nInline <img src=x onerror=alert(1)> html and [a link](javascript:alert(1)).\n"},
		{Kind: pack.KindConfig, Name: "strict-settings", Version: "1.0.0", Category: "configuration", Tags: []string{"permissions"},
			Tools: []library.Tool{library.ToolClaudeCode}, Description: "Settings that deny destructive shell commands.",
			Example: "Synced into Claude Code settings.\n", Body: "{\"permissions\": {\"deny\": [\"Bash(rm -rf:*)\"]}}\n"},
		{Kind: pack.KindAgent, Name: "doc-writer", Version: "1.0.0", Category: "documentation", Tags: []string{"docs"},
			Tools: []library.Tool{library.ToolClaudeCode, library.ToolCodex}, Description: "Writes clear documentation.",
			Example: "Ask the doc-writer agent to document a package.\n", Body: "---\nname: doc-writer\ntools: Read, Grep\n---\n\nYou write **clear** docs.\n"},
	}
}

func TestLibraryAC2ItemDetailWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	ids := insertLibraryItems(t, fixture.pool, detailFixtureItems()...)
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	list, _ := fetchPage(t, adminClient, fixture.server.URL+"/admin/library", http.StatusOK)
	links := libraryLinks(list)
	open := func(t *testing.T, key string) string {
		t.Helper()
		id, ok := links[key]
		if !ok {
			t.Fatalf("the library does not link %s: %v", key, links)
		}
		body, header := fetchPage(t, adminClient, fixture.server.URL+"/admin/library/items/"+id, http.StatusOK)
		if header.Get("Cache-Control") != "no-store" || !strings.Contains(header.Get("Content-Security-Policy"), "default-src 'none'") {
			t.Fatalf("headers = %v", header)
		}
		return body
	}

	t.Run("item_page_shows_description_example_version_tools_and_a_rendered_preview", func(t *testing.T) {
		if links["Skill/release-checklist"] != ids["skill/release-checklist@2.3.1"] {
			t.Fatalf("list links release-checklist to %q", links["Skill/release-checklist"])
		}
		body := open(t, "Skill/release-checklist")
		for _, want := range []string{`<p class="eyebrow">Skill</p>`, "<h1>release-checklist</h1>", `<dd id="item-version">2.3.1</dd>`, `<dd id="item-category">release</dd>`, `<p id="item-description">Pre-release checklist for tagged builds.</p>`} {
			if !strings.Contains(body, want) {
				t.Fatalf("item page missing %q: %s", want, body)
			}
		}
		tools := ddByID(t, body, "item-tools")
		if !strings.Contains(tools, "Claude Code") || !strings.Contains(tools, "Cursor") || strings.Contains(tools, "Codex") {
			t.Fatalf("supported tools = %s, want Claude Code and Cursor only", tools)
		}
		if example := fragment(t, body, `id="item-example"`); !strings.Contains(example, "<strong>release</strong>") {
			t.Fatalf("example not rendered: %s", example)
		}
		preview := fragment(t, body, `id="item-preview"`)
		for _, want := range []string{"<h1>Release checklist</h1>", "<strong>every</strong>", "<li>Run <code>make check</code></li>", "<table>"} {
			if !strings.Contains(preview, want) {
				t.Fatalf("preview missing %q: %s", want, preview)
			}
		}
		if strings.Contains(preview, "# Release checklist") {
			t.Fatalf("preview shows raw Markdown: %s", preview)
		}
	})

	t.Run("preview_never_runs_html_or_unsafe_links_from_the_body", func(t *testing.T) {
		preview := fragment(t, open(t, "Skill/release-checklist"), `id="item-preview"`)
		lower := strings.ToLower(preview)
		for _, banned := range []string{"<script", "onerror", "onclick"} {
			if strings.Contains(lower, banned) {
				t.Fatalf("preview kept %q: %s", banned, preview)
			}
		}
		if unsafeLinkPattern.MatchString(preview) {
			t.Fatalf("preview kept an unsafe URL: %s", preview)
		}
	})

	t.Run("config_preview_is_the_file_as_code", func(t *testing.T) {
		preview := fragment(t, open(t, "Config/strict-settings"), `id="item-preview"`)
		if !strings.HasPrefix(preview, `id="item-preview"><code>`) || !strings.Contains(preview, "&#34;permissions&#34;") || strings.Contains(preview, "<h1>") {
			t.Fatalf("config preview = %s", preview)
		}
	})

	t.Run("agent_front_matter_is_shown_apart_from_the_rendered_markdown", func(t *testing.T) {
		body := open(t, "Agent/doc-writer")
		if !strings.Contains(body, "<pre class=\"front-matter\"><code>name: doc-writer\ntools: Read, Grep</code></pre>") {
			t.Fatalf("front matter not shown: %s", body)
		}
		preview := fragment(t, body, `id="item-preview"`)
		if !strings.Contains(preview, "<p>You write <strong>clear</strong> docs.</p>") || strings.Contains(preview, "<hr>") || strings.Contains(preview, "<h2>") {
			t.Fatalf("agent preview = %s", preview)
		}
	})

	t.Run("unknown_or_malformed_item_is_not_found", func(t *testing.T) {
		for _, id := range []string{uuid.NewString(), "not-a-uuid"} {
			if body, _ := fetchPage(t, adminClient, fixture.server.URL+"/admin/library/items/"+id, http.StatusNotFound); !strings.Contains(body, "NOT_FOUND") {
				t.Fatalf("%s body = %s", id, body)
			}
		}
	})
}
```

RED: comment out the `GET /admin/library/items/{itemId}` route line, run `go test -v -count=1 -run '^TestLibraryAC2ItemDetailWithPostgres$' ./internal/web/` and see status 303 (the `GET /` catch-all redirect) instead of 200; save it as `red-b5.log`; restore the line. GREEN: the same command.

### B6 — AC3: 200+ items stay under 300 ms

Append to `internal/web/library_test.go`:

```go
// generatedCatalog builds count distinct, valid items whose kind, category,
// tags and tools follow the index, so expected counts come from the index
// alone and not from the filter code under test.
func generatedCatalog(count int) []library.Item {
	kinds := []pack.Kind{pack.KindSkill, pack.KindAgent, pack.KindConfig, pack.KindMCPTemplate}
	toolSets := [][]library.Tool{
		{library.ToolClaudeCode},
		{library.ToolCodex},
		{library.ToolCursor},
		{library.ToolClaudeCode, library.ToolCodex},
		{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor},
	}
	items := make([]library.Item, 0, count)
	for i := range count {
		items = append(items, library.Item{
			Kind:        kinds[i%len(kinds)],
			Name:        fmt.Sprintf("generated-item-%03d", i),
			Version:     fmt.Sprintf("1.%d.0", i%7),
			Category:    fmt.Sprintf("category-%02d", i%12),
			Tags:        []string{fmt.Sprintf("tag-%02d", i%30), fmt.Sprintf("tag-%02d", (i+7)%30), "generated"},
			Tools:       toolSets[i%len(toolSets)],
			Description: fmt.Sprintf("Generated item %03d for the catalog load test. %s", i, strings.Repeat("It keeps the description realistic. ", 5)),
			Example:     strings.Repeat("Ask for the generated item by name.\n", 30),
			Body:        "# Generated item\n\n" + strings.Repeat("- one line of generated guidance\n", 120),
		})
	}
	return items
}

func TestLibraryAC3FilteringUnder300msWithPostgres(t *testing.T) {
	const total = 240
	const limit = 300 * time.Millisecond
	fixture := newLibraryFixture(t)
	insertLibraryItems(t, fixture.pool, generatedCatalog(total)...)
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	libraryURL := fixture.server.URL + "/admin/library"

	// Warm the connection, TLS session and query plan once: responsiveness is
	// about an admin clicking through filters, not the first request.
	if body, _ := fetchPage(t, adminClient, libraryURL, http.StatusOK); !strings.Contains(body, fmt.Sprintf("Showing %d of %d items", total, total)) {
		t.Fatalf("library does not hold %d items", total)
	}
	cases := []struct {
		name, query string
		want        func(i int) bool
	}{
		{"no filter", "", func(int) bool { return true }},
		{"kind", "?kind=agent", func(i int) bool { return i%4 == 1 }},
		{"category", "?category=category-03", func(i int) bool { return i%12 == 3 }},
		{"tag", "?tag=tag-05", func(i int) bool { return i%30 == 5 || (i+7)%30 == 5 }},
		{"tool", "?tool=cursor", func(i int) bool { return i%5 == 2 || i%5 == 4 }},
		{"text", "?q=ITEM-123", func(i int) bool { return i == 123 }},
		{"all filters", "?kind=agent&category=category-01&tool=codex&q=generated", func(i int) bool { return i%12 == 1 && (i%5 == 1 || i%5 == 3 || i%5 == 4) }},
		{"no match", "?q=nothing-matches-this", func(int) bool { return false }},
	}
	for _, tc := range cases {
		want := 0
		for i := range total {
			if tc.want(i) {
				want++
			}
		}
		durations := make([]time.Duration, 0, 3)
		for range 3 {
			start := time.Now()
			response := request(t, adminClient, http.MethodGet, libraryURL+tc.query, "", "")
			body := readPage(t, response)
			elapsed := time.Since(start)
			if response.StatusCode != http.StatusOK {
				t.Fatalf("%s: status %d", tc.name, response.StatusCode)
			}
			if rows := len(libraryRowPattern.FindAllString(body, -1)); rows != want || !strings.Contains(body, fmt.Sprintf("Showing %d of %d items", want, total)) {
				t.Fatalf("%s: %d rows, want %d", tc.name, rows, want)
			}
			durations = append(durations, elapsed)
		}
		slices.Sort(durations)
		median := durations[1]
		t.Logf("%-11s %-62s rows=%3d median=%7.2fms max=%7.2fms", tc.name, "/admin/library"+tc.query, want,
			float64(median)/float64(time.Millisecond), float64(durations[2])/float64(time.Millisecond))
		if median >= limit {
			t.Errorf("%s: median response time %v, want under %v", tc.name, median, limit)
		}
	}
}
```

This test is green as soon as B4 exists (its RED is the base-commit build failure). Prove it can fail: add `time.Sleep(350 * time.Millisecond)` as the first line of `libraryView`, run `go test -v -count=1 -run '^TestLibraryAC3FilteringUnder300msWithPostgres$' ./internal/web/` and see `--- FAIL` with "median response time", restore, rerun green. Save both runs in `$EVID/mutations-<sha7>.txt`. Also run it once under the race detector (`go test -race -v -count=1 -run '^TestLibraryAC3FilteringUnder300msWithPostgres$' ./internal/web/`) and record the medians: `make test` uses `-race`.

### B7 — The shipped library renders end to end

Append to `internal/web/library_test.go`:

```go
func TestLibraryShowsTheShippedLibraryWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	if _, err := fixture.repository.EnsureLibrary(context.Background()); err != nil {
		t.Fatalf("EnsureLibrary: %v", err)
	}
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	list, _ := fetchPage(t, adminClient, fixture.server.URL+"/admin/library", http.StatusOK)
	links := libraryLinks(list)
	if len(links) != len(shipped.Items) {
		t.Fatalf("library lists %d items, the binary ships %d", len(links), len(shipped.Items))
	}
	for _, item := range shipped.Items {
		id, ok := links[item.Kind.Label()+"/"+item.Name]
		if !ok {
			t.Fatalf("%s is not listed", item.Key())
		}
		body, _ := fetchPage(t, adminClient, fixture.server.URL+"/admin/library/items/"+id, http.StatusOK)
		// html/template escapes more characters than html.EscapeString (for
		// example "+"), so compare against the unescaped page.
		page := html.UnescapeString(body)
		for _, want := range []string{`<dd id="item-version">` + item.Version + `</dd>`, item.Description, `id="item-preview"`} {
			if !strings.Contains(page, want) {
				t.Fatalf("%s page missing %q", item.Key(), want)
			}
		}
	}
}
```

Run `go test -v -count=1 -run '^TestLibrary' ./internal/web/` — all library tests green.

### B8 — Wiring, then commit

1. `cmd/control-plane/main.go`: after `application.SetPacks(repository, seed)` add `application.SetLibrary(repository)`.
2. `go build ./... && go vet ./...` (with PATH from B0).
3. Commit 2: `git add internal/web/library.go internal/web/library_test.go internal/web/packs_test.go internal/web/handler.go cmd/control-plane/main.go && git commit -m "feat(86bcm901v): library catalog browser in the admin console"`.

### B9 — README note, then commit

Append to `internal/web/README.md` (match the file's style; every test name must exist exactly as written):

```markdown
## Library catalog browser

Story 86bcm901v. `GET /admin/library` lists the content library loaded by story 86bcm9018
(`library_items`), newest version of each item, with filters for kind, category, tag and
supported tool and a text search over name, description, category and tags. Filters
combine; empty fields mean "any". `GET /admin/library/items/{itemId}` shows one item:
description, example, version, category, tags, supported tools and a preview. The admin
home links to it ("Library").

- The preview renders Markdown bodies with goldmark (`library.RenderMarkdown`): raw HTML is
  dropped and `javascript:`, `vbscript:`, `file:` and `data:` links are emptied. Agent front
  matter is shown on its own. Configs and MCP templates are tool files, so they show as code.
- Admins only (members get 403, signed-out visitors go to sign-in). The library is shared
  product content, so every tenant's admin sees the same items; tenant packs never appear.
  Pages are no-store with the nonce-only CSP and need no scripts.
- Impossible filters (an unknown kind or tool, a category or tag that isn't a slug, a search
  over 100 characters or with control characters, a repeated or unknown parameter) show an
  inline error with a 400. An unknown item is a 404 problem.
- No API change: these are HTML pages, so the OpenAPI contract is unchanged.
- Limits: no pagination (the library holds at most 2000 items); older versions are reachable
  by id only.

Verification (real PostgreSQL unless noted):
- `TestLibraryAC1FilterAndSearchWithPostgres`: the admin home links the library; every item
  once with its newest version; each filter, the search and combinations; selected filters
  stay selected; an empty state; impossible filters are rejected with 400.
- `TestLibraryAC2ItemDetailWithPostgres`: description, example, version, tools and a rendered
  preview; hostile HTML and links never survive; a config shows as code; agent front matter
  is separate; unknown and malformed ids are 404.
- `TestLibraryAC3FilteringUnder300msWithPostgres`: 240 items; every filter's median response,
  measured in-process around the whole request, stays under 300 ms (timings are logged).
- `TestLibraryAccessWithPostgres`: members, signed-out visitors, other tenants, tenant packs,
  an unwired library (503) and a failing store (generic 500 with a trace ID).
- `TestLibraryShowsTheShippedLibraryWithPostgres`: every shipped item is listed and opens.
- `TestLibraryCatalogWithPostgres` (`internal/store/postgres`): newest version by numeric
  order, metadata-only lists, any version by id, fail-closed reads, one shared library.
- Unit (`internal/library`): `TestFilterMatchesEachField`, `TestFilterValidateRejectsImpossibleValues`,
  `TestFacetsAreSortedAndDistinct`, `TestToolsHaveDisplayLabels`, `TestRenderMarkdownFormatsCommonMarkdown`,
  `TestRenderMarkdownDropsRawHTMLAndUnsafeLinks`, `TestPreviewShowsToolFilesAsCode`,
  `TestPreviewSplitsFrontMatter`, `TestPreviewOfEveryShippedItem`.

Demo: run the tests above with `-v`. Locally, the binary in its existing dev mode
(`LEORNA_DEV_MODE=1`) against a throwaway database shows the pages at `/admin/library`.
```

Commit 3: `git add internal/web/README.md && git commit -m "docs(86bcm901v): document the library catalog browser"`.

### B10 — Mutation checks (prove the tests can fail)

One at a time: make the change, run the named test, see it fail, restore, rerun green. Record each (change, test, FAIL line, restored PASS) in `$EVID/mutations-<sha7>.txt`. `git diff` must be empty afterwards.

| # | Change | Test that must fail |
| --- | --- | --- |
| M1 | `Filter.Matches`: delete the Tag check | `TestFilterMatchesEachField/tag`, AC1 `filter_by_tag` |
| M2 | `Filter.Matches`: `text := filter.Text` (no `ToLower`) | `TestFilterMatchesEachField/text_in_the_name_in_any_case`, AC1 `search_by_text_in_the_name_in_any_case` |
| M3 | `Filter.Validate`: drop the kind check | `TestFilterValidateRejectsImpossibleValues`, AC1 `impossible_filters_are_rejected` |
| M4 | store: `ORDER BY kind, name, version DESC` (text order) | `TestLibraryCatalogWithPostgres` (newest version), AC1 row version |
| M5 | store: drop `DISTINCT ON (kind, name)` | `TestLibraryCatalogWithPostgres`, AC1 item list |
| M6 | preview: `goldmark.WithRendererOptions(html.WithUnsafe())` | `TestRenderMarkdownDropsRawHTMLAndUnsafeLinks`, AC2 `preview_never_runs_html…` |
| M7 | preview: render the whole body (skip `splitFrontMatter`) | `TestPreviewSplitsFrontMatter`, AC2 front matter subtest |
| M8 | preview: no Code branch for configs | `TestPreviewShowsToolFilesAsCode`, AC2 `config_preview_is_the_file_as_code` |
| M9 | route: drop `requireAdmin` on `GET /admin/library` | `TestLibraryAccessWithPostgres/members_are_refused` |
| M10 | `time.Sleep(350*time.Millisecond)` in `libraryView` | AC3 (done in B6) |
| M11 | `libraryFilter`: remove `len(values) != 1` | AC1 `impossible_filters_are_rejected` (`?kind=skill&kind=agent`) |
| M12 | store: `GetLibraryItem` without `beginOrg` (query the pool directly) | `TestLibraryCatalogWithPostgres/reads_fail_closed…` |

Use never-true comparisons rather than deleting code if a deletion would leave an unused variable (a build error proves nothing).

### B11 — Gates on the final head

From `$WT`, with B0's PATH and DB env, `H=$(git rev-parse --short=7 HEAD)`; each log ends with `EXIT=<code>` and gets a small `<log>.json` receipt `{"command": …, "head": …, "exit_code": …, "finished": …}`:

1. `GOLANGCI_LINT="$SCR/bin/golangci-lint" make check > "$EVID/gates-$H.txt" 2>&1; echo "EXIT=$?" >> "$EVID/gates-$H.txt"` (workspace, contracts-check, fmt, vet, test with `-race`, lint 2.14.0, govulncheck, gitleaks, build).
2. `bash ./scripts/test-module-add.sh > "$EVID/module-add-$H.txt" 2>&1; echo "EXIT=$?" >> …`.
3. Verbose Postgres proof (the canonical gate stays unchanged; this is a separate run): `go test -v -count=1 -run 'TestLibrary|TestEnsureLibrary' ./internal/web/ ./internal/store/postgres/ > "$EVID/pg-verbose-$H.txt" 2>&1; echo "EXIT=$?" >> …` — must show `--- PASS` lines and no `--- SKIP`.
4. Each AC's single-test command, saved as `$EVID/ac<n>-$H.log` with the ac-verification recipe (`HEAD=` first line, `EXIT=` last).
5. Story-range secret scan: `gitleaks git --redact --no-banner --log-opts="origin/main..HEAD" > "$EVID/gitleaks-story-$H.txt" 2>&1; echo "EXIT=$?" >> …`.
6. Contract drift: `git diff --name-only origin/main...HEAD -- contracts packages/contracts .github` prints nothing (save to `$EVID/no-contract-or-ci-diff-$H.txt`).
7. Authors: `git log --format='%an <%ae>' origin/main..HEAD | sort -u` is only `Justin Issa <justin@leorna.com>`.

A failure that also happens on the base (B0 step 7) is pre-existing: record it with both logs, don't fix it.

### B12 — Evidence capture: one screenshot per AC (named build task)

Do this after B11 on the final head; retake if a later fix changes what a page shows. No before-state page screenshot: the library pages don't exist on base, and the only changed existing page (the admin home link line) sits in the card that shows the session email and tenant ID; the RED logs are the before evidence.

**Run the real admin console locally (dev mode, loopback only, throwaway DB):**

```bash
cd "$WT"
docker exec leorna-test-pg createdb -U leorna leorna_86bcm901v_v3_demo   # owned by this build; dropped at the end
go build -o "$SCR/control-plane" ./cmd/control-plane
python3 -I -c 'import json,sys; m=json.load(open(sys.argv[1])); m["server"]["address"]="127.0.0.1:18431"; json.dump(m, open(sys.argv[2],"w"), indent=2)' config/manifest.example.json "$SCR/manifest.json"
lsof -nP -iTCP:18431 -sTCP:LISTEN   # must print nothing
env LEORNA_MANIFEST_PATH="$SCR/manifest.json" \
    LEORNA_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901v_v3_demo?sslmode=disable' \
    LEORNA_DEV_MODE=1 LEORNA_PUBLIC_BASE_URL='https://pending.leorna.invalid' \
    LEORNA_SECRET_ENCRYPTION_KEY="$(openssl rand -base64 32)" \
    "$SCR/control-plane" > "$SCR/demo-server.log" 2>&1 &
echo $! > "$SCR/demo-server.pid"
```

(Run the last command as a background job; never print the key.) Poll `curl -fsS http://127.0.0.1:18431/readyz` until it answers (≤ 60 s); `demo-server.log` must show `content library loaded` and the dev-mode warning. If the binary refuses to start, keep the log, stop, and report the exact error (don't change config code).

**Seed 240 demo items** so the page holds 248 (8 shipped + 240):

```bash
docker exec -i leorna-test-pg psql -U leorna -d leorna_86bcm901v_v3_demo -v ON_ERROR_STOP=1 <<'SQL'
INSERT INTO library_items (id, kind, name, version, category, tags, tools, description, example, body, content_sha256, library_version)
SELECT gen_random_uuid(),
       (ARRAY['skill','agent','config','mcp_template'])[1 + i % 4],
       format('demo-item-%s', lpad(i::text, 3, '0')),
       format('1.%s.0', i % 7),
       (ARRAY['code-quality','testing','security','documentation','integrations','configuration','release','onboarding','observability','performance','data','incident-response'])[1 + i % 12],
       ARRAY[format('tag-%s', lpad((i % 30)::text, 2, '0')), format('tag-%s', lpad(((i + 7) % 30)::text, 2, '0')), 'demo'],
       CASE i % 5 WHEN 0 THEN ARRAY['claude-code'] WHEN 1 THEN ARRAY['codex'] WHEN 2 THEN ARRAY['cursor'] WHEN 3 THEN ARRAY['claude-code','codex'] ELSE ARRAY['claude-code','codex','cursor'] END,
       format('Demo item %s about %s, seeded only for the local screenshot.', lpad(i::text, 3, '0'), (ARRAY['code review','testing','security review','release notes','onboarding','incident response','performance','documentation'])[1 + i % 8]),
       'Ask for the demo item by name.',
       E'# Demo item\n\n- One line of demo guidance\n- Another line\n',
       encode(sha256(convert_to(format('demo-item-%s', i), 'UTF8')), 'hex'),
       'demo'
FROM generate_series(0, 239) AS i;
SQL
```

**Screenshots (headless Chrome, throwaway profile, no URL bar).** Each run signs in through the existing dev login and lands on the page given in `next` (URL-encoded):

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { # shot <file> <window-size> <path-and-query>
  local profile; profile=$(mktemp -d "$SCR/chrome-XXXX")
  local next; next=$(python3 -I -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$3")
  "$CHROME" --headless=new --disable-gpu --no-first-run --hide-scrollbars --user-data-dir="$profile" \
    --window-size="$2" --screenshot="$EVID/$1" "http://127.0.0.1:18431/dev/login?next=$next"
  rm -rf "$profile"
}
```

| AC | File | What it must show | How |
| --- | --- | --- | --- |
| AC1 | `ac1-library-filtered.png` | The Content library page with the filter bar showing chosen values and a short result table ("Showing N of 248 items"). | `shot ac1-library-filtered.png 1440,1500 '/admin/library?kind=skill&category=code-quality&tool=codex&q=review'` (expected about 7 rows: the shipped `code-review-checklist` plus demo items; if it shows fewer than 3 or more than 15 rows, pick another combination and record the path used). |
| AC2 | `ac2-item-detail.png` | The shipped agent `code-reviewer` item page: kind, name, version, category, tags, supported tools, description, rendered example, front matter block and rendered Markdown preview, all visible. | Get its id: `docker exec leorna-test-pg psql -U leorna -d leorna_86bcm901v_v3_demo -tAc "SELECT id FROM library_items WHERE kind='agent' AND name='code-reviewer' ORDER BY created_at DESC LIMIT 1"`, then `shot ac2-item-detail.png 1440,2200 "/admin/library/items/<id>"`; enlarge the height if the preview is cut off. Optional extra: `ac2-item-detail-config.png` for `config/claude-code-settings`. |
| AC3 | `ac3-timing-terminal.png` + `ac3-timing-<sha7>.log` | A real Terminal window running the AC3 test: the command, the per-filter timing lines (`rows=… median=…ms`), `--- PASS`, `ok`, and `EXIT=0`. | See below. Optional extra: `ac3-library-248-items.png` = `shot ac3-library-248-items.png 1440,1600 '/admin/library'` ("Showing 248 of 248 items"). |

AC3 terminal capture: write `$SCR/run-ac3.sh`:

```bash
#!/opt/homebrew/bin/bash
set -o pipefail
cd "$HOME/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3"
export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901v_v3_test?sslmode=disable'
EVID="$HOME/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3"
H=$(git rev-parse --short=7 HEAD)
echo "HEAD=$H"
echo "\$ go test -v -count=1 -run '^TestLibraryAC3FilteringUnder300msWithPostgres\$' ./internal/web/"
go test -v -count=1 -run '^TestLibraryAC3FilteringUnder300msWithPostgres$' ./internal/web/ 2>&1 | tee "$EVID/ac3-timing-$H.log"
echo "EXIT=${PIPESTATUS[0]}" | tee -a "$EVID/ac3-timing-$H.log"
```

Then follow the `leorna` skill's terminal capture recipe (step 4b): a dedicated Terminal window opened with `osascript` running `exec env -i HOME="$HOME" PATH="<B0 PATH>" PS1='$ ' /opt/homebrew/bin/bash --norc --noprofile`, wait until its `history` shows the `$ ` prompt, type `/opt/homebrew/bin/bash ~/.hermes/cache/scratch/86bcm901v-catalog-browser-v3/run-ac3.sh`, wait until `history` contains `EXIT=`, capture with `screencapture -x -o -l <window id> "$EVID/ac3-timing-terminal.png"`, then close only that window. The database URL is set inside the script, so it never appears on screen. If Terminal automation fails (AppleEvent timeout, no window), record the attempt in `EVIDENCE.md` and instead open the real `ac3-timing-<sha7>.log` as `file://` in headless Chrome with a throwaway profile and save that as `ac3-timing-terminal.png`, labelled "log rendering" in `EVIDENCE.md`.

**Clean up:** `kill "$(cat "$SCR/demo-server.pid")"`, confirm with `ps -p <pid>` that it's gone, then `docker exec leorna-test-pg dropdb -U leorna leorna_86bcm901v_v3_demo` (only this database). Keep `leorna_86bcm901v_v3_test`.

**Privacy check before listing any file:** open every PNG (look at it) and grep every log: no server domain, URL bar, tenant ID, token, email, `/dev/login` text or database password may be visible. The library pages show none of these; never capture `/admin` (it shows the session email and tenant ID). Retake or crop if anything shows.

**`$EVID/EVIDENCE.md`:** head SHA, base SHA, one line per AC (AC → test → log → screenshot → what it shows), gate logs with their receipts' exit codes (open each log and read its `EXIT=` line before citing it), mutation summary, the demo-run notes (port, demo DB created and dropped, item count), and anything NOT VERIFIED with the reason.

### B13 — Hand back at ready-for-review

`git status --porcelain` is empty (evidence lives outside the repo). Report: branch, base and head SHAs, `git diff --stat origin/main..HEAD`, the gate results with log paths, the AC → test → screenshot table, the mutation results, deviations from this plan with reasons, `found_else`, and `skill_lessons`. Never push, open a PR, merge or post to ClickUp.

## Gates the builder, reviewers, verifier and auditor run

- `make check` with the CI linter bound: `GOLANGCI_LINT=<abs path to golangci-lint 2.14.0> make check`, with `$SCR/bin` first in PATH and gnubin + `/opt/homebrew/bin` ahead of system tools (macOS `realpath --relative-to` and Bash ≥ 4 `mapfile -d` are needed by the workspace scripts). Never `GO='go -v'`.
- `bash ./scripts/test-module-add.sh`.
- A separate verbose run proving the Postgres tests ran (no `--- SKIP`).
- Each AC's single-test command on head and on the base commit (ac-verification.md), each agent with its own `_test` database.
- `gitleaks git --redact --no-banner --log-opts="origin/main..HEAD"` and no `.github/`, `contracts/`, `packages/contracts/` paths in `git diff --name-only <base>...HEAD`.

## Definition of Done mapping

| DoD item | Where |
| --- | --- |
| Unit tests | `internal/library/catalog_test.go`, `preview_test.go` |
| Integration tests, happy path + failure | AC1 (impossible filters → 400), AC2 (unknown/malformed → 404, hostile HTML), access test (403, 302, 503, 500), store test (fail-closed, not found) |
| OpenAPI updated if the API is touched | Not touched (HTML pages only); `make contracts-check` green, no diff under `contracts/` |
| lint/format/CI green incl. gitleaks + golangci-lint | B11 (`make check` with golangci-lint 2.14.0, gitleaks story range); hosted CI runs only after Justin's "push"/"make a PR" |
| Demoable in isolation | Tests with `-v`; the local dev-mode run in B12 (screenshots) |
| Short module README note | `internal/web/README.md` "Library catalog browser" |

## Overlaps with other work in this repo

- **`86bcm901u-quality-gate-v3`** (Content quality gate, planning in another session since 2026-10-24; v2 on `feat/86bcm901u-quality-gate-v2` @ `2e8b5cd` is paused). Its v2 plan touched `.github/workflows/ci.yml`, `cmd/library-check/`, `internal/library/qualitygate/`, `internal/toolrender/`, `internal/library/README.md`, possibly `internal/library/source.go` and `internal/pack/pack.go`. This story touches **no CI, no loader/manifest code, no content, no lock file and not `internal/library/README.md`**; it only **adds new files** in `internal/library` (`catalog.go`, `preview.go` + tests) and changes `internal/web`, `internal/store/postgres` (new file), `cmd/control-plane/main.go` and `go.mod`/`go.sum`. Shared surface: the `internal/library` package (new files only) and `go.mod`/`go.sum` if 901u adds dependencies. **They can be built in parallel**; whichever merges second rebases and resolves at most a `go.mod`/`go.sum` merge. If 901u changes `library.Item` (e.g. multi-file items), this story's reads of `Item` fields may need a small rebase fix. Never touch either 901u worktree, branch or database (`leorna_86bcm901u_*`).
- **86bcm9016 prompt kind** (PR #85, open): adds a `prompt` pack kind. This story reads kinds from `pack.Kinds()` and renders non-file kinds as Markdown, so either merge order works; the tests use explicit kinds. Possible trivial conflict in `handler.go` route lines.

## Docs & records

Updated by the build and finish, and by whom:

- Repo (builder): the files in "Parts of the code it touches", including `internal/web/README.md`.
- `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (main session at go; read-only copy that `ac-check.sh` reads).
- Evidence folder (builder at its root; verifier only in `verifier/`, auditor only in `auditor/`): screenshots, `red-*.log`, `ac<n>-<sha7>.log`, `gates-*.txt` + receipts, `module-add-*.txt`, `pg-verbose-*.txt`, `gitleaks-story-*.txt`, `mutations-*.txt`, `tools.txt`, `EVIDENCE.md`; finisher adds `clickup-draft.md` (closing comment + attachment list, posted only on Justin's "post").
- Memory (main session, from reports): a status line in `leorna-workflow.md` "Start here" for `86bcm901v-catalog-browser-v3` at each stage; the `skill_lessons` the main session accepts (e.g. a correction in `leorna-control-plane-workflow.md` that the binary does run locally in dev mode).
- Finisher hand-over: PR text in Christian's plain style (Summary, one line per file/area, Test Plan with results, Assumptions from this plan, ClickUp link, security/migration/rollback notes: no migration, rollback = revert; Evidence block with head SHA), the review prompt (`review-prompt-for-agent.md`), the team message (`story-done-team-message.md`), and the ClickUp evidence draft.
- `delivery/stories.json` (finisher, **only after a PR exists**, i.e. after Justin says "make a PR"): add `"86bcm901v": {"name": "Library catalog browser", "prs": {"LeornaAI/leorna-control-plane": [82, <new PR number>]}}` (82 = the loader dependency) in one small commit on the same branch.
- After merge (Justin merges): `python3 scripts/check-story-shippable.py 86bcm901v`, then the team message; Justin moves the card.

## Other things found (not fixed here)

- `leorna-control-plane-workflow.md` (memory) still says "No browser demo exists. The binary needs verify-full TLS Postgres, an HTTPS public URL and Google OAuth". Since dev mode (`LEORNA_DEV_MODE=1`, `internal/config/runtime.go:61-86`) the binary accepts `sslmode=disable` and needs no Google credentials; only the public URL must still be `https://`. Low severity (stale note).
- `readBody` in `internal/web/handler_test.go:308-316` silently truncates bodies at 64 KiB, so an assertion on a large page can look at a cut-off body without any error. Low severity, test-only; this story uses its own reader.

## Estimate

About 3–5 hours of builder time (B1–B9 ≈ 2–3 h, mutations ≈ 30 min, gates ≈ 20–30 min of runtime, evidence ≈ 45 min), plus the review → fix → verify → audit loop.

## Justin's answers (recorded 2026-10-24 by the main session)

Justin picked the **Full** pipeline and "Keep going like v2" before planning: every ⭐ answer counts as his, through the finisher hand-over, with no separate **go**. So **Q1A Q2A Q3A Q4A Q5A Q6A Q7A Q8A** are approved as written in this plan, including the new `github.com/yuin/goldmark` v1.7.17 dependency (Q2A) and dev-mode screenshots on 127.0.0.1 against a throwaway database (Q7A). AC1–AC3 are the card's ACs; none is `(live)` or proposed. Unchanged boundaries: no push, PR, merge, ClickUp writes, servers/cloud, or `.github/workflows/*` edits.

### Away grant (2026-10-24, Justin, leaving the house)

Justin's words: "Look ima go and leave the house you as the orchestrator just keep it going throughout the pipline and go with the recommendation if it does not have recommendation make it create one."

Recorded scope: the main session keeps the Full pipeline running (fix → review 2 → fix → verifier → blind AC auditor + `ac-check.sh` → finisher hand-over) without waiting for him. Any question an agent raises is answered with its recommended option; a question with no recommendation goes back to that agent (or a fresh one) to make one, which is then applied. Termination: the finisher hand-over for this story, or Justin cancels. Unchanged boundaries: no push, PR, merge, ClickUp writes/posts, server/cloud actions or `.github/` edits; each of those still needs his own word.

### Decisions applied under the away grant

- **Review 2 question (a), 2026-10-24 → A (recommended):** record the Markdown preview's worst-case cost (goldmark table padding grows with columns × rows; a 16 KB table → 80 MB HTML, 1.8 GiB) as a follow-up now, in a README "Limits" line and the PR's Assumptions. It must be fixed before content not written by Leorna can reach `library_items` (e.g. 86bcm945u upstream import, or tenant variants). No guard code in this story.

### Publication (2026-10-24, Justin)

Asked what "go" should do after the hand-over, Justin picked **"Make a PR + post"**: re-run gates on 2c43b39, push the branch as Justin-Leorna, open the PR (no merge), then post the ClickUp closing comment plus attachments (no card status change). `delivery/stories.json` entry is drafted, not committed or pushed, in this step.

### Merge with main after PR #88 opened (2026-10-24, Justin)

PR #88 went CONFLICTING after PRs #85 (86bcm9016 prompt kind) and #89 (86bcm945u upstream sync) merged into main (origin/main `6275a4e`). The text conflict is `internal/web/handler.go`: both sides added a struct field next to each other and both changed the admin-home nav line (ours "Library", #89 "Third-party content"). Justin asked to "check pr we have merge conflict and double check AC" and answered:

- **Merge method:** merge `origin/main` into the branch with a merge commit (as PRs #85 and #89 did); no rebase, no force-push.
- **Preview cost limit → "Follow-up, fix wording":** no guard code. Correct the README Limits line and the PR's Assumptions: upstream items (86bcm945u) now reach `library_items`, but only through a reviewed commit of files under `internal/library/content` that the binary embeds; the bound must land before content can reach `library_items` without such a commit (e.g. tenant variants or a runtime import). The agents confirm that import path with file:line evidence and time the real imported item's preview.
- **The "empty Prompt filter" assumption is obsolete:** migration 21 widened `library_items.kind` to include `prompt`, and main ships a prompt item (`pr-description`). Check the catalog handles it.
- **Publication → "Push + update PR text":** once `ac-check.sh` says ALL ACCEPTED on the merged head, push the merge to the PR branch (no force-push), refresh the PR description (Test Plan, Assumptions, Evidence) and wait for CI. ClickUp stays as posted until Justin says "post". Never merge.
- ACs are unchanged (AC1–AC3 in `plan-approved.md`). Re-proof on the new head: fixer (merge) → fresh verifier → blind auditor → `ac-check.sh` with base = the new merge-base.
- **ClickUp re-post (Justin, 2026-10-24): "if new screenshots are gonna get uploaded to clickup make sure to delete the old ones."** Re-posting still needs his "post". When it happens: name the new files with the head suffix (e.g. `ac1-library-filters-86c16b8.png`) so old and new are told apart. The ClickUp connector has no attachment delete (only `clickup_delete_comment`), so the main session lists the 8 old attachments from comment 90140272964839 (titles + IDs from `clickup_get_task include=[attachments]`) for Justin to delete by hand, and reads back after he does. Recommended for the old comment: update it in place with `clickup_update_comment` (new head, results, file names) rather than adding a second comment.
- **Verifier round 2 (cc20482) question Q1 → A (main session, matching its earlier call on the same CSS item):** the "Prompt" label wrapping mid-word comes from the shared, pre-existing `td{overflow-wrap:anywhere}` (`internal/web/admin_ui.go:7`); leave it, and list it in the PR's Assumptions as a cosmetic follow-up (stop the Kind cell from wrapping). Logged in `found-else.md`.
- **ac-check after the merge:** `ALL ACCEPTED: 3 of 3 ACs on cc20482` (round-2 verifier + blind auditor). Publish agent pushed `cc20482` to PR #88 (fast-forward) and updated the body; CI run 40127235709 passed (Go quality gates, image, admin-portal).
- **"post" (Justin, 2026-10-24): "whenever auditor is done push the pr and update the clickup photos ok. let me know when doen so i merge".** Authorizes the ClickUp re-post: upload the new `-cc20482` screenshots and logs to `86bcm901v`, update comment 90140272964839 in place, read back. The connector can't delete attachments, so the 8 old ones go to Justin as a list to delete by hand. No card status change; never merge (Justin merges).
- **ClickUp re-post blocked (2026-10-24):** the publish finisher's `clickup_request_attachment_upload` was denied by Claude Code's auto-mode classifier in the subagent; nothing was posted. Justin picked **"Run it here, I'll approve"**: the main session runs the 7 uploads + `clickup_update_comment` on 90140272964839 itself, then lists the 8 old attachments for him to delete.
- **stories.json (Justin, 2026-10-24): "Add to PR #88 first".** One commit on the branch adding `86bcm901v` with PRs [82, 88] (draft `evidence/…/publish-merge/stories-json-entry.md`), pushed fast-forward to PR #88; CI re-runs; PR Evidence updated to the new head. ACs stay proven on `cc20482` (the new commit touches only `delivery/stories.json`).
