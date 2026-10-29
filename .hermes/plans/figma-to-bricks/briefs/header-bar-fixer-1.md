# Brief: FIXER 1 for figma-to-bricks feature "header-bar" (Full pipeline)

You are a fresh fixer. Act on reviewer 1's findings: verify each one first, fix the valid ones test-first, and push
back with evidence on any that are wrong. Don't re-plan and don't widen the job.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar` (branch `worktree-header-bar`, head
  `eb23695`, base `main` = `dea6296`). Work only there; never edit the main folder or another worktree.
- Reviewer 1's report: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/reviewer-1/review.json` (read it whole),
  with its probes and logs beside it (`probe-variants-{base,head}.log`, `probe-hydraulics-header-tree.log`,
  `probe-page1-header-tree.log`, `probe-left-menu-{base,head}.log`, `probe-r3.log`, `mutation-report.txt`,
  `ink-1024.log`). Reuse its probe fixtures rather than retyping them.
- Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/header-bar/plan-approved.md`. The builder's
  receipts: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/builder/`. Ledger:
  `.superpowers/sdd/2026-10-29-header-bar/progress.md`. The B-Dry paste: `~/.hermes/plans/figma-to-bricks/evidence/
  bdry-paste/header-v1/`.
- Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/fixer-1/`.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (FIXER/BUILDER role) and its
   `references/rules-summary.md`; only the worktree `CLAUDE.md` sections you need (grep + offset/limit).
2. `engineering-best-practices`, 3. `receiving-code-review`, 4. `test-driven-development`,
5. `mutation-testing-discipline` (each guard you add or keep must have a test that fails without it),
6. `systematic-debugging` whenever a test fails unexpectedly, 7. `git-commit-rules`.

## The findings (reviewer 1, verdict request-changes)
- **F1 (high), `site-header.ts` `logoBar` / `logoThenActions` / `action`:** widened recognition takes non-header bars
  as the header: P1 a title band "Our Services" + "View all" link (lost when ticked; its title links `/` unticked); P2
  a top strip with a phone icon and a phone line above a real logo+menu bar (only the strip left out → two headers;
  the strip's icon links `/`); P3 a call band with a phone picture, a phone line and a button (left out when ticked).
  Reviewer's suggestion: a drawn logo can't be icon-sized in the new path; the typed-logo path's closing icon can't sit
  inside a menu item or a linked box; a later top bar that is itself a logo bar joins the header run and is the bar
  whose logo links home. Add P1–P3 as negatives (and the run-joining case as a positive) before the fix.
- **F2 (medium), `site-header.ts:189` `headerMenuIcon`:** names the rightmost small layer even inside a linked button
  and even when it isn't a menu icon. On Justin's real files (hydraulics, page-1, Services, ticks off or footer only)
  the AC6 note names "Component 1", the arrow inside the linked "Schedule Now" button. Also P4 search icon, P5 arrow in
  a linked "Book now" button, a cart icon. Fix: stop `rightmost()` at a layer with a link or click, a button
  (`ctaLike`) or a menu item; require no link or click from the row down to the icon. **AC6 is not accepted until this
  is fixed**, and the receipts must pin each added note's quoted label per file (expected: no false note on those
  three files), never accept any "opens nothing" note.
- **F3 (medium), `site-header.ts:182` `headerLogo`:** takes the bar's first layer as the logo whatever it is (a ☰ at
  the left links `/`; P2/P3 link a phone icon). Fix: pick the real logo (a drawn picture or typed words, not an
  icon-sized layer when a bigger picture follows), or give no home link when the first layer is icon-sized.
- **F4 (low):** guards with no failing test: R3 the "linked word" guard in `header-bar.ts` `clicks()` (a typed logo
  `Bright<a>way</a>` silently becomes plain text linked to `/`), R1 a linked group counts as an action, R2 the
  group-depth limit, R7 a contact line is one line, R9 the note once per design across two bars. Add a test for each
  that fails with the guard removed (record the mutation receipts). R5 and R8 change nothing on screen: say so.
- **F5 (low), B-Dry paste 768–1024px:** the phone line sits at the left beside the logo; bdryswi.com centres the words
  (real ink 372–589 at 1024, ours 234–407). Fix the paste's tablet rule so the words are centred as on bdryswi.com,
  and make AC9 measure the words' ink (text rects), not the element's box, at every width it checks. Rebuild the paste
  through its own scripts and give its new sha256.

## Held for Justin (don't change it unless the main session sends his answer)
The builder's ruling that a design wider than 1440 has its header span the window from 1441px up touches his
confirmed decision "Designs wider than 1440 keep the 1440 Container". Justin has been asked. Keep today's behaviour.
If the main session sends his answer before you finish, apply it as its own last commit, test-first.

## Out of scope (list, don't fix)
Reviewer 1's "other problems" exist on base too: a strip of a lone small icon plus short texts becomes the header's
bar on base (P2b); `iconOnly()` treats any one-line text 64px or narrower as an icon. Fix P2b only as far as F1's own
fix covers it, and say how far; leave `iconOnly()` alone (found_else).

## Done means
Every valid finding fixed test-first (a failing test committed or shown before each change), each guard's test proven
to fail without it, `npm run check` green, the browser tests for this job green with `skipped 0`, the full browser
suite compared by test name with base `dea6296` (no new failures), the AC7/AC8 receipts re-run (byte-identity list
unchanged, notes pinned per file), the B-Dry paste tests green, ledger and HANDOFF updated, committed. Stop with
`status: ready-for-review` (a second fresh reviewer comes next): no merge, no BUILD.

## This machine and the guard
Linux/WSL. Chrome: your own wrapper in your scratch containing `exec /home/justin/.cache/chrome-for-testing/chrome-f2b
--disable-software-rasterizer "$@"` as `CHROME_PATH`, `/home/justin/.local/node-v22.23.3/bin` first on PATH, the same
profile for base and head. `npm run corpus` measures nothing here; corpus-backed unit tests need scratch `git archive`
trees with `corpus.json` re-pointed (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/
corpus-paths-on-desktop.md`). The worktree guard refuses Bash it can't prove stays in the worktree (shell variables or
loops around `node`/`git`/`sed`, heredoc then node, `git -C`, the word git inside a grep pattern or a script's text,
the word `source` anywhere, even in a path): write scripts with Write and run `node <absolute script> <absolute args>`,
one plain command per call. Another job (`after-faq-sections`) is building in its own worktree: leave it alone.

## Rules
- Commit after each passing fix: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines; check
  `git diff --cached --name-only` (never CLAUDE.md). Don't push, don't bump BUILD, don't edit the worktree's CLAUDE.md,
  never bare `git stash`. Files under about 300 lines.
- You can't ask Justin anything. A real trade-off becomes "My ruling, not yet confirmed" in `rulings[]` and the ledger.
- Other bugs: `found_else` (one line each, evidence, severity); don't fix them.
- Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check
  that would have caught a broken rule: its kind, what it checks, where it runs). An empty list is normal. Never edit
  skills or memory.
- Don't start other agents.

## Return (your final message)
`{name, status: ready-for-review|stopped, findings[{id, verdict: fixed|rejected|partly, commit, test, evidence}],
rulings[], ac_status[{ac, accepted, test, evidence}], paste_sha256, last_commit, shots[], found_else[],
skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
