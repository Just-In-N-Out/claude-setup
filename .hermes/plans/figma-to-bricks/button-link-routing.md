# Button link routing — preserve each CTA's own destination and navigation behavior

## Justin's release decision A — 2026-10-22

Justin explicitly chose **A** to finish this link release while accepting only the two independently established existing validation limits: **BLR-R1**, genuine Garamond Condensed absent in unchanged baseline/candidate; and **BLR-R2**, source-independent raster/capture differences reproduced with unchanged source/document despite identical HTML. These remain open, unverified validation issues, not passing checks. This waiver is only for button-link-routing's release; it does not authorize font substitutes, expected-set narrowing, weakened strict-pixel assertions, new regressions, other releases, or site writes. A fresh independent verifier must first confirm the link candidate and no new regression; only then may the finisher run the established release procedure. Assembly URL and installed Bricks acceptance remain separate outstanding checks.

## Justin's approval and model routing — 2026-10-22

Approved by Justin: **go**. Q2A explicitly chosen: keep the existing address and warn when unavailable; never guess a sibling page. The exact Assembly public URL was not supplied, so converter work proceeds while live 404 closure remains pending that input. No WordPress writes are authorized.

Justin explicitly confirmed: **“no continue with 6.1 sol”** after the interrupted dispatch setup. Use **gpt-6.1-sol via openai-codex, xhigh** for the remaining builder, fresh reviewer, fix/finisher and fresh verifier pipeline. This model choice does not waive the plan's independent review, defect loop, project gates or release boundaries.

## Open questions

The implementation below assumes the ⭐ answers. A bare **go** approves the bounded converter work, not a WordPress write or a claim that an unpublished destination has been repaired.

**Q1. What is the exact public permalink of the intended “Assembly, Test, Paint & Delivery” page?** Its currently published Learn More anchor goes to `/assembly-test-paint-delivery-final/`, which returns an actual HTTP 404. The complete public page inventory and sitemap contain no published Assembly page.
- **A ⭐ Supply the URL from WordPress “View Page” (not an editor/preview URL).** Keep this as the one indispensable live-completion input; then compare it with the fresh Figma link and conversion notes. Source-level work can proceed meanwhile.
- B It exists only as a draft/private page: the site owner publishes it, then supplies its public URL and reconverts. Agents do not publish it.
- C This CTA should deliberately open the rods page instead: explicitly confirm that destination and correct the authoring source. Do not infer this from the “rod staff” transcription.

**Q2. What should happen when a frame's page cannot be verified on WordPress?**
- **A ⭐ Preserve the existing approved policy:** keep an explicitly typed URL unchanged; frame/inferred navigation retains its existing fallback address and missing/draft warning. Never substitute another sibling's page or fabricate a different slug. An unavailable public page remains an explicit unresolved acceptance item.
- B Remove unmatched frame/inferred links and name them. This reverses the previous “page not made yet keeps its address” decision and needs an expanded plan/test allowlist.
- C Fuzzy-match the closest page anyway. Not recommended: it can turn the reported 404 into a worse wrong-service link.

## Playback

1. Five service sections have nearly identical Learn More pills. Each must use that specific Figma element's link, not its label text, component name, neighboring title, or an adjacent button's metadata.
2. A label-only pill may become a native Bricks Button; a pill with a drawn arrow remains a linked box. Both must keep the same source-link selection and emission path.
3. A frame destination is not itself proof that a published WordPress page exists at the generated address. Existing pages must use their actual returned permalink; an unresolved destination must not be silently redirected to a different service.
4. For ordinary navigation, an explicit Figma URL action's same-tab/new-tab choice must travel with that action's URL. Missing metadata must not inherit another action's choice. Existing PDF behavior belongs to `pdf-direct-download` and is not reversed here.
5. The present evidence separates two issues: the Assembly CTA really reaches a 404, but the currently published rods and Assembly CTAs both navigate in the same tab. Neither the screenshots nor the supplied JSON proves the reported new-tab difference.

## Baseline, authority, and skills

- Planning-only. No worktree, branch, source/test edits, commits, push, build, corpus run, or live-site write is authorized in this turn. Only this plan is created.
- Repository: `/Users/justin/Documents/FigmaToBricksV2`; inspected main **`b4ed333631dba923b73e1731ad420a4f92d880f1`**, **BUILD `2026-10-22.5`**. Main equals origin/main locally; only the user's `figma-to-bricks-debug-page-1.json` is dirty. Do not alter it.
- Main `CLAUDE.md:7` still says build `2026-10-21.12`; this is a known stale, protected-write/pending-record state, not the current source identity. Read current source, HANDOFF, and pending records together. Do not retry a previously denied protected write by another route.
- Loaded explicitly, in order: `software-development/figma-to-bricks`, `software-development/engineering-best-practices`, `software-development/implementation-planning`, `software-development/systematic-debugging`; then `codex-imports/frontend-testing-workflow`, `web/blocked-page-recovery`, and `codex-imports/frontend-ui-repair`. Relevant linked material: Figma compact rules summary; implementation-planning plan-validation reference.
- **Agent Defect Loop:** `frontend-ui-repair` contains the mandatory implementation → independent problem-finder → correction → independent verifier loop. The Figma skill also explicitly requires a fresh VERIFIER before merge when a loaded skill carries that loop. A reviewer report alone is not final verification. The other loaded specialist skills do not independently contain that named mandatory loop. This plan-only investigation does not start implementation agents.
- Initial forecast: 20–35 minutes, moderate confidence, tool-observed start `2026-10-22 08:34:19 EDT`. At `08:52:36 EDT`, elapsed **18m 17s**: the saved plan's required-section check passed, both TypeScript fences parsed with esbuild, and its Bash command fence passed `bash -n` (syntax only, no planned work executed). Live source/HTTP/Chrome evidence was collected; application test suites/build/corpus were not run. Repository readback still showed the same HEAD and only the pre-existing dirty debug. Investigation finished slightly ahead of the original range; no substantive validation scope was dropped. Builder effort is separately forecast below; user publication/paste and final live checks are external waits.

