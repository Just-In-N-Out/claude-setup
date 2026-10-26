---
name: corpus-paths-on-desktop
description: "On the Linux/WSL desktop, corpus/corpus.json's Mac paths make npm run corpus find no files; v1's three files aren't on this machine"
metadata:
  node_type: memory
  type: project
  originSessionId: 41446e56-3547-4d3a-8588-7488cbdf535c
  modified: 2026-10-26T17:27:53.302Z
---

`corpus/corpus.json` lists absolute Mac paths (`/Users/justin/...`). `tools/lib/corpus-files.ts` checks them with `existsSync`, so on the Windows desktop (Ubuntu, `/home/justin`) every corpus file reads as missing and `npm run corpus` measures nothing (checked 2026-10-26). In the repo: `corpus/files/hydraulics-home.json` and `gro-home.json`. Not on this machine: v1's design, final-design and page-1 (`~/Desktop/figmaplugin` doesn't exist).

Browser gates too: `test/browser/chrome.ts` defaults `CHROME_PATH` to the macOS Chrome app, there is no Linux Chrome, and `libnss3`/`libasound2` are missing (`ldconfig -p`); `sudo -n` is refused, but `apt-get download` resolves the libs (label-floor planner, 2026-10-26). The only Chrome is Windows' `chrome.exe` under `/mnt/c`. Without Chrome every `test/browser` test is `{ skip }`ped (`hasChrome()`), yet `npm run test:browser` exits 0: a browser gate counts only when its output says `skipped 0` (faq-answer-space planner, 2026-10-26).

**Why:** a corpus run that "passes" here may have compared nothing.
**How to apply:** tell every builder, reviewer and verifier on this machine to measure the two repo corpus files directly (replay/snap), and not to count `npm run corpus` as a check until the paths resolve on both machines. Before promising browser proof here, check `CHROME_PATH`; plan a no-sudo Chrome for Testing step or send the browser gates to the Mac. Related: [[git-and-parallel-agents]].
