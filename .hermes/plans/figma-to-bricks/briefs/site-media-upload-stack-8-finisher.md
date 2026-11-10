# Finisher (step 1, in a copy): stack 8 — move site-media-upload onto the new main

You are a fresh finisher (**Opus 5.5, high**). site-media-upload (`npm run site:upload`: a scanned page's own pictures
go to the user's WordPress media library from the command line) is review-clean on an **old** main: branch
`site-media-upload-fix1`, head `c66ded408ca965502ec0f2f7c3038645cf364532` (28 commits), base
`2879e4968438e7a442594d1021cb024dd85b3976` (Build 2026-11-10.3). One job has merged since with a build commit: local
`main` is now `7eeca437ea100c821bcfb82cdbbe516a023ff097` (Build 2026-11-10.4, staging-fit-renderer). Files both sides
changed: `docs/HANDOFF.md` and `package.json` only.

## The one rule above all others in this job
This job builds the first tool that writes to WordPress. **You never run `site:upload`, or any upload, against a real
site: only the local WordPress stand-in on 127.0.0.1 that the tests start.** You use no login, no Application Password
and no key of any kind, and never ask for, look for, read or print one. Never load bdryswi.com, B-Dry staging or any
live site. Justin's standing rule — "Never write to any WordPress site; GET/read only, and ask me before using any
login." — binds you fully.

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Nothing paid.

**Skills:** `git-commit-rules`, `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into main", the stacking
lines) with `references/testing-pitfalls.md`.

## Your copy (you start in your own worktree)
`git checkout -B site-media-upload-stack8 c66ded408ca965502ec0f2f7c3038645cf364532`, then `git rebase --onto main
2879e4968438e7a442594d1021cb024dd85b3976` (check `git rev-parse main` = `7eeca437…`; **if main moved again** — another
job, footer-icon-list, may merge while you work: it adds `src/core/site/sides.ts` and two lines in
`src/core/site/blocks.ts` — use the newest main and say so).

## Rules
- **A rebase with no conflict gets no new commit at all** (the branch stays a pure rebase; touch no file).
- **A conflict:** keep both sides' meaning. `package.json`: both sides' script keys (main's `site:live`; this job's
  `site:upload`), then count each script key (no duplicate, none lost). HANDOFF: every section stays, this job's
  first, then main's lines exactly as main has them (staging-fit-renderer's section and end-of-run entry now read
  Build 2026-11-10.4 and 3ds); this job's `<site-media-upload id at merge>` / `<at merge>` placeholders stay. Resolve
  the same way in every commit of this job that touches the file. Record each conflict and its resolution in this
  job's ledger (`docs/plans/2026-11-10-site-media-upload-ledger.md`) as the branch's last commit, and say so plainly.
  A conflict outside `docs/` and `package.json` is not expected: if one appears, stop and report it exactly.
- Prove every patch unchanged: `git range-diff 2879e496..c66ded40 main..<new head before any ledger commit>`;
  patch-ids commit by commit (`git show --full-index <c> | git patch-id --stable`); for a context-only conflict the
  `-U0` patch-id of that commit.
- Commits (only if a conflict forces one): plain `git commit -m` (or `-F <file>`), no author override, no AI or
  Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md.

## Where the sides meet (probe on the rebased head; local fixtures and the stand-in only)
- staging-fit-renderer changed the test renderer (class CSS printed as Bricks prints it, Bricks 2.4.2's CSS by
  default) and `test/web/lib/site-check.ts`: re-run this job's AC14 page check
  (`test/web/site-upload-page.test.ts`: the fixture page with uploaded pictures within 2 px at every width, as the
  plain paste) and say whether its numbers moved and why.
- A paste whose pictures are library pictures (`{id, url, …}`, `sourceUrl` set) through `site:check --whole` and
  `site:live`'s drawing (against a local stand-in page only): do the renderer and the picture stand-ins handle an
  Image with an `id` (no crash, the picture drawn at its size)? If something fails and the cure is new logic, **don't
  write it**: stop and report the failing run, the smallest repro and your reading of the cause.

## Gates (on a `git archive` scratch copy of the new head; put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin`
on PATH and symlink the main folder's `node_modules` in)
Both typechecks (`tsconfig.sandbox.json` too) and `npm run check` (the parallel unit suite may need an 8G scope); the
job's unit tests and story pins (`F2B_STORY_PINS=1`: AC4, AC12, AC13 — regenerating a pin is a fixer's job: if one
moved because main changed pastes by design, record the proof and stop on it); `test/web/site-upload-page.test.ts`
alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no
`--setenv=PATH`); `test/unit/plugin-convert.test.ts`; staging-fit-renderer's own tests that touch what this job
touches (`site-live.test.ts` and the read-only unit tests; the `--whole` test), each alone under the cap, compared by
name with `main`. Each log starts `HEAD=` and ends with one line `EXIT=`. Run `gitleaks` (or a grep for token-shaped
values) over your evidence folder. Stop and report if anything fails that isn't a named flake (the code-page fixture's
5.09 px load flake; `capture-entrances` R8-1).

## Evidence
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/stack-8/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md` or "none", `meet/`, `logs/`), scripts under `~/.cache/smu-s8/` (written with Write; one `bash <file>`
per Bash call). The tool's record file belongs under a scratch `HOME` in any run, never the real
`~/.config/figma-to-bricks/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-s8/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (stop it by the PIDs of
its own profile path; never `pkill -f <pattern>`). SIGTERM / 143 / 137 or "Killed" may be earlyoom (`journalctl -u
earlyoom --since "-30 min" -o short-iso | grep sending`). Waits under 115 s. The PC lost power twice this week: write
each log's `EXIT=` line; when resumed, check `git status` and `git cat-file -t HEAD` (a commit made in the last seconds
can leave empty objects: point the branch back to the last good commit, make the content differ, commit again), and
read your finished logs first.

## Report (as text)
Branch, the new HEAD (full SHA), its base (full SHA), "a pure rebase: every patch-id equal" or the conflicts and
resolutions commit by commit with the ledger commit; where the sides meet: what you probed and saw; each gate's
result; a line confirming no upload ran against anything but the 127.0.0.1 stand-in and no real login was used; then
`found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit
skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
