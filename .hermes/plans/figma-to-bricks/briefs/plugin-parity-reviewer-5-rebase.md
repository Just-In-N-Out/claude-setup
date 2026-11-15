# Role: reviewer round 5 (full, on the new base; report only): plugin-parity

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command; scripts with
the Write tool, run as `bash <file>`, no heredocs). Never load any live site; never write to any WordPress site; touch nothing under
`~/Downloads`. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first. Don't read the fixer's report as proof. Ask of every paste: "would a Bricks pro find this logical and easy to
change?" (the standard at the top of the repo CLAUDE.md "Decisions the user made"). Keep to about 90 minutes (Justin's deadline is Monday
09:00 on this computer). P0–P2 only for what a real paste or normal use hits, with a scenario and a measured result.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md` (AC1–AC18; AC18 live).
- Head **`033e870b4ae9483ce14df10360a5e1d5b7e52caf`** (branch `plugin-parity-fix3`) on main **`e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`**:
  accepted head `2fe8bb52` (review 4 clean on base `fe29b65d`) moved by fixer 3 with **source conflicts** (`src/core/convert.ts`,
  `tools/replay.ts`, HANDOFF, `test/fixtures/later-jobs.ts`; `evidence/plugin-parity/fixer-3/conflicts.txt`) plus an AC14 pin update
  (`b19b9fb3`). One ConvertResult hunk was resolved by a script: check it by hand.
- **Focus hardest on the join with main's shared-palette** (site colours, `siteColours`/`siteColoursUsed`, palette links, `writePalette`):
  probe the merge with `git merge-tree --write-tree --merge-base=fe29b65d e2fc35aa 2fe8bb52` against the moved head; does a colour this job
  moves onto a look class still link the site's palette variable; does replay write both jobs' files; does the plugin's conversion stay byte
  equal to replay. Then the job as a whole (`git diff e2fc35aa...033e870b`).
- **Known open, not yours to judge:** the Theme Style finding (Buttons on a shared look lose to a site's Theme Style;
  `fixer-3/cause.txt`, `fixer-3/notes.txt`) waits on Justin's decision; a fix will follow as its own commits. Don't re-file it.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-5/review.json` (round 5, scope full, `from`
`e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`, full SHA `head`), in review-4's format; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e2fc35aaa6b7e3a662d0c3cce37ec636495a5405 /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity` and quote its last line.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppr5/t1`); scripts under `~/.cache/ppr5/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f`/`pgrep -f` with a
pattern in your own command line); before each Chrome suite check `/proc/loadavg`; `test/browser` needs the network on (Splide, Google Fonts);
memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`. An archive tree has no `node_modules/.bin` (a `tsc` wrapper
first on PATH) and no repo (set `GIT_DIR`, `F2B_SERVICES_FILE`). Foreground Bash moves to the background after about 180 s: wait in bounded
steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
