"""The guards, no model: AC9, AC11, AC14, AC15, AC16, AC17, AC18, AC44 (plan Task 8).

Each guard is checked on a scratch copy (snap = live bytes, copy = the editor's result), and the ACs that
say "the run does not go live" also end to end, with an editor and a checker that say yes.
"""
import json
import os
import re
import subprocess
import unittest

import fakehome as fh
from fakehome import FakeHome, typed
from dreamlib import guards, targets, paths

MEM = "claude/projects/%s/memory/build-notes.md" % fh.PROJ


def fnd(fid="f1", date="2026-11-09", folder=fh.PROJ, **kw):
    f = {"id": fid, "session": "s1", "folder": folder, "project": "proj", "uuid": "u1", "quote": "a quote here ok",
         "kind": "correction", "statement": "s", "date": date, "label": "TYPED", "general": False,
         "two_projects": False, "replaces": "", "ambiguous": False, "tries": 0}
    f.update(kw)
    return f


def change(file, ids=("f1",), adds=(), rems=(), basis="finding", order_id=""):
    return {"file": file, "basis": basis, "finding_ids": list(ids), "order_id": order_id, "summary": "x",
            "additions": list(adds), "removals": list(rems)}


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("guards")
        self.env = self.h.denv()
        self.n = 0

    def tearDown(self):
        self.h.cleanup()

    def G(self, files, findings=(), changes=None, orders=(), tally=None):
        """files: {copy path: (old or None, new or None)}"""
        self.n += 1
        d = self.h.root / ("g%d" % self.n)
        for rel, (old, new) in files.items():
            for root, text in (("snap", old), ("copy", new)):
                if text is not None:
                    f = d / root / rel
                    f.parent.mkdir(parents=True, exist_ok=True)
                    f.write_text(text)
        (d / "copy").mkdir(parents=True, exist_ok=True)
        (d / "snap").mkdir(parents=True, exist_ok=True)
        diffs, links = targets.diff_copy(d)
        mapping = {rel: {"live": targets.live_rel(rel), "sha": "x"} for rel, (old, _) in files.items() if old is not None}
        ch = changes if changes is not None else {"changes": [], "already_saved": [], "declined": []}
        for k in ("changes", "already_saved", "declined"):
            ch.setdefault(k, [])
        return guards.Input(self.env, d, mapping, diffs, links, list(findings), list(orders), ch,
                            tally or {"kinds": {}}, targets.load_rules(self.env))

    def test_ac9_addition_from_typed_finding_carries_its_date(self):
        old = "# Build notes\n\n- Run the tests first.\n"
        f = fnd(date="2026-11-09")
        bad = self.G({MEM: (old, old + "- Run the linter before committing.\n")}, [f],
                     {"changes": [change(MEM, adds=["- Run the linter before committing."])]})
        self.assertTrue(guards.g_dates_on_additions(bad))
        good = self.G({MEM: (old, old + "- Run the linter before committing (2026-11-09).\n")}, [f],
                      {"changes": [change(MEM, adds=["- Run the linter before committing (2026-11-09)."])]})
        self.assertEqual(guards.g_dates_on_additions(good), [])
        # the date must be in the file, not only in changes.json
        lie = self.G({MEM: (old, old + "- Run the linter before committing.\n")}, [f],
                     {"changes": [change(MEM, adds=["- Run the linter before committing. (2026-11-09)"])]})
        self.assertTrue(guards.g_dates_on_additions(lie))

    def test_ac11_protected_section_change_blocks_the_run(self):
        c = "claude/CLAUDE.md"
        old = fh.CLAUDE_MD
        one_byte = old.replace("never push to Leorna", "never push to Leorna!")
        self.assertTrue(guards.g_protected(self.G({c: (old, one_byte)})), "one byte inside the section")
        outside = old.replace("- Keep plans short.", "- Keep plans short and clear.")
        self.assertEqual(guards.g_protected(self.G({c: (old, outside)})), [])
        renamed = old.replace("## Git Rules", "## Git rules (old)")
        self.assertTrue(guards.g_protected(self.G({c: (old, renamed)})), "a renamed heading")
        gone = self.G({c: (old.replace("## Git Rules", "## Other"), outside.replace("## Git Rules", "## Other"))})
        self.assertTrue(guards.g_protected(gone), "a listed heading that no longer exists")
        self.h.write(".claude/dream/conf/protected.tsv", "# t\n.claude/CLAUDE.md\tGit Rules\n"
                     "%s/SKILL.md\t*\n" % fh.PROJ_SKILL)
        sk = targets.copy_rel(fh.PROJ_SKILL + "/SKILL.md")
        s_old = self.h.read(fh.PROJ_SKILL + "/SKILL.md")
        self.assertTrue(guards.g_protected(self.G({sk: (s_old, s_old + "- one more\n")})), "a whole file frozen")
        # end to end: the helper, the editor and the checker all say yes; the guard alone stops it
        self.h.cleanup()
        self.h = h = FakeHome("ac11", repo=True)
        h.session(fh.PROJ, "s11", [typed("u1", "from now on we always push to Leorna without asking")])
        h.scenario({
            "session-helper": {"s11": {"findings": [dict(uuid="u1", quote="we always push to Leorna without asking",
                kind="decision", statement="Push to Leorna without asking (2026-11-09).", general=True,
                replaces="never push to Leorna without asking",
                matches_pending="", loosens_safety=False, weakens_check=False, personal=False, ambiguous=False,
                depends_on_image=False)]}},
            "editor": {"edits": [{"file": "claude/CLAUDE.md", "replace": [
                "- never push to Leorna without asking (2026-10-01)", "- push to Leorna without asking (2026-11-09)"]}],
                "changes": {"changes": [change("claude/CLAUDE.md", ids="ALL", adds=["- push to Leorna without asking (2026-11-09)"],
                            rems=[{"text": "- never push to Leorna without asking (2026-10-01)", "reason": "outdated"}])]}},
            "checker": {"verdict": "yes", "lost_facts": [], "untraced": [], "notes": ""}})
        h.write(".claude/dream/conf/canary.tsv", "# none\n")
        before = h.read(".claude/CLAUDE.md")
        self.assertEqual(h.run(), 3)
        self.assertEqual(h.read(".claude/CLAUDE.md"), before)
        self.assertNotIn("dream(", h.git("log", "--format=%s").stdout, "no dream commit")
        self.assertIn("Git Rules", h.local("last-run.json")["reason"])

    def test_ac14_file_over_budget_may_only_shrink(self):
        base = "# Notes\n" + "".join("- line %04d of the note\n" % i for i in range(400))  # about 9,600 bytes
        self.assertGreater(len(base), 8000)
        grow = self.G({MEM: (base, base + "- one more line\n")})
        self.assertTrue(guards.g_budgets(grow), "over budget and growing")
        shrink = self.G({MEM: (base, base.replace("- line 0001 of the note\n", ""))})
        self.assertEqual(guards.g_budgets(shrink), [])
        under = "# Notes\n" + "x" * 7980 + "\n"
        cross = self.G({MEM: (under, under + "- a line that crosses the budget\n")})
        self.assertTrue(guards.g_budgets(cross), "under budget may not cross it")
        stay = self.G({MEM: ("# Notes\n", "# Notes\n- small\n")})
        self.assertEqual(guards.g_budgets(stay), [])
        idx = "claude/projects/%s/memory/MEMORY.md" % fh.PROJ
        many = "# Memory\n" + "".join("- [n%d](n%d.md)\n" % (i, i) for i in range(199))
        self.assertTrue(guards.g_budgets(self.G({idx: (many, many + "- [x](x.md)\n- [y](y.md)\n")})),
                        "the 200-line budget of a memory index")

    def test_ac15_change_caps_block_oversized_runs_and_ignore_verbatim_moves(self):
        g = guards.g_caps
        old = "# Notes\n"
        add = lambda n: "".join("- added line %05d %s\n" % (i, "x" * 40) for i in range(n))  # 60 bytes a line
        self.assertTrue(g(self.G({MEM: (old, old + add(51))})), "3,060 bytes added to one file")
        self.assertEqual(g(self.G({MEM: (old, old + add(48))})), [])
        big = "# Big\n" + add(1700)                       # 102,006 bytes: 5% is 5,100
        cut = big.replace(add(1700)[: 60 * 70], "")      # 4,200 bytes removed: over 3,000, under 5%
        self.assertEqual(g(self.G({MEM: (big, cut)})), [])
        cut2 = big.replace(add(1700)[: 60 * 90], "")     # 5,400 bytes: over both
        self.assertTrue(g(self.G({MEM: (big, cut2)})))
        five = {"claude/projects/%s/memory/n%d.md" % (fh.PROJ, i): (old, old + add(47)) for i in range(5)}
        self.assertTrue(g(self.G(five)), "14,100 bytes added in one run, 2,820 per file")
        thirteen = {"claude/projects/%s/memory/m%02d.md" % (fh.PROJ, i): (old, old + "- x\n") for i in range(13)}
        self.assertTrue(g(self.G(thirteen)), "13 files changed")
        new3 = {"claude/projects/%s/memory/new%d.md" % (fh.PROJ, i): (None, "# New\n") for i in range(3)}
        self.assertTrue(g(self.G(new3)), "3 new files")
        self.assertTrue(g(self.G({MEM: (old, None)})), "a deleted file")
        libs = {"hermes/skills-library/skills/s%d/SKILL.md" % i: ("# S\n", "# S\n- x\n") for i in range(4)}
        self.assertTrue(g(self.G(libs)), "4 library skills")
        three = dict(list(libs.items())[:3])
        self.assertEqual(g(self.G(three)), [])
        # a section moved word for word to references/ counts as neither removed nor added (up to 30,000)
        section = "## Long section\n" + add(160)          # about 9,800 bytes
        sk = targets.copy_rel(fh.PROJ_SKILL + "/SKILL.md")
        ref = targets.copy_rel(fh.PROJ_SKILL + "/references/long.md")
        moved = self.G({sk: ("# Skill\n\n" + section + "\n## Tail\n", "# Skill\n\nSee references/long.md.\n\n## Tail\n"),
                        ref: (None, "# Long\n\n" + section)})
        self.assertEqual(g(moved), [])
        # the same bytes removed without landing anywhere are over the cap
        lost = self.G({sk: ("# Skill\n\n" + section + "\n## Tail\n", "# Skill\n\n## Tail\n")})
        self.assertTrue(g(lost))

    def test_ac16_missing_canary_fact_blocks_the_run(self):
        c = "claude/CLAUDE.md"
        old = fh.CLAUDE_MD
        gone = old.replace("- never push to Leorna without asking (2026-10-01)\n", "")
        self.assertTrue(guards.g_canary(self.G({c: (old, gone)})))
        kept = old.replace("- Keep plans short.\n", "")
        self.assertEqual(guards.g_canary(self.G({c: (old, kept)})), [])
        self.assertTrue(guards.g_canary(self.G({c: (old, None)})), "a deleted file loses its canaries")
        # every seed canary is in its live file in this checkout
        missing = []
        for row in paths.read_tsv(fh.DREAM_SRC / "conf/canary.tsv"):
            if row[1] not in (fh.REPO / row[0]).read_text():
                missing.append(row)
        self.assertEqual(missing, [])
        self.assertGreaterEqual(len(paths.read_tsv(fh.DREAM_SRC / "conf/canary.tsv")), 25)

    def test_ac17_every_removed_and_added_line_is_accounted_for(self):
        old = "# Build notes\n\n- Run the tests first.\n- Old way of building.\n"
        new = "# Build notes\n\n- Run the tests first.\n- New way of building (2026-11-09).\n"
        f = [fnd()]
        ok = {"changes": [change(MEM, adds=["- New way of building (2026-11-09)."],
                                 rems=[{"text": "- Old way of building.", "reason": "outdated"}])]}
        self.assertEqual(guards.g_accounting(self.G({MEM: (old, new)}, f, ok)), [])
        unlisted = {"changes": [change(MEM, adds=["- New way of building (2026-11-09)."])]}
        self.assertTrue(guards.g_accounting(self.G({MEM: (old, new)}, f, unlisted)), "a removal not listed")
        stranger = {"changes": [change(MEM, ids=["nope"], adds=["- New way of building (2026-11-09)."],
                                       rems=[{"text": "- Old way of building.", "reason": "outdated"}])]}
        self.assertTrue(guards.g_accounting(self.G({MEM: (old, new)}, f, stranger)), "a finding that did not pass")
        no_add = {"changes": [change(MEM, rems=[{"text": "- Old way of building.", "reason": "outdated"}])]}
        self.assertTrue(guards.g_accounting(self.G({MEM: (old, new)}, f, no_add)), "an addition not listed")
        # a duplicate: removed because the same text stays elsewhere, and it really does
        dup_old = "# Build notes\n\n- Run the tests first.\n- Run the tests first, always.\n"
        dup_new = "# Build notes\n\n- Run the tests first.\n"
        dup = lambda s: {"changes": [change(MEM, ids=[], basis="duplicate",
                                            rems=[{"text": "- Run the tests first, always.", "reason": "duplicate",
                                                   "surviving_text": s}])]}
        self.assertEqual(guards.g_accounting(self.G({MEM: (dup_old, dup_new)}, f, dup("- Run the tests first."))), [])
        self.assertTrue(guards.g_accounting(self.G({MEM: (dup_old, dup_new)}, f, dup("- Not in any file."))))
        # moved word for word to another target
        mem2 = "claude/projects/%s/memory/other.md" % fh.PROJ
        mv = self.G({MEM: (old, "# Build notes\n\n- Run the tests first.\n"), mem2: ("# Other\n", "# Other\n- Old way of building.\n")})
        self.assertEqual(guards.g_accounting(mv), [])

    def test_ac18_only_allowed_targets_and_narrowest_scope(self):
        h = self.h
        e = lambda rel, f=None, ch=None: guards.g_allowlist(self.G({rel: (None, "# x\n")}, f or [fnd()], ch or {
            "changes": [change(rel, adds=["# x"])]}))
        for rel in ("codex/AGENTS.md", "claude/dream/DREAM.md", "claude/projects/%s/s1.jsonl" % fh.PROJ,
                    "hermes/plans/p/evidence/s/e.md", "hermes/skills/sd/proj-skill/run.sh",
                    "hermes/memories/MEMORY.md", "claude/dream/state/tally.json"):
            self.assertTrue(e(rel), rel)
        # a path reached through a link: a skill folder that is a link into ~/Leorna
        h.write("Leorna/skills/x/SKILL.md", "# x\n")
        os.symlink(h.p("Leorna/skills/x"), h.p(".hermes/skills/sd/linked"))
        self.assertTrue(e("hermes/skills/sd/linked/new.md", [fnd(general=True)]), "through a link into ~/Leorna")
        # narrowest scope: CLAUDE.md and a general skill need a general finding (or two projects)
        c = "claude/CLAUDE.md"
        cm = lambda f: guards.g_allowlist(self.G({c: (fh.CLAUDE_MD, fh.CLAUDE_MD + "- x (2026-11-09)\n")}, [f],
                                                 {"changes": [change(c, adds=["- x (2026-11-09)"])]}))
        self.assertTrue(cm(fnd()))
        self.assertEqual(cm(fnd(general=True)), [])
        self.assertEqual(cm(fnd(two_projects=True)), [])
        gs = "hermes/skills/sd/general-skill/SKILL.md"
        self.assertTrue(guards.g_allowlist(self.G({gs: ("# G\n", "# G\n- x\n")}, [fnd()], {"changes": [change(gs, adds=["- x"])]})))
        ps = targets.copy_rel(fh.PROJ_SKILL + "/SKILL.md")
        self.assertEqual(guards.g_allowlist(self.G({ps: ("# P\n", "# P\n- x\n")}, [fnd()], {"changes": [change(ps, adds=["- x"])]})), [])
        om = "claude/projects/%s/memory/MEMORY.md" % fh.OTHER
        self.assertTrue(guards.g_allowlist(self.G({om: ("# M\n", "# M\n- x\n")}, [fnd()], {"changes": [change(om, adds=["- x"])]})),
                        "another project's memory")
        self.assertEqual(guards.g_allowlist(self.G({MEM: ("# M\n", "# M\n- x\n")}, [fnd()], {"changes": [change(MEM, adds=["- x"])]})), [])
        # every allowed seed is synced: it matches a manifest line and not sync.sh's never-list
        self.assertEqual(seed_problems(), [])


