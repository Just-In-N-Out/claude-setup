"""One dream run, step by step (plan "One run"; rules: DREAM.md section 10), and the `dream` command.

Exit codes of run(): 0 nothing new or the run completed (a dry run too), 3 a guard (or the checker, or
the editor) stopped it with nothing live, 4 an environment failure (pull conflict, GitHub unreachable,
login, every new session of an unknown shape, a missing CLI flag).
"""
import fcntl
import json
import shutil
import subprocess
import sys
import time
from pathlib import Path

from . import agents, apply, bar, extract, guards, ledger, log, mistakes, paths, state, targets

MAX_HELPERS = 8
REVIEW_LINES = 150
PULL_TRIES = 8
KEEP_DAYS = 14


class Ctx:
    """What one run knows: its id and folder, mode, the calls it made, the facts its log entry needs."""

    def __init__(self, env, mode, hooks):
        self.env, self.mode, self.hooks = env, mode, hooks
        self.now = env.now()
        self.id = self.now.strftime("%Y%m%d-%H%M%S")
        self.dir = env.cache / self.id
        self.dir.mkdir(parents=True, exist_ok=True)
        self.calls = []
        self.facts = {"sessions": [], "dropped": [], "list": [], "unattributed": [], "format_errors": [],
                      "typed": {}, "corrections": {}, "already_saved": 0, "masked": 0, "review_lines": 0,
                      "pending_expired": [], "notes": [], "unreadable": [], "skipped_lines": []}

    def lock_wait(self):
        return float(self.env.environ.get("DREAM_LOCK_WAIT", "15"))


def write_last_run(env, d):
    paths.save_json(env.local / "last-run.json", d)


def fail(R, reason, rc=4):
    write_last_run(R.env, {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": R.mode,
                           "result": "failed", "reason": reason, "commit": None, "files": 0, "findings": 0,
                           "list_open": log.list_open(R.env), "push_pending": False,
                           "unreadable": R.facts["unreadable"]})
    print("dream: %s" % reason, file=sys.stderr)
    return rc


def clear_failure(R):
    """A run that found nothing new succeeded: a failed or stopped run shown at every session start is
    cleared (R1-12, AC31). With no failure to clear, it writes nothing (AC4)."""
    lr = paths.load_json(R.env.local / "last-run.json", None)
    if isinstance(lr, dict) and lr.get("result") in ("failed", "stopped"):
        write_last_run(R.env, {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": R.mode,
                               "result": "nothing-new", "reason": "", "cleared": lr.get("run"), "commit": None,
                               "files": 0, "findings": 0, "list_open": log.list_open(R.env), "push_pending": False})


def preflight(R):
    env = R.env
    user = env.environ.get("SETUP_SYNC_GH_USER", "Just-In-N-Out")
    try:
        p = subprocess.run(["gh", "auth", "token", "--user", user], capture_output=True, text=True,
                           env=env.environ, timeout=60)
        if p.returncode != 0:
            return "gh has no login for %s (gh auth token --user %s failed)" % (user, user)
    except (OSError, subprocess.TimeoutExpired):
        return "gh is not installed or did not answer"
    missing = agents.missing_flags(env)
    if missing:
        return "claude --help no longer lists %s; the dream's isolation needs every one" % ", ".join(missing)
    n = apply.library_local_commits(env)
    if n:
        return "the library clone %s has %d local commit(s); the dream never commits there" % (env.lib, n)
    return None


def pull(R):
    """sync.sh pull; it commits other sessions' pending edits as their own sync(<host>) commit first."""
    for i in range(PULL_TRIES):
        p = subprocess.run(["bash", str(R.env.sync_sh), "pull"], capture_output=True, text=True,
                           cwd=str(R.env.home), env=R.env.environ)
        out = p.stdout + p.stderr
        if "another sync is running" in out and i < PULL_TRIES - 1:
            time.sleep(R.lock_wait())
            continue
        if "CONFLICT" in out:
            return fail(R, "sync.sh pull reported a CONFLICT; merge it by hand, then the next run continues")
        if p.returncode != 0:
            return fail(R, "sync.sh pull failed (exit %d): %s" % (p.returncode, out.strip()[-300:]))
        if "GitHub unreachable" in out:
            return fail(R, "GitHub unreachable at the pull; nothing was read")
        return 0
    return fail(R, "another sync kept the setup repo locked")


