"""Step 8 of a run: apply, commit, push, and recovery from a run killed half way (plan "One run", step 8;
DREAM.md section 10). Also `dream undo` (DREAM.md section 14).

Live files change only here, under sync.sh's own lock, after a second pull, when every file still has the
bytes the copy was made from. The commit holds exactly the dream's paths and is pushed by sync.sh.
"""
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

from . import ledger, log, mistakes, paths, state, targets

LOCK_TRIES = 8
STALE_SECONDS = 600


class Stop(Exception):
    pass


# ---------- git ----------

def g(env, *args, check=False, input=None):
    return subprocess.run(["git", "-c", "core.quotePath=false", "--git-dir=%s" % env.git_dir,
                           "--work-tree=%s" % env.home] + list(args), cwd=str(env.home), env=env.environ,
                          capture_output=True, text=True, input=input, check=check)


def library_local_commits(env):
    if not (env.lib / ".git").exists():
        return 0
    p = subprocess.run(["git", "-C", str(env.lib), "rev-list", "--count", "HEAD", "--not", "--remotes"],
                       capture_output=True, text=True, env=env.environ)
    try:
        return int(p.stdout.strip() or 0)
    except ValueError:
        return 1


def library_diff(env):
    return subprocess.run(["git", "-C", str(env.lib), "diff"], capture_output=True, text=True,
                          env=env.environ).stdout


def git_commit(env, message):
    """Plain `git commit -F -`: the repo's own identity and the githooks apply as for any commit."""
    return g(env, "commit", "-q", "-F", "-", input=message)


def write_live(path, data):
    paths.write_atomic(path, data)


# ---------- the lock sync.sh uses ----------

def take_lock(env, wait):
    lock = env.git_dir / "setup-sync.lock"
    for i in range(LOCK_TRIES):
        try:
            os.mkdir(lock)  # atomic, unlike uutils mkdir
            (lock / "dream.pid").write_text(str(os.getpid()))
            return lock
        except FileExistsError:
            if _stale(lock):
                shutil.rmtree(lock, ignore_errors=True)
                continue
            if i < LOCK_TRIES - 1:
                time.sleep(wait)
    raise Stop("another sync kept the setup repo locked (%s)" % lock)


def _stale(lock):
    try:
        pid = int((lock / "dream.pid").read_text())
        os.kill(pid, 0)
        return False
    except ProcessLookupError:
        return True
    except (OSError, ValueError):
        pass
    try:
        return time.time() - lock.stat().st_mtime > STALE_SECONDS
    except OSError:
        return False


def drop_lock(lock):
    if lock:
        shutil.rmtree(lock, ignore_errors=True)


def clear_dead_dream_lock(env):
    """A killed dream leaves sync.sh's lock behind, and every sync would wait 10 minutes for it: remove it
    when it is the dream's own (it holds dream.pid) and that process is gone. sync.sh's lock is never touched."""
    lock = env.git_dir / "setup-sync.lock"
    try:
        pid = int((lock / "dream.pid").read_text())
    except (OSError, ValueError):
        return False
    try:
        os.kill(pid, 0)
        return False
    except ProcessLookupError:
        shutil.rmtree(lock, ignore_errors=True)
        return True
    except OSError:
        return False


# ---------- the plan ----------

class Plan:
    def __init__(self):
        self.writes = []         # {path (absolute), rel, data (bytes), kind, copy_sha}
        self.log_text = ""
        self.settled = []        # finding ids applied, already saved or declined
        self.markers_after = {}
        self.orders_done = []
        self.commit_msg = ""
        self.has_library = False
        self.diffs = []
        self.last_run = {}

    def target_files(self):
        return [w["rel"] for w in self.writes if w["kind"] in ("target", "library")]

    def diff_text(self):
        out = []
        for d in self.diffs:
            out.append(d.unified)
        for w in self.writes:
            if w["kind"] in ("dream", "backlog"):
                import difflib
                try:
                    old = Path(w["path"]).read_text()
                except OSError:
                    old = ""
                out.append("".join(difflib.unified_diff(old.splitlines(True), w["data"].decode().splitlines(True),
                                                        "a/" + w["rel"], "b/" + w["rel"], n=1)))
        return "".join(out)


