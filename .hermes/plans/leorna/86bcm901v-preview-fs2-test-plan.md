# 86bcm901v — FS-2 test-plan correction and headings follow-up (PLAN ONLY)

Status: **READY_FOR_FS2_APPROVAL** (static checks only; nothing here has been compiled or run).
Author: Opus 5.5 xhigh planner, 2026-10-23. Brief: `briefs/86bcm901v-preview-fs2-test-planner.md`.
This plan does not authorise execution. FS-2 needs a **new explicit grant** from Justin; the FS-1 grant is spent (2 of 2 Go spawns, 3 orchestration launches) and is never reset or replayed.

## 1. What FS-1 established (stays as recorded)

FS-1 (`evidence/86bcm901v/feasibility-admission-20261023T052558Z`, manifest `454c9635…c44`, probe `ca3f75e5…a0c`, HEAD `1293ce1`) is **PARTIAL for good**: 4 top tests, 3 PASS / 1 FAIL; 553 records (96 decision, 56 scaling, 400 random from 200 seeded documents, 1 negative); 0 decision mismatches; NC1/NC2/NC3 sensitive; both list-nested code witnesses formatted by the prototype while the committed renderer still falls back.

Still valid and reused, not re-run: the decision rows (O1, O2, O3 where committed formats, O4) and the negative controls. They are bound to unchanged H and source bytes.

