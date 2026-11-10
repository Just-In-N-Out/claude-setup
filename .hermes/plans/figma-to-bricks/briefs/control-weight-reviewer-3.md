# Role: reviewer (round 3, a short delta: fix pass 2; report only): control-weight

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees. Never load any live site; no
logins; never write to any WordPress site; never run `npm run site:upload` against anything.

**Importer rule (Justin, 2026-11-02):** P0–P2 only for a bug a real site or normal use hits, with a concrete real-use
scenario; edge cases are P3. This is the job's third review round (the project's cap): be exact about what is a real
bug in the delta and what is a recorded limit.

## What to review
The job (on the website importer's code route, an element its parent reads as an inline word at some widths carries
those widths in its own class, at every depth the reading nests, so Bricks' class controls can't out-weigh the
parent's rule) was reviewed at `271e7815fe06935387bacd208ee8577ef0f0068e` on `main`
`56a9379faf207c2bfa76211dff1365db7d74be37`. Review 2 found R2-1 (P2): an earlier fixer had removed two reads as "dead"
(`out.decls.get(x.path) ?? x.node.decls`; `words[rest]`), so when two moves overlap (a link that is a word of its
wrapper's line on tablets and a block reading its own icon and label inline on phones) the first move was lost and
the label showed its desktop size on small tablets, where main draws it right. Justin chose "Fix it"
(`evidence/control-weight/review-2/justin.json`).

**Fix pass 2** (yours to review): branch `control-weight-fix2`, head `8ec7d0ee9290ee68bce0115a9498fc86283b6f7d`, three
commits on `271e7815`: `54b0d85e` (the two reads restored in `src/core/site/inline-own.ts`, each with a comment; unit
variants `overlap`, `overlap-deeper`, `overlap-words`; a new fixture site `inline-overlap` and a second test in
`test/web/site-inline-nested.test.ts`; the cited tests of AC2 and AC3 extended, under unchanged names, with the nested
cases), `20376b52` (two stale test comments), `8ec7d0ee` (docs). **Your scope: `git diff 271e7815..HEAD` and what it
touches.**

In your own worktree: `git checkout --detach 8ec7d0ee9290ee68bce0115a9498fc86283b6f7d`, confirm HEAD and a clean
status. The fixer's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/fixer-2/`
(`red-*.log`, `green-*.log`, `mut-grade.txt`, `mut/`, `probes/probes.log`). Review 2's probes:
`~/.cache/control-weight-review2/` (`sites/cw2-overlap`, `cw2-shapes`, `cw2-ranges`, `cw2-match`); review 1's:
`~/.cache/cw-r1/`. Recorded limits (not findings unless you rate one higher, with a scenario):
`evidence/control-weight/follow-ups.md` and HANDOFF's "Known limits" in the job's section (R2-2: a link holding two
labels, the first hidden on tablets; R1-3: words beside the element; a tablet-only child passing the count check; the
lifted-child condition untested until site-native-structure's `lift` is on main; mutants M3 and N5).

## Check (do each yourself)
1. **R2-1 is closed.** Re-run review 2's overlap probe on head against the site (both Bricks samples, rich and basic
   text; 390, 479, 600, 767, 768, 769, 880, 991, 992, 1200): 0 differences where the rule applies. Then two shapes of
   your own beside it: the link is a block on phones **and** a different inline word of another wrapper at a third
   range; a label read by the wrapper on tablets, by the link on phones, and shown as its own element on desktops
   with a hover look. Each: every element's display, font size, padding and colour against the site's; nothing worse
   than main anywhere.
2. **The restored reads are right as written:** `take(out.decls.get(x.path) ?? x.node.decls, …)` and
   `take(words[rest], …)`: can the map's current entry ever be stale or belong to another element (two elements with
   one path; a path reused across parts; the loop visiting a child before its wrapper)? The fixer's claim "the two
   moves never write the same range, so loop order doesn't matter": true? Try the reverse loop order in a scratch
   copy on the overlap fixtures.
3. **The cited tests' new clauses** (`test/unit/site-inline-own.test.ts`: AC2's and AC3's cited tests, names byte for
   byte unchanged against `271e7815`): each clause the fixer lists is asserted; no assertion narrowed (`git diff
   271e7815..HEAD -- test/`); two mutants of your own under the 4 GB cap (one per restored read's neighbour: the
   wrapper's key not dropped after a nested move; a moved element's phones reading written at the tablets range),
   each killed by a cited test's own assertion.
4. **Nothing else moved against review 2's head:** your own byte comparison, `271e7815`'s converter beside head's, on
   ten fixture captures and B-Dry's stand-in
   (`~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/inputs/standin-capture-0581852c.json`, 8G scope):
   identical except captures holding the overlapping shape; review 1's and review 2's other probes (`cw-nested`,
   `cw-leak`, `cw-text`, `cw2-ranges`: 0 differences; `cw-words`, `cw2-shapes`, `cw2-match`: line for line as on
   `271e7815`).
5. The two comment-only edits are comment-only and true (`test/web/site-range-cancels.test.ts` header;
   `test/web/lib/site-page-check.ts` header: `checkPage` draws with `NEWEST_BRICKS`). HANDOFF's lines "and so does
   each element inside it" and "at every depth" are true for what you measured; R2-2 is recorded.
6. `npm run check` on head (the parallel unit suite may need an 8G scope); both typechecks (the sandbox config too);
   the job's web files (`site-inline-nested`, `site-range-cancels`), each alone under the cap.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` ("Code-route paste traps"). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight/review-3/review.json` (round 3, a delta from
`271e7815`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo
<your worktree> --base 56a9379faf207c2bfa76211dff1365db7d74be37
/home/justin/.hermes/plans/figma-to-bricks/evidence/control-weight` (exit 2 means your file is wrong: fix it). Say
whether R2-1 is closed.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cw-r3/t1`, a
separate one per script started at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (one
Chrome job at a time, closed after: stop it by the PIDs of its own profile path; never `pkill -f <pattern>`); a
worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own call, then untar; never
chain a git command after a `cd` into a scratch folder: `git -C <absolute path>`). Scripts written with Write under
`~/.cache/control-weight-review3/`. Heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`
(B-Dry 8G; export variables first, no `--setenv=PATH`). SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC lost power twice this week: keep notes and
finished probe results on disk; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario) or "none", R2-1 closed or not, `verdict`,
`ac_status` (per AC: what the review saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