def merge_findings(old, new):
    ids = {f["id"] for f in old}
    return old + [f for f in new if f["id"] not in ids]


def _run(env, mode, hooks):
    if mode == "off":
        return 0
    R = Ctx(env, mode, hooks)
    apply.clear_dead_dream_lock(env)
    if (env.local / "apply-journal.json").exists():
        rc = apply.recover(R)
        if rc is not None:
            return rc
    why = preflight(R)
    if why:
        return fail(R, why)
    if mode == "live":
        rc = pull(R)
        if rc:
            return rc

    # step 2: extract, no model
    R.facts["unattributed"] = ledger.check(env, R.now, write=(mode == "live"), record_unattributed=False)
    cursors = state.load_cursors(env)
    unsettled = state.load_unsettled(env)
    # lines whose findings already wait in unsettled.json are not read again (their helpers ran)
    eff = dict(cursors)
    eff.update(unsettled.get("markers_after") or {})
    sc = state.scan(env, eff, R.now)
    R.facts["format_errors"] = [str(e) for e in sc.errors]
    R.facts["unreadable"] = [e.session for e in sc.errors]
    tally = unsettled.get("tally") or state.load_state(env, "tally", state.default_tally())
    lines = extract.review_lines(env, tally.get("seen", []))
    # an unreadable session stops only a run that has nothing else to do (ruling R1-1): new review lines
    # and findings waiting from an earlier run go on, and the session shows in the session-start line
    if sc.errors and not sc.reads and not lines and not state.has_work(unsettled):
        return fail(R, "every session with new lines has an unknown transcript shape: " + "; ".join(
            R.facts["format_errors"][:3]))
    if not sc.reads and not lines and not state.has_work(unsettled):
        shutil.rmtree(R.dir, ignore_errors=True)
        clear_failure(R)
        return 0

    # steps 3 and 4: helpers, then the bar
    pending = unsettled.get("pending") or state.load_state(env, "pending", {"candidates": {}})
    applied = set(state.load_state(env, "applied", {"ids": []}).get("ids", []))
    jobs = []
    for r in sc.reads[:MAX_HELPERS]:
        R.facts["skipped_lines"] += ["session %s, line %d (NUL bytes a freeze left)" % (r.session, n)
                                     for n in r.freeze_lines]
        R.facts["masked"] += extract.scrub_entries(r.entries, env)
        digest, used = extract.render_digest(r.session, r.project, r.entries)
        jobs.append((r, digest, used))
    results = agents.session_helpers(R, jobs, pending)
    if any(res.fatal for res in results):
        return fail(R, next(res.error for res in results if res.fatal))
    for (r, digest, used), res in zip(jobs, results):
        info = {"session": r.session, "project": r.project, "entries": len(used), "findings": 0, "passed": 0}
        R.facts["sessions"].append(info)
        if not res.ok:
            R.facts["dropped"].append("helper for session %s failed (%s); read again next run" % (r.session[:8], res.error))
            continue
        b = bar.check(env, r, used, res.data.get("findings") or [], pending, applied, R.now)
        info["findings"], info["passed"] = b.total, len(b.passed)
        R.facts["dropped"] += b.dropped
        if b.discarded:
            continue
        unsettled["findings"] = merge_findings(unsettled["findings"], b.passed)
        unsettled["list_items"] += b.list_items
        unsettled["markers_after"][r.key] = state.markers_after(r, used, eff.get(r.key))
        t = unsettled["log"].setdefault("typed", {})
        t[r.project] = t.get(r.project, 0) + len(used)
        c = unsettled["log"].setdefault("corrections", {})
        c[r.project] = c.get(r.project, 0) + b.corrections
        unsettled["log"].setdefault("sessions", []).append(info)
    R.facts["pending_expired"] = bar.expire(pending, R.now)
    if lines:
        backfill = not tally.get("backfill_done")
        given, assigns, ok = agents.review_helpers(R, lines, tally, backfill, REVIEW_LINES)
        if any(x.fatal for x in ok):
            return fail(R, next(x.error for x in ok if x.fatal))
        unsettled["enforce_lines"] += mistakes.record(env, tally, given, assigns, R.now)
        R.facts["review_lines"] = len(given)
        if backfill and all(x.ok for x in ok):
            tally["backfill_done"] = True
    unsettled["pending"], unsettled["tally"] = pending, tally
    unsettled["orders"] = mistakes.merge_orders(unsettled.get("orders", []), mistakes.orders(env, tally))
    if mode == "live":
        state.save_unsettled(env, unsettled)

    # step 5: findings that failed twice go to Justin's list; then the editor on a copy
    parked = [f for f in unsettled["findings"] if f.get("tries", 0) >= 2]
    parked_orders = [o for o in unsettled["orders"] if o.get("tries", 0) >= 2]
    for f in parked:
        unsettled["list_items"].append(bar.list_item(f, "could not apply automatically after two tries"))
    for o in parked_orders:
        unsettled["list_items"].append(mistakes.order_list_item(o))
        tally["kinds"].get(o["kind"], {})["parked"] = True
    unsettled["findings"] = [f for f in unsettled["findings"] if f.get("tries", 0) < 2]
    unsettled["orders"] = [o for o in unsettled["orders"] if o.get("tries", 0) < 2]
    unsettled["parked_ids"] = sorted(set(unsettled.get("parked_ids") or []) | {f["id"] for f in parked})
    if mode == "live" and (parked or parked_orders):
        state.save_unsettled(env, unsettled)
    findings, orders = unsettled["findings"], unsettled["orders"]
    rules = targets.load_rules(env)
    mapping, diffs, links, changes = {}, [], [], {"changes": [], "already_saved": [], "declined": []}
    if findings or orders:
        files = targets.files_for(env, rules, findings, orders)
        mapping = targets.build_copy(env, R.dir, files)
        agents.write_editor_inputs(R, mapping, findings, orders)
        res = agents.editor(R)
        if res.fatal:
            return fail(R, res.error)
        if not res.ok:
            return stop(R, unsettled, "the editor call failed: %s" % res.error)
        if res.denials:
            return stop(R, unsettled, "the editor tried to leave its folder (%d permission denial(s))" % len(res.denials))
        changes, problem = agents.read_changes(R)
        if changes is None:
            return stop(R, unsettled, "the editor wrote no readable _dream/changes.json (%s)" % problem)
        mistakes.normalize_copy(env, R.dir, mapping, tally, orders)
        diffs, links = targets.diff_copy(R.dir)
        if diffs:
            res = agents.checker(R, diffs, findings, orders, changes)
            if res.fatal:
                return fail(R, res.error)
            if not res.ok:
                return stop(R, unsettled, "the checker call failed: %s" % res.error)
            if res.data.get("verdict") != "yes":
                return stop(R, unsettled, "the checking agent said no: %s" % (res.data.get("notes") or "")[:300])

    # step 7: guards, no model
    G = guards.Input(env, R.dir, mapping, diffs, links, findings, orders, changes, tally, rules)
    failures = guards.run_all(G)
    if failures:
        return stop(R, unsettled, "guards: " + "; ".join(failures))
    R.facts["already_saved"] = len(changes.get("already_saved") or [])

    # step 8: the log entry (scanned too), then dry run or apply
    plan = apply.make_plan(R, unsettled, mapping, diffs, changes, tally, pending, cursors)
    leaks = guards.log_secrets(env, plan.log_text)
    if leaks:
        return stop(R, unsettled, "guards: " + "; ".join(leaks))
    if mode != "live":
        return dry_run(R, plan)
    rc = apply.apply(R, plan)
    prune(env)
    return rc


