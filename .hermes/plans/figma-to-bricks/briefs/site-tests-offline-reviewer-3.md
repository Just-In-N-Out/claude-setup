# Role: reviewer round 3 (delta; report only): site-tests-offline

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command; scripts with
the Write tool, run as `bash <file>`, no heredocs). Never load any live site; run any test that captures the B-Dry stand-in or draws Justin's
scan only inside a no-network namespace (`unshare -rn sh -c 'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev
d0 && ip link set d0 up && ip route add unreachable default && exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`, inside the memory
scope); never write to any WordPress site; touch nothing under `~/Downloads`. Load `requesting-code-review` and `code-review-practice`; read
the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first. Don't read the fixer's report as proof. Keep to about 60 minutes (Justin's deadline is Monday 09:00 on this
computer). P0–P2 only for what a real test run or normal use hits, with a scenario and a measured result; the rest P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4): test runs
  never reach the internet (every test Chrome and Node fetch loopback-only, guarded).
- Round 2 (`evidence/site-tests-offline/review-2/review.json`) reviewed `fe29b65d...001f2a1a` and found R2-1 (a capture given no browser
  starts a Chrome with no host rule the guard never sees), R2-2 and R2-3. Fixer 2 made head **`29a7f6c1`** (branch
  `site-tests-offline-fix2`, full SHA by `git rev-parse`) on base `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`.
- **Your scope:** the fix commits `git diff 001f2a1a906504f1e06193eb143c265547e740a5..29a7f6c1` and what they touch: are R2-1, R2-2, R2-3
  fixed for real (a capture without a browser now refused or offline; www.google.com allowed only as the fixer claims, counted), does any
  test now open the internet or lose a check it had, does the guard still see every launch.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/review-3/review.json` (round 3, scope delta, `from`
`001f2a1a906504f1e06193eb143c265547e740a5`, full SHA `head`), in the format of review-2's file; self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
fe29b65d94da2c6f4e1ecb881354b9e9b9842cef /home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline` and quote its last line.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sto3/t1`); scripts under `~/.cache/sto3/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f`/`pgrep -f` with a
pattern in your own command line); before each Chrome suite check `/proc/loadavg`; memory scopes `systemd-run --user --scope -p MemoryMax=4G
-p MemorySwapMax=0 …` outside the namespace (B-Dry files 8G). Foreground Bash moves to the background after about 180 s: wait in bounded steps
of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso |
grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
