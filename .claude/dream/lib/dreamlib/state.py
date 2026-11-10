"""Markers per session (local/cursors.json), findings not yet live (local/unsettled.json) and the
synced state files (state/*.json). Rules: DREAM.md section 10; plan "One run", step 2.

A marker is {committed_line, extracted_line, uuid_at_extracted, line_sha, seen_uuids}: helpers already
read every line before extracted_line (their passing findings wait in unsettled.json), and every line
before committed_line is settled in a dream commit. The next read starts at extracted_line.
"""
import datetime
from pathlib import Path

from . import extract, paths, targets

ACTIVE_MINUTES = 30


class Scan:
    def __init__(self):
        self.reads = []      # SessionRead objects with new typed text (newest first)
        self.skipped = {}    # key -> "active" | "headless" | "no typed message"
        self.errors = []     # UnknownShape, one per session
        self.gone = []       # keys whose file no longer exists


def key_of(env, path):
    p = Path(path)
    return "%s/%s" % (p.parent.name, p.name)


def session_files(env):
    """Main-session transcripts only: ~/.claude/projects/*/*.jsonl (never subagents/)."""
    try:
        folders = sorted(d for d in env.projects_dir.iterdir() if d.is_dir())
    except OSError:
        return []
    out = []
    for d in folders:
        for f in sorted(d.glob("*.jsonl")):
            if f.is_file():
                out.append(f)
    return out


def load_cursors(env):
    return paths.load_json(env.local / "cursors.json", {})


def save_cursors(env, cursors):
    paths.save_json(env.local / "cursors.json", cursors)


def scan(env, cursors, now):
    s = Scan()
    files = session_files(env)
    present = {key_of(env, f) for f in files}
    s.gone = sorted(k for k in cursors if k not in present)
    for f in files:
        key = key_of(env, f)
        cur = cursors.get(key) or {}
        try:
            mtime = f.stat().st_mtime
        except OSError:
            continue
        if now.timestamp() - mtime < ACTIVE_MINUTES * 60:
            s.skipped[key] = "active"
            continue
        start = int(cur.get("extracted_line") or 0)
        expect = (cur.get("uuid_at_extracted"), cur.get("line_sha")) if start else None
        try:
            r = extract.read_session(f, start, cur.get("seen_uuids") or (), expect)
        except extract.UnknownShape as e:
            s.errors.append(e)
            continue
        r.key, r.folder, r.mtime = key, f.parent.name, mtime
        r.project = targets.project_of(env, r.folder)["name"]
        if r.headless:
            s.skipped[key] = "headless"
        elif not r.entries:
            s.skipped[key] = "no typed message"
        else:
            s.reads.append(r)
    s.reads.sort(key=lambda r: r.mtime, reverse=True)
    return s


def markers_after(read, used, cursor):
    """The marker once the helper read `used` (the first entries of read.entries): reading resumes at the
    first entry left for a later run, or at the end of the file."""
    cur = dict(cursor or {})
    used_ids = [e["uuid"] for e in used]
    rest = read.entries[len(used):]
    if rest:
        line = rest[0]["line"]
        uuid, sha = read.line_meta.get(line - 1, (None, None)) if line else (None, None)
    else:
        line, uuid, sha = read.lines_read, read.last_uuid, read.last_sha
    seen = list(dict.fromkeys(list(cur.get("seen_uuids") or []) + used_ids))
    cur.update({"extracted_line": line, "uuid_at_extracted": uuid, "line_sha": sha, "seen_uuids": seen})
    cur.setdefault("committed_line", 0)
    return cur


def commit_cursor(cur):
    """At the dream commit: everything extracted is settled."""
    cur = dict(cur)
    cur["committed_line"] = cur.get("extracted_line", 0)
    return cur


# ---------- findings not yet live, and the synced state ----------

def load_unsettled(env):
    u = paths.load_json(env.local / "unsettled.json", {})
    u.setdefault("findings", [])
    u.setdefault("orders", [])
    u.setdefault("list_items", [])
    u.setdefault("markers_after", {})
    u.setdefault("enforce_lines", [])
    u.setdefault("log", {})
    return u


def has_work(u):
    return bool(u.get("findings") or u.get("orders") or u.get("list_items") or u.get("markers_after")
                or u.get("enforce_lines") or u.get("tally") or u.get("pending"))


def save_unsettled(env, u):
    paths.save_json(env.local / "unsettled.json", u)


def load_state(env, name, default):
    return paths.load_json(env.state / (name + ".json"), default)


def default_tally():
    return {"backfill_done": False, "kinds": {}, "seen": [], "stories": {}, "story_seq": []}


def init(env, now):
    """First-time markers: a session with fewer than 3 typed messages starts at its end, so only the
    sessions with 3 or more are read (8 per run, newest first)."""
    cursors = load_cursors(env)
    n_end = n_read = n_bad = 0
    for f in session_files(env):
        key = key_of(env, f)
        if key in cursors:
            continue
        try:
            r = extract.read_session(f)
        except extract.UnknownShape:
            n_bad += 1
            continue
        if len(r.entries) < 3:
            cursors[key] = commit_cursor(markers_after(r, r.entries, {}))
            n_end += 1
        else:
            n_read += 1
    save_cursors(env, cursors)
    return n_end, n_read, n_bad
