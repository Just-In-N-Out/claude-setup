# rods-page-link — correct destination ID, wrong service content

## Indispensable question first

**Q1. Open the existing Rods entry in “Edit with Bricks”. Does its main hero say Assembly or Rods?** The public URL already reaches WordPress **page 645**, but that page renders **SERVICE 05 / ASSEMBLY, TEST, PAINT & DELIVERY**.

- **A ⭐ Check page 645 first; if its saved Bricks body is Assembly, restore the intended Rods design into this same entry.** Keep the title, ID and permalink. This is the smallest repair supported by the evidence. Justin performs any site edit; agents remain read-only.
- **B The saved body already says Rods.** Do not replace it blindly. Supply one screenshot showing the builder URL/page ID and hero; inspect the owner’s content-template assignment and cache state before changing content. Public cache-miss responses already render Assembly, so “clear browser cache” alone is not an established fix.
- **C The screenshot’s intended entry is not page 645.** Supply that entry’s **View Page** public URL, or a screenshot with its editor post ID. Reconcile its identity before changing either link or content. Anonymous inventory cannot rule out an additional private/draft entry.

**Recommendation:** A, with the inspection before any save. One screenshot of page 645’s builder URL and main hero is the smallest indispensable observation that distinguishes wrong saved body from a site-rendering/template problem. No fresh Services export or new permalink is needed to prove the present public failure. A fresh **Rods** export is needed only if the correct body is not already available for restoration or its authoring source is disputed.

A bare **go** approves this bounded inspection/owner-assisted repair-and-check workflow; it is **not permission for agents to log in or write to WordPress**, and it does not authorize speculative converter changes.

## Playback

1. The selected yellow Learn More pill in screenshot 1 belongs to Services’ fourth service, Rods 1″–15″ & Rechroming Rods. Screenshot 2 shows an existing WordPress page entry bearing the Rods name.
2. The link really does navigate to that published Rods entry. However, the entry’s **rendered main content is Assembly**, so the visitor understandably sees the wrong service.
3. Repair the content rendered under the existing Rods identity; retain correct links. Do not create a second rods slug, redirect to a neighboring service, or repeat the prior new-tab fix.
4. Confirm success with the actual public click, WordPress ID/canonical URL **and main service content**. A 200, a Rods browser title, or Rods words in “More services” is insufficient.

## Authority, baseline, skills and scope

- **PLANNER only.** This turn creates this plan and read-only evidence. No repository source/test edits, application test suites, builds, worktree/branch, commit/push, login or site write.
- Repository: `/Users/justin/Documents/FigmaToBricksV2`; coherent committed main inspected at **`8f538bb0ad2ea287f7ae5f8dfce58ae9e01949e0`**, **BUILD `2026-10-22.6`**. Main equals its local origin/main tracking ref. Only the existing mutable root debug is dirty; preserve it.
- `CLAUDE.md:7` still reports 2026-10-21.12. This is stale protected-write/pending-record state, not current source identity. Do not bypass denied writes or reorder pending records.
- Loaded explicitly: `figma-to-bricks`, `engineering-best-practices`, `implementation-planning`, `systematic-debugging`, `frontend-ui-repair`, `blocked-page-recovery`. Read compact project rules; link-validation; panel-validation; plan-validation; relevant CLAUDE Start here, links/site state, General logic, Architecture, Working in repo and Debugging; project memory; prior link plan/HANDOFF; all three active sibling plans and actual diffs.
- **Agent Defect Loop applies** through frontend-ui-repair: owner-assisted repair/implementation → independent problem-finder → correction if needed → fresh independent verifier. Plan-only investigation does not launch builders. Do not pretend peer source review replaces public content verification.
- Non-goals: converter routing/tab/PDF policy changes; fuzzy matching; generic title-to-H1 production enforcement; uploads/media repair; font/capture work; changing page publication, title, slug, ID or template without the owner’s specific action/approval.
- Initial forecast: **15–25 minutes**, medium confidence, tool-observed start **2026-10-22 12:25:17 EDT**, with a 2–5 minute discovery checkpoint. The first live probe localized the mismatch by 12:26:23; Chrome click proof and sibling controls were complete by 12:30:43. Plan section/shell syntax and programmatic evidence-count checks passed at **12:37:13 EDT**, **11m 56s** after the recorded start, ahead of the initial range. The live identity oracle returned its expected RED; no application test suite ran. Implementation/source work was not started. Owner repair duration is unknown until Q1; allow 5–15 minutes for a simple available-content restoration, longer if its source/template must be recovered, plus review/live-check waits.

