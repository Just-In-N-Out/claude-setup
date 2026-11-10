# Brief: REVIEWER 4 (delta), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 4** for Justin's setup story `dream-pass`. Rounds 1 and 2 were full reviews; round 3 and this round review only the fix commits since the last review and what they touch. You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude`.

You never saw the build, the earlier reviews' work or the fixes.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `code-review-practice`, `security-best-practices`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: the oldest tree that has the code, the previous round's head, head).

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `877c99e616e3cbc1b0f498fdf0f970941eba6ba4`. **Previous round's head (your `from`):** `818600358d3c149b64799c282c07d5a6f4a4512f`. **Story base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (it has no `.claude/dream`; round 1's head `cae6bf88` is the oldest tree with the code).
- Review `git diff 81860035..877c99e6`: 8 fix commits, 9 files, about 970 added lines, and what they touch.
- **Before you start,** confirm HEAD equals `877c99e` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only; "Justin's answers" is binding and ends with his 2026-11-10 decision to have review 2's R2-9 fixed now). **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree (one line was added to section 6 this round, quoted below).
- **What the story is:** a twice-daily job that reads what Justin typed in his Claude Code sessions and the pipeline's review findings, has one model helper per session list lessons, one editor change a copy of his skills, `CLAUDE.md` files and memory notes, and scripts decide what may go live as one commit, with no human reading it first. Scripts, not models, make every allow decision.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-1/`, `review-2/`, `review-3/` (each `review.json` and `probes/`); the fixers' answers in `fixer-1/README.md`, `fixer-2/README.md`, `fixer-3/README.md`, `fixer-3/other-ways.txt`, `fixer-3/final/mutants.md`.

### The fixer's answer to each item of this round (all three reported fixed)
- **R3-1** (P2, repeats R2-2; commits `71b6059b`, `f92993b5`, `877c99e6`): the orders are now **bounded** by the 4,000-byte change cap, not exempted from it. `mistakes.orders` charges each order what `g_caps` counts for it at its largest (a removal its whole entry, an add its `max_entry_bytes`, a move its heading at both files, plus 2 bytes of blank lines and the heading of any area the order opens or empties); removals first, then adds and moves, most frequent first; what does not fit waits for a later run, unparked. A new fake editor `tests/obey.py` does exactly what the orders say at their largest size.
- **R3-2** (P2; commits `97a122bd`, `355f2c14`, `f81659cb`): a move order whose entry is no longer in the file the tally lists it in is now an **add** where the kind belongs; every order carries the same 11 fields.
- **R2-9** (a P3 of review 2, fixed by Justin's decision; commits `dd774799`, `09fb3270`): when text moves word for word into a `references/` file of the same skill, or from a memory note to another note in its folder, the move may leave exactly one line of a fixed shape, with no finding. The line added to `DREAM.md` section 6:
  > A move may leave one line where the text was, of exactly this shape: ``See `<path>` for the section "<heading>" (moved there word for word).`` (``See `<path>` (moved there word for word).`` when the moved text starts with no heading). Only for text moved word for word into a `references/` file of the same skill, or from a memory note into another note of its folder: `<path>` is the receiving file seen from the folder of the file the line is in, `<heading>` the moved text's first heading word for word, and the receiving file got exactly the moved lines and nothing else. One such line per move, nothing else on it, no finding needed; for a new memory note it goes in the folder's `MEMORY.md`, which names every note. The script checks each of these.
The fixer reports 168 of 168 in-repo mutants killed and the dream suite at 78 passed.

### The fixer's rulings and question (rule on each: valid, or a finding)
1. **R3-1, bounded rather than exempted:** the plan's Q3 (a) and `DREAM.md` section 6 say a repeat-mistakes file changes at most 4,000 bytes per run; exempting what the script orders would leave the cap nothing to count there. Effect: when more entries are due than fit (about 7 of the largest per run), the rest are ordered in the next run.
2. **R3-2:** a move whose entry is gone becomes an add where the kind belongs.
3. **R2-9:** the pointer rule covers every allowed move (an over-budget tidy, or a file already being edited for a finding); the line must match exactly (no list marker, no `~/` path, no trailing space).
4. **Question for Justin, the fixer recommends (b):** should the script still order a kind added when it is already due to retire where it would be listed? (a) leave it: listed, then retired over the next runs; (b) never order such a kind added or moved; it is listed if it comes back in a newer story; (c) mark it retired at once. Say what the plan's words support and whether (a) as built does harm.

## Focus
- **Do the three fixes hold?** Re-run round 3's probes (`review-3/probes/`, p03, p04, p09) and round 2's `p06` (qI) on this head, then vary them. Before accepting a fix, list the other ways to the same failure and probe each: every earlier round found a second way left open (R1-3 → R2-2 → R3-1).
- **The pointer line is a new way for text to go live with no finding. Press hardest here.** Can a pointer line carry a rule or an instruction (in the path, in the heading slot, through a heading the same edit first changed in the source, through a file or folder name the editor chose)? Can the "receiving file got exactly the moved lines" check be met while other text also goes live (a second file, an existing references file that already had content, text appended after the moved block, a heading that differs by whitespace or case)? Can the move be used to take a protected, canary or dated line out of a file every agent loads into a `references/` file that few load, and does any script stop that? A path that leaves the skill (`..`, a symlink, an absolute path, a `~/Leorna/` path, a library skill). The memory-note variant: `MEMORY.md` gaining a line that is not the note's own name. Many moves in one run against the caps (moved bytes are not charged to the change cap).
- **The bounded orders:** can the queue starve (an order that never fits, orders that grow while they wait, a kind that waits forever behind larger ones)? Does the first live run on real-sized data finish its backfill in a bounded number of runs? The fixer's found items: a single order over 4,000 bytes can never fit; a retired kind is never listed again; moved text is detected by exact line equality across files, so a line identical to one removed elsewhere is charged to no cap.
- **Tests:** does each new test fail with its fix removed; do the clauses the fixer names have assertions that can fail; is `tests/obey.py` a fair "does exactly what the orders say".
- **Did the fixes break anything earlier rounds covered:** R1-2 and R2-1's line accounting (the pointer line is a new accepted addition), R2-4's fold, R1-8's and R2-3's `check_copy`, R1-4's "applied needs a diff".
- Anything else you notice outside the fix commits and what they touch is P3. Earlier P3s are follow-ups (R1-15 to R1-31 except R1-19; R2-7, R2-8, R2-10 to R2-14; R3-3 to R3-11): if you find the same defect, set `repeats` to its id and add a `new_fact` when you have one.

## Output: `<evidence>/review-4/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-4/review.json`: round 4, scope "delta", from = `818600358d3c149b64799c282c07d5a6f4a4512f`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-4/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 131f9b0ad65dda6a4a157b5aefd829cebecee9be <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-pass-reviewer-4/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-4/`. Remove both by literal path at the end; give each probe case its own fresh folder rather than removing one named through a shell variable.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>` (never `worktree add` against the setup repo; never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result.
- Run the regression gate (`regression.sh` against `evidence/dream-pass/baseline.md`) with nothing else of yours running: `cortexos-memory.test.sh` is timing-sensitive and fails under load. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- The evidence folders under `~/.hermes/plans` hold symlinks into `node_modules`: don't walk them with a recursive glob that follows links.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` covers the ACs the fix commits touch (AC14, AC15, AC17, AC27, AC28 and any other you find affected); the fresh verifier runs all of them after the loop.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
