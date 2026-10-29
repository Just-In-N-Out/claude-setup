# 86bcm901z — Customise a shipped item (company variant) (control plane)

## Questions for Justin (⭐ = recommended; the plan is written as if every ⭐ is chosen, so **go** needs no re-plan)

**Q1. What is a variant called in packs and in engineers' tools?**
- **A ⭐ Its own name (prefilled `<name>-custom`)**
- B. The shipped item's name; a pack holds one or the other

With A, a variant is one more row in the Content library with its own kind and name. Every pack path (tick, untick, Move up/down, Remove, the JSON API's ids, assignment, Sync) works on it unchanged, and a company can keep several variants of one item (`incident-postmortem-acme`, `incident-postmortem-ops`). The admin decides whether a pack holds the shipped item, the variant or both.
If B: pack items must remember where they came from (a new `pack_version_items` column), the pack builder's ticks and "in pack" marks switch from kind+name to that origin, ticking the variant must swap out the shipped item in one save, and a company gets at most one variant per shipped item. About +3 h, and it reworks 901w/901y code paths.

**Q2. What does "merge" do when upstream ships a newer version?**
- **A ⭐ Three-way line merge; conflicts resolved in a text box**
- B. Replace with upstream's text (company edits dropped)

With A, lines only the company changed and lines only upstream changed are both kept. Where both changed the same lines, nothing is saved: the admin gets the merged text with `<<<<<<< your variant` / `>>>>>>> upstream …` markers in a text box, fixes those spots and saves. That save is the merge.
If B: Merge copies upstream's new text over the variant after showing the diff; no merge code and no resolver (about −2 h), but every merge throws the company's edits away, which defeats "adapt it while staying close".

**Q3. What does "ignore" record?**
- **A ⭐ That version only; a newer release shows the notice again**
- B. All future updates, until the admin turns updates back on

With A, the variant stores the ignored version; the notice disappears, the variant page still offers that version's merge, and the next upstream version brings the notice back.
If B: a per-variant "updates off" switch plus a "watch updates again" button; AC2's ignore subtest changes to "no notice for 1.2.0 either".

**Q4. What can an admin edit in a variant?**
- **A ⭐ Description and main text; supporting files follow upstream**
- B. Also add, edit and remove supporting files

With A, a skill variant's supporting files stay as upstream ships them (listed read-only) and a merge takes upstream's files, so files never need merging.
If B: the variant editor reuses the item editor's file fields and uploads, merge gains a per-file three-way merge with file conflicts, and AC2/AC4 grow. About +4 h; a good follow-up card instead.

## Acceptance criteria

AC1–AC3 are the card's, in its own words. AC4 is mine (proposed): it covers the DoD's failure case, the admin-only and tenant guards, and the secret gate. No AC needs Justin's hands (the "UI demo" of the card's Verify line is an agent-captured run of the real binary, see "Evidence"), so none is `(live)`. Each test's whole name sits on its AC line.

- AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version — test `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`
- AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore — test `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`
- AC3: Given a variant, then it is used in packs exactly like a library item — test `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`
- AC4 (proposed): Given a variant request that is invalid or not allowed (a member, a bad CSRF token, signed out, another company's variant, a config or MCP template, a name the company's variants or a shipped item of that kind already use, a malformed name, a stale or unchanged edit, a suspected secret in the text, a merge or ignore with no newer upstream version or after upstream moved on, an unknown id), then it is refused with a clear status or inline alert, nothing is written (no variant row change, no audit record, no pack version), a suspected secret is never echoed back, and one company never sees, changes or packs another company's variant — test `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`

## Playback and summary

**Playback:** an admin can make a company copy of a shipped skill, agent or prompt, edit it, and keep it close to the original: the copy remembers which library item and version it came from, shows "Update available" with a diff when a newer control-plane release ships a newer version, and can merge or ignore it; inside packs the copy behaves exactly like a shipped item.

**Summary:**
1. **Migration 25** adds `library_variants` (tenant-owned; `upstream_item_id` → the `library_items` row it is based on; `ignored_upstream_version`). The shipped library and saved pack versions are never touched.
2. **`internal/textdiff`** (new, pure, stdlib only): a bounded line diff for display and a three-way line merge with conflict markers. **`internal/variant`** (new): the variant domain and service; every save runs the item editor's gate (`itembuilder` rules + `gate.CheckTenantItem`: renders for Claude Code, Codex and Cursor plus gitleaks).
3. **Console:** "Customise for your company" on a shipped item's page; the Content library lists the company's variants beside shipped items (chip "Company variant", "Update available: X"); a variant page `/admin/library/variants/{id}` with lineage, the update notice and upstream diff, Merge / Ignore, the conflict resolver, an editor, a bounded preview and Delete.
4. **Packs:** the pack builder (console ticks and `POST /v1/packs`, `POST /v1/packs/{id}/versions`) accepts a variant's id wherever it accepts a library item's id; pack versions copy the variant's content, so Move, Remove, assignment and Sync need no change. OpenAPI: description-only change to the two id lists; the client is untouched.
5. **A "newer upstream version"** is a newer `library_items` row for the same kind and name, which a new control-plane release's embedded library adds at startup (`EnsureLibrary`). Tests insert that row the way the loader does; one store test runs the real loader; the demo builds a second binary ("release B") with a bumped item and restarts it on the same database.

## Base, repo, pipeline