## Root cause: the public-rendered body disagrees with its correct WordPress identity

**Confirmed boundary:** Figma target → generated URL → current matcher result → supplied/saved link → public navigation all identify Rods. **WordPress page 645 then renders Assembly’s main service body.** This is a site content/rendering inconsistency, not an evidenced converter destination-selection defect.

**Not yet proven:** whether Assembly was saved into page 645, a wrong authoring frame was pasted, or a site content template/other rendering rule substitutes that body. The private saved Bricks structure is not exposed by the anonymous REST response. Do not accuse a specific paste action or call the saved body definitively wrong before Q1. A page-specific stylesheet containing the Assembly hero selector makes wrong page content plausible, but is not exclusive proof against all template/cache mechanisms.

### Trace and evidence

Evidence directory **E** = `/Users/justin/.hermes/plans/figma-to-bricks/evidence/rods-page-link/`. All live requests were unauthenticated GETs; cache-busted responses and raw bodies are retained.

| Boundary | Observed value and evidence |
|---|---|
| Historical source provenance | Retained Services capture `/Users/justin/.hermes/plans/figma-to-bricks/evidence/button-link-routing/builder-b4ed333/inputs/services-historical-build19.4.json`, build **2026-10-19.4**, root **528:3029 / Services Page Final**, SHA256 **ea87c30e946cf588bbce29b889a675d6c33a30cc4d46ede6a33d33b0448d0262**. This is not a fresh Services export. Mutable root file is **2026-10-20.6 / 553:7604 / Hydraulic Cylinder Repairs Final**, not this page. |
| Figma rods action | Pill **528:3176** has its own ON_CLICK / NODE / NAVIGATE → **553:10356**. Raw target name is `Rods 1"-15" & Rechroming Rods Final ` (one trailing space). Its separate hover reaction is CHANGE_TO, not navigation. Current reader trims the name and selects `/rods-1-15-rechroming-rods-final/`. `E/source-matcher-trace.json`. |
| Selection mechanism | `src/core/normalise/links.ts:97–109` selects the node’s successful click action, skipping hover; `:83–86` generates the frame fallback. `normalise/normalise.ts:237–238` indexes targets by ID, not repeated Learn More words. |
| Canonical site resolution | `src/ui/site-pages.ts:29–64,99–120` decodes/keys titles and matches; current pure-reader diagnostic with the fresh REST inventory uniquely selects **645**, no tie, same canonical path. Literal Figma ASCII quotes and REST `&#8243;`/`&amp;` yield the same **rod-1-15-rechroming-rod** key. Unicode mismatch is falsified for this case. |
| Permalink mechanism | `site-pages.ts:77–86` returns the published page’s real `link` pathname, not a new slug guess; `:126–154` relinks only listed IDs/runs with the still-current old href. `core/emit/page-addresses.ts:33–43` includes frame-provenance links; typed URLs remain protected. `ui/run.ts:168–180` applies results/notes. No current conversion-run receipt was supplied; pure-reader evidence is not a claim that a particular connected Convert ran. |
| Existing copied Bricks control | `/Users/justin/.hermes/composer-pastes/pasted_content_2026-10-22_12-30-58-791_ab5bab.txt`: **mpvmqc**, linked Div with `tag:"a"`, `settings.link:{type:"external",url:"/rods-1-15-rechroming-rods-final/"}`. Label/arrow are inside it; no newTab/rel. This is evidence for the one pill only. |
| Fresh public anchor | On Services **page 50**, the current rods pill is **brxe-cwrdtw** (Bricks IDs changed since earlier evidence). Literal href is `/rods-1-15-rechroming-rods-final/`; resolved href is on the configured site; no target/rel/download, no linked ancestor/nested anchor. Identify by service context and href, not the historic emitted ID. `E/chrome-clicks.json`, `E/click-summary.json`. |
| WordPress intended entry | Exact-ID GET `/wp-json/wp/v2/pages/645`: **type page, publish, parent 0**, slug `rods-1-15-rechroming-rods-final`, title rendered **`Rods 1&#8243;-15&#8243; &amp; Rechroming Rods Final`**, `link` = `https://darksalmon-badger-335429.hostingersite.com/rods-1-15-rechroming-rods-final/`. `E/rods-id.body` and receipt. |
| Exhausted public inventory | **X-WP-Total 9 / X-WP-TotalPages 1**; all nine IDs collected: 641,645,143,517,509,486,52,50,10. Explicit page 2 returned 400 / invalid page number. Yoast page sitemap independently includes the same rods permalink and no second published rods entry. `E/inventory-1.body`, receipts, `E/page-sitemap.body`. Anonymous absence is not evidence against private/draft entries. |
| HTTP identity | Direct canonical GET: **200, no redirect**, canonical rods URL, body class **page-id-645**, **H1 Assembly, Test, Paint & Delivery**. Initial cache-busted HTML had LiteSpeed **miss**, CDN **MISS**. `/?page_id=645` separately 301s to that same rods URL and same Assembly body. `E/rods.body`, `E/rods.receipt.json`, `E/rods-standard.*`, `E/rods-plain.*`. |
| Actual Chrome click | System **Chrome 155.0.8059.85**, Node **v22.19.0**, isolated profile. Real mouse click on the pill’s padding at **1440 and 390** commits a new document, page-target count **2→2**, final exact rods URL, canonical rods URL and page-id-645. Main H1 **brxe-edysjg / ASSEMBLY, TEST, PAINT & DELIVERY** both times. Main body: SERVICE 05, Assembly description, “How we finish every cylinder”, full reassembly/pressure-tested/painted/delivered process and Assembly FAQ. `E/chrome-clicks.json`, screenshots `rods-after-click-1440.png`, `rods-after-click-390.png`. |
| Not a redirect to Assembly | The site main-document chain contains only the rods URL. Raw Chrome trace also includes an independent Google Maps **iframe** redirect; `E/click-summary.json` explicitly separates it. Do not report it as a page redirect. |
| Site-specific content support | HTML loads `bricks-post-645-css` / `post-645.min.css?ver=1792533262`; that stylesheet contains the observed Assembly H1 selector `#brxe-edysjg`. Header/footer styles are posts 15/68 separately. `E/post645-css-receipt.json`, `E/post-645.min.css`. This supports page-645 rendering ownership; it is not access to the saved builder body. |

