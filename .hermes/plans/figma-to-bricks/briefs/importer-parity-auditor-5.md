# Role: blind AC auditor (read-only, on the rebased head; runs alongside the verifier): importer-parity

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read any verifier's or earlier auditor's report or folder** (`evidence/importer-parity/verifier*/`, `auditor*/` other than your own), nor
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
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/plan-approved.md` (AC1–AC22; AC22 live: `not_run`). The job (website importer): the paste uses Bricks' own settings and elements like a Bricks pro would — named elements, settings before custom CSS (controls, Button Style: Primary), native Accordion, Slider, Video, Nav (Nestable), Form, Divider; the switch off (`parity: false`) = main byte for byte; Figma untouched; main's shared classes, palette links and Icons kept (an Icon's class writes no Bricks control). Justin ruled 2026-11-14 that a simple scanned form pastes as a Bricks Form for now (forms-wpforms switches it to WPForms later).
  Named-only tests run by name with the plan's variables. The head may print test names with an `ACn ` prefix the plan's names lack: use
  `ac-verification.md`'s by-name checker; write each `ac.json` command so it parses in bash (double quotes, `\$`) with its env on the command.
- Head **`a049bb4baa7329b8184cb3777e3ffabf47e1252a`** (branch `importer-parity-final`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`** (Build 2026-11-14.4). In your
  own worktree: `git checkout --detach a049bb4b…`, clean status. Old code: a `git archive` of fe29b65d (extract separately) with head's
  test files and fixtures copied in (where a new module doesn't import, prove with a one-line mutant of head). In an archive tree put a `tsc`
  wrapper first on PATH and set `GIT_DIR` (and `F2B_SERVICES_FILE` for tests reading `git show 2199895:…`).
- Known on main itself, not this job: `icon-elements` renderer@600/390 "11 icons shown"; `site-motion-bdry`'s Elementor hover-look test;
  `site-media-unchanged`'s 308 misses; `site-live` 3 of 6; `site-upload-icons` needs the network (AVIF encoder; run it with network, local
  fixtures only).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code (fail on its own assertion), plus one check of your own per AC beyond
