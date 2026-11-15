# Role: reviewer round 1 (full; report only): native-widgets

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path> <sha>`, extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site
(every Chrome that draws a site capture or paste with `SITE_OFFLINE`); run any test that captures the B-Dry stand-in or draws Justin's scan
only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 &&
ip link set d0 up && ip route add unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`, inside the memory
scope); never write to any WordPress site; touch nothing under `~/Downloads` (his scan copy:
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`). **Importer rule (repo CLAUDE.md): this is
the job's one review: P0–P2 only for bugs a real paste or normal use hits (a scenario and a measured number); edge cases are P3 and go to
follow-ups.** Justin's deadline is Monday 09:00 on this computer: keep to about 75 minutes. Load `requesting-code-review` and
`code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with
`references/testing-pitfalls.md` and `references/live-site-reading.md` "Code-route paste traps"; read both `repeat-mistakes.md` files first.
Don't read the builder's report or folder as proof. Ask of every paste: "would a Bricks pro find this logical and easy to change?" (the
standard at the top of the repo CLAUDE.md "Decisions the user made").

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/native-widgets/plan-approved.md` (AC1–AC10; its live AC
  `not_run`): Bricks' own elements instead of Code wherever Bricks has one, both tools (the menu's list slide as Bricks' Accordion inside
  the opened box, no Code; card arrows stay script, Q7).
- Head **`f8807e60`** (full SHA: `git rev-parse f8807e60`; branch `native-widgets-build`), base **`808d8dd4d04d38f8916f661d72e909de7ae82b3a`**
  (the builder's merge of importer-parity's older head `0585042a` and plugin-parity's `89e41a0d`, both on site-shared-styles' pre-rebase
  `7b7501bd`; built early on purpose). `git checkout --detach f8807e60`. Review `git diff 808d8dd4...f8807e60` (14 commits, 45 files). Those
  two jobs have since been rebased onto main `fe29b65d` and are in their final checks; this job will be rebased after they merge, so judge its
  own code, and name anything that will clash with main's newer code (bricks-icons-site's Icons, the shared classes and palette).
- page-faq-slide (being built now on f8807e60) reuses this job's `TreePick.rest`, `cssCurve`, `listSlideClass` and the renderer's two
  attributes: say if any of them is wrong.

## Check hardest
1. The Accordion this job makes from a scanned list slide: opens and closes as on the site (time, easing, one at a time or several, Escape,
   reduced motion), on Bricks 2.4.2 and 2.3.9 JS + CSS; flex/grid answers sit inside the content wrapper, never as it.
2. No Code element left where the plan says Bricks has an element; none of a kept widget's own code lost; nothing pasted that runs a page or
   tracking script.
3. Pastes the job doesn't touch byte for byte as its base; Figma designs as the plan says.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/native-widgets/review-1/review.json` (round 1, scope full, `from`
`808d8dd4d04d38f8916f661d72e909de7ae82b3a`, full SHA `head`), in the format `review-check.sh` reads (example:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-parity/review-4/review.json`); self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
808d8dd4d04d38f8916f661d72e909de7ae82b3a /home/justin/.hermes/plans/figma-to-bricks/evidence/native-widgets` and quote its last line.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/nwr1/t1`); scripts under `~/.cache/nwr1/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line); before each Chrome suite check `/proc/loadavg` (other agents share
the machine; above ~40 do reading first); memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …` outside the
namespace (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`,
`F2B_SERVICES_FILE`). Use `tail -n 3`. Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a
script file. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`
first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; what will clash with main; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