The screenshot of the selected pill shows editing selection, not link activation or URL settings. Editor click suppression may explain a click that merely selects an element **inside Bricks**, but does not explain the independently reproduced public wrong-service body.

### Working sibling controls, refreshed

All three were actually clicked in Chrome at 1440, with new document identity, no destination redirect, unchanged same-tab target count 2→2, correct ID and correct primary content:

| Service | Current public anchor | Href | Final ID | Main H1 |
|---|---|---|---|---|
| Repairs | brxe-ylpysh | `/hydraulic-cylinder-repairs-final/` | 486 | Hydraulic Cylinder Repairs |
| Remanufactured | brxe-gnwxgy | `/remanufactured-hydraulics-cylinders-final/` | 509 | Remanufactured Hydraulic Cylinders |
| Core Exchanges | brxe-hbukum | `/core-exchanges-final/` | 641 | Core Exchanges |

Historical Figma source actions are independently assigned to target IDs 553:7604, 553:8518, 553:9503, respectively; rods targets 553:10356 and Assembly targets 553:11209. Current matcher results preserve this mapping. A shared CTA label or reused hover variant does not swap the navigation actions in the inspected evidence.

### Ranked hypotheses resolved

1. **Correct URL, wrong rendered destination content:** confirmed by ID/canonical/main H1/process/FAQ and actual clicks.
2. **Wrong sibling href generated or saved:** falsified for the supplied control, retained source reader, current canonical matcher and refreshed live anchor. A fresh different authoring state remains possible but unneeded to explain this failure.
3. **Punctuation or duplicate-slug matching failure:** falsified for this published rods entry: same key, unique match, real permalink. No unsafe fuzzy substitute is warranted.
4. **Unavailable rods page or media attachment:** falsified: exact page645/publish, HTML page body, no file redirect. The separate Assembly path is still unavailable publicly.
5. **Only stale browser cache/new-tab/editor behavior:** does not explain cache-miss HTML plus independent desktop/phone document commits. Saved body versus server/template state remains Q1’s bounded private boundary.