Not covered (the plan's omissions, not product defects):

| Gap | Rows | Oracle missing |
|---|---|---|
| Scaling fallback rows | 20 | O2 exact escaped fallback |
| Scaling admitted rows | 36 | O4 block skeleton |
| Scaling rows | 56 | O3 committed decision and output comparison |
| Random rows | 400 | O3 committed decision and output comparison |

Zero observed violations elsewhere does not count as coverage here.

O5 headings failed as written: best64/best32 = 7.527708 ms / 2.192417 ms = **3.4335 > 3.0**. FS-1 also logged admission-only bests of 2.538334/1.291167 ms (ratio 1.97). Those are a separate phase and cannot stand in for the end-to-end ratio. **The cause is unknown.** One sample proves neither asymptotic growth nor noise.

## 2. Hypotheses for the headings ratio (falsifiable)

- **H1 estimator artifact.** FS-1 took the best of 3 back-to-back runs, swept sizes in ascending order and did not control GC, so size was confounded with time and heap state. Prediction: with interleaved, repeated, GC-reset sampling the candidate ratio is robustly ≤ 3.0.
- **H2 shared render path.** The growth is in goldmark parse/render, which the committed renderer shares. Prediction: candidate *and* committed ratios are robustly > 3.0, while admission is not.
- **H3 H admission.** Prediction: the admission-only ratio is robustly > 3.0.
- **H4 candidate-only.** Candidate > 3.0 while committed and admission are not. This is unexplained, not proof of a harness defect: separately measured phases can interact differently when combined (including allocation/GC state). Inspect combined-path effects and harness differences before attributing a cause. The raw diagnostic token remains H4_CANDIDATE_ONLY_UNEXPLAINED.
- **Modifiers.** `GC_ATTRIBUTED`: the ratio is above 3.0 with GC on and below it with GC off. `ALLOCATION_COUNT_*`: deterministic malloc-count growth (linear 1.8–2.2, or superlinear > 3.0).

FS-1's own rows show the single-cell estimator is noisy at a level comparable to the 3.0 margin, which is the evidence for H1 being plausible, not proven. In three scaling families the admission-only best exceeded the end-to-end best that contains it (references at 64 KiB: 1.754 ms vs 1.191 ms; also link_open and unclosed_code at 8 KiB), and the headings 16 KiB cold sample was 4.2× its best.

## 3. Certifying versus diagnostic, and the threshold

- **Certifying in FS-2:** O1–O4 on all 56 scaling and 400 random rows, plus four pre-registered sensitivity controls for the new oracles. A pass closes the coverage gaps only.
- **Diagnostic in FS-2:** the headings experiment never calls `t.Errorf` on a ratio. It classifies H1–H4 from raw samples using the rules in §6.
- **O5 stays UNRESOLVED after FS-2 under every outcome.** The 3.0 threshold is not lowered. TestFS1BlockPhaseScaling is **not** re-run, so no rerun can turn it green. FS-2 therefore cannot return VALIDATED for H; its top result is `PARTIAL_O5_UNRESOLVED`.
- **Proposed method change M1 — NOT APPROVED and not part of the FS-2 approval.** M1 would replace "best of 3, ascending sweep" with "nearest-rank interquartile ratio over 15 interleaved, GC-reset rounds", keeping 3.0. It needs Justin's explicit decision after FS-2 evidence exists. So does any H2 policy (for example, scoping O5 to admission when growth is in pre-existing committed rendering).

## 4. Code change: one added overlay file; FS-1 probe byte-identical

- The FS-1 probe is reused **unchanged** (sha `ca3f75e5…a0c`). That keeps H, the decision, ordinary, code, witness, boundary and control fixtures identical by construction.
- FS-2 adds `internal/web/zz_fs2_followup_test.go` through `-overlay` only. Neither overlay target may exist in the worktree.
- Its scaling `fill/references/families` block is verbatim FS-1 lines 433–465. Its random generator is verbatim FS-1 lines 524–556 (seed 86901, same RNG call order). The reader also checks each regenerated row's identity against FS-1's raw log.
- Comparison work runs in untimed tests. Timed regions contain only the measured call; GC setup, `ReadMemStats` and logging sit outside them.
- File-ending rule: the file bytes are the exact interior of the single `go` fence below, which ends with one LF. Pinned bytes: 14,309 B, SHA-256 `de8765f0495262801fd170756c1bdfe037e771bf6b05faa405c3dc29b5bb4e25` (`FS2_PROBE_SHA` in §7).
- Static checks on the saved plan:
  - Go 1.27.3 `gofmt` via stdin (HOME=/var/empty) gives byte-identical output, which means it parses.
  - The two verbatim regions equal FS-1 lines 433–465 and 524–556 exactly.
  - Python `ast.parse` passes.
  - `bash -n` passes.
  - **Not run:** compile, typecheck, test or execution. Undeclared and unused identifiers were audited by hand only, so the first FS-2 spawn is also the first compile; a build failure ends it as `INCOMPLETE`.

```go
package web

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"html"
	"math/rand"
	"reflect"
	"runtime"
	"runtime/debug"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/ast"
	"github.com/yuin/goldmark/text"
)

// FS-2 follow-up instrumentation only. Candidate H, its helpers and every FS-1
// fixture stay in the byte-identical FS-1 probe compiled beside this file.

const (
	fs2FormattedLabel = "formatted"
	fs2FallbackLabel  = "fallback"
)

func fs2ExactFallback(body string) string {
	return fsNotice + "<pre><code>" + html.EscapeString(body) + "</code></pre>"
}

func fs2SameSkeleton(document ast.Node, body string) bool {
	return reflect.DeepEqual(fsSkeleton(document), fsSkeleton(goldmark.DefaultParser().Parse(text.NewReader([]byte(body)))))
}

type fs2Oracle struct {
	decision, committed, structure, comparison string
	fallbackExact, committedFallbackExact      bool
	consistent                                 bool
	renderErr, committedErr                    error
}

func fs2Evaluate(body string) fs2Oracle {
	output, fellBack, renderErr := fsRender(body, fsCandidate)
	admitted, document := fsAdmit(body, fsCandidate)
	committedHTML, committedErr := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: body})
	committed := string(committedHTML)
	result := fs2Oracle{decision: fs2FormattedLabel, committed: fs2FormattedLabel, structure: "not-applicable",
		fallbackExact: true, committedFallbackExact: true, consistent: fellBack == !admitted,
		renderErr: renderErr, committedErr: committedErr}
	if fellBack {
		result.decision = fs2FallbackLabel
		result.fallbackExact = output == fs2ExactFallback(body)
	}
	switch {
	case committedErr != nil:
		result.committed = "error"
	case strings.Contains(committed, "Plain-text preview:"):
		result.committed = fs2FallbackLabel
		result.committedFallbackExact = committed == fs2ExactFallback(body)
	}
	if admitted && renderErr == nil {
		result.structure = "identical"
		if !fs2SameSkeleton(document, body) {
			result.structure = "DIFFERENT"
		}
	}
	equal := "DIFFERENT"
	if output == committed {
		equal = "equal"
	}
	switch {
	case result.committed == "error":
		result.comparison = "committed-error"
	case result.decision == result.committed:
		result.comparison = "both-" + result.decision + "-" + equal
	default:
		result.comparison = "candidate-" + result.decision + "-committed-" + result.committed
	}
	return result
}

func fs2Failures(result fs2Oracle, want string) []string {
	failures := []string{}
	if result.renderErr != nil || result.decision != want {
		failures = append(failures, "O1")
	}
	if !result.consistent {
		failures = append(failures, "O1-consistency")
	}
	if !result.fallbackExact {
		failures = append(failures, "O2")
	}
	if result.structure == "DIFFERENT" {
		failures = append(failures, "O4")
	}
	if strings.HasSuffix(result.comparison, "-DIFFERENT") {
		failures = append(failures, "O3")
	}
	if result.committedErr != nil || !result.committedFallbackExact {
		failures = append(failures, "O3-committed")
	}
	return failures
}

func fs2Record(kind, name, family string, param int, body, want string, result fs2Oracle, failures []string) map[string]any {
	sum := sha256.Sum256([]byte(body))
	return map[string]any{"kind": kind, "name": name, "family": family, "param": param, "bytes": len(body),
		"sha256": hex.EncodeToString(sum[:]), "expected": want, "candidate": result.decision, "committed": result.committed,
		"structure": result.structure, "comparison": result.comparison, "fallback_exact": result.fallbackExact,
		"committed_fallback_exact": result.committedFallbackExact, "consistent": result.consistent,
		"render_error": fmt.Sprint(result.renderErr), "committed_error": fmt.Sprint(result.committedErr), "failures": failures}
}

func fs2Log(t *testing.T, record map[string]any) {
	t.Helper()
	line, err := json.Marshal(record)
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("FS2 %s", line)
}

func TestFS2HeadingsDiagnostic(t *testing.T) {
	const rounds, warmups, seed = 15, 3, 86902
	fill := func(unit string, size int) string { return strings.Repeat(unit, size/len(unit)) }
	sizes := []int{8 << 10, 16 << 10, 24 << 10, 32 << 10, 40 << 10, 48 << 10, 56 << 10, 64 << 10}
	arms := []struct {
		name string
		run  func(string)
	}{
		{"admission", func(body string) { fsAdmit(body, fsCandidate) }},
		{"candidate", func(body string) { fsRender(body, fsCandidate) }},
		{"committed", func(body string) { renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: body}) }},
		{"default_parse", func(body string) { goldmark.DefaultParser().Parse(text.NewReader([]byte(body))) }},
	}
	bodies := map[int]string{}
	for _, size := range sizes {
		body := fill("###### x\n", size)
		if len(body) > pack.MaxBodyBytes {
			t.Fatalf("headings %d exceeds body cap", size)
		}
		result := fs2Evaluate(body)
		failures := fs2Failures(result, fs2FormattedLabel)
		if result.committed != fs2FormattedLabel {
			failures = append(failures, "committed-not-formatted")
		}
		fs2Log(t, fs2Record("diagnostic-precondition", fmt.Sprintf("headings/%d", size), "headings", size, body, fs2FormattedLabel, result, failures))
		if len(failures) > 0 {
			t.Fatalf("FS2 diagnostic precondition headings/%d failed %v", size, failures)
		}
		bodies[size] = body
	}
	type cell struct {
		condition string
		size, arm int
	}
	var cells []cell
	for _, condition := range []string{"gc_on", "gc_off"} {
		for _, size := range sizes {
			for arm := range arms {
				cells = append(cells, cell{condition, size, arm})
			}
		}
	}
	defaultPercent := debug.SetGCPercent(-1)
	defer debug.SetGCPercent(defaultPercent)
	fs2Log(t, map[string]any{"kind": "diagnostic-context", "go_version": runtime.Version(), "gomaxprocs": runtime.GOMAXPROCS(0),
		"num_cpu": runtime.NumCPU(), "default_gc_percent": defaultPercent, "seed": seed, "rounds": rounds, "warmups": warmups,
		"sizes": sizes, "cells": len(cells), "expected_samples": rounds * len(cells)})
	measure := func(c cell) (time.Duration, runtime.MemStats, runtime.MemStats) {
		if c.condition == "gc_on" {
			debug.SetGCPercent(defaultPercent)
		} else {
			debug.SetGCPercent(-1)
		}
		runtime.GC()
		var before, after runtime.MemStats
		runtime.ReadMemStats(&before)
		start := time.Now()
		arms[c.arm].run(bodies[c.size])
		elapsed := time.Since(start)
		runtime.ReadMemStats(&after)
		return elapsed, before, after
	}
	started := time.Now()
	for warmup := 0; warmup < warmups; warmup++ {
		for _, c := range cells {
			measure(c)
		}
	}
	random := rand.New(rand.NewSource(seed))
	samples := 0
	for round := 0; round < rounds; round++ {
		for order, index := range random.Perm(len(cells)) {
			c := cells[index]
			elapsed, before, after := measure(c)
			allocated := after.TotalAlloc - before.TotalAlloc
			fs2Log(t, map[string]any{"kind": "diagnostic-sample", "round": round, "order": order, "condition": c.condition,
				"size_param": c.size, "bytes": len(bodies[c.size]), "arm": arms[c.arm].name, "ns": elapsed.Nanoseconds(),
				"alloc_bytes": allocated, "mallocs": after.Mallocs - before.Mallocs,
				"num_gc": after.NumGC - before.NumGC, "pause_ns": after.PauseTotalNs - before.PauseTotalNs})
			samples++
			if allocated > 512<<20 {
				t.Fatalf("FS2 diagnostic allocation guard %s/%d/%s allocated=%d", c.condition, c.size, arms[c.arm].name, allocated)
			}
			if time.Since(started) > 180*time.Second {
				t.Fatalf("FS2 diagnostic wall guard after %d samples", samples)
			}
		}
	}
	debug.SetGCPercent(defaultPercent)
	fs2Log(t, map[string]any{"kind": "diagnostic-complete", "samples": samples, "elapsed_ns": time.Since(started).Nanoseconds()})
}

func TestFS2OracleSensitivity(t *testing.T) {
	headings := strings.Repeat("###### x\n", 1000)
	mutated := strings.TrimSuffix(headings, "###### x\n") + "x\n"
	quotes := strings.Repeat(">", 8192)
	admitted, document := fsAdmit(headings, fsCandidate)
	candidateHeadings, _, candidateErr := fsRender(headings, fsCandidate)
	committedHeadings, committedErr := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: headings})
	committedMutated, mutatedErr := renderLibraryPreview(library.Item{Kind: pack.KindSkill, Body: mutated})
	quoteResult := fs2Evaluate(quotes)
	base := fs2Oracle{decision: fs2FormattedLabel, committed: fs2FormattedLabel, structure: "identical",
		comparison: "both-formatted-equal", fallbackExact: true, committedFallbackExact: true, consistent: true}
	inexact, different, mismatched, committedInexact := base, base, base, base
	inexact.fallbackExact = false
	different.structure = "DIFFERENT"
	mismatched.comparison = "both-formatted-DIFFERENT"
	committedInexact.committedFallbackExact = false
	clean := len(fs2Failures(base, fs2FormattedLabel)) == 0
	controls := []struct {
		name               string
		positive, detected bool
	}{
		{"O2_unescaped_fallback", quoteResult.decision == fs2FallbackLabel && quoteResult.fallbackExact,
			fsNotice+"<pre><code>"+quotes+"</code></pre>" != fs2ExactFallback(quotes)},
		{"O4_mutated_skeleton", admitted && fs2SameSkeleton(document, headings), !fs2SameSkeleton(document, mutated)},
		{"O3_admitted_output", candidateErr == nil && committedErr == nil && candidateHeadings == string(committedHeadings),
			mutatedErr == nil && candidateHeadings != string(committedMutated)},
		{"O3_committed_fallback", quoteResult.committed == fs2FallbackLabel && quoteResult.committedFallbackExact,
			slices.Contains(fs2Failures(committedInexact, fs2FormattedLabel), "O3-committed")},
		{"classifier_O1", clean, slices.Contains(fs2Failures(base, fs2FallbackLabel), "O1")},
		{"classifier_O2", clean, slices.Contains(fs2Failures(inexact, fs2FormattedLabel), "O2")},
		{"classifier_O3", clean, slices.Contains(fs2Failures(mismatched, fs2FormattedLabel), "O3")},
		{"classifier_O4", clean, slices.Contains(fs2Failures(different, fs2FormattedLabel), "O4")},
	}
	for _, control := range controls {
		fs2Log(t, map[string]any{"kind": "sensitivity", "control": control.name, "positive": control.positive, "detected": control.detected})
		if !control.positive || !control.detected {
			t.Errorf("FS2 sensitivity control %s positive=%t detected=%t", control.name, control.positive, control.detected)
		}
	}
}

func TestFS2ScalingOracles(t *testing.T) {
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
		for _, size := range []int{8 << 10, 16 << 10, 32 << 10, 64 << 10} {
			body := family.build(size)
			if len(body) > pack.MaxBodyBytes {
				t.Fatalf("%s exceeds body cap", family.name)
			}
			result := fs2Evaluate(body)
			failures := fs2Failures(result, family.want)
			fs2Log(t, fs2Record("scaling-oracle", fmt.Sprintf("%s/%d", family.name, size), family.name, size, body, family.want, result, failures))
			if len(failures) > 0 {
				t.Errorf("FS2 scaling oracle %s/%d failed %v", family.name, size, failures)
			}
		}
	}
}

func TestFS2RandomOracles(t *testing.T) {
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
			result := fs2Evaluate(tc.body)
			failures := fs2Failures(result, tc.want)
			fs2Log(t, fs2Record("random-oracle", tc.name, "random", index, tc.body, tc.want, result, failures))
			if len(failures) > 0 {
				t.Errorf("FS2 random oracle %s failed %v", tc.name, failures)
			}
		}
	}
}
```

## 5. Expected population (derived from the composed code above)

FS-2 runs only `^TestFS2` (4 tests, in declaration order: diagnostic, sensitivity, scaling, random). The FS-1 tests are compiled but **not run**, so FS-1 has no real-document dependency here and its decision and negative evidence stay as recorded.

| Record kind | Count | Fixed sub-accounting |
|---|---|---|
| `diagnostic-precondition` | 8 | headings 8–64 KiB; candidate and committed both formatted, no failures |
| `diagnostic-context` | 1 | `expected_samples`=960, `default_gc_percent` ≥ 0 |
| `diagnostic-sample` | 960 | 15 rounds × 2 GC conditions × 8 sizes × 4 arms, unique keys |
| `diagnostic-complete` | 1 | samples=960 |
| `sensitivity` | 8 | all `positive` and `detected` true |
| `scaling-oracle` | 56 | 14 families × 4 sizes. Candidate: 20 fallback / 36 formatted. O2 checked on 20; O4 on 36. Every row has one comparison class |
| `random-oracle` | 400 | 200 `code_only` formatted / 200 `paragraph_attack` fallback. O2 on 200; O4 on 200 |
| **Total** | **1434** | |

Comparison classes:
- `both-*-equal` is an O3 comparison.
- `candidate-formatted-committed-fallback` is the improvement class; its committed fallback must be byte-exact.
- `candidate-fallback-committed-formatted` is the stricter class and is allowed only on expected-fallback rows.
- `*-DIFFERENT` and `committed-error` are failures.

How the class totals split is **observed, not predicted**. Identity: each scaling row's `(family, bytes, expected)` and each random row's `(name, bytes, expected, candidate, structure, fallback_exact)` must match FS-1's raw log.

## 6. Headings diagnostic protocol and decision rule

- **Order.** Untimed preconditions run first. Then 3 warmup passes over all 64 cells in fixed order, then 15 rounds, each a seeded permutation (seed 86902) of the 64 cells.
- **Each sample.** Set GC% (default, or −1 for `gc_off`), `runtime.GC()`, `ReadMemStats`, time only the arm call, then `ReadMemStats`.
- **Arms.** `admission` = `fsAdmit`; `candidate` = `fsRender`; `committed` = `renderLibraryPreview` (committed baseline); `default_parse` = goldmark default parse.
- **Guards.** 512 MiB allocation per sample and a 180 s in-test wall limit; on either the test stops, after already-logged rows are preserved.
- **Statistics** (reader, n=15, nearest rank). q25=`sorted[3]`, med=`sorted[7]`, q75=`sorted[11]`. For each condition/arm: `low`=q25(64K)/q75(32K), `mid`=med64/med32, `high`=q75(64K)/q25(32K). Band is **ABOVE** if low > 3.0, **BELOW** if high ≤ 3.0, else **STRADDLE**.
- **Class** (gc_on), first match wins:
  1. admission ABOVE → `H3_ADMISSION_SUPERLINEAR_SUPPORTED`.
  2. candidate ABOVE and committed ABOVE → `H2_SHARED_RENDER_SUPERLINEAR_SUPPORTED`.
  3. candidate ABOVE → `H4_CANDIDATE_ONLY_UNEXPLAINED`.
  4. candidate BELOW → `H1_FS1_RATIO_NOT_REPRODUCED`.
  5. otherwise `INDETERMINATE`.
  6. Any population or type error → `INVALID`.
- **Modifiers.**
  - `GC_ATTRIBUTED`: gc_on candidate ABOVE and gc_off candidate BELOW.
  - `ALLOCATION_COUNT_LINEAR` or `ALLOCATION_COUNT_SUPERLINEAR`: median mallocs ratio within 1.8–2.2, or above 3.0.
  - `HOST_LOAD_HIGH`: either load sample has loadavg1 > cpu/2.
- **Reported but non-certifying.** Log-log slopes between neighbouring sizes, and a frozen-estimator analogue (min of rounds 0–2).
- No class changes O5 or authorises product work.

## 7. One-shot execution contract (only after a new grant)

- **Budget.** Exactly 1 Go test spawn and 0 retries, plus at most 3 Go tool calls (`telemetry off`, `env -json`, `version`).
- **Wall limits.** Launcher interrupting watchdog: 900 s from spawn (SIGTERM, then SIGKILL after 10 s). Go `-timeout 600s` covers the test binary only, not compilation. In-test limit: 180 s for the diagnostic. The post-call elapsed time is only recorded; it never pre-empts.
- **Exit status.** The child exit (`go_child_exit`) is reported separately from the launcher exit. Launcher exit 0 means collection completed, never that tests passed.
- **Refusals.** Pin drift, a tool-context mismatch or host load above the limit stops the run before the spawn (`NOT_RUN_*`), with no wait or poll.
- **Environment.** Offline cached go1.27.3, `GOPROXY=off`, `GOFLAGS=-mod=readonly`, and an owned HOME, caches and tmp under the new root. Bindings are set before every tool invocation, and supported `go telemetry off` is read back.
- **Pins and outputs.** 504 source pins are compared before and after with HEAD, index, status, `go.work`/`go.work.sum` and both probe pins. The root is new and atomic; owned caches are removed after the receipts are written. RSS is not sampled (honest limit). The launcher writes a seal over its own outputs.
- **Running it.** Executor: `PLAN_SHA` comes from the grant. Record `command -v python3` and its version.

```bash
set -euo pipefail
PLAN=/Users/justin/.hermes/plans/leorna/86bcm901v-preview-fs2-test-plan.md
PLAN_SHA="${PLAN_SHA:?set from the FS-2 grant}"
test "$(shasum -a 256 "$PLAN" | cut -d' ' -f1)" = "$PLAN_SHA"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
ROOT=/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/fs2-headings-oracles-$STAMP
mkdir "$ROOT"
mkdir "$ROOT/scripts"
python3 -I - "$PLAN" "$ROOT/scripts/fs2_launcher.py" <<'PY'
import re
import sys
text = open(sys.argv[1], encoding="utf-8").read()
blocks = [b for b in re.findall(r"^```python\n(.*?)^```\n", text, re.M | re.S) if b.startswith("# file: fs2_launcher.py\n")]
if len(blocks) != 1:
    raise SystemExit("launcher fence count != 1")
with open(sys.argv[2], "x", encoding="utf-8") as handle:
    handle.write(blocks[0])
PY
status=0
python3 -I "$ROOT/scripts/fs2_launcher.py" "$ROOT" "$PLAN_SHA" || status=$?
echo "launcher_exit=$status root=$ROOT"
```

The same script is the complete raw reader. `python3 -I fs2_launcher.py --read <ROOT>` re-parses the sealed log without spawning or writing anything.

```python
# file: fs2_launcher.py
import hashlib
import json
import math
import os
import platform
import re
import shutil
import signal
import subprocess
import sys
import time
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

PLAN = Path("/Users/justin/.hermes/plans/leorna/86bcm901v-preview-fs2-test-plan.md")
WORKTREE = Path("/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-library-catalog-browser")
FS1 = Path("/Users/justin/.hermes/plans/leorna/evidence/86bcm901v/feasibility-admission-20261023T052558Z")
GO = "/Users/justin/go/pkg/mod/golang.org/toolchain@v0.0.1-go1.27.3.darwin-arm64/bin/go"
HEAD = "1293ce1ff48c184235bb7a066631d5fb87551cd9"
BRANCH = "feat/86bcm901v-library-catalog-browser"
INDEX = Path("/Users/justin/Leorna/leorna-control-plane/.git/worktrees/86bcm901v-library-catalog-browser/index")
INDEX_SHA = "469dbb0a3b03e7f561b7939a5ce458fc2e916a5a62c716025280e751e21156f0"
FS1_MANIFEST_SHA = "454c9635b2e4a042d140a581117d3bef32d3eead19a06e2e6b2c35c6ea290c44"
FS1_PROBE_SHA = "ca3f75e5b3efd65e3a8bf7c437774547ca2310f0eb183943919c6461f5445a0c"
FS1_LOG_SHA = "b4cd0e02cf382acecbc99cc43687b9e76c3390340ab4a839f6446c7fbf975464"
FS2_PROBE_SHA = "de8765f0495262801fd170756c1bdfe037e771bf6b05faa405c3dc29b5bb4e25"
WORKSPACE_PINS = {"go.work": [44, "725f2faad3e3c59c8057ae10393892b1968f382321017e9c38d9de60705c03f4"],
                  "go.work.sum": [8122, "9213ddca833cacad6b386c0a4c96f7f9ff4c7c81e102a8690174431fe2028071"]}
OVERLAY_TARGETS = ["zz_fs1_admission_test.go", "zz_fs2_followup_test.go"]
WATCHDOG_SECONDS = 900
ROOT_NAME = re.compile(r"^fs2-headings-oracles-\d{8}T\d{6}Z$")
RECORD = re.compile(r"^\s+zz_fs2_followup_test\.go:\d+: FS2 (\{.*\})$")
FS1_RECORD = re.compile(r"^\s+zz_fs1_admission_test\.go:\d+: FS1 (\{.*\})$")
OUTCOME = re.compile(r"^\s*--- (PASS|FAIL|SKIP): (TestFS2\w+) \(")
TESTS = ["TestFS2HeadingsDiagnostic", "TestFS2OracleSensitivity", "TestFS2ScalingOracles", "TestFS2RandomOracles"]
FAMILIES = {"quote_single_line": "fallback", "ordered_single_line": "fallback", "link_open": "fallback",
            "unclosed_code": "fallback", "references": "fallback", "quote_lines_depth64": "formatted",
            "ordered_lines_depth64": "formatted", "lazy_depth64": "formatted", "tab_quote_depth64": "formatted",
            "nested_fenced_json": "formatted", "headings": "formatted", "thematic": "formatted",
            "html_blocks": "formatted", "long_line": "formatted"}
SCALING_SIZES = [8192, 16384, 32768, 65536]
DIAG_SIZES = [8192, 16384, 24576, 32768, 40960, 49152, 57344, 65536]
ARMS = ["admission", "candidate", "committed", "default_parse"]
CONDITIONS = ["gc_on", "gc_off"]
ROUNDS = 15
CONTROLS = ["O2_unescaped_fallback", "O4_mutated_skeleton", "O3_admitted_output", "O3_committed_fallback",
            "classifier_O1", "classifier_O2", "classifier_O3", "classifier_O4"]
ALLOWED_CLASSES = {"both-formatted-equal", "both-fallback-equal", "candidate-formatted-committed-fallback",
                   "candidate-fallback-committed-formatted"}


def now():
    return datetime.now(timezone.utc).isoformat()


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_json(root, relative, value):
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "x", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")


def reject_constant(value):
    raise ValueError(f"non-finite JSON constant {value}")


def git(*args):
    return subprocess.run(["git", "--no-optional-locks", "-C", str(WORKTREE), *args],
                          capture_output=True, check=True, timeout=60).stdout


def source_snapshot():
    tracked = [os.fsdecode(p) for p in git("ls-files", "--cached", "-z").split(b"\0") if p]
    untracked = [os.fsdecode(p) for p in git("ls-files", "--others", "--exclude-standard", "-z").split(b"\0") if p]
    hashes = {}
    for relative in sorted(set(tracked) | set(untracked)):
        path = WORKTREE / relative
        hashes[relative] = sha(os.readlink(path).encode() if path.is_symlink() else path.read_bytes())
    workspace = {}
    for name, (size, digest) in WORKSPACE_PINS.items():
        data = (WORKTREE / name).read_bytes()
        workspace[name] = {"bytes": len(data), "sha256": sha(data), "matches": len(data) == size and sha(data) == digest}
    return {"at": now(), "head": git("rev-parse", "HEAD").decode().strip(),
            "branch": git("branch", "--show-current").decode().strip(),
            "status_hex": git("status", "--porcelain=v1", "-z", "--untracked-files=all").hex(),
            "tracked": len(tracked), "untracked": len(untracked), "hashes": hashes,
            "index_sha256": sha(INDEX.read_bytes()), "workspace": workspace,
            "overlay_targets_present": [n for n in OVERLAY_TARGETS if (WORKTREE / "internal/web" / n).exists()]}


def pin_errors(snapshot):
    expected = json.loads((FS1 / "snapshots/source-final.json").read_text(encoding="utf-8"))["hashes"]
    errors = []
    if snapshot["head"] != HEAD:
        errors.append("head")
    if snapshot["branch"] != BRANCH:
        errors.append("branch")
    if snapshot["status_hex"] or snapshot["untracked"]:
        errors.append("worktree-not-clean")
    if len(expected) != 504 or snapshot["hashes"] != expected:
        errors.append("source-byte-map")
    if snapshot["index_sha256"] != INDEX_SHA:
        errors.append("index")
    errors += [f"workspace:{name}" for name, value in snapshot["workspace"].items() if not value["matches"]]
    errors += [f"overlay-target-exists:{name}" for name in snapshot["overlay_targets_present"]]
    return errors


def fs1_inputs():
    manifest_bytes = (FS1 / "manifest.json").read_bytes()
    if sha(manifest_bytes) != FS1_MANIFEST_SHA:
        raise SystemExit("FS-1 manifest drift")
    payloads = json.loads(manifest_bytes)["payloads"]
    for relative in ("probe/zz_fs1_admission_test.go", "logs/fs1-attempt2.log", "snapshots/source-final.json"):
        data = (FS1 / relative).read_bytes()
        if payloads[relative] != {"bytes": len(data), "sha256": sha(data)}:
            raise SystemExit(f"FS-1 payload drift {relative}")
    probe = (FS1 / "probe/zz_fs1_admission_test.go").read_bytes()
    if sha(probe) != FS1_PROBE_SHA or sha((FS1 / "logs/fs1-attempt2.log").read_bytes()) != FS1_LOG_SHA:
        raise SystemExit("FS-1 pinned bytes drift")
    return probe


def fs1_rows():
    rows = {"scaling": {}, "random": {}}
    for line in (FS1 / "logs/fs1-attempt2.log").read_text(encoding="utf-8").splitlines():
        match = FS1_RECORD.match(line)
        if match:
            record = json.loads(match.group(1))
            if record["kind"] == "scaling":
                rows["scaling"][(record["family"], record["bytes"])] = record
            elif record["kind"] == "random":
                rows["random"][record["name"]] = record
    if len(rows["scaling"]) != 56 or len(rows["random"]) != 400:
        raise SystemExit("FS-1 raw reader population mismatch")
    return rows


def child_env(root):
    return {"CLANG_MODULE_CACHE_PATH": str(root / "toolcache/clang"), "GOCACHE": str(root / "gocache"), "GOENV": "off",
            "GOFLAGS": "-mod=readonly", "GOMODCACHE": "/Users/justin/go/pkg/mod", "GOPATH": str(root / "gopath"),
            "GOPROXY": "off", "GOSUMDB": "off", "GOTELEMETRY": "off", "GOTMPDIR": str(root / "tmp"),
            "GOTOOLCHAIN": "local", "HOME": str(root / "home"), "LANG": "en_US.UTF-8", "LC_ALL": "en_US.UTF-8",
            "PATH": str(Path(GO).parent) + ":/usr/bin:/bin:/usr/sbin:/sbin", "TEMP": str(root / "tmp"),
            "TMP": str(root / "tmp"), "TMPDIR": str(root / "tmp"), "XDG_CACHE_HOME": str(root / "toolcache"),
            "XDG_CONFIG_HOME": str(root / "home/.config"), "XDG_DATA_HOME": str(root / "home/.local/share")}


def tool_context(root, env):
    records = {}
    for name, argv in (("telemetry-off", [GO, "telemetry", "off"]),
                       ("env", [GO, "env", "-json", "GOTELEMETRY", "GOTELEMETRYDIR", "GOVERSION", "GOCACHE", "GOWORK",
                                "GOMODCACHE", "GOPROXY", "GOFLAGS", "GOTOOLCHAIN"]),
                       ("version", [GO, "version"])):
        result = subprocess.run(argv, cwd=WORKTREE, env=env, capture_output=True, timeout=120)
        records[name] = {"argv": argv, "exit": result.returncode, "stdout": result.stdout.decode(errors="replace"),
                         "stderr": result.stderr.decode(errors="replace"), "at": now()}
        if result.returncode != 0:
            break
    write_json(root, "snapshots/tool-context.json", records)
    errors = [name for name, record in records.items() if record["exit"] != 0]
    if len(records) != 3 or errors:
        return errors or ["incomplete"]
    values = json.loads(records["env"]["stdout"])
    wanted = {"GOTELEMETRY": "off", "GOVERSION": "go1.27.3", "GOCACHE": env["GOCACHE"],
              "GOWORK": str(WORKTREE / "go.work"), "GOMODCACHE": env["GOMODCACHE"], "GOPROXY": "off",
              "GOFLAGS": "-mod=readonly", "GOTOOLCHAIN": "local"}
    errors = [key for key, value in wanted.items() if values.get(key) != value]
    if not values.get("GOTELEMETRYDIR", "").startswith(str(root / "home") + "/"):
        errors.append("GOTELEMETRYDIR")
    if records["version"]["stdout"] != "go version go1.27.3 darwin/arm64\n":
        errors.append("version")
    return errors


def host_context():
    def text(argv):
        try:
            return subprocess.run(argv, capture_output=True, timeout=10).stdout.decode(errors="replace").strip()
        except (OSError, subprocess.SubprocessError) as error:
            return f"unavailable: {error!r}"
    return {"at": now(), "loadavg": list(os.getloadavg()), "cpu_count": os.cpu_count(), "platform": platform.platform(),
            "python": [sys.executable, sys.version], "hw_model": text(["/usr/sbin/sysctl", "-n", "hw.model"]),
            "hw_memsize": text(["/usr/sbin/sysctl", "-n", "hw.memsize"]),
            "cpu_brand": text(["/usr/sbin/sysctl", "-n", "machdep.cpu.brand_string"]),
            "power": text(["/usr/bin/pmset", "-g", "batt"])}


def spawn(root, env, overlay):
    argv = [GO, "test", "-overlay", str(overlay), "-count=1", "-timeout", "600s", "-v", "./internal/web", "-run", "^TestFS2"]
    write_json(root, "command.json", {"argv": argv, "cwd": str(WORKTREE), "env": env,
                                      "watchdog_seconds": WATCHDOG_SECONDS, "go_test_binary_timeout": "600s"})
    log_path = root / "logs/fs2.log"
    started_at, started = now(), time.monotonic()
    watchdog = False
    with open(log_path, "xb") as log:
        process = subprocess.Popen(argv, cwd=WORKTREE, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        write_json(root, "logs/payload-start.json", {"pid": process.pid, "at": started_at})
        try:
            exit_code = process.wait(timeout=WATCHDOG_SECONDS)
        except subprocess.TimeoutExpired:
            watchdog = True
            os.killpg(process.pid, signal.SIGTERM)
            try:
                exit_code = process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                exit_code = process.wait()
    data = log_path.read_bytes()
    receipt = {"argv": argv, "start": started_at, "end": now(), "elapsed_seconds": time.monotonic() - started,
               "go_child_exit": exit_code, "watchdog_triggered": watchdog, "log_bytes": len(data), "log_sha256": sha(data)}
    write_json(root, "logs/fs2-receipt.json", receipt)
    return receipt


def is_count(value):
    return type(value) is int and value >= 0


def quartiles(values):
    ordered = sorted(values)
    return ordered[3], ordered[7], ordered[11]


def band(cells, condition, arm, field="ns"):
    q25_large, median_large, q75_large = quartiles([s[field] for s in cells[(condition, 65536, arm)]])
    q25_half, median_half, q75_half = quartiles([s[field] for s in cells[(condition, 32768, arm)]])
    if min(q25_half, median_half, q75_half) <= 0:
        return {"band": "INVALID"}
    low, middle, high = q25_large / q75_half, median_large / median_half, q75_large / q25_half
    label = "ABOVE" if low > 3.0 else "BELOW" if high <= 3.0 else "STRADDLE"
    return {"low": low, "mid": middle, "high": high, "band": label}


def oracle_rows(rows, expected_names, identity, fs1, errors, failures):
    names = [row["name"] for row in rows]
    if len(names) != len(set(names)) or set(names) != expected_names:
        errors.append(f"{rows[0]['kind'] if rows else 'oracle'} population")
    for row in rows:
        if row["failures"]:
            failures.append({"name": row["name"], "failures": row["failures"]})
        if row["comparison"] not in ALLOWED_CLASSES:
            failures.append({"name": row["name"], "failures": ["comparison:" + row["comparison"]]})
        if row["comparison"] == "candidate-fallback-committed-formatted" and row["expected"] != "fallback":
            failures.append({"name": row["name"], "failures": ["stricter-on-expected-formatted"]})
        if not is_count(row["bytes"]) or not is_count(row["param"]):
            errors.append(f"type {row['name']}")
        problem = identity(row, fs1)
        if problem:
            failures.append({"name": row["name"], "failures": ["FS1-identity:" + problem]})
    return {"rows": len(rows), "candidate": dict(Counter(r["candidate"] for r in rows)),
            "committed": dict(Counter(r["committed"] for r in rows)),
            "comparison": dict(Counter(r["comparison"] for r in rows)),
            "o2_checked": sum(r["candidate"] == "fallback" for r in rows),
            "o4_checked": sum(r["structure"] != "not-applicable" for r in rows),
            "o3_compared": sum(r["comparison"].startswith("both-") for r in rows)}


def scaling_identity(row, fs1):
    old = fs1["scaling"].get((row["family"], row["bytes"]))
    if old is None or old["expected"] != row["expected"] or FAMILIES.get(row["family"]) != row["expected"]:
        return "missing-or-expected"
    return "" if old["candidate"] == row["candidate"] else "candidate"


def random_identity(row, fs1):
    old = fs1["random"].get(row["name"])
    if old is None:
        return "missing"
    fields = ("bytes", "expected", "candidate", "structure", "fallback_exact")
    return ",".join(field for field in fields if old[field] != row[field])


def read(root):
    errors, failures = [], []
    log_bytes = (root / "logs/fs2.log").read_bytes()
    records, outcomes = [], {}
    for number, line in enumerate(log_bytes.decode("utf-8").splitlines(), start=1):
        match = RECORD.match(line)
        if match:
            record = json.loads(match.group(1), parse_constant=reject_constant)
            record["_line"] = number
            records.append(record)
        elif " FS2 {" in line:
            errors.append(f"unparsed FS2 line {number}")
        outcome = OUTCOME.match(line)
        if outcome:
            if outcome.group(2) in outcomes:
                errors.append(f"duplicate outcome {outcome.group(2)}")
            outcomes[outcome.group(2)] = outcome.group(1)
    if sorted(outcomes) != sorted(TESTS):
        errors.append(f"top-test outcomes {sorted(outcomes)}")
    kinds = {}
    for record in records:
        kinds.setdefault(record.get("kind"), []).append(record)
    known = {"sensitivity", "scaling-oracle", "random-oracle", "diagnostic-precondition", "diagnostic-context",
             "diagnostic-sample", "diagnostic-complete"}
    errors += [f"unknown kind {kind}" for kind in kinds if kind not in known]
    fs1 = fs1_rows()
    sensitivity = kinds.get("sensitivity", [])
    if sorted(r["control"] for r in sensitivity) != sorted(CONTROLS):
        errors.append("sensitivity population")
    insensitive = [r["control"] for r in sensitivity if r["positive"] is not True or r["detected"] is not True]
    scaling = oracle_rows(kinds.get("scaling-oracle", []), {f"{f}/{s}" for f in FAMILIES for s in SCALING_SIZES},
                          scaling_identity, fs1, errors, failures)
    random_rows = oracle_rows(kinds.get("random-oracle", []),
                              {f"random/{i:03d}/{k}" for i in range(200) for k in ("code_only", "paragraph_attack")},
                              random_identity, fs1, errors, failures)
    if scaling["candidate"] != {"fallback": 20, "formatted": 36} or (scaling["o2_checked"], scaling["o4_checked"]) != (20, 36):
        errors.append("scaling sub-accounting")
    if random_rows["candidate"] != {"formatted": 200, "fallback": 200} or (random_rows["o2_checked"], random_rows["o4_checked"]) != (200, 200):
        errors.append("random sub-accounting")
    diagnostic = {"class": "INVALID", "modifiers": []}
    diagnostic_errors = []
    context = kinds.get("diagnostic-context", [])
    if len(context) != 1 or context[0]["expected_samples"] != 960 or context[0]["default_gc_percent"] < 0:
        diagnostic_errors.append("context")
    preconditions = kinds.get("diagnostic-precondition", [])
    if sorted(r["param"] for r in preconditions) != DIAG_SIZES or any(r["failures"] or r["committed"] != "formatted" for r in preconditions):
        diagnostic_errors.append("preconditions")
    samples = kinds.get("diagnostic-sample", [])
    keys = [(s["round"], s["condition"], s["size_param"], s["arm"]) for s in samples]
    expected_keys = {(r, c, z, a) for r in range(ROUNDS) for c in CONDITIONS for z in DIAG_SIZES for a in ARMS}
    if len(keys) != 960 or set(keys) != expected_keys:
        diagnostic_errors.append("sample population")
    if any(not all(is_count(s[f]) for f in ("ns", "alloc_bytes", "mallocs", "num_gc", "pause_ns", "bytes")) for s in samples):
        diagnostic_errors.append("sample types")
    complete = kinds.get("diagnostic-complete", [])
    if len(complete) != 1 or complete[0]["samples"] != 960:
        diagnostic_errors.append("completion")
    if not diagnostic_errors:
        cells = {}
        for sample in samples:
            cells.setdefault((sample["condition"], sample["size_param"], sample["arm"]), []).append(sample)
        gc_on = {arm: band(cells, "gc_on", arm) for arm in ARMS}
        gc_off = {arm: band(cells, "gc_off", arm) for arm in ARMS}
        bands = {arm: gc_on[arm]["band"] for arm in ARMS}
        if "INVALID" in bands.values() or "INVALID" in [gc_off[arm]["band"] for arm in ARMS]:
            label = "INVALID"
        elif bands["admission"] == "ABOVE":
            label = "H3_ADMISSION_SUPERLINEAR_SUPPORTED"
        elif bands["candidate"] == "ABOVE" and bands["committed"] == "ABOVE":
            label = "H2_SHARED_RENDER_SUPERLINEAR_SUPPORTED"
        elif bands["candidate"] == "ABOVE":
            label = "H4_CANDIDATE_ONLY_UNEXPLAINED"
        elif bands["candidate"] == "BELOW":
            label = "H1_FS1_RATIO_NOT_REPRODUCED"
        else:
            label = "INDETERMINATE"
        modifiers = []
        if bands["candidate"] == "ABOVE" and gc_off["candidate"]["band"] == "BELOW":
            modifiers.append("GC_ATTRIBUTED")
        mallocs = band(cells, "gc_on", "candidate", "mallocs").get("mid", 0.0)
        if mallocs > 3.0:
            modifiers.append("ALLOCATION_COUNT_SUPERLINEAR")
        elif 1.8 <= mallocs <= 2.2:
            modifiers.append("ALLOCATION_COUNT_LINEAR")
        hosts = [json.loads((root / name).read_text(encoding="utf-8")) for name in ("snapshots/host-before.json", "snapshots/host-after.json") if (root / name).exists()]
        if any(h["loadavg"][0] > h["cpu_count"] / 2 for h in hosts):
            modifiers.append("HOST_LOAD_HIGH")
        medians, slopes = {}, {}
        for condition in CONDITIONS:
            for arm in ARMS:
                series = [(cells[(condition, z, arm)][0]["bytes"], quartiles([s["ns"] for s in cells[(condition, z, arm)]])[1]) for z in DIAG_SIZES]
                medians[f"{condition}/{arm}"] = [m for _, m in series]
                slopes[f"{condition}/{arm}"] = [math.log(m2 / m1) / math.log(b2 / b1)
                                               for (b1, m1), (b2, m2) in zip(series, series[1:])]
        early = {z: min(s["ns"] for s in cells[("gc_on", z, "candidate")] if s["round"] < 3) for z in (32768, 65536)}
        diagnostic = {"class": label, "modifiers": modifiers, "gc_on": gc_on, "gc_off": gc_off,
                      "malloc_ratio_candidate": mallocs, "medians_ns": medians, "loglog_slopes": slopes,
                      "frozen_estimator_analogue_ratio_noncertifying": early[65536] / early[32768]}
    errors += [f"diagnostic {e}" for e in diagnostic_errors]
    if errors:
        oracle_verdict = "INCOMPLETE"
    elif failures:
        oracle_verdict = "FAILED"
    elif insensitive:
        oracle_verdict = "INSENSITIVE"
    else:
        oracle_verdict = "CLOSED"
    return {"schema": "leorna-fs2-results-v1", "at": now(), "log_sha256": sha(log_bytes), "records": len(records),
            "records_by_kind": {k: len(v) for k, v in kinds.items()}, "expected_records": 1434,
            "top_test_outcomes": outcomes, "reader_errors": errors, "oracle_failures": failures,
            "insensitive_controls": insensitive, "scaling": scaling, "random": random_rows,
            "oracle_verdict": oracle_verdict, "diagnostic": diagnostic,
            "h_status": "PARTIAL_O5_UNRESOLVED", "o5": "UNRESOLVED; M1 not approved; FS-1 remains PARTIAL"}


def seal(root, status):
    payloads = {}
    for path in sorted(p for p in root.rglob("*") if p.is_file() and p.name != "manifest.json"):
        data = path.read_bytes()
        payloads[path.relative_to(root).as_posix()] = {"bytes": len(data), "sha256": sha(data)}
    write_json(root, "manifest.json", {"schema": "leorna-fs2-manifest-v1", "status": status, "payloads": payloads})


def finish(root, status, report, code):
    report.update({"status": status, "at": now()})
    write_json(root, "report.json", report)
    seal(root, status)
    print(json.dumps({"status": status, "root": str(root), "launcher_exit": code}))
    return code


def main():
    if len(sys.argv) == 3 and sys.argv[1] == "--read":
        print(json.dumps(read(Path(sys.argv[2])), indent=2, sort_keys=True))
        return 0
    root, plan_sha = Path(sys.argv[1]), sys.argv[2]
    contents = sorted(p.relative_to(root).as_posix() for p in root.rglob("*"))
    if not ROOT_NAME.match(root.name) or root.parent != FS1.parent or contents != ["scripts", "scripts/fs2_launcher.py"]:
        raise SystemExit("root is not a fresh FS-2 root")
    report = {"schema": "leorna-fs2-report-v1", "root": str(root), "go_test_spawns": 0, "spawn_budget": 1}
    plan = PLAN.read_bytes()
    if sha(plan) != plan_sha:
        return finish(root, "NOT_RUN_PLAN_DRIFT", report, 2)
    fs1_probe = fs1_inputs()
    blocks = re.findall(r"^```go\n(.*?)^```\n", plan.decode("utf-8"), re.M | re.S)
    if len(blocks) != 1 or sha(blocks[0].encode()) != FS2_PROBE_SHA or not blocks[0].endswith("}\n"):
        return finish(root, "NOT_RUN_PROBE_DRIFT", report, 2)
    (root / "probe").mkdir()
    with open(root / "probe/zz_fs2_followup_test.go", "xb") as handle:
        handle.write(blocks[0].encode())
    with open(root / "probe/zz_fs1_admission_test.go", "xb") as handle:
        handle.write(fs1_probe)
    overlay = root / "overlay.json"
    write_json(root, "overlay.json", {"Replace": {str(WORKTREE / "internal/web" / n): str(root / "probe" / n) for n in OVERLAY_TARGETS}})
    before = source_snapshot()
    write_json(root, "snapshots/source-before.json", before)
    report["pin_errors_before"] = pin_errors(before)
    if report["pin_errors_before"]:
        return finish(root, "NOT_RUN_PIN_DRIFT", report, 3)
    for relative in ("home/.config", "home/.local/share", "gocache", "gopath", "tmp", "toolcache/clang"):
        (root / relative).mkdir(parents=True)
    env = child_env(root)
    report["tool_context_errors"] = tool_context(root, env)
    if report["tool_context_errors"]:
        return finish(root, "NOT_RUN_TOOL_CONTEXT", report, 4)
    host = host_context()
    write_json(root, "snapshots/host-before.json", host)
    if host["loadavg"][0] > host["cpu_count"] / 2:
        return finish(root, "NOT_RUN_HOST_LOAD", report, 5)
    report["go_test_spawns"] = 1
    report["receipt"] = spawn(root, env, overlay)
    write_json(root, "snapshots/host-after.json", host_context())
    after = source_snapshot()
    write_json(root, "snapshots/source-after.json", after)
    report["pin_errors_after"] = pin_errors(after)
    results = read(root)
    write_json(root, "results/fs2-results.json", results)
    cleanup = {}
    for relative in ("gocache", "gopath", "tmp", "toolcache"):
        path = root / relative
        cleanup[relative] = sum(p.stat().st_size for p in path.rglob("*") if p.is_file() and not p.is_symlink())
        shutil.rmtree(path)
    write_json(root, "logs/owned-cache-cleanup.json", cleanup)
    report.update({"go_child_exit": report["receipt"]["go_child_exit"], "oracle_verdict": results["oracle_verdict"],
                   "diagnostic_class": results["diagnostic"]["class"], "h_status": results["h_status"]})
    status = "COMPLETE_EVIDENCE_ONLY" if not report["pin_errors_after"] else "COMPLETE_WITH_PIN_DRIFT"
    return finish(root, status, report, 0)


if __name__ == "__main__":
    sys.exit(main())
```

## 8. Result rules after the single run

- **Oracle verdict:**
  - `CLOSED` needs all 1434 records, every population and FS-1 identity check matching, all 4 tests reported, 0 failures and all 8 controls sensitive.
  - `FAILED` means an O1–O4 or identity failure. That is product evidence and is reported, not repaired.
  - `INSENSITIVE` means a control did not detect its injected fault.
  - `INCOMPLETE` covers a compile failure, missing or extra rows, a reader error, a guard or a watchdog.
  - A `go_child_exit` of 0 by itself proves nothing, and a nonzero exit is read per test.
- **Diagnostic class:** reported with its bands and modifiers. It never certifies O5.
- **Afterwards:** stop and return the root. Main runs intake against the seal. No second spawn, rerun, threshold change or product edit follows automatically.

## 9. Still open regardless of FS-2

- O5 / M1 decision.
- OPUS-R2-F1 on `1293ce1`.
- **Q2 NOT APPROVED.** It counts >64 container/list depth and >256 literal `]:` pairs per paragraph, prose included; the existing numbers are not acceptance of these counting domains.
- T1–T9 unapplied.
- Application fix not applied, so the preview bug stays open in the app.
- A fresh full independent review, the applicable verifier, a genuine manual check at actual 200% zoom, coordinated records and separate publication permission.

## 10. Skills and loop audit (actual successful loads this pass)

- **Loaded:** leorna, engineering-best-practices, implementation-planning (+ `references/plan-validation.md`), systematic-debugging, algorithmic-engineering-validation (+ `references/algorithmic-engineering-validation.md`), spike, concurrent-state-validation, security-best-practices, multi-tenant-auth-management, ux-frontend-workbench, frontend-testing-workflow, review-fix-cadence.
- **How they applied:** debugging and algorithmic validation shaped the hypotheses, interleaved design and robust statistics. Concurrent-state shaped the atomic root, pins, child-versus-supervisor exit, one-shot gate and reader-first accounting. Spike gives FS-2 its non-certifying verdict vocabulary.
- **Not applicable here:** security and multi-tenant need no auth or tenant change, since this is test-only with escaped-fallback preservation. UX/frontend-testing apply only to the later manual and zoom acceptance, which stays NOT VERIFIED.
- **defect_loop_skills:** [] for this planning pass. The Agent Defect Loop verifier applies to the later application fix, not to this plan.
