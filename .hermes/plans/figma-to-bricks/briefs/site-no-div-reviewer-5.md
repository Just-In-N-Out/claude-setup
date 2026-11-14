# Role: reviewer (round 5, review of the REBASE RESOLUTION onto main 12.3; report only): site-no-div

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command; `git archive -o <file> <sha>` then extract
separately; scripts with the Write tool, no heredocs). Never load any live site; never write to any WordPress site; touch nothing under
`~/Downloads` (Justin's scan copy: `evidence/media-clickable/run/`). **Importer rule:** P0–P2 only for bugs a real paste or normal use hits (a
scenario and a measured number); edge cases P3.

## Scope
Reviews 1–4 were clean on `828f7dc01af443ea5bc248fac1d1106e711cfdba` (based on main `56b5076b`). A finisher rebased it onto local main
`7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8` (Build 2026-11-12.3: site-fonts-match and bricks-icons merged meanwhile) with conflicts, then
added one test-only commit. New head `cf4f887de2a52ad8d7cb757486cc1916f3e3f4f4` (branch `site-no-div-final`; `git checkout --detach
cf4f887d…`). Review only what the reviewed head lacks: the conflict resolutions and the new commit, and how this job's code meets what
main added.
- Finisher's record: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/rebase/conflicts.md` (5 resolutions: `src/core/site/convert.ts`
  `ConvertOptions` `failedFaces` + `native`; `reference/bricks/README.md`; `test/browser/render.ts` head line `${textLinkCss}`; HANDOFF; the
  allow-lists in `media-avif-untouched` and `site-import-figma-unchanged`), `range-diff.txt` (`git range-diff 56b5076b..828f7dc0 7f54b0a5..cf4f887d~1`
  to redo it), and commit `cf4f887d` changing site-fonts-match's `test/unit/site-fonts.test.ts` AC3 and AC7 (logs `site-fonts-red-4a4bfa1.log`,
  `site-fonts-green.log`, `site-fonts-mutants.log`, `ac7-base-sums.txt`, `base-sums.ts`).

## Check hardest
1. Each resolution keeps both sides' meaning (no field, CSS or allow-list entry lost; the allow-lists name exactly this job's files).
2. site-fonts-match meets this job's new structure on a real paste: page-named families (`"home__Roboto"`) and the `<page>__site-fonts-<4>`
   class reach every lifted top Section and every new element (Text link, Button, Rich Text), on both routes; a fonts fixture whose faces the
   site serves itself (with `fontsRead: 2`) drawn in Chrome base (main 7f54b0a5) vs head: the words keep their fonts; no plain carried name in
   a Typography control.
3. bricks-icons meets it: an Icon (Figma side, Pictures to WordPress + Icons as SVG) is unchanged (Figma replays byte for byte main's); no site
   paste path writes an Icon wrongly.
4. The AC3/AC7 test change is honest: AC3 now expects the root's family list once per top Section — is that what a Bricks pro would want, or
   should the list sit once on the fonts class? (a real paste bloat is P2 only with a measured visible or editing cost); AC7's native-off
   comparison still pins what site-fonts-match pinned (its three mutants killed; try one of your own).
5. The standard (repo CLAUDE.md top of "Decisions the user made"): would a Bricks pro find the rebased paste logical?

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div/review-5/review.json` (round 5, scope of the resolution, full SHA `head`
cf4f887d…), in review-4's format; self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base 7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-no-div` and quote its last
line; if the script asks for another scope or base, follow it and say so. Load `requesting-code-review` and `code-review-practice`; read the
project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly; not linked) with `references/testing-pitfalls.md`;
read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sdr5/t1`); scripts under `~/.cache/sdr5/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start; one Chrome suite at a time under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`
(B-Dry 8G). Use `tail -n 3`. Waits under 115 s in foreground poll chunks (never end your turn to wait). After SIGTERM/143/137/"Killed"
check earlyoom's log and `journalctl --user | grep -E 'oom-kill|OOM killer'`.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; each resolution: holds or not; Bricks-pro notes; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
