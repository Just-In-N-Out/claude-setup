#!/usr/bin/env python3
"""Stage 4: the remaining numbers quoted in the plan (run after scan.py and analyze.py).

Sections: carry rebuild-causes bash-sizes findings ac-agreement loop reruns era
Usage: python3 extras.py [--out ~/.cache/token-report] [--plans ~/.hermes/plans] [section ...]   (no section = all)
--out is the folder scan.py and analyze.py wrote; --plans holds the review and ac.json evidence.
Prints numbers, story names and paths only.
"""
import bisect
import collections
import datetime
import glob
import json
import os
import re
import statistics as st
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


HERE = os.path.expanduser(opt("--out", "~/.cache/token-report"))   # the folder analyze.py wrote
PLANS = os.path.expanduser(opt("--plans", "~/.hermes/plans"))
want = set(sys.argv[1:])
A = [json.loads(l) for l in open(os.path.join(HERE, "agents.jsonl"))]
M = [json.loads(l) for l in open(os.path.join(HERE, "mains.jsonl"))]
S = json.load(open(os.path.join(HERE, "stories.json")))
TOT_A = sum(a["usd"] for a in A)
TOT_M = sum(m["usd"] for m in M if m["pipeline_agents"])
ALL = TOT_A + TOT_M


def on(x):
    return not want or x in want


def wr(a):
    return 10.0 if "fable" in a["model"] else 5.0


if on("carry"):
    print("== carry cost of fixed baggage (first cache write + a cache read on every later call), 4.0 chars/token ==")

    def carry(chars, a):
        return chars / 4.0 * ((a["calls"] - 1) * 0.2 + wr(a)) / 1e6

    c = collections.Counter()
    for a in A:
        for p, ch in a["instr"]:
            key = "FigmaToBricksV2 CLAUDE.md" if "FigmaToBricks" in p and p.endswith("CLAUDE.md") else "global CLAUDE.md" if p.endswith(".claude/CLAUDE.md") else "MEMORY.md" if p.endswith("MEMORY.md") else "other instructions"
            c[key] += carry(ch, a)
        c["skill listing"] += carry(a["listing_chars"], a)
        c["nested CLAUDE.md"] += carry(a["nested_chars"], a)
        c["fixed 36k tokens (system prompt, tool schemas, MCP lists, brief)"] += carry(36000 * 4, a)
        c["skill bodies the agent loads"] += a["skill_carry"] / 4 * 0.2 / 1e6 + a["skill_chars"] / 4 * wr(a) / 1e6
        c["brief / plan / reference reads"] += a["setup_read_carry"] / 4 * 0.2 / 1e6 + a["setup_read_chars"] / 4 * wr(a) / 1e6
    for k, v in c.most_common():
        print("  %-66s $%6.0f %5.1f%% of agent $" % (k, v, 100 * v / TOT_A))
    print("  TOTAL %.1f%% of agent $" % (100 * sum(c.values()) / TOT_A))

if on("rebuild-causes") or on("bash-sizes"):
    def T(s):
        try:
            return datetime.datetime.fromisoformat(s.replace("Z", "+00:00")).timestamp()
        except Exception:
            return None

    cat_n = collections.Counter()
    cat_cw = collections.Counter()
    b_n = collections.Counter()
    b_ch = collections.Counter()
    b_carry = collections.Counter()
    stop_next = []
    with open(os.path.join(HERE, "scan.jsonl")) as fh:
        for line in fh:
            r = json.loads(line)
            if not r["sub"] or not r["calls"]:
                continue
            calls = r["calls"]
            n = len(calls)
            cts = [c["ts"] or "" for c in calls]
            id2 = {t["id"]: t for c in calls for t in c["tools"]}
            w = 10.0 if "fable" in calls[0]["model"] else 5.0
            ev = []
            for e in r["user_events"]:
                idx = bisect.bisect_right(cts, e.get("ts") or "")
                rem = max(n - idx, 0)
                for kind, size, tid, head in e["k"]:
                    if kind == "tool_result" and id2.get(tid, {}).get("n") == "Bash":
                        k = "<2k" if size < 2000 else "2-8k" if size < 8000 else "8-30k"
                        b_n[k] += 1
                        b_ch[k] += size
                        b_carry[k] += size / 4 * (w + rem * 0.2) / 1e6
                    elif kind == "text" and (head.startswith("Stop hook") or head.startswith("The coordinator") or head.startswith("[SYSTEM NOTIFICATION")):
                        ev.append((e["ts"] or "", head[:12]))
                        if head.startswith("Stop hook") and idx < n:
                            c = calls[idx]
                            stop_next.append((c["cw"] * w + c["cr"] * 0.2 + c["out"] * w * 4) / 1e6)
            ev.sort()
            ets = [x[0] for x in ev]
            for i, c in enumerate(calls):
                ctx = c["in"] + c["cw"] + c["cr"]
                if i and ctx > 30000 and c["cr"] < 0.5 * ctx:
                    t0, t1 = T(calls[i - 1]["ts"] or ""), T(c["ts"] or "")
                    gap = (t1 - t0) if t0 and t1 else -1
                    j = bisect.bisect_right(ets, c["ts"] or "") - 1
                    prev = [t["n"] for t in calls[i - 1]["tools"]]
                    if j >= 0 and ets[j] > (calls[i - 1]["ts"] or ""):
                        cat = "after a resume message (" + ev[j][1].strip() + ")"
                    elif gap >= 290:
                        cat = "5+ min wait on " + (prev[0] if prev else "no tool")
                    else:
                        cat = "under 5 min, after " + (prev[0] if prev else "no tool")
                    cat_n[cat] += 1
                    cat_cw[cat] += c["cw"]
    if on("rebuild-causes"):
        print("== agent cache rebuilds by cause ==")
        for k, v in cat_cw.most_common(8):
            print("  %-48s n=%3d tokens=%.1fM" % (k, cat_n[k], v / 1e6))
        print("  stop-hook send-backs: %d, cost of the call that follows: $%.0f total" % (len(stop_next), sum(stop_next)))
    if on("bash-sizes"):
        print("== Bash results by size (the harness caps one result near 30k chars) ==")
        tot = sum(b_ch.values())
        for k in ("<2k", "2-8k", "8-30k"):
            print("  %-6s n=%6d chars=%5.1fM (%4.1f%%) carry $%.0f = %.1f%% of agent $" % (k, b_n[k], b_ch[k] / 1e6, 100 * b_ch[k] / tot, b_carry[k], 100 * b_carry[k] / TOT_A))