def stop(R, unsettled, reason, tries=True):
    """Nothing goes live and the markers stay. A stop in steps 5 to 7 gives every finding and order waiting
    one more try; a stop in the apply step (tries=False) leaves them as they were (R1-5, AC19)."""
    if R.mode == "live":
        if tries:
            for f in unsettled.get("findings", []):
                f["tries"] = f.get("tries", 0) + 1
            for o in unsettled.get("orders", []):
                o["tries"] = o.get("tries", 0) + 1
            state.save_unsettled(R.env, unsettled)
        log.append_stop(R.env, R, reason)
    write_last_run(R.env, {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": R.mode,
                           "result": "stopped", "reason": reason, "commit": None, "files": 0,
                           "findings": len(unsettled.get("findings", [])), "list_open": log.list_open(R.env),
                           "push_pending": False, "unreadable": R.facts["unreadable"]})
    print("dream: stopped, nothing went live: %s" % reason, file=sys.stderr)
    return 3


def dry_run(R, plan):
    """Dry-run mode stops before the apply step: the would-be diff and log entry, nothing live."""
    (R.dir / "would-apply.diff").write_text(plan.diff_text())
    (R.dir / "would-log-entry.md").write_text(plan.log_text)
    write_last_run(R.env, {"run": R.id, "time": R.now.isoformat(timespec="minutes"), "mode": "dry-run",
                           "result": "dry-run", "reason": "", "commit": None, "files": len(plan.target_files()),
                           "findings": len(plan.settled), "list_open": log.list_open(R.env), "push_pending": False,
                           "diff": str(R.dir / "would-apply.diff"), "unreadable": R.facts["unreadable"]})
    return 0


