# site-tests-offline: every test that draws a site capture or paste keeps Chrome offline (Mini)

Base: local `main` `392f67e2a6b52c40a64acaf7d344a50c934dee26` (Build 2026-11-14.2). Tests only: nothing under `src/` or `tools/` changes.
Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/planner/` (`probe.ts`, `probe-output.txt`).
Size: Mini is right. One helper, one guard, about 63 one-line launch edits of one pattern. No paste changes by a byte, so the
Bricks-pro standard is untouched.

## Questions (the ⭐ answers are taken unless Justin says otherwise)

- **Q1. How wide?** ⭐ **A: every test file that draws a site paste or capture** (63 or so files: the 2 that draw Justin's real scan
  bare, 41 that draw fixture pastes bare, about 20 already offline that move to the one helper). Why: the guard then has one rule a
  script can check ("a file that draws a site paste launches only through the helper"), so the next B-Dry test can't repeat this
  whatever its variables are called; the site fixtures also name real hosts (`swiperjs.com`, `www.openstreetmap.org`,
  `maps.google.com`, `www.youtube.com`, `www.facebook.com`). B: only the 2 real-scan files, and a guard keyed on the scan variables'
  names (smaller, but a new variable name slips past it).
- **Q2. The test that goes online on purpose.** `test/web/site-live-widget-bdry.test.ts:98` lets Chrome reach `cdn.trustindex.io`
  (the reviews widget's own host, never Justin's site) only when `F2B_LIVE_WIDGET_NET=1` is set. ⭐ **A: keep it, as the guard's one
  named exception; agents never set that variable.** B: take the network out of it (its own job: the widget's loader needs a local
  stand-in). `test/web/site-tiers-live.test.ts` (`F2B_LIVE=1`: it captures live sites, which is what that variable means) draws no
  site paste through these helpers and stays as it is; agents never set `F2B_LIVE`.

## Playback

A builder found that `test/web/site-slider-bdry.test.ts` draws Justin's scan of bdryswi.com in a plain Chrome whenever
`F2B_BDRY_CAPTURE` is set, so pictures the scan holds no bytes of, font files and widget loaders were fetched from the live site
during a test. Justin: "Fix it", for the whole class. Wanted: every test that draws a site capture or paste launches Chrome with the
offline rules `site:check` uses (127.0.0.1 and Google Fonts only), and a check in `npm run check` that fails when one doesn't.

## Root cause and the offending files (main 392f67e2)

`launchChrome()` (`test/browser/chrome.ts:380`) adds no host rule; each test must remember to pass one, and 14 files carry their own
copy of the rule string. Nothing checks it.

**Draw Justin's real scan in a bare Chrome (the reported bug, 2 files):**
- `test/web/site-slider-bdry.test.ts:43` `browser = await launchChrome();` then draws `F2B_BDRY_CAPTURE` (line 25) through
  `renderSitePaste`/`pastePictures`/`fontsHead` (import, line 23) at 48 widths.
- `test/web/site-elementor-faq-bdry.test.ts:31` `browser = await launchChrome();` then draws `F2B_BDRY_CAPTURE_1109` (line 16)
  through `renderSitePaste` (line 14). Its header says "No request names the site"; nothing enforces that.

**Draw a fixture site paste in a bare Chrome (41 files, `launchChrome()` at the line given):** `test/browser/`
`render-class-selectors.test.ts:51`, `site-background-control.test.ts:22`, `site-motion-flat.test.ts:20`; `test/web/`
`site-check-settle.test.ts:23`, `site-code-proof.test.ts:31`, `site-elementor-button.test.ts:35`, `site-elementor-carousels.test.ts:42`,
`site-elementor-divider.test.ts:28`, `site-elementor-grid.test.ts:26`, `site-elementor-linked-image.test.ts:29`,
`site-elementor-margins.test.ts:27`, `site-elementor-open-item.test.ts:19`, `site-elementor-open-place.test.ts:20`,
`site-elementor-pads.test.ts:26`, `site-elementor-pbox.test.ts:26`, `site-elementor-places.test.ts:63`,
`site-elementor-proof.test.ts:44`, `site-elementor-pull.test.ts:31`, `site-elementor-slider.test.ts:67`,
`site-elementor-stretch.test.ts:33`, `site-elementor-svg-icons.test.ts:31`, `site-elementor-swiper8.test.ts:54`,
`site-fonts-drawn.test.ts:69`, `site-inline-nested.test.ts:48`, `site-live-lifted.test.ts:47`, `site-logical-sides.test.ts:29`,
`site-motion-proof.test.ts:34`, `site-native-stay.test.ts:17`, `site-native-structure.test.ts:30`, `site-no-div-elementor.test.ts:30`,
`site-no-div-plain.test.ts:36`, `site-opens-more.test.ts:39`, `site-opens-proof.test.ts:34`, `site-page-proof.test.ts:42`,
`site-range-cancels.test.ts:40`, `site-slide-proof.test.ts:29`, `site-slider-reset.test.ts:18`, `site-sticky-header.test.ts:34`,
`site-twice-sides-more.test.ts:74`, `site-twice-sides.test.ts:61`, `site-upload-page.test.ts:42`. A suspicion only (not measured per
file): where a fixture names a real host, these fetch it today.

**Already offline, by a hand-written rule (about 20 files, moved to the helper so there is one way):** the 13 with a local
`const OFFLINE = "--host-resolver-rules=…"` (`capture-one-side-bdry:32`, `capture-speed-bdry:24`, `site-code-bdry:28`,
`site-elementor-bdry:33`, `site-elementor-page-bdry:34`, `site-elementor-wxr:22`, `site-motion-bdry:35`, `site-native-bdry:36`,
`site-no-div-bdry:30`, `site-page-bdry:33`, `site-page-bdry-paint:32`, and `site-opens-bdry:21` without Google Fonts, 2 launches);
`site-icons-look.test.ts:79` (`SITE_OFFLINE`); the 3 that use `test/fixtures/web/offline.ts` (`site-widget-places`, `site-widget-codes`,
`site-live-widget`); the 2 that launch with `chromeFor()`'s arguments (`test/browser/render-class-selectors.test.ts:107`,
`test/web/site-check-cli.test.ts:172`).

**Not touched, with why:** `site-live-widget-bdry.test.ts:98` (Q2); `site-tiers-live.test.ts` (Q2); tests that spawn
`tools/site-check.ts` (offline by `chromeFor`) or `tools/site-live.ts` against a 127.0.0.1 stand-in; capture tests of local fixture
sites that draw no paste. A plain test Chrome also calls Google's own update hosts at every launch (probe C): a follow-up, not this job.

The guard's own output is the final list: the two converter names (`siteToBricks`, `siteParts`) add a few files to the 61 the five
drawing names find (`site-scroll-lock.test.ts` and `site-check-lifted.test.ts` at least). Convert whatever it names.

## The fix

1. **One helper, `test/web/lib/offline-chrome.ts`** (new):

```ts
// The Chrome every test draws a site capture or paste in (site-tests-offline): no host but 127.0.0.1, localhost and
// Google Fonts, as site:check's (tools/lib/site-chrome.ts). Chrome reads only its last host rule, so the helper writes
// the one rule itself: a test's own names go in `maps`, each to 127.0.0.1 only.
import { launchChrome, type Browser } from "../../browser/chrome.ts";
import { SITE_OFFLINE } from "../../../tools/lib/site-chrome.ts";

