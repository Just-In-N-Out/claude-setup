---
name: corpus-paths-on-desktop
description: "On the Linux/WSL desktop, corpus/corpus.json's Mac paths make npm run corpus find no files; v1's three files aren't on this machine"
metadata:
  node_type: memory
  type: project
  originSessionId: 41446e56-3547-4d3a-8588-7488cbdf535c
  modified: 2026-10-26T19:09:01.389Z
---

`corpus/corpus.json` lists absolute Mac paths (`/Users/justin/...`). `tools/lib/corpus-files.ts` checks them with `existsSync`, so on the Windows desktop (Ubuntu, `/home/justin`) every corpus file reads as missing and `npm run corpus` measures nothing (checked 2026-10-26). In the repo: `corpus/files/hydraulics-home.json` and `gro-home.json`. Not on this machine: v1's design, final-design and page-1 (`~/Desktop/figmaplugin` doesn't exist).

Browser gates too: `test/browser/chrome.ts` defaults `CHROME_PATH` to the macOS Chrome app, there is no Linux Chrome, and `libnss3`/`libasound2` are missing (`ldconfig -p`); `sudo -n` is refused, but `apt-get download` resolves the libs (label-floor planner, 2026-10-26). The only Chrome is Windows' `chrome.exe` under `/mnt/c`. Without Chrome every `test/browser` test is `{ skip }`ped (`hasChrome()`), yet `npm run test:browser` exits 0: an AC's browser test run alone counts only when its output says `skipped 0`; the full suite always skips `woff.test.ts` (Mac font path) and fails some tests on main too, so compare it by name with main's run. `npm run check` likewise exits 0 while its 55 unit + 5 performance corpus tests skip (`corpus-convert` soundness, plugin = replay): run them for real in scratch `git archive` trees of head and of base, `node_modules` linked, only `corpus/corpus.json` rewritten to the local files (node counts from that tree's `countNodes(loadSnapshot())`), and compare the two runs by test name; `corpus-colors` fails on the Repairs and Services saves in both (they carry colour records) (faq-answer-space verifier, 2026-10-26).

**Why:** a corpus run that "passes" here may have compared nothing.
**How to apply:** tell every builder, reviewer and verifier on this machine to measure the two repo corpus files directly (replay/snap), and not to count `npm run corpus` as a check until the paths resolve on both machines. For browser gates here, pass the proven no-sudo setup (label-floor builder, 2026-10-26): `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (a wrapper that sets `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` and runs Chrome for Testing 156 Stable; libs from `apt-get download libnss3 libnspr4 libasound2t64` + `dpkg -x`). Baseline at main: 349/362, 12 font-environment failures (no Arial/Inter here); compare by test name, not count. The Mac stays the browser gate of record. Related: [[git-and-parallel-agents]].
