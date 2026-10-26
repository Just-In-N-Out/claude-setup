# 86bcm901v — Preview admission recovery plan (OPUS-R2-F1: ordinary nested code)

**Status: PLAN ONLY — feasibility slice FS-1 READY for approval; production implementation GATED on FS-1 = VALIDATED plus Justin's renewed go.** Nothing in this file has been executed. The candidate design below is still an **unproven hypothesis (H)**: the source argument is written down, but its CPU behavior has not been measured.

Author/role: Opus 5.5 xhigh scoped recovery **planner** (read-only). Sole authored artifact: this file.

## 0. Time record (tool-observed)

| UTC | Elapsed | Checkpoint |
| --- | --- | --- |
| 2026-10-23T01:34:06Z | 0 | Start. Forecast **15–30 min, low confidence, advisory** (read-only source + plan). |
| 01:50:32Z | 16 min | Brief, stopped report, current guard, failing probe and goldmark Parse lifecycle read. |
| 01:57:14Z | 23 min | Block-phase quadratic located in goldmark source (`LineOffset`, link-reference removal). |
| 02:07:24Z | 33 min | Past the upper forecast. Optional exploration stopped and work narrowed to writing this plan. Cause: the block-phase worst-case analysis needed two more goldmark files than expected. |
| 02:11:18Z | 37 min | Plan writing started; no further research. |
| 02:27:13Z | 53 min | Saved and statically validated (§15). **Variance +23 min over the upper forecast.** Causes: locating and characterizing the two block-phase quadratics, and writing complete probe and implementation code instead of an outline. No research restart, no extra agents. |

## 1. Goal (finite)

Fix the problem behind OPUS-R2-F1. Two ordinary documents with code nested in a list currently lose all formatting. The fix must not create a formatting ceiling and must not bring back the multi-second CPU cost. It decides **whether** an item is formatted using **goldmark's own block grammar**, not a parallel line heuristic. The deliverables are:

1. a READY, isolated feasibility slice (FS-1) that can falsify the hypothesis;
2. gated implementation microtasks with complete code, to be used only if FS-1 validates H.

Non-goals: a third heuristic patch, a new dependency, a goldmark fork, caches, timeouts, background work, API/schema/auth/store/CI changes, or reopening options B/C.

## 2. Frozen inputs (verified read-only at plan time)

- Worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser`, branch `feat/86bcm901v-library-catalog-browser`.
  - `HEAD = 1293ce1ff48c184235bb7a066631d5fb87551cd9`.
  - `git status --porcelain=v1 -uall` was empty at the start of planning. Recheck in §15.
- `e54c221..HEAD` touches exactly 4 paths:
  - `internal/web/library_browser_test.go` (+33)
  - `internal/web/library_preview.go` (157 lines changed)
  - `internal/web/library_preview_test.go` (178 lines changed)
  - `internal/web/testdata/library_preview/ordinary-guide.md` (+42)
- Original base: `0da9f5443a2a49b157cf24b5d30301345d371d3e`.
- Stopped fixer evidence (`fix-opus-r2-20261023T003551Z`, immutable):
  - report.json, manifest.json, source-final.json, execution-index.json;
  - `scripts/zz_fix_opus_r2_nested_test.go`;
  - `logs/nested-code-class-recheck.log` (exit 1). Results:
    - `nested_fenced`: 49,102 B, fallback=true, direct goldmark 519.375 µs, H1/list/code present;
    - `nested_indented`: 51,886 B, fallback=true, direct 996.75 µs.
- Parent intake: 310 payloads / 76,897,175 B, 504 source pins, 41 receipts (18 exit0 / 23 exit1), 13 skills. These results are carried forward, not re-run.
- Earlier history (preserved, read-only):
  - R1 CPU evidence `review-opus-r1-20261022T221056Z/adv-scaling-probe.log` (quoted in §6);
  - the R2 reviewer's six SHA-bound real documents: `review-opus-r2-20261022T234744Z/probes/realistic-doc-identities.txt` plus `private/probe-inputs/*/`.
- Two heuristic refinements have already been spent. This plan does **not** reset that count. Any further line-heuristic patch is out of scope.

## 3. User contract (unchanged; not renegotiated here)

Justin's F2 choice, verbatim: **"A — Limit complex parsing and show safe plain text instead; only those items lose formatting"**.

Must stay the same:

- Ordinary meaningful Markdown/code formatting is preserved, including nested code. No raw-density, ~8 KiB or nested-code formatting ceiling.
- Only structurally excessive or pathological content gets the clearly labeled, complete, escaped fallback. The notice text stays the same.
- Size and encoding limits: 64 KiB body/example, 1 MiB output, UTF-8, no NUL.
- Markdown stays inert: no active links, images or HTML. Config/MCP items stay escaped source.
- Auth, store, tenant and lifecycle behavior is unchanged. No dependency, API, schema or CI changes. No caches or timeouts as a bound.
- All closed R1 F1/F3/F4 behavior stays protected.
- AC3: strict list filtering, every sample under 300 ms with 240 rows. The R1 reviewer's 2-second probe is **not** a product AC. Watchdogs in FS-1 are experimental stop conditions, not product promises.

## 4. Root cause (systematic-debugging, Phase 1–2)

- **Red-capable loop already exists.** `zz_fix_opus_r2_nested_test.go` fails on the exact committed bytes, and direct goldmark renders the same inputs correctly in under 1 ms.
- **Mechanism.** `libraryMarkdownWithinBudget` (`internal/web/library_preview.go:54–177`) counts `[`, `<` and `](` per *physical blank-line region*, with a limit of 256. It exempts only code it can recognize *at the root*:
  - root fences: `line[0] == char || !containerContext`;
  - root indented code: `!containerContext`.

  Inside a list, `containerContext` is true, so fenced and indented code lines are counted as inline text. Each JSON line `"args":[` contributes one `[`, so 700 lines give 700 > 256 and the document falls back.
- **Why a third heuristic fails.** Deciding whether a line is code inside containers needs the full CommonMark container/leaf state machine: list offsets, lazy continuation, blank-line rules, fence closing, HTML block types, setext/link-reference interplay. Rebuilding that is exactly the parallel approximate parser the brief forbids. Two refinements were already spent on root-level versions of it.
- **What a correct bound needs.** It must be the renderer's own block classification, plus explicit bounds on the parts of goldmark's **block phase** that are themselves superlinear (§6).

## 5. Pinned goldmark v1.7.17 API and lifecycle receipts

Read-only from the installed module `/Users/justin/go/pkg/mod/github.com/yuin/goldmark@v1.7.17` (`go.mod:13` pins v1.7.17; `go.sum:77–78`). No upstream fetch was needed.

| Fact | Source |
| --- | --- |
| `goldmark.New` uses `DefaultParser()` = default block parsers + default inline parsers + default paragraph transformers. No AST transformers. | `markdown.go:15–19`, `:100–113` |
| `Parse` runs `parseBlocks` (whole block tree) **first**, then `walkBlock`+`parseBlock` (inline phase per block), then AST transformers. | `parser/parser.go:840–888` |
| Inline phase: `parseBlock` returns immediately for `parent.IsRaw()`. It reads only `parent.Lines()`. It runs a parser only when `p.inlineParsers[c] != nil`. Delimiters and link-label state are processed or cleared **per block** (`ProcessDelimiters(nil,pc)`, `CloseBlocker`). | `parser/parser.go:1131–1249`; `parser/delimiter.go:157–161`; `parser/link.go:437–449` |
| A parser built with `NewParser(WithBlockParsers(...), WithParagraphTransformers(...))` and **no** `WithInlineParsers` leaves `inlineParsers` nil. Inline parsing then degrades to linear text segmentation, and `ProcessDelimiters` returns at once. | `parser/parser.go:729–741`, `:852–855`, `:1185–1186`; `delimiter.go:158–160` |
| Raw blocks: `CodeBlock`, `FencedCodeBlock`, `HTMLBlock` (`IsRaw()==true`). All other blocks are non-raw. | `ast/block.go:23–24`, `:246–247`, `:304–305`, `:487–488` |
| `BlockParser` interface: `Trigger`, `Open(parent,reader,pc)`, `Continue`, `Close`, `CanInterruptParagraph`, `CanAcceptIndentedLine`. `ParagraphTransformer.Transform(*ast.Paragraph, text.Reader, Context)`. `Context.Get/Set(ContextKey)`; `NewContextKey`; `NewContext`; `WithContext`. | `parser/parser.go:121–145`, `:490–529`, `:557`, `:234`, `:832–838` |
| `DefaultBlockParsers()` returns singletons such as `NewBlockquoteParser()` and `NewListParser()`, which return package-level pointers. Default paragraph transformer: `LinkReferenceParagraphTransformer` (prio 100). | `parser/parser.go:581–594`, `:618–622`; `blockquote.go:12–18`; `list.go:107–114` |
| Paragraph transformers run **during the block phase** (on paragraph close, and in the setext `RequireParagraph` path, which can remove a paragraph and retry). Block structure therefore depends on them. | `parser/parser.go:900–918`, `:984–998` |
| `PrioritizedValue{Value interface{}; Priority int}`. `ast.KindBlockquote`, `ast.KindListItem`. `ast.Walk`. | `util/util.go:866–871`; `ast/block.go:351`, `:439`; `ast/ast.go:496–499` |

**Source argument vs CPU feasibility.** The table establishes that a block-only parse uses exactly the renderer's block grammar. It does **not** show that the block phase is cheap. §6 shows the opposite in two places.

## 6. Block-phase worst cases (source argument; CPU feasibility not executed)

1. **Nested containers on one line are quadratic.**
   - `reader.LineOffset()` recomputes the column by scanning from the line head to the current position after every `Advance` (`text/reader.go:167–180`, `:199–200`).
   - `openBlocks` calls it on every `goto retry` (`parser.go:937–938`). Blockquote and list-item processing call it again (`blockquote.go:22`, `list_item.go:62`, `:74`; `list.go:189`).
   - So K nested openings on one line cost O(K²). R1 observed exactly this:
     - `blockquote_nest` 8/16/32/64 KiB: 43 ms → 157 ms → 603 ms → 3.53 s;
     - `list_nest_ordered`: 10 ms → 56 ms → 141 ms → 706 ms.
   - Padded lines (tabs or list padding) also make `PeekLine` copy the rest of the line (`text/segment.go:57–65`).
   - **Argument:** if the open-container depth D is capped, every container step costs at most O(line length) and there are at most O(D) steps per line. Block phase is then O(D·N). With D ≤ 64 this is linear in the input with factor 64. **Unmeasured.**
2. **Link-reference definitions are quadratic in definitions per paragraph.**
   - The removal loop re-slices and `append`s the rest of the paragraph's lines for every definition (`link_ref.go:32–41`; `text/segment.go:183–185`, `:206–213`): O(defs × lines).
   - A 64 KiB paragraph of `[a]: b` lines has about 9,362 definitions, so about 44 M segment moves. **Estimated** (not measured) at tens to ~100+ ms per parse, paid twice (admission + render).
   - The committed guard prevents this only indirectly: it counts every `[` in a region.
   - Title scans do **not** go quadratic: with `Nesting:false`, `findClosureReader` stops at the next opener, and a failed closure leaves the reader at the end (`text/reader.go:623–701`).
3. **Checked and linear by source:**
   - HTML block `Continue` re-checks the first line only while `lines.Len()==1` (`html_block.go:157–214`);
   - fenced/indented code continue and close;
   - ATX/setext/thematic break per line;
   - list close tightness pass;
   - `isBlankLine` (bounded by depth).
4. **Inline phase** is already bounded per block by the existing implementation limits (256 link/HTML candidates, 1,024 delimiters, 1,024 `&` run); these are engineering settings, not prior explicit user approval of every new counting domain. Goldmark's own inline work unit is one block (row 3 of §5), so applying the same limits **per inline-parsed block** fits the cost model better than the current per-blank-region scan.

## 7. Candidate architecture H (hypothesis — needs FS-1 before integration)

`renderLibraryPreview` keeps its control flow, caps, notice, fallback bytes, inert renderer and output writer. Only `libraryMarkdownWithinBudget` is replaced.

1. **Admission parser.**
   - Built from `parser.DefaultBlockParsers()` and `parser.DefaultParagraphTransformers()` with **no inline parsers**.
   - The `Blockquote` and `List` singletons are wrapped by `libraryDepthLimited`. `Open` refuses, and records exceeded in the parse `Context`, when the new container would make blockquote + list-item nesting exceed 64, or once exceeded is already set.
   - The link-reference transformer is wrapped by `libraryDefinitionsLimited`. It refuses, and records exceeded, when the paragraph's `]:` pairs exceed 256. Every definition needs an adjacent `]:` (`link_ref.go:87`), so this is an upper bound on definitions. It costs O(paragraph).
   - In every other case the wrappers delegate unchanged. So when admission finishes **without** a refusal, its block tree is the renderer's block tree. Only the inline phase differs, and that cannot change block structure (§5 row 2).
2. **Inline budget.** Walk the admission AST. For every `TypeBlock` node with `!IsRaw()`, count over `node.Lines()`:
   - link/HTML candidates (`[`, `<`, `](`), at most 256 per block;
   - delimiters (`*`, `_`, `` ` ``), at most 1,024 per block;
   - a contiguous `&` run, at most 1,024 per line.

   These are the same tokens and constants as today, but the domain is now exactly what goldmark inline-parses.
3. **Decision.** Refusal or any block over budget → the exact current fallback. Otherwise → the unchanged `goldmark.New(...)` inert render.

**Supported-grammar and CPU contract (explicit, for approval):**

- **Formatted:** any CommonMark document goldmark v1.7.17 parses with container nesting ≤ 64, ≤ 256 literal `]:` pairs per paragraph (including prose; a conservative upper bound, not an exact definition count), and inline-parsed blocks within the per-block limits above.
- **Code and raw HTML** (root or nested to any allowed depth) consume **no** budget and have no size or density limit beyond the 64 KiB body cap.
- **CPU (argued, not yet measured):** admission is O(64·N) block work plus O(N) counting. The render is the same block work plus inline work bounded per block.

**Behavior deltas vs committed `1293ce1` (named, not hidden):**

- (a) **More permissive:** all code (any container) and HTML blocks are exempt. The 256-column indentation cap disappears. Lines inside code with more than 64 `>`/list markers no longer cause fallback.
- (b) **Stricter, for structurally excessive content only:**
  - lists nested more than 64 levels purely by indentation fall back (today, at most 256 columns, they render);
  - nesting is now counted as grammar containers, not markers per line, with the same boundary of 64 for `>`×N and `1. `×N.
- (c) The 256 limit now explicitly also bounds link-reference definitions per paragraph. Today they are subsumed by the per-region `[` count, which is stricter.

## 8. Alternatives considered

| Option | Verdict |
| --- | --- |
| Extend the line state machine to container offsets (third heuristic) | **Rejected.** Spent attempts; re-implements CommonMark containers approximately. |
| Keep the cheap per-line marker/column pre-guard, then block-only parse | **Fallback design only if H's wrappers fail FS-1.** False positives inside code; keeps the approximate root-fence/HTML state machine; the link-reference quadratic still needs a bound. |
| Wrap the *inline* parsers with an invocation budget (single pass) | **Rejected.** Per-invocation cost is not constant (code-span/closure scans), it is more invasive, and the full AST is built before the decision. |
| Block-only parse **without** paragraph transformers | **Unsound** — FS-1 negative control NC1. `[a]: b\n===\n    <attack>` is a setext heading + indented code in admission, but a paragraph (`===`, attack) in the render, because the transformer removes the definition-only paragraph and the setext retry fails. |
| Timeout, cache, background render, accept slow (C), error-only (B) | **Forbidden / not selected.** |

## 9. READY task FS-1 — isolated feasibility slice (Sol 6.1 xhigh; needs Justin's go for FS-1 only)

**Question.** Given the committed bytes plus the candidate admission code in an overlay-only test file:

1. Are all contract decisions correct?
2. Does admission's block tree equal the renderer's?
3. Do the block-phase families grow at most linearly, with exact fallback bytes?

**Ownership / isolation.**

- One new evidence namespace, `~/.hermes/plans/leorna/evidence/86bcm901v/feasibility-admission-<UTC>/`, claimed atomically with plain `mkdir`. Stop if it exists.
- The probe enters the build only through `go test -overlay`. Nothing is written into the worktree.
- No branch, worktree, index, commit, DB, server, browser or network.
- `GOPROXY=off`, `-mod=readonly`. GOCACHE and GOTMPDIR are owned and live under the namespace.
- Frozen worktree identity is checked before and after. Drift → stop and report.
- **Budget:** about 5–15 min wall time (cold compile into a fresh cache dominates). One `go test` invocation. `-timeout 600s` is the experimental kill switch. A 1 s cold-call violation is checked only after the call returns; it is not a preemptive per-call watchdog. The 600 s test-binary timeout is separate from compilation and from an outer command deadline. Keep these experimental safeguards distinct from product guarantees. **Two attempts maximum:** a second run only after an orchestration/environment failure (for example a missing cached module) whose new fact is recorded; never to make results green.

**Inputs** (all generated in code or SHA-verified; the expected decisions are the contract table, not output from the candidate):

- **Seven original families (fallback):** exact bodies from `TestLibraryPreviewComplexMarkdownFallsBack`.
- **Two witnesses (formatted):** exact generators. Byte counts asserted at 49,102 and 51,886.
- **Six real docs (formatted):** files under `private/probe-inputs`, each SHA-256 matched to `realistic-doc-identities.txt`.
- **Ordinary docs (formatted):** 16/32/64 KiB × prose/code-heavy via the existing `ordinaryLibraryMarkdown`.
- **Structural boundaries:** all 8 units × {limit−1, limit, limit+1} from `TestLibraryPreviewStructuralBudgetBoundaries`, plus its 1,000-paragraph repeated-constructs body.
- **Existing adversary cases:** 15 surrounding/bypass cases (fallback), 6 literal-code wrappers (formatted), 2 root indented/fence cases (formatted).
- **New mixed-wrapper code (formatted):** fence in a blockquote, in an ordered list, in a 3-level list; indented code in list-in-quote; an unclosed tilde fence in a list; a 64 KiB nested fence. Each code block is dense enough (≥ 720 link candidates) that **any** misclassification would trigger fallback.
- **New bypass cases (fallback):** setext/reference spoof, list paragraph after code, lazy line after a quoted fence, list lazy continuation, deep-quote lazy continuation, HTML type 6 then attack.
- **Grammar boundaries:** quote lines, indentation lists, tab quotes and quote/list pairs at depth 63/64/65; reference definitions 255/256/257.
- **Scaling families:** at 8/16/32/64 KiB — single-line `>`, `1. `, `[a](`, `` `a ``, references; depth-64 quote lines, depth-64 ordered lines, depth-64 lazy continuation, depth-64 tab quotes, nested fenced JSON, headings, thematic breaks, HTML blocks, long line.
- **Seeded metamorphic documents:** 200 documents (seed 86901) built from 5 wrappers × fragments. Attack text placed only in code must give formatted. One attack paragraph anywhere must give fallback.

**Oracles / invariants:**

- **(O1) Decision** equals the contract table, row by row.
- **(O2) Fallback bytes** equal exactly `notice + <pre><code> + html.EscapeString(body) + </code></pre>`.
- **(O3) Admitted output** has no notice and equals the committed renderer's bytes whenever that renderer also formats.
- **(O4) Structure agreement:** for every admitted input, the block skeleton (kind, depth, line segments) of the admission AST equals that of `goldmark.DefaultParser()`. This is independent evidence that admission uses the render's grammar.
- **(O5) Scaling:** for each family, if best(64 KiB) ≥ 1 ms then best(64 KiB)/best(32 KiB) ≤ 3.0. Linear growth is about 2 and the R1 quadratic was about 4–6. This is an experimental growth discriminator, **not** a product SLA.
- **(O6) Negative controls:**
  - NC1: no-transformer admission admits the spoof;
  - NC2: no-depth-wrapper admission admits `>`×65;
  - NC3 (informational): no-definitions-wrapper admission time on 64 KiB references.
- **Comparison only:** decisions and timings of the committed `renderLibraryPreview` for every row.

**Predeclared verdict:**

- **VALIDATED:** exit 0; O1–O5 have zero violations; NC2 is sensitive. NC1 insensitivity is reported, but O4 is the deciding soundness evidence.
- **PARTIAL:** decisions and safety are correct, but a scaling or watchdog violation occurs, or a *grammar-boundary* row differs. Return to Opus with the exact family/row. Sol does not patch.
- **INVALIDATED:** any of the following:
  - an ordinary/real/witness/mixed/random-code row falls back;
  - an expected-fallback row is admitted;
  - an O4 structure difference;
  - inexact fallback bytes.

  H is rejected. Return to Opus/Justin with the evidence.

The run produces evidence only. It writes no product code and makes no "fixed" claim.

### FS-1 probe — full unapplied file (`$NS/probe/zz_fs1_admission_test.go`, overlaid as `internal/web/zz_fs1_admission_test.go`)

```go
package web

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"html"
	"math/rand"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
	"time"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/ast"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer"
	"github.com/yuin/goldmark/text"
	"github.com/yuin/goldmark/util"
)

// ---- Candidate H: identical to the gated implementation except the fs prefix and variant switches. ----

var fsAdmissionExceeded = parser.NewContextKey()

func fsContainerDepth(node ast.Node) int {
	depth := 0
	for ; node != nil; node = node.Parent() {
		if node.Kind() == ast.KindBlockquote || node.Kind() == ast.KindListItem {
			depth++
		}
	}
	return depth
}

type fsDepthLimited struct{ parser.BlockParser }

func (limited fsDepthLimited) Open(parent ast.Node, reader text.Reader, pc parser.Context) (ast.Node, parser.State) {
	if pc.Get(fsAdmissionExceeded) != nil || fsContainerDepth(parent) >= maxLibraryMarkdownDepth {
		pc.Set(fsAdmissionExceeded, true)
		return nil, parser.NoChildren
	}
	return limited.BlockParser.Open(parent, reader, pc)
}

type fsDefinitionsLimited struct{ parser.ParagraphTransformer }

func (limited fsDefinitionsLimited) Transform(node *ast.Paragraph, reader text.Reader, pc parser.Context) {
	if pc.Get(fsAdmissionExceeded) != nil {
		return
	}
	definitions, lines, source := 0, node.Lines(), reader.Source()
	for index := 0; index < lines.Len(); index++ {
		segment := lines.At(index)
		definitions += bytes.Count(source[segment.Start:segment.Stop], []byte("]:"))
	}
	if definitions > maxLibraryMarkdownLinks {
		pc.Set(fsAdmissionExceeded, true)
		return
	}
	limited.ParagraphTransformer.Transform(node, reader, pc)
}

type fsVariant struct{ depth, definitions, transformers bool }

var fsCandidate = fsVariant{depth: true, definitions: true, transformers: true}

func fsAdmissionParser(variant fsVariant) parser.Parser {
	blocks := parser.DefaultBlockParsers()
	for index := range blocks {
		switch blocks[index].Value {
		case parser.NewBlockquoteParser(), parser.NewListParser():
			if variant.depth {
				blocks[index].Value = fsDepthLimited{blocks[index].Value.(parser.BlockParser)}
			}
		}
	}
	options := []parser.Option{parser.WithBlockParsers(blocks...)}
	if variant.transformers {
		transformers := parser.DefaultParagraphTransformers()
		for index := range transformers {
			if variant.definitions {
				transformers[index].Value = fsDefinitionsLimited{transformers[index].Value.(parser.ParagraphTransformer)}
			}
		}
		options = append(options, parser.WithParagraphTransformers(transformers...))
	}
	return parser.NewParser(options...)
}

func fsInlineWithinBudget(source []byte, lines *text.Segments) bool {
	links, delimiters := 0, 0
	for index := 0; index < lines.Len(); index++ {
		segment := lines.At(index)
		line := source[segment.Start:segment.Stop]
		escapeRun := 0
		for position, c := range line {
			if c == '[' || c == '<' || (c == ']' && position+1 < len(line) && line[position+1] == '(') {
				links++
			}
			if c == '*' || c == '_' || c == '`' {
				delimiters++
			}
			if c == '&' {
				escapeRun++
			} else {
				escapeRun = 0
			}
			if links > maxLibraryMarkdownLinks || delimiters > maxLibraryMarkdownDelimiters || escapeRun > maxLibraryMarkdownDelimiters {
				return false
			}
		}
	}
	return true
}

func fsAdmit(body string, variant fsVariant) (bool, ast.Node) {
	source := []byte(body)
	context := parser.NewContext()
	document := fsAdmissionParser(variant).Parse(text.NewReader(source), parser.WithContext(context))
	if context.Get(fsAdmissionExceeded) != nil {
		return false, document
	}
	within := true
	_ = ast.Walk(document, func(node ast.Node, entering bool) (ast.WalkStatus, error) {
		if !entering || node.Type() != ast.TypeBlock {
			return ast.WalkContinue, nil
		}
		if node.IsRaw() {
			return ast.WalkSkipChildren, nil
		}
		if !fsInlineWithinBudget(source, node.Lines()) {
			within = false
			return ast.WalkStop, nil
		}
		return ast.WalkContinue, nil
	})
	return within, document
}

// ---- Harness ----

const fsNotice = `<p class="meta">Plain-text preview: Markdown formatting complexity limit reached.</p>`
const fsJSON = `{"label":"example","args":["--check","--read-only"],"enabled":true}`
const fsAttackLine = "{\"label\":\"[a](*_`<x>&\",\"args\":[\"[\",\"](\"]}"

func fsDirect(body string) (string, error) {
	markdown := goldmark.New(goldmark.WithRendererOptions(renderer.WithNodeRenderers(util.Prioritized(libraryInertNodes{}, 100))))
	var out libraryPreviewWriter
	err := markdown.Convert([]byte(body), &out)
	return out.String(), err
}

func fsRender(body string, variant fsVariant) (string, bool, error) {
	if admitted, _ := fsAdmit(body, variant); !admitted {
		return fsNotice + "<pre><code>" + html.EscapeString(body) + "</code></pre>", true, nil
	}
	out, err := fsDirect(body)
	return out, false, err
}

type fsBlock struct {
	Kind  string
	Depth int
	Lines [][2]int
}

func fsSkeleton(document ast.Node) []fsBlock {
	var blocks []fsBlock
	var visit func(node ast.Node, depth int)
	visit = func(node ast.Node, depth int) {
		if node.Type() == ast.TypeInline {
			return
		}
		block := fsBlock{Kind: node.Kind().String(), Depth: depth}
		if node.Type() == ast.TypeBlock {
			for index := 0; index < node.Lines().Len(); index++ {
				segment := node.Lines().At(index)
				block.Lines = append(block.Lines, [2]int{segment.Start, segment.Stop})
			}
		}
		blocks = append(blocks, block)
		for child := node.FirstChild(); child != nil; child = child.NextSibling() {
			visit(child, depth+1)
		}
	}
	visit(document, 0)
	return blocks
}

func fsTime(run func()) (time.Duration, time.Duration) {
	start := time.Now()
	run()
	cold := time.Since(start)
	best := cold
	for repeat := 0; repeat < 2; repeat++ {
		start = time.Now()
		run()
		if elapsed := time.Since(start); elapsed < best {
			best = elapsed
		}
	}
	return cold, best
}

func fsLog(t *testing.T, record map[string]any) {
	t.Helper()
	line, err := json.Marshal(record)
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("FS1 %s", line)
}

func fsPrefix(prefix, block string) string {
	var out strings.Builder
	for _, line := range strings.SplitAfter(block, "\n") {
		if line != "" {
			out.WriteString(prefix + line)
		}
	}
	return out.String()
}

func fsReferences(count int) string {
	var body strings.Builder
	for index := 0; index < count; index++ {
		fmt.Fprintf(&body, "[r%d]: /u%d\n", index, index)
	}
	return body.String() + "\nSee [r1].\n"
}

func fsRealDocs(t *testing.T) map[string]string {
	t.Helper()
	dir, ids := os.Getenv("FS1_REAL_DOCS"), os.Getenv("FS1_REAL_DOC_IDS")
	if dir == "" || ids == "" {
		t.Fatal("FS1_REAL_DOCS and FS1_REAL_DOC_IDS are required")
	}
	file, err := os.Open(ids)
	if err != nil {
		t.Fatal(err)
	}
	defer file.Close()
	pinned := map[string]bool{}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		if fields := strings.Fields(scanner.Text()); len(fields) == 2 {
			pinned[fields[0]] = true
		}
	}
	docs := map[string]string{}
	err = filepath.WalkDir(dir, func(path string, entry os.DirEntry, err error) error {
		if err != nil || entry.IsDir() {
			return err
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		sum := sha256.Sum256(data)
		if !pinned[hex.EncodeToString(sum[:])] {
			return fmt.Errorf("unpinned real document %s", path)
		}
		docs[filepath.Base(filepath.Dir(path))] = string(data)
		return nil
	})
	if err != nil || scanner.Err() != nil || len(docs) != 6 {
		t.Fatalf("real documents=%d err=%v scan=%v", len(docs), err, scanner.Err())
	}
	return docs
}

type fsCase struct{ name, family, body, want string }

func fsCases(t *testing.T) []fsCase {
	t.Helper()
	const formatted, fallback = "formatted", "fallback"
	var cases []fsCase
	add := func(family, name, want, body string) {
		cases = append(cases, fsCase{name: family + "/" + name, family: family, body: body, want: want})
	}
	attack := strings.Repeat("[a](", 15000)
	code := strings.Repeat(fsAttackLine+"\n", 120)
	for name, body := range map[string]string{
		"link_open": strings.Repeat("[a](", 16384), "blockquote_nest": strings.Repeat(">", 65536),
		"ordered_lists": strings.Repeat("1. ", 21845), "unmatched_emphasis": strings.Repeat("*_", 32768),
		"unclosed_code": strings.Repeat("`a", 32768), "maximal_escape": strings.Repeat("&", 65536),
		"raw_html": "<script>window.catalogAttack=1</script>\n" + strings.Repeat(">", 65000),
	} {
		add("seven", name, fallback, body)
	}
	fenced := "# Settings guide\n\n- Review the following configuration example.\n\n  ```json\n" + strings.Repeat("  "+fsJSON+"\n", 700) + "  ```\n\n- Check the result.\n"
	indented := "# Settings guide\n\n- Review the following configuration example.\n\n" + strings.Repeat("      "+fsJSON+"\n", 700) + "\n- Check the result.\n"
	if len(fenced) != 49102 || len(indented) != 51886 {
		t.Fatalf("witness generators drifted: %d %d", len(fenced), len(indented))
	}
	add("witness", "nested_fenced", formatted, fenced)
	add("witness", "nested_indented", formatted, indented)
	for name, body := range fsRealDocs(t) {
		add("real", name, formatted, body)
	}
	for _, size := range []int{16 << 10, 32 << 10, 64 << 10} {
		for _, codeHeavy := range []bool{false, true} {
			add("ordinary", fmt.Sprintf("%d_code_%t", size, codeHeavy), formatted, ordinaryLibraryMarkdown(t, size, codeHeavy))
		}
	}
	for _, unit := range []struct {
		name, unit string
		limit      int
	}{{"link_labels", "[", 256}, {"link_destinations", "[a](", 128}, {"html_candidates", "<", 256}, {"emphasis", "*", 1024}, {"code_delimiters", "`a", 1024}, {"quote_depth", ">", 64}, {"list_depth", "1. ", 64}, {"escape_run", "&", 1024}} {
		for _, delta := range []int{-1, 0, 1} {
			body := strings.Repeat(unit.unit, unit.limit+delta)
			body += strings.Repeat("ordinary trailing text ", (65536-len(body))/23)
			want := formatted
			if delta > 0 {
				want = fallback
			}
			add("boundary-existing", fmt.Sprintf("%s_%d", unit.name, unit.limit+delta), want, body)
		}
	}
	add("boundary-existing", "repeated_constructs", formatted, "# Repeated constructs\n\n"+strings.Repeat("**Check** `value[key]` and [label](https://outside.invalid).\n\n", 1000))
	for name, body := range map[string]string{
		"nested_indented_code": "- item\n\n    " + attack + "\n", "paragraph_indented_continuation": "An ordinary paragraph\n    " + attack + "\n",
		"indented_code_dedent": "    literal [a](*_`<tag>&\n\n" + attack, "surrounding_prose": "# Notes\n\nAn ordinary paragraph.\n\n" + attack + "\n\nFinal notes.\n",
		"surrounding_fences": "```go\nfmt.Println(1)\n```\n\n" + attack + "\n\n~~~sh\nprintf safe\n~~~\n", "longer_closer": "```go\nfmt.Println(1)\n````\n\n" + attack,
		"indented_closer": "~~~sh\nprintf safe\n   ~~~\n\n" + attack, "invalid_backtick_info": "```not`a`fence\n" + attack,
		"nested_fence_dedent": "- item\n\n  ```text\n  literal\n" + attack, "html_script_fake_fence": "<script>\n\n```text\n</script>\n\n" + attack,
		"html_comment_fake_fence": "<!--\n\n```text\n-->\n\n" + attack, "html_processing_fake_fence": "<?instruction\n\n```text\n?>\n\n" + attack,
		"html_declaration_fake_fence": "<!DOCTYPE\n\n```text\n>\n\n" + attack, "html_cdata_fake_fence": "<![CDATA[\n\n```text\n]]>\n\n" + attack,
		"html_generic_fake_fence": "<div>\n<script>\n</script>\n```text\n\n" + attack,
		"spoof_setext_reference":  "[a]: b\n===\n    " + attack + "\n", "list_paragraph_after_code": "- item\n\n  ```\n  x\n  ```\n  " + attack + "\n",
		"quote_fence_then_lazy": "> ```\n> x\n" + attack + "\n", "list_lazy_continuation": "- item text\n" + attack + "\n",
		"deep_quote_lazy": strings.Repeat(">", 64) + " start\n" + attack + "\n", "html6_then_attack": "<div>\n\n" + attack + "\n",
	} {
		add("bypass", name, fallback, body)
	}
	for name, wrapper := range map[string][2]string{
		"backtick": {"```text\n", "\n```\n"}, "tilde": {"~~~text\n", "\n~~~\n"}, "without_blank": {"# Source\nProse before the fence.\n```text\n", "\n```\n"},
		"unclosed": {"```text\n", ""}, "wrong_closer": {"```text\n~~~\n", ""}, "short_closer": {"````text\n```\n", ""},
	} {
		add("literal", name, formatted, wrapper[0]+strings.Repeat("[a](*_`<tag>&{\"key\":[1,2]})\n", 2200)+wrapper[1])
	}
	add("indented", "indented_block", formatted, "# Source examples\n\n- Read the output.\n\nA root paragraph closes the list.\n\n"+strings.Repeat("    values[\"key\"] = []string{\"[label](\", \"*_`<literal>&\"}\n", 1000))
	add("indented", "indented_fence", formatted, "# Source examples\n\n  ```go\n"+strings.Repeat("values[\"key\"] = []string{\"[label](\", \"*_`<literal>&\"}\n", 1000)+"  ```\n")
	add("mixed", "quote_fenced", formatted, "> Example:\n>\n> ```json\n"+fsPrefix("> ", code)+"> ```\n")
	add("mixed", "ordered_fenced", formatted, "1. Step\n\n   ```json\n"+fsPrefix("   ", code)+"   ```\n")
	add("mixed", "three_level_fenced", formatted, "- a\n  - b\n    - c\n\n      ```json\n"+fsPrefix("      ", code)+"      ```\n")
	add("mixed", "quote_list_indented", formatted, "> - item\n>\n"+fsPrefix(">       ", code))
	add("mixed", "list_tilde_unclosed", formatted, "- item\n\n  ~~~text\n"+fsPrefix("  ", code))
	add("mixed", "nested_fence_64k", formatted, "- item\n\n  ```json\n"+strings.Repeat("  "+fsAttackLine+"\n", 1400)+"  ```\n")
	for _, depth := range []int{63, 64, 65} {
		want := formatted
		if depth > 64 {
			want = fallback
		}
		var indentedLists strings.Builder
		for level := 0; level < depth; level++ {
			indentedLists.WriteString(strings.Repeat("  ", level) + "- level\n")
		}
		add("boundary-grammar", fmt.Sprintf("quote_lines_%d", depth), want, strings.Repeat(strings.Repeat(">", depth)+" nested line\n", 40))
		add("boundary-grammar", fmt.Sprintf("indented_lists_%d", depth), want, indentedLists.String())
		add("boundary-grammar", fmt.Sprintf("tab_quotes_%d", depth), want, strings.Repeat(">\t", depth)+"nested text\n")
		add("boundary-grammar", fmt.Sprintf("quote_list_pairs_%d", depth), want, strings.Repeat("> - ", depth/2)+strings.Repeat(">", depth%2)+" nested text\n")
	}
	for _, count := range []int{255, 256, 257} {
		want := formatted
		if count > 256 {
			want = fallback
		}
		add("boundary-grammar", fmt.Sprintf("definitions_%d", count), want, fsReferences(count))
	}
	return cases
}

func TestFS1AdmissionDecisions(t *testing.T) {
	for _, tc := range fsCases(t) {
		if len(tc.body) > pack.MaxBodyBytes || !utf8.ValidString(tc.body) || strings.ContainsRune(tc.body, 0) {
			t.Fatalf("invalid probe input %s bytes=%d", tc.name, len(tc.body))
		}
		var output string
		var fellBack bool
		var renderErr error
		cold, best := fsTime(func() { output, fellBack, renderErr = fsRender(tc.body, fsCandidate) })
		admissionStart := time.Now()
		admitted, document := fsAdmit(tc.body, fsCandidate)
		admission := time.Since(admissionStart)
		committedStart := time.Now()
		committed, committedErr := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: tc.body})
		committedElapsed := time.Since(committedStart)
		decision, committedDecision, structure := "formatted", "formatted", "not-applicable"
		if fellBack {
			decision = "fallback"
		}
		if strings.Contains(string(committed), "Plain-text preview:") {
			committedDecision = "fallback"
		}
		fallbackExact := !fellBack || output == fsNotice+"<pre><code>"+html.EscapeString(tc.body)+"</code></pre>"
		if admitted && renderErr == nil {
			structure = "identical"
			if !reflect.DeepEqual(fsSkeleton(document), fsSkeleton(goldmark.DefaultParser().Parse(text.NewReader([]byte(tc.body))))) {
				structure = "DIFFERENT"
				t.Errorf("O4 structure disagreement %s", tc.name)
			}
			if committedDecision == "formatted" && committedErr == nil && output != string(committed) {
				t.Errorf("O3 admitted output differs from committed renderer %s", tc.name)
			}
		}
		fsLog(t, map[string]any{"kind": "decision", "name": tc.name, "family": tc.family, "bytes": len(tc.body), "expected": tc.want,
			"candidate": decision, "committed": committedDecision, "structure": structure, "fallback_exact": fallbackExact,
			"render_error": fmt.Sprint(renderErr), "cold_ns": cold.Nanoseconds(), "best_ns": best.Nanoseconds(),
			"admission_ns": admission.Nanoseconds(), "committed_ns": committedElapsed.Nanoseconds()})
		if renderErr != nil || decision != tc.want {
			t.Errorf("O1 decision %s: got %s want %s err=%v", tc.name, decision, tc.want, renderErr)
		}
		if !fallbackExact {
			t.Errorf("O2 inexact fallback %s", tc.name)
		}
		if cold > time.Second {
			t.Errorf("EXPERIMENTAL WATCHDOG %s cold=%s", tc.name, cold)
		}
	}
}

func TestFS1BlockPhaseScaling(t *testing.T) {
	fill := func(unit string, size int) string { return strings.Repeat(unit, size/len(unit)) }
	references := func(size int) string {
		var body strings.Builder
		for index := 0; body.Len() < size-16; index++ {
			fmt.Fprintf(&body, "[r%d]: /u\n", index)
		}
		return body.String()
	}
	families := []struct {
		name, want string
		build      func(int) string
	}{
		{"quote_single_line", "fallback", func(n int) string { return fill(">", n) }},
		{"ordered_single_line", "fallback", func(n int) string { return fill("1. ", n) }},
		{"link_open", "fallback", func(n int) string { return fill("[a](", n) }},
		{"unclosed_code", "fallback", func(n int) string { return fill("`a", n) }},
		{"references", "fallback", references},
		{"quote_lines_depth64", "formatted", func(n int) string { return fill(strings.Repeat(">", 64)+" line\n", n) }},
		{"ordered_lines_depth64", "formatted", func(n int) string { return fill(strings.Repeat("1. ", 64)+"x\n", n) }},
		{"lazy_depth64", "formatted", func(n int) string {
			head := strings.Repeat(">", 64) + " start\n"
			return head + fill("lazy continuation text\n", n-len(head))
		}},
		{"tab_quote_depth64", "formatted", func(n int) string { return fill(strings.Repeat(">\t", 64)+"x\n", n) }},
		{"nested_fenced_json", "formatted", func(n int) string {
			head := "- item\n\n  ```json\n"
			return head + fill("  "+fsJSON+"\n", n-len(head)-6) + "  ```\n"
		}},
		{"headings", "formatted", func(n int) string { return fill("###### x\n", n) }},
		{"thematic", "formatted", func(n int) string { return fill("***\n", n) }},
		{"html_blocks", "formatted", func(n int) string { return fill("<div>\nx\n\n", n) }},
		{"long_line", "formatted", func(n int) string { return fill("a", n) }},
	}
	for _, family := range families {
		bests := map[int]time.Duration{}
		for _, size := range []int{8 << 10, 16 << 10, 32 << 10, 64 << 10} {
			body := family.build(size)
			if len(body) > pack.MaxBodyBytes {
				t.Fatalf("%s exceeds body cap", family.name)
			}
			var fellBack bool
			var renderErr error
			cold, best := fsTime(func() { _, fellBack, renderErr = fsRender(body, fsCandidate) })
			_, admissionBest := fsTime(func() { fsAdmit(body, fsCandidate) })
			decision := "formatted"
			if fellBack {
				decision = "fallback"
			}
			bests[size] = best
			fsLog(t, map[string]any{"kind": "scaling", "family": family.name, "bytes": len(body), "expected": family.want, "candidate": decision,
				"cold_ns": cold.Nanoseconds(), "best_ns": best.Nanoseconds(), "admission_best_ns": admissionBest.Nanoseconds(), "render_error": fmt.Sprint(renderErr)})
			if renderErr != nil || decision != family.want {
				t.Errorf("O1 scaling decision %s/%d: got %s want %s err=%v", family.name, size, decision, family.want, renderErr)
			}
			if cold > time.Second {
				t.Errorf("EXPERIMENTAL WATCHDOG %s/%d cold=%s", family.name, size, cold)
			}
		}
		if large, half := bests[64<<10], bests[32<<10]; large >= time.Millisecond && float64(large) > 3.0*float64(half) {
			t.Errorf("SUPERLINEAR %s best64=%s best32=%s", family.name, large, half)
		}
	}
}

func TestFS1NegativeControls(t *testing.T) {
	spoof := "[a]: b\n===\n    " + strings.Repeat("[a](", 15000) + "\n"
	deep := strings.Repeat(">", 65) + "x"
	candidateSpoof, _ := fsAdmit(spoof, fsCandidate)
	noTransformers, _ := fsAdmit(spoof, fsVariant{depth: true, definitions: true, transformers: false})
	candidateDeep, _ := fsAdmit(deep, fsCandidate)
	noDepth, _ := fsAdmit(deep, fsVariant{depth: false, definitions: true, transformers: true})
	candidateReferences, _ := fsAdmit(fsReferences(257), fsCandidate)
	var noDefinitions bool
	_, noDefinitionsBest := fsTime(func() {
		noDefinitions, _ = fsAdmit(fsReferences(5000), fsVariant{depth: true, definitions: false, transformers: true})
	})
	fsLog(t, map[string]any{"kind": "negative", "candidate_spoof_admitted": candidateSpoof, "nc1_no_transformers_admitted": noTransformers,
		"candidate_depth65_admitted": candidateDeep, "nc2_no_depth_admitted": noDepth, "candidate_definitions257_admitted": candidateReferences,
		"nc3_no_definitions_admitted": noDefinitions, "nc3_no_definitions_admission_best_ns": noDefinitionsBest.Nanoseconds()})
	if candidateSpoof || candidateDeep || candidateReferences {
		t.Error("candidate admitted a negative-control input")
	}
	if !noDepth {
		t.Error("NC2 insensitive: depth wrapper is not load-bearing for >x65")
	}
	if !noTransformers {
		t.Log("NC1 not discriminating: report; O4 remains the soundness evidence")
	}
}

func TestFS1RandomWrappedDocuments(t *testing.T) {
	random := rand.New(rand.NewSource(86901))
	code := strings.Repeat(fsAttackLine+"\n", 100)
	fragments := []string{
		"Ordinary **prose** with `code` and [label](https://outside.invalid).\n",
		"## Section\n",
		"```json\n" + code + "```\n",
		"Code follows:\n\n" + fsPrefix("    ", code),
	}
	wrap := func(kind int, block string) string {
		switch kind {
		case 1:
			return "- " + strings.Replace(fsPrefix("  ", block), "  ", "", 1)
		case 2:
			return "1. " + strings.Replace(fsPrefix("   ", block), "   ", "", 1)
		case 3:
			return strings.ReplaceAll(fsPrefix("> ", block), "> \n", ">\n")
		case 4:
			return strings.ReplaceAll(fsPrefix("> ", "- "+strings.Replace(fsPrefix("  ", block), "  ", "", 1)), "> \n", ">\n")
		}
		return block
	}
	for index := 0; index < 200; index++ {
		var parts []string
		for part := 0; part < 4; part++ {
			parts = append(parts, wrap(random.Intn(5), fragments[random.Intn(len(fragments))]))
		}
		clean := strings.Join(parts, "\n\n")
		poisoned := append([]string{}, parts...)
		poisoned[random.Intn(len(poisoned))] = wrap(random.Intn(5), strings.Repeat("[a](", 300)+"\n")
		for _, tc := range []struct{ name, body, want string }{
			{fmt.Sprintf("random/%03d/code_only", index), clean, "formatted"},
			{fmt.Sprintf("random/%03d/paragraph_attack", index), strings.Join(poisoned, "\n\n"), "fallback"},
		} {
			output, fellBack, err := fsRender(tc.body, fsCandidate)
			decision := "formatted"
			if fellBack {
				decision = "fallback"
			}
			structure := "not-applicable"
			if admitted, document := fsAdmit(tc.body, fsCandidate); admitted {
				structure = "identical"
				if !reflect.DeepEqual(fsSkeleton(document), fsSkeleton(goldmark.DefaultParser().Parse(text.NewReader([]byte(tc.body))))) {
					structure = "DIFFERENT"
					t.Errorf("O4 structure disagreement %s", tc.name)
				}
			}
			fsLog(t, map[string]any{"kind": "random", "name": tc.name, "family": "random", "bytes": len(tc.body), "expected": tc.want, "candidate": decision,
				"structure": structure, "fallback_exact": !fellBack || output == fsNotice+"<pre><code>"+html.EscapeString(tc.body)+"</code></pre>"})
			if err != nil || decision != tc.want {
				t.Errorf("O1 random decision %s: got %s want %s err=%v", tc.name, decision, tc.want, err)
			}
		}
	}
}
```

The probe uses only package symbols that exist at `1293ce1`: `renderLibraryPreview`, `libraryInertNodes`, `libraryPreviewWriter`, `ordinaryLibraryMarkdown`, `maxLibraryMarkdown{Depth,Links,Delimiters}`. If a compile error shows an API mismatch, **stop and return it to Opus** rather than redesigning.

### FS-1 commands (run only after go for FS-1; one invocation; worktree is never written)

```bash
set -euo pipefail
WT=/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser
EV=/Users/justin/.hermes/plans/leorna/evidence/86bcm901v
PLAN=/Users/justin/.hermes/plans/leorna/86bcm901v-preview-admission-recovery.md
NS="$EV/feasibility-admission-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir "$NS"
mkdir "$NS/probe" "$NS/logs" "$NS/results" "$NS/gocache" "$NS/tmp"
test "$(GIT_OPTIONAL_LOCKS=0 git -C "$WT" rev-parse HEAD)" = 1293ce1ff48c184235bb7a066631d5fb87551cd9
test -z "$(GIT_OPTIONAL_LOCKS=0 git -C "$WT" status --porcelain=v1 -uall)"
GIT_OPTIONAL_LOCKS=0 git -C "$WT" ls-files -s -z | shasum -a 256 > "$NS/logs/index-before.sha256"
# Materialize the probe from the first ```go fence under "FS-1 probe" in this plan: exact interior bytes, one final LF.
python3 -I - "$PLAN" "$NS/probe/zz_fs1_admission_test.go" <<'PY'
import pathlib, re, sys
plan = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
section = plan.split("### FS-1 probe", 1)[1]
body = re.search(r"^```go\n(.*?)^```", section, re.M | re.S).group(1)
assert body.startswith("package web\n") and "func TestFS1AdmissionDecisions" in body
pathlib.Path(sys.argv[2]).write_text(body.rstrip("\n") + "\n", encoding="utf-8")
PY
shasum -a 256 "$NS/probe/zz_fs1_admission_test.go" > "$NS/logs/probe.sha256"
printf '{"Replace":{"%s":"%s"}}\n' "$WT/internal/web/zz_fs1_admission_test.go" "$NS/probe/zz_fs1_admission_test.go" > "$NS/overlay.json"
cd "$WT"
set +e
env GOFLAGS=-mod=readonly GOPROXY=off GOCACHE="$NS/gocache" GOTMPDIR="$NS/tmp" \
  FS1_REAL_DOCS="$EV/review-opus-r2-20261022T234744Z/private/probe-inputs" \
  FS1_REAL_DOC_IDS="$EV/review-opus-r2-20261022T234744Z/probes/realistic-doc-identities.txt" \
  go test -overlay "$NS/overlay.json" -count=1 -timeout 600s -v ./internal/web -run '^TestFS1' > "$NS/logs/fs1.log" 2>&1
status=$?
set -e
printf '{"exit": %d, "end": "%s"}\n' "$status" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$NS/logs/fs1-receipt.json"
test "$(GIT_OPTIONAL_LOCKS=0 git -C "$WT" rev-parse HEAD)" = 1293ce1ff48c184235bb7a066631d5fb87551cd9
test -z "$(GIT_OPTIONAL_LOCKS=0 git -C "$WT" status --porcelain=v1 -uall)"
GIT_OPTIONAL_LOCKS=0 git -C "$WT" ls-files -s -z | shasum -a 256 | cmp - "$NS/logs/index-before.sha256"
python3 -I - "$NS/logs/fs1.log" "$NS/logs/fs1-receipt.json" "$NS/results/fs1-summary.json" <<'PY'
import json, sys
log_path, receipt_path, out_path = sys.argv[1:4]
records, flags = [], []
for line in open(log_path, encoding="utf-8"):
    at = line.find("FS1 {")
    if at >= 0:
        records.append(json.loads(line[at + 4:]))
    for token in ("EXPERIMENTAL WATCHDOG", "SUPERLINEAR", "O4 structure", "O2 inexact", "O3 admitted", "NC2 insensitive", "NC1 not discriminating"):
        if token in line:
            flags.append(line.strip())
exit_code = json.load(open(receipt_path, encoding="utf-8"))["exit"]
rows = [r for r in records if r["kind"] in ("decision", "random", "scaling")]
bad = [r for r in rows if r["candidate"] != r["expected"]]
grammar_only = all(r.get("family") == "boundary-grammar" for r in bad)
unsafe = [r for r in bad if r["expected"] == "fallback"]
inexact = [r for r in rows if r.get("fallback_exact") is False]
different = [r for r in rows if r.get("structure") == "DIFFERENT"]
slow = [f for f in flags if "WATCHDOG" in f or "SUPERLINEAR" in f]
negative = [r for r in records if r["kind"] == "negative"]
if unsafe or inexact or different or (bad and not grammar_only):
    verdict = "INVALIDATED"
elif exit_code != 0 or bad or slow or not negative or not negative[0]["nc2_no_depth_admitted"]:
    verdict = "PARTIAL"
else:
    verdict = "VALIDATED"
summary = {"verdict": verdict, "exit": exit_code, "records": len(records), "decision_mismatches": bad, "unsafe_admissions": unsafe,
           "inexact_fallbacks": inexact, "structure_differences": different, "flags": flags, "negative_controls": negative,
           "note": "Experimental evidence only; not a product SLA or a fixed claim."}
with open(out_path, "w", encoding="utf-8") as handle:
    json.dump(summary, handle, indent=2, sort_keys=True)
print(json.dumps({"verdict": verdict, "exit": exit_code, "records": len(records), "mismatches": len(bad), "flags": len(flags)}))
PY
rm -rf "$NS/gocache" "$NS/tmp"
```

**Stop conditions:**

- Worktree drift before or after;
- `mkdir` collision;
- a missing cached module (`GOPROXY=off`). Report it as an environment fact and do not fetch;
- a compile error;
- `-timeout` panic. Keep the stack as INVALIDATED/PARTIAL evidence.

Never edit the probe to make rows pass; a corrected probe means a new namespace and a recorded reason. **Outputs:** `fs1.log`, `fs1-receipt.json`, `probe.sha256`, `index-*.sha256`, `results/fs1-summary.json`. Sol returns the verdict and these paths. **FS-1 never authorizes T1–T9.**

## 10. GATED implementation (requires FS-1 = VALIDATED **and** Justin's renewed go)

Owner: Sol 6.1 xhigh builder, in the existing worktree and branch.

- **Paths:** only `internal/web/library_preview.go`, `internal/web/library_preview_test.go`, `internal/web/library_browser_test.go`. These are already scoped paths; no new path.
- **Start state:** re-baseline HEAD `1293ce1`, clean status, record the 504-pin inventory.
- **Working rules:** TDD; one behavior per microtask; explicit `git add <paths>`; Justin's identity; no `git add .`.
- **Repair budget:** at most 2 focused repair cycles per microtask, then stop to Opus.

### T1 — RED: ordinary nested code keeps formatting (test only)

Replace the import block of `library_preview_test.go`, then append the declarations below.

```go
// Replacement import block for internal/web/library_preview_test.go.
import (
	"fmt"
	"html"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/renderer"
	"github.com/yuin/goldmark/util"
)
```

```go
// Append to internal/web/library_preview_test.go.
const libraryNestedJSON = `{"label":"example","args":["--check","--read-only"],"enabled":true}`
const libraryNestedAttackLine = "{\"label\":\"[a](*_`<x>&\",\"args\":[\"[\",\"](\"]}"

func libraryDirectPreview(t *testing.T, body string) string {
	t.Helper()
	markdown := goldmark.New(goldmark.WithRendererOptions(renderer.WithNodeRenderers(util.Prioritized(libraryInertNodes{}, 100))))
	var direct libraryPreviewWriter
	if err := markdown.Convert([]byte(body), &direct); err != nil {
		t.Fatal(err)
	}
	return direct.String()
}

func libraryPrefixed(prefix, block string) string {
	var out strings.Builder
	for _, line := range strings.SplitAfter(block, "\n") {
		if line != "" {
			out.WriteString(prefix + line)
		}
	}
	return out.String()
}

func libraryExpectFallback(t *testing.T, body string) {
	t.Helper()
	got, err := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: body})
	want := `<p class="meta">Plain-text preview: Markdown formatting complexity limit reached.</p><pre><code>` + html.EscapeString(body) + `</code></pre>`
	if err != nil || string(got) != want {
		t.Fatalf("structurally excessive Markdown must use the complete escaped fallback: bytes=%d err=%v", len(body), err)
	}
}

func libraryExpectFormatted(t *testing.T, body string) string {
	t.Helper()
	got, err := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: body})
	if err != nil || strings.Contains(string(got), "Plain-text preview:") || string(got) != libraryDirectPreview(t, body) {
		t.Fatalf("ordinary Markdown must keep the renderer's formatting: bytes=%d err=%v", len(body), err)
	}
	return string(got)
}

func TestLibraryPreviewNestedCodeKeepsFormatting(t *testing.T) {
	code := strings.Repeat(libraryNestedAttackLine+"\n", 120)
	for name, tc := range map[string]struct {
		body  string
		bytes int
	}{
		"nested_fenced":       {"# Settings guide\n\n- Review the following configuration example.\n\n  ```json\n" + strings.Repeat("  "+libraryNestedJSON+"\n", 700) + "  ```\n\n- Check the result.\n", 49102},
		"nested_indented":     {"# Settings guide\n\n- Review the following configuration example.\n\n" + strings.Repeat("      "+libraryNestedJSON+"\n", 700) + "\n- Check the result.\n", 51886},
		"quote_fenced":        {"> Example:\n>\n> ```json\n" + libraryPrefixed("> ", code) + "> ```\n", 0},
		"ordered_fenced":      {"1. Step\n\n   ```json\n" + libraryPrefixed("   ", code) + "   ```\n", 0},
		"three_level_fenced":  {"- a\n  - b\n    - c\n\n      ```json\n" + libraryPrefixed("      ", code) + "      ```\n", 0},
		"quote_list_indented": {"> - item\n>\n" + libraryPrefixed(">       ", code), 0},
		"list_tilde_unclosed": {"- item\n\n  ~~~text\n" + libraryPrefixed("  ", code), 0},
	} {
		t.Run(name, func(t *testing.T) {
			if tc.bytes != 0 && len(tc.body) != tc.bytes {
				t.Fatalf("witness drifted: %d", len(tc.body))
			}
			if strings.Count(tc.body, "[") <= maxLibraryMarkdownLinks {
				t.Fatal("fixture would not detect code being counted as inline text")
			}
			got := libraryExpectFormatted(t, tc.body)
			if !strings.Contains(got, "<pre><code") || !(strings.Contains(got, "<li>") || strings.Contains(got, "<blockquote>")) {
				t.Fatal("nested code block missing from formatted preview")
			}
		})
	}
}
```

- **RED command:**

  ```
  go test ./internal/web -run '^TestLibraryPreviewNestedCodeKeepsFormatting$' -count=1 -v
  ```

- **Intended RED:** `ordinary Markdown must keep the renderer's formatting` on at least `nested_fenced` and `nested_indented`. A compile or import error is **not** RED.
- **No commit yet** (no seam needed).

### T2 — GREEN: grammar-derived admission (complete `library_preview.go`)

Replace the whole file with the following. Lines 179–238 (writer, inert nodes, `renderLibraryPreview`) are byte-identical in meaning to `1293ce1`. The `regexp` import, `libraryMarkdownFence`, the HTML regexes and the line state machine are removed.

```go
package web

import (
	"bytes"
	"errors"
	"html"
	"html/template"
	"io"
	"strings"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/ast"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer"
	"github.com/yuin/goldmark/text"
	"github.com/yuin/goldmark/util"
)

var errLibraryPreview = errors.New("library preview could not be rendered")

const maxLibraryPreviewBytes = 1 << 20

// Admission uses the renderer's own goldmark block grammar. Inline limits apply
// to one inline-parsed block (goldmark's inline work unit); raw code and HTML
// blocks are never inline-parsed and consume no budget at any nesting depth.
const (
	maxLibraryMarkdownLinks      = 256  // link/HTML candidates per block; link reference definitions per paragraph
	maxLibraryMarkdownDelimiters = 1024 // emphasis/code delimiters per block; contiguous ampersands per line
	maxLibraryMarkdownDepth      = 64   // nested blockquotes plus list items
)

var libraryAdmissionExceeded = parser.NewContextKey()

func libraryContainerDepth(node ast.Node) int {
	depth := 0
	for ; node != nil; node = node.Parent() {
		if node.Kind() == ast.KindBlockquote || node.Kind() == ast.KindListItem {
			depth++
		}
	}
	return depth
}

// goldmark recomputes the line offset for every container opened on a line, so
// unbounded nesting is quadratic. Refuse deeper openings and record fallback.
type libraryDepthLimited struct{ parser.BlockParser }

func (limited libraryDepthLimited) Open(parent ast.Node, reader text.Reader, pc parser.Context) (ast.Node, parser.State) {
	if pc.Get(libraryAdmissionExceeded) != nil || libraryContainerDepth(parent) >= maxLibraryMarkdownDepth {
		pc.Set(libraryAdmissionExceeded, true)
		return nil, parser.NoChildren
	}
	return limited.BlockParser.Open(parent, reader, pc)
}

// Link reference extraction is quadratic in definitions per paragraph; every
// definition contains an adjacent "]:", so that count is a cheap upper bound.
type libraryDefinitionsLimited struct{ parser.ParagraphTransformer }

func (limited libraryDefinitionsLimited) Transform(node *ast.Paragraph, reader text.Reader, pc parser.Context) {
	if pc.Get(libraryAdmissionExceeded) != nil {
		return
	}
	definitions, lines, source := 0, node.Lines(), reader.Source()
	for index := 0; index < lines.Len(); index++ {
		segment := lines.At(index)
		definitions += bytes.Count(source[segment.Start:segment.Stop], []byte("]:"))
	}
	if definitions > maxLibraryMarkdownLinks {
		pc.Set(libraryAdmissionExceeded, true)
		return
	}
	limited.ParagraphTransformer.Transform(node, reader, pc)
}

// goldmark's default block parsers and paragraph transformers without inline
// parsers: the same block tree as the renderer unless a limit is refused.
func libraryAdmissionParser() parser.Parser {
	blocks := parser.DefaultBlockParsers()
	for index := range blocks {
		switch blocks[index].Value {
		case parser.NewBlockquoteParser(), parser.NewListParser():
			blocks[index].Value = libraryDepthLimited{blocks[index].Value.(parser.BlockParser)}
		}
	}
	transformers := parser.DefaultParagraphTransformers()
	for index := range transformers {
		transformers[index].Value = libraryDefinitionsLimited{transformers[index].Value.(parser.ParagraphTransformer)}
	}
	return parser.NewParser(parser.WithBlockParsers(blocks...), parser.WithParagraphTransformers(transformers...))
}

func libraryInlineWithinBudget(source []byte, lines *text.Segments) bool {
	links, delimiters := 0, 0
	for index := 0; index < lines.Len(); index++ {
		segment := lines.At(index)
		line := source[segment.Start:segment.Stop]
		escapeRun := 0
		for position, c := range line {
			if c == '[' || c == '<' || (c == ']' && position+1 < len(line) && line[position+1] == '(') {
				links++
			}
			if c == '*' || c == '_' || c == '`' {
				delimiters++
			}
			if c == '&' {
				escapeRun++
			} else {
				escapeRun = 0
			}
			if links > maxLibraryMarkdownLinks || delimiters > maxLibraryMarkdownDelimiters || escapeRun > maxLibraryMarkdownDelimiters {
				return false
			}
		}
	}
	return true
}

func libraryMarkdownWithinBudget(body string) bool {
	source := []byte(body)
	context := parser.NewContext()
	document := libraryAdmissionParser().Parse(text.NewReader(source), parser.WithContext(context))
	if context.Get(libraryAdmissionExceeded) != nil {
		return false
	}
	within := true
	_ = ast.Walk(document, func(node ast.Node, entering bool) (ast.WalkStatus, error) {
		if !entering || node.Type() != ast.TypeBlock {
			return ast.WalkContinue, nil
		}
		if node.IsRaw() {
			return ast.WalkSkipChildren, nil
		}
		if !libraryInlineWithinBudget(source, node.Lines()) {
			within = false
			return ast.WalkStop, nil
		}
		return ast.WalkContinue, nil
	})
	return within
}

type libraryPreviewWriter struct{ bytes.Buffer }

func (writer *libraryPreviewWriter) Write(data []byte) (int, error) {
	if writer.Len()+len(data) > maxLibraryPreviewBytes {
		return 0, errLibraryPreview
	}
	return writer.Buffer.Write(data)
}

type libraryInertNodes struct{}

func (libraryInertNodes) RegisterFuncs(register renderer.NodeRendererFuncRegisterer) {
	register.Register(ast.KindLink, libraryInertInline)
	register.Register(ast.KindImage, libraryInertInline)
	register.Register(ast.KindAutoLink, libraryInertAutoLink)
	register.Register(ast.KindRawHTML, libraryOmitHTML)
	register.Register(ast.KindHTMLBlock, libraryOmitHTML)
}
func libraryInertInline(_ util.BufWriter, _ []byte, _ ast.Node, _ bool) (ast.WalkStatus, error) {
	// No element/URL emitted; normal child text/emphasis/code remains escaped by goldmark.
	return ast.WalkContinue, nil
}
func libraryInertAutoLink(writer util.BufWriter, source []byte, node ast.Node, entering bool) (ast.WalkStatus, error) {
	if entering {
		if _, err := io.WriteString(writer, html.EscapeString(string(node.(*ast.AutoLink).Label(source)))); err != nil {
			return ast.WalkStop, err
		}
	}
	return ast.WalkSkipChildren, nil
}
func libraryOmitHTML(_ util.BufWriter, _ []byte, _ ast.Node, _ bool) (ast.WalkStatus, error) {
	return ast.WalkSkipChildren, nil
}

func renderLibraryPreview(item library.Item) (template.HTML, error) {
	if len(item.Body) > pack.MaxBodyBytes || len(item.Example) > library.MaxExampleBytes ||
		!utf8.ValidString(item.Body) || !utf8.ValidString(item.Example) ||
		strings.ContainsRune(item.Body, 0) || strings.ContainsRune(item.Example, 0) {
		return "", errLibraryPreview
	}
	plainText := item.Kind == pack.KindConfig || item.Kind == pack.KindMCPTemplate
	notice := ""
	if !plainText && !libraryMarkdownWithinBudget(item.Body) {
		plainText = true
		notice = `<p class="meta">Plain-text preview: Markdown formatting complexity limit reached.</p>`
	}
	if plainText {
		safe := notice + "<pre><code>" + html.EscapeString(item.Body) + "</code></pre>"
		if len(safe) > maxLibraryPreviewBytes {
			return "", errLibraryPreview
		}
		return template.HTML(safe), nil // generated constant wrapper plus escaped text only
	}
	markdown := goldmark.New(goldmark.WithRendererOptions(renderer.WithNodeRenderers(util.Prioritized(libraryInertNodes{}, 100))))
	var safe libraryPreviewWriter
	if err := markdown.Convert([]byte(item.Body), &safe); err != nil {
		return "", errLibraryPreview
	}
	return template.HTML(safe.String()), nil // parser-generated inert markup; sole audited trusted-HTML boundary
}
```

- **GREEN:**
  1. The unchanged T1 command must pass.
  2. Then the whole existing preview family, unchanged:

     ```
     go test ./internal/web -run '^TestLibraryPreview' -count=1 -v
     ```

  3. All 7 families must be exact fallback, all structural boundaries and code wrappers as before, all inertness/bounds/config tests passing.
- `gofmt -l internal/web` must be empty.
- Commit both files: `feat(86bcm901v): admit previews by goldmark block grammar`.

### T3 — grammar boundaries and bypass characterization (tests; some rows already green)

```go
// Append to internal/web/library_preview_test.go.
func TestLibraryPreviewGrammarDepthBoundaries(t *testing.T) {
	builders := map[string]func(int) string{
		"quote_lines": func(n int) string { return strings.Repeat(strings.Repeat(">", n)+" nested line\n", 40) },
		"indented_lists": func(n int) string {
			var body strings.Builder
			for level := 0; level < n; level++ {
				body.WriteString(strings.Repeat("  ", level) + "- level\n")
			}
			return body.String()
		},
		"tab_quotes":       func(n int) string { return strings.Repeat(">\t", n) + "nested text\n" },
		"quote_list_pairs": func(n int) string { return strings.Repeat("> - ", n/2) + strings.Repeat(">", n%2) + " nested text\n" },
	}
	for name, build := range builders {
		for _, depth := range []int{63, 64, 65} {
			t.Run(fmt.Sprintf("%s/%d", name, depth), func(t *testing.T) {
				if depth > 64 {
					libraryExpectFallback(t, build(depth))
				} else {
					libraryExpectFormatted(t, build(depth))
				}
			})
		}
	}
}

func TestLibraryPreviewReferenceDefinitionBoundary(t *testing.T) {
	for _, count := range []int{255, 256, 257} {
		t.Run(fmt.Sprint(count), func(t *testing.T) {
			var body strings.Builder
			for index := 0; index < count; index++ {
				fmt.Fprintf(&body, "[r%d]: /u%d\n", index, index)
			}
			body.WriteString("\nSee [r1].\n")
			if count > 256 {
				libraryExpectFallback(t, body.String())
			} else {
				libraryExpectFormatted(t, body.String())
			}
		})
	}
}

func TestLibraryPreviewAdmissionFollowsRenderGrammar(t *testing.T) {
	attack := strings.Repeat("[a](", 15000)
	for name, body := range map[string]string{
		"setext_reference_spoof":    "[a]: b\n===\n    " + attack + "\n",
		"list_paragraph_after_code": "- item\n\n  ```\n  x\n  ```\n  " + attack + "\n",
		"quote_fence_then_lazy":     "> ```\n> x\n" + attack + "\n",
		"list_lazy_continuation":    "- item text\n" + attack + "\n",
		"deep_quote_lazy":           strings.Repeat(">", 64) + " start\n" + attack + "\n",
		"html_block_then_attack":    "<div>\n\n" + attack + "\n",
	} {
		t.Run(name, func(t *testing.T) { libraryExpectFallback(t, body) })
	}
}
```

- Run:

  ```
  go test ./internal/web -run '^TestLibraryPreview(GrammarDepthBoundaries|ReferenceDefinitionBoundary|AdmissionFollowsRenderGrammar)$' -count=1 -v
  ```

  It must pass on T2's code.
- **Honest chronology:** these tests were written after T2.
  - `indented_lists/65` is the only row expected to differ from `1293ce1` (named delta 7b). It was characterized, not observed RED.
  - The other rows also pass on the old code, so their sensitivity comes **only** from T5's mutants.
- Commit: `test(86bcm901v): pin grammar admission boundaries`.

### T4 — browser coverage of the nested witnesses (env-gated, existing harness)

```go
// Append to internal/web/library_browser_test.go (existing imports already include fmt, time and chromedp).
func TestLibraryBrowserNestedCodeWithPostgres(t *testing.T) {
	f := newPackFixture(t)
	f.handler.SetLibrary(f.repository)
	items := seedLibraryCatalogRows(t, f, 1)
	ctx, evidence := libraryBrowser(t, f, false)
	for name, body := range map[string]string{
		"nested-fenced":   "# Settings guide\n\n- Review the following configuration example.\n\n  ```json\n" + strings.Repeat("  "+libraryNestedJSON+"\n", 700) + "  ```\n\n- Check the result.\n",
		"nested-indented": "# Settings guide\n\n- Review the following configuration example.\n\n" + strings.Repeat("      "+libraryNestedJSON+"\n", 700) + "\n- Check the result.\n",
	} {
		if _, err := f.pool.Exec(t.Context(), `UPDATE library_items SET body=$1 WHERE id=$2`, body, items[0].ID); err != nil {
			t.Fatal(err)
		}
		start := time.Now()
		response, err := chromedp.RunResponse(ctx, chromedp.Navigate(f.server.URL+"/admin/library/items/"+items[0].ID))
		if err != nil || response.Status != 200 {
			t.Fatalf("nested preview status err=%v", err)
		}
		var state struct{ Heading, NestedCode, Notice bool }
		if err := chromedp.Run(ctx, chromedp.Evaluate(`({Heading:!!document.querySelector('#library-preview h1'),NestedCode:!!document.querySelector('#library-preview li pre code'),Notice:!!document.querySelector('#library-preview .meta')})`, &state), chromedp.ScrollIntoView("#library-preview", chromedp.ByQuery)); err != nil {
			t.Fatal(err)
		}
		t.Logf("nested route body=%s cold_request=%s DOM=%+v", name, time.Since(start), state)
		captureLibrary(t, ctx, evidence, fmt.Sprintf("%s-formatted.png", name))
		if !state.Heading || !state.NestedCode || state.Notice {
			t.Errorf("nested code lost browser formatting: %s DOM=%+v", name, state)
		}
		assertLibraryBrowser(t, ctx, `document.querySelectorAll('#library-preview script,#library-preview img,#library-preview iframe,#library-preview svg,#library-preview form,#library-preview style,#library-preview a[href]').length===0`)
	}
}
```

- **Before-capture:** run this same test **at `1293ce1`** with the T1 test file stashed? **No.** Stashing is forbidden. The visible "before" state is already preserved by the stopped fixer's evidence (`nested-code-class-recheck.log` plus the earlier fallback screenshots `captures/restored-final-family/complex-plain-text-preview-1.png`). Cite those; do not reconstruct a before image.
- **Run (Chrome env and Postgres required; SKIP is not acceptance):**

  ```
  go test ./internal/web -run '^TestLibraryBrowser(NestedCode|OrdinaryDocuments|ComplexPreview)WithPostgres$' -count=1 -v
  ```

- Commit: `test(86bcm901v): exercise nested code in the browser preview`.

### T5 — falsification (each mutant must compile, be caught, then be restored by exact diff)

| Mutant (one at a time, in `library_preview.go`) | Must fail |
| --- | --- |
| M1 do not wrap Blockquote/List (use defaults) | `GrammarDepthBoundaries/*/65` and `ComplexMarkdownFallsBack/{blockquote_nest,ordered_lists}` (slow but bounded; `-timeout 300s`) |
| M2 omit paragraph transformers from admission | `AdmissionFollowsRenderGrammar/setext_reference_spoof` |
| M3 transform without the `]:` bound | `ReferenceDefinitionBoundary/257` |
| M4 count raw blocks (remove the `IsRaw` skip) | `NestedCodeKeepsFormatting/*`, `IndentedCodeKeepsFormatting/*`, literal-code rows |
| M5 one counter for the whole document (hoist `links, delimiters` out of per-block) | `StructuralBudgetBoundaries` repeated-constructs body |
| M6 drop the `escapeRun` limit | `ComplexMarkdownFallsBack/maximal_escape`, `escape_run/1025` |
| M7 depth `>` instead of `>=` | `GrammarDepthBoundaries/*/65` |
| M8 walk stops after the first block | `CodeSpansAndSurroundingAdversaries/surrounding_prose` |

Record for each mutant: mutant id, the failing assertion, exit, and that the restored tree's diff against the pre-mutation candidate is empty. A compile error or timeout is not a caught mutant.

### T6 — gates on the exact candidate head (unchanged canonical commands)

```bash
set -euo pipefail
cd /Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
realpath --relative-to="$PWD" "$PWD"
test -n "${LEORNA_TEST_DATABASE_URL:-}"
go test ./internal/web -run '^TestLibraryPreview' -count=1 -v
go test ./internal/library ./internal/store/postgres ./internal/web -run 'Test(Catalog|Library|EnsureLibrary|PackCatalog|Packs)' -count=1 -v
go test ./internal/web -run '^TestLibraryFiltering(ServerTime|Stress)WithPostgres$' -count=1 -v
GOLANGCI_LINT="${verified_linter:?bind the verified CI-matching linter path}" make check
bash ./scripts/test-module-add.sh
git diff --check
git diff --name-only 0da9f5443a2a49b157cf24b5d30301345d371d3e...HEAD -- .github/
```

Notes:

- The `export PATH` above is shell-local to that gate script, not a persistent profile change.
- Rerun FS-1's probe once, unchanged, through a **new** namespace against the committed candidate. Use the decision, scaling and random sets as evidence (not a product AC). The candidate functions in the probe are then redundant with production but harmless.
- Rerun the six real docs through FS-1 rows.
- Strict AC3: all 240-row samples under 300 ms. The 2000-row run is reporting only.

### T7 — evidence while building

- Use per-head logs `gates-<sha7>.txt`, `mutations-<sha7>.txt`, `fs1-candidate-<sha7>/summary.json`.
- Screenshots `nested-fenced-formatted.png` and `nested-indented-formatted.png` from T4.
- The existing fallback/ordinary captures must be retaken on the new head by the existing browser tests.
- Inspect every image for private data.
- Keep the R2 stopped evidence immutable.

### T8 — reviews (no self-approval)

- After T6 is green, run a **fresh full independent Opus 5.5 xhigh review** of the complete feature range `0da9f54..HEAD`, with a focused look at `1293ce1..HEAD`, OPUS-R2-F1, FS-1 evidence and every earlier finding.
- Sol fixes valid findings; a behavioral fix means another fresh re-review.
- Agent Defect Loop verifier: **N/A** (§12) unless a loop skill becomes applicable.

### T9 — Docs & records (final, dedicated commit; parent-coordinated finisher)

See §13.

## 11. Risks, unknowns and questions

**Genuine unknowns (FS-1 decides):**

- (U1) Whether O(D·N) block work with D=64 is cheap enough in practice. Candidates for trouble: `ordered_lines_depth64` (output roughly 7× the input) and `tab_quote_depth64` (padding copies).
- (U2) Whether some other block family not modeled in §6 is superlinear.
- (U3) Whether goldmark's skeleton is identical between the no-inline and full parsers on every row (O4).

**Risks:**

- Admission now costs one extra block-phase parse for every Markdown preview. This is expected to be sub-millisecond for ordinary documents, and FS-1 measures it.
- The wrappers rely on two things: (a) the `DefaultBlockParsers` singleton identity used by the `switch`, and (b) refusing `List` before any item opens. Both are pinned by T3/T5 and by the dependency pin. A future goldmark upgrade must rerun FS-1.
- The `]:` bound over-counts literal prose such as "note]:" as well as actual reference definitions. Above 256 pairs in one paragraph, it can select plain text even without 257 real definitions. This is a proposed additional conservative fallback trigger, NOT an already accepted limitation; any later Q2 approval must include it explicitly.

**Questions for Justin (approval items, not silent policy):**

- **Q1.** Approve running FS-1 (isolated, evidence-only)?
- **Q2.** If FS-1 = VALIDATED, do you accept the named semantic deltas in §7, including:
  - 7b: lists nested more than 64 levels by indentation fall back;
  - 7c: at most 256 literal `]:` pairs per paragraph, including non-definition prose?

  Both reuse numbers from the current implementation, but their counting domains and behavior change. Reuse is NOT prior user approval. Q2 remains a separate, pending product-policy decision; FS-1 permission does not accept these deltas.

## 12. Skills and loop audit

**Freshly loaded for this planning task (successful `skill_view` results):**

- `leorna`, `engineering-best-practices`, `systematic-debugging`;
- `implementation-planning` + `references/plan-validation.md`;
- `algorithmic-engineering-validation` + `references/algorithmic-engineering-validation.md`;
- `spike` (research/planning only; its build/directory steps were not used);
- `ux-frontend-workbench`, `frontend-testing-workflow`, `security-best-practices`, `multi-tenant-auth-management`, `concurrent-state-validation`, `review-fix-cadence`.

No math/solver tooling was installed or needed.

**Loop audit (scoped):** the actual relevant skills loaded for this recovery have no applicable specialist `Mandatory Validation and Agent Defect Loop` section, so the current recovery reports `defect_loop_skills: []`. This is not a claim about every installed skill and not a permanent verifier waiver. The parent re-audits actual future role loads; any newly applicable specialist loop requires its separate fresh Opus verifier. Required independent reviews/re-review remain. API contract and migration specialists are **N/A** while there is no API or schema scope.

**Required skills by role:**

- **FS-1 executor (Sol):** `leorna`, `engineering-best-practices`, `systematic-debugging`, `algorithmic-engineering-validation`, `spike` (verdict format only), `concurrent-state-validation`.
- **Builder (T1–T7):** the above, plus `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `ux-frontend-workbench`, `frontend-testing-workflow`, `git-commit-rules`.
- **Reviewer:** `requesting-code-review` + `code-review-practice` (report only), plus the preview security specialists.
- **Finisher:** `receiving-code-review`, `git-commit-rules`, `test-driven-development`.

