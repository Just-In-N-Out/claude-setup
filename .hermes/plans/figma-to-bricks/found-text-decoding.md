# found-text-decoding — LPF-UTF16 (PLAN ONLY; implementation HELD)

## Questions first — all input-policy/capability choices remain held

**Q1. Which newly decoded files should this fix accept?**
- **A ⭐ Recommend:** only BOM-marked UTF-16LE (`FF FE`), the exact existing Excel Unicode Text finding, alongside today's unchanged UTF-8 path. Explicit UTF-16BE/UTF-32 signatures produce an honest unsupported-format error; no other encoding detection.
- B Add both BOM-marked UTF-16LE and UTF-16BE. This is additional input capability, not implicitly approved by the bug assignment; requires Justin's decision and a revised acceptance matrix.
- C Keep today's decoder; explain that users must export UTF-8. This leaves LPF-UTF16 unfixed.

**Q2. What happens to malformed or unsupported marked input?**
- **A ⭐ Recommend:** reject odd-byte or invalid-surrogate UTF-16LE without saving; reject explicit UTF-16BE/UTF-32 signatures with a resave-as-UTF-8 message. Match four-byte UTF-32 signatures before the two-byte LE signature. Keep UTF-8's existing replacement decoding, including malformed UTF-8, untouched.
- B Use replacement decoding for malformed LE. This can silently save changed cell values; not recommended.
- The four-byte `FF FE 00 00` prefix also describes LE beginning with U+0000: A deliberately refuses that ambiguous prefix instead of guessing. This is a held input-policy choice, not a pre-existing parser rule.

**Q3. Read failure and retry behavior?**
- **A ⭐ Recommend:** show “The spreadsheet couldn't be read. Choose the file again or save it as UTF-8 CSV.”; send no save message, preserve existing stored data/PDFs, reset the picker in `finally` so the same file can be picked again. Decode failures likewise show their specific error and do not post.
- B Retain the uncaught read rejection (current behavior). Not recommended.

The autonomous recommendation grant does **not** answer Q1–Q3 or authorize implementation. Parent must obtain/record the specific decisions and source ownership before a builder starts. No extra separator, row-action, validation or import-size policy is included.

## Justin's approval — October22
Justin replied **"A"** to parent bundled narrow Excel import choice, approving Q1A/Q2A/Q3A: only BOM-marked UTF16LE added, preserve existingUTF8 behavior, reject malformed markedLE and explicit unsupportedBE/UTF32, no unmarked guessing; recoverable no-save errors preserve current data/PDFs and reset picker for user retry. Input/error-policy hold cleared for this exact scope. All other W-B/ALONE/Garamond/CLAUDE constraints persist. Explicit Sol6.1 high pipeline, independent fresh review/verifier. Parent must reconcile source/disk/heavy capture admission before builder; no further go needed.

## Goal and playback

1. A spreadsheet already offered by the `.txt` picker can arrive as Excel Unicode Text, UTF-16LE with a BOM.
2. The current reader turns those bytes into UTF-8 text before CSV parsing. It produces corrupted headers and extra NUL rows, which are then saved to the Figma file.
3. Repair that byte-to-text boundary only, if approved. Leave the already-correct UTF-8 CSV/TSV parser, binding rules, PDF lifecycle and conversion pipeline intact.

**Routing:** explicit **Sol6.1 high** for builder and finisher; independent spec/code-quality/adversarial reviewer and fresh verifier also Sol6.1 high unless Justin changes routing. Do not substitute Opus or inherit another chat's model. This is a bounded import seam, not a reason to raise the six BUILDER/FINISHER cap.

**Planning authority/output:** read-only repository inspection and bounded Node diagnostics only; writes are this plan and `evidence/found-text-decoding/planner/`. No worktree, source/test edits, application test suite, commit, build, corpus capture or site operation occurred. No CLAUDE.md write/retry/bypass by this or another agent.

## Current context and immutable evidence

