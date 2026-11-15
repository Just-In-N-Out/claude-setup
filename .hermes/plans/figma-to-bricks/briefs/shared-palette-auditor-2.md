# Role: blind AC auditor (read-only, on the rebased head; runs alongside the verifier): shared-palette

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read any verifier's or earlier auditor's report or folder** (`evidence/shared-palette/verifier*/`, `auditor*/` other than your own), nor
`builder/`, `fixer-*/`, `planner*/`, `review-*/`, `rebase/`, nor anyone's reports, as proof. A verifier is working on the same head at the same
time: don't touch its worktree or processes. Change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each
command alone (never `git -C` the main folder; no git piped into another command). Never load any live site; run any test that captures the
B-Dry stand-in or draws Justin's scan only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy &&
ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user --map-user=1000
--map-group=1000 <cmd>'`, inside the memory scope); never write to any WordPress site; never call alttext.ai; touch nothing under `~/Downloads`
(Justin's scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`).

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/rendering-validation.md`, `references/testing-pitfalls.md` (CHROME_PATH, the pin gates `F2B_STORY_PINS=1` / `F2B_PIN_BASE=1`,
the no-network rules). Read both `repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11, amended twice; AC11 live: `not_run`). The job (both tools): one colour is one palette colour on a Bricks site — one id and one `--color-<hex>` variable across pages and tools; the site's own palette exports (`--colours a.json,b.json`, the panel's "Colours already on the site") are reused so each palette file holds only colours the site lacks (new ones to `palette-2.json`, a `--colours` file never overwritten); bad files stop with one line; no site colours = main byte for byte. Read the plan's "Rulings of the fix rounds [amended 2]" section.
  Named-only tests run by name with the plan's variables. The head may print test names with an `ACn ` prefix the plan's names lack: use
  `ac-verification.md`'s by-name checker; write each `ac.json` command so it parses in bash (double quotes, `\$`) with its env on the command.
- Head **`00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`** (branch `shared-palette-final`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`** (Build 2026-11-14.4). In your
  own worktree: `git checkout --detach 00aff255…`, clean status. Old code: a `git archive` of fe29b65d (extract separately) with head's
  test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head). In an archive tree put a `tsc`
  wrapper first on PATH and set `GIT_DIR` (and `F2B_SERVICES_FILE` for tests reading `git show 2199895:…`).
- Known on main itself, not this job: `icon-elements` renderer@600/390 "11 icons shown"; `site-motion-bdry`'s Elementor hover-look test;
  `site-media-unchanged`'s 308 misses; `site-live` 3 of 6; `site-upload-icons` needs the network (AVIF encoder; run it with network, local
  fixtures only).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code (fail on its own assertion), plus one check of your own per AC beyond
the cited test — e.g. a palette export of your own (two palettes, an hsl colour, a see-through one, a hand-named colour, a raw with a fallback) given to `npm run site`, `site:upload --dry-run` against `test/fixtures/wp-standin.ts`, `replay` and the panel: links, the written file, the notes; the same command three times with the `--colours` file in the out folder; the panel with Icons as SVG still makes main's Icons; without `--colours` the importer's palette.json, styles.txt and next-steps text byte for byte main's. A picture per AC (a terminal capture where nothing is visual). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/auditor-2/ac.json` and logs there (create it; check it is empty); self-check
with `ac-check.sh` on a copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`). Put every receipt wrapper in a script file written
with the Write tool and run it with `bash <file>`. Also say where a Bricks pro would not find the paste logical (the standard at the top of the
repo CLAUDE.md "Decisions the user made").

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spa2/t1`); scripts under
`~/.cache/spa2/s/`; **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close
every Chrome you start by PID (a `user-data-dir=` pattern ends in `/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line);
before each Chrome suite check `/proc/loadavg` (above ~40: unit work first); one Chrome suite at a time, each under `systemd-run --user --scope
-p MemoryMax=4G -p MemorySwapMax=0 …` (B-Dry files 8G) outside the namespace. Use `tail -n 3`. Foreground Bash moves to the background after
about 180 s: long runs with `setsid --fork`, waiting on `^EXIT=` in bounded steps of 160 s or less. SIGTERM/143/137/"Killed" may be earlyoom:
check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
