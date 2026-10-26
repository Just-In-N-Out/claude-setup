The plan is below. The main session should save it to `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md`.

# Plan: 86bcm901v Library catalog browser (v2, fresh start)

## 1. Goal, context, assumptions, base

**Goal.** Add an admin-only content library browser to the control-plane admin console. Admins can filter by kind, category, tag and supported tool, and search by text (AC1). Each item opens a page with its description, example, version, supported tools and a rendered preview that cannot run anything (AC2). Filtering stays under 300 ms server time with 200+ items, proven by a test (AC3).

**Base.** Plan against `origin/main` **57c7fc152796186c703fe2d48afeb784ee4562da** (#86 adoption dashboard). Local `main` is `0da9f54`, 4 commits behind. An SSH fetch failed during planning ("Permission denied (publickey)"), so the builder fetches over HTTPS through gh (T0).

**Context (verified on 57c7fc1):**
- `internal/library` holds the format and loader from #82 (card 86bcm9018). Each item has kind, name, version, category, tags, tools (`claude-code|codex|cursor`), description, example and body. The table is `library_items` (migration 20). It has **no tenant column**: it is shared product content and rows are only ever added. It is keyed `(kind,name,version)`, and several versions of one item can exist. `library.MaxItems = 2000`.
- The admin pages use `html/template`, a nonce'd `<style>` and `writeHTMLPage` (`internal/web/packs.go`), which sets the CSP `default-src 'none'; style-src 'nonce-…'; script-src 'nonce-…'; …`, plus `no-store`, `nosniff`, `Referrer-Policy` and COOP. Pages are guarded by `requireSession(requireAdmin(...), true)`. The newest dashboards (`adoption.go`, `dashboard_filter.go`) validate query keys strictly and return **400 with an editable form and `role="alert"`** on a bad filter.
- No `/admin/library` route exists. `GET /` catches everything else and sends a 303 to `/admin`.
- Test fixtures: `newPackFixture` (`internal/web/packs_test.go`) gives a schema-scoped Postgres, an admin, a member, a second tenant, `login` and `get`. `newAssignHandler` (`pack_assignments_test.go`) gives an admin logged in against fakes. Store tests use `testPool`, `seedBaseStore` and the unexported `repository.loadLibrary` (`internal/store/postgres/library_test.go`). Fixtures refuse database names that don't end in `_test`.
- Running locally works with existing code. With `LEORNA_DEV_MODE=1` (`internal/config/runtime.go:61-86`) the database URL may use `sslmode=disable` and Google OAuth is optional. `LEORNA_PUBLIC_BASE_URL` only has to be an `https://…` string. The server speaks plain HTTP on the manifest address, and the gated `GET /dev/login?next=` (already on main since PR #81) signs in a demo admin. Nothing new is added.

**Assumptions (small, reversible; go in the PR):**
1. Library rows are shared product content. Every tenant's admins see the same catalog. Isolation means an admin role check plus a tenant-context check; no tenant data is read.
2. Admin only, matching "As an admin" and `/admin/packs`. Members get 403.
3. Search covers name, description, category and tags, not example or body. It ignores case, every word must match, and it allows at most 100 characters and 8 words. `%` and `_` are ordinary characters (`strpos`, not `LIKE`).
4. One choice per filter. Filters combine with AND; an empty choice means "any".
5. 50 items per page, pages 1–40 (`MaxItems/PageSize`).
6. An item dropped from a later library release still shows, because rows are never removed. There is no "retired" marker; note this for 901w and 901z.
7. HTML pages only, like `/admin/adoption`. No JSON API and no OpenAPI change, so the client is unaffected.
8. No migration and no index: at most 2000 items scan in a few ms. Revisit if `MaxItems` grows a lot.
9. Preview subset limits: tables, nested lists, links, images and single-`*` emphasis show as literal text.
10. Tool labels are "Claude Code", "Codex" and "Cursor"; an unknown tool shows its raw ID.
11. A bad filter clears the form values and does not echo them back.
12. `delivery/stories.json` gets `86bcm901v` with dependency PR `[82]`. This PR's number is added once the PR exists.

**Blind-rule disclosure.** While finding which lines of `leorna-workflow.md` to skip, my `grep -n` printed the matching lines. That showed fragments of the earlier attempt's status (mentions of Goldmark and preview budgets). I did not open its branch, worktrees, plans or evidence. This design comes from main and the card only. The choice of a small in-repo renderer is argued in Q1 on its own merits.

## 2. Design

**Data source and query shape.** The new file `internal/store/postgres/library_catalog.go` has three read methods on `*Store`. They implement the new `library.Catalog` port in `internal/library/catalog.go`.
- `ListLibrary(ctx, actor, Filter) (Page, error)`. A CTE `newest` picks `DISTINCT ON (kind,name) … ORDER BY kind, name, string_to_array(version,'.')::numeric[] DESC`, so 1.10.0 beats 1.9.0; the table's CHECK keeps every part digits. It selects metadata only, never example or body. Filters are parameterised `($n::text = '' OR …)`. Search uses `NOT EXISTS (SELECT 1 FROM unnest($5::text[]) term WHERE strpos(lower(name||' '||description||' '||category||' '||array_to_string(tags,' ')), lower(term)) = 0)`. `count(*) OVER ()` gives the total. Order is by position in `pack.Kinds()`, then name with `COLLATE "C"`. `LIMIT 50 OFFSET …`.
- `LibraryFacets(ctx, actor) (Facets, error)`. One round trip returns the distinct kinds, categories, tags and tools of the **newest** versions. Because the options come from data, a new kind such as #85's `prompt` appears without a code change.
- `GetLibraryItem(ctx, actor, kind, name, version) (Detail, error)`. It returns every stored version (newest first) plus one full row: the newest, or `?version=`. Malformed input or an unknown item returns `store.ErrNotFound`.
- Each method opens `beginOrg(ctx, actor, false)`, which checks that the context tenant matches the actor and reads the role, and then requires `admin`, else `org.ErrForbidden`. This is the same defence in depth as `GetCatalog`.

**Filter and search rules** (`library.Filter.Validate`, `library.SearchTerms`):
- kind must satisfy `pack.Kind.Valid()`, so `prompt` is accepted automatically once #85 lands;
- tool must satisfy `library.Tool.Valid()`;
- category and tag must be slugs of at most 64 characters;
- page is 1–40;
- search is at most 100 runes and 8 words, valid UTF-8, with no control characters.

The web layer accepts only the keys `q, kind, category, tag, tool, page`, each at most once. Anything else gets a 400 page with the form.

**Item page** (`GET /admin/library/{kind}/{name}[?version=x.y.z]`). It shows the kind label, the name, the version marked "(newest)" when it is, links to all versions with `aria-current` on the current one, the category and tag chips (links back to filtered lists), and the supported tools. Then come three sections: Description, Example (rendered) and Preview (rendered). Markdown kinds also get a `<details>` "Show the file as written" with the raw body. Configs and MCP templates preview as the file itself, verbatim; **every other kind**, including future ones, previews as Markdown.

**Preview and its safety bounds** (new package `internal/library/preview`):
- It is a parser that **never emits HTML**. It returns a typed `Document{Blocks []Block, Truncated bool}`. Blocks are heading, paragraph, list, quote, code or rule. Spans are plain, code or strong.
- The page template prints every string with `{{.Text}}` in text context, so `html/template` escapes it. No `template.HTML/JS/URL` anywhere; the gate script greps the diff to prove it.
- Recognised: ATX headings (shown as h3–h6), paragraphs, one level of `-*+` and `1.`/`1)` lists, `>` quotes, fenced code, `***`/`---`/`___` rules, leading YAML frontmatter (shown as a code block labelled "Frontmatter"), `` `code` `` and `**bold**`. Everything else (raw HTML, links, images, tables) stays literal text.
- Bounds:
  - at most `MaxInputBytes = 64 KiB`, cut at a rune boundary with invalid UTF-8 replaced;
  - at most `MaxBlocks = 500` blocks plus list items, after which it sets `Truncated` and shows a notice;
  - one pass over lines using RE2 regexps, which are linear time;
  - an inline scan that only moves forward: an opener with no closer turns off further searches for that delimiter.
- The admin CSP has no `img-src` and no inline script, so even an injected tag could not load anything.
- Access is checked by both the route guard and the store.

**Authorization.** `requireSession(requireAdmin(…), true)` on both routes, plus the store's admin check. Members get 403, signed-out visitors get a 302 to sign-in, and a context-tenant mismatch gets 404 from the store. Pages are GET only with no CSRF cookie needed, like adoption.

**Performance for AC3.** Metadata-only selects over at most 2000 rows, 50 rows per page, and a page budget of 256 KiB asserted in the AC3 test. AC3 is proven by a real-Postgres test with 250 items plus 50 older versions. It times the full handler in-process (session lookup, admin check, both queries, render) with `httptest.Recorder`: one warm-up plus 20 timed runs for each of 10 filter cases, failing if **any** run takes 300 ms or more. It runs inside `make check` (`-race`) and therefore in CI.

**OpenAPI impact: none.** These are HTML admin pages like `/admin/adoption`; no `/v1` route is added. Drift is checked by `make contracts-check`, which is inside `make check`, plus `git diff --name-only origin/main...HEAD -- contracts packages/contracts` being empty.

**README note.**
- `internal/web/README.md`: new section "## Library catalog browser" at the end of the file.
- `internal/library/README.md`: 3-line pointer inserted before "## Loading". This position avoids #85's and 901u-v2's hunks.
- Root `README.md`: one row in the role table.

## 3. Ordered microtasks

Shared variables, used in every command:

```bash
WT="$HOME/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v2"
SCRATCH="$HOME/.hermes/cache/scratch/86bcm901v-catalog-browser-v2"
EVID="$HOME/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:$PATH"
```

Rules for every task:
- Keep each RED and GREEN transcript in `$EVID/red-green-T<n>.txt`.
- Run `gofmt -l <changed files>` (must print nothing) before each commit.
- Check the identity first: `git log -1 --pretty='%an <%ae>'` must be `Justin Issa <justin@leorna.com>`. No AI attribution lines; follow `git-commit-rules`.
- Commit only the named files.
- Run each mutation on a committed tree and restore it with `git checkout -- <file>`. Record each mutation with its failing assertion in `$EVID/mutations-<sha7>.txt`.

### T0 Preflight (about 15 min, no code)

1. Fetch over HTTPS:
   ```bash
   git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main
   ```
   If `origin/main` is not `57c7fc1`, record the new SHA and run `git diff --name-only 57c7fc1..origin/main`. **Stop and report** if that touches any file in §8 "Touches".
2. Create the worktree:
   ```bash
   git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm901v-catalog-browser-v2 "$WT" origin/main
   ```
   Then `mkdir -p "$SCRATCH/bin" "$EVID"`. Do not touch other worktrees, `deploy/local/` or the untracked `.claude/`.
3. Tools:
   - Lint: use `LINT="$HOME/.hermes/cache/scratch/leorna-bin/golangci-lint"` only if `"$LINT" --version` shows `2.14.0` (CI pins 2.14.0 in `.github/workflows/ci.yml:120`). Otherwise run `GOBIN="$SCRATCH/bin" go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.14.0` and set `LINT="$SCRATCH/bin/golangci-lint"`. If lint later prints "export data version … greater than maximum", reinstall this way; that error comes from the tool, not the code.
   - Check the shell tools: `realpath --relative-to=/ /tmp && bash -c 'mapfile -d "" x </dev/null' && echo tools-ok` (GNU realpath, Bash 5.3).
4. Databases. Make one gate DB and one demo DB, both owned by this builder and never shared:
   ```bash
   docker start leorna-test-pg
   for db in leorna_901v2_gates_test leorna_901v2_demo_test; do docker exec leorna-test-pg psql -U leorna -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$db'" | grep -q 1 || docker exec leorna-test-pg createdb -U leorna "$db"; done
   printf "export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_901v2_gates_test?sslmode=disable'\n" > "$SCRATCH/test-env.sh"; chmod 600 "$SCRATCH/test-env.sh"
   ```
   The password is the CI-only one from `ci.yml`. Never echo it into logs.
5. **Before-state evidence, on the unchanged base:**
   - Build the base binary: `cd "$WT" && go build -o "$SCRATCH/control-plane-base" ./cmd/control-plane`.
   - Start it with the demo recipe in §5.
   - Run `curl -sS -o /dev/null -w '%{http_code} %{redirect_url}\n' http://127.0.0.1:18901/admin/library`. Expect `303 …/admin`. Save the output to `$EVID/before-library-route.txt`.
   - Screenshot `/dev/login?next=%2Fadmin`, then crop to the navigation line with `sips --cropToHeightWidth H W --cropOffset Y X`, giving `$EVID/before-admin-nav.png` (no "Library" link). **The crop must exclude the Email and Tenant rows**; check it visually. If a clean crop is impossible, keep only the `.txt` and say so.
   - Stop the base server.

### T1 Catalog filter types (`internal/library/catalog.go`)

**T1a, stub (2 min).** Create `internal/library/catalog.go` with the full types and constants below. For the three behaviours, use stubs first: `Label()` returns `string(tool)`, `Validate()` returns `nil`, `SearchTerms` returns `nil, nil`.

**T1b, RED (3 min).** Create `internal/library/catalog_test.go`:

```go
package library

import (
	"errors"
	"reflect"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

func TestCatalogFilterAcceptsOnlyValuesAnItemCanHave(t *testing.T) {
	for _, filter := range []Filter{
		{Page: 1},
		{Kind: pack.KindAgent, Category: "code-quality", Tag: "code-review", Tool: ToolCursor, Terms: []string{"review", "100%"}, Page: MaxPage},
	} {
		if err := filter.Validate(); err != nil {
			t.Errorf("Validate(%+v) = %v", filter, err)
		}
	}
	for name, filter := range map[string]Filter{
		"unknown kind":      {Kind: "widget", Page: 1},
		"category not slug": {Category: "Code Quality", Page: 1},
		"tag too long":      {Tag: strings.Repeat("a", 65), Page: 1},
		"unknown tool":      {Tool: "vim", Page: 1},
		"page zero":         {Page: 0},
		"page past the end": {Page: MaxPage + 1},
		"too many words":    {Terms: strings.Fields("a b c d e f g h i"), Page: 1},
		"empty word":        {Terms: []string{""}, Page: 1},
		"word with a space": {Terms: []string{"two words"}, Page: 1},
		"control character": {Terms: []string{"a\x00b"}, Page: 1},
	} {
		if err := filter.Validate(); !errors.Is(err, ErrInvalid) {
			t.Errorf("%s: Validate() = %v, want ErrInvalid", name, err)
		}
	}
}

func TestSearchTermsSplitsWordsWithinBounds(t *testing.T) {
	terms, err := SearchTerms("  Code   review\u00a0checklist ")
	if err != nil || !reflect.DeepEqual(terms, []string{"Code", "review", "checklist"}) {
		t.Fatalf("SearchTerms() = %q, %v", terms, err)
	}
	if terms, err := SearchTerms(""); err != nil || len(terms) != 0 {
		t.Fatalf("empty search = %q, %v", terms, err)
	}
	if _, err := SearchTerms(strings.Repeat("é", MaxSearchRunes)); err != nil {
		t.Fatalf("%d characters rejected: %v", MaxSearchRunes, err)
	}
	for name, text := range map[string]string{
		"too long": strings.Repeat("é", MaxSearchRunes+1), "too many words": "a b c d e f g h i",
		"invalid utf-8": "\xff", "newline": "a\nb",
	} {
		if _, err := SearchTerms(text); !errors.Is(err, ErrInvalid) {
			t.Errorf("%s: SearchTerms() error = %v, want ErrInvalid", name, err)
		}
	}
}

func TestToolLabelsNameTheProducts(t *testing.T) {
	for tool, want := range map[Tool]string{ToolClaudeCode: "Claude Code", ToolCodex: "Codex", ToolCursor: "Cursor", "future-tool": "future-tool"} {
		if got := tool.Label(); got != want {
			t.Errorf("%s.Label() = %q, want %q", tool, got, want)
		}
	}
}
```

- RED: `cd "$WT" && go test ./internal/library -run 'TestCatalogFilter|TestSearchTerms|TestToolLabels' -count=1`
- Expected failures: `unknown kind: Validate() = <nil>, want ErrInvalid` (and the other 9 cases), `SearchTerms() = [], <nil>`, and `claude-code.Label() = "claude-code", want "Claude Code"`.

**T1c, implement (4 min).** Final `catalog.go`:

```go
package library

import (
	"context"
	"fmt"
	"strings"
	"unicode"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// Catalog browsing bounds (story 86bcm901v). MaxPage pages of PageSize items
// cover the largest library Validate accepts.
const (
	PageSize       = 50
	MaxPage        = (MaxItems + PageSize - 1) / PageSize
	MaxSearchRunes = 100
	MaxSearchTerms = 8
)

// Label is the tool's product name; unknown tools show their ID.
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

// ValidName reports whether value is lowercase words joined by hyphens, at most
// 64 characters: the rule for item names, categories and tags.
func ValidName(value string) bool { return validSlug(value) }

// ValidVersion reports whether value is MAJOR.MINOR.PATCH.
func ValidVersion(value string) bool { return semverPattern.MatchString(value) }

// Filter selects catalog entries. Empty fields match every item; set fields must
// all match. Each of Terms must appear in the name, description, category or
// tags, ignoring case.
type Filter struct {
	Kind     pack.Kind
	Category string
	Tag      string
	Tool     Tool
	Terms    []string
	Page     int
}

// Validate rejects values no stored item can have, without echoing them.
func (filter Filter) Validate() error {
	switch {
	case filter.Kind != "" && !filter.Kind.Valid():
		return invalid("filter", "kind is not supported")
	case filter.Category != "" && !validSlug(filter.Category):
		return invalid("filter", "category must be lowercase words joined by hyphens")
	case filter.Tag != "" && !validSlug(filter.Tag):
		return invalid("filter", "tag must be lowercase words joined by hyphens")
	case filter.Tool != "" && !filter.Tool.Valid():
		return invalid("filter", "tool is not supported")
	case filter.Page < 1 || filter.Page > MaxPage:
		return invalid("filter", fmt.Sprintf("page must be 1 to %d", MaxPage))
	case len(filter.Terms) > MaxSearchTerms:
		return invalid("filter", fmt.Sprintf("search has more than %d words", MaxSearchTerms))
	}
	for _, term := range filter.Terms {
		if term == "" || !plainText(term) || strings.ContainsFunc(term, unicode.IsSpace) || utf8.RuneCountInString(term) > MaxSearchRunes {
			return invalid("filter", "search words must be plain text")
		}
	}
	return nil
}

// SearchTerms splits a typed search into words. It rejects more than
// MaxSearchRunes characters, more than MaxSearchTerms words, invalid UTF-8 and
// control characters.
func SearchTerms(text string) ([]string, error) {
	if !plainText(text) || utf8.RuneCountInString(text) > MaxSearchRunes {
		return nil, invalid("search", fmt.Sprintf("must be at most %d characters of plain text", MaxSearchRunes))
	}
	terms := strings.Fields(text)
	if len(terms) > MaxSearchTerms {
		return nil, invalid("search", fmt.Sprintf("must have at most %d words", MaxSearchTerms))
	}
	return terms, nil
}

func plainText(value string) bool {
	return utf8.ValidString(value) && !strings.ContainsFunc(value, unicode.IsControl)
}

// Entry is one catalog row: the newest stored version of an item, without its
// example and body.
type Entry struct {
	Kind        pack.Kind
	Name        string
	Version     string
	Category    string
	Tags        []string
	Tools       []Tool
	Description string
}

// Page is one page of matching entries and the number of all matches.
type Page struct {
	Entries []Entry
	Total   int
}

// Facets lists the values present in the newest stored versions, for the filter
// choices. Kinds follow pack.Kinds order; the rest are sorted.
type Facets struct {
	Kinds      []pack.Kind
	Categories []string
	Tags       []string
	Tools      []Tool
}

// Detail is one item version and every stored version of it, newest first.
type Detail struct {
	Item     Item
	Versions []string
}

// Catalog reads stored library items for the admin console. Items are shared
// product content, but the actor must be an administrator of the tenant in ctx.
type Catalog interface {
	ListLibrary(ctx context.Context, actor store.Principal, filter Filter) (Page, error)
	LibraryFacets(ctx context.Context, actor store.Principal) (Facets, error)
	GetLibraryItem(ctx context.Context, actor store.Principal, kind pack.Kind, name, version string) (Detail, error)
}
```

- GREEN: the same command, then `go test ./internal/library -count=1`.
- Mutations: **M1** delete the `filter.Kind` case, so `unknown kind` fails. **M2** delete the `MaxSearchTerms` check in `SearchTerms`, so `too many words` fails.
- Commit: `feat(86bcm901v): validate library catalog filters and search` (files: catalog.go, catalog_test.go).

### T2 Preview that cannot run anything (`internal/library/preview`)

**T2a, stub (2 min).** Create `preview.go` with the types and constants below, plus stubs `func Markdown(string) Document { return Document{} }` and `func Verbatim(string) Document { return Document{} }`.

**T2b, RED (4 min).** Create `internal/library/preview/preview_test.go`:

```go
package preview

import (
	"reflect"
	"strings"
	"testing"
	"time"
	"unicode/utf8"
)

func TestMarkdownRendersTheSupportedSubset(t *testing.T) {
	source := "---\nname: code-reviewer\ntools: Read\n---\n\n# Code review\n\nIntro line one\ncontinues here with `go test` and **care**.\n\n- Scope\n- Tests\n\n1. Run the diff\n2) Read files\n\n> Quoted advice\n\n```bash\nmake check\n```\n\n***\n## Next\n"
	want := Document{Blocks: []Block{
		{Kind: BlockCode, Label: "Frontmatter", Text: "name: code-reviewer\ntools: Read"},
		{Kind: BlockHeading, Level: 1, Spans: []Span{{Text: "Code review"}}},
		{Kind: BlockParagraph, Spans: []Span{{Text: "Intro line one continues here with "}, {Text: "go test", Code: true}, {Text: " and "}, {Text: "care", Strong: true}, {Text: "."}}},
		{Kind: BlockList, Items: [][]Span{{{Text: "Scope"}}, {{Text: "Tests"}}}},
		{Kind: BlockList, Ordered: true, Items: [][]Span{{{Text: "Run the diff"}}, {{Text: "Read files"}}}},
		{Kind: BlockQuote, Spans: []Span{{Text: "Quoted advice"}}},
		{Kind: BlockCode, Label: "bash", Text: "make check"},
		{Kind: BlockRule},
		{Kind: BlockHeading, Level: 2, Spans: []Span{{Text: "Next"}}},
	}}
	if got := Markdown(source); !reflect.DeepEqual(got, want) {
		t.Fatalf("Markdown() =\n%#v\nwant\n%#v", got, want)
	}
}

func TestMarkdownLeavesEverythingElseAsText(t *testing.T) {
	source := "<script>alert(1)</script>\n[click](javascript:alert(1)) ![pixel](https://tracker.example/p.png) <img src=x onerror=alert(1)>\n\n    indented stays text\n\n| a | b |\n"
	want := Document{Blocks: []Block{
		{Kind: BlockParagraph, Spans: []Span{{Text: "<script>alert(1)</script> [click](javascript:alert(1)) ![pixel](https://tracker.example/p.png) <img src=x onerror=alert(1)>"}}},
		{Kind: BlockParagraph, Spans: []Span{{Text: "    indented stays text"}}},
		{Kind: BlockParagraph, Spans: []Span{{Text: "| a | b |"}}},
	}}
	if got := Markdown(source); !reflect.DeepEqual(got, want) {
		t.Fatalf("Markdown() =\n%#v\nwant\n%#v", got, want)
	}
}

func TestMarkdownStaysBoundedOnHostileInput(t *testing.T) {
	hostile := map[string]string{
		"backticks":       strings.Repeat("`a", MaxInputBytes/2),
		"unclosed stars":  strings.Repeat("**a ", MaxInputBytes/4),
		"nested quotes":   strings.Repeat(">", MaxInputBytes),
		"headings":        strings.Repeat("# h\n", MaxInputBytes/4),
		"list items":      strings.Repeat("- a\n", MaxInputBytes/4),
		"unclosed fence":  "```\n" + strings.Repeat("x\n", MaxInputBytes/2),
		"oversized input": strings.Repeat("word ", MaxInputBytes),
		"invalid utf-8":   strings.Repeat("\xff\xfe", 1000),
	}
	for name, source := range hostile {
		t.Run(name, func(t *testing.T) {
			started := time.Now()
			doc := Markdown(source)
			if elapsed := time.Since(started); elapsed > time.Second {
				t.Fatalf("rendering took %v", elapsed)
			}
			units, size := 0, 0
			for _, block := range doc.Blocks {
				units += 1 + len(block.Items)
				texts := []string{block.Text}
				for _, span := range block.Spans {
					texts = append(texts, span.Text)
				}
				for _, item := range block.Items {
					for _, span := range item {
						texts = append(texts, span.Text)
					}
				}
				for _, text := range texts {
					size += len(text)
					if !utf8.ValidString(text) {
						t.Fatal("preview holds invalid UTF-8")
					}
				}
			}
			if units > MaxBlocks || size > MaxInputBytes {
				t.Fatalf("%d blocks and items (limit %d), %d bytes of text (limit %d)", units, MaxBlocks, size, MaxInputBytes)
			}
		})
	}
	if !Markdown(hostile["oversized input"]).Truncated || !Markdown(hostile["headings"]).Truncated {
		t.Fatal("a cut preview is not marked truncated")
	}
}

