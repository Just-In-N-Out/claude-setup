# Role: fixer (round 2: review 2's R2-1, a script tag taken alone as a widget's whole code): site-reviews

You are a fresh fixer for FigmaToBricksV2 (Fable 5.2, high). Fix review 2's one P2 test-first, then stop at
`ready-for-review`. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never
push or merge, don't bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or
any live site (local stand-ins and saved files only; no third-party embed host either: stand-in scripts written from the
public shape of such embed codes); no logins; never write to any WordPress site. Nothing paid. Nothing may hide that the
importer's Chrome is automated.

**Skills to load:** `receiving-code-review` (verify the finding before fixing), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline` (what runs on Justin's site is a guard), `git-commit-rules`.
Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md` (the lines on embeds, snippets and the served
page), the repo `CLAUDE.md` and `reference/bricks/README.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-reviews-fix2 77bd97f5506cbb59c53bebffa58e0bc07dbbc1f5` (the reviewed head, branch
`site-reviews-fix1`), confirm `git rev-parse HEAD` and a clean status (after a machine restart, look for tracked files
of exactly 8388608 bytes and restore them). Base: local `main` `fd1986dcdbc8cf35f114b80be456e94279346743`. Report your
branch; work only in your own copy.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/plan-approved.md` (AC2,
  AC3; Q2 A, Q5 A). Don't change the plan or any AC.
- Review 2: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/review-2/review.json`; its three-tree
  probe `~/.cache/srv-r2/probes/p4-embedcodes.ts`, sites under `~/.cache/srv-r2/sites/`, logs
  `~/.cache/srv-r2/logs/{p4-head.log,p4-r1.log,p4-base.log,check-quote.log,p2-b.log}`.
- Fixer 1's receipts: `evidence/site-reviews/fixer-1/`.

## The finding
**R2-1 (P2, `src/web/read/embeds.ts:144`):** `ownPlace` (fixer 1's R1-3 fix) takes a script tag alone as a widget's
whole code whenever one element that file made sits beside its served tag in a painted or shared box. It never checks
that the tag alone can draw it. An embed code made of a placeholder the script replaces (a post's `<blockquote>` plus
its embed script), or of a library tag plus an inline call (a form's `create()`), is captured as `how: "slot"` with the
bare tag as its slot: the pasted tag runs on the Bricks page and draws nothing, while the note says "pastes live where
it showed" and `site:check` says OK, 0 px. Round 1's head and base copy the element, so it shows; the same embed codes
alone in an unpainted box are right at head. Real use: a client's WordPress page with an Instagram post's embed code in
a Custom HTML block between paragraphs, or a HubSpot form's embed code in a padded Elementor HTML widget: that place is
empty on the Bricks page.

The reviewer's smallest fix: take the own place only when every served element of the box is still in the live box and
the box's served children hold no inline script; otherwise keep the copy.

## Work
1. Verify the finding yourself first (the reviewer's probe, or your own).
2. **Test first (RED on `77bd97f5`):** in `test/web/site-widget-places.test.ts` (or beside it) a fixture site with (a) a
   blockquote-plus-script embed and (b) a library-tag-plus-inline-call embed, each in a painted box between other
   content, asserting the pasted page shows the post and the form where the site did; with controls that must keep
   passing: the same two codes alone in an unpainted box, and round 1's self-replacing loader at its own place (the
   R1-3 case, Trustindex's shape) still pasting live. Stand-in scripts follow the public shape of such embed codes.
3. **Fix as a general rule**, not for these two shapes: a tag is the widget's whole code only where it is proven able to
   draw it alone (what it needs from the served box is still there after it ran, nothing it replaced, no inline call
   beside it); any doubt keeps today's safe output (the copy, or the whole served slot as the plan's Q2 A says). Keep
   the R1-1/R1-2 guards as they are: on the code route nothing but the slot's own served markup or the loader's own
   tag is pasted to run, and no head or tracking snippet rides along. The note must say what really happens (never
   "pastes live" for something pasted as a still copy).
4. Mutate the new guard (each condition removed in turn kills a test); run mutations under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
5. P3s (R2-2 … R2-6) are already in `follow-ups.md`: leave them, but if your rule also closes R2-2 (a head tag after a
   `<noscript><img>` read as body's child) say so with a test; don't widen scope for it.
6. Gates before stopping: both typechecks, `npm run check`, the eight `test/web` files the reviewer ran plus
   `site-live-widget`, `site-check-live-widget` (each exit 0, one Chrome job at a time), older captures without `slot`
   pasting byte for byte as base (AC6's test), `npm run corpus` same as main. Commit after each passing step (plain
   `git commit -m`, no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without
   CLAUDE.md). HANDOFF's site-reviews section updated if the rule's wording changes. Evidence in
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-reviews/fixer-2/` (logs with `HEAD=` first, `EXIT=` last).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/srv-f2/tmp`,
  one per concurrent Chrome job: two runs sharing a TMPDIR close each other's Chrome);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file
  written with Write, paths spelled out; keep scripts and logs under `~/.cache/srv-f2/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); say so, find what grew, rerun under the cap.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.

## Report (as text; don't write report files)
`status: ready-for-review`, branch, last commit (full SHA), R2-1: verified?, the rule, the fix, tests, RED/GREEN paths,
mutations, gates vs the reviewed head, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable
only; empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