the cited test — e.g. a fixture site of your own (not the repo's) with a plain menu with a sub-list, a details FAQ, a Swiper slider with breakpoints, a YouTube frame, a simple contact form, a bordered card with a hover, a divider — each the plan's Bricks element, drawing as the site at rest, hovered, focused and opened on Bricks 2.4.2 and 2.3.9; on Justin's scan both routes offline: every `var(--color-…)` in `palette.json`, no property written by two classes, 0 px against main beyond what the ACs explain. A picture per AC (a terminal capture where nothing is visual). Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/auditor-3/ac.json` and logs there (create it; check it is empty); self-check
with `ac-check.sh` on a copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`). Put every receipt wrapper in a script file written
with the Write tool and run it with `bash <file>`. Also say where a Bricks pro would not find the paste logical (the standard at the top of the
repo CLAUDE.md "Decisions the user made").

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ipa3/t1`); scripts under
`~/.cache/ipa3/s/`; **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close
every Chrome you start by PID (a `user-data-dir=` pattern ends in `/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line);
before each Chrome suite check `/proc/loadavg` (above ~40: unit work first); one Chrome suite at a time, each under `systemd-run --user --scope
-p MemoryMax=4G -p MemorySwapMax=0 …` (B-Dry files 8G) outside the namespace. Use `tail -n 3`. Foreground Bash moves to the background after
about 180 s: long runs with `setsid --fork`, waiting on `^EXIT=` in bounded steps of 160 s or less. SIGTERM/143/137/"Killed" may be earlyoom:
check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`


## Update for this run (main session, 2026-11-15) — overrides the head, base and folders above
- Head **`34e02b9062596891d33377e2eb829c1ffebee046`** (branch `importer-parity-fix4`), base **main `e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`** (Build 2026-11-15.1: shared-palette's site colours on top of fe29b65d). Wherever the text above says `a049bb4b…` read `34e02b90…`, and `fe29b65d…` read `e2fc35aa…` (the old code is a `git archive` of e2fc35aa with head's tests copied in; `ac-check.sh --base e2fc35aaa6b7e3a662d0c3cce37ec636495a5405`).
- Since the last checks: fixer 4 moved the job onto e2fc35aa (conflicts with shared-palette, keep-both) and fixed AC2 (a folded wrapper's by-id names counted in a notes line), AC13 (a Swiper that is its section's only box becomes a Slider inside the Section; a slider that is a part's top box stays static, named), AC12 (a details FAQ gets `independentToggle` unless its details share one name) and AC16 (the capture keeps `type` on buttons, `name` on details; a form whose button is type=button/reset stays as it is, named; an older capture as before plus one note). Review 5 clean.
- Also run `test/browser` with the network on (Splide, Google Fonts) and person-check web tests with `DISPLAY=:0`; B-Dry/scan files in the namespace.
- Known on main itself, not this job: also `importer-app-notes` (styles.txt listed), `panel-embed-unchanged` and `site-scroll-lock-base` story pins.
- Write to `evidence/importer-parity/auditor-3/` (create it; it must be empty).
- You are blind: read nothing under `evidence/importer-parity/` but `plan-approved.md` and your own folder (no earlier auditor's or verifier's folder, no review, no fixer report). A verifier works on the same head at the same time. Prove AC2, AC12, AC13 and AC16 with your own cases too (a folded wrapper with aria-labelledby; a Swiper and a details FAQ that are their section's only box; several details open on their own; a form sent by a script).


## Update 2 for this run (main session, 2026-11-15, later) — overrides the head, base and folders above and in Update 1
- Head **`dd0f1a9d1efd24ce513d590ea315214da699bc41`** (branch `importer-parity-fix6`), base **main `9942df18bf3b4fb986d19d8baa266be559a836a8`** (site-tests-offline: every test Chrome through `launchOffline`, every Node fetch through `offlineFetch`, guard `test/unit/site-tests-offline.test.ts`, which must pass on head). Old code: a `git archive` of 9942df18 with head's tests copied in; `ac-check.sh --base 9942df18bf3b4fb986d19d8baa266be559a836a8`. Test runs no longer need the network (Update 1's "network on" line is void); B-Dry/scan files still in the namespace.
- Since the checks on 34e02b90: fixer 5 moved the job onto 9942df18 and fixed AC12 (a plain native — Accordion, Divider, Nav, Video, Form — that is its Section's only box now becomes that native: Justin's "Keep it flat" ruling, a FAQ, Divider or Nav alone in its Section pastes as Section > Accordion with no Container) and AC17 (a Form field's size from HTML `rows`/`cols`/`size`); fixer 5 (R6-1) and fixer 6 (R7-1) made those sizes right on both axes for a field with no box-sizing (content-box), with and without a declared size, min or max on the other axis. Reviews 6–8 clean after the fixes. A finisher is moving this head onto main 201218fa (test-only list conflicts) at the same time: check dd0f1a9d as given.
- Prove AC12 and AC17 with your own cases too: a FAQ, a Divider and a Nav each alone in its Section; a content-box textarea (rows) and input (size) with padding, with a declared width/height on the other axis, on Bricks 2.4.2 and 2.3.9 within 2 px.
- Known on main itself, not this job: `site-media-unchanged`, `panel-embed-unchanged`, `site-scroll-lock-base`, `importer-app-notes`.
- Write to `evidence/importer-parity/auditor-3/` (create it; it must be empty). You are blind: read nothing under `evidence/importer-parity/` but `plan-approved.md` and your own folder.


## Update 3 for this run (main session, 2026-11-15, night) — overrides the head, base, folders and TMPDIR above and in Updates 1–2
- Head **`f23ba8d5bcf2f400371c19fb0857cd45c8eb6924`** (branch `importer-parity-fix11`), base **main `201218fa7608343cad97da8b9e609ba6377b8438`** (Build 2026-11-15.2 with plugin-parity). Old code: a `git archive` of 201218fa with head's tests copied in; `ac-check.sh --base 201218fa7608343cad97da8b9e609ba6377b8438`. Deadline Monday 09:00 on this computer: about 12 hours; aim for about 90 minutes.
- Since the checks on dd0f1a9d: the job moved onto 201218fa, and two more fixes landed (one about names that point at another element by id, one about the wording of a still form's note). You are blind: read nothing under `evidence/importer-parity/` but `plan-approved.md` and your own folder.
- Prove every AC; with your own cases also AC2 (a real capture of your own: a section with aria-labelledby, a p with aria-describedby, a folded wrapper's aria-labelledby; what the notes say and what the paste holds), AC12 (a FAQ, a Divider and a Nav each alone in its Section), AC16 (a form a script sends; a form inside a box a button opens; what its notes say) and AC17 (a content-box textarea with rows and an input with size, with padding, on Bricks 2.4.2 and 2.3.9 within 2 px).
- Known on main itself, not this job: `site-media-unchanged`, `panel-embed-unchanged`, `site-scroll-lock-base`, `site-ticks-base`, `importer-app-notes`; `media-avif-untouched`/`site-import-figma-unchanged`/`media-avif-as-served` red on both trees only on `src/shared/build.ts`. Each concurrent runner needs its own TMPDIR lane.
- Write to `evidence/importer-parity/auditor-5/` (create it; it must be empty). TMPDIR `~/.cache/ipa5/t1`; script names `ipa5-*.sh`; when you kill Chromes by lane, end the pgrep pattern with `/`.
