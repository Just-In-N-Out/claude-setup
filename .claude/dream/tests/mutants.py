"""Mutation run on the dream's guards (plan Task 16; mutation-testing-discipline).

Each mutant is one small change to one file of a scratch copy of the checkout's HEAD (never the checkout
itself). The change's text must match exactly once (else BLIND, not a pass). The named tests run on the
mutated copy under the memory cap; the mutant is KILLED only when every named test prints its own
`not ok N - <name>` line. The file's bytes are restored after each mutant and checked by sha256.
Usage (from mutants.sh): python3 mutants.py <copy root> <report.md> [mutant id...]
"""
import hashlib
import os
import re
import subprocess
import sys
import time
from pathlib import Path

L = ".claude/dream/lib/dreamlib/"
H = ".claude/hooks/"
T = {
    "ac6": "test_ac6_review_and_failed_ac_lines_are_new_and_counted_once",
    "ac7": "test_ac7_finding_without_verbatim_typed_quote_never_reaches_editor",
    "ac8": "test_ac8_explicit_passes_at_once_and_single_sightings_wait_across_runs",
    "ac10": "test_ac10_safety_loosening_and_weakened_checks_go_to_justins_list",
    "ac11": "test_ac11_protected_section_change_blocks_the_run",
    "ac12": "test_ac12_secrets_and_personal_details_are_never_written",
    "ac13": "test_ac13_checker_no_leaves_live_files_untouched_and_parks_after_two_tries",
    "ac14": "test_ac14_file_over_budget_may_only_shrink",
    "ac15": "test_ac15_change_caps_block_oversized_runs_and_ignore_verbatim_moves",
    "ac16": "test_ac16_missing_canary_fact_blocks_the_run",
    "ac17": "test_ac17_every_removed_and_added_line_is_accounted_for",
    "ac18": "test_ac18_only_allowed_targets_and_narrowest_scope",
    "ac19": "test_ac19_target_changed_since_copy_blocks_apply",
    "ac20": "test_ac20_library_edit_travels_only_in_the_patch_file",
    "ac21": "test_ac21_one_dream_commit_holds_only_the_dreams_paths_and_is_pushed",
    "ac24": "test_ac24_log_entry_quotes_evidence_and_markers_move_after_commit",
    "ac26": "test_ac26_unattributed_change_is_logged_once",
    "ac29": "test_ac29_headless_calls_carry_isolation_flags_and_preflight_stops_on_a_missing_flag",
    "ac30": "test_ac30_eight_session_helpers_per_run_three_at_a_time_newest_first",
    "ac32": "test_ac32_dry_run_stops_before_the_apply_step",
    "ac34": "test_ac34_undo_reverts_live_files_library_edits_and_project_copies",
    "ac43": "test_ac43_question_answers_are_entries_and_only_the_chosen_text_is_quotable",
    "ac44": "test_ac44_already_saved_findings_are_verified_counted_and_not_added_again",
    "ac45": "test_ac45_an_ambiguous_message_never_replaces_a_dated_rule",
    "ac25": "ac25_ledger_records_target_edits_through_links_and_fails_open",
    "ac31": "ac31_session_start_line_reports_the_last_dream",
    "ac1": "test_ac1_digest_holds_only_typed_messages_with_context",
    "ac3": "test_ac3_unknown_transcript_shape_fails_loudly",
    "ac4": "test_ac4_nothing_new_makes_no_model_call",
    "ac42": "test_ac42_mid_turn_prompts_and_slash_arguments_are_typed_and_nothing_is_counted_twice",
    # review 1 fixes (fixer 1)
    "freeze": "test_a_nul_line_left_by_a_freeze_is_skipped_and_noted",
    "unread": "test_an_unreadable_session_does_not_stop_review_lines_or_waiting_findings",
    "unreadline": "test_unreadable_sessions_show_in_the_session_start_line",
    "unreadhook": "dream_unreadable_sessions_show_in_the_session_start_line",
    "tidy": "test_a_tidy_adds_nothing_and_a_duplicate_names_a_whole_line_that_stays",
    "rmrewrite": "test_the_scripts_own_heading_rewrite_in_a_repeat_mistakes_file_goes_live",
    "applieddiff": "test_a_finding_listed_as_applied_needs_a_diff_holding_its_additions",
    "applytries": "test_a_stop_in_the_apply_step_adds_no_try",
    "ownfiles": "test_an_edit_the_second_pull_brings_to_the_dreams_own_files_is_kept",
    "undoguard": "test_undo_refuses_while_the_library_clone_or_a_project_file_holds_unsynced_edits",
    "rmshape": "test_text_outside_the_entries_of_a_repeat_mistakes_file_cannot_change",
    "rmbudget": "test_the_script_orders_only_the_entries_that_fit_a_repeat_mistakes_file_most_frequent_first",
    "ctxmarker": "test_the_first_message_after_a_marker_keeps_claudes_text_before_it",
    "unattr": "test_an_unattributed_change_seen_by_a_run_that_commits_nothing_is_logged_by_a_later_run",
    "clearfail": "test_a_nothing_new_run_clears_a_failed_run_and_mode_off_stops_promising_a_run",
    "offhook": "dream_a_failed_run_says_the_dream_is_off_and_clears_after_a_nothing_new_run",
    "badchanges": "test_a_changes_json_of_the_wrong_shape_stops_the_run_and_counts_a_try",
    "evidence": "test_an_evidence_file_that_is_not_a_json_object_is_skipped",
    "crash": "test_a_crash_shows_in_the_session_start_line",
    "wiring": "test_run_all_runs_every_guard",
    "limits": "test_each_cap_and_limit_stops_the_run_on_its_own",
    "typedlabel": "test_a_dated_line_is_replaced_only_by_a_finding_from_typed_text",
    "logsecret": "test_a_secret_in_the_log_entry_stops_the_run",
    "denials": "test_the_editor_leaving_its_folder_stops_the_run",
    "libpre": "test_the_library_clone_must_have_nothing_staged_and_equal_the_patch_file",
    "gitstatus": "test_the_apply_step_refuses_a_target_with_someone_elses_uncommitted_edit",
    # review 2 fixes (fixer 2)
    "basis": "test_a_change_counts_only_in_a_file_its_basis_belongs_to",
    "rmcharge": "test_the_scripts_own_rewrite_of_a_repeat_mistakes_file_is_not_charged_to_its_cap_or_budget",
    "allowance": "test_an_ordered_entry_is_held_to_the_allowance_the_editor_is_given",
    "fold": "test_a_lesson_folded_into_a_line_keeps_that_line_whole_and_needs_no_replaces",
    "memkey": "test_a_finding_of_a_worktree_session_targets_the_memory_folder_of_its_repository",
    "codedrop": "test_a_lesson_dropped_for_a_code_like_token_is_named_on_justins_list_without_its_text",
    # review 3 fixes (fixer 3)
    "missingmove": "test_a_move_order_whose_entry_is_missing_from_its_file_is_an_add_where_it_now_belongs",
    "orderkinds": "test_every_kind_of_order_goes_through_every_reader_of_its_fields",
    "classcap": "test_orders_done_exactly_at_their_largest_size_pass_every_guard_run_after_run",
    "capedge": "test_at_the_change_caps_edge_blank_lines_and_area_headings_count_too",
    "pointer": "test_a_move_out_of_an_over_budget_file_may_leave_one_pointer_line_the_script_checks",
    # fixer 4 (Justin's 2026-11-10 round)
    "checkerprompt": "test_the_checkers_prompt_names_the_four_changes_that_need_no_finding",
    "foldtoken": "test_a_fold_keeps_the_old_lines_last_word_or_number_whole",
    "plainname": "test_a_pointer_names_only_a_plainly_named_file",
    "retireb": "test_a_kind_already_due_to_retire_is_not_listed_until_it_comes_back",
    # fixer 5: R5-1 (stories counted by date), R5-3 and R5-4 (the editor's prompt)
    "r51first": "test_the_first_run_counts_stories_by_their_dates_not_their_folder_names",
    "r51late": "test_a_story_counted_in_a_later_run_takes_its_place_by_its_date",
    "r51round": "test_a_mistake_seen_again_in_a_later_round_of_an_older_story_is_not_stale",
    "r51mig": "test_a_tally_written_before_stories_had_dates_is_put_in_their_order_by_date",
    "r51tie": "test_of_two_equally_frequent_mistakes_with_room_for_one_the_more_recent_is_listed",
    "safefold": "test_the_editors_prompt_gives_a_fold_the_script_always_accepts",
    "newnote": "test_the_editors_prompt_gives_the_name_rule_where_it_writes_a_new_memory_note",
    # fixer 6: R6-1
    "r61": "test_a_listed_mistake_seen_again_in_lines_past_the_150_a_run_reads_stays_listed",
    "r61unread": "test_no_repeat_mistakes_order_is_given_while_review_lines_on_disk_wait_unread",
    "r61late": "test_a_mistake_removed_while_a_review_file_lands_during_the_run_is_not_retired_for_good",
}
P = ".claude/dream/prompts/"
ALL_GUARDS = ("ALL = [g_links, g_allowlist, g_protected, g_budgets, g_caps, g_canary, g_accounting, g_settled, "
              "g_dated_lines,\n       g_dates_on_additions, g_secrets, g_repeat_mistakes, g_memory_index, g_library]")