func TestVerbatimKeepsTheFileAsWritten(t *testing.T) {
	file := "{\n  \"mcpServers\": {\"github\": {\"command\": \"npx\"}}\n}\n# not a heading\n<b>not markup</b>\n"
	if got, want := Verbatim(file), (Document{Blocks: []Block{{Kind: BlockCode, Text: file}}}); !reflect.DeepEqual(got, want) {
		t.Fatalf("Verbatim() = %#v, want %#v", got, want)
	}
	if long := Verbatim(strings.Repeat("x", MaxInputBytes+1)); !long.Truncated || len(long.Blocks[0].Text) != MaxInputBytes {
		t.Fatal("an oversized file is not cut and marked truncated")
	}
}
```

- RED: `go test ./internal/library/preview -count=1`
- Expected: `Markdown() = preview.Document{Blocks:[]preview.Block(nil)…} want …`, `a cut preview is not marked truncated`, and the `Verbatim()` mismatch.

**T2c, implement (5 min).** `internal/library/preview/preview.go`:

```go
// Package preview turns untrusted library text into a small document model for
// the admin console (story 86bcm901v). It never produces HTML: the console
// renders the blocks with html/template, which escapes every piece of text, so
// raw HTML, links and images in the source stay visible as text and never load.
//
// Only a short Markdown subset is recognised: ATX headings, paragraphs, one level
// of bullet and numbered lists, block quotes, fenced code, thematic breaks, a
// leading YAML frontmatter block, `code` and **bold**. Everything else is literal
// text. Rendering is one pass, bounded by MaxInputBytes and MaxBlocks.
package preview

import (
	"regexp"
	"strings"
	"unicode/utf8"
)

const (
	// MaxInputBytes is the most source text one preview holds.
	MaxInputBytes = 64 << 10
	// MaxBlocks bounds blocks plus list items in one preview.
	MaxBlocks     = 500
	maxLabelRunes = 32
)

// BlockKind names a block; the page template compares these values.
type BlockKind string

// Block kinds.
const (
	BlockHeading   BlockKind = "heading"
	BlockParagraph BlockKind = "paragraph"
	BlockList      BlockKind = "list"
	BlockQuote     BlockKind = "quote"
	BlockCode      BlockKind = "code"
	BlockRule      BlockKind = "rule"
)

// Span is a run of inline text; at most one of Code and Strong is set.
type Span struct {
	Text   string
	Code   bool
	Strong bool
}

// Block is one block of a preview.
type Block struct {
	Kind    BlockKind
	Level   int      // heading level, 1 to 6
	Ordered bool     // numbered list
	Spans   []Span   // heading, paragraph, quote
	Items   [][]Span // list
	Text    string   // code, verbatim
	Label   string   // code: fence info string or "Frontmatter"
}

// Document is a bounded preview.
type Document struct {
	Blocks    []Block
	Truncated bool
}

// RE2 patterns: matching is linear in the line length.
var (
	fenceLine   = regexp.MustCompile("^ {0,3}(`{3,}|~{3,})[ \t]*([^`]*)$")
	headingLine = regexp.MustCompile(`^ {0,3}(#{1,6})[ \t]+(.*)$`)
	ruleLine    = regexp.MustCompile(`^ {0,3}(?:(?:\*[ \t]*){3,}|(?:-[ \t]*){3,}|(?:_[ \t]*){3,})$`)
	bulletLine  = regexp.MustCompile(`^[ \t]*[-*+][ \t]+(.*)$`)
	orderedLine = regexp.MustCompile(`^[ \t]*[0-9]{1,9}[.)][ \t]+(.*)$`)
	quoteLine   = regexp.MustCompile(`^ {0,3}>[ \t]?(.*)$`)
)

// Verbatim previews a file exactly as written, as one code block.
func Verbatim(source string) Document {
	text, truncated := bound(source)
	return Document{Blocks: []Block{{Kind: BlockCode, Text: text}}, Truncated: truncated}
}

// Markdown previews source as the supported Markdown subset.
func Markdown(source string) Document {
	text, truncated := bound(source)
	lines := strings.Split(text, "\n")
	b := &builder{doc: Document{Truncated: truncated}}
	start := 0
	if end := frontmatterEnd(lines); end > 0 {
		b.push(Block{Kind: BlockCode, Label: "Frontmatter", Text: strings.Join(lines[1:end], "\n")})
		start = end + 1
	}
	for i := start; i < len(lines); i++ {
		line := strings.TrimRight(lines[i], " \t\r")
		if m := fenceLine.FindStringSubmatch(line); m != nil {
			end := i + 1
			for end < len(lines) && !closesFence(lines[end], m[1]) {
				end++
			}
			b.add(Block{Kind: BlockCode, Label: label(m[2]), Text: strings.Join(lines[i+1:end], "\n")})
			i = end
			continue
		}
		if strings.TrimSpace(line) == "" {
			b.flush()
			continue
		}
		if ruleLine.MatchString(line) {
			b.add(Block{Kind: BlockRule})
			continue
		}
		if m := headingLine.FindStringSubmatch(line); m != nil {
			b.add(Block{Kind: BlockHeading, Level: len(m[1]), Spans: inline(strings.TrimSpace(m[2]))})
			continue
		}
		if m := bulletLine.FindStringSubmatch(line); m != nil {
			b.item(false, m[1])
			continue
		}
		if m := orderedLine.FindStringSubmatch(line); m != nil {
			b.item(true, m[1])
			continue
		}
		if m := quoteLine.FindStringSubmatch(line); m != nil {
			b.quoteText(m[1])
			continue
		}
		b.text(line)
	}
	b.flush()
	return b.doc
}

type builder struct {
	doc       Document
	units     int
	paragraph []string
	quote     []string
	items     [][]string
	ordered   bool
	inList    bool
}