## Root cause and evidence

### 1. Actual live failure: a frame-derived address whose public page is unavailable

Read-only GETs and a fresh, isolated system-Chrome session on October 22, 2026 established:

| Service context | Live anchor ID | Literal href | GET/final destination | Redirect chain | target / rel |
|---|---|---|---|---|---|
| Hydraulic Cylinder Repairs | `brxe-tgzwfj` | `/hydraulic-cylinder-repairs-final/` | 200, unchanged path | none | absent / absent |
| Remanufactured Hydraulic Cylinders | `brxe-luqyyn` | `/remanufactured-hydraulics-cylinders-final/` | 200, unchanged path | none | absent / absent |
| Core Exchanges | `brxe-wgbwdp` | `/core-exchanges-final/` | 200, unchanged path | none | absent / absent |
| Rods 1″–15″ & Rechroming Rods | `brxe-mpvmqc` | `/rods-1-15-rechroming-rods-final/` | 200, unchanged path | none | absent / absent |
| Assembly, Test, Paint & Delivery | `brxe-qnebrj` | `/assembly-test-paint-delivery-final/` | **404**, unchanged path; title “Page not found - All Type Hydraulics” | none | absent / absent |

The site is `darksalmon-badger-335429.hostingersite.com`; `/services/` itself returns 200. The public REST GET `/wp-json/wp/v2/pages?per_page=100&_fields=id,slug,status,link,title,parent` returned **X-WP-Total 9, X-WP-TotalPages 1**, and exactly nine records: IDs 641, 645, 143, 517, 509, 486, 52, 50, 10. Rods is published page 645 at the exact rods href above. No Assembly record was present. A slug-filtered public GET for Assembly returned `[]`; the public page sitemap independently omitted it. This does **not** prove the page does not exist in the WordPress editor: a draft/private page is invisible to these anonymous reads.

Chrome inspection at **1440 and 390** found all five hrefs unchanged, no `base[target]`, no target/rel attributes, no nested anchors, and no linked ancestor. Each clickable pill measured **197.046875 × 59** at 1440 and **358 × 59** at 390. Actual mouse clicks on rods and Assembly each committed a new document (`performance.timeOrigin` changed), kept the page-target count **2 → 2**, and landed in the same tab: rods on its named page, Assembly on Page not found. Thus the live tab-difference allegation is **not reproduced now**; “opens a new page” may mean ordinary navigation, or another paste/state not available here.

Code provenance of these addresses:
- `src/core/normalise/links.ts:97–109` reads each node's own click action. A NODE/NAVIGATE action resolves its `destinationId` through the captured ID→name map, then `pageUrl`.
- `links.ts:83–86` constructs `/slug-of-frame-name/`; it has no WordPress publication knowledge.
- `src/core/normalise/normalise.ts:236–238` indexes names by ID, not by repeated CTA label; `:93–96,143–145` puts that node's selected href and frame name on its SceneNode.
- `src/core/emit/page-addresses.ts:33–43` lists only emitted IDs belonging to that frame-derived link; typed paths with no frame provenance are intentionally not candidates.
- `src/ui/site-pages.ts:77–86,99–120` uses the matched page's returned published permalink (including parent path), or retains the existing fallback when no page matches. `:126–154` rewrites only the listed IDs/runs whose old href still matches; it does not select buttons by their shared words.
- `src/ui/run.ts:74,168–180` performs that site check when WordPress is connected. The supplied paste has no run/site-check receipt, so it cannot show whether a connected check succeeded, failed, or was skipped.

**Conclusion:** the observed Assembly 404 is an unresolved source/site destination, not evidence that rods' URL leaked onto Assembly. Current code can emit/retain this frame-derived fallback, and an earlier paste can retain it indefinitely. Anonymous evidence cannot distinguish unpublished, removed, or renamed-without-public-match state. No historical permalink-change audit was supplied; do not assert one. Existing saved pages require owner re-convert/re-paste after the source/site state is corrected; this fix must not claim Convert changes saved-page hrefs or creates redirects.

### 2. Confirmed general converter defect: source tab metadata is discarded

- The installed Figma typings explicitly support URL actions with `openInNewTab?: boolean`: `node_modules/@figma/plugin-typings/plugin-api.d.ts:5698–5706`. Text `HyperlinkTarget` at `:5468–5471` has only `type` and `value`: do not invent tab metadata for text-run hyperlinks or NODE navigation.
- Extraction already snapshots reactions: `src/plugin/extract/dump.ts:56–76`; `plain.ts:2–6` preserves ordinary boolean fields. Extraction is not the demonstrated loss boundary.
- `src/core/normalise/links.ts:4,97–109` neither types nor returns `openInNewTab`; its selected-link result contains only `{url, frame}`.
- `SceneNode` at `normalise/scene.ts:114–118` and `IRNode` at `understand/ir.ts:46` carry hrefs without tab intent. `understand/node.ts:69–71` chooses the href correctly but cannot carry the lost metadata.
- `src/core/emit/elements.ts:108–111` uses the same emission block for native Buttons and linked boxes, but currently adds `newTab:true, rel:"noopener"` **only for PDFs**. It cannot honor an ordinary URL action's explicit true/false choice.
- Read-only pure-reader diagnostics on this exact main returned identical `{url:"/care/",frame:null}` for three explicitly synthetic URL-action inputs: `openInNewTab:true`, `false`, and omitted. This proves metadata loss independently of the unavailable fresh authoring state; it does **not** attribute the live same-tab/new-page complaint to that defect.
- `reference/bricks/link-schema.json:4,29–33` archives Link Control schema **2.4.3**, with `newTab` boolean and `rel` string. The supplied installed paste is **Bricks 2.3.9**. Existing PDF work is source-backed, not a completed installed-version round trip. New ordinary-URL tab cases still owe paste/save/copy-back and actual frontend checks.

### 3. Broken/working Figma comparison and supplied artifacts

