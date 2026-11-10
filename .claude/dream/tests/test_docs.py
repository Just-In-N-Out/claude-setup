"""Pointer lines, the three repeat-mistakes files and the docs: AC36 (plan Tasks 11 and 17).
Reads this checkout's real files (the worktree, or $HOME once merged); writes nothing."""
import re
import unittest

import fakehome as fh

R = fh.REPO
SKILLS = {
    "leorna": ".hermes/skills/software-development/leorna",
    "figma-to-bricks": ".hermes/skills/software-development/figma-to-bricks",
    "feature-dispatch": ".hermes/skills/autonomous-ai-agents/feature-dispatch",
}
GENERAL = "feature-dispatch/references/repeat-mistakes.md"


def text(rel):
    return (R / rel).read_text()


class DocsTests(unittest.TestCase):
    def test_ac36_pointer_lines_and_docs_are_in_place(self):
        problems = []

        def need(rel, *needles, flags=0):
            t = text(rel)
            for n in needles:
                if not re.search(n, t, flags):
                    problems.append("%s lacks %r" % (rel, n))

        # one pointer line in each of the three skills, and in the pipeline section of CLAUDE.md
        for name, d in SKILLS.items():
            own = "<project skill>" if name == "feature-dispatch" else name
            lines = [ln for ln in text(d + "/SKILL.md").splitlines() if "repeat-mistakes.md" in ln]
            want = [ln for ln in lines if ("`%s/references/repeat-mistakes.md`" % own) in ln and GENERAL in ln
                    and "Builders, reviewers and fixers" in ln and "every brief for those roles says so" in ln]
            if len(want) != 1:
                problems.append("%s/SKILL.md: %d pointer lines" % (d, len(want)))
        fd = text(SKILLS["feature-dispatch"] + "/SKILL.md")
        sec = fd[fd.index("## Skills every agent loads"):]
        sec = sec[: sec.index("\n## ", 5)]
        if GENERAL not in sec:
            problems.append("feature-dispatch: the pointer is not under 'Skills every agent loads'")
        cm = text(".claude/CLAUDE.md")
        pipeline = cm[: cm.index("\n## Git & GitHub Privacy")]
        brief = [ln for ln in pipeline.splitlines() if ln.startswith("Every brief names")]
        if not (brief and "repeat-mistakes.md" in brief[0] and GENERAL in brief[0]):
            problems.append("CLAUDE.md: the 'Every brief names' sentence lacks the repeat-mistakes pointer")
        # the three files exist with the entry format
        for name, d in SKILLS.items():
            rm = d + "/references/repeat-mistakes.md"
            if not (R / rm).is_file():
                problems.append("missing " + rm)
                continue
            t = text(rm)
            if not t.startswith("# Repeat mistakes: "):
                problems.append(rm + ": no title")
            for n in ("Builders and fixers: build it the way each entry says. Reviewers: check for each entry.",
                      "`~/.claude/dream/DREAM.md`, section 7", "do not edit by hand"):
                if n not in t:
                    problems.append("%s lacks %r" % (rm, n))
        # nothing given to pipeline agents names the tally
        for rel in [d + "/SKILL.md" for d in SKILLS.values()] + [d + "/references/repeat-mistakes.md" for d in SKILLS.values()] \
                + [".claude/CLAUDE.md"]:
            if (R / rel).is_file() and re.search(r"\btally\b|tally\.json", text(rel), re.I):
                problems.append(rel + " mentions the tally")
        # the docs
        need(".claude/setup/manifest.txt", *[r"(?m)^:\(glob\)\.claude/dream/%s$" % re.escape(x) for x in
             ("*.md", "bin/**", "lib/**", "conf/**", "prompts/**", "state/**", "systemd/**", "tests/**")],
             r"(?m)^\.claude/dream/DREAM\.md$")
        need(".claude/setup/exclude.txt", r"(?m)^/\.claude/dream/local/$")
        need(".claude/setup/desktop.md", r"(?m)^## Dream pass", r"dream install", r"loginctl enable-linger",
             r"dream mode (live|dry-run|off)", r"systemctl --user start dream\.service", r"dream-log\.md",
             r"justin-list\.md", r"local/cursors\.json", r"~/\.cache/dream/", r"dream undo", r"~/\.config/dream/env",
             r"(?i)login", r"(?i)flag", r"(?i)unknown transcript shape", r"systemctl --user disable --now dream\.timer")
        need(".claude/setup/mac.md", r"(?i)dream pass.*desktop only")
        need(".github/README.md", r"\| `\.claude/dream/` \|", r"`~/\.claude/dream/local/`", r"`~/\.cache/dream/`",
             r"(?m)^\| .*dream.* \| .* \|$", r"(?m)^- \*\*.*[Dd]ream")
        need(".claude/dream/DREAM.md", r"built, mode dry-run, timer off", r"dream undo <commit>",
             r"GitHub unreachable", r"a CLI flag is missing", r"the editor tried to leave its folder",
             r"3 at a time", r"local/ledger\.jsonl", r"90,000", r"12 files", r"search first",
             r"(?i)typed while Claude was working", r"ambiguous", r"voice-note slip", r"short paste",
             r"names what it replaces", r"`~/\.hermes/memories/`", r"enforce-backlog\.md", r"model calls and tokens",
             r"already saved", r"could not apply automatically", r"dry-run")
        d = text(".claude/dream/DREAM.md")
        if "(plan" in d or "a quote that cannot be found" in d:
            problems.append("DREAM.md still has a (plan) marker or the old quote rule")
        need(".claude/CLAUDE.md", r"(?m)^## Dream Pass$", r"dream undo", r"dream mode off",
             r"systemctl --user disable --now dream\.timer", r"dream-log\.md", r"justin-list\.md",
             r"pre-dream-2026-11-09", r"never hand-edit", r"dream reads the same skills and never duplicates a saved lesson")
        if len(cm.encode()) >= 30000:
            problems.append("CLAUDE.md is %d bytes (budget 30,000)" % len(cm.encode()))
        self.assertEqual(problems, [])


if __name__ == "__main__":
    unittest.main()