def project_paths(env):
    """name -> this machine's project folder, for projects whose CLAUDE.md is synced (setup projects.tsv)."""
    col = env.environ.get("SETUP_SYNC_PATH_COL") or ("2" if sys.platform == "darwin" else "3")
    out = {}
    for row in paths.read_tsv(env.home / ".claude/setup/projects.tsv"):
        if len(row) >= 5 and row[4].strip() == "yes":
            out[row[0]] = Path(row[int(col) - 1])
    return out


def make_plan(R, unsettled, mapping, diffs, changes, tally, pending, cursors):
    env = R.env
    P = Plan()
    P.diffs = diffs
    projects = project_paths(env)
    for d in diffs:
        m = mapping.get(d.copy)
        rel = m["live"] if m else d.live
        kind = "library" if targets.is_library(rel) else "target"
        P.writes.append({"path": str(env.home / rel), "rel": rel, "data": d.new.encode(), "kind": kind,
                         "copy_sha": m["sha"] if m else None, "old": d.old.encode() if m else None})
        if kind == "library":
            P.has_library = True
        if rel.startswith(".claude/project-docs/") and rel.endswith("/CLAUDE.md"):
            name = rel.split("/")[2]
            pdir = projects.get(name)
            if pdir and pdir.is_dir():
                P.writes.append({"path": str(pdir / "CLAUDE.md"), "rel": str(pdir / "CLAUDE.md"),
                                 "data": d.new.encode(), "kind": "project", "copy_sha": None,
                                 "must_equal": rel, "old": d.old.encode() if m else None})
    applied_ids = [i for c in changes.get("changes") or [] for i in (c.get("finding_ids") or [])
                   if any(f["id"] == i for f in unsettled["findings"])]
    saved = [s.get("finding_id") for s in changes.get("already_saved") or []]
    declined = changes.get("declined") or []
    by_id = {f["id"]: f for f in unsettled["findings"]}
    from . import bar
    list_items = list(unsettled.get("list_items") or [])
    for x in declined:
        f = by_id.get(x.get("finding_id"))
        if f:
            list_items.append(bar.list_item(f, "the editor declined it: %s" % x.get("reason", ""), kind="question"))
    P.settled = sorted(set(applied_ids) | set(i for i in saved if i in by_id) |
                       set(x.get("finding_id") for x in declined if x.get("finding_id") in by_id))
    P.orders_done = [o for o in unsettled.get("orders") or []]
    P.markers_after = dict(unsettled.get("markers_after") or {})
    tally_after = json.loads(json.dumps(tally))
    mistakes.after_commit(tally_after, P.orders_done, R.now)
    applied = state.load_state(env, "applied", {"ids": []})
    applied["ids"] = sorted(set(applied.get("ids", [])) | set(P.settled) | set(unsettled.get("parked_ids") or []))
    trend = state.load_state(env, "trend", {"runs": []})
    lg = unsettled.get("log") or {}
    projs = {}
    for p, n in (lg.get("typed") or {}).items():
        projs[p] = {"typed": n, "corrections": (lg.get("corrections") or {}).get(p, 0)}
    if projs:
        trend.setdefault("runs", []).append({"run": R.id, "time": R.now.isoformat(timespec="minutes"), "projects": projs})
    dream = env.dream
    P.log_text = log.entry(R, unsettled, P, changes, list_items, lg, cursors)
    main_log, archives = log.rotate(log.read(env), R.now)
    for name, text in archives.items():
        P.writes.append(_dream_write(env, dream / name, text.encode()))
    P.writes.append(_dream_write(env, dream / "dream-log.md", (main_log + P.log_text).encode()))
    for name, obj in (("pending", pending), ("tally", tally_after), ("applied", applied), ("trend", trend)):
        P.writes.append(_dream_write(env, dream / "state" / (name + ".json"), paths.dump_json(obj).encode()))
    if list_items:
        P.writes.append(_dream_write(env, dream / "justin-list.md", (log.read_list(env) + log.list_lines(list_items)).encode()))
    lines = [ln for ln in unsettled.get("enforce_lines") or []]
    if lines:
        try:
            cur = env.enforce_backlog.read_text()
        except OSError:
            cur = "# Enforce backlog\n\n"
        if cur and not cur.endswith("\n"):
            cur += "\n"
        w = _dream_write(env, env.enforce_backlog, (cur + "\n".join(lines) + "\n").encode())
        w["kind"] = "backlog"
        P.writes.append(w)
    n_files = len(P.target_files())
    P.commit_msg = "dream(%s): %d file(s), %d finding(s) [run %s]\n\n%s\n" % (
        R.now.strftime("%Y-%m-%d %H:%M"), n_files, len(P.settled), R.id,
        "\n".join("- " + r for r in P.target_files()) or "- (log and state only)")
    P.list_items = list_items
    return P