## Prior release scope gap

Build **2026-10-22.6 button-link-routing** repaired discarded ordinary URL-action **openInNewTab** metadata and its ownership/copies. The rods source action is **NODE/NAVIGATE**, so its destination was not changed by that feature. It could not fix page645’s content.

The previous plan’s rods “200 / named page” evidence did not establish correct **main service content**. Its use of URL/browser title was too weak for this complaint. Green local metadata/anchor tests are not live content acceptance. Do not reuse that release’s narrow Garamond/capture waiver for this follow-up or mark its failed/unverified gates passing.

## Minimal general repair and exact allowlist

**Recommended repair: no converter change.** Apply the general rule “repair the failing owner”: preserve the verified navigation and restore the intended main content under its existing WordPress identity. Generality does not mean adding a speculative runtime heuristic.

### Allowed writes after approval

- Owner-controlled WordPress **page645’s service body only**, after Q1 proves it is wrong and the intended Rods body is identified. Agents do not perform these writes.
- If saved body is already right, **no content write**: first inspect the owner’s exact template/cache mechanism; obtain separate scope before editing a shared template. No header/footer or global-template change is pre-approved.
- Agent-owned local evidence under **E**; approved plan copy `docs/plans/2026-10-22-rods-page-link.md`; ledger `docs/plans/2026-10-22-rods-page-link-ledger.md`; narrowly scoped HANDOFF/CLAUDE records at normal integration time.
- **Production source allowlist: empty. Test-file allowlist: empty.** All files in `src/`, `test/`, `reference/`, and dist remain read-only for the recommended resolution. No worktree/build is needed for an owner-only content repair. If new evidence identifies a converter defect, stop and return a revised code/test allowlist for approval.

### Existing tests pinning current behavior (preserve, do not weaken)

- `test/unit/ui-site-pages.test.ts:38–61`: working-name keys, entity/Unicode punctuation and singular matching; `:125–159`: returned canonical/parent/plain permalinks and duplicate-title tie warning; `:168–193`: listed-ID-only relink and unmatched/draft/old-page notes.
- Same file `:21–35`: canonical relinking preserves each element’s own tab/rel and leaves typed/changed peers alone.
- `test/unit/convert-page-links.test.ts`: independent card destinations, listed IDs and phone-copy isolation; `test/unit/button-link-routing.test.ts`, `test/browser/button-link-routing.test.ts`: own selected destination/tab ownership, native/box behavior and copied/replaced metadata.
- `test/unit/normalise-label-links.test.ts`, `test/unit/label-link-descendants.test.ts`, `test/unit/convert-card-link-words.test.ts`: whole-pill ownership versus independent descendants, typed/frame provenance and plain card.
- **No existing test should be changed to a new outcome for this repair.** These correctly characterize URL mechanics and do not verify the remote page’s Bricks body. Do not manufacture a converter RED or change a correct expectation merely to make this a source patch.

## Test-first, bounded tasks