REV = {}
for f in glob.glob(os.path.join(PLANS, "*/evidence/*/review-*/review.json")):
    story = f.split("/")[-3]
    n = int(re.search(r"review-(\d+)", f).group(1))
    try:
        d = json.load(open(f))
    except Exception:
        continue
    c = collections.Counter((x.get("severity") or "?").upper()[:2] for x in d.get("findings", []) if isinstance(x, dict))
    REV[(story, n)] = (d.get("scope"), c)

if on("findings"):
    print("== review rounds from <evidence>/review-<n>/review.json: %d stories ==" % len({k[0] for k in REV}))
    rn = collections.Counter()
    bl = collections.Counter()
    sev = collections.defaultdict(collections.Counter)
    top = collections.Counter()
    for (story, n), (scope, c) in REV.items():
        k = min(n, 6)
        rn[k] += 1
        sev[k].update(c)
        if c["P0"] + c["P1"] + c["P2"]:
            bl[k] += 1
            top[("round 1" if n == 1 else "round 2" if n == 2 else "round 3+", "has P0/P1" if c["P0"] + c["P1"] else "P2 only")] += 1
    for k in sorted(rn):
        print("  round %s%s: reviews=%d blocking=%d (%.0f%%) mean P0=%.2f P1=%.2f P2=%.2f P3=%.2f" % (k, "+" if k == 6 else "", rn[k], bl[k], 100 * bl[k] / rn[k], sev[k]["P0"] / rn[k], sev[k]["P1"] / rn[k], sev[k]["P2"] / rn[k], sev[k]["P3"] / rn[k]))
    print("  blocking rounds by top severity:", dict(top))
    g = collections.defaultdict(list)
    for a in A:
        if a["role"] != "reviewer":
            continue
        for (story, n), (scope, c) in REV.items():
            if n == a["round"] and (a["story"] == story or a["story"].startswith(story) or story.startswith(a["story"])):
                g[(a["model"].replace("claude-", ""), a["effort"] or "default", "round 1" if n == 1 else "round 2+")].append((c["P0"] + c["P1"], c["P2"], c["P3"], a["usd"]))
                break
    print("  per review, by reviewer model / effort: n, mean P0+P1, mean P2, mean P3, mean $")
    for k, v in sorted(g.items()):
        if len(v) >= 4:
            print("   ", k, len(v), *(round(st.mean([x[i] for x in v]), 2) for i in range(4)))