def _dream_write(env, path, data):
    return {"path": str(path), "rel": env.rel(path), "data": data, "kind": "dream", "copy_sha": None}


# ---------- apply ----------

def git_paths(env, P):
    out = []
    for w in P.writes:
        if w["kind"] in ("target", "dream", "backlog"):
            out.append(w["rel"])
    if P.has_library:
        out.append(env.rel(env.patch))
    return out


def preconditions(R, P):
    env = R.env
    for w in P.writes:
        if w["kind"] in ("target", "library"):
            cur = paths.sha256_file(w["path"])
            if cur != w["copy_sha"]:
                raise Stop("%s changed since the copy was made (%s); nothing was written"
                           % (w["rel"], ledger.who_changed(env, w["rel"])))
    tgt = [w["rel"] for w in P.writes if w["kind"] == "target"]
    if tgt:
        st = g(env, "status", "--porcelain", "--", *tgt).stdout
        if st.strip():
            raise Stop("uncommitted edits by someone else in %s" % ", ".join(ln[3:] for ln in st.splitlines()))
    for w in P.writes:
        if w["kind"] == "project":
            live_copy = (env.home / w["must_equal"]).read_bytes()
            try:
                own = Path(w["path"]).read_bytes()
            except OSError:
                own = None
            if own != live_copy:
                raise Stop("the project's own %s differs from its synced copy %s; nothing was written"
                           % (w["path"], w["must_equal"]))
    if P.has_library:
        if library_local_commits(env):
            raise Stop("the library clone has a local commit")
        staged = subprocess.run(["git", "-C", str(env.lib), "diff", "--cached", "--name-only"],
                                capture_output=True, text=True, env=env.environ).stdout
        if staged.strip():
            raise Stop("the library clone has staged changes")
        try:
            patch = env.patch.read_text()
        except OSError:
            patch = ""
        if library_diff(env) != patch:
            raise Stop("the library clone's edits differ from skills-library-local.patch; run sync.sh first")


def journal_path(env):
    return env.local / "apply-journal.json"


def apply(R, P):
    """Returns the run's exit code."""
    from .run import pull, stop as run_stop, write_last_run
    env = R.env
    rc = pull(R)
    if rc:
        return rc
    lock = None
    unsettled = state.load_unsettled(env)
    try:
        lock = take_lock(env, R.lock_wait())
        preconditions(R, P)
        before = R.dir / "before"
        before.mkdir(parents=True, exist_ok=True)
        files = []
        for i, w in enumerate(P.writes):
            p = Path(w["path"])
            old = p.read_bytes() if p.exists() else None
            if old is not None:
                (before / str(i)).write_bytes(old)
            files.append({"path": w["path"], "before_sha": paths.sha256_bytes(old) if old is not None else None,
                          "after_sha": paths.sha256_bytes(w["data"]), "kind": w["kind"], "rel": w["rel"]})
        if P.has_library:
            files.append({"path": str(env.patch), "before_sha": paths.sha256_file(env.patch), "after_sha": None,
                          "kind": "patch", "rel": env.rel(env.patch), "derived": True})
            if env.patch.exists():
                (before / "patch").write_bytes(env.patch.read_bytes())
        J = {"run": R.id, "stage": "applying", "files": files, "before_dir": str(before),
             "markers_after": P.markers_after, "settled": P.settled, "git_paths": git_paths(env, P),
             "commit_msg": P.commit_msg, "last_run": _last_run(R, P)}
        paths.save_json(journal_path(env), J)
        for w in P.writes:
            write_live(w["path"], w["data"])
        if P.has_library:
            patch = library_diff(env).encode()
            files[-1]["after_sha"] = paths.sha256_bytes(patch)
            paths.save_json(journal_path(env), J)
            write_live(str(env.patch), patch)
        ledger.append(env, [ledger.row(w["rel"], paths.sha256_bytes(w["data"]), "dream", R.now, R.id)
                            for w in P.writes if w["kind"] in ("target", "library", "project")])
        held, lock = lock, None  # finish() gives the lock back before sync.sh runs
        return finish(R, J, held)
    except Stop as e:
        drop_lock(lock)
        lock = None
        return run_stop(R, unsettled, str(e), tries=False)
    finally:
        drop_lock(lock)


