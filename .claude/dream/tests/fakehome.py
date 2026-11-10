"""A fake $HOME for the dream's tests: never the real $HOME, setup repo, library clone or claude.

FakeHome() builds, under $DREAM_TEST_ROOT (default ~/.cache/dream-tests, outside the RAM /tmp):
  home/                 the fake $HOME: CLAUDE.md, memory folders, skills, the dream folder (this
                        checkout's DREAM.md, conf, prompts, systemd, state seeds), the setup folder
                        (this checkout's sync.sh, manifest, exclude, gitleaks.toml, githooks)
  remote.git            the setup repo's "GitHub" (repo=True), made the way sync.test.sh does it
  lib-origin.git        the library clone's origin (library=True)
  bin/                  fake gh and systemctl, first on PATH
  calls/                one JSON file per fake-claude call
Transcript lines are built from the shapes measured on 2026-11-09 (plan, "What the planner
measured"), never copied from real transcripts. Fake secrets are assembled at run time.
"""
import datetime
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

TESTS = Path(__file__).resolve().parent
DREAM_SRC = TESTS.parent
REPO = DREAM_SRC.parents[1]          # the checkout root ($HOME-relative layout)
LIB_DIR = DREAM_SRC / "lib"
FAKE_CLAUDE = TESTS / "fake-claude"
REAL_HOME = Path(os.environ["HOME"])
TEST_ROOT = Path(os.environ.get("DREAM_TEST_ROOT", REAL_HOME / ".cache/dream-tests"))
if str(LIB_DIR) not in sys.path:
    sys.path.insert(0, str(LIB_DIR))

NOW = "2026-11-10T05:00:00-05:00"
PROJ = "-fake-proj"          # folder keys under .claude/projects
OTHER = "-fake-other"
SETUPK = "-fake-setup"
GENERAL_RM = ".hermes/skills/ad/feature-dispatch/references/repeat-mistakes.md"
PROJ_SKILL = ".hermes/skills/sd/proj-skill"
PROJ_RM = PROJ_SKILL + "/references/repeat-mistakes.md"
OTHER_RM = ".hermes/skills/sd/other-skill/references/repeat-mistakes.md"
RM_HEADER = ("# Repeat mistakes: {p}\nBuilders and fixers: build it the way each entry says. Reviewers: check "
             "for each entry. Kept by the dream pass (`~/.claude/dream/DREAM.md`, section 7); do not edit by hand.\n")

CLAUDE_MD = """# Global Instructions

## Git Rules

- never push to Leorna without asking (2026-10-01)

## Notes

- Old note about builds (2026-10-02).
- Keep plans short.
"""


def ts(minute, day=9, hour=10):
    return "2026-11-%02dT%02d:%02d:00.000Z" % (day, hour, minute)


def typed(uuid, text, minute=1, source="typed", **kw):
    line = {"type": "user", "uuid": uuid, "parentUuid": None, "timestamp": ts(minute), "sessionId": "s",
            "entrypoint": "cli", "isSidechain": False, "promptSource": source, "origin": {"kind": "human"},
            "message": {"role": "user", "content": text}}
    line.update(kw)
    return line


def assistant(text, uuid=None, minute=1, extra_blocks=(), **kw):
    blocks = list(extra_blocks) + [{"type": "text", "text": text}]
    line = {"type": "assistant", "uuid": uuid or ("a-%d" % minute), "timestamp": ts(minute), "isSidechain": False,
            "entrypoint": "cli", "message": {"role": "assistant", "content": blocks}}
    line.update(kw)
    return line


def tool_result(uuid, text, minute=1, tool_use_result=None):
    line = {"type": "user", "uuid": uuid, "timestamp": ts(minute), "isSidechain": False, "entrypoint": "cli",
            "message": {"role": "user", "content": [{"type": "tool_result", "tool_use_id": "t1", "content": text}]}}
    if tool_use_result is not None:
        line["toolUseResult"] = tool_use_result
    return line


def queued_attachment(uuid, prompt, kind="human", minute=1):
    return {"type": "attachment", "uuid": uuid, "timestamp": ts(minute), "isSidechain": False, "entrypoint": "cli",
            "attachment": {"type": "queued_command", "prompt": prompt, "origin": {"kind": kind}}}


