"""The log entry: AC24 (plan Task 10)."""
import json
import unittest

import fakehome as fh
from fakehome import FakeHome, typed, assistant
from dreamlib import apply, ledger, state


class LogTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("ac24", repo=True)

    def tearDown(self):
        self.h.cleanup()

    def test_ac24_log_entry_quotes_evidence_and_markers_move_after_commit(self):
        h = self.h
        env = h.denv()
        ledger.baseline(env, env.now())
        # a target changed with no ledger row: an unattributed change (the pull commits it as sync(<host>))
        h.write(".hermes/skills/sd/other-skill/SKILL.md", "# Other skill\n\n- Lint.\n- Changed by hand.\n")
        long_quote = "No, " + fh.LINT_Q + ", " + "and keep doing it on every single repository we have " * 8
        h.session(fh.PROJ, "s1", [assistant("I committed without linting."), typed("u1", long_quote),
                                  typed("u2", "for this task just keep the answers brief please")])
        h.scenario({"session-helper": {"s1": {"findings": [
            fh.finding("u1", long_quote),
            fh.finding("u2", "for this task just keep the answers brief", kind="preference"),
            fh.finding("u1", "a sentence Justin never typed at all")]}},
            "editor": {"edits": [{"file": fh.MEM_COPY, "replace": ["- Run the tests first.", fh.LINT_LINE]}],
                       "changes": {"changes": [{"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL",
                                                "summary": "lint before every commit replaces the old first step",
                                                "additions": [fh.LINT_LINE],
                                                "removals": [{"text": "- Run the tests first.", "reason": "outdated"}]}]}}})
        cursors_at_commit = []
        real_commit = apply.git_commit

        def spy(*a, **kw):
            cursors_at_commit.append(json.dumps(state.load_cursors(env), sort_keys=True))
            return real_commit(*a, **kw)
        apply.git_commit = spy
        try:
            self.assertEqual(h.run(), 0)
        finally:
            apply.git_commit = real_commit
        self.assertEqual(cursors_at_commit, ["{}"], "the markers had not moved when the commit was made")
        self.assertEqual(state.load_cursors(env)["%s/s1.jsonl" % fh.PROJ]["committed_line"], 3, "they moved after it")
        log = h.read(".claude/dream/dream-log.md")
        entries = log.split("\n## Dream ")
        self.assertEqual(len(entries), 2, "one new entry")
        e = entries[1]
        self.assertTrue(e.startswith("2026-11-10 05:00"), e[:40])
        for want in ("s1", fh.MEM_LIVE, "lint before every commit replaces the old first step",
                     "- Run the tests first.", "outdated", "for this task just keep the answers brief",
                     "quote not found", "Already saved: 0", ".hermes/skills/sd/other-skill/SKILL.md", "sync(",
                     "proj: 50 corrections per 100 typed messages", "Model calls: 3", "tokens",
                     "read to line 3"):
            self.assertIn(want, e, want)
        quoted = [ln for ln in e.splitlines() if ln.lstrip().startswith("> ")]
        self.assertTrue(quoted, "the evidence is quoted")
        self.assertTrue(all(len(ln.strip()[2:]) <= 300 for ln in quoted), "each quote at most 300 characters")
        self.assertNotIn("a sentence Justin never typed", e, "a failed quote's text is not logged")
        self.assertIn("2 typed message(s)", e)


if __name__ == "__main__":
    unittest.main()