The **mutable root debug is the wrong page**: build `2026-10-20.6`, root `553:7604` “Hydraulic Cylinder Repairs Final”, with no root Learn More service CTAs. Never relabel it as a fresh Services capture.

However, `git show b4ed333:figma-to-bricks-debug-page-1.json` is a retained **Services** capture, build `2026-10-19.4`, root `528:3029` “Services Page Final”. Read-only structural traversal compared all five sibling CTA subtrees, including all descendants, text segments, visible/absolute/hidden states, and their captured destinations:

| CTA source node | Captured own ON_CLICK NAVIGATE target | Target frame |
|---|---|---|
| `528:3095` | `553:7604` | Hydraulic Cylinder Repairs Final |
| `528:3124` | `553:8518` | Remanufactured Hydraulics Cylinders Final |
| `528:3147` | `553:9503` | Core Exchanges Final |
| `528:3176` | `553:10356` | Rods 1"-15" & Rechroming Rods Final |
| `528:3199` | `553:11209` | Assembly, Test, Paint & Delivery Final |

All five have ON_HOVER/CHANGE_TO reactions separately from ON_CLICK/NAVIGATE; `linkOf` skips hover. Each pill's captured subtree has plain “Learn More” text runs and a plain drawn-arrow subtree, no separately linked descendant, no hidden child or explicit absolute child in that pill. Rods and Assembly are both visible INSTANCE pills; their intended NAVIGATE destination differs, their navigation kind does not. Pure-reader diagnostics selected all five correct corresponding frame-derived paths on current main. The mutable Repairs capture also names the rods/Assembly target frames, but that alone does not make it a Services reproduction.

The exact supplied Bricks paste `/Users/justin/.hermes/composer-pastes/pasted_content_2026-10-22_12-30-58-791_ab5bab.txt` contains **three elements**: `mpvmqc` is a Div with `tag:"a"`, `settings.link:{type:"external",url:"/rods-1-15-rechroming-rods-final/"}`, plain label child `tuwksr` “Learn More” and image-arrow child `yxjwlx`; no `newTab` or `rel`. This exactly agrees with the current rods live anchor and is valid evidence about that one emitted link, not proof of all assignment or tab behavior. Bricks can rename imported IDs; compare source identity and ancestry, not a guessed raw-source hash to a live ID.

Both attached images were inspected. `image_1c3958.png` shows Service 004's rods Learn More pill; `image_74a66e.png` shows Service 005's distinct Assembly pill. Neither screenshot exposes a URL, a target attribute, a click result, or a browser tab. Do not infer metadata from the diagonal arrow drawing.

### Hypotheses checked, not conflated

1. **A source URL action loses tab metadata:** confirmed by installed API, source trace, and synthetic pure-reader probe.
2. **Repeated labels cause neighboring href assignment in this case:** not supported by the retained Services capture, current reader output, or live anchors. Preserve current correct selection and add stronger adversarial regression coverage; do not rewrite matching by proximity.
3. **The 404 is a guessed/unresolved frame path or old saved paste:** current unavailable path is confirmed; the paste's age/check state and a supposed prior permalink change are unproved.
4. **Only the words or an enclosing card are linked:** not present on the two live pills inspected. Existing `card-link-words` guards already address that class and must remain intact.

## Scope and non-goals

### Included

- Carry an optional boolean from the **selected ordinary URL action** through normalise → understand → emit, including explicit false, without borrowing from another action, node, label, card, or component.
- Keep the existing link selection precedence: own designer link; contact fallback; inferred page fallback. Preserve uniformly linked label promotion and conservative independent-descendant guards.
- Keep native Button and painted/outlined linked-box emission on the one shared path.
- Preserve ordinary explicitly typed internal/absolute paths byte-for-byte after existing safety classification; frame links continue through exact existing site matching and ID/run-scoped relinking.
- Bind tab metadata to the effective href owner through phone copies and deliberately clear it when a list/file binding replaces the source link.
- Add generic sibling/mixed-source/WordPress-canonical-path and real-browser regressions, plus a concrete owner-operated repair/check path for the already-pasted Services page.

### Excluded

- No hardcoded service names, Figma IDs, CTA words, slugs, site domain, colors, order, or pixels in production logic.
- No fuzzy name matching, automatic WordPress publishing, login, permalink changes, page edits, media renames, redirect creation, HEAD-checking every typed URL, or changing the established missing-page policy under Q2A.
- No redesign, layout/adapt/CSS changes, new dependencies, extra Code elements, synthetic anchors, changed SVG arrows, or wholesale replacement of the existing string-link model.
- No changes to PDF new-tab/download policy, rich-text PDF markup, or `pdf-direct-download` ownership. For this patch the existing PDF default remains unchanged, including its existing precedence; ordinary page navigation is the new source-metadata case. An explicit PDF false/direct-download policy is for that feature, not silently expanded here.
- No claim that the original wrong-sibling or new-tab symptom has been reproduced on fresh Figma data. Request a fresh Services debug if it recurs after source/site clarification; investigate a failing actual case before widening production changes.

## Proposed pipeline and exact implementation contract

Keep this small: **one optional `linkNewTab?: boolean` on SceneNode and IRNode**, rather than a compulsory field that forces edits to every synthetic-node fixture.