def slash(uuid, name, args, minute=1):
    text = "<command-message>%s is running…</command-message>\n<command-name>/%s</command-name>\n" \
           "<command-args>%s</command-args>" % (name, name, args)
    return {"type": "user", "uuid": uuid, "timestamp": ts(minute), "isSidechain": False, "entrypoint": "cli",
            "origin": {"kind": "human"}, "message": {"role": "user", "content": text}}


MEM_LIVE = ".claude/projects/%s/memory/build-notes.md" % PROJ
MEM_COPY = MEM_LIVE[1:]
LINT_Q = "from now on always run the linter before every commit"
LINT_LINE = "- Run the linter before every commit (2026-11-09)."


def finding(uuid, quote, **kw):
    f = {"uuid": uuid, "quote": quote, "kind": "correction", "statement": "Run the linter before every commit.",
         "general": False, "replaces": "", "matches_pending": "", "loosens_safety": False, "weakens_check": False,
         "personal": False, "ambiguous": False, "depends_on_image": False}
    f.update(kw)
    return f


def standard(h, sid="s1", extra_findings=(), edits=None, changes=None, checker=None, **kw):
    """One session with one correction; the editor adds one dated line to the project's memory note."""
    h.session(PROJ, sid, [assistant("I committed without linting."), typed("u1", "No, " + LINT_Q + ", please.")])
    sc = {"session-helper": {sid: {"findings": [finding("u1", LINT_Q)] + list(extra_findings)}},
          "editor": {"edits": edits if edits is not None else [{"file": MEM_COPY, "append": LINT_LINE + "\n"}],
                     "changes": changes if changes is not None else {"changes": [
                         {"file": MEM_COPY, "basis": "finding", "finding_ids": "ALL", "order_id": "",
                          "summary": "lint before commit", "additions": [LINT_LINE], "removals": []}],
                         "already_saved": [], "declined": []}},
          "checker": checker or {"verdict": "yes", "lost_facts": [], "untraced": [], "notes": ""}}
    sc.update(kw)
    h.scenario(sc)
    return sc


def fake_secret():
    """A string gitleaks flags, built from pieces so no synced file holds it whole."""
    return "aws_secret_access_key = " + "Zx9pQ2rT7vW1yB4n" + "M8kL3jH6gF5dS0aQwErTyUiO"


def fake_stripe_key():
    """Flagged by gitleaks (stripe-access-token) but not by the dream's own regex pass."""
    return "sk_" + "live_" + "Zq8RwP3mN6tY1vB9cX4kL7jH"


def fake_github_token():
    return "gh" + "p_" + "A1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p6Q7r8"


