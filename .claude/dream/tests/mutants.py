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
}

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
     [(L + "guards.py", 'f.get("replaces", "").strip() and not f.get("ambiguous") and\n                           f.get("label") in TYPED_LABELS',
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
    ("X34", "undo leaves the library clone", [(L + "apply.py", "        if env.rel(env.patch) in changed and (env.lib / \".git\").exists():\n",
                                               "        if False:\n")], ["ac34"]),
    ("X25", "the ledger hook records the link path", [(H + "dream-ledger.sh", 'real=$(realpath -e -- "$f" 2>/dev/null) || exit 0\n',
                                                       'real=$f\n[ -e "$real" ] || exit 0\n')], ["ac25"]),
    ("X31", "a failed run shown only once", [(H + "dream-notice.sh", 'case "$result" in\n  failed | stopped) ;;\n  *)\n',
                                              'case "$result" in\n  *)\n')], ["ac31"]),
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
