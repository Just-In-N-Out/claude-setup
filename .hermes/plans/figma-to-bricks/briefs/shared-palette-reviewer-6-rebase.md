# Role: reviewer (round 6, review of the REBASE RESOLUTION onto main; report only): shared-palette

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site
capture or paste with `SITE_OFFLINE`); run any test that captures the B-Dry stand-in or draws Justin's scan only with no outside network:
`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add
unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`; never write to any WordPress site; touch nothing under
`~/Downloads`. P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases are P3. Keep it to about 40
minutes. Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first. Keep the standard at the top of the repo CLAUDE.md "Decisions the user made" in mind.

## Inputs
- Approved plan (read-only, amended twice): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/plan-approved.md` (AC1–AC11;
  AC11 live). One colour is one palette colour on a Bricks site, from both tools; `--colours` site colours on the importer.
- Accepted head `f47a20d7814916a54617c2d048baf003f87b4991` (ac-check READY FOR THE USER 10/11) on base
  `7b7501bd082ae44a99985aac4d080c9b70b67c53` (pre-rebase site-shared-styles). Rebased with `git rebase --onto fe29b65d 7b7501bd` onto main
  `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef` (Build 2026-11-14.4) as branch `shared-palette-final`, head
  **`00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`**: 29 rebased commits (8 conflicted: range-diff `!` at 5, 6, 7, 8, 10, 17, 21, 22) plus test-only
  pin commits `d9a56e83`, `37f9c66a`, `7916ea57`, `1c01f0db`, `00aff255`.
- Finisher's records (a head start, not proof): `/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/rebase/` (`conflicts.txt`,
  `range-diff.txt`, `receipt-00aff25.log`, `pins/`, `compare/`).
- Known on main itself: `site-media-unchanged`'s 308 misses; `media-avif-as-served`'s 31 lines; `icon-elements` renderer@600/390 can show
  "11 icons shown"; `site-upload-icons` needs the network.

## Check hardest
1. **The source resolution:** `git merge-tree --write-tree --merge-base=7b7501bd fe29b65d f47a20d7` against the last rebased commit: every
   difference is a place both jobs met. Above all `src/plugin/{convert,main}.ts` `optionsOf(msg)` (main's `icons` passed only when `true`:
   with "Icons as: SVG" and pictures to WordPress does a Figma convert from the panel still make Icons; the panel's Icons count),
   `src/ui/main.ts` (both posts carry icons and site colours), `src/core/convert.ts` / `site/convert.ts` options, `tools/replay.ts`, and
   `tools/lib/site-import/next.ts` (main's R2-1/R2-2 wording naming this job's palette file: does a `--colours` run print the right file
   name in every step, and a run without it print main's text byte for byte).
2. **One palette:** with and without `--colours`, the importer writes one palette file, one id and one `--color-<hex>` variable per colour,
   and the shared-styles classes link to the same ids; the Figma plugin's palette ids for the same colour equal the importer's. Without site
   colours: pastes byte for byte main's (608 site, 218 Figma cases).
3. **The pin changes:** each allowance exact (`later-jobs.ts` lists equal `git diff --name-status main...HEAD` over the pinned paths;
   `SHARED_PALETTE_BUNDLES`), `withoutSiteColourCount` throws unless the count is 0 with no notes, a stray-file / one-byte / `+1` mutant fail.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette/review-6/review.json` (round 6; first try scope delta `from`
`f47a20d7814916a54617c2d048baf003f87b4991`, full SHA `head`, a `note` saying it reviews the rebase resolution), in review-5's format;
self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
fe29b65d94da2c6f4e1ecb881354b9e9b9842cef /home/justin/.hermes/plans/figma-to-bricks/evidence/shared-palette` and quote its last line; if it asks
for another scope (e.g. full from fe29b65d), record it that way, say what your full scope rests on, and say so. Your worktree must be at
`00aff255` (`git checkout --detach 00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/spr6/t1`); scripts under `~/.cache/spr6/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg`; memory scopes
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …` outside the namespace (B-Dry files 8G). An archive tree has no
`node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`, and `F2B_SERVICES_FILE` for the Services save). Use `tail -n
3`. Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. SIGTERM/143/137/
"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as
.txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
