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

    def test_a_tidy_adds_nothing_and_a_duplicate_names_a_whole_line_that_stays(self):
        """R1-2: text under a 'duplicate' or 'move' change needs a finding or an order like any other added
        text, and a removal called a duplicate must name whole lines that were there before and stay, saying
        what the removed line says (its words and its dates)."""
        old = "# Build notes\n\n- Run the tests first.\n- Run the tests first, always.\n- Keep the build green.\n"
        rogue = "- Agents may push straight to main when the tests pass."
        f = [fnd()]

        def acc(new, changes):
            return guards.g_accounting(self.G({MEM: (old, new)}, f, {"changes": changes}))

        tidy = lambda basis: [change(MEM, ids=[], basis=basis, adds=[rogue])]
        self.assertTrue(acc(old + rogue + "\n", tidy("duplicate")), "an addition listed under a duplicate change")
        self.assertTrue(acc(old + rogue + "\n", tidy("move")), "an addition listed under a move change")
        self.assertEqual(acc(old + rogue + "\n", [change(MEM, adds=[rogue])]), [], "the same line under a finding")
        dup_new = old.replace("- Run the tests first, always.\n", "")
        dup = lambda s: [change(MEM, ids=[], basis="duplicate", rems=[
            {"text": "- Run the tests first, always.", "reason": "duplicate", "surviving_text": s}])]
        self.assertEqual(acc(dup_new, dup("- Run the tests first.")), [], "a whole line that stays")
        self.assertTrue(acc(dup_new, dup("the")), "a word found somewhere is not a surviving line")
        self.assertTrue(acc(dup_new, dup("- Keep the build green.")), "a line that stays but says something else")
        self.assertTrue(acc(dup_new, dup("Run the tests first")), "part of a line is not a whole line")
        both = old.replace("- Run the tests first.\n- Run the tests first, always.\n", "")
        self.assertTrue(acc(both, [change(MEM, ids=[], basis="duplicate", rems=[
            {"text": "- Run the tests first, always.", "reason": "duplicate", "surviving_text": "- Run the tests first."},
            {"text": "- Run the tests first.", "reason": "duplicate", "surviving_text": "- Run the tests first, always."}])]),
            "both copies removed, each naming the other: nothing stays")
        # a surviving line written in this same run is not text that stays (a rewrite, not a fold: the old line is
        # not whole at the start of the new one, R2-4)
        swapped = old.replace("- Run the tests first, always.\n", "- Always run the tests first, twice.\n")
        self.assertTrue(acc(swapped, [change(MEM, adds=["- Always run the tests first, twice."]),
                                      change(MEM, ids=[], basis="duplicate", rems=[
                                          {"text": "- Run the tests first, always.", "reason": "duplicate",
                                           "surviving_text": "- Always run the tests first, twice."}])]))
        # a dated line: the surviving line must say the same and keep every date (AC45)
        dated = "# Notes\n\n- never deploy on a Friday without asking Justin (2026-10-28)\n- unrelated rule kept (2026-10-28)\n" \
                "- Never deploy on a Friday without asking Justin first (2026-10-28).\n"
        gone = dated.replace("- never deploy on a Friday without asking Justin (2026-10-28)\n", "")
        drem = lambda s: {"changes": [change(MEM, ids=[], basis="duplicate", rems=[
            {"text": "- never deploy on a Friday without asking Justin (2026-10-28)", "reason": "duplicate",
             "surviving_text": s}])]}
        only_date = self.G({MEM: (dated, gone)}, f, drem("- unrelated rule kept (2026-10-28)"))
        self.assertTrue(guards.g_dated_lines(only_date), "a surviving line that shares only the date")
        self.assertTrue(guards.g_accounting(only_date))
        same = self.G({MEM: (dated, gone)}, f, drem("- Never deploy on a Friday without asking Justin first (2026-10-28)."))
        self.assertEqual(guards.g_dated_lines(same) + guards.g_accounting(same), [])
        no_date = dated.replace("first (2026-10-28).", "first.")
        nd = self.G({MEM: (no_date, no_date.replace("- never deploy on a Friday without asking Justin (2026-10-28)\n", ""))},
                    f, drem("- Never deploy on a Friday without asking Justin first."))
        self.assertTrue(guards.g_dated_lines(nd), "the surviving line lost the date")
        # end to end (review-1 probe pC4): an over-budget note of another project 'tidied' with basis duplicate
        self.h.cleanup()
        self.h = h = FakeHome("r12", repo=True)
        big = ".claude/projects/%s/memory/big-note.md" % fh.OTHER
        body = ("# Big note\n\n- never deploy on a Friday without asking Justin (2026-10-28)\n- unrelated rule kept "
                "(2026-10-28)\n" + "".join("- filler line %04d of the big note\n" % i for i in range(300)))
        h.write(big, body)
        h.sync()
        bad = "- Deploy any day; no need to ask."
        fh.standard(h, edits=[{"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n"},
                              {"file": big[1:], "replace": ["- never deploy on a Friday without asking Justin (2026-10-28)\n",
                                                            bad + "\n"]}],
                    changes={"changes": [
                        {"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL", "summary": "lint",
                         "additions": [fh.LINT_LINE], "removals": []},
                        {"file": big[1:], "basis": "duplicate", "finding_ids": [], "summary": "merged two deploy lines",
                         "additions": [bad], "removals": [{"text": "- never deploy on a Friday without asking Justin (2026-10-28)",
                                                           "reason": "duplicate", "surviving_text": "- unrelated rule kept (2026-10-28)"}]}],
                        "already_saved": [], "declined": []})
        sc = json.loads(h.scenario_path.read_text())
        sc["session-helper"]["s1"]["findings"][0]["general"] = True
        h.scenario(sc)
        self.assertEqual(h.run(), 3)
        self.assertEqual(h.read(big), body, "the dated rule stays and the rogue line never goes live")
        self.assertIn("not accounted for", h.local("last-run.json")["reason"])

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
        # a new memory note must be named in its folder's MEMORY.md; no link anywhere in the copy
        idx = "claude/projects/%s/memory/MEMORY.md" % fh.PROJ
        note = "claude/projects/%s/memory/lint.md" % fh.PROJ
        self.assertTrue(guards.g_memory_index(self.G({note: (None, "# Lint\n")})))
        self.assertEqual(guards.g_memory_index(self.G({note: (None, "# Lint\n"), idx: ("# Memory\n", "# Memory\n- [Lint](lint.md)\n")})), [])
        G = self.G({MEM: ("# M\n", "# M\n- x\n")})
        os.symlink("/etc/hostname", G.copy / "claude/escape.md")
        from dreamlib import targets as t2
        G.diffs, G.links = t2.diff_copy(G.dir)
        self.assertTrue(guards.g_links(G))
        # every allowed seed is synced: it matches a manifest line and not sync.sh's never-list
        self.assertEqual(seed_problems(), [])

    def test_a_finding_of_a_worktree_session_targets_the_memory_folder_of_its_repository(self):
        """R2-5: Claude Code keeps auto memory per git repository, shared by its worktrees and subdirectories
        (code.claude.com/docs/en/memory: "The <project> path is derived from the git repository, so all worktrees
        and subdirectories within the same repo share one auto memory directory. Outside a git repo, the project
        root is used instead"). A finding's memory folder is that repository's, never a folder no session loads."""
        from dreamlib import state
        h = self.h
        h.cleanup()
        self.h = h = FakeHome("r25", repo=True)
        repo, wt = h.p("work/repo"), h.p("work/repo/.claude/worktrees/story-x")
        h.sh("git", "init", "-q", "-b", "main", str(repo))
        h.sh("git", "-C", str(repo), "commit", "-q", "--allow-empty", "-m", "init")
        h.sh("git", "-C", str(repo), "worktree", "add", "-q", "-b", "story-x", str(wt))
        key = lambda p: re.sub(r"[^A-Za-z0-9]", "-", str(p))
        rkey, wkey = key(repo), key(wt)
        rmem = ".claude/projects/%s/memory" % rkey
        h.write(rmem + "/MEMORY.md", "# Memory\n\n- [Build notes](build-notes.md)\n")
        h.write(rmem + "/build-notes.md", "# Build notes\n\n- Run the tests first.\n")
        h.sync()
        h.session(wkey, "s25", [fh.assistant("I committed without linting.", cwd=str(wt)),
                                typed("u1", "No, " + fh.LINT_Q + ", please.", cwd=str(wt))])
        wmem = "claude/projects/%s/memory" % wkey
        note = "- Run the linter before every commit (2026-11-09)."
        sc = {"session-helper": {"s25": {"findings": [fh.finding("u1", fh.LINT_Q)]}},
              "editor": {"edits": [{"file": wmem + "/lint.md", "write": "# Lint\n\n" + note + "\n"},
                                   {"file": wmem + "/MEMORY.md", "write": "# Memory\n\n- [Lint](lint.md): lint before commits (2026-11-09)\n"}],
                         "changes": {"changes": [
                             {"file": wmem + "/lint.md", "basis": "finding", "finding_ids": "ALL", "summary": "lint",
                              "additions": ["# Lint", note], "removals": []},
                             {"file": wmem + "/MEMORY.md", "basis": "finding", "finding_ids": "ALL", "summary": "index",
                              "additions": ["# Memory", "- [Lint](lint.md): lint before commits (2026-11-09)"], "removals": []}],
                             "already_saved": [], "declined": []}},
              "checker": {"verdict": "yes", "lost_facts": [], "untraced": [], "notes": ""}}
        h.scenario(sc)
        # review-2 probe p06 (qH): a note in the worktree key's own memory folder, which no session loads
        self.assertEqual(h.run(), 3)
        self.assertFalse(h.p(".claude/projects/%s/memory" % wkey).exists(), "nothing written where no session looks")
        self.assertIn("no finding or order allows this file", h.local("last-run.json")["reason"])
        self.assertEqual([f.get("memory") for f in h.local("unsettled.json")["findings"]], [rkey],
                         "the bar records the repository's key with the finding")
        # the repository's memory folder is the finding's narrowest place: the lesson goes live there
        sc["editor"] = {"edits": [{"file": rmem[1:] + "/build-notes.md", "append": note + "\n"}], "changes": {"changes": [
            {"file": rmem[1:] + "/build-notes.md", "basis": "finding", "finding_ids": "ALL", "summary": "lint",
             "additions": [note], "removals": []}], "already_saved": [], "declined": []}}
        h.scenario(sc)
        h.env["DREAM_NOW"] = "2026-11-10T05:01:00-05:00"   # a run of its own (its own folder under ~/.cache/dream)
        self.assertEqual(h.run(), 0, h.local("last-run.json"))
        self.assertIn(note, h.read(rmem + "/build-notes.md"))
        # the rule, case by case
        env = h.denv()
        sib = h.p("work/story-y")                              # a worktree beside the repository, not inside it
        h.sh("git", "-C", str(repo), "worktree", "add", "-q", "-b", "story-y", str(sib))
        plain = h.p("work/plain")
        plain.mkdir(parents=True)
        (repo / "src").mkdir()
        cases = {
            "a worktree under .claude/worktrees": (wkey, str(wt), rkey),
            "a worktree beside the repository": (key(sib), str(sib), rkey),
            "a subdirectory of the repository": (key(repo / "src"), str(repo / "src"), rkey),
            "a folder outside any git repository: its own key": (key(plain), str(plain), key(plain)),
            "a worktree under .claude/worktrees that is gone": (key(repo) + "--claude-worktrees-gone",
                                                               str(repo) + "/.claude/worktrees/gone", rkey),
            "a folder that is gone, its own key with no memory folder": ("-gone-folder", "/gone/folder", None),
            "a folder that is gone, its own key with a memory folder": (fh.PROJ, "/gone/proj", fh.PROJ),
            "no working folder known (a finding from before this fix)": (fh.PROJ, None, fh.PROJ),
        }
        got = {k: targets.memory_key(env, folder, cwd) for k, (folder, cwd, _) in cases.items()}
        self.assertEqual(got, {k: want for k, (_, _, want) in cases.items()})
        # the bar records it from the session read; the editor's targets name that folder only
        r = state.scan(env, {}, env.now()).reads
        self.assertEqual([x.cwd for x in r if x.folder == wkey], [str(wt)])
        f = fnd(folder=wkey, project=wkey, memory=rkey)
        self.assertEqual(targets.scope_for(env, f)[0], targets.memory_dir(env, rkey) + "/")
        self.assertNotIn(env.real_rel(".claude/projects/%s/memory" % wkey) + "/", targets.scope_for(env, f))
        self.assertEqual(targets.scope_for(env, fnd(folder="-gone-folder", memory=None)), [], "no memory folder at all")

    def test_a_lesson_folded_into_a_line_keeps_that_line_whole_and_needs_no_replaces(self):
        """R2-4: DREAM.md section 6 and the editor's step 2 say to fold a lesson into an existing line first. A fold
        keeps the old line whole, word for word, at the start of the new one (only its final full stop may go) and
        adds the finding's words after it: nothing of the old line is lost, so it is no removal to list and, for a
        dated line, no dated rule replaced (AC45 stays: changing the dated line's own words still needs a finding
        that names what it replaces)."""
        und = "- Run the tests first."
        dat = "- Run the tests first (2026-10-02)."
        more = ", and the linter before every commit (2026-11-09)."
        f1 = fnd("f1")
        f2 = fnd("f2", folder=fh.OTHER, project="other")

        lint = "- Lint (2026-11-09)."

        def fails(old_line, new_line, adds, rems=(), ids=("f1",)):
            # when another finding makes the change, f1 also adds a line, so the file is one the run may change
            # and only the fold itself is judged
            old = "# Build notes\n\n" + old_line + "\n- Keep the build green.\n"
            new = "# Build notes\n\n" + new_line + "\n- Keep the build green.\n" + ("" if "f1" in ids else lint + "\n")
            chs = [change(MEM, ids=ids, adds=adds, rems=rems)] + ([] if "f1" in ids else [change(MEM, adds=[lint])])
            return guards.run_all(self.G({MEM: (old, new)}, [f1, f2], {"changes": chs, "declined": [
                {"finding_id": "f2", "reason": "x"}] if "f2" not in ids else []}))

        ok = {
            "an undated line, the added words listed (probe qF1)": (und, und[:-1] + more, [more[:-1]]),
            "a dated line, the added words listed": (dat, dat[:-1] + more, [more[:-1]]),
            "a dated line, the whole new line listed with the old one as a removal (probe qF3)":
                (dat, dat[:-1] + more, [dat[:-1] + more], [{"text": dat, "reason": "outdated"}]),
            "a dated line kept with its full stop, a sentence after it": (dat, dat + " Also the linter (2026-11-09).",
                                                                         ["Also the linter (2026-11-09)."]),
        }
        wrong = ["%s: %s" % (k, v) for k, v in ((k, fails(*a)) for k, a in sorted(ok.items())) if v]
        self.assertEqual(wrong, [])
        refused = {
            "the dated line's own words changed": (dat, "- Run the unit tests first (2026-10-02)" + more, [more[:-1]]),
            "the dated line's date dropped": (dat, "- Run the tests first" + more, [more[:-1]]),
            "words put in front of the dated line": ("Run the tests first (2026-10-02).",
                                                     "Do not Run the tests first (2026-10-02).", ["Do not"]),
            "the added words not listed": (dat, dat[:-1] + more, []),
            "a finding of another project": (dat, dat[:-1] + more, [more[:-1]], (), ("f2",)),
            "the added words carry no date of the finding": (dat, dat[:-1] + ", and the linter.", [", and the linter"]),
            "the old line's last word changed (no word boundary)": ("- Run the test.", "- Run the tests twice (2026-11-09).",
                                                                    ["- Run the tests twice (2026-11-09)."]),
        }
        missed = [k for k, a in sorted(refused.items()) if not fails(*a)]
        self.assertEqual(missed, [], "each of these must stop the run")
        # end to end (review-2 probe p03, qF): Justin's correction folded into the note's dated line goes live
        self.h.cleanup()
        self.h = h = FakeHome("r24", repo=True)
        h.write(fh.MEM_LIVE, "# Build notes\n\n" + dat + "\n")
        h.sync()
        new_line = dat[:-1] + more
        fh.standard(h, edits=[{"file": fh.MEM_COPY, "replace": [dat, new_line]}], changes={"changes": [
            {"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL", "order_id": "", "summary": "folded",
             "additions": [more[:-1]], "removals": []}], "already_saved": [], "declined": []})
        self.assertEqual(h.run(), 0, h.local("last-run.json"))
        self.assertIn(new_line, h.read(fh.MEM_LIVE))

    def test_a_change_counts_only_in_a_file_its_basis_belongs_to(self):
        """R2-1 (R1-2 again): for every changes.json basis, a change that adds a line and removes a dated one in a
        file that basis does not belong to stops the run, even while a finding of that file also changes it. An
        order belongs only to the repeat-mistakes file it names (checked entry by entry there), a finding only to
        the files of its narrowest place, a tidy adds nothing, and an unknown basis counts nowhere."""
        from dreamlib import mistakes, state
        friday = "- never deploy on a Friday without asking Justin (2026-10-28)"
        rogue = "- the entry now covers this (2026-11-09)"
        lint = "- Lint before every commit (2026-11-09)."
        old = "# Build notes\n\n- Run the tests first.\n" + friday + "\n"
        new_ok = old + lint + "\n"
        new_bad = old.replace(friday + "\n", rogue + "\n") + lint + "\n"
        tally = dict(state.default_tally(), backfill_done=True)
        tally["kinds"]["k-one"] = {"title": "a guard is skipped", "description": "d", "area": "Guards", "listed_in": None,
                                   "listed_since": None, "repeats_while_listed": [], "retired": False,
                                   "projects": {"proj": {"stories": ["story-a", "story-b"], "findings": 2,
                                                         "last_story": "story-b"}}}
        tally["stories"] = {"proj": ["story-a", "story-b"]}
        tally["story_seq"] = ["proj/story-a", "proj/story-b"]
        orders = mistakes.orders(self.env, tally)
        self.assertEqual([o["id"] for o in orders], ["add:k-one"])
        rm = fh.PROJ_RM[1:]
        rm_old = self.h.read(fh.PROJ_RM)
        rm_new = mistakes.normalize_text(rm_old + "\n## Guards\n" + mistakes.heading_for("k-one", "a guard is skipped", tally)
                                         + "- **Build it this way:** check every path (2026-11-10).\n"
                                         "- **Check for it:** a test per path.\n", tally)
        f1 = fnd("f1")
        f2 = fnd("f2", folder=fh.OTHER, project="other", replaces="never deploy on a Friday without asking Justin")
        base = [change(MEM, ids=["f1"], adds=[lint]), change(rm, ids=[], basis="order", order_id="add:k-one")]
        rem = lambda reason, **kw: dict({"text": friday, "reason": reason}, **kw)
        cases = {
            "a finding of another project": change(MEM, ids=["f2"], adds=[rogue], rems=[rem("outdated")]),
            "one finding of this file and one of another project": change(MEM, ids=["f1", "f2"], adds=[rogue],
                                                                          rems=[rem("outdated")]),
            "an order (it names the repeat-mistakes file)": change(MEM, ids=[], basis="order", order_id="add:k-one",
                                                                   adds=[rogue], rems=[rem("retired")]),
            "a duplicate": change(MEM, ids=[], basis="duplicate", adds=[rogue],
                                  rems=[rem("duplicate", surviving_text="- Run the tests first.")]),
            "a move": change(MEM, ids=[], basis="move", adds=[rogue], rems=[rem("moved", moved_to=rm)]),
            "an unknown basis": change(MEM, ids=["f1"], basis="tidy", adds=[rogue], rems=[rem("outdated")]),
        }

        def run_all(new, extra):
            return guards.run_all(self.G({MEM: (old, new), rm: (rm_old, rm_new)}, [f1, f2],
                                         {"changes": base + extra, "declined": [{"finding_id": "f2", "reason": "other"}]},
                                         orders=orders, tally=tally))

        self.assertEqual(run_all(new_ok, []), [], "the control: the finding's line and the ordered entry go live")
        wrong = []
        for name, c in sorted(cases.items()):
            fails = run_all(new_bad, [c])
            if not any(friday[:60] in x for x in fails):
                wrong.append("%s: the dated line's removal passed: %s" % (name, fails))
            if not any(rogue[:40] in x for x in fails):
                wrong.append("%s: the added line passed: %s" % (name, fails))
        self.assertEqual(wrong, [])
        # a move names a target as its destination, never the editor's own _dream/changes.json (which always holds
        # the removed text): an undated line 'moved' there is a removal with no evidence (R2-14's moved_to half)
        green = "- Keep the build green."
        o2 = old + green + "\n"
        n2 = o2.replace(green + "\n", "") + lint + "\n"
        G = self.G({MEM: (o2, n2), rm: (rm_old, rm_old)}, [f1], {"changes": [base[0], change(MEM, ids=[], basis="move", rems=[
            {"text": green, "reason": "moved", "moved_to": "_dream/changes.json"}])]})
        (G.copy / "_dream").mkdir(parents=True, exist_ok=True)
        (G.copy / "_dream/changes.json").write_text(json.dumps(G.changes))
        self.assertTrue(any(green in x for x in guards.g_accounting(G)), "moved into the editor's changes.json")
        mem2 = "claude/projects/%s/memory/other.md" % fh.PROJ
        G = self.G({MEM: (o2, n2), mem2: ("# Other\n" + green + "\n",) * 2}, [f1], {"changes": [base[0], change(
            MEM, ids=[], basis="move", rems=[{"text": green, "reason": "moved", "moved_to": mem2}])]})
        self.assertEqual(guards.g_accounting(G), [], "moved to a target of the copy that holds it")
        # end to end (review-2 probe p02, qA): a run that holds an order and a correction; under basis order the
        # editor also drops the note's dated rule for undated wording; nothing goes live
        self.h.cleanup()
        self.h = h = FakeHome("r21", repo=True)
        kind = {"id": "link-path-guard", "title": "a guard checks the link path", "description": "d", "area": "Guards"}
        entry = ("\n## Guards\n### link-path-guard — a guard checks the link path (1×: x)\n"
                 "- **Build it this way:** resolve links (2026-11-10).\n- **Check for it:** a link test.\n")
        bad = "- Deploy any day; agents need not ask."
        h.write(fh.MEM_LIVE, "# Build notes\n\n- Run the tests first.\n" + friday + "\n")
        h.write(".claude/dream/state/tally.json", paths.dump_json(dict(state.default_tally(), backfill_done=True)))
        h.sync()
        from test_mistakes import review
        review(h, "proj", "story-a", ["guard took the link path"])
        h.scenario({"review-helper": {"assign": "new", "new_kind": kind, "enforce_proposal": ""}})
        self.assertEqual(h.run(), 0)
        review(h, "proj", "story-b", ["again the link path"])
        sc = fh.standard(h, edits=[{"file": rm, "write": h.read(fh.PROJ_RM) + entry},
                                   {"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n"},
                                   {"file": fh.MEM_COPY, "replace": [friday + "\n", bad + "\n"]}],
                         changes={"changes": [
                             {"file": rm, "basis": "order", "finding_ids": [], "order_id": "add:link-path-guard",
                              "summary": "the ordered entry", "additions": [], "removals": []},
                             {"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL", "order_id": "",
                              "summary": "lint", "additions": [fh.LINT_LINE], "removals": []},
                             {"file": fh.MEM_COPY, "basis": "order", "finding_ids": [], "order_id": "add:link-path-guard",
                              "summary": "the entry now covers this", "additions": [bad],
                              "removals": [{"text": friday, "reason": "retired"}]}],
                             "already_saved": [], "declined": []})
        sc["review-helper"] = {"assign": "link-path-guard"}
        h.scenario(sc)
        self.assertEqual(h.run(), 3)
        self.assertIn(friday, h.read(fh.MEM_LIVE), "the dated rule stays")
        self.assertNotIn(bad, h.read(fh.MEM_LIVE))
        self.assertIn("not accounted for", h.local("last-run.json")["reason"])


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