const SWITCH = "--host-resolver-rules=";
const LOCAL = /^MAP \S+ 127\.0\.0\.1(:\d+)?$/;
type Launch = Exclude<Parameters<typeof launchChrome>[0], string[] | undefined>;
export type OfflineOptions = Launch & { googleFonts?: boolean; maps?: string[] };

export function offlineRule(o: { googleFonts?: boolean; maps?: string[] } = {}): string {
  for (const m of o.maps ?? []) if (!LOCAL.test(m)) throw new Error(`launchOffline maps a name to 127.0.0.1 only ("MAP www.x.test 127.0.0.1"), not: ${m}`);
  const rules = SITE_OFFLINE.slice(SWITCH.length).split(" , ").filter((r) => o.googleFonts !== false || !r.startsWith("EXCLUDE fonts."));
  return SWITCH + [...(o.maps ?? []), ...rules].join(" , ");
}
export function launchOffline(o: OfflineOptions = {}): Promise<Browser> {
  const { googleFonts, maps, ...launch } = o;
  const args = (launch.args ?? []).filter((a) => a !== SITE_OFFLINE);
  const own = args.find((a) => a.startsWith(SWITCH));
  if (own) throw new Error(`launchOffline writes the one host rule Chrome reads; give names in maps, not ${own}`);
  return launchChrome({ ...launch, args: [...args, offlineRule({ googleFonts, maps })] });
}
```

2. **Each listed file:** `launchChrome()` becomes `launchOffline()`; `launchChrome([OFFLINE])` with a local copy becomes
   `launchOffline()` and the local `const OFFLINE` goes; the files without Google Fonts in their rule (`site-opens-bdry`, the three
   on `test/fixtures/web/offline.ts`) become `launchOffline({ googleFonts: false })`, so what they reach doesn't change; the two
   `chromeFor()` launches become `launchOffline({ path: c.path, args: c.args })`. The file's import of `launchChrome` goes (keep
   `hasChrome` and the types). `test/fixtures/web/offline.ts` stays for the capture tests that use it.
3. **The guard, `test/unit/site-tests-offline.test.ts`** (new, runs in `npm test`, so in `npm run check`). Pure function plus a walk:

```ts
import { test } from "node:test";
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = fileURLToPath(new URL("../..", import.meta.url));
const DIRS = ["test/web", "test/browser", "test/fixtures"];
// a file draws a site capture or paste when it names a drawing helper or a site converter
const DRAWS = /\b(renderSitePaste|pastePictures|drawPictures|checkPage|buildStandIn|siteToBricks|siteParts)\b/;
const LAUNCH = /\blaunch(Capture)?Chrome\b/;
const WHOLE = /import\s*\*\s*as\s+\w+\s+from\s*"[^"]*browser\/chrome\.ts"/;
// the only lines naming a plain launcher a drawing file may keep, each with why
export const KEPT: Array<{ file: string; line: string; why: string }> = [
  { file: "test/web/site-live-widget-bdry.test.ts", line: 'import { hasChrome, launchChrome, type Browser, type Page } from "../browser/chrome.ts";', why: "the launch below" },
  { file: "test/web/site-live-widget-bdry.test.ts", line: "  browser = await launchChrome([NETWORK]);", why: "reaches the reviews widget's own host, only with F2B_LIVE_WIDGET_NET=1 (Justin, Q2)" },
];
// every line of a drawing file that names a plain launcher (a call, an import, an alias, a comment), as "file:line: text"
export function offenders(files: Record<string, string>, kept = KEPT): string[] {
  const out: string[] = [];
  for (const [file, text] of Object.entries(files)) {
    if (!DRAWS.test(text)) continue;
    text.split("\n").forEach((line, i) => {
      if ((LAUNCH.test(line) || WHOLE.test(line)) && !kept.some((k) => k.file === file && k.line === line && k.why)) out.push(`${file}:${i + 1}: ${line.trim()}`);
    });
  }
  return out;
}
const walk = (dir: string): string[] => readdirSync(join(ROOT, dir), { withFileTypes: true }).flatMap((e) => e.isDirectory() ? walk(`${dir}/${e.name}`) : e.name.endsWith(".ts") ? [`${dir}/${e.name}`] : []);
```

   Its tests: (a) `offenders` of the real tree is `[]`, the tree holds at least 40 drawing files and every `KEPT` line still exists in
   its file; (b) in-memory texts, one per shape, are each refused: a bare `launchChrome()`, `launchChrome([OFFLINE])` with a
   hand-written rule, `launchCaptureChrome()`, an alias import (`launchChrome as go`), a whole-module import of `chrome.ts`, a kept
   line with its reason emptied; and a drawing file that only calls `launchOffline()` and a non-drawing file that calls
   `launchChrome()` are both accepted. A comment that names `launchChrome` in a drawing file is refused on purpose: reword it.

## Acceptance criteria (all **proposed**; none live)

- AC1 (proposed): Given a site paste whose picture, font file and script name a host that is not 127.0.0.1 (a `*.localhost` name on the test's own log server: Chrome resolves those by itself, probe A), when it is drawn in `launchOffline()`'s Chrome, the log holds 0 requests for that host and the paste's own 127.0.0.1 picture still loads; the same page in a plain `launchChrome()` logs them (the control that shows the log can see it); `offlineRule()` holds exactly `SITE_OFFLINE`'s rules (Google Fonts kept), `{ googleFonts: false }` drops only the two font hosts, a name mapped to 127.0.0.1 in `maps` is served, and a map to any other address or a second host rule in `args` throws. Test: `test/web/offline-chrome.test.ts` › "AC1: a site paste drawn in the offline Chrome sends nothing to an outside host".
- AC2 (proposed): Given Justin's two scans (`F2B_BDRY_CAPTURE`, `F2B_BDRY_CAPTURE_1109`, each given only to its own file) and a Chrome wrapper that sends every host a launch doesn't rule on to a log on 127.0.0.1 (the sink: probe C, D), when `test/web/site-slider-bdry.test.ts` and `test/web/site-elementor-faq-bdry.test.ts` run, the sink's log is empty for both; on the base tree the same run logs at least one request for the scan's own site, answered by the sink (nothing leaves the machine either way). Test: `test/web/site-tests-offline-scan.test.ts` › "AC2: the two tests that draw Justin's scan reach no outside host" (named-only: skipped without the two variables; agents run it, it is not live).
- AC3 (proposed): Given the tree, `npm run check` fails when a file under `test/web`, `test/browser` or `test/fixtures` that draws a site capture or paste names a plain launcher outside the `KEPT` list: it passes on the head, fails on the base naming the two scan files among the rest, and fails on each one-line mutant (a listed file's `launchOffline()` put back to `launchChrome()`, the scan file's import aliased, a `KEPT` reason emptied). Test: `test/unit/site-tests-offline.test.ts` › "AC3: every test file that draws a site paste launches Chrome only through launchOffline".
- AC4 (proposed): Given the base and the head, every touched test file gives the same result per test name (pass, fail, skip) on its normal inputs with no `F2B_*` variable set, `npm run check` passes, and `git diff --name-only 392f67e2` names no file under `src/` or `tools/`. A test that passed on the base and fails offline is not papered over: it is reported with the outside host it asked for. Test: `node test/web/offline/tally.ts --compare <base.json> <head.json>` prints "AC4: every touched test gives the same result as on the base" and exits 0.

## Tasks (one commit each; the guard is red from Task 2 until Task 4, on purpose)

1. **Before any edit.** `npm run check` and `npm run corpus` on the base; record the tallies in the ledger.
2. **The helper and its test** (the AC1 test). The test serves a log on `127.0.0.1:0`, builds one page naming
   `http://live.localhost:<port>/pic.png`, a `@font-face` file and a `<script src>` there plus `http://127.0.0.1:<port>/local.png`,
   draws it in `launchOffline()` and in `launchChrome()`, and reads the log's Host headers after 2 s (as `probe.ts`). Red proof: with
   `launchOffline` returning `launchChrome(launch)` the first assertion fails.
