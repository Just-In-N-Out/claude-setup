"""The write ledger (DREAM.md section 11): local/ledger.jsonl, one row {path, sha256, session, agent, time}
per write to a target. The hook ~/.claude/hooks/dream-ledger.sh adds rows for Claude Code's writes; the
dream adds its own (agent "dream"), a "baseline" row for a target it has never seen, and an
"unattributed" row once it has reported a change nobody recorded."""
import fcntl
import json
import subprocess

from . import paths, targets

MAX_BYTES = 5 * 1024 * 1024
KEEP_ROWS = 20000


def ledger_path(env):
    return env.local / "ledger.jsonl"


def last_rows(env):
    out = {}
    try:
        with open(ledger_path(env)) as f:
            for ln in f:
                try:
                    r = json.loads(ln)
                except ValueError:
                    continue
                if isinstance(r, dict) and r.get("path"):
                    out[r["path"]] = r
    except OSError:
        pass
    return out


def append(env, rows):
    if not rows:
        return
    p = ledger_path(env)
    p.parent.mkdir(parents=True, exist_ok=True)
    with open(p, "a+") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        for r in rows:
            f.write(json.dumps(r, sort_keys=True) + "\n")
        f.flush()
        if p.stat().st_size > MAX_BYTES:
            f.seek(0)
            keep = f.readlines()[-KEEP_ROWS:]
            f.seek(0)
            f.truncate()
            f.writelines(keep)


def row(path, sha, agent, now, session=""):
    return {"path": path, "sha256": sha, "session": session, "agent": agent, "time": now.isoformat(timespec="seconds")}


def git_info(env, rel):
    """What git knows about a change nobody recorded: the commit that brought it, or "uncommitted"."""
    if targets.is_library(rel):
        return "an edit in the library clone (it travels in skills-library-local.patch)"
    g = ["git", "--git-dir=%s" % env.git_dir, "--work-tree=%s" % env.home]
    try:
        st = subprocess.run(g + ["status", "--porcelain", "--", rel], capture_output=True, text=True,
                            cwd=str(env.home), env=env.environ)
        if st.stdout.strip():
            return "uncommitted"
        lg = subprocess.run(g + ["log", "-1", "--format=%h %s", "--", rel], capture_output=True, text=True,
                            cwd=str(env.home), env=env.environ)
        return lg.stdout.strip() or "not in the setup repo"
    except OSError:
        return "unknown (git failed)"


def check(env, now, write=True):
    """Targets whose sha256 differs from their last ledger row: each is reported once (a new row is
    written); a target never seen before only gets a baseline row."""
    rules = targets.load_rules(env)
    last = last_rows(env)
    rows, changed = [], []
    for rel in targets.all_target_files(env, rules):
        sha = paths.sha256_file(env.home / rel)
        prev = last.get(rel)
        if prev is None:
            rows.append(row(rel, sha, "baseline", now))
        elif prev.get("sha256") != sha:
            changed.append({"path": rel, "git": git_info(env, rel)})
            rows.append(row(rel, sha, "unattributed", now))
    if write:
        append(env, rows)
    return changed


def baseline(env, now):
    rules = targets.load_rules(env)
    last = last_rows(env)
    rows = [row(rel, paths.sha256_file(env.home / rel), "baseline", now)
            for rel in targets.all_target_files(env, rules) if rel not in last]
    append(env, rows)
    return len(rows)


def who_changed(env, rel):
    r = last_rows(env).get(rel)
    if not r:
        return "nobody recorded (no ledger row)"
    return "%s (session %s, agent %s, %s)" % (r.get("agent") or "?", (r.get("session") or "?")[:8],
                                              r.get("agent") or "-", r.get("time"))
