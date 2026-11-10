#!/usr/bin/env python3
"""Stage 3: print the tables the plan quotes.
Usage: python3 report.py [--out ~/.cache/token-report] [--plans ~/.hermes/plans] [section ...]
Sections: tokens stories roles startup main top rounds rebuild hooks prefix. No argument = all.
Reads agents.jsonl, mains.jsonl, stories.json in --out (made by analyze.py); --plans is where
the planner briefs are (to tell Mini from Full). Prints numbers, story names and file paths
only; never transcript text.

       python3 report.py context <transcript.jsonl>
prints one number: the context size of the transcript's last API response (input + cache
write + cache read tokens). The pipeline's fresh-session rule reads it for the main session.
"""
import collections
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


def context(path):
    """Input + cache write + cache read tokens of the last API response in a transcript.
    Lines that repeat a message id (one line per content block) are one response."""
    last_id, last = None, None
    with open(path, "r", errors="replace") as fh:
        for line in fh:
            try:
                d = json.loads(line)
            except ValueError:
                continue
            if not isinstance(d, dict) or d.get("type") != "assistant" or d.get("isSidechain"):
                continue
            msg = d.get("message")
            if not isinstance(msg, dict) or msg.get("model") == "<synthetic>":
                continue
            u = msg.get("usage") or {}
            if not u:
                continue
            mid = msg.get("id") or d.get("uuid")
            size = (u.get("input_tokens") or 0) + (u.get("cache_creation_input_tokens") or 0) + (u.get("cache_read_input_tokens") or 0)
            last = max(last, size) if mid == last_id and last is not None else size
            last_id = mid
    if last is None:
        sys.exit("error: no API response in %s" % path)
    return last


if sys.argv[1:2] == ["context"]:
    if len(sys.argv) != 3:
        sys.exit("usage: report.py context <transcript.jsonl>")
    print(context(sys.argv[2]))
    sys.exit(0)

HERE = os.path.expanduser(opt("--out", "~/.cache/token-report"))   # the folder analyze.py wrote
PLANS = os.path.expanduser(opt("--plans", "~/.hermes/plans"))
A = [json.loads(l) for l in open(os.path.join(HERE, "agents.jsonl"))]
M = [json.loads(l) for l in open(os.path.join(HERE, "mains.jsonl"))]
S = json.load(open(os.path.join(HERE, "stories.json")))
want = set(sys.argv[1:])


def on(name):
    return not want or name in want


def med(x):
    return st.median(x) if x else 0


def proj(p):
    if "Leorna" in p or "leorna" in p:
        return "leorna"
    if "Figma" in p:
        return "figma"
    return "setup"


def mini(story):
    for d in ("claude-setup", "leorna", "figma-to-bricks"):
        for f in glob.glob(os.path.join(PLANS, "%s/briefs/%s-planner*.md" % (d, story))):
            try:
                if re.search(r"\bMini\b", open(f).read(6000)):
                    return True
            except OSError:
                pass
    return False


by_story = collections.defaultdict(list)
for a in A:
    if a["story"]:
        by_story[a["story"]].append(a)


def story_row(name):
    ags = by_story[name]
    s = S[name]
    c = collections.Counter(a["role"] for a in ags)
    usd = collections.defaultdict(float)
    for a in ags:
        usd[a["role"]] += a["usd"]
    tok = {k: sum(a[k] for a in ags) for k in ("in", "cw", "cr", "out")}
    return {
        "story": name,
        "proj": proj(s["project"]),
        "date": (s["t0"] or "")[:10],
        "end": (s["t1"] or "")[:10],
        "fable": s["fable"],
        "mini": mini(name),
        "agents": len(ags),
        "n": c,
        "usd_role": usd,
        "sub_usd": sum(a["usd"] for a in ags),
        "main_usd": s["main_usd"],
        "tok": tok,
        "complete": c["builder"] > 0 and c["reviewer"] > 0 and (c["finisher"] > 0 or c["verifier"] > 0),
    }