3. **The guard** (the AC3 test), red on the tree: its message lists the files to convert. Save that list in the ledger.
4. **Convert the files** the guard names, as "The fix" 2 says, in three commits: the two scan files; the bare fixture files; the
   already-offline files. Guard green after the third. Run each touched file once after its edit.
5. **The scan test** (the AC2 test). It starts a raw TCP log (`net.createServer`, one entry per connection: the HTTP Host line, or
   `tls` for a first byte 0x16), writes a wrapper script in a temp folder (`exec "<real CHROME_PATH>" "--host-resolver-rules=MAP *
   127.0.0.1:<port> , EXCLUDE localhost , EXCLUDE 127.0.0.1" "$@"`), and runs `node --test <tree>/test/web/<file>` for each of the two
   files with async `spawn`, `CHROME_PATH` the wrapper and only that file's scan variable; `<tree>` is `F2B_OFFLINE_TREE` or this repo.
   Head: the log is empty. Old-code check: the same test with `F2B_OFFLINE_TREE=<git archive of 392f67e2, node_modules linked>` fails
   with the logged hosts. **Never run either scan file on the base without the wrapper.** The orchestrator's brief names the two scan
   files' paths on this desktop.
6. **The tally** (`test/web/offline/tally.ts <tree> <out.json>`; `--compare a b`): each file the guard converted, run alone with
   `node --test --test-concurrency=1 --test-reporter=tap`, every `F2B_*` variable removed, 20 min a file, under
   `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`; a difference is rerun alone on both trees once before it counts.
   Then `npm run check` and `npm run corpus`.