// room reserves space for one block or list item; when the preview is full it
// marks the document truncated instead.
func (b *builder) room() bool {
	if b.units >= MaxBlocks {
		b.doc.Truncated = true
		return false
	}
	b.units++
	return true
}

func (b *builder) push(block Block) {
	if b.room() {
		b.doc.Blocks = append(b.doc.Blocks, block)
	}
}

func (b *builder) add(block Block) {
	b.flush()
	b.push(block)
}

func (b *builder) flush() {
	if b.paragraph != nil {
		b.push(Block{Kind: BlockParagraph, Spans: inline(strings.Join(b.paragraph, " "))})
		b.paragraph = nil
	}
	if b.quote != nil {
		b.push(Block{Kind: BlockQuote, Spans: inline(strings.Join(b.quote, " "))})
		b.quote = nil
	}
	if b.inList {
		if len(b.items) > 0 {
			list := Block{Kind: BlockList, Ordered: b.ordered}
			for _, parts := range b.items {
				list.Items = append(list.Items, inline(strings.Join(parts, " ")))
			}
			// The list and each item reserved their room as they were read.
			b.doc.Blocks = append(b.doc.Blocks, list)
		}
		b.items, b.inList = nil, false
	}
}

func (b *builder) item(ordered bool, text string) {
	if b.inList && b.ordered != ordered {
		b.flush()
	}
	if !b.inList {
		b.flush()
		if !b.room() {
			return
		}
		b.inList, b.ordered = true, ordered
	}
	if b.room() {
		b.items = append(b.items, []string{text})
	}
}

func (b *builder) quoteText(text string) {
	if b.quote == nil {
		b.flush()
		b.quote = []string{}
	}
	b.quote = append(b.quote, strings.TrimSpace(text))
}

// text continues the open list item or quote, or the paragraph. Parts are joined
// once at flush, so a long run of lines stays linear.
func (b *builder) text(line string) {
	switch {
	case b.inList && len(b.items) > 0:
		last := len(b.items) - 1
		b.items[last] = append(b.items[last], strings.TrimSpace(line))
	case b.quote != nil:
		b.quote = append(b.quote, strings.TrimSpace(line))
	default:
		b.paragraph = append(b.paragraph, line)
	}
}

// inline splits text into plain, `code` and **bold** spans in one pass. An
// opener without a closer stays literal, and no later opener of that kind is
// searched for, so the scan stays linear.
func inline(text string) []Span {
	spans := []Span{}
	var plain strings.Builder
	keep := func() {
		if plain.Len() > 0 {
			spans = append(spans, Span{Text: plain.String()})
			plain.Reset()
		}
	}
	noCode, noStrong := false, false
	for i := 0; i < len(text); {
		switch {
		case text[i] == '`' && !noCode:
			end := strings.IndexByte(text[i+1:], '`')
			if end < 0 {
				noCode = true
				continue
			}
			keep()
			spans = append(spans, Span{Text: text[i+1 : i+1+end], Code: true})
			i += end + 2
		case !noStrong && strings.HasPrefix(text[i:], "**"):
			end := strings.Index(text[i+2:], "**")
			if end < 0 {
				noStrong = true
				continue
			}
			if end == 0 {
				plain.WriteString("****")
				i += 4
				continue
			}
			keep()
			spans = append(spans, Span{Text: text[i+2 : i+2+end], Strong: true})
			i += end + 4
		default:
			plain.WriteByte(text[i])
			i++
		}
	}
	keep()
	return spans
}

// frontmatterEnd returns the line closing a leading "---" block, or 0.
func frontmatterEnd(lines []string) int {
	if len(lines) == 0 || strings.TrimRight(lines[0], " \t\r") != "---" {
		return 0
	}
	for i := 1; i < len(lines); i++ {
		if line := strings.TrimRight(lines[i], " \t\r"); line == "---" || line == "..." {
			return i
		}
	}
	return 0
}

func closesFence(line, fence string) bool {
	line = strings.TrimRight(line, " \t\r")
	indent := len(line) - len(strings.TrimLeft(line, " "))
	if indent > 3 {
		return false
	}
	run := line[indent:]
	return len(run) >= len(fence) && strings.Trim(run, fence[:1]) == ""
}

func label(info string) string {
	info = strings.TrimSpace(info)
	if utf8.RuneCountInString(info) > maxLabelRunes {
		info = string([]rune(info)[:maxLabelRunes])
	}
	return info
}

// bound cuts source to MaxInputBytes on a rune boundary and replaces invalid
// UTF-8, reporting whether anything was cut.
func bound(source string) (string, bool) {
	truncated := false
	if len(source) > MaxInputBytes {
		source, truncated = source[:MaxInputBytes], true
	}
	text := strings.ToValidUTF8(source, "\uFFFD")
	if len(text) > MaxInputBytes {
		cut := MaxInputBytes
		for cut > 0 && !utf8.RuneStart(text[cut]) {
			cut--
		}
		text, truncated = text[:cut], true
	}
	return text, truncated
}
```

- GREEN: `go test ./internal/library/preview -count=1 -race -v`
- Mutations: **M3** make `room()` always `return true`, so `headings` fails (more than 500 units, not truncated). **M4** in `bound()`, skip the first cut, so `oversized input` fails. **M5p** make `frontmatterEnd` return 0, so the subset test fails.
- Commit: `feat(86bcm901v): add an inert Markdown preview for library items`.

### T3 Store reads (`internal/store/postgres/library_catalog.go`)

**T3a, stub (2 min).** Create the file with the three methods returning zero values and `nil` (signatures as in `library.Catalog`) and `var _ library.Catalog = (*Store)(nil)`.

**T3b, RED (5 min).** Create `internal/store/postgres/library_catalog_test.go`:

```go
package postgres

import (
	"context"
	"errors"
	"fmt"
	"reflect"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/google/uuid"
)

type catalogFixture struct {
	repository    *Store
	ctx           context.Context
	admin, member store.Principal
}

// newCatalogStore loads library 1.0.0 (four items, security-reviewer at 1.9.0)
// and the 1.1.0 upgrade (security-reviewer 1.10.0) into a fresh schema.
func newCatalogStore(t *testing.T) catalogFixture {
	t.Helper()
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	all := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
	for _, shipped := range []library.Library{
		testLibrary("1.0.0",
			catalogItem(pack.KindSkill, "code-review-checklist", "1.0.0", "code-quality", []string{"code-review", "pull-requests"}, all, "Review checklist for pull requests."),
			catalogItem(pack.KindSkill, "commit-message-style", "1.0.0", "workflow", []string{"git", "commits"}, []library.Tool{library.ToolClaudeCode}, "Conventional commit format."),
			catalogItem(pack.KindAgent, "security-reviewer", "1.9.0", "security", []string{"security", "legacy"}, []library.Tool{library.ToolCodex}, "Old reviewer."),
			catalogItem(pack.KindConfig, "codex-defaults", "1.1.0", "configuration", []string{"codex"}, []library.Tool{library.ToolCodex}, "Baseline Codex CLI configuration."),
		),
		testLibrary("1.1.0",
			catalogItem(pack.KindAgent, "security-reviewer", "1.10.0", "code-quality", []string{"security", "code-review"}, []library.Tool{library.ToolCodex, library.ToolCursor}, "Reviews diffs for 100% of auth_checks."),
		),
	} {
		if _, err := repository.loadLibrary(ctx, shipped); err != nil {
			t.Fatalf("load library %s: %v", shipped.Version, err)
		}
	}
	admin, err := repository.ResolveOrCreateGoogleUser(ctx, store.GoogleIdentity{Subject: "catalog-admin", Email: "admin@example.com", DisplayName: "Admin"})
	if err != nil {
		t.Fatal(err)
	}
	member := store.Principal{UserID: store.UserID(uuid.NewString()), TenantID: admin.TenantID}
	if err := repository.CreateUser(store.WithTenant(ctx, admin.TenantID), store.User{ID: member.UserID, TenantID: admin.TenantID, Provider: "google", ProviderSubject: "catalog-member", Email: "member@example.com", DisplayName: "Member"}); err != nil {
		t.Fatal(err)
	}
	return catalogFixture{repository: repository, ctx: store.WithTenant(ctx, admin.TenantID), admin: admin, member: member}
}

func catalogItem(kind pack.Kind, name, version, category string, tags []string, tools []library.Tool, description string) library.Item {
	return library.Item{Kind: kind, Name: name, Version: version, Category: category, Tags: tags, Tools: tools,
		Description: description, Example: "Ask for " + name + ".\n", Body: "Body of " + name + " " + version + ".\n"}
}

func entryKeys(entries []library.Entry) []string {
	keys := []string{}
	for _, entry := range entries {
		keys = append(keys, string(entry.Kind)+"/"+entry.Name+"@"+entry.Version)
	}
	return keys
}

func TestLibraryCatalogWithPostgres(t *testing.T) {
	t.Run("lists the newest version of each item in kind order", func(t *testing.T) {
		f := newCatalogStore(t)
		page, err := f.repository.ListLibrary(f.ctx, f.admin, library.Filter{Page: 1})
		if err != nil {
			t.Fatal(err)
		}
		want := []string{"skill/code-review-checklist@1.0.0", "skill/commit-message-style@1.0.0", "agent/security-reviewer@1.10.0", "config/codex-defaults@1.1.0"}
		if got := entryKeys(page.Entries); !reflect.DeepEqual(got, want) || page.Total != 4 {
			t.Fatalf("entries = %v (total %d), want %v (total 4)", got, page.Total, want)
		}
		if e := page.Entries[2]; e.Category != "code-quality" || !reflect.DeepEqual(e.Tools, []library.Tool{library.ToolCodex, library.ToolCursor}) || e.Description != "Reviews diffs for 100% of auth_checks." {
			t.Fatalf("newest metadata not used: %+v", e)
		}
	})
	t.Run("filters combine and only match the newest version", func(t *testing.T) {
		f := newCatalogStore(t)
		for name, tc := range map[string]struct {
			filter library.Filter
			want   []string
		}{
			"kind and tool":                {library.Filter{Kind: pack.KindSkill, Tool: library.ToolCodex, Page: 1}, []string{"skill/code-review-checklist@1.0.0"}},
			"category only on old version": {library.Filter{Category: "security", Page: 1}, []string{}},
			"tag only on old version":      {library.Filter{Tag: "legacy", Page: 1}, []string{}},
			"every word must match":        {library.Filter{Terms: []string{"REVIEW", "checklist"}, Page: 1}, []string{"skill/code-review-checklist@1.0.0"}},
			"percent is literal":           {library.Filter{Terms: []string{"%"}, Page: 1}, []string{"agent/security-reviewer@1.10.0"}},
			"underscore is literal":        {library.Filter{Terms: []string{"w_r"}, Page: 1}, []string{}},
			"tags are searched":            {library.Filter{Terms: []string{"pull-requests"}, Page: 1}, []string{"skill/code-review-checklist@1.0.0"}},
		} {
			page, err := f.repository.ListLibrary(f.ctx, f.admin, tc.filter)
			if err != nil {
				t.Fatalf("%s: %v", name, err)
			}
			if got := entryKeys(page.Entries); !reflect.DeepEqual(got, tc.want) || page.Total != len(tc.want) {
				t.Errorf("%s: entries = %v (total %d), want %v", name, got, page.Total, tc.want)
			}
		}
	})
	t.Run("pages hold 50 items and report every match", func(t *testing.T) {
		f := newCatalogStore(t)
		var generated []library.Item
		for i := range 120 {
			generated = append(generated, catalogItem(pack.KindMCPTemplate, fmt.Sprintf("generated-%03d", i), "1.0.0", "integrations", []string{"generated"}, []library.Tool{library.ToolCursor}, "Generated item."))
		}
		if _, err := f.repository.loadLibrary(context.Background(), testLibrary("1.2.0", generated...)); err != nil {
			t.Fatal(err)
		}
		third, err := f.repository.ListLibrary(f.ctx, f.admin, library.Filter{Page: 3})
		if err != nil || third.Total != 124 || len(third.Entries) != 24 || third.Entries[0].Name != "generated-096" {
			t.Fatalf("page 3 = %d entries, total %d, err %v", len(third.Entries), third.Total, err)
		}
		tagged, err := f.repository.ListLibrary(f.ctx, f.admin, library.Filter{Tag: "generated", Page: 2})
		if err != nil || tagged.Total != 120 || len(tagged.Entries) != library.PageSize || tagged.Entries[0].Name != "generated-050" {
			t.Fatalf("tagged page 2 = %d entries, total %d, err %v", len(tagged.Entries), tagged.Total, err)
		}
	})
	t.Run("facets come from the newest versions", func(t *testing.T) {
		f := newCatalogStore(t)
		facets, err := f.repository.LibraryFacets(f.ctx, f.admin)
		want := library.Facets{
			Kinds:      []pack.Kind{pack.KindSkill, pack.KindAgent, pack.KindConfig},
			Categories: []string{"code-quality", "configuration", "workflow"},
			Tags:       []string{"code-review", "codex", "commits", "git", "pull-requests", "security"},
			Tools:      []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor},
		}
		if err != nil || !reflect.DeepEqual(facets, want) {
			t.Fatalf("facets = %+v, %v; want %+v", facets, err, want)
		}
	})
	t.Run("an item opens at its newest or a chosen version", func(t *testing.T) {
		f := newCatalogStore(t)
		newest, err := f.repository.GetLibraryItem(f.ctx, f.admin, pack.KindAgent, "security-reviewer", "")
		if err != nil || newest.Item.Version != "1.10.0" || !reflect.DeepEqual(newest.Versions, []string{"1.10.0", "1.9.0"}) ||
			newest.Item.Body != "Body of security-reviewer 1.10.0.\n" || newest.Item.Example != "Ask for security-reviewer.\n" ||
			!reflect.DeepEqual(newest.Item.Tags, []string{"security", "code-review"}) {
			t.Fatalf("newest = %+v, %v", newest, err)
		}
		older, err := f.repository.GetLibraryItem(f.ctx, f.admin, pack.KindAgent, "security-reviewer", "1.9.0")
		if err != nil || older.Item.Category != "security" || older.Item.Body != "Body of security-reviewer 1.9.0.\n" {
			t.Fatalf("older = %+v, %v", older, err)
		}
		for _, ref := range [][3]string{{"agent", "security-reviewer", "2.0.0"}, {"agent", "no-such-item", ""}, {"widget", "security-reviewer", ""}, {"agent", "Security Reviewer", ""}, {"agent", "security-reviewer", "1.10"}} {
			if _, err := f.repository.GetLibraryItem(f.ctx, f.admin, pack.Kind(ref[0]), ref[1], ref[2]); !errors.Is(err, store.ErrNotFound) {
				t.Errorf("%v: error = %v, want not found", ref, err)
			}
		}
	})
	t.Run("only administrators of the request tenant can read", func(t *testing.T) {
		f := newCatalogStore(t)
		if _, err := f.repository.ListLibrary(f.ctx, f.member, library.Filter{Page: 1}); !errors.Is(err, org.ErrForbidden) {
			t.Errorf("member list error = %v", err)
		}
		if _, err := f.repository.LibraryFacets(f.ctx, f.member); !errors.Is(err, org.ErrForbidden) {
			t.Errorf("member facets error = %v", err)
		}
		if _, err := f.repository.GetLibraryItem(f.ctx, f.member, pack.KindSkill, "code-review-checklist", ""); !errors.Is(err, org.ErrForbidden) {
			t.Errorf("member item error = %v", err)
		}
		elsewhere := store.WithTenant(context.Background(), store.TenantID(uuid.NewString()))
		if _, err := f.repository.ListLibrary(elsewhere, f.admin, library.Filter{Page: 1}); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("other-tenant context error = %v", err)
		}
		if _, err := f.repository.ListLibrary(f.ctx, f.admin, library.Filter{Page: 0}); !errors.Is(err, library.ErrInvalid) {
			t.Errorf("invalid filter error = %v", err)
		}
	})
}
```

- RED: `source "$SCRATCH/test-env.sh" && go test ./internal/store/postgres -run TestLibraryCatalogWithPostgres -count=1 -v`
- Expected: `entries = [] (total 0), want [skill/code-review-checklist@1.0.0 …]`, then failures in each subtest. **Not** `--- SKIP` (a skip means the env file wasn't sourced).

**T3c, implement (5 min).** Final `library_catalog.go`:

```go
package postgres