ROWS = sorted((story_row(n) for n in by_story), key=lambda r: r["date"])
COMPLETE = [r for r in ROWS if r["complete"]]
ROLES = ["planner", "builder", "reviewer", "fixer", "verifier", "auditor", "finisher", "other"]

if on("tokens"):
    print("== tokens per role: transcripts, API calls, input, cache write, cache read, output tokens, API $ ==")
    for label, rows in [(r, [a for a in A if a["role"] == r]) for r in ROLES] + [("main", M)]:
        if rows:
            print("%-9s n=%d calls=%d in=%d cw=%d cr=%d out=%d usd=%.3f" % ((label, len(rows), sum(a["calls"] for a in rows)) + tuple(sum(a[k] for a in rows) for k in ("in", "cw", "cr", "out")) + (sum(a["usd"] for a in rows),)))

if on("stories"):
    print("== complete stories (builder + reviewer + verifier/finisher): %d of %d story names ==" % (len(COMPLETE), len(ROWS)))
    print("story|proj|start|mini|fable|agents|plan/build/rev/fix/ver/aud/fin|sub$|main$|total$|cacheRead M|cacheWrite M|out M|" + "|".join(r + "$" for r in ROLES))
    for r in COMPLETE[-16:]:
        n = r["n"]
        print(
            "%s|%s|%s|%s|%s|%d|%d/%d/%d/%d/%d/%d/%d|%.0f|%.0f|%.0f|%.0f|%.1f|%.2f|" % (r["story"], r["proj"], r["date"], "mini" if r["mini"] else "full", "y" if r["fable"] else "n", r["agents"], n["planner"], n["builder"], n["reviewer"], n["fixer"], n["verifier"], n["auditor"], n["finisher"], r["sub_usd"], r["main_usd"], r["sub_usd"] + r["main_usd"], r["tok"]["cr"] / 1e6, r["tok"]["cw"] / 1e6, r["tok"]["out"] / 1e6)
            + "|".join("%.0f" % r["usd_role"][x] for x in ROLES)
        )
    for label, rows in (
        ("ALL complete", COMPLETE),
        ("since 2026-11-09 (fable era)", [r for r in COMPLETE if r["fable"]]),
        ("before", [r for r in COMPLETE if not r["fable"]]),
        ("leorna", [r for r in COMPLETE if r["proj"] == "leorna"]),
        ("figma", [r for r in COMPLETE if r["proj"] == "figma"]),
        ("setup", [r for r in COMPLETE if r["proj"] == "setup"]),
        ("mini", [r for r in COMPLETE if r["mini"]]),
        ("full", [r for r in COMPLETE if not r["mini"]]),
    ):
        if not rows:
            continue
        tot = [r["sub_usd"] + r["main_usd"] for r in rows]
        print(
            "GROUP %s: n=%d median total$=%.0f mean=%.0f p90=%.0f | median agents=%d | mean agents by role %s | mean $ share by role %s | main share %.1f%%"
            % (
                label,
                len(rows),
                med(tot),
                st.mean(tot),
                sorted(tot)[int(len(tot) * 0.9) - 1] if len(tot) > 1 else tot[0],
                med([r["agents"] for r in rows]),
                " ".join("%s=%.1f" % (x[:3], st.mean([r["n"][x] for r in rows])) for x in ROLES),
                " ".join("%s=%.0f%%" % (x[:3], 100 * sum(r["usd_role"][x] for r in rows) / sum(tot)) for x in ROLES),
                100 * sum(r["main_usd"] for r in rows) / sum(tot),
            )
        )
        print("   tokens (mean per story, M): in=%.3f cacheWrite=%.2f cacheRead=%.1f out=%.2f" % tuple(st.mean([r["tok"][k] for r in rows]) / 1e6 for k in ("in", "cw", "cr", "out")))

