# Brief: REVIEWER 1 (with the verifier's AC work), story `dream-coding-only` [claude-setup] (Mini pipeline)

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `dream-coding-only`, and, as the Mini pipeline asks, you also do the **verifier's AC work** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`). You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub (your evidence folder below is the one exception);
- never start the dream's timer or service and never run a real dream against Justin's real home.

You never saw the build. Order: reviewer 1 (you) → fixer and a fresh delta reviewer if needed → blind AC auditor → `ac-check.sh`.

## Skills to load first (Skill tool; say so in one line each)
1. `engineering-best-practices`
2. `requesting-code-review`: use its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer.
3. `code-review-practice`
4. `mutation-testing-discipline`: check that the AC tests and the coding verdict guard can actually fail.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (review.json format) and `ac-verification.md` (verifier receipts). Before starting, read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` and look for those mistakes in this change.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-coding-only`, branch `dream-coding-only`, a linked worktree of the setup repo `~/.claude-setup.git` (main work tree `$HOME`).
- **Candidate head:** `55310ad2ccd536642d0fb0ef75f01848941185b6`. **Base:** `8131bdc38886f9ecb53dce47110fbc34a682e0e2` (= `git -C <worktree> merge-base HEAD main`). Review `git diff 8131bdc...55310ad`, all 7 commits.
- **Before you start,** confirm HEAD equals `55310ad` and `git status --porcelain --untracked-files=all` is empty (the repo has `status.showUntrackedFiles=no`). If either fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-coding-only/plan-approved.md` (read-only). Justin said "go", so its recommended options hold: Q1 (a) skip when unsure; Q2 (a) the session helper decides in its existing call; Q3 (a) Justin's dry run checks the real career session.
- **ACs:** AC1–AC12. AC12 is `(live)`: Justin's, mark it `not_run` for that reason. AC10 is the named-only live test (three small real calls); run it **once** on the head as the verifier, and judge its code.
- **Known on the base, not this story's:** `test_ac36_pointer_lines_and_docs_are_in_place` fails on main; `codex-parity.test.sh` fails `ac19_config_merge_idempotent`, `ac21_pipeline_model_switch`, `ac4_codex_sees_claude_skills` on the base too. Same failures on head are not findings for this story (you may list them in `found_else`).
- **Builder's evidence:** `~/.hermes/plans/claude-setup/evidence/dream-coding-only/builder/` (`INVENTORY.md` has the rulings; `mutants.md`; `../baseline.md`). Don't reuse its receipts as yours: re-run.

### The builder's rulings (rule on each: valid, or a finding)
1. AC6's test allows `local/last-run.json` plus the empty `local/run.lock` that every run (base too) creates.
2. AC5's missing-key case is made by wrapping `agents.session_helpers` in the test to drop the key (the fake defaults `coding: true` when a scenario leaves it out); the null and `"yes"` cases go through the fake.
3. `.claude/setup/desktop.md` edited in this branch.
4. The mutation report lives at `builder/mutants.md`, not `<evidence>/mutants.md`.
5. The helper prompt's opening sentence and "usual answer" line were reworded (the plan's paragraph kept verbatim), since the old `{"findings": []}` no longer matches the schema.
6. The reason is cut to 120 characters both in `run.py` (saved) and `log.py` (written).

## Focus areas
- **AC truth:** does each test prove every clause of its AC, through the real entry point the AC names? Which tests cannot fail?
- **Can a non-coding session still reach a live file or Justin's list:** a `coding: false` answer with findings, pending candidates, list questions, the review-finding path, a session split across digests (over 120,000 characters), a resumed session, a helper failure or retry, a dry run.
- **Markers:** a skipped session never read again; a missing verdict moves nothing; no path loses a coding session's lines.
- **The reason text** reaches a synced log: length cut, one line, no quote or name, the log's secret scan still applies; model text can't break the log's shape.
- **Wrong blocks:** anything that makes every run fail or skip every session in normal use (schema too strict, the real CLI's structured output rejecting the new fields).
- **Docs:** `DREAM.md`, `CLAUDE.md` "Dream Pass" (under 36,000 bytes), `desktop.md` agree with the code.

## Verifier's AC work
For every non-live AC, run its named test on head and on the base (in a separate copy, as `ac-verification.md` says; for the setup repo use `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach 8131bdc`, never `worktree add`), with receipts in `ac-verification.md`'s format (first line `HEAD=<sha>`, last line `EXIT=<code>`) and a PNG capture each. Write `<evidence>/verifier/ac.json` and its `ac_status` as `ac-verification.md` specifies, and run AC11's regression check.

## Output
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-coding-only/`
- `review-1/review.json`: round 1, scope "full", from = base, head = the head above, findings (empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic inputs, configs, git operations, macOS and WSL), anything breaking an AC, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-1/probes/`.
- `verifier/ac.json` plus receipts under `verifier/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 8131bdc38886f9ecb53dce47110fbc34a682e0e2 <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-coding-only-reviewer-1/` (mkdir without -p); `/tmp` is a RAM tmpfs, keep big things under `~/.cache/dream-coding-only-reviewer-1/`. Remove both by literal path at the end.
- Probe on scratch copies with a fake home and the fake `claude`, as the tests do.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | /usr/bin/grep -E 'sending SIG[A-Z]* to process'` before reading a result.
- In the Bash tool `grep` is ugrep and `find` is bfs (use `/usr/bin/grep`, `/usr/bin/find`); never `| grep -q` under `pipefail`; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes. Commit-free: you write only the evidence folder.
- The evidence folders under `~/.hermes/plans` may hold symlinks: don't walk them with a recursive glob that follows links.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, verifier_ac_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files.
Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks, where it runs). An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
