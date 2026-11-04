# element-link — Fixer 1 (after the rebase onto main fb143824)

**Role:** fixer. Load `receiving-code-review`, `engineering-best-practices`, `test-driven-development`.

**Copy:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a7f58956799bac1e2`, branch `worktree-agent-a7f58956799bac1e2`, HEAD `f713ab946e1f07048ee2bab09905b223f9b8c767` (element-link rebased with no conflicts onto local `main` `fb143824`, "Build 2026-11-04.4: general structure recognition"). Don't rebase again, don't fetch/push, don't bump BUILD, don't edit the main folder or CLAUDE.md, never bare `git stash`, never stage CLAUDE.md; plain `git commit -m`, no author override, no Co-Authored-By.

**The problem:** `npm run check` fails on the rebased head, passing on main: `test/unit/recognition-footer-safety.test.ts:177` "recognition-footer-safety: contact values retain contact links and structural negatives retain fallback". At line 184 it expects a footer entry that is only a phone number or only an email to have no element Link to (`settingsOf(entry).link === undefined`, link as `<a href>` inside the text). element-link's approved rule (plan `~/.hermes/plans/figma-to-bricks/evidence/element-link/plan-approved.md`, AC1/AC2; the designer's request, approved by Justin) is that such a text carries `{type:'external', url:'tel:…'|'mailto:…'}` in Link to and no `<a` in its words.

**Do:**
1. Read the test and main's structure-recognition code it guards; confirm what the test's intent is (the contact link is kept, no page link is made from the value, no nested links, snapshot unchanged). Confirm the failure is only the link's *form*, not a lost link or a new page link. If you find the new rule actually breaks the footer safety intent (a link lost, nested, or a page link invented), stop and report that instead of editing.
2. Update only that assertion to element-link's form: for the phone and email entries, Link to is `{type:'external', url:<contact>}` and the words hold no `<a`; keep every other check. Make sure the updated test fails on main's code path if Link to were missing (prove it: temporarily revert the element-link emit for texts in a scratch copy, see it fail, restore).
3. Also check main's new structure-recognition code for any other spot that reads a text's inline run link where element-link moved it to `textLink`/`elementLink(ir)` (e.g. code that decides "this footer entry is a contact link" by its runs): it must still see the link. Add a test if you find one, fix test-first.
4. Run `npm run check` (all green) and `npm run corpus` on the copy's head vs main, using the finisher's ready scratch setup: `/home/justin/.cache/el-fin/run.sh <tree> <logname> corpus` (trees `/home/justin/.cache/el-fin/head` — re-create it from your new HEAD with `git -C <copy> archive HEAD | tar -x -C …` after re-pointing `corpus.json` as the finisher did — and `/home/justin/.cache/el-fin/base` = main). Corpus must equal main's except the intended phone/email Link to changes.
5. Commit with a clear message; stop `ready-for-next-review`.

**Memory rule:** big runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first.

**Return:** status, new HEAD SHA, what you changed and why, the proof the test can fail, check/corpus results vs main, anything found in step 3, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