if on("rounds"):
    print("== rounds per complete story ==")
    for label, rows in (("all", COMPLETE), ("mini", [r for r in COMPLETE if r["mini"]]), ("full", [r for r in COMPLETE if not r["mini"]])):
        for role in ("reviewer", "fixer", "verifier", "auditor", "finisher", "planner"):
            v = sorted(r["n"][role] for r in rows)
            if v:
                print("%s %s: median=%s mean=%.1f p90=%d max=%d  share of stories with >1: %.0f%%" % (label, role, med(v), st.mean(v), v[int(len(v) * 0.9) - 1], v[-1], 100 * sum(1 for x in v if x > 1) / len(v)))
    sub = collections.Counter()
    subusd = collections.defaultdict(float)
    for a in A:
        if a["sub"]:
            sub[a["role"] + ":" + a["sub"]] += 1
            subusd[a["role"] + ":" + a["sub"]] += a["usd"]
    print("special agents:", {k: (v, round(subusd[k])) for k, v in sub.items()})
    # reviewer cost by round
    byr = collections.defaultdict(list)
    for a in A:
        if a["role"] == "reviewer":
            byr[min(a["round"], 5)].append(a["usd"])
    print("reviewer $ by round (5 = 5+):", {k: (len(v), round(st.mean(v), 2), round(med(v), 2)) for k, v in sorted(byr.items())})
    byr = collections.defaultdict(list)
    for a in A:
        if a["role"] in ("verifier", "auditor") and not a["sub"]:
            byr[(a["role"], min(a["round"], 3))].append(a["usd"])
    print("verifier/auditor $ by round:", {k: (len(v), round(st.mean(v), 2)) for k, v in sorted(byr.items())})

if on("roles"):
    print("== by role and model/effort: n, mean $, median $, mean calls, mean avg-context k, mean out k, $ split read/write/out % ==")
    g = collections.defaultdict(list)
    for a in A:
        g[(a["role"], a["model"].replace("claude-", ""), a["effort"])].append(a)
    for k, v in sorted(g.items()):
        if len(v) < 3:
            continue
        u = sum(a["usd"] for a in v)
        print("%-9s %-10s %-6s n=%3d mean$=%6.2f med$=%6.2f calls=%4d ctx=%4dk out=%4dk  read/write/out=%2.0f/%2.0f/%2.0f%%" % (k[0], k[1], k[2], len(v), u / len(v), med([a["usd"] for a in v]), st.mean([a["calls"] for a in v]), st.mean([a["ctx_avg"] for a in v]) / 1000, st.mean([a["out"] for a in v]) / 1000, 100 * sum(a["usd_cr"] for a in v) / u, 100 * sum(a["usd_cw"] for a in v) / u, 100 * sum(a["usd_out"] for a in v) / u))

if on("startup"):
    print("== startup per role (median agent): ctx0 tokens | skills loaded | skill body chars | setup-read chars | calls before first work action | ctx at first work | setup $ | prefix carry $ and % of agent $ | skill carry est $ ==")
    g = collections.defaultdict(list)
    for a in A:
        g[a["role"]].append(a)
    for role in ROLES:
        v = g[role]
        if not v:
            continue
        ratio = 3.6
        skc = [a["skill_carry"] / ratio * 0.2 / 1e6 for a in v]
        src = [a["setup_read_carry"] / ratio * 0.2 / 1e6 for a in v]
        tot = sum(a["usd"] for a in v)
        print(
            "%-9s n=%3d ctx0=%5.1fk skills=%.1f skillchars=%5.0fk setupread=%4.0fk firstwork@call=%2.0f ctx@work=%5.1fk setup$=%.2f | prefix carry: $%.0f = %.1f%% | skill-body carry: $%.0f = %.1f%% | setup-read carry: $%.0f = %.1f%%"
            % (role, len(v), med([a["ctx0"] for a in v]) / 1000, st.mean([len(a["skills"]) for a in v]), med([a["skill_chars"] for a in v]) / 1000, med([a["setup_read_chars"] for a in v]) / 1000, med([a["first_work"] for a in v]), med([a["ctx_at_work"] for a in v]) / 1000, med([a["setup_usd"] for a in v]), sum(a["prefix_carry_usd"] for a in v), 100 * sum(a["prefix_carry_usd"] for a in v) / tot, sum(skc), 100 * sum(skc) / tot, sum(src), 100 * sum(src) / tot)
        )
    sk = collections.Counter()
    for a in A:
        for s in a["skills"]:
            sk[s] += 1
    print("skill loads (count):", sk.most_common(22))

