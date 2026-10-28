# FIXER — photo-hotspots G5 responsibility split

Fresh fixer: verify the read-only verifier's G5 finding, then make the smallest coherent, behavior-preserving responsibility split. Own only the relevant normalise module/helper and this feature's records/evidence. You are not alone: preserve others' edits and commits, never touch sibling worktrees/evidence/processes, and adjust to concurrent work. Main stays read-only. Do not rebase, acquire a release lock, merge, bump BUILD, push, remove worktrees, spawn agents or edit skills/memory.

## Pins and authority

- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`, clean HEAD **`9236571fb5976514f5e6412df2e67ef3e230b232`**.
- Current integration base/main **`5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`**. Confirm pins and cleanliness; don't silently change base.
- Own durable evidence `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/fixer-g5/`.
- Immutable approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`; recorded later decisions in worktree `docs/plans/2026-10-26-photo-hotspots.md`. AC1–AC12 and all feature behavior/rulings unchanged. AC12 stays live, **3bp**.

## Skills

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` plus its rules summary/rendering-validation reference, then engineering-best-practices, receiving-code-review, test-driven-development and git-commit-rules from `/home/justin/.agents/skills/`. Load systematic-debugging for an unexpected failure. This is a refactor: start with failed architecture evidence and a green functional baseline, then preserve behavior. Do not add tests that merely mirror the new file layout to manufacture a RED; add behavioral coverage first only if a genuine gap is found.

## Finding to verify

Verifier 3 returned findings, **F1 / G5 / medium**. Reports:
`evidence/photo-hotspots/verifier/round-3/report.json` and `architecture-assessment.json`.

`src/core/normalise/normalise.ts` is 315 lines versus base303. The feature adds apart() around86 and overlay/pulse orchestration while a distinct fitPadding responsibility remains around232–245. Approved G5 requires every changed source module under about300 lines and a responsibility split when it grows beyond that guidance. Untouched inherited303 does not waive this feature growth. The verifier requires one coherent helper extraction that preserves exact outputs. Its assessment names possible responsibilities, not a prescribed design: inspect and choose the smallest proper boundary yourself.

Other modules already received real splits (infer332→222 plus infer-lines125; style299→294; overlay/pulse88/33). Do not satisfy G5 by compressing statements, deleting useful comments or moving unrelated lines. Keep both resulting modules small and single-purpose, preserving stage ordering, purity, type shapes and exact conversion results. No new feature, public interface, dependency or architecture redesign.

Verifier source stayed read-only. Named non-live tests all passed head; AC1's sensitivity work remained unfinished after the parent stopped further obsolete-head execution. This is incomplete proof, not an additional established product defect. Complete browser identity comparison passed (391 head/386 base, same12 font failures/one Mac-only skip, only5 added hotspot passes). Mapped verification/mutations remained unrun. Do not inherit those runs as final proof on your new HEAD.

## Work and validation

1. Verify F1 and capture before/after responsibility/size evidence. Preserve the existing green behavioral baseline; keep the extracted implementation semantically identical, using a domain-purpose module. Push back with evidence only if the actual finding is invalid.
2. Prove exact output preservation against pre-refactor9236571, including hotspot variants and available real-file replays. Reuse meaningful existing tests; don't weaken assertions, hooks, timeouts, budgets or notes to fit the refactor. Preserve fixed/HUG paragraph growth, linked/card copies, combined nested-link coverage, flip/slider/label-floor integration and the browser lifecycle correction.
3. Run the authorized whole check, standalone hotspot browser with zero skips, full browser head/base comparison by complete package/file/hierarchy/result occurrence, available mapped corpus unit/performance and measured reports, standard corpus's honest missing-input result, four replay pairs' payload/warnings/full HTML, sandbox/type/build and architecture checks. Compare the feature with actual base5e2f98b and the mechanical refactor with pre-refactor9236571. No unavailable v1 file is measured by assumption.
4. Runtime: pin `/home/justin/.local/node-v22.23.3/bin/node` and prepend its bin directory to PATH for npm children. Chrome156 CPU/CSS profile: create this launcher in your own fresh scratch and set CHROME_PATH to it:

```sh
#!/bin/sh
exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"
```

Use the same binaries/profile on both sources. For old-production browser execution, overlay only head's `test/browser/chrome.ts` lifecycle driver on a separate base tree; keep base production/original assertions/rendering unchanged. Record the overlay and CPU/CSS qualification, no GPU/WebGL/Safari claim. Both normal full suites completed under this profile during execution recovery; lower-level default software-GPU cause remains unknown. All original failed/capped receipts stay historical, not passes. Twelve known font failures and the Mac-only skip are permitted only when identical by full name/result; no new failure/cancellation/missing file/case. Complete-file sequential fallback remains authorized if needed with original whole files and limits, never unchanged retries until green.
5. Update HANDOFF, the plan copy's execution/architecture note and existing ledger with the verified refactor, exact sizes, actual gates and unchanged live3bp. No acceptance/ruling changes. Commit passing feature-owned changes on the branch, plain personal configured identity, no AI trailer/author override or CLAUDE.md/debug JSON staged. Finish **ready-for-verify** with exact new HEAD and fully clean status; main session owns fresh verifier, blind audit and ac-check before merge.

## Isolation and handback

Create new mktemp -d parent, mkdir without -p for photo-hotspots-fixer-g5; never reuse another role's tree. Always explicit workdir. Track true child/controller exits, preserve full raw logs and each capture/comparison exit; use owned session handles rather than invisible/reused PIDs. Keep concise status.txt with milestones/qualifications in your evidence folder. Only your new disposable scratch may be cleaned; preserve evidence, user files and sibling resources.

Codex role gpt-6.1-sol xhigh. Setup sync is read-only even with escalation; keep local records without bypass. Return `{status: ready-for-verify|stopped, head, base, findings[], responsibility_split, sizes, behavior_equivalence, gates, ac_status[], qualifications, found_else[], skill_lessons[{skill, lesson, evidence}]}`. Empty lessons are normal; never edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