import (
	"context"
	"slices"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/jackc/pgx/v5"
)

var _ library.Catalog = (*Store)(nil)

// newestLibraryItems keeps the newest stored version of every library item.
// Versions compare numerically (1.10.0 is newer than 1.9.0); migration 20's
// CHECK guarantees every part is digits.
const newestLibraryItems = `WITH newest AS (
	SELECT DISTINCT ON (kind, name) kind, name, version, category, tags, tools, description
	FROM library_items
	ORDER BY kind, name, string_to_array(version, '.')::numeric[] DESC
)
`

// Search words are matched with strpos, so % and _ are ordinary characters.
const listLibraryItems = newestLibraryItems + `SELECT kind, name, version, category, tags, tools, description, count(*) OVER ()
FROM newest
WHERE ($1::text = '' OR kind = $1::text)
	AND ($2::text = '' OR category = $2::text)
	AND ($3::text = '' OR $3::text = ANY(tags))
	AND ($4::text = '' OR $4::text = ANY(tools))
	AND NOT EXISTS (
		SELECT 1 FROM unnest($5::text[]) AS term
		WHERE strpos(lower(name || ' ' || description || ' ' || category || ' ' || array_to_string(tags, ' ')), lower(term)) = 0
	)
ORDER BY array_position($6::text[], kind), kind, name COLLATE "C"
LIMIT $7 OFFSET $8`

const libraryFacetValues = newestLibraryItems + `SELECT
	ARRAY(SELECT kind FROM (SELECT DISTINCT kind FROM newest) AS kinds ORDER BY array_position($1::text[], kind), kind),
	ARRAY(SELECT DISTINCT category COLLATE "C" FROM newest ORDER BY 1),
	ARRAY(SELECT DISTINCT tag COLLATE "C" FROM newest, unnest(tags) AS tag ORDER BY 1),
	ARRAY(SELECT DISTINCT tool COLLATE "C" FROM newest, unnest(tools) AS tool ORDER BY 1)`

// ListLibrary returns one page of the newest library items matching filter.
// Library rows are shared product content with no tenant column, but the actor
// must be an administrator of the tenant in ctx.
func (database *Store) ListLibrary(ctx context.Context, actor store.Principal, filter library.Filter) (library.Page, error) {
	if err := filter.Validate(); err != nil {
		return library.Page{}, err
	}
	tx, err := database.beginLibraryRead(ctx, actor)
	if err != nil {
		return library.Page{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	terms := filter.Terms
	if terms == nil {
		terms = []string{}
	}
	rows, err := tx.Query(ctx, listLibraryItems, string(filter.Kind), filter.Category, filter.Tag, string(filter.Tool),
		terms, kindOrder(), library.PageSize, (filter.Page-1)*library.PageSize)
	if err != nil {
		return library.Page{}, orgError(err)
	}
	defer rows.Close()
	page := library.Page{Entries: []library.Entry{}}
	for rows.Next() {
		var entry library.Entry
		var kind string
		var tools []string
		if err := rows.Scan(&kind, &entry.Name, &entry.Version, &entry.Category, &entry.Tags, &tools, &entry.Description, &page.Total); err != nil {
			return library.Page{}, orgError(err)
		}
		entry.Kind, entry.Tools = pack.Kind(kind), libraryTools(tools)
		page.Entries = append(page.Entries, entry)
	}
	if err := rows.Err(); err != nil {
		return library.Page{}, orgError(err)
	}
	return page, nil
}

// LibraryFacets lists the kinds, categories, tags and tools of the newest
// stored versions, for the filter choices.
func (database *Store) LibraryFacets(ctx context.Context, actor store.Principal) (library.Facets, error) {
	tx, err := database.beginLibraryRead(ctx, actor)
	if err != nil {
		return library.Facets{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	var kinds, tools []string
	var facets library.Facets
	if err := tx.QueryRow(ctx, libraryFacetValues, kindOrder()).Scan(&kinds, &facets.Categories, &facets.Tags, &tools); err != nil {
		return library.Facets{}, orgError(err)
	}
	for _, kind := range kinds {
		facets.Kinds = append(facets.Kinds, pack.Kind(kind))
	}
	facets.Tools = libraryTools(tools)
	return facets, nil
}

// GetLibraryItem returns one stored item version (the newest when version is
// empty) and every stored version of the item, newest first.
func (database *Store) GetLibraryItem(ctx context.Context, actor store.Principal, kind pack.Kind, name, version string) (library.Detail, error) {
	if !kind.Valid() || !library.ValidName(name) || (version != "" && !library.ValidVersion(version)) {
		return library.Detail{}, store.ErrNotFound
	}
	tx, err := database.beginLibraryRead(ctx, actor)
	if err != nil {
		return library.Detail{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	versions, err := libraryVersions(ctx, tx, kind, name)
	if err != nil {
		return library.Detail{}, err
	}
	if len(versions) == 0 || (version != "" && !slices.Contains(versions, version)) {
		return library.Detail{}, store.ErrNotFound
	}
	if version == "" {
		version = versions[0]
	}
	item := library.Item{Kind: kind, Name: name, Version: version}
	var tools []string
	if err := tx.QueryRow(ctx, `SELECT category, tags, tools, description, example, body FROM library_items WHERE kind=$1 AND name=$2 AND version=$3`,
		string(kind), name, version).Scan(&item.Category, &item.Tags, &tools, &item.Description, &item.Example, &item.Body); err != nil {
		return library.Detail{}, orgError(err)
	}
	item.Tools = libraryTools(tools)
	return library.Detail{Item: item, Versions: versions}, nil
}

func libraryVersions(ctx context.Context, tx pgx.Tx, kind pack.Kind, name string) ([]string, error) {
	rows, err := tx.Query(ctx, `SELECT version FROM library_items WHERE kind=$1 AND name=$2 ORDER BY string_to_array(version, '.')::numeric[] DESC`, string(kind), name)
	if err != nil {
		return nil, orgError(err)
	}
	defer rows.Close()
	versions := []string{}
	for rows.Next() {
		var version string
		if err := rows.Scan(&version); err != nil {
			return nil, orgError(err)
		}
		versions = append(versions, version)
	}
	if err := rows.Err(); err != nil {
		return nil, orgError(err)
	}
	return versions, nil
}

// beginLibraryRead requires an administrator of the tenant in ctx.
func (database *Store) beginLibraryRead(ctx context.Context, actor store.Principal) (pgx.Tx, error) {
	tx, admin, err := database.beginOrg(ctx, actor, false)
	if err != nil {
		return nil, err
	}
	if !admin {
		_ = tx.Rollback(ctx)
		return nil, org.ErrForbidden
	}
	return tx, nil
}

func kindOrder() []string {
	order := []string{}
	for _, kind := range pack.Kinds() {
		order = append(order, string(kind))
	}
	return order
}

func libraryTools(values []string) []library.Tool {
	tools := make([]library.Tool, 0, len(values))
	for _, value := range values {
		tools = append(tools, library.Tool(value))
	}
	return tools
}
```

- GREEN: the same command; all 6 subtests PASS, with no SKIP.
- Mutations:
  - **M6** replace `string_to_array(version, '.')::numeric[]` with `version` in both places: the newest becomes 1.9.0 and Versions become `[1.9.0 1.10.0]`.
  - **M7** replace `strpos(…, lower(term)) = 0` with `NOT (… LIKE '%' || lower(term) || '%')`: `percent is literal` and `underscore is literal` fail.
  - **M9** delete the `if !admin` block: the member subtests fail.
- Commit: `feat(86bcm901v): read the newest library items with filters and facets`.

### T4 List page (AC1 and its failure path)

**T4a, stub (3 min).**
- `internal/web/handler.go`:
  - add the import `"github.com/LeornaAI/leorna-control-plane/internal/library"` (between `internal/console` and `internal/metric`);
  - add the struct field `libraryCatalog library.Catalog` after `packAssignmentsTemplate`.
- New `internal/web/library.go` with only `func (handler *Handler) SetLibrary(catalog library.Catalog) { handler.libraryCatalog = catalog }`.
- `cmd/control-plane/main.go`: add `application.SetLibrary(repository)` right after `application.SetPacks(repository, seed)`.

**T4b, RED (5 min).** New `internal/web/library_test.go`: shared helpers plus the AC1 and failure tests. AC2 tests are appended in T5.

```go
package web

import (
	"context"
	"errors"
	"net/http"
	"reflect"
	"regexp"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

func newLibraryFixture(t *testing.T) packFixture {
	t.Helper()
	fixture := newPackFixture(t)
	fixture.handler.SetLibrary(fixture.repository)
	return fixture
}

// insertLibraryItems writes validated items straight into the fixture's schema.
func insertLibraryItems(t *testing.T, pool *pgxpool.Pool, items ...library.Item) {
	t.Helper()
	batch := &pgx.Batch{}
	for _, item := range items {
		if err := item.Validate(); err != nil {
			t.Fatalf("fixture item %s: %v", item.Key(), err)
		}
		tools := make([]string, 0, len(item.Tools))
		for _, tool := range item.Tools {
			tools = append(tools, string(tool))
		}
		batch.Queue(`INSERT INTO library_items(id,kind,name,version,category,tags,tools,description,example,body,content_sha256,library_version)
			VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,'test')`,
			uuid.NewString(), string(item.Kind), item.Name, item.Version, item.Category, item.Tags, tools,
			item.Description, item.Example, item.Body, item.Checksum())
	}
	if err := pool.SendBatch(context.Background(), batch).Close(); err != nil {
		t.Fatalf("insert library items: %v", err)
	}
}

// catalogFixtureItems: four items, security-reviewer stored at 1.9.0 and 1.10.0.
// Only the old version has category "security" and tag "legacy".
func catalogFixtureItems() []library.Item {
	all := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
	return []library.Item{
		{Kind: pack.KindSkill, Name: "code-review-checklist", Version: "1.0.0", Category: "code-quality", Tags: []string{"code-review", "pull-requests"}, Tools: all, Description: "Review checklist for pull requests.", Example: "Ask for code-review-checklist.\n", Body: "# Checklist\n\n- Scope\n"},
		{Kind: pack.KindSkill, Name: "commit-message-style", Version: "1.0.0", Category: "workflow", Tags: []string{"git", "commits"}, Tools: []library.Tool{library.ToolClaudeCode}, Description: "Conventional commit format.", Example: "Ask for commit-message-style.\n", Body: "Use feat: and fix:.\n"},
		{Kind: pack.KindAgent, Name: "security-reviewer", Version: "1.9.0", Category: "security", Tags: []string{"security", "legacy"}, Tools: []library.Tool{library.ToolCodex}, Description: "Old reviewer.", Example: "Ask for the old reviewer.\n", Body: "Old body.\n"},
		{Kind: pack.KindAgent, Name: "security-reviewer", Version: "1.10.0", Category: "code-quality", Tags: []string{"security", "code-review"}, Tools: []library.Tool{library.ToolCodex, library.ToolCursor}, Description: "Reviews diffs for 100% of auth_checks.", Example: "Ask for security-reviewer.\n", Body: "New body.\n"},
		{Kind: pack.KindConfig, Name: "codex-defaults", Version: "1.1.0", Category: "configuration", Tags: []string{"codex"}, Tools: []library.Tool{library.ToolCodex}, Description: "Baseline Codex CLI configuration.", Example: "Ask for codex-defaults.\n", Body: "approval_policy = \"on-request\"\n"},
	}
}

var libraryRowLink = regexp.MustCompile(`<td><a href="/admin/library/([a-z_]+)/([a-z0-9-]+)">`)

func listedLibraryItems(body string) []string {
	items := []string{}
	for _, match := range libraryRowLink.FindAllStringSubmatch(body, -1) {
		items = append(items, match[1]+"/"+match[2])
	}
	return items
}

func pageSection(t *testing.T, body, start, end string) string {
	t.Helper()
	from := strings.Index(body, start)
	if from < 0 {
		t.Fatalf("page has no %q:\n%s", start, body)
	}
	rest := body[from+len(start):]
	to := strings.Index(rest, end)
	if to < 0 {
		t.Fatalf("page has no %q after %q", end, start)
	}
	return rest[:to]
}

func TestLibraryBrowserFiltersByKindCategoryTagToolAndTextWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	insertLibraryItems(t, fixture.pool, catalogFixtureItems()...)
	admin := fixture.login(t, fixture.admin, strings.Repeat("a", 43))

	t.Run("the admin console links to the library", func(t *testing.T) {
		if body := fixture.get(t, admin, "/admin", http.StatusOK); !strings.Contains(body, `<a href="/admin/library">Library</a>`) {
			t.Fatalf("admin navigation has no library link: %s", body)
		}
	})
	t.Run("the library lists each item's newest version with filter choices from the data", func(t *testing.T) {
		body := fixture.get(t, admin, "/admin/library", http.StatusOK)
		want := []string{"skill/code-review-checklist", "skill/commit-message-style", "agent/security-reviewer", "config/codex-defaults"}
		if got := listedLibraryItems(body); !reflect.DeepEqual(got, want) {
			t.Fatalf("listed %v, want %v", got, want)
		}
		if !strings.Contains(body, `<p id="result-count" class="muted">4 items match</p>`) || !strings.Contains(body, "<td>1.10.0</td>") || strings.Contains(body, "<td>1.9.0</td>") {
			t.Fatalf("count or newest version wrong: %s", body)
		}
		for name, options := range map[string]string{
			"kind":     `<option value="">All kinds</option><option value="skill">Skill</option><option value="agent">Agent</option><option value="config">Config</option>`,
			"category": `<option value="">All categories</option><option value="code-quality">code-quality</option><option value="configuration">configuration</option><option value="workflow">workflow</option>`,
			"tag":      `<option value="">All tags</option><option value="code-review">code-review</option><option value="codex">codex</option><option value="commits">commits</option><option value="git">git</option><option value="pull-requests">pull-requests</option><option value="security">security</option>`,
			"tool":     `<option value="">All tools</option><option value="claude-code">Claude Code</option><option value="codex">Codex</option><option value="cursor">Cursor</option>`,
		} {
			if got := pageSection(t, body, `<select name="`+name+`" id="filter-`+name+`">`, `</select>`); got != options {
				t.Errorf("%s choices = %s\nwant %s", name, got, options)
			}
		}
		if !strings.Contains(body, `<input type="search" name="q" id="filter-q" value="" maxlength="100">`) {
			t.Error("search box missing")
		}
	})
	t.Run("each filter and the search narrow the list", func(t *testing.T) {
		everything := []string{"skill/code-review-checklist", "skill/commit-message-style", "agent/security-reviewer", "config/codex-defaults"}
		for _, tc := range []struct {
			query string
			want  []string
		}{
			{"?kind=agent", []string{"agent/security-reviewer"}},
			{"?category=code-quality", []string{"skill/code-review-checklist", "agent/security-reviewer"}},
			{"?category=security", []string{}},
			{"?tag=code-review", []string{"skill/code-review-checklist", "agent/security-reviewer"}},
			{"?tag=legacy", []string{}},
			{"?tool=cursor", []string{"skill/code-review-checklist", "agent/security-reviewer"}},
			{"?tool=claude-code", []string{"skill/code-review-checklist", "skill/commit-message-style"}},
			{"?q=COMMIT", []string{"skill/commit-message-style"}},
			{"?q=review+checklist", []string{"skill/code-review-checklist"}},
			{"?q=%25", []string{"agent/security-reviewer"}},
			{"?q=w_r", []string{}},
			{"?kind=skill&tool=claude-code&category=workflow&tag=git&q=commit", []string{"skill/commit-message-style"}},
			{"?q=&kind=&category=&tag=&tool=", everything},
		} {
			body := fixture.get(t, admin, "/admin/library"+tc.query, http.StatusOK)
			if got := listedLibraryItems(body); !reflect.DeepEqual(got, tc.want) {
				t.Errorf("%s listed %v, want %v", tc.query, got, tc.want)
			}
			if len(tc.want) == 0 && !strings.Contains(body, "No library items match these filters.") {
				t.Errorf("%s: empty result has no message", tc.query)
			}
		}
	})
	t.Run("the chosen filters stay selected", func(t *testing.T) {
		body := fixture.get(t, admin, "/admin/library?kind=agent&tool=cursor&q=review", http.StatusOK)
		for _, want := range []string{`<option value="agent" selected>Agent</option>`, `<option value="cursor" selected>Cursor</option>`, `name="q" id="filter-q" value="review"`} {
			if !strings.Contains(body, want) {
				t.Errorf("form lost %s", want)
			}
		}
	})
}

func TestLibraryBrowserRejectsBadFiltersAndNonAdminsWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	insertLibraryItems(t, fixture.pool, catalogFixtureItems()...)
	admin := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	member := fixture.login(t, fixture.member, strings.Repeat("b", 43))
	other := fixture.login(t, fixture.other, strings.Repeat("d", 43))

	t.Run("a bad filter returns 400 with the form and a message", func(t *testing.T) {
		for _, query := range []string{"?kind=widget", "?tool=vim", "?category=Code%20Quality", "?tag=" + strings.Repeat("a", 65), "?q=" + strings.Repeat("x", 101), "?q=a+b+c+d+e+f+g+h+i", "?page=0", "?page=41", "?page=two", "?sort=name", "?kind=skill&kind=agent"} {
			response := request(t, admin, http.MethodGet, fixture.server.URL+"/admin/library"+query, "", "")
			assertStatus(t, response, http.StatusBadRequest)
			body := readBody(t, response)
			if !strings.HasPrefix(response.Header.Get("Content-Type"), "text/html") || !strings.Contains(body, `role="alert"`) || !strings.Contains(body, `action="/admin/library"`) || !strings.Contains(body, `<option value="skill">Skill</option>`) || strings.Contains(body, `id="results"`) {
				t.Errorf("%s did not keep an editable form without results: %s", query, body)
			}
		}
	})
	t.Run("members are refused", func(t *testing.T) {
		for _, path := range []string{"/admin/library", "/admin/library/skill/code-review-checklist"} {
			fixture.get(t, member, path, http.StatusForbidden)
		}
	})
	t.Run("signed-out visitors are sent to sign in", func(t *testing.T) {
		response := request(t, newTestClient(t, fixture.server), http.MethodGet, fixture.server.URL+"/admin/library?kind=skill", "", "")
		closeBody(t, response)
		if response.StatusCode != http.StatusFound || response.Header.Get("Location") != "/v1/auth/google/login" {
			t.Fatalf("signed-out visit = %d %q", response.StatusCode, response.Header.Get("Location"))
		}
	})
	t.Run("unknown items and versions are not found", func(t *testing.T) {
		for _, path := range []string{"/admin/library/skill/no-such-item", "/admin/library/widget/code-review-checklist", "/admin/library/skill/code-review-checklist?version=9.9.9", "/admin/library/skill/code-review-checklist?version=latest"} {
			fixture.get(t, admin, path, http.StatusNotFound)
		}
		fixture.get(t, admin, "/admin/library/skill/code-review-checklist?view=raw", http.StatusBadRequest)
	})
	t.Run("another tenant's admin browses the same shared library", func(t *testing.T) {
		if got := listedLibraryItems(fixture.get(t, other, "/admin/library", http.StatusOK)); len(got) != 4 {
			t.Fatalf("other tenant sees %v", got)
		}
	})
}
```

Compile note: if `errors`, `store` or `context` are unused until T5, the test file will not compile. Either add T5's fake catalog now or remove those imports and add them back in T5.

- RED: `source "$SCRATCH/test-env.sh" && go test ./internal/web -run 'TestLibraryBrowser' -count=1 -v`
- Expected: `admin navigation has no library link`, then `status = 303, want 200` (and `want 400` / `want 403` / `want 404`), because `GET /` redirects to `/admin`.

**T4c, implement (5 min).**

1. `handler.go` routes, after the `POST /admin/packs/assignments/project` line:
   ```go
   routes.Handle("GET /admin/library", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryView)), true))
   routes.Handle("GET /admin/library/{kind}/{name}", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.libraryItemView)), true))
   ```
2. `adminTemplate` nav: change `<a href="/admin/packs">Packs</a> · <a href="/admin/setup">Setup</a>` to `<a href="/admin/packs">Packs</a> · <a href="/admin/library">Library</a> · <a href="/admin/setup">Setup</a>`.
3. Full `internal/web/library.go`. The item handler and its template are included here so the file is written once; the AC2 tests come in T5.

```go
package web

