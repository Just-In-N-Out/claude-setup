# Diagnostic PLANNER — pdf-direct-download saved-settings failure

## Role and deliverable

PLANNER/read-only root-cause investigation for the existing `pdf-direct-download` live failure. The user supplied the requested saved Bricks button JSON. Trace the first loss boundary and write a **small evidence-backed follow-up plan**; do not build, create a worktree/branch, commit, or change source/site/settings. Do not restart the previous broad review/corpus pipeline for diagnosis.

Keep one feature identity `pdf-direct-download`. Save your new diagnostic/fix plan to `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download-live-followup.md`, retaining the approved release history in the existing `pdf-direct-download.md`. You own only the follow-up plan and diagnostic evidence, not the shared board/HANDOFF/found ledger.

## Skills

Load in order: `figma-to-bricks`, `engineering-best-practices`, `implementation-planning`, `systematic-debugging`, `frontend-ui-repair`, `frontend-testing-workflow`. Load project `references/link-validation.md` and `references/rules-summary.md`. For PDF panel/store paths also load `references/panel-validation.md`. Use selective project context, never the entire CLAUDE/HANDOFF.

## User request, rewritten

The saved PDF download button still has no download behavior even after cache purge and repeat conversion/paste. Justin copied the whole saved Bricks element and asks whether it is the requested evidence. It is: a linked Div with icon/text. Locate whether the attributes are missing in actual plugin clipboard output or lost during Bricks save/copy-back. No further PDF replacement or cache repetition is indicated by current evidence.

Justin's latest words: **“is it this?”**, following the exact Bricks JSON supplied in this file:

`/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/live-check-3be/user-bricks-button-iovjet.json`

Original symptom: clicking **Download Full Inventory (PDF)** views the PDF instead of saving it. He wants a normal direct download to the visitor's browser-chosen folder.

Earlier replies:

> it did not work. Should i clear cache or something?

> yeah i resetted cache and did it again it still didnt work do i try uplaoding another pdf?

## What is established

1. Parent parsed the exact supplied JSON. `source=bricksCopiedElements`, `version=2.3.9`. Root `iovjet` is `name:div`, `tag:a`, children `udtzdd` icon image and `jbshyb` text. Its `settings.link` has **only type and url**. No `_attributes`; no download attribute; no `newTab`; no `rel`.
2. Exact user values/IDs, including `@url:` wrappers, are preserved in the artifact. Do not normalize/rewrite it. These may be chat/application annotations; **do not feed a retyped annotated URL into a predicate and call the resulting failure the product root cause** without independently establishing the real runtime value. The user supplied a newer PDF destination ending `team-29-3dsearch-project-plan-review-5-pdf.pdf`; the previous checker tested another uploaded PDF. Do not confuse the two observations or assume replacing the file fixes absent metadata.
3. Released source build2026-10-22.7 at977fcce7fc1e2fac834d3721c23050447f61e927 was parent-verified with real dist hashes and main/remote equal. Later main releases may exist: inspect actual source/build/manifest paths read-only; do not assume .7 is globally latest or Figma loaded this folder merely because main dist is correct.
4. Source generated output and local browser tests did include a valueless download custom attribute for structural controls. Actual installed Bricks retention was explicitly unproved. All repeated converter-only green tests did not establish the plugin→clipboard→Bricks boundary.
5. Read-only live checker independently reproduced the public failure even after a page update: cacheMISS and explicit no-cache/private/no-store HTML plus isolated Chrome lacked download/target/rel; click navigated same tab to a valid direct200PDF, zero redirects. Saved settings vs rendering loss was unresolved then; user JSON now proves those fields are absent in the saved/copied data too, but still does **not** prove whether plugin output lacked them or Bricks dropped them.

Live-check evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/live-check-3be/20261022T174106Z/` (48 parent-hash-verified targets).

Prior plan/release/evidence: `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md` and sibling evidence folders `release/`, `verifier-integrated-0f07f09/`, `finisher-integration/`, etc. Use only relevant receipts.

## Focused investigation

1. Trace **actual PDF upload/list assignment and panel/store/clipboard construction**, not just core `emitPayload` fixtures. Identify every post-emit writer of `settings.link`, root tags and `_attributes`; a PDF attached by the panel after emit can bypass emitter-only policy or replace metadata. This is a hypothesis to prove/disprove, not a predetermined cause.
2. Compare exact current and released source consumers, the mutable on-disk debug artifact's build/panel/list state if relevant, generated final clipboard payload, and the supplied saved-element shape. Read-only local reproduction/probes are permitted; no source edits, live upload, account login or cache purge. Use a real available fixture/store path and record provenance; do not fabricate an API/clipboard success or force an artificial input solely to prove the hypothesis.
3. Inspect legitimate local evidence for actual Figma manifest/plugin build/folder identity if retrievable without touching the user's state. Do not assert that reloading Figma necessarily loaded the intended dist. Don't read unrelated clipboard/session secrets.
4. If Bricks schema/attribute persistence is the likely boundary, use source-backed docs/archived native samples and the actual supplied copy. Do not invent a Bricks option or conclude that empty download is stripped merely because this JSON lacks it.
5. Return exact **first proven loss boundary**, its reproducer and file/line evidence, or explicitly state the boundary still missing. If the only indispensable input is the **pre-Bricks generated button JSON**/plugin build display, request the smallest one, not a full page dump or another large export. Avoid a new whole corpus/browser suite before root cause; it cannot settle which actual payload was pasted.
6. Plan the smallest general correction and a failing regression at the real affected boundary. Keep unrelated source and previously approved ordinary-link behavior intact. Scope by semantic role/structure, not label, IDs, page or one PDF. Tests must cover final panel/store-to-clipboard output plus normal/picture/prose controls, not only emitter output.

## Existing policy and permissions

Structural direct same-origin PDF controls download; pictures/vectors/prose stay viewing links. User accepted exact same-origin→off-site redirect limitation, NOT fixed, and THIS-PDF-release-only pre-existing Garamond Condensed UNVERIFIED waiver; neither authorizes broader server/script mechanisms, new font substitutions or a waiver for a follow-up release. A new release's waiver scope must remain explicit, not inherited silently.

No source/build/mainCLAUDE/site/admin/cache/upload writes or new dependency. No changes to other worktrees. Save diagnostics under `evidence/pdf-direct-download/live-diagnosis-saved-iovjet/`. Another source owner may be active; identify actual overlap in the plan, not a speculative global hold.

## Plan and return

Write a short self-contained plan with root cause, first-boundary proof, tasks/test-first acceptance, exact affected files/tests, risks, open questions (recommended lettered choices), and a final **Docs & records** task listing plan copy/ledger/HANDOFF/BUILD/mainCLAUDE/rule updates. If evidence is insufficient, don't pad a guess into a plan: identify the one missing input.

Return `summary`, `plan_path`, `root_cause`, `first_loss_boundary`, `evidence_paths[]`, `questions[]`, `touches[]`, `found_else[]`. Don't fix unrelated problems; don't label a hypothesis confirmed. Prefer a bounded useful diagnosis over another repeated full validation cycle.
