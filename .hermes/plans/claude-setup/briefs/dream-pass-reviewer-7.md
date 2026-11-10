# Brief: REVIEWER 7 (delta), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 7** for Justin's setup story `dream-pass`. Rounds 1 and 2 were full reviews; every round since reviews only the fix commits since the last review and what they touch. Round 6 found one P2; the referee stopped the loop on it, Justin answered "Fix it, review again", and this round reviews that fix. You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude`.

You never saw the build, the earlier reviews' work or the fixes.

**Be sparing:** Justin's weekly usage limit is nearly spent. Do what this brief asks and no wider exploration. If a request is refused for the limit, stop; your work so far is kept and you will be resumed.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `code-review-practice`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: the oldest tree that has the code, the previous round's head, head).

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `698311c092ba609e41b0558aad2f1d29ea9067ab`. **Previous round's head (your `from`):** `0288330c0777ecf97b604a28c58409b9bec27655`. **Story base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (it has no `.claude/dream`; round 1's head `cae6bf88` is the oldest tree with the code).
- Review `git diff 0288330c..698311c0`: 2 fix commits (`c30d0300`, `698311c0`), and what they touch. `DREAM.md` is unchanged this round.
- **Before you start,** confirm HEAD equals `698311c` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only; "Justin's answers" is binding, option (b) of the retire rule among them). **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree; section 7 covers the repeat-mistakes files.
- **What the story is:** a twice-daily job that reads what Justin typed in his Claude Code sessions and the pipeline's review findings, has model helpers list lessons, one editor change a copy of his skills, `CLAUDE.md` files and memory notes, and scripts decide what may go live as one commit. Part of it keeps three "repeat mistakes" files: a mistake kind seen in two stories is listed, and retires when it has not come back in 10 later stories. After the first run a run reads at most 150 new review lines.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-6/review.json` and `review-6/probes/` (p12 and p14 are R6-1's probes, p11 is R6-2's); the fixer's answer in `fixer-6/README.md` (its table of places), `fixer-6/final/mutants.md`, `fixer-6/probes/walk_cost.py`.

### The fixer's answer (reported fixed, commit `c30d0300`; `698311c0` adds a mutant-registry key)
- **R6-1** (P2, repeats R5-1): when more than 150 lines waited, a listed kind whose newest sighting was still unread was removed and retired for good. Now `mistakes.orders` makes **no order at all** (add, move or remove) while `mistakes.unread` finds review lines on disk that the tally has not counted (it walks the evidence again and checks it against the tally's seen list); and `apply.make_plan` passes `settled=not mistakes.unread(...)` to `mistakes.after_commit`, so a removal sets `retired=True` only when settled; otherwise the kind is only taken out and option (b) decides whether it comes back.
- The fixer says this also closes **R6-2** (a P3 of review 6: one project's backfill helper fails once, a stale two-project kind is listed in the general file and later retired for good).
- Three new tests; 8 new mutants (R6a to R6h); the fixer reports 259 of 259 killed and the dream suite at 92 passed.

### The fixer's rulings (rule on each: valid, or a finding)
1. "Wait" rather than "oldest 150 first": reading the oldest first only narrows the window; all orders wait, not only removals, because R6-2 is an add made on part of the stories.
2. AC28's retire rule and AC30's 150 lines per run are unchanged, so not a plan gap; a removal that waits is made by the first run that has counted every line.
3. Liveness: a backlog of L lines holds the repeat-mistakes orders for ceil(L/150) runs (one or two at the real pace); a review helper that fails every run holds them until it answers.
4. Cost: two more evidence walks per run, about 3 s each on the real evidence.
5. Left open by design: an add made in a run during which a review file lands, for a kind exactly 9 stories back; the enforce-line boundary for a story whose first file lands while the editor works.

## Focus
- **Does the fix hold?** Re-run review 6's p12, p14 and p11 on this head (three trees), with real file times carried into fixtures (`os.utime`), then vary: 151, 300 and 451 lines waiting; a pause that ends with a run whose helper fails; lines landing between the walk and the orders, while the editor works, and during the apply step.
- **The new rule can hold the orders. Can it hold them for good?** This is the main risk: "no order while any line on disk is uncounted" stops every repeat-mistakes update if some line can never become counted. Press on every way a line on disk could stay uncounted run after run: a line the review helper never returns or returns under another id; a line it is given but drops; a helper that fails on one particular project or one particular file every time (too long, a shape it rejects, a code-like token, a secret the scrubber drops); old-format reviews (`high`/`medium`/`low`, `file`/`line`); nested copies of another story's review; a `review.json` rewritten after it was counted (does it read as new lines again and again?); files under `superseded-*`; evidence folders that are symlinks; lines the 150 cut never reaches because the walk order starts with the same uncounted ones each run; a story folder being written during the walk. Measure read-only on Justin's real evidence (`~/.hermes/plans/*/evidence`; shapes and counts only, the head's own functions on in-memory data, nothing written, no model called, no symlinks followed): how many real lines would `mistakes.unread` report after a fake first run that counts what a helper would be given, and is any of them one that could never be counted? If orders can be held for good, say how Justin would find out (the log, the session-start line, his list).
- **What "taken out but not retired" does:** a kind removed while unsettled, then listed again, then removed again (flapping); its count, stories and enforce line; whether the file's 4,000-byte cap and 16,000-byte budget still hold through it.
- **Tests:** does each new test fail with the fix removed; are the two call sites pinned (the fixer names R6e).
- **Did the fix break anything earlier rounds covered:** R3-1's bounded orders (do waiting orders still fit the cap when they are finally made, after several held runs?), option (b), R5-1's dates, AC27, AC28, AC30 and AC6's own tests.
- Anything else you notice outside the fix commits and what they touch is P3. Earlier P3s are follow-ups: if you find the same defect, set `repeats` to its id and add a `new_fact` when you have one.

## Output: `<evidence>/review-7/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-7/review.json`: round 7, scope "delta", from = `0288330c0777ecf97b604a28c58409b9bec27655`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-7/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 131f9b0ad65dda6a4a157b5aefd829cebecee9be <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on. (`review-6/justin.json` holds Justin's answer to the last round's stop; leave it alone.)

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-reviewer-7/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-7/`. Remove both by literal path at the end; give each probe case its own fresh folder rather than removing one named through a shell variable.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>` (never `worktree add` against the setup repo; never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result (a line reading "sending SIGTERM when mem avail <= 5.00%…" with no process name is earlyoom's start banner, not a kill).
- Run the regression gate (`regression.sh` against `evidence/dream-pass/baseline.md`) with nothing else of yours running: `cortexos-memory.test.sh` is timing-sensitive and fails under load. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `xargs`, `find -exec` or `systemd-run`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound. With `--git-dir ~/.claude-setup.git` from a subfolder a pathspec is read relative to that folder: use `:(top)` paths or `git -C <worktree>`.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` covers the ACs the fix commits touch (AC6, AC27, AC28, AC30 and any other you find affected); the fresh verifier runs all of them after the loop.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