- **Card:** [Customise a shipped item (company variant)](https://app.clickup.com/t/86bcm901z) (E11 Pack Builder, PI-2, Size L, priority high, tag pillar-governance, to do, assigned to Justin). Read 2026-10-29 19:15 UTC; the ACs above are its text verbatim. Its one dependency, [Library catalog browser](https://app.clickup.com/t/86bcm901v), is complete.
- **Repo:** `leorna-control-plane` only. No `leorna-client` change (see D9).
- **Base:** `b65f797ff6cdc56a802dfaf417b0adec96463317` ("Merge pull request #100", 86bcm9023 item editor live preview). 2026-10-29 19:20 UTC: HTTPS fetch through gh, then `git merge --ff-only origin/main` in the main checkout fast-forwarded local `main` from `b985422` (13 commits). Local `main` = `origin/main` = GitHub `main` (`gh api repos/LeornaAI/leorna-control-plane/commits/main`) = base. The main checkout is on `main` with only an untracked `.claude/`. Client GitHub `main` is `f105e27`.
- **Worktree / branch (builder creates them in B0):** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item` on `feat/86bcm901z-customise-shipped-item`, from the base.
- **Pipeline:** Full. Every role is a fresh Opus 5.5 xhigh agent. Nothing is pushed, posted or merged without Justin's own word.

## Skills (build roles)

Every role loads `leorna` (its role section; the planner did the Step 1 context load), then `engineering-best-practices`, then:
- **Specialists (every role):** `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` **(ends with "Mandatory Validation and Agent Defect Loop")**, `backend-data-migrations` **(ends with "Mandatory Validation and Agent Defect Loop")**. Their loops' "spawn an agent" steps are run by the main session's review → fix → verifier → auditor pipeline, never by a role itself.
- **Builder:** `test-driven-development`, plus `mutation-testing-discipline` for the guards: the tenant filter in every variant query and in the pack builder's id lookup, the admin re-check in every write, the expected-version and expected-upstream checks, the kind and shipped-name checks, the secret gate and its no-echo rule, the conflict-marker check and the bounded preview (list in "Mutation checks").
- **Reviewers:** `requesting-code-review` + `code-review-practice` (report only).
- **Fixers:** `receiving-code-review`, `test-driven-development` (+ `mutation-testing-discipline` when a guard changes).
- **Verifier / auditor:** read-only; `feature-dispatch/references/ac-verification.md`.
- **Finisher:** `receiving-code-review`, `git-commit-rules`, `test-driven-development`.
- Not a bug, so no `systematic-debugging` up front; any unexpected failure during the build goes to it.

## What exists on base versus what 901z adds

| Capability | On `b65f797` | 901z |
| --- | --- | --- |
| Shipped library rows `(kind, name, version)`, immutable, loaded at startup | `library_items` (migration 20), `EnsureLibrary` (`internal/store/postgres/library.go:16`), loader adds new versions and keeps old ones (`:29`) | Unchanged. A variant references one row. |
| Library page, item page | `GET /admin/library`, `GET /admin/library/items/{itemId}` (`internal/web/library.go:125,175`), shipped items only, newest version per kind+name (`library_catalog.go:21`) | Lists the company's variants beside shipped items; item page gets "Customise for your company" |
| Tenant-written items | Only inside pack versions (item editor, `internal/itembuilder`, `internal/web/item_create.go`, `pack_versions.go`) | A tenant-owned, editable variant outside packs, saved through the same gate |
| Pack builder picks items by id | Library row ids only (`loadLibraryItems`, `internal/store/postgres/pack_builder.go:230`; console `ticksToChange`, `internal/web/pack_builder.go:429`) | Library row ids **or** this company's variant ids (same fields, same code paths) |
| Move / Remove / assign / Sync | By pack item id and copied content (901y `pack_items.go`, assignments, `internal/bundle`) | Unchanged (pack versions copy the variant's content) |
| Text diff / merge | None at runtime (the upstream tool shells out to git, `internal/library/upstream/adaptation.go:79`) | `internal/textdiff`: bounded diff + three-way merge |
| Bounded Markdown preview for tenant text | `renderBoundedItem` (`internal/web/item_preview.go:179`, PR #100) | Reused on the variant page (the library item page's unbounded preview stays for shipped content only; `internal/web/README.md:205-225` requires this) |

## How a "newer upstream version" happens

- **In production:** library items ship inside the control-plane binary (`internal/library/content`, `//go:embed`). Leorna publishes a change to a shipped item as a new item version: `go run ./cmd/library-upstream accept …` for an imported item, or a hand edit plus a version bump for a Leorna-authored one, each with a new `content.lock.json` line (`internal/library/README.md` "Published versions are immutable"). When an install runs the new release, `EnsureLibrary` runs at startup and in the setup wizard and **adds** the new `library_items` row `(kind, name, newer version)` while keeping the old ones (`internal/store/postgres/library.go:29-87`). Nothing else writes `library_items`.
- **What the variant sees:** its `upstream_item_id` points at the row it is based on. "Update available" means the newest stored row of the same kind and name (versions compared number by number, as `ListLibraryItems` does: `string_to_array(version,'.')::numeric[]`) is not that row, and its version is not the ignored one. It is computed when a page is read; there is no job or notification.
- **In tests:**
  - `internal/web` AC tests insert the newer row with the existing helper `insertLibraryItems` (`internal/web/library_test.go:36`), which writes exactly the columns the loader writes, including `content_sha256 = item.Checksum()`.
  - `TestVariantUpdateAppearsAfterTheNextLibraryLoadWithPostgres` (`internal/store/postgres`) runs the real loader twice: `loadLibrary(ctx, libA)` then `loadLibrary(ctx, libB)` where `libB` is `libA` with one item bumped (built in the test from `library.Library{…}`), and checks the variant's newest upstream moves to the new row.
  - The demo (E2) builds **release B**: a scratch copy of the head with `skill/incident-postmortem` bumped from 1.1.0 to 1.2.0 (one line changed, one added; lock line recorded with `-update-lock`; `library.json` 0.9.0), never committed, and restarts it on the same demo database; its log shows "content library loaded … added 1".

## Design

### D1. Scope

- **Kinds:** skill, agent, prompt (`variant.Customisable`). Configs and MCP templates are **out**: the tenant item gate (`itembuilder` validation, `internal/itembuilder/validate.go:41`) only accepts those three kinds, and configs/MCP templates depend on the 901j policy gate (`internal/library/gate/policy.go`: credential placeholders, pinned launchers, least-privilege floor), which runs only on shipped content in CI. A company copy of them would bypass that policy. Their item page says "Configs and MCP templates can't be customised." and the POST is refused (AC4).
- **Who:** tenant administrators only, like the library and the pack builder. Routes use `requireSession` + `requireAdmin`; every store write re-checks the admin role inside its transaction (`beginOrg(ctx, actor, true)`, `internal/store/postgres/teams.go:31`).
- **What is editable (Q4-A):** description and main text (`body`). Supporting files are copied from the upstream version and replaced by upstream's files on merge.
- **Not in scope:** a JSON API for variants (the library catalog has none either; follow-up), renaming a variant, editing supporting files, variants on the older Pack Versions paths (fork, single-item edit, "Add library item" reads the embedded library, not `library_items`), quick start (902a) and starter packs (901r), which pick shipped items only.

### D2. Data model — migration `000025_library_variants`

`internal/store/postgres/migrations/000025_library_variants.up.sql`:

```sql
-- Company variants of shipped library items (story 86bcm901z). A variant is a
-- tenant-owned, editable copy of one stored library item version. It keeps a
-- link to that version (its merge base), so the console can offer newer
-- upstream versions. Pack versions copy a variant's content like a library
-- item's, so editing or deleting a variant never changes a saved pack version.
CREATE TABLE library_variants (
 id uuid PRIMARY KEY,
 tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE RESTRICT,
 kind text NOT NULL CHECK (kind IN ('skill','agent','prompt')),
 name text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 64 AND name ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
 version text NOT NULL CHECK (version ~ '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'),
 description text NOT NULL CHECK (char_length(btrim(description)) BETWEEN 1 AND 2000),
 body text NOT NULL CHECK (octet_length(body) BETWEEN 1 AND 65536),
 files jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(files) = 'array'),
 upstream_item_id uuid NOT NULL REFERENCES library_items(id) ON DELETE RESTRICT,
 ignored_upstream_version text NULL CHECK (ignored_upstream_version ~ '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'),
 created_at timestamptz NOT NULL DEFAULT now(),
 updated_at timestamptz NOT NULL DEFAULT now(),
 CONSTRAINT library_variants_tenant_kind_name UNIQUE (tenant_id, kind, name)
);
-- Keeps the foreign key check on library_items cheap.
CREATE INDEX library_variants_upstream_item ON library_variants (upstream_item_id);
```

`000025_library_variants.down.sql`: `DROP TABLE library_variants;`

- Lineage = `upstream_item_id` (the row gives the upstream kind, name and version). Upstream kind always equals the variant's kind (checked in code at create; the row never changes).
- `ON DELETE RESTRICT` on `library_items`: the loader never deletes rows, and a manual cleanup cannot orphan a variant. `tenants` RESTRICT matches `pack_lineages`.
- Version rule: a new variant is `1.0.0`; every saved content change (edit or merge) bumps the minor (`1.1.0`, `1.2.0`…). Ignore does not change the version.
- Number 25 is the next free number on base. PR #101 (902a) and the local 901r branch also add a `000025_*`: whichever merges later renumbers (see Risks). Before writing, the builder re-checks `ls internal/store/postgres/migrations | grep '\.up\.sql$' | tail -2` on the base it builds from.
- Tests: add `library_variants` to both table lists in `TestMigrationRoundTrip` (`internal/store/postgres/store_test.go:34` and `:104`) and to `resetDatabase`'s `DROP TABLE` list (`:499`, before `library_items`).
- Rollback: the down migration deletes every variant (packs keep their copies). Prefer fix-forward; say so in the README and PR.

### D3. `internal/textdiff` (new package, stdlib only)

`internal/textdiff/textdiff.go` — complete code:

```go
// Package textdiff compares and merges texts line by line (story 86bcm901z).
// Work is bounded: a changed region larger than maxCells line pairs is
// reported as one replaced block instead of being matched line by line.
package textdiff

import (
	"slices"
	"strings"
)

// maxCells bounds the line-matching table (old lines × new lines) to about
// 4 MB per comparison. Bodies are at most 64 KiB.
const maxCells = 1 << 20

// contextLines is how many unchanged lines a shown block keeps around changes.
const contextLines = 3

// Conflict markers written into a merged text where both sides changed the
// same lines. "=======" alone is a Markdown heading underline, so only the
// first and last markers count when checking that a text is resolved.
const (
	MarkerOurs   = "<<<<<<< your variant"
	MarkerSep    = "======="
	MarkerTheirs = ">>>>>>> upstream"
)

// splitLines splits text after each "\n"; the last line has no "\n" when the
// text does not end with one. "" has no lines.
func splitLines(text string) []string {
	if text == "" {
		return nil
	}
	lines := strings.SplitAfter(text, "\n")
	if lines[len(lines)-1] == "" {
		lines = lines[:len(lines)-1]
	}
	return lines
}

// hunk replaces old[Start:End] with Lines.
type hunk struct {
	Start, End int
	Lines      []string
}

// hunks returns the changes that turn a into b, in order and non-overlapping;
// consecutive hunks are separated by at least one unchanged line.
func hunks(a, b []string) []hunk {
	prefix := 0
	for prefix < len(a) && prefix < len(b) && a[prefix] == b[prefix] {
		prefix++
	}
	suffix := 0
	for suffix < len(a)-prefix && suffix < len(b)-prefix && a[len(a)-1-suffix] == b[len(b)-1-suffix] {
		suffix++
	}
	am, bm := a[prefix:len(a)-suffix], b[prefix:len(b)-suffix]
	if len(am) == 0 && len(bm) == 0 {
		return nil
	}
	if len(am) == 0 || len(bm) == 0 || (len(am)+1)*(len(bm)+1) > maxCells {
		return []hunk{{Start: prefix, End: prefix + len(am), Lines: bm}}
	}
	// lcs[i*width+j] is the longest common subsequence of am[i:] and bm[j:].
	width := len(bm) + 1
	lcs := make([]int32, (len(am)+1)*width)
	for i := len(am) - 1; i >= 0; i-- {
		for j := len(bm) - 1; j >= 0; j-- {
			if am[i] == bm[j] {
				lcs[i*width+j] = lcs[(i+1)*width+j+1] + 1
			} else {
				lcs[i*width+j] = max(lcs[(i+1)*width+j], lcs[i*width+j+1])
			}
		}
	}
	var out []hunk
	var current *hunk
	flush := func() {
		if current != nil {
			out = append(out, *current)
			current = nil
		}
	}
	open := func(i int) {
		if current == nil {
			current = &hunk{Start: prefix + i, End: prefix + i}
		}
	}
	i, j := 0, 0
	for i < len(am) || j < len(bm) {
		switch {
		case i < len(am) && j < len(bm) && am[i] == bm[j]:
			flush()
			i, j = i+1, j+1
		case j < len(bm) && (i == len(am) || lcs[i*width+j+1] >= lcs[(i+1)*width+j]):
			open(i)
			current.Lines = append(current.Lines, bm[j])
			j++
		default:
			open(i)
			i++
			current.End = prefix + i
		}
	}
	flush()
	return out
}

// Op marks one shown line.
type Op byte

const (
	Context Op = ' '
	Removed Op = '-'
	Added   Op = '+'
)

// Line is one shown line without its line ending. NoNewline marks a last line
// that has none.
type Line struct {
	Op        Op
	Text      string
	NoNewline bool
}

// Block is one run of changes with up to three unchanged lines around it,
// like a unified diff hunk ("@@ -OldStart,OldLines +NewStart,NewLines @@").
type Block struct {
	OldStart, OldLines, NewStart, NewLines int
	Lines                                  []Line
}

// Diff returns the blocks that turn oldText into newText; nil when equal.
func Diff(oldText, newText string) []Block {
	a, b := splitLines(oldText), splitLines(newText)
	type step struct {
		op       Op
		text     string
		old, new int // 0-based positions in a and b
	}
	var steps []step
	ai, bi := 0, 0
	for _, h := range hunks(a, b) {
		for ; ai < h.Start; ai, bi = ai+1, bi+1 {
			steps = append(steps, step{Context, a[ai], ai, bi})
		}
		for ; ai < h.End; ai++ {
			steps = append(steps, step{Removed, a[ai], ai, bi})
		}
		for _, line := range h.Lines {
			steps = append(steps, step{Added, line, ai, bi})
			bi++
		}
	}
	for ; ai < len(a); ai, bi = ai+1, bi+1 {
		steps = append(steps, step{Context, a[ai], ai, bi})
	}
	var blocks []Block
	for i := 0; i < len(steps); {
		if steps[i].op == Context {
			i++
			continue
		}
		start, end := max(0, i-contextLines), i
		for end < len(steps) {
			if steps[end].op != Context {
				end++
				continue
			}
			run := end
			for run < len(steps) && steps[run].op == Context {
				run++
			}
			if run == len(steps) || run-end > 2*contextLines {
				end = min(len(steps), end+contextLines)
				break
			}
			end = run
		}
		block := Block{OldStart: steps[start].old + 1, NewStart: steps[start].new + 1}
		for _, s := range steps[start:end] {
			if s.op != Added {
				block.OldLines++
			}
			if s.op != Removed {
				block.NewLines++
			}
			block.Lines = append(block.Lines, Line{Op: s.op, Text: strings.TrimSuffix(s.text, "\n"), NoNewline: !strings.HasSuffix(s.text, "\n")})
		}
		blocks = append(blocks, block)
		i = end
	}
	return blocks
}

// Conflict is one place where both sides changed the same base lines
// differently. BaseStart is 1-based.
type Conflict struct {
	BaseStart          int
	Base, Ours, Theirs []string
}

// MergeResult is a three-way merge: Text has conflict markers when Conflicts
// is not empty.
type MergeResult struct {
	Text      string
	Conflicts []Conflict
}

// Merge3 applies the changes base→ours and base→theirs. Changes that overlap
// or touch (including insertions at the same place) form one region: it takes
// the side that changed it, takes identical changes once, and is a conflict
// otherwise. theirsLabel follows MarkerTheirs, e.g. "team-handbook 1.1.0".
func Merge3(base, ours, theirs, theirsLabel string) MergeResult {
	b := splitLines(base)
	oh, th := hunks(b, splitLines(ours)), hunks(b, splitLines(theirs))
	var out []string
	var conflicts []Conflict
	pos, i, j := 0, 0, 0
	for i < len(oh) || j < len(th) {
		var start, end int
		var takeO, takeT []hunk
		if j >= len(th) || i < len(oh) && oh[i].Start <= th[j].Start {
			start, end = oh[i].Start, oh[i].End
			takeO = append(takeO, oh[i])
			i++
		} else {
			start, end = th[j].Start, th[j].End
			takeT = append(takeT, th[j])
			j++
		}
		for grown := true; grown; {
			grown = false
			if i < len(oh) && oh[i].Start <= end && oh[i].End >= start {
				end = max(end, oh[i].End)
				takeO = append(takeO, oh[i])
				i++
				grown = true
			}
			if j < len(th) && th[j].Start <= end && th[j].End >= start {
				end = max(end, th[j].End)
				takeT = append(takeT, th[j])
				j++
				grown = true
			}
		}
		out = append(out, b[pos:start]...)
		pos = end
		oursSpan, theirsSpan := apply(b, start, end, takeO), apply(b, start, end, takeT)
		switch {
		case len(takeT) == 0:
			out = append(out, oursSpan...)
		case len(takeO) == 0:
			out = append(out, theirsSpan...)
		case slices.Equal(oursSpan, theirsSpan):
			out = append(out, oursSpan...)
		default:
			conflicts = append(conflicts, Conflict{BaseStart: start + 1, Base: b[start:end], Ours: oursSpan, Theirs: theirsSpan})
			out = append(out, MarkerOurs+"\n")
			out = append(out, withNewline(oursSpan)...)
			out = append(out, MarkerSep+"\n")
			out = append(out, withNewline(theirsSpan)...)
			out = append(out, MarkerTheirs+" "+theirsLabel+"\n")
		}
	}
	out = append(out, b[pos:]...)
	return MergeResult{Text: strings.Join(out, ""), Conflicts: conflicts}
}

// apply returns base[start:end] with hs (all inside it, in order) applied.
func apply(base []string, start, end int, hs []hunk) []string {
	var out []string
	pos := start
	for _, h := range hs {
		out = append(out, base[pos:h.Start]...)
		out = append(out, h.Lines...)
		pos = h.End
	}
	return append(out, base[pos:end]...)
}

// withNewline makes sure a span ends with "\n" before a marker line.
func withNewline(lines []string) []string {
	if len(lines) == 0 || strings.HasSuffix(lines[len(lines)-1], "\n") {
		return lines
	}
	out := slices.Clone(lines)
	out[len(out)-1] += "\n"
	return out
}

// HasConflictMarkers reports whether text still has a merge's first or last
// conflict marker line.
func HasConflictMarkers(text string) bool {
	for _, line := range strings.Split(text, "\n") {
		line = strings.TrimSuffix(line, "\r")
		if line == MarkerOurs || line == MarkerTheirs || strings.HasPrefix(line, MarkerTheirs+" ") {
			return true
		}
	}
	return false
}
```

The planner traced `hunks` and `Merge3` by hand on: separate changes (`[a b c d e]`, ours changes b, theirs changes d and appends f → `[a B c D e f]`), the same line changed differently (conflict), identical insertions (taken once) and adjacent changes (conflict, as git does). The builder's unit tests pin these.

### D4. `internal/variant` (new package)

`internal/variant/variant.go`:

```go
// Package variant lets a company customise a shipped library item and keep
// its copy in step with upstream (story 86bcm901z).
package variant

// Upstream is one stored library item version (a library_items row).
type Upstream struct {
	ID, Name, Version, Category, Description, Body string
	Kind                                           pack.Kind
	Tags                                           []string
	Tools                                          []library.Tool
	Files                                          []pack.SupportFile
}

// Variant is a company's own copy of a shipped item. Lists leave Body, Files
// and both upstreams' Description, Body and Files empty.
type Variant struct {
	ID, Name, Version, Description, Body string
	Kind                                 pack.Kind
	Files                                []pack.SupportFile
	Base                                 Upstream // the version the content is based on (the merge base)
	Latest                               Upstream // newest stored version of the same upstream kind and name; Base when none is newer
	IgnoredVersion                       string   // "" when no update is ignored
	CreatedAt, UpdatedAt                 time.Time
}

func (v Variant) UpdateAvailable() bool { return v.Latest.ID != v.Base.ID && v.Latest.Version != v.IgnoredVersion }
func (v Variant) UpdateIgnored() bool   { return v.Latest.ID != v.Base.ID && v.Latest.Version == v.IgnoredVersion }

// FirstVersion is a new variant's version; each saved change bumps the minor.
const FirstVersion = "1.0.0"

// gateLabel names the pack the tenant item gate renders a variant into.
const gateLabel = "Company variants"

func Customisable(kind pack.Kind) bool { return kind == pack.KindSkill || kind == pack.KindAgent || kind == pack.KindPrompt }

var (
	ErrNotCustomisable = fmt.Errorf("only skills, agents and prompts can be customised: %w", org.ErrInvalid)
	ErrShippedName     = fmt.Errorf("a shipped item of this kind already uses this name: %w", org.ErrInvalid)
	ErrNothingChanged  = fmt.Errorf("the variant is unchanged: %w", org.ErrInvalid)
	ErrNoUpdate        = fmt.Errorf("upstream has no newer version: %w", org.ErrInvalid)
	ErrUnresolved      = fmt.Errorf("the text still has conflict markers: %w", org.ErrInvalid)
	ErrNameTaken       = fmt.Errorf("the company already has a variant of this kind with this name: %w", store.ErrConflict)
	ErrChanged         = fmt.Errorf("the variant changed since it was read: %w", store.ErrConflict)
	ErrUpstreamChanged = fmt.Errorf("upstream has a newer version than the one shown: %w", store.ErrConflict)
	ErrMergeConflict   = fmt.Errorf("the variant and upstream changed the same lines: %w", store.ErrConflict)
)

// NewVariant is a checked copy of an upstream version under a new name.
type NewVariant struct {
	UpstreamID, Name, Description, Body string
	Files                               []pack.SupportFile
}

// SaveSpec is one saved change. MergedUpstreamID is "" for an edit; for a
// merge it is the upstream version merged in, which must still be the newest.
type SaveSpec struct {
	ID, ExpectedVersion, Version, Description, Body, MergedUpstreamID string
	Files                                                             []pack.SupportFile
}

// IgnoreSpec ignores the newest upstream version, which must be UpstreamID.
type IgnoreSpec struct{ ID, ExpectedVersion, UpstreamID string }

// Store persists variants. Every read and write is keyed by the actor's
// tenant; another tenant's variant is store.ErrNotFound. Writes re-check the
// admin role, run in one transaction and append their audit record in it.
type Store interface {
	LibraryItem(ctx context.Context, actor store.Principal, id string) (Upstream, error)
	CreateVariant(ctx context.Context, actor store.Principal, spec NewVariant) (Variant, error)
	ListVariants(ctx context.Context, actor store.Principal) ([]Variant, error)
	GetVariant(ctx context.Context, actor store.Principal, id string) (Variant, error)
	SaveVariant(ctx context.Context, actor store.Principal, spec SaveSpec) (Variant, error)
	IgnoreUpdate(ctx context.Context, actor store.Principal, spec IgnoreSpec) (Variant, error)
	DeleteVariant(ctx context.Context, actor store.Principal, id, expectedVersion string) error
}
```

`internal/variant/draft.go` (pure):

```go
// Draft is the first content of a variant of upstream named name: upstream's
// description, body and files, with an agent's frontmatter name set to name.
// It does not validate; Service.check does.
func Draft(upstream Upstream, name string) (itembuilder.Input, error) {
	if !Customisable(upstream.Kind) {
		return itembuilder.Input{}, ErrNotCustomisable
	}
	name = strings.TrimSpace(name)
	body := upstream.Body
	if upstream.Kind == pack.KindAgent {
		renamed, ok := renameAgent(body, name)
		if !ok {
			return itembuilder.Input{}, itembuilder.Issue{Field: "body", Message: "The shipped agent has no frontmatter name line to rename"}
		}
		body = renamed
	}
	return itembuilder.Input{Kind: upstream.Kind, Name: name, Version: FirstVersion, Description: upstream.Description, Body: body, Files: slices.Clone(upstream.Files)}, nil
}

// renameAgent sets the frontmatter's name line to "name: <name>" and changes
// no other byte (names are lowercase slugs, so no quoting is needed).
func renameAgent(body, name string) (string, bool) {
	rest, found := strings.CutPrefix(body, "---\n")
	if !found {
		return body, false
	}
	end := strings.Index(rest, "\n---\n")
	if end < 0 {
		return body, false
	}
	lines := strings.Split(rest[:end], "\n")
	for index, line := range lines {
		if strings.HasPrefix(line, "name:") {
			lines[index] = "name: " + name
			return "---\n" + strings.Join(lines, "\n") + rest[end:], true
		}
	}
	return body, false
}

// DefaultName suggests "<upstream name>-custom", cut to the 64-character limit.
func DefaultName(upstream string) string {
	const suffix = "-custom"
	if len(upstream)+len(suffix) > 64 {
		upstream = strings.TrimRight(upstream[:64-len(suffix)], "-")
	}
	return upstream + suffix
}

// NextVersion bumps the minor: 1.2.3 → 1.3.0.
func NextVersion(version string) (string, error) {
	parts := strings.Split(version, ".")
	if len(parts) != 3 {
		return "", fmt.Errorf("variant version is invalid: %w", org.ErrInvalid)
	}
	major, err1 := strconv.Atoi(parts[0])
	minor, err2 := strconv.Atoi(parts[1])
	if err1 != nil || err2 != nil || major < 0 || minor < 0 {
		return "", fmt.Errorf("variant version is invalid: %w", org.ErrInvalid)
	}
	return fmt.Sprintf("%d.%d.0", major, minor+1), nil
}

// MergePreview is what merging the newest upstream version would give. The
// description merges as one value; on a conflict it keeps the company's.
type MergePreview struct {
	Description         string
	DescriptionConflict bool
	UpstreamDescription string
	Body                textdiff.MergeResult
}

func (p MergePreview) Conflicts() int {
	n := len(p.Body.Conflicts)
	if p.DescriptionConflict {
		n++
	}
	return n
}

func PreviewMerge(v Variant) MergePreview {
	description, conflict := mergeValue(v.Base.Description, v.Description, v.Latest.Description)
	return MergePreview{Description: description, DescriptionConflict: conflict, UpstreamDescription: v.Latest.Description,
		Body: textdiff.Merge3(v.Base.Body, v.Body, v.Latest.Body, v.Latest.Name+" "+v.Latest.Version)}
}

func mergeValue(base, ours, theirs string) (string, bool) {
	switch {
	case ours == theirs || theirs == base:
		return ours, false
	case ours == base:
		return theirs, false
	default:
		return ours, true
	}
}

// FileChange is one supporting file upstream added, removed or changed.
type FileChange struct{ Path, Change string } // Change: "added", "removed" or "changed"

// FileChanges compares two file lists by path, sorted by path.
func FileChanges(before, after []pack.SupportFile) []FileChange
```

`internal/variant/service.go`:

```go
type Service struct {
	store   Store
	scanner gate.Scanner
}

func NewService(store Store, scanner gate.Scanner) *Service { return &Service{store: store, scanner: scanner} }

func (s *Service) Variants(ctx context.Context, actor store.Principal) ([]Variant, error) { return s.store.ListVariants(ctx, actor) }
func (s *Service) Variant(ctx context.Context, actor store.Principal, id string) (Variant, error) { return s.store.GetVariant(ctx, actor, id) }

// Customise copies one stored library item version into a new variant.
func (s *Service) Customise(ctx context.Context, actor store.Principal, upstreamID, name string) (Variant, error) {
	upstream, err := s.store.LibraryItem(ctx, actor, upstreamID)
	if err != nil {
		return Variant{}, err
	}
	in, err := Draft(upstream, name)
	if err != nil {
		return Variant{}, err
	}
	if err := s.check(ctx, &in); err != nil {
		return Variant{}, err
	}
	return s.store.CreateVariant(ctx, actor, NewVariant{UpstreamID: upstream.ID, Name: in.Name, Description: in.Description, Body: in.Body, Files: in.Files})
}

// Edit is the admin's new description and main text for the version they saw.
type Edit struct{ ExpectedVersion, Description, Body string }

func (s *Service) Edit(ctx context.Context, actor store.Principal, id string, edit Edit) (Variant, error) {
	current, err := s.store.GetVariant(ctx, actor, id)
	if err != nil {
		return Variant{}, err
	}
	if current.Version != edit.ExpectedVersion {
		return Variant{}, ErrChanged
	}
	if edit.Description == current.Description && edit.Body == current.Body {
		return Variant{}, ErrNothingChanged
	}
	return s.save(ctx, actor, current, edit.Description, edit.Body, current.Files, "")
}

// MergeRequest merges the newest upstream version the admin saw. Resolved
// carries the admin's text after resolving conflicts; nil asks for an
// automatic merge, which is refused when it has conflicts.
type MergeRequest struct {
	ExpectedVersion, UpstreamID string
	Resolved                    *Resolution
}

type Resolution struct{ Description, Body string }

func (s *Service) Merge(ctx context.Context, actor store.Principal, id string, request MergeRequest) (Variant, error) {
	current, err := s.store.GetVariant(ctx, actor, id)
	if err != nil {
		return Variant{}, err
	}
	switch {
	case current.Version != request.ExpectedVersion:
		return Variant{}, ErrChanged
	case current.Latest.ID == current.Base.ID:
		return Variant{}, ErrNoUpdate
	case !strings.EqualFold(current.Latest.ID, request.UpstreamID):
		return Variant{}, ErrUpstreamChanged
	}
	var description, body string
	if request.Resolved == nil {
		preview := PreviewMerge(current)
		if preview.Conflicts() > 0 {
			return Variant{}, ErrMergeConflict
		}
		description, body = preview.Description, preview.Body.Text
	} else {
		description, body = request.Resolved.Description, request.Resolved.Body
		if textdiff.HasConflictMarkers(description) || textdiff.HasConflictMarkers(body) {
			return Variant{}, ErrUnresolved
		}
	}
	return s.save(ctx, actor, current, description, body, current.Latest.Files, current.Latest.ID)
}

func (s *Service) Ignore(ctx context.Context, actor store.Principal, id, expectedVersion, upstreamID string) (Variant, error) {
	return s.store.IgnoreUpdate(ctx, actor, IgnoreSpec{ID: id, ExpectedVersion: expectedVersion, UpstreamID: upstreamID})
}

func (s *Service) Delete(ctx context.Context, actor store.Principal, id, expectedVersion string) error {
	return s.store.DeleteVariant(ctx, actor, id, expectedVersion)
}

func (s *Service) save(ctx context.Context, actor store.Principal, current Variant, description, body string, files []pack.SupportFile, mergedUpstreamID string) (Variant, error) {
	next, err := NextVersion(current.Version)
	if err != nil {
		return Variant{}, err
	}
	in := itembuilder.Input{Kind: current.Kind, Name: current.Name, Version: next, Description: description, Body: body, Files: slices.Clone(files)}
	if err := s.check(ctx, &in); err != nil {
		return Variant{}, err
	}
	return s.store.SaveVariant(ctx, actor, SaveSpec{ID: current.ID, ExpectedVersion: current.Version, Version: next,
		Description: in.Description, Body: in.Body, Files: in.Files, MergedUpstreamID: mergedUpstreamID})
}

// check runs the item editor's gate: field rules (itembuilder), then renders
// for Claude Code, Codex and Cursor plus the secret scan (gate.CheckTenantItem).
// DraftIssues recomputes each file's Script flag and sorts the files in in's
// own copy.
func (s *Service) check(ctx context.Context, in *itembuilder.Input) error {
	if issues := itembuilder.DraftIssues(*in); len(issues) > 0 {
		return issues[0]
	}
	_, err := gate.CheckTenantItem(ctx, gateLabel, in.Version, pack.ItemEdit{Kind: in.Kind, Name: in.Name, Version: in.Version,
		Description: in.Description, Body: in.Body, Files: in.Files}, s.scanner)
	return err
}
```

(`itembuilder.DraftIssues` takes `Input` by value but `validate` sorts `in.Files` and sets `Script` through the shared backing array; because `Draft` and `save` pass a cloned slice, that only touches the variant's own copy. See "Other things found".)

### D5. Store — `internal/store/postgres/library_variants.go`

`var _ variant.Store = (*Store)(nil)`. Every method: `validUUID` on ids first (malformed → `store.ErrNotFound`), `beginOrg(ctx, actor, write)` (reads `false`, writes `true`), `defer tx.Rollback`, `orgError` on database errors (it passes errors wrapping `org.ErrInvalid`/`store.ErrConflict` through and maps no rows to `store.ErrNotFound`).

- **Reads:**

  ```sql
  -- variantSelect: a variant, the version it is based on (b) and the newest
  -- stored version of the same upstream kind and name (l).
  SELECT v.id::text, v.kind, v.name, v.version, v.description, v.body, v.files,
         COALESCE(v.ignored_upstream_version, ''), v.created_at, v.updated_at,
         b.id::text, b.kind, b.name, b.version, b.category, b.tags, b.tools, b.description, b.body, b.files,
         l.id::text, l.kind, l.name, l.version, l.category, l.tags, l.tools, l.description, l.body, l.files
  FROM library_variants v
  JOIN library_items b ON b.id = v.upstream_item_id
  JOIN LATERAL (SELECT * FROM library_items i WHERE i.kind = b.kind AND i.name = b.name
                ORDER BY string_to_array(i.version, '.')::numeric[] DESC LIMIT 1) l ON true
  WHERE v.tenant_id = $1
  ```

  `GetVariant` adds `AND v.id = $2`. `ListVariants` uses the same joins with `''`/`'[]'` in place of every body, files and upstream description column (metadata only; the variant's own description stays), and sorts in Go by kind, then name (byte order, as `ListLibraryItems`). One scan helper fills `variant.Variant` (tools through `libraryTools`, files through `json.Unmarshal`).
- **`LibraryItem`:** `SELECT id::text, kind, name, version, category, tags, tools, description, body, files FROM library_items WHERE id=$1` in `beginOrg(false)` (shared content; the read still needs a current user of the tenant, like `GetLibraryItem`).
- **`CreateVariant`:** in one `beginOrg(…, true)` transaction:
  1. `SELECT kind, name, version FROM library_items WHERE id=$1` (none → `store.ErrNotFound`);
  2. `!variant.Customisable(kind)` → `variant.ErrNotCustomisable` (the store's own backstop);
  3. `SELECT EXISTS(SELECT 1 FROM library_items WHERE kind=$1 AND name=$2)` → `variant.ErrShippedName`;
  4. `INSERT INTO library_variants(id,tenant_id,kind,name,version,description,body,files,upstream_item_id) VALUES(…)` with `variant.FirstVersion` and the row's kind; a unique violation on `library_variants_tenant_kind_name` (use `uniqueViolation`, `pack_builder.go:218`) → `variant.ErrNameTaken`;
  5. audit `library.variant.create` (target = variant id, before nil, after = the audit record below);
  6. read back with `variantSelect … AND v.id=$2`; commit.
- **`SaveVariant`:** one write transaction:
  1. `SELECT version FROM library_variants WHERE tenant_id=$1 AND id=$2 FOR UPDATE` (lock first; no `FOR UPDATE` on the LATERAL query);
  2. `version != spec.ExpectedVersion` → `variant.ErrChanged`;
  3. read the full current variant with `variantSelect`;
  4. if `spec.MergedUpstreamID != ""`: `Latest.ID == Base.ID` → `ErrNoUpdate`; `!strings.EqualFold(Latest.ID, spec.MergedUpstreamID)` → `ErrUpstreamChanged`; the new base is `Latest.ID` and `ignored_upstream_version` becomes NULL; action `library.variant.merge`. Otherwise the base stays and the action is `library.variant.update`;
  5. `UPDATE library_variants SET version=$3, description=$4, body=$5, files=$6, upstream_item_id=$7, ignored_upstream_version=$8, updated_at=now() WHERE tenant_id=$1 AND id=$2` (`$8` is the current value for an edit, NULL for a merge);
  6. audit (before = record of the current variant, after = record of the saved one); read back; commit.
- **`IgnoreUpdate`:** lock and version check as above; read current; `Latest.ID == Base.ID` → `ErrNoUpdate`; `Latest.ID` ≠ `spec.UpstreamID` → `ErrUpstreamChanged`; already ignoring that version → return the current variant, write nothing, no audit; else `UPDATE … SET ignored_upstream_version=<latest version>, updated_at=now()` and audit `library.variant.ignore`.
- **`DeleteVariant`:** lock and version check; read current (for the audit before-value); `DELETE FROM library_variants WHERE tenant_id=$1 AND id=$2`; audit `library.variant.delete` (after nil).
- **Audit record** (before/after values; never description, body or files):

  ```go
  type variantAuditRecord struct {
  	VariantID              string `json:"variantId"`
  	Kind                   string `json:"kind"`
  	Name                   string `json:"name"`
  	Version                string `json:"version"`
  	UpstreamID             string `json:"upstreamId"`
  	UpstreamName           string `json:"upstreamName"`
  	UpstreamVersion        string `json:"upstreamVersion"`
  	IgnoredUpstreamVersion string `json:"ignoredUpstreamVersion,omitempty"`
  }
  ```

### D6. Packs: a variant id goes wherever a library item id goes

- `internal/store/postgres/pack_builder.go`: `loadLibraryItems(ctx, tx, ids)` becomes `loadCatalogItems(ctx, tx, tenantID, ids)` (callers `CreatePack:34`, `SavePackVersion:101` pass `actor.TenantID`):

  ```sql
  SELECT id::text,kind,name,version,description,body,files FROM library_items WHERE id = ANY($1::uuid[])
  UNION ALL
  SELECT id::text,kind,name,version,description,body,files FROM library_variants WHERE tenant_id = $2 AND id = ANY($1::uuid[])
  ```

  The rest of the function is unchanged: any id that matches neither (unknown, or another company's variant) is `org.ErrInvalid` → 400 `INVALID_PACK`, with the same message for both, so the API is no oracle for other companies' ids. Update the comments on `pack.NewPack.LibraryItemIDs`, `pack.PackChange.AddLibraryItemIDs`, `pack.VersionChange.AddLibraryItemIDs` ("content library item or company variant ids"); keep the field names (no churn for 902a's callers).
- `internal/library/catalog.go`: `Entry` gains `Variant *VariantOf` (nil for shipped items):

  ```go
  // VariantOf marks a catalog entry that is a company's variant of a shipped
  // item (story 86bcm901z). The entry's Category, Tags and Tools are the
  // upstream version's.
  type VariantOf struct {
  	UpstreamID, UpstreamName, UpstreamVersion string
  	UpdateVersion string // newest upstream version when an update is available and not ignored
  	NameClash     bool   // a shipped item of the same kind now has this name (a later release)
  }
  ```

  `ListLibraryItems` is unchanged (still shipped items only; 902a's quick start reads it).
- `internal/web/library.go`: new `(*Handler).catalogEntries(ctx, actor) ([]library.Entry, error)`: `ListLibraryItems`, then (when `handler.variants != nil`) `variants.Variants`, each turned into an entry (`ID` = variant id; `Item` = kind, name, version, the variant's description, Base's category, tags and tools; `Variant` set; `NameClash` when a shipped entry has the same kind and name), then a stable sort by kind, then name. `renderLibrary` (`:138`) and `packBuilderSaveForm` (`pack_builder.go:371`) call it instead of `ListLibraryItems`. In `packBuilderSaveForm` the `byID` map skips `NameClash` entries, so a forged tick of one is "The form no longer matches the library" (400).
- Nothing else in the pack paths changes: `ApplyChange`, `DiffItems`, the 901y item list (Move up/down/Remove by pack item id), assignments and the bundle work on copied content. `newLibraryBuilder`'s `inLibrary` now also contains variant keys, so a pack's variant item is not labelled "not in the library" while the variant exists, and is once it is deleted (the same as an item no longer in the library).
- Name clash after a later release (Q1-A edge): the console shows the variant row without an Include checkbox and with the note below; the API still accepts its id (unambiguous by id), and a pack still holds at most one item per kind and name (`ApplyChange`'s rule refuses both).

### D7. Console pages and routes (`internal/web/library_variants.go`, edits in `library.go`, `handler.go`)

Routes (in `Routes()`, next to the library routes):

| Method | Route | Guard |
| --- | --- | --- |
| POST | `/admin/library/items/{itemId}/customise` | `requireSession(requireAdmin(…), false)` |
| GET | `/admin/library/variants/{variantId}` | `requireSession(requireAdmin(…), true)` |
| POST | `/admin/library/variants/{variantId}/edit` | `requireSession(requireAdmin(…), false)` |
| POST | `/admin/library/variants/{variantId}/merge` | same |
| POST | `/admin/library/variants/{variantId}/ignore` | same |
| POST | `/admin/library/variants/{variantId}/delete` | same |

`Handler` gains `variants variantService` and `SetVariants(v variantService)` (interface below, at its point of use); a nil service means no customise form, no variant rows and 503 `VARIANTS_UNAVAILABLE` on the variant routes.

```go
type variantService interface {
	Variants(ctx context.Context, actor store.Principal) ([]variant.Variant, error)
	Variant(ctx context.Context, actor store.Principal, id string) (variant.Variant, error)
	Customise(ctx context.Context, actor store.Principal, upstreamID, name string) (variant.Variant, error)
	Edit(ctx context.Context, actor store.Principal, id string, edit variant.Edit) (variant.Variant, error)
	Merge(ctx context.Context, actor store.Principal, id string, request variant.MergeRequest) (variant.Variant, error)
	Ignore(ctx context.Context, actor store.Principal, id, expectedVersion, upstreamID string) (variant.Variant, error)
	Delete(ctx context.Context, actor store.Principal, id, expectedVersion string) error
}
```

POST forms use `adminFormLimit(w, r, maxVariantFormBytes)` (`cloud_plan.go:99`: form-encoded, CSRF `csrfToken` = cookie) with `const maxVariantFormBytes = 512 << 10` (a 64 KiB body percent-encodes to at most 192 KiB). Each expected field must appear exactly once (else 400 `INVALID_REQUEST`); text areas go through `normalizeTextArea` (`item_create.go:232`). Success answers 303 with `Cache-Control: no-store`: customise, edit, merge and ignore to `/admin/library/variants/{id}`; delete to `/admin/library`.

**Content library page (`libraryTemplate`):**
- Lede: "Skills, agents, configs, MCP templates and prompts shipped with Leorna, and your company's variants of them. …" (keep every kind word: `TestLibraryPageIntroNamesEveryKind`).
- `libraryRow` gains `Variant bool`, `UpstreamName`, `UpstreamVersion`, `UpdateVersion string`, `NameClash bool`. A variant row: `<tr class="item variant" data-variant="{{.ID}}">`; the name links to `/admin/library/variants/{{.ID}}`; after the name `<span class="chip variant-chip">Company variant</span>`, then when `UpdateVersion` is set `<a class="chip update-chip" href="/admin/library/variants/{{.ID}}#update-notice">Update available: {{.UpdateVersion}}</a>`, then `<div class="muted variant-of">Based on {{.UpstreamName}} {{.UpstreamVersion}}</div>`, and with `NameClash` `<div class="muted name-clash">A shipped item now uses this name, so this variant can't be ticked here.</div>` and no Include checkbox and no `shown` field.
- Shipped rows are unchanged.

**Shipped item page (`libraryItemTemplate`):** `libraryItemPageData` gains `Customise *customiseSection` (set when variants are wired, the kind is customisable and the request has a valid CSRF cookie) and `NotCustomisable bool` (variants wired, kind is config or MCP template).

```html
<section id="customise" aria-labelledby="customise-title">
  <h2 id="customise-title">Customise for your company</h2>
  <p class="muted">Make your company's own copy of {{name}} {{version}} to edit. It keeps a link to this version, and when Leorna ships a newer one you can review the changes and merge or ignore them.</p>
  {{if .Error}}<p role="alert" class="alert" id="customise-error">{{.Error}}</p>{{end}}
  <form id="customise-form" method="post" action="/admin/library/items/{{id}}/customise">
    <input type="hidden" name="csrfToken" value="{{csrf}}">
    <label>Variant name <input type="text" name="name" value="{{.Name}}" maxlength="64" required pattern="[a-z0-9]+(-[a-z0-9]+)*"></label>
    <button type="submit">Customise</button>
  </form>
  {{if .Variants}}<p class="muted" id="your-variants">Your variants: {{range}}<a href="/admin/library/variants/{{id}}">{{name}} ({{version}})</a>{{end}}</p>{{end}}
</section>
```

`.Name` is `variant.DefaultName(item.Name)` on GET, or the submitted name after a refusal. With `NotCustomisable`: `<p class="muted" id="not-customisable">Configs and MCP templates can't be customised.</p>`.

**Variant page (`GET /admin/library/variants/{variantId}`), element ids the tests use:**
- `<p class="eyebrow">Company variant · {{KindLabel}}</p><h1>{{Name}}</h1>`; `<dl class="facts">`: `#variant-version` (version), `#variant-upstream` (`<a href="/admin/library/items/{{Base.ID}}">{{Base.Name}} {{Base.Version}}</a>`), category, tags, supported tools (Base's), `#variant-updated`.
- `<p role="alert" class="alert" id="variant-alert">` after a refused POST.
- **Notice** when `UpdateAvailable()`: `<section id="update-notice" class="notice" role="status" aria-labelledby="update-title"><h2 id="update-title">Update available: {{Latest.Name}} {{Latest.Version}}</h2><p>Your variant is based on {{Base.Version}}. Review what changed upstream, then merge it into your variant or ignore this version.</p>`, then `#upstream-diff` (below), then `#merge-preview` ("Merging is clean: your changes and upstream's don't touch the same lines." or "N conflict(s): both you and upstream changed the same lines. Merge opens them for you to resolve."), then `form#merge-form` (hidden `csrfToken`, `version` = current, `upstream_id` = Latest.ID; button "Merge {{Latest.Version}}") and `form#ignore-form` (same hidden fields; button "Ignore {{Latest.Version}}").
- **Ignored** when `UpdateIgnored()`: `<section id="update-ignored">` "Upstream {{Latest.Version}} is ignored. You can still review and merge it.", the diff in `<details>`, and `#merge-form`.
- **Upstream diff** `#upstream-diff`: Base → Latest. "Description" (only when it changed) and "Main text" as `textdiff.Diff` blocks, each `<pre class="diff"><code><span class="diff-hunk">@@ -a,b +c,d @@</span>\n` then one `<span class="diff-ctx"> {{text}}</span>`, `<span class="diff-del">-{{text}}</span>` or `<span class="diff-add">+{{text}}</span>` per line (`\ No newline at end of file` after a `NoNewline` line); then "Supporting files" `<ul id="upstream-files">` with `variant.FileChanges(Base.Files, Latest.Files)` as `<li>{{path}}: {{change}}</li>`. At most 2,000 shown lines per section, then "… N more lines not shown".
- **Resolver** (rendered by a refused merge with `ErrMergeConflict` or `ErrUnresolved`): `<section id="merge-conflicts">` "N conflict(s) with upstream {{Latest.Version}}. Each is between `<<<<<<< your variant` and `>>>>>>> upstream …` below: keep the lines you want, delete the marker lines, then save the merge." and `form#resolve-form` posting to `…/merge` with hidden `csrfToken`, `version`, `upstream_id`, `<textarea name="description">` (merged description; on a description conflict the company's, with "Upstream's description:" shown read-only beside it) and `<textarea name="body">` (`MergePreview.Body.Text` with markers; after `ErrUnresolved`, the submitted text).
- **Your changes** `#your-changes`: Base → variant diff (description and main text), or "No changes from {{Base.Name}} {{Base.Version}} yet."
- **Editor** `form#variant-edit-form` posting to `…/edit`: hidden `csrfToken`, `version`; `<textarea name="description">`, `<textarea name="body">`; button "Save as version {{next}}". For an agent, a note that the frontmatter name and description must match the fields (the item editor's rule).
- **Preview** `#variant-preview`: `renderBoundedItem(kind, body)` (`item_preview.go:179`), never `library.Item.Preview()` directly, with "Preview shown as plain text because the content is too large or complex" when it falls back.
- **Supporting files** `#variant-files` (skills): path list, read-only, "Supporting files come from {{Base.Name}} {{Base.Version}}."
- **Delete** `form#delete-form` posting to `…/delete` (hidden `version`): "Delete this variant. Pack versions that include it keep their copy; teams keep syncing it until you assign a version without it."

**POST error mapping (variant page and item page re-render with the alert; a failed re-read falls back to the problem):**

| Error | Status | Shown as |
| --- | --- | --- |
| `itembuilder.Issue` | 422 | alert with the issue text; submitted text kept |
| `variant.ErrNotCustomisable`, `ErrShippedName`, `ErrNothingChanged`, `ErrNoUpdate` | 400 | alert: "Only skills, agents and prompts can be customised." / "A shipped {{kind}} already uses this name. Choose another name." / "Nothing changed: edit the description or main text, then save." / "There is no newer upstream version to merge or ignore." |
| `variant.ErrNameTaken` | 409 | alert "Your company already has a {{kind}} variant named {{name}}. Choose another name." |
| `variant.ErrChanged` | 409 | alert "This variant changed since you opened it (now version X). Your text is below; review the latest version before saving again." |
| `variant.ErrUpstreamChanged` | 409 | alert "Upstream has a newer version (X). Review its changes, then merge again." (page from a fresh read) |
| `variant.ErrMergeConflict` | 409 | the resolver, prefilled; nothing saved |
| `variant.ErrUnresolved` | 422 | the resolver with the submitted text; alert "Remove every conflict marker line (<<<<<<< your variant and >>>>>>> upstream …) before saving the merge." |
| `gate.TenantSecretIssue` | 422 | alert `<issue>. Remove it before saving`; the named field is **cleared** (main body → body; description → description; anything else → both), as `item_create.go:186-198` does |
| `gate.ErrTenantSecret` (no detail) | 422 | alert "A suspected secret was found. Remove it before saving"; both cleared |
| `gate.TenantRenderIssue` / `gate.ErrTenantRender` | 422 | alert with the issue |
| `org.ErrForbidden` | 403 | problem `FORBIDDEN` |
| `store.ErrNotFound` | 404 | problem `NOT_FOUND` "The requested variant is unavailable" (item page: "The requested library item is unavailable") |
| anything else (scanner unavailable, database) | 503 | alert "The content scanner or variant store is unavailable; nothing was saved"; text cleared |

GET errors: 403/404 as above, others 500 `VARIANTS_FAILED` via `writeProblem` (trace id, no detail).

### D8. Auth and tenant isolation

| Layer | Rule | Proof |
| --- | --- | --- |
| Route | session + current admin (`requireAdmin`); GETs redirect signed-out visitors to sign-in, POSTs answer 401 | AC4 member/signed-out subtests |
| CSRF | every POST via `adminFormLimit` | AC4 bad-CSRF subtest |
| Store reads | `beginOrg(false)` (a current user of the tenant) and `WHERE v.tenant_id = $1` in every query | AC4 other-tenant subtest; store test |
| Store writes | `beginOrg(true)` re-checks admin inside the transaction; `WHERE tenant_id=$1 AND id=$2` on lock, update and delete | store test (member principal straight at the store → `org.ErrForbidden`) |
| Pack builder | variant ids resolve only `WHERE tenant_id = $2`; another company's id = unknown id (400, same message) | AC4 + `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` |
| Not found vs forbidden | unknown, malformed and other-tenant variant ids are 404, never 403 | AC4 |
| Content | every saved text passes `itembuilder` rules and `gate.CheckTenantItem` (renders + gitleaks); a finding is never echoed; the preview is bounded | AC4 secret subtest; `TestVariantPagePreviewIsBoundedWithPostgres` |
| Library rows | shared, never written by this story; variants reference them | AC1 (checksum unchanged) |

### D9. OpenAPI and the client

- `contracts/control-plane.openapi.yaml`: description-only changes. `createPack` summary: "Create a pack at version 1 holding exactly the given content library items or company variants". `PackCreate.libraryItemIds` description: "Content library item ids or ids of this company's variants (story 86bcm901z). Version 1 lists the items in this order." `PackVersionChange.addLibraryItemIds` gains description "Content library item ids or ids of this company's variants to add, in this order." Field names, types and bounds are unchanged.
- Regenerate with `make generate` (`packages/contracts/controlplane.gen.go` comments change); `make contracts-check` must pass. Save `git diff "$BASE" -- contracts packages/contracts` as `$EVID/contract-diff-<sha7>.txt` and classify it in EVIDENCE.md as "behavioural, additive: the same fields accept more ids; no breaking change".
- **Client:** no change, no regeneration. `leorna-client` keeps its own copy at `api/control-plane.openapi.yaml`, which has no `/v1/packs` operations (`git -C ~/Leorna/leorna-client grep -c libraryItemIds -- api/` → no match at `f105e27`). The desktop receives a variant inside a pack version's bundle exactly like any other item (kind, name, version, files). No cross-repo import (`scripts/verify-workspace.sh` gate).

### D10. Wiring (`cmd/control-plane/main.go`)

After `application.SetItemBuilder(…)` (line 188): `application.SetVariants(variant.NewService(repository, gate.NewGitleaks("gitleaks")))`. Like the item editor, customise and every save need `gitleaks` on `PATH` (the container has it; `make run` needs it locally); without it they answer 503 and save nothing.

## Tests

All Postgres tests need `LEORNA_TEST_DATABASE_URL` (a disposable database whose name ends in `_test`) and `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks` (the web tests wire `gate.NewGitleaks(bin)` with `gitleaks` as the fallback, as `item_create_integration_test.go:26` does). AC tests live in `internal/web/library_variants_test.go` (AC1, AC2, AC4) and `internal/web/library_variants_packs_test.go` (AC3).

**Fixtures (new, in `library_variants_test.go`):**
- `newVariantFixture(t)` = `newPackFixture(t, …)` with `SetLibrary(repository)`, `SetPackBuilder(pack.NewBuilderService(repository))`, `SetPackVersions(pack.NewVersionService(repository))` and `SetVariants(variant.NewService(repository, gate.NewGitleaks(bin)))`; returns the fixture, `scoped` context, an admin client, a member client and an other-tenant admin client.
- `variantLibraryItem(kind, name, version, description, body string, files ...library.SupportFile) library.Item` (category `operations`, tags `incidents`, all three tools, example `"Use " + name + ".\n"`).
- Handbook texts (upstream skill `team-handbook`):
  - `handbookV1 = "# Team handbook\n\nShare the incident channel.\nPage the on-call engineer.\nWrite the timeline.\nList the action items.\nReview the alerts.\nClose the incident.\n"`, file `references/checklist.md` = `"# Checklist\n\nFILE-MARKER-checklist\n"`;
  - `handbookV2` (1.1.0) = V1 with `Write the timeline.` → `Write the timeline in UTC.` and `Hold the review within five days.\n` appended; files: the checklist plus `references/timeline.md` = `"# Timeline\n"`;
  - `handbookV3` (1.2.0) = V2 with `Review the alerts.` → `Review the alerts and dashboards.`.
- Helpers: `customise(t, client, libraryID, name) (variantID string)` (POST, expect 303, id from `Location`), `editVariant(t, client, id, version, description, body) *http.Response`, `variantPage(t, client, id, want int) string`, `variantRow(t, pool, id) variantRowState` (version, upstream_item_id, ignored, sha256 of description+body+files), `variantAudit(t, pool, target) []auditRow`, `tableCounts(t, pool)` (library_variants, audit_records, pack_versions, pack_version_items).
- Scope HTML assertions to the element (`fragment`, `ddByID`, `libraryRowFor` from `library_test.go`), never whole-body `Contains`; decode JSON strictly (`decodeStrict`).

### AC1 — `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`

Run: `go test -v -count=1 -run '^TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres$' ./internal/web`

Library rows: `skill/team-handbook@1.0.0` (handbookV1 + checklist) and `@1.1.0` (handbookV2 + both files); `agent/review-buddy@1.0.0` (body `"---\nname: review-buddy\ndescription: Review buddy description.\n---\n\n# Review buddy\n\nReview the diff.\n"`, description `Review buddy description.`); `prompt/ship-notes@1.0.0`; `config/codex-defaults@1.1.0`.

Subtests:
1. `the_item_page_offers_customise_for_skills_agents_and_prompts`: `#customise-form` on the skill, agent and prompt pages with action `/admin/library/items/<id>/customise`, a `csrfToken` field and `name` value `team-handbook-custom` (etc.); the config page has `#not-customisable` and no `#customise-form`.
2. `customising_creates_a_tenant_owned_variant_linked_to_the_upstream_item_and_version`: customise `team-handbook@1.1.0` as `team-handbook-acme` → 303 to `/admin/library/variants/<uuid>`. The row: `tenant_id` = admin's tenant, kind `skill`, version `1.0.0`, `upstream_item_id` = the 1.1.0 row id, description, body and files equal that row's (compare the decoded `files`), `ignored_upstream_version` NULL. The page: `#variant-version` = `1.0.0`, `#variant-upstream` links `/admin/library/items/<1.1.0 id>` with text `team-handbook 1.1.0`, `#variant-files` lists both paths, no `#update-notice`.
3. `the_library_lists_the_variant_with_its_upstream`: `/admin/library` has the shipped row (unchanged) and a `tr.variant` row for `team-handbook-acme` linking `/admin/library/variants/<id>`, with `Company variant` and `Based on team-handbook 1.1.0`; the other tenant's `/admin/library` has no variant row.
4. `an_agent_variant_takes_its_new_name_in_its_frontmatter`: customise `review-buddy` as `review-buddy-custom` → body = upstream body with the line `name: review-buddy` replaced by `name: review-buddy-custom`, every other byte equal.
5. `a_prompt_can_be_customised`: `ship-notes` → `ship-notes-custom` created.
6. `customising_an_older_version_links_that_version`: customise `team-handbook@1.0.0` (its page by id) as `team-handbook-legacy` → `upstream_item_id` = the 1.0.0 row; its page shows `#update-notice` naming `1.1.0` (lineage keeps the exact version).
7. `the_shipped_row_is_unchanged_and_each_customise_is_audited`: every `library_items.content_sha256` equals its value before the subtests; one `library.variant.create` record per variant, target = variant id, before `null`, after keys exactly `variantId, kind, name, version, upstreamId, upstreamName, upstreamVersion`, values matching; no record's JSON contains a body line (`Share the incident channel`).

**Old-code check:** on base `b65f797` the test file does not build (`undefined: variant`, `(*Handler).SetVariants undefined`), so `go test` exits non-zero. Behaviourally, base answers `POST /admin/library/items/{id}/customise` with 405 (the `GET /` catch-all, `internal/web/handler.go:319`) and `GET /admin/library/variants/{id}` with 303 to `/admin`.

**Evidence:** log `ac1-<sha7>.log`; screenshot **`ac1-variant-created.png`** (the variant page with its lineage); extras `ac1-item-page-before-<base7>.png` (E0, base binary: no Customise section), `ac1-customise-form.png`, `ac1-library-lists-variant.png`.

### AC2 — `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`

Run: `go test -v -count=1 -run '^TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres$' ./internal/web`

Setup: library row `team-handbook@1.0.0` only. Customise three variants: `team-handbook-acme` (then edit `Share the incident channel.` → `Share the incident channel and the status page.`, version 1.1.0), `team-handbook-ops` (unedited), `team-handbook-clash` (edit `Write the timeline.` → `Write the timeline in local time.`, version 1.1.0).

Subtests:
1. `no_notice_while_upstream_has_no_newer_version`: no `#update-notice`, no `update-chip` on the library rows.
2. `a_newer_upstream_version_shows_the_notice_with_its_diff`: `insertLibraryItems` `team-handbook@1.1.0` (handbookV2). Library rows of all three variants carry `Update available: 1.1.0`. `team-handbook-acme`'s page: `#update-title` = `Update available: team-handbook 1.1.0`; the notice says `based on 1.0.0`; `#upstream-diff` holds `<span class="diff-del">-Write the timeline.</span>`, `<span class="diff-add">+Write the timeline in UTC.</span>` and `<span class="diff-add">+Hold the review within five days.</span>`, and `#upstream-files` lists `references/timeline.md: added`; `#merge-preview` says clean. `team-handbook-clash`'s `#merge-preview` says `1 conflict`.
3. `merge_keeps_the_company_edit_and_takes_upstreams_changes`: POST `#merge-form` of `team-handbook-acme` (`version=1.1.0`, `upstream_id`=1.1.0 row) → 303. Row: version `1.2.0`, `upstream_item_id` = 1.1.0 row, body = handbookV2 with the company's line (`Share the incident channel and the status page.`), files = the 1.1.0 row's. Page: no `#update-notice`, `#variant-upstream` = `team-handbook 1.1.0`, `#your-changes` shows only the company's line. One `library.variant.merge` record: before `{version 1.1.0, upstreamVersion 1.0.0}`, after `{version 1.2.0, upstreamVersion 1.1.0}`, keys as AC1's, no body text.
4. `ignore_hides_the_notice_until_a_newer_version_ships`: POST `#ignore-form` of `team-handbook-ops` → 303. Row: `ignored_upstream_version` = `1.1.0`, version and content hash unchanged. Page: no `#update-notice`, `#update-ignored` names 1.1.0 and still has `#merge-form`; library row has no `update-chip`. One `library.variant.ignore` record. A second identical POST → 303, no new record. Then `insertLibraryItems` `team-handbook@1.2.0` (handbookV3): `team-handbook-ops` shows `#update-notice` for `1.2.0` again, and so does `team-handbook-acme` (based on 1.1.0).
5. `a_conflicting_merge_saves_nothing_and_opens_the_resolver`: POST merge of `team-handbook-clash` (`upstream_id` = 1.2.0 row) → 409; `#merge-conflicts` says `1 conflict`; `#resolve-form`'s body textarea contains `<<<<<<< your variant`, `Write the timeline in local time.`, `=======`, `Write the timeline in UTC.` and `>>>>>>> upstream team-handbook 1.2.0`; row and audit count unchanged. POST the resolution with the markers left in → 422 alert, nothing written. POST the resolution with `Write the timeline in local time (UTC in the record).` and no markers → 303: version `1.2.0`, based on the 1.2.0 row, body = handbookV3 with that line, no `#update-notice`, one `library.variant.merge` record.

**Old-code check:** the file does not build on base (same undefined symbols); base has no variant page (303 to `/admin`).

**Evidence:** log `ac2-<sha7>.log`; screenshot **`ac2-update-available.png`** (real console: the notice with its diff, after the release-B restart); extras `ac2-no-update-before.png`, `ac2-library-update-chip.png`, `ac2-after-merge.png`, `ac2-after-ignore.png`, `ac2-merge-conflict.png`, and `release-b-<sha7>.txt` (the release-B patch, its lock line, its two library test results and the server log line "content library loaded … added 1").

### AC3 — `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`

Run: `go test -v -count=1 -run '^TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres$' ./internal/web`

Fixture: `newPackSyncFixture(t)` (`internal/web/pack_items_test.go:155`: library rows A–D and F, a team with the admin, a project, a real desktop token) plus `SetVariants(…)`, plus library row `skill/team-handbook@1.0.0` (handbookV1 + checklist). Customise it as `team-handbook-acme` (V) and edit the body to append `VARIANT-MARKER-acme\n` (V is `1.1.0`).

Subtests:
1. `the_library_page_lists_the_variant_with_an_include_checkbox`: in builder mode, V's row has `<input type="checkbox" name="item" value="<V>" form="pack-builder"`.
2. `console_create_takes_a_ticked_variant_like_a_library_item`: POST `/admin/library/packs` `name=Variant pack`, `item=[A, V]` → 303; `GET /v1/packs/<id>` lists `skill/code-review-checklist` and `skill/team-handbook-acme` in that order, V at version `1.1.0`; its `pack_version_items` row's description, body (contains the marker) and files equal V's; the `pack.create` audit's `diff.added` names `{skill, team-handbook-acme, 1.1.0}`.
3. `the_json_api_takes_a_variant_id_in_both_id_lists`: `POST /v1/packs` `{"name":"API pack","libraryItemIds":["<V>"]}` → 201 with V's item; on another pack, `POST /v1/packs/<id>/versions` `{"parentVersion":…,"addLibraryItemIds":["<V>"]}` → 201 with V added.
4. `untick_and_tick_remove_and_add_the_variant`: on "Variant pack"'s edit view V's row is ticked with `in pack`; untick it (all rows `shown`) and save → version 2 without V, `diff.removed` names V; tick it and save → version 3 with V, `diff.added` names V.
5. `move_and_remove_buttons_treat_the_variant_like_any_item`: `move_up` on V's item (901y form `POST /admin/library/packs/<id>/items`) → version 4 with V first; `remove` on V → version 5 without V, then tick and save → version 6 with V.
6. `an_assigned_pack_syncs_the_variant_to_engineers`: assign version 6 to the team (`s.assign`) → the bundle (`s.synced`) has `skill/team-handbook-acme` and `skill/team-handbook-acme/references/checklist.md` in its lockfile; the content (`s.content(digest, 200)`) carries `VARIANT-MARKER-acme` and `FILE-MARKER-checklist`.
7. `an_edited_variant_reaches_a_pack_only_when_added_again`: edit V again (version `1.2.0`) → the edit view shows `in pack (1.1.0)` on V's row; the synced lockfile digest is unchanged; untick + save, then tick + save → the pack holds V at `1.2.0` (as a shipped item's newer version does).
8. `deleting_the_variant_keeps_every_pack_version`: delete V → every `pack_versions`/`pack_version_items` row is unchanged (count and an md5 over their content columns before and after); the edit view lists V's item with `not in the library`; the synced digest is unchanged; `addLibraryItemIds:[V]` now → 400 `INVALID_PACK`.

**Old-code check:** the file does not build on base. Behaviourally, on base a variant id in `libraryItemIds` is an unknown library id → 400 `INVALID_PACK`.

**Evidence:** log `ac3-<sha7>.log`; screenshot **`ac3-pack-with-variant.png`** (real console: the pack's edit view listing the variant as an item); extras `ac3-library-before-<base7>.png` (E0), `ac3-variant-ticked-before-save.png`, `ac3-variant-moved-up.png`, and `ac3-sync-terminal.png` (terminal capture of the AC3 run: command, the 8 subtest PASS lines, `EXIT=0`).

### AC4 (proposed) — `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`

Run: `go test -v -count=1 -run '^TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres$' ./internal/web`

Setup: library rows `team-handbook@1.0.0`, `config/codex-defaults@1.1.0`, `mcp_template/github-mcp@2.0.0`; the admin customises V = `team-handbook-acme`; the other tenant's admin has a client. Every subtest records `tableCounts` and V's `variantRow` before and checks them unchanged after.

Subtests:
1. `a_member_cannot_see_or_change_variants`: member GET V's page → 403; POST customise, edit, merge, ignore, delete → 403.
2. `signed_out_visitors_are_sent_to_sign_in`: GET V's page with no session → 302 to `/v1/auth/google/login…`; POST edit → 401.
3. `a_bad_csrf_token_is_refused`: each of the five POSTs with a wrong `csrfToken` → 403 `CSRF_REJECTED`.
4. `another_company_cannot_read_change_or_pack_the_variant`: other admin: GET V's page → 404; POST edit, merge, ignore, delete → 404; their `/admin/library` has no V row; `POST /v1/packs` with `libraryItemIds:[V]` → 400 `INVALID_PACK`; their console create form with `item=V` → 400; no pack, version or audit record for either tenant.
5. `configs_and_mcp_templates_cannot_be_customised`: POST customise on each → 400 with the alert.
6. `names_must_be_new_slugs`: `team-handbook-acme` again → 409 alert; `team-handbook` (a shipped skill name) → 400 alert; `Bad Name` and an empty name → 422 alert with the slug message; 65 characters → 422.
7. `stale_and_unchanged_edits_are_refused`: edit with `version=0.9.0` → 409 alert; edit with the current text → 400 "Nothing changed".
8. `a_suspected_secret_is_refused_and_never_echoed`: edit with body + `"github_token = " + token`, where `token` is built at run time as `"ghp_"` + 36 characters from `bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ0123456789` (as `scanCanary`, `internal/library/gate/scan.go:234`; never a literal in the file) → 422, alert contains `suspected secret in main body`, the page does not contain `token`, the body textarea is empty.
9. `merge_and_ignore_need_a_newer_upstream_version`: with no newer row, merge → 400, ignore → 400; then `insertLibraryItems` `team-handbook@1.1.0` and merge or ignore with `upstream_id` = the 1.0.0 row → 409.
10. `unknown_and_malformed_ids_are_not_found`: GET `/admin/library/variants/<random uuid>` and `/admin/library/variants/not-a-uuid` → 404; customise on a random library id → 404.

**Old-code check:** the file does not build on base. Behaviourally, base has none of these routes (405/303).

**Evidence:** log `ac4-<sha7>.log`; screenshot **`ac4-refused-terminal.png`** (terminal capture: command, every subtest PASS, `EXIT=0`); extra real console capture `ac4-name-taken-alert.png`.

### Supporting tests (Verify line: "unit tests for variant lineage + upstream-diff")

`internal/textdiff/textdiff_test.go` (no database):
- `TestDiffShowsChangedLinesWithThreeLinesOfContext` (one change in a 12-line text → one block, `@@ -3,7 +3,7 @@`, three context lines each side);
- `TestDiffOfEqualTextsIsEmpty`;
- `TestDiffSplitsFarApartChangesIntoBlocks` (changes 10 lines apart → two blocks);
- `TestDiffMarksALastLineWithoutNewline`;
- `TestDiffFallsBackToOneBlockAboveTheCellLimit` (two 1,100-line texts differing in every line → one block of 1,100 `-` and 1,100 `+` lines);
- `TestMerge3TakesSeparateChangesFromBothSides` (the hand-traced case);
- `TestMerge3ConflictsWhenBothSidesChangeTheSameLines` (exact text with markers and label; `Conflicts[0].BaseStart`);
- `TestMerge3TakesIdenticalChangesOnce`;
- `TestMerge3ConflictsOnAdjacentChanges`;
- `TestMerge3InsertsAtStartAndEnd`;
- `TestMerge3EndsAConflictAtTheLastLineWithANewline` (base and both sides lack a final newline);
- `TestHasConflictMarkersIgnoresASetextUnderline` (`"Title\n=======\n"` → false; `MarkerOurs` line → true; `MarkerTheirs + " x"` → true).

`internal/variant/variant_test.go` (no database; a fake `Store` and a fake `gate.Scanner`):
- `TestDraftKeepsTheUpstreamContentAndRecordsItsVersion`;
- `TestDraftRenamesAnAgentInItsFrontmatterOnly`;
- `TestDraftRefusesConfigsAndMCPTemplates`;
- `TestDefaultNameFitsTheNameRules` (a 64-character upstream name → ≤ 64, valid slug, ends in `-custom`);
- `TestNextVersionBumpsTheMinor`;
- `TestUpdateAvailableUnlessThatVersionIsIgnored`;
- `TestPreviewMergeMergesDescriptionAndBody` (description: ours-only, theirs-only, both-same, both-different);
- `TestFileChangesListsAddedRemovedAndChangedPaths`;
- `TestServiceCustomiseRefusesConfigsBeforeTheStore` (the fake store would accept anything; the service must refuse first);
- `TestServiceRefusesStaleEditsAndMerges` (`ErrChanged`, `ErrNoUpdate`, `ErrUpstreamChanged`, `ErrMergeConflict`, `ErrUnresolved`; the fake store records no save);
- `TestServiceRunsTheSecretGateBeforeEverySave` (a scanner with one finding → `gate.ErrTenantSecret` from Customise, Edit and Merge; no store write);
- `TestEveryShippedSkillAgentAndPromptCanBeCustomised`: for every `library.Embedded()` item of a customisable kind, `Draft(upstreamOf(item), DefaultName(item.Name))` then `itembuilder.DraftIssues` is empty (the planner checked the four shipped agents' frontmatter: only `name` and `description`, matching their `item.json`). If one fails, don't change the content: report it in `found_else` and list it in the test's `knownRefusals` map with its exact issue text, so the console's refusal is pinned.

`internal/store/postgres/library_variants_test.go` (real Postgres, `seedBaseStore`-style fixture):
- `TestLibraryVariantsStoreWithPostgres` subtests: create and read back (lineage, content, `FirstVersion`); list sorted, metadata only; another tenant's actor → `store.ErrNotFound` on get, save, ignore, delete and is absent from its list; a member principal → `org.ErrForbidden` on every write; duplicate name → `ErrNameTaken`; shipped name → `ErrShippedName`; a config upstream straight at `CreateVariant` → `ErrNotCustomisable`; save bumps and keeps the base; merge moves the base and clears the ignore; merge with a stale upstream id → `ErrUpstreamChanged`; ignore once (audit), twice (no second audit); delete; `DELETE FROM library_items WHERE id=<base>` → 23503; inserting a row with kind `config` directly → 23514; each write's audit record shape.
- `TestVariantUpdateAppearsAfterTheNextLibraryLoadWithPostgres`: `loadLibrary(ctx, libA)` (a two-item `library.Library` built in the test and passing `Validate`), customise, `GetVariant` → `Latest.ID == Base.ID`; `loadLibrary(ctx, libB)` (one item bumped) → `Latest.Version` is the new version and `UpdateAvailable()`.
- `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres`: `CreatePack` with the tenant's own variant id → its content copied; with another tenant's variant id → `org.ErrInvalid`, nothing written.
- Existing `TestMigrationRoundTrip` with `library_variants` added to both lists.

`internal/web` (real Postgres unless noted):
- `TestVariantPagePreviewIsBoundedWithPostgres`: a variant whose body has 2,100 `[` characters renders `#variant-preview` as `<pre><code>` escaped text with the plain-text note (kills a switch to the unbounded `Item.Preview`).
- `TestVariantNameClashWithALaterShippedItemIsNotTickableWithPostgres`: customise, then `insertLibraryItems` a shipped skill with the variant's name → the variant row has `name-clash` and no checkbox; a forged edit form that ticks it → 400 "The form no longer matches the library".
- `TestLibraryPageWithAFailingVariantServiceAnswers500` (no database: a fake catalog and a failing fake `variantService`) → 500 `LIBRARY_FAILED` with a trace id.

## Mutation checks (builder, `mutation-testing-discipline`; `go test -overlay`, never editing the real file)

| # | Mutant | Must be killed by |
| --- | --- | --- |
| M1 | `variantSelect` without `v.tenant_id = $1` (make it `true`) | AC4 `another_company_cannot_read_change_or_pack_the_variant`; store test |
| M2 | `loadCatalogItems` without `tenant_id = $2` | AC4 subtest 4; `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` |
| M3 | `CreateVariant` with `beginOrg(…, false)` | store test (member → `org.ErrForbidden`) |
| M4 | `SaveVariant` skips the expected-version check | AC4 `stale_and_unchanged_edits_are_refused` (with the service check also overlaid off); `TestServiceRefusesStaleEditsAndMerges` for the service check alone |
| M5 | `SaveVariant` skips the merged-upstream-is-newest check | store test (stale upstream id) |
| M6 | `CreateVariant` skips the shipped-name check | AC4 `names_must_be_new_slugs` |
| M7 | service `Customisable` always true | `TestServiceCustomiseRefusesConfigsBeforeTheStore` (the store backstop survives at the web level by design: name it an equivalent there) |
| M8 | store `Customisable` check removed | store test (config upstream) |
| M9 | `Service.check` skips `gate.CheckTenantItem` | AC4 secret subtest; `TestServiceRunsTheSecretGateBeforeEverySave` |
| M10 | the web secret alert keeps the submitted body | AC4 secret subtest |
| M11 | `HasConflictMarkers` returns false | AC2 subtest 5; `TestHasConflictMarkersIgnoresASetextUnderline` |
| M12 | `Merge3` takes ours on a two-sided region | `TestMerge3ConflictsWhenBothSidesChangeTheSameLines`; AC2 subtest 5 |
| M13 | `UpdateAvailable` ignores `IgnoredVersion` | AC2 subtest 4; unit test |
| M14 | variant page uses `library.Item{…}.Preview()` instead of `renderBoundedItem` | `TestVariantPagePreviewIsBoundedWithPostgres` |
| M15 | `DeleteVariant`'s `DELETE` without the tenant filter | AC4 subtest 4 (row still there) |
| M16 | `catalogEntries` ignores `NameClash` | `TestVariantNameClashWithALaterShippedItemIsNotTickableWithPostgres` |
| M17 | `CreateVariant` stores the newest row's id instead of the chosen one | AC1 `customising_an_older_version_links_that_version` |
| M18 | migration kind CHECK also allows `config` (SQL, edit in place, restore from saved bytes) | store test (23514) |

Record each mutant's id, overlay, the killing test's FAIL line and the restored PASS in `$EVID/mutations-<sha7>.txt`; count by distinct id.

## Host prerequisites (checked 2026-10-29 19:15 UTC on this WSL desktop)

| Tool | Result |
| --- | --- |
| `go` | not on `PATH`; `~/.local/leorna-toolchain/go/bin/go` = go1.27.3 (= `go.mod`) |
| `make` | `/usr/bin/make` |
| `gcc` | `/usr/bin/gcc` 15.2.0; with the toolchain's go, `go env CGO_ENABLED` = 1 (so `-race` works) |
| `golangci-lint` | not on `PATH`; `~/.local/leorna-toolchain/bin/golangci-lint` 2.14.0 = CI pin (`.github/workflows/ci.yml:125`) |
| `govulncheck` | not on `PATH`; `~/.local/leorna-toolchain/bin/govulncheck` v1.7.0 = CI pin (`ci.yml:139`) |
| `gitleaks` | `/usr/local/bin/gitleaks` 8.30.1 = CI |
| `docker ps` | `leorna-test-pg` up, `127.0.0.1:55432->5432` (use this one); `leorna-pg` on 5432 belongs to something else: never touch it |
| `psql` | missing on the host; use `docker exec leorna-test-pg psql …` |
| Chrome for Testing | `~/.cache/chrome-for-testing/chrome-linux64/chrome` (156) and `~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` |

Nothing is missing, so there is no host question.

## Tasks (builder, test-first)

Scratch: keep scratch in your own fresh `<scratchpad>/86bcm901z-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries, detached copies) go to `~/.cache/86bcm901z-<role>/`.

Common variables (set once per shell; never print the DB URL or password):

```bash
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item
BASE=b65f797ff6cdc56a802dfaf417b0adec96463317     # re-check in B0
SCR=<scratchpad>/86bcm901z-builder                  # mkdir "$SCR" (no -p): small files only
C=$HOME/.cache/86bcm901z-builder                    # mkdir "$C": TMPDIR, Chrome profile, binaries, detached copies
EVID=~/.hermes/plans/leorna/evidence/86bcm901z
TOOLS=$HOME/.local/leorna-toolchain
export PATH="$TOOLS/go/bin:$TOOLS/bin:/usr/local/bin:/usr/bin:/bin" GOTOOLCHAIN=local
export TMPDIR="$C/tmp" GOTMPDIR="$C/tmp"
export GOLANGCI_LINT="$TOOLS/bin/golangci-lint" GOVULNCHECK="$TOOLS/bin/govulncheck" GITLEAKS=/usr/local/bin/gitleaks
export LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
PGPW=$(/usr/bin/docker exec leorna-test-pg printenv POSTGRES_PASSWORD); [ -n "$PGPW" ] || { echo "empty leorna-test-pg password"; exit 1; }
PGPORT=$(/usr/bin/docker port leorna-test-pg 5432 | head -1 | sed 's/.*://')   # 55432 here; never hard-code 5432
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/leorna_86bcm901z_test?sslmode=disable"
```

Save this as `$EVID/env.sh.txt` (the password stays a command, never a literal).

**Databases** (in `leorna-test-pg`, created with `docker exec leorna-test-pg psql -U leorna -d leorna_test -c 'CREATE DATABASE <name>'`, dropped with `DROP DATABASE <name> WITH (FORCE)` when the role ends): builder `leorna_86bcm901z_test`; base baseline `leorna_86bcm901z_base_test`; console demo `leorna_86bcm901z_demo_test`; later roles `leorna_86bcm901z_<role>_test` and `leorna_86bcm901z_<role>_base_test`. Keep the builder DB until the main session says the story is done.

Never touch another story's database, worktree (`.claude/worktrees/86bcm901{a,b,j,r,w,y}-*`, `86bcm902a-*`), branch or evidence folder. Run workspace gates from the worktree or a detached copy, never the main checkout (`scripts/verify-workspace.sh:26` would see the sibling worktrees' modules).

### B0. Worktree and environment (stop conditions in bold)

1. Main checkout: `git -C ~/Leorna/leorna-control-plane status --porcelain --untracked-files=no` must be empty (**else stop**). Fetch GitHub `main` (`git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, URL written out), `git -C ~/Leorna/leorna-control-plane merge --ff-only origin/main` (**if it refuses, stop**; on a lock error wait a few seconds and retry once; never delete a lock file), record `git rev-parse main origin/main` (equal).
2. If `origin/main` ≠ `b65f797`: `git diff --name-only b65f797 origin/main`. If it touches `internal/web/library.go`, `internal/web/pack_builder.go`, `internal/store/postgres/pack_builder.go`, `internal/library/catalog.go` or `contracts/`, **stop and report the list** (a sibling such as 902a or 901r merged and the plan's line numbers may move). Otherwise set `BASE` to the new SHA, record it in `$EVID/base.txt`, and take the next free migration number (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | tail -1`); say so.
3. `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm901z-customise-shipped-item "$WT" "$BASE"`; then `git -C "$WT" status --porcelain` is empty and `git -C "$WT" rev-parse HEAD` = `$BASE`.
4. `mkdir "$SCR" "$C" "$C/tmp"`; `mkdir -p "$EVID"`; create the builder DB.
5. Echo `go version`, `"$GOLANGCI_LINT" --version`, `"$GOVULNCHECK" -version`, `gitleaks version`, `go env CGO_ENABLED` and `docker ps --format '{{.Names}} {{.Ports}}' | grep leorna-test-pg` into `$EVID/tools.txt`: go1.27.3, 2.14.0, v1.7.0, 8.30.1, 1, port 55432. **Stop if any differs.** Append `make -n -s lint audit secrets` run in `$WT` (shows the bound binaries).

### B0.5. Base baseline (detached copy, own DB)

`git -C "$WT" worktree add --detach "$C/base-tree" "$BASE"`; with `LEORNA_TEST_DATABASE_URL` on `leorna_86bcm901z_base_test`, run `make check` and `bash ./scripts/test-module-add.sh` there; record both `EXIT=` lines in `$EVID/baseline-<base7>.txt` (expected 0 and 0; a failure is a baseline fact, compared later by test identity). Keep `$C/base-tree` for E0, then `git -C "$WT" worktree remove --force "$C/base-tree"`.

### E0. Before-state captures (base binary, before any code change)

Follow "Evidence capture" with `-mode base` on a binary built from `$C/base-tree`: `ac1-item-page-before-<base7>.png` (`/admin/library/items/<incident-postmortem id>`: no Customise section) and `ac3-library-before-<base7>.png` (`/admin/library` in builder mode: no variant rows). Look at both.

### B1. `internal/textdiff`

1. **RED:** write `internal/textdiff/textdiff_test.go` (the twelve tests above, with exact expected strings). `go test -count=1 ./internal/textdiff` → build failure (`undefined: Diff`, `Merge3`, …).
2. **GREEN:** D3's `textdiff.go`. Rerun; all pass. `go vet ./internal/textdiff`.
3. Commit `feat(86bcm901z): add a bounded line diff and three-way merge` (explicit files).

### B2. Variant domain (pure)

1. **RED:** `internal/variant/variant_test.go` with the pure tests (`TestDraft…`, `TestDefaultName…`, `TestNextVersion…`, `TestUpdateAvailable…`, `TestPreviewMerge…`, `TestFileChanges…`, `TestEveryShippedSkillAgentAndPromptCanBeCustomised`). Build fails.
2. **GREEN:** D4's `variant.go` and `draft.go`. `go test -count=1 ./internal/variant`.
3. Commit `feat(86bcm901z): variant domain: draft, versions and merge preview`.

### B3. Migration 25 and the store

1. **RED:** `internal/store/postgres/library_variants_test.go` with `TestLibraryVariantsStoreWithPostgres` (all subtests) and `TestVariantUpdateAppearsAfterTheNextLibraryLoadWithPostgres`; add `library_variants` to `TestMigrationRoundTrip`'s two lists and to `resetDatabase`. `go test -count=1 -run 'TestLibraryVariantsStore|TestVariantUpdateAppears|TestMigrationRoundTrip' ./internal/store/postgres` → build failure, then (after a stub) `relation "library_variants" does not exist`.
2. **GREEN:** the two migration files (D2) and `library_variants.go` (D5). Rerun; then the whole package `go test -count=1 ./internal/store/postgres` (other tests unchanged).
3. **Real fill (backend-data-migrations):** on a throwaway `_test` DB filled from the base code (a `go test -overlay` probe with no cleanup that applies 1–24 and inserts library rows, a pack and a tenant), apply 25 with the real runner, check every existing row is unchanged (md5 over `library_items`, `pack_versions`, `pack_version_items` before/after), then run the 25 down file plus `DELETE FROM schema_migrations WHERE version=25` in one `docker exec … psql --single-transaction`, and apply again. Log `$EVID/migration-fill-<sha7>.log`.
4. Commit `feat(86bcm901z): store company variants (migration 25)`.

### B4. Variant service

1. **RED:** the service tests (`TestServiceCustomiseRefusesConfigsBeforeTheStore`, `TestServiceRefusesStaleEditsAndMerges`, `TestServiceRunsTheSecretGateBeforeEverySave`) with a fake `Store` and fake scanners. Build fails.
2. **GREEN:** D4's `service.go`. `go test -count=1 ./internal/variant`.
3. Commit `feat(86bcm901z): customise, edit, merge, ignore and delete variants`.

### B5. Pack builder resolves variant ids

1. **RED:** `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` (in `library_variants_test.go`). Fails: the own variant's id is refused as unknown.
2. **GREEN:** D6's `loadCatalogItems` and the comment updates. Rerun, then `go test -count=1 -run 'TestPackBuilder|TestPackItem' ./internal/store/postgres ./internal/web` (901w/901y suites stay green).
3. Commit `feat(86bcm901z): packs copy a company's own variants like library items`.

### B6. Console: customise and the variant page (AC1)

1. **RED:** fixtures and AC1's test (all 7 subtests). Run AC1's command → build failure (`undefined: variant`…, `SetVariants`). Save `$EVID/red-ac1.log`.
2. **GREEN:** `Handler.variants`, `SetVariants`, the routes (D7), `catalogEntries`, the library row changes, the item page's Customise section, `libraryCustomiseForm`, `variantView` with facts, files, preview (bounded) and "your changes", and the error mapping. Rerun AC1 → PASS; then `go test -count=1 -run 'TestLibrary' ./internal/web` (catalog tests unchanged, incl. `TestLibraryPageIntroNamesEveryKind`).
3. Add AC4's `configs_and_mcp_templates_cannot_be_customised`, `names_must_be_new_slugs` and `unknown_and_malformed_ids_are_not_found` subtests here (RED against a deliberately missing check, then GREEN), plus `TestVariantPagePreviewIsBoundedWithPostgres` and `TestLibraryPageWithAFailingVariantServiceAnswers500`.
4. Commit `feat(86bcm901z): customise a shipped item from the library console`.

### B7. Edit and delete

1. **RED:** AC4 `stale_and_unchanged_edits_are_refused` and `a_suspected_secret_is_refused_and_never_echoed`, and AC3's edit/delete subtests are not yet possible (no pack paths), so write the edit form's happy path as part of AC2's setup helper `editVariant` and assert it (303, version 1.1.0) in a small `TestVariantEditSavesTheNextVersionWithPostgres`.
2. **GREEN:** `variantEditForm`, `variantDeleteForm`, the editor and delete sections, the secret no-echo rule.
3. Commit `feat(86bcm901z): edit and delete a company variant`.

### B8. Update notice, diff, merge and ignore (AC2)

1. **RED:** AC2's test (5 subtests) → fails on the missing `#update-notice` (save `$EVID/red-ac2.log`); add AC4's `merge_and_ignore_need_a_newer_upstream_version`.
2. **GREEN:** the notice, the diff rendering (`textdiff.Diff` blocks → spans; 2,000-line cap), `#merge-preview`, `variantMergeForm` (automatic merge and resolution), `variantIgnoreForm`, the ignored section, the resolver. Rerun AC2 and AC4.
3. Commit `feat(86bcm901z): show upstream updates with a diff; merge or ignore them`.

### B9. Variants in packs (AC3)

1. **RED:** AC3's test (8 subtests) → fails at subtest 1 (no checkbox, until `catalogEntries` reaches builder mode) or 2 (save refused); save `$EVID/red-ac3.log`. Add `TestVariantNameClashWithALaterShippedItemIsNotTickableWithPostgres`.
2. **GREEN:** `packBuilderSaveForm` uses `catalogEntries` (skipping `NameClash` in `byID`); the row template's checkbox rules. Rerun AC3, the clash test, and `go test -count=1 -run 'TestPackBuilder|TestPackItems' ./internal/web`.
3. Commit `feat(86bcm901z): tick, order, assign and sync a variant like a library item`.

### B10. Cross-cutting refusals (AC4)

1. Add the remaining AC4 subtests (`a_member_cannot_see_or_change_variants`, `signed_out_visitors_are_sent_to_sign_in`, `a_bad_csrf_token_is_refused`, `another_company_cannot_read_change_or_pack_the_variant`). Note in `$EVID/ac4-notes.md` which subtests were green on first run (the route guards already exist; that is characterization, not invented RED), and prove each such guard by its mutant in B14.
2. Run AC4's command → PASS. Commit `test(86bcm901z): refused variant requests write nothing and stay in their tenant`.

### B11. OpenAPI

1. D9's description edits; `make generate`; `make contracts-check` → exit 0; `go test -count=1 ./packages/contracts/... ./internal/web -run 'TestContract'`.
2. `$EVID/contract-diff-<sha7>.txt` and the client check (`git -C ~/Leorna/leorna-client grep -c libraryItemIds -- api/` → no match) in `$EVID/client-contract-check.txt`.
3. Commit `docs(86bcm901z): pack id lists accept company variant ids`.

### B12. Wiring

`cmd/control-plane/main.go`: D10's line. `go build ./... ./packages/contracts/...`. Commit `feat(86bcm901z): wire company variants into the control plane`.

### B13. Docs & records

1. `internal/library/README.md`: new section "Company variants (86bcm901z)": what a variant is, kinds and why configs/MCP templates are out, lineage (`upstream_item_id`), how an update appears (a release's newer row; computed on read), the diff, merge (three-way, conflicts, markers), ignore (that version only), editing (description and main text; files follow upstream), the gate and gitleaks dependency, versions (1.0.0, minor per change), deletion (packs keep copies), the name rule and the later-release name clash, migration 25 and its destructive down, and the test names (AC tests and supporting).
2. `internal/pack/README.md`, "Build a pack from the library": one paragraph: company variants are ticked, ordered, removed, assigned and synced like library items; the API's id lists take variant ids; a pack copies the variant's content, so a later edit reaches a pack only when re-added.
3. `internal/web/README.md`: the routes table above, the bounded preview, the error statuses; under "Library catalog browser" note that variant rows are listed and that the unbounded preview stays for shipped items only.
4. `internal/audit/README.md`: `library.variant.create|update|merge|ignore|delete`, target = variant id, record keys, never text.
5. `GLOSSARY.md`: **Company variant**: "A tenant's editable copy of one shipped content library item version, linked to that version so newer upstream versions can be reviewed and merged or ignored. _Avoid_: fork, override."
6. `delivery/stories.json`: append this story's entry **last, as text**: replace the file's final `\n}\n` with `,\n  "86bcm901z": {\n    "name": "Customise a shipped item (company variant)",\n    "prs": {\n      "LeornaAI/leorna-control-plane": []\n    }\n  }\n}\n`; check `python3 -c 'import json; json.load(open("delivery/stories.json"))'`, that every earlier entry is unchanged by value, and `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`.
7. Grep the tracked tree for `86bcm901z` next to "until/once/later" (`git grep -n -i -E '86bcm901z|variant' -- '*.md' '*.json' | grep -i -E 'until|once|later'`): `internal/web/README.md:224` names "tenant variants" as needing a bounded preview; reword it to say the variant page uses the bounded renderer.
8. Commit `docs(86bcm901z): document company variants`.
9. **Not the builder's:** the plan copy (`$EVID/plan-approved.md`, written by the main session on go), and `leorna-workflow.md` (the main session adds the status line; put a draft line in the hand-back).

### B14. Mutation checks

Run M1–M18 (table above) through `go test -overlay` on the final head (SQL mutant M18 edited in place and restored from saved bytes; confirm `git -C "$WT" status --porcelain` empty afterwards). `$EVID/mutations-<sha7>.txt`.

### B15. Gates on the final head (detached copy `$C/gate-tree` at HEAD, the builder DB)

1. `make check` with `GOLANGCI_LINT`/`GOVULNCHECK` bound → `gates-<sha7>.txt` with `EXIT=`.
2. `bash ./scripts/test-module-add.sh` → `module-add-<sha7>.txt`.
3. Postgres stream: `go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/variant > pg-<sha7>.json`; per test, fail any skip whose reason names `LEORNA_TEST_DATABASE_URL`; allowed skips only `TestTeamsAPIWithPostgres`'s two ClickHouse subtests, `TestEvidenceThirdPartyContentPage` ("LEORNA_EVIDENCE_DIR is not set") and `TestProvisionManagedPostgresLive` ("SCW_LIVE=1 not set"); summary in `pg-<sha7>-summary.txt`.
4. Each AC's own command → `ac<n>-<sha7>.log` (only that test; no skips).
5. `gitleaks git --redact --no-banner --log-opts="$BASE..HEAD"` → `gitleaks-story-<sha7>.txt`.
6. Image: `docker build --no-cache --file Containerfile --tag leorna-cp-86bcm901z:<sha7> .` in `$C/gate-tree` (check the `RUN go build` step says DONE), then `docker run --rm --entrypoint /usr/local/bin/gitleaks leorna-cp-86bcm901z:<sha7> version` → `8.30.1`; `docker rmi` the tag → `image-<sha7>.txt`.
7. Pre-flight: `git -C "$WT" log --format='%an <%ae>' "$BASE"..HEAD | sort -u` is one line, `Justin Issa <justin@leorna.com>` (record only "authors: 1 identity, Leorna OK", never the address); no commit body matches `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive); `git diff --name-only "$BASE"...HEAD -- .github` is empty; `git diff --stat "$BASE"...HEAD` → `changed-files-<sha7>.txt`.
8. `git worktree remove --force "$C/gate-tree"`.

### B16. Evidence E1–E4 (final head binary; see "Evidence capture")

### B17. Hand back `ready-for-review`

Head SHA, commits, `git diff --stat`, each AC's test and log, base RED, screenshots, mutants, gates with `EXIT=`, the migration fill, deviations from the plan with reasons, `found_else`, `skill_lessons`, and a draft `leorna-workflow.md` status line. Drop the demo DB; remove `$C` and `$SCR` by literal absolute path; keep the builder DB.

## Evidence capture on this desktop (E0–E4)

**Folder:** `~/.hermes/plans/leorna/evidence/86bcm901z/`. The builder writes at its root; the verifier only in `verifier/`, the auditor only in `auditor/`, a fixer in `fixer<n>/`. Nothing goes inside the worktree (`ac-check.sh` fails on untracked files).

**Demo server (loopback only; the 901j/901w/901y recipe):**
1. Detached copy of the head: `git -C "$WT" worktree add --detach "$C/head-tree" HEAD` (at `BASE` for E0).
2. `cd "$C/head-tree" && go build -o "$C/run/control-plane-a" ./cmd/control-plane`; record `go version -m … | grep vcs` (revision = head, `vcs.modified=false`).
3. Run it with `LEORNA_MANIFEST_PATH` = a copy of `config/manifest.example.json` listening on `127.0.0.1:<free port>`; `LEORNA_DATABASE_URL` = `leorna_86bcm901z_demo_test` on `$PGPORT` with `sslmode=disable`; `LEORNA_DEV_MODE=1`; `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`; `LEORNA_SECRET_ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)`; `PATH` including `/usr/local/bin` (gitleaks); the password read inside the script (as `~/.hermes/plans/leorna/evidence/86bcm901y/capture.sh.txt`), never on a command line. Fresh demo DB per run (drop, create). The log must show "content library loaded".
4. **Release B** (for E2): `git -C "$WT" worktree add --detach "$C/release-b-tree" HEAD`; in it change `internal/library/content/items/skill/incident-postmortem/body.md` line `- A near miss that could have caused one of those` → `- A near miss that could have caused one of those (log it within two working days)` and append `\nReview open action items every week.\n`; `item.json` version `1.2.0`; `content/library.json` version `0.9.0`; `go test ./internal/library -run TestContentLock -update-lock`; then `go test -count=1 ./internal/library -run 'TestEmbeddedLibraryIsValid|TestContentLockPinsEveryItemVersion'` (both pass); `go build -o "$C/run/control-plane-b" ./cmd/control-plane`. Save `git -C "$C/release-b-tree" diff` and the test results into `$EVID/release-b-<sha7>.txt`. Never commit it; remove the worktree afterwards with `git worktree remove --force`. (Check the line exists first: `grep -n 'near miss' …/body.md`; if the text differs, pick that bullet's real text and say so.)

**Capture driver:** adapt `~/.hermes/plans/leorna/evidence/86bcm901y/capture-main.go` into `$EVID/capture-main.go` and run it as `cmd/zz-capture-901z/main.go` inside `$C/head-tree` (untracked there, never in `$WT`): `go run ./cmd/zz-capture-901z -base http://127.0.0.1:<port> -out "$EVID" -chrome ~/.cache/chrome-for-testing/chrome-linux64/chrome -profile "$C/chrome-profile" -mode base|a|b`, under `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, chromedp flags `headless=new`, `NoSandbox`, `DisableGPU`, `disable-software-rasterizer`, window 1440×1000. Keep 901y's `waitFor`, `heading`, `section`, `page`, `click` and `listIs`; mark the old page before each form submit (`window.__beforeSubmit = true`) and wait for a loaded page without the mark. Every shot first checks its page (an element id and text) so a wrong page fails the run instead of saving a misleading PNG. Find the shipped item's id from the library page link whose text is `incident-postmortem`.

**Flow `-mode base` (E0):** `/dev/login?next=<item page>` → `ac1-item-page-before-<base7>.png` (`page`); `/admin/library` → `ac3-library-before-<base7>.png`.

**Flow `-mode a` (release A, the head binary):**
1. Item page of `incident-postmortem` → set `name` to `incident-postmortem-acme` → **`ac1-customise-form.png`** (`#customise`) → Customise → wait for heading `incident-postmortem-acme` and `#variant-upstream` = `incident-postmortem 1.1.0` → **`ac1-variant-created.png`**.
2. `/admin/library?q=incident` → **`ac1-library-lists-variant.png`**.
3. On `incident-postmortem-acme`: edit the body line starting `Collect alerts, dashboards` to end with ` Attach the Acme status page link.` → save → wait for `#variant-version` = `1.1.0`.
4. Customise `incident-postmortem-ops` (unedited) and `incident-postmortem-conflict`; on the conflict variant edit the near-miss bullet to `- A near miss that could have caused one of those (log it the same day)` → 1.1.0.
5. `incident-postmortem-acme` page → **`ac2-no-update-before.png`** (no `#update-notice`). Stop server A.

**Flow `-mode b` (release B on the same DB; its log shows "content library loaded … added 1"):**
1. `/admin/library?q=incident` → **`ac2-library-update-chip.png`** (three rows with `Update available: 1.2.0`).
2. `incident-postmortem-acme` → check `#update-notice` and a clean `#merge-preview` → **`ac2-update-available.png`** (`#update-notice` section, diff included).
3. Click "Merge 1.2.0" → wait for `#variant-version` = `1.2.0` and no notice → **`ac2-after-merge.png`**.
4. `incident-postmortem-ops` → Ignore → **`ac2-after-ignore.png`** (`#update-ignored`).
5. `incident-postmortem-conflict` → Merge → 409 page with `#merge-conflicts` → **`ac2-merge-conflict.png`**.
6. `/admin/library` (builder mode): tick `debugging-and-error-recovery` and `incident-postmortem-acme`, name "Acme incident pack" → **`ac3-variant-ticked-before-save.png`** (the two rows and the builder form) → Create → wait for "version 1"; `listIs(skill/debugging-and-error-recovery, skill/incident-postmortem-acme)` → **`ac3-pack-with-variant.png`** (`section.builder`).
7. `click("Move incident-postmortem-acme (Skill) up")` → wait for "version 2"; `listIs(skill/incident-postmortem-acme, skill/debugging-and-error-recovery)` → **`ac3-variant-moved-up.png`**.
8. Item page of `incident-postmortem`: name `incident-postmortem-acme` → Customise → 409 with `#customise-error` → **`ac4-name-taken-alert.png`**.

**Terminal captures (AC3 sync run, AC4):** render the real log in a `<pre>` page: `python3 -I -c 'import html,sys; print("<!doctype html><meta charset=utf-8><body style=\"background:#0b1320;color:#e6edf3\"><pre style=\"font:13px monospace;white-space:pre-wrap\">"+html.escape(open(sys.argv[1]).read())+"</pre>")' <log> > "$C/<name>.html"`, then `env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=… ~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --disable-software-rasterizer --hide-scrollbars --user-data-dir="$C/chrome-term" --window-size=1400,<height> --screenshot="$EVID/<name>.png" "file://$C/<name>.html"`. Judge success by "bytes written" and the PNG magic `89504e47`, not Chrome's exit code (139 after writing is known). The command line in the log must hold no DB URL or password.

**Privacy (every role, before citing a PNG):** look at each image (tall pages in bands of ≤1,300 px); grep its text source for emails, URLs, tokens and passwords; no URL bar exists in headless shots; UUIDs and version ids from the throwaway demo DB are accepted; never capture `/admin` itself.

**Mapping (the builder's root files; the verifier and auditor take their own):**

| AC | Test log | `ac.json` screenshot | Extra captures |
| --- | --- | --- | --- |
| AC1 | `ac1-<sha7>.log` | `ac1-variant-created.png` | `ac1-item-page-before-<base7>.png`, `ac1-customise-form.png`, `ac1-library-lists-variant.png` |
| AC2 | `ac2-<sha7>.log` | `ac2-update-available.png` | `ac2-no-update-before.png`, `ac2-library-update-chip.png`, `ac2-after-merge.png`, `ac2-after-ignore.png`, `ac2-merge-conflict.png`, `release-b-<sha7>.txt` |
| AC3 | `ac3-<sha7>.log` | `ac3-pack-with-variant.png` | `ac3-library-before-<base7>.png`, `ac3-variant-ticked-before-save.png`, `ac3-variant-moved-up.png`, `ac3-sync-terminal.png` |
| AC4 | `ac4-<sha7>.log` | `ac4-refused-terminal.png` | `ac4-name-taken-alert.png` |

If a fix later changes a template, a route or the pack paths, retake that AC's console shots on the new head; a test-only change needs only the terminal captures re-rendered. The card's "UI demo" is the E0–E2 series (a real binary, a real "release B", real clicks), recorded by an agent; nothing is owed to Justin.

## Sibling stories (checked 2026-10-29 19:20 UTC)

Open PRs: only **#101** (902a quick start, head `bb79ec6`, base `b65f797`). Worktrees under `.claude/worktrees/`: 901a, 901b, 901j, 901r, 901w, 901y, 902a (901a/b/j/w/y are merged; 901r has no PR yet: local `feat/86bcm901r-starter-packs` `805b6cd`, merge-base `b985422`, so it still has to bring #100 in).

| Sibling | Files it also edits | How the finisher resolves at hand-over |
| --- | --- | --- |
| #101 902a (`bb79ec6`) | `delivery/stories.json`; `internal/store/postgres/migrations/000025_quick_starts.*` (**same number 25**); `internal/store/postgres/store_test.go` (the two `TestMigrationRoundTrip` lists and `resetDatabase`, same lines); `cmd/control-plane/main.go`; `internal/web/handler.go` (struct fields, routes); `internal/web/README.md`; `internal/audit/README.md` (new paragraph at the same spot after line 86) | Take main's files and re-add this story's lines: stories.json entry appended last as text; both tables in both lists; both audit paragraphs; both route blocks. **Migration:** if #101 merges first, rename this pair to the next free number (26, or 27 if 901r took 26) and change "migration 25" in this story's README text; check `ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` is empty on the trial merge. 902a's quick start calls `ListLibraryItems` and `BuilderService.CreatePack` with library ids; both keep their signatures and behaviour here. |
| 901r (`805b6cd`, no PR) | `internal/web/library.go` (the `libraryCSS` constant line, `libraryPageData` struct, `renderLibrary` right after the filter block, the template's header section); `internal/web/handler.go`; `cmd/control-plane/main.go`; `internal/library/README.md`; `internal/pack/README.md`; migration `000025_starter_packs.*` (**same number**); `delivery/stories.json` | Real text conflicts in `library.go`: keep both (CSS: both appended rules; struct: both fields; `renderLibrary`: 901r's starter block and this story's `catalogEntries` call; template: starter section and the variant row changes). Renumber the later migration as above. Run AC1–AC3 and 901r's tests on the trial merge. |
| Future 9026 (pack diff preview, Yan) | none yet | `internal/textdiff` is reusable for text previews; say so in the PR. |

## Risks

- **Migration number collision** with #101 and 901r (all three use 25). Mechanical renumber by whoever merges later; the builder re-checks in B0.
- **`library.go` conflict with 901r** (same CSS line, struct and template header). Mechanical but real; the finisher trial-merges.
- **gitleaks at runtime:** customise, edit and merge need it (as the item editor does); without it they answer 503 and save nothing. Documented.
- **Coarse diffs:** a changed region over 2^20 line pairs (two ~1,000-line rewrites) is one replaced block, so a merge there conflicts as a whole. Safe (no silent loss); documented.
- **Adjacent edits conflict** (as in git): a company edit right next to an upstream edit asks for manual resolution. Documented with a unit test.
- **Name clash after a later release:** handled (D6); the admin re-customises under a new name to keep ticking it.
- **Destructive rollback:** migration 25 down drops all variants; packs keep their copies. Prefer fix-forward.
- **Variant version numbers are the variant's own** (1.0.0, 1.1.0…), not upstream's; pack audits and the bundle show them. Documented.
- **Imported upstream items (MIT):** a variant of an `agent-skills` item is a modified copy; the licence notice already ships in `THIRD_PARTY_NOTICES.md` and on `/admin/third-party-content`. The variant page does not repeat the attribution (follow-up).

## Follow-ups (offer as cards; not in this story)

1. Edit supporting files in a variant, with per-file merge (Q4-B).
2. A JSON API for variants (list, read, customise, edit, merge, ignore, delete) in OpenAPI.
3. "Replace with upstream" in one click, and rename a variant.
4. Tell admins when updates arrive (admin home badge or a message), instead of only on the library and variant pages.
5. Show the upstream's licence and source on a variant of an imported item.

## Assumptions

- Admins only, as for the library and the pack builder.
- A variant's category, tags and supported tools are its base upstream version's.
- Updates are computed when a page is read; no job, no notification.
- A merge takes upstream's supporting files (Q4-A).
- Deleting a variant leaves every pack version that copied it unchanged; teams keep syncing that copy until a version without it is assigned.
- Customise also runs the gate (the variant's name changes the rendered paths), so a shipped item that fails the tenant rules can't be customised; `TestEveryShippedSkillAgentAndPromptCanBeCustomised` shows none does today.
- No client change and no client regeneration (D9).
- The "UI demo" is agent-captured locally; no live AC.

## Other things found

- **P3 (docs):** `internal/library/README.md:696-698` and the `Requires` comment in `internal/library/library.go:85-90` say the pack builder (86bcm901w) reads `Library.Required`; on `b65f797` no non-test code calls it (`git grep -n 'Required(' -- '*.go'` finds only its definition; 901r's branch adds the first caller in `internal/library/starter.go:156`). Not touched here.
- **P3 (side effect):** `itembuilder.DraftIssues(in Input)` takes the input by value, but `validate` (`internal/itembuilder/validate.go:73-88`) sets `Script` on `&in.Files[i]` and `sort.Slice(in.Files, …)`, which write through the caller's shared backing array. This story passes cloned slices, so it is unaffected. Not touched here.
- **Constraint honoured, not a bug:** `internal/web/README.md:205-225` says a bound must land before tenant content reaches the unbounded library preview "for example tenant variants". Variants are stored in their own table and rendered through PR #100's bounded `renderBoundedItem`; B13 rewords that sentence.

## Rules for every role

- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in your report's "Other things found".
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- Scratch: keep scratch in your own fresh `<scratchpad>/86bcm901z-<role>/` folder (`mkdir` without `-p`) and remove only that folder by its literal absolute path. `/tmp` is a small RAM tmpfs here: big temp files (Go `TMPDIR`, Chrome profiles, binaries) go to `~/.cache/86bcm901z-<role>/`.
- You can't ask Justin anything and can't start agents: questions go in your report, and any skill step that says "spawn a subagent" is run by the main session.
- Never push, open a PR, post to ClickUp, change a card or merge. Never commit or stage `CLAUDE.md`. Commits use the repo's identity (`Justin Issa <justin@leorna.com>`), `feat(86bcm901z): …` style, no AI attribution lines.

## Completion contract

- **Builder:** stops at `ready-for-review` (B17) with every AC's test passing on the head and failing on base, every PNG named above, mutants M1–M18 recorded, and every gate `EXIT=0` (or a baseline-identical failure explained).
- **Then:** fresh review → fix rounds until `review-check.sh` prints MOVE ON → verifier → blind auditor → `ac-check.sh --reviews` → finisher hand-over (PR text, review prompt, ClickUp evidence draft, team message), with no push or post until Justin says the word.
