# Reviewer brief — pdf-direct-download

## Role

Fresh independent REVIEWER, read only, for Figma-to-Bricks feature `pdf-direct-download`.

Review this isolated worktree and branch:

- worktree: `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/pdf-direct-download`
- branch: `worktree-pdf-direct-download`
- builder tip: `d2e86e1b388bd36322d051e7d3f3a524acf1bbdc`
- approved plan: `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`
- durable builder evidence: `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/builder/`
- evidence manifest has been independently read back and every archived target reported `OK` before dispatch.

Review `git diff main...HEAD` against the approved plan and current project rules. Do not trust the builder's summary, tests, screenshots, hashes, or conclusions—reproduce the important claims yourself.

Change nothing. No source edits, auto-fixes, commits, pushes, merges, BUILD bumps, live-site writes, uploads, logins, or WordPress changes. Restore any temporary mutation or test artifact you create.

## Required skills

Load these in order and state that you loaded them:

1. `figma-to-bricks`
2. `engineering-best-practices`
3. `requesting-code-review`
4. `code-review-practice`
5. `mutation-testing-discipline`
6. `frontend-ui-repair`
7. `frontend-cross-browser-matrix`
8. `frontend-testing-workflow`

You are already the fresh reviewer. Skip any loaded skill's instruction to spawn another reviewer or apply automatic fixes. Report findings only. The main dispatcher owns fixes and the Agent Defect Loop.

## Approved contract

Justin approved **1A, 2A, 3A, 4A**:

1. Same-site PDF links on structural download controls—native Buttons and linked Div/Block boxes whose root is the anchor—ask the browser to download.
2. Other-site PDF controls retain the existing new-tab/`noopener` fallback.
3. PDF links inside rich-text paragraphs keep opening in a new tab.
4. Plugin-only; no server/live-site changes.

The implementation must be general. It may use element kind and `isPdfAddress`, but never words, names, styling, a particular page, layer ID, or URL.

## Builder's claims to challenge

The builder reports:

- structural PDF controls gain a valueless `download` custom attribute in `settings._attributes`, preserving existing attributes and deterministic IDs;
- `newTab:true` and `rel:"noopener"` remain for cross-origin fallback;
- same-origin PDF clicks and keyboard activation save the server bytes/name, open no tab, and leave the page in place;
- cross-origin PDFs still open a new tab and save nothing;
- linked words, pictures, whole-linked text, page links, other documents and phone links remain unchanged;
- only one browser test that pinned old behavior was narrowed;
- no change was needed in `src/ui/site-pages.ts` or `test/browser/render.ts`;
- check is 2118/2118 plus 6/6 performance; browser is 250/250; six focused mutants die; five corpus pastes and HTML files are byte-identical; Justin's debug replay is byte-identical;
- Safari, Firefox, Edge, mobile and installed Bricks 2.3.9 paste/copy-back are explicitly unproved.

Builder rulings:

1. Chrome 155, both headed and headless, proved `download` + `_blank` + `noopener` does not open an extra tab for same-site PDF, so the approved 2A path stays.
2. Page relinking cannot remove a typed PDF control link because the site-page address list excludes it, so no `site-pages.ts` change was made.
3. A planned fixture converted to a native Bricks Button rather than a Div; the test follows the actual emitted kind.
4. The browser uses download behavior `allow` so the server filename is retained; Chrome normalized `Guide.PDF` to `Guide.pdf`.
5. `test/browser/pdf-new-tab.test.ts` now asserts `download=""` for the native Button; inline-word and page-link checks remain.

## Review requirements

1. Confirm source scope and no accidental behavior change outside the contract.
2. Trace all consumers of link emission and `_attributes`, including existing attributes, marquee copies, deterministic IDs and renderer placement on the actual anchor.
3. Check that Div/Block eligibility truly means Bricks renders the element root as the anchor; kill plausible mutants such as Buttons-only, every PDF element, any address, overwriting attribute arrays, valued download, unstable/order-dependent IDs, and applying download to rich text or linked images.
4. Independently exercise real Chrome with real PDF bytes for mouse and keyboard. Distinguish a true download event/file from PDF-viewer `.crdownload` noise. Verify page/tab/opener behavior and cross-origin fallback.
5. Inspect the test that changed old pdf-new-tab expectations. Ensure it preserves independent coverage for native new-tab links outside the new download-control scope.
6. Verify browser tests read the actual emitted payload/anchor rather than synthesizing a passing result. Use missing-download and misplaced-attribute mutations.
7. Re-run the applicable project gates and compare corpus/debug outputs against a valid same-base baseline. Treat existing 18 corpus findings honestly; do not accept count-only proof.
8. Assess accessibility/keyboard behavior, filename handling, same-origin boundary, redirect behavior if relevant, and browser coverage claims. Do not promote unrun browsers or installed Bricks to passes.
9. Check records and documented rulings. The rules-summary plan assumption that headless Chrome may download every PDF was disproved by the builder and must not be written as a rule.
10. List any other problem in `found_else`; do not fix or fold it in.

## Agent Defect Loop

`frontend-ui-repair` and `frontend-cross-browser-matrix` apply. You are the independent problem-finder. Return every critical/major/minor issue with reproducible evidence. A separate finisher will address valid findings, then a fresh verifier will rerun the loop gates before release.

## Output

Return:

- `verdict`: `clean` or `findings`
- `findings[]`: each with `id`, `severity`, `introduced`, `claim`, and exact `evidence`
- `found_else[]`
- `defect_loop_skills[]`
- gates/mutations actually run and exact artifact paths

Do not make changes, even for an obvious one-line fix.

## RESTART after interrupted review — 2026-10-22

The first fresh Sol reviewer was interrupted without a verdict because its foreground `npm run test:browser` call hit Hermes's 420-second tool cap. This is **not** a review or code failure.

Verified recovery state:

- no live reviewer remains;
- worktree HEAD is still `d2e86e1b388bd36322d051e7d3f3a524acf1bbdc`, main is still `b4ed333631dba923b73e1731ad420a4f92d880f1`;
- the worktree has no tracked diff, merge or rebase state—only the builder's preserved untracked `.superpowers/` evidence;
- interrupted-review scratch is `/Users/justin/.hermes/cache/scratch/pdf-review-bitfwd85/`;
- its independent `npm run check` completed with exit 0;
- its browser log passed tests 1–195, including pdf-direct-download tests 184–189 and pdf-new-tab tests 190–191, then tests 196–197 failed only because Chrome could not start within 20 seconds;
- six orphaned headless-Chrome roots with parent PID 1 were terminated and a read-back found zero remaining. A live `card-hover-shift` Chrome with a living parent was left alone.

Start the review fresh; do not treat the partial run as a verdict. Reuse the scratch evidence only as historical diagnosis. For the full browser suite, avoid another foreground-cap interruption: run it as a tracked background command and wait through `process_manage`, or split the unchanged browser suite into bounded file groups while preserving complete coverage. Independently rerun the feature-focused tests, mutations and important browser behavior. If Chrome startup fails again, preserve the exact process/resource evidence and distinguish host contention from source behavior rather than weakening tests.
