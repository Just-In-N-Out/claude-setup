# dream-coding-only: the dream reads only sessions about coding

`pipeline=mini` · project `claude-setup` · planned 2026-11-25 18:15 EST on setup-repo `main` `0d39171f` · evidence folder `~/.hermes/plans/claude-setup/evidence/dream-coding-only/`

Nothing is built yet. This plan is written as if every recommended option below is chosen: "go" accepts them and the proposed acceptance criteria.

## Questions for Justin ("go" accepts the recommended option of each)

**Q1. When the helper cannot tell whether a session is about coding (an even split, or too little to judge), what happens?**
- **(a) Recommended: skip it.** You said only coding messages should be read, and you accepted losing a coding lesson inside a mixed session. A wrong skip loses a lesson you will say again if it matters, and the log names the skip with its reason. A wrong read puts personal text into your agent files and questions on your list, which is what this story stops.
- (b) Read it. Nothing is lost, but a half-and-half session like the career chat's neighbours can still leave non-coding notes.

**Q2. Who decides "about coding"?**
- **(a) Recommended: the session helper, in the call it already makes.** It answers `coding: true/false` with a short reason next to its findings, and a script throws away everything from a session it marks false. No extra model call: a run costs what it costs now (the first dry run was 13 calls, $2.17, 8 of them session helpers).
- (b) A separate small call before the helper. One more call for every session. On Opus 5.5 xhigh it reads the same digest, so it costs about as much as the helper itself; on a smaller model it needs a second model pinned in `conf/models.conf` and a change to the rule that every dream call runs on exactly one model.
- (c) A script rule with keywords. Free, but the career session itself says "run two planner agents" and "my cloud project", and setup chats say things like "where is the leorna folder". Keywords would misjudge both.

**Q3. How is the real career session checked after this lands (AC12)?**
- **(a) Recommended: you start one dry run right after landing** (`systemctl --user start dream.service`, about $2 and 20 minutes) and read the new `would-log-entry.md`. A dry run reads the 8 newest unread sessions and never moves markers; today the career session is 7th of those 8, so two more new sessions with a typed message push it out. The main session checks its place first with the no-model command under "Tests and validation".
- (b) Add a small command, `dream judge <transcript>`, that asks the helper about one session (one real call) and prints the verdict. It works whenever you want and for any session, but it is new code this story does not otherwise need.
- (c) No check on the real session: the three made-up digests of AC10 are enough.

## Playback

You asked that the dream read "only the messages that have to do with codinf and that are on this laptop". Your choices on 2026-11-25: this desktop only, judged per session, Mini pipeline.

So: a session that is mostly not about coding is skipped whole. Coding means code, tests, bugs, agents, tools, the terminal and this machine's setup, the Claude and Hermes setup, and the pipeline. The case this must stop is the first dry run (2026-11-25, `~/.cache/dream/20261125-173709/`): of 8 sessions, the only one with findings was the resume and career chat `5080910a-9445-46fa-ad7e-bf7e748286b6`. It gave 6 findings, 3 passed the bar (all 3 already in `career-profiles.md`) and 3 became questions for your list.

"On this laptop" needs no code change. The dream already reads only transcripts on this disk, and the Mac's transcripts never come here. AC8 adds the test that proves it.

## Acceptance criteria (all **proposed**: Justin gave none; "go" approves them)

