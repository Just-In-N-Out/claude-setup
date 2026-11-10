# dream-trim: trim four oversized instruction files before the dream pass starts

`pipeline=mini` · project `claude-setup` · planned 2026-11-09 against setup-repo `main` `f3c950b9` · planner: Fable 5.2 high
Worktree (builder makes it after "go"): `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/dream-trim" -b dream-trim main`
Evidence: `~/.hermes/plans/claude-setup/evidence/dream-trim/`

## Questions for Justin (the plan is written as if each recommended option was chosen)

1. **The files change many times a day, so the move is redone by script on the newest `main` right before landing. May that redone commit land without a second verifier and auditor round?**
   - a. **Yes (recommended):** land when the reviewed tool and map are unchanged, the lossless check passes on the new head and the pinned tests pass.
   - b. Only when no moved line changed meanwhile (the review-loop rule: the story's own `+`/`-` lines byte-identical); otherwise verify again.
   - c. Always verify again on the final head.
2. **Where does text moved out of the Figma project `CLAUDE.md` go?**
   - a. **Into the `figma-to-bricks` skill's `references/` folder (recommended):** already synced to both machines, same path for Claude Code, Hermes and Codex, no change to `sync.sh`.
   - b. Into the project repo's `docs/` folder: travels with the code and builders can edit it in a feature, but it needs a second landing in FigmaToBricksV2 under that repo's merge rules.
   - c. Into a new synced folder beside the copy (`~/.claude/project-docs/figma-to-bricks/`): needs new `sync.sh` code and a manifest line.
3. **Leorna's "make a PR" steps (step 7, about 19,000 characters of push rules):**
   - a. **Keep them in the main file (recommended):** push rules stay where every agent sees them; leorna ends near 50,000.
   - b. Move them to `references/make-a-pr.md` behind a pointer: leorna ends near 31,000, but a push rule is one load further away.
4. **Target sizes:**
   - a. **As listed below (recommended):** 56,000 / 75,000 / 52,000 / 56,000 characters, moving detail only.
   - b. Tighter, every file under 50,000: also moves the Figma skill's merge steps and more of the dispatcher's rules out of the main files.
   - c. Looser, every file just under 80,000: smallest change, least room for new lessons.

## Playback

1. Four instruction files are at or over their size limit, so the scheduled "dream pass" has no room to add lessons.
2. Trim them once, in two passes. Pass 1 moves whole lines into `references/` files and leaves a pointer; nothing is reworded, and a script proves nothing was lost.
3. Pass 2 merges duplicates and cuts superseded text. It rewrites text, so Justin reads its diff before it goes live.
4. Safety rules (push, authorship, approval, guards, merge policy) are never reworded or dropped.
5. Nothing that points at these files by section name or path may break.

Not in scope: other skills, other `references/` files that are already large, the global `~/.claude/CLAUDE.md` (one Docs line aside), any change to `sync.sh`.

## Acceptance criteria (all **proposed**; "go" approves them)

Tests are functions in `~/.claude/setup/trim/trim.test.sh`, run as `bash .claude/setup/trim/trim.test.sh <name>` from the worktree. Characters are counted like the existing limit test: Python `len()` of the file's text.

- AC1 (proposed): Given the pass-1 commit, when it is compared with its base, then every line that left one of the four files exists byte for byte in the `references/` file the map names, in the same order, each of the four files gained only pointer lines, and no kept line changed. Test: `ac1_pass1_is_lossless`
- AC2 (proposed): Given the pass-1 commit, then `figma-to-bricks/SKILL.md` is at most 56,000 characters, `feature-dispatch/SKILL.md` at most 75,000, `leorna/SKILL.md` at most 52,000 and the Figma project `CLAUDE.md` at most 56,000. Test: `ac2_sizes_under_target`
- AC3 (proposed): Given either pass, then every `## ` and `### ` heading the four files had at base is still there with the same text, and every pointer line names a `references/` file that exists and holds the text it points at. Test: `ac3_headings_and_pointers_resolve`
- AC4 (proposed): Given either pass, when `harness-guards.test.sh`, `review-check.test.sh` and `codex-parity.test.sh` run on the worktree, then every test that passed on the base passes on the head, compared by test name. Test: `ac4_existing_pins_still_pass`
- AC5 (proposed): Given a copy of the pass-1 result with one moved line dropped, one moved line changed by one character, one pointer removed, or one heading removed, when the lossless check runs, then it exits 1 and names the line each time. Test: `ac5_checker_catches_loss`
- AC6 (proposed): Given the pass-2 commit, then every protected safety line listed from the pass-1 commit is still in the same file, byte for byte. Test: `ac6_protected_lines_intact`
- AC7 (proposed): Given the pass-2 commit, then every line it removed or changed has a ledger row saying which kept line now carries its meaning, and that kept line exists at the head. Test: `ac7_pass2_removals_accounted`
- AC8 (proposed): Given a scratch home with a scratch setup repo and a project folder, when `land.sh` lands a trimmed project `CLAUDE.md` and `sync.sh status` runs next, then the project's own `CLAUDE.md` equals the trimmed copy and the sync does not put the old text back. Test: `ac8_land_survives_next_sync`
- AC9 (proposed) (live): Justin reads the pass-2 diff and summary (`evidence/dream-trim/pass2.diff`, `pass2-summary.md`) and says "land pass 2"; until then only pass 1 is live.

RED on the base: run the head's test file with `TRIM_SRC` pointing at a `git archive` export of the base. AC2 fails there on size, AC1/AC3 fail on the missing `references/` files. AC5 is the proof the checker can fail. Each AC also gets a terminal capture of its run in the evidence folder.

## What was measured (main `f3c950b9`, 2026-11-09 21:40)

| File | Characters now | Target | Where the weight is |
|---|---|---|---|
| `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` | 105,321 | ≤ 56,000 | Pitfalls 42,938; Step 3 36,262; Step 4 12,098 |
| `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` | 98,738 | ≤ 75,000 | Models 15,104; Rules 10,762; Phase 3b 8,905; Defect loop 8,730 |
| `~/.hermes/skills/software-development/leorna/SKILL.md` | 73,589 | ≤ 52,000 | "Doing a story" 50,204 |
| `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` | 95,470 | ≤ 56,000 | Decisions 44,195; Status 22,760; Working in this repo 18,697 |

- The weight is not in sections but in single lines: bullets of 3,000 to 13,000 characters (one line each in the skills). So the unit that moves is the **whole line**, never part of one.
- The files are live: the three skills and the project copy had 155, 54, 46 and 20 commits in the last 7 days. Two of the four already differ from the brief's byte counts, taken the same evening.
- The copy at `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` is not the source. `sync.sh` `copy_in` copies `~/Documents/FigmaToBricksV2/CLAUDE.md` over it before every commit, so an edit to the copy alone is undone by the next sync. Landing must write both (Task 6).

## Approach

**Pass 1, move only, done by a script.** A small mover reads a map (which lines, to which file, which pointer) and applies it. Because the commit is generated, bringing it up to date is a rerun on the newest `main`, not a hand merge.

Rules the mover and the checker share:
1. Only whole lines move. A moved line is byte-identical in its `references/` file, and lines keep their order.
2. **Every heading stays** in the main file, with its text unchanged. This is what keeps section-name pointers from other files working.
3. Each moved group leaves one pointer line that names the `references/` file and says in a few trigger words when to load it. New pointers go at the end of the section's kept text, never between a heading and the pointer already under it (two existing tests read "the first line after the heading").
4. When sub-bullets move without their parent, the `references/` file repeats the parent line above them (a copy; the original stays in the main file).
5. A `references/` file may hold only: moved lines, copies of base lines, headings, blank lines and a one-line header. An existing `references/` file only gains lines.

**Pass 2, merge duplicates and cut superseded text, by hand, small.**
- Scope: the four files and the `references/` files pass 1 created or extended. Nothing else.
- Candidates come from `trim-check.py dupes`: passages of 200+ characters that overlap 70% or more between two places, plus lines that mark themselves old (`superseded`, `This replaces the`, a replaced dated table).
- For each: the fullest, newest copy stays in its home (role models → feature-dispatch "Which model runs which agent"; skills per role → feature-dispatch "Skills every agent loads"; project facts → the project `CLAUDE.md`). The other place gets a one-line pointer, or the superseded line is deleted when its replacement is in the same section.
- Never touched: protected lines (below), lines the existing tests pin, headings, pass-1 pointer lines.
- At most the 40 largest candidates; the rest go to `evidence/dream-trim/follow-ups.md`. Pass 2 has no size target: pass 1 alone meets the targets.
- Every removal or change gets a row in `evidence/dream-trim/pass2-ledger.md`: file, the old line (first 80 characters and its sha1), `duplicate-of` or `superseded-by`, and the kept line that carries the meaning.

**Protected lines (never reworded or dropped in pass 2).** `trim-check.py protect` writes the list from the pass-1 commit:
- every line of these sections: leorna "Hard rules" and step 7 ("make a PR"); feature-dispatch "Merge policy per project", "Skills every agent loads" and "Phase 3b"; figma-to-bricks "Step 4: Merge into main"; the project `CLAUDE.md` "Working in this repo";
- plus any line in the four files or their `references/` that pairs a rule word (`never`, `don't`, `do not`, `only when`, `must`, `refuse`) with a safety word (`push`, `merge`, `force`, `author`, `identity`, `Co-Authored`, `gh auth`, `credential`, `approv`, `"go"`, `guard`, `secret`, `token`, `domain`, `CLAUDE.md`, `stash`, `reset`, `prune`, `delete`).

## Move list (line numbers are those of `f3c950b9`; the builder turns each into an anchor: the line's first 60 characters)

### figma-to-bricks/SKILL.md (105,321 → about 54,000)
| Lines | What | To |
|---|---|---|
| Step 3, PLANNER sub-bullets of 600+ characters: L73, L75, L77, L78, L80, L89, L90, L92, L93, L94 (22,222) | link and tab rows, who owns the element, hover copies, variant IR keys, laptop-width measuring, pinned tests, golden payloads, widening a recognizer, blast radius, per-element acceptance | new `references/planning-checks.md` |
| Pitfalls, bullets of 600+ characters that are not already pointers: L184, L186, L192, L193, L194, L196, L198, L200, L204, L208, L209, L215, L217 (30,508) | Bricks output and hand-built CSS, fixtures and text, fonts, process and evidence | new `references/pitfalls.md`, under four topic headings |

Stays: Steps 1, 2 and 4 whole; the PLANNER line, the short planner bullets and the Docs & records list; BUILDER, CHECKER, FINISHER and before/after picture lines; the Pitfalls lines that are already pointers (L188, L206, L211, L216) and every Pitfalls bullet under 600 characters; Reporting; Verification.

### feature-dispatch/SKILL.md (98,738 → about 73,500)
| Lines | What | To |
|---|---|---|
| "The board" L67–L103 (5,680); L66 (the helper rule) stays | board states, helper calls, reminders | new `references/board.md` |
| "Which model runs which agent" L137–L148 (4,883) | superseded tables, what to do at an Opus or Sol limit, an explicit model pick, "wait" | new `references/model-routing.md` |
| same section L159–L163, L165 (2,986) | checking the delegation setting took effect | same file |
| "Agent Defect Loop" L215, L216, L222, L223, L224, L231 (4,656) | records-only finisher, baseline-only holds, accepted limits, reopened findings | new `references/agent-defect-loop.md` |
| "Ask to reset the main chat" body and "What are we working on?" body (3,520) | main-chat housekeeping | new `references/main-chat-housekeeping.md` |
| L55, L330, L356, L399, L401 (4,814) | recommendation grants, reusing an old copy, evidence scope in corrective handoffs, a pinned test that stops the builder, "why is it paused" | new `references/dispatch-edge-cases.md` |

Stays: the pipeline pick; the rest of "Rules for the main chat"; the models paragraph, the role table and L135–L136, L149–L158, L164, L166–L167; "Skills every agent loads"; Phase 1 (its `If you learn something reusable` line is pinned by a test); Phase 2; Phase 3 and 3b; Phase 4; Phase 5's first lines; "Merge policy per project"; Pitfalls; Verification.

### leorna/SKILL.md (73,589 → about 50,100)
| Lines | What | To |
|---|---|---|
| Step 4 gate detail L109–L112 (11,059); L108 stays | host prerequisites, control-plane and client `make check` | new `references/gates.md` |
| Step 4b L114–L123 (8,420); L113, L124, L125 stay | evidence capture by role, the terminal capture recipe, opening logs | new `references/evidence-capture.md` |
| "Live acceptance setup" L155–L161 (4,420); the heading and the existing pointer L163 stay | the seven setup steps | existing `references/live-acceptance-setup.md`, appended under a new heading |

Stays: Step 1, Reading ClickUp, Hard rules, the role lines of "Doing a story" (the `**Skill lessons` line is pinned by a test), steps 0–3, 5, 6 and all of step 7, the two "what may leave the machine" lines of 4b, and every later section.

### Figma project CLAUDE.md (95,470 → about 54,000)
| Lines | What | To |
|---|---|---|
| Status, "Current build" bullet L10–L180: its first two lines and the newest 5 build entries stay; the older entries move (about 14,300) | per-build feature log | new `figma-to-bricks/references/project-status-log.md` |
| "Decisions the user made": the 14 decisions of 800+ characters (L550, L655, L691, L754, L774, L788, L836, L849, L869, L882, L897, L906, L923, L958). Each decision's own top line(s) stay; its nested lines move (about 29,500) | the detail under each decision | new `figma-to-bricks/references/project-decisions.md`, each under a copy of its decision line |

Stays: every decision's headline, so each agent still sees that the decision exists; "Build general logic", "Architecture rules", "Working in this repo", "Debugging a user's design"; the rest of Status. Pointers in this file use the full path `~/.hermes/skills/software-development/figma-to-bricks/references/<file>.md`, the same on both machines.
New decisions and new status lines still go into `CLAUDE.md` as today; the finisher's standing permission to write it is unchanged. A change to an old decision's moved detail is written under its headline in `CLAUDE.md` (the newer line wins).

## What points at these files (found by grep; none breaks while headings stay)

- **Tests that pin text** (must still pass, AC4):
  - `~/.claude/hooks/tests/harness-guards.test.sh` L1100–1104, L1118–1120: the `If you learn something reusable` line in feature-dispatch is one line and names the lesson fields; leorna has a `**Skill lessons` line; feature-dispatch is under 100,000 characters.
  - `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh` `ac12_docs_name_the_review_loop` and `ac14_feature_dispatch_under_limit`: feature-dispatch and leorna name `review-check.sh` and lack two old phrases; `## Phase 5: Live check` and `## Stop, pause and notification controls` are each followed by their pointer; `**Out of steps:**` and `**Needs a decision:**` are still in feature-dispatch.
- **Section names used from other files:** "Skills every agent loads" (leorna, figma-to-bricks, `mini-pipeline.md`, `~/.hermes/memories/USER.md`); "Phase 3b" (figma-to-bricks, `mini-pipeline.md`); "Which model runs which agent" (leorna); "Merge policy per project" (`git-commit-rules`); "Phase 4: Report" (`ux-visual-review`); "Phase 5: Live check", "Stop, pause and notification controls", "Things agents found" (their own `references/` files); leorna "Doing a story → step 7" (leorna Hard rules, about 70 old briefs); project "Decisions the user made" (`receiving-code-review`, about 20 old briefs), "Architecture rules", "Working in this repo", "Build general logic" (old briefs and plans).
- **Paths:** `~/.claude/CLAUDE.md` line 10 and its generated copy `~/.codex/AGENTS.md` line 53 name `feature-dispatch/SKILL.md` and three of its `references/` files; all four paths stay. No hook, `feature-dispatch/scripts/*.sh` or `~/.codex` file reads these files' text apart from the two test files above.
- Old briefs, plans and session records keep their old wording: they are history and are not rewritten.

## Tasks

0. **Baseline.** Make the worktree. Run the three suites of AC4 on the base and save the tally by test name to `evidence/dream-trim/base-pins.txt`. Save the four files' sizes.
1. **Checker first** (`test-driven-development`; it is a guard, so `mutation-testing-discipline` for AC5). Write `.claude/setup/trim/trim-check.py` with the modes `pass1`, `size`, `headings`, `protect`, `dupes`, `pass2`, and `.claude/setup/trim/trim.test.sh` with the eight named tests. Fixtures are small made-up files in a scratch folder, never the live files. Prove AC5's four cases fail the checker.
2. **Mover and map.** Write `.claude/setup/trim/move-to-references.py` and `.claude/setup/trim/maps/dream-trim.json` from the move list above (anchor, line count, target file, target heading, pointer text). The mover stops with an error when an anchor is missing or matches twice. Pointer lines are the only new prose; keep each to one line built from the moved lines' own lead words.
3. **Pass 1.** Run the mover in the worktree and commit the result as one commit (`trim: pass 1, move to references (lossless)`). AC1, AC2, AC3, AC4 pass. If a target is missed, add the next-largest non-protected, non-pinned bullet to the map and say so in the report; never shorten a line.
4. **Pass 2.** Write the protected list, run `dupes`, make the merges and cuts with the ledger, and commit as a second commit (`trim: pass 2, merge duplicates`). AC3, AC4, AC6, AC7 pass. Write `pass2.diff` (`git diff --word-diff` of that commit) and `pass2-summary.md` (counts, characters saved, the ten biggest changes in plain words).
5. **`land.sh`** (`.claude/setup/trim/land.sh`, takes the commit to land) with AC8's scratch test. It does, in order:
   1. takes `sync.sh`'s own lock (`mkdir ~/.claude-setup.git/setup-sync.lock`, released by a trap), so no sync commits and no `copy_in` runs while it lands;
   2. reads `main`'s sha, rebases the tool commit onto it, takes `main`'s version of the four files and their `references/`, reruns the mover and recommits pass 1;
   3. runs `pass1`, `size`, `headings` and the AC4 suites; any failure stops it with the lock released and nothing merged;
   4. checks the live copies of the touched paths under `$HOME` have no uncommitted change; if they do, it stops (another session is mid-edit) and is rerun after the next sync;
   5. `git merge --ff-only` into `main`, then copies the trimmed `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` over `~/Documents/FigmaToBricksV2/CLAUDE.md` and `cmp`s them;
   6. releases the lock. It never stashes, resets, forces or edits another session's files.
6. **Landing (finisher, then main session).** `~/.claude/setup/sync.sh pull` first, so every session's edits are on `main`. Run `land.sh` for pass 1; if `main` moved or a live file was dirty, rerun. Then one `~/.claude/setup/sync.sh` pushes it. Check: `main` and `origin/main` hold the commit, the four live files are at or under target, the project file equals its copy. Pass 2 stays on the branch until Justin's "land pass 2" (AC9), then lands the same way: rebase, AC3/AC4/AC6/AC7 again, `--ff-only`, sync.
7. **Docs & records (one line):** fold the tool's path into the existing "Keep skills lean" sentence of `~/.claude/CLAUDE.md`, add one line to `figma-to-bricks/references/rules-summary.md` naming the two new project files, and write `evidence/dream-trim/follow-ups.md`.

## Touched files

- Changed: the four files in the table above; `leorna/references/live-acceptance-setup.md` (appended); `figma-to-bricks/references/rules-summary.md` and `~/.claude/CLAUDE.md` (one line each, Task 7); `~/Documents/FigmaToBricksV2/CLAUDE.md` (the live source of the project copy, written by `land.sh`).
- New: `figma-to-bricks/references/{planning-checks,pitfalls,project-status-log,project-decisions}.md`; `feature-dispatch/references/{board,model-routing,agent-defect-loop,main-chat-housekeeping,dispatch-edge-cases}.md`; `leorna/references/{gates,evidence-capture}.md`; `~/.claude/setup/trim/{trim-check.py,move-to-references.py,land.sh,trim.test.sh,maps/dream-trim.json}`.
- Not touched: `sync.sh`, `manifest.txt` (both new places are already covered by `.hermes/skills/**` and `.claude/setup/**`), hooks, `feature-dispatch/scripts/`, `~/.codex`.

## Order with "dream-pass"

Pass 1 of dream-trim lands first: figma-to-bricks is over the limit today, so dream-pass cannot add its pointer line there until the trim is in. The order is not fragile, because the mover works by anchor and is rerun on the newest `main`: if dream-pass lands in between, its pointer line and `references/repeat-mistakes.md` are simply part of the base. Two things for the dream-pass plan: its pointer lines must not be named in any trim map, and it can reuse `trim-check.py size` for its own "is there room" check. Pass 2 can land before or after dream-pass.

## Risks

- **A session edits a moved line while the trim lands.** Its Edit fails with "string not found" (the line is now in `references/`); the agent must reread. Nothing is lost, and the lock plus the dirty-file check keep the landing itself from overwriting an unsynced edit.
- **The Mac has unsynced edits to the same files.** Its next sync reports `CONFLICT`. Fix: take the Mac's text for the four files, rerun the mover there, sync. Landing while the Mac is idle avoids it.
- **`land.sh` holds the sync lock.** A sync started in those seconds says "another sync is running; try again in a minute". If `land.sh` dies, `sync.sh` clears a lock older than 10 minutes.
- **A pointer too vague to trigger a load.** An agent may skip the reference. Pointers carry the moved lines' own lead words, and decisions keep their headline in `CLAUDE.md`.
- **Pass 2 is judgement work on files every agent loads.** It is held behind the protected list, the ledger and Justin's own read, and lands separately so pass 1 does not wait for it.
- **Size of the job.** This is at the top of Mini: three small scripts, a landing script and two landings. Pass 1 is mechanical and fits Mini. If Justin wants two full review rounds on pass 2, that part should run as Full.

## Other things found

- figma-to-bricks `SKILL.md` is over Hermes' 100,000-character limit today (105,321) and no check fails: the only size test (`harness-guards.test.sh` L1118–1120, `review-check.test.sh` ac14) covers feature-dispatch. What Hermes does with an over-limit skill was not checked. Medium.
- `sync.sh` `copy_in` overwrites `~/.claude/project-docs/<name>/CLAUDE.md` from the project folder before every commit, so a setup story that edits only the copy is silently undone. `~/.claude/setup/mac.md` line 16 says the copy happens but not that the project file wins. Low (planned around here).
- Two `references/` files are already large and have no size check: figma-to-bricks `testing-pitfalls.md` 74,847 bytes and `live-site-reading.md` 51,958. Low.
- The project `CLAUDE.md` Status log holds 34 build entries of roughly 500 characters each, while the figma-to-bricks skill says Status gets "one feature line" per merge: the finishers' entries are several lines long, which is how the file grew. Low.
- Where Hermes enforces the 100,000 limit was not found by a quick search of `~/.hermes/hermes-agent`; the number comes from `~/.claude/CLAUDE.md` and the existing test. Low.

## Justin's answers

Approved by Justin 2026-11-09. His message was "Continue sorry", sent after both plans and their questions were shown; the main session read it as "go" with every recommended option. Q1 (a): a redone pass 1 may land without a second verifier and auditor round when the reviewed tool and map are unchanged and the lossless check and pins pass. Q2 (a): text moved out of the project CLAUDE.md goes to the figma-to-bricks skill's references/. Q3 (a): Leorna's "make a PR" steps stay in the main file. Q4 (a): target sizes as listed. Pass 2 still waits for his "land pass 2" (AC9, live).
