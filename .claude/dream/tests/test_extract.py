"""Transcript extractor: AC1, AC2, AC3, AC42, AC43 (plan Task 2)."""
import json
import subprocess
import unittest

import fakehome as fh
from fakehome import FakeHome, typed, assistant, tool_result, queued_attachment, slash
from dreamlib import extract, bar


def marks_absent(test, text, marks):
    found = [m for m in marks if m in text]
    test.assertEqual(found, [], "these must never reach a digest")


class ExtractTests(unittest.TestCase):
    def setUp(self):
        self.h = FakeHome("extract")
        self.env = self.h.denv()

    def tearDown(self):
        self.h.cleanup()

    def read(self, path, **kw):
        r = extract.read_session(path, **kw)
        extract.scrub_entries(r.entries, self.env)
        return r

    def test_ac1_digest_holds_only_typed_messages_with_context(self):
        p1 = "x" * 400
        p2 = "Which header should stay?\n- A: the fixed one\n- B: the floating one\n" + "y" * 1230
        p3 = "z" * 300
        first_ctx = p1 + "\n\n" + p2 + "\n\n" + p3
        lines = [
            assistant(first_ctx, minute=1, extra_blocks=[
                {"type": "thinking", "thinking": "THINK-MARK"},
                {"type": "tool_use", "id": "t1", "name": "Bash", "input": {"command": "TOOLCALL-MARK"}}]),
            typed("u1", "[Image #1] please keep the header fixed", minute=2,
                  message={"role": "user", "content": [
                      {"type": "text", "text": "[Image #1] please keep the header fixed"},
                      {"type": "image", "source": {"type": "base64", "data": "AAAA"}}]}),
            tool_result("r1", "TOOLRESULT-MARK", minute=3),
            typed("sc1", "SIDECHAIN-MARK typed in a subagent", minute=3, isSidechain=True),
            typed("m1", "META-MARK skill body", minute=3, isMeta=True),
            typed("sdk1", "SDK-MARK headless prompt", minute=3, source="sdk"),
            typed("n1", "<task-notification>NOTIF-MARK</task-notification>", minute=3, source="system"),
            dict(typed("c1", "COMPACT-MARK summary", minute=3), isCompactSummary=True, promptSource=None),
            slash("cl1", "clear", "", minute=3),
            dict(typed("b1", "<bash-input>ls BASH-MARK</bash-input>", minute=3), promptSource=None),
            dict(typed("o1", "<local-command-stdout>STDOUT-MARK</local-command-stdout>", minute=3), promptSource=None),
            dict(typed("i1", "[Request interrupted by user]", minute=3), promptSource=None),
            assistant("SIDE-ASSIST-MARK", minute=3, isSidechain=True),
            assistant("Done with the header.", minute=4),
            typed("u2", "also the footer, same way", minute=5, source="queued"),
            typed("u3", "", minute=6, message={"role": "user", "content": [
                {"type": "text", "text": "[Image: source: /tmp/CAPTION-MARK.png]"},
                {"type": "text", "text": "the second thing matters more"}]}),
        ]
        f = self.h.session(fh.PROJ, "s1", lines)
        r = self.read(f)
        self.assertEqual([e["uuid"] for e in r.entries], ["u1", "u2", "u3"])
        self.assertEqual([e["ts"] for e in r.entries], [fh.ts(2), fh.ts(5), fh.ts(6)])
        self.assertEqual(r.entries[0]["text"], "please keep the header fixed")
        self.assertEqual([e["image"] for e in r.entries], [True, False, False])
        self.assertEqual(r.entries[2]["text"], "the second thing matters more")
        # context: the last 1,500 characters, moved back to the start of the paragraph the cut falls in
        self.assertEqual(r.entries[0]["context"], p2 + "\n\n" + p3)
        self.assertEqual(r.entries[1]["context"], "Done with the header.")
        self.assertEqual(r.entries[2]["context"], "")
        # the 3,000-character limit when the paragraph is longer
        self.assertEqual(extract.context_tail("w" * 5000), "w" * 3000)
        self.assertEqual(extract.context_tail("short"), "short")
        digest, used = extract.render_digest("s1", "proj", r.entries)
        self.assertEqual(len(used), 3)
        i_ctx = digest.index("CONTEXT (what Claude said, not evidence)")
        self.assertLess(i_ctx, digest.index("please keep the header fixed"))
        self.assertIn("uuid=u1", digest)
        self.assertIn(fh.ts(2), digest)
        self.assertIn("has an image the helper cannot see", digest)
        self.assertNotIn("[Image #1]", digest)
        marks_absent(self, digest, ["THINK-MARK", "TOOLCALL-MARK", "TOOLRESULT-MARK", "SIDECHAIN-MARK", "META-MARK",
                                    "SDK-MARK", "NOTIF-MARK", "COMPACT-MARK", "BASH-MARK", "STDOUT-MARK",
                                    "Request interrupted", "SIDE-ASSIST-MARK", "CAPTION-MARK", "/clear"])

    def test_ac2_whole_paste_kept_and_inner_paste_omitted(self):
        inner = "INNER-PASTE-MARK 12345"
        lines = [
            typed("p1", '<pasted_content id="6a6a">line one of the pasted rule\nline two</pasted_content id="6a6a">\n'),
            typed("p2", 'look at this <pasted_content id="7b7b">%s</pasted_content id="7b7b"> and fix it' % inner),
        ]
        r = self.read(self.h.session(fh.PROJ, "s2", lines))
        self.assertEqual([e["label"] for e in r.entries], ["PASTE (whole message)", "TYPED"])
        self.assertEqual(r.entries[0]["text"], "line one of the pasted rule\nline two")
        self.assertEqual(r.entries[1]["text"], "look at this [paste omitted, %d chars] and fix it" % len(inner))
        digest, _ = extract.render_digest("s2", "proj", r.entries)
        self.assertIn("PASTE (whole message)", digest)
        self.assertNotIn("INNER-PASTE-MARK", digest)

    def test_ac3_unknown_transcript_shape_fails_loudly(self):
        good = typed("g1", "a normal typed message here")
        cases = {
            "no-source": dict(typed("x1", "hello there, plain text"), promptSource=None),
            "no-uuid": {k: v for k, v in typed("x2", "missing the uuid").items() if k != "uuid"},
            "no-timestamp": {k: v for k, v in typed("x3", "missing the time").items() if k != "timestamp"},
            "no-content": dict(typed("x4", "x"), message={"role": "user"}),
            "odd-source": typed("x5", "a new kind of prompt", source="voice"),
        }
        for name, bad in cases.items():
            f = self.h.session(fh.PROJ, "bad-" + name, [good, bad, typed("g2", "after the bad line")])
            with self.assertRaises(extract.UnknownShape, msg=name) as cm:
                extract.read_session(f)
            self.assertIn("bad-" + name, str(cm.exception), name)
            self.assertIn("line 2", str(cm.exception), name)
        # a broken line in the middle is an unknown shape; a broken last line is still being written
        mid = self.h.session(fh.PROJ, "bad-json", [good], raw_tail='{"type": "user", "uuid"\n' + json.dumps(good) + "\n")
        with self.assertRaises(extract.UnknownShape):
            extract.read_session(mid)
        tail = self.h.session(fh.PROJ, "tail-json", [good], raw_tail='{"type": "user", "uu')
        r = extract.read_session(tail)
        self.assertEqual(r.lines_read, 1)
        self.assertEqual([e["uuid"] for e in r.entries], ["g1"])
        # the shape is named without Justin's text, and `dream extract` exits non-zero naming it
        out = self.h.dream("extract", str(self.h.p(".claude/projects/%s/bad-no-source.jsonl" % fh.PROJ)))
        self.assertNotEqual(out.returncode, 0)
        self.assertIn("bad-no-source", out.stderr)
        self.assertIn("unknown transcript shape", out.stderr)
        self.assertNotIn("hello there", out.stderr)
        self.assertEqual(out.stdout, "", "no digest, not even an empty one")
        # in a run: that session gets no digest and keeps no marker; the others go on; all bad: exit 4
        h = FakeHome("ac3run", repo=True)
        try:
            h.session(fh.PROJ, "bad", [good, cases["no-source"]])
            fh.standard(h, sid="good")
            self.assertEqual(h.run(), 0)
            run_dir = h.p(".cache/dream/20261110-050000")
            self.assertTrue((run_dir / "digest-good.md").exists())
            self.assertFalse((run_dir / "digest-bad.md").exists())
            cur = json.loads(h.read(".claude/dream/local/cursors.json"))
            self.assertIn("%s/good.jsonl" % fh.PROJ, cur)
            self.assertNotIn("%s/bad.jsonl" % fh.PROJ, cur)
            self.assertIn("bad, line 2", h.read(".claude/dream/dream-log.md"), "the run reports the format error")
            h.session(fh.PROJ, "bad2", [cases["odd-source"]])
            self.assertEqual(h.run(), 4, "every session with new lines is of an unknown shape")
            self.assertIn("unknown transcript shape", h.local("last-run.json")["reason"])
        finally:
            h.cleanup()

    def test_ac42_mid_turn_prompts_and_slash_arguments_are_typed_and_nothing_is_counted_twice(self):
        lines = [
            typed("u1", "first typed message about the build", minute=1),
            queued_attachment("q1", "and also check the footer while you are at it", minute=2),
            queued_attachment("q2", [{"type": "text", "text": "a block-list prompt typed mid-turn"}], minute=3),
            queued_attachment("q3", "<task-notification>NOTIF-ATT-MARK</task-notification>", kind="task-notification", minute=4),
            queued_attachment("q4", "PEER-MARK message from another agent", kind="peer", minute=5),
            slash("sl1", "loop", "make the timer five minutes from now on", minute=6),
            {"type": "api-request-blob", "uuid": "blob1", "timestamp": fh.ts(7),
             "messages": [{"role": "user", "content": "first typed message about the build"}]},
            typed("u1", "first typed message about the build", minute=8),
        ]
        r = self.read(self.h.session(fh.PROJ, "s42", lines))
        self.assertEqual([(e["uuid"], e["label"]) for e in r.entries],
                         [("u1", "TYPED"), ("q1", "mid-turn"), ("q2", "mid-turn"), ("sl1", "SLASH /loop")])
        self.assertEqual(r.entries[3]["text"], "make the timer five minutes from now on")
        self.assertEqual(r.entries[2]["text"], "a block-list prompt typed mid-turn")
        digest, _ = extract.render_digest("s42", "proj", r.entries)
        self.assertEqual(digest.count("first typed message about the build"), 1)
        marks_absent(self, digest, ["NOTIF-ATT-MARK", "PEER-MARK"])

    def test_ac43_question_answers_are_entries_and_only_the_chosen_text_is_quotable(self):
        tur = {"questions": [
            {"question": "Which pipeline should this story use?", "header": "Pipeline", "multiSelect": False,
             "options": [{"label": "Full pipeline with reviews", "description": "d"},
                         {"label": "Mini pipeline, one review", "description": "d"}]},
            {"question": "Which card is it?", "header": "Card", "multiSelect": False,
             "options": [{"label": "No card for this one", "description": "d"}]}],
            "answers": {"Which pipeline should this story use?": "Full pipeline with reviews",
                        "Which card is it?": "it is a setup bug, never ask for a card here"}}
        lines = [assistant("Two questions for you."), tool_result("ans1", "answered", minute=2, tool_use_result=tur)]
        r = self.read(self.h.session(fh.PROJ, "s43", lines))
        self.assertEqual([(e["uuid"], e["label"]) for e in r.entries], [("ans1", "ANSWER"), ("ans1", "ANSWER")])
        a, b = r.entries
        self.assertEqual(a["question"], "Which pipeline should this story use?")
        self.assertEqual(a["options"], ["Full pipeline with reviews", "Mini pipeline, one review"])
        self.assertEqual(a["chosen"], ["Full pipeline with reviews"])
        self.assertEqual(a["own"], "")
        self.assertEqual(b["chosen"], [])
        self.assertEqual(b["own"], "it is a setup bug, never ask for a card here")
        digest, _ = extract.render_digest("s43", "proj", r.entries)
        self.assertIn("Which pipeline should this story use?", digest)
        self.assertIn("Mini pipeline, one review", digest)  # offered options are shown
        ok = lambda q: bar.quote_ok(r.entries, "ans1", q)
        self.assertTrue(ok("Full pipeline with reviews"))
        self.assertTrue(ok("never ask for a card here"))
        self.assertFalse(ok("Mini pipeline, one review"), "an option he did not choose")
        self.assertFalse(ok("Which pipeline should this story use?"), "the question is not his text")


