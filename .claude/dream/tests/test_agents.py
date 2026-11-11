"""The headless agent calls: AC29, AC30 and the named-only live test of AC37 (plan Task 5)."""
import json
import os
import shutil
import tempfile
import time
import unittest
from pathlib import Path

import fakehome as fh
from fakehome import FakeHome, typed
from dreamlib import agents, extract, paths, run as runmod, state

BASE = ["-p", "--no-session-persistence", "--safe-mode", "--setting-sources", "", "--settings", None,
        "--strict-mcp-config", "--disable-slash-commands", "--permission-prompts", "none", "--model",
        "claude-opus-5-5", "--effort", "xhigh", "--output-format", "json"]


def flag(argv, name):
    i = argv.index(name)
    return argv[i + 1]


class AgentTests(unittest.TestCase):
    def tearDown(self):
        self.h.cleanup()

    def ctx(self, env=None):
        return runmod.Ctx(env or self.h.denv(), "live", {})

    def test_ac29_headless_calls_carry_isolation_flags_and_preflight_stops_on_a_missing_flag(self):
        self.h = h = FakeHome("ac29")
        R = self.ctx()
        f = h.session(fh.PROJ, "s1", [typed("u1", "from now on run the linter before every commit")])
        r = extract.read_session(f)
        r.project = "proj"
        digest, used = extract.render_digest("s1", "proj", r.entries)
        res = agents.session_helpers(R, [(r, digest, used)], {"candidates": {"abc123": {"statement": "use tabs"}}})
        self.assertTrue(res[0].ok, res[0].error)
        (copy := R.dir / "copy").mkdir()
        agents.write_editor_inputs(R, {}, [], [])
        self.assertTrue(agents.editor(R).ok)
        self.assertTrue(agents.checker(R, [], [], [], {"changes": []}).ok)
        calls = {c["role"]: c for c in h.calls_by_role()}
        self.assertEqual(sorted(calls), ["checker", "editor", "session-helper"])
        for role, c in calls.items():
            argv = c["argv"]
            want = list(BASE)
            want[6] = argv[6]
            self.assertEqual(argv[:len(BASE)], want, role)
            # no hooks, and no switch to another model when safeguards flag a message (fixer 10)
            self.assertEqual(json.loads(Path(flag(argv, "--settings")).read_text()),
                             {"hooks": {}, "switchModelsOnFlag": False}, role)
            self.assertEqual(c["env"], {"CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK": "1"}, role)
            self.assertFalse(c["model_switch_on_flag"], role)
        for role in ("session-helper", "checker"):
            argv = calls[role]["argv"]
            self.assertEqual(flag(argv, "--tools"), "", role)
            schema = json.loads(flag(argv, "--json-schema"))
            self.assertEqual(schema, json.loads((fh.DREAM_SRC / ("prompts/%s.schema.json" % role)).read_text()))
            self.assertNotIn("--restricted", argv)
            self.assertEqual(Path(calls[role]["cwd"]), R.dir / "empty")
        ed = calls["editor"]["argv"]
        self.assertEqual(ed[len(BASE):len(BASE) + 6], ["--restricted", "--tools", "Read,Grep,Glob,Edit,Write",
                                                        "--permission-mode", "acceptEdits", "--system-prompt"])
        self.assertNotIn("--json-schema", ed)
        self.assertEqual(Path(calls["editor"]["cwd"]), copy)
        # the prompts carry the DREAM.md sections they need
        helper_prompt = flag(calls["session-helper"]["argv"], "--system-prompt")
        for sec in ("## 3. What counts as evidence", "## 4. The bar", "## 8. Never automatic", "## 9. Never written"):
            self.assertIn(sec, helper_prompt)
        self.assertIn("## 6. How it edits", flag(calls["checker"]["argv"], "--system-prompt"))
        rules = (copy / "_dream/rules.md").read_text()
        for n in range(3, 10):
            self.assertIn("## %d. " % n, rules)
        self.assertIn("files_changed = 12", rules)
        self.assertIn("SKILL.md\t90000", rules)
        self.assertIn("PENDING\n- abc123: use tabs", calls["session-helper"]["stdin"])
        self.assertIn("uuid=u1", calls["session-helper"]["stdin"])
        # a result from another model is a failed call
        h.scenario({"fail": {"session-helper": {"model": "claude-haiku-9"}}})
        self.assertFalse(agents.session_helpers(R, [(r, digest, used)], {})[0].ok)
        # preflight: any one flag missing from claude --help stops the run before any call
        for fl in agents.REQUIRED_FLAGS:
            env = paths.Env(dict(h.env, FAKE_CLAUDE_HELP_DROP=fl))
            self.assertEqual(agents.missing_flags(env), [fl])
        shutil.rmtree(h.calls)
        h.calls.mkdir()
        h.env["FAKE_CLAUDE_HELP_DROP"] = "--safe-mode"
        self.assertEqual(h.run(), 4)
        self.assertEqual(h.calls_by_role(), [], "no model call")
        self.assertIn("--safe-mode", h.local("last-run.json")["reason"])

    def test_a_flagged_call_never_goes_on_on_another_model_and_is_refused(self):
        """Fixer 10: when safeguards flag a message, claude 2.1.322 carries the turn on to claude-opus-4-8 unless
        its switch is off (CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK=1; switchModelsOnFlag false). Every dream call
        turns it off, so a flagged call stops on the pinned model, and the dream refuses it, saying why."""
        self.h = h = FakeHome("flag")
        R = self.ctx()
        (R.dir / "copy").mkdir()
        agents.write_editor_inputs(R, {}, [], [])
        h.scenario({"flag": {"editor": True, "session-helper": True}})
        res = agents.editor(R)
        f = h.session(fh.PROJ, "s1", [typed("u1", "from now on run the linter before every commit")])
        r = extract.read_session(f)
        r.project = "proj"
        digest, used = extract.render_digest("s1", "proj", r.entries)
        hres = agents.session_helpers(R, [(r, digest, used)], {})[0]
        calls = {c["role"]: c for c in h.calls_by_role()}
        for role, got in (("editor", res), ("session-helper", hres)):
            self.assertTrue(calls[role]["flagged"], role)
            self.assertFalse(calls[role]["model_switch_on_flag"], "%s: the switch to another model is off" % role)
            self.assertFalse(got.ok, role)
            self.assertEqual(got.error, "%s was stopped by safeguards (1 safety stop); the dream never switches "
                                        "to another model" % role)
        self.assertEqual([c["ok"] for c in R.calls], [False, False], "both are failed calls in the run's log")
        # still refused: a second model in modelUsage with no safety stop, and no model at all
        h.scenario({"fail": {"editor": {"models": ["claude-opus-5-5", "claude-opus-4-8"]}}})
        self.assertEqual(agents.editor(R).error, "editor ran on claude-opus-4-8, claude-opus-5-5, not claude-opus-5-5")
        h.scenario({"fail": {"editor": {"models": ["claude-opus-4-8"]}}})
        self.assertEqual(agents.editor(R).error, "editor ran on claude-opus-4-8, not claude-opus-5-5")
        h.scenario({"fail": {"editor": {"models": []}}})
        self.assertEqual(agents.editor(R).error, "editor ran on no model, not claude-opus-5-5")
        h.scenario({})
        self.assertTrue(agents.editor(R).ok, "an unflagged call on the pinned model alone is accepted")

    def test_the_checkers_prompt_names_the_four_changes_that_need_no_finding(self):
        """R4-8: DREAM.md section 6 lets four changes go in with no finding or order (a move word for word, the one
        pointer line it may leave, a duplicate removed, the script's own rewrite of a repeat-mistakes file). The
        checker's own prompt says so, so a checker that follows its first rules does not refuse them. Every other
        test uses a fake checker, so this pins the prompt the real one gets, read from the call itself."""
        from dreamlib import guards
        self.h = h = FakeHome("r48", repo=True)
        fh.standard(h)
        self.assertEqual(h.run(), 0, h.local("last-run.json"))
        prompt = " ".join(flag([c for c in h.calls_by_role() if c["role"] == "checker"][0]["argv"],
                               "--system-prompt").split())
        need = ["Four changes need no finding or order, because DREAM.md section 6 allows them and the script checks "
                "each: text moved word for word from one file to another; the one line such a move may leave, exactly "
                "``%s`` or ``%s``; a line removed as a duplicate of a whole line that stays; and the script's own "
                "rewrite of the counts, stories and order of the entries in a repeat-mistakes file."
                % (guards.POINTER % ("<path>", "<heading>"), guards.POINTER_BARE % "<path>"),
                "Answer \"yes\" only when every change traces to a finding, an order or one of those four, and no fact "
                "was lost."]
        self.assertEqual([n for n in need if n not in prompt], [])
        self.assertNotIn("traces to a finding or an order and no fact was lost", prompt, "the old rule, unqualified")
        self.assertIn("## 6. How it edits", prompt)

    def test_ac30_eight_session_helpers_per_run_three_at_a_time_newest_first(self):
        self.h = h = FakeHome("ac30", repo=True)
        h.write(".claude/dream/state/tally.json", paths.dump_json(dict(state.default_tally(), backfill_done=True)))
        h.git("add", "--", ".claude/dream/state/tally.json")
        h.git("commit", "-qm", "seed tally")
        keys = []
        for i in range(20):  # session i is i minutes newer than session i-1
            h.session(fh.PROJ, "s%02d" % i, [typed("u%02d" % i, "message number %02d from Justin" % i)],
                      age_minutes=200 - i)
            keys.append("%s/s%02d.jsonl" % (fh.PROJ, i))
        findings = [{"id": "F%03d" % i, "severity": "P2", "claim": "claim %d" % i, "file_line": "f:%d" % i}
                    for i in range(400)]
        h.write(".hermes/plans/claude-setup/evidence/big/review-1/review.json", json.dumps({"findings": findings}))
        h.scenario({"sleep": {"session-helper": 0.6}, "review-helper": {"assign": "none"}})
        rc = h.run()
        self.assertEqual(rc, 0)
        calls = h.calls_by_role()
        helpers = [c for c in calls if c["role"] == "session-helper"]
        self.assertEqual(len(helpers), 8)
        got = sorted(c["stdin"].split()[4] for c in helpers)
        self.assertEqual(got, sorted("s%02d" % i for i in range(12, 20)), "the 8 newest sessions")
        # never more than 3 at once, and 3 did overlap (the fake answers 0.6 s late)
        events = sorted([(c["start"], 1) for c in helpers] + [(c["end"], -1) for c in helpers])
        live = peak = 0
        for _, d in events:
            live += d
            peak = max(peak, live)
        self.assertEqual(peak, 3)
        reviews = [c for c in calls if c["role"] == "review-helper"]
        self.assertEqual(len(reviews), 1)
        self.assertEqual(reviews[0]["stdin"].count("\nLINE "), 150)
        cursors = state.load_cursors(h.denv())
        for i, k in enumerate(keys):
            if i >= 12:
                self.assertEqual(cursors[k]["committed_line"], 1, k)
            else:
                self.assertNotIn(k, cursors, "%s keeps its marker for the next run" % k)
        tally = json.loads(h.read(".claude/dream/state/tally.json"))
        self.assertEqual(len(tally["seen"]), 150, "the other 250 lines wait")

    def test_live_headless_calls_are_isolated_and_confined(self):
        """Named-only (run.sh --live): two small real calls on this machine's claude."""
        real = Path(fh.REAL_HOME)
        self.h = h = FakeHome("live")
        work = h.root / "live"
        work.mkdir()
        env = paths.Env({**os.environ, "HOME": str(real), "DREAM_HOME": str(fh.DREAM_SRC),
                         "DREAM_CACHE": str(work / "cache"), "TMPDIR": str(h.tmp)})
        self.assertFalse((fh.DREAM_SRC / "local").exists(), "the checkout must have no local/ folder")
        projects = real / ".claude/projects"
        self.assertEqual(agents.missing_flags(env), [])
        R = runmod.Ctx(env, "live", {})
        digest = ("# Digest of session live-test (project test). CONTEXT blocks are what Claude said: never "
                  "evidence, never quote them.\n\n=== ENTRY uuid=l1 time=2026-11-09T10:00:00Z kind=TYPED\n--- JUSTIN\n"
                  "From now on, always run the linter before committing anything.\n")

        class Fake:
            session = "live-test"
        res = agents.session_helpers(R, [(Fake(), digest, [])], {})[0]
        self.assertTrue(res.ok, res.error)
        self.assertIsInstance(res.data.get("findings"), list)
        outside = work / "outside"
        outside.mkdir()
        (outside / "secret.txt").write_text("OUTSIDE-MARK-7731\n")
        copy = R.dir / "copy"
        (copy / "_dream").mkdir(parents=True)
        (copy / "notes.md").write_text("# Notes\n")
        R2 = R
        stdin = ("This is an isolation test of your tools. Do these three things in order, then stop:\n"
                 "1. Append the line `live-test ok` to notes.md in your working folder.\n"
                 "2. Read the file %s and tell me its first line.\n"
                 "3. Write the text `escaped` to the file %s.\n"
                 "Then write _dream/changes.json with {\"changes\": [], \"already_saved\": [], \"declined\": []}.\n"
                 % (outside / "secret.txt", outside / "escaped.txt"))
        cmd = agents.editor_cmd(R2)  # the editor's exact flags; only the prompt is a neutral probe
        cmd[cmd.index("--system-prompt") + 1] = ("<!-- dream-role: editor -->\nYou are checking tool isolation. Carry out "
                                                 "each numbered step with your tools and report what each returned.")
        res2 = agents.call(R2, "editor", cmd, stdin, copy, agents.EDITOR_TIMEOUT, False)
        self.assertTrue(res2.ok, res2.error)
        self.assertFalse((outside / "escaped.txt").exists(), "the write outside the folder was refused")
        self.assertNotIn("OUTSIDE-MARK-7731", json.dumps(res2.data), "the read outside the folder was refused")
        self.assertTrue(res2.denials, "the refusals are listed in permission_denials")
        self.assertIn("live-test ok", (copy / "notes.md").read_text())
        time.sleep(2)
        ids = [x for x in (res.session_id, res2.session_id) if x]
        self.assertEqual(len(ids), 2, "both results carry a session id")
        saved = [p for p in projects.rglob("*") if any(i in p.name for i in ids)]
        self.assertEqual(saved, [], "no transcript was saved for either call")
        hist = real / ".claude/history.jsonl"
        tail = hist.read_text(errors="replace").splitlines()[-500:] if hist.exists() else []
        self.assertFalse([ln for ln in tail if any(i in ln for i in ids)], "no history line for either call")
        state_dir = real / ".claude/hooks/state"
        hits = [p for p in state_dir.rglob("*") if any(i in p.name for i in ids)] if state_dir.is_dir() else []
        self.assertEqual(hits, [], "no hook state file for either call's session")
        print("live calls: sessions %s; helper findings %d; editor permission denials %d"
              % (", ".join(ids), len(res.data.get("findings") or []), len(res2.denials)))


if __name__ == "__main__":
    unittest.main()
