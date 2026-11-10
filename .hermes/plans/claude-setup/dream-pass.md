# dream-pass: a twice-daily job that learns from Justin's sessions and review findings (desktop only)

Story: claude-setup, **Full** pipeline (`pipeline=full`). Planner: 2026-11-09. Base: setup repo `main` (at `f3c950b9` when planned; it moves about 120 commits a day).
Build in a setup-repo worktree, never in `$HOME` directly:
`git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/dream-pass" -b dream-pass main`.
Nothing in this plan is built yet. The plan is written as if every recommended option below were chosen, so "go" needs no re-plan.

## Questions for Justin (each has a recommended default; "go" accepts the defaults)

1. **Are Hermes's own memory files (`~/.hermes/memories/MEMORY.md`, `USER.md`) dream targets?** Measured: 2,116 and 1,361 bytes, both right at Hermes's own limits (2,200 and 1,375 characters), and Hermes on the Mac rewrites them itself.
   - **(a) Recommended: no.** The dream never edits them. A desktop edit would collide with Hermes's own rewrite on the Mac (a sync CONFLICT) and nothing fits in them anyway.
   - (b) Yes, with Hermes's limits as their budgets (so the dream could only replace or cut).
   - (c) Read-only: the editor may read them to avoid duplicates, never write.