def _last_run(R, P):
    return {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": "live",
            "result": "changed" if P.target_files() else "nothing-changed", "reason": "",
            "files": len(P.target_files()), "findings": len(P.settled), "push_pending": False,
            "unreadable": R.facts["unreadable"]}


def restore(J, which):
    before = Path(J["before_dir"])
    for i, f in enumerate(J["files"]):
        if i not in which:
            continue
        src = before / ("patch" if f.get("derived") else str(i))
        if f["before_sha"] is None:
            try:
                os.unlink(f["path"])
            except OSError:
                pass
        elif src.exists():
            write_live(f["path"], src.read_bytes())


def finish(R, J, lock):
    """Sub-steps 5 to 7: stage exactly the dream's paths, commit, move the markers, push."""
    from .run import stop as run_stop, write_last_run
    env = R.env
    gp = J["git_paths"]
    g(env, "add", "--", *gp)
    staged = set(g(env, "diff", "--cached", "--name-only").stdout.split("\n")) - {""}
    foreign = sorted(staged - set(gp))
    if foreign:
        g(env, "reset", "-q", "--", *gp)
        restore(J, set(range(len(J["files"]))))
        os.unlink(journal_path(env))
        drop_lock(lock)
        return run_stop(R, state.load_unsettled(env), "someone else staged %s in the setup repo while the dream held "
                                                       "the lock; the dream's own files were restored" % ", ".join(foreign),
                        tries=False)
    c = git_commit(env, J["commit_msg"])
    if c.returncode != 0:
        g(env, "reset", "-q", "--", *gp)
        restore(J, set(range(len(J["files"]))))
        os.unlink(journal_path(env))
        drop_lock(lock)
        return run_stop(R, state.load_unsettled(env), "git commit failed: %s" % (c.stderr or c.stdout).strip()[-300:],
                        tries=False)
    J["stage"] = "committed"
    paths.save_json(journal_path(env), J)
    return after_commit(R, J, lock)


def after_commit(R, J, lock):
    from .run import write_last_run
    env = R.env
    cursors = state.load_cursors(env)
    for k, cur in (J.get("markers_after") or {}).items():
        cursors[k] = state.commit_cursor(cur)
    state.save_cursors(env, cursors)
    u = state.load_unsettled(env)
    settled = set(J.get("settled") or [])
    left = [f for f in u.get("findings", []) if f["id"] not in settled]
    state.save_unsettled(env, {"findings": left, "orders": [], "list_items": [], "markers_after": {},
                               "enforce_lines": [], "log": {}, "parked_ids": []})
    sha = g(env, "rev-parse", "--short", "HEAD").stdout.strip()
    lr = dict(J["last_run"], commit=sha, list_open=log.list_open(env))
    write_last_run(env, lr)
    os.unlink(journal_path(env))
    drop_lock(lock)
    push(R, J, lr)
    return 0


def push(R, J, lr):
    """sync.sh pushes (it rebases on GitHub first). A failure leaves the commit for the next sync."""
    from .run import write_last_run
    env = R.env
    p = subprocess.run(["bash", str(env.sync_sh)], capture_output=True, text=True, cwd=str(env.home), env=env.environ)
    on_remote = g(env, "merge-base", "--is-ancestor", "HEAD", "refs/remotes/origin/main").returncode == 0
    sha = g(env, "log", "-1", "--format=%h", "--grep", "[run %s]" % J["run"], "--fixed-strings").stdout.strip()
    lr["commit"] = sha or lr.get("commit")
    if p.returncode != 0 or not on_remote:
        lr["push_pending"] = True
        why = (p.stdout + p.stderr).strip().splitlines()[-1:] or ["no output"]
        with open(env.dream / "dream-log.md", "a") as f:
            f.write("- %s: push pending (%s); the next sync.sh pushes commit %s.\n"
                    % (R.now.strftime("%Y-%m-%d %H:%M"), why[0][:200], lr["commit"]))
    write_last_run(env, lr)