def drop(g):
    """Review 1's W mutants: one guard left out of guards.run_all."""
    return (L + "guards.py", ALL_GUARDS, ALL_GUARDS.replace("ALL = [", "ALL = [x for x in [") + " if x is not %s]" % g)

# (id, what it breaks, [(file, old text, new text)...], killing test keys)
MUTANTS = [
    ("M1", "quote check always true", [(L + "bar.py", "    q = norm(quote)\n    if not q:\n        return False\n",
                                        "    return True  # M1\n")], ["ac7"]),
    ("M2", "quote may come from the context block", [(L + "bar.py", '    return [entry.get("text") or ""]\n',
                                                      '    return [entry.get("text") or "", entry.get("context") or ""]\n')], ["ac7"]),
    ("M3", "implied passes at once", [(L + "bar.py", "        if kind in STATED:\n",
                                       '        if kind in STATED or kind == "implied":\n')], ["ac8"]),
    ("M4", "loosens_safety ignored", [(L + "bar.py", '        if f.get("loosens_safety") or f.get("weakens_check"):\n',
                                       '        if f.get("weakens_check"):\n')], ["ac10"]),
    ("M5", "protected-section comparison skipped", [(L + "guards.py", "            elif new != old:\n",
                                                     "            elif False:\n")], ["ac11"]),
    ("M6", "gitleaks result ignored", [(L + "extract.py",
                                        "    return [bool(s) or any(rx.search(t) for rx in TOKEN_RES)",
                                        "    return [any(rx.search(t) for rx in TOKEN_RES)")], ["ac12"]),
    ("M7a", "tries never reach 2", [(L + "run.py", '            f["tries"] = f.get("tries", 0) + 1\n',
                                     '            f["tries"] = f.get("tries", 0)\n')], ["ac13"]),
    ("M7b", 'checker "no" treated as "yes"', [(L + "run.py", '            if res.data.get("verdict") != "yes":\n',
                                               "            if False:\n")], ["ac13"]),
    ("M8", "growth of an over-budget file allowed", [(L + "guards.py", "            if old > cap and new > old:\n",
                                                      "            if False:\n")], ["ac14"]),
    ("M9", "per-file cap not applied", [(L + "guards.py", '        if added > c.get("file_added", 3000):\n',
                                         "        if False:\n")], ["ac15"]),
    ("M10", "canary check skipped", [(L + "guards.py", "        if d and row[1] in d.old and row[1] not in d.new:\n",
                                      "        if False:\n")], ["ac16"]),
    ("M11", "unlisted removal accepted", [(L + "guards.py", "            if not removal_ok(G, d, ln, cs):\n",
                                           "            if False:\n")], ["ac17"]),
    ("M12", "allowlist checked on the link path, not the real path", [
        (L + "guards.py", '        if d.status == "A" and targets.through_link(env, live):\n', "        if False:\n"),
        (L + "guards.py", '        real = env.real_rel(live) if d.status == "A" else live\n', "        real = live\n")], ["ac18"]),
    ("M13", "copy-time hash not compared", [(L + "apply.py", '            if cur != w["copy_sha"]:\n',
                                             "            if False:\n")], ["ac19"]),
    ("M14", "clone commit count not checked", [(L + "apply.py", "def library_local_commits(env):\n",
                                                "def library_local_commits(env):\n    return 0\n")], ["ac20"]),
    ("M15", "staged-set comparison skipped", [(L + "apply.py", "    foreign = sorted(staged - set(gp))\n",
                                               "    foreign = []\n")], ["ac21"]),
    ("M16", "markers move before the commit", [(L + "apply.py", '        for w in P.writes:\n            write_live(w["path"], w["data"])\n',
                                                '        _c = state.load_cursors(env)\n        _c.update({k: state.commit_cursor(v) for k, v in '
                                                'P.markers_after.items()})\n        state.save_cursors(env, _c)\n'
                                                '        for w in P.writes:\n            write_live(w["path"], w["data"])\n')], ["ac24"]),
    ("M17", "dry run applies", [(L + "run.py", '    if mode != "live":\n        return dry_run(R, plan)\n',
                                 "    if False:\n        return dry_run(R, plan)\n")], ["ac32"]),
    ("M18", "quote accepted anywhere in the digest, not in the named entry",
     [(L + "bar.py", '        if e.get("uuid") != uuid:\n            continue\n        for t in quotable(e):\n',
       "        for t in quotable(e):\n")], ["ac7"]),
    ("M19", "an unchosen option of an answer is quotable",
     [(L + "bar.py", '        return [c for c in entry.get("chosen") or []]', '        return [c for c in entry.get("options") or []]')], ["ac43"]),
    ("M20", '"already saved" text not looked up in the file',
     [(L + "guards.py", "        if not ex or text is None or ex not in norm(text):\n", "        if not ex:\n")], ["ac44"]),
    ("M21a", "ambiguous ignored", [(L + "bar.py", '        if f.get("ambiguous") or any(p in q for p in phrases):\n',
                                    "        if any(p in q for p in phrases):\n")], ["ac45"]),
    ("M21b", "a dated line replaced without a naming finding",
     [(L + "guards.py", 'f.get("replaces", "").strip() and not f.get("ambiguous") and\n                           typed_label(f.get("label"))',
       "True")], ["ac45"]),
    # code whose test came after it (honest chronology): these show the tests can fail
    ("X6a", "the evidence walk follows links", [(L + "extract.py", "os.walk(ev, followlinks=False)", "os.walk(ev, followlinks=True)"),
                                                (L + "extract.py", '\n                             and not os.path.islink(os.path.join(root, d)))', ")")], ["ac6"]),
    ("X6b", "P3 findings counted", [(L + "extract.py", 'SEVERE = {"P0", "P1", "P2", "high", "medium"}',
                                     'SEVERE = {"P0", "P1", "P2", "P3", "high", "medium"}')], ["ac6"]),
    ("X6c", "a seen line counted again", [(L + "extract.py", "            if lid in seen:\n                continue\n", "")], ["ac6"]),
    ("X26", "a changed target never reported", [(L + "ledger.py", '        elif prev.get("sha256") != sha:\n',
                                                 "        elif False:\n")], ["ac26"]),
    ("X29a", "--safe-mode dropped", [(L + "agents.py", '"--no-session-persistence", "--safe-mode", "--setting-sources", "",',
                                      '"--no-session-persistence", "--setting-sources", "",')], ["ac29"]),
    ("X29b", "the editor without --restricted", [(L + "agents.py", 'base_cmd(R) + ["--restricted", "--tools", EDITOR_TOOLS,',
                                                  'base_cmd(R) + ["--tools", EDITOR_TOOLS,')], ["ac29"]),
    ("X29c", "a result from another model accepted", [(L + "agents.py", "    elif used != {model}:\n", "    elif not used:\n")], ["ac29"]),
    ("X29d", "preflight ignores a missing flag", [(L + "run.py", "    missing = agents.missing_flags(env)\n",
                                                   "    missing = []\n")], ["ac29"]),
    ("X30a", "8 helpers at once", [(L + "agents.py", "WORKERS = 3\n", "WORKERS = 8\n")], ["ac30"]),
    ("X30b", "the oldest sessions first", [(L + "state.py", "    s.reads.sort(key=lambda r: r.mtime, reverse=True)\n",
                                            "    s.reads.sort(key=lambda r: r.mtime)\n")], ["ac30"]),
    ("X34", "undo leaves the library clone", [(L + "apply.py",
        "    lib_too = env.rel(env.patch) in changed and (env.lib / \".git\").exists()\n", "    lib_too = False\n")], ["ac34"]),
    ("X25", "the ledger hook records the link path", [(H + "dream-ledger.sh", 'real=$(realpath -e -- "$f" 2>/dev/null) || exit 0\n',
                                                       'real=$f\n[ -e "$real" ] || exit 0\n')], ["ac25"]),
    ("X31", "a failed run shown only once", [(H + "dream-notice.sh", 'case "$result" in\n  failed | stopped) ;;\n  *)\n',
                                              'case "$result" in\n  *)\n')], ["ac31"]),
    # review 1's mutants (probe p15), re-derived where fixer 1 moved the code they name
] + [("W-" + g[2:], "%s left out of run_all" % g, [drop(g)], ["wiring"]) for g in (
    "g_links", "g_allowlist", "g_protected", "g_budgets", "g_caps", "g_canary", "g_accounting", "g_settled",
    "g_dated_lines", "g_dates_on_additions", "g_secrets", "g_repeat_mistakes", "g_memory_index", "g_library")] + [
    ("W-logsecrets", "the log entry is not scanned", [(L + "run.py", "    leaks = guards.log_secrets(env, plan.log_text)\n",
                                                      "    leaks = []\n")], ["logsecret"]),
    ("W-denials", "the editor's permission denials ignored", [(L + "run.py", "        if res.denials:\n", "        if False:\n")],
     ["denials"]),
    ("W-nochanges", "no readable changes.json is not a stop", [(L + "run.py", "        if changes is None:\n",
                                                                "        if False:\n")], ["badchanges"]),
    ("R-runremoved", "the whole-run removed cap", [(L + "guards.py", '    if run_rem > c.get("run_removed", 12000):\n',
                                                     "    if False:\n")], ["limits"]),
    ("R-moved", "the moved cap", [(L + "guards.py", '    if moved > c.get("moved", 30000):\n', "    if False:\n")], ["limits"]),
    ("R-rmcap", "the repeat-mistakes change cap (re-derived: fixer 2 measures it from the script's rewrite)", [
        (L + "guards.py", '            if "\\n### " in "\\n" + d.old and changed > c.get("repeat_mistakes_change", 4000):\n',
         "            if False:\n")], ["limits", "rmcharge"]),
    ("R-tidy2", "the 2-file tidy limit", [(L + "guards.py", "    if over_budget_tidies > 2:\n", "    if False:\n")], ["limits"]),
    ("R-movesrc", "a move destination whose source no finding allows (re-derived: fixer 3 added a second such check)", [
        (L + "guards.py", "        if not sources <= ok_files:\n            out.append(\"%s: text moved here",
         "        if False:\n            out.append(\"%s: text moved here")], ["limits"]),
    ("R-strangerid", "changes.json names a finding not in this run", [(L + "guards.py",
        '        if i not in G.findings:\n            out.append("changes.json names',
        '        if False:\n            out.append("changes.json names')], ["limits"]),
    ("R-gitstatus", "a target with uncommitted edits written over", [(L + "apply.py",
        '        if st.strip():\n            raise Stop("uncommitted edits', '        if False:\n            raise Stop("uncommitted edits')],
     ["gitstatus"]),
    ("R-libstaged", "the library clone's staged files", [(L + "apply.py",
        '        if staged.strip():\n            raise Stop("the library clone has staged changes")',
        '        if False:\n            raise Stop("the library clone has staged changes")')], ["libpre"]),
    ("R-libpatch", "the library clone's diff against the patch file", [(L + "apply.py",
        '        if library_diff(env) != patch:\n            raise Stop(', '        if False:\n            raise Stop(')], ["libpre"]),
    ("R-undo-project", "undo leaves the project's own CLAUDE.md", [(L + "apply.py",
        '                    shutil.copyfile(env.home / rel, pdir / "CLAUDE.md")\n', "                    pass\n")], ["ac34"]),
    ("R-step8tries", "an apply-step stop counts a try", [(L + "apply.py",
        "        return run_stop(R, unsettled, str(e), tries=False)\n", "        return run_stop(R, unsettled, str(e), tries=True)\n")],
     ["applytries"]),
    ("R-dupdate", "a duplicate's surviving text need not keep the dates", [(L + "guards.py",
        "    if not all(x in text for x in DATE.findall(line)):\n        return False\n", "")], ["tidy"]),
    ("R-typedlabel", "any label may replace a dated line", [(L + "guards.py",
        '                           typed_label(f.get("label")) for f in fs):\n', "                           True for f in fs):\n")],
     ["typedlabel"]),
    ("R-errexit4", "unknown-shape sessions never stop a run", [(L + "run.py",
        "    if sc.errors and not sc.reads and not lines and not state.has_work(unsettled):\n", "    if False:\n")], ["ac3", "unread"]),
    ("R-seenuuid", "a repeated line counted twice", [(L + "extract.py",
        '        seen.update(e["uuid"] for e in new)  # a line repeated later (same uuid) is counted once\n', "        pass\n")],
     ["ac42"]),
    ("R-contextmax", "the context's 3,000-character limit", [(L + "extract.py", "    if len(text) - start > CONTEXT_MAX:\n",
                                                              "    if False:\n")], ["ac1"]),
    # fixer 1: one or more per fix
    ("F1a", "a NUL line is an unknown shape again", [(L + "extract.py",
        '    return "\\x00" in line and not line.strip("\\x00 \\t\\r")\n', "    return False\n")], ["freeze"]),
    ("F1b", "any broken line is skipped (widening)", [(L + "extract.py",
        '            raise UnknownShape(r.session, idx + 1, "a line that is not valid JSON")\n', "            continue\n")],
     ["freeze", "ac3"]),
    ("F1c", "unreadable sessions not in last-run.json", [(L + "run.py",
        '    R.facts["unreadable"] = [e.session for e in sc.errors]\n', '    R.facts["unreadable"] = []\n')], ["unread", "unreadline"]),
    ("F1d", "the session-start line drops unreadable sessions", [(H + "dream-notice.sh",
        '  0:* | *"unknown transcript shape"*) ;;\n', "  *) ;;\n")], ["unreadhook"]),
    ("F1e", "an unreadable session stops review lines and waiting findings", [(L + "run.py",
        "    if sc.errors and not sc.reads and not lines and not state.has_work(unsettled):\n",
        "    if sc.errors and not sc.reads:\n")], ["unread"]),
    ("F2a", "a tidy may add text (re-derived: fixer 2 left only finding changes adding lines)", [(L + "guards.py",
        '        adds = [norm(a) for c in cs if c.get("basis") == "finding"\n',
        '        adds = [norm(a) for c in cs if c.get("basis") in ("finding", "duplicate", "move")\n')], ["tidy"]),
    ("F2b", "a surviving line need not have been there before", [(L + "guards.py",
        "s not in G.before_lines or s not in G.after_lines", "s not in G.after_lines")], ["tidy"]),
    ("F2c", "a surviving line need not stay", [(L + "guards.py",
        "s not in G.before_lines or s not in G.after_lines", "s not in G.before_lines")], ["tidy"]),
    ("F2d", "a surviving line need not say the same", [(L + "guards.py", "    return 2 * len(rw & words(text)) >= len(rw)\n",
                                                         "    return True\n")], ["tidy"]),
    ("F3a", "the script's rewrite refused again", [(L + "guards.py",
        '        if G.is_rm(d) and d.status == "M" and mistakes.normalize_text(d.old, G.tally) == d.new:\n',
        "        if False:\n")], ["rmrewrite"]),
    ("F3b", "any repeat-mistakes change passes the allowlist (widening)", [(L + "guards.py",
        '        if G.is_rm(d) and d.status == "M" and mistakes.normalize_text(d.old, G.tally) == d.new:\n',
        '        if G.is_rm(d) and d.status == "M":\n')], ["rmrewrite"]),
    ("F4a", "applied with no diff", [(L + "guards.py", "        if d is None:\n            out.append(\"finding %s: changes.json lists",
                                      "        if d is None:\n            continue\n            out.append(\"finding %s: changes.json lists")],
     ["applieddiff"]),
    ("F4b", "listed additions not looked up in the diff", [(L + "guards.py", "            if norm(a) and norm(a) not in added:\n",
                                                            "            if False:\n")], ["applieddiff"]),
    ("F6a", "the dream's own files not rebuilt under the lock", [(L + "apply.py",
        '        P.writes = [w for w in P.writes if w["kind"] not in ("dream", "backlog")] + own_writes(env, P)\n', "")],
     ["ownfiles"]),
    ("F6b", "a changed tally or pending file written over", [(L + "apply.py", "        moved = own_changed(env, P)\n",
                                                              "        moved = []\n")], ["ownfiles"]),
    ("F7a", "undo checks nothing first", [(L + "apply.py", "        why = undo_blockers(env, sha, changed, lib_too, projects)\n",
                                           "        why = None\n")], ["undoguard"]),
    ("F7b", "undo does not compare the project's own CLAUDE.md", [(L + "apply.py",
        "and own.read_bytes() != (env.home / rel).read_bytes():", "and False:")], ["undoguard"]),
    ("F7c", "undo does not compare the clone with the patch file", [(L + "apply.py",
        '        if library_diff(env) != patch:\n            return ("the library clone', '        if False:\n            return ("the library clone')],
     ["undoguard"]),
    ("F8a", "a repeat-mistakes header may change", [(L + "mistakes.py", "    if h_new.strip() != h_old.strip():\n", "    if False:\n")],
     ["rmshape"]),
    ("F8b", "an area no order names may appear", [(L + "mistakes.py", "        elif name not in areas_ok:\n", "        elif False:\n")],
     ["rmshape"]),
    ("F8c", "text under a new area", [(L + "mistakes.py", "        elif pre.strip():\n", "        elif False:\n")], ["rmshape"]),
    ("F8d", "text under an existing area", [(L + "mistakes.py", "            if pre.strip() != pre_old[name].strip():\n",
                                             "            if False:\n")], ["rmshape"]),
    ("F8e", "an entry may hold more than its two lines", [(L + "mistakes.py",
        "            if len(lines) != 2 or not lines[0].startswith(BUILD) or not lines[1].startswith(CHECK):\n",
        "            if BUILD not in body or CHECK not in body:\n")], ["rmshape"]),
    ("F8f", "a listed entry's mistake line may change", [(L + "mistakes.py",
        "before[kind][2].rstrip() != body.rstrip() or\n                                   _mistake(before[kind][1]) != _mistake(head)):",
        "before[kind][2].rstrip() != body.rstrip()):")], ["rmshape"]),
    ("F9a", "orders past the file's room (re-derived: fixer 3 added the cap's terms to the line)", [(L + "mistakes.py",
        "        if dest in full or size[dest] + est > FILE_TARGET or not fits(", "        if dest in full or not fits(")],
     ["rmbudget"]),
    ("F9b", "a less frequent kind jumps ahead (re-derived as F9a)", [(L + "mistakes.py",
        "        if dest in full or size[dest] + est > FILE_TARGET or not fits(", "        if size[dest] + est > FILE_TARGET or not fits(")],
     ["rmbudget"]),
    ("F10", "no context from behind the marker", [(L + "extract.py",
        "            try:\n                _line_entries(r.session, idx, obj, ctx)\n            except UnknownShape:\n                ctx.clear()\n",
        "")], ["ctxmarker"]),
    ("F11a", "unattributed rows written before the commit", [(L + "run.py", "write=(mode == \"live\"), record_unattributed=False)",
                                                              "write=(mode == \"live\"), record_unattributed=True)")], ["unattr"]),
    ("F11b", "unattributed rows never written", [(L + "apply.py", "    ledger.append(env, ledger.unattributed_rows(",
                                                  "    (lambda *a: None)(env, ledger.unattributed_rows(")], ["ac26"]),
    ("F12a", "a nothing-new run clears nothing", [(L + "run.py", "        clear_failure(R)\n", "")], ["clearfail"]),
    ("F12b", "a failure promises a next run while the dream is off", [(H + "dream-notice.sh",
        '    [ "$(cat "$LOCAL/mode" 2>/dev/null)" = off ] && next=', '    false && next=')], ["clearfail", "offhook"]),
    ("F12c", "a nothing-new run overwrites any last run (widening)", [(L + "run.py",
        '    if isinstance(lr, dict) and lr.get("result") in ("failed", "stopped"):\n', "    if isinstance(lr, dict):\n")],
     ["clearfail"]),
    ("F13a", "changes.json shapes not checked", [(L + "agents.py", "    why = changes_problem(c)\n", "    why = None\n")],
     ["badchanges"]),
    ("F13b", "declined items not checked", [(L + "agents.py",
        '(("already_saved", ("finding_id", "file", "existing_text")), ("declined", ("finding_id", "reason")))',
        '(("already_saved", ("finding_id", "file", "existing_text")),)')], ["badchanges"]),
    ("F13c", "an evidence file that is a list read as an object", [(L + "extract.py",
        "        if not isinstance(data, dict):\n            continue  # not the shape of a review or an ac.json (R1-13)\n", "")],
     ["evidence"]),
    ("F13d", "a crash leaves no last-run.json", [(L + "run.py", "        except Exception as e:\n", "        except ZeroDivisionError as e:\n")],
     ["crash"]),
    # fixer 2 (review 2): one or more per fix
    ("G1a", "an order change counts in any file again (its lines, a 'retired' removal)", [
        (L + "guards.py", '        elif basis in ("duplicate", "move"):\n            out.append(c)\n    return out\n',
         '        elif basis == "order" and c.get("order_id") in G.orders:\n            out.append(c)\n'
         '        elif basis in ("duplicate", "move"):\n            out.append(c)\n    return out\n'),
        (L + "guards.py", '        adds = [norm(a) for c in cs if c.get("basis") == "finding"\n',
         '        adds = [norm(a) for c in cs if c.get("basis") in ("finding", "order")\n'),
        (L + "guards.py", '            if reason == "duplicate" and duplicate_ok(G, line, r):\n',
         '            if reason == "retired" and c.get("basis") == "order":\n                return True\n'
         '            if reason == "duplicate" and duplicate_ok(G, line, r):\n')], ["basis"]),
    ("G1ab", "G1a and the dated guard's order branch: the head's code (V9's class)", [
        (L + "guards.py", '        elif basis in ("duplicate", "move"):\n            out.append(c)\n    return out\n',
         '        elif basis == "order" and c.get("order_id") in G.orders:\n            out.append(c)\n'
         '        elif basis in ("duplicate", "move"):\n            out.append(c)\n    return out\n'),
        (L + "guards.py", '        adds = [norm(a) for c in cs if c.get("basis") == "finding"\n',
         '        adds = [norm(a) for c in cs if c.get("basis") in ("finding", "order")\n'),
        (L + "guards.py", '            if reason == "duplicate" and duplicate_ok(G, line, r):\n',
         '            if reason == "retired" and c.get("basis") == "order":\n                return True\n'
         '            if reason == "duplicate" and duplicate_ok(G, line, r):\n'),
        (L + "guards.py", '                            ok = True\n            if not ok:\n',
         '                            ok = True\n                elif c.get("basis") == "order":\n                    ok = True\n'
         '            if not ok:\n')], ["basis"]),
    ("G1c", "a finding change counts in a file outside its narrowest place", [(L + "guards.py",
        "                i in G.findings and targets.in_scope(targets.scope_for(G.env, G.findings[i]), real) for i in ids):\n",
        "                i in G.findings for i in ids):\n")], ["basis"]),
    ("G1d", "one in-scope finding is enough for a change citing two", [(L + "guards.py",
        '        if basis == "finding" and ids and all(\n', '        if basis == "finding" and ids and any(\n')], ["basis"]),
    ("G1e", "a move's destination may be the editor's own _dream/ files", [(L + "guards.py",
        "                t = G.copy_text(dest) if dest in G.targets else None\n", "                t = G.copy_text(dest)\n")],
     ["basis"]),
    ("G2a", "the budget charges the script's own rewrite again", [(L + "guards.py", "        base = G.base(d)\n",
                                                                   "        base = d.old\n")], ["rmcharge"]),
    ("G2b", "the change cap charges the script's own rewrite again", [(L + "guards.py",
        "            ed = targets.FileDiff(d.copy, d.status, G.base(d), d.new)", "            ed = targets.FileDiff(d.copy, d.status, d.old, d.new)")],
     ["rmcharge"]),
    ("G2c", "the orders measure room on the live bytes, not on the pending rewrite", [(L + "mistakes.py",
        "        return normalize_text((env.home / rel).read_text(), tally)\n", "        return (env.home / rel).read_text()\n")],
     ["rmcharge"]),
    ("G2d", "nothing the editor writes in a repeat-mistakes file is charged (widening)", [(L + "guards.py",
        "            return mistakes.normalize_text(d.old, self.tally)\n", "            return d.new\n")], ["rmcharge"]),
    ("G3a", "the allowance per ordered entry is 4,000 bytes, not 400 (review 2's V10)", [(L + "mistakes.py",
        "ENTRY_ALLOWANCE = 400 ", "ENTRY_ALLOWANCE = 4000 ")], ["allowance"]),
    ("G3b", "an added entry is not held to its order's bytes", [(L + "mistakes.py",
        '                    if size > o["max_entry_bytes"]:\n', "                    if False:\n")], ["allowance"]),
    ("G3c", "an added entry's heading is not counted, only its two lines", [(L + "mistakes.py",
        "            size = len(head.encode()) + sum(len(ln.encode()) + 1 for ln in lines)\n",
        "            size = sum(len(ln.encode()) + 1 for ln in lines)\n")], ["allowance"]),
    ("G3d", "an added entry's heading is counted from the order's title, not as the editor wrote it", [(L + "mistakes.py",
        "            size = len(head.encode()) + sum(len(ln.encode()) + 1 for ln in lines)\n",
        "            size = len((heading_for(kind, (G.orders.get(\"add:\" + kind) or {}).get(\"title\", \"\"), G.tally) or \"\")"
        ".encode()) + sum(len(ln.encode()) + 1 for ln in lines)\n")], ["allowance"]),
    # G4a and G4b re-derived by fixer 4 for the new fold_rest (R3-3): their receipts on 877c99e6 stay in fixer-3/final
    ("G4a-v2", "a fold may put the old line anywhere in the new one (words in front of it)", [(L + "guards.py",
        "    if not core or not n.startswith(core):\n        return None\n    tail = n[len(core):]\n",
        "    if not core or core not in n:\n        return None\n    tail = n[n.index(core) + len(core):]\n")], ["foldtoken"]),
    ("G4b-v2", "a fold need not end the old line at a word boundary", [(L + "guards.py",
        "    else:\n        return None\n    return rest.strip(", "    else:\n        rest = tail\n    return rest.strip(")],
     ["fold", "foldtoken"]),
    ("G4c", "a fold's added words need not be listed", [(L + "guards.py",
        "            if rest and any(rest in x for x in adds):\n", "            if rest:\n")], ["fold"]),
    ("G4d", "a fold's added words may be listed by a change of another place", [(L + "guards.py",
        '    adds = [norm(a) for c in _valid_changes(G, d) if c.get("basis") == "finding"\n',
        '    adds = [norm(a) for c in G.by_file.get(d.copy, []) if c.get("basis") == "finding"\n')], ["fold"]),
    ("G4e", "the dated-line guard ignores folds (R2-4 back)", [(L + "guards.py",
        "        kept = set(folds(G, d).values())  # a dated line", "        kept = set()  # a dated line")], ["fold"]),
    ("G4f", "the line accounting ignores folds (R2-4 back)", [(L + "guards.py",
        "        kept = set(fo.values())\n", "        kept, fo = set(), {}\n")], ["fold"]),
    ("G5a", "a finding's memory folder is its session's own folder key again (R2-5 back)", [(L + "targets.py",
        '    mkey = finding["memory"] if "memory" in finding else memory_key(env, finding["folder"])\n',
        '    mkey = finding["folder"]\n')], ["memkey"]),
    ("G5b", "the bar records no memory key with a finding", [(L + "bar.py",
        '               "memory": targets.memory_key(env, read.folder, getattr(read, "cwd", None)),\n', "")], ["memkey"]),
    ("G5c", "the repository of an existing working folder is not looked up", [(L + "targets.py",
        "        if os.path.basename(common) == \".git\":\n            return key_of_path(os.path.dirname(common))\n",
        "        if False:\n            return key_of_path(os.path.dirname(common))\n")], ["memkey"]),
    ("G5d", "a gone Claude Code worktree no longer names its repository", [(L + "targets.py",
        "        if m:\n            return key_of_path(m.group(1))\n", "        if False:\n            return key_of_path(m.group(1))\n")],
     ["memkey"]),
    ("G5e", "a session's own key is used though it has no memory folder (widening)", [(L + "targets.py",
        '    return folder if (env.projects_dir / folder / "memory").is_dir() else None\n', "    return folder\n")], ["memkey"]),
    ("G5f", "outside any git repository no memory folder is given (narrowing)", [(L + "targets.py",
        "        if p.returncode != 0:\n            return folder\n", "        if p.returncode != 0:\n            return None\n")],
     ["memkey"]),
    ("G5g", "the session read keeps no working folder", [(L + "extract.py",
        '            r.cwd = obj["cwd"]\n', "            pass\n")], ["memkey"]),
    ("G6a", "a lesson dropped for a code-like token is silent again (R2-6 back)", [(L + "bar.py",
        '            res.list_items.append({"id": fid, "date": rec["date"], "kind": "dropped"',
        '            (lambda *a: None)({"id": fid, "date": rec["date"], "kind": "dropped"')], ["codedrop"]),
    ("G6b", "the list item carries the dropped finding's quote (widening what is written)", [(L + "bar.py",
        '"kind": "dropped", "quote": "",', '"kind": "dropped", "quote": quote,')], ["codedrop"]),
    ("G6c", "the list item carries the dropped lesson's wording, token and all", [(L + "bar.py",
        '"statement": "a lesson from your message was not saved"', '"statement": rec["statement"]')], ["codedrop"]),
    ("G6d", "the list item does not name the message", [(L + "bar.py",
        "                                          % uuid})\n", "                                          % \"\"})\n")],
     ["codedrop"]),
    ("G3e", "a listed entry is held to the bytes of an add order for its kind too (widening the check's reach)", [
        (L + "mistakes.py", '                if kind not in before and o["action"] == "add" and o["kind"] == kind:\n',
         '                if o["action"] == "add" and o["kind"] == kind:\n')], ["allowance"]),
    # ---- review 3 fixes (fixer 3): R3-2, R3-1, R2-9 ----
    ("H2a", "a move order whose entry is gone stays a move (R3-2 back: orders() crashes)", [(L + "mistakes.py",
        '                if kid in entries(k["listed_in"]):\n', "                if True:\n")], ["missingmove", "orderkinds"]),
    ("H2b", "the add for a gone entry goes to the file the tally lists it in", [(L + "mistakes.py",
        '(R3-2)\n                    cands.append(order(info, "add", want))\n',
        '(R3-2)\n                    cands.append(order(info, "add", k["listed_in"]))\n')], ["missingmove", "orderkinds"]),
    ("H2c", "an order that is not a move carries no `to` field", [(L + "mistakes.py",
        'action=action, file=file, to=to, max_entry_bytes=most)', 'action=action, file=file, max_entry_bytes=most, **({"to": to} if to else {}))')],
     ["orderkinds"]),
    ("H2d", "the add for a gone entry carries no max_entry_bytes", [(L + "mistakes.py",
        '(R3-2)\n                    cands.append(order(info, "add", want))\n',
        '(R3-2)\n                    cands.append(dict(order(info, "add", want), max_entry_bytes=None))\n')], ["missingmove", "orderkinds"]),
    ("H1a", "removals not bounded by the change cap", [(L + "mistakes.py",
        '            if not fits(o["file"], n):\n                continue', '            if False:\n                continue')],
     ["classcap", "capedge"]),
    ("H1b", "adds and moves not bounded at the file they go to", [(L + "mistakes.py",
        ' or not fits(dest, n_in) or not fits(o["file"], n_out):', ' or not fits(o["file"], n_out):')], ["classcap", "capedge"]),
    ("H1c", "moves not bounded at the file they leave", [(L + "mistakes.py",
        ' or not fits(dest, n_in) or not fits(o["file"], n_out):', ' or not fits(dest, n_in):')], ["classcap"]),
    ("H1d", "no slack for the blank line beside an entry", [(L + "mistakes.py", "SLACK = 2 ", "SLACK = 0 ")], ["capedge"]),
    ("H1e", "the heading of an area an order opens is not charged", [(L + "mistakes.py",
        "    return n + SLACK + (max(area_cost(f, a) for a in new) if new else 0), new", "    return n + SLACK, new")],
     ["capedge"]),
    ("H1f", "the heading of an area a removal empties is not charged", [(L + "mistakes.py",
        "        return n + (area_cost(f, e[0]) if left[key] == 1 else 0), key", "        return n, key")], ["capedge"]),
    ("H1g", "a removal is charged its heading only", [(L + "mistakes.py",
        '            n, key = out_cost(o["file"], o["kind"], True)\n', '            n, key = out_cost(o["file"], o["kind"], False)\n')],
     ["classcap"]),
    ("H1h", "removals and adds of one file do not share its cap", [(L + "mistakes.py",
        "    growing = sorted((o for o in cands if o[\"action\"] != \"remove\")",
        "    charge.clear()\n    growing = sorted((o for o in cands if o[\"action\"] != \"remove\")")], ["classcap"]),
    ("H1i", "the cap holds a file before it has entries (narrowing: the backfill cannot fill it)", [(L + "mistakes.py",
        "        return not capped[f] or charge.get(f, 0) + n <= cap\n", "        return charge.get(f, 0) + n <= cap\n")],
     ["classcap"]),
    ("H1j", "the orders are never held to the cap (widening: R3-1 back)", [(L + "mistakes.py",
        "        return not capped[f] or charge.get(f, 0) + n <= cap\n", "        return True\n")], ["classcap", "capedge"]),
    ("H1k", "the cap is not read from caps.conf (40,000)", [(L + "mistakes.py",
        '    return int(v) if v.lstrip("-").isdigit() else 4000\n', "    return 40000\n")], ["classcap", "capedge"]),
    ("H1l", "every file counts as holding entries", [(L + "mistakes.py",
        '    return "\\n### " in "\\n" + text\n', "    return True\n")], ["classcap"]),
    ("H1m", "a move's heading is not charged at the file it goes to", [(L + "mistakes.py",
        '            n_in, new = in_cost(dest, {e[0], o["area"]}, len(e[1].encode()))\n',
        '            n_in, new = in_cost(dest, {e[0], o["area"]}, 0)\n')], ["classcap"]),
    ("W2", "the repeat-mistakes change cap counts only what the editor adds, not what it removes (review 3's W2)", [
        (L + "guards.py",
         "            changed = nb([ln for ln in ed.added if ln not in mi]) + nb([ln for ln in ed.removed if ln not in mo])\n",
         "            changed = nb([ln for ln in ed.added if ln not in mi])\n")], ["capedge"]),
    ("P1", "a pointer line is accepted in any file, not only where the text left", [(L + "guards.py",
        '            mv = G.pointers.get((G.live(d), ln)) if d.status == "M" else None\n',
        "            mv = next((v for (p, l), v in G.pointers.items() if l == ln), None)\n")], ["pointer"]),
    ("P2", "many pointer lines for one move", [(L + "guards.py", "            if mv and mv not in used:\n", "            if mv:\n")],
     ["pointer"]),
    ("P3", "the receiving file need not have got exactly the moved lines", [(L + "guards.py",
        "            if not places or not got or block != got:\n", "            if not places or not got or not block:\n")],
     ["pointer"]),
    ("P4", "a pointer for a move to any file (widening)", [(L + "guards.py",
        '    if t.parent.name == "references" and s.parent in (t.parent, t.parent.parent):\n        return [src]\n    return []\n',
        "    return [src]\n")], ["pointer"]),
    ("P4b", "a repeat-mistakes file may be a side of a move with a pointer", [(L + "guards.py",
        ' or \\\n            "repeat-mistakes.md" in (s.name, t.name):\n', ":\n")], ["pointer"]),
    # P5 re-derived by fixer 4: pointer_places now gives MEMORY.md for a new note only (R4-8's smaller note)
    ("P5-v2", "the pointer for a new memory note may not sit in MEMORY.md (narrowing)", [(L + "guards.py",
        '        return [ms.group(1) + "/MEMORY.md"] if new else [src]\n', "        return [src]\n")], ["pointer", "plainname"]),
    ("P5b", "a memory note may point into another memory folder", [(L + "guards.py",
        "    if ms and mt and ms.group(1) == mt.group(1):\n", "    if ms and mt:\n")], ["pointer"]),
    ("P6", "any line that starts like a pointer is accepted (the heading slot and the rest unchecked)", [(L + "guards.py",
        '            mv = G.pointers.get((G.live(d), ln)) if d.status == "M" else None\n',
        '            mv = next((v for (p, l), v in G.pointers.items() if p == G.live(d) and '
        'ln.startswith(l.split(" for the section")[0].split(" (moved")[0])), None)\n')], ["pointer"]),
    ("P7", "a pointer never names the moved heading", [(L + "guards.py", "            h = HEADING.match(block[0])\n",
                                                        "            h = None\n")], ["pointer"]),
    ("P8", "a file whose only change is a pointer need not point at text from an allowed file", [(L + "guards.py",
        "        if not sources <= ok_files:\n            out.append(\"%s: a pointer to text", "        if False:\n            out.append(\"%s: a pointer to text")],
     ["pointer"]),
    ("P10", "the line accounting ignores pointers (R2-9 back)", [(L + "guards.py", "            if mv and mv not in used:\n",
                                                                 "            if False:\n")], ["pointer"]),
    ("P11", "MEMORY.md may not gain a pointer line (R2-9's memory half back)", [(L + "guards.py",
        '        if d.status == "M" and added and not any(ln.strip() for ln in d.removed) and \\\n',
        "        if False and \\\n")], ["pointer"]),
    ("P13", "a file whose only change is a pointer need not be listed in changes.json", [(L + "guards.py",
        ' and cs and all(c.get("basis") == "move" for c in cs):\n', ":\n")], ["pointer"]),
    ("P12", "the shape the script builds is not the one DREAM.md and the prompt give", [(L + "guards.py",
        '(moved there word for word)."\nPOINTER_BARE', '(moved word for word)."\nPOINTER_BARE')], ["pointer"]),
    # fixer 4: R3-3, a fold keeps the old line's last word or number whole
    ("K1", "a mark need not be followed by a space (3,000, 18.5)", [(L + "guards.py",
        "    if tail[:2] in FOLD_MARKS:\n        rest = tail[2:]\n", "    if tail[:1] in \",;:.\":\n        rest = tail[1:]\n")],
     ["foldtoken"]),
    ("K2a", "a comma and a space no longer start the added words (narrowing)", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = ("; ", ": ", ". ")')], ["foldtoken"]),
    ("K2b", "a semicolon and a space no longer start the added words (narrowing)", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = (", ", ": ", ". ")')], ["foldtoken"]),
    ("K2c", "a colon and a space no longer start the added words (narrowing)", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = (", ", "; ", ". ")')], ["foldtoken"]),
    ("K2d", "the old line's full stop and a space no longer start the added words (narrowing)", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = (", ", "; ", ": ")')], ["foldtoken"]),
    ("K3a", "a question mark may end the old line (widening: '? No')", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = (", ", "; ", ": ", ". ", "? ")')], ["foldtoken"]),
    ("K3b", "an exclamation mark may end the old line (widening)", [(L + "guards.py",
        'FOLD_MARKS = (", ", "; ", ": ", ". ")', 'FOLD_MARKS = (", ", "; ", ": ", ". ", "! ")')], ["foldtoken"]),
    ("K4", "a plain space may follow a number (3 000, 3 KB, 3 thousand)", [(L + "guards.py",
        " and len(tail) > 1 and not core[-1].isnumeric() and \\\n", " and len(tail) > 1 and \\\n")], ["foldtoken"]),
    ("K5", "only ASCII digits count as a number (a fraction at the end)", [(L + "guards.py",
        "not core[-1].isnumeric()", "not core[-1].isdigit()")], ["foldtoken"]),
    ("K6", "anything may come after a plain space (' 't')", [(L + "guards.py",
        "            (tail[1].isalnum() or tail[1] in FOLD_SPACE_START) and not _negation(",
        "            True and not _negation(")], ["foldtoken"]),
    ("K7a", "an opening bracket after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "[`\\"\u201c\u2014\u2013"')], ["foldtoken"]),
    ("K7b", "a square bracket after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "(`\\"\u201c\u2014\u2013"')], ["foldtoken"]),
    ("K7c", "a backtick after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "([\\"\u201c\u2014\u2013"')], ["foldtoken"]),
    ("K7d", "a quote after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "([`\u201c\u2014\u2013"')], ["foldtoken"]),
    ("K7e", "a curly quote after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "([`\\"\u2014\u2013"')], ["foldtoken"]),
    ("K7f", "a dash after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "([`\\"\u201c\u2013"')], ["foldtoken"]),
    ("K7g", "an en dash after a plain space no longer starts the added words (narrowing)", [(L + "guards.py",
        'FOLD_SPACE_START = "([`\\"\u201c\u2014\u2013"', 'FOLD_SPACE_START = "([`\\"\u201c\u2014"')], ["foldtoken"]),
    ("K8", "a negation may follow a plain space ('can not')", [(L + "guards.py",
        " and not _negation(tail[1:].split(\" \", 1)[0]):\n", ":\n")], ["foldtoken"]),
    ("K9-not", "'not' is no longer a negation", [(L + "guards.py",
        'NEGATIONS = {"not", "no", "never", "nor", "neither"}', 'NEGATIONS = {"no", "never", "nor", "neither"}')], ["foldtoken"]),
    ("K9-no", "'no' is no longer a negation", [(L + "guards.py",
        'NEGATIONS = {"not", "no", "never", "nor", "neither"}', 'NEGATIONS = {"not", "never", "nor", "neither"}')], ["foldtoken"]),
    ("K9-never", "'never' is no longer a negation", [(L + "guards.py",
        'NEGATIONS = {"not", "no", "never", "nor", "neither"}', 'NEGATIONS = {"not", "no", "nor", "neither"}')], ["foldtoken"]),
    ("K9-nor", "'nor' is no longer a negation", [(L + "guards.py",
        'NEGATIONS = {"not", "no", "never", "nor", "neither"}', 'NEGATIONS = {"not", "no", "never", "neither"}')], ["foldtoken"]),
    ("K9-neither", "'neither' is no longer a negation", [(L + "guards.py",
        'NEGATIONS = {"not", "no", "never", "nor", "neither"}', 'NEGATIONS = {"not", "no", "never", "nor"}')], ["foldtoken"]),
    ("K10", "'n't' after a space is no negation", [(L + "guards.py",
        '    return w in NEGATIONS or w.startswith(("n\'", "n\u2019"))', "    return w in NEGATIONS")], ["foldtoken"]),
    ("K11", "a negation in capitals is none", [(L + "guards.py",
        '    w = word.strip(".,;:!?").lower()\n', '    w = word.strip(".,;:!?")\n')], ["foldtoken"]),
    ("K12", "a negation with a comma after it is none ('not, ever')", [(L + "guards.py",
        '    w = word.strip(".,;:!?").lower()\n', "    w = word.lower()\n")], ["foldtoken"]),
    ("K13", "the editor is not told the fold rule", [(P + "editor.md",
        " starting after a comma, semicolon, colon or full stop and a space, or after a\n", " \n")], ["foldtoken"]),
    # fixer 4: R4-1, a pointer names only a plainly named file
    ('N1', 'a pointer may name a file of any name (R4-1 back)', [(L + "guards.py", ' and nameable(live(t)) else []\n', ' else []\n')], ['plainname']),
    ('N2', "a name's length is not bounded", [(L + "guards.py", '    return bool(PLAIN_NAME.fullmatch(name)) and len(name) - 3 <= PLAIN_MAX\n', '    return bool(PLAIN_NAME.fullmatch(name))\n')], ['plainname']),
    ('N3a', '51 characters before .md pass (widening by one)', [(L + "guards.py", 'PLAIN_MAX = 50\n', 'PLAIN_MAX = 51\n')], ['plainname']),
    ('N3b', '50 characters before .md are refused (narrowing by one)', [(L + "guards.py", 'PLAIN_MAX = 50\n', 'PLAIN_MAX = 49\n')], ['plainname']),
    ('N4a', 'seven words pass', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,6}\\.md")')], ['plainname']),
    ('N4b', 'six words are refused (narrowing)', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,4}\\.md")')], ['plainname']),
    ('N5a', 'capitals pass', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+){0,5}\\.md")')], ['plainname']),
    ('N5b', 'a dot may join words', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_.][a-z0-9]+){0,5}\\.md")')], ['plainname']),
    ('N5c', 'a space may join words', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_ ][a-z0-9]+){0,5}\\.md")')], ['plainname']),
    ('N5d', 'an underscore may not join words (narrowing)', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-][a-z0-9]+){0,5}\\.md")')], ['plainname']),
    ('N5e', 'a hyphen may not join words (narrowing)', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[_][a-z0-9]+){0,5}\\.md")')], ['plainname']),
    ('N5f', 'accented lower-case letters pass', [(L + "guards.py", 'PLAIN_NAME = re.compile(r"[a-z0-9]+(?:[-_][a-z0-9]+){0,5}\\.md")', 'PLAIN_NAME = re.compile(r"[a-z0-9à-ÿ]+(?:[-_][a-z0-9à-ÿ]+){0,5}\\.md")')], ['plainname']),
    ('N6', 'a plain start is enough (match, not fullmatch)', [(L + "guards.py", 'PLAIN_NAME.fullmatch(name)', 'PLAIN_NAME.match(name)')], ['plainname']),
    ('N7a', 'names that differ only in capitals are not looked for', [(L + "guards.py", ' and not self.case_twins(live)\n', '\n')], ['plainname']),
    ('N7b', 'twins looked for only in the copy', [(L + "guards.py", '        for root in (self.env.home / folder, self.copy / targets.copy_rel(folder)):\n', '        for root in (self.copy / targets.copy_rel(folder),):\n')], ['plainname']),
    ('N7c', 'twins looked for only in the live folder', [(L + "guards.py", '        for root in (self.env.home / folder, self.copy / targets.copy_rel(folder)):\n', '        for root in (self.env.home / folder,):\n')], ['plainname']),
    ('N7d', 'a twin must be the same name exactly (no case folding)', [(L + "guards.py", 'x.casefold() == name.casefold()', 'x == name')], ['plainname']),
    ('N8a', "a new memory note's name is not checked", [(L + "guards.py", '        if not G.nameable(live, m.group(2)):\n', '        if False:\n')], ['plainname']),
    ('N8b', "only a new note's file name is checked, not the folders before it", [(L + "guards.py", 'G.nameable(live, m.group(2))', 'G.nameable(live)')], ['plainname']),
    ('N9a', "MEMORY.md may hold the pointer for a note that exists (R4-8's smaller note back)", [(L + "guards.py", '        return [ms.group(1) + "/MEMORY.md"] if new else [src]\n', '        return [ms.group(1) + "/MEMORY.md"] if new else [src, ms.group(1) + "/MEMORY.md"]\n')], ['plainname']),
    ('N9b', "a new note's pointer may sit in the note the text left", [(L + "guards.py", '        return [ms.group(1) + "/MEMORY.md"] if new else [src]\n', '        return [ms.group(1) + "/MEMORY.md", src] if new else [src]\n')], ['plainname']),
    ('N10', 'every receiving note counts as new', [(L + "guards.py", 'pointer_places(live(s), live(t), t.status == "A")', 'pointer_places(live(s), live(t), True)')], ['pointer']),
    ("N11", "DREAM.md section 6 does not give the name rule", [(".claude/dream/DREAM.md",
        "The receiving file's name is plain: lower-case letters and digits, 1 to 6 words joined by single hyphens or underscores, at most 50 characters before `.md`, and no other file in its folder with the same name in other capitals. ", "")], ["plainname"]),
    ("N12", "the editor is not told the name rule", [(P + "editor.md",
        "Leave a pointer only\nto a file with a plain name: lower-case letters and digits, 1 to 6 words joined by single hyphens or\n",
        "Leave a pointer only\nto a file with a plain name: lower-case letters and digits, or\n")], ["plainname"]),
    # fixer 4: option (b), a kind already due to retire where it would be listed is not listed
    ('B1', 'a kind already due to retire where it would be listed is added or moved all the same (option (a) back)', [('.claude/dream/lib/dreamlib/mistakes.py', '        if want and retire_due(env, tally, kid, want):\n            want = None\n', '')], ['retireb']),
    ('B2', 'due is judged where the kind is listed, not where it would be listed', [('.claude/dream/lib/dreamlib/mistakes.py', '        if want and retire_due(env, tally, kid, want):\n', '        if want and retire_due(env, tally, kid):\n')], ['retireb']),
    ('B3', 'retire_due ignores the file it is given', [('.claude/dream/lib/dreamlib/mistakes.py', '    f = f or k.get("listed_in")\n', '    f = k.get("listed_in")\n')], ['retireb']),
    ('B4a-v2', "a project's kind is due one story early (9 later stories; B4a on R5-1's text)", [('.claude/dream/lib/dreamlib/mistakes.py', '        if last is not None and len(lst) - 1 - last >= RETIRE_AFTER:\n', '        if last is not None and len(lst) - 1 - last >= RETIRE_AFTER - 1:\n')], ['retireb']),
    ('B4b-v2', 'a general kind is due one story early (9 later stories; B4b on R5-1\'s text)', [('.claude/dream/lib/dreamlib/mistakes.py', '        return last is not None and len(seq) - 1 - last >= RETIRE_AFTER\n', '        return last is not None and len(seq) - 1 - last >= RETIRE_AFTER - 1\n')], ['retireb']),
    ('B4c', "a general kind is judged by its project's stories (another project's 10 stories make it due)", [('.claude/dream/lib/dreamlib/mistakes.py', '    if f == targets.general_rm(env):\n', '    if f == targets.general_rm(env) or True:\n')], ['retireb']),
    ('B5', 'only an add is held back; a move into a file where the kind is due goes ahead', [('.claude/dream/lib/dreamlib/mistakes.py', '        if want and retire_due(env, tally, kid, want):\n', '        if want and not k.get("listed_in") and retire_due(env, tally, kid, want):\n')], ['retireb']),
    ('B6', 'DREAM.md section 7 does not say the rule', [('.claude/dream/DREAM.md', '- A mistake already due to retire where it would be listed is not added or moved there; it is listed once it comes back in a newer story.\n', '')], ['retireb']),
    # fixer 4: R4-8, the checker's prompt
    ("C1", "the checker's prompt no longer names the changes that need no finding (R4-8 back)", [(P + "checker.md",
        "Four changes need no finding or order, because DREAM.md section 6 allows them and the script checks each:\n"
        "text moved word for word from one file to another; the one line such a move may leave, exactly\n"
        "``See `<path>` for the section \"<heading>\" (moved there word for word).`` or\n"
        "``See `<path>` (moved there word for word).``; a line removed as a duplicate of a whole line that stays;\n"
        "and the script's own rewrite of the counts, stories and order of the entries in a repeat-mistakes file.\n", "")],
     ["checkerprompt"]),
    ("C2", "the checker's yes rule is unqualified again", [(P + "checker.md",
        "traces to a finding, an order or one of those four, and no\nfact was lost.",
        "traces to a finding or an order and no fact was lost.")], ["checkerprompt"]),
    ("C3", "the pointer shape the checker is given is not the one the script builds", [(P + "checker.md",
        "``See `<path>` (moved there word for word).``;", "``See `<path>` (moved word for word).``;")], ["checkerprompt"]),
    ("C4", "the checker is not told a duplicate removed needs no finding", [(P + "checker.md",
        " a line removed as a duplicate of a whole line that stays;\n", "\n")], ["checkerprompt"]),
    # fixer 5: R5-1, stories counted by date; R5-3 and R5-4, the editor's prompt
    ('R5a', 'a new story goes at the end, not at its date (R5-1 back)', [('.claude/dream/lib/dreamlib/mistakes.py', '    return next((i for i, x in enumerate(keys) if times.get(x, float("-inf")) > t), len(keys))\n', '    return len(keys)\n')], ['r51first', 'r51late']),
    ('R5b', "a story placed before a listing's boundary does not move it", [('.claude/dream/lib/dreamlib/mistakes.py', '                k["listed_since"]["seq"] += 1\n', '                pass\n')], ['r51late']),
    ('R5c', "a story placed right at a listing's boundary moves it too", [('.claude/dream/lib/dreamlib/mistakes.py', '            if (k.get("listed_since") or {}).get("seq", 0) > i:\n', '            if (k.get("listed_since") or {}).get("seq", 0) >= i:\n')], ['r51late']),
    ('R5d', "a project's own list takes new stories at its end", [('.claude/dream/lib/dreamlib/mistakes.py', '            lst.insert(_place(["%s/%s" % (p, x) for x in lst], times, key), s)\n', '            lst.append(s)\n')], ['r51first', 'r51late']),
    ('R5e', "a story's date is its newest evidence file, not its first", [('.claude/dream/lib/dreamlib/extract.py', '        if t is not None and (key not in out or t < out[key]):\n', '        if t is not None and (key not in out or t > out[key]):\n')], ['r51first']),
    ('R5f', "a story's date is the file of its first counted line, not its first evidence file", [('.claude/dream/lib/dreamlib/extract.py', '                        "story_time": first.get("%s/%s" % (project, story))})\n', '                        "story_time": mtime(f)})\n')], ['r51first']),
    ('R5g', "a line's own date is its story's date (a late round is no later sighting)", [('.claude/dream/lib/dreamlib/extract.py', '                        "file": where, "claim": claim, "time": mtime(f),\n', '                        "file": where, "claim": claim, "time": first.get("%s/%s" % (project, story)),\n')], ['r51first']),
    ('R5h', 'the date a kind was last seen is not kept', [('.claude/dream/lib/dreamlib/mistakes.py', '            pk["last_seen"] = ln["time"]    # a later review round of an older story is a sighting at its own date\n', '            pass\n')], ['r51round', 'r51first']),
    ('R5i', 'the date a kind was last seen keeps its first sighting', [('.claude/dream/lib/dreamlib/mistakes.py', 'if ln.get("time") is not None and ln["time"] > (pk.get("last_seen") or float("-inf")):\n', 'if ln.get("time") is not None and pk.get("last_seen") is None:\n')], ['r51round']),
    ('R5j', "retiring ignores a later round's sighting", [('.claude/dream/lib/dreamlib/mistakes.py', '    if seen:\n        mine += ', '    if False:\n        mine += ')], ['r51round', 'r51first']),
    ('R5k', 'a tally written before stories had dates is not migrated', [('.claude/dream/lib/dreamlib/run.py', '    mistakes.migrate(env, tally)    # a tally written before stories had dates goes in their order of date (R5-1)\n', '')], ['r51mig']),
    ('R5l', 'a story whose evidence is gone counts as the newest', [('.claude/dream/lib/dreamlib/mistakes.py', '    times = tally["story_time"] = {x: found.get(x, 0.0) for x in old}\n', '    times = tally["story_time"] = {x: found.get(x, 1e12) for x in old}\n')], ['r51mig']),
    ('R5m', 'a migrated listing keeps its old boundary', [('.claude/dream/lib/dreamlib/mistakes.py', '            since["seq"] = 1 + max(new.index(x) for x in old[:since["seq"]])\n', '            pass\n')], ['r51mig']),
    ('R5n', "a migrated project's own list keeps the old order", [('.claude/dream/lib/dreamlib/mistakes.py', '        lst.sort(key=lambda s: times.get("%s/%s" % (p, s), 0.0))\n', '        pass\n')], ['r51mig']),
    ('R5o', 'migration dates the stories but keeps their old order', [('.claude/dream/lib/dreamlib/mistakes.py', '    new = tally["story_seq"] = sorted(old, key=lambda x: times[x])\n', '    new = tally["story_seq"] = list(old)\n')], ['r51mig']),
    ('R5p', 'equally frequent kinds go by name again', [('.claude/dream/lib/dreamlib/mistakes.py', 'key=lambda o: (-o["count"], -recency(o), o["kind"]))\n', 'key=lambda o: (-o["count"], o["kind"]))\n')], ['r51tie']),
    ('R5q', 'equally frequent kinds go oldest first', [('.claude/dream/lib/dreamlib/mistakes.py', 'key=lambda o: (-o["count"], -recency(o), o["kind"]))\n', 'key=lambda o: (-o["count"], recency(o), o["kind"]))\n')], ['r51tie']),
    ('R5r', 'a tally with nothing counted yet is migrated too, so a run with nothing new changes it', [('.claude/dream/lib/dreamlib/mistakes.py', '    if "story_time" in tally or not tally.get("story_seq"):\n', '    if "story_time" in tally:\n')], ['ac21']),
    ('E5a', 'the editor is not told the fold that is always accepted (R5-3 back)', [('.claude/dream/prompts/editor.md', '   The safe way, which the fold rule always accepts, is a comma or a full stop and a space before the added\n', '   \n')], ['safefold']),
    ('E5b', 'the editor is not told the name rule where it writes a new memory note (R5-4 back)', [('.claude/dream/prompts/editor.md', '   A new memory note you write for a finding goes straight in its memory folder, never in a subfolder, with a\n', '   \n')], ['newnote']),

    # fixer 6: R6-1, no repeat-mistakes order and no retiring for good while review lines on disk wait uncounted
    ('R6a', 'orders are made while review lines on disk wait uncounted (R6-1 back)', [('.claude/dream/lib/dreamlib/mistakes.py', '    if unread(env, tally):\n        return []\n', '')], ['r61', 'r61unread']),
    ('R6b', 'only removals wait for uncounted lines; adds and moves are made (R6-2 back)', [('.claude/dream/lib/dreamlib/mistakes.py', '    if unread(env, tally):\n        return []\n', '    hold = unread(env, tally)\n'), ('.claude/dream/lib/dreamlib/mistakes.py', '        if o["action"] == "remove":\n            n, key = out_cost(', '        if o["action"] == "remove" and not hold:\n            n, key = out_cost(')], ['r61unread']),
    ('R6c', 'only adds and moves wait for uncounted lines; removals are made (R6-1 back)', [('.claude/dream/lib/dreamlib/mistakes.py', '    if unread(env, tally):\n        return []\n', '    hold = unread(env, tally)\n'), ('.claude/dream/lib/dreamlib/mistakes.py', '    growing = sorted((o for o in cands if o["action"] != "remove"), ', '    growing = sorted((o for o in cands if o["action"] != "remove" and not hold), ')], ['r61', 'r61unread']),
    ('R6d', 'a removal retires the kind for good even while lines wait uncounted', [('.claude/dream/lib/dreamlib/mistakes.py', '            k["listed_in"], k["retired"] = None, bool(settled)\n', '            k["listed_in"], k["retired"] = None, True\n')], ['r61late']),
    ('R6e', 'the apply step settles the tally as if every line were counted (the call site)', [('.claude/dream/lib/dreamlib/apply.py', 'R.now, settled=not mistakes.unread(env, tally_after))', 'R.now, settled=True)')], ['r61late']),
    ('R6f', 'a removal while lines wait keeps the kind listed in the tally, its entry gone', [('.claude/dream/lib/dreamlib/mistakes.py', '            k["listed_in"], k["retired"] = None, bool(settled)\n', '            k["listed_in"], k["retired"] = (None if settled else k["listed_in"]), bool(settled)\n')], ['r61late']),
    ('R6g', "every review line on disk counts as uncounted (the tally's seen ignored)", [('.claude/dream/lib/dreamlib/mistakes.py', '    return extract.review_lines(env, tally.get("seen") or [])\n', '    return extract.review_lines(env, [])\n')], ['r61', 'ac28']),
    ('R6h', 'the apply step settles the tally only while lines wait (inverted)', [('.claude/dream/lib/dreamlib/apply.py', 'R.now, settled=not mistakes.unread(env, tally_after))', 'R.now, settled=bool(mistakes.unread(env, tally_after)))')], ['r61late', 'ac28']),
]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def run_tests(root, keys, log):
    names = [T[k] for k in keys]
    hook = [n for n in names if not n.startswith("test_")]
    py = [n for n in names if n.startswith("test_")]
    cap = ["systemd-run", "--user", "--scope", "-q", "-p", "MemoryMax=4G", "-p", "MemorySwapMax=0", "timeout", "900"]
    out, rc = "", 0
    if py:
        p = subprocess.run(cap + ["bash", str(root / ".claude/dream/tests/run.sh")] + py, capture_output=True, text=True)
        out += p.stdout + p.stderr
        rc = rc or p.returncode
    for n in hook:
        f = "dream-ledger.test.sh" if n.startswith("ac25") else "dream-notice.test.sh"
        p = subprocess.run(cap + ["bash", str(root / ".claude/hooks/tests" / f), n], capture_output=True, text=True)
        out += p.stdout + p.stderr
        rc = rc or p.returncode
    Path(log).write_text(out + "\nRC=%d\n" % rc)
    return names, out, rc


def grade(names, out, rc):
    if rc in (124, 137):
        return "KILLED (%s)" % ("timeout" if rc == 124 else "memory cap")
    if not names:
        return "UNKNOWN (no test named)"
    fails = [n for n in names if re.search(r"(?m)^not ok \d+ - %s\s*$" % re.escape(n), out)]
    oks = [n for n in names if re.search(r"(?m)^ok \d+ - %s\s*$" % re.escape(n), out)]
    if len(fails) == len(names):
        return "KILLED"
    if len(oks) == len(names):
        return "SURVIVED"
    return "UNKNOWN (no result line for %s)" % ", ".join(n for n in names if n not in fails and n not in oks)


def main(argv):
    root, report = Path(argv[0]), Path(argv[1])
    only = set(argv[2:])
    chosen = [m for m in MUTANTS if not only or m[0] in only]
    if not chosen:
        print("no mutant matches %s" % " ".join(sorted(only)))
        return 2
    logs = report.parent / "mutants"
    logs.mkdir(parents=True, exist_ok=True)
    keys = sorted({k for m in chosen for k in m[3]})
    names, out, rc = run_tests(root, keys, logs / "baseline.log")
    base = grade(names, out, rc)
    rows = ["| Mutant | What it breaks | Killing test | Result |", "|---|---|---|---|"]
    print("baseline (no mutant): %s" % ("green" if base == "SURVIVED" else base))
    if base != "SURVIVED":
        print("the unmutated copy is not green; no mutant can be judged")
        return 1
    bad = 0
    for mid, what, edits, ks in chosen:
        saved = {}
        result = None
        try:
            for f, old, new in edits:
                p = root / f
                if p not in saved:
                    saved[p] = (p.read_bytes(), sha(p))
                text = p.read_text()
                n = text.count(old)
                if n != 1:
                    result = "BLIND (the change matches %d times in %s)" % (n, f)
                    break
                p.write_text(text.replace(old, new))
            if result is None:
                start = time.time()
                names, out, rc = run_tests(root, ks, logs / ("%s.log" % mid))
                result = grade(names, out, rc) + " in %.0f s" % (time.time() - start)
        finally:
            for p, (data, h) in saved.items():
                p.write_bytes(data)
                assert sha(p) == h, "restore failed for %s" % p
        if not result.startswith("KILLED"):
            bad += 1
        rows.append("| %s | %s | %s | %s |" % (mid, what, ", ".join("`%s`" % T[k] for k in ks), result))
        print("%-5s %-60s %s" % (mid, what, result), flush=True)
    report.write_text("# dream-pass mutation run\n\nCopy of HEAD %s, each test under MemoryMax=4G. A mutant is killed only "
                      "when every named test prints its own `not ok` line. Logs: `mutants/<id>.log`.\n\n%s\n\nKilled %d of %d.\n"
                      % (os.environ.get("MUTANT_HEAD", "?"), "\n".join(rows), len(chosen) - bad, len(chosen)))
    print("killed %d of %d" % (len(chosen) - bad, len(chosen)))
    return 0 if bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