1. **Extract / snapshot — preserve, do not alter production.** Reactions already preserve booleans. Add a regression using `dumpNode`/existing extraction API fixture that true and false survive serialization. No schema version bump; old captures without metadata retain their behavior.
2. **Normalise — select URL and metadata together.** Extend the local `Action` shape and `linkOf` result with optional `newTab?: boolean`. At the exact successful URL-action return, include it only when `typeof a.openInNewTab === "boolean"`. Keep existing trigger/action order and URL safety behavior. NODE/NAVIGATE returns no tab override. Never scan the remaining actions for a tab setting.
3. **Normalise SceneNode — attach only when the corresponding link survives.** In `normalise.ts`'s `build`, copy selected `newTab` to `linkNewTab` only when the selected navigation URL is kept as `node.link`, not when used as a video source or blocked by file classification. Suppressed href means suppressed metadata. No mutation of Snapshot.
4. **Understand — choose one owner.** In `nodeIR`, copy `n.linkNewTab` only when the winning `ir.link` is that node's own `n.link` and no ancestor suppressed it. Native Button and box follow this same code. Video conversion clears both link and override. Contact/inferred links do not inherit an override from a discarded source.
5. **Copies/replacements — transfer complete intent.** `copyIR` already spreads properties; prove false as well as true survives. `understand/phone.ts`'s local ancestor link lookup must return href plus that exact owner's override, not only a string. Its hero deduplication must distinguish different **effective** tab behavior for otherwise identical label/href; omitted and false ordinary navigation stay equivalent, and old no-metadata deduplication remains unchanged. Copy fallback assignment transfers both fields. If `list-links.ts:113` or `list-rows.ts:72` replaces an href with a selected file, explicitly clear `linkNewTab`, even if the file URL happens to equal the prior href. Do not alter list recognition/removal policy.
6. **Emit — extend the existing shared native block, not one Button-only branch.** At `elements.ts:108–111`, preserve the exact href and existing Div/Block `tag:"a"` rule. For an ordinary link, omitted override emits the old `{type,url}`; true emits `newTab:true,rel:"noopener"`; explicit false emits `newTab:false` without adding rel. PDFs keep current behavior, pending the other feature. The small contextual implementation is:

```ts
// Context: inside the existing `if (ir.link)` block in emitPayload.visit.
const newTab = isPdfAddress(ir.link) ? true : ir.linkNewTab;
settings.link = {
  type: "external", url: ir.link,
  ...(newTab === undefined ? {} : { newTab }),
  ...(newTab === true ? { rel: "noopener" } : {}),
};
```

7. **Site matching — preserve existing ownership and real permalink resolution.** No matcher/source rewrite is justified by the observed Assembly state. Add integration tests through `convert → pageAddresses → matchPages → relink` showing actual published parent/custom paths win only for listed frame/inferred links. Explicit typed relative URLs, query strings, fragments, neighboring elements, and mixed typed/frame links sharing an old href remain untouched. Relinking must preserve target/rel belonging to the same element. A missing/publicly unavailable page is still reported honestly and never replaced by a sibling.
8. **Style/adapt — no edits.** Text hyperlinks have no source tab field in the supported Figma API. `label-links.ts` promotion moves the existing run URL/provenance and remains unchanged; it must not manufacture tab metadata from an icon/neighbor/ancestor. Keep the actual drawn arrow inside the pill anchor and the enclosing card plain.

## Touches and ownership allowlist

**Editable source (only the behavior described above):**
- `src/core/normalise/links.ts` — action/result optional tab metadata.
- `src/core/normalise/scene.ts` — optional SceneNode `linkNewTab` only; coordinate with found-tiles' separate SceneNode change.
- `src/core/normalise/normalise.ts` — bind selected metadata to kept href.
- `src/core/understand/ir.ts` — optional IRNode field.
- `src/core/understand/node.ts` — own-source metadata propagation/suppression.
- `src/core/understand/phone.ts` — ancestor-owner transfer and effective-behavior dedupe.
- `src/core/understand/list-links.ts`, `src/core/understand/list-rows.ts` — clear stale overrides only at explicit file replacement; coordinate with PDF owner.
- `src/core/emit/elements.ts` — shared native link-control emission.

**New test files:**
- `test/fixtures/button-link-routing.ts`
- `test/unit/button-link-routing.test.ts`
- `test/browser/button-link-routing.test.ts`

**Existing tests editable for narrowly scoped additions / any intentionally changed explicit-tab expectations:**
- `test/unit/extract.test.ts`
- `test/unit/convert-page-links.test.ts`
- `test/unit/ui-site-pages.test.ts`
- `test/unit/understand-phone.test.ts`
- `test/unit/list-pdfs-review.test.ts`
- `test/unit/convert-card-link-words.test.ts` (only explicit source-tab cases; legacy cases must remain exact).

**Read-only production dependencies:** `plugin/extract/{dump,plain}.ts`, `normalise/{label-links,label-box,text,contact-links,page-links,card-title}.ts`, `understand/{copies,widgets}.ts`, `emit/page-addresses.ts`, `ui/{site-pages,site-read,run,text-links}.ts`, `style/typography.ts`, `reference/bricks/link-schema.json`. A failing new test requiring different matcher/promotion policy is a stop/revision gate, not implicit permission to change these.

### Existing tests that pin behavior

These must be named in the builder brief, not discovered after a broad readonly test restriction stops the build:
- `test/unit/convert-page-links.test.ts:140–168`: generic alike-card destinations, own IDs, and a relink moving only one card; `:174–189` proves phone copies move only with their own card. They currently test inferred **whole cards**, not duplicate explicit-link CTA pills. Preserve their original expected behavior; add the missing sibling-button cases.
- `test/unit/convert-card-link-words.test.ts:27–53,65–70,92–114`: deep-equal legacy native/box link objects to `{type,url}` and plain inner words/card. Those no-tab-metadata cases must remain unchanged. Explicit false/true new cases may expect the newly added properties; do not loosen the old deep equals globally.
- `test/unit/normalise-label-links.test.ts:13–37,74–88` and `test/unit/label-link-descendants.test.ts`: snapshot immutability, mixed typed/frame provenance, separate label/icon and deep/absolute/hidden independent links, and linkless-decoration positive controls. Remain preservation controls.
- `test/unit/ui-site-pages.test.ts:108–123,136–164`: actual parent/plain permalinks and rewriting only listed elements; `:167–175` pins missing/draft/old-paste notes under Q2A. Add canonical-path and metadata preservation cases; do not erase these contracts.
- `test/unit/normalise-file-links.test.ts:72–95,116–135`: URL classification, allowed direct documents, and video-source separation. Retain all of them.
- `test/unit/pdf-new-tab.test.ts:12–28,40–74`, `test/browser/pdf-new-tab.test.ts:21–69`, `test/{unit,browser}/render-links.test.ts`: PDF defaults, untouched ordinary defaults, payload-faithful rel/target and actual tab behavior. **Do not change PDF policy tests here.** New ordinary explicit-override tests supplement them. The renderer must never synthesize noopener to make the new tests pass.

