# Role: reviewer (round 4, review of the REBASE RESOLUTION onto main + the gate fix; report only): importer-parity

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE`); run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network:
`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add
unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'` (the dummy interface stops Chrome reading itself as
offline); never write to any WordPress site; touch nothing under `~/Downloads` (his scan copy:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`). **Importer rule:** P0–P2 only for
bugs a real paste or normal use hits (a scenario and a measured number); edge cases are P3. Keep it to about 45 minutes. Load
`requesting-code-review` and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly) with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first. Keep the standard at the top of the repo
CLAUDE.md "Decisions the user made" in mind ("would a Bricks pro find this logical and easy to change?").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Reviewed head `745578889c56baf81a58110770a5513b6c67c7d4` (review 3 MOVE ON) on base `7b7501bd082ae44a99985aac4d080c9b70b67c53` (a
  pre-rebase site-shared-styles commit). Rebased with `git rebase --onto fe29b65d 7b7501bd` onto main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`
  (Build 2026-11-14.4: shared classes and palette, bricks-icons-site's Icons, importer-app) as branch `importer-parity-final`, head
  **`a049bb4baa7329b8184cb3777e3ffabf47e1252a`**: the 31 rebased commits end at `7c221b3d`, then test-only commits: `cba7a8b3` (one shared-class
  list `test/unit/lib/site-shared-classes.ts` `SHARED_CLASSES` read by `class-names.ts` and `site-parity-invariants.ts`, plus
  `test/unit/site-shared-class-list.test.ts`), pins `db7c0e8f`, `69115703`, `b3230325`, `e2081c72`, `6268b5aa`, `78bd0481`, `a049bb4b`.
- Finisher's records (a head start, not proof): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/rebase/` (`conflicts.txt`,
  `range-diff.txt`, `gates.txt`, `receipt-a049bb4.log`, `drawn/moves.txt`, `drawn/compare.txt`, `pin-mutants/`).
- Known on main itself, not this job: `test/browser/icon-elements.test.ts` renderer@600/390 "11 icons shown"; `site-motion-bdry`'s Elementor
  hover-look test; `site-media-unchanged`'s 308 misses; `site-upload-icons` needs the network (AVIF encoder download).

## Check hardest
1. **The source resolution.** `git merge-tree --write-tree --merge-base=7b7501bd fe29b65d 74557888` against `7c221b3d`: every difference is
   a place both jobs met (eight commits conflicted: 1, 4, 7, 8, 9, 12, 13, 17). Above all where this job's new Bricks settings (Style:
   Primary, class values moved into controls, `_attributes`, the Video/Nav/Form natives, `ClassSource` `more`/hover) meet main's shared-look
   classes and palette: does a shared class still have one writer per property; do its settings keep main's `var(--color-<hex>, …)` palette
   links where they were (a colour moved into a control must still be a palette link, or the palette and `styles.txt` lose it); does an Icon's
   class still write no Bricks control (`class-source.ts` `fromStates`); does `palette.json` hold every colour the paste uses; are the 4-letter
   class-name changes (plain 20, Elementor 336) exactly the classes whose settings changed.
2. **The gate fix and pins:** one list read by both sides, its test fails a name only one side accepts; each pin's allowance exact, the old
   oracle with `parity: false`, on-state goldens made on this tree and not regenerable by a test run.
3. **Combined behaviour on his scan** (offline, both routes): no element moves against main beyond what the plan's ACs explain (the
   finisher's `drawn/moves.txt` says every width's worst element and px equal main's), main's shared-styles AC4 (one writer) and AC7 (draws
   the same switch on vs off) and its icon look test on the new head.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-4/review.json` (round 4; first try scope delta `from`
`745578889c56baf81a58110770a5513b6c67c7d4`, full SHA `head`, a `note` saying it reviews the rebase resolution and gate fix), in review-3's
format; self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
fe29b65d94da2c6f4e1ecb881354b9e9b9842cef /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity` and quote its last line; if it
asks for another scope (e.g. full from fe29b65d), record it that way, say what your full scope rests on, and say so. Your worktree must be at
`a049bb4b` (`git checkout --detach a049bb4baa7329b8184cb3777e3ffabf47e1252a`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipr4/t1`); scripts under `~/.cache/ipr4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line: use a script file); before each Chrome suite check `/proc/loadavg`;
memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …` outside the namespace (B-Dry files 8G). An archive tree has no
`node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`, and `F2B_SERVICES_FILE` for the Services save). Use `tail -n
3`. Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. `cancelled 1` is a
timeout. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`
first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