import (
	"bytes"
	"errors"
	"html/template"
	"net/http"
	"net/url"
	"slices"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/preview"
	"github.com/LeornaAI/leorna-control-plane/internal/org"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// SetLibrary binds the content library reader behind /admin/library (86bcm901v).
func (handler *Handler) SetLibrary(catalog library.Catalog) { handler.libraryCatalog = catalog }

const libraryFilterHelp = "Check the filters: choose kind, category, tag and tool from the lists, search with at most 100 characters and 8 words, and use the page links."

var libraryFilterKeys = []string{"q", "kind", "category", "tag", "tool"}

// libraryFilter reads the list query. Each parameter may appear once; an empty
// value means "any".
func libraryFilter(query url.Values) (library.Filter, error) {
	for key, values := range query {
		if len(values) != 1 || (key != "page" && !slices.Contains(libraryFilterKeys, key)) {
			return library.Filter{}, library.ErrInvalid
		}
	}
	terms, err := library.SearchTerms(query.Get("q"))
	if err != nil {
		return library.Filter{}, err
	}
	filter := library.Filter{Kind: pack.Kind(query.Get("kind")), Category: query.Get("category"), Tag: query.Get("tag"),
		Tool: library.Tool(query.Get("tool")), Terms: terms, Page: 1}
	if raw := query.Get("page"); raw != "" {
		if filter.Page, err = strconv.Atoi(raw); err != nil {
			return library.Filter{}, library.ErrInvalid
		}
	}
	return filter, filter.Validate()
}

func (handler *Handler) libraryView(w http.ResponseWriter, r *http.Request) {
	if handler.libraryCatalog == nil {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "LIBRARY_UNAVAILABLE", "The content library is unavailable")
		return
	}
	actor := teamActor(r)
	facets, err := handler.libraryCatalog.LibraryFacets(r.Context(), actor)
	if err != nil {
		handler.libraryFailure(w, r, err)
		return
	}
	nonce, err := handler.randomHex(16)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library page could not be rendered", err)
		return
	}
	query := r.URL.Query()
	filter, err := libraryFilter(query)
	if err != nil {
		page := newLibraryListPage(facets, library.Filter{})
		page.Nonce, page.FilterError = nonce, libraryFilterHelp
		handler.renderLibraryPage(w, r, libraryListTemplate, http.StatusBadRequest, nonce, page)
		return
	}
	result, err := handler.libraryCatalog.ListLibrary(r.Context(), actor, filter)
	if err != nil {
		handler.libraryFailure(w, r, err)
		return
	}
	page := newLibraryListPage(facets, filter)
	page.Nonce, page.Query = nonce, strings.Join(filter.Terms, " ")
	page.Total, page.Page = result.Total, filter.Page
	page.Pages = (result.Total + library.PageSize - 1) / library.PageSize
	for _, entry := range result.Entries {
		page.Rows = append(page.Rows, libraryRowFor(entry))
	}
	page.FirstHref = libraryPageHref(query, 1)
	if filter.Page > 1 {
		page.PrevHref = libraryPageHref(query, filter.Page-1)
	}
	if filter.Page < page.Pages {
		page.NextHref = libraryPageHref(query, filter.Page+1)
	}
	handler.renderLibraryPage(w, r, libraryListTemplate, http.StatusOK, nonce, page)
}

func (handler *Handler) libraryItemView(w http.ResponseWriter, r *http.Request) {
	if handler.libraryCatalog == nil {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "LIBRARY_UNAVAILABLE", "The content library is unavailable")
		return
	}
	query := r.URL.Query()
	for key, values := range query {
		if key != "version" || len(values) != 1 {
			handler.writeProblem(w, r, http.StatusBadRequest, "INVALID_REQUEST", "The library request is invalid")
			return
		}
	}
	detail, err := handler.libraryCatalog.GetLibraryItem(r.Context(), teamActor(r), pack.Kind(r.PathValue("kind")), r.PathValue("name"), query.Get("version"))
	if err != nil {
		handler.libraryFailure(w, r, err)
		return
	}
	nonce, err := handler.randomHex(16)
	if err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library page could not be rendered", err)
		return
	}
	page := newLibraryItemPage(detail)
	page.Nonce = nonce
	handler.renderLibraryPage(w, r, libraryItemTemplate, http.StatusOK, nonce, page)
}

func (handler *Handler) libraryFailure(w http.ResponseWriter, r *http.Request, err error) {
	switch {
	case errors.Is(err, org.ErrForbidden):
		handler.writeProblem(w, r, http.StatusForbidden, "ADMIN_REQUIRED", "Administration rights are required")
	case errors.Is(err, store.ErrNotFound):
		handler.writeProblem(w, r, http.StatusNotFound, "NOT_FOUND", "The requested library item is unavailable")
	case errors.Is(err, library.ErrInvalid):
		handler.writeProblem(w, r, http.StatusBadRequest, "INVALID_REQUEST", "The library request is invalid")
	default:
		handler.writeProblem(w, r, http.StatusInternalServerError, "LIBRARY_FAILED", "The content library could not be read", err)
	}
}

func (handler *Handler) renderLibraryPage(w http.ResponseWriter, r *http.Request, page *template.Template, status int, nonce string, data any) {
	var body bytes.Buffer
	if err := page.Execute(&body, data); err != nil {
		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The library page could not be rendered", err)
		return
	}
	handler.writeHTMLPage(w, nonce, status, &body)
}

type libraryOption struct {
	Value, Label string
	Selected     bool
}

type libraryLink struct{ Label, Href string }

type libraryRow struct {
	Name, Href, KindLabel, Version, Category, CategoryHref, Summary string
	Tags                                                           []libraryLink
	Tools                                                          []string
}

type libraryListPage struct {
	Nonce, Query, FilterError      string
	Kinds, Categories, Tags, Tools []libraryOption
	Rows                           []libraryRow
	Total, Page, Pages             int
	PrevHref, NextHref, FirstHref  string
}

type libraryVersionLink struct {
	Label, Href string
	Current     bool
}

type libraryItemPage struct {
	Nonce, KindLabel, CategoryHref, PreviewNote string
	Item                                        library.Item
	Newest, ShowSource                          bool
	Tags                                        []libraryLink
	Tools                                       []string
	Versions                                    []libraryVersionLink
	Example, Preview                            preview.Document
}

func newLibraryListPage(facets library.Facets, filter library.Filter) libraryListPage {
	page := libraryListPage{Page: 1}
	for _, kind := range facets.Kinds {
		page.Kinds = append(page.Kinds, libraryOption{Value: string(kind), Label: kind.Label(), Selected: kind == filter.Kind})
	}
	for _, category := range facets.Categories {
		page.Categories = append(page.Categories, libraryOption{Value: category, Label: category, Selected: category == filter.Category})
	}
	for _, tag := range facets.Tags {
		page.Tags = append(page.Tags, libraryOption{Value: tag, Label: tag, Selected: tag == filter.Tag})
	}
	for _, tool := range facets.Tools {
		page.Tools = append(page.Tools, libraryOption{Value: string(tool), Label: tool.Label(), Selected: tool == filter.Tool})
	}
	return page
}

func libraryRowFor(entry library.Entry) libraryRow {
	row := libraryRow{Name: entry.Name, Href: libraryItemHref(entry.Kind, entry.Name, ""), KindLabel: entry.Kind.Label(),
		Version: entry.Version, Category: entry.Category, CategoryHref: libraryFilterHref("category", entry.Category),
		Summary: librarySummary(entry.Description)}
	for _, tag := range entry.Tags {
		row.Tags = append(row.Tags, libraryLink{Label: tag, Href: libraryFilterHref("tag", tag)})
	}
	for _, tool := range entry.Tools {
		row.Tools = append(row.Tools, tool.Label())
	}
	return row
}

func newLibraryItemPage(detail library.Detail) libraryItemPage {
	item := detail.Item
	page := libraryItemPage{Item: item, KindLabel: item.Kind.Label(), CategoryHref: libraryFilterHref("category", item.Category),
		Newest: len(detail.Versions) > 0 && detail.Versions[0] == item.Version, Example: preview.Markdown(item.Example)}
	if verbatimKind(item.Kind) {
		page.Preview, page.PreviewNote = preview.Verbatim(item.Body), "Shown exactly as the file the AI tools receive."
	} else {
		page.Preview, page.PreviewNote = preview.Markdown(item.Body), "Rendered from Markdown. Links, images and HTML show as plain text and never load."
		page.ShowSource = true
	}
	for _, tag := range item.Tags {
		page.Tags = append(page.Tags, libraryLink{Label: tag, Href: libraryFilterHref("tag", tag)})
	}
	for _, tool := range item.Tools {
		page.Tools = append(page.Tools, tool.Label())
	}
	for _, version := range detail.Versions {
		page.Versions = append(page.Versions, libraryVersionLink{Label: version, Href: libraryItemHref(item.Kind, item.Name, version), Current: version == item.Version})
	}
	return page
}

// verbatimKind reports kinds whose body is a configuration file. Every other
// kind, including kinds added later, previews as Markdown.
func verbatimKind(kind pack.Kind) bool { return kind == pack.KindConfig || kind == pack.KindMCPTemplate }

func libraryItemHref(kind pack.Kind, name, version string) string {
	href := "/admin/library/" + url.PathEscape(string(kind)) + "/" + url.PathEscape(name)
	if version != "" {
		href += "?version=" + url.QueryEscape(version)
	}
	return href
}

func libraryFilterHref(key, value string) string {
	return "/admin/library?" + url.Values{key: {value}}.Encode()
}

func libraryPageHref(query url.Values, number int) string {
	next := url.Values{}
	for _, key := range libraryFilterKeys {
		if value := query.Get(key); value != "" {
			next.Set(key, value)
		}
	}
	if number > 1 {
		next.Set("page", strconv.Itoa(number))
	}
	if len(next) == 0 {
		return "/admin/library"
	}
	return "/admin/library?" + next.Encode()
}

func librarySummary(description string) string {
	const limit = 160
	if utf8.RuneCountInString(description) <= limit {
		return description
	}
	return strings.TrimSpace(string([]rune(description)[:limit])) + "…"
}