class FakeHome:
    def __init__(self, name="t", repo=False, library=False, mode="live", sessions_old=True):
        TEST_ROOT.mkdir(parents=True, exist_ok=True)
        self.root = Path(tempfile.mkdtemp(prefix="dream-%s-" % name, dir=str(TEST_ROOT)))
        self.home = self.root / "home"
        self.remote = self.root / "remote.git"
        self.calls = self.root / "calls"
        self.bin = self.root / "bin"
        self.tmp = self.root / "tmp"
        for d in (self.home, self.bin, self.tmp, self.calls):
            d.mkdir(parents=True)
        self.scenario_path = self.root / "scenario.json"
        self.scenario({})
        self.env = {
            "HOME": str(self.home), "PATH": "%s:%s" % (self.bin, os.environ.get("PATH", "/usr/bin:/bin")),
            "GIT_CONFIG_GLOBAL": str(self.home / ".gitconfig"), "GIT_CONFIG_NOSYSTEM": "1",
            "DREAM_CLAUDE_BIN": str(FAKE_CLAUDE), "FAKE_CLAUDE_DIR": str(self.calls),
            "FAKE_CLAUDE_SCENARIO": str(self.scenario_path), "DREAM_NOW": NOW,
            "SETUP_SYNC_URL": str(self.remote), "SETUP_SYNC_PATH_COL": "3", "TMPDIR": str(self.tmp),
            "LANG": os.environ.get("LANG", "C.UTF-8"), "DREAM_LOCK_WAIT": "0.05",
        }
        self._base(mode)
        if library:
            self.make_library()
        if repo:
            self.make_repo()

    # ---------- building ----------
    def p(self, rel):
        return self.home / rel

    def write(self, rel, text, mode=None):
        f = self.p(rel)
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text(text)
        if mode:
            f.chmod(mode)
        return f

    def read(self, rel):
        return self.p(rel).read_text()

    def scenario(self, sc):
        self.scenario_path.write_text(json.dumps(sc))

    def _base(self, mode):
        shutil.copy(REAL_HOME / ".gitconfig", self.home / ".gitconfig")
        shutil.copytree(REPO / ".claude/githooks", self.p(".claude/githooks"))
        setup = self.p(".claude/setup")
        setup.mkdir(parents=True)
        for f in ("sync.sh", "manifest.txt", "exclude.txt", "gitleaks.toml"):
            shutil.copy(REPO / ".claude/setup" / f, setup / f)
        self.project_dir = self.home / "work/proj"
        self.project_dir.mkdir(parents=True)
        (setup / "projects.tsv").write_text("# fake\nproj\t/nowhere/proj\t%s\t-fake-proj\tyes\n" % self.project_dir)
        d = self.p(".claude/dream")
        d.mkdir(parents=True)
        shutil.copy(DREAM_SRC / "DREAM.md", d / "DREAM.md")
        for sub in ("conf", "prompts", "systemd", "state"):
            if (DREAM_SRC / sub).is_dir():
                shutil.copytree(DREAM_SRC / sub, d / sub)
        for f in ("dream-log.md", "justin-list.md"):
            if (DREAM_SRC / f).exists():
                shutil.copy(DREAM_SRC / f, d / f)
        # conf for this fake home: its own frozen sections, canaries and projects
        (d / "conf/protected.tsv").write_text("# fake\n.claude/CLAUDE.md\tGit Rules\n")
        (d / "conf/canary.tsv").write_text("# fake\n.claude/CLAUDE.md\tnever push to Leorna without asking\n")
        (d / "conf/projects.tsv").write_text(
            "# fake\n%s*\tproj\t%s\t%s\n%s*\tother\t.hermes/skills/sd/other-skill\t%s\n"
            "%s*\tclaude-setup\t.hermes/skills/ad/feature-dispatch\t%s\n"
            % (PROJ, PROJ_SKILL, PROJ_RM, OTHER, OTHER_RM, SETUPK, GENERAL_RM))
        if mode:
            self.write(".claude/dream/local/mode", mode + "\n")
        self.write(".claude/CLAUDE.md", CLAUDE_MD)
        self.write(".claude/projects/%s/memory/MEMORY.md" % PROJ, "# Memory\n\n- [Build notes](build-notes.md)\n")
        self.write(".claude/projects/%s/memory/build-notes.md" % PROJ, "# Build notes\n\n- Run the tests first.\n")
        self.write(".claude/projects/%s/memory/MEMORY.md" % OTHER, "# Memory\n")
        self.write(".claude/projects/%s/memory/MEMORY.md" % SETUPK, "# Memory\n")
        self.write(".claude/project-docs/proj/CLAUDE.md", "# Proj rules\n\n- Use tabs.\n")
        (self.project_dir / "CLAUDE.md").write_text("# Proj rules\n\n- Use tabs.\n")
        self.write(PROJ_SKILL + "/SKILL.md", "# Proj skill\n\n## Steps\n\n- Build first.\n")
        self.write(PROJ_RM, RM_HEADER.format(p="proj"))
        self.write(".hermes/skills/sd/other-skill/SKILL.md", "# Other skill\n\n- Lint.\n")
        self.write(OTHER_RM, RM_HEADER.format(p="other"))
        self.write(".hermes/skills/ad/feature-dispatch/SKILL.md", "# Feature dispatch\n\n- Plan first.\n")
        self.write(GENERAL_RM, RM_HEADER.format(p="general"))
        self.write(".hermes/skills/sd/general-skill/SKILL.md", "# General skill\n\n- Be clear.\n")
        self.write(".hermes/plans/claude-setup/enforce-backlog.md", "# Enforce backlog\n\n")
        self.write(".hermes/skills-library-local.patch", "")
        gh = self.bin / "gh"
        gh.write_text("#!/bin/sh\n[ \"$1 $2\" = 'auth token' ] && { echo fake-token; exit 0; }\nexit 1\n")
        gh.chmod(0o755)
        sc = self.bin / "systemctl"
        sc.write_text("#!/bin/sh\necho \"$*\" >> \"%s/systemctl.log\"\n" % self.root)
        sc.chmod(0o755)

    def sh(self, *args, cwd=None, check=True, input=None):
        r = subprocess.run(list(args), cwd=str(cwd or self.home), env=self.env, input=input,
                           capture_output=True, text=True)
        if check and r.returncode != 0:
            raise AssertionError("%s failed (%d): %s %s" % (args, r.returncode, r.stdout, r.stderr))
        return r

    def git(self, *args, check=True):
        return self.sh("git", "--git-dir=%s" % (self.home / ".claude-setup.git"), "--work-tree=%s" % self.home,
                       *args, check=check)

    def sync(self, *args, check=True):
        return self.sh("bash", str(self.p(".claude/setup/sync.sh")), *args, check=check)

    def make_repo(self):
        self.sh("git", "init", "-q", "--bare", "-b", "main", str(self.remote))
        self.sync("init")
        self.sync()

    def on_pull(self, script):
        """Run `script` (bash, in $HOME) each time sync.sh is called with `pull`, after the real pull;
        $N is the call's number (1 = the run's first pull)."""
        setup = self.p(".claude/setup")
        real = setup / "sync.real.sh"
        if not real.exists():
            (setup / "sync.sh").rename(real)
            (setup / "sync.sh").write_text(
                '#!/usr/bin/env bash\nbash "$(dirname "$0")/sync.real.sh" "$@"; rc=$?\n'
                'if [ "$1" = pull ] && [ -f "%s/on-pull.sh" ]; then n=$(( $(cat "%s/pulls" 2>/dev/null || echo 0) + 1 ));'
                ' echo $n > "%s/pulls"; N=$n bash "%s/on-pull.sh"; fi\nexit $rc\n' % ((self.root,) * 4))
        (self.root / "on-pull.sh").write_text("cd \"$HOME\"\n" + script)
        (self.root / "pulls").write_text("0")

    def make_library(self):
        lib = self.p(".hermes/skills-library")
        origin = self.root / "lib-origin.git"
        self.write(".hermes/skills-library/skills/lib-skill/SKILL.md",
                   "# Lib skill\n\n## Rules\n\n- Review twice.\n- Keep it short.\n")
        self.sh("git", "init", "-q", "-b", "main", str(lib))
        self.sh("git", "add", "-A", cwd=lib)
        self.sh("git", "commit", "-qm", "library", cwd=lib)
        self.sh("git", "init", "-q", "--bare", "-b", "main", str(origin))
        self.sh("git", "remote", "add", "origin", str(origin), cwd=lib)
        self.sh("git", "push", "-q", "origin", "main", cwd=lib)
        self.sh("git", "branch", "-q", "--set-upstream-to=origin/main", cwd=lib)
        self.p(".claude/skills").mkdir(parents=True, exist_ok=True)
        os.symlink(lib / "skills/lib-skill", self.p(".claude/skills/lib-skill"))

    def session(self, key, sid, lines, age_minutes=120, raw_tail=None):
        f = self.p(".claude/projects/%s/%s.jsonl" % (key, sid))
        f.parent.mkdir(parents=True, exist_ok=True)
        body = "".join(json.dumps(x) + "\n" for x in lines)
        if raw_tail is not None:
            body += raw_tail
        f.write_text(body)
        self.age(f, age_minutes)
        return f

    def append_session(self, path, lines, age_minutes=120):
        with open(path, "a") as f:
            for x in lines:
                f.write(json.dumps(x) + "\n")
        self.age(path, age_minutes)

    def age(self, path, minutes):
        now = datetime.datetime.fromisoformat(self.env["DREAM_NOW"]).timestamp()
        t = now - minutes * 60
        os.utime(path, (t, t))

    # ---------- running ----------
    def denv(self):
        import importlib
        paths = importlib.import_module("dreamlib.paths")
        return paths.Env(self.env)

    def run(self, **kw):
        from dreamlib import run as runmod
        return runmod.run(self.denv(), **kw)

    def dream(self, *args, check=False):
        return self.sh(sys.executable, "-B", str(DREAM_SRC / "bin/dream"), *args, check=check)

    def calls_by_role(self):
        out = []
        for f in sorted(self.calls.glob("call-*.json")):
            out.append(json.loads(f.read_text()))
        return out

    def local(self, name, default=None):
        f = self.p(".claude/dream/local/" + name)
        try:
            return json.loads(f.read_text())
        except (OSError, ValueError):
            return default

    def head(self):
        return self.git("rev-parse", "HEAD").stdout.strip()

    def remote_head(self):
        return self.sh("git", "--git-dir=%s" % self.remote, "rev-parse", "main").stdout.strip()

    def cleanup(self):
        shutil.rmtree(self.root, ignore_errors=True)