The parent re-audits actual loads.

## 13. Docs & records — final named task with its own commit (later coordinated finisher)

Only after T8 is clean and the parent has reconciled sibling ownership:

- `internal/library/README.md` catalog section. Add the preview admission contract (§7 grammar/limits/CPU argument), the exact test names from T1/T3/T4, and FS-1 evidence paths. Preserve the sibling sections.
- `delivery/stories.json`. Use the entry prepared from the private drafts; add the PR number only after a PR exists.
- Approved plan links: the original plan plus this recovery plan.
- Closing evidence draft: AC → test → result. FS-1 is labeled as experimental evidence. The following stay explicitly **NOT VERIFIED / held**:
  - manual operator walkthrough;
  - **actual** 200% browser zoom (fixtures, CDP or viewport emulation are not proof);
  - hosted CI;
  - combined sibling head;
  - publication.
- Commit: `docs(86bcm901v): record preview admission contract and evidence`.
- No push, PR, merge, deploy or ClickUp write without Justin's separate instruction. Manual acceptance is never deferred to after merge.

## 14. Approval stopping point

- **Planner stops here.** Ready now, after go: **FS-1 only**.
- **Gated:** T1–T9, until FS-1 = VALIDATED is admitted by the parent and Justin gives a renewed go covering the §7 deltas.
- **PARTIAL or INVALIDATED** goes back to Opus with the evidence. Sol must not patch heuristics; §8's fallback design is not automatically authorized.