const libraryCSS = `h1{font-size:2rem;margin:.5rem 0}.eyebrow{color:#70d6c7;font-weight:700;letter-spacing:.08em;text-transform:uppercase;font-size:.8rem;margin:0}.filters{display:flex;flex-wrap:wrap;gap:1rem;align-items:end;padding:1.25rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem;margin:1.5rem 0}.filters div{display:grid;gap:.35rem}.filters label{margin:0}.filters input[type=search]{min-width:16rem}.table-wrap{overflow-x:auto}.chip{display:inline-block;margin:0 .25rem .25rem 0;padding:.1rem .45rem;border:1px solid #2b4058;border-radius:.4rem;font-size:.85rem;text-decoration:none}.error{padding:1rem;border:1px solid #f5c26b;border-radius:.6rem;color:#f5c26b}.empty{padding:1rem 0}.visually-hidden{position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap}dl.facts{display:grid;grid-template-columns:10rem 1fr;gap:.6rem}dl.facts dt{color:#9db0c7}dl.facts dd{margin:0}ul.tools{margin:0;padding-left:1.1rem}.preview{overflow-wrap:anywhere}.preview h3,.preview h4,.preview h5,.preview h6{margin:1rem 0 .5rem}.preview blockquote{margin:.5rem 0;padding-left:1rem;border-left:3px solid #2b4058;color:#9db0c7}.preview code{font:.9em ui-monospace,SFMono-Regular,Menlo,monospace}details summary{cursor:pointer;margin:.75rem 0}a:focus-visible,button:focus-visible,input:focus-visible,select:focus-visible,summary:focus-visible{outline:3px solid #fff;outline-offset:3px}`

var libraryListTemplate = template.Must(template.New("library").Parse(`<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Content library — Leorna</title>
<style nonce="{{.Nonce}}">` + adminBaseCSS + libraryCSS + `</style>
</head>
<body>
<main>
<p><a href="/admin">Admin workspace</a> · <a href="/admin/packs">Packs</a></p>
<h1>Content library</h1>
<p class="muted">Skills, agents, configs and MCP templates that ship with Leorna. Each row shows the item's newest version.</p>
<form method="get" action="/admin/library" class="filters" role="search" aria-label="Filter the library">
<div><label for="filter-q">Search</label><input type="search" name="q" id="filter-q" value="{{.Query}}" maxlength="100"></div>
<div><label for="filter-kind">Kind</label><select name="kind" id="filter-kind"><option value="">All kinds</option>{{range .Kinds}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></div>
<div><label for="filter-category">Category</label><select name="category" id="filter-category"><option value="">All categories</option>{{range .Categories}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></div>
<div><label for="filter-tag">Tag</label><select name="tag" id="filter-tag"><option value="">All tags</option>{{range .Tags}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></div>
<div><label for="filter-tool">Supported tool</label><select name="tool" id="filter-tool"><option value="">All tools</option>{{range .Tools}}<option value="{{.Value}}"{{if .Selected}} selected{{end}}>{{.Label}}</option>{{end}}</select></div>
<button type="submit">Apply filters</button><a href="/admin/library">Reset</a>
</form>
{{if .FilterError}}<p role="alert" class="error">{{.FilterError}}</p>
{{else if .Rows}}<p id="result-count" class="muted">{{if eq .Total 1}}1 item matches{{else}}{{.Total}} items match{{end}}</p>
<div class="table-wrap"><table id="results">
<caption class="visually-hidden">Library items</caption>
<thead><tr><th scope="col">Item</th><th scope="col">Kind</th><th scope="col">Category</th><th scope="col">Tags</th><th scope="col">Supported tools</th><th scope="col">Version</th></tr></thead>
<tbody>{{range .Rows}}<tr><td><a href="{{.Href}}">{{.Name}}</a><br><span class="muted">{{.Summary}}</span></td><td>{{.KindLabel}}</td><td><a href="{{.CategoryHref}}">{{.Category}}</a></td><td>{{range .Tags}}<a class="chip" href="{{.Href}}">{{.Label}}</a>{{end}}</td><td>{{range $i, $tool := .Tools}}{{if $i}}, {{end}}{{$tool}}{{end}}</td><td>{{.Version}}</td></tr>{{end}}</tbody>
</table></div>
{{if gt .Pages 1}}<nav aria-label="Result pages"><p>Page {{.Page}} of {{.Pages}}{{if .PrevHref}} · <a href="{{.PrevHref}}" rel="prev">Previous page</a>{{end}}{{if .NextHref}} · <a href="{{.NextHref}}" rel="next">Next page</a>{{end}}</p></nav>{{end}}
{{else if gt .Page 1}}<p class="empty">No items on page {{.Page}}. <a href="{{.FirstHref}}">Go to the first page</a></p>
{{else}}<p class="empty">No library items match these filters. <a href="/admin/library">Show every item</a></p>{{end}}
</main>
</body>
</html>`))

var libraryItemTemplate = template.Must(template.New("libraryItem").Parse(`<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{.Item.Name}} — Content library — Leorna</title>
<style nonce="{{.Nonce}}">` + adminBaseCSS + libraryCSS + `</style>
</head>
<body>
<main>
<p><a href="/admin">Admin workspace</a> · <a href="/admin/library">Content library</a></p>
<p class="eyebrow">{{.KindLabel}}</p>
<h1>{{.Item.Name}}</h1>
<dl class="facts">
<dt>Version</dt><dd>{{.Item.Version}}{{if .Newest}} (newest){{end}}</dd>
{{if gt (len .Versions) 1}}<dt>All versions</dt><dd>{{range .Versions}}{{if .Current}}<span aria-current="page">{{.Label}}</span>{{else}}<a href="{{.Href}}">{{.Label}}</a>{{end}} {{end}}</dd>{{end}}
<dt>Category</dt><dd><a href="{{.CategoryHref}}">{{.Item.Category}}</a></dd>
<dt>Tags</dt><dd>{{range .Tags}}<a class="chip" href="{{.Href}}">{{.Label}}</a>{{end}}</dd>
<dt>Supported tools</dt><dd><ul class="tools">{{range .Tools}}<li>{{.}}</li>{{end}}</ul></dd>
</dl>
<section aria-labelledby="description-title"><h2 id="description-title">Description</h2><p>{{.Item.Description}}</p></section>
<section aria-labelledby="example-title"><h2 id="example-title">Example</h2><div class="preview">{{template "blocks" .Example}}</div></section>
<section aria-labelledby="preview-title"><h2 id="preview-title">Preview</h2><p class="muted">{{.PreviewNote}}</p><div class="preview" id="preview">{{template "blocks" .Preview}}</div>{{if .ShowSource}}<details><summary>Show the file as written</summary><pre>{{.Item.Body}}</pre></details>{{end}}</section>
</main>
</body>
</html>
{{define "blocks"}}{{range .Blocks}}{{if eq .Kind "heading"}}{{if eq .Level 1}}<h3>{{template "spans" .Spans}}</h3>{{else if eq .Level 2}}<h4>{{template "spans" .Spans}}</h4>{{else if eq .Level 3}}<h5>{{template "spans" .Spans}}</h5>{{else}}<h6>{{template "spans" .Spans}}</h6>{{end}}{{else if eq .Kind "paragraph"}}<p>{{template "spans" .Spans}}</p>{{else if eq .Kind "quote"}}<blockquote><p>{{template "spans" .Spans}}</p></blockquote>{{else if eq .Kind "list"}}{{if .Ordered}}<ol>{{range .Items}}<li>{{template "spans" .}}</li>{{end}}</ol>{{else}}<ul>{{range .Items}}<li>{{template "spans" .}}</li>{{end}}</ul>{{end}}{{else if eq .Kind "code"}}{{if .Label}}<p class="muted">{{.Label}}</p>{{end}}<pre><code>{{.Text}}</code></pre>{{else if eq .Kind "rule"}}<hr>{{end}}{{end}}{{if .Truncated}}<p class="muted">Preview shortened: the file is longer than the preview shows.</p>{{end}}{{end}}
{{define "spans"}}{{range .}}{{if .Code}}<code>{{.Text}}</code>{{else if .Strong}}<strong>{{.Text}}</strong>{{else}}{{.Text}}{{end}}{{end}}{{end}}`))
```

- GREEN: `go test ./internal/web -run 'TestLibraryBrowser' -count=1 -v`, then `go test ./internal/web -count=1` (regression).
- Mutations:
  - **M10** in `libraryFilter` set `Tool: ""`: `?tool=cursor` lists everything.
  - **M12** in `libraryFacetValues` replace `FROM newest` with `FROM library_items` in the category subquery: the category choices include `security`.
- Commit: `feat(86bcm901v): browse and filter the content library in the admin console` (files: handler.go, library.go, library_test.go, cmd/control-plane/main.go).

### T5 Item page (AC2) and preview safety

**T5a, RED (5 min).** At T4's commit the item route already exists, so to see RED, write these tests **before** T4c's route lines. If they were added together, prove sensitivity with M5 and M13 instead; see the "characterization" note in §6. Append to `internal/web/library_test.go`:

```go
type fakeLibraryCatalog struct {
	facets library.Facets
	page   library.Page
	detail library.Detail
	err    error
}

func (f *fakeLibraryCatalog) ListLibrary(context.Context, store.Principal, library.Filter) (library.Page, error) {
	return f.page, f.err
}
func (f *fakeLibraryCatalog) LibraryFacets(context.Context, store.Principal) (library.Facets, error) {
	return f.facets, f.err
}
func (f *fakeLibraryCatalog) GetLibraryItem(context.Context, store.Principal, pack.Kind, string, string) (library.Detail, error) {
	return f.detail, f.err
}

func TestLibraryItemShowsDescriptionExampleVersionToolsAndPreviewWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	insertLibraryItems(t, fixture.pool, catalogFixtureItems()...)
	admin := fixture.login(t, fixture.admin, strings.Repeat("a", 43))

	t.Run("a Markdown item shows every field and a rendered preview", func(t *testing.T) {
		body := fixture.get(t, admin, "/admin/library/skill/code-review-checklist", http.StatusOK)
		for _, want := range []string{
			`<p class="eyebrow">Skill</p>`, `<h1>code-review-checklist</h1>`, `<dt>Version</dt><dd>1.0.0 (newest)</dd>`,
			`<dt>Category</dt><dd><a href="/admin/library?category=code-quality">code-quality</a></dd>`,
			`<a class="chip" href="/admin/library?tag=pull-requests">pull-requests</a>`,
			`<li>Claude Code</li>`, `<li>Codex</li>`, `<li>Cursor</li>`,
			`<h2 id="description-title">Description</h2><p>Review checklist for pull requests.</p>`,
			`<h2 id="example-title">Example</h2><div class="preview"><p>Ask for code-review-checklist.</p></div>`,
		} {
			if !strings.Contains(body, want) {
				t.Errorf("item page missing %s", want)
			}
		}
		if got := pageSection(t, body, `<div class="preview" id="preview">`, `</div>`); got != "<h3>Checklist</h3><ul><li>Scope</li></ul>" {
			t.Errorf("preview = %s", got)
		}
		if source := pageSection(t, body, "<details>", "</details>"); !strings.Contains(source, "# Checklist\n\n- Scope\n") {
			t.Errorf("source = %s", source)
		}
	})
	t.Run("the newest version is shown and older versions stay reachable", func(t *testing.T) {
		body := fixture.get(t, admin, "/admin/library/agent/security-reviewer", http.StatusOK)
		for _, want := range []string{`<dd>1.10.0 (newest)</dd>`, `<span aria-current="page">1.10.0</span>`, `<a href="/admin/library/agent/security-reviewer?version=1.9.0">1.9.0</a>`, "New body."} {
			if !strings.Contains(body, want) {
				t.Errorf("newest page missing %s", want)
			}
		}
		older := fixture.get(t, admin, "/admin/library/agent/security-reviewer?version=1.9.0", http.StatusOK)
		if !strings.Contains(older, "<dd>1.9.0</dd>") || !strings.Contains(older, "<p>Old reviewer.</p>") || !strings.Contains(older, "Old body.") || strings.Contains(older, "New body.") {
			t.Errorf("older version page wrong: %s", older)
		}
	})
	t.Run("a config file previews exactly as written", func(t *testing.T) {
		body := fixture.get(t, admin, "/admin/library/config/codex-defaults", http.StatusOK)
		if got := pageSection(t, body, `<div class="preview" id="preview">`, `</div>`); got != "<pre><code>approval_policy = &#34;on-request&#34;\n</code></pre>" {
			t.Errorf("config preview = %s", got)
		}
		if strings.Contains(body, "<details>") {
			t.Error("a config item needs no second copy of the file")
		}
	})
	t.Run("every shipped library item opens with a preview", func(t *testing.T) {
		shipped := newLibraryFixture(t)
		if _, err := shipped.repository.EnsureLibrary(context.Background()); err != nil {
			t.Fatal(err)
		}
		client := shipped.login(t, shipped.admin, strings.Repeat("e", 43))
		embedded, err := library.Embedded()
		if err != nil {
			t.Fatal(err)
		}
		for _, item := range embedded.Items {
			body := shipped.get(t, client, "/admin/library/"+string(item.Kind)+"/"+item.Name, http.StatusOK)
			if !strings.Contains(body, "<h1>"+item.Name+"</h1>") || !strings.Contains(body, `<div class="preview" id="preview">`) {
				t.Errorf("%s did not open with a preview", item.Key())
			}
		}
	})
}

func TestLibraryItemPreviewIsInert(t *testing.T) {
	handler, server, client := newAssignHandler(t, &fakeAssigner{})
	hostile := library.Item{Kind: pack.KindSkill, Name: "hostile-markup", Version: "1.0.0", Category: "testing", Tags: []string{"tests"}, Tools: []library.Tool{library.ToolClaudeCode},
		Description: "<svg onload=alert(1)>",
		Example:     "<iframe src=https://evil.example/></iframe>\n",
		Body:        "# Title <img src=x onerror=alert(1)>\n\n<script>alert(1)</script>\n\n[click](javascript:alert(1)) ![pixel](https://tracker.example/p.png)\n\n**bold <b>x</b>** and `<code>`\n"}
	handler.SetLibrary(&fakeLibraryCatalog{detail: library.Detail{Item: hostile, Versions: []string{"1.0.0"}}})
	response := request(t, client, http.MethodGet, server.URL+"/admin/library/skill/hostile-markup", "", "")
	assertStatus(t, response, http.StatusOK)
	csp := response.Header.Get("Content-Security-Policy")
	body := readBody(t, response)
	if !strings.HasPrefix(csp, "default-src 'none';") || strings.Contains(csp, "img-src") || strings.Contains(csp, "unsafe-inline") || response.Header.Get("Cache-Control") != "no-store" {
		t.Fatalf("headers: CSP %q, cache %q", csp, response.Header.Get("Cache-Control"))
	}
	for _, active := range []string{"<script", "<img", "<iframe", "<svg", "<b>", `href="javascript`, `<a href="https://`} {
		if strings.Contains(body, active) {
			t.Errorf("page contains active markup %q", active)
		}
	}
	preview := pageSection(t, body, `<div class="preview" id="preview">`, `</div>`)
	for _, want := range []string{"<h3>Title &lt;img src=x onerror=alert(1)&gt;</h3>", "<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>", "[click](javascript:alert(1))", "<strong>bold &lt;b&gt;x&lt;/b&gt;</strong>", "<code>&lt;code&gt;</code>"} {
		if !strings.Contains(preview, want) {
			t.Errorf("preview missing %q:\n%s", want, preview)
		}
	}
	if strings.Contains(preview, "href=") || strings.Contains(preview, "src=\"") {
		t.Errorf("preview has a live attribute: %s", preview)
	}
}