- AC1 (proposed): Given a session whose helper answers `coding: false` and still returns findings with true quotes (a stated correction, an implied preference and an ambiguous message), when a live run ends, then no finding from it is saved or left waiting, no pending candidate and no item on Justin's list comes from it, the editor is never started and no target file changes. Test: `test_coding_ac1_a_session_not_about_coding_gives_nothing_even_when_the_helper_returns_findings`
- AC2 (proposed): Given a mixed session (four messages about a resume, one coding correction), when the helper answers `coding: false` and returns the coding correction as a finding, then nothing from the session is saved; and when the same session is answered `coding: true`, the correction goes live as it does today. Test: `test_coding_ac2_a_mixed_session_follows_its_verdict_whole`
- AC3 (proposed): Given a live run that skipped a session, then the session's marker stands after the last line the helper was shown, a second run with nothing else new starts no model call, and the log entry holds one line for it of the shape `session <id> (<project>): N entries, skipped: not about coding (<reason>)` with the reason on one line and at most 120 characters, while the "Read:" count and the corrections rate leave that session's messages out. Test: `test_coding_ac3_a_skipped_session_moves_its_marker_and_the_log_names_it_with_the_reason`
- AC4 (proposed): Given a session that was skipped and later grew new typed messages, when the next run reads it, then the helper is shown only the new messages, and when it answers `coding: true` a stated correction in the new part goes live, while nothing of the old part is sent or used again. Test: `test_coding_ac4_a_resumed_session_is_judged_on_its_new_part_only`
- AC5 (proposed): Given a helper answer whose `coding` is missing or not true/false, then nothing from that answer is used, the session's marker does not move, the log's "Dropped" line says the session is read again next run, and the next run sends the same messages again. Test: `test_coding_ac5_an_answer_without_a_verdict_is_not_used_and_the_session_waits`
- AC6 (proposed): Given a dry run in which a session is skipped, then `would-log-entry.md` holds that session's "skipped: not about coding" line, and no marker, no file under `local/` except `last-run.json`, and no live file changes. Test: `test_coding_ac6_a_dry_run_shows_the_skip_and_moves_nothing`
- AC7 (proposed): Given new review findings in an evidence folder and a run whose only session is skipped, then the review helper is sent every new review line and the tally counts each line once, exactly as in a run with no session at all. Test: `test_coding_ac7_review_lines_are_sorted_the_same_when_every_session_is_skipped`
- AC8 (proposed): Given a home folder with a main-session transcript, a subagent transcript, a transcript saved outside `~/.claude/projects/`, and a `-Users-…` project folder that holds only memory notes, then the dream lists only the main-session transcript, and after a real `sync.sh` run the setup repo tracks no file matching `.claude/projects/**/*.jsonl`, so no transcript can travel from the Mac. Test: `test_coding_ac8_only_this_disks_main_sessions_are_read_and_sync_carries_no_transcript`
- AC9 (proposed): Given the landed files, then the session helper's schema requires `coding` (true/false) and `coding_reason` (text) and every helper call sends that schema, the helper's prompt says to judge the subject and not the tools, to answer false when it cannot tell, and to return no findings when false, `DREAM.md` section 2 and the "Dream Pass" section of `~/.claude/CLAUDE.md` each say the dream reads only coding sessions on this desktop, and `~/.claude/CLAUDE.md` stays under 36,000 bytes. Test: `test_coding_ac9_rules_prompt_and_schema_say_coding_sessions_only`
- AC10 (proposed): Given the real session helper on this machine and three made-up digests (one about a failing test and a linter rule; one about writing a resume that also says "run two planner agents"; one with four resume messages and one coding correction), then the helper answers `coding` true, false, false, each with a reason. Test: `test_live_coding_verdict_on_three_made_up_digests`
- AC11 (proposed): Given the story's head, then the setup repo's other suites give the same pass tally and the same failing names as on the story's base, and the dream's own suite passes every test it passed on the base (base: 101 tests, 100 passed, the one failure named under "Tests and validation"). Test: `regression_existing_suites_match_the_base_tally`
- AC12 (proposed) (live): Given a dry run Justin starts while session `5080910a` is among the 8 sessions it reads, then `~/.cache/dream/<run>/would-log-entry.md` shows `session 5080910a-9445-46fa-ad7e-bf7e748286b6 (claude-setup): 16 entries, skipped: not about coding (…)`, and the entry holds no "Already saved" line from `career-profiles.md` and none of the three questions about August to December, 5 websites or customers. Check: Justin reads that file.

## What the planner found (2026-11-25, on `0d39171f`)

- **Where a session's findings enter:** `lib/dreamlib/run.py`, the loop after `agents.session_helpers(...)` (about lines 150 to 170). For each session it calls `bar.check(...)`, which also adds pending candidates and list items, then saves the marker with `state.markers_after(r, used, …)` and counts the typed messages. A skipped session must leave this loop before `bar.check`.
- **The helper call:** `agents.session_helpers` sends `prompts/session-helper.md` plus `DREAM.md` sections 3, 4, 8 and 9, with `prompts/session-helper.schema.json`. The schema today requires only `findings`.
- **The log entry:** `lib/dreamlib/log.py`, `entry(...)`. It lists `unsettled["log"]["sessions"]`; `unsettled["log"]` is saved in `local/unsettled.json` in live mode and emptied after the dream commit, so a `skipped` list beside `sessions` survives a stopped run the same way.
- **This desktop only, already true in three places:** `state.session_files` reads only `<HOME>/.claude/projects/*/*.jsonl`; `.claude/setup/manifest.txt` syncs `.claude/projects/*/memory/**` and no transcript (the repo tracks one `.jsonl`, a Codex test fixture); and `run()` exits 4 where `~/.claude/dream/local/` is missing, a folder `exclude.txt` keeps out of sync, so the Mac never runs the dream. On this disk the 13 `-Users-justin-…` folders hold memory notes only. No test proves the first two: AC8 adds it.
- **Review findings never pass the session helper:** `extract.review_lines` and `agents.review_helpers` are a separate path. No change there; AC7 pins it.
- **Justin's list is clean:** `~/.claude/dream/justin-list.md` and `dream-log.md` hold only their headings, `state/pending.json` has no candidate and `local/unsettled.json` does not exist. The dry run wrote nothing live, so there is nothing to clean up.
- **Sizes:** `~/.claude/CLAUDE.md` is 32,064 bytes of its 36,000 budget; the new words add about 110.
- **The career digest shows why keywords fail:** its first message asks to "run two planner agents" and to put documents "in my cloud project". The subject is a resume; the tools are agents.

