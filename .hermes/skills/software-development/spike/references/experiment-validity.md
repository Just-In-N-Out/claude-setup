# Experiment validity audit

Use this when a spike includes a generated test matrix, differential oracle or performance comparison. This is a design and evidence-reading recipe, not authority to run another experiment.

## 1. Tie the run to a decision

Name the uncertainty, the result vocabulary and the exact prerequisite each outcome can resolve. Keep diagnostic evidence separate from certifying checks. If no outcome can clear the implementation gate, identify the remaining decision before requesting execution rather than presenting another diagnostic as the final validation step.

## 2. Inspect coverage in the composed source

Inspect the complete proposed source, including reused helpers and additional files. For each input family, fill this matrix:

| Obligation | Applicable inputs | Real assertion/helper | Raw result | Reader rejection | Sensitivity control |
|---|---|---|---|---|---|
| Decision | Declared domain | Expected versus actual | Decision fields | Mismatch or absence | Wrong decision |
| Exact output | Required output/fallback paths | Whole-byte equality | Comparison result | Difference or missing check | Corrupted output |
| Structure | Applicable admitted inputs | Independent structure oracle | Compared identity | Difference or absence | Altered structure |
| Resources | Declared scale families | Frozen timed operation | Raw samples/context | Threshold or incompleteness | Relevant bounded falsifier |

Mark not-applicable cells with a reason. An initialized true flag, absent false result or complete input count does not prove an oracle ran. Check every loop independently, especially random and scaling paths that may omit comparisons present in example tests.

Derive expected identities and multiplicities from the complete generators. Keep documents, variants, samples and positive/fault control pairs distinct. Require the reader to reject missing groups, duplicate identities, skipped prerequisites and truncated runs. A compile-valid deliberate fault must fail the intended assertion while the positive control passes; setup failure is not sensitivity evidence.

## 3. Preserve measurement meaning

Freeze inputs, measured operation, order, warmup, repetitions, seeds, runtime conditions and verdict criteria before sampling. Keep oracle work, logging and instrumentation outside the timed region unless explicitly part of the measured workload. Record raw results and relevant allocation/GC/load context rather than retaining only a favorable minimum.

Interpret a failed finite-size growth discriminator at its declared scope. It does not prove a complexity class, and an unexplained miss is not proven host noise. Separately measured phases need not add to the combined path's measured cost: their allocation, cache and object-lifetime conditions can interact. Treat candidate-only growth as unexplained until those interactions and harness differences are distinguished. Use causal labels only when the design and evidence justify causation.

Keep the original outcome immutable when proposing a new statistic or protocol. State what changes, why it could discriminate the uncertainty, what remains unproved and which approval is needed. A new run must not silently refund spent attempts or rewrite a failed prior result.

## 4. Read outcomes at the right boundary

Distinguish a setup refusal, a spawned workload, its actual exit status and the collector's status. A successful collector may contain a failed test. Preserve partial rows before aborting and label missing oracle coverage explicitly. Separate a post-return timing check, a test-binary timeout and an outer compile/run watchdog; only the actual interrupting mechanism bounds unfinished work.

Static source inspection and parsing can reveal missing checks, but cannot establish compilation, execution, sensitivity or runtime success. A diagnostic label cannot clear a certifying obligation merely because all records were collected.
