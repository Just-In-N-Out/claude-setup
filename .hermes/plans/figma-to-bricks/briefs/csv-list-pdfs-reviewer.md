# REVIEWER only: csv-list-pdfs

Fresh reviewer. Load skill_view('figma-to-bricks') (REVIEWER) and skill_view('requesting-code-review') (report only, never auto-fix; its security scan matters: file uploads, PDF signature check, WordPress requests, slugs, URLs from CSV cells); say you loaded them.

Worktree ~/Documents/FigmaToBricksV2/.claude/worktrees/csv-list-pdfs, branch worktree-csv-list-pdfs, tip 2625008. Plan ~/.hermes/plans/figma-to-bricks/csv-list-pdfs.md (Justin: go = 1A–6A + "the plugin should find the download button" by itself). Review `git diff $(git merge-base main HEAD)...HEAD`. Main is now 2026-10-21.13.

Builder claims: panel asks for PDFs after the CSV is saved; finds the list's download button by itself (on Justin's Services Page Final: exactly one, "Download Full Inventory (PDF)", node 528:4208, a box with icon + words); row matching by file-name column else closest name; rows without a PDF lose their button; leftovers named; CSV URL column works without WordPress; pickers greyed out without WordPress; uploads as name-pdf.pdf with explicit slug, own cache record (picture repair never moves them); saved in the Figma file; emit unchanged (existing external link, no new Bricks key); nothing saved → paste byte-identical on his file and all 5 corpus files. check 1509 + 6 perf; browser 155/156 (1 known showcase flake). Paste check 3an. Shots/proof ~/.hermes/plans/figma-to-bricks/shots/csv-list-pdfs/.

Judge the builder's 8 rulings (in its ledger/HANDOFF): single button counts as download whatever its words; English words decide among several; no icon-shape detection; last button in a row; file-name column needs >50% of PDFs; URL cell rules; Remove CSV keeps PDFs; re-pick replaces set; picked PDF overrides a typed Figma link. Flag any that break a CLAUDE.md rule (general logic, no keying on his words) or surprise a user.

Check hard: no keying on Justin's words/ids/layer names (the 528:4208 must only appear in proof, not code/tests as logic); PDF signature check real (magic bytes), size/time limits, refused uploads named; slug never equals a page's address; assertPayload still guards (direct PDF URLs allowed, media/attachment links not); figma clientStorage/pluginData size cap (~100 kB) respected for 78+ rows; Cancel during upload stops new uploads and never copies a stale paste (link-upload-fixes .11 rules); main.ts edits wiring only; files under ~300 lines; Bricks keys only from reference samples. Run gates yourself (re-run the flaky showcase test), try mutations.

Change nothing: no commit/merge/push; restore anything; no live-site writes (WordPress via stubs only). Other agents running (layout-floors, text-link-followups, photo-hover-glass reviewer): leave them alone. Other bugs: found_else.

Output: verdict pass/request_changes, findings [{id, severity, introduced, claim, evidence}], found_else. Plain words.
