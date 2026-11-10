#!/usr/bin/env python3
"""Stage 2: turn scan.jsonl into per-agent, per-story and per-session tables.

Writes agents.jsonl, mains.jsonl and stories.json in the --out folder (where scan.py
wrote scan.jsonl) and prints nothing but a one-line receipt. report.py prints the tables.

Run:  python3 analyze.py [--out ~/.cache/token-report]

Weighted cost: the subscription's real weighting of models and token types is not
published, so two measures are kept side by side:
  * raw tokens by type (input, cache write, cache read, output)
  * "API $": the same tokens at Anthropic's public API prices (PRICES below,
    per million tokens, from the claude-api skill's models table cached 2026-11-03).
"""
import collections
import json
import os
import re
import sys


def opt(name, default):
    """Take `--name value` out of sys.argv; the default when it isn't given."""
    if name in sys.argv:
        i = sys.argv.index(name)
        if i + 1 >= len(sys.argv):
            sys.exit("error: %s needs a value" % name)
        value = sys.argv[i + 1]
        del sys.argv[i : i + 2]
        return value
    return default


HERE = os.path.expanduser(opt("--out", "~/.cache/token-report"))   # the folder scan.py wrote
PRICES = {  # in, cache write 5m, cache write 1h, cache read, out   ($ / MTok)
    "claude-fable-5-2": (8.0, 10.0, 16.0, 0.20, 40.0),
    "claude-opus-5-5": (4.0, 5.0, 8.0, 0.20, 20.0),
    "claude-sonnet-5-5": (2.0, 2.5, 4.0, 0.10, 10.0),
    "claude-haiku-5-5": (0.1, 0.125, 0.2, 0.01, 0.5),
}
DEFAULT_PRICE = PRICES["claude-opus-5-5"]

ROLE_PATTERNS = [
    ("planner", r"-(planner|plan-amendment)"),
    ("builder", r"-builder"),
    ("reviewer", r"-(reviewer|review|repin-review)(?![a-z])"),
    ("fixer", r"-(stack-)?fixer"),
    ("verifier", r"-(postmerge-|stack-|final-)?(verifier|verify)"),
    ("auditor", r"-(postmerge-|stack-|final-)?auditor"),
    ("finisher", r"-(merge-finisher|pr-finisher|wave1-finisher|stack-\d+-finisher|stack-finisher|finisher|final-rebase|rebaser|rebase|bring-main|mainin|postmerge|postprep|integrator|pr-record|clickup-post|post|pr|push)(?![a-z])"),
]
SETUP_READ = re.compile(r"(/\.claude/skills/|/\.hermes/skills/|CLAUDE\.md|/briefs/|/\.hermes/plans/[^/]+/[^/]+\.md$|/references/|SKILL\.md|/memory/|plan-approved\.md)")


def cost(c):
    p = PRICES.get(c["model"], DEFAULT_PRICE)
    cw5 = c["cw"] - c["cw1h"]
    return (c["in"] * p[0] + cw5 * p[1] + c["cw1h"] * p[2] + c["cr"] * p[3] + c["out"] * p[4]) / 1e6


def parse_brief(name):
    best = None
    for role, pat in ROLE_PATTERNS:
        m = re.search(pat, name)
        if m and (best is None or m.start() < best[1]):
            best = (role, m.start(), m.end())
    if not best:
        return name, "other", "", 0
    role, s, e = best
    story = name[:s] or name
    tail = name[s:]
    sub = ""
    if role == "planner" and re.search(r"amend|revise|planner2|amendment", tail):
        sub = "amend"
    if role == "fixer" and re.search(r"main|update-pr|repin|stack", tail):
        sub = "integration"
    if role in ("verifier", "auditor") and re.search(r"-pr|postmerge|stack|train|final", tail):
        sub = "rerun-after-integration"
    if role == "finisher":
        if re.search(r"rebase|bring-main|mainin|integrator", tail):
            sub = "rebase"
        elif re.search(r"post|pr|push|record", tail) and "postmerge" not in tail:
            sub = "pr-post"
        elif re.search(r"postmerge|postprep", tail):
            sub = "after-merge"
    m = re.search(r"(\d+)\D*$", tail)
    rnd = int(m.group(1)) if m and int(m.group(1)) < 50 else 1
    return story, role, sub, rnd


