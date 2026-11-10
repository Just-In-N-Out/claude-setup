# Brief: REVIEWER 8 (delta, the rebase), story `dream-pass` [claude-setup] (Full pipeline)

## Role
You are the fresh **reviewer 8** for Justin's setup story `dream-pass`. The review loop ended clean at round 7 (`MOVE ON: review-7 at 698311c`). A finisher then rebased the branch onto local `main` and resolved one conflict. You review **only that rebase**: is it faithful, and did the conflict resolution and the automatic merges keep both sides. You **only report**: no source changes, no commits, no other agents, nothing written outside `<evidence>/review-8/` and your scratch folder, never push, sync, merge or install, never run a real dream or the real `claude`.

**Be sparing:** Justin's weekly usage limit is nearly spent. This is a small, mechanical review: do what the brief asks and stop. If a request is refused for the limit, stop; you will be resumed.

## Skills to load first (Skill tool; say so in one line each)
`requesting-code-review` (skip its "independent reviewer subagent" and auto-fix steps), `code-review-practice`.
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and follow it: a rebase inside the loop is reviewed as `git range-diff <old base>..<previous head> <new base>..HEAD`, and `from` is still the previous round's head. Its "After MOVE ON" section says how to prove a rebase resolution.

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/dream-pass`, branch `dream-pass`, a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Previous round's head (your `from`):** `698311c092ba609e41b0558aad2f1d29ea9067ab`, on old base `131f9b0ad65dda6a4a157b5aefd829cebecee9be`.
- **Head:** `36fd44ed76f14fbe5f060458f91b9612785da691`, on new base `63f09cb6ef84c490cc990f07b98bd27d85f5089a` (= `git -C <worktree> merge-base HEAD main`; `main` has moved on since, which is not your concern).
- **Before you start,** confirm HEAD equals `36fd44e` and `git status --porcelain --untracked-files=all` is empty. If not, stop and report.
- The finisher's records: `~/.hermes/plans/claude-setup/evidence/dream-pass/finisher-1/` (`range-diff.txt`, `both-sides-proof.txt`, the suite logs). Check its claims yourself; don't take them as given.

### What the finisher reports
- 50 commits replayed; `range-diff` shows 49 as `=` and one changed: `4d634546` → `12f5792e`.
- One conflict, in `.claude/CLAUDE.md`, on the bullet that begins "**Subagents report skill lessons, the main session saves them**": `main` had changed "`references/` folder." to "`references/` folder (`~/.claude/setup/trim/`: … shows the room left)."; the branch had inserted "The dream reads the same skills and never duplicates a saved lesson." after "…that the skill doesn't already say." The finisher kept `main`'s line and inserted the branch's sentence at the same spot.
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, `.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `.hermes/skills/software-development/leorna/SKILL.md` merged automatically: `main` had moved many of their lines to `references/` files (the dream-trim story) and other sessions had edited them; the branch adds one pointer line to each.
- `.claude/CLAUDE.md` is 29,937 bytes against the dream's 30,000-byte budget.

## Your job
1. **Is the rebase faithful?** Run the range-diff yourself. Every commit but one must carry the same patch; nothing may have been added, dropped or reordered; authors and messages unchanged; no merge commits; no AI trailer.
2. **The one resolved conflict:** read the bullet on the old head, on the new base and on the new head. Both sides' words must be there, unchanged, and the sentence must still read correctly. Rebuild the resolution as `review-loop.md` describes (apply `main`'s own change of that file to the old head's file and compare with the new head's file; where the plain patch cannot apply because both sides changed one line, do it at the word level and say so).
3. **The three auto-merged `SKILL.md` files:** `main`'s text must be kept exactly and the branch's one pointer line must sit in the same section with sensible neighbours, in the main file (not lost into a `references/` file), and must still point at files that exist on the head (`references/repeat-mistakes.md` in each skill, and the general one in `feature-dispatch`). Check the frozen sections and canary facts the dream ships (`.claude/dream/conf/protected.tsv`, `conf/canary.tsv`) still match these rebased files: the story's own tests `test_ac11…`, `test_ac16…` and `test_ac36…` cover that; run those three by name on a scratch clone of the head (`bash .claude/dream/tests/run.sh <name>` under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`).
4. **Anything `main` brought that the story's code or tests read** (the `settings.json` hook groups, `manifest.txt`, `exclude.txt`, the hooks folder): did the rebase leave the branch's additions in place and in the order its own tests require (the dream's hook groups before cortexos-memory's)?
5. Don't re-review the story. Anything you notice outside the rebase is P3.

## Output: `<evidence>/review-8/review.json`
Evidence: `/home/justin/.hermes/plans/claude-setup/evidence/dream-pass/`
Write `review-8/review.json`: round 8, scope "delta", from = `698311c092ba609e41b0558aad2f1d29ea9067ab`, head = the head above, findings (an empty array when clean), in the `review-loop.md` format. P0/P1 a guard bypass, a false AC, a lost safety line or a wrong block; P2 a lost or altered line of either side, or anything that breaks an AC; P3 cosmetic or outside the rebase. Every P0–P2 needs a concrete real-use scenario.
Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 63f09cb6ef84c490cc990f07b98bd27d85f5089a <evidence>`; exit 2 means your file is wrong, fix it; 0/1/3 is the referee's verdict, not yours to act on. If it says the records do not cover the story from this base, report that line exactly.

## Environment rules
- Scratch only in a fresh folder `/tmp/claude-1000/-home-justin/e7431cef-ff41-40e3-a2ba-ca5cd54b1f13/scratchpad/dream-pass-reviewer-8/` (mkdir without -p); big things under `~/.cache/dream-pass-reviewer-8/`. Remove both by literal path at the end.
- Scratch copies via `git clone -q ~/.claude-setup.git <scratch>/x && git -C <scratch>/x checkout -q --detach <sha>`; never `worktree add` against the setup repo.
- In the Bash tool `grep` is ugrep (use `command grep`, or `/usr/bin/grep` under `systemd-run`); never `pkill -f`. With `--git-dir ~/.claude-setup.git` from a subfolder a pathspec is read relative to that folder: use `git -C <worktree>`. A foreground command is moved to the background after about 180 s: poll long runs in steps under 3 minutes.
- The machine is under heavy load from another session's browser tests; don't run the timing-sensitive regression gate (the verifier does that later).

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, evidence}], rebase_faithful: yes|no with evidence, both_sides_kept: yes|no with evidence, review_json, found_else[], skill_lessons[]}`. `ac_status` covers AC11, AC16 and AC36 (the three you ran).
Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce` is `none` or a one-line check proposal); never edit a skill or memory file. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
