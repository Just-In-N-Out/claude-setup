# Common rules for every reviewer (2026-11-15) — read with your own brief

Review only: change no source or test, commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C`
the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`, extract separately; scripts with the Write tool,
run as `bash <file>`, no heredocs). Never load any live site (every Chrome that draws a site capture or paste with `SITE_OFFLINE`); run tests
that capture the B-Dry stand-in or draw Justin's scan only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add
d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user
--map-user=1000 --map-group=1000 <cmd>'`, inside the memory scope); `test/browser` and every other file need the network on (Splide, Google
Fonts); person-check web tests need `DISPLAY=:0`. Never write to any WordPress site; touch nothing under `~/Downloads` (his scan copy:
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`).

Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md` and
`references/live-site-reading.md`; read both `repeat-mistakes.md` files first. Don't read the builder's or fixer's report or folder as proof.
Ask of every paste: "would a Bricks pro find this logical and easy to change?" (the standard at the top of the repo CLAUDE.md "Decisions the
user made"). Justin's deadline is Monday 2026-11-16 09:00 on this computer: keep to your brief's time. **Website importer jobs (repo
CLAUDE.md): P0–P2 only for bugs a real paste or normal use hits, with a scenario and a measured number; edge cases are P3 → follow-ups.**

Write `review.json` where your brief says, in the format `review-check.sh` reads (example:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/review-5/review.json`), and self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base <the brief's base> <the job's
evidence folder>`; quote its last line.

Machine: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (your brief names it); scripts beside it;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (a `user-data-dir=` pattern ends in
`/`; never `pkill -f`/`pgrep -f` with a pattern in your own command line; give your own scripts names with your role and job in them, never a bare `queue2.sh`/`run.sh`, since another agent's process sweep can match it; never run another agent's script copy before `grep`-ing it for that agent's id and cache folder (0 matches): a copy keeps their worktree paths); before each Chrome suite check `/proc/loadavg` (several agents
share the machine; above ~40 read first); memory scopes `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …` outside the
namespace (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`,
`F2B_SERVICES_FILE`); check a base run's file list lacks the job's new test files. Use `tail -n 3`. Foreground Bash moves to the background
after about 180 s: wait in bounded steps of 160 s or less from a script file (never end your turn to wait on a background run: that reads as your final report). A Bash call the git guard refuses runs none of its steps, those chained before the refused part included: put git steps in a script. SIGTERM/143/137/"Killed": check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

Report (as text; only review.json is written): findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