def main():
    agents = []
    mains = []
    with open(os.path.join(HERE, "scan.jsonl")) as fh:
        for line in fh:
            r = json.loads(line)
            calls = r["calls"]
            if not calls:
                continue
            ctx = [c["in"] + c["cw"] + c["cr"] for c in calls]
            tot = {k: sum(c[k] for c in calls) for k in ("in", "cw", "cr", "out", "cw1h")}
            usd = sum(cost(c) for c in calls)
            n = len(calls)
            model = collections.Counter(c["model"] for c in calls).most_common(1)[0][0]
            price = PRICES.get(model, DEFAULT_PRICE)
            # cache rebuilds: a later call that re-writes most of its context
            rebuild_n = 0
            rebuild_cw = 0
            for i, c in enumerate(calls):
                if i and ctx[i] > 30000 and c["cr"] < 0.5 * ctx[i]:
                    rebuild_n += 1
                    rebuild_cw += c["cw"]
            # tool results by tool
            id2tool = {}
            for i, c in enumerate(calls):
                for t in c["tools"]:
                    id2tool[t["id"]] = (t["n"], t["k"], i)
            res_chars = collections.Counter()
            skill_chars = 0
            skill_carry = 0.0  # chars x remaining calls
            setup_read_chars = 0
            setup_read_carry = 0.0
            instr = []
            instr_chars = 0
            listing_chars = 0
            nested_chars = 0
            stop_hooks = 0
            first_stop_ts = None
            coord_msgs = 0
            nudges = 0
            nudge_chars = 0
            handback_chars = 0
            handbacks = 0
            notif = 0
            call_ts = [c["ts"] or "" for c in calls]
            import bisect

            for e in r["user_events"]:
                ets = e.get("ts") or ""
                idx = bisect.bisect_right(call_ts, ets)  # calls already made
                remaining = max(n - idx, 0)
                for kind, size, tid, head in e["k"]:
                    if kind == "tool_result":
                        tn, tk, ti = id2tool.get(tid, ("?", "", 0))
                        res_chars[tn] += size
                        if tn == "Read" and SETUP_READ.search(tk):
                            setup_read_chars += size
                            setup_read_carry += size * remaining
                    elif kind == "text":
                        if head.startswith("Base directory for this skill"):
                            skill_chars += size
                            skill_carry += size * remaining
                        elif head.startswith("Stop hook") or "hook" in head[:40].lower() and "feedback" in head.lower():
                            stop_hooks += 1
                            first_stop_ts = first_stop_ts or ets
                        elif head.startswith("The coordinator sent a message"):
                            coord_msgs += 1
                        elif head.startswith("Another Claude session sent"):
                            handbacks += 1
                            handback_chars += size
                        elif head.startswith("<task-notification>"):
                            notif += 1
                    elif kind == "attachment:instructions":
                        try:
                            files = json.loads(head)
                        except Exception:
                            files = []
                        instr += files
                        instr_chars += size
                    elif kind == "attachment:skill_listing":
                        listing_chars += size
                    elif kind == "attachment:nested_memory":
                        nested_chars += size
                    elif kind == "attachment:hook_additional_context" and head.startswith("PostToolUse"):
                        nudges += 1
                        nudge_chars += size
            after_stop = sum(cost(c) for c in calls if first_stop_ts and (c["ts"] or "") > first_stop_ts)
            # setup phase: calls before the first call that issues a non-setup tool
            first_work = n
            for i, c in enumerate(calls):
                work = False
                for t in c["tools"]:
                    if t["n"] in ("Skill", "ToolSearch"):
                        continue
                    if t["n"] == "Read" and SETUP_READ.search(t["k"]):
                        continue
                    work = True
                if work:
                    first_work = i
                    break
            setup_usd = sum(cost(c) for c in calls[:first_work])
            ctx_at_work = ctx[first_work] if first_work < n else ctx[-1]
            skills = [t["k"] for c in calls for t in c["tools"] if t["n"] == "Skill"]
            tools_n = sum(len(c["tools"]) for c in calls)
            base = {
                "path": r["path"],
                "project": r["project"],
                "session": r["path"].split(os.sep)[-3] if r["sub"] else os.path.basename(r["path"])[:-6],
                "t0": r["t0"],
                "t1": r["t1"],
                "model": model,
                "calls": n,
                "tools": tools_n,
                **tot,
                "usd": round(usd, 3),
                "ctx0": ctx[0],
                "ctx_max": max(ctx),
                "ctx_avg": int(sum(ctx) / n),
                "rebuild_n": rebuild_n,
                "rebuild_cw": rebuild_cw,
                "skills": skills,
                "skill_chars": skill_chars,
                "skill_carry": skill_carry,
                "setup_read_chars": setup_read_chars,
                "setup_read_carry": setup_read_carry,
                "instr": instr,
                "instr_chars": instr_chars,
                "listing_chars": listing_chars,
                "nested_chars": nested_chars,
                "first_work": first_work,
                "setup_usd": round(setup_usd, 3),
                "ctx_at_work": ctx_at_work,
                "prefix_carry_usd": round(ctx[0] * (n - 1) * price[3] / 1e6, 3),
                "res_chars": dict(res_chars),
                "stop_hooks": stop_hooks,
                "after_stop_usd": round(after_stop, 3),
                "coord_msgs": coord_msgs,
                "nudges": nudges,
                "nudge_chars": nudge_chars,
                "handbacks": handbacks,
                "handback_chars": handback_chars,
                "notif": notif,
                "usd_cr": round(tot["cr"] * price[3] / 1e6, 3),
                "usd_cw": round(((tot["cw"] - tot["cw1h"]) * price[1] + tot["cw1h"] * price[2]) / 1e6, 3),
                "usd_out": round(tot["out"] * price[4] / 1e6, 3),
            }
            if r["sub"]:
                fp = r.get("first_prompt") or ""
                m = re.search(r"briefs/([\w.\-]+)\.md", fp)
                meta = r.get("meta") or {}
                brief = m.group(1) if m else ""
                story, role, sub, rnd = parse_brief(brief) if brief else ("", "other", "", 0)
                base.update(
                    {
                        "agent": os.path.basename(r["path"])[:-6],
                        "brief": brief,
                        "story": story,
                        "role": role,
                        "sub": sub,
                        "round": rnd,
                        "meta_model": meta.get("model") or "",
                        "effort": meta.get("effort") or "",
                        "desc": (meta.get("description") or "")[:60],
                        "bg": meta.get("requestShape") or "",
                    }
                )
                agents.append(base)
            else:
                base["call_list"] = [(c["ts"], round(cost(c), 4), ctx[i], c["cw"], [t["n"] for t in c["tools"]]) for i, c in enumerate(calls)]
                mains.append(base)

    # main-session calls -> story of the nearest earlier agent start/end in that session
    by_session = collections.defaultdict(list)
    for a in agents:
        if a["story"]:
            by_session[a["session"]].append((a["t0"] or "", a["story"]))
            by_session[a["session"]].append((a["t1"] or "", a["story"]))
    main_story = collections.defaultdict(lambda: {"usd": 0.0, "calls": 0})
    for m in mains:
        ev = sorted(by_session.get(m["session"], []))
        m["pipeline_agents"] = len(ev) // 2
        ts_list = [e[0] for e in ev]
        import bisect

        for ts, usd, cx, cw, tl in m.pop("call_list"):
            if not ev:
                continue
            i = bisect.bisect_right(ts_list, ts or "") - 1
            story = ev[max(i, 0)][1]
            main_story[story]["usd"] += usd
            main_story[story]["calls"] += 1

    stories = {}
    for a in agents:
        if not a["story"]:
            continue
        s = stories.setdefault(a["story"], {"story": a["story"], "project": a["project"], "t0": a["t0"], "t1": a["t1"], "agents": 0, "usd": 0.0, "roles": collections.defaultdict(lambda: {"n": 0, "usd": 0.0, "in": 0, "cw": 0, "cr": 0, "out": 0, "calls": 0}), "models": collections.defaultdict(lambda: {"usd": 0.0, "in": 0, "cw": 0, "cr": 0, "out": 0}), "fable": False})
        s["t0"] = min(s["t0"], a["t0"])
        s["t1"] = max(s["t1"], a["t1"])
        s["agents"] += 1
        s["usd"] += a["usd"]
        key = a["role"] + (":" + a["sub"] if a["sub"] else "")
        ro = s["roles"][key]
        ro["n"] += 1
        ro["usd"] += a["usd"]
        ro["calls"] += a["calls"]
        mo = s["models"][a["model"]]
        mo["usd"] += a["usd"]
        for k in ("in", "cw", "cr", "out"):
            ro[k] += a[k]
            mo[k] += a[k]
        if a["model"].startswith("claude-fable"):
            s["fable"] = True
    for name, s in stories.items():
        s["main_usd"] = round(main_story[name]["usd"], 2)
        s["main_calls"] = main_story[name]["calls"]
        s["usd"] = round(s["usd"], 2)
        s["roles"] = {k: {kk: (round(vv, 2) if isinstance(vv, float) else vv) for kk, vv in v.items()} for k, v in s["roles"].items()}
        s["models"] = {k: {kk: (round(vv, 2) if isinstance(vv, float) else vv) for kk, vv in v.items()} for k, v in s["models"].items()}

    with open(os.path.join(HERE, "agents.jsonl"), "w") as out:
        for a in agents:
            out.write(json.dumps(a) + "\n")
    with open(os.path.join(HERE, "mains.jsonl"), "w") as out:
        for m in mains:
            out.write(json.dumps(m) + "\n")
    with open(os.path.join(HERE, "stories.json"), "w") as out:
        json.dump(stories, out, indent=1)
    print("agents", len(agents), "mains", len(mains), "stories", len(stories))


if __name__ == "__main__":
    main()