def prune(env):
    cutoff = time.time() - KEEP_DAYS * 86400
    try:
        for d in env.cache.iterdir():
            if d.is_dir() and d.stat().st_mtime < cutoff:
                shutil.rmtree(d, ignore_errors=True)
    except OSError:
        pass


def run(env, mode=None, hooks=None):
    if not env.local.is_dir():
        print("dream: %s does not exist, so this is not a dream machine (see dream install)" % env.local,
              file=sys.stderr)
        return 4
    lockf = open(env.local / "run.lock", "a")
    try:
        try:
            fcntl.flock(lockf, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            print("dream: another run is going; this one exits", file=sys.stderr)
            return 0
        try:
            return _run(env, mode or env.mode(), hooks or {})
        except Exception as e:
            # anything unexpected still reaches the session-start line, then the traceback goes to the log
            now = env.now()
            write_last_run(env, {"run": now.strftime("%Y%m%d-%H%M%S"), "time": now.isoformat(timespec="minutes"),
                                 "mode": mode or env.mode(), "result": "failed", "commit": None, "files": 0,
                                 "findings": 0, "list_open": log.list_open(env), "push_pending": False,
                                 "reason": "the dream crashed (%s: %s); see journalctl --user -u dream"
                                           % (type(e).__name__, str(e)[:200])})
            raise
    finally:
        lockf.close()


# ---------- the command line ----------

def main(argv, doc=""):
    env = paths.Env()
    cmd = argv[0] if argv else "help"
    rest = argv[1:]
    if cmd == "run":
        if sys.stdout.isatty():
            print("dream: started by hand, without the memory cap; `systemctl --user start dream.service` has it",
                  file=sys.stderr)
        mode = "dry-run" if "--dry-run" in rest else "live" if "--live" in rest else None
        return run(env, mode)
    if cmd == "status":
        return status(env)
    if cmd == "mode" and len(rest) == 1 and rest[0] in ("dry-run", "live", "off"):
        if not env.local.is_dir():
            print("dream: no %s here (dream install first)" % env.local, file=sys.stderr)
            return 4
        paths.write_atomic(env.local / "mode", rest[0] + "\n")
        print("dream: mode is now %s" % rest[0])
        return 0
    if cmd == "install":
        return install(env, enable="--enable" in rest)
    if cmd == "uninstall":
        return uninstall(env)
    if cmd == "undo" and len(rest) == 1:
        return apply.undo(env, rest[0])
    if cmd == "init":
        if not env.local.is_dir():
            print("dream: no %s here (dream install first)" % env.local, file=sys.stderr)
            return 4
        n_end, n_read, n_bad = state.init(env, env.now())
        n_led = ledger.baseline(env, env.now())
        print("dream: markers set at the end of %d session(s) with fewer than 3 typed messages; %d will be read; "
              "%d of an unknown shape; %d ledger baseline row(s)" % (n_end, n_read, n_bad, n_led))
        return 0
    if cmd == "extract" and len(rest) == 1:
        try:
            r = extract.read_session(rest[0])
            extract.scrub_entries(r.entries, env)
        except extract.UnknownShape as e:
            print("dream: %s" % e, file=sys.stderr)
            return 4
        text, _ = extract.render_digest(r.session, "?", r.entries)
        sys.stdout.write(text)
        return 0
    print(doc.strip())
    return 0 if cmd in ("help", "-h", "--help") else 2


def status(env):
    print("mode: %s%s" % (env.mode(), "" if env.local.is_dir() else " (not installed here: no %s)" % env.local))
    lr = paths.load_json(env.local / "last-run.json", None)
    if lr:
        print("last run: %s %s (%s)%s" % (lr.get("time"), lr.get("result"), lr.get("mode"),
                                          (": " + lr["reason"]) if lr.get("reason") else ""))
    else:
        print("last run: none")
    cursors = state.load_cursors(env)
    started = sum(1 for c in cursors.values() if c.get("committed_line"))
    print("markers: %d session(s), %d with settled lines" % (len(cursors), started))
    u = state.load_unsettled(env)
    print("waiting: %d finding(s), %d order(s)" % (len(u["findings"]), len(u["orders"])))
    print("journal: %s" % ("an unfinished apply is waiting" if (env.local / "apply-journal.json").exists() else "none"))
    return 0


# ---------- install ----------

UNITS = ("dream.service", "dream.timer")


def systemctl(env, *args):
    return subprocess.run(["systemctl", "--user"] + list(args), capture_output=True, text=True, env=env.environ)


def install(env, enable=False):
    """local/ (mode dry-run unless a mode is set), the units in ~/.config/systemd/user, a daemon-reload;
    the timer is enabled only with --enable."""
    env.local.mkdir(parents=True, exist_ok=True)
    if not (env.local / "mode").exists():
        paths.write_atomic(env.local / "mode", "dry-run\n")
    units = env.home / ".config/systemd/user"
    units.mkdir(parents=True, exist_ok=True)
    for u in UNITS:
        shutil.copyfile(env.dream / "systemd" / u, units / u)
    r = systemctl(env, "daemon-reload")
    if r.returncode != 0:
        print("dream install: systemctl --user daemon-reload failed: %s" % r.stderr.strip(), file=sys.stderr)
        return 4
    if enable:
        r = systemctl(env, "enable", "--now", "dream.timer")
        if r.returncode != 0:
            print("dream install: enabling the timer failed: %s" % r.stderr.strip(), file=sys.stderr)
            return 4
    print("dream install: units in %s, mode %s, timer %s" % (units, env.mode(), "enabled" if enable else
                                                              "not enabled (dream install --enable, or systemctl --user enable --now dream.timer)"))
    return 0


def uninstall(env):
    systemctl(env, "disable", "--now", "dream.timer")
    units = env.home / ".config/systemd/user"
    for u in UNITS:
        try:
            (units / u).unlink()
        except OSError:
            pass
    systemctl(env, "daemon-reload")
    print("dream uninstall: timer off and units removed; %s is kept" % env.local)
    return 0