## Approach

1. **The helper gives a verdict.** The schema gains two required fields: `coding` (boolean) and `coding_reason` (string). The prompt gains this paragraph, before "Return a finding only for…" (the builder may tidy the wording but keeps its four rules):

   > First decide what this session is about. `coding` is true when most of Justin's messages in the digest are about software work: code, tests, bugs, agents and how they work, tools, the terminal, this machine's setup, his Claude and Hermes setup, the pipeline. It is false when most of them are about something else (a resume or career documents, school, personal writing, money, health, general questions), even when agents, files or a repo were used to do that work: judge the subject, not the tools. Judge his messages only, never the context blocks. When you cannot tell (an even split, or too little to judge), answer false. `coding_reason` names the subject in at most 12 words, with no name, no quote and no personal detail ("resume and career documents"). When `coding` is false, return `"findings": []`.

2. **The script enforces it** (`run.py`, in the per-session loop, after the `res.ok` check):
   - `coding` is not exactly true or false: treat the answer like a failed helper. Add `"helper for session <id8> gave no coding verdict; read again next run"` to the dropped list and move nothing.
   - `coding` is false: do **not** call `bar.check`. Save the marker exactly as for a read session (`state.markers_after(r, used, eff.get(r.key))`), append `{session, project, entries, reason}` to `unsettled["log"]["skipped"]` with the reason passed through `log.cut(…, 120)` ("no reason given" when empty), and add nothing to `typed`, `corrections` or `sessions`.
   - `coding` is true: today's path, unchanged.
3. **The log** (`log.py`, `entry`): after the sessions it read, one line `- Skipped: N session(s) not about coding (nothing from them is used; their markers move)` and under it one line per session in the shape AC3 gives. No such lines when nothing was skipped, so today's entries stay byte for byte. The reason is model text: it is cut to 120 characters, and the whole entry already passes `guards.log_secrets` before anything is written.
4. **The marker.** It moves past what the helper was shown, by the same code as a read session, so a skipped session is never read again and costs no later call. Two cases are judged part by part, each new part on its own: a session resumed later (AC4), and a session too long for one digest (over 120,000 characters), whose rest is judged at the next run. A coding session resumed with a non-coding chat has that new part skipped; a skipped session resumed with coding work has the new part read. Nothing is stored about the old verdict.
5. **Dry run:** unchanged rule. Nothing moves; the skip shows in `would-log-entry.md`.
6. **Not built (say so if you want one):** no switch to force a skipped session to be read, and no `dream judge` command (Q3 b).

## Tasks (worktree `~/.claude-setup-wt/dream-coding-only`, branch `dream-coding-only`; test first; one commit per task with explicit paths, personal identity, no AI trailer)

Paths below are `$HOME`-relative and the same in the worktree. Forecast for the builder: 60 to 100 minutes, most of it the two suite runs.

