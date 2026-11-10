"""Apply, commit, push and recovery: AC19, AC20, AC21, AC22, AC23, AC35 (plan Task 9)."""
import json
import os
import shutil
import unittest

import fakehome as fh
from fakehome import FakeHome, typed
from dreamlib import apply, ledger, state


def dream_commits(h):
    out = h.git("log", "--format=%H %s", "main").stdout.splitlines()
    return [ln.split(" ", 1) for ln in out if ln.split(" ", 1)[1].startswith("dream(")]


def changed_paths(h, sha):
    return sorted(h.git("show", "--name-only", "--format=", sha).stdout.split())


class ApplyTests(unittest.TestCase):
    def tearDown(self):
        self.h.cleanup()

    def test_ac19_target_changed_since_copy_blocks_apply(self):
        self.h = h = FakeHome("ac19", repo=True)
        fh.standard(h)
        # another session edits the target while the dream runs (after the copy was made), and its
        # ledger hook records the write
        h.on_pull('[ "$N" = 2 ] || exit 0\necho "- edited by another session" >> %s\n'
                  'printf \'{"path": "%s", "sha256": "x", "session": "other-sess-42", "agent": "", "time": "t"}\\n\' '
                  '>> .claude/dream/local/ledger.jsonl\n' % (fh.MEM_LIVE, fh.MEM_LIVE))
        head = h.head()
        rc = h.run()
        self.assertEqual(rc, 3)
        text = h.read(fh.MEM_LIVE)
        self.assertNotIn(fh.LINT_LINE, text, "nothing was written")
        self.assertIn("- edited by another session", text)
        self.assertEqual(dream_commits(h), [])
        reason = h.local("last-run.json")["reason"]
        self.assertIn(fh.MEM_LIVE, reason)
        self.assertIn("other-sess", reason, "the ledger says who changed it")
        u = h.local("unsettled.json")
        self.assertEqual(len(u["findings"]), 1, "the finding stays for the next run")

    def test_a_stop_in_the_apply_step_adds_no_try(self):
        """R1-5: tries count only stops in steps 5 to 7; a stop in the apply step (a target changed since the
        copy, the lock, a foreign staged file, a failed commit) leaves the findings as they were."""
        self.h = h = FakeHome("r15", repo=True)
        fh.standard(h)
        h.on_pull('case "$N" in 2|4) echo "- edited by another session $N" >> %s ;; esac\n' % fh.MEM_LIVE)
        res = []
        for _ in range(2):
            rc = h.run()
            res.append((rc, [f["tries"] for f in h.local("unsettled.json")["findings"]]))
        self.assertEqual(res, [(3, [0]), (3, [0])], "two apply-step stops, no try counted")
        self.assertIn("changed since the copy", h.local("last-run.json")["reason"])
        self.assertEqual(h.run(), 0)
        self.assertIn(fh.LINT_LINE, h.read(fh.MEM_LIVE))
        self.assertNotIn("could not apply automatically", h.read(".claude/dream/justin-list.md"))

    def test_an_edit_the_second_pull_brings_to_the_dreams_own_files_is_kept(self):
        """R1-6: the log, Justin's list, the state and enforce-backlog lines are built on the files as they are
        after the apply step's pull, under the lock; a pending or tally file changed by the other machine in
        between stops the run with nothing written (no try), and the next run starts from that file."""
        self.h = h = FakeHome("r16", repo=True)
        lst = ".claude/dream/justin-list.md"
        bl = ".hermes/plans/claude-setup/enforce-backlog.md"
        h.write(lst, h.read(lst) + '- [ ] 2026-11-01 question: "old item one" x. Why: y\n'
                '- [ ] 2026-11-02 question: "old item two" x. Why: y\n')
        h.write(bl, "# Enforce backlog\n\n- 2026-11-01 | s | k | first proposal | offered\n")
        h.sync()
        fh.standard(h, extra_findings=[fh.finding("u1", "always run the linter before every", ambiguous=True)])
        mac = h.root / "mac"

        def mac_edit(script):  # after the run's first pull: the Mac edits, commits and pushes
            h.on_pull('[ "$N" = 1 ] || exit 0\nrm -rf "%s" && git clone -q "%s" "%s" && cd "%s" && %s && '
                      'git -c core.hooksPath=/dev/null commit -qam "sync(mac): edit" && git push -q origin HEAD:main\n'
                      % (mac, h.remote, mac, mac, script))

        mac_edit('grep -v "old item one" %s > l.tmp && mv l.tmp %s && '
                 'echo "- 2026-11-10 | mac-story | k | a proposal saved on the Mac | offered" >> %s' % (lst, lst, bl))
        self.assertEqual(h.run(), 0)
        text = h.read(lst)
        self.assertNotIn("old item one", text, "the item Justin deleted on the Mac stays deleted")
        self.assertIn("old item two", text)
        self.assertIn("always run the linter before every", text, "the run's own new item is there")
        self.assertIn("saved on the Mac", h.read(bl))
        self.assertIn(fh.LINT_LINE, h.read(fh.MEM_LIVE))
        self.assertEqual(h.remote_head(), h.head())
        self.assertNotIn("old item one", h.sh("git", "--git-dir=%s" % h.remote, "show", "main:" + lst).stdout)
        # a tally changed by the other machine while the dream ran: nothing written, no try, then a clean retry
        h.session(fh.PROJ, "s2", [typed("v1", "from now on always write the plan before the code")])
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s2"] = {"findings": [fh.finding("v1", "always write the plan before the code")]}
        sc["editor"]["edits"] = [{"file": fh.MEM_COPY, "append": "- Write the plan first (2026-11-09).\n"}]
        sc["editor"]["changes"]["changes"][0]["additions"] = ["- Write the plan first (2026-11-09)."]
        h.scenario(sc)
        tl = ".claude/dream/state/tally.json"
        mac_edit("python3 -c 'import json,sys; p=sys.argv[1]; t=json.load(open(p)); t[\"mac_note\"]=\"kept\"; "
                 "open(p,\"w\").write(json.dumps(t, indent=1, sort_keys=True)+\"\\n\")' %s" % tl)
        before = h.read(fh.MEM_LIVE)
        self.assertEqual(h.run(), 3)
        self.assertIn("tally.json", h.local("last-run.json")["reason"])
        self.assertEqual(h.read(fh.MEM_LIVE), before, "nothing written")
        self.assertEqual(json.loads(h.read(tl)).get("mac_note"), "kept")
        self.assertEqual([f["tries"] for f in h.local("unsettled.json")["findings"]], [0])
        (h.root / "on-pull.sh").write_text("exit 0\n")
        self.assertEqual(h.run(), 0)
        self.assertIn("- Write the plan first (2026-11-09).", h.read(fh.MEM_LIVE))
        self.assertEqual(json.loads(h.read(tl)).get("mac_note"), "kept", "the next run starts from the file")

    def test_ac20_library_edit_travels_only_in_the_patch_file(self):
        self.h = h = FakeHome("ac20", repo=True, library=True)
        lib = h.p(".hermes/skills-library")
        lib_copy = "hermes/skills-library/skills/lib-skill/SKILL.md"
        line = "- Review twice, once for the tests (2026-11-09)."
        fh.standard(h, edits=[{"file": lib_copy, "replace": ["- Review twice.", line]}],
                    changes={"changes": [{"file": lib_copy, "basis": "finding", "finding_ids": "ALL", "additions": [line],
                                          "removals": [{"text": "- Review twice.", "reason": "outdated"}]}]})
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s1"]["findings"][0]["general"] = True
        h.scenario(sc)
        self.assertEqual(h.run(), 0)
        self.assertIn(line, (lib / "skills/lib-skill/SKILL.md").read_text(), "the edit is in the clone's work tree")
        self.assertEqual(h.sh("git", "-C", str(lib), "rev-list", "--count", "HEAD", "--not", "--remotes").stdout.strip(), "0")
        self.assertEqual(h.sh("git", "-C", str(lib), "diff", "--cached", "--name-only").stdout, "", "nothing staged")
        diff = h.sh("git", "-C", str(lib), "diff").stdout
        self.assertEqual(h.read(".hermes/skills-library-local.patch"), diff)
        sha = dream_commits(h)[0][0]
        self.assertIn(".hermes/skills-library-local.patch", changed_paths(h, sha))
        self.assertEqual(diff.count("\n@@ "), 1, "one block per file")
        # a clone with a local commit: the run does not go live
        (lib / "skills/lib-skill/SKILL.md").write_text((lib / "skills/lib-skill/SKILL.md").read_text() + "- local\n")
        h.sh("git", "-C", str(lib), "commit", "-qam", "a local commit")
        h.session(fh.PROJ, "s2", [typed("v1", "always keep the review short and kind")])
        head = h.head()
        self.assertEqual(h.run(), 4)
        self.assertEqual(h.head(), head)
        self.assertIn("local commit", h.local("last-run.json")["reason"])
        # and the guard: more diff blocks against the library than before are refused
        from dreamlib import guards, targets
        long = "".join("- rule %02d\n" % i for i in range(30))
        h.sh("git", "-C", str(lib), "reset", "-q", "--hard", "origin/main")  # drop the local commit made above
        (lib / "skills/lib-skill/SKILL.md").write_text(long)
        h.sh("git", "-C", str(lib), "commit", "-qam", "longer skill")
        h.sh("git", "-C", str(lib), "push", "-q", "origin", "HEAD:main")
        rel = "hermes/skills-library/skills/lib-skill/SKILL.md"
        d = h.root / "g-lib"
        for root, text in (("snap", long), ("copy", long.replace("- rule 01\n", "- rule one\n").replace("- rule 28\n", "- rule 28b\n"))):
            (d / root / rel).parent.mkdir(parents=True, exist_ok=True)
            (d / root / rel).write_text(text)
        diffs, links = targets.diff_copy(d)
        G = guards.Input(h.denv(), d, {rel: {"live": targets.live_rel(rel), "sha": "x"}}, diffs, links, [], [], {},
                         {"kinds": {}}, targets.load_rules(h.denv()))
        self.assertTrue(guards.g_library(G), "two blocks where there were none")
        (d / "copy" / rel).write_text(long.replace("- rule 01\n", "- rule one\n"))
        diffs, links = targets.diff_copy(d)
        G.diffs = diffs
        self.assertEqual(guards.g_library(G), [], "one block is fine")

    def test_ac21_one_dream_commit_holds_only_the_dreams_paths_and_is_pushed(self):
        self.h = h = FakeHome("ac21", repo=True)
        fh.standard(h)
        # another session's uncommitted edit to a different synced file, and one made while the dream runs
        h.write(".hermes/skills/sd/general-skill/SKILL.md", "# General skill\n\n- Be clear.\n- Another session.\n")
        h.on_pull('[ "$N" = 2 ] || exit 0\necho "- typed while the dream ran" >> .hermes/skills/sd/other-skill/SKILL.md\n')
        self.assertEqual(h.run(), 0)
        commits = dream_commits(h)
        self.assertEqual(len(commits), 1)
        sha, subject = commits[0]
        self.assertRegex(subject, r"^dream\(2026-11-10 05:00\): 1 file\(s\), 1 finding\(s\) \[run 20261110-050000\]$")
        self.assertEqual(changed_paths(h, sha), sorted([
            fh.MEM_LIVE, ".claude/dream/dream-log.md", ".claude/dream/state/applied.json",
            ".claude/dream/state/trend.json"]), "the target, the log and the state files that changed")
        self.assertEqual(h.git("log", "-1", "--format=%ae", sha).stdout.strip(),
                         h.sh("git", "config", "user.email").stdout.strip())
        msg = h.git("log", "-1", "--format=%B", sha).stdout
        self.assertNotRegex(msg, r"(?im)^(co-authored-by|claude-session|generated-by):|anthropic|generated with")
        self.assertEqual(h.sh("git", "--git-dir=%s" % h.remote, "branch", "--contains", sha).stdout.strip("* \n"), "main",
                         "it is on main of the remote")
        subjects = h.git("log", "--format=%s", "main").stdout
        self.assertIn("sync(", subjects, "the other session's edit went in its own sync commit")
        st = h.git("status", "--porcelain").stdout
        self.assertIn("other-skill/SKILL.md", st + h.git("log", "--name-only", "--format=", "-3").stdout)
        # a foreign path staged while the dream holds the lock: the dream refuses to commit it
        h.session(fh.PROJ, "s2", [typed("v1", "from now on always write the plan before the code")])
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s2"] = {"findings": [fh.finding("v1", "always write the plan before the code")]}
        sc["editor"]["edits"] = [{"file": fh.MEM_COPY, "append": "- Write the plan first (2026-11-09).\n"}]
        sc["editor"]["changes"]["changes"][0]["additions"] = ["- Write the plan first (2026-11-09)."]
        h.scenario(sc)
        h.on_pull('[ "$N" = 2 ] || exit 0\necho "- staged by someone" >> .hermes/skills/sd/general-skill/SKILL.md\n'
                  'git --git-dir=.claude-setup.git --work-tree=. add -- .hermes/skills/sd/general-skill/SKILL.md\n')
        before_mem = h.read(fh.MEM_LIVE)
        self.assertEqual(h.run(), 3)
        self.assertEqual(len(dream_commits(h)), 1, "no second dream commit")
        self.assertEqual(h.read(fh.MEM_LIVE), before_mem, "its own files are restored")
        self.assertIn("staged", h.local("last-run.json")["reason"])

    def test_ac22_failed_push_leaves_a_local_commit_for_the_next_sync(self):
        self.h = h = FakeHome("ac22", repo=True)
        fh.standard(h)
        away = h.root / "remote-away.git"
        h.on_pull('[ "$N" = 2 ] || exit 0\nmv "%s" "%s"\n' % (h.remote, away))
        self.assertEqual(h.run(), 0)
        commits = dream_commits(h)
        self.assertEqual(len(commits), 1, "the dream commit exists locally")
        cur = state.load_cursors(h.denv())
        self.assertEqual(cur["%s/s1.jsonl" % fh.PROJ]["committed_line"], 2, "the markers have moved")
        lr = h.local("last-run.json")
        self.assertTrue(lr["push_pending"])
        self.assertIn("push pending", h.read(".claude/dream/dream-log.md"))
        shutil.move(str(away), str(h.remote))
        h.sync()
        self.assertEqual(h.remote_head(), h.head(), "the next ordinary sync.sh pushes it")
        self.assertEqual(h.sh("git", "--git-dir=%s" % h.remote, "branch", "--contains", commits[0][0]).stdout.strip("* \n"), "main")

    def test_ac23_unfinished_apply_is_finished_or_restored(self):
        def killed_run(h, where, after=1):
            """A run that dies (no finally, no cleanup) at `where` in apply."""
            pid = os.fork()
            if pid == 0:
                try:
                    n = {"k": 0}
                    real = getattr(apply, where)

                    def die(*a, **kw):
                        n["k"] += 1
                        if where == "write_live":
                            real(*a, **kw)
                        if n["k"] >= after:
                            os._exit(9)
                        if where != "write_live":
                            return real(*a, **kw)
                    setattr(apply, where, die)
                    h.run()
                finally:
                    os._exit(0)
            _, status = os.waitpid(pid, 0)
            self.assertEqual(os.waitstatus_to_exitcode(status), 9, "the run was killed where planned")

        # A: killed after every file was written, before the commit: the next run finishes the commit
        self.h = h = FakeHome("ac23a", repo=True)
        fh.standard(h)
        killed_run(h, "git_commit")
        self.assertTrue(h.p(".claude/dream/local/apply-journal.json").exists())
        self.assertEqual(dream_commits(h), [])
        self.assertEqual(h.run(), 0)
        self.assertEqual(len(dream_commits(h)), 1)
        self.assertEqual(h.read(fh.MEM_LIVE).count(fh.LINT_LINE), 1)
        self.assertFalse(h.p(".claude/dream/local/apply-journal.json").exists())
        for c in h.calls.glob("call-*"):
            c.unlink()
        self.assertEqual(h.run(), 0)
        self.assertEqual(h.calls_by_role(), [], "nothing processed twice")
        h.cleanup()

        # B: killed after 1 of 2 target files: the next run restores them; the finding is applied once later
        self.h = h = FakeHome("ac23b", repo=True)
        mem2 = ".claude/projects/%s/memory/MEMORY.md" % fh.PROJ
        line2 = "- [Build notes](build-notes.md): lint first (2026-11-09)."
        fh.standard(h, edits=[{"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n"},
                              {"file": mem2[1:], "append": line2 + "\n"}],
                    changes={"changes": [{"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL", "additions": [fh.LINT_LINE], "removals": []},
                                         {"file": mem2[1:], "basis": "finding", "finding_ids": "ALL", "additions": [line2], "removals": []}]})
        old = {p: h.read(p) for p in (fh.MEM_LIVE, mem2)}
        killed_run(h, "write_live", after=1)
        self.assertNotEqual([h.read(p) for p in old], list(old.values()), "one file was written before the kill")
        self.assertEqual(h.run(), 3)
        self.assertEqual({p: h.read(p) for p in old}, old, "every file it changed is back to its old bytes")
        self.assertFalse(h.p(".claude/dream/local/apply-journal.json").exists())
        self.assertEqual(len(h.local("unsettled.json")["findings"]), 1, "the finding is not lost")
        self.assertEqual(h.run(), 0)
        self.assertEqual(h.read(fh.MEM_LIVE).count(fh.LINT_LINE), 1, "applied once")
        self.assertEqual(len(dream_commits(h)), 1)
        h.cleanup()

        # C: someone edited a written file between the kill and the next run: left alone and reported
        self.h = h = FakeHome("ac23c", repo=True)
        fh.standard(h, edits=[{"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n"},
                              {"file": mem2[1:], "append": line2 + "\n"}],
                    changes={"changes": [{"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL", "additions": [fh.LINT_LINE], "removals": []},
                                         {"file": mem2[1:], "basis": "finding", "finding_ids": "ALL", "additions": [line2], "removals": []}]})
        killed_run(h, "write_live", after=1)
        written = [p for p in (fh.MEM_LIVE, mem2) if fh.LINT_LINE in h.read(p) or line2 in h.read(p)][0]
        h.write(written, h.read(written) + "- someone else\n")
        mine = h.read(written)
        self.assertEqual(h.run(), 3)
        self.assertEqual(h.read(written), mine, "left alone")
        self.assertIn(written, h.local("last-run.json")["reason"])

    def test_ac35_project_claude_md_copy_and_project_file_are_written_together(self):
        self.h = h = FakeHome("ac35", repo=True)
        doc = ".claude/project-docs/proj/CLAUDE.md"
        line = "- Lint before every commit (2026-11-09)."
        fh.standard(h, edits=[{"file": doc[1:], "append": line + "\n"}],
                    changes={"changes": [{"file": doc[1:], "basis": "finding", "finding_ids": "ALL", "additions": [line],
                                          "removals": []}]})
        self.assertEqual(h.run(), 0)
        self.assertIn(line, h.read(doc))
        self.assertEqual((h.project_dir / "CLAUDE.md").read_text(), h.read(doc), "the project's own file got the same bytes")
        h.sync()
        self.assertIn(line, h.read(doc), "sync.sh does not overwrite it with the old project file")
        # the two differed before the edit: the run does not go live
        (h.project_dir / "CLAUDE.md").write_text("# Proj rules\n\n- Use tabs.\n- A local change.\n")
        h.session(fh.PROJ, "s2", [typed("v1", "from now on always write the plan before the code")])
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s2"] = {"findings": [fh.finding("v1", "always write the plan before the code")]}
        sc["editor"]["edits"] = [{"file": doc[1:], "append": "- Plan first (2026-11-09).\n"}]
        sc["editor"]["changes"]["changes"][0]["additions"] = ["- Plan first (2026-11-09)."]
        h.scenario(sc)
        h.on_pull('[ "$N" = 2 ] || exit 0\necho "- changed in the project while the dream ran" >> "%s/CLAUDE.md"\n'
                  % h.project_dir)
        before = h.read(doc)
        self.assertEqual(h.run(), 3)
        self.assertNotIn("Plan first", h.read(doc))
        self.assertIn("project", h.local("last-run.json")["reason"])


if __name__ == "__main__":
    unittest.main()