## Test-first implementation tasks

Work only after approval, in the feature's own copy. Default builder stops **ready-for-review**, not merged. Each source behavior gets its own RED → minimal GREEN → focused regression commit. The small editing steps below target 2–5 minutes each; inspection and running gates are separate waits. Forecast source/test work **60–110 minutes**, required complete gates/review/verification **30–90 additional minutes depending on host load**, plus owner permalink/paste waits of unknown duration. Reforecast after the first real RED and after 15 active minutes; do not turn this into an indefinite rewrite.

### Task 0 — refresh source identity, ownership and baseline (no change yet)

Re-read compact rules, current HEAD/BUILD/HANDOFF and `.worktreeinclude`; preserve the user's dirty debug. Coordinate PDF owner before edits. Create the approved worktree only now. Run baseline `check`, complete browser suite and corpus; save console logs, **full corpus/report-v2.json**, every baseline paste and full rendered HTML before the next run overwrites them. Record per-file fonts/findings/widths/v1-difference identities, not totals alone. No auto-fetching dependencies.

Save a **separately named** copy of the tracked Services capture using `git show <baseline>:figma-to-bricks-debug-page-1.json` inside the worktree's evidence area; label it build 19.4/historical. Also copy the mutable Repairs debug read-only under a different name/build. Never overwrite either provenance. A fresh Services capture, if supplied, is a third input, not a replacement silently presented as original evidence.

### Task 1 — tight RED for source metadata (then GREEN at the loss boundary)

Create `test/unit/button-link-routing.test.ts`; start with this complete regression module. It uses synthetic paths/labels, not the user's site:

```ts
import { test } from "node:test";
import assert from "node:assert/strict";
import { linkOf } from "../../src/core/normalise/links.ts";
import { frame } from "../fixtures/builders.ts";

test("the chosen URL action carries true, false, or no override with its own href", () => {
  for (const value of [true, false, undefined]) {
    const action = { type: "URL", url: "/support/?mode=full#details",
      ...(value === undefined ? {} : { openInNewTab: value }) };
    const node = frame("Control", { reactions: [
      { trigger: { type: "ON_HOVER" }, actions: [{ type: "URL", url: "/hover/", openInNewTab: true }] },
      { trigger: { type: "ON_CLICK" }, actions: [action, { type: "URL", url: "/neighbor/", openInNewTab: !value }] },
    ] });
    assert.deepEqual(linkOf(node, new Map()), {
      url: "/support/?mode=full#details", frame: null,
      ...(value === undefined ? {} : { newTab: value }),
    });
  }
});

test("frame navigation cannot borrow a following URL action's tab override", () => {
  const node = frame("Control", { reactions: [{ trigger: { type: "ON_CLICK" }, actions: [
    { type: "NODE", navigation: "NAVIGATE", destinationId: "2:901" },
    { type: "URL", url: "/elsewhere/", openInNewTab: true },
  ] }] });
  assert.deepEqual(linkOf(node, new Map([["2:901", "Support Final"]])), {
    url: "/support-final/", frame: "Support Final",
  });
});
```

Run `node --test test/unit/button-link-routing.test.ts`. Expected initial RED: the true/false result lacks `newTab`, not an import/setup failure. The frame-isolation case is an initially green preservation control; do not falsify it merely to obtain RED. Add legacy `reaction.action` rather than `actions`, non-click trigger, unsafe/blocked media, and video-source negatives using the existing fixture helpers. Add extraction true/false preservation to `test/unit/extract.test.ts` (green characterization is legitimate).

Implement only the optional metadata described in pipeline steps 2–4. Rerun the exact command, extraction test, and typecheck. Record the original RED result and scoped commit.

### Task 2 — generic sibling identity through conversion and emitted Bricks payload

Create `test/fixtures/button-link-routing.ts` using the real `builders.ts` helpers. Return `{snap, controls, labels, cards, targets}` with handles; never identify the test subject solely by visible “Learn More”. Fixture requirements:
- At least three visually alike sibling service cards/sections, all with the **same CTA label and component-like name** but independently authored hrefs.
- Two control representations: label-only painted pill → native Button; painted pill with an exact drawn vector arrow → linked Div/Block. Repeat with outlined and multi-style-label boxes.
- Inputs cover own URL reaction, own NODE/NAVIGATE, and linked label runs. Alternate own URLs with `openInNewTab:true`, false and absent. Text hyperlinks have no invented tab metadata.
- Reorder siblings, permute target-map insertion order, vary labels/addresses/nesting, add a linkless sibling, and keep an explicit link whose destination intentionally disagrees with the surrounding service title. The explicit source wins unchanged.

Add conversion tests in the same new unit file before extending emit. RED: the correct native/box href is already present but true's `settings.link.newTab/rel` is missing. GREEN after pipeline step 6. For each control assert **exact own source handle → emitted ID → href → newTab/rel**. Explicit false must survive, omitted must still omit. Assert children/plain label, drawn arrow retained, no linked enclosing card, no nested inline link, `assertPayload` passes, Snapshot unchanged, deterministic repeated conversion. Both representations must hit the shared emission path.

Add adversarial cases with independent linked descendants/runs including deep, absolute and hidden layers; even equal hrefs cannot erase provenance boundaries. Keep the positive linkless-deep-decoration promotion case. Existing `label-links.ts` should pass unchanged; if not, stop with its exact failing fixture rather than broadening this source allowlist silently.

### Task 3 — exact published paths and ID-scoped panel relinking