- Repository: `/Users/justin/Documents/FigmaToBricksV2`; integration branch `main` and local `origin/main` equal at observation; HEAD `b4ed333631dba923b73e1731ad420a4f92d880f1`, BUILD `2026-10-22.5`.
- Tool-observed planning start: **2026-10-22 07:26:08 EDT**; forecast 15–25 minutes, moderate confidence. Done condition: source-grounded saved plan, reproduced boundary and exact ownership, not implementation. No human-review/build wait is included. Planning finished earlier than forecast; final receipt records actual elapsed.
- Root status only `M figma-to-bricks-debug-page-1.json`; preserved. Its SHA-256 is captured without modifying/copying it. This is a byte-import bug independent of a Figma design; no debug replay is needed to localize it, and no debug export can preserve the original selected file's pre-decoding bytes.
- Free disk at first check **5.2 GiB** (lower than the brief's ~6.2 GiB); no clone, worktree, bulk archive or Chrome/corpus process. Builder must re-check capacity and acquire the parent-coordinated heavy slot before required gates.
- CLAUDE.md advertises `.12`, stale; current source/build/git/HANDOFF establish actual state. Its relevant general, architecture, searchable-list and debugging rules were read; stale docs do not undo later `.22` decisions. No attempt to refresh protected instructions.
- Canonical finding: `~/.hermes/plans/figma-to-bricks/found-else.md:10–11`, **LPF-UTF16**, under “list-panel-followups reviewer/finisher”. Remains open; this plan is not a closure.

### Durable bounded diagnostic (actually run, not application tests)

`/Users/justin/.hermes/plans/figma-to-bricks/evidence/found-text-decoding/planner/probe.mjs`

Run from the exact repo:

```bash
node /Users/justin/.hermes/plans/figma-to-bricks/evidence/found-text-decoding/planner/probe.mjs
```

Actual original output is `probe.json` in that directory: Node **v22.19.0**, **14 diagnostic inputs**, exit 0, same HEAD before/after. The diagnostic uses real Node `File.text()`, current `parseCsv`, `sendList`, and current plugin `saveList` with in-memory storage. It does **not** dispatch the real DOM picker or run Chrome/Figma; that boundary remains a builder acceptance requirement. Current `dist/ui.html` contains the same `if (f) sendList(l.id, await f.text(), deps);` reader. Source/dist/debug hashes are in the output; this is a reader-presence check, not a byte-reproducible bundle build claim.

| Input | Observed current result | Diagnostic meaning |
|---|---|---|
| UTF-8 TSV, UTF-8 Unicode, UTF-8 BOM, UTF-8 CSV | expected two columns, one row, one save | working twins |
| UTF-16LE BOM ASCII | NUL-interleaved headers, **four** rows instead of one, one corrupt save persisted | exact LPF-UTF16 reproduced |
| UTF-16LE BOM accented/CJK/astral characters | corrupted values and four rows, one save | stripping NULs would not repair lost characters |
| UTF-16BE BOM | corrupted headers, three rows, one save | unsupported control, not approved BE capability |
| UTF-16LE unmarked | corrupted values and four rows | demonstrates why unmarked files cannot be promised supported; do not add heuristics |
| LE odd tail / lone leading surrogate | corrupt save today; explicit fatal LE decoder throws TypeError | malformed controls, proposed rejection held |
| LE BOM only | existing no-rows error, no save | parser error remains separate from decode failure |
| UTF-32LE/BE signatures with short payload | existing no-rows error | demonstrates signature overlap; not a claim longer files are safe |
| malformed UTF-8 byte | replacement character retained, one save | pins existing fallback semantics, not a new strict-UTF-8 policy |

The generic exact reproduction is `Model\tType\r\nA7\tDozer\r\n` encoded LE with prefix `FF FE`, selected as `generic.txt`. Working control is the same text encoded UTF-8. Even setting the File MIME to `text/plain;charset=utf-16le` does not change current `File.text()` behavior. Explicit `TextDecoder('utf-16le', {fatal:true})` on the same bytes yields the original text; this is a discriminating diagnostic, **not an implemented decoder**.

Historical independent receipts were also read, not rerun or rewritten: `evidence/list-panel-followups/reviewer-fresh/probes/utf16-probe.mjs` and `finisher/sdd/fix/utf16-probe-branch.txt`. Historical script imports a transient scratch path; use the current durable diagnostic above, not that stale path.

## Root cause and smallest complete path

1. **File acceptance:** `src/ui/list-box.ts:35` advertises exactly `.csv,text/csv,.tsv,.txt,text/tab-separated-values`. Added by `8eb2a58` as part of released **2026-10-21.22** (`5e32aec`). No charset validation is present. This picker hint does not itself promise every encoding or justify a new MIME/extension rule.
2. **First bad boundary:** `list-box.ts:36–39`, `pick.onchange`, calls `await f.text()`. Original byte order and non-UTF-8 characters are lost here. MIME/name changes do not fix this.
3. **Parser:** `src/ui/lists.ts:63–74` accepts a **string**; `:64` removes a decoded U+FEFF only, not misdecoded `FF FE`. `split :12–33` sees NULs as cell content, so NUL fragments between CR/LF become nonempty rows. `headerSeparators :40–60` does not create the original corruption.
4. **Panel save:** `list-box.ts:19–27 sendList` → `lists.ts:86–89 listMessage`; corruption is structurally valid `ListData`, so `expectSave` is queued and `saveList` is posted.
5. **Plugin/store:** `src/shared/messages.ts:45` schema → `src/plugin/main.ts:48–49` → `src/plugin/lists.ts:23–28 saveList`, `write :14–19` → Figma `f2b-lists`. `src/core/normalise/lists.ts:29–44` checks strings/arrays, not original encoding. It cannot reconstruct bytes. Replace/remove deliberately keep saved PDFs (`plugin/lists.ts:21–25`).
6. **Acknowledgment:** `src/ui/main.ts:372–373` uses `savedText`. The new read-error path must not enqueue `expectSave` or emit a fake `listSaved`; successful paths retain this unchanged acknowledgment lifecycle.

### Ranked hypotheses, discriminating observations

- **H1 (confirmed): wrong byte decoder.** Same content differs solely by encoding; LE bytes fail current File.text, explicit LE decoding restores exact text before the unchanged parser.
- **H2 (ruled out as primary cause): tab/quote separator regression.** UTF-8 TSV and existing quoted-header controls parse correctly; corruption is already present before `parseCsv`.
- **H3 (ruled out as corruption origin): plugin storage/binding changes words.** Current `sendList` already carries corrupt columns; `saveList` preserves those strings in memory. The boundary is upstream, not list recognition.
- **H4 (not a solution): extension/MIME mismatch.** Same bytes with an explicit LE MIME still fail; changing accept cannot decode bytes. No accept-string change is proposed.

Do not “fix” this by deleting NULs, U+FFFD, every BOM occurrence, or adjusting parser separators; those lose real text and cannot recover non-ASCII characters already replaced.

### Authoritative platform references (GET-only)

Retrieved during planning, not dependency additions:
- W3C File API, §3.3.3 `text()` and §3.3.4 `arrayBuffer()`: `https://w3c.github.io/FileAPI/#dom-blob-text` — text always UTF-8; arrayBuffer preserves bytes. File inherits Blob behavior.
- WHATWG Encoding Standard, BOM table / TextDecoder / UTF-16 decoder: `https://encoding.spec.whatwg.org/` — explicit LE/BE labels, byte-order handling and malformed-sequence error mode. A decoder being available does not grant product approval for that encoding.

## Reconcile `.22`: existing, duplicate and held dispositions

- `.22` **did not implement LPF-UTF16**: current reader still calls File.text; `docs/HANDOFF.md:112–115` explicitly limits TSV to UTF-8, and `.22` ledger `:66–67` records the unresolved finding. No current test asserts correct LE byte import.
- `.22` **already fixed ordinary non-PDF row-action replacement**: commit `9656d5d`, `src/core/understand/list-rows.ts:62–65` excludes recognized `rowActions` from binding; `test/unit/list-actions.test.ts:31–102` covers native/box actions, extra columns, PDFs, missing links, genuine data cells, per-row badges and the approved constant-badge cost. This is source/test/history reconciliation, **not a fresh suite execution**. Parent/found-list-actions owns independent disposition; do not duplicate this fix or edit its recognizer.
- `.22` quote-aware separators, existing tie order comma → semicolon → tab, truthful removal, multi-PDF connection freshness, cancellation and ordered store acknowledgment are retained. Large-CSV warning, shared desktop/phone list data, new list recognition/alignment and main.ts Stage 2 remain outside scope.
- **HELD unchanged:** W-B / ALONE / grid policy; Garamond Condensed **UNVERIFIED**, no stand-in, no narrowed expected family set, no extended historical waiver. No site writes (GET-only if later inspection is necessary); no CLAUDE write/retry/bypass; preserve root debug.

## Architecture / proposed smallest repair (conditional on Q1A/Q2A/Q3A)

Introduce one small DOM-free panel-only helper `src/ui/list-text.ts`:

- `decodeListText(bytes: Uint8Array): string | { error: string }` determines only explicitly marked formats; UTF-8/unmarked fallback is exactly replacement UTF-8 decoding. Check 4-byte explicit UTF-32 signatures before LE; BE is an explicit unsupported error under Q1A. No sniffing, locale fallback, MIME/extension inference, normalization, parser or store schema change.
- `readListText(file: Pick<Blob, 'arrayBuffer'>): Promise<string | { error: string }>` reads bytes once and maps I/O rejection to the approved read error.
- `pick.onchange` reads using that helper; errors set `listStatus` and never call `sendList`; success calls existing `sendList` unchanged; `finally` resets `pick.value`.
- Keep `parseCsv` API and internals unchanged. Its line 67 comment can be narrowly corrected to explain decoding now occurs in the picker; do not broaden the public string parser into a byte parser.
- No global rejection of NUL/replacement characters, no repair of already saved corrupted data, no migration or silent reinterpretation of old plugin data. Users reselect the original file; Replace preserves saved PDFs through the existing store behavior.

### Exact conditional reference implementation (not executed / not approved)

Complete proposed new module, used only if Q1A/Q2A/Q3A are approved:

```typescript
export function decodeListText(bytes: Uint8Array): string | { error: string } {
  const utf32 = (bytes[0] === 0xff && bytes[1] === 0xfe && bytes[2] === 0 && bytes[3] === 0)
    || (bytes[0] === 0 && bytes[1] === 0 && bytes[2] === 0xfe && bytes[3] === 0xff);
  if (utf32 || (bytes[0] === 0xfe && bytes[1] === 0xff)) {
    return { error: 'This spreadsheet encoding is not supported. Save it as UTF-8 CSV and choose it again.' };
  }
  if (bytes[0] === 0xff && bytes[1] === 0xfe) {
    try { return new TextDecoder('utf-16le', { fatal: true }).decode(bytes); }
    catch {
      return { error: 'The UTF-16 spreadsheet is damaged or incomplete. Save it again as UTF-8 CSV and choose it again.' };
    }
  }
  return new TextDecoder('utf-8').decode(bytes);
}

export async function readListText(file: Pick<Blob, 'arrayBuffer'>): Promise<string | { error: string }> {
  try { return decodeListText(new Uint8Array(await file.arrayBuffer())); }
  catch {
    return { error: "The spreadsheet couldn't be read. Choose the file again or save it as UTF-8 CSV." };
  }
}
```

In `list-box.ts`, add `import { readListText } from './list-text.ts';`; replace only the existing `pick.onchange` body (inside `showLists`, retaining `l`, `deps`, `pick`):

```typescript
pick.onchange = async () => {
  try {
    const f = pick.files?.[0];
    if (!f) return;
    const text = await readListText(f);
    if (typeof text === 'string') sendList(l.id, text, deps);
    else deps.el('listStatus').textContent = text.error;
  } finally { pick.value = ''; }
};
```

No race/token redesign is hidden in this handler change. Existing async read overlaps are not proved safe by these diagnostics; if independently reproduced as a separate defect, report it rather than widening lifecycle policy here.

## Exact ownership / source and test allowlist

Parent must reserve these paths after reconciling sibling writes; no shared edits by this planner.

| File | Granted future edit scope / reason |
|---|---|
| **new** `src/ui/list-text.ts` | only BOM byte-decoding + read-error helper above |
| `src/ui/list-box.ts` | one import and `showLists` spreadsheet onchange `:36–40`; accept string and PDF/removal/other wiring unchanged |
| `src/ui/lists.ts` | comment `:67` only; parser/body/list labels and message implementations are read-only |
| **new** `test/unit/ui-list-text.test.ts` | helper byte matrix + I/O failure; no shared fixture edits |
| `test/browser/panel.test.ts` | additive spreadsheet-byte tests beside `:385–404`, reusing `open/js/until/deliverList/fileStore/answerAsPlugin`; do not alter STUB, existing Google/PDF/removal tests or skip predicates |

**Read-only regression contracts (no assertion found pinning old LE corruption):**
- `test/unit/ui-lists.test.ts:5–42,58–69,118–132`: decoded FEFF, CSV/TSV, quoting, escaped/inch quotes, empty/header-only errors, exact tie order. “UTF-8” test title is truthful and need not be renamed.
- `test/browser/panel.test.ts:352–404`: existing UTF-8 import/replace/remove and exact accept string; `:418–430` actual plugin store helper; later removal/PDF freshness/cancel tests stay unchanged.
- `test/unit/plugin-lists.test.ts:11–42`: multi-list storage, refusal, PDF retention on Replace/Remove.
- `test/unit/normalise-lists.test.ts`, `test/unit/list-actions.test.ts`, `test/unit/list-pdfs-review.test.ts`, `test/unit/ui-list-files.test.ts`, `test/unit/ui-pdf-pick.test.ts`, `test/unit/ui-pdf-upload.test.ts`: shared lifecycle/conversion regressions, no writes planned.

**Sibling overlap report:**
- **found-list-head** (`found-list-head.md:73–98`): owns `core/understand/lists.ts`, export-only `list-links.ts`, conditional `adapt/rules/list.ts`; tests `adapt-list`, `understand-lists`, new `list-head`, browser `list-layout`, fixture `lists.ts`; later narrow D2 in `adapt-fixed-tiles-review`. **No direct write overlap** with this plan. Its shared recognizer/fixture are read-only here; do not add list-head tests to this feature. Q2 layout alignment remains held.
- **found-list-actions**: its plan was not yet present at **07:28:53 EDT**; briefing requests reconciliation of already released `.22` action behavior. Potential textual overlap only if it proposes UI wording in `src/ui/lists.ts`, or additive `panel.test.ts`. Our `lists.ts` claim is comment-only, panel subsection strictly byte import. Parent must serialize/consolidate same-file writes if sibling later claims them; do not assume a missing plan grants this file wholesale.
- **found-contacts** actual branch diff: normalise `contacts.ts/page-links.ts/page-words.ts` plus contact/title tests/docs; **none** of our files.
- **found-gates** actual branch diff at read: `shared/breakpoints.ts` + `unit/breakpoints.test.ts`; brief also reserves geometry/lint/snap/widths. **No direct file overlap**; browser/corpus host slot shared, await parent.
- **found-layout** actual committed branch delta empty at read; brief reserves nudge/place/turned/upright rules. **No direct overlap**; do not interpret empty delta as released ownership.
- **Tiles-A/Tiles-B** current branch delta empty at read; brief reserves past-edge/scene/compose/settings and fixed-tile/least/shapes/unpin/icons/kinds/tests. **No direct source/test overlap**; shared required gates and disk are the constraint. No `fixtures/lists.ts` edit needed here.
- `docs/HANDOFF.md`, release BUILD, ledger and plan copies are finisher-serialized records only. Do not update shared found-else/queues from this planner.

If any listed read-only assertion blocks the approved repair, preserve exact RED and ask parent for a narrow allowlist amendment; never weaken it ad hoc.

## Ordered microtasks — builder only AFTER decisions and source reservation

### 0. Admission / baseline (2–5-minute discovery; gates have separate waiting duration)

Re-read current main/build/status, brief, this plan and sibling reservations. Confirm Q1–Q3 decisions, Sol6.1 high routing, disk capacity and slot. Create only the approved feature worktree via project workflow after approval. Preserve user's root debug; use a scratch copy only for later replay. Save current diagnostic output and source hashes separately; do not overwrite planner evidence. Run required baseline checks/corpus only in the parent-issued heavy slot and preserve full original reports/pastes/HTML/fonts. Missing gates/font completeness stay disclosed/held; a historical Garamond waiver does not apply.

### 1. Exact-symptom RED at real picker boundary (2–5-minute focused test edit)

First add a test to the existing real bundled-panel suite, using bytes in File rather than `new File([text])` (string File construction always encodes the JS string and cannot reproduce this bug). Append beside the existing TSV test, before implementation. Complete proposed case using existing same-file helpers; expected list bytes are synthetic generic controls:

```typescript
test('LPF-UTF16: a BOM-marked LE file reaches the real list store without corrupting its words or PDFs', { skip }, async () => {
  await open();
  resetFile();
  answered = 0;
  await js(`window.__deliver({ type: 'init', build: 't', stored: {} })`);
  await js("document.getElementById('convert').click()");
  await deliverList(pdfList);
  await until("/^(ok|warn)$/.test(document.getElementById('status').className)");
  await js(`(() => {
    const text = 'Modèle\\t类型\\r\\nÉ7\\t泵 😀\\r\\n';
    const bytes = new Uint8Array(2 + text.length * 2);
    bytes.set([255, 254]);
    for (let i = 0; i < text.length; i++) {
      const u = text.charCodeAt(i);
      bytes[2 + i * 2] = u & 255;
      bytes[3 + i * 2] = u >>> 8;
    }
    const dt = new DataTransfer();
    dt.items.add(new File([bytes], 'generic.txt', { type: 'text/plain' }));
    const input = document.querySelector('#listItems input[type=file]');
    input.files = dt.files;
    input.dispatchEvent(new Event('change'));
  })()`);
  await until("window.__sent.some((m) => m.type === 'saveList')");
  assert.deepEqual(await js("window.__sent.filter((m) => m.type === 'saveList')"), [
    { type: 'saveList', id: '1:2', data: { columns: ['Modèle', '类型'], rows: [['É7', '泵 😀']] } },
  ]);
  await answerAsPlugin();
  const saved = new Map(parseLists(fileData[LISTS_KEY])).get('1:2')!;
  assert.deepEqual(saved.columns, ['Modèle', '类型']);
  assert.deepEqual(saved.rows, [['É7', '泵 😀']]);
  assert.equal(saved.buttons?.['5:6'].name, 'Full list.pdf');
  assert.equal(pdfsInFile(), 1);
  assert.equal(await js("document.querySelector('#listItems input[type=file]').value"), '');
  assert.match(await js<string>("document.getElementById('listStatus').textContent"), /Convert again/);
  assert.deepEqual(await js('window.__uploads'), []);
});
```

The declaration may be placed beside the UTF-8 test even though helper `const`s appear later: tests execute after module initialization; retain existing suite conventions. Do not add a second browser harness.

RED/GREEN command, `workdir=<approved worktree>`:

```bash
node --test --test-name-pattern='LPF-UTF16:' test/browser/panel.test.ts
```

Expected RED before code: exact message columns/rows differ (NUL/replacement corruption), **not** import failure, skipped case or Chrome startup timeout. `panel.test.ts` already rebuilds dist in its `before` hook; never run this in main. This case reaches actual picker → saveList message → real plugin store → acknowledgment, not just a decode helper.

### 2. Unit byte contract and minimal helper GREEN (two 2–5-minute slices)

Add complete `test/unit/ui-list-text.test.ts` before adding the helper. Initial missing-module RED is only a harness/setup stage, not the symptom proof (Task 1 provides that). The cases below specify Q1A/Q2A/Q3A; do not execute another answer as if approved:

```typescript
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { decodeListText, readListText } from '../../src/ui/list-text.ts';
import { parseCsv } from '../../src/ui/lists.ts';
const text = 'Modèle\t类型\r\nÉ7\t泵 😀\r\n';
const le = (s: string): Uint8Array => new Uint8Array(Buffer.from(s, 'utf16le'));
const marked = (s: string): Uint8Array => new Uint8Array([255, 254, ...le(s)]);

test('LPF-UTF16: LE BOM imports the same exact Unicode cells as UTF-8', async () => {
  assert.equal(decodeListText(marked(text)), text);
  const read = await readListText(new Blob([marked(text)]));
  assert.equal(read, text);
  assert.deepEqual(parseCsv(read as string), { columns: ['Modèle', '类型'], rows: [['É7', '泵 😀']] });
});

test('unmarked and UTF-8 inputs retain File.text replacement and BOM semantics', async () => {
  const utf8 = new TextEncoder().encode(text);
  for (const b of [utf8, new Uint8Array([239, 187, 191, ...utf8]), le(text),
    new Uint8Array([77, 10, 255, 10]), new Uint8Array(), new Uint8Array([255])]) {
    assert.equal(decodeListText(b), await new Blob([b]).text());
  }
  assert.equal(decodeListText(new TextEncoder().encode('x\uFEFFy')), 'x\uFEFFy');
});

test('malformed marked LE is rejected, never silently replaced', () => {
  for (const tail of [[65], [0, 216], [0, 220]]) {
    assert.deepEqual(decodeListText(new Uint8Array([...marked('M\nV\n'), ...tail])), {
      error: 'The UTF-16 spreadsheet is damaged or incomplete. Save it again as UTF-8 CSV and choose it again.',
    });
  }
  assert.equal(decodeListText(new Uint8Array([255, 254])), '');
  assert.ok('error' in parseCsv(''));
});

test('explicit BE and UTF-32 signatures are unsupported under Q1A, before the LE prefix', () => {
  for (const b of [[254, 255, 0, 77], [255, 254, 0, 0, 77, 0, 0, 0], [0, 0, 254, 255, 0, 0, 0, 77]]) {
    assert.deepEqual(decodeListText(new Uint8Array(b)), {
      error: 'This spreadsheet encoding is not supported. Save it as UTF-8 CSV and choose it again.',
    });
  }
});

test('a file read rejection is a recoverable error, not a save', async () => {
  assert.deepEqual(await readListText({ arrayBuffer: async () => { throw new Error('read denied'); } }), {
    error: "The spreadsheet couldn't be read. Choose the file again or save it as UTF-8 CSV.",
  });
});
```

Implement the exact conditional module/handler above; update only the stale decoding comment. Then unchanged focused browser RED must become GREEN; run focused units and pre-existing parser/store controls:

```bash
node --test test/unit/ui-list-text.test.ts test/unit/ui-lists.test.ts test/unit/plugin-lists.test.ts test/unit/normalise-lists.test.ts test/unit/list-actions.test.ts test/unit/ui-list-files.test.ts
```

No dependencies/config changes or new fixture framework. First commit explicit approved sources/tests only after focused proof; no BUILD in worktree.

### 3. Error/no-data-loss/retry controls (2–5-minute slices, same panel subsection)

Extend the actual panel regression with a table of odd LE, unmatched surrogate, BE/UTF-32 signatures and forced `File.arrayBuffer` rejection. Use the existing `resetFile`, `fileData`, `answerAsPlugin` (do not replace storage with a fake success assertion):
- Save `JSON.stringify(fileData)` before the pick; wait for the exact approved error, then assert zero new `saveList` and `saveListFiles`, byte-identical store, retained PDF count/addresses, no “Saving…” or success status, no upload/WordPress request, picker reset.
- For read rejection, override only that File instance's `arrayBuffer` via `Object.defineProperty` in the browser; do not globally mock TextDecoder or skip the byte reader. Then select the same valid bytes in a fresh File via the same input and prove exactly one correct save/acknowledgment. A retry is user-triggered, never automatic.
- A BOM-only/header-only input keeps existing parser no-rows wording and leaves prior stored data/PDFs unchanged.
- Cross-file ownership: deliver two list IDs, target the second input, ensure only its exact ID is saved and the first stored list is untouched. This is not new shared-list policy.
- Add UTF-8 byte parity cases (CSV comma, TSV/semicolon with quoted header separators, quoted newlines/escaped quotes, malformed UTF-8) comparing the new path to `Blob.text()` → unchanged `parseCsv`. Keep exact accept-string assertion; selecting `.csv` versus `.txt` must not alter byte decoding, and neither name nor MIME is authoritative.
- Check keyboard-visible error text and recovery focus in the actual panel; no unrelated accessibility redesign. Capture small panel error/success screenshots only if useful for the repair record; no page-wide screenshot workload or motion work.

RED/GREEN these acceptance cases using the same `LPF-UTF16:` test-name prefix. Record actual case counts, skips and raw output. Any zero/skipped-only result is not a pass.

### 4. Sensitivity, independent review and combined gates

- Isolated mutation/old-writer check: restore only the old `await f.text()` reader in a scratch copy, not in main/another live writer. The **real picker/store** Unicode test must fail on columns/rows; restore correct source and rerun green. Remove BOM recognition → LE case fails; use replacement rather than fatal LE → malformed case fails; ignore decoding errors/call sendList anyway → no-save/store guard fails. No broad mutation campaign needed.
- Independent reviewer stage 1: **spec conformance** against recorded Q1–Q3, exact LE byte reproduction, UTF-8 parity, unsupported/malformed error/no-save/retry and PDF preservation. Stage 2 only after stage 1 passes: **code quality/design**, tiny panel-only helper, unchanged parser/store API, no guessed encodings, no swallow/retry of writes.
- **Fresh adversarial problem-finder** did not author the fix and must try surrogate pairs, odd tails, misleading MIME/name, explicit BE/UTF-32 overlap, interior FEFF, existing UTF-8 replacement semantics, same-file retry, two-list ownership and store refusal. It may share the review role only if fresh to authoring context; attach concrete attack inputs/results, not agreement.
- Finisher addresses valid findings test-first. **Independent fresh verifier** then reruns exact corrected-head focused tests and applicable full gates; because `frontend-ui-repair` carries the **Mandatory Validation and Agent Defect Loop**, finisher stops `ready-for-verify` until verifier is clean. Reviewer/author self-assertion is not verifier closure. Blocking issue after two focused repair cycles → preserve failure and escalate, not policy expansion or gate waiver.
- Required baseline/final and post-rebase gates (exclusive heavy slot, explicit workdir):

```bash
npm run check
npm run test:browser
npm run corpus
```

These commands are **planned/not run**. Keep full baseline/final reports, exact pastes/HTML, fonts, lint and Worse-than-v1 identities. Corpus exit alone is not acceptance. With no import chosen, output should be byte-identical same-base; run matching git-debug and scratch-root-debug replays as required project no-worse evidence. New LE fixture changes only intentional input content, not converter/layout. No independent laptop/375/360/320 layout sweep is added: no CSS/layout source changes; if output changes without a newly decoded import, stop and diagnose.

Missing Garamond remains UNVERIFIED and a release blocker absent new explicit authority; do not provision a stand-in, narrow expectations, extend M1A or call corpus font completeness green. A full suite baseline infrastructure failure needs exact disclosure and no worse identity comparison, not silent skipping. No competing corpus capture with gates/layout/tiles.

## Acceptance / completion contract

- Approved scope documented before builder starts; current main/sibling source reservations refreshed.
- Actual binary LE BOM input through rebuilt panel picker → exact saveList → real plugin store/ack gives expected Unicode columns/rows, no NUL fragments, valid astral characters and retained existing PDFs.
- Existing UTF-8 outputs including BOM/replacement/quote-aware tie semantics unchanged. Only explicit approved markers gain decoding; unmarked input is never guessed or claimed universally supported.
- Unsupported/malformed/read failure sends no save, no overwrite, no PDF loss, no network side effects; real same-input retry recovers.
- No source/test assertion weakening, no unrelated action/head/layout policy edits, no new dependencies/size threshold/migration.
- Required gates and exact-head independent review/verifier completed or explicitly blocked; no claim planning equals implementation, review, release or Figma verification.
- Parent closes only LPF-UTF16 after verified merge/release and records remaining real-Figma check separately. BE/unmarked/legacy encodings remain unsupported unless separately approved. Already saved corruption is repaired only by reselecting/replacing the original file, not an automatic migration.

## Skills and Agent Defect Loop

- All roles: `figma-to-bricks` (rules-summary + panel-validation), `engineering-best-practices` (+peer-review-strategy).
- Planner loaded: `implementation-planning`, `systematic-debugging`, `qa-testing-local-cloud` (+detailed reference), `frontend-testing-workflow`, `frontend-ui-repair`.
- Builder: add `test-driven-development`, `mutation-testing-discipline`; use `systematic-debugging` on surprises. Panel specialist evidence is real File/DataTransfer → post → plugin store, not a replacement browser framework.
- Reviewer: `requesting-code-review`, `code-review-practice`, `frontend-testing-workflow`; spec first, quality second, fresh adversarial pass.
- Finisher: `receiving-code-review`, `test-driven-development`, `git-commit-rules`; stop before merge for fresh independent verifier required by `frontend-ui-repair`.
- Verifier: `qa-testing-local-cloud`, `frontend-testing-workflow`, scoped mutation awareness; reads actual candidate/evidence and reruns, not the author's prose.
- No agents spawned by this planner; added planners do not raise builder/finisher concurrency cap. No new reusable workflow was discovered requiring a shared skill edit; obey the own-plan/evidence-only write scope.

## Docs & records — LAST, future finisher only

1. Copy this approved plan to `docs/plans/2026-10-22-found-text-decoding.md`; maintain `.superpowers/sdd/found-text-decoding/progress.md`, then permanent `docs/plans/found-text-decoding-ledger.md` with actual decisions, base/candidate, RED/GREEN, mutations, review/verifier and gate evidence.
2. Update `docs/HANDOFF.md` with exact supported/unsupported encoding statement and next-free **Figma panel check**: reload released plugin, choose Excel Unicode Text containing accented/CJK/astral cells, Convert and confirm row/column words, Replace UTF-8 then Remove, confirm PDFs retained. No live-site paste/signature regeneration is newly required by a reader-only change; standard site check remains GET-only. Existing owed checks are not closed by this work.
3. Parent updates canonical LPF-UTF16 row only after verified release; no broad closure of old lists-minors/action/list-head rows. Preserve sibling records and all held items.
4. Bump `src/shared/build.ts` **only at authorized release**, build dist, follow existing merge lock/rebase/gates/push/readback policy. Never bump in builder or planning.
5. **No CLAUDE.md writes/retries/bypass.** Record future exact Start here / Where things stand / list-rule proposal only in `found-text-decoding-claude-md-pending.md`, after older pending builds in order; do not try writing first. This planner does not create it yet because decisions/release wording are not approved.
6. Final delivery distinguishes built / reviewed / verified / merged/pushed / real-Figma checked, names raw artifact paths, remaining unsupported encodings and any blocked gates; no invented pass counts or release number.