func TestLibraryPagesHideStoreFailures(t *testing.T) {
	handler, server, client := newAssignHandler(t, &fakeAssigner{})
	response := request(t, client, http.MethodGet, server.URL+"/admin/library", "", "")
	assertStatus(t, response, http.StatusServiceUnavailable)
	closeBody(t, response)
	handler.SetLibrary(&fakeLibraryCatalog{err: errors.New("private database detail")})
	for _, path := range []string{"/admin/library", "/admin/library/skill/code-review-checklist"} {
		response := request(t, client, http.MethodGet, server.URL+path, "", "")
		assertStatus(t, response, http.StatusInternalServerError)
		if body := readBody(t, response); strings.Contains(body, "private database detail") || response.Header.Get("X-Trace-ID") == "" {
			t.Errorf("%s leaked the cause or has no trace ID: %s", path, body)
		}
	}
}
```

- RED (if written before the item route): `go test ./internal/web -run 'TestLibraryItem|TestLibraryPagesHide' -count=1 -v`. Expected: `status = 303, want 200` / `want 503`.

**T5b, implement.** Already in `library.go` (T4c). GREEN with the same command.
- Mutations:
  - **M5** add `.Funcs(template.FuncMap{"raw": func(s string) template.HTML { return template.HTML(s) }})` and change the plain `{{.Text}}` in `spans` to `{{raw .Text}}`: the inert test fails on `<script`. Restore it; it must never be committed.
  - **M13** `verbatimKind` returns `false`: the config preview test fails, because the body becomes a `<p>`.
- Commit: `feat(86bcm901v): show a library item with its versions and a rendered preview`.

### T6 AC3 timing test (`internal/web/library_timing_test.go`)

This test is expected to pass on its first run (a "characterization" test, not a new RED). Its sensitivity is proven by mutations M8 and M11.

```go
package web

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

func TestLibraryFilteringStaysUnder300msWith250ItemsWithPostgres(t *testing.T) {
	fixture := newLibraryFixture(t)
	kinds := []pack.Kind{pack.KindSkill, pack.KindAgent, pack.KindConfig, pack.KindMCPTemplate}
	categories := []string{"code-quality", "testing", "workflow", "operations", "integrations", "configuration", "security", "documentation"}
	toolSets := [][]library.Tool{{library.ToolClaudeCode}, {library.ToolCodex}, {library.ToolCursor}, {library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}}
	body := strings.Repeat("Follow the team checklist and explain each step.\n", 80) // about 4 KiB, like a real skill
	items := make([]library.Item, 0, 300)
	for i := range 250 {
		item := library.Item{Kind: kinds[i%4], Name: fmt.Sprintf("generated-item-%03d", i), Version: "1.0.0",
			Category: categories[i%8], Tags: []string{fmt.Sprintf("tag-%02d", i%40), "generated"}, Tools: toolSets[i%4],
			Description: fmt.Sprintf("Generated catalog entry %03d for %s work.", i, categories[i%8]), Example: "Ask for it.\n", Body: body}
		items = append(items, item)
		if i%5 == 0 { // 50 items also keep an older version the list must skip
			older := item
			older.Version = "0.9.0"
			items = append(items, older)
		}
	}
	insertLibraryItems(t, fixture.pool, items...)
	token := strings.Repeat("a", 43)
	fixture.login(t, fixture.admin, token)
	routes := fixture.handler.Routes()

	const budget = 300 * time.Millisecond
	const timedRuns = 20
	for _, tc := range []struct {
		name, query string
		total, rows int
	}{
		{"everything", "", 250, 50},
		{"kind", "?kind=agent", 63, 50},
		{"category", "?category=code-quality", 32, 32},
		{"tag", "?tag=tag-07", 7, 7},
		{"tool", "?tool=codex", 125, 50},
		{"search", "?q=entry+042", 1, 1},
		{"every filter", "?kind=agent&tool=codex&category=testing&tag=generated&q=generated", 32, 32},
		{"third page", "?page=3", 250, 50},
		{"last page", "?tool=codex&page=3", 125, 25},
		{"no match", "?q=nothing-matches-this", 0, 0},
	} {
		t.Run(tc.name, func(t *testing.T) {
			durations := make([]time.Duration, 0, timedRuns)
			for run := 0; run <= timedRuns; run++ {
				request := httptest.NewRequest(http.MethodGet, "/admin/library"+tc.query, nil)
				request.AddCookie(&http.Cookie{Name: sessionCookieName, Value: token})
				recorder := httptest.NewRecorder()
				started := time.Now()
				routes.ServeHTTP(recorder, request) // the full server path: session, admin check, queries, render
				elapsed := time.Since(started)
				if recorder.Code != http.StatusOK {
					t.Fatalf("status = %d: %s", recorder.Code, recorder.Body.String())
				}
				if run == 0 { // warm-up: check what was served, do not time it
					page := recorder.Body.String()
					if rows := strings.Count(page, `<td><a href="/admin/library/`); rows != tc.rows {
						t.Fatalf("listed %d rows, want %d", rows, tc.rows)
					}
					if tc.total > 0 && !strings.Contains(page, fmt.Sprintf(`<p id="result-count" class="muted">%d `, tc.total)) {
						t.Fatalf("page does not report %d matches", tc.total)
					}
					if size := recorder.Body.Len(); size > 256<<10 {
						t.Fatalf("page is %d bytes, budget 256 KiB", size)
					}
					continue
				}
				durations = append(durations, elapsed)
			}
			slices.Sort(durations)
			p95 := durations[(len(durations)*95+99)/100-1]
			t.Logf("server time over %d requests: p50=%v p95=%v max=%v (budget %v)", timedRuns, durations[len(durations)/2], p95, durations[len(durations)-1], budget)
			if slowest := durations[len(durations)-1]; slowest >= budget {
				t.Fatalf("slowest request took %v, budget %v", slowest, budget)
			}
		})
	}
}
```

Note the search case: `?q=entry+042` matches only item 42, but `"1 item matches"` still begins `>1 `, so the count prefix check holds.

- GREEN: `source "$SCRATCH/test-env.sh" && go test ./internal/web -run '^TestLibraryFilteringStaysUnder300msWith250ItemsWithPostgres$' -count=1 -race -v`
- Mutations:
  - **M8** delete `DISTINCT ON (kind, name)`: `everything` fails with `page does not report 250 matches`.
  - **M11** add `time.Sleep(300 * time.Millisecond)` as the first line of `libraryView`: every case fails with `slowest request took 3xxms, budget 300ms` (about 60 s run).
- **Do not relax the budget.** If it flakes, investigate and report.
- Commit: `feat(86bcm901v): prove library filtering stays under 300 ms with 250 items`.

### T7 Docs and inventory (about 5 min)

1. `internal/web/README.md`: append "## Library catalog browser". Write only claims the tests prove. Cover:
   - the routes;
   - newest-version semantics;
   - choices built from data, so kinds added later need no change;
   - the AND and "any" rules;
   - search fields and bounds, with `%` and `_` literal;
   - 400 for a bad filter;
   - the item page fields and version links;
   - "every kind except configs and MCP templates previews as Markdown, so kinds added later (such as `prompt`) need no change";
   - why the preview is inert, and its bounds;
   - admin only, plus the store check, with library rows shared product content;
   - no API or OpenAPI change;
   - a Verification paragraph naming every test in §4;
   - "Demo: run the tests with `-v`; the local demo used the existing `LEORNA_DEV_MODE` sign-in against a throwaway database."
2. `internal/library/README.md`: insert immediately **before** `## Loading`:
   ```
   ## Browsing in the admin console

   Administrators browse, filter and preview the stored library at `/admin/library`
   (story 86bcm901v); see [the catalog browser](../web/README.md#library-catalog-browser).
   ```
3. `README.md` role table: add after the `/admin/setup` row: ``| `/admin/library` and library item pages | 403 | Allowed (shared product content) |``
4. `delivery/stories.json`: insert after the closing `},` of `"86bcm9018"` (not at the end):
   ```json
     "86bcm901v": {
       "name": "Library catalog browser",
       "prs": {
         "LeornaAI/leorna-control-plane": [
           82
         ]
       }
     },
   ```
5. Commit: `docs(86bcm901v): document the catalog browser and register the story`.

### T8 Gates (§5) on the final head

Write `$EVID/gates-<sha7>.txt` and `verbose-<sha7>.log`. Open the log and read each `EXIT=` line before citing it.

### T9 Demo and evidence (about 30 min, §4 and §5)

1. Build `$SCRATCH/control-plane-head` and start it on the demo DB.
2. Capture `ac1-library-filters.png` and `ac2-item-detail-preview.png`.
3. Capture the AC3 terminal: `ac3-filter-timing-test.png` plus `.log`.
4. Write `INVENTORY.md` (AC → test → result → artifact, plus NOT VERIFIED).
5. Check every image visually for privacy.
6. Stop the server. Keep both owned DBs and list them for cleanup.

### T10 Stop

Report `ready-for-review` with:
- `git diff --stat origin/main..HEAD`;
- the `.github`, `contracts`, `migrations` and `go.mod` file lists (all empty);
- the gate exit codes;
- the evidence paths.

No push, no PR, no ClickUp.

## 4. AC → test → evidence

| AC | Tests | Command | Screenshot | Log |
|---|---|---|---|---|
| AC1 filter by kind, category, tag, tool and text | `TestLibraryBrowserFiltersByKindCategoryTagToolAndTextWithPostgres`; failure path `TestLibraryBrowserRejectsBadFiltersAndNonAdminsWithPostgres`; units `TestCatalogFilterAcceptsOnlyValuesAnItemCanHave`, `TestSearchTermsSplitsWordsWithinBounds`; store `TestLibraryCatalogWithPostgres` | `go test ./internal/web ./internal/library ./internal/store/postgres -run 'TestLibraryBrowser\|TestCatalogFilter\|TestSearchTerms\|TestLibraryCatalog' -count=1 -v` | `ac1-library-filters.png`: real local console, `/admin/library?q=review&tool=codex` (2 rows, search and tool selected) | `ac1-library-tests.log` |
| AC2 description, example, version, tools, rendered preview | `TestLibraryItemShowsDescriptionExampleVersionToolsAndPreviewWithPostgres`, `TestLibraryItemPreviewIsInert`, `TestLibraryPagesHideStoreFailures`, `TestMarkdown*`, `TestVerbatimKeepsTheFileAsWritten`, `TestToolLabelsNameTheProducts` | `go test ./internal/web ./internal/library/... -run 'TestLibraryItem\|TestLibraryPagesHide\|TestMarkdown\|TestVerbatim\|TestToolLabels' -count=1 -v` | `ac2-item-detail-preview.png`: `/admin/library/agent/code-reviewer` (frontmatter block, numbered list, all fields), window 1366×2000 | `ac2-library-item-tests.log` |
| AC3 under 300 ms server time with 200+ items | `TestLibraryFilteringStaysUnder300msWith250ItemsWithPostgres` | `go test ./internal/web -run '^TestLibraryFilteringStaysUnder300msWith250ItemsWithPostgres$' -count=1 -race -v` | `ac3-filter-timing-test.png`: real Terminal window capture of that run (PASS plus p50/p95/max lines) | `ac3-filter-timing-test.log` (ends `EXIT=0`) |
| Before state | none | curl on the base binary | `before-admin-nav.png` (cropped, optional) | `before-library-route.txt` |
| Gates | `make check`, `test-module-add`, verbose Postgres run | §5 | none | `gates-<sha7>.txt`, `verbose-<sha7>.log`, `mutations-<sha7>.txt` |

Upload set: exactly one screenshot per AC (the three `ac*` files). The before shot is optional. Screenshots must show no URL bar, `/dev/login`, email, tenant ID or token. Headless Chrome has no URL bar, and the library pages show no email or tenant. Retake any capture whose output changes after a fix.

## 5. Gates and local demo on macOS (exact)

**Gate script.** The builder writes it to `$SCRATCH/run-gates.sh` (scratch, not the repo) and runs `LINT=<verified abs path> bash "$SCRATCH/run-gates.sh"`:

```bash
#!/opt/homebrew/bin/bash
set -uo pipefail
WT="$HOME/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v2"
SCRATCH="$HOME/.hermes/cache/scratch/86bcm901v-catalog-browser-v2"
EVID="$HOME/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2"
: "${LINT:?set LINT to the verified golangci-lint 2.14.0 absolute path}"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:$PATH"
source "$SCRATCH/test-env.sh"
cd "$WT"
SHA=$(git rev-parse --short=7 HEAD)
OUT="$EVID/gates-$SHA.txt"; [ -e "$OUT" ] && OUT="$EVID/gates-$SHA-$(date -u +%H%M%S).txt"
{
  echo "head=$(git rev-parse HEAD) base=$(git merge-base HEAD origin/main) utc=$(date -u +%FT%TZ)"
  echo "dirty=[$(git status --porcelain)]"
  echo "go=$(go version) | lint=$("$LINT" --version | head -1) | realpath=$(command -v realpath) | bash=$BASH_VERSION | gitleaks=$(gitleaks version)"
  echo "== make check"; GOLANGCI_LINT="$LINT" make check; echo "make-check EXIT=$?"
  echo "== test-module-add"; bash ./scripts/test-module-add.sh; echo "test-module-add EXIT=$?"
  echo "== story-shippable unit tests"; python3 -m unittest discover -s scripts -p 'test_story_shippable.py'; echo "story-shippable-tests EXIT=$?"
  echo "== stories.json parses"; python3 -m json.tool delivery/stories.json >/dev/null; echo "stories-json EXIT=$?"
  echo "== Postgres tests really ran (separate -v run)"
  go test -count=1 -v ./internal/library/... ./internal/store/postgres ./internal/web \
    -run 'TestCatalogFilter|TestSearchTerms|TestToolLabels|TestMarkdown|TestVerbatim|TestLibrary' > "$EVID/verbose-$SHA.log" 2>&1
  echo "verbose-tests EXIT=$?"
  grep -E -- '--- (PASS|FAIL|SKIP): Test' "$EVID/verbose-$SHA.log"
  echo "story tests skipped: $(grep -c -E -- '--- SKIP: Test(Library|Catalog)' "$EVID/verbose-$SHA.log")  (must be 0)"
  echo "== boundaries (each must be 0)"
  for p in .github contracts packages/contracts internal/store/postgres/migrations go.mod go.sum go.work; do echo "$p: $(git diff --name-only origin/main...HEAD -- "$p" | wc -l | tr -d ' ')"; done
  echo "trusted-html-types: $(git diff origin/main...HEAD -- '*.go' | grep -c -E '^\+.*template\.(HTML|JS|JSStr|URL|HTMLAttr|CSS|Srcset)\(')"
  echo "authors:"; git log --format='%an <%ae>' origin/main..HEAD | sort -u
} 2>&1 | tee "$OUT"
```

**Notes on the gate run:**
- If `make check` fails only in `secrets`: `gitleaks git` scans every local branch, including sibling stories. Keep the failing log and run `gitleaks git --redact --no-banner --log-opts="origin/main..HEAD"` (must exit 0) as proof scoped to this branch. Report it as outside the branch; do not fix it.
- If lint fails with "export data version … greater than maximum", that comes from the tool. Rebind `LINT` (T0.3) and rerun the unchanged gate.
- ClickHouse tests skip locally because `LEORNA_TEST_CLICKHOUSE_URL` is not set; they are not affected.
- Never run `make check` in the main checkout: `verify-workspace.sh` there picks up the `go.mod` files under `.claude/worktrees/*`.

**Local demo for screenshots.** This uses only main's existing gated dev mode. It binds 127.0.0.1, uses a throwaway DB and no cloud variables, and nothing leaves the Mac.

```bash
cd "$WT" && go build -o "$SCRATCH/control-plane-head" ./cmd/control-plane    # base binary in T0 uses control-plane-base
sed 's/127.0.0.1:8080/127.0.0.1:18901/' config/manifest.example.json > "$SCRATCH/manifest.json"
KEY=$(openssl rand -base64 32)
env -i HOME="$HOME" PATH="$PATH" \
  LEORNA_MANIFEST_PATH="$SCRATCH/manifest.json" \
  LEORNA_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_901v2_demo_test?sslmode=disable' \
  LEORNA_DEV_MODE=1 LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid LEORNA_SECRET_ENCRYPTION_KEY="$KEY" \
  "$SCRATCH/control-plane-head" > "$SCRATCH/demo-server.log" 2>&1 &
echo $! > "$SCRATCH/demo-server.pid"
curl -fsS --retry 30 --retry-connrefused --retry-delay 1 http://127.0.0.1:18901/readyz
```

