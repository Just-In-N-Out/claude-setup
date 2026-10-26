# PLANNER: google-font-hardening — two isolated found items

Justin authorizes selecting and running small Sol-sized found fixes with no conflicts. This is a PLANNER only: research root causes, write bounded plan; no code/worktree/commits. Main chat handles builder/reviewer/finisher. Model Sol 6.1 high; entire pipeline separate fresh Sol reviewer.

Load skill_view('figma-to-bricks') PLANNER and skill_view('systematic-debugging'); rules-summary first, then only required CLAUDE.md sections. Plan path ~/.hermes/plans/figma-to-bricks/google-font-hardening.md. Say skills loaded. Include playback, root cause evidence, tasks/tests, touches/overlaps, risks, questions first and Docs & records task. Keep small and generic. No new capability or design changes. New trade-offs go to Justin; do not treat them approved.

## Exact owned found-else items
2026-10-21 (google-partial-fonts reviewer):
- Medium (pre-existing): src/ui/fonts.ts:84,89–94 appends Google's returned CSS to _cssCustom unchanged, so a returned `font-weight: 100 900` range would land in a paste (breaks the no-range rule). Synthetic repro in ~/.hermes/cache/scratch/google-partial-fonts-review/review-proof.json edgeCases.range; not seen in a real discrete-weight answer yet.
- Low (pre-existing): fonts.ts:41–47 descriptor validation accepts malformed values ('oblique nonsense', mismatched family quotes) as confirmed coverage. Hardening only.

Investigate both in one batch (same source). B8 already merged .9: actual returned descriptor coverage determines missing/supplied. Preserve that behavior, requested typography, legitimate returned CSS, site coverage precedence and request count; don't silently substitute fonts/weights or invent coverage. Check project's no-range rule precisely; distinguish synthetic danger from observed response. If handling ranges correctly requires a wider redesign or decision, defer that item explicitly and plan only the genuinely small descriptor validation fix. Do not remove valid usable faces indiscriminately. Reject malformed descriptors without treating them confirmed.

## Conflict boundary
Running test-cleanup builder owns style/style.ts split, test/browser/panel.test.ts, test fixtures, tools/snap/corpus and style guards. Running link-upload-fixes finisher owns src/ui/main.ts/run.ts/site-*/wordpress.ts, core payload guard, link/unit/browser tests. Neither owns src/ui/fonts.ts. Avoid all shared browser/panel/fixture/run.ts files; use existing focused ui-fonts tests or a new isolated unit test file. Don't change source outside font parser/emission helpers without reporting overlap first. Shared docs/HANDOFF/build/CLAUDE.md merges serialized under normal merge lock later, not concurrent edits to main.
Queued layout-floors/pill-clip own adapt layout; card-link-words/text-link-followups own widget/normalise/contact-link/page-address logic. Leave all alone. Phone false-positive recognition found item is not yours. Font-loader duplication stage 2 remains held for live paste proof, not yours.

Expected small = 1-3 source files, one panel-font area, no changed user decisions. Verify file overlap against plans and current git. If bigger, return stopped/deferred, don't move Opus work onto Sol.

Justin's words: 'Hey from the bugs other agents found in that file if there are any put whatever you think can be assigned to 6.1 SOL that aren’t heavy lifters run them and have no conflicts with what we have up.'
