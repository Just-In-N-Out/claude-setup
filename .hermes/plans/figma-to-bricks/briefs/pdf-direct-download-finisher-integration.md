# Pre-verifier integration FINISHER — pdf-direct-download

## Why this pass is required

Records-only finisher is ready-for-verify at `0e85cc96635431ba9d74ec2b864bb790fcf31ad6`. Its only changed paths from fresh-reviewed `9df0175` are HANDOFF, feature plan and ledger; parent independently confirmed zero src/test diff.

However, another approved feature **button-link-routing** is actively releasing into the same repository. Main advanced from the reviewed PDF base `b4ed333` to intermediate `7f63465503df41fea0ed2046957af665abc7478b`. It touches the PDF feature's `src/core/emit/elements.ts` plus `normalise/links.ts`, other link/IR/list/phone consumers and tests. At the parent's read-only check, main was ahead9 and had that release owner's uncommitted BUILD/HANDOFF/ledger edits. This is a real overlapping integration dependency, not permission to edit or take over its main-folder work.

The owner is board feature `button-link-routing`, release finisher `sa-0-8db5f7c1` / `deleg_395adc9f`. Its release completion/main commit and normal merge-lock release clear this conflict. Recheck actual state because it may finish before you start. Do not call intermediate main a completed release. Do not touch its edits, change its board row or delete its lock.

## Role and target

You are the FINISHER doing **pre-verifier integration only**, not release.

- Worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/pdf-direct-download`
- Branch: `worktree-pdf-direct-download`
- Saved PDF tip: `0e85cc96635431ba9d74ec2b864bb790fcf31ad6`
- Reviewed source: `6bc55591001e7f2575360062016a10f69be598bd`
- Original base: `b4ed333631dba923b73e1731ad420a4f92d880f1`
- Approved current plan: `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`
- Records receipt: `evidence/pdf-direct-download/finisher-records/receipt.json` under `/Users/justin/.hermes/plans/figma-to-bricks/`
- Clean fresh review: `evidence/pdf-direct-download/rereviewer-9df0175/` (189 parent-verified targets)
- Fix evidence: `evidence/pdf-direct-download/finisher-r1r2/` (283 parent-verified targets)

## Skills

Load `figma-to-bricks`, `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `systematic-debugging`, `frontend-ui-repair`, `frontend-cross-browser-matrix`, `frontend-testing-workflow`, `mutation-testing-discipline`, and the project `references/link-validation.md`.

Child cannot spawn agents. Parent will dispatch a NEW independent loop VERIFIER after integrated candidate is ready. Use explicit workdir for every command.

## Product decisions to preserve

Justin approved structural direct PDF downloads, not prose/picture downloads. Preserve semantic image/vector exclusion in both picture modes, deterministic valueless download attributes and existing custom attributes/marquee behavior. Preserve all approved button-link-routing behavior too; PDF policy is explicitly separate from ordinary page-link navigation metadata.

Justin explicitly selected:

- “Keep direct downloads; accept that redirect limitation.” Same-origin URL redirected off-site may replace the current page without downloading. Accepted bounded limitation, NOT fixed; do not claim universal fallback. Direct same-origin download and direct foreign viewer fallback still required.
- “Allow this PDF release with that font check marked unverified.” **This feature release only**: the same pre-existing final-design Garamond Condensed absence may remain UNVERIFIED. No substitute, expected-set narrowing or weaker test; every other gate required. Another feature's waivers are not ours.

No live-site write, server/script mechanism, new dependency or permission expansion. Installed Bricks2.3.9/user-paste check remains owed, and unrun browsers remain unproved.

## Tasks

1. Reconcile live main/owner/normal merge-lock state and preserve the saved PDF branch/evidence. If button-link-routing is still writing main, use the established project's merge-lock waiting behavior or stop with its exact owner/release condition; do not race/retry around its lock. Confirm completed acquisition, not background-process startup. Never hold an invented global browser reservation.
2. Once coherent main is available, integrate **in the PDF worktree**, using the project's rebase procedure. Keep both HANDOFF sections and all approved link behavior. Do not edit main or bump BUILD. Preserve and report old/new tip/base identities. If a substantive conflict cannot be reconciled safely, stop with exact conflict evidence; no reset/stash/discard.
3. Run focused PDF and button-link-routing tests after integration and the project's required check/browser/corpus validation on the integrated branch. Trace new interactions specifically at the shared emitter/semantic link boundary. Any unexpected failure needs root-cause diagnosis, not assertion weakening. Treat the one scoped font waiver honestly and preserve full same-base comparison evidence; no counts-only corpus proof.
4. For a behavior changed by conflict resolution, add a causal regression test first and report it so the parent knows independent review must cover it. Keep changes to integration of approved scopes; no unrelated fixes.
5. Refresh text proof/records against the actual integrated base, preserve original archives, and take a paste-check number only at eventual merge time. Main's sibling already allocated3bd; verify actual current numbering rather than reusing it.
6. Store durable receipts/manifests under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/finisher-integration/`, naming exact source/base, conflict resolution, commands/exits and unchanged versus intentionally changed output.
7. Release any lock on every settled failure/success path. For long gates use tracked background execution/process_manage rather than the 420-second foreground cap. Clean only proven own orphaned Chrome roots; leave live processes alone.

## HARD RELEASE HOLD

Return **ready-for-verify** with integrated commits and gates, or stopped with evidence. **No PDF merge into main, no push, BUILD bump, dist rebuild, main CLAUDE edit, branch/worktree deletion or evidence cleanup.** A separate fresh verifier must examine the integrated result and rerun its required gates. This pass is not a waiver of that loop.

Return `status`, `summary`, `worktree`, `last_commit`, `integrated_base`, `conflicts[]`, `source_changes[]`, `gates[]`, `evidence_paths[]`, `found_else[]`, `defect_loop_skills[]`. Parent owns board/canonical shared ledgers. No further routine go is needed within this approved integration scope.
