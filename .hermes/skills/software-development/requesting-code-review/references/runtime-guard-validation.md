# Runtime guard and execution-evidence validation

Use these recipes when the reviewed change claims a hard I/O/time bound or
required dependency execution. Select the relevant claims under the existing
review contract; these are not a mandatory extra full test matrix.

## Bounded Go output and optimized copy interfaces

1. Trace the actual producer-to-writer call path and the concrete type's complete
   method set. Check whether `io.Copy` selects source `io.WriterTo` or destination
   `io.ReaderFrom` instead of the capped `Write`; `os/exec` pipe collection can
   reach that optimized path. Inspect embedded promoted methods explicitly.
2. Pair an actual oversized child-process fixture with a reader wrapper exposing
   only `Read`. The latter prevents a source-side `WriterTo` from hiding the
   destination's `ReadFrom`. Keep a normal below-limit payload as a control.
3. Verify that the cap covers every admitted path. When overriding `ReadFrom`,
   copy through a writer-only wrapper that dispatches to the capped `Write`.
   Copying into the embedded buffer bypasses the cap; copying back into the same
   `ReaderFrom`-implementing destination can recurse.
4. Assert the declared overflow result, retained-byte limit and any promised
   cancellation/termination behavior through the public execution path. A direct
   `Write` test alone cannot establish subprocess capture bounds.
5. Remove the protective override in an owned mutant, leave the oracle unchanged,
   and require the precise output-limit assertion to fail. Restore source/test
   hashes and verify the focused green cases. A compiler/setup error or an earlier
   unrelated rejection is not this mutation's kill.

## Timeouts without weakening the error contract

- Put a short elapsed-time assertion on the fixture that explicitly configures
  the short timeout. Do not apply it indiscriminately to ordinary error cases
  still using a longer production default.
- Preserve every independent error/content assertion when correcting a wrongly
  scoped timing expectation. Retain the original failed run and prove the
  configured-timeout case still detects a disabled timeout.
- Attribute environmental timing failures with evidence, not a silent threshold
  increase or deletion of the cancellation oracle.

## Dependency-backed execution versus green no-ops

1. Resolve the exact selected test identities and inspect their dependency/setup
   path. A regex selecting HTTP mocks does not establish Postgres coverage merely
   because its name contains the feature under review.
2. Supply the real admitted dependency in an owned namespace; demonstrate that
   required cases reached their intended assertions and effects. Do not infer
   execution from command exit zero, headline counts or a test's optimistic flag.
3. Missing or skipped required cases block acceptance. Preserve declared optional
   and platform skips with reasons instead of failing every `skipping` message.
4. Observe the effect at the boundary appropriate to the claim. Read-only tests,
   rollback and cleanup may leave zero retained rows; a post-suite row count is
   not a universal proof that database assertions ran.
5. Give concurrent reviewers separate resettable database fixtures and output
   roots. Verify exact candidate restoration after mutations and preserve each
   command's real exit before summarizing its logs.

## Untrusted diagnostics and CI log commands

1. Enumerate source-derived schema messages, transformer warnings/errors, display
   metadata, child stdout/stderr and operational path/flag failures. Trace each to
   JSON/Markdown reports, local step summaries, ordinary logs, annotations and
   artifacts retained after a failed run; a failing exit does not prevent disclosure.
2. Generate synthetic noncredential canaries at runtime and use the admitted real
   scanner plus renderer through the compiled production CLI. Keep a healthy
   control, a genuine quality failure and an infrastructure failure. Store raw
   canary-bearing proof privately; publish sanitized observations, not raw bodies.
3. Assert absence of the exact canary in every relevant output channel while
   retaining scanner findings, useful structured item/tool/rule/path evidence and
   the original pass/failure classifications. Cover schema, warning and error
   paths separately; scanner redaction alone cannot prove diagnostic redaction.
4. Exercise newline/control-character and command-marker input through both
   ordinary stdout and stderr, including flags, paths and operational errors.
   Assert that no standalone untrusted workflow-command line is emitted, while
   genuine annotations retain their trusted prefix and escaped data. A unit test
   of an annotation helper does not cover direct writes around it.
5. Temporarily restore each unsafe publication/log path in an owned mutant with
   unchanged oracles. Require the intended leak or command-line assertion to fail
   and the independent healthy/failure controls to retain their expected outcomes.
   Restore exact source/test bytes and re-establish the passing focused checks.
6. Report local output reproduction separately from hosted exploitation. A raw
   command witness establishes unsafe log output, not a successful hosted exploit
   or passing-gate bypass. Likewise, local reports do not prove remote acquisition,
   artifact upload or an actual hosted job summary.
