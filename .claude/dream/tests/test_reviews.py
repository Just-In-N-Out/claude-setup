"""Review findings and failed acceptance checks: AC6 (plan Task 4)."""
import json
import os
import time
import unittest

from fakehome import FakeHome
from dreamlib import extract


class ReviewLineTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("ac6")

    def tearDown(self):
        self.h.cleanup()

    def test_ac6_review_and_failed_ac_lines_are_new_and_counted_once(self):
        h = self.h
        long_claim = "The guard accepts a path through a link. " * 20
        review1 = {"findings": [
            {"id": "R1-1", "severity": "P1", "claim": long_claim, "file_line": "guards.py:10"},
            {"id": "R1-2", "severity": "P2", "claim": "The test cannot fail.", "file_line": "t.py:3"},
            {"id": "R1-3", "severity": "P3", "claim": "A typo in a comment.", "file_line": "a.py:1"}]}
        old = {"findings": [
            {"severity": "high", "file": "x.js", "line": 3, "claim": "Old-style high finding."},
            {"severity": "medium", "file": "y.js", "claim": "Old-style medium finding."},
            {"severity": "low", "file": "z.js", "line": 1, "claim": "Old-style low finding."}]}
        ev = ".hermes/plans/figma-to-bricks/evidence/story-a/"
        h.write(ev + "review-1/review.json", json.dumps(review1))
        h.write(ev + "reviewer-2/review.json", json.dumps(old))
        # nested copies of the same review are not counted again
        h.write(ev + "earlier-oracles/review-1/review.json", json.dumps(review1))
        h.write(ev + "original-review-methods/review-1/review.json", json.dumps(review1))
        h.write(ev + "review-1/copy/review-1/review.json", json.dumps(review1))
        h.write(ev + "notes/review.json", json.dumps(review1))  # not in a review-<n> folder
        ac = {"head": "abc", "ac_status": [
            {"ac": "AC1", "accepted": True, "test": "t1"},
            {"ac": "AC2", "accepted": False, "test": "t2", "evidence": "the log ends EXIT=1"},
            {"ac": "AC3", "accepted": False, "not_run": "live: only Justin can run it"}]}
        ev2 = ".hermes/plans/leorna/evidence/story-b/"
        h.write(ev2 + "verifier/ac.json", json.dumps(ac))
        # links are never followed: a node_modules link holding a review, and a loop
        h.write("elsewhere/pkg/review-9/review.json", json.dumps(review1))
        h.write("elsewhere/pkg/ac.json", json.dumps(ac))
        os.symlink(h.p("elsewhere/pkg"), h.p(ev2 + "node_modules"))
        os.symlink(h.p(".hermes/plans/leorna/evidence"), h.p(ev2 + "loop"))
        os.symlink(h.p(ev + "review-1/review.json"), h.p(ev2 + "review-3-link.json"))
        env = h.denv()
        start = time.time()
        lines = extract.review_lines(env, [])
        self.assertLess(time.time() - start, 5, "the walk must not follow the loop")
        got = sorted((x["project"], x["story"], x["finding"], x["severity"], x["file"], x["claim"]) for x in lines)
        want = sorted([
            ("figma-to-bricks", "story-a", "R1-1", "P1", "guards.py:10", long_claim[:400]),
            ("figma-to-bricks", "story-a", "R1-2", "P2", "t.py:3", "The test cannot fail."),
            ("figma-to-bricks", "story-a", "", "high", "x.js:3", "Old-style high finding."),
            ("figma-to-bricks", "story-a", "", "medium", "y.js", "Old-style medium finding."),
            ("leorna", "story-b", "AC2", "AC", "t2", "the log ends EXIT=1")])
        self.assertEqual(got, want)
        self.assertEqual(len(lines[0]["claim"]) <= 400, True)
        # a second run yields no lines
        self.assertEqual(extract.review_lines(env, [x["id"] for x in lines]), [])


if __name__ == "__main__":
    unittest.main()
