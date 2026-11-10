"""Markers and the nothing-new exit: AC4, AC5 (plan Task 3)."""
import json
import unittest

import fakehome as fh
from fakehome import FakeHome, typed, assistant, tool_result
from dreamlib import state, paths


class StateTests(unittest.TestCase):
    def tearDown(self):
        self.h.cleanup()

    def test_ac4_nothing_new_makes_no_model_call(self):
        self.h = h = FakeHome("ac4", repo=True)
        f = h.session(fh.PROJ, "s1", [typed("u1", "an old message already processed by a dream")])
        env = h.denv()
        # the session was read to its end by an earlier run; it then grew only by Claude's own lines
        r = state.scan(env, {}, env.now())
        cur = state.markers_after(r.reads[0], r.reads[0].entries, {})
        state.commit_cursor(cur)
        state.save_cursors(env, {r.reads[0].key: cur})
        h.append_session(f, [assistant("Claude kept talking"), tool_result("r9", "tool output")])
        # an evidence folder whose findings were all seen before, and one with only P3 findings
        h.write(".hermes/plans/claude-setup/evidence/st/review-1/review.json", json.dumps(
            {"findings": [{"id": "F1", "severity": "P3", "claim": "cosmetic", "file_line": "a:1"}]}))
        before_head, before_remote = h.head(), h.remote_head()
        rc = h.run()
        self.assertEqual(rc, 0)
        self.assertEqual(h.calls_by_role(), [], "zero model calls")
        self.assertEqual(h.head(), before_head, "no commit")
        self.assertEqual(h.remote_head(), before_remote)
        self.assertIsNone(h.local("last-run.json"), "a run with nothing new writes nothing")
        self.assertEqual(h.git("status", "--porcelain").stdout, "")

    def test_ac5_markers_resume_per_session_and_skip_active_and_headless(self):
        self.h = h = FakeHome("ac5")
        env = h.denv()
        a = h.session(fh.PROJ, "a", [typed("a1", "first message in session a"), assistant("ok"),
                                    typed("a2", "second message in session a")])
        h.session(fh.PROJ, "busy", [typed("b1", "typed a few minutes ago")], age_minutes=10)
        h.session(fh.PROJ, "quiet", [assistant("only Claude here"), tool_result("q1", "output")])
        h.session(fh.PROJ, "headless", [dict(typed("h1", "a headless prompt", source="sdk"), entrypoint="sdk-cli"),
                                        dict(assistant("answer"), entrypoint="sdk-cli")])
        e = h.session(fh.OTHER, "e", [typed("e1", "message one in e"), typed("e2", "message two in e")])
        s1 = state.scan(env, {}, env.now())
        self.assertEqual(sorted(r.key for r in s1.reads), sorted(["%s/a.jsonl" % fh.PROJ, "%s/e.jsonl" % fh.OTHER]))
        self.assertEqual(s1.skipped["%s/busy.jsonl" % fh.PROJ], "active")
        self.assertEqual(s1.skipped["%s/quiet.jsonl" % fh.PROJ], "no typed message")
        self.assertEqual(s1.skipped["%s/headless.jsonl" % fh.PROJ], "headless")
        cursors = {}
        for r in s1.reads:
            cursors[r.key] = state.commit_cursor(state.markers_after(r, r.entries, {}))
        state.save_cursors(env, cursors)
        cursors = state.load_cursors(env)
        # new lines in a: only they are read
        h.append_session(a, [assistant("more"), typed("a3", "third message in session a")])
        # e is rewritten (compacted): the old uuids stay, one new message, different line layout
        h.session(fh.OTHER, "e", [assistant("a summary line first"), typed("e1", "message one in e"),
                                  typed("e2", "message two in e"), typed("e3", "message three in e")])
        s2 = state.scan(env, cursors, env.now())
        got = {r.key: [x["uuid"] for x in r.entries] for r in s2.reads}
        self.assertEqual(got, {"%s/a.jsonl" % fh.PROJ: ["a3"], "%s/e.jsonl" % fh.OTHER: ["e3"]})
        er = [r for r in s2.reads if r.key.endswith("/e.jsonl")][0]
        self.assertTrue(er.rewritten)
        # nothing new after those are committed
        for r in s2.reads:
            cursors[r.key] = state.commit_cursor(state.markers_after(r, r.entries, cursors.get(r.key, {})))
        s3 = state.scan(env, cursors, env.now())
        self.assertEqual(s3.reads, [])
        # the marker of a session whose file is gone is dropped
        a.unlink()
        s4 = state.scan(env, cursors, env.now())
        self.assertIn("%s/a.jsonl" % fh.PROJ, s4.gone)
        # dream init: a session with fewer than 3 typed messages starts at its end; one with 3 or more is read
        h2 = FakeHome("ac5init")
        try:
            h2.session(fh.PROJ, "two", [typed("t1", "one message here"), typed("t2", "two messages here")])
            h2.session(fh.PROJ, "three", [typed("r1", "first of three"), typed("r2", "second of three"),
                                          typed("r3", "third of three")])
            out = h2.dream("init")
            self.assertEqual(out.returncode, 0, out.stderr)
            c = state.load_cursors(h2.denv())
            self.assertEqual(c["%s/two.jsonl" % fh.PROJ]["committed_line"], 2)
            self.assertNotIn("%s/three.jsonl" % fh.PROJ, c)
            self.assertEqual([r.key for r in state.scan(h2.denv(), c, h2.denv().now()).reads], ["%s/three.jsonl" % fh.PROJ])
        finally:
            h2.cleanup()


if __name__ == "__main__":
    unittest.main()
