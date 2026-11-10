"""The editor and checker stages, dry run and the run end to end: AC13, AC32, and one end-to-end run
per exit code (plan Tasks 7 and 14)."""
import json
import unittest

import fakehome as fh
from fakehome import FakeHome, typed
from dreamlib import state


def snapshot(h):
    files = [fh.MEM_LIVE, ".claude/CLAUDE.md", ".claude/projects/%s/memory/MEMORY.md" % fh.PROJ,
             fh.PROJ_SKILL + "/SKILL.md", ".claude/project-docs/proj/CLAUDE.md"]
    return {f: h.read(f) for f in files}


class StageTests(unittest.TestCase):
    def tearDown(self):
        self.h.cleanup()

    def test_ac13_checker_no_leaves_live_files_untouched_and_parks_after_two_tries(self):
        self.h = h = FakeHome("ac13", repo=True)
        fh.standard(h, checker={"verdict": "no", "lost_facts": [], "untraced": [{"file": "x", "text": "y"}],
                                "notes": "the new line says more than the quote"})
        before, head = snapshot(h), h.head()
        self.assertEqual(h.run(), 3)
        self.assertEqual(snapshot(h), before, "every live target is byte-identical")
        self.assertEqual(h.head(), head, "no commit")
        self.assertEqual(state.load_cursors(h.denv()), {}, "the markers have not moved")
        self.assertIn("checking agent said no", h.local("last-run.json")["reason"])
        self.assertEqual([f["tries"] for f in h.local("unsettled.json")["findings"]], [1])
        # a second run tries the same findings again, without the helpers
        for c in h.calls.glob("call-*"):
            c.unlink()
        self.assertEqual(h.run(), 3)
        self.assertEqual(sorted(c["role"] for c in h.calls_by_role()), ["checker", "editor"])
        self.assertEqual(snapshot(h), before)
        # after two failed tries they go on Justin's list and stop blocking
        for c in h.calls.glob("call-*"):
            c.unlink()
        self.assertEqual(h.run(), 0)
        self.assertEqual(h.calls_by_role(), [], "no editor call for parked findings")
        lst = h.read(".claude/dream/justin-list.md")
        self.assertIn("could not apply automatically", lst)
        self.assertIn(fh.LINT_Q, lst)
        self.assertEqual(snapshot(h), before)
        self.assertEqual(h.local("unsettled.json", {}).get("findings", []), [])
        for c in h.calls.glob("call-*"):
            c.unlink()
        self.assertEqual(h.run(), 0)
        self.assertEqual(h.calls_by_role(), [])

    def test_ac32_dry_run_stops_before_the_apply_step(self):
        self.h = h = FakeHome("ac32", repo=True, mode=None)  # no mode file: dry-run
        self.assertFalse(h.p(".claude/dream/local/mode").exists())
        h.p(".claude/dream/local").mkdir(parents=True, exist_ok=True)
        fh.standard(h)
        before, head, remote = snapshot(h), h.head(), h.remote_head()
        self.assertEqual(h.run(), 0)
        run_dir = h.p(".cache/dream/20261110-050000")
        diff = (run_dir / "would-apply.diff").read_text()
        self.assertIn("+" + fh.LINT_LINE, diff)
        self.assertIn(fh.MEM_LIVE, diff)
        self.assertIn("## Dream 2026-11-10 05:00", (run_dir / "would-log-entry.md").read_text())
        self.assertEqual(snapshot(h), before, "no live file changed")
        self.assertEqual((h.head(), h.remote_head()), (head, remote), "no commit")
        self.assertIsNone(h.local("cursors.json"), "no marker moved")
        self.assertIsNone(h.local("unsettled.json"))
        self.assertEqual(h.git("status", "--porcelain").stdout, "")
        lr = h.local("last-run.json")
        self.assertEqual((lr["mode"], lr["result"]), ("dry-run", "dry-run"))
        # the mode file says live, the command line says --dry-run: still a dry run
        h.write(".claude/dream/local/mode", "live\n")
        self.assertEqual(h.run(mode="dry-run"), 0)
        self.assertEqual(snapshot(h), before)
        self.assertEqual(h.head(), head)

    def test_e2e_exit_0_a_live_run_applies_a_finding_and_pushes(self):
        self.h = h = FakeHome("e0", repo=True)
        fh.standard(h)
        self.assertEqual(h.run(), 0)
        self.assertIn(fh.LINT_LINE, h.read(fh.MEM_LIVE))
        self.assertEqual(h.remote_head(), h.head())
        lr = h.local("last-run.json")
        self.assertEqual((lr["result"], lr["files"], lr["findings"]), ("changed", 1, 1))

    def test_e2e_exit_3_a_guard_stops_the_run(self):
        self.h = h = FakeHome("e3", repo=True)
        fh.standard(h, edits=[{"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n" + "x" * 4000 + "\n"}])
        before = snapshot(h)
        self.assertEqual(h.run(), 3)
        self.assertEqual(snapshot(h), before)
        self.assertIn("guards", h.local("last-run.json")["reason"])

    def test_e2e_exit_4_a_pull_conflict_stops_before_any_call(self):
        self.h = h = FakeHome("e4", repo=True)
        fh.standard(h)
        h.on_pull('echo "setup-sync: CONFLICT: both changed the same file" >&2\n')
        self.assertEqual(h.run(), 4)
        self.assertEqual(h.calls_by_role(), [])
        self.assertIn("CONFLICT", h.local("last-run.json")["reason"])

    def test_e2e_exit_4_a_login_failure_stops_with_nothing_live(self):
        self.h = h = FakeHome("e4b", repo=True)
        sc = fh.standard(h)
        sc["fail"] = {"session-helper": {"api_error_status": 401}}
        h.scenario(sc)
        before, head = snapshot(h), h.head()
        self.assertEqual(h.run(), 4)
        self.assertEqual((snapshot(h), h.head()), (before, head))
        self.assertIn("login", h.local("last-run.json")["reason"])
        self.assertIsNone(h.local("unsettled.json"), "nothing saved: the next run reads the session again")

    def test_e2e_review_backfill_sends_one_helper_per_project_once(self):
        self.h = h = FakeHome("bf", repo=True)
        for proj in ("leorna", "figma-to-bricks", "claude-setup"):
            h.write(".hermes/plans/%s/evidence/st/review-1/review.json" % proj, json.dumps(
                {"findings": [{"id": "F%d" % i, "severity": "P2", "claim": "%s claim %d" % (proj, i), "file_line": "a:1"}
                              for i in range(80)]}))
        h.scenario({"review-helper": {"assign": "none"}})
        self.assertEqual(h.run(), 0)
        rh = [c for c in h.calls_by_role() if c["role"] == "review-helper"]
        self.assertEqual(sorted(c["stdin"].count("\nLINE ") for c in rh), [80, 80, 80], "no 150-line limit, one per project")
        t = json.loads(h.read(".claude/dream/state/tally.json"))
        self.assertTrue(t["backfill_done"])
        self.assertEqual(len(t["seen"]), 240)


if __name__ == "__main__":
    unittest.main()
