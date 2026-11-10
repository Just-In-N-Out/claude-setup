# REVIEWER round 1 (full) + VERIFIER AC work: dream-trim (claude-setup), Mini pipeline

Role: fresh REVIEWER, report only. You never saw the build. Do not edit any file in the worktree or `$HOME`, don't commit, don't push, don't run `sync.sh` or `land.sh` against the real home. You may write only inside your own folders named below and your own scratch folder.

Inputs (only these):
- Approved plan (the contract, read-only): `~/.hermes/plans/claude-setup/evidence/dream-trim/plan-approved.md` (its "Justin's answers" section is binding; AC9 is `(live)`, owed to Justin).
- Worktree: `/home/justin/.claude-setup-wt/dream-trim` (branch `dream-trim`)
- head: `bac67c3475312e50e3557495a21073b5f61d9f2d`
- base: `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (= `git -C <worktree> merge-base HEAD main`; setup repo gitdir `~/.claude-setup.git`). `main` has moved on since (`9fae62a5` when this brief was written).
- Review the whole story: `git -C <worktree> diff <base>..<head>` (8 commits, 23 files). Pass 1 is commit `31abeb33`, pass 2 is `bac67c34` (the head).
- The builder's rulings, to judge on their merits, are in `~/.hermes/plans/claude-setup/evidence/dream-trim/builder/INVENTORY.md`. The main ones: `land.sh` holds the sync lock only for its final step (the plan had it held for the whole run), because `sync.sh` takes over a lock older than 10 minutes; a tool commit comes before the generated pass 1; the branch was reordered twice to keep pass 2 last; pass 2 was kept to 6 edits.

## What the story is
A one-time trim of four oversized instruction files (`figma-to-bricks/SKILL.md`, `feature-dispatch/SKILL.md`, `leorna/SKILL.md`, the FigmaToBricks project `CLAUDE.md`). Pass 1 moves whole lines into `references/` files behind pointer lines and must not change a byte of any moved line. Pass 2 merges duplicates; it must never reword or drop a protected safety line (push, authorship, approval, guards, merge policy), and Justin reads its diff before it lands. Every agent loads these files, so a lost or altered rule is the worst outcome.

## Skills to load (Skill tool), one line each when you do
`requesting-code-review`, `code-review-practice`, `engineering-best-practices`, `mutation-testing-discipline` (the checker behind AC1, AC5, AC6, AC7 and the `land.sh` guards behind AC8 are data-integrity guards).
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow them exactly.

## Job 1: review (writes `<evidence>/review-1/review.json`)
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-trim/`
Write `review-1/review.json`: round 1, scope "full", from = base, head = the head above, findings (empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases: inputs, configs, git operations, macOS and WSL), anything breaking an AC, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario.
Focus areas:
- Is pass 1 really lossless: check it yourself, independently of the builder's `trim-check.py` (your own comparison of base and pass-1 text), and that every pointer leads to the moved text.
- Can the checker pass when something was lost (a line changed, dropped, duplicated, reordered, moved to the wrong file; a file not in the map)?
- Pass 2: every one of the 6 edits against its ledger row; any safety rule, date, "why" or file:line reference lost or blurred.
- Would an agent still find what it needs: sections whose text every role needs on every load that moved out; pointers too vague to trigger a load; names other files, briefs, tests and hooks point at.
- `land.sh` against real use: other sessions edit and sync these files all day; `main` moves every few minutes; `sync.sh` copies a project's own `CLAUDE.md` over the project-docs copy; a held or stale sync lock; a dirty live file; a rerun after a partial landing; the Mac pulling the result.
- Tests that cannot fail, or that touch the real home, the real setup repo or the real project repo.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Job 2: verifier AC work (writes `<evidence>/verifier/ac.json`)
Per `ac-verification.md`: re-run the gates (every suite the plan's AC4 names), run each AC1–AC8 test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base && git -C <scratch>/base checkout -q --detach <base>`, head's test files copied in; never `worktree add` against the setup repo), logs stamped `HEAD=<sha>`, one terminal capture per AC as its screenshot. AC9: `"accepted": false, "not_run": "live: <why>"`. Self-check your `ac.json` blind as the doc says (copy, run `ac-check.sh` without `--reviews`, delete the copy).

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trim-reviewer-1/` (mkdir without -p); `/tmp` is a RAM tmpfs, keep big things under `~/.cache/dream-trim-reviewer-1/`. Remove both by literal path at the end.
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- In the Bash tool `grep` is ugrep: use `command grep` or `/usr/bin/grep`. Desktop coreutils are uutils; `mkdir` is not atomic under contention. Never `pkill -f`.
- A foreground Bash command is moved to the background after about 180 s: wait on long runs with repeated polls of under 3 minutes, each with the Bash `timeout` set above its bound. The AC4 suites take about 3.5 minutes per side.
- `codex-parity.test.sh` already fails 4 tests on the base (the builder says one is flaky); AC4 is worded as "every test that passed on base still passes".

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, verifier_ac_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