### 0 — retain the real RED (already completed by planner)

`E/public-click.mjs` performs the read-only public clicks and records main document identity, anchors, canonical and primary H1. `E/assert-page-identity.mjs` accepts expected path/ID/heading as inputs; no service-specific logic is installed in the converter.

The following oracle was actually run against the captured Chrome observations and returned **exit 1**. At both widths the final path, page ID, canonical and new-document assertions pass, while the primary-heading check fails. Receipt: **`E/identity-red.json`**. Preserve it unchanged.

```bash
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/rods-page-link/assert-page-identity.mjs /Users/justin/.hermes/plans/figma-to-bricks/evidence/rods-page-link/chrome-clicks.json /rods-1-15-rechroming-rods-final/ 645 'Rods 1"-15" & Rechroming Rods Final'
```

This is a live-acceptance evidence oracle, not an application unit test or HTTP200-only smoke check. It uses the existing page-name key only to tolerate the already supported formatting variants of the expected **main H1**; it never chooses another page. It must not replace the human/service-body comparison.

### 1 — identify the exact content owner (ready; 2–5 minute inspection)

1. Justin opens **Pages → Rods… Final → Edit with Bricks**.
2. Verify the editor address identifies **post/page645**, not merely a similar title. Do not save yet.
3. Inspect the **main hero**, not the More services rods card. Record its heading and the content source/template if shown.
4. Return Q1’s single screenshot. A → Task2. B → stop replacement and inspect the specific site rendering/template/cache boundary. C → reconcile the new public identity before proceeding.

Do not request credentials or have an agent log in. Do not copy/rename the entry as a shortcut.

### 2 — restore only the intended Rods body (owner action, gated by Q1A)

1. Preserve the current body via Bricks’ owner-managed revision/export before replacing content, so rollback does not erase Assembly work.
2. In Figma select the intended **Rods** frame, verify its hero and service description are Rods/rechroming rather than Assembly, and confirm the selected root/build when saving any debug. The retained target record is shallow (`extract/components.ts:128–145`); it proves target name/ID, not the target body. Do not relabel the Repairs debug as Rods.
3. If the authoring frame itself contains Assembly content, correct that authoring content first; do not repair it with a route heuristic. If conversion of a demonstrably correct Rods frame produces Assembly content, preserve source/output and stop for a new converter diagnosis before any paste.
4. With a correct Rods output available, Justin restores/pastes **only page645’s intended service content**, retaining its existing ID/permalink/title. Save. Do not alter the already-correct Services href, all service links, or create redirects.
5. If the paste includes code, regenerate Bricks code signatures; if it changes CSS, purge LiteSpeed after saving. Recheck cache-busted and ordinary navigation. Cache purge is a post-repair delivery step, not this plan’s claimed root cause.
6. Reply **pasted Rods**. Re-pasting Services alone cannot fix the demonstrated body mismatch. If a separate old Services page has a different stale href, refresh only that page with the verified canonical match and owner save; current `/services/` already needs no href repair.

### 3 — GREEN live acceptance (checker, GET-only; 5–10 minutes)

Save fresh observations under a **new evidence subdirectory**; do not overwrite this plan’s raw RED. Reuse a copy of `public-click.mjs` with only its local output directory changed. Refresh all selectors from service context/href: imported IDs are not stable contracts.

At **1440 and 390**, actually click the public Service004 Learn More pill; also activate it with **Tab + Enter**. Wait for a changed main-document identity rather than stale DOM readiness. Required result:

