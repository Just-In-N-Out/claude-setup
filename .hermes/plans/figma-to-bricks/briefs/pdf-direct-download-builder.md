# Builder brief — pdf-direct-download

## Role and approved scope

BUILDER for Figma-to-Bricks feature `pdf-direct-download`.

The approved plan is:

`/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`

Read it first and implement it exactly. Justin approved all recommended answers on 2026-10-22: **1A, 2A, 3A, 4A**.

Approved behavior:

1. Same-site PDF links on structural download controls—native Buttons and linked Div/Block boxes whose root is the anchor—ask the browser to download.
2. Other-site PDF controls retain the existing new-tab/`noopener` fallback.
3. PDF links inside paragraph/rich text keep opening in a new tab.
4. This is plugin-only. Do not log in, write to the live site, alter WordPress/server configuration, upload files, or claim control over the visitor's filesystem folder.
5. Do not key behavior to words, page, layer ID, styling, one URL, or this screenshot.

Justin's words:

> there is an issue when someone clicks the "Download the PDF" thing on Figma V2 bricks. What should happen is that it should automatically show up in Downloads on his laptop. However it opens up a new tab. Can we just make it so that when someone clicks that button, the PDF downloads directly on that person's laptop so it shows up?

Approval: **“go”**.

Screenshot context: `/Users/justin/Library/Application Support/Hermes/composer-images/image_ef4835.png` shows a dark equipment inventory table. At bottom right is the affected outlined control with a download icon and the label `DOWNLOAD FULL INVENTORY (PDF)`.

## Required skills and workflow

Load these in order and state that you loaded them:

1. `figma-to-bricks`
2. `engineering-best-practices`
3. `test-driven-development`
4. `frontend-ui-repair`
5. `frontend-cross-browser-matrix`
6. `frontend-testing-workflow`
7. `mutation-testing-discipline`

Use `systematic-debugging` on any unexpected failure, browser discrepancy, corpus regression, or difference from the plan's evidenced root cause.

`frontend-ui-repair` and `frontend-cross-browser-matrix` carry the Agent Defect Loop. You are the implementation agent only. Do not spawn a reviewer or verifier; the main dispatcher will run fresh agents.

Follow the BUILDER role in `figma-to-bricks`:

- load only the required project context;
- create/reuse the isolated worktree `.claude/worktrees/pdf-direct-download` on branch `worktree-pdf-direct-download` from current local `main`;
- if an empty old copy exists, use `git merge --ff-only main`, never a destructive reset;
- copy the approved plan into `docs/plans/2026-10-22-pdf-direct-download.md`;
- establish baseline evidence;
- write a meaningful RED test before each behavior change;
- commit each passing task;
- stop at `ready-for-review`, committed and unmerged. Do not bump BUILD, push, merge, or edit the worktree's copied `CLAUDE.md`.

## Required implementation and proof

Follow the plan's dependency order. In particular:

1. Before source edits, run the plan's real-Chrome probe for same-origin and cross-origin `download` plus `target=_blank`. Preserve the result. If same-site download opens an extra tab, apply the plan's narrow fallback ruling: remove `newTab`/`rel` only from structural download controls and record that ruling. Do not broaden scope.
2. Use the documented Bricks custom-attribute route (`settings._attributes`) with valueless `download`; do not invent a link-control key or add JavaScript.
3. Preserve any existing custom attributes and deterministic IDs. Verify marquee/relinking behavior and remove no unrelated attribute.
4. Keep inline words, linked images, non-PDF links, phone/email/page links, and cross-origin PDF fallback behavior unchanged.
5. Prove emitted Bricks JSON and actual browser click behavior with real PDF bytes. A headless download event alone is insufficient: assert DOM attributes, no unexpected tab/navigation, saved bytes/name, keyboard activation, and the negative controls in the plan. Include one headed-Chrome deciding run where the plan requires it.
6. Run focused tests, mutation proof, `npm run check`, `npm run test:browser`, and the project corpus comparison. Preserve baseline and final reports as the project skill requires. Do not call a pre-existing corpus exit code a feature regression without identity comparison.
7. Since the change is behavior, not appearance, return text proof rather than before/after screenshots: old payload/browser outcome versus new outcome for each positive and negative control.
8. Copy durable builder evidence to the project-plan evidence area before reporting, and make sure the ledger/HANDOFF paths you cite actually exist.

## Coordination

The plan found no source overlap with `found-contacts`, `found-layout`, `found-tiles`, `found-gates`, `found-list-head`, or `found-text-decoding`. Avoid `test/browser/chrome.ts`, which `card-hover-shift` may touch. If `test/browser/render.ts` becomes necessary, inspect current branch/worktree ownership before editing and stop if there is a real conflict. `hero-media-row` overlap was unknown because its plan was absent; check its actual diff before touching optional shared files.

`docs/HANDOFF.md` is shared. Keep every sibling section during rebase, and take the next free paste-check number from current main at merge time—not now.

The live Services page currently lacks even pdf-new-tab's emitted `target`/`rel`. That is an existing verification gap, not permission to expand this build into a live-site or Bricks migration. Record it and leave installed Bricks 2.3.9 paste/copy-back verification owed.

If you find another bug or problem, do not fix or fold it into this feature. Return it in `found_else` with severity and evidence.

## Stop conditions and return

You cannot ask Justin questions. For a safe, plan-covered ruling, make it and record `My ruling, not yet confirmed`. For a real unapproved trade-off, installed-Bricks incompatibility that changes the mechanism, or conflicting source ownership, stop with the options and evidence.

If you run low on steps, commit everything that passes and stop with the exact worktree, branch, last commit, completed gates, and remaining task.

Return structured fields:

- `name`
- `status`: `ready-for-review` or `stopped`
- `summary`
- `rulings[]`
- `steps_for_justin[]`
- `stop_reason`
- `worktree`
- `last_commit`
- `shots[]` (empty unless unexpectedly visual)
- `text_proof[]`
- `found_else[]`
- `defect_loop_skills[]`
- exact test/gate evidence and artifact paths
