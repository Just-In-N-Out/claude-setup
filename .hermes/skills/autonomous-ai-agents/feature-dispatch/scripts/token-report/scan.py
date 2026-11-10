#!/usr/bin/env python3
"""Stage 1 of the pipeline token measurement.

Streams every Claude Code transcript under ~/.claude/projects (main sessions and
<session>/subagents/agent-*.jsonl) line by line and writes one compact JSON record
per transcript to scan.jsonl in this folder. No transcript text is kept except the
first 4000 characters of each transcript's first prompt (needed to map an agent to
its story and role) and short tool-call keys (tool name + file path / skill name /
first 120 chars of a command).

Usage is counted once per API response: assistant lines that repeat a message id
(one line per content block) are merged, and a message id already seen in another
transcript (a resumed session copies history) is skipped.

Run:  python3 scan.py [--root ~/.claude/projects] [--out ~/.cache/token-report] [--since 2026-10-20]
  --root   the transcript folder (Claude Code's projects folder)
  --out    the folder the four scripts share (scan.jsonl, agents.jsonl, mains.jsonl, stories.json)
"""
import glob
import json
import os
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


ROOT = os.path.expanduser(opt("--root", "~/.claude/projects"))
OUTDIR = os.path.expanduser(opt("--out", "~/.cache/token-report"))
OUT = os.path.join(OUTDIR, "scan.jsonl")
SINCE = opt("--since", "2026-10-20")

seen_global = set()


def tool_key(block):
    name = block.get("name", "")
    inp = block.get("input") or {}
    key = ""
    if name == "Skill":
        key = str(inp.get("skill", ""))
    elif name in ("Read", "Edit", "Write", "NotebookEdit"):
        key = str(inp.get("file_path", ""))
    elif name == "Bash":
        key = str(inp.get("command", ""))[:120].replace("\n", " ")
    elif name in ("Agent", "Task"):
        key = json.dumps(
            {
                "d": inp.get("description", ""),
                "m": inp.get("model", ""),
                "e": inp.get("effort", ""),
                "t": inp.get("subagent_type", ""),
                "bg": inp.get("run_in_background", None),
                "iso": inp.get("isolation", ""),
                "plen": len(str(inp.get("prompt", ""))),
                "p": str(inp.get("prompt", ""))[:600],
            }
        )
    elif name in ("Grep", "Glob"):
        key = str(inp.get("pattern", ""))[:80]
    elif name == "SendMessage":
        key = str(inp.get("to", "")) + "|" + str(len(str(inp.get("message", ""))))
    return {"n": name, "k": key, "id": block.get("id", "")}


def text_of(content):
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for b in content:
            if isinstance(b, dict):
                if b.get("type") == "text":
                    parts.append(b.get("text", ""))
                elif b.get("type") == "tool_result":
                    parts.append(text_of(b.get("content", "")))
        return "\n".join(parts)
    return ""


