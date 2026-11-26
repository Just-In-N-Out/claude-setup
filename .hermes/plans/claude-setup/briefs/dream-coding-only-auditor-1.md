# Brief: blind AC AUDITOR, story `dream-coding-only` [claude-setup] (Mini pipeline)

## Role
You are the fresh, blind **AC auditor**. You prove every acceptance criterion yourself, from the approved plan and the code alone. You never saw the build or any review, and you must not read anyone else's evidence: **do not open** anything under `~/.hermes/plans/claude-setup/evidence/dream-coding-only/` except `plan-approved.md` and your own folder `auditor/`. Report only:
- no source changes, no commits; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub (your `auditor/` folder is the one exception);
- never start the dream's timer or service and never run a real dream against Justin's real home.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, then `mutation-testing-discipline` (an AC test that can't fail does not prove its AC). Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (receipts, base runs, `ac.json` format).

## Inputs (all you get)
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-coding-only/plan-approved.md` (read-only). Justin said "go", so its recommended options hold.
- **Worktree:** `/home/justin/.claude-setup-wt/dream-coding-only` (linked worktree of the setup repo `~/.claude-setup.git`; it has `status.showUntrackedFiles=no`, so check cleanliness with `git status --porcelain --untracked-files=all`).
- **Head:** `55310ad2ccd536642d0fb0ef75f01848941185b6`. **Base:** `8131bdc38886f9ecb53dce47110fbc34a682e0e2`. Confirm HEAD and a clean tree before you start; stop and report if either is wrong.
- **Your folder:** `~/.hermes/plans/claude-setup/evidence/dream-coding-only/auditor/` (exists, empty).

## What to prove
- AC1–AC12. AC12 is `(live)`: Justin's; record it `not_run` with that reason. AC10 is the named-only live test (three small real model calls): run it **once** on head.
- For each non-live AC: read its exact words, read its named test and the code it exercises, decide whether the test proves every clause through the entry point the AC names, run it on head and on the base (base copy: `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach 8131bdc`, never `worktree add`; head's test files laid over it as `ac-verification.md` says), and where a clause looks unpinned, try a small mutant in a scratch copy. Receipts in `ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`) plus one PNG terminal capture each (headless Chrome under `env -u DISPLAY -u WAYLAND_DISPLAY` with `--disable-software-rasterizer`; `~/.claude/projects/-home-justin/memory/desktop-test-browser-libs.md` if Chrome misses libraries).
- Judge each AC by its plan text. If the code does something sensible that the AC's words don't allow, that is `accepted: false` with the exact words and the observed behaviour.
- Known on the base, not this story's: `test_ac36_pointer_lines_and_docs_are_in_place` fails on main, and `codex-parity.test.sh` fails 3 tests on main.

## Output
Write `auditor/ac.json` in `ac-verification.md`'s format, receipts under `auditor/`.

## Environment rules
- Scratch only in a fresh `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-coding-only-auditor-1/` (mkdir without -p); big things under `~/.cache/dream-coding-only-auditor-1/`. Remove both by literal path at the end.
- Suites and mutants run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | /usr/bin/grep -E 'sending SIG[A-Z]* to process'` first.
- In the Bash tool `grep` is ugrep and `find` is bfs (use `/usr/bin/grep`, `/usr/bin/find`); never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.

## Report
Return `{verdict: accepted|not_accepted, ac_status[{ac, accepted, test, evidence, why}], auditor_ac_json, found_else[], skill_lessons[]}`.
Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check that would have caught a broken rule). An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
