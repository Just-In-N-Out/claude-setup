# Role: blind AC auditor (read-only): plugin-header-footer-ticks

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own folder.
**Never read the verifier's report or folder** (`evidence/plugin-header-footer-ticks/verifier/`), the reviewer's, builder's or
planner's reports as proof. Change no source or test, commit nothing, start no agents. Never load any live site; never write to any
WordPress site.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the
`ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read both
`repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/plan-approved.md` (AC1–AC6;
  AC6 live: `not_run`).
- Head `c0e04ef4a1d5b6580203e822ad36fff06ec33b83` (branch `plugin-header-footer-ticks-build`), base
  `e61c0ca091413adfdca3c9b3abe4757ef2fd521f`. Your own worktree: `git checkout --detach c0e04ef4…`, clean status. Old code: a `git archive`
  of `e61c0ca0` with head's test files copied in. AC5 by name with `F2B_BASE_TREE` = a fresh `git archive` of the base.

## Work
Prove every AC yourself: its cited test on head and old code (or `base_exempt` with a reason and a mutant), plus one check of your own
per AC beyond the cited test — e.g. AC1: the built `dist/ui.html` in Chrome driven through the four box states (and a fresh file, a
file saved ticked), the line's words read back each time against what a Convert then pastes; AC2: grep `src/`, `tools/`, `dist/` for
the old words, wrapped across comment lines too; AC3: the plugin's own `saveSite` + `convert()` with both ticked vs never ticked on a
design of your own (a fixture with a top bar and a footer stack); AC5: your own byte comparison at the four states on the repo's Figma
files and a capture. A picture per AC. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/auditor/ac.json`
and logs there (it's empty); self-check with `ac-check.sh` on a copy (`--base e61c0ca091413adfdca3c9b3abe4757ef2fd521f`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/pha/t1`); keep scripts under
`~/.cache/pha/s/`. `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start; one Chrome suite at
a time, each under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Write scripts with the Write tool; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