## 15. Planner validation receipt

At 2026-10-23T02:27Z the following checks ran in memory against this saved file. No files were written apart from this plan.

**Go fences (6):** all parsed with `/usr/local/go/bin/gofmt -e` via stdin.

- Three fragments were wrapped with `package web` only for parsing: the T1 import block, the T1/T3 appended declarations and the T4 appended function.
- The full FS-1 probe and the full `library_preview.go` are already gofmt-formatted byte for byte; one alignment was fixed after the first check.
- The FS-1 materializer's selection regex selects the probe fence.
- The T2 file's writer/inert-renderer/`renderLibraryPreview` tail is **byte-identical** to `1293ce1`.

**Bash fences (2):** both pass `/bin/bash -n`.

**Not checked:** the indented single-command fences inside list items (plain `go test` lines) were not parsed. No NUL bytes.

**Scope of this evidence:** this is syntax and format evidence only.

- **No** typecheck, compile, test, probe, benchmark, server or browser run happened.
- **No** source, test, fixture, README, delivery, board or notes write; no branch, worktree, index or commit.
- The frozen worktree was rechecked after writing: `HEAD = 1293ce1ff48c184235bb7a066631d5fb87551cd9`, porcelain status empty (0 entries).

Read-only goldmark v1.7.17 source came from the installed module cache; no network was used. Static validation is not runtime proof. Every CPU and behavior claim above stays **unexecuted** until FS-1.
