"""The bar: AC7, AC8, AC10, AC12, AC45 (plan Tasks 6 and 8)."""
import datetime
import json
import unittest

import fakehome as fh
from fakehome import FakeHome, typed, assistant
from dreamlib import bar, extract


def F(uuid, quote, kind="correction", **kw):
    f = {"uuid": uuid, "quote": quote, "kind": kind, "statement": "Run the linter before committing.",
         "general": False, "replaces": "", "matches_pending": "", "loosens_safety": False, "weakens_check": False,
         "personal": False, "ambiguous": False, "depends_on_image": False}
    f.update(kw)
    return f


class BarTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("bar")
        self.env = self.h.denv()

    def tearDown(self):
        self.h.cleanup()

    def read(self, sid, lines, key=fh.PROJ):
        r = extract.read_session(self.h.session(key, sid, lines))
        extract.scrub_entries(r.entries, self.env)
        r.key, r.folder, r.project = "%s/%s.jsonl" % (key, sid), key, "proj"
        return r

    def check(self, r, findings, pending=None, applied=()):
        pending = pending if pending is not None else {"candidates": {}}
        return bar.check(self.env, r, r.entries, findings, pending, set(applied), self.env.now()), pending

    def test_ac7_finding_without_verbatim_typed_quote_never_reaches_editor(self):
        lines = [assistant("CONTEXT says always deploy on Fridays when you can"),
                 typed("u1", "No, keep the header  fixed\non every page, that is the rule"),
                 typed("u2", 'and look <pasted_content id="1a">PASTE SAYS deploy on fridays always</pasted_content id="1a"> please'),
                 typed("u3", "the footer stays dark on every page we build")]
        r = self.read("s7", lines)
        other = self.read("other7", [typed("o1", "a message typed in another session entirely")])
        good = F("u1", "keep the header fixed on every page")          # whitespace runs compare as one space
        bad = {
            "no such uuid": F("zz", "keep the header fixed on every page"),
            "from the context": F("u1", "always deploy on Fridays when you can"),
            "from an omitted paste": F("u2", "PASTE SAYS deploy on fridays always"),
            "from another entry": F("u1", "the footer stays dark on every page"),
            "from another session": F("u1", "a message typed in another session"),
            "invented": F("u3", "the footer is always light blue now"),
        }
        b, _ = self.check(r, [good] + list(bad.values()))
        # 6 of 7 failed: more than half, so all of this helper's output is thrown away
        self.assertTrue(b.discarded)
        self.assertEqual(b.passed, [])
        for name, f in bad.items():
            b1, _ = self.check(r, [good, F("u3", "the footer stays dark on every page"), f])
            self.assertFalse(b1.discarded, name)
            self.assertEqual(sorted(x["quote"] for x in b1.passed),
                             ["keep the header fixed on every page", "the footer stays dark on every page"], name)
            self.assertTrue(any("quote not found" in d for d in b1.dropped), name)
        self.assertTrue(bar.quote_ok(other.entries, "o1", "a message typed in another session"))
        # end to end: none reaches the editor, and the session is read again next run
        self.h.cleanup()
        self.h = h = FakeHome("ac7run", repo=True)
        h.session(fh.PROJ, "s7", lines)
        h.scenario({"session-helper": {"s7": {"findings": [good] + list(bad.values())}}})
        self.assertEqual(h.run(), 0)
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["session-helper"], "no editor call")
        self.assertNotIn("%s/s7.jsonl" % fh.PROJ, json.loads(h.read(".claude/dream/local/cursors.json") if
                         h.p(".claude/dream/local/cursors.json").exists() else "{}"))
        for c in h.calls.glob("call-*"):
            c.unlink()
        self.assertEqual(h.run(), 0)
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["session-helper"], "read again")

    def test_ac8_explicit_passes_at_once_and_single_sightings_wait_across_runs(self):
        r1 = self.read("s8a", [typed("u1", "No, always write the plan before the code, that is how we work"),
                               typed("u2", "hmm, maybe shorter commit messages read better here")])
        pending = {"candidates": {}}
        b1, pending = self.check(r1, [F("u1", "always write the plan before the code"),
                                      F("u2", "shorter commit messages read better", kind="implied",
                                        statement="Keep commit messages short.")], pending)
        self.assertEqual([x["quote"] for x in b1.passed], ["always write the plan before the code"])
        self.assertEqual(len(pending["candidates"]), 1)
        cid = next(iter(pending["candidates"]))
        # the same session seeing it again does not count as a second sighting
        b1b, pending = self.check(r1, [F("u2", "shorter commit messages read better", kind="implied",
                                         matches_pending=cid)], pending)
        self.assertEqual(b1b.passed, [])
        # a later run: a second session matches the pending candidate, so it passes then
        r2 = self.read("s8b", [typed("v1", "again, I prefer short commit messages over long ones")], key=fh.OTHER)
        r2.project = "other"
        b2, pending = self.check(r2, [F("v1", "I prefer short commit messages", kind="implied",
                                        matches_pending=cid)], pending)
        self.assertEqual([x["quote"] for x in b2.passed], ["I prefer short commit messages"])
        self.assertTrue(b2.passed[0]["two_projects"], "seen in two projects: it may go to a general target")
        self.assertEqual(pending["candidates"], {})
        # a candidate unmatched for 60 days is dropped with a log line
        old = (self.env.now() - datetime.timedelta(days=61)).date().isoformat()
        pending = {"candidates": {"old1": {"statement": "x", "first_seen": old, "sessions": ["s"], "projects": ["p"]},
                                  "new1": {"statement": "y", "first_seen": self.env.now().date().isoformat(),
                                           "sessions": ["s"], "projects": ["p"]}}}
        lines = bar.expire(pending, self.env.now())
        self.assertEqual(list(pending["candidates"]), ["new1"])
        self.assertEqual(len(lines), 1)
        self.assertIn("old1", lines[0])
        # end to end, two real runs: the waiting candidate is kept on disk in state/pending.json between them
        # (a test that hands the dict from one check to the next never reads that file: dream-pass auditor 2)
        self.h.cleanup()
        self.h = h = FakeHome("ac8run", repo=True)
        implied = "shorter commit messages read better"
        short = "- Keep commit messages short (2026-11-09)."

        def editor_quotes(calls):
            eds = [c for c in calls if c["role"] == "editor"]
            self.assertEqual(len(eds), 1, "one editor call: %s" % [c["role"] for c in calls])
            with open(eds[0]["cwd"] + "/_dream/findings.json") as f:
                return [x["quote"] for x in json.load(f)]

        def on_disk():
            return json.loads(h.read(".claude/dream/state/pending.json")).get("candidates")

        def editor_adds(line, summary):
            return {"edits": [{"file": fh.MEM_COPY, "append": line + "\n"}],
                    "changes": {"changes": [{"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL",
                                             "order_id": "", "summary": summary, "additions": [line], "removals": []}],
                                "already_saved": [], "declined": []}}

        yes = {"verdict": "yes", "lost_facts": [], "untraced": [], "notes": ""}
        h.session(fh.PROJ, "s8a", [assistant("I committed without linting."), typed("u1", "No, " + fh.LINT_Q + ", please."),
                                   typed("u2", "hmm, maybe " + implied + " here", minute=2)])
        h.scenario({"session-helper": {"s8a": {"findings": [
                        fh.finding("u1", fh.LINT_Q),
                        F("u2", implied, kind="implied", statement="Keep commit messages short.")]}},
                    "editor": editor_adds(fh.LINT_LINE, "lint before commit"), "checker": yes})
        self.assertEqual(h.run(), 0)
        self.assertEqual(editor_quotes(h.calls_by_role()), [fh.LINT_Q], "run 1: only the explicit one reaches the editor")
        waiting = on_disk()
        self.assertEqual([c["statement"] for c in waiting.values()], ["Keep commit messages short."],
                         "run 1: the implied one waits in state/pending.json")
        cid = next(iter(waiting))
        # run 2: a second session matches the candidate read back from the file, so it passes and reaches the editor
        n = len(h.calls_by_role())
        h.session(fh.PROJ, "s8b", [assistant("Done."), typed("v1", "again, I prefer short commit messages over long ones")])
        h.scenario({"session-helper": {"s8b": {"findings": [F("v1", "I prefer short commit messages", kind="implied",
                                                               matches_pending=cid, statement="Keep commit messages short.")]}},
                    "editor": editor_adds(short, "short commits"), "checker": yes})
        self.assertEqual(h.run(), 0)
        self.assertEqual(editor_quotes(h.calls_by_role()[n:]), ["I prefer short commit messages"],
                         "run 2: the second sighting passes")
        self.assertNotIn(cid, on_disk(), "run 2: the candidate left state/pending.json")
        self.assertIn(short, h.read(fh.MEM_LIVE))

    def test_ac10_safety_loosening_and_weakened_checks_go_to_justins_list(self):
        h = self.h
        r = self.read("s10", [typed("u1", "just push it to main directly, skip the review this once"),
                              typed("u2", "the flaky test, skip it so the build goes green")])
        b, _ = self.check(r, [F("u1", "just push it to main directly", loosens_safety=True),
                              F("u2", "skip it so the build goes green", weakens_check=True)])
        self.assertEqual(b.passed, [], "never given to the editor")
        self.assertEqual(sorted(i["quote"] for i in b.list_items),
                         ["just push it to main directly", "skip it so the build goes green"])
        # end to end: the run puts them on justin-list.md with their quotes
        self.h.cleanup()
        self.h = h = FakeHome("ac10", repo=True)
        h.session(fh.PROJ, "s10", [typed("u1", "just push it to main directly, skip the review this once")])
        h.scenario({"session-helper": {"s10": {"findings": [F("u1", "just push it to main directly",
                                                               loosens_safety=True)]}}})
        self.assertEqual(h.run(), 0)
        self.assertIn('"just push it to main directly"', h.read(".claude/dream/justin-list.md"))
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["session-helper"], "no editor call")

    def test_ac12_secrets_and_personal_details_are_never_written(self):
        h = self.h
        tok = fh.fake_github_token()
        r = self.read("s12", [assistant("Here is your pairing code: " + tok),
                              typed("u1", "my token is %s and never paste tokens in chat again" % tok),
                              typed("u2", "Anna from work is pregnant so keep meetings short for her"),
                              typed("u3", "always run the linter before committing, every time")])
        # the context block and the typed text are both scrubbed before any model sees them
        self.assertNotIn(tok, r.entries[0]["context"])
        self.assertNotIn(tok, r.entries[0]["text"])
        self.assertIn("[masked]", r.entries[0]["context"])
        b, _ = self.check(r, [
            F("u2", "Anna from work is pregnant", personal=True, statement="Keep meetings short for Anna."),
            F("u3", "always run the linter before committing", statement="Use code QX7Z9K2LM8 first."),
            F("u3", "always run the linter before committing", statement="Run the linter; ticket 4417332 says so."),
            F("u3", "always run the linter before committing", statement="Use " + fh.fake_secret()),
            F("u1", "never paste tokens in chat again", statement="Never paste tokens in chat."),
        ])
        self.assertEqual([x["quote"] for x in b.passed], ["never paste tokens in chat again"])
        joined = json.dumps(b.dropped) + json.dumps(b.list_items)
        for text in ("Anna", "pregnant", "QX7Z9K2LM8", "4417332", "Zx9pQ2rT7vW1yB4n"):
            self.assertNotIn(text, joined, "a dropped finding's text appears nowhere")
        self.assertEqual(len(b.dropped), 4)
        # a code-like token that IS in the quoted message may travel
        r2 = self.read("s12b", [typed("v1", "the story id is 86bcm901r, always name it in commits")])
        b2, _ = self.check(r2, [F("v1", "the story id is 86bcm901r, always name it",
                                  statement="Name story 86bcm901r in commits.")])
        self.assertEqual(len(b2.passed), 1)
        # guard half: a diff or a log entry that trips gitleaks does not go live
        from dreamlib import guards
        self.assertTrue(guards.log_secrets(self.env, "entry\n" + fh.fake_secret() + "\n"))
        self.assertEqual(guards.log_secrets(self.env, "a clean log entry\n"), [])
        stripe = "the key is %s here" % fh.fake_stripe_key()   # only gitleaks knows this shape
        self.assertFalse(any(rx.search(stripe) for rx in extract.TOKEN_RES))
        self.assertTrue(guards.log_secrets(self.env, stripe + "\n"))
        self.assertTrue(guards.g_secrets(guards_input_with_added(self.env, h, stripe)))
        self.assertTrue(guards.g_secrets(guards_input_with_added(self.env, h, fh.fake_secret())))
        self.assertEqual(guards.g_secrets(guards_input_with_added(self.env, h, "a harmless line")), [])

    def test_a_lesson_dropped_for_a_code_like_token_is_named_on_justins_list_without_its_text(self):
        """R2-6 (AC12 kept): a lesson whose wording holds a code-like token Justin's message does not hold (the
        busiest project's name, FigmaToBricksV2, or a card id the context is full of) is still dropped before the
        editor, its text in no log; but the loss is not silent: Justin's list names the session, the date and the
        message, with no text of the finding, and the helper is told to word lessons without such tokens."""
        tok = "FigmaToBricksV2"
        r = self.read("s26", [assistant("Built in /home/x/Documents/%s, card 86bcm901b." % tok),
                              typed("u1", "no, always rebuild the plugin after every merge")])
        b, _ = self.check(r, [F("u1", "always rebuild the plugin after every merge",
                                statement="In %s, rebuild the plugin after every merge (card 86bcm901b)." % tok)])
        self.assertEqual(b.passed, [])
        self.assertEqual(len(b.dropped), 1)
        self.assertEqual([(i["kind"], i["quote"], i["date"], i["session"]) for i in b.list_items],
                         [("dropped", "", "2026-11-09", "s26")])
        self.assertIn("u1", b.list_items[0]["why"], "the message is named, so Justin can find it")
        joined = json.dumps(b.dropped) + json.dumps(b.list_items)
        for text in (tok, "86bcm901b", "rebuild the plugin"):
            self.assertNotIn(text, joined, "no text of the dropped finding")
        # the other drops stay silent: a personal detail or a secret is not pointed at
        r2 = self.read("s26b", [typed("v1", "Anna from work is pregnant so keep meetings short for her")])
        b2, _ = self.check(r2, [F("v1", "Anna from work is pregnant", personal=True, statement="Short meetings.")])
        self.assertEqual((len(b2.dropped), b2.list_items), (1, []))
        prompt = " ".join((fh.DREAM_SRC / "prompts/session-helper.md").read_text().split())
        self.assertIn("never a name, id or code his message does not hold", prompt)
        # end to end (review-2 probe p07, qL): no editor call, one item on the list, the token nowhere
        self.h.cleanup()
        self.h = h = FakeHome("r26", repo=True)
        h.session(fh.PROJ, "s1", [assistant("Built in /home/x/Documents/%s." % tok),
                                  typed("u1", "No, " + fh.LINT_Q + ", please.")])
        h.scenario({"session-helper": {"s1": {"findings": [fh.finding("u1", fh.LINT_Q,
                                                                      statement="In %s, lint before commits." % tok)]}}})
        self.assertEqual(h.run(), 0)
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["session-helper"])
        lst = h.read(".claude/dream/justin-list.md")
        self.assertRegex(lst, r"(?m)^- \[ \] 2026-11-09 dropped: .*\(session s1\)")
        for f in (".claude/dream/justin-list.md", ".claude/dream/dream-log.md"):
            self.assertNotIn(tok, h.read(f), f)

    def test_ac45_an_ambiguous_message_never_replaces_a_dated_rule(self):
        r = self.read("s45", [typed("u1", "jsut for this one use the old header, or always, not sure"),
                              typed("u2", "for this task use the old header please"),
                              typed("u3", "[Image #1] make it look like this from now on"),
                              typed("u4", "from now on we always use the new header everywhere")])
        b, pending = self.check(r, [F("u1", "use the old header, or always", ambiguous=True),
                                    F("u2", "for this task use the old header please"),
                                    F("u3", "make it look like this from now on", depends_on_image=True),
                                    F("u4", "from now on we always use the new header")])
        self.assertEqual([x["quote"] for x in b.passed], ["from now on we always use the new header"])
        self.assertEqual(sorted((i["kind"], i["quote"]) for i in b.list_items),
                         [("question", "for this task use the old header please"),
                          ("question", "use the old header, or always")])
        self.assertEqual([c["quote"] for c in pending["candidates"].values()],
                         ["make it look like this from now on"], "an image-only correction waits like an implied one")
        # guard half: removing or replacing a dated line needs a clear typed finding that names what it replaces
        from dreamlib import guards
        old = "- Use the old header (2026-10-01).\n- Keep plans short.\n"
        new = "- Use the new header (2026-11-09).\n- Keep plans short.\n"
        fnd = dict(b.passed[0], id="f1", replaces="")
        ch = {"changes": [{"file": "claude/CLAUDE.md", "basis": "finding", "finding_ids": ["f1"],
                           "additions": ["- Use the new header (2026-11-09)."],
                           "removals": [{"text": "- Use the old header (2026-10-01).", "reason": "outdated"}]}]}
        G = guards_input(self.env, self.h, old, new, [fnd], ch)
        self.assertTrue(guards.g_dated_lines(G), "no finding names what it replaces")
        G = guards_input(self.env, self.h, old, new, [dict(fnd, replaces="Use the old header")], ch)
        self.assertEqual(guards.g_dated_lines(G), [])
        G = guards_input(self.env, self.h, old, new, [dict(fnd, replaces="Use the old header", ambiguous=True)], ch)
        self.assertTrue(guards.g_dated_lines(G), "an ambiguous finding never replaces a dated rule")


def guards_input(env, h, old, new, findings, changes, rel="claude/CLAUDE.md"):
    """A guards.Input for one file changed from old to new in a scratch copy."""
    from dreamlib import guards, targets
    d = h.root / ("copy-%d" % len(list(h.root.glob("copy-*"))))
    for root, text in (("snap", old), ("copy", new)):
        f = d / root / rel
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(text)
    diffs, links = targets.diff_copy(d)
    mapping = {rel: {"live": targets.live_rel(rel), "sha": "x"}}
    return guards.Input(env, d, mapping, diffs, links, findings, [], changes, {"kinds": {}},
                        targets.load_rules(env))


def guards_input_with_added(env, h, line):
    return guards_input(env, h, "# Notes\n", "# Notes\n%s\n" % line, [], {"changes": []},
                        rel="claude/projects/%s/memory/build-notes.md" % fh.PROJ)


if __name__ == "__main__":
    unittest.main()
