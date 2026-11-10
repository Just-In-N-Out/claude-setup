# Brief: REVIEWER 1, story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `dream-pass`. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude` (the verifier runs the one live test later; don't spend on it).

You never saw the build. The order is reviewer 1 (you) → fixer → reviewer 2 (full again) → fixer → … until a review is clean → verifier → blind AC auditor.

## Skills to load first (Skill tool; say so in one line each)
1. `engineering-best-practices`
2. `requesting-code-review`: use its security scan and quality gates. **Skip its "independent reviewer subagent" and auto-fix steps:** you are the fresh reviewer.
3. `code-review-practice`
4. `security-best-practices`: this job feeds text from transcripts to model calls and then writes Justin's live instruction files without a human reading them.
5. `mutation-testing-discipline`: check that the AC tests and guards can actually fail.

Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`. It is a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Candidate head:** `cae6bf8858861f0342c08b17b23905578ca3919c`. **Base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (= `git -C <worktree> merge-base HEAD main`). Review `git diff 131f9b0...cae6bf8`, all 9 commits (75 files, about 7,160 added lines).
- **Before you start,** confirm HEAD equals `cae6bf8` and that `git status --porcelain --untracked-files=all` is empty (the repo has `status.showUntrackedFiles=no`). If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only). Its "Justin's answers" section is binding: every recommended option, Q1 (a) through Q9 (a).
- **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree.
- **ACs:** AC1–AC45. AC39, AC40 and AC41 are `(live)`, Justin's checks after install: mark them `not_run` for that reason. AC37 is a named-only live test (two real model calls): judge its code, don't run it.
- **Builder's evidence:** `~/.hermes/plans/claude-setup/evidence/dream-pass/builder/` (`INVENTORY.md` has the rulings; `mutants.md`; `../baseline.md`).

### The builder's rulings (rule on each: valid, or a finding)
1. **A cut-off line in the middle of a transcript makes that session fail loudly and never be read.** Two real sessions have one today (a truncated write followed by a `last-prompt` line), one of them the active FigmaToBricksV2 session, so both would be reported as format errors on every run. The builder offered: (a) keep; (b) skip a broken line that is followed by `last-prompt` and log it. Say which the plan's intent supports and whether (a) is a wrong block of normal work.
2. "Markers" are `local/cursors.json` and move only after the commit; lines helpers already read are tracked in `unsettled.json`.
3. Dry-run does no pull, writes no ledger rows and no `unsettled.json`.
4. A stopped live run appends a "stopped" note to `dream-log.md`; the next `sync.sh` commits it.
5. The dream holds `sync.sh`'s lock only for the apply step (hash re-check, status checks, writes, commit). `sync.sh` takes over a lock older than 10 minutes.
6. The dream writes `dream.pid` into its lock and clears that lock at the start of a run if the process is dead.
7. Findings the editor declines go on Justin's list and count as settled, as do findings parked after two tries.
8. Repeat-mistakes files are checked entry by entry, not by the line-accounting guard.
10. The pre-apply `git status` check covers target files only; Justin's own edits to `justin-list.md` are kept.
11. The narrowest place for a finding; library skills need a finding stated as general or seen in two projects.
13. The live test replaces only the system prompt.
14. The dream's hook groups sit before cortexos-memory's in `settings.json`.

## Focus areas (on top of a normal full review)
- **AC truth:** does each test prove every clause of its AC? Which tests cannot fail?
- **Can anything reach a live file that should not.** Try to get past each guard with realistic inputs: the quote check (a quote from context, from another entry, from an omitted paste, from a menu option Justin did not choose); the bar; safety flags a helper forgot to set; protected sections and canary facts; budgets and caps; the line-accounting of removals; the allowlist (symlinks, `..`, a `~/.claude/skills/<name>` link, a library link, a path under `~/Leorna/`, `DREAM.md`, `~/.codex/AGENTS.md`); the hash check; the editor's `changes.json` disagreeing with its real diff.
- **Text that carries instructions.** Transcript text reaches helpers (context blocks, whole-message pastes, menu answers); findings reach the editor and the checker. Could a pasted web page or tool output steer a helper into a finding that passes the quote check, or steer the editor or checker? Are the model calls' prompts and schemas built so that data cannot be read as instructions, and do the scripts, not the models, make every allow decision?
- **Secrets and personal details:** scrubbed before any model call, never in the log, the list, the state files or a commit. The log quotes Justin's messages and syncs to his private repo.
- **The commit:** exactly the dream's paths; other sessions' pending edits never inside it; the sync lock (ruling 5 and 6, a pid reused by another process, a `sync.sh` that takes the lock over mid-apply); push only through `sync.sh` to `Just-In-N-Out/claude-setup`; zero commits in the library clone; nothing under `~/Leorna/`.
- **Crash safety:** a kill at each step of the apply; the journal; `dream undo` on a commit that touched a skill, a library skill and a project `CLAUDE.md`.
- **Wrong blocks:** anything that would make the dream stop on every run in normal use (ruling 1, unknown line shapes after a CLI update, a file already over budget, a stale lock) with no way for Justin to see why in the session-start line.
- **The two hooks** (`dream-ledger.sh` on Write and Edit, `dream-notice.sh` at session start) run in every session on both machines: fail open, fast, never block or slow a tool call, safe under macOS `/bin/bash` 3.2 with a minimal PATH, no secrets in argv, and the `settings.json` change is a pure addition that keeps every existing suite green.
- **Cost and load:** at most 8 session helpers, 3 at once, the digest cap, no retry loop that can spend without bound, the memory cap on the service, the preflight for a missing CLI flag.
- **The extractor against the plan's line shapes:** typed, queued, mid-turn, slash-command arguments, menu answers, whole paste and inner paste, injected shapes, headless sessions; fail loud on an unknown shape.
- **Tests:** none may touch the real home, the real setup repo, the real library clone or real systemd units, and no fixture may contain Justin's real messages, keys or tokens.
- **Overlap with `dream-trim`** (lands first; it moves lines out of `leorna/SKILL.md`, `figma-to-bricks/SKILL.md`, `feature-dispatch/SKILL.md`): will this branch's pointer lines and `references/repeat-mistakes.md` files survive a rebase onto the trimmed files?

## Output: `<evidence>/review-1/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-1/review.json`: round 1, scope "full", from = base, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases: inputs, configs, git operations, macOS and WSL), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-1/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-1/` (mkdir without -p); `/tmp` is a RAM tmpfs, keep big things under `~/.cache/dream-pass-reviewer-1/`. Remove both by literal path at the end.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x` (never `worktree add` against the setup repo, never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- The evidence folders under `~/.hermes/plans` hold symlinks into `node_modules`: don't walk them with a recursive glob that follows links.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