Add tests to `test/unit/ui-site-pages.test.ts` and `convert-page-links.test.ts` (or reuse the new fixture in the new unit file):
- A frame named “Support Final” initially produces `/support-final/`, while the uniquely matched published page's actual `link` is `https://site.test/catalog/customer-care/`. After `matchPages/relink`, only the listed control IDs/copies use **`/catalog/customer-care/`**, not a freshly slugified title or another card's address.
- A **typed** `/catalog/customer-care/?view=all#options` stays byte-for-byte, never joins the frame-derived relink candidates. Include an absolute typed address and a typed address equal to another frame's original href.
- Two sibling controls with identical labels and intentionally different URLs remain different after only one matching page is provided. Prove exact ids and inline `runs.at` ownership, not just all hrefs as an unordered set.
- Changing the matched href preserves that element's existing target/rel; a typed peer sharing the old href stays unchanged. A payload changed since conversion fails the existing old-href guard.
- Existing nested parent paths, plain `?page_id=` permalinks, publish/draft/private/missing states, punctuation/entity singular matches, ties, and media-blocked candidates remain unchanged. No live site responses are synthesized as “observed”; fixtures are explicitly offline stand-ins.

These are preservation/coverage tasks and may start GREEN. **No production matcher change unless a true failing case is localized and approved separately.** Existing Q2A missing-page behavior is intentional, not a test to weaken.

### Task 4 — complete-intent copies and explicit replacement

First add RED cases to `understand-phone.test.ts` and the new unit file for two header/hero CTAs with equal label and href but opposite explicit tab choices. On phones they must not collapse into one action. Add copied own-link/ancestor-link true and false cases, label-promoted default controls, and default/false effective-equivalence preservation. Then implement the bounded `phone.ts` change.

Add RED stale-metadata replacement tests to `list-pdfs-review.test.ts`: a source ordinary URL action with true is replaced by an explicitly selected document address; it must not keep that source override merely because the IR was copied. Cover row copies and list-level buttons, a same-address replacement, no-selection unchanged control, and the existing row-with-no-file removal behavior. Then add `delete <target>.linkNewTab` only beside the two replacement assignments. PDF output still uses its existing PDF policy. Reuse existing list fixtures/recognizers, do not invent a second button predicate.

Run each file directly with `node --test <exact-file>` after its RED/GREEN, followed by the combined focused command below. Separate unrelated recognizer failures from this feature.

### Task 5 — real-browser anchor ownership and navigation

New `test/browser/button-link-routing.test.ts`, using the current `chrome.ts` and `renderPage` harness (not a new browser framework):
- Serve the **actual converted/relinked payload** from a local HTTP server, with two ordinary destination pages. Their HTML may report origin/opener to the local server; label it an HTML navigation probe, not an installed-Bricks proof or fabricated WordPress response.
- At **1440 and 390**, inspect every duplicate-label CTA by its fixture-derived emitted ID. Read literal href, target, rel, owner tag, bounding rectangle, arrow rectangle, ancestor-anchor and descendant-anchor counts.
- Real mouse click on padding and on drawn arrow lands at the same own destination. Same-tab/explicit false keeps page-target count and commits a new main document; true retains the source document, creates the new destination tab, and has null opener. Wait for document/navigation identity, not just a stale ready DOM or an arbitrary sleep. Never silently pass if Chrome is skipped/unavailable.
- Native Button and drawn-arrow box must behave identically for a given selected link. No nested anchor; no enclosing-card click; text, padding and arrow belong to the same intended pill anchor. Tab reaches each visible link once, then the expected next link; press Enter through CDP key events if the existing helper only exposes Tab (do not fake keyboard proof with `.click()`).
- Include a protected descendant-link negative: a partial independently linked label/icon remains its own target rather than swallowed by promotion. Include explicit true adjacent to a default frame-derived control and a default text-link-promoted control: neither neighbor gains `_blank`/rel.
- If phone deduplication structure changes for the new true/false collision fixture, verify both visible phone actions remain present at 390; old fixtures keep the same count/geometry. No CSS or width change is authorized.

### Task 6 — same-base text proof and no-visual-change gates

Before/after evidence is primarily **text proof**, because the approved behavior is navigation, not appearance. Save under `~/.hermes/plans/figma-to-bricks/evidence/button-link-routing/` and a short human-readable `shots/button-link-routing/proof-links.txt` at implementation time.

Each row must include: tested source revision/base, input source node/fixture handle, visible label plus service/card identity, selected action/run source, emitted ID, href, newTab/target/rel, clickable owner and its rectangle, drawn-arrow inclusion, nested-anchor count, enclosing-card link status, and final click destination/tab/opener result. The three ordinary source-tab cases have this expected before/after change:

| Input | Before | After |
|---|---|---|
| URL `/support/`, `openInNewTab:true` | same href; override lost | same href; `newTab:true`, `_blank`, `noopener` |
| URL `/care/`, `openInNewTab:false` | same href; override lost | same href; `newTab:false`, no target/added rel |
| NODE/navigation, promoted run, or URL with omitted metadata | existing own href and defaults | **identical existing href/default fields** |

The historical Services capture contains only NODE/NAVIGATE CTAs: its current-base before/after payload and HTML should be byte-identical, not “fixed” merely because the generic metadata case changed. The current 404 will remain unavailable until Q1 is resolved and the owner repastes any corrected link. Assert exact per-CTA paths, not only equal screenshot pixels.

For generic existing controls and Services, compare same-base desktop/phone screenshot **decoded RGBA**, plus measured anchor rectangles and actual padding/arrow hit targets. A pixel-identical page alone does not prove link ownership. New metadata only must not change pixels or unrelated settings/IDs. For the deliberately added opposite-tab phone-collision fixture, keep an explicit authorized structure-delta record rather than falsely claiming identical pixels/counts there.

Run required commands from the approved worktree (not from main):

```bash
node --test test/unit/button-link-routing.test.ts test/unit/extract.test.ts test/unit/convert-card-link-words.test.ts test/unit/normalise-label-links.test.ts test/unit/label-link-descendants.test.ts test/unit/convert-page-links.test.ts test/unit/ui-site-pages.test.ts test/unit/understand-phone.test.ts test/unit/list-pdfs-review.test.ts test/unit/normalise-file-links.test.ts test/unit/pdf-new-tab.test.ts
node --test --test-concurrency=1 test/browser/button-link-routing.test.ts test/browser/pdf-new-tab.test.ts test/browser/render-links.test.ts
npm run check
npm run test:browser
npm run corpus
```

