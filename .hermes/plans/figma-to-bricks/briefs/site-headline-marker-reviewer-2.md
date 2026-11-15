# Role: reviewer round 2 (the move onto importer-parity's newest head; report only): site-headline-marker
Fresh reviewer, **Opus 5.5, high**, about 45 minutes; importer job: this round checks the move only. First read and follow /home/justin/.hermes/plans/figma-to-bricks/briefs/_reviewer-common-2026-11-15.md. TMPDIR ~/.cache/shr2/t1.
- Plan (read-only): /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/plan-approved.md (AC1–AC14; AC14 live). Review 1 clean on 75392d9d7cf8e350fdef3b6d805b25ff96916dc4 (base a049bb4b).
- Fixer 1 moved it onto importer-parity **34e02b9062596891d33377e2eb829c1ffebee046** (on main e2fc35aa): head **e37e4c06239e382454a68f594ef9593c7da7f032**
  (branch `site-headline-marker-fix1`); 3 keep-both conflicts in one commit (/home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/fixer-1/conflicts.txt), then 4 test-only commits (AC8 case with
  site colours, fix 4's by-id count through the headline's folds, AC11/AC12 pins re-recorded on 34e02b90, merged jobs' src pins allow its files).
- Scope: `git range-diff a049bb4b..75392d9d 34e02b90..e37e4c06` (what changed in each moved commit), the conflict resolutions (keep both:
  `siteColours`/`paletteFile`/`parity`/`marker`; `markers` beside `byId`; `pageInk` with `site`), the re-recorded pins moved only by fix 4
  (48 of 736, notes only), and the marker colour linking the site's own palette variable with `--colours`. Run media-avif-untouched and
  site-import-figma-unchanged one file at a time (both rebuild dist/).
- Write /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/review-2/review.json (round 2, scope full, from 34e02b9062596891d33377e2eb829c1ffebee046, full SHA head); self-check with --base 34e02b9062596891d33377e2eb829c1ffebee046 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-headline-marker.
