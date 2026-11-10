"""Install and undo: AC33, AC34 (plan Task 15)."""
import json
import re
import subprocess
import unittest

import fakehome as fh
from fakehome import FakeHome


class InstallTests(unittest.TestCase):
    def tearDown(self):
        self.h.cleanup()

    def test_ac33_units_run_twice_daily_persistent_and_memory_capped(self):
        self.h = h = FakeHome("ac33", mode=None)
        r = h.dream("install")
        self.assertEqual(r.returncode, 0, r.stderr)
        units = h.p(".config/systemd/user")
        svc, tmr = units / "dream.service", units / "dream.timer"
        self.assertTrue(svc.is_file() and tmr.is_file())
        v = subprocess.run(["systemd-analyze", "--user", "verify", str(svc), str(tmr)], capture_output=True, text=True)
        self.assertEqual(v.returncode, 0, v.stdout + v.stderr)
        t, s = tmr.read_text(), svc.read_text()
        self.assertEqual(sorted(re.findall(r"^OnCalendar=(.*)$", t, re.M)), ["*-*-* 05:00:00", "*-*-* 17:00:00"])
        self.assertRegex(t, r"(?m)^Persistent=true$")
        self.assertRegex(s, r"(?m)^MemoryMax=6G$")
        self.assertRegex(s, r"(?m)^MemorySwapMax=0$")
        self.assertRegex(s, r"(?m)^ExecStart=/usr/bin/python3 %h/\.claude/dream/bin/dream run$")
        self.assertEqual(h.read(".claude/dream/local/mode").strip(), "dry-run")
        log = (h.root / "systemctl.log").read_text().splitlines()
        self.assertEqual(log, ["--user daemon-reload"], "the timer is not enabled without --enable")
        r = h.dream("install", "--enable")
        self.assertEqual(r.returncode, 0, r.stderr)
        self.assertEqual((h.root / "systemctl.log").read_text().splitlines()[-1], "--user enable --now dream.timer")
        h.write(".claude/dream/local/mode", "live\n")
        h.dream("install")
        self.assertEqual(h.read(".claude/dream/local/mode").strip(), "live", "an existing mode is kept")

    def test_ac34_undo_reverts_live_files_library_edits_and_project_copies(self):
        self.h = h = FakeHome("ac34", repo=True, library=True)
        lib = h.p(".hermes/skills-library")
        files = {
            fh.PROJ_SKILL + "/SKILL.md": ("- Build first.", "- Build first, lint before (2026-11-09)."),
            ".hermes/skills-library/skills/lib-skill/SKILL.md": ("- Review twice.", "- Review twice, lint first (2026-11-09)."),
            ".claude/project-docs/proj/CLAUDE.md": ("- Use tabs.", "- Use tabs; lint before commits (2026-11-09)."),
        }
        old = {p: h.read(p) for p in files}
        old_project = (h.project_dir / "CLAUDE.md").read_text()
        old_patch = h.read(".hermes/skills-library-local.patch")
        fh.standard(h, edits=[{"file": p[1:], "replace": [a, b]} for p, (a, b) in files.items()],
                    changes={"changes": [{"file": p[1:], "basis": "finding", "finding_ids": "ALL", "additions": [b],
                                          "removals": [{"text": a, "reason": "outdated"}]} for p, (a, b) in files.items()]})
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s1"]["findings"][0]["general"] = True
        h.scenario(sc)
        self.assertEqual(h.run(), 0)
        for p, (a, b) in files.items():
            self.assertIn(b, h.read(p), p)
        self.assertIn("lint before commits", (h.project_dir / "CLAUDE.md").read_text())
        dream_sha = h.git("log", "-1", "--format=%H", "--grep", "^dream(").stdout.strip()
        before_undo = h.git("rev-list", "--count", "HEAD").stdout.strip()
        r = h.dream("undo", dream_sha)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)
        self.assertEqual(int(h.git("rev-list", "--count", "HEAD").stdout), int(before_undo) + 1, "one revert commit")
        self.assertTrue(h.git("log", "-1", "--format=%s").stdout.startswith('Revert "dream('))
        for p in files:
            self.assertEqual(h.read(p), old[p], "back to its old bytes: " + p)
        self.assertEqual(h.read(".hermes/skills-library-local.patch"), old_patch)
        self.assertEqual(h.sh("git", "-C", str(lib), "diff").stdout, old_patch, "the clone matches the reverted patch file")
        self.assertEqual((h.project_dir / "CLAUDE.md").read_text(), old_project, "the project's own CLAUDE.md too")
        # so the next sync cannot bring the edit back
        h.sync()
        for p in files:
            self.assertEqual(h.read(p), old[p], "after the next sync: " + p)
        self.assertEqual(h.remote_head(), h.head())
        # only a dream commit can be undone this way
        r = h.dream("undo", "HEAD")
        self.assertNotEqual(r.returncode, 0)


if __name__ == "__main__":
    unittest.main()
