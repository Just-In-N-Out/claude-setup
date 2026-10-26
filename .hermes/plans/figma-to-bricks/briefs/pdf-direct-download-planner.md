# Planner brief — pdf-direct-download

## Role

PLANNER for the Figma-to-Bricks feature `pdf-direct-download`. Research and write the plan only. Do not create a worktree, branch, code change, commit, push, or live-site write.

## Request rewritten for action

Bug/change request: the generated **Download Full Inventory (PDF)** control currently opens the PDF in a new browser tab. When a visitor clicks a PDF download control, the PDF should instead begin downloading directly through the browser, so it appears in that visitor's normal Downloads folder rather than opening as a viewed document.

Screenshot: a dark heavy-equipment inventory table. At the bottom right is an outlined button with a download icon labelled **DOWNLOAD FULL INVENTORY (PDF)**. This is the affected control. The visible table contains equipment model, cylinder group, brand, and serial-number columns.

Done means:

1. Generated Bricks output gives supported PDF download controls direct-download behavior instead of opening a new tab.
2. The fix is general—never keyed to this button's text, page, layer ID, styling, URL, or one design.
3. Normal page/navigation links keep their existing behavior.
4. Existing PDF links outside the intended download-control pattern are not silently changed unless the plan explicitly proves that is the correct general rule.
5. The plan explains browser and Bricks/WordPress compatibility limits. Do not promise that JavaScript/HTML can choose the user's Downloads folder; the browser/OS controls the actual destination.
6. Tests prove the real emitted payload and browser click behavior, including controls that must remain new-tab or ordinary navigation links.

## Justin's words

> there is an issue when someone clicks the "Download the PDF" thing on Figma V2 bricks. What should happen is that it should automatically show up in Downloads on his laptop. However it opens up a new tab. Can we just make it so that when someone clicks that button, the PDF downloads directly on that person's laptop so it shows up?

Attached image: `/Users/justin/Library/Application Support/Hermes/composer-images/image_ef4835.png`.

## Required workflow and skills

Load these in order and say so in your first steps:

1. `figma-to-bricks`
2. `engineering-best-practices`
3. `implementation-planning`
4. `systematic-debugging`
5. `frontend-ui-repair`
6. `frontend-testing-workflow`

Follow the PLANNER role in `feature-dispatch` and the project skill. Read `figma-to-bricks` → `references/rules-summary.md`, then only the relevant portions of the repository's `CLAUDE.md`, memory, HANDOFF, prior plans, source, samples, tests, and history.

This is a bug/change to behavior previously addressed by the merged `pdf-new-tab` feature. Find the current root cause and the earlier decision with file/line/commit evidence before proposing the fix. Determine whether the correct mechanism is a Bricks link setting, an emitted HTML attribute such as `download`, a server `Content-Disposition` response, or another source-backed route. Account for browser same-origin/cross-origin restrictions and installed Bricks compatibility. Do not guess unsupported Bricks keys or claim a browser can force a specific filesystem directory.

No live-site writes, logins, uploads, or configuration changes. Read-only HTTP/browser checks are allowed if needed.

## Output

Write the self-contained plan to:

`/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`

Put `## Open questions` immediately after the title. Give each question 2–4 short lettered options and mark the recommended answer. Write the plan as if every recommended option is accepted, so Justin can reply `go` without a re-plan.

The plan must include:

- request playback;
- root cause with file/line/history evidence;
- exact general behavior and explicit non-goals;
- implementation tasks in dependency order;
- a test-first plan covering emitted Bricks JSON/HTML and real-browser click behavior;
- compatibility evidence required for the installed Bricks/WordPress/browser path;
- affected source and test files, including existing tests that pin the old new-tab behavior;
- risks and rollback;
- a `## Skills` section naming builder/reviewer specialists and any Agent Defect Loop skills;
- overlaps with currently open Figma work: `found-contacts`, `found-layout`, `found-tiles`, `found-gates`, `card-hover-shift`, `hero-media-row`, `found-list-head`, and `found-text-decoding`;
- an `## Other things found` section. Do not fix or fold unrelated issues into this feature;
- a final `## Docs & records` task naming: the plan copy, ledger, HANDOFF update and paste check, BUILD bump, main `CLAUDE.md` updates, and any project-skill summary/rule update.

Return a concise structured summary with `plan_path`, `summary`, `root_cause`, `questions`, `risks`, `touches`, `overlaps`, and `found_else`.