- Source Services page **50**, own rods pill, literal canonical href retained; padding, label and drawn arrow belong to the same anchor; no nested or enclosing-card link.
- No unexpected destination redirect; final exact canonical rods permalink on the same origin; page ID **645**; same-tab behavior remains unless a fresh explicit authoring action intentionally changes it. Do not silently add `_blank`.
- **Main hero H1 is the intended Rods 1″–15″ & Rechroming Rods heading**, with Rods/rechroming description and intended process/body/FAQ from the approved Rods design. The Service04 identity and main content must agree. Assembly may still appear legitimately in a More services card; a global ban on its words is not the oracle.
- Browser title/canonical/ID are still correct, but are not substitutes for the preceding content check.
- Re-run the primary-identity oracle against the **fresh** click JSON; require exit0. Compare complete main hero/process content with the approved Rods source and retain desktop/phone screenshots; changing only H1 to conceal Assembly’s body fails.
- Re-click Repairs486, Reman509 and Core641; retain their correct own canonical paths/main H1s. Inspect Assembly’s existing unresolved status separately; never make it pass by routing it to Rods.
- Preserve old/new raw bodies, response/cache headers, redirect receipts, source identity, actual hrefs and screenshots. A local fixture or a future asserted pass count is not live closure.

### 4 — independent review and verification

An independent problem-finder checks the complete source→ID→canonical→main-content chain, Q1 evidence, permitted owner repair and unaffected siblings. Correct only verified in-scope findings. A fresh independent verifier repeats the public desktop/phone and keyboard navigation/content check after owner save/cache delivery. No unresolved P0/P1, wrong service body, missing owner action or test-only synthetic claim may be called complete.

**Application gates:** not run during planning and **N/A for the recommended no-source owner repair**. No build/check/browser-suite/corpus run or old font waiver is needed to demonstrate a remote content correction. If scope changes to converter code, a new approved worktree/TDD allowlist and baseline/final check + full browser + corpus/no-worse evidence are mandatory; prior release waivers do not transfer.

## Expected page identity and regression controls

- **Expected WordPress entry:** ID645; publish; parent0; `rods-1-15-rechroming-rods-final`; public canonical permalink given above; API title exactly as retained; main service Rods/rechroming, not merely a Rods document title with Assembly body.
- **Canonical paths:** use returned `link`, including custom/parent or plain permalink forms in any future general regression; never recompute or assume `-final` from screenshots. No slug mutation is part of this fix.
- **Unicode:** preserve real literals in evidence. Existing ASCII quotes, U+2033 double-primes and entity decoding already match here. Do not rewrite key normalization without a fresh failing input. Distinct numbers/service words remain distinct.
- **Duplicate titles/slugs:** no second public rods candidate in exhausted inventory. A draft/private duplicate remains possible but cannot justify substitution. Retain existing tie warning/ranking; do not alter policy or add fuzzy fallback.
- **Unmatched links:** preserve approved Q2A keep-existing-address plus warning policy; explicitly typed URLs remain untouched. No neighboring-service substitution, no redirect creation and no unapproved HTTP validation in Convert.
- **Already-pasted state:** correcting converter code would not repair page645’s body. The owner content restore/save is essential; repair saved hrefs only where refreshed evidence shows they are actually stale.

## Risks, overlap, ownership and merge order

- **Wrong saved body versus template:** Q1 bounds this uncertainty. Public cache-miss HTML, main page-ID and post645 CSS do not disclose private builder provenance. Do not guess beyond the confirmed rendering boundary.
- **Wrong overwrite:** preserve the current body/revision before owner restoration; Assembly work must not be destroyed. If a shared template owns content, stop and separately scope its conditions so other services do not change.
- **Source gap:** historical Services targets are shallow; no complete fresh Rods frame is available. Correct body content must come from the owner’s intended design, not synthesized Assembly-to-Rods text substitutions.
- **No unsafe generalization:** this plan’s exact ID/path assertions are diagnostic acceptance data, not production branches. A universal “page title must equal H1” rule is not valid for every site and is not proposed.
- **Other-session ownership remains active even if no local delegate is listed.** At inspection: PDF branch **1698c13** changes `src/core/emit/elements.ts` (download predicate/attributes); card-hover branch **060b713** changes `understand/{ir,overlay}.ts`, `style/sizing.ts`, `adapt/least.ts`; hero branch **0e2a6b0** changes normalise/text, normalise/normalise, IR, phone/recognise, adapt facts/layout/least/shapes/type and style. Plans and actual source diffs were read. They own their implementation/holds; do not use them as a shortcut or alter them here.
- **Direct production overlap for this recommended repair: none.** No emitter, IR, normalise or layout edit is justified. Read-only checking may proceed while siblings finish; avoid unnecessary full Chrome suites during their gates.
- **Records merge order:** serialize HANDOFF/BUILD/CLAUDE handling through normal ownership/merge-lock procedure. Refresh coherent committed main after sibling releases before any documentation integration; never stage another owner’s partial main edits. Allocate the **next truly free check number** then (3be appeared unused at inspection but is not reserved).
- Explicitly stopped **found-*** branches remain stopped. No branch/worktree cleanup or resumption is part of this plan.
- Rollback: owner restores the preserved page645 revision/content; read-only checker records its state. No converter revert is indicated. A rollback can reintroduce the reported wrong-body symptom and must not be reported as success.