Replay the separately labelled tracked Services and mutable Repairs inputs with `npm run replay -- <saved-input> <owned-output>` and inspect normal corpus widths **390/768/1024/1440/design width**. Use `snap -- <input> <owned-output> 390,1440 --sides` for the no-look-change anchor/pixel pair; the widths argument is one comma-separated token. No margin/padding/floor change is planned, so 320/360/375 and laptop sweeps become mandatory only if a source change unexpectedly affects layout; stop/re-scope rather than silently accepting such a change.

Save original and final full reports/pastes/HTML. No corpus file may get worse: compare every old finding identity/multiplicity, heights, loaded/expected/failed font state and v1-difference identities at like widths. Do not compare replay output to corpus stand-in output. A corpus exit 1 caused by known v1 comparisons is not automatically new failure, but the newer font-completeness gate can also fail: preserve and name real failures, do not reuse M1A's historical narrow waiver as this feature's permission. Missing-font recaptures must be separately labelled matched-policy/font comparisons with full HTML equality proved, not overwrite originals.

After rebase, regenerate same-base proof. A successful `check` does not run browser tests. Revert/mutate only the fix in an isolated scratch copy to prove the true/false preservation, neighbor-isolation and phone-copy tests fail at the correct boundary; retain positive controls. Do not strand mutations in a shared copy or weaken assertions to force green.

### Task 7 — independent review, correction, verifier, and release gate

- Independent problem-finder reviews merge-base diff, this plan, current rules, retained source/live evidence, exact tested base and all changed consumers (especially phone dedupe/file replacement). No self-review substitution.
- Correct verified findings test-first within the allowlist; a policy expansion returns to approval. Rerun affected focused and full gates.
- Fresh independent VERIFIER repeats the symptom-specific and integrated checks on the final candidate. Unresolved P0/P1, missing required gates, altered/unreviewed scope, or a source revision different from the proof blocks merge.
- Finisher uses existing merge-lock/fast-forward/rebase workflow only after the loop is clean. No builder BUILD bump or main-folder edits.
- **Code release and live closure are separate:** the source metadata gap can be verified and released while Q1's public permalink/paste is waiting. The final report must say “converter verified; Assembly live 404 unresolved” until the actual public destination and owner paste are confirmed. Do not close every user criterion on synthetic coverage alone.

## Live repair and acceptance after owner action

1. Obtain Q1's public URL and, if the tab/neighbor complaint persists, a fresh Services debug whose build/root prove it is the current source. Compare each pill's own reaction and all descendant/run/absolute/hidden links with rods, not only its repeated words.
2. If intended page is draft/private, the **site owner** publishes it; agents remain read-only. If the Figma source points to the wrong page or a deliberately typed stale address, the owner corrects that source. If a matched frame page has a different published permalink, existing connected Convert selects that actual path. No plugin heuristic can invent a verified absent public page.
3. Reload the released plugin, Convert/copy with the intended WordPress connection, inspect per-link matched/missing notes, then owner re-pastes the affected Services content and saves. Existing saved links do not repair themselves. Regenerate Bricks code signatures only if the paste includes code; purge LiteSpeed for changed CSS. This link-only change does not need class-replacement instructions unless an independently approved CSS change is included.
4. Reply **pasted + Services page name**. CHECKER reads the exact frontend anonymously; record all five service identities/hrefs/target/rel/rectangles at desktop and phone, click rods and Assembly, record response chains/final pages/tab behavior, and verify Assembly resolves to the intended page rather than merely any 200. Wrong-service 200 is failure.
5. For explicit ordinary URL new-tab behavior, owner supplies one native Button and one drawn-arrow box test using the supported setting in installed Bricks **2.3.9**. Paste/save/copy-back must retain the correct per-link `newTab`/rel and plain inner content, and frontend clicks must prove target/opener behavior. Official newer schema and the local renderer are not installed-version proof. Preserve PDF check 3ar and its separate owner.

**Acceptance mapping:** sibling identity and no neighboring inheritance → Tasks 1–3 plus live table; real existing WordPress paths → Task 3 and Q1/owner check; source-only tab intent → Tasks 1/2/4/5; native/box parity → Tasks 2/5; existing working cases unchanged → baseline/final exact payload, corpus, PDF/classification/promotion controls. The unavailable-public-page item remains blocked, not silently waived, until step 4 passes.

## Risks, decisions, rollback, and overlaps

### Risks and rulings assumed under go

- **Evidence mismatch:** current mutable debug is Repairs, retained Services is historical. Do not claim a fresh Services reproduction or attribute source metadata loss to the present same-tab live links.
- **Source/site distinction:** current Assembly HTTP 404 is confirmed, but no published intended counterpart is visible. A valid public URL/publication state is required for live completion. No guessed replacement or unsafe nearest-name match.
- **Explicit false:** avoid truthiness checks that erase false; omit fields only when undefined. Legacy absent metadata stays byte-identical. No ambient `_blank` from neighboring actions.
- **Copies and replacements:** optional metadata becomes stale if href-only writers are ignored. Phone inheritance/dedupe and both file replacement assignments are explicitly in scope; ordinary no-metadata output and PDF policy remain unchanged.
- **Compatibility:** schema 2.4.3 is not installed 2.3.9 proof. Copy-back/frontend checks remain owed; the source patch reuses the same supported native fields already used by pdf-new-tab, not guessed keys.
- **Rollback:** revert this feature's scoped source commits and rebuild/release through the normal finisher process; preserve its tests/evidence as appropriate. Reverting code does not roll back owner-pasted content or WordPress publication. Do not reset/stash user changes or make live repair writes.

### Concrete overlap and merge order

