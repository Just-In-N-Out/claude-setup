"""Roots and small file helpers shared by every module.

Every root is taken from the environment (HOME, SETUP_SYNC_GIT_DIR, SETUP_SYNC_URL, DREAM_HOME,
DREAM_CACHE, DREAM_CLAUDE_BIN, DREAM_NOW), so tests point the whole job at a fake home.
"""
import datetime
import hashlib
import json
import os
import re
import tempfile
from pathlib import Path

CODE_ROOT = Path(__file__).resolve().parents[2]  # the dream folder that holds bin/ and lib/


class Env:
    def __init__(self, environ=None):
        e = dict(os.environ if environ is None else environ)
        self.environ = e
        self.home = Path(e.get("HOME") or os.path.expanduser("~"))
        self.dream = Path(e.get("DREAM_HOME") or self.home / ".claude/dream")
        self.local = self.dream / "local"
        self.state = self.dream / "state"
        self.conf = self.dream / "conf"
        self.prompts = self.dream / "prompts"
        self.cache = Path(e.get("DREAM_CACHE") or self.home / ".cache/dream")
        self.git_dir = Path(e.get("SETUP_SYNC_GIT_DIR") or self.home / ".claude-setup.git")
        self.claude = e.get("DREAM_CLAUDE_BIN") or str(self.home / ".local/bin/claude")
        self.lib = self.home / ".hermes/skills-library"
        self.patch = self.home / ".hermes/skills-library-local.patch"
        self.sync_sh = self.home / ".claude/setup/sync.sh"
        self.projects_dir = self.home / ".claude/projects"
        self.plans = self.home / ".hermes/plans"
        self.enforce_backlog = self.home / ".hermes/plans/claude-setup/enforce-backlog.md"

    def now(self):
        t = self.environ.get("DREAM_NOW")
        if t:
            d = datetime.datetime.fromisoformat(t)
            return d if d.tzinfo else d.astimezone()
        return datetime.datetime.now().astimezone()

    def rel(self, path):
        """$HOME-relative text of a path (absolute when it is outside $HOME)."""
        p = Path(path)
        try:
            return p.relative_to(self.home).as_posix()
        except ValueError:
            return p.as_posix()

    def real_rel(self, rel_or_abs):
        """The $HOME-relative real path (every link resolved) of a $HOME-relative or absolute path."""
        p = Path(rel_or_abs)
        if not p.is_absolute():
            p = self.home / p
        real = Path(os.path.realpath(p))
        home_real = Path(os.path.realpath(self.home))
        try:
            return real.relative_to(home_real).as_posix()
        except ValueError:
            return real.as_posix()

    def abs(self, rel):
        p = Path(rel)
        return p if p.is_absolute() else self.home / p

    def mode(self):
        """dry-run, live or off; dry-run whenever the mode file is missing or unreadable."""
        try:
            m = (self.local / "mode").read_text().strip()
        except OSError:
            return "dry-run"
        return m if m in ("dry-run", "live", "off") else "dry-run"


def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()


def sha256_file(path):
    try:
        return sha256_bytes(Path(path).read_bytes())
    except OSError:
        return None


def load_json(path, default):
    try:
        return json.loads(Path(path).read_text())
    except (OSError, ValueError):
        return default


def dump_json(obj):
    return json.dumps(obj, sort_keys=True, indent=1, ensure_ascii=False) + "\n"


def write_atomic(path, data):
    """Write bytes or text beside the target and rename it into place."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    if isinstance(data, str):
        data = data.encode()
    fd, tmp = tempfile.mkstemp(prefix=".dream-", dir=str(path.parent))
    try:
        with os.fdopen(fd, "wb") as f:
            f.write(data)
        if path.exists():
            os.chmod(tmp, path.stat().st_mode & 0o7777)
        os.replace(tmp, path)
    except BaseException:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def save_json(path, obj):
    write_atomic(path, dump_json(obj))


def glob_re(pattern):
    """A $HOME-relative glob as a regex: ** spans folders, * and ? stay inside one."""
    out, i = "", 0
    while i < len(pattern):
        c = pattern[i]
        if pattern.startswith("**/", i):
            out += "(?:.*/)?"
            i += 3
        elif pattern.startswith("**", i):
            out += ".*"
            i += 2
        elif c == "*":
            out += "[^/]*"
            i += 1
        elif c == "?":
            out += "[^/]"
            i += 1
        else:
            out += re.escape(c)
            i += 1
    return re.compile("^" + out + "$")


def glob_match(pattern, path):
    return bool(glob_re(pattern).match(path))


def read_conf_lines(path):
    """Non-empty, non-comment lines of a conf file."""
    try:
        text = Path(path).read_text()
    except OSError:
        return []
    return [ln for ln in text.splitlines() if ln.strip() and not ln.lstrip().startswith("#")]


def read_kv(path):
    out = {}
    for ln in read_conf_lines(path):
        if "=" in ln:
            k, v = ln.split("=", 1)
            out[k.strip()] = v.strip()
    return out


def read_tsv(path):
    return [ln.split("\t") for ln in read_conf_lines(path)]