`env -i` keeps your shell's `LEORNA_*`/`SCW_*` variables out. The placeholder public URL hides the client card.

Headless Chrome with a fresh scratch profile (never Justin's profile):

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { "$CHROME" --headless=new --user-data-dir="$SCRATCH/chrome-profile" --no-first-run --no-default-browser-check \
  --disable-extensions --hide-scrollbars --window-size="$2" --screenshot="$1" \
  "http://localhost:18901/dev/login?next=$(python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1],safe=""))' "$3")"; }
shot "$EVID/ac1-library-filters.png"     1366,1000 "/admin/library?q=review&tool=codex"
shot "$EVID/ac2-item-detail-preview.png" 1366,2000 "/admin/library/agent/code-reviewer"
kill "$(cat "$SCRATCH/demo-server.pid")"
```

Check every image visually. If it shows a redirect loop or a sign-in error, Chrome refused the `__Host-` Secure cookie on `http://localhost`. In that case retry with `127.0.0.1`. If that also fails, **stop and report** (Q5-B is the labelled fallback).

**AC3 terminal capture:**

```bash
osascript -e 'tell application "Terminal" to activate' \
  -e "tell application \"Terminal\" to do script \"cd '$WT' && source '$SCRATCH/test-env.sh' && go test ./internal/web -run '^TestLibraryFilteringStaysUnder300msWith250ItemsWithPostgres\$' -count=1 -race -v 2>&1 | tee '$EVID/ac3-filter-timing-test.log'; echo EXIT=\${pipestatus[1]} | tee -a '$EVID/ac3-filter-timing-test.log'\"" \
  -e 'tell application "Terminal" to set bounds of front window to {40, 40, 1440, 940}'
```

Wait with a bounded until-loop on `grep -q '^EXIT=' "$EVID/ac3-filter-timing-test.log"` (use the Monitor tool if foreground `sleep` is blocked). Then run `screencapture -x -o -l "$(osascript -e 'tell application "Terminal" to id of front window')" "$EVID/ac3-filter-timing-test.png"`. If the capture comes out blank (no Screen Recording permission), render the real log through headless Chrome `file://`, label it "log capture, not terminal", and report.

## 6. Skills

Everyone loads `leorna` first (its Step 1 context load, blind rule kept), then `engineering-best-practices`. The Hermes frontend skills are files under `~/.hermes/skills/codex-imports/<name>/SKILL.md`, read with Read. Do not add a JS framework or build tool.

| Role | Skills |
|---|---|
| Builder | `test-driven-development`, `mutation-testing-discipline`, `security-best-practices` (read `references/golang-general-backend-security.md`: GO-XSS-001, GO-INJECT-001, GO-REDIRECT-001), `multi-tenant-auth-management`, **`api-contract-drift-guard` (loop)**, **`backend-data-migrations` (loop)**, `git-commit-rules`; files: `frontend-testing-workflow`, **`frontend-accessibility-audit` (loop)**, **`frontend-performance-budget` (loop)** |
| Reviewers 1 and 2 | `requesting-code-review`, `code-review-practice` (report only), the same specialists and files as the builder |
| Fixer | `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, the specialists; **`frontend-ui-repair` (loop)** only if a UI defect is being fixed |
| Verifier | `mutation-testing-discipline` (re-run M1–M13), loop skills `api-contract-drift-guard`, `backend-data-migrations`, `frontend-accessibility-audit`, `frontend-performance-budget` (plus `frontend-ui-repair` if a UI repair happened) |
| Finisher | `receiving-code-review`, `git-commit-rules`, `test-driven-development` |

**Loop skills** (those with `## Mandatory Validation and Agent Defect Loop`), verified with grep:
- `~/.claude/skills/api-contract-drift-guard`
- `~/.claude/skills/backend-data-migrations`
- `~/.hermes/skills/codex-imports/frontend-accessibility-audit`
- `~/.hermes/skills/codex-imports/frontend-performance-budget`
- `~/.hermes/skills/codex-imports/frontend-ui-repair`

**How the verifier runs each loop skill here:**
- **Contract drift:** `make contracts-check` passes, the `contracts`/`packages/contracts` diff is empty, the client is untouched. Classification: no change.
- **Data:** the migrations diff is empty, the existing `TestMigrationRoundTrip` passes, and the queries are proven on real Postgres 18.6, the same image as CI.
- **Accessibility:** no `eslint` or `axe` exists (no JS toolchain, by standing rule), so record **NOT RUN** with that reason. Substitutes: the tests assert `<label for>` on every control, `lang="en"`, heading order, `role="alert"`, `aria-current` and `scope="col"`. A keyboard-only walk by a person stays **NOT VERIFIED** unless done.
- **Performance:** Lighthouse is N/A for a server-rendered page with no JS. The budget is the AC3 test: every request under 300 ms and each page at most 256 KiB.

## 7. Questions (answer by letter; ⭐ = recommended, and the plan builds it)

```json
[
 {"q":"Q1. What should the 'rendered preview' be, and how is it kept safe?",
  "options":["A ⭐ A small in-repo Markdown renderer for a fixed subset: headings, paragraphs, lists, quotes, code, bold, inline code. Configs and MCP templates show the file as code. Raw HTML, links and images stay plain text. html/template escapes everything, size and blocks are capped, no new dependency.",
             "B Full Markdown with the goldmark library (MIT, pinned), raw HTML off and links/images turned into text. Closer to GitHub rendering, but a new dependency, an extra sanitising step, and CPU limits on hostile input are harder to prove.",
             "C No rendering: show the file as plain monospace text, like today's pack item page.",
             "D Show what Sync would write for each tool (Claude Code, Codex, Cursor). Needs 901u-v2's internal/toolrender merged first; a good follow-up."],
  "recommended":"A"},
 {"q":"Q2. Which versions are listed?",
  "options":["A ⭐ The list shows each item's newest version (1.10.0 counts as newer than 1.9.0); the item page links every stored version.",
             "B Every stored version is its own row in the list.",
             "C Newest only; older versions cannot be opened."],
  "recommended":"A"},
 {"q":"Q3. Where do the category, tag and tool choices come from? (The values themselves come from each item's item.json.)",
  "options":["A ⭐ From the stored items (newest versions), so only real values appear and a new kind such as 'prompt' shows up with no code change.",
             "B Fixed lists in code (all kinds and all three tools), with free-text category and tag boxes."],
  "recommended":"A"},
 {"q":"Q4. How are 200+ items seeded for AC3, and how is 'server time' measured?",
  "options":["A ⭐ A real-Postgres test seeds 250 items (plus 50 older versions), times the full request inside the server (sign-in check, admin check, queries, page render) 20 times for each of 10 filter cases, and fails if any request takes 300 ms or more. Runs in make check and CI.",
             "B Same seeding, but as a Go benchmark: evidence only, not a gate.",
             "C Seed the local demo with 250 items and time real requests with curl: manual evidence only."],
  "recommended":"A"},
 {"q":"Q5. How are the AC1/AC2 screenshots taken?",
  "options":["A ⭐ Run the real control plane locally with the existing dev sign-in (LEORNA_DEV_MODE, already on main), on 127.0.0.1 with a throwaway _test database, and capture pages with headless Chrome using a scratch profile.",
             "B Capture the HTML the tests render, opened as local files, labelled as test renders rather than live pages."],
  "recommended":"A"}
]
```

## 8. Risks, touches, overlaps, forecast

**Risks:**
1. **Timing flake** on CI or under local load: `-race` plus parallel packages plus other sessions sharing `leorna-test-pg`. Expected per-request time is about 5–30 ms, so roughly 10× headroom. Never relax the budget; investigate instead.
2. **Chrome refuses the `__Host-` Secure cookies** on `http://localhost` or `127.0.0.1`. The fallback is Q5-B, and the builder stops and asks.
3. **Screen Recording permission** may block `screencapture -l`; fall back to a labelled log capture.
4. **Merge conflicts** in `delivery/stories.json` and `internal/library/README.md`. Mitigated by inserting mid-file and before `## Loading`. Re-run `git merge-tree` and the gates after the first sibling merges.
5. **Authors may be surprised by the Markdown subset** (tables show as text). It is documented, and Q1-B or D can follow later.
6. **`gitleaks` scans every local branch**; a sibling branch can make `make secrets` fail. Handle as in §5.
7. **Stale lint binary.** Rebind it as in T0.3.
8. **A stale `origin/main`** while SSH is locked. Use the HTTPS fetch in T0.

**Touches.**
- New: `internal/library/catalog.go` + `_test`, `internal/library/preview/preview.go` + `_test`, `internal/store/postgres/library_catalog.go` + `_test`, `internal/web/library.go`, `library_test.go`, `library_timing_test.go`.
- Modified: `internal/web/handler.go` (1 import, 1 field, 2 routes, 1 nav link), `cmd/control-plane/main.go` (1 line), `internal/web/README.md`, `internal/library/README.md`, `README.md` (1 row), `delivery/stories.json`.
- Not touched: `.github/`, contracts, migrations, `go.mod`/`go.sum`.

**Overlaps:**
- **#85 prompt kind** (`feat/86bcm9016-prompt-kind` @ 5a3b5c6, open). It touches `pack.go`, migration 21, library content 0.3.0 (adds a prompt item), the library README (lines 1–20 and about 66), `stories.json` (inserted before 902n), `packs_test.go`, the contracts and the root README (line 309).
  - No file overlaps except the two docs and inventory files, at non-adjacent positions.
  - Behaviour: after #85, `prompt` passes `Valid()`, appears in the choices from data, and previews as Markdown with no change here.
  - Our tests never hard-code the embedded item count; "every shipped library item opens" will then cover the prompt item.
- **901u-v2** (`feat/86bcm901u-quality-gate-v2` @ 0a50ddd, in progress). It adds `internal/toolrender`, `internal/library/qualitygate`, `cmd/library-check` and `ci.yml`, and appends to `internal/library/README.md` and README line 95. No overlapping code.
- **Merge order (recommended):** #85 first, then this story (rerun gates and the AC tests on the combined head so the prompt kind is covered), with 901u-v2 before or after. The second of 901v-v2/901u-v2 to merge reruns `merge-tree` and the gates.
- Follow-up after 901u-v2: per-tool preview (Q1-D).

**Forecast.**
- Builder: about 150–210 min (code and tests about 90, 2–3 gate runs at 8–10 min each, demo and evidence about 30, docs about 15).
- Full pipeline: about 6–9 h wall clock.
- Confidence: medium (about 55%). The main unknowns are the Chrome cookie behaviour and CI timing headroom.

## 9. found_else (not folded in)

- **Low, dev mode only, not executed.** `/dev/login?next=` accepts `/\evil.example`. The check `strings.HasPrefix(next,"/") && !strings.HasPrefix(next,"//")` is in `internal/web/handler.go` `devLoginHandler`. Browsers read `\` as `/`, so the redirect becomes `//evil.example`: an open redirect (GO-REDIRECT-001).
- **Low, test hazard.** `readBody` (`internal/web/handler_test.go:308`) silently truncates at 64 KiB, so a "must not contain" assertion on a bigger page can pass falsely.
- **Info.** Unknown `/admin/...` paths get a 303 to `/admin` (the `GET /` catch-all in `Routes`) instead of a 404.
- **Info.** Items dropped from a later library release stay browsable because rows are append-only and there is no retired flag (`internal/store/postgres/library.go`). This matters for 901w and 901z.
- **Info.** Migration 20's CHECKs don't enforce slug format for category and tags; only the loader does.
- **Environment.** The SSH fetch fails ("Permission denied (publickey)") and local `main` is 4 commits behind. Use the HTTPS gh fetch.
- **Memory note stale (low).** `leorna-control-plane-workflow.md` says "No browser demo exists… needs verify-full TLS Postgres, an HTTPS public URL and Google OAuth". Main's `LEORNA_DEV_MODE` relaxes DB TLS and Google OAuth (`internal/config/runtime.go:61-86`), the server is plain HTTP, and #86's PR text reports a "local isolated demo".

## 10. Skill lessons

| Skill | Lesson | Evidence |
|---|---|---|
| `memory` (leorna-control-plane-workflow.md) | A local admin-console demo is possible on main with dev mode: `sslmode=disable`, any `https://` public URL (the placeholder hides the client card), a base64 32-byte key, a manifest on a free port, and `env -i`. A headless Chrome `--screenshot` of `/dev/login?next=<encoded>` lands on the target page. Untested: Chrome may still refuse the `__Host-` cookie on http. | `runtime.go:61-86`, `main.go`, `handler.go` devLoginHandler |
| `leorna` (blind rule) | To skip blind-rule paragraphs, run `grep -v`/`grep -c` directly; never `grep -n` the matching lines, because that prints the content being avoided. | This session's first grep showed old-attempt status fragments |
| `implementation-planning` / `leorna` | In a shared JSON registry (`delivery/stories.json`), insert the new key at its sorted neighbour rather than appending; appending makes parallel stories collide at end of file. | #85 inserted mid-file before 902n |
| `test-driven-development` | For new Go APIs, add a compiling stub (permissive zero results) before the tests, so RED is an assertion failure, not an `undefined:` compile error. | T1a/T2a/T3a pattern |
| `frontend-accessibility-audit`, `frontend-performance-budget` | Their only commands are npm/axe/Lighthouse. For a server-rendered Go console with no JS toolchain, the loop needs named substitutes (HTML structure assertions; a server-time test plus a page-size budget), and the unrun tools recorded as NOT RUN with the reason. | §6 mapping |
| `leorna` (control-plane tests) | `internal/web` `readBody` caps at 64 KiB; for large pages assert on `httptest.Recorder` output or a bigger reader. | `handler_test.go:308` |

## 11. Skills actually loaded

- **Skill tool:** `leorna`, `engineering-best-practices`, `implementation-planning`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`.
- **Files read:** `~/.hermes/skills/codex-imports/{frontend-testing-workflow,frontend-accessibility-audit,frontend-performance-budget,frontend-ui-repair}/SKILL.md`; `security-best-practices/references/golang-general-backend-security.md` (relevant sections).
- **Memory notes:** `MEMORY.md`, `leorna-workflow.md` (catalog and 901v lines filtered out), `leorna-control-plane-workflow.md`, `consistency-over-local-fixes.md`, `prefer-small-verified-scope.md`, `infer-and-list-assumptions.md`, `no-auth-bypass-from-chat-guidance.md`, `no-ci-changes.md`, `clickup-evidence.md`, `stop-and-show-diff.md`.
- **ClickUp, read only:** 86bcm901v, 86bcm9018, 86bcm901w, 86bcm901z, 86bcm927y.
- Plan mode was lifted partway through this session. I still made no edits, wrote no files and ran no builds or tests.

### Critical files for implementation
- `/Users/justin/Leorna/leorna-control-plane/internal/web/handler.go`
- `/Users/justin/Leorna/leorna-control-plane/internal/web/packs.go` (`writeHTMLPage`, `packStyles`) and `/Users/justin/Leorna/leorna-control-plane/internal/web/packs_test.go` (`newPackFixture`)
- `/Users/justin/Leorna/leorna-control-plane/internal/library/library.go`
- `/Users/justin/Leorna/leorna-control-plane/internal/store/postgres/library.go` and `/Users/justin/Leorna/leorna-control-plane/internal/store/postgres/teams.go` (`beginOrg`, `orgError`)
- `/Users/justin/Leorna/leorna-control-plane/cmd/control-plane/main.go`