2. **Size budgets** (bytes, `wc -c`; a file over its budget may only shrink):
   - **(a) Recommended:** any `SKILL.md` 90,000 (Hermes's limit is 100,000 characters); other skill `.md` files 60,000; each `repeat-mistakes.md` 16,000; `~/.claude/CLAUDE.md` 30,000 (29,427 now); a project `CLAUDE.md` 40,000; a memory note 8,000; a memory index `MEMORY.md` 12,000 and 200 lines. Where dream-trim's approved target for one of its four files is higher than these, that file's budget is the trim target plus 10%.
   - (b) Tighter: `SKILL.md` 80,000, `~/.claude/CLAUDE.md` 28,000 (it could then only shrink from day one).
   - (c) Looser: `SKILL.md` 98,000, `~/.claude/CLAUDE.md` 36,000.
3. **Per-run change caps** (a run over any cap does not go live):
   - **(a) Recommended:** at most 12 files changed and 2 new files (a memory note or a `references/*.md`), never a file deleted; per file at most 3,000 bytes added, and removed at most 3,000 bytes or 5% of the file, whichever is larger; whole run at most 12,000 added and 12,000 removed; text moved word for word to another target is not counted as removed, up to 30,000 bytes moved per run; at most 3 library skills per run. The three repeat-mistakes files may fill to their budget on the run that creates them, then change at most 4,000 bytes each per run.
   - (b) Half of all those numbers for the first week.
   - (c) Double.
4. **The schedule cannot be exact: Ubuntu (WSL) is not always running, and "linger" does not keep it running.** Measured from `~/crashlog`: Ubuntu was up all day on 5 of the last 7 days, and down for hours on 2 (Nov 5 from 21:03, Nov 6 until 11:13). Linger only starts your systemd user services without a login; when Windows stops the Ubuntu VM, nothing runs.
   - **(a) Recommended:** the systemd user timer at 05:00 and 17:00 with `Persistent=true`. A slot missed while Ubuntu was down runs once when Ubuntu next starts. Nothing is lost, because each run continues from the markers. The one-time `sudo loginctl enable-linger justin` is still done (AC39).
   - (b) Also add a Windows Task Scheduler task at 04:58 and 16:58 that starts Ubuntu (`wsl.exe -d Ubuntu -u justin --exec /bin/true`), so the timer fires on time while the PC is on. One PowerShell step for you.
   - (c) Windows Task Scheduler runs the dream directly, no systemd timer.
5. **A helper returns a quote that is not in your typed message.** The draft `DREAM.md` (section 13) says the whole run stops.
   - **(a) Recommended:** that finding is dropped and logged ("1 quote not found"); the rest of the run continues. If more than half of one helper's findings fail, all of that helper's output is thrown away and the session is read again next run. A helper that invents a quote then cannot block every later run.
   - (b) Keep the draft: stop the run, change nothing.
6. **Login for the headless calls.** Proven on 2026-11-09: `claude -p` works here on the subscription login, with no API key. The login's token showed an expiry of 2026-11-23, and it is not proven that a headless run renews it.
   - **(a) Recommended:** use the existing login. If a run fails on login, it stops before any edit and the session-start line says so; you then open `claude` once, or choose (b).
   - (b) Now: you run `claude setup-token` once and put the one-year token in `~/.config/dream/env` (mode 600, never synced); the timer's unit already reads that file if it exists.
7. **Can Codex's edits be recorded in the write ledger?** Yes: Codex already calls `~/.codex/hooks/codex-hooks.sh post-tool` after every tool, so one added line there can call the ledger script, with no change to `hooks.json` (so no re-trust). Not proven: that a hook started from Codex's sandbox may write `~/.claude/dream/local/`.
   - **(a) Recommended: a follow-up story.** Until then a Codex edit shows up in the log as an "unattributed change", which is true and loses nothing.
   - (b) Include it now: one line in `codex-hooks.sh`, one case in `codex-parity.test.sh`, and a probe for the sandbox question.
8. **How far "cut old text" goes in v1.**
   - **(a) Recommended:** the dream cuts text only when (1) a finding from you proves it outdated or wrong, (2) it duplicates text that stays (the surviving text is quoted and checked), (3) it was moved word for word to `references/`, or (4) a repeat-mistakes entry retires by its rule. Text that only looks old is put on your list as a suggestion, never cut.
   - (b) The editor may also cut text it judges stale when the checking agent agrees.
9. **How the first real run is staged.**
   - **(a) Recommended:** the build lands with the timer off and the mode set to `dry-run`. You start one dry run by hand and read its diff (AC40). Then `dream mode live`, one live run by hand that you check on GitHub (AC41), then the timer is switched on (AC39).
   - (b) Timer on in dry-run mode for two days first (each dry run costs an editor and a checker call and changes nothing).
   - (c) Live from the first scheduled run.

## Acceptance criteria (all **proposed**: Justin gave none; "go" approves them)

Test names are exactly as the runner prints them. Python tests: `bash ~/.claude-setup-wt/dream-pass/.claude/dream/tests/run.sh`; hook tests: the two `dream-*.test.sh` files under `.claude/hooks/tests/`.

- AC1 (proposed): Given a transcript holding typed, queued, headless (`sdk`), task-notification, compact-summary, slash-command, `<bash-input>`, image-token, tool-result, sidechain and meta lines, when the extractor runs, then the digest holds exactly the typed and queued messages in order (image tokens like `[Image #1]` removed, the text after them kept and the entry marked "has an image the helper cannot see"; injected `[Image: …]` captions dropped), each with its line uuid and timestamp and, before it, the tail of Claude's visible text labelled as context (the last 1,500 characters, extended back to the start of the paragraph or list the cut falls in, 3,000 at most), and no tool result, tool call or thinking text anywhere. Test: `test_ac1_digest_holds_only_typed_messages_with_context`
- AC2 (proposed): Given a message that is only a `<pasted_content id=…>` block and a typed message with a paste inside it, when the extractor runs, then the first is kept labelled `PASTE (whole message)` and the second keeps its typed text with the paste replaced by `[paste omitted, N chars]`. Test: `test_ac2_whole_paste_kept_and_inner_paste_omitted`
- AC3 (proposed): Given a transcript whose user lines have an unknown shape (no `promptSource`, a missing `uuid`, `timestamp` or `message.content`, or text that fits no known kind), when the extractor runs, then it exits non-zero naming the session and the shape, writes no digest for it and moves no marker; it never returns an empty digest for such a file. Test: `test_ac3_unknown_transcript_shape_fails_loudly`
- AC4 (proposed): Given no new typed message, no new review finding or failed AC, nothing waiting from an earlier run and no unfinished apply, when a run starts, then it makes zero model calls, writes no commit and exits 0. Test: `test_ac4_nothing_new_makes_no_model_call`
- AC5 (proposed): Given sessions already read up to a line, when new lines are appended, then only the new lines are extracted; a session modified in the last 30 minutes, a session with no typed message and a headless session (`entrypoint` `sdk-cli`) are skipped; and a session file that was rewritten is read again from the top without repeating a message already processed. Test: `test_ac5_markers_resume_per_session_and_skip_active_and_headless`
- AC6 (proposed): Given evidence folders with `review-<n>/review.json` and `ac.json` files, old ones with `high/medium/low` severities, a nested copy of the same review and a symlinked `node_modules`, when the extractor runs, then each new P0–P2 (or high/medium) finding and each failed AC becomes exactly one line (project, story, id, severity, file, claim cut to 400 characters), the copy is not counted twice, the symlink is not followed, and a second run yields no lines. Test: `test_ac6_review_and_failed_ac_lines_are_new_and_counted_once`
- AC7 (proposed): Given helper findings whose uuid names no entry of that session's digest, or whose quote is not word for word inside that named entry's own user text (taken from the context, from an omitted paste, from another entry of the same digest, from another session, or invented), when the bar script runs, then each is dropped and logged and never reaches the editor, and when more than half of one helper's findings fail, all of that helper's output is discarded and its session is read again next run. Test: `test_ac7_finding_without_verbatim_typed_quote_never_reaches_editor`
- AC8 (proposed): Given one explicit correction or stated decision from Justin and one merely implied preference, when the bar script runs, then the first passes at once and the second waits in `state/pending.json`; when a later run's helper matches a second session to that pending candidate it passes then, and a candidate unmatched for 60 days is dropped with a log line. Test: `test_ac8_explicit_passes_at_once_and_single_sightings_wait_across_runs`
- AC9 (proposed): Given an addition that cites a typed finding, when the guards run, then the added text must contain that message's date (`YYYY-MM-DD`), and an addition without it blocks the run. Test: `test_ac9_addition_from_typed_finding_carries_its_date`
- AC10 (proposed): Given a finding the helper marks as loosening a safety rule (push, authorship, approval, guards, merge policy) or as a fix that weakened a check (skip a test, bypass a guard, force), when the bar script runs, then it is never given to the editor and is appended to `~/.claude/dream/justin-list.md` with its quote. Test: `test_ac10_safety_loosening_and_weakened_checks_go_to_justins_list`
- AC11 (proposed): Given an edit that changes one byte inside a section listed in `conf/protected.tsv` (the git, authorship, push, approval and merge sections), when the guards run, then the run does not go live, whatever the helper, editor and checker said. Test: `test_ac11_protected_section_change_blocks_the_run`
- AC12 (proposed): Given a finding marked as a personal detail about another person or whose text trips gitleaks, then it is dropped before the editor and its text appears nowhere in the log; given a finding whose lesson sentence holds a code-like token (8 or more characters mixing letters and digits, or 6 or more digits) that is not in the message it quotes, then it is dropped the same way (so a code from Claude's context text cannot travel); the context blocks of a digest are scrubbed like the typed text; and given a diff or log entry that trips gitleaks, then the run does not go live. Test: `test_ac12_secrets_and_personal_details_are_never_written`
- AC13 (proposed): Given the editor has changed the copy, when the checking agent answers "no", then every live target is byte-identical to before, no commit exists and the markers have not moved; after the same findings fail to go live in two runs they are put on Justin's list as "could not apply automatically" and stop blocking later runs. Test: `test_ac13_checker_no_leaves_live_files_untouched_and_parks_after_two_tries`
- AC14 (proposed): Given a target over its budget in `conf/budgets.tsv`, when an edit makes it larger, the run does not go live; an edit that makes it smaller passes; and a target under budget may not cross its budget. Test: `test_ac14_file_over_budget_may_only_shrink`
- AC15 (proposed): Given edits over a per-file or whole-run cap in `conf/caps.conf` (bytes added, bytes removed, files changed, new files, a deleted file, library files), when the guards run, then the run does not go live, and text moved word for word to another target is not counted as removed. Test: `test_ac15_change_caps_block_oversized_runs_and_ignore_verbatim_moves`
- AC16 (proposed): Given `conf/canary.tsv` (file, exact text), when an edit removes one of those texts from its file, then the run does not go live. Test: `test_ac16_missing_canary_fact_blocks_the_run`
- AC17 (proposed): Given the editor's diff and its `changes.json`, when a removed line is neither moved word for word, nor listed with a reason and a finding that passed the bar, nor a duplicate whose surviving text is really in a target, or an added line is not listed against a finding or a repeat-mistakes order, then the run does not go live. Test: `test_ac17_every_removed_and_added_line_is_accounted_for`
- AC18 (proposed): Given an edit to a path outside the allowlist (`~/.codex/AGENTS.md`, anything under `~/Leorna/`, `DREAM.md`, a transcript, an evidence folder, a non-`.md` skill file, a path reached through a symlink), or an edit to `~/.claude/CLAUDE.md` or a general skill citing only a finding that is neither stated as general nor seen in two projects, when the guards run, then the run does not go live. Test: `test_ac18_only_allowed_targets_and_narrowest_scope`
- AC19 (proposed): Given a live target whose sha256 at apply time differs from its sha256 when the copy was made, when the apply step runs, then nothing is written, the log names the file and (from the ledger) who changed it, and the findings stay for the next run. Test: `test_ac19_target_changed_since_copy_blocks_apply`
- AC20 (proposed): Given a library-linked skill is edited, when the run goes live, then the edit is in the clone's work tree only, the clone has zero local commits and nothing staged, `~/.hermes/skills-library-local.patch` equals `git diff` of the clone and is in the dream commit, and the file has no more diff hunks than before (at least one); and given the clone has a local commit, the run does not go live. Test: `test_ac20_library_edit_travels_only_in_the_patch_file`
- AC21 (proposed): Given another session's uncommitted edit to a different synced file and one to be made while the dream runs, when the run goes live, then exactly one commit `dream(<time>): …` exists whose changed paths are exactly the dream's (targets, log, state, list), authored by the repo's own identity with no AI trailer, and it is on `main` of the remote; the other session's edits are in a separate `sync(<host>)` commit or still uncommitted. Test: `test_ac21_one_dream_commit_holds_only_the_dreams_paths_and_is_pushed`
- AC22 (proposed): Given the push fails (remote unreachable), when the run ends, then the dream commit exists locally, the markers have moved, the log says the push is pending, and the next ordinary `sync.sh` pushes it. Test: `test_ac22_failed_push_leaves_a_local_commit_for_the_next_sync`
- AC23 (proposed): Given a run killed after some live files were written and before the commit, when the next run starts, then it either finishes the commit (every listed file has its new hash) or restores every file it changed to its old bytes, leaves alone and reports any file someone edited in between, and in both cases no message is processed twice or lost. Test: `test_ac23_unfinished_apply_is_finished_or_restored`
- AC24 (proposed): Given a run that went live, then `dream-log.md` has one new entry with the time, the sessions and findings read, each changed file with its reason, the evidence quoted (at most 300 characters each), every removed text with its reason, what went on Justin's list, what was dropped and why, how many findings were already saved (counted apart from what the dream added), unattributed changes, corrections per 100 typed messages per project, model calls and tokens, and the marker stated in words; and the markers move only after the commit exists. Test: `test_ac24_log_entry_quotes_evidence_and_markers_move_after_commit`
- AC25 (proposed): Given the ledger hook receives a Write or Edit on a target (directly, through a `~/.claude/skills/<name>` link, through a linked memory folder, or a project's own `CLAUDE.md`), then one row `{path, sha256, session, agent, time}` with the real path is appended to `~/.claude/dream/local/ledger.jsonl`; for any other path, on a machine without `~/.claude/dream/local/`, or on bad input it prints nothing and exits 0. Test: `ac25_ledger_records_target_edits_through_links_and_fails_open`
- AC26 (proposed): Given a target whose sha256 differs from its last ledger row at the start of a run, then the log lists it as an unattributed change with what git knows (the `sync(<host>)` commit that brought it, or "uncommitted"), a new ledger row is written so it is reported once, and a target never seen before only gets a baseline row. Test: `test_ac26_unattributed_change_is_logged_once`
- AC27 (proposed): Given the tally, when a mistake kind has been seen in two stories of one project, then the editor is ordered to add it to that project's `repeat-mistakes.md` and the file must then hold one entry for it with the heading `### <kind> — <mistake> (N×: stories)`, a "Build it this way" line and a "Check for it" line, with the count and stories written by the script; a kind seen in two projects belongs in the general file and nowhere else; entries are ordered most frequent first within their area. Test: `test_ac27_repeat_mistake_entry_appears_at_two_stories_and_moves_to_general`
- AC28 (proposed): Given a listed kind, when its project has had 10 later stories without it, then the script orders the entry removed and it is gone after the run; and when a listed kind is seen again in a story that began after it was listed, then one line is appended to `~/.hermes/plans/claude-setup/enforce-backlog.md` in its existing format and the entry's wording does not change. Test: `test_ac28_entry_retires_after_ten_stories_and_a_repeat_becomes_an_enforce_proposal`
- AC29 (proposed): Given any dream agent call, then its command line has `-p --no-session-persistence --safe-mode --setting-sources "" --strict-mcp-config --disable-slash-commands --permission-prompts none --model claude-opus-5-5 --effort xhigh --output-format json`, helpers and the checker have `--tools ""` and a `--json-schema`, the editor has `--restricted --tools Read,Grep,Glob,Edit,Write --permission-mode acceptEdits` with the copy as its working folder, the prompts carry the `DREAM.md` sections they need, and when `claude --help` no longer lists one of these flags the run stops before any call. Test: `test_ac29_headless_calls_carry_isolation_flags_and_preflight_stops_on_a_missing_flag`
- AC30 (proposed): Given 20 sessions with new typed text, when a run starts, then exactly 8 session helpers run, never more than 3 at once, the 8 newest sessions first, and the other 12 sessions keep their markers for the next run; given 400 new review lines, one review helper gets at most 150 and the rest wait. Test: `test_ac30_eight_session_helpers_per_run_three_at_a_time_newest_first`
- AC31 (proposed): Given the last run's result in `~/.claude/dream/local/last-run.json`, when a session starts, then the notice hook shows one line (what the dream changed, the commit, how many items are on Justin's list) once per run, shows a failed run at every start until a run succeeds, and prints nothing and exits 0 when the file is missing or broken. Test: `ac31_session_start_line_reports_the_last_dream`
- AC32 (proposed): Given the mode is `dry-run`, when a run reaches the apply step, then it writes `would-apply.diff` and the would-be log entry under `~/.cache/dream/<run>/`, changes no live file, makes no commit and moves no marker; and the mode is `dry-run` whenever the mode file is missing. Test: `test_ac32_dry_run_stops_before_the_apply_step`
- AC33 (proposed): Given `dream install`, then `~/.config/systemd/user/dream.service` and `dream.timer` exist, pass `systemd-analyze --user verify`, the timer has `OnCalendar` 05:00 and 17:00 and `Persistent=true`, the service has `MemoryMax=6G` and `MemorySwapMax=0`, and the timer is not enabled unless `--enable` is given. Test: `test_ac33_units_run_twice_daily_persistent_and_memory_capped`
- AC34 (proposed): Given a dream commit that changed a skill, a library skill and a project `CLAUDE.md`, when `dream undo <commit>` runs, then one revert commit exists, every file is back to its old bytes, the library clone's work tree matches the reverted patch file (so the next sync cannot bring the edit back), and the project's own `CLAUDE.md` matches the reverted copy. Test: `test_ac34_undo_reverts_live_files_library_edits_and_project_copies`
- AC35 (proposed): Given an edit to `~/.claude/project-docs/<name>/CLAUDE.md` for a project that exists on this machine, when the run goes live, then the project's own `CLAUDE.md` gets the same bytes (so `sync.sh` does not overwrite the edit with the old project file), and the run does not go live when the two differed before the edit. Test: `test_ac35_project_claude_md_copy_and_project_file_are_written_together`
- AC36 (proposed): Given the landed setup, then `leorna/SKILL.md`, `figma-to-bricks/SKILL.md`, `feature-dispatch/SKILL.md` and the pipeline section of `~/.claude/CLAUDE.md` each hold one line telling builders, reviewers and fixers to read the project's `references/repeat-mistakes.md` and the general one, the three files exist with the entry format, no file given to agents mentions the tally, and `manifest.txt`, `exclude.txt`, `desktop.md`, `README.md` and `DREAM.md` hold the lines the Docs task names. Test: `test_ac36_pointer_lines_and_docs_are_in_place`
- AC37 (proposed): Given this machine's real `claude`, when the named-only live test makes one helper call and one editor call with the AC29 flags, then both return valid structured output from `claude-opus-5-5`, no transcript file is added under `~/.claude/projects`, no hook state file is created for the call's session id, and the editor's attempt to read and write outside its folder is refused. Test: `test_live_headless_calls_are_isolated_and_confined`
- AC38 (proposed): Given the existing suites (`sync.test.sh`, every `~/.claude/hooks/tests/*.test.sh`, `codex-parity.test.sh`, `ac-check.test.sh`, `review-check.test.sh`), when they run on the story's head, then each prints the same pass tally and the same failing test names as Task 0 recorded on the base. Test: `regression_existing_suites_match_the_base_tally`
- AC39 (proposed) (live): Justin has run `sudo loginctl enable-linger justin`, `loginctl show-user justin` shows `Linger=yes`, and `systemctl --user list-timers dream.timer` shows the next 05:00 or 17:00 run. Test: `live_linger_and_timer_enabled`
- AC40 (proposed) (live): Justin has started one dry run by hand (`systemctl --user start dream.service`), the session-start line reported it, and he has read `would-apply.diff` and said it is sane. Test: `live_first_dry_run_read_by_justin`
- AC41 (proposed) (live): After `dream mode live`, one run started by hand made exactly one `dream(…)` commit that is on `main` of `Just-In-N-Out/claude-setup` on GitHub, and `git -C ~/.hermes/skills-library log origin/main..HEAD` is empty. Test: `live_first_live_run_is_one_commit_on_github`
- AC42 (proposed): Given a prompt typed while a turn was running (a `type: "attachment"` line with `attachment.type` `queued_command` and `origin.kind` `human`), a task notification and a peer-agent message of that same attachment type, a slash command with typed text in `<command-args>`, and an `api-request-blob` line that repeats an earlier typed message, when the extractor runs, then the digest holds the mid-turn prompt and the slash-command text (labelled with the command's name) once each, and holds neither the notification, the peer message nor a second copy of the repeated message. Test: `test_ac42_mid_turn_prompts_and_slash_arguments_are_typed_and_nothing_is_counted_twice`
- AC43 (proposed): Given an AskUserQuestion result (`toolUseResult` with `questions` and `answers`), when the extractor runs, then each answered question becomes its own entry labelled `ANSWER` with the question, the option labels offered, the option Justin chose and any text he wrote, under the result line's uuid; a quote from the chosen option or his own text of that entry passes the quote check, and a quote from an option he did not choose fails. Test: `test_ac43_question_answers_are_entries_and_only_the_chosen_text_is_quotable`
- AC44 (proposed): Given findings that passed the bar, when the editor reports one as already saved, then the script checks the text the editor names is really in that target word for word, the finding is settled with no edit and counted as "already saved" in the log; a finding the editor neither applied, nor reported as already saved, nor declined with a reason stops the run. Test: `test_ac44_already_saved_findings_are_verified_counted_and_not_added_again`
- AC45 (proposed): Given a finding the helper marks ambiguous, or whose quote holds a task-only phrase from `conf/task-only-phrases.txt` ("for this task", "just for this", "this time", "for this chat"), then it never reaches the editor and goes on Justin's list as a question; given a finding that depends on an image the helper could not see, then it waits in the pending list like an implied one; and given an edit that removes or replaces a dated line, then it must cite a finding from a typed message or answer that is not ambiguous and names what it replaces, else the run does not go live. Test: `test_ac45_an_ambiguous_message_never_replaces_a_dated_rule`

AC39, AC40 and AC41 are the three `(live)` ones; AC42 to AC45 were added after the hand trial's results came in.

## Playback

Justin wants a job on the Windows desktop that, about every 12 hours, rereads what is new in his Claude Code sessions and in the pipeline's review results, and uses it to keep his long-term agent files right: lessons added, outdated text replaced, duplicates merged, old text cut. Only what he typed and what agents corrected counts as evidence. One helper per session returns short findings; one editor makes all the edits; the edits go straight to the live files as one commit pushed to his own setup repo, never to the Leorna library repo. Builders, reviewers and fixers get a repeat-mistakes file per project and a general one. Every agent write to these files is recorded with a hash. Two files describe it: the rules (`DREAM.md`) and a log appended each run.

## What the planner measured on 2026-11-09 (the builder re-checks anything it relies on)

- **Headless calls work and are isolated, with these exact flags** (three real calls, Claude Code 2.1.322; it was 2.1.321 that morning, so the CLI updates itself): `claude -p --no-session-persistence --safe-mode --setting-sources "" --settings <file holding {"hooks":{}}> --strict-mcp-config --disable-slash-commands --permission-prompts none --model opus --effort low --tools "" --output-format json --system-prompt … --json-schema …` returned exit 0, `modelUsage` `claude-opus-5-5`, the answer in both `.result` (a JSON string) and `.structured_output` (an object), 609 to 1,256 input tokens in total (so no `CLAUDE.md`, no hooks, no tool list), no new transcript (83 before and after), no nudge-hook state file and no `history.jsonl` line for its session id. Send the prompt on stdin or redirect `</dev/null`: with neither, the CLI waits 3 s and warns.
- **The editor can be confined.** With `--restricted --tools "Read,Grep,Glob,Edit,Write" --permission-mode acceptEdits` and the copy as working folder, it edited two files in the copy; a Read of `~/.claude/setup/manifest.txt` and a Write outside the folder were refused ("--restricted confines the file tools to the working directory") and listed in `.permission_denials`. A `CLAUDE.md` inside the copy telling it to answer "PINEAPPLE" was not obeyed.
- `--bare` cannot be used (needs an API key). `.credential_expires_at` in the result was `2026-11-23`.
- **Transcripts:** 83 main-session files, 359 MB; 893 subagent files. User lines carry `promptSource`: `typed` (870 lines), `queued` (126, typed while Claude was working: they count as typed), `system` (210, task notifications), `sdk` (5, headless; `entrypoint` `sdk-cli`), and none on compact summaries (`isCompactSummary`, 31), slash commands, `<local-command-stdout>`, `<bash-input>`, `<bash-stdout>` and `[Request interrupted`. Typed lines have `origin.kind == "human"`. 44 sessions have 3 or more typed messages, 31 have 1 or 2, 8 have none; 22 span more than one day. 2 lines in 83 files are not valid JSON (a file being written).
- **The brief's list of injected prefixes is wrong for images:** 78 typed messages start with `[Image #N]` followed by Justin's text. They are typed messages; only the token is removed.
- **Pastes:** always `<pasted_content id="6a6a">…</pasted_content id="6a6a">` (the closing tag repeats the id), 59 messages. A short paste is not marked anywhere and reads as typed. `~/.claude/history.jsonl` is not used: the hand trial found it incomplete (12 of 147 and 3 of 41 kept messages missing) and its times are typing times.
- **Prompts typed while a turn is running are not user lines.** They are `type: "attachment"` lines with `attachment.type == "queued_command"`, `attachment.origin.kind == "human"`, the text in `attachment.prompt` (a string in 74, a block list in 6) and a line `uuid`: 80 in all sessions, none repeated as a user line. The same attachment type carries 924 task notifications and 77 peer-agent messages, so `origin.kind` decides.
- **Slash-command arguments** are typed text inside `<command-args>` on a user line with `origin.kind == "human"` and no `promptSource` (1 with text, 8 empty).
- **AskUserQuestion answers** are tool results: `toolUseResult` holds `questions[{question, header, options[{label, description}], multiSelect}]`, `answers{question: answer}` and often `annotations`; 115 results, 130 answers that are an option label and 25 that are Justin's own text.
- **Other injected shapes:** peer messages, skill bodies and system reminders on user lines are all `isMeta`; hook output arrives as attachment lines; `api-request-blob` lines repeat earlier message content, so a transcript is parsed by line type, never searched as raw text.
- **The hand trial (three sessions, Opus xhigh helpers, finished 2026-11-09):** 147, 41 and 33 kept messages gave 10, 4 and 2 findings for 178,000, 104,000 and 92,000 tokens in 5, 3.5 and 2 minutes. The context blocks were 87% of the largest digest (199,000 characters, about 50,000 tokens). Most findings were already saved in skills or memory notes the same day by the live lesson-saving. Helpers rejected "for this task" instructions, plain approvals and questions; one invented a uuid; decisions made through AskUserQuestion were missing from every digest; one correction depended on an image the helper could not see; one finding from an ambiguous message ("jsut for this one") contradicted a dated saved rule; 1,500 characters of context sometimes cut off the option list Justin was answering; a regex pass plus gitleaks masked 2 token-shaped strings in a paste but not a one-time pairing code in a context block.
- **Reviews:** 209 `review.json` (figma-to-bricks 148, leorna 50, claude-setup 11), 720 findings: P1 14, P2 209, P3 449, plus 48 older ones with `high/medium/low` and `file`/`line` instead of `file_line`. 12 files are nested copies (`…/earlier-oracles/review-N/`, `…/original-review-methods/review-N/`). 304 `ac.json`, all `{head, ac_status[{ac, accepted, test, evidence, …}]}`, 386 rows with `accepted: false`. Evidence folders hold 856 symlinks, some to `node_modules`: Python's `glob('**', recursive=True)` followed them and did not finish in 120 s; `find` (no symlink following) took 1.2 s.
- **Sizes:** `figma-to-bricks/SKILL.md` 105,514; `feature-dispatch/SKILL.md` 99,018; `leorna/SKILL.md` 73,735; `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` 95,669; `~/.claude/CLAUDE.md` 29,427. Memory notes: 220 files, the largest 168,730 bytes (`leorna-workflow.md`). Desktop memory folders are links to the Mac-named folders (`-home-justin-Leorna/memory` → `../-Users-justin-Leorna/memory`).
- **Library clone:** `~/.hermes/skills-library` on `main`, 11 edited files, 0 local commits, remote `LeornaAI/skills-library`; the patch file is 102,218 bytes, 11 files. 119 skill links point into it.
- **Setup repo:** 2,237 tracked files, 123 commits in the last 24 hours, tag `pre-dream-2026-11-09` = `fafe0ac3` on GitHub. `sync.sh pull` commits every pending local edit in the manifest as `sync(<host>)` before it pulls.
- **systemd:** user manager running, systemd 259, `Linger=no`, `systemd-analyze`, `flock`, `gitleaks` 8.30.1 and Python 3.14.4 present. The user manager's `PATH` has no `~/.local/bin`, where `claude` is.
- **Project `CLAUDE.md` copies:** only FigmaToBricksV2 is cloned on this desktop; its `CLAUDE.md` equals the copy. `sync.sh` `copy_in` (lines 106–113) copies project → copy before every commit whenever they differ.
- uutils `mkdir` on this desktop is not atomic under contention (memory note `desktop-docker-gotchas.md`); `sync.sh`'s lock is a `mkdir` lock. Python's `os.mkdir` is atomic (0 of 300 races).

## What cannot work as the brief wrote it, and what the plan does instead

1. **`[Image ` as an injected prefix** would drop 78 typed messages. The extractor strips the tokens and keeps the text.
2. **Editing only `~/.claude/project-docs/<name>/CLAUDE.md`** is undone by the next sync when the project is cloned here (`copy_in`). The dream writes the copy and the project's own file together (AC35).
3. **"The revert path is reverting the dream's commit"** is not enough for two kinds of file. After a local revert the library clone still holds the edit, and the next sync's `save_lib_patch` writes it back into the patch file; and `copy_in` copies the still-edited project `CLAUDE.md` back over the reverted copy. `dream undo <commit>` does the revert and both repairs (AC34). `DREAM.md` section 14 changes to name that command.
4. **Linger does not make the schedule exact** (question 4).
5. **"Stop the run when a quote cannot be found"** (draft `DREAM.md` section 13) lets one invented quote block every later run (question 5).
6. **The log entry cannot be written after the commit** if it is synced with it. The entry is part of the dream commit, written by the apply step; "markers move only after the commit" is kept (AC24).

## Design

### Files

Synced through the setup repo (new manifest lines in Task 17; `.claude/dream/DREAM.md` is already listed):

| Path (under `~/.claude/dream/` unless shown) | What it is |
|---|---|
| `DREAM.md` | The rules. Exists as a draft; Task 17 fills the *(plan)* lines and makes the edits listed under "Changes to DREAM.md". Never a dream target. |
| `dream-log.md` | One entry per run that read something. At the first run of a month the older month moves to `dream-log-YYYY-MM.md`. |
| `justin-list.md` | Items only Justin may decide. The dream appends; Justin deletes what he has handled. |
| `state/pending.json`, `state/tally.json`, `state/applied.json`, `state/trend.json` | Candidates seen once; mistake kinds with counts and stories; ids of findings already applied (never applied twice); typed and correction counts per project per run. Written with sorted keys and 1-space indent so diffs stay small. |
| `conf/targets.txt`, `conf/budgets.tsv`, `conf/caps.conf`, `conf/canary.tsv`, `conf/protected.tsv`, `conf/projects.tsv`, `conf/models.conf`, `conf/task-only-phrases.txt` | Allowlist and never-list; budgets; caps; exact facts that must stay; protected sections; project map; model and effort; phrases that mark a message as meant for one task. |
| `prompts/session-helper.md`, `prompts/review-helper.md`, `prompts/editor.md`, `prompts/checker.md`, `prompts/*.schema.json` | Agent prompts and output schemas. |
| `bin/dream` | The one command (Python 3, standard library only). |
| `lib/dreamlib/*.py` | `paths`, `extract`, `state`, `agents`, `bar`, `targets`, `guards`, `apply`, `ledger`, `mistakes`, `log`, `run`. |
| `systemd/dream.service`, `systemd/dream.timer` | Unit files that `dream install` copies to `~/.config/systemd/user/`. |
| `tests/` | `run.sh`, `test_*.py`, `fakehome.py`, `fake-claude`, `mutants.sh`, `regression.sh`, fixtures. |
| `~/.claude/hooks/dream-ledger.sh`, `~/.claude/hooks/dream-notice.sh`, `~/.claude/hooks/tests/dream-ledger.test.sh`, `~/.claude/hooks/tests/dream-notice.test.sh` | The two hooks and their tests (existing manifest globs cover them). |
| `~/.hermes/skills/software-development/leorna/references/repeat-mistakes.md`, `…/figma-to-bricks/references/repeat-mistakes.md`, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` | The three repeat-mistakes files. |

Machine-local, never synced (`~/.claude/dream/local/`, also added to `exclude.txt`): `cursors.json` (markers), `unsettled.json` (findings extracted but not yet live, with tries), `ledger.jsonl`, `apply-journal.json`, `mode` (`dry-run`, `live` or `off`), `last-run.json`, `run.lock`. Its existence is what makes a machine "a dream machine": the Mac has no such folder, so both hooks are silent there and `dream run` refuses to start.
Working files: `~/.cache/dream/<run-id>/` (digests, the copy, diffs, agent outputs), kept 14 days, never synced. Not `/tmp`: it is RAM on this desktop.

Every script takes its roots from the environment (`HOME`, `SETUP_SYNC_GIT_DIR`, `SETUP_SYNC_URL`, `DREAM_HOME`, `DREAM_CACHE`, `DREAM_CLAUDE_BIN`, `DREAM_NOW`) and finds `lib/` beside itself, so the tests run it against a fake home from the worktree.

### `bin/dream` commands and exit codes

`dream run [--dry-run|--live]` · `dream status` · `dream mode dry-run|live|off` · `dream install [--enable]` · `dream uninstall` · `dream undo <commit>` · `dream init` (first-time markers and ledger baseline) · `dream extract <transcript>` (prints one digest, for debugging).
`dream run` exits 0 when nothing was new or the run completed (a dry run included), 3 when a guard stopped it with nothing live, 4 on an environment failure (pull conflict, GitHub unreachable, login, unknown transcript shape everywhere, a missing CLI flag). The tests pin these on the `run()` function, not through a wrapper.

### One run (`lib/dreamlib/run.py`), step by step

0. **Start.** Take `local/run.lock` with `flock` (a second run exits 0 at once). Mode `off` → exit 0. If `local/apply-journal.json` exists, recover first (step 8). Preflight, all before any model call: `gh auth token --user Just-In-N-Out` succeeds; `claude --help` lists every flag in AC29; the library clone has 0 local commits.
1. **Pull.** `~/.claude/setup/sync.sh pull`. `CONFLICT`, a non-zero exit, "another sync is running" after 8 tries 15 s apart, or "GitHub unreachable" → stop (exit 4), no model call.
2. **Extract, no model.**
   - Ledger check: every target's sha256 against its last ledger row (AC26).
   - Sessions: `~/.claude/projects/*/*.jsonl` (never `subagents/`), read line by line. A session is skipped when its mtime is under 30 minutes old, its lines are all `entrypoint: sdk-cli`, or it has no typed message. Classification of a `type: "user"` line that is not `isSidechain` and not `isMeta` and has text: `promptSource` `typed` or `queued` with `origin.kind == "human"` → typed; `sdk` → headless, skipped; `system` → notification, skipped; no `promptSource` and `isCompactSummary` → skipped; no `promptSource` and text starting with `<command-name`, `<command-message` (after any `<command-args>` text is taken, see below), `<local-command-stdout`, `<local-command-stderr`, `<bash-input`, `<bash-stdout`, `<bash-stderr`, `[Request interrupted` → skipped; anything else → **unknown shape**: that session is not read, its marker stays, and the run reports a format error (AC3). A last line that is not valid JSON is treated as "still being written" and left for the next run; a broken line elsewhere is an unknown shape. If every session with new lines is unknown-shaped, the run stops with exit 4.
   - Also typed (AC42, AC43): a `type: "attachment"` line with `attachment.type == "queued_command"` and `attachment.origin.kind == "human"` (label `mid-turn`, text from `attachment.prompt`; any other origin is skipped); the text inside `<command-args>` of a slash-command line with `origin.kind == "human"` (label `SLASH /<name>`; empty arguments are skipped); and each answered question of a user line whose `toolUseResult` has `questions` and `answers` (label `ANSWER`: the question, the option labels offered, the chosen option or options, and any text that is not an option label, which is Justin's own). Lines of type `api-request-blob` and every other line type are never read for text.
   - Typed text: `[Image #N]` tokens removed and the entry marked `has an image the helper cannot see` (also when the message has an image block); text starting `[Image:` is an injected caption and is dropped; `<pasted_content id="X">…</pasted_content id="X">` blocks replaced by `[paste omitted, N chars]`, unless nothing but whitespace is left outside them, in which case the message is kept whole and labelled `PASTE (whole message)`.
   - Context: the tail of the preceding assistant lines' `text` blocks (not sidechain), labelled `CONTEXT (what Claude said, not evidence)`: the last 1,500 characters, extended back to the previous blank line so a question or option list is not cut in half, 3,000 characters at most. An `ANSWER` entry carries its own question and options, so it needs no context.
   - One helper's digest is at most 120,000 characters (about 30,000 tokens); a session with more new text is read up to the last entry that fits and the rest waits for the next run.
   - Marker per session in `local/cursors.json`: `{committed_line, extracted_line, uuid_at_extracted, seen_uuids[]}`. If the line at `extracted_line` no longer has that uuid, the file is read from the top and uuids in `seen_uuids` are skipped. A marker whose file is gone is dropped.
   - Each whole digest, context blocks included, goes through a regex pass for common token shapes and then gitleaks; a hit is masked as `[masked]` before any model sees it. Context is never quotable, never logged and never shown to the editor, which bounds what a missed code can reach (AC12).
   - Reviews: files named `review.json` whose folder is `review-<n>` or `reviewer-<n>`, and files named `ac.json`, under `~/.hermes/plans/*/evidence/`, listed with a walk that never follows symlinks and skips any path with an `earlier-` or `original-` segment. One line per finding with severity P0, P1, P2, `high` or `medium`, and per `ac_status` row with `accepted == false` and no `not_run`. Lines already in `tally.json`'s `seen` (sha256 of project, story and claim) are not new.
   - Nothing new, nothing in `unsettled.json` → exit 0, zero model calls (AC4).
3. **Helpers (Opus 5.5, xhigh, no tools).** The 8 sessions with the newest mtime that have new typed text get one helper each, at most 3 at a time; the rest wait. Each helper reads only its digest and the short list of pending candidates (id and one line each) on stdin and returns `{findings: [{uuid, quote, kind: "correction"|"decision"|"preference"|"fact"|"implied", statement, general, replaces, matches_pending, loosens_safety, weakens_check, personal, ambiguous, depends_on_image}]}`. Its prompt says: reject instructions meant for one task ("for this task", "just this time", "for this chat"), plain approvals and questions; quote the message exactly as typed, voice-note slips included, and put the corrected reading in `statement`; never take wording from the context; mark `ambiguous` when the message can be read two ways and `depends_on_image` when it cannot be understood without the image. One review helper gets up to 150 new review lines plus the tally's kinds (id, title, description) and returns `{assignments: [{line_id, kind: "<existing id>"|"new"|"none", new_kind: {id, title, description, area}, enforce_proposal}]}`. Its output is used for counting and for kind titles only.
4. **The bar, no model (`bar.py`).** Per finding: the `uuid` must name an entry of that session's digest and the `quote` (15 characters or more, or the whole entry) must be inside that entry's own user text word for word, runs of whitespace compared as one space; for an `ANSWER` entry the user text is the chosen option and Justin's own text only. A quote from the context, an omitted paste, another entry or an option he did not choose fails (AC7, AC43). `personal`, a gitleaks hit on the quote or statement, or a code-like token in the statement that is not in the quoted entry → dropped, never logged with its text (AC12). `loosens_safety` or `weakens_check` → `justin-list.md` (AC10). `ambiguous`, or a task-only phrase in the quote → `justin-list.md` as a question (AC45). `depends_on_image` → treated as `implied`. `kind` other than `implied` → passes. `implied` → joins or matches `state/pending.json`; passes when two different sessions hold it (AC8). A finding whose id (sha256 of session, uuid and quote, 12 characters) is in `state/applied.json` is dropped. The script gives every passing finding its allowed targets: the session's project memory folder and project skill; any target only when `general` is true or the same pending candidate was seen in two projects (AC18).
   Review assignments update `state/tally.json`; `mistakes.py` turns the tally into **orders** for the editor (add entry K to file F, move K from F to the general file, remove K from F) and appends enforce-backlog lines (AC27, AC28).
   Passing findings and orders are saved in `local/unsettled.json`, so a later failure never needs the helpers again.
5. **The editor (Opus 5.5, xhigh, confined).** `targets.py` copies every target into `~/.cache/dream/<run>/copy/` as real files with no links, with the first dot of the path dropped (`.claude/CLAUDE.md` → `claude/CLAUDE.md`, a library skill → `hermes/skills-library/skills/<name>/…`), and records `map.tsv` (copy path, live real path, sha256). It writes `_dream/findings.json`, `_dream/orders.json` and `_dream/rules.md` (sections 3 to 9 of `DREAM.md` plus the budgets and caps) into the copy. The editor runs with the copy as its working folder, edits files there, and writes `_dream/changes.json`: `{changes: [{file, basis: "finding"|"order"|"duplicate"|"move", finding_ids, order_id, summary, additions: [text], removals: [{text, reason: "outdated"|"wrong"|"duplicate"|"moved"|"retired", surviving_text, moved_to}]}], already_saved: [{finding_id, file, existing_text}], declined: [{finding_id, reason}]}`. It sees findings, never transcripts. **Dedupe comes first:** for every finding it searches the targets before writing; when the lesson is already there it edits nothing and reports the finding under `already_saved` with the existing text, which the script then checks is really in that file (AC44). It never removes or replaces a dated line unless the finding names what it replaces (AC45); when a finding seems to contradict a dated rule without saying so, it declines it with that reason and the script puts it on Justin's list as a question. Every finding must end up applied, already saved or declined. It may tidy (merge duplicates, move a section to `references/`) only in a file it is already editing for a finding or in up to 2 files that are over budget. A non-empty `.permission_denials` in its result is logged and stops the run.
6. **The checker (Opus 5.5, xhigh, no tools).** It gets the unified diff of the copy against its snapshot, the findings with their quotes, the orders and `changes.json` on stdin and returns `{verdict: "yes"|"no", lost_facts: [{file, text}], untraced: [{file, text}], notes}`. "no" → nothing goes live.
7. **Guards, no model (`guards.py`),** every one on the copy, any failure → nothing goes live: allowlist and scope (AC18), protected sections (AC11), budgets (AC14), caps (AC15), canary facts (AC16), line accounting against `changes.json` (AC17), every finding accounted for and "already saved" texts verified (AC44), dated lines replaced only by a clear typed finding (AC45), dates on additions (AC9), gitleaks on the changed files and the log entry (AC12), repeat-mistakes shape with counts rewritten by the script (AC27), a new memory note is named in its folder's `MEMORY.md`, library hunks (AC20), and no link anywhere in the copy.
   A run stopped by step 5, 6 or 7 adds one try to each finding in `unsettled.json`. At the start of step 5, findings with 2 tries are moved to `justin-list.md` ("could not apply automatically", with the quote) and count as settled (AC13).
8. **Apply, commit, push (`apply.py`).** Dry-run mode stops here: it writes `would-apply.diff` and the would-be log entry and exits 0 (AC32). Live:
   1. `sync.sh pull` again (it commits other sessions' pending edits as their own `sync(<host>)` commit and brings the Mac's). Stop rules as in step 1.
   2. Take the sync lock: `os.mkdir("$GD/setup-sync.lock")` (the directory `sync.sh` uses; Python's mkdir is atomic), up to 8 tries 15 s apart, removed in a `finally`.
   3. Under the lock: every file to change still has its copy-time sha256 (AC19); `git status --porcelain -- <paths>` is empty; a project's own `CLAUDE.md` equals its copy (AC35); the clone has 0 local commits, nothing staged, and `git -C ~/.hermes/skills-library diff` equals the patch file (AC20).
   4. Write `local/apply-journal.json`: `{run, stage: "applying", files: [{path, before_sha, after_sha}], markers_after, log_entry}` and keep the old bytes in `~/.cache/dream/<run>/before/`. Write each file to a temp file beside it and `os.replace` it. Write the log entry, `state/*.json`, `justin-list.md`, the enforce-backlog lines, the project's own `CLAUDE.md` where one exists, and, when a library file changed, the patch file as `git diff` of the clone. Append one ledger row per file with agent `dream`.
   5. `git add -- <the exact paths>`; the staged set must equal the dream's set, else unstage, restore and stop. Commit with `git commit -q -F -`, message `dream(<YYYY-MM-DD HH:MM>): <n> file(s), <k> finding(s) [run <id>]` and the file list as the body. No `-c user.*`, no `--author`, no trailer: the repo's identity and the `~/.claude/githooks` checks apply as for any commit (AC21).
   6. Journal stage `committed`; move the markers; clear settled findings; write `local/last-run.json`; delete the journal; release the lock.
   7. `sync.sh` (plain) rebases and pushes to `main` of `Just-In-N-Out/claude-setup` with its own credential helper. A failure leaves the commit for the next sync and is noted in `last-run.json` (AC22). The dream never runs `git push` itself and never touches a remote of the library clone.
   **Recovery (AC23):** journal at stage `applying` → if every listed file has its `after_sha`, redo sub-steps 5 to 7; otherwise restore each file that has its `after_sha` from `before/`, leave and report any file that has neither hash, delete the journal and stop this run. Journal at stage `committed` → finish sub-step 6.
9. **After.** Prune `~/.cache/dream/` folders older than 14 days. The log entry was written in step 8; a run that read something but changed no target still commits its log entry and state, so the markers can move.

### The exact agent call (`agents.py`)

```python
BASE = [CLAUDE, "-p", "--no-session-persistence", "--safe-mode", "--setting-sources", "",
        "--settings", str(run_dir / "empty-settings.json"),   # {"hooks": {}}
        "--strict-mcp-config", "--disable-slash-commands", "--permission-prompts", "none",
        "--model", MODEL, "--effort", EFFORT, "--output-format", "json"]     # conf/models.conf: claude-opus-5-5, xhigh
HELPER  = BASE + ["--tools", "", "--system-prompt", prompt_text, "--json-schema", schema_json]          # stdin: digest; cwd: an empty folder
CHECKER = HELPER                                                                                        # stdin: diff + evidence
EDITOR  = BASE + ["--restricted", "--tools", "Read,Grep,Glob,Edit,Write", "--permission-mode", "acceptEdits",
                  "--system-prompt", prompt_text]                                                       # stdin: the task; cwd: the copy
```
`CLAUDE` is `DREAM_CLAUDE_BIN` or `~/.local/bin/claude`. Each call: `subprocess.run(..., input=..., capture_output=True, timeout=…)` (helpers and checker 900 s, editor 1,800 s). A call counts as failed when the exit code is not 0, the output is not JSON, `.is_error` is true, `.subtype != "success"`, `.structured_output` is missing where a schema was given, or `.modelUsage` names a model other than `MODEL`. A login or limit failure (`.api_error_status` 401, 403 or 429) stops the run with exit 4. `usage` and `total_cost_usd` of every call go into the log entry. Helpers run in a 3-worker thread pool.

### Repeat-mistakes files

```markdown
# Repeat mistakes: <project>
Builders and fixers: build it the way each entry says. Reviewers: check for each entry. Kept by the dream pass (`~/.claude/dream/DREAM.md`, section 7); do not edit by hand.

## <Area>
### <kind-id> — <the mistake in one line> (4×: story-a, story-b, story-c, story-d)
- **Build it this way:** …
- **Check for it:** …
```
The script owns which entries exist, their order and the text in the brackets; the editor owns the wording. `state/tally.json`: `{kinds: {<id>: {title, description, area, projects: {<project>: {stories: [], findings, last_story}}, listed_in, listed_since, repeats_while_listed: [], retired}}, stories: {<project>: [names in order of first evidence]}, seen: [sha256…]}`. Rules: 2 stories in one project → that project's file; 2 projects → the general file only; retired after 10 later stories of that file's project (any project, for the general file) without it; seen again in a story that began after `listed_since` → one enforce-backlog line `- <date> | dream | <skill> | <proposal> | offered` and no wording change. Evidence project `claude-setup` uses the general file. Pipeline agents are pointed at the three files only; nothing names the tally to them.
**Review backfill:** the first run finds all 271 lines of P1/P2/high/medium findings new. It sends one review helper per project (3 calls, no 150-line limit for this one run, flag `backfill_done` in `tally.json`) and the editor fills the three files up to their budget.
**Session backfill:** `dream init` sets the marker of every existing session with fewer than 3 typed messages to its end, so the 44 sessions with 3 or more are read 8 per run, newest first (6 runs).

### The ledger hook (`~/.claude/hooks/dream-ledger.sh`)

PostToolUse on `^(Write|Edit|NotebookEdit)$`, timeout 5. Bash and `jq`, house style: any bad input or failure exits 0 silently. It exits at once when `~/.claude/dream/local/` is missing. It reads `.tool_input.file_path`, `.session_id`, `.agent_id`; resolves the real path; records only when the real path is `~/.claude/CLAUDE.md`, a file named `CLAUDE.md` outside `~/Leorna/`, or under `~/.claude/projects/*/memory/`, `~/.claude/project-docs/`, `~/.hermes/skills/` or `~/.hermes/skills-library/skills/`; appends `{"path","sha256","session","agent","time"}` to `ledger.jsonl` under `flock`. It over-records on purpose; `conf/targets.txt` is the real allowlist. Over 5 MB the file keeps its last 20,000 rows.

### The session-start line (`~/.claude/hooks/dream-notice.sh`)

SessionStart, matcher `startup`, timeout 5, always exit 0. It reads `local/last-run.json` (`{run, time, mode, result, commit, files, findings, list_open, push_pending, reason}`) and prints a `systemMessage`, for example `Dream 2026-11-10 05:00: changed 3 files from 5 findings (a1b2c3d), 2 items on your list. Log: ~/.claude/dream/dream-log.md`. A finished run is shown once (its id is saved in `local/last-run.shown`); a failed run is shown at every start until a run succeeds.

### settings.json additions (merged into the existing arrays; nothing else changes)

```json
"PostToolUse":  { "matcher": "^(Write|Edit|NotebookEdit)$", "hooks": [ { "type": "command", "command": "~/.claude/hooks/dream-ledger.sh", "timeout": 5 } ] }
"SessionStart": { "matcher": "startup", "hooks": [ { "type": "command", "command": "~/.claude/hooks/dream-notice.sh", "timeout": 5 } ] }
```

### Unit files

```ini
# dream.service
[Unit]
Description=Dream pass: learn from recent Claude Code sessions (rules: ~/.claude/dream/DREAM.md)
[Service]
Type=oneshot
WorkingDirectory=%h
Environment=PATH=%h/.local/bin:/usr/local/bin:/usr/bin:/bin
EnvironmentFile=-%h/.config/dream/env
ExecStart=/usr/bin/python3 %h/.claude/dream/bin/dream run
MemoryMax=6G
MemorySwapMax=0
Nice=10
TimeoutStartSec=5400
SuccessExitStatus=3

# dream.timer
[Unit]
Description=Dream pass at 05:00 and 17:00
[Timer]
OnCalendar=*-*-* 05:00:00
OnCalendar=*-*-* 17:00:00
Persistent=true
[Install]
WantedBy=timers.target
```
A run by hand is `systemctl --user start dream.service`, so it has the same memory cap. `dream run` typed directly prints a warning that it is uncapped.

### Seeds for the guard data (the builder writes them; the reviewer checks them against the live files)

- `conf/targets.txt` allow: `.claude/CLAUDE.md`, `.claude/project-docs/*/CLAUDE.md`, `.claude/projects/*/memory/**/*.md`, `.hermes/skills/**/*.md`, `.hermes/skills-library/skills/**/*.md`, `.hermes/plans/claude-setup/enforce-backlog.md` (append only), and the dream's own `dream-log*.md`, `justin-list.md`, `state/*.json`. Never: `.claude/dream/DREAM.md`, `.codex/**`, `Leorna/**`, `.hermes/memories/**`, `.hermes/plans/**/evidence/**`, `.claude/projects/*/*.jsonl`, anything not `.md` under a skill. Every allowed path must also match a `manifest.txt` line and not match `sync.sh`'s `DENY_RE`; the test checks this against the real files.
- `conf/protected.tsv` (file, heading; the whole section is frozen): in `~/.claude/CLAUDE.md`: "Git & GitHub Privacy", "Git Commit Authorship — Read Every Time", "Worktrees from `claude -w` — Finishing a Feature", "Setup Sync — Mac ⇄ Windows Desktop", "Windows Desktop: Runaway Memory (2026-11-02)", "Dream Pass"; `leorna/SKILL.md` "Hard rules (details live in memory)"; `feature-dispatch/SKILL.md` "Merge policy per project"; all of `git-commit-rules/SKILL.md`. A heading that no longer exists in its file fails the guard (so a rename cannot unprotect a section).
- `conf/canary.tsv`: at least 25 exact strings taken from the live files, among them both git identities, "Never override git commit author metadata", "never merge", "`--ff-only`", "Never run `gh auth switch`", the tag name `pre-dream-2026-11-09`, and the Hermes 100,000-character limit line.
- `conf/projects.tsv` (folder-key glob, name, project skill, repeat-mistakes file): `-home-justin-Leorna*` → `leorna`; `-home-justin-Documents-FigmaToBricksV2*` → `figma-to-bricks`; `-home-justin`, `-home-justin--claude*`, `-home-justin--hermes*`, `-home-justin--cache*` → `claude-setup` with `feature-dispatch` and the general file; anything else → its folder key, memory folder only.

## Tasks (in the worktree; test first; commit after each with explicit paths, personal identity, no AI trailer)

Builder skills: `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (Task 16). Every test builds a fake home with `tests/fakehome.py`: a temp `HOME`, a bare setup repo with a local bare remote and the worktree's `sync.sh` (the way `~/.claude/setup/sync.test.sh` does it; read its first 60 lines), a fake library clone with an `origin`, and `tests/fake-claude`, a script that records its arguments and stdin and prints a canned result. No test touches the real `$HOME`, the real setup repo or the real `claude`, except the named-only live test. Run every Python test under the cap: `systemd-run --user --scope -q -p MemoryMax=4G -p MemorySwapMax=0 bash .claude/dream/tests/run.sh`.

0. **Worktree and baseline.** Create the worktree (header). Run each AC38 suite on the clean base, save its tally and failing names to `<evidence>/baseline.md`. Record `claude --version`.
1. **Skeleton.** `bin/dream`, `lib/dreamlib/paths.py`, `conf/*` with the seeds above, `tests/run.sh` (prints unittest `-v` output; `--live` adds the live test; names as arguments run only those), `tests/fakehome.py`, `tests/fake-claude`. `dream status` prints mode, last run and marker counts.
2. **Transcript extractor** (`extract.py`): AC1, AC2, AC3, AC42, AC43. Fixtures are hand-written lines in the measured shapes, never copies of real transcripts. The hand trial's script (`/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trial/extract.py`, if it still exists; `/tmp` is cleared on restart) is a starting point for the line shapes and the secret patterns, not the design: it keeps unlabelled lines by a prefix fallback, where this plan fails loudly, and it leaves out answers and slash arguments.
3. **Markers** (`state.py`, `dream init`): AC4, AC5.
4. **Review and AC lines** (`extract.py`): AC6. The fixture has a symlink loop; the test fails if the walk takes over 5 s.
5. **Agent runner, prompts, schemas** (`agents.py`, `prompts/`): AC29, AC30, then the live test of AC37 (run once by the builder, again by the verifier and the auditor with `tests/run.sh --live`).
6. **The bar** (`bar.py`): AC7, AC8, AC10, the finding half of AC12, the finding half of AC45.
7. **Targets, copy, editor and checker stages** (`targets.py`, `run.py`): AC13, the scope half of AC18.
8. **Guards** (`guards.py`): AC9, AC11, AC12, AC14, AC15, AC16, AC17, AC18, AC19, the guard half of AC20, AC44, the dated-line half of AC45. One function per guard, each returning a list of plain-word failures; `run.py` stops on any.
9. **Apply, commit, push, recovery** (`apply.py`): AC20, AC21, AC22, AC23, AC35.
10. **Log and trend** (`log.py`): AC24.
11. **Repeat mistakes** (`mistakes.py`, the three files with only their header, the pointer lines): AC27, AC28, the pointer half of AC36. Pointer line, the same in the three skills and (as part of the "Every brief names…" sentence) in `~/.claude/CLAUDE.md`: "Builders, reviewers and fixers read `<this skill>/references/repeat-mistakes.md` and `feature-dispatch/references/repeat-mistakes.md` before they start; every brief for those roles says so." In `feature-dispatch/SKILL.md` it goes under "Skills every agent loads". Do this task last among the code tasks and rebase on `main` first: dream-trim edits the same three skill files.
12. **Ledger hook and unattributed check** (`dream-ledger.sh`, `ledger.py`, `settings.json`): AC25, AC26.
13. **Session-start line** (`dream-notice.sh`, `settings.json`): AC31.
14. **Dry run, modes, the whole run end to end** (`run.py`): AC32, plus one end-to-end test per exit code (0, 3, 4).
15. **Install and undo** (`systemd/`, `dream install`, `dream undo`): AC33, AC34. `dream install` creates `~/.claude/dream/local/` with mode `dry-run`, copies the units, runs `systemctl --user daemon-reload`, and enables the timer only with `--enable`. The test uses a fake `systemctl` on `PATH` and the real `systemd-analyze --user verify` on the unit files.
16. **Mutation run on the guards** (`tests/mutants.sh`, under the 4G cap, never bare). Each mutant is one small change applied to a temp copy of `lib/`; the named test must fail. A surviving mutant is a finding to fix, not to explain away.

    | Mutant | Must be killed by |
    |---|---|
    | M1 quote check always true | AC7 |
    | M2 quote may come from the context block | AC7 |
    | M3 `implied` passes at once | AC8 |
    | M4 `loosens_safety` ignored | AC10 |
    | M5 protected-section comparison skipped | AC11 |
    | M6 gitleaks result ignored | AC12 |
    | M7 tries never reach 2 / checker "no" treated as "yes" | AC13 |
    | M8 growth of an over-budget file allowed | AC14 |
    | M9 per-file cap not applied | AC15 |
    | M10 canary check skipped | AC16 |
    | M11 unlisted removal accepted | AC17 |
    | M12 allowlist checked on the link path, not the real path | AC18 |
    | M13 copy-time hash not compared | AC19 |
    | M14 clone commit count not checked | AC20 |
    | M15 staged-set comparison skipped | AC21 |
    | M16 markers move before the commit | AC24 |
    | M17 dry run applies | AC32 |
    | M18 quote accepted when it is anywhere in the digest, not in the named entry | AC7 |
    | M19 an unchosen option of an answer is quotable | AC43 |
    | M20 "already saved" text not looked up in the file | AC44 |
    | M21 `ambiguous` ignored / a dated line replaced without a naming finding | AC45 |
17. **Docs & records** (below), then AC36 and AC38, then stop at `ready-for-review`.

## Docs & records (every file the build and the finish update)

- `~/.claude/dream/DREAM.md`: the changes listed in the next section, and the status line changed to "built, mode dry-run, timer off" (the finisher changes it again when the timer goes on).
- `~/.claude/CLAUDE.md`: rewrite the section "Dream Pass (planned 2026-11-09, not running yet)" to say what runs, when, in which mode, where the log and Justin's list are, `dream undo`, the off switch (`dream mode off` or `systemctl --user disable --now dream.timer`), and that sessions must not hand-edit the three repeat-mistakes files; add the repeat-mistakes pointer to the pipeline section's "Every brief names…" sentence; in "Subagents report skill lessons" add half a line that the dream reads the same skills and never duplicates a saved lesson. Keep the file under 30,000 bytes.
- `~/.claude/setup/manifest.txt`: add `:(glob).claude/dream/*.md`, `:(glob).claude/dream/bin/**`, `:(glob).claude/dream/lib/**`, `:(glob).claude/dream/conf/**`, `:(glob).claude/dream/prompts/**`, `:(glob).claude/dream/state/**`, `:(glob).claude/dream/systemd/**`, `:(glob).claude/dream/tests/**`; the existing `.claude/dream/DREAM.md` line stays.
- `~/.claude/setup/exclude.txt`: add `/.claude/dream/local/`.
- `~/.claude/settings.json`: the two hook entries.
- `~/.claude/setup/desktop.md`: a "Dream pass" part: install, the linger step, modes, a run by hand, where the log, list, markers and working files are, undo, off switches, the optional `~/.config/dream/env` token, troubleshooting (login failed, CLI flag missing, unknown transcript shape).
- `~/.claude/setup/mac.md`: one line: the dream runs on the desktop only; both hooks are silent on the Mac.
- `~/.github/README.md`: a row for `.claude/dream/` in "What's in the repo", `~/.claude/dream/local/` and `~/.cache/dream/` in "What is NOT in the repo", one Troubleshooting row, one Status line.
- The three skills' pointer lines and the three `references/repeat-mistakes.md` files (Task 11).
- `~/.hermes/plans/claude-setup/dream-pass.md` (this plan: the finisher adds a "Landed" line) and `<evidence>/plan-approved.md` (the orchestrator's copy on "go").
- `~/.hermes/plans/claude-setup/enforce-backlog.md`: unchanged by the build; the dream appends to it later.

### Changes to DREAM.md (where this plan differs from the draft)

- Section 2: add "sessions with no typed message" and "headless sessions" to what is not read; say that a message typed while Claude was working counts.
- Section 3: add Justin's answers to Claude's questions (the option he chose and anything he wrote) and typed slash-command text as evidence; add "an ambiguous message, or one meant for a single task, is never evidence for a rule: it becomes a question on Justin's list", "a message that cannot be understood without its image waits for a repeat", "a voice-note slip is quoted as typed; the lesson carries the corrected reading", and "a short paste is not marked by Claude Code and reads as typed (known gap)".
- Section 4: add "a dated rule is replaced only by a clear statement that names what it replaces".
- Section 5: skills means `.md` files only; a project `CLAUDE.md` is written as the synced copy and the project's own file together; add `enforce-backlog.md` (append only) and the dream's own log, list and state; add "Never: `~/.hermes/memories/`" (question 1).
- Section 6: the budgets (question 2) and caps (question 3) in place of the two *(plan)* lines; add the v1 rule for cutting (question 8) and the tidy limit (a file already being edited, or up to 2 over-budget files).
- Section 7: the entry heading format, and "the script writes the count and the stories; the editor writes the wording".
- Section 10: step 3 "3 at a time"; step 4 "a finding whose quote is not found is dropped and logged" (question 5); step 8 names the second pull, the lock and that the commit holds only the dream's paths; add "findings that fail to go live twice go on Justin's list"; add the two modes.
- Section 11: the ledger is per machine (`local/ledger.jsonl`); Codex edits show as unattributed until the follow-up (question 7).
- Section 6: add "search first: a lesson that is already saved is counted, not added again".
- Section 12: add model calls and tokens, what was dropped, and the count of findings that were already saved.
- Section 13: remove "a quote that cannot be found"; add "GitHub unreachable", "a CLI flag is missing", "the editor tried to leave its folder".
- Section 14: `~/.claude/dream/bin/dream undo <commit>` instead of a bare revert, with the reason (library clone, project copies).

## Tests and validation

- Unit and end-to-end tests with the fake home and `fake-claude`: every AC1–AC36 and AC42–AC45 test. End-to-end tests run the real `sync.sh` from the worktree against the local remote and the real `gitleaks`.
- A fake secret in a fixture is built at run time from pieces, never written whole in a synced file: `sync.sh`'s gitleaks scan would otherwise block every sync.
- Live, named-only: AC37 (`tests/run.sh --live`, two small real calls, about 10 cents of subscription use each time).
- Mutation run: Task 16, capped.
- Regression: AC38 through `tests/regression.sh <evidence>/baseline.md` (it does nothing without the baseline path, so it never fails a later story).
- Evidence per AC: a terminal capture of its test run; AC36 also a capture of `grep -n repeat-mistakes` over the four files.
- The verifier and the auditor run the suites in their own scratch copies and never start the real timer, change the real mode file or run `dream run` against the real `$HOME`.

## What a run costs

- **Nothing new:** zero tokens. The script exits before any agent starts.
- **One session helper (Opus 5.5, xhigh):** the hand trial measured 92,000, 104,000 and 178,000 tokens (2 to 5 minutes) for whole sessions of 33, 41 and 147 messages, with tools the real helpers will not have. Plan on 90,000 to 180,000 tokens per helper in the backfill. A digest holds about 340 tokens per typed message with its context (199,000 characters for 147 messages); typed text is about 13% of that.
- **A normal run after the backfill** reads only what is new: about 60 typed messages a day across all sessions (870 in 14 days), so about 30 per run in perhaps 3 to 6 sessions. Each of those helpers gets a digest of a few thousand tokens; its total is not measured yet and the first live runs' log entries will show it.
- **The backfill:** 44 sessions at 8 per run is 6 runs, each up to 8 × 90,000–180,000 = 0.7 to 1.4 million tokens for helpers, so 4 to 8 million tokens over three days, plus 3 review helpers once (the largest gets about 211 lines of 400 characters, about 21,000 tokens of input).
- **Editor and checker:** one each per run that has findings. Not measured at xhigh; the editor reads the files it edits (a 90,000-byte skill is about 23,000 tokens).
- **Why 1,500 characters of context stays:** the trial's helpers could follow every message with it; a shorter cut would lose more of the option lists Justin answers. Two changes bound the cost instead: the cut moves back to a paragraph start (3,000 at most), and one helper's digest stops at 120,000 characters.
- Every run's log entry records its calls and tokens, so the real numbers replace these after the first week.

## Staging the first real run (so it cannot do much damage)

1. The story merges with the timer off, `local/` created by `dream install`, mode `dry-run`. From then the ledger records and the session-start hook is live; nothing reads sessions.
2. The finisher's after-merge step runs `dream install` (no `--enable`) and `dream init`, and checks `dream status`. dream-trim must be on `main` before step 3 (see Overlaps).
3. Justin starts one dry run (`systemctl --user start dream.service`) and reads `~/.cache/dream/<run>/would-apply.diff` (AC40).
4. Justin types `~/.claude/dream/bin/dream mode live` and starts one live run by hand; the commit is checked on GitHub and the library clone has no commit (AC41).
5. `sudo loginctl enable-linger justin` (Justin, in the Ubuntu window, one line) and `systemctl --user enable --now dream.timer` (AC39).
Undo at any point: `dream undo <commit>`; everything before the first dream is the tag `pre-dream-2026-11-09`. Off: `dream mode off`.

## Overlaps

- **dream-trim (Mini, planned in parallel).** Both jobs edit `figma-to-bricks/SKILL.md`, `feature-dispatch/SKILL.md` and `leorna/SKILL.md` (dream-pass adds one pointer line to each and a new `references/repeat-mistakes.md` beside them; dream-trim moves sections out). dream-trim also edits `~/.claude/project-docs/figma-to-bricks/CLAUDE.md`, which dream-pass does not touch at build time. **dream-trim lands first.** dream-pass builds in parallel in its own worktree, adds its pointer lines last (Task 11) after rebasing on `main`, and its finisher rebases again. `conf/budgets.tsv` takes dream-trim's approved targets into account (question 2). Until dream-trim lands, the first live run is not started: three of the four files are at or over budget, so the dream could only shrink them.
- **The hand trial** (three sessions, scratch only) is finished and its results are in this plan: mid-turn prompts, slash arguments and question answers are evidence (AC42, AC43), the quote must be in the named entry (AC7), dedupe comes first and "already saved" is counted (AC44), an ambiguous message never replaces a dated rule and an unseen image means "wait" (AC45), context is cut at a paragraph and scrubbed (AC1, AC12), helpers get no tools (AC29). In-session agent retries stay out of v1: the trial found failures are marked only by `is_error: true` on a tool result, pipes and `|| true` hide about half of them, almost all are in subagent transcripts (18 in one main session against 586 in its subagents), and pairing a failure with its retry is good to about ±20%.
- **Other writers to the same files** (the nudge hook, `skill_lessons` saved by the main session, auto memory, the CortexOS hook): the editor searches a target before adding, `state/applied.json` stops the same quote being applied twice, and the hash check stops the dream writing over an edit made during its run. Dream edits do not pass through Claude Code's hooks, so skill edits made by the dream do not reach CortexOS (memory notes do, at the next session start's reconcile).

## Choices the planner made

- Python 3 with the standard library only for the job; bash and `jq` for the two hooks, in the house style (fail open, tests beside them).
- Helpers and the checker have no tools at all; the editor has file tools confined to a copy by `--restricted`. Proven here, and pinned by a live test because the CLI updates itself.
- The editor edits real files in a copy and reports what it did in `changes.json`; scripts compare that report with the actual diff line by line. No script trusts the editor's own description.
- The dream holds `sync.sh`'s lock itself and commits its exact paths; `sync.sh` is not changed. Pushing is always done by `sync.sh`.
- The log, Justin's list, the pending list and the tally sync (so the Mac can read them and a revert takes them back together); markers, the ledger and the journal are per machine.
- Model `claude-opus-5-5` at `xhigh` for every agent, pinned by full name in `conf/models.conf` and checked against each result.
- Safety is enforced twice: helpers flag findings, and frozen sections plus canary facts are checked by a script whatever the models say.
- A run that read something always commits its log entry and state, even with no target changed. A run with nothing new writes nothing.
- A queued message, a prompt typed mid-turn, typed slash-command text and an answer to one of Claude's questions all count as typed. A paste counts only when it is the whole message (the brief's rule).
- An unknown line shape stops that session loudly; the trial script's "keep it by prefix" fallback is not used.
- The digest keeps 1,500 characters of context, cut at a paragraph (reasons in "What a run costs").
- A pending candidate expires after 60 days; working files after 14.
- v1 leaves out: subagent transcripts, Codex and Mac sessions, in-session retries, Codex ledger rows, Hermes memory files.

## Risks and trade-offs

- **A wrong lesson goes live with no review** (Justin's choice). Limits: evidence must be his own quoted words or a mistake seen in two stories, caps and budgets bound each run, frozen sections and canary facts cannot change, every removal is logged with its text, and `dream undo` restores a run.
- **Text in a paste, a review finding or a file tries to instruct the agents.** Helpers and the checker have no tools; the editor cannot leave the copy; quotes from pastes inside messages are impossible by construction; the guards are scripts.
- **Subscription use** (numbers in "What a run costs"). The 17:00 run shares the limit and the memory with working sessions. A limit error stops the run with nothing lost.
- **A short paste reads as typed.** Claude Code marks only long pastes; a few pasted lines inside a message cannot be told from typing. Bound: the helper is told that copied material (log lines, code, another tool's output) is not a statement by Justin, and a rule still needs his own words around it to pass the checker. Accepted as a known gap.
- **Most findings are already saved.** In the trial the live lesson-saving had caught most of them the same day. The dream's value is then in what it adds beyond that; the log's "already saved" count shows it run by run, and if it stays near 100% the helper cap or the schedule can come down.
- **Helpers cannot see images.** A correction that depends on a screenshot waits for a repeat instead of being learned from half the message.
- **The CLI changes a flag** (it updated itself during planning). The preflight stops the run, and the live test fails in the next story that runs it.
- **The login expires** (question 6).
- **The transcript format changes.** The extractor stops loudly and the session-start line says so; nothing is silently skipped.
- **A sync conflict with the Mac** after the dream commit: `sync.sh` reports CONFLICT at the next session start, as for any edit; the commit is local until merged by hand.
- **`sync.sh`'s `mkdir` lock can have two holders** on this desktop. The dream takes it atomically, but a `sync.sh` starting in the same instant could still enter. The staged-set check and the explicit commit paths keep the dream commit clean even then.
- **A library skill the dream edited changes upstream** in the same place: `sync.sh` then warns that the patch no longer applies. One block per file keeps this rare; it is fixed by hand as today.
- **Sessions already open hold the old text** of a file the dream changed, as after any sync.
- **The log holds Justin's quoted messages** and is pushed to his private repo. Secrets are scanned out; personal details about others are dropped before logging.
- **Size of the build:** 45 acceptance criteria, about 12 Python modules and 2 hooks. The tasks are ordered so the job is useful and safe in dry-run mode from Task 14.

## Touched files (`$HOME`-relative; the same path in the worktree)

New: `.claude/dream/bin/dream`, `.claude/dream/lib/dreamlib/{__init__,paths,extract,state,agents,bar,targets,guards,apply,ledger,mistakes,log,run}.py`, `.claude/dream/conf/{targets.txt,budgets.tsv,caps.conf,canary.tsv,protected.tsv,projects.tsv,models.conf}`, `.claude/dream/prompts/{session-helper,review-helper,editor,checker}.md` and their `.schema.json` files, `.claude/dream/systemd/{dream.service,dream.timer}`, `.claude/dream/tests/**`, `.claude/dream/{dream-log.md,justin-list.md}`, `.claude/dream/state/{pending,tally,applied,trend}.json`, `.claude/hooks/dream-ledger.sh`, `.claude/hooks/dream-notice.sh`, `.claude/hooks/tests/dream-ledger.test.sh`, `.claude/hooks/tests/dream-notice.test.sh`, the three `references/repeat-mistakes.md` files.
Changed: `.claude/dream/DREAM.md`, `.claude/CLAUDE.md`, `.claude/settings.json`, `.claude/setup/manifest.txt`, `.claude/setup/exclude.txt`, `.claude/setup/desktop.md`, `.claude/setup/mac.md`, `.github/README.md`, `.hermes/skills/software-development/leorna/SKILL.md`, `.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`.
Not changed: `.claude/setup/sync.sh`, anything under `.codex/`, `~/.hermes/skills-library`, `~/Leorna/`.
On this machine only, at install: `~/.claude/dream/local/`, `~/.config/systemd/user/dream.{service,timer}`, `~/.cache/dream/`.

## Other things found (not fixed, not folded in)

- The planner brief and the hand-trial brief list `[Image ` as an injected prefix to leave out; 78 typed messages start with `[Image #N]` and then Justin's text, so that rule drops them. Evidence: `prefix × promptSource` count `('[Image ', 'typed') 75`, `('[Image ', 'queued') 3`; the hand trial found the same (6 and 2 dropped) and corrected its script. Medium for anything else built from that list.
- A local `git revert` of a setup-repo commit that changed `skills-library-local.patch` does not change the clone, and the next sync's `save_lib_patch` (`sync.sh:129-135`) writes the clone's edits back into the patch, silently undoing the revert. Medium; this plan's `dream undo` covers dream commits only.
- `sync.sh` `copy_in` (`sync.sh:106-113`) overwrites `~/.claude/project-docs/<name>/CLAUDE.md` with the project's file whenever they differ, so an edit made only to the copy on a machine that has the project is lost at the next sync, with no message. Low to medium.
- `sync.sh:86` still uses a `mkdir` lock, which is not atomic with uutils on this desktop (already offered as a follow-up on 2026-11-07). Low.
- Memory notes far over any budget: `leorna-workflow.md` 168,730 bytes, `leorna-control-plane-workflow.md` 39,217, `v2-rewrite.md` 16,338, `own-control-plane-install.md` 15,960. dream-trim does not cover them; under this plan they can only shrink. Low.
- Older `review.json` files use `high/medium/low` and `file`/`line` (48 findings), and 12 are nested copies of other reviews; anything that counts findings across stories must handle both. Low.
- Evidence folders contain symlinks into `node_modules` and worktrees (856 links); a recursive Python glob over `~/.hermes/plans/*/evidence` did not finish in 120 s. Low.
- Claude Code updated itself from 2.1.321 to 2.1.322 during the day; anything that depends on CLI flags can break without a change on this side. Low.

## Completion and reporting

The builder stops at `ready-for-review` with the worktree branch and HEAD, the AC1–AC38 and AC42–AC45 test output, the mutation table, `<evidence>/baseline.md` and one terminal capture per AC. AC39, AC40 and AC41 are owed to Justin after the merge. The finish follows "Worktrees from `claude -w`" applied to the setup repo: rebase on local `main` (after dream-trim), `merge --ff-only`, the after-merge steps in "Staging" (1 and 2 only), then `sync.sh`.

## Justin's answers

Approved by Justin 2026-11-09. His message was "Continue sorry", sent after both plans and their questions were shown; the main session read it as "go" with every recommended option: Q1 (a) Hermes memory files are not targets; Q2 (a) budgets as recommended; Q3 (a) caps as recommended; Q4 (a) systemd timer with Persistent=true, linger enabled; Q5 (a) drop a finding whose quote is not in the message, discard the helper output if more than half fail; Q6 (a) use the existing login; Q7 (a) Codex ledger rows are a follow-up; Q8 (a) cut only what his message proves outdated, duplicates, word-for-word moves and retired entries; Q9 (a) one dry run by hand, one live run by hand, then the timer. AC39, AC40 and AC41 are live and stay his.

Added by Justin 2026-11-10, mid review loop. His message was "Add fixer", in answer to the main session's question "Add the pointer fix now? … Say 'add the pointer fix', or leave it as a follow-up"; the main session read it as "add the pointer fix". Scope: review 2's finding R2-9 (rated P3 by the reviewer, so it was a follow-up) is to be fixed now, in the next fix round: a section moved word for word out of an over-budget file into a `references/` file may leave one pointer line behind, of one fixed shape that the script checks (it names the file, and that file holds the moved text), without a finding; and an over-budget memory note may move text to a new note the same way. Everything else about AC17 stands: no other added line without a finding or an order.

Added by Justin 2026-11-10, mid review loop. His message was "Whatever you want", in answer to the main session's message that put two choices to him with its recommendation for each; the main session read it as "do what you recommend" for those two, and as nothing more (pass 2 of dream-trim still needs his own "land pass 2"). (1) Fixer 3's question: option (b), the script never orders a kind added or moved when it is already due to retire where it would be listed; it is listed if it comes back in a newer story. (2) Review 3's finding R3-3 (rated P3 by the reviewer) is to be fixed in the next fix round: a fold may not change the old line's last word or number ("can" to "can't", "at most 3" to "3,000"); the old line must stay whole, and new words may only follow it.

Main session's note, 2026-11-10, under the same "Whatever you want": review 4 was clean (MOVE ON at 877c99e) and found two gaps in the pointer fix Justin asked for, both rated P3 by the reviewer. The main session added them to the same fix round as the two items above and told Justin so: R4-1 (a pointer may only name a plainly named file, so a sentence or a backtick in a file name cannot go live) and R4-8 (the checker's prompt names the three things that need no finding: a word-for-word move, its one pointer line of the fixed shape, the script's own rewrite of counts and order). If Justin objects, these two are dropped.

Main session's note, 2026-11-10, under the same "Whatever you want": review 5 found one P2 (R5-1: at the first live run the stories are counted in folder-name order, not time, so newest mistakes count as already due to retire) and the main session added two prompt sentences from the same review, both rated P3 (R5-3: the editor's prompt says the safe way to fold; R5-4: the prompt says the plain-name rule where it talks about a new memory note). No rule changes for those two. If Justin objects, they are dropped.

Added by Justin 2026-11-10, at the finish step. The main session asked: the rule says the verifier and auditor run again whenever the code changes after they accept it, but his other sessions push to the setup repo 4 to 16 times an hour and the two checks take about an hour, so `main` will always have moved; may the last step skip a second verifier and auditor round when the final rebase changes nothing? His answer (the option he picked): "Yes, if the rebase is pure". Meaning, as put to him: the verifier and auditor run once on the rebased head; then a finisher rebases onto the newest `main`, and if every commit is unchanged (range-diff all "="), there is no conflict and all test suites pass, it lands at once; any conflict or changed commit means a fresh review and a full re-check. This allowance is for dream-pass only.
