# Role: fixer (after the blind audit; NOT ACCEPTED AC2, AC13) + move onto the new main: importer-parity

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md` and
`references/live-site-reading.md`. Read both `repeat-mistakes.md` files first. Keep to the standard at the top of the repo CLAUDE.md
"Decisions the user made". Never load any live site (every Chrome that draws a site capture or paste with `SITE_OFFLINE`); run any test that
captures the B-Dry stand-in or draws Justin's scan only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add d0
type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user
--map-user=1000 --map-group=1000 <cmd>'`, inside the memory scope); never write to any WordPress site; touch nothing under `~/Downloads`
(his scan copy: `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Commit to your branch only (plain `git commit -m`, no author
override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain
`git` in your own worktree, each command alone; files only with Write/Edit, never heredocs; scripts run as `bash <file>`. Before every `git
add` / `rebase --continue` in a conflict, `git diff --check`. **Deadline:** Justin needs this merged by Monday 2026-11-16 09:00 on this
computer's clock: fix what's listed, no gold-plating.

## State
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live).
- Head `a049bb4baa7329b8184cb3777e3ffabf47e1252a` (branch `importer-parity-final`) on main `fe29b65d`. Review 4 clean. The blind auditor
  (`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/auditor/ac.json`, its `own-*` files and `pics/`) found AC2 and AC13
  false; verifier 3 (`evidence/importer-parity/verifier-3/`) may still be finishing — read its `ac.json` if it's there when you start, and the
  main session will forward its report.
- **Local main moved** to `00aff255cdd2d0b6b6210ecf4e72ec6e925f44fb` (shared-palette merged: `--colours`, site colours in `src/core/site/convert.ts`,
  `parts.ts`, `share.ts`/`colours.ts`, `tools/lib/site-import/next.ts`, pins in `test/fixtures/later-jobs.ts`).

## Do
1. **Move first:** `git checkout -B importer-parity-fix4 a049bb4b…`; `git rebase 00aff255…`. Record conflicts in
   `evidence/importer-parity/fixer-4/conflicts.txt` (keep both sides' meaning: main's site colours and palette links, this job's settings and
   natives; a colour this job moves into a Bricks control still links the site's palette variable). Pins that meet: test-only updates the
   skill's pin lines describe (one commit each, exact allowances, old oracle with the switch off, mutants).
2. **Fix, each test first (RED on the moved head, GREEN, a one-line mutant killed):**
   - **AC2 (false):** a folded wrapper's by-id name (aria-labelledby, aria-controls, for) is dropped with no notes line; the same name on a
     kept wrapper or the element itself gives "1 name points at another element by id and is left out". Make the folded case write the same
     line (the auditor's case: a folded `div` with role, aria-label and aria-labelledby gives only "Names: 2 kept"; `own-ac2-folded-byid.txt`).
     Extend AC2's cited test with that case under its unchanged name.
   - **AC13 (false):** a Swiper/Splide that is its section's only child (`<section><div class="swiper">`) never becomes a Slider: rule S makes
     it the Section's Container and `src/core/site/plain-natives.ts:104` skips the record silently, so it pastes static (one full-width slide
     where the site shows three, no working arrow, no note). Make it a Slider inside the Section (the Section's Container holding the Slider,
     or the Slider standing for the Container — pick what a Bricks pro would build and Bricks' samples allow), or at least never silently:
     the plan's AC13 says it becomes a Slider. Extend AC13's cited test with the section-only variant on both routes and both Bricks versions.
   - **AC12 finding (P2):** a details FAQ the site lets several answers stay open (details open on their own) pastes as an Accordion that closes
     the others on a click: set `independentToggle: true` when the site's details aren't grouped (`name` attribute absent / the site's own
     script doesn't close siblings), as `reference/bricks/README.md` L714 names the key. Test first.
   - **AC16 finding (P2):** a `button` that is `type="button"` or `"reset"` is no send control (the plan's F1), but the capture keeps no button
     type and `form.ts:63` accepts any button, so a form sent by a script pastes as a Form that emails the admin. Read the button's `type` (the
     capture already has the element's attributes? if the capture must keep it, that's a capture change: keep it minimal; an older capture
     without it keeps today's behaviour, with a note) and refuse such a form as F1 says. Test first.
3. Everything else in the auditor's list (Bricks-pro notes, P3 test gaps, the 16 px arrows) goes to `evidence/importer-parity/follow-ups.md`.

## Gates
Both typechecks, `npm run check` (8G); every AC test by plan name on your head (B-Dry ones in the namespace) into
`evidence/importer-parity/fixer-4/receipt-<head7>.log` (`HEAD=` first, `EXIT=` last); the pins by name with `F2B_PIN_BASE=1` and
`F2B_STORY_PINS=1`; Justin's scan through `npm run site` both routes, drawn at 1440 and 390 against main 00aff255: every move named by an AC.
Ledger: a "Fixer 4" section. Stop at `ready-for-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipf4/t1`); scripts under `~/.cache/ipf4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg`; one Chrome suite at
a time; memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 …` outside the namespace (B-Dry files 8G). An archive
tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`, `F2B_SERVICES_FILE`). Foreground Bash moves to the
background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check
earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
New head (full SHA) and its main; conflicts; per finding: verified or pushed back, RED/GREEN, mutant; gates; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