def scan(path, is_sub):
    rec = {
        "path": path,
        "sub": is_sub,
        "project": os.path.relpath(path, ROOT).split(os.sep)[0],
        "first_prompt": None,
        "t0": None,
        "t1": None,
        "calls": [],  # one per API response
        "user_events": [],  # main session: user/tool_result sizes by time
    }
    calls = {}
    order = []
    try:
        fh = open(path, "r", errors="replace")
    except OSError:
        return None
    with fh:
        for line in fh:
            if len(line) < 20:
                continue
            try:
                d = json.loads(line)
            except Exception:
                continue
            ts = d.get("timestamp")
            typ = d.get("type")
            if ts:
                if rec["t0"] is None:
                    rec["t0"] = ts
                rec["t1"] = ts
            if not is_sub and d.get("isSidechain"):
                continue
            msg = d.get("message")
            if typ == "user" and isinstance(msg, dict):
                content = msg.get("content")
                if rec["first_prompt"] is None and not d.get("isMeta"):
                    rec["first_prompt"] = text_of(content)[:4000]
                # size and kind of what entered the context
                kinds = []
                if isinstance(content, str):
                    kinds.append(("text", len(content), "", content[:160]))
                elif isinstance(content, list):
                    for b in content:
                        if not isinstance(b, dict):
                            continue
                        if b.get("type") == "tool_result":
                            t = text_of(b.get("content", ""))
                            kinds.append(("tool_result", len(t), b.get("tool_use_id", ""), ""))
                        elif b.get("type") == "text":
                            t = b.get("text", "")
                            kinds.append(("text", len(t), "", t[:160]))
                rec["user_events"].append({"ts": ts, "meta": bool(d.get("isMeta")), "k": kinds})
            elif typ == "attachment":
                att = d.get("attachment") or {}
                size = len(json.dumps(att))
                atype = str(att.get("type", ""))
                head = str(att.get("hookName", "") or att.get("hookEvent", ""))[:80]
                if atype == "instructions":
                    head = json.dumps([[f.get("path", ""), len(str(f.get("content", "")))] for f in att.get("files") or [] if isinstance(f, dict)])
                    size = sum(len(str(f.get("content", ""))) for f in att.get("files") or [] if isinstance(f, dict))
                elif atype == "skill_listing":
                    size = len(str(att.get("content", "")))
                    head = str(att.get("skillCount", ""))
                elif atype == "nested_memory":
                    c = att.get("content") or {}
                    size = len(str(c.get("content", ""))) if isinstance(c, dict) else size
                    head = str(att.get("path", ""))
                elif atype == "hook_additional_context":
                    size = len(json.dumps(att.get("content", "")))
                rec["user_events"].append({"ts": ts, "meta": True, "k": [("attachment:" + atype, size, "", head)]})
            elif typ == "assistant" and isinstance(msg, dict):
                mid = msg.get("id") or d.get("uuid")
                u = msg.get("usage") or {}
                model = msg.get("model") or ""
                if model == "<synthetic>":
                    continue
                c = calls.get(mid)
                if c is None:
                    if mid in seen_global:
                        continue
                    c = {"ts": ts, "model": model, "in": 0, "cw": 0, "cr": 0, "out": 0, "cw1h": 0, "tools": [], "txt": 0, "think": 0}
                    calls[mid] = c
                    order.append(mid)
                c["in"] = max(c["in"], u.get("input_tokens") or 0)
                c["cw"] = max(c["cw"], u.get("cache_creation_input_tokens") or 0)
                c["cr"] = max(c["cr"], u.get("cache_read_input_tokens") or 0)
                c["out"] = max(c["out"], u.get("output_tokens") or 0)
                cc = u.get("cache_creation") or {}
                c["cw1h"] = max(c["cw1h"], cc.get("ephemeral_1h_input_tokens") or 0)
                for b in msg.get("content") or []:
                    if not isinstance(b, dict):
                        continue
                    if b.get("type") == "tool_use":
                        c["tools"].append(tool_key(b))
                    elif b.get("type") == "text":
                        c["txt"] += len(b.get("text", ""))
                    elif b.get("type") == "thinking":
                        c["think"] += len(b.get("thinking", "") or "")
    for mid in order:
        seen_global.add(mid)
        rec["calls"].append(calls[mid])
    if is_sub:
        meta_path = path[: -len(".jsonl")] + ".meta.json"
        try:
            with open(meta_path) as mf:
                rec["meta"] = json.load(mf)
        except Exception:
            rec["meta"] = {}
        # sub-agent user events are only needed in small form
        rec["user_events"] = [e for e in rec["user_events"]][:4000]
    return rec


def main():
    mains = sorted(glob.glob(os.path.join(ROOT, "*", "*.jsonl")))
    subs = sorted(glob.glob(os.path.join(ROOT, "*", "*", "subagents", "*.jsonl")))
    subs += sorted(glob.glob(os.path.join(ROOT, "*", "*", "subagents", "*", "*.jsonl")))
    n = 0
    os.makedirs(OUTDIR, exist_ok=True)
    with open(OUT, "w") as out:
        # subagents first, so a main transcript that embeds them does not claim their usage
        for is_sub, files in ((True, subs), (False, mains)):
            for p in files:
                try:
                    if os.path.getmtime(p) < __import__("datetime").datetime.fromisoformat(SINCE).timestamp():
                        continue
                except OSError:
                    continue
                rec = scan(p, is_sub)
                if rec and (rec["calls"] or rec["first_prompt"]):
                    out.write(json.dumps(rec) + "\n")
                    n += 1
    print("transcripts written:", n, "->", OUT)


if __name__ == "__main__":
    main()