- **`pdf-direct-download` is planning:** its brief changes PDF control behavior and explicitly preserves ordinary navigation. It can overlap `normalise/links.ts`, `emit/elements.ts`, `understand/list-links.ts`, `list-rows.ts`, renderer/behavior tests, and possibly typed link metadata. At this inspection only its brief existed, not a finalized plan or worktree. **This implementation must not begin shared-file edits until the dispatcher reconciles that plan's file ownership.** Preferred order: land this ordinary URL metadata/ownership fix first, then PDF consumes/preserves that metadata and owns download/PDF precedence. If PDF starts first, wait and rebase this plan, not two uncoordinated emitter rewrites. Read-only planning and separate fixture design can proceed now.
- **`found-contacts`** at `7908e85`: actual branch diff changes `normalise/{address,contacts,page-links,page-words}.ts` and contact/title integration tests. This plan deliberately leaves those production files alone. Build independently after PDF ownership is agreed; rerun contact/title/explicit-pill consumers after rebase. Do not merge this feature as a workaround for that feature's semantic review hold.
- **`found-tiles`** at `18f3b5d`: changes `normalise/scene.ts` (direct shared type file), `understand/compose.ts`, `emit/settings.ts` and tile tests. Coordinate the additive SceneNode field merge; neither feature changes the other's geometry policy. Must verify same-base anchor rectangles after rebase.
- **`found-layout`** changes adapt nudge/upright and style placement; no direct source overlap, but same-base no-visual-change evidence must be refreshed after it lands.
- **`found-gates`** changes breakpoints and browser geometry/lint; gate/report comparisons may need its final measurement policy. Preserve old reports and label any matched-policy recapture.
- **`found-text-decoding`** currently changes panel browser tests; no direct source overlap. Preserve those tests at rebase/full browser gate.
- **`card-hover-shift`** worktree appeared during investigation at current main with no committed diff yet. Shared node/IR/phone ownership is not yet known; dispatcher must recheck before parallel implementation. No assumption that an empty committed diff means no active editor.
- **Previously merged:** `link-hrefs` build20.14 (`72fbf68`, generic sibling tests `04bbc72` and phone-copy guard `a1dd0be`); `frame-text-links`21.5 (`bfeb633`); `link-upload-fixes`21.11 (`6ba11f5`); `text-link-followups`21.15 (`0cd4fd5`); `pdf-new-tab`21.18 (`f2a4a42`, native change `f0a2ddb`); `card-link-words`21.19 (`9f9b751`). Preserve their URL safety, provenance, run indices/labels, ID-scoped relinking, PDF defaults, and whole-pill/independent-descendant rules. This is not a reason to reopen their resolved logic.
- Shared docs/HANDOFF and build/merge lock are serialized at finish. Do not reserve a paste number now; the finisher allocates the next truly free number under the lock and updates all plan/ledger/report copies consistently.

## Other things found — report, do not fix

- Public header/footer links `/services-rods/` and `/services-assembly/` both return 404, even though the rods CTA's longer actual permalink returns 200. These are separate already-authored template/site links, not evidence that the inspected Learn More controls were swapped. Add to HANDOFF as owner follow-up, not production scope.
- `/services-page-final/` returns 404 while `/services/` is published. Existing site matching correctly needs the returned canonical permalink; do not link the site through a generated frame slug when the known page exists.
- Main CLAUDE status is stale relative to actual BUILD; respect pending protected-write records and apply in build order, not by bypassing a denial.
- Normalise's legacy whole-element NODE link path does not share text.ts's deleted/unnamed-frame notes; a missing NODE name can become `#`. This was not the observed rods/Assembly case (both target names are captured). Report as separate follow-up, do not broaden the metadata fix without a failing real contract and approval.
- Browser tool's real-profile route was unavailable because Chrome held its profile database write lock. No user browser was quit and no config was changed. An isolated headless system-Chrome profile under the authorized scratch directory successfully supplied the read-only DOM/click evidence and was closed afterward.
- Direct official-document extraction was unavailable in the configured web extraction backend; Figma Action HTTP fetch returned 202 without the requested content and Bricks Link docs returned 403. Installed Figma primary typings and the repository's archived official Bricks schema provide the actual inspected field evidence. Do not call those failed fetches current official-doc confirmation.
- The initial optional Node pure-reader diagnostic hit execFileSync's default output-buffer limit reading the large tracked debug; it produced no application verdict. A bounded larger buffer rerun completed and printed the five own-frame links and separately labelled synthetic metadata-loss observations. No full application test suite, build or corpus was run in this planning turn.

## Docs & records — final implementation task

- Copy this approved plan to **`docs/plans/2026-10-22-button-link-routing.md`** when implementation starts; keep a TDD/evidence ledger at `.superpowers/sdd/button-link-routing/progress.md`, then move it to **`docs/plans/2026-10-22-button-link-routing-ledger.md`** before release.
- Update **`docs/HANDOFF.md`** with confirmed dual diagnosis, actual changed behavior, exact before/after CTA proof, source/base identity, fresh review/verifier results, all deferred/unproved user symptoms, and the **next free paste/live-check number** allocated at finish. Preserve 3ar PDF and every unrelated outstanding check.
- Finisher reads then bumps **`src/shared/build.ts` BUILD**, rebuilds main dist and follows approved merge-lock/push verification. Builder never bumps BUILD in its copy.
- After merge, update main **`CLAUDE.md` “Start here” and “Where things stand”** in chronological build order. Respect prior denied writes; if approval remains blocked, preserve exact unapplied edits in the feature's pending file, state which sections did/didn't land, and do not retry through a different tool. This planning turn does not change CLAUDE.
- Update compact project rules summary **only if** the accepted implementation establishes a new reusable rule: selected URL action's tab metadata travels with its href; copying carries it and replacement clears it. Do not add status lines. Existing link-scope rules already cover whole-pill/hidden-descendant preservation and should not be duplicated.
- Final report must separate **planned / implemented / independently verified / merged / owner-pasted / live verified**. Return text-proof paths and remaining Q1/installed-version checks. “Done” for the user's site requires the actual intended public Assembly destination and post-paste check, not just green generic tests.
