"""The headless agent calls (plan "The exact agent call"; DREAM.md section 10).

Helpers and the checker have no tools at all; the editor has file tools confined to its copy by
--restricted. Every call runs with no session saved, no customizations, no hooks, no MCP servers and
no slash commands, on the model in conf/models.conf, and its result must name exactly that model.
No call may go on on another model when safeguards flag a message (CALL_ENV, CALL_SETTINGS): a flagged
call stops, and the dream refuses it.
"""
import concurrent.futures
import json
import re
import subprocess
from pathlib import Path

from . import paths

REQUIRED_FLAGS = ["--no-session-persistence", "--safe-mode", "--setting-sources", "--settings",
                  "--strict-mcp-config", "--disable-slash-commands", "--permission-prompts", "--model",
                  "--effort", "--output-format", "--tools", "--json-schema", "--restricted",
                  "--permission-mode", "--system-prompt"]
EDITOR_TOOLS = "Read,Grep,Glob,Edit,Write"
HELPER_TIMEOUT = 900
EDITOR_TIMEOUT = 1800
WORKERS = 3
FATAL_STATUS = {401, 403, 429}
# When a model's safeguards flag a message, claude carries the turn on to another model (claude-opus-4-8 on
# 2.1.322) unless this is set; its changelog names the variable. With it, a flagged call stops on the pinned model.
CALL_ENV = {"CLAUDE_CODE_DISABLE_REFUSAL_FALLBACK": "1"}
# the --settings file: no hooks, and the same switch off as a setting ("When off, your session will pause instead")
CALL_SETTINGS = '{"hooks": {}, "switchModelsOnFlag": false}\n'
# DREAM.md sections each prompt carries
SECTIONS = {"session-helper": [3, 4, 8, 9], "review-helper": [7], "checker": [4, 6, 8, 9],
            "editor": [3, 4, 5, 6, 7, 8, 9]}


class Result:
    def __init__(self, role):
        self.role = role
        self.ok = False
        self.fatal = False
        self.data = {}
        self.error = ""
        self.denials = []
        self.usage = {}
        self.cost = 0.0
        self.session_id = ""


def claude_bin(env):
    return env.claude


def models(env):
    kv = paths.read_kv(env.conf / "models.conf")
    return kv.get("model", "claude-opus-5-5"), kv.get("effort", "xhigh")


def missing_flags(env):
    try:
        p = subprocess.run([claude_bin(env), "--help"], capture_output=True, text=True, env=env.environ,
                           stdin=subprocess.DEVNULL, timeout=120)
        text = p.stdout + p.stderr
    except (OSError, subprocess.TimeoutExpired):
        return ["the claude command itself (%s)" % claude_bin(env)]
    return [f for f in REQUIRED_FLAGS if not re.search(r"(?<![\w-])" + re.escape(f) + r"(?![\w-])", text)]


def dream_sections(env, numbers):
    """The `## N. Title` sections of DREAM.md with those numbers, verbatim."""
    try:
        text = (env.dream / "DREAM.md").read_text()
    except OSError:
        return ""
    parts = re.split(r"(?m)^(?=## \d+\. )", text)
    keep = [p for p in parts if re.match(r"## (\d+)\. ", p) and int(re.match(r"## (\d+)\. ", p).group(1)) in numbers]
    return "".join(keep).strip()


def prompt_text(env, role):
    text = (env.prompts / (role + ".md")).read_text()
    rules = dream_sections(env, SECTIONS[role])
    if rules and role != "editor":
        text += "\n\n# The rules (from ~/.claude/dream/DREAM.md)\n\n" + rules + "\n"
    return text


def schema_text(env, role):
    return json.dumps(json.loads((env.prompts / (role + ".schema.json")).read_text()), separators=(",", ":"))


def base_cmd(R):
    model, effort = models(R.env)
    settings = R.dir / "empty-settings.json"
    if not settings.exists():
        settings.write_text(CALL_SETTINGS)
    return [claude_bin(R.env), "-p", "--no-session-persistence", "--safe-mode", "--setting-sources", "",
            "--settings", str(settings), "--strict-mcp-config", "--disable-slash-commands",
            "--permission-prompts", "none", "--model", model, "--effort", effort, "--output-format", "json"]


def helper_cmd(R, role):
    return base_cmd(R) + ["--tools", "", "--system-prompt", prompt_text(R.env, role),
                          "--json-schema", schema_text(R.env, role)]


def editor_cmd(R):
    return base_cmd(R) + ["--restricted", "--tools", EDITOR_TOOLS, "--permission-mode", "acceptEdits",
                          "--system-prompt", prompt_text(R.env, "editor")]


def call_environ(R):
    return {**R.env.environ, **CALL_ENV}