7. **Docs & records:** one HANDOFF line (what changed, the guard's name, the one kept exception, Q1 and Q2 not yet confirmed, the
   Google update-host follow-up); the builder reports for `figma-to-bricks/references/testing-pitfalls.md` line 26 that the rule is
   now `launchOffline` and `test/unit/site-tests-offline.test.ts` enforces it (in `skill_lessons`; the main session saves it); the
   finisher adds one standing-rule line to CLAUDE.md ("a test that draws a site paste launches Chrome through `launchOffline`").

## Touched files

New: `test/web/lib/offline-chrome.ts`, `test/web/offline-chrome.test.ts`, `test/web/site-tests-offline-scan.test.ts`,
`test/unit/site-tests-offline.test.ts`, `test/web/offline/tally.ts`. Changed: the files the guard names (about 63, listed above),
`docs/HANDOFF.md`, the ledger. Nothing under `src/`, `tools/`, `reference/` or `corpus/`. No `BUILD` change is needed for the code
(nothing Figma or a command loads changes); the finisher follows the project's finish steps.

## Risks and stop conditions

- A fixture test that needs an outside host fails offline: stop on that file, report the host; never re-open it.
- A drawing file launches with options (`{ sockets: true }`, `visible`): they pass through `launchOffline` unchanged.
- A test that already maps a name (`MAP www.x.test 127.0.0.1` ahead of the offline rule) gives it in `maps`.
- A run that dies with SIGTERM, 137 or 143: check earlyoom before reading it as a result.

## Report

The builder stops at `ready-for-review` with: the guard's converted-file list, the base and head tallies, the AC1–AC4 runs (a
terminal capture each), and `skill_lessons`.
