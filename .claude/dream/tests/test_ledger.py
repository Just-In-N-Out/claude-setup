"""Unattributed changes: AC26 (plan Task 12)."""
import json
import unittest

import fakehome as fh
from fakehome import FakeHome, typed
from dreamlib import ledger, paths


class LedgerTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("ac26", repo=True)
        self.env = self.h.denv()

    def tearDown(self):
        self.h.cleanup()

    def rows(self):
        return [json.loads(x) for x in self.h.p(".claude/dream/local/ledger.jsonl").read_text().splitlines()]

    def test_ac26_unattributed_change_is_logged_once(self):
        h, env = self.h, self.env
        # a target never seen before only gets a baseline row
        self.assertEqual(ledger.check(env, env.now()), [])
        base = {r["path"]: r for r in self.rows()}
        self.assertIn(fh.MEM_LIVE, base)
        self.assertEqual(base[fh.MEM_LIVE]["agent"], "baseline")
        a, b = ".hermes/skills/sd/other-skill/SKILL.md", fh.MEM_LIVE
        h.write(a, "# Other skill\n\n- Lint.\n- Changed on the Mac.\n")
        h.sync()  # it arrives in a sync(<host>) commit
        h.write(b, h.read(b) + "- typed by hand, not committed\n")
        # a write the hook recorded is not unattributed
        h.write(".claude/CLAUDE.md", h.read(".claude/CLAUDE.md") + "- recorded by the hook\n")
        ledger.append(env, [ledger.row(".claude/CLAUDE.md", paths.sha256_file(h.p(".claude/CLAUDE.md")), "", env.now(), "s9")])
        h.write(".hermes/skills/sd/new-skill/SKILL.md", "# New\n")
        got = {u["path"]: u["git"] for u in ledger.check(env, env.now())}
        self.assertEqual(sorted(got), sorted([a, b]))
        self.assertRegex(got[a], r"^[0-9a-f]{7,} sync\(")
        self.assertEqual(got[b], "uncommitted")
        self.assertEqual({r["path"]: r["agent"] for r in self.rows()}[".hermes/skills/sd/new-skill/SKILL.md"], "baseline")
        # reported once: a new ledger row was written
        self.assertEqual(ledger.check(env, env.now()), [])
        # end to end: the run's log entry names it, and the next run's does not
        h.write(a, h.read(a) + "- changed again\n")
        fh.standard(h)
        self.assertEqual(h.run(), 0)
        h.session(fh.PROJ, "s2", [typed("v1", "from now on always write the plan before the code")])
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s2"] = {"findings": [fh.finding("v1", "always write the plan before the code")]}
        sc["editor"]["edits"] = [{"file": fh.MEM_COPY, "append": "- Write the plan first (2026-11-09).\n"}]
        sc["editor"]["changes"]["changes"][0]["additions"] = ["- Write the plan first (2026-11-09)."]
        h.scenario(sc)
        self.assertEqual(h.run(), 0)
        entries = h.read(".claude/dream/dream-log.md").split("\n## Dream ")[1:]
        self.assertEqual(len(entries), 2)
        self.assertIn("`%s` (" % a, entries[0])
        self.assertNotIn(a, entries[1])
        self.assertNotIn(fh.MEM_LIVE + "` (", entries[1].split("Unattributed changes:")[1].split("\n")[0],
                         "the dream's own edit is not unattributed")


if __name__ == "__main__":
    unittest.main()