def call(R, role, cmd, stdin, cwd, timeout, schema):
    res = Result(role)
    model, _ = models(R.env)
    try:
        p = subprocess.run(cmd, input=stdin, capture_output=True, text=True, cwd=str(cwd), env=call_environ(R),
                           timeout=timeout)
    except subprocess.TimeoutExpired:
        res.error = "%s timed out after %d s" % (role, timeout)
        return _done(R, res)
    except OSError as e:
        res.error = "%s could not start: %s" % (role, e)
        return _done(R, res)
    try:
        out = json.loads(p.stdout)
    except ValueError:
        out = None
    if not isinstance(out, dict):
        res.error = "%s exit %d, output is not JSON" % (role, p.returncode)
        return _done(R, res)
    res.usage = out.get("usage") or {}
    res.session_id = str(out.get("session_id") or "")
    res.cost = out.get("total_cost_usd") or 0.0
    res.denials = out.get("permission_denials") or []
    status = out.get("api_error_status")
    if status in FATAL_STATUS:
        res.fatal = True
        res.error = "the %s call failed on login or limits (HTTP %s); open claude once, or see desktop.md" % (role, status)
        return _done(R, res)
    used = set((out.get("modelUsage") or {}).keys())
    stops = out.get("safety_stops") or 0
    if stops:
        res.error = "%s was stopped by safeguards (%s safety stop%s); the dream never switches to another model" % (
            role, stops, "" if stops == 1 else "s")
    elif p.returncode != 0:
        res.error = "%s exit %d" % (role, p.returncode)
    elif out.get("is_error") or out.get("subtype") != "success":
        res.error = "%s returned an error (%s)" % (role, out.get("subtype"))
    elif used != {model}:
        res.error = "%s ran on %s, not %s" % (role, ", ".join(sorted(used)) or "no model", model)
    elif schema and not isinstance(out.get("structured_output"), dict):
        res.error = "%s returned no structured output" % role
    else:
        res.ok = True
        res.data = out.get("structured_output") if schema else out
    return _done(R, res)


def _done(R, res):
    R.calls.append({"role": res.role, "ok": res.ok, "input_tokens": res.usage.get("input_tokens", 0),
                    "output_tokens": res.usage.get("output_tokens", 0), "cost": res.cost})
    return res


def empty_dir(R):
    d = R.dir / "empty"
    d.mkdir(exist_ok=True)
    return d


def pending_block(pending):
    c = (pending or {}).get("candidates") or {}
    if not c:
        return "\nPENDING\n(none)\n"
    return "\nPENDING\n" + "".join("- %s: %s\n" % (k, v.get("statement", "")[:200]) for k, v in sorted(c.items()))


def session_helpers(R, jobs, pending):
    """One helper per (read, digest, used) job, at most 3 at a time; results in job order."""
    cmd = helper_cmd(R, "session-helper")
    cwd = empty_dir(R)
    tail = pending_block(pending)
    for r, digest, _ in jobs:
        (R.dir / ("digest-%s.md" % r.session)).write_text(digest)

    def one(job):
        return call(R, "session-helper", cmd, job[1] + tail, cwd, HELPER_TIMEOUT, True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=WORKERS) as ex:
        return list(ex.map(one, jobs))


def review_input(lines, tally):
    out = ["KINDS"]
    for k, v in sorted((tally.get("kinds") or {}).items()):
        out.append("KIND %s: %s — %s" % (k, v.get("title", ""), v.get("description", "")))
    out.append("")
    for ln in lines:
        out += ["LINE %s" % ln["id"], "project: %s" % ln["project"], "story: %s" % ln["story"],
                "severity: %s" % ln["severity"], "file: %s" % ln["file"], "claim: %s" % ln["claim"], ""]
    return "\n".join(out) + "\n"


def review_helpers(R, lines, tally, backfill, limit):
    """The backfill sends one helper per project with every line; later runs one helper, `limit` lines.
    Returns (lines given, assignments, results)."""
    if backfill:
        batches = {}
        for ln in lines:
            batches.setdefault(ln["project"], []).append(ln)
        groups = [batches[k] for k in sorted(batches)]
    else:
        groups = [lines[:limit]]
    cmd = helper_cmd(R, "review-helper")
    cwd = empty_dir(R)
    with concurrent.futures.ThreadPoolExecutor(max_workers=WORKERS) as ex:
        results = list(ex.map(lambda g: call(R, "review-helper", cmd, review_input(g, tally), cwd,
                                             HELPER_TIMEOUT, True), groups))
    given, assigns = [], []
    for g, res in zip(groups, results):
        if res.ok:
            given += g
            assigns += [a for a in res.data.get("assignments") or [] if isinstance(a, dict)]
    return given, assigns, results