if on("prefix"):
    print("== what is in the fixed prefix (first-call context) ==")
    files = collections.defaultdict(list)
    for a in A:
        for p, n in a["instr"]:
            files[re.sub(r"agent-[0-9a-f]+", "agent-#", p)].append(n)
    for p, v in sorted(files.items(), key=lambda x: -sum(x[1]))[:14]:
        print("  instructions file %s: in %d agents, median %d chars, total %.1fM chars" % (p, len(v), med(v), sum(v) / 1e6))
    print("  skill listing chars: median %d (in %d agents)" % (med([a["listing_chars"] for a in A if a["listing_chars"]]), sum(1 for a in A if a["listing_chars"])))
    nm = [a for a in A if a["nested_chars"]]
    print("  nested_memory (extra CLAUDE.md picked up from a subfolder): %d agents, median %d chars" % (len(nm), med([a["nested_chars"] for a in nm])))
    # least-squares: ctx0 ~ a + b*(instr+listing)
    xs = [a["instr_chars"] + a["listing_chars"] for a in A if a["instr_chars"]]
    ys = [a["ctx0"] for a in A if a["instr_chars"]]
    mx, my = st.mean(xs), st.mean(ys)
    b = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / sum((x - mx) ** 2 for x in xs)
    a0 = my - b * mx
    print("  fit ctx0 = %.0f + chars/%.2f  (chars per token %.2f; the constant is system prompt + tool schemas + brief prompt)" % (a0, 1 / b, 1 / b))
    print("  ctx0 quantiles:", [sorted(ys)[int(len(ys) * q)] for q in (0.1, 0.5, 0.9)])

if on("main"):
    print("== main sessions that ran pipeline agents ==")
    P = [m for m in M if m["pipeline_agents"]]
    tu = sum(m["usd"] for m in P)
    su = sum(a["usd"] for a in A if a["story"])
    print("sessions=%d main$=%.0f vs their agents$=%.0f -> main share %.1f%%" % (len(P), tu, su, 100 * tu / (tu + su)))
    print("main $ split: cache read %.0f%%, cache write (1h) %.0f%%, output %.0f%%" % (100 * sum(m["usd_cr"] for m in P) / tu, 100 * sum(m["usd_cw"] for m in P) / tu, 100 * sum(m["usd_out"] for m in P) / tu))
    print("main calls=%d, mean context per call=%.0fk, median max context=%.0fk, calls per pipeline agent=%.1f" % (sum(m["calls"] for m in P), sum(m["ctx_avg"] * m["calls"] for m in P) / sum(m["calls"] for m in P) / 1000, med([m["ctx_max"] for m in P]) / 1000, sum(m["calls"] for m in P) / sum(m["pipeline_agents"] for m in P)))
    print("hand-back messages into main: %d, chars %.1fM (mean %.1fk each); task notifications %d" % (sum(m["handbacks"] for m in P), sum(m["handback_chars"] for m in P) / 1e6, sum(m["handback_chars"] for m in P) / max(1, sum(m["handbacks"] for m in P)) / 1000, sum(m["notif"] for m in P)))
    print("main cache rebuilds (a turn that re-writes >half its context): %d, tokens %.1fM" % (sum(m["rebuild_n"] for m in P), sum(m["rebuild_cw"] for m in P) / 1e6))
    print("main skill loads:", collections.Counter(s for m in P for s in m["skills"]).most_common(8))
    for m in sorted(P, key=lambda m: -m["usd"])[:8]:
        print("  %s %s: $%.0f calls=%d agents=%d ctx_avg=%dk ctx_max=%dk cw=%.1fM" % (m["project"][-28:], m["session"][:8], m["usd"], m["calls"], m["pipeline_agents"], m["ctx_avg"] / 1000, m["ctx_max"] / 1000, m["cw"] / 1e6))

