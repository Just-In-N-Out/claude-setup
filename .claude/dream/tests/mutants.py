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
}
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
    ("R-movesrc", "a move destination whose source no finding allows", [(L + "guards.py",
        "        if not sources <= ok_files:\n", "        if False:\n")], ["limits"]),
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
    ("F9a", "orders past the file's room", [(L + "mistakes.py", "        if dest in full or size[dest] + est > FILE_TARGET:\n",
                                             "        if False:\n")], ["rmbudget"]),
    ("F9b", "a less frequent kind jumps ahead", [(L + "mistakes.py", "        if dest in full or size[dest] + est > FILE_TARGET:\n",
                                                  "        if size[dest] + est > FILE_TARGET:\n")], ["rmbudget"]),
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
    ("G3e", "a listed entry is held to the bytes of an add order for its kind too (widening the check's reach)", [
        (L + "mistakes.py", '                if kind not in before and o["action"] == "add" and o["kind"] == kind:\n',
         '                if o["action"] == "add" and o["kind"] == kind:\n')], ["allowance"]),
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
