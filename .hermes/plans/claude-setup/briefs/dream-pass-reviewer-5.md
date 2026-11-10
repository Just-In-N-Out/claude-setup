# Brief: REVIEWER 5 (delta), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 5** for Justin's setup story `dream-pass`. Rounds 1 and 2 were full reviews; rounds 3, 4 and this one review only the fix commits since the last review and what they touch. Round 4 was clean; this round exists because Justin then asked for four more fixes. You **only report**:
- no source changes, no commits, no auto-fixes; no other agents;
- never write to the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, `~/.config/systemd`, global git config, `~/.claude-setup.git` refs or GitHub;
- never install or start the dream's timer or service, never run a real dream against Justin's real home, and never call the real `claude`.

You never saw the build, the earlier reviews' work or the fixes.

## Skills to load first (Skill tool; say so in one line each)
`engineering-best-practices`, `requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer), `code-review-practice`, `security-best-practices`, `mutation-testing-discipline`.
Read the rules in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow them exactly (delta round; three trees per probe: the oldest tree that has the code, the previous round's head, head).

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git`.
- **Head:** `d0c216db3e9198b1e2add6143a73a3f40c611f5b`. **Previous round's head (your `from`):** `877c99e616e3cbc1b0f498fdf0f970941eba6ba4`. **Story base:** `131f9b0ad65dda6a4a157b5aefd829cebecee9be` (it has no `.claude/dream`; round 1's head `cae6bf88` is the oldest tree with the code).
- Review `git diff 877c99e6..d0c216db`: 6 fix commits, 9 files, about 630 added lines, and what they touch.
- **Before you start,** confirm HEAD equals `d0c216d` and that `git status --porcelain --untracked-files=all` is empty. If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/dream-pass/plan-approved.md` (read-only). "Justin's answers" is binding; its last three paragraphs (2026-11-10) record the decisions behind this round. **The rules the job must obey:** `.claude/dream/DREAM.md` in the worktree (two lines changed this round, quoted below).
- **What the story is:** a twice-daily job that reads what Justin typed in his Claude Code sessions and the pipeline's review findings, has one model helper per session list lessons, one editor change a copy of his skills, `CLAUDE.md` files and memory notes, and scripts decide what may go live as one commit, with no human reading it first. Scripts, not models, make every allow decision.
- **Earlier records:** `~/.hermes/plans/claude-setup/evidence/dream-pass/review-1/` to `review-4/` (each `review.json` and `probes/`); the fixers' answers in `fixer-1/README.md` to `fixer-4/README.md`; `fixer-4/R3-3-other-ways.txt`, `R4-1-other-ways.txt`, `retire-b-other-ways.txt`, `fixer-4/final/` and `final-2/` (mutants).

### The fixer's answer to each of the four items (all reported fixed)
- **R4-8** (`63be84c8`): the checker's prompt now names four changes that need no finding (a word-for-word move, its one pointer line in both exact shapes, a line removed as a duplicate of a whole line that stays, and the script's own rewrite of counts, stories and order), and its "yes" rule ends "traces to a finding, an order or one of those four".
- **R3-3, the fold** (`0ea6430f`): added words must start after a comma, semicolon, colon or full stop plus a space, or after a plain space; a plain space is not allowed after a number, or before "not", "no", "never", "nor", "neither" or n't, and must be followed by a letter, a digit, an opening bracket, a quote, a backtick or a dash. Stricter than review 3 suggested. Named cost: after a line ending in a number the editor must use a comma; the editor's prompt says so.
- **R4-1, the pointer's file name** (`9d1c4a33`): lower-case ASCII letters and digits, 1 to 6 words joined by single hyphens or underscores, at most 50 characters before `.md`, no other file in its folder with the same name in other capitals; the same for a new memory note's name; a new note may not sit in a subfolder; `MEMORY.md` is the pointer's place only for a new note.
- **Retire rule, option (b)** (`ad4fb406`, `913a8303`, `d0c216db`): a kind already due to retire where it would be listed is not added or moved there; it is listed once it comes back in a newer story. All three order paths (add, move, the add of a gone entry) go through the same check.
The fixer reports 231 of 231 in-repo mutants killed and the dream suite at 82 passed.

`DREAM.md` lines changed this round:
> Section 6, in the pointer line, added: "The receiving file's name is plain: lower-case letters and digits, 1 to 6 words joined by single hyphens or underscores, at most 50 characters before `.md`, and no other file in its folder with the same name in other capitals." and at its end: "(a new note's name is plain the same way), and for a note that exists in the note the text left."
> Section 7, added after the retire line: "A mistake already due to retire where it would be listed is not added or moved there; it is listed once it comes back in a newer story."

### The fixer's rulings and question (rule on each: valid, or a finding)
1. Option (b), the move case: a kind listed in a project file, seen in a second project, but already due to retire in the general file is not moved; its entry stays and retires there by its own rule.
2. AC27's "is ordered to add" now holds only for a kind not already due to retire there; AC27's text and test name are unchanged. **Question:** (a) leave AC27's text, since Justin's 2026-11-10 answer in the approved plan qualifies it (the fixer recommends this); or (b) amend AC27's text. Say whether a blind auditor reading the approved plan would call AC27 false as built.
3. **Three older tests changed fixture** (the R1-9, R2-3 and R3-1 tests), because their kinds happened to be already due to retire. Check each still pins what it pinned: run its registered mutants yourself.
4. `d0c216db` restores two mutant kills this round's own changes had cost (F9b, P5b).
5. The fold rule as described above. Accepted limits the fixer names: whitespace-only changes and a new clause after a mark still go live by design; an old line that leaves a backtick span open can get words added inside that span.
6. The name rule's bound is the longest real name (the fixer counted 451 real references and memory notes: 6 words, 49 characters). Accepted limit: a short imperative in plain characters passes as a file name (`skip-the-security-review.md`), inside a code span, naming a file that holds exactly the moved text.
7. `MEMORY.md` is the pointer's place only for a new note.

## Focus
- **Do the four fixes hold?** Re-run the earlier probes on this head (`review-3/probes/p02` pF2 for the fold; `review-4/probes/` pA and pE for names, pO1, pO2 and pO6 for the retire rule), then vary them. Before accepting a fix, list the other ways to the same failure and probe each.
- **Wrong blocks are the main risk this round: three of the four fixes make a rule stricter.** A refused edit stops the whole run and adds a try to every waiting finding; two stops park them. Measure, read-only, against Justin's real files where you can (as round 4 did, with the guard's own functions on in-memory text; nothing written, no model called):
  - the fold: for the kinds of line the dream would fold into (lines ending in a number, a version, a path, a code span, a bracket, a quote, a date in brackets as every dream-added line has), can an editor that follows its prompt always add its words? Does the prompt tell it enough to never be refused?
  - the name rule: do all existing `references/` files and memory notes that a move could target pass it (the fixer says the bound is the longest real name; check capitals, dots and digits in real names, and what happens to a move whose natural target is an existing file with a non-plain name)?
  - option (b): can a kind be starved for good (always stale by the time it has room; due to retire in the general file but live in a project file); does the first live run on real-sized data still fill and settle?
- **Did a fix open something new?** The checker's prompt now tells a model that four kinds of change need no finding: does any wording there let a model wave through more than the scripts allow, and do the scripts still decide? The fold's accepted limits (ruling 5). The name rule's accepted limit (ruling 6).
- **Tests:** does each new test fail with its fix removed; the changed fixtures (ruling 3).
- **Did the fixes break anything earlier rounds covered:** R2-4's fold cases that must still go live, R2-9's pointer cases, R3-1's bounded orders, R3-2's gone-entry add.
- Anything else you notice outside the fix commits and what they touch is P3. Earlier P3s are follow-ups (R1-15 to R1-31 except R1-19; R2-7, R2-8, R2-10 to R2-14; R3-4 to R3-11; R4-2 to R4-7 except R4-3): if you find the same defect, set `repeats` to its id and add a `new_fact` when you have one.

## Output: `<evidence>/review-5/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-5/review.json`: round 5, scope "delta", from = `877c99e616e3cbc1b0f498fdf0f970941eba6ba4`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. Severities: P0/P1 a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2 a bug a real person or agent could plausibly hit (realistic edge cases), anything breaking an AC or the session-start line, or a test that can't fail. P3 cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has. Give every P0–P2 a concrete real-use scenario and, where you can, a probe log under `review-5/probes/`.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 131f9b0ad65dda6a4a157b5aefd829cebecee9be <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-reviewer-5/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-5/`. Remove both by literal path at the end; give each probe case its own fresh folder rather than removing one named through a shell variable.
- Probe on scratch copies: a fake home and a fake `claude` as the tests do, or `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>` (never `worktree add` against the setup repo; never a `git archive` copy for suites that check what git tracks).
- Run suites and mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | command grep sending` before reading a result (a line that reads "sending SIGTERM when mem avail <= 5.00%…" with no process name is earlyoom's start banner, not a kill).
- Run the regression gate (`regression.sh` against `evidence/dream-pass/baseline.md`) with nothing else of yours running: `cortexos-memory.test.sh` is timing-sensitive and fails under load. `codex-parity.test.sh` fails `ac4`, `ac19`, `ac21` on the base.
- In the Bash tool `grep` is ugrep (use `command grep`); never `| grep -q` under `pipefail`; desktop coreutils are uutils and `mkdir` is not atomic; never `pkill -f`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes with the Bash `timeout` set above the bound.
- The evidence folders under `~/.hermes/plans` hold symlinks into `node_modules`: don't walk them with a recursive glob that follows links.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rulings[{n, valid, why}], review_json, found_else[], skill_lessons[]}`. Summaries go in the report, not in extra files. `ac_status` covers the ACs the fix commits touch (AC17, AC27, AC28, AC45 and any other you find affected); the fresh verifier runs all of them after the loop.
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]`, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: its kind, what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
