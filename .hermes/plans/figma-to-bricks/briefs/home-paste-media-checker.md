# CHECKER: Home paste media failure (read-only diagnosis)

Role: CHECKER for a failed live acceptance of the paste prepared in this conversation. This is bounded diagnosis, not a new implementation pipeline. Work fresh; do not spawn agents. You are not alone in the codebase; other sessions may release changes. Never revert others or touch sibling worktrees.

Load engineering-best-practices, systematic-debugging, and the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` CHECKER instructions, including rules-summary and only relevant project CLAUDE sections. Skills guide diagnosis only: no code/test/source/site edits.

## Ask rewritten
Justin pasted the Home payload prepared by this session and reports two failures: (1) clicking the picture/media control in Bricks does not show the image/media properly (exact editor vs preview interaction is being clarified); (2) the actual project photos reverted to older images rather than the newer photos on the preview he supplied. Establish the first broken boundary, restore mapping provenance and propose the smallest corrective artifact or evidence request. Do not conflate an editor-picker failure with frontend image loading/click-through.

Justin's words:

> Alright, there's an issue. The link I gave you, the media aren't working. When I copy and paste the photos, clicking on the media doesn't work. I don't know why. Also the photos for the actual projects got changed, so we need to fix them back to how they were. The copy-paste has bugs; the images don't show up when I click on them. The media for bricks doesn't show up on it. And the images are the old ones, not the new ones from the site I sent you.

## Known artifacts; preserve all originals
Repo main: `/home/justin/Documents/FigmaToBricksV2`. Read-only for this role. Feature label-floor released as build 2026-10-28.2 (commit 27b787b78d88850cbb9863bb31fcfc840406331c); main may since have moved. This is not proof label-floor code caused media issues.
Preview supplied by Justin: `https://darksalmon-badger-335429.hostingersite.com/?bricks_preview=1793205443`. Never log in or change site/media/cache. Use public GET only and inspect actual responses/headers.
All original preparation evidence:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/label-floor/paste-test/`
- `All-Type-Home-2026-10-28.2.json`: EXACT supplied 566-element Bricks paste, sourceUrl site origin, photos map 13 media and 30 inline SVG.
- `Copy-All-Type-Home.html`: exact payload embedded base64, copied to Windows Downloads `/mnt/c/Users/Admin/Downloads/Copy-All-Type-Home.html`. No Windows clipboard was successfully delivered by WSL xsel. User instead received this button file. Never replace it yet.
- `prepare.ts`, `finalize.mjs`, `conversion.json`: handmade artifact preparation using current main converter from saved `corpus/files/hydraulics-home.json` (Home Page Final), not a fresh open Figma selection. `prepare.ts` set site header/footer already present and convert inlinePictures:true. Do not assume these options preserve native Bricks media editability.
- `preview-curl.html`: COMPLETE original supplied Home preview captured BEFORE Justin pasted, critical baseline for newer project photos. `preview.html` is incomplete; do not use it as full baseline. `live-faq.json`, `live-links.json`, `live-summary.json`, read-live.py were extracted from this capture.
- `media-1.json` through media-4.json`: 377 public WordPress Media entries captured at preparation.
- `pages.json`, `asset-map.json`, `paste-receipt.json`, `clipboard-receipt.json`, `finalize.log`.
The first finalizer matched exact safe slug before currently displayed media for brand logos; this was corrected to prefer exactly one observed current page URL. All 13 non-SVG final URLs were checked present in the baseline HTML. That alone does NOT prove the project photo selection was correct (hidden alternatives may exist). Map each actual visible photo to its section/order/content and explain old/new.
All five original FAQ answers were restored by matching the exact question text. Pill minima, FAQ25px Content bottom spacing, other converted layout, and site header/footer handling must be preserved in any later correction. No production fix authorized in this role.

## Scope and output ownership
You may create diagnosis scripts/logs/screenshots/reports ONLY under:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/home-paste-media/checker/`
Preserve all original inputs; use scratch copies for any probe. Never edit Downloads, original paste-test artifacts, project source/tests/docs, main CLAUDE or skills/memory. No commits, uploads, authentication, media renames, cache purge or site writes. No Figma document edits.

Inspect source/contracts only as necessary to trace supplied artifact -> Bricks native image settings, public attachment ids/URLs, actual visible baseline/current site photos. Consult reference/bricks importer or copy/paste media schema before calling a field invalid. Compare main producer vs our handmade conversion options and final asset substitution. HTTP 200 alone is not a correct image or interactive picker proof. If possible use existing local Chrome testing tools for read-only DOM/screenshots; do not install system packages/sudo. Retain raw cache headers/timestamps for ordinary and timestamp-query requests and label cache evidence honestly.

Return a concise report with each symptom independently classified proven/unproved, file:line/element-id evidence, exact expected-vs-supplied media map (baseline visible projects), likely root cause with a falsifying control, and recommended minimum next action. If exact saved Bricks element Copy JSON is the first missing boundary, request only that affected element and explain what it will prove. Do not propose another broad pipeline until evidence demonstrates production source repair is needed. If a corrected one-off payload suffices, outline it and its preservation checks; do not write the replacement yet.
Return `verdict`, `ac_status` (live acceptance failed/unproved, not automated AC acceptance), `summary`, `findings`, `screenshots`, and `skill_lessons[{skill,lesson,evidence}]` (normally empty; do not edit skills or memory). End: MAIN SESSION: check and save these skill_lessons now.
