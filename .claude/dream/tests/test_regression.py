"""AC38's own script, regression.sh: it must never pass with nothing compared (verifier V2C-1).

Each test builds a tiny git checkout whose suites are one-line fakes, so a record and a compare take a
second, and runs this checkout's regression.sh against it with --root.
"""
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

import fakehome as fh

SCRIPT = fh.DREAM_SRC / "tests/regression.sh"
TEST = "regression_existing_suites_match_the_base_tally"
HOOK = ".claude/hooks/tests/"
FIXED = [".claude/setup/sync.test.sh", ".claude/setup/codex/codex-parity.test.sh",
         ".hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh",
         ".hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh"]
TWO_OK = 'echo "ok 1 - first"\necho "ok 2 - second"\n'


class RegressionScriptTests(unittest.TestCase):
    def setUp(self):
        fh.TEST_ROOT.mkdir(parents=True, exist_ok=True)
        self.dir = Path(tempfile.mkdtemp(prefix="dream-regression-", dir=str(fh.TEST_ROOT)))
        self.tmp = self.dir / "tmp"
        self.tmp.mkdir()

    def tearDown(self):
        shutil.rmtree(self.dir, ignore_errors=True)

    def git(self, root, *args):
        subprocess.run(["git", "-C", str(root)] + list(args), check=True, capture_output=True, text=True)

    def checkout(self, hooks):
        """A git checkout with the four fixed suites passing twice and the given hook suites."""
        root = self.dir / "root"
        for rel in FIXED:
            self.put(root, rel, TWO_OK)
        for name, body in hooks.items():
            self.put(root, HOOK + name, body)
        self.git(root.parent, "init", "-q", str(root))
        self.commit(root, "base")
        return root

    def put(self, root, rel, body):
        f = root / rel
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(body)

    def commit(self, root, msg):
        self.git(root, "add", "-A")
        self.git(root, "commit", "-qm", msg)
        return subprocess.run(["git", "-C", str(root), "rev-parse", "HEAD"], capture_output=True,
                              text=True, check=True).stdout.strip()

    def run_script(self, root, *args, tmpdir=None):
        env = dict(os.environ, TMPDIR=str(tmpdir or self.tmp))
        p = subprocess.run(["bash", str(SCRIPT)] + list(args) + ["--root", str(root)], capture_output=True,
                           text=True, env=env, timeout=120)
        return p.returncode, p.stdout + p.stderr

    def baseline(self, sha, suites, name="hand.md"):
        f = self.dir / name
        f.write_text("# a hand-written baseline\n\nRecorded on base %s.\n\n```json\n%s\n```\n"
                     % (sha, json.dumps({"suites": suites}, indent=2)))
        return f

    def all_suites(self, hooks, tallies=None):
        tallies = tallies or {}
        names = [FIXED[0]] + [HOOK + n for n in sorted(hooks)] + FIXED[1:]
        return [{"suite": s, "pass": tallies.get(s, 2), "rc": 0, "failing": []} for s in names]

    def test_regression_records_and_compares_a_small_suite_set(self):
        """The control: a record and a compare on the same checkout pass; a suite the story added after the
        base is not asked of the baseline; a changed tally still fails."""
        root = self.checkout({"a.test.sh": TWO_OK})
        base = self.dir / "baseline.md"
        rc, out = self.run_script(root, "--record", str(base))
        self.assertEqual(rc, 0, out)
        self.assertTrue(base.exists(), out)
        rc, out = self.run_script(root, str(base))
        self.assertEqual((rc, out.splitlines()[-1]), (0, "ok 1 - " + TEST), out)
        self.put(root, HOOK + "added-by-the-story.test.sh", TWO_OK)
        self.commit(root, "the story adds a suite")
        rc, out = self.run_script(root, str(base))
        self.assertEqual((rc, out.splitlines()[-1]), (0, "ok 1 - " + TEST), out)
        self.put(root, HOOK + "a.test.sh", 'echo "ok 1 - first"\necho "not ok 2 - second"\n')
        self.commit(root, "a test breaks")
        rc, out = self.run_script(root, str(base))
        self.assertEqual(rc, 1, out)
        self.assertIn("not ok 1 - " + TEST, out)

    def test_regression_refuses_to_record_or_compare_without_a_temporary_folder(self):
        root = self.checkout({"a.test.sh": TWO_OK})
        missing = self.dir / "no-such-folder"
        base = self.dir / "baseline.md"
        rc, out = self.run_script(root, "--record", str(base), tmpdir=missing)
        self.assertNotEqual(rc, 0, out)
        self.assertFalse(base.exists(), "no baseline is written: " + out)
        self.assertIn("could not make a temporary folder in %s" % missing, out)
        good = self.baseline(self.commit_sha(root), self.all_suites({"a.test.sh": 1}))
        rc, out = self.run_script(root, str(good), tmpdir=missing)
        self.assertEqual(rc, 1, out)
        self.assertIn("not ok 1 - " + TEST, out)
        self.assertIn("could not make a temporary folder in %s" % missing, out)

    def test_regression_refuses_to_record_a_suite_that_tallied_no_tests(self):
        root = self.checkout({"a.test.sh": TWO_OK, "silent.test.sh": "true\n"})
        base = self.dir / "baseline.md"
        rc, out = self.run_script(root, "--record", str(base))
        self.assertNotEqual(rc, 0, out)
        self.assertFalse(base.exists(), "no baseline is written: " + out)
        self.assertIn("tallied no tests: %ssilent.test.sh" % HOOK, out)

    def test_regression_refuses_a_baseline_that_lists_no_suites(self):
        root = self.checkout({"a.test.sh": TWO_OK})
        rc, out = self.run_script(root, str(self.baseline(self.commit_sha(root), [])))
        self.assertEqual(rc, 1, out)
        self.assertIn("not ok 1 - " + TEST, out)
        self.assertIn("the baseline lists no suites", out)

    def test_regression_refuses_a_baseline_that_leaves_out_a_suite_the_base_had(self):
        hooks = {"a.test.sh": TWO_OK, "b.test.sh": TWO_OK}
        root = self.checkout(hooks)
        suites = [s for s in self.all_suites(hooks) if not s["suite"].endswith("/b.test.sh")]
        rc, out = self.run_script(root, str(self.baseline(self.commit_sha(root), suites)))
        self.assertEqual(rc, 1, out)
        self.assertIn("not ok 1 - " + TEST, out)
        self.assertIn("the baseline leaves out suites the base had: %sb.test.sh" % HOOK, out)

    def test_regression_refuses_a_baseline_suite_at_no_tests(self):
        """The head's suite also tallies none, so the tallies agree: only the refusal can fail this."""
        hooks = {"a.test.sh": TWO_OK, "silent.test.sh": "true\n"}
        root = self.checkout(hooks)
        suites = self.all_suites(hooks, {HOOK + "silent.test.sh": 0})
        rc, out = self.run_script(root, str(self.baseline(self.commit_sha(root), suites)))
        self.assertEqual(rc, 1, out)
        self.assertIn("not ok 1 - " + TEST, out)
        self.assertIn("the baseline has suites with no tests: %ssilent.test.sh" % HOOK, out)

    def commit_sha(self, root):
        return subprocess.run(["git", "-C", str(root), "rev-parse", "HEAD"], capture_output=True, text=True,
                              check=True).stdout.strip()


if __name__ == "__main__":
    unittest.main()