def write_editor_inputs(R, mapping, findings, orders):
    d = R.dir / "copy/_dream"
    d.mkdir(parents=True, exist_ok=True)
    live_to_copy = {v["live"]: k for k, v in mapping.items()}

    def cpath(rel):
        from . import targets
        return live_to_copy.get(rel) or targets.copy_rel(rel)

    from . import targets
    shown = []
    for f in findings:
        scope = targets.scope_for(R.env, f)
        shown.append({"id": f["id"], "quote": f["quote"], "date": f["date"], "kind": f["kind"],
                      "statement": f["statement"], "replaces": f.get("replaces", ""),
                      "targets": ["(any file in this folder)"] if "*" in scope else [targets.copy_rel(s) for s in scope]})
    (d / "findings.json").write_text(json.dumps(shown, indent=1, ensure_ascii=False))
    # an add order carries max_entry_bytes, the bytes its entry may take (mistakes.orders, R2-3)
    (d / "orders.json").write_text(json.dumps([dict(o, file=cpath(o["file"]), to=cpath(o["to"]) if o.get("to") else "")
                                               for o in orders], indent=1, ensure_ascii=False))
    rules = dream_sections(R.env, SECTIONS["editor"])
    budgets = (R.env.conf / "budgets.tsv").read_text() if (R.env.conf / "budgets.tsv").exists() else ""
    caps = (R.env.conf / "caps.conf").read_text() if (R.env.conf / "caps.conf").exists() else ""
    (d / "rules.md").write_text("# Rules for this run (from DREAM.md)\n\n%s\n\n# Size budgets (bytes; paths "
                                "start with a dot on the live machine)\n\n```\n%s```\n\n# Change caps\n\n```\n%s```\n"
                                % (rules, budgets, caps))


def editor(R):
    stdin = ("Apply the findings in _dream/findings.json and the orders in _dream/orders.json, following "
             "_dream/rules.md, to the files in this folder. Then write _dream/changes.json as your instructions say.\n")
    return call(R, "editor", editor_cmd(R), stdin, R.dir / "copy", EDITOR_TIMEOUT, False)


BASES = ("finding", "order", "duplicate", "move")


def _strs(v):
    return isinstance(v, list) and all(isinstance(x, str) for x in v)


def _opt_str(x, k):
    return x.get(k) is None or isinstance(x.get(k), str)


def changes_problem(c):
    """What is wrong with the shape of changes.json (the shape the editor's prompt gives), or None. Every
    later step reads it, so an item of another shape stops the run here, as an editor failure (R1-13)."""
    if not isinstance(c, dict):
        return "it is not a JSON object"
    for k in ("changes", "already_saved", "declined"):
        if not isinstance(c.get(k, []), list):
            return "%s is not a list" % k
    for x in c.get("changes", []):
        if not isinstance(x, dict):
            return "a change is not an object"
        if not isinstance(x.get("file"), str) or not x["file"]:
            return "a change names no file"
        if x.get("basis") not in BASES:
            return "a change has the basis %r" % (x.get("basis"),)
        for k in ("finding_ids", "additions"):
            if not _strs(x.get(k, [])):
                return "a change's %s is not a list of text" % k
        if not all(_opt_str(x, k) for k in ("order_id", "summary")):
            return "a change's order_id or summary is not text"
        rems = x.get("removals", [])
        if not isinstance(rems, list) or not all(isinstance(r, dict) and isinstance(r.get("text"), str)
                                                 and all(_opt_str(r, k) for k in ("reason", "surviving_text", "moved_to"))
                                                 for r in rems):
            return "a change's removals are not objects with a text"
    for k, fields in (("already_saved", ("finding_id", "file", "existing_text")), ("declined", ("finding_id", "reason"))):
        for x in c.get(k, []):
            if not isinstance(x, dict) or not all(isinstance(x.get(f), str) for f in fields):
                return "an item of %s is not an object with %s" % (k, ", ".join(fields))
    return None


def read_changes(R):
    """(changes, None), or (None, what is wrong) when _dream/changes.json is missing, not JSON or of
    another shape."""
    try:
        c = json.loads((R.dir / "copy/_dream/changes.json").read_text())
    except (OSError, ValueError) as e:
        return None, "missing or not JSON: %s" % type(e).__name__
    why = changes_problem(c)
    if why:
        return None, why
    for k in ("changes", "already_saved", "declined"):
        c.setdefault(k, [])
    return c, None


def checker(R, diffs, findings, orders, changes):
    body = "DIFF\n" + "".join(d.unified for d in diffs)
    body += "\nFINDINGS\n" + json.dumps([{k: f.get(k) for k in ("id", "quote", "date", "statement", "replaces")}
                                          for f in findings], indent=1, ensure_ascii=False)
    body += "\nORDERS\n" + json.dumps(orders, indent=1, ensure_ascii=False)
    body += "\nCHANGES\n" + json.dumps(changes, indent=1, ensure_ascii=False) + "\n"
    (R.dir / "checker-input.txt").write_text(body)
    return call(R, "checker", helper_cmd(R, "checker"), body, empty_dir(R), HELPER_TIMEOUT, True)