# ---------- recovery ----------

def recover(R):
    """A journal left by a killed run: finish its commit when every file has its new bytes, else put back
    every file it changed (leaving alone, and naming, any file someone edited in between). Returns None to
    go on with the run, or an exit code."""
    from .run import write_last_run
    env = R.env
    J = paths.load_json(journal_path(env), None)
    if not isinstance(J, dict):
        os.unlink(journal_path(env))
        return None
    if J.get("stage") == "committed":
        after_commit(R, J, None)
        return None
    status = []
    for f in J["files"]:
        cur = paths.sha256_file(f["path"])
        status.append("after" if f.get("after_sha") and cur == f["after_sha"] else
                      "before" if cur == f["before_sha"] else "other")
    if all(s == "after" for s in status):
        rc = finish(R, J, take_lock(env, R.lock_wait()))
        return None if rc == 0 else rc
    restore(J, {i for i, s in enumerate(status) if s == "after"})
    others = [f["rel"] for f, s in zip(J["files"], status) if s == "other"]
    os.unlink(journal_path(env))
    reason = "an unfinished apply of run %s was undone: every file it had written is back to its old bytes" % J["run"]
    if others:
        reason += "; left alone because someone edited them since: %s" % ", ".join(others)
    write_last_run(env, {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": R.mode,
                         "result": "stopped", "reason": reason, "commit": None, "files": 0, "findings": 0,
                         "list_open": log.list_open(env), "push_pending": False})
    print("dream: %s" % reason, file=sys.stderr)
    return 3


# ---------- dream undo ----------

def undo(env, commit):
    sha = g(env, "rev-parse", "--verify", "-q", commit + "^{commit}").stdout.strip()
    if not sha:
        print("dream undo: %s is not a commit of the setup repo" % commit, file=sys.stderr)
        return 2
    subject = g(env, "log", "-1", "--format=%s", sha).stdout.strip()
    if not subject.startswith("dream("):
        print("dream undo: %s is not a dream commit (%s)" % (sha[:8], subject), file=sys.stderr)
        return 2
    changed = [x for x in g(env, "show", "--name-only", "--format=", sha).stdout.splitlines() if x]
    lock = None
    try:
        lock = take_lock(env, float(env.environ.get("DREAM_LOCK_WAIT", "15")))
        r = g(env, "revert", "--no-edit", sha)
        if r.returncode != 0:
            g(env, "revert", "--abort")
            print("dream undo: the revert did not apply cleanly; nothing changed:\n%s" % (r.stderr or r.stdout),
                  file=sys.stderr)
            return 1
        if env.rel(env.patch) in changed and (env.lib / ".git").exists():
            subprocess.run(["git", "-C", str(env.lib), "checkout", "-q", "--", "."], env=env.environ)
            if env.patch.exists() and env.patch.stat().st_size:
                subprocess.run(["git", "-C", str(env.lib), "apply", "--whitespace=nowarn", str(env.patch)],
                               env=env.environ)
        projects = project_paths(env)
        for rel in changed:
            if rel.startswith(".claude/project-docs/") and rel.endswith("/CLAUDE.md"):
                pdir = projects.get(rel.split("/")[2])
                if pdir and pdir.is_dir() and (env.home / rel).exists():
                    shutil.copyfile(env.home / rel, pdir / "CLAUDE.md")
        now = env.now()
        rows = []
        for rel in changed:
            if (env.home / rel).exists():
                rows.append(ledger.row(rel, paths.sha256_file(env.home / rel), "dream-undo", now))
        if env.local.is_dir():
            ledger.append(env, rows)
    finally:
        drop_lock(lock)
    new = g(env, "rev-parse", "--short", "HEAD").stdout.strip()
    print("dream undo: reverted %s as %s (%d file(s)); pushing with sync.sh" % (sha[:8], new, len(changed)))
    p = subprocess.run(["bash", str(env.sync_sh)], capture_output=True, text=True, cwd=str(env.home), env=env.environ)
    if p.returncode != 0:
        print("dream undo: sync.sh failed; the revert is committed here and goes up on the next sync", file=sys.stderr)
    return 0