class WiringTests(unittest.TestCase):
    """R1-14: the ACs say the run does not go live; these tests fail when one guard is left out of
    guards.run_all, or when one cap or limit is not applied, each through a fixture only it refuses."""

    def setUp(self):
        self.h = FakeHome("wiring", library=True)
        self.env = self.h.denv()
        self.gt = GuardTests("test_ac9_addition_from_typed_finding_carries_its_date")
        self.gt.h, self.gt.env, self.gt.n = self.h, self.env, 300

    def tearDown(self):
        self.h.cleanup()

    def G(self, *a, **kw):
        return self.gt.G(*a, **kw)

    def test_run_all_runs_every_guard(self):
        h = self.h
        old = "# Build notes\n\n- Run the tests first.\n"
        line = "- Lint before every commit (2026-11-09)."
        ok_change = {"changes": [change(MEM, adds=[line])]}
        c = "claude/CLAUDE.md"
        big = "# Notes\n" + "".join("- line %04d of the note\n" % i for i in range(400))
        lib = h.p(".hermes/skills-library")
        long = "".join("- rule %02d\n" % i for i in range(30))
        (lib / "skills/lib-skill/SKILL.md").write_text(long)
        h.sh("git", "-C", str(lib), "commit", "-qam", "longer skill")
        lib_rel = "hermes/skills-library/skills/lib-skill/SKILL.md"
        linked = self.G({MEM: (old, old + line + "\n")}, [fnd()], ok_change)
        os.symlink("/etc/hostname", linked.copy / "claude/escape.md")
        linked.diffs, linked.links = targets.diff_copy(linked.dir)
        order = {"id": "add:k-one", "action": "add", "kind": "k-one", "file": fh.PROJ_RM, "title": "t", "area": "Guards",
                 "count": 2, "stories": ["a", "b"]}
        rm_text = self.h.read(fh.PROJ_RM)
        cases = {
            "g_links": (linked, "the copy holds a link"),
            "g_allowlist": (self.G({"codex/AGENTS.md": (None, "# x\n")}, [fnd()], {"changes": [change("codex/AGENTS.md", adds=["# x"])]}),
                            "not an allowed target"),
            "g_protected": (self.G({c: (fh.CLAUDE_MD, fh.CLAUDE_MD.replace("never push to Leorna", "never push to Leorna!"))}),
                            "changed the frozen section"),
            "g_budgets": (self.G({MEM: (big, big + "- one more line\n")}), "over its budget"),
            "g_caps": (self.G({MEM: (old, old + "".join("- added line %05d %s\n" % (i, "x" * 40) for i in range(51)))}),
                       "bytes added (cap"),
            "g_canary": (self.G({c: (fh.CLAUDE_MD, fh.CLAUDE_MD.replace("- never push to Leorna without asking (2026-10-01)\n", ""))}),
                         "lost the exact fact"),
            "g_accounting": (self.G({MEM: (old, "# Build notes\n")}), "a removed line is not accounted for"),
            "g_settled": (self.G({MEM: (old, old)}, [fnd()]), "neither applied, already saved nor declined"),
            "g_dated_lines": (self.G({MEM: (old + "- Old way (2026-10-01).\n", old)}, [fnd()], {"changes": [change(
                MEM, rems=[{"text": "- Old way (2026-10-01).", "reason": "outdated"}])]}), "a dated line was removed"),
            "g_dates_on_additions": (self.G({MEM: (old, old + "- Lint before every commit.\n")}, [fnd()],
                                            {"changes": [change(MEM, adds=["- Lint before every commit."])]}),
                                     "does not carry its date"),
            "g_secrets": (self.G({MEM: (old, old + "- the key is %s (2026-11-09)\n" % fh.fake_stripe_key())}, [fnd()],
                                 {"changes": [change(MEM, adds=["- the key is %s (2026-11-09)" % fh.fake_stripe_key()])]}),
                          "gitleaks or the token check"),
            "g_repeat_mistakes": (self.G({fh.PROJ_RM[1:]: (rm_text, rm_text)}, orders=[order]), "missing k-one"),
            "g_memory_index": (self.G({"claude/projects/%s/memory/lint.md" % fh.PROJ: (None, "# Lint\n")}),
                               "must be named in its folder's MEMORY.md"),
            "g_library": (self.G({lib_rel: (long, long.replace("- rule 01\n", "- rule one\n").replace("- rule 28\n", "- rule 28b\n"))}),
                          "diff blocks against the library"),
        }
        self.assertEqual(sorted(cases), sorted(g.__name__ for g in guards.ALL), "a case for every guard in run_all")
        missing = []
        for name, (G, text) in sorted(cases.items()):
            if not any(text in f for f in getattr(guards, name)(G)):
                missing.append("%s: the fixture does not trip it" % name)
            elif not any(text in f for f in guards.run_all(G)):
                missing.append("%s: run_all did not run it" % name)
        self.assertEqual(missing, [])

    def test_each_cap_and_limit_stops_the_run_on_its_own(self):
        add = lambda n, tag="a": "".join("- %s line %05d %s\n" % (tag, i, "x" * 40) for i in range(n))  # 56 bytes a line
        problems = []

        def expect(label, fails, text):
            if not any(text in f for f in fails):
                problems.append("%s: no \"%s\" in %s" % (label, text, fails))

        # the whole-run removed cap: five notes, each under its own cap of 3,000, 14,000 bytes in all
        notes = {"claude/projects/%s/memory/n%d.md" % (fh.PROJ, i): ("# N\n" + add(60), "# N\n" + add(60)[56 * 50:])
                 for i in range(5)}
        expect("run removed", guards.g_caps(self.G(notes)), "bytes removed in this run (cap 12000)")
        self.assertEqual(guards.g_caps(self.G(dict(list(notes.items())[:1]))), [], "one of them is under every cap")
        # the moved cap: 31,376 bytes moved word for word to references/
        section = "## Long section\n" + add(560)
        sk = targets.copy_rel(fh.PROJ_SKILL + "/SKILL.md")
        ref = targets.copy_rel(fh.PROJ_SKILL + "/references/long.md")
        expect("moved", guards.g_caps(self.G({sk: ("# Skill\n\n" + section + "\n## Tail\n", "# Skill\n\n## Tail\n"),
                                               ref: (None, section)})), "bytes moved in this run (cap 30000)")
        # the repeat-mistakes cap, once the file has an entry: 4,000 bytes a run
        rm = fh.PROJ_RM[1:]
        rm_old = self.h.read(fh.PROJ_RM) + "\n## Guards\n### k-one — t (2×: a, b)\n- **Build it this way:** x.\n- **Check for it:** y.\n"
        expect("repeat-mistakes", guards.g_caps(self.G({rm: (rm_old, rm_old + add(80))})), "bytes changed (cap 4000")
        # at most 2 files over budget tidied with no finding
        over = "# Big\n- the same rule twice\n- the same rule twice\n" + add(150)  # over the 8,000 of a note
        tidy = {"claude/projects/%s/memory/big%d.md" % (fh.OTHER, i): (over, over.replace("- the same rule twice\n", "", 1))
                for i in range(3)}
        tch = {"changes": [change(f, ids=[], basis="duplicate", rems=[{"text": "- the same rule twice", "reason": "duplicate",
                                                                      "surviving_text": "- the same rule twice"}]) for f in tidy]}
        expect("tidy limit", guards.g_allowlist(self.G(tidy, [], tch)), "tidied 3 files over budget")
        self.assertEqual(guards.g_allowlist(self.G(dict(list(tidy.items())[:2]), [], tch)), [], "two are fine")
        # changes.json naming a finding that is not in this run
        old = "# Build notes\n\n- Run the tests first.\n"
        line = "- Lint (2026-11-09)."
        expect("stranger", guards.g_settled(self.G({MEM: (old, old + line + "\n")}, [fnd()],
                                                   {"changes": [change(MEM, ids=["f1", "nope"], adds=[line])]})),
               "names a finding that is not in this run")
        # text moved between two files no finding allows (a swap): each is a move destination of the other
        a = "claude/projects/%s/memory/a.md" % fh.OTHER
        b = "claude/projects/%s/memory/b.md" % fh.OTHER
        swap = self.G({a: ("# A\n- rule of a\n", "# A\n- rule of b\n"), b: ("# B\n- rule of b\n", "# B\n- rule of a\n")}, [fnd()])
        expect("move source", guards.g_allowlist(swap), "text moved here from a file no finding allows")
        self.assertEqual(problems, [])

    def test_a_dated_line_is_replaced_only_by_a_finding_from_typed_text(self):
        """AC45 and R1-19: typed text includes slash-command text; a finding with no typed label cannot replace
        a dated line (the label check, pinned)."""
        old = "- Use the old header (2026-10-01).\n- Keep plans short.\n"
        new = "- Use the new header (2026-11-09).\n- Keep plans short.\n"
        ch = {"changes": [change("claude/CLAUDE.md", adds=["- Use the new header (2026-11-09)."],
                                 rems=[{"text": "- Use the old header (2026-10-01).", "reason": "outdated"}])]}
        g = lambda label: guards.g_dated_lines(self.G({"claude/CLAUDE.md": (old, new)},
                                                      [fnd(label=label, replaces="Use the old header")], ch))
        for label in ("TYPED", "QUEUED", "mid-turn", "ANSWER", "PASTE (whole message)", "SLASH /loop"):
            self.assertEqual(g(label), [], label)
        for label in ("", "CONTEXT", "REVIEW"):
            self.assertTrue(g(label), "no typed label: %r" % label)


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

    def test_a_finding_listed_as_applied_needs_a_diff_holding_its_additions(self):
        """R1-4: changes.json alone never settles a finding as applied: the file it names must have changed,
        and every addition it lists must be in that file's added lines."""
        gt = GuardTests("test_ac9_addition_from_typed_finding_carries_its_date")
        gt.h, gt.env, gt.n = self.h, self.env, 200
        text = "# Build notes\n\n- Run the tests first.\n"
        line = "- Lint before every commit (2026-11-09)."
        other = "claude/projects/%s/memory/MEMORY.md" % fh.PROJ
        ok = gt.G({MEM: (text, text + line + "\n")}, [fnd()], {"changes": [change(MEM, adds=[line])]})
        self.assertEqual(guards.g_settled(ok), [])
        no_diff = gt.G({MEM: (text, text)}, [fnd()], {"changes": [change(MEM, adds=[line])]})
        self.assertTrue(guards.g_settled(no_diff), "the named file did not change")
        elsewhere = gt.G({MEM: (text, text + line + "\n"), other: ("# Memory\n", "# Memory\n")}, [fnd()],
                         {"changes": [change(other, adds=[line])]})
        self.assertTrue(guards.g_settled(elsewhere), "the change names a file that did not change")
        missing = gt.G({MEM: (text, text + "- Something else (2026-11-09).\n")}, [fnd()],
                       {"changes": [change(MEM, adds=[line, "- Something else (2026-11-09)."])]})
        self.assertTrue(guards.g_settled(missing), "a listed addition that is not in the diff")
        # end to end (review-1 probe pD): the editor changed nothing but wrote changes.json as planned
        self.h.cleanup()
        self.h = h = FakeHome("r14", repo=True)
        fh.standard(h, edits=[])
        before = h.read(fh.MEM_LIVE)
        self.assertEqual(h.run(), 3)
        self.assertEqual(h.read(fh.MEM_LIVE), before)
        self.assertEqual(json.loads(h.read(".claude/dream/state/applied.json"))["ids"], [], "not marked applied")
        self.assertEqual([f["tries"] for f in h.local("unsettled.json")["findings"]], [1], "it waits for the next run")


if __name__ == "__main__":
    unittest.main()
