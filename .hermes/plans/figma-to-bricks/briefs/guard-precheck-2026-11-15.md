# Role: read-only checker (**Opus 5.5, high**): main's test guards over waiting heads

Change no source or test, commit nothing, start no agents. Follow the machine and safety rules in /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md (ignore its review.json part). About 30 minutes. TMPDIR ~/.cache/gpc/t1.

**Why:** main `9942df18bf3b4fb986d19d8baa266be559a836a8` gained the site-tests-offline guard (`test/unit/site-tests-offline.test.ts`: every test that draws a site capture or paste, captures or fetches must use `launchOffline` / `offlineFetch` / pass a browser and fetcher). Each head below was built on an older base, so after its rebase onto main the guard may refuse its new or changed test files and make the rebase impure.

**Do:** for each head, make a `git archive` tree of the head, put main's guard file (`git show 9942df18:test/unit/site-tests-offline.test.ts`, plus any test helper it imports that the head lacks, e.g. `test/web/lib/offline-chrome.ts`) into it, and run only that guard test there (node `--test`, no Chrome needed). Report per head the offending files and lines it lists, or "none". Don't fix anything.

Heads (full SHA, job):
- cbbf3ebf87db58456fb5890cda3026380d9db756 plugin-parity
- 34e02b9062596891d33377e2eb829c1ffebee046 importer-parity (its fixer 5 is moving it onto main now; report anyway)
- 4348d16e6d8b6794bb2a19ed5a4c131b3b092653 forms-wpforms
- e37e4c06239e382454a68f594ef9593c7da7f032 site-headline-marker
- 09e3c128ad0ee306d71012acd71f64e799330019 page-faq-slide
- dc480103d3c5e082b4cbb83b412ae90a8eca8625 look-grouping
- 61caa59f7888c22a6cee946cd65e3e63604c3bff fewer-kept-boxes
- f8807e60b6b01355da712653962375459151f3b5 native-widgets
- ba96204b932e13c9e4d7c392e5ce43269b5a4bb1 site-sticky-cards

Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/guard-precheck-2026-11-15/report.txt` (one block per head: offenders with file:line and the guard's message, or none) and the logs beside it.

Report (as text): the per-head result; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
