# Validating resource-guard regressions

Use when a review finds that an admission, size, timeout or complexity heuristic
protects resources but changes supported ordinary output. This is a validation
recipe, not a claim that a particular replacement algorithm has been proven.

## 1. Freeze the actual contract and reproduce

Record supported inputs, normal output, the permitted fallback trigger, content
completeness and existing security/resource bounds. Keep a heuristic's threshold
separate from user-approved product limits. Reproduce the reported ordinary-input
regression on the exact candidate before production edits; preserve the original
costly-input witnesses too.

When useful, compare the pure renderer with its real authorized HTTP/UI entrypoint
on the same input. A fast component can expose a false-positive admission rule,
but component timing does not establish end-to-end latency or user acceptance.
Keep benchmark methodology and shared-host caveats with the measurements.

## 2. Build a discriminating, source-local corpus

| Input class | Required observation under the accepted contract |
|---|---|
| Representative ordinary documents | Expected semantics remain intact; no needless fallback |
| Ordinary code-heavy or escaped content | Formatting and content survive without heuristic misclassification |
| Small, intermediate and maximum supported ordinary inputs | Supported capacity does not silently become a lower effective output limit |
| Original costly structural families | Resource protection and permitted safe fallback remain effective |
| Mixed ordinary and costly regions | Harmless surrounding content does not mask an expensive region |

Include realistic distributions of headings, lists, balanced inline constructs and
code where relevant. Repeated characters or words are useful byte-bound controls,
not the sole ordinary-content corpus. Retain copied-input provenance and hashes;
keep committed fixtures source-local rather than dependent on an operator's home
or an expendable evidence directory.

## 3. Test independent outcomes before choosing a repair

Assert user-visible semantics independently of the production heuristic and its
constants. Check ordinary output as well as the absence of an inappropriate
fallback. On genuinely costly cases, check the approved fallback, notice,
completeness and unchanged security/size bounds.

Measure cold work as well as output. Warm caching or background work continuing
after a timeout can conceal the original resource problem. Prefer deterministic
work-bound checks where available, and qualify timing observations; do not turn a
diagnostic time threshold into a new acceptance SLA.

Calibrate or reject proposed repairs against both sides of this corpus. Do not
whitelist witness names, merely raise a proxy threshold, or treat the current tiny
shipped sample as the entire supported input domain. If the accepted contract
cannot be retained within authorized scope, return the specific design need;
do not silently accept another output limitation.

## 4. Qualify the corrected candidate

Require intended failures for both ordinary-content degradation and protection
bypass, with compile-valid sensitivity variants and unaffected positive controls.
An old test encoding a rejected heuristic may need a deliberate expectation
change; replace it with stronger contract-based coverage, not a skip or weakened
safety check. Restore all temporary variants and run the project's required gates
on the resulting candidate.

For visible regressions, capture the real ordinary before-state during baseline
execution and the corrected state during GREEN. For very tall preview panels,
align the panel's start explicitly before capture: a successful generic
scroll-into-view can center the viewport deep inside the body and omit the
heading or fallback notice that distinguishes the states. Inspect the image,
not only its file's existence. If production has already changed, preserve the
inadequate capture and use an authorized hash-bound historical-source overlay
with the same real HTTP/browser fixture; never rewrite the live candidate or
relabel an unrelated fallback image as the missing baseline. Inspect captures
before sharing; label automated fixtures honestly and retain any owed
operator/browser-zoom proof as unverified. Another item's image or a picture of
test logs is not evidence for this rendering repair.
