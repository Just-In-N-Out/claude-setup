# PLANNER brief — button-link-routing

## Role

PLANNER for the FigmaToBricksV2 bug **button-link-routing**. Investigate and write an approval-ready plan only. Do not create a worktree, edit code, commit, merge, push, or change the live site.

## Skills — load in this order

1. `software-development/figma-to-bricks`
2. `software-development/engineering-best-practices`
3. `software-development/implementation-planning`
4. `software-development/systematic-debugging`
5. Any link/URL or frontend specialist skill that actually applies after inspection. Name every skill used in the plan and identify any that contain the Agent Defect Loop.

Follow the Figma project skill's **PLANNER** workflow. Start with its compact rules summary and only the needed parts of project context. Find the root cause with file/line evidence before proposing a fix. Do not ask Justin directly; put questions and recommended answers in the plan.

## Clear request

The Figma-to-Bricks plugin is assigning **Learn More** CTA hyperlinks inconsistently on a Services layout. A CTA can receive the wrong destination, wrong link behavior (for example opening differently from the working rods CTA), or a generated/selected slug that returns **Page Not Found even though the intended WordPress page exists**.

Fix the general conversion logic so each button-shaped CTA receives the hyperlink belonging to that specific Figma element, with the right destination and same-tab/new-tab behavior. Do not hard-code these service names, layer IDs, text, slugs, or this one website.

Done means the plan identifies the actual cause and specifies regression coverage proving:

1. Each sibling Learn More button keeps its own intended Figma URL.
2. One button cannot inherit or be paired with a neighboring service's URL.
3. Existing internal WordPress paths are preserved or resolved correctly instead of inventing a 404 slug.
4. Same-tab/new-tab metadata comes only from the correct source link.
5. Button-shaped boxes and native Button elements use the same safe link-assignment path.
6. Existing working link cases remain unchanged.

## Supplied Bricks output

Read this exact pasted Bricks JSON:

`/Users/justin/.hermes/composer-pastes/pasted_content_2026-10-22_12-30-58-791_ab5bab.txt`

The relevant emitted wrapper is an anchor (`tag: "a"`) with:

- label: `Learn More`
- `link.type`: `external`
- `link.url`: `/rods-1-15-rechroming-rods-final/`
- no visible `newTab` field in the supplied JSON

Use that as evidence, not as proof that emission is correct. Trace where its href and metadata came from.

## Screenshots

Inspect both attached images:

1. `/Users/justin/Library/Application Support/Hermes/composer-images/image_1c3958.png`
   - Service 004, **RODS 1”-15” & RECHROMING RODS**.
   - Yellow **LEARN MORE** pill under the service description.
   - This is the rods/rechroming comparison case Justin says behaves differently.

2. `/Users/justin/Library/Application Support/Hermes/composer-images/image_74a66e.png`
   - Service 005, **ASSEMBLY, TEST, PAINT & DELIVERY**.
   - Separate yellow **LEARN MORE** pill.
   - Justin reports another CTA can lead to Page Not Found although its intended WordPress page exists.

Use `vision_analyze` if needed. Compare the broken element's Figma/debug data with working sibling CTA elements, including descendants/runs and any absolute or hidden layers, as the project link-scope rules require.

## Live/read-only evidence

This is a bug seen on the site. Follow the project PLANNER rule to inspect relevant published pages read-only over HTTP/browser:

- Record actual anchor hrefs, redirects, tab behavior, and final destinations.
- Check whether the 404 comes from current code, a previously pasted guessed slug, or a page whose permalink changed after the paste.
- Never log in or write to WordPress.
- If the exact second broken destination cannot be identified from the supplied artifacts, make the smallest concrete question for Justin and still complete all safe diagnosis possible.

## Justin's words

> this is for Figma V2 bricks. There is an issue here with the hyperlinks. Sometimes they work, sometimes they don't. For instance this one right here for "Learn more": it puts it on a new page, which isn't like the rod staff one. There's something wrong with the hyperlinks when it comes to button assignments and all, or assigning the right link to the right part of it. There's another one I'll send you in the second photo where, when I click it, it says "page not found" but the page is definitely there even though the page for the rod staff should be there. Please fix it. I'll send you the code of the "Learn more" button.

Treat “rod staff” as likely voice transcription for the rods/rechroming service, but preserve uncertainty in the plan if evidence does not settle it.

## Existing and concurrent work to reconcile

Check current code/history and name concrete overlaps, especially:

- `pdf-direct-download` is currently planning and may touch shared link handling.
- `found-contacts` has been reviewing recognizer/link-adjacent behavior.
- Previously merged work includes `link-hrefs`, `card-link-words`, `frame-text-links`, `link-upload-fixes`, `text-link-followups`, and `pdf-new-tab`.

State whether this fix can build independently or must wait. Search for existing tests that assert the old behavior and list them under **Touches** as editable when necessary.

## Required plan output

Save the full plan to:

`/Users/justin/.hermes/plans/figma-to-bricks/button-link-routing.md`

Shape it like existing Figma plans and include:

1. Title.
2. **Open questions first**, with A/B/C options and ⭐ on the recommendation. Write the plan as though the recommended answers are accepted so a bare `go` is enough.
3. Plain-language playback of the bug.
4. Root cause with file/line evidence and artifact/live evidence.
5. Scope and non-goals.
6. Pipeline stages and exact source/tests touched.
7. Test-first tasks for generic fixtures, conversion integration, emitted Bricks payload, and browser anchor behavior. For this no-visual-change link fix, specify old-vs-new text proof: each CTA label/identity → emitted href, target/newTab/rel, clickable owner/rectangle, no nested anchor, no enclosing-card link. Include desktop and phone anchor checks if structure is affected.
8. Existing tests that currently pin the behavior.
9. Corpus/check/browser gates and before/after payload or pixel-identical proof required by the project skill.
10. Risks, decisions, overlaps, and merge order.
11. **Docs & records** task: copy plan to `docs/plans/2026-10-22-button-link-routing.md`; move ledger to the matching `-ledger.md`; update `docs/HANDOFF.md` with the next free paste/live check; bump `BUILD`; update main `CLAUDE.md` Start here/Where things stand after merge; update the compact rules summary only if the fix establishes a new reusable rule.
12. **Other things found** — report but do not fix unrelated findings.

Return a concise structured result with `plan_path`, `summary`, `root_cause`, `questions`, `risks`, `touches`, `overlaps`, and `found_else`.