def seed_problems():
    """Each allow/dream/append glob of the checkout's conf/targets.txt, as a sample path, must be added by
    the checkout's manifest.txt and must not match sync.sh's DENY_RE (library skills travel in the patch)."""
    import tempfile
    rules = [r for r in paths.read_tsv(fh.DREAM_SRC / "conf/targets.txt") if r[0] in ("allow", "dream", "append")]
    deny = re.search(r"^DENY_RE='(.*)'$", (fh.REPO / ".claude/setup/sync.sh").read_text(), re.M).group(1)
    probs = []
    with tempfile.TemporaryDirectory(dir=str(fh.TEST_ROOT)) as d:
        subprocess.run(["git", "init", "-q", d], check=True)
        samples = {}
        for kind, g in rules:
            if g.startswith(".hermes/skills-library/"):
                continue
            s = g.replace("**/", "a/").replace("**", "a.md").replace("*", "x")
            samples[s] = g
            p = os.path.join(d, s)
            os.makedirs(os.path.dirname(p), exist_ok=True)
            open(p, "w").write("x\n")
        for spec in paths.read_conf_lines(fh.REPO / ".claude/setup/manifest.txt"):
            subprocess.run(["git", "-C", d, "add", "-A", "--", spec], capture_output=True)
        staged = set(subprocess.run(["git", "-C", d, "diff", "--cached", "--name-only"], capture_output=True,
                                    text=True).stdout.split())
        for s, g in samples.items():
            if s not in staged:
                probs.append("%s: not in the manifest" % g)
            if subprocess.run(["grep", "-qE", deny], input=s, text=True).returncode == 0:
                probs.append("%s: never synced (DENY_RE)" % g)
    return probs


class SettledTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("ac44")
        self.env = self.h.denv()

    def tearDown(self):
        self.h.cleanup()

    def test_ac44_already_saved_findings_are_verified_counted_and_not_added_again(self):
        gt = GuardTests("test_ac9_addition_from_typed_finding_carries_its_date")
        gt.h, gt.env, gt.n = self.h, self.env, 100
        text = "# Build notes\n\n- Run the tests first.\n"
        f1, f2, f3 = fnd("f1"), fnd("f2"), fnd("f3")
        saved = {"already_saved": [{"finding_id": "f1", "file": MEM, "existing_text": "- Run the tests first."}],
                 "declined": [{"finding_id": "f2", "reason": "it contradicts a dated rule it does not name"}],
                 "changes": [change(MEM, ids=["f3"], adds=["- Lint (2026-11-09)."])]}
        G = gt.G({MEM: (text, text + "- Lint (2026-11-09).\n")}, [f1, f2, f3], saved)
        self.assertEqual(guards.g_settled(G), [])
        bad_text = json.loads(json.dumps(saved))
        bad_text["already_saved"][0]["existing_text"] = "- Run every test twice."
        self.assertTrue(guards.g_settled(gt.G({MEM: (text, text + "- Lint (2026-11-09).\n")}, [f1, f2, f3], bad_text)),
                        "the 'already saved' text is not in the file")
        forgot = json.loads(json.dumps(saved))
        forgot["declined"] = []
        self.assertTrue(guards.g_settled(gt.G({MEM: (text, text + "- Lint (2026-11-09).\n")}, [f1, f2, f3], forgot)),
                        "a finding neither applied, already saved nor declined")
        no_reason = json.loads(json.dumps(saved))
        no_reason["declined"][0]["reason"] = ""
        self.assertTrue(guards.g_settled(gt.G({MEM: (text, text + "- Lint (2026-11-09).\n")}, [f1, f2, f3], no_reason)))
        # end to end: an already-saved finding settles with no edit, is counted in the log and not applied again
        self.h.cleanup()
        self.h = h = FakeHome("ac44e", repo=True)
        h.session(fh.PROJ, "s44", [typed("u1", "no, always run the tests first, I said that before")])
        fdef = dict(uuid="u1", quote="always run the tests first", kind="correction", statement="Run the tests first.",
                    general=False, replaces="", matches_pending="", loosens_safety=False, weakens_check=False,
                    personal=False, ambiguous=False, depends_on_image=False)
        h.scenario({"session-helper": {"s44": {"findings": [fdef]}},
                    "editor": {"edits": [], "changes": {"changes": [], "declined": [], "already_saved": [
                        {"finding_id": "FIRST", "file": MEM, "existing_text": "- Run the tests first."}]}}})
        before = h.read(".claude/projects/%s/memory/build-notes.md" % fh.PROJ)
        self.assertEqual(h.run(), 0)
        self.assertEqual(h.read(".claude/projects/%s/memory/build-notes.md" % fh.PROJ), before)
        log = h.read(".claude/dream/dream-log.md")
        self.assertRegex(log, r"[Aa]lready saved: 1\b")
        applied = json.loads(h.read(".claude/dream/state/applied.json"))["ids"]
        self.assertEqual(len(applied), 1)
        # the same message seen again is dropped as already applied: no editor call
        for c in h.calls.glob("call-*"):
            c.unlink()
        cur = h.p(".claude/dream/local/cursors.json")
        cur.unlink()
        self.assertEqual(h.run(), 0)
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["session-helper"])


if __name__ == "__main__":
    unittest.main()