## Other findings — reported, not fixed

- Assembly’s expected `/assembly-test-paint-delivery-final/` still returns **404** and is absent from public inventory/sitemap. A missing public record is not proof there is no private/draft page. Its content appearing under Rods645 makes owner content-placement inspection important, but does not authorize moving/publishing it in this task.
- Current page645 REST `content.rendered` is empty while the frontend contains Bricks output. Do not interpret that field as proof of an empty page or evidence that the public body is inaccessible.
- The prior live Services IDs changed (old supplied mpvmqc/current cwrdtw), and REST Services modified time is 2026-10-22T16:18:52; this proves state has changed since older evidence, not what exact edit caused the body mismatch. Page645 REST modified time remains 2026-10-20T21:54:22. No historical paste audit was supplied.
- Main CLAUDE status is stale; existing pending protected-write records must be respected in build order. No record was modified here.
- The browser tool’s real-profile route was blocked by Chrome’s profile database write lock; no user browser was quit or settings changed. Existing system-Chrome helper with a new scratch profile supplied real click evidence and was closed normally. Generic web extraction backend was search-only and could not extract; direct unauthenticated HTTP/Chrome evidence is the basis, not that failed extraction. WordPress core sitemap path returned404; actual Yoast sitemap index/page sitemap succeeded.
- Raw source-matcher diagnostics include `pageUrl` called directly on an entity-encoded diagnostic string; that synthetic fallback is not a production WordPress title path. Actual matching uses decoded keys and returned canonical `link`. Do not misread that diagnostic as another demonstrated converter defect.

## Docs & records — final task

1. After approval, copy this plan to **`docs/plans/2026-10-22-rods-page-link.md`** through the normal owned documentation integration, and maintain/move its evidence/decision ledger to **`docs/plans/2026-10-22-rods-page-link-ledger.md`**. Retain exact source pins, original RED and separately named GREEN evidence; do not replace old claims silently.
2. Update **`docs/HANDOFF.md`** with the correct diagnosis, Q1 outcome, exact owner repair, evidence paths and **next free paste/live check number**. Correct the earlier implication that rods’ 200/title established content acceptance; preserve button-link-routing’s actual metadata fix and all unresolved checks.
3. **BUILD:** recommended result is **no plugin code change, therefore no BUILD bump or dist rebuild**. Record the inspected build and this N/A explicitly. If a later separately approved converter defect requires code, the finisher reads/bump/rebuilds BUILD only after its own review/verifier/gates; no builder or planner bumps it.
4. **Post-integration CLAUDE:** update main “Start here” and “Where things stand” with owner-content repair/live acceptance and the reusable check rule: destination verification includes primary content, not status/title alone. Respect earlier pending protected writes; if denied, retain exact pending edits without retry/bypass. Do not advance the displayed build for a content-only fix.
5. Final report must distinguish **diagnosed / owner inspection pending / owner repaired / independently live verified**. Return plan_path, root_cause, evidence, expected_page_identity, questions, touches, overlaps and found_else. Do not call this converter-fixed, published or live-resolved until the actual Rods main body and public navigation pass.