1. **Worktree and base.** `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/dream-coding-only -b dream-coding-only main`; record the base commit. If `main` is no longer `0d39171f`, run `git diff --name-only 0d39171f HEAD -- .claude/dream .claude/CLAUDE.md` and re-read any file it names before relying on the line numbers above. Record the regression baseline on the base before any edit: `bash .claude/dream/tests/regression.sh --record <evidence>/baseline.md` in the fresh worktree.
2. **The fake helper answers like an obedient one.** In `tests/fake-claude`, the session-helper answer gets `coding: true` and `coding_reason: ""` when the scenario gives neither (a scenario's own `"coding": false` or `"coding": null` is kept as given). Document both in its header. Run the whole suite: the tally must equal the base tally (this commit changes no behaviour).
3. **Skip tests, red first.** New file `tests/test_coding.py` (class `CodingTests`, built on `fakehome.FakeHome` like `test_stages.py`) with the tests of AC1 to AC7. Each must fail on its own assertion before task 4, not on an import or setup error; capture the red run. Fixture notes: AC1 and AC2 give the helper findings whose quotes really are in the typed messages, so the bar would pass them; AC2's session has four made-up resume messages and one message "No, always run the linter before every commit, please."; AC3 gives a reason of 200 characters with a line break in it; AC5 uses `"coding": null` and also a scenario with `"coding": "yes"`; AC7 compares the review helper's input and `state/tally.json` with a second fake home that has the same evidence file and no session. Use made-up text only, never words from Justin's real career session.
4. **Make them pass.** The schema and prompt (Approach 1), `run.py` (Approach 2), `log.py` (Approach 3). Then the whole suite.
5. **This desktop.** The AC8 test in `tests/test_state.py`: `state.session_files` on a fake home with the four kinds of file AC8 names, then `FakeHome.sync()` (the real `sync.sh` against the fake repo, with the checkout's `manifest.txt` and `exclude.txt` if the fake home does not already use them) and `git ls-files` holding no `.claude/projects/**/*.jsonl`. It should pass on the base: it is a pin, not a fix. Say so in the report.
6. **Docs and the AC9 test** (in `tests/test_docs.py`, red first on the two doc lines):
   - `DREAM.md` section 2, one new bullet: "Only sessions about coding (Justin, 2026-11-25): code, tests, agents, tools, this Claude and Hermes setup, the pipeline. The session helper judges the new part of each session by Justin's messages, the subject and not the tools used. One that is mostly about something else, or that it cannot tell, is skipped whole, a coding lesson inside it included: nothing from it is used, its marker moves, and the log names it with the reason." Section 12 gains the words "sessions skipped as not about coding, with the reason" in its list.
   - `.claude/CLAUDE.md`, "Dream Pass": "which rereads new typed messages and review findings" becomes "which rereads new typed messages from coding sessions saved on this desktop (a session mostly about something else is skipped whole; user, 2026-11-25) and review findings". Check `wc -c` stays under 36,000.
7. **The real-model test** (AC10) in `tests/test_agents.py`, beside `test_live_headless_calls_are_isolated_and_confined` and built the same way (the real `claude`, three calls through `agents.session_helpers`). It asserts each call is `ok`, the three verdicts, and that each reason is non-empty text; it prints the reasons. Run it once: `bash .claude/dream/tests/run.sh --live test_live_coding_verdict_on_three_made_up_digests`. If a verdict is wrong, fix the prompt wording, not the digests, and say what changed.
8. **Mutants.** Add three rows to `tests/mutants.py` and run `bash .claude/dream/tests/mutants.sh <evidence>/mutants.md MC1 MC2 MC3` (it runs each test under the 4 GB cap). All three must be KILLED:
   - MC1, the verdict is ignored (the `coding` false branch never taken): killed by the tests of AC1 and AC2.
   - MC2, a skipped session's marker is not saved: killed by the test of AC3.
   - MC3, a missing verdict is read as true: killed by the test of AC5.
9. **Gates and captures.** The whole dream suite under the cap, the regression compare, one terminal capture per criterion in `<evidence>/`, then stop at `ready-for-review` with the branch, base and head.

## Tests and validation

- Dream suite: `systemd-run --user --scope -q -p MemoryMax=4G -p MemorySwapMax=0 bash .claude/dream/tests/run.sh` (about 4 minutes). **Base tally, measured by the planner on `0d39171f` in the live folder: 101 tests, 100 passed, 1 failed.** The failure is `test_ac36_pointer_lines_and_docs_are_in_place` ("figma-to-bricks/SKILL.md mentions the tally"); it is not this story's and must fail the same way, or pass, on the head. No earlyoom kill during that run.
- Other suites: `bash .claude/dream/tests/regression.sh <evidence>/baseline.md` prints `ok 1 - regression_existing_suites_match_the_base_tally`.
- Real model: the `--live` command in task 7 (three small real calls each time it is run; the builder, the verifier and the auditor each run it once).
- A command that dies with SIGTERM, exit 143 or 137, or "Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | /usr/bin/grep -E 'sending SIG[A-Z]* to process'` before reading it as a result.
- Before asking Justin for his dry run, the main session checks the career session's place with no model call (it prints the sessions the next run would read, newest first; `5080910a` must be in the first 8):

  ```
  python3 -B -c "import sys; sys.path.insert(0,'/home/justin/.claude/dream/lib'); from dreamlib import paths,state; e=paths.Env(); print([r.session[:8] for r in state.scan(e,state.load_cursors(e),e.now()).reads[:8]])"
  ```

## Landing

As the earlier setup-repo stories did (`ac-verification.md`, "setup-repo stories"): the finisher commits, rebases the branch on the setup repo's local `main` (keeping both meanings if the "Dream Pass" line of `CLAUDE.md` moved), reruns the dream suite, and stops. No `sync.sh` between that rebase and the merge, because every sync moves `main`. The main session then runs `git --git-dir=$HOME/.claude-setup.git merge --ff-only dream-coding-only` and one `~/.claude/setup/sync.sh`, which takes its own lock, rebuilds `~/.codex/AGENTS.md` from the new `CLAUDE.md` and pushes. Nothing is installed or restarted: the units and `local/` do not change, the mode stays dry-run and the timer stays off.

**Docs & records:** `.claude/setup/desktop.md` "Dream pass" gets the same "from coding sessions saved on this desktop" words as `CLAUDE.md`; `~/.codex/AGENTS.md` is rebuilt by the landing sync; this plan gets a "Landed" line with the commit; the "Other things found" below go to `<evidence>/follow-ups.md`.

## Touched files

- `.claude/dream/prompts/session-helper.md`, `.claude/dream/prompts/session-helper.schema.json`
- `.claude/dream/lib/dreamlib/run.py`, `.claude/dream/lib/dreamlib/log.py`
- `.claude/dream/tests/fake-claude`, `tests/test_coding.py` (new), `tests/test_state.py`, `tests/test_docs.py`, `tests/test_agents.py`, `tests/mutants.py`
- `.claude/dream/DREAM.md`, `.claude/CLAUDE.md`, `.claude/setup/desktop.md`

Not touched: `state.py`, `extract.py`, `bar.py`, `agents.py`, `apply.py`, `guards.py`, `conf/`, the units, the hooks.

## Risks and trade-offs

- **A wrong skip is final.** A setup chat judged "not coding" is never read again. The prompt names this machine's setup, the terminal and tools as coding, the log names every skip with its reason, and AC10 checks the real model on clear cases only; a borderline case is not tested.
- **A coding lesson inside a mostly non-coding session is lost.** Justin accepted this.
- **The reason is model text in a synced log.** It is cut to 120 characters, told to hold no name or quote, and the entry is secret-scanned; a personal word could still slip in. The repo is private.
- **The check Justin owes (the last criterion) can go stale.** The career session is 7th of the 8 a dry run reads today; a dry run never moves markers, so two more new sessions put it out of reach until the dream runs live (65 sessions wait, 8 a run).
- **`CLAUDE.md` moves often.** The finisher may have to rebase the one changed line.
- **Size against Mini:** two source files, the prompt, the schema and the tests. It fits Mini; the three docs and the real-model test make it a larger Mini.

## Overlaps

No running job is known to touch `~/.claude/dream/`. `~/.claude/CLAUDE.md` is edited by many sessions; this story changes one line of its "Dream Pass" section, which `conf/protected.tsv` freezes for the dream itself, not for a story.

## Other things found (not fixed, not folded in)

- **Session `67456e97` is never read (medium).** Line 34021 of `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/67456e97-9f8e-4083-928f-7bcdbe7e3240.jsonl` (46,820 lines, 154 MB) is a 156-byte line cut off mid-text (`{"type":"queue-operation",…"content":"<task-`), with good lines after it. The dream calls the whole session an unknown shape at every run and names it in the session-start line. Recommended: its own small job, to skip and note one cut-off line the way a line of NUL bytes already is.
- **One dream test fails on `main` (low to medium).** `test_ac36_pointer_lines_and_docs_are_in_place`: "figma-to-bricks/SKILL.md mentions the tally". A later edit to that skill broke the dream's docs test; every dream story's gate now shows one failure.
- **`FigmaToBricksV3` is not in `conf/projects.tsv` (low).** Session `6c7eaf10` (34 messages) is filed as its own project `-home-justin-Documents-FigmaToBricksV3`, so a lesson from it can reach only that folder's memory, never the figma-to-bricks skill. Justin decides whether V3 is the same project.
- **About 50 "unattributed changes" in the first dry run's log (low to medium).** Files changed since the ledger's first rows with no ledger row, most of them brought by `sync(DESKTOP-UA2RBUD)` commits. Either the ledger hook is not recording edits on this desktop or those edits were made outside the Edit and Write tools. Worth one look before the dream goes live.
- **A dry run re-reads the same sessions every time (low, by design).** Markers move only in live mode, so with the timer on in dry-run each run would spend about $2 on the same 8 sessions.

## Completion and reporting

The builder stops at `ready-for-review` with: branch, base and head; the red and green output of each test; the mutation table; `<evidence>/baseline.md`; one terminal capture per criterion; `skill_lessons`. AC12 is owed to Justin after the merge.

## Justin's answers

(none yet)