if on("ac-agreement"):
    heads = collections.defaultdict(dict)
    for f in glob.glob(os.path.join(PLANS, "*/evidence/*/verifier*/ac.json")) + glob.glob(os.path.join(PLANS, "*/evidence/*/auditor*/ac.json")) + glob.glob(os.path.join(PLANS, "*/evidence/*/*/verifier*/ac.json")) + glob.glob(os.path.join(PLANS, "*/evidence/*/*/auditor*/ac.json")):
        try:
            d = json.load(open(f))
        except Exception:
            continue
        role = "verifier" if re.search(r"/verifier[^/]*/ac.json", f) else "auditor"
        acs = {re.sub(r"\W", "", str(x.get("ac")).upper())[:6]: x.get("accepted") for x in d.get("ac_status", []) if isinstance(x, dict)}
        if acs:
            heads[(f[len(PLANS) + 1 :].split("/")[2], d.get("head"))][role] = acs
    pairs = {k: v for k, v in heads.items() if "verifier" in v and "auditor" in v}
    n_ac = agree = aud = ver = 0
    pa, pv = set(), set()
    for k, v in pairs.items():
        for ac, va in v["verifier"].items():
            if ac not in v["auditor"]:
                continue
            aa = v["auditor"][ac]
            n_ac += 1
            if (va is True) == (aa is True):
                agree += 1
            elif va is True:
                aud += 1
                pa.add(k)
            else:
                ver += 1
                pv.add(k)
    print("== verifier vs auditor on the same head (reports still on disk) ==")
    print("  pairs=%d in %d stories; ACs compared=%d; agree=%d; auditor refused what the verifier accepted: %d ACs in %d pairs (%d stories); the reverse: %d ACs in %d pairs" % (len(pairs), len({k[0] for k in pairs}), n_ac, agree, aud, len(pa), len({k[0] for k in pa}), ver, len(pv)))

if on("loop"):
    print("== cost of later rounds (share of agents + main = $%.0f) ==" % ALL)
    for role in ("reviewer", "fixer"):
        g = collections.defaultdict(list)
        for a in A:
            if a["role"] == role and not a["sub"]:
                g[min(a["round"], 6)].append(a["usd"])
        print("  %s by round (6 = 6+):" % role, {k: (len(v), round(sum(v)), "%.1f%%" % (100 * sum(v) / ALL)) for k, v in sorted(g.items())})
    r4 = sum(a["usd"] for a in A if a["role"] == "reviewer" and a["round"] >= 4 and not a["sub"])
    f3 = sum(a["usd"] for a in A if a["role"] == "fixer" and a["round"] >= 3 and not a["sub"])
    print("  reviewers round 4+ $%.0f + fixers round 3+ $%.0f = %.1f%%" % (r4, f3, 100 * (r4 + f3) / ALL))

if on("reruns"):
    print("== special agents (share of agents + main) ==")
    for role, sub in (("verifier", ""), ("verifier", "rerun-after-integration"), ("auditor", ""), ("auditor", "rerun-after-integration"), ("finisher", ""), ("finisher", "rebase"), ("finisher", "pr-post"), ("finisher", "after-merge"), ("planner", ""), ("planner", "amend"), ("builder", ""), ("fixer", ""), ("fixer", "integration"), ("reviewer", ""), ("other", "")):
        v = [a["usd"] for a in A if a["role"] == role and a["sub"] == sub]
        if v:
            print("  %-9s %-24s n=%3d $%5.0f = %4.1f%%" % (role, sub or "(plain)", len(v), sum(v), 100 * sum(v) / ALL))
    print("  main sessions with pipeline agents: $%.0f = %.1f%%; per agent dispatched $%.2f" % (TOT_M, 100 * TOT_M / ALL, TOT_M / len(A)))

if on("era"):
    print("== stories with at least one Fable agent (since 2026-11-09), tokens by model ==")
    by = collections.defaultdict(list)
    for a in A:
        if a["story"]:
            by[a["story"]].append(a)
    tm = collections.defaultdict(lambda: [0, 0, 0, 0, 0, 0.0])
    for s, ags in sorted(by.items(), key=lambda x: S[x[0]]["t0"]):
        if not S[s]["fable"] or not any(a["role"] == "builder" for a in ags) or not any(a["role"] == "reviewer" for a in ags):
            continue
        g = collections.defaultdict(lambda: [0, 0, 0, 0, 0, 0.0])
        for a in ags:
            m = a["model"].replace("claude-", "")
            for d in (g[m], tm[m]):
                d[0] += 1
                d[1] += a["in"]
                d[2] += a["cw"]
                d[3] += a["cr"]
                d[4] += a["out"]
                d[5] += a["usd"]
        print("  " + s + " | " + " ; ".join("%s n=%d in=%.1fk cacheWrite=%.1fM cacheRead=%.0fM out=%.2fM $%.0f" % (m, v[0], v[1] / 1e3, v[2] / 1e6, v[3] / 1e6, v[4] / 1e6, v[5]) for m, v in sorted(g.items())) + " | main $%.0f" % S[s]["main_usd"])
    for m, v in tm.items():
        print("  TOTAL %s n=%d in=%.1fk cacheWrite=%.1fM cacheRead=%.0fM out=%.2fM $%.0f" % (m, v[0], v[1] / 1e3, v[2] / 1e6, v[3] / 1e6, v[4] / 1e6, v[5]))