def freeze_session(h, sid, key=fh.PROJ):
    """A session as a freeze leaves it: a line of NUL bytes where a write was cut off, then a last-prompt line,
    then more typed text (the shape of the two real cases, review-1 probe p02)."""
    f = h.session(key, sid, [typed("u0", "hello there, please start the build")])
    with open(f, "a") as fp:
        fp.write("\x00" * 300 + "\n")
        fp.write(json.dumps({"type": "last-prompt", "lastPrompt": "x", "leafUuid": "u0", "sessionId": "s"}) + "\n")
        fp.write(json.dumps(typed("u1", "No, " + fh.LINT_Q + ", please.", minute=5)) + "\n")
    h.age(f, 120)
    return f


class UnreadableTests(unittest.TestCase):
    """Ruling R1-1 (b): a line a freeze left is skipped and noted; a session of an unknown shape still stops
    loudly, but it does not stop the run from handling review lines and waiting findings, and it shows in
    the session-start line."""

    def tearDown(self):
        self.h.cleanup()

    def test_a_nul_line_left_by_a_freeze_is_skipped_and_noted(self):
        self.h = h = FakeHome("freeze", repo=True)
        f = freeze_session(h, "sF")
        r = extract.read_session(f)
        self.assertEqual([e["uuid"] for e in r.entries], ["u0", "u1"])
        self.assertEqual(r.freeze_lines, [2])
        # a line that is broken in any other way is still an unknown shape (AC3)
        bad = h.session(fh.PROJ, "bad-json", [typed("g1", "a normal typed message")],
                        raw_tail='{"type": "user", "uuid"\n' + json.dumps(typed("g2", "after it")) + "\n")
        with self.assertRaises(extract.UnknownShape):
            extract.read_session(bad)
        bad.unlink()
        # in a run: the session is read, its correction goes live, the log notes the skipped line
        h.scenario({"session-helper": {"sF": {"findings": [fh.finding("u1", fh.LINT_Q)]}},
                    "editor": {"edits": [{"file": fh.MEM_COPY, "append": fh.LINT_LINE + "\n"}],
                               "changes": {"changes": [{"file": fh.MEM_COPY, "basis": "finding", "finding_ids": "ALL",
                                                        "summary": "lint", "additions": [fh.LINT_LINE], "removals": []}]}}})
        self.assertEqual(h.run(), 0)
        self.assertIn(fh.LINT_LINE, h.read(fh.MEM_LIVE))
        log = h.read(".claude/dream/dream-log.md")
        self.assertIn("line 2", log.split("Skipped lines:")[1].split("\n")[0], "the log notes the skipped line")
        self.assertNotIn("Format errors", log)

    def test_an_unreadable_session_does_not_stop_review_lines_or_waiting_findings(self):
        self.h = h = FakeHome("unread", repo=True)
        bad = [typed("g1", "a normal typed message here"), dict(typed("x1", "hello there, plain text"), promptSource=None)]
        h.session(fh.PROJ, "bad", bad)
        h.write(".hermes/plans/proj/evidence/st/review-1/review.json", json.dumps(
            {"findings": [{"id": "F1", "severity": "P2", "claim": "a guard was skipped", "file_line": "a:1"}]}))
        h.scenario({"review-helper": {"assign": "none"}})
        self.assertEqual(h.run(), 0, "the review line is handled though the only session is unreadable")
        self.assertEqual([c["role"] for c in h.calls_by_role()], ["review-helper"])
        self.assertEqual(len(json.loads(h.read(".claude/dream/state/tally.json"))["seen"]), 1)
        self.assertIn("bad, line 2", h.read(".claude/dream/dream-log.md"))
        self.assertEqual(h.local("last-run.json")["unreadable"], ["bad"], "for the session-start line")
        # findings that wait from a stopped run are tried again, though the only new lines are unreadable
        fh.standard(h, sid="good", checker={"verdict": "no", "lost_facts": [], "untraced": [], "notes": "no"})
        self.assertEqual(h.run(), 3)
        sc = json.loads(h.scenario_path.read_text())
        sc["checker"] = {"verdict": "yes", "lost_facts": [], "untraced": [], "notes": ""}
        h.scenario(sc)
        h.session(fh.PROJ, "bad2", bad)
        self.assertEqual(h.run(), 0)
        self.assertIn(fh.LINT_LINE, h.read(fh.MEM_LIVE))
        self.assertEqual(sorted(h.local("last-run.json")["unreadable"]), ["bad", "bad2"])
        # nothing but unreadable sessions, nothing waiting: still the loud stop (AC3)
        h.session(fh.PROJ, "bad3", bad)
        self.assertEqual(h.run(), 4)

    def test_unreadable_sessions_show_in_the_session_start_line(self):
        self.h = h = FakeHome("unread-line", repo=True)
        h.session(fh.PROJ, "bad", [typed("g1", "a normal typed message here"),
                                    dict(typed("x1", "hello there, plain text"), promptSource=None)])
        fh.standard(h, sid="good")
        self.assertEqual(h.run(), 0)
        out = subprocess.run(["bash", str(fh.REPO / ".claude/hooks/dream-notice.sh")], env=h.env, input="{}",
                             capture_output=True, text=True).stdout
        msg = json.loads(out)["systemMessage"]
        self.assertIn("changed 1 file", msg)
        self.assertIn("1 session could not be read", msg)


if __name__ == "__main__":
    unittest.main()
