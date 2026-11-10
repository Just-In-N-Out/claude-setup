# Brief: REVIEWER 3 (delta), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 3** for Justin's setup story `dream-pass`. Rounds 1 and 2 were full reviews; from round 3 a round reviews only the fix commits since the last review and what they touch. You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude`.

You never saw the build, the earlier reviews' work or the fixes.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `code-review-practice`, `security-best-practices`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: base, the previous round's head, head).

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `818600358d3c149b64799c282c07d5a6f4a4512f`. **Previous round's head (your `from`):** `e3c6302a16b63092e1bddecbe4dfa841397fb9ff`. **Story base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be`.
- Review `git diff e3c6302a..81860035`: 6 fix commits, 12 files, about 795 added lines, and what they touch.
- **Before you start,** confirm HEAD equals `8186003` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only; "Justin's answers" is binding). **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree (unchanged by this fix round).
- **What the story is:** a twice-daily job that reads what Justin typed in his Claude Code sessions and the pipeline's review findings, has one model helper per session list lessons, one editor change a copy of his skills, `CLAUDE.md` files and memory notes, and scripts decide what may go live as one commit, with no human reading it first. Scripts, not models, make every allow decision.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-1/review.json` and `review-2/review.json` with their `probes/`; the fixers' answers in `fixer-1/README.md` and `fixer-2/README.md`; `fixer-2/mutants.md`, `fixer-2/review-2-probes-on-head/`.

### The fixer's answer to each round-2 P0–P2 (all 6 reported fixed; none rejected, none a plan gap)
- **R2-1** `77cf8c97`: an `order` change now counts in no file's line accounting (its branch removed from `_valid_changes`, `removal_ok` and `g_dated_lines`); a finding change counts only in a file every finding it cites may change; a move's destination must be a target of the copy, never `_dream/`.
- **R2-2** `a1bc1f57`: the change cap and the budget measure a repeat-mistakes file's change from the script's own rewrite of it, so the rewrite is charged to neither; orders size a file's room on that rewrite.
- **R2-3** `28fb6df4`: each add order carries `max_entry_bytes` (heading plus 400 bytes); the editor is given it and `check_copy` holds every added entry to it.
- **R2-4** `f31029db`: a "fold" is recognised: the old line stays whole, word for word, at the start of the new one (only its final full stop or semicolon may go), the added words are a listed addition of a finding change that may change the file; a fold is not a removal and not a dated line replaced.
- **R2-5** `f95b70cf`: a finding's memory folder is the one Claude Code loads for its session: the git repository of the session's working folder; once that folder is gone, the repository a `.claude/worktrees` path names; else the session's own key only when it has a memory folder; else none.
- **R2-6** `81860035`: AC12's rule is unchanged (a finding whose lesson holds a code-like token its message lacks is dropped, text in no log); Justin's list now gets a `dropped` item naming the session, date and message id with no text.
The fixer reports 136 of 136 in-repo mutants killed and the dream suite at 73 passed.

### The fixer's rulings (rule on each: valid, or a finding)
1. R2-1 closes the class for every basis. A line the editor lists under a general finding is the editor's own attribution, which only the checker model judges.
2. Only the `moved_to` half of R2-14 is fixed; its `already_saved` half stays a P3.
3. **R2-2:** the script's own rewrite may take a repeat-mistakes file past its 16,000-byte budget; the budget and the 4,000-byte cap now bind only what the editor writes; once over, the file gets no new entries until retirements shrink it.
4. R2-3: the per-entry limit counts the heading too.
5. **R2-4:** a fold keeps the old line at the start of the new one. The fixer argues this is within AC45 ("removes or replaces" a dated line: a fold does neither) and that a fold can do nothing an appended line beside the old one could not. Test that argument: can words appended to a dated rule reverse or void it in place ("…, except when …", "… (no longer applies)", a second sentence), and does any script check stand in the way, or only the checker model?
6. R2-5: when a session's folder is gone and is not a `.claude/worktrees` path, its own key is used only if it has a memory folder.
7. R2-6: only the code-like drop is named on Justin's list.

## Focus
- **Do the six fixes hold?** Re-run round 2's probes (`review-2/probes/`) on this head, then vary them. Before accepting a fix, list the other ways to the same failure and probe each: rounds 1 and 2 both found a second way left open (R1-2 → R2-1; R1-3 → R2-2; R1-9 → R2-3).
- **Did a fix open something new?** The new allowances are the places to press: the fold (ruling 5); the script's rewrite exempt from cap and budget (can an editor's change hide inside what is counted as the script's rewrite? can the file grow without bound?); `memory_key` resolving through git from a `cwd` taken out of a transcript (a `cwd` that is not a folder, is a symlink, is under `~/Leorna/`, or names a repository whose key is not an allowed target); the `dropped` item on Justin's list (does anything from the finding or the message leak into it?); the session helper's prompt change.
- **Tests:** does each new test fail with its fix removed; do the clauses the fixer names have assertions that can fail.
- **Did the fixes break anything rounds 1 and 2 covered:** the round-1 fixes that touch the same functions (R1-2's duplicate and move rules, R1-3's allowlist allowance, R1-8's and R1-9's checks, R1-4's "applied needs a diff").
- Anything else you notice outside the fix commits and what they touch is P3. The earlier P3s (R1-15 to R1-31 except R1-19, R2-7 to R2-14) are follow-ups: if you find the same defect, set `repeats` to its id and add a `new_fact` when you have one.

## Output: `<evidence>/review-3/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-3/review.json`: round 3, scope "delta", from = `e3c6302a16b63092e1bddecbe4dfa841397fb9ff`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-3/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 131f9b0ad65dda6a4a157b5aefd829cebecee9be <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-3/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-3/`. Remove both by literal path at the end; give each probe case its own fresh folder rather than removing one named through a shell variable.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>` (never `worktree add` against the setup repo; never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- Run the regression gate (`regression.sh` against `evidence/dream-pass/baseline.md`) with nothing else of yours running: `cortexos-memory.test.sh` is timing-sensitive and fails under load. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- The evidence folders under `~/.hermes/plans` hold symlinks into `node_modules`: don't walk them with a recursive glob that follows links.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` covers the ACs the fix commits touch (AC12, AC17, AC18, AC27, AC28, AC45 and any other you find affected); the fresh verifier runs all of them after the loop.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