if on("top"):
    print("== top single agents by $ ==")
    for a in sorted(A, key=lambda a: -a["usd"])[:12]:
        print("  $%.0f %s (%s %s) calls=%d ctx_avg=%dk ctx_max=%dk out=%dk rebuilds=%d | %s" % (a["usd"], a["brief"] or a["desc"], a["model"].replace("claude-", ""), a["effort"], a["calls"], a["ctx_avg"] / 1000, a["ctx_max"] / 1000, a["out"] / 1000, a["rebuild_n"], a["path"].replace(os.path.expanduser("~"), "~")))
    print("== top stories by $ ==")
    for r in sorted(ROWS, key=lambda r: -(r["sub_usd"] + r["main_usd"]))[:10]:
        print("  $%.0f %s agents=%d rev=%d fix=%d ver=%d aud=%d fin=%d" % (r["sub_usd"] + r["main_usd"], r["story"], r["agents"], r["n"]["reviewer"], r["n"]["fixer"], r["n"]["verifier"], r["n"]["auditor"], r["n"]["finisher"]))
    tot = sum(a["usd"] for a in A)
    v = sorted((a["usd"] for a in A), reverse=True)
    print("concentration: top 10%% of agents = %.0f%% of agent $; agents over 300 calls: %d = %.0f%% of $" % (100 * sum(v[: len(v) // 10]) / tot, sum(1 for a in A if a["calls"] > 300), 100 * sum(a["usd"] for a in A if a["calls"] > 300) / tot))
    for lo, hi in ((0, 50), (50, 100), (100, 200), (200, 300), (300, 9999)):
        w = [a for a in A if lo <= a["calls"] < hi]
        print("  calls %d-%d: agents=%d $=%.0f (%.0f%%) mean ctx=%dk" % (lo, hi, len(w), sum(a["usd"] for a in w), 100 * sum(a["usd"] for a in w) / tot, st.mean([a["ctx_avg"] for a in w]) / 1000 if w else 0))
    rc = collections.Counter()
    for a in A:
        for k, n in a["res_chars"].items():
            rc[k] += n
    print("tool-result chars into agent contexts (M):", {k: round(v / 1e6, 1) for k, v in rc.most_common(8)})

if on("rebuild"):
    print("== cache rebuilds in agents (5-minute cache expired while the agent waited) ==")
    tot = sum(a["usd"] for a in A)
    n = sum(a["rebuild_n"] for a in A)
    cw = sum(a["rebuild_cw"] for a in A)
    usd = sum(a["rebuild_cw"] * (10.0 if a["model"].startswith("claude-fable") else 5.0) / 1e6 for a in A)
    print("rebuilds=%d tokens=%.1fM  $%.0f = %.1f%% of agent $; agents with >=1: %d" % (n, cw / 1e6, usd, 100 * usd / tot, sum(1 for a in A if a["rebuild_n"])))
    g = collections.defaultdict(lambda: [0, 0, 0])
    for a in A:
        g[a["role"]][0] += a["rebuild_n"]
        g[a["role"]][1] += a["rebuild_cw"]
        g[a["role"]][2] += 1
    print({k: (v[0], round(v[1] / 1e6, 1), v[2]) for k, v in g.items()})

if on("hooks"):
    print("== hook send-backs and nudges in agents ==")
    tot = sum(a["usd"] for a in A)
    sh = [a for a in A if a["stop_hooks"]]
    print("agents with a Stop-hook send-back: %d of %d; send-backs: %d; $ spent after the first send-back: %.0f (%.1f%%)" % (len(sh), len(A), sum(a["stop_hooks"] for a in sh), sum(a["after_stop_usd"] for a in sh), 100 * sum(a["after_stop_usd"] for a in sh) / tot))
    print("skill-lesson nudges (PostToolUse additional context): %d, chars %.1fM, mean %.0f chars" % (sum(a["nudges"] for a in A), sum(a["nudge_chars"] for a in A) / 1e6, sum(a["nudge_chars"] for a in A) / max(1, sum(a["nudges"] for a in A))))
    print("coordinator messages (SendMessage into a running/stopped agent): %d in %d agents" % (sum(a["coord_msgs"] for a in A), sum(1 for a in A if a["coord_msgs"])))
