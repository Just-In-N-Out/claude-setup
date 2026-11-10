#!/usr/bin/env python3
"""trim-check.py: prove a trim of instruction files lost nothing (story dream-trim, ~/.hermes/plans/claude-setup/dream-trim.md).

Trees are folders with the setup repo's $HOME-relative layout (a `git archive` export, a worktree, or $HOME). The map
(maps/<name>.json) names, per main file, the groups of whole lines that move into a references/ file, and the one
pointer line each group leaves behind. Characters are counted as Python len() of the file's text.

  trim-check.py pass1    --map M --base B --head H     lossless move: kept lines unchanged, only pointers added,
                                                       every moved line byte for byte in its references/ file, in order
  trim-check.py size     --root R FILE[=MAX] ...       characters per file; over MAX fails (no MAX: room to 100,000)
  trim-check.py headings --map M --base B --head H     every ## / ### heading of B still in H; every pointer resolves
  trim-check.py protect  --map M --root P [--out F] [--check H]
                                                       list the protected safety lines of P (TSV); with --check, fail
                                                       when one of them is not in the same file of H byte for byte
  trim-check.py dupes    --map M --root R [--top N]    duplicate passages (200+ chars, 70%+ overlap) and self-marked
                                                       superseded lines: the pass-2 candidates, largest first
  trim-check.py pass2    --map M --base P1 --head P2 --ledger L
                                                       every line pass 2 removed or changed has a ledger row whose
                                                       kept line exists in P2

Exit 0 when the check passes, 1 when it fails (each failure is a `FAIL <file>: …` line naming the line), 2 on a usage
or setup error (a missing map, an anchor that is missing or matches more than one line).
"""
import argparse
import difflib
import hashlib
import json
import os
import re
import sys

LIMIT = 100000  # Hermes' skill size limit (~/.claude/CLAUDE.md "Keep skills lean")


class SetupError(Exception):
    pass


def read_lines(path):
    with open(path, encoding='utf-8', newline='') as f:
        return f.read().split('\n')


def preview(line, n=80):
    return line[:n]


def sha1(line):
    return hashlib.sha1(line.encode('utf-8')).hexdigest()


def load_map(path):
    try:
        with open(path, encoding='utf-8') as f:
            m = json.load(f)
    except (OSError, ValueError) as e:
        raise SetupError(f"can't read map {path}: {e}")
    if not isinstance(m.get('files'), list):
        raise SetupError(f"map {path} has no files list")
    return m


def find_one(lines, anchor, where):
    if not isinstance(anchor, str) or not anchor:
        raise SetupError(f"{where}: empty anchor")
    hits = [i for i, l in enumerate(lines) if l.startswith(anchor)]
    if len(hits) != 1:
        raise SetupError(f"{where}: anchor {'missing' if not hits else f'matches {len(hits)} lines'}: {anchor!r}")
    return hits[0]


def resolve(lines, spec, where):
    """A line spec: {anchor, offset=0} plus count (default 1), through (an anchor) or until_outdent (the indented
    lines from there up to the next line that does not start with a space); returns 0-based line indexes."""
    start = find_one(lines, spec.get('anchor'), where) + int(spec.get('offset', 0))
    if 'through' in spec:
        end = find_one(lines, spec['through'], where)
    elif spec.get('until_outdent'):
        end = start - 1
        while end + 1 < len(lines) and lines[end + 1].startswith(' '):
            end += 1
    else:
        end = start + int(spec.get('count', 1)) - 1
    if start < 0 or end < start or end >= len(lines):
        raise SetupError(f"{where}: spec {spec!r} selects no valid range")
    return list(range(start, end + 1))


def groups_of(entry, lines, fname):
    """Resolve every group of a map file entry against its source lines: [(group, moved idx, parent idx)]."""
    out, seen = [], {}
    for gi, g in enumerate(entry.get('groups', [])):
        where = f"{fname} group {gi + 1}"
        moved = sorted({i for spec in g.get('lines', []) for i in resolve(lines, spec, where)})
        if not moved:
            raise SetupError(f"{where}: moves no lines")
        parent = [i for spec in g.get('parent', []) for i in resolve(lines, spec, where + ' parent')]
        for i in moved:
            if i in seen:
                raise SetupError(f"{where}: line {i + 1} is also moved by group {seen[i] + 1}")
            seen[i] = gi
        for k in ('target', 'heading', 'pointer'):
            if not isinstance(g.get(k), str) or not g[k]:
                raise SetupError(f"{where}: no {k}")
        out.append((g, moved, parent))
    return out


def report(fails):
    for f in fails:
        print(f"FAIL {f}")
    return 1 if fails else 0


# ---------------------------------------------------------------- pass1
def check_pass1(m, base, head):
    fails = []
    targets = {}  # target path -> list of (group, moved lines, source file)
    base_lines_of = {}
    for entry in m['files']:
        f = entry['path']
        try:
            b = read_lines(os.path.join(base, f))
        except OSError:
            raise SetupError(f"{f}: not in the base tree {base}")
        try:
            h = read_lines(os.path.join(head, f))
        except OSError:
            fails.append(f"{f}: missing from the head tree")
            continue
        base_lines_of[f] = b
        groups = groups_of(entry, b, f)
        moved = {i for _, idx, _ in groups for i in idx}
        expected = [l for i, l in enumerate(b) if i not in moved]
        # head minus one copy of each pointer line must equal base minus the moved lines
        head_no = list(range(1, len(h) + 1))  # head line number of each line still in rest
        rest = list(h)
        for g, _, _ in groups:
            if g['pointer'] in rest:
                j = rest.index(g['pointer'])
                del rest[j], head_no[j]
            else:
                fails.append(f"{f}: pointer line missing: {preview(g['pointer'])}")
        sm = difflib.SequenceMatcher(None, expected, rest, autojunk=False)
        base_no = [i + 1 for i in range(len(b)) if i not in moved]  # base line number of each expected line
        for op, i1, i2, j1, j2 in sm.get_opcodes():
            if op == 'equal':
                continue
            for i in range(i1, i2):
                fails.append(f"{f}: kept line {base_no[i]} missing or changed in the head: {preview(expected[i])}")
            for j in range(j1, j2):
                fails.append(f"{f}: head line {head_no[j]} is new and not a pointer (or a moved line "
                             f"left behind): {preview(rest[j])}")
        for g, idx, _ in groups:
            targets.setdefault(g['target'], []).append((g, [b[i] for i in idx], f))
    for t, glist in targets.items():
        fails += check_target(t, glist, base, head, base_lines_of)
    return fails


def check_target(t, glist, base, head, base_lines_of):
    fails = []
    try:
        h = read_lines(os.path.join(head, t))
    except OSError:
        return [f"{t}: missing from the head tree"]
    start = 0
    try:
        old = read_lines(os.path.join(base, t))
        prefix = old[:-1] if old and old[-1] == '' else old
        if h[:len(prefix)] != prefix:
            sm = difflib.SequenceMatcher(None, prefix, h[:len(prefix)], autojunk=False)
            for op, i1, i2, _, _ in sm.get_opcodes():
                for i in range(i1, i2) if op != 'equal' else ():
                    fails.append(f"{t}: existing line {i + 1} missing or changed (an existing references file "
                                 f"only gains lines): {preview(prefix[i])}")
            return fails
        start = len(prefix)
    except OSError:
        pass
    allowed = set()
    for g, _, f in glist:
        allowed.update(base_lines_of[f])
    expected = [(g, l, k == 0, f) for g, lines, f in glist for k, l in enumerate(lines)]
    k, heading = 0, None
    for j in range(start, len(h)):
        line = h[j]
        if k < len(expected) and line == expected[k][1]:
            g, _, first, _ = expected[k]
            if first and heading != g['heading']:
                fails.append(f"{t}: line {j + 1} starts a moved group under {heading!r}, not under its heading "
                             f"{g['heading']!r}: {preview(line)}")
            k += 1
        elif line.startswith('#'):
            heading = line
        elif line == '' or line in allowed:
            pass
        else:
            fails.append(f"{t}: line {j + 1} is not a moved line, a copy of a base line, a heading or blank: "
                         f"{preview(line)}")
    if k < len(expected):
        _, line, _, f = expected[k]
        fails.append(f"{t}: moved line missing, changed or out of order (from {f}): {preview(line)}")
    return fails


# ---------------------------------------------------------------- size
def check_size(root, specs):
    fails = []
    for spec in specs:
        f, _, mx = spec.partition('=')
        try:
            n = len(open(os.path.join(root, f), encoding='utf-8', newline='').read())
        except OSError:
            fails.append(f"{f}: missing from {root}")
            continue
        if mx:
            mx = int(mx)
            print(f"{f}: {n} characters, target {mx}: {'ok' if n <= mx else f'over by {n - mx}'}")
            if n > mx:
                fails.append(f"{f}: {n} characters is over its target of {mx}")
        else:
            print(f"{f}: {n} characters, room {LIMIT - n} below {LIMIT}")
    return fails


# ---------------------------------------------------------------- headings and pointers
ABS_REF = re.compile(r'~/(\.hermes/skills/[\w./-]+?/references/[\w.-]+\.md)')
REL_REF = re.compile(r'(?<![\w/.~-])(references/[\w.-]+\.md)')


def refs_in(line, f, root):
    """(shown path, path in root, label or None) for each references/ path the line names."""
    out = []
    for rx, absolute in ((ABS_REF, True), (REL_REF, False)):
        for mt in rx.finditer(line):
            path = os.path.join(root, mt.group(1)) if absolute else os.path.join(root, os.path.dirname(f), mt.group(1))
            lab = re.match(r'`?\s*→\s*"([^"]+)"', line[mt.end():])
            out.append((mt.group(0), path, lab.group(1) if lab else None))
    return out


def check_headings(m, base, head):
    from collections import Counter
    fails = []
    for entry in m['files']:
        f = entry['path']
        try:
            b = read_lines(os.path.join(base, f))
        except OSError:
            raise SetupError(f"{f}: not in the base tree {base}")
        try:
            h = read_lines(os.path.join(head, f))
        except OSError:
            fails.append(f"{f}: missing from the head tree")
            continue
        is_h = lambda l: l.startswith('## ') or l.startswith('### ')
        hb, hh = Counter(filter(is_h, b)), Counter(filter(is_h, h))
        for l in b:
            if is_h(l) and hh[l] < hb[l]:
                fails.append(f"{f}: heading missing or changed: {preview(l)}")
                hh[l] = hb[l]  # report each heading once
        for g in entry.get('groups', []):
            if g['pointer'] not in h:
                fails.append(f"{f}: pointer line missing: {preview(g['pointer'])}")
        old = set(b)
        for j, l in enumerate(h):
            if l in old:
                continue
            for shown, path, label in refs_in(l, f, head):
                if not os.path.isfile(path):
                    fails.append(f"{f}: line {j + 1} points at {shown}, which does not exist: {preview(l)}")
                elif label is not None:
                    want = label.strip()
                    if not any(t.lstrip('#').strip() == want for t in read_lines(path) if t.startswith('#')):
                        fails.append(f"{f}: line {j + 1} points at heading \"{want}\", which {shown} does not "
                                     f"have: {preview(l)}")
    return fails


# ---------------------------------------------------------------- protect
RULE = re.compile(r"\b(never|don't|don’t|do not|only when|must|refuse)", re.I)
SAFETY = re.compile(r'push|merge|force|author|identity|co-authored|gh auth|credential|approv|"go"|“go”|guard|secret|'
                    r'token|domain|claude\.md|stash|reset|prune|delete', re.I)


def scope_files(m):
    """The main files, then every references/ file the map writes, each once."""
    out = [e['path'] for e in m['files']]
    for e in m['files']:
        for g in e.get('groups', []):
            if g['target'] not in out:
                out.append(g['target'])
    return out


def section_lines(lines, sec, where):
    if 'heading' in sec:
        hits = [i for i, l in enumerate(lines) if l.startswith('#') and l.startswith(sec['heading'])]
        if len(hits) != 1:
            raise SetupError(f"{where}: protected section heading {'missing' if not hits else 'not unique'}: "
                             f"{sec['heading']!r}")
        i = hits[0]
        level = len(lines[i]) - len(lines[i].lstrip('#'))
        j = i + 1
        while j < len(lines) and not (lines[j].startswith('#') and len(lines[j]) - len(lines[j].lstrip('#')) <= level):
            j += 1
        return range(i, j)
    return resolve(lines, sec, where)


def protected(m, root):
    """[(file, line number, line)] of every protected line in the tree at root."""
    secs = m.get('protect', {}).get('sections', [])
    out = []
    for f in scope_files(m):
        path = os.path.join(root, f)
        if not os.path.isfile(path):
            continue
        lines = read_lines(path)
        inside = set()
        for k, s in enumerate(secs):
            if s['file'] == f:
                inside.update(section_lines(lines, s, f"protect section {k + 1}"))
        for i, l in enumerate(lines):
            if l.strip() and (i in inside or (RULE.search(l) and SAFETY.search(l))):
                out.append((f, i + 1, l))
    for k, s in enumerate(secs):
        if s['file'] not in scope_files(m):
            raise SetupError(f"protect section {k + 1}: {s['file']} is not a file of the map")
    return out


def check_protect(m, root, out_path, check):
    from collections import Counter
    plist = protected(m, root)
    rows = [f"{f}\t{sha1(l)}\t{n}\t{preview(l).replace(chr(9), ' ')}" for f, n, l in plist]
    if out_path:
        with open(out_path, 'w', encoding='utf-8') as fh:
            fh.write('# file\tsha1\tline\tfirst 80 characters\n' + '\n'.join(rows) + '\n')
    print(f"# {len(plist)} protected lines in {len(scope_files(m))} files of {root}")
    if not check:
        return []
    fails, have = [], {}
    want = Counter((f, sha1(l)) for f, _, l in plist)
    for f, n, l in plist:
        if f not in have:
            try:
                have[f] = Counter(sha1(x) for x in read_lines(os.path.join(check, f)))
            except OSError:
                have[f] = Counter()
        if have[f][sha1(l)] < want[(f, sha1(l))]:
            fails.append(f"{f}: protected line {n} missing or changed in {check}: {preview(l)}")
            want[(f, sha1(l))] = 0  # report once
    return fails


# ---------------------------------------------------------------- dupes
OLD = re.compile(r'[Ss]uperseded|[Tt]his replaces the')


def passages(lines):
    """(first line number, text) per bullet or paragraph, a wrapped bullet's lines joined."""
    out, cur = [], None
    for i, l in enumerate(lines):
        s = l.lstrip(' ')
        starts = not l.startswith(' ') or re.match(r'(- |\d+[.)] |\* )', s)
        if not s or s.startswith('#') or s.startswith('```') or s.startswith('|'):
            cur = None
            continue
        if starts or cur is None:
            cur = [i + 1, s]
            out.append(cur)
        else:
            cur[1] += ' ' + s
    return [(n, t) for n, t in out]


def dupes(m, root, top, minimum=70):
    """Pass-2 candidates. A parent line pass 1 copied into a references/ file on purpose is not a duplicate."""
    shingles, info = {}, []
    targets = set(scope_files(m)) - {e['path'] for e in m['files']}
    for f in scope_files(m):
        path = os.path.join(root, f)
        if not os.path.isfile(path):
            continue
        for n, t in passages(read_lines(path)):
            if OLD.search(t):
                info.append((len(t), 100, f"{f}:{n}", 'self-marked old', t))
            if len(t) < 200:
                continue
            w = re.findall(r'\w+', t.lower())
            sh = {' '.join(w[k:k + 5]) for k in range(max(1, len(w) - 4))}
            shingles[(f, n)] = (t, sh)
    index = {}
    for key, (_, sh) in shingles.items():
        for s in sh:
            index.setdefault(s, []).append(key)
    pairs = {}
    for s, keys in index.items():
        if len(keys) > 30:
            continue  # boilerplate
        for x in range(len(keys)):
            for y in range(x + 1, len(keys)):
                pairs[(keys[x], keys[y])] = pairs.get((keys[x], keys[y]), 0) + 1
    for (a, b), common in pairs.items():
        ta, sa = shingles[a]
        tb, sb = shingles[b]
        ov = common / min(len(sa), len(sb))
        if ta == tb and (a[0] in targets or b[0] in targets):
            continue  # an exact copy in a references/ file: the parent copy of rule 4
        if ov >= minimum / 100:
            small, big = (a, b) if len(ta) <= len(tb) else (b, a)
            info.append((min(len(ta), len(tb)), round(ov * 100), f"{small[0]}:{small[1]}",
                         f"{big[0]}:{big[1]}", shingles[small][0]))
    info.sort(key=lambda r: -r[0])
    print(f"# {len(info)} pass-2 candidates in {root} ({minimum}%+ overlap), largest first (chars of the smaller "
          f"copy, % overlap)")
    for r in info[:top]:
        print(f"{r[0]}\t{r[1]}%\t{r[2]}\t{r[3]}\t{preview(r[4])}")
    return []


# ---------------------------------------------------------------- pass2
def parse_ledger(path):
    try:
        lines = read_lines(path)
    except OSError:
        raise SetupError(f"no ledger at {path}")
    cols, rows = None, []
    for l in lines:
        s = l.strip()
        if not s.startswith('|'):
            continue
        s = s[1:]
        if s.endswith('|') and not s.endswith('\\|'):
            s = s[:-1]
        cells = [c.strip().replace('\\|', '|') for c in re.split(r'(?<!\\)\|', s)]
        if cols is None:
            low = [c.lower() for c in cells]
            if 'old sha1' in low and 'kept sha1' in low:
                cols = low
            continue
        if set(''.join(cells)) <= set('-: '):
            continue
        rows.append(dict(zip(cols, cells)))
    if cols is None:
        raise SetupError(f"{path}: no ledger table (a header row with 'old sha1' and 'kept sha1')")
    for k in ('file', 'kind', 'old sha1', 'kept in', 'kept sha1'):
        if k not in cols:
            raise SetupError(f"{path}: the ledger table has no '{k}' column")
    return rows


def check_pass2(m, p1, p2, ledger):
    rows = parse_ledger(ledger)
    by_old = {}
    for r in rows:
        by_old.setdefault((r['file'], r['old sha1']), []).append(r)
    fails, n_removed = [], 0
    for f in scope_files(m):
        try:
            a = read_lines(os.path.join(p1, f))
        except OSError:
            continue
        try:
            b = read_lines(os.path.join(p2, f))
        except OSError:
            b = []
        sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
        for op, i1, i2, _, _ in sm.get_opcodes():
            if op not in ('delete', 'replace'):
                continue
            for i in range(i1, i2):
                if not a[i].strip():
                    continue  # a blank line carries no meaning
                n_removed += 1
                rs = by_old.get((f, sha1(a[i])))
                if not rs:
                    fails.append(f"{f}: line {i + 1} was removed or changed in pass 2 with no ledger row: "
                                 f"{preview(a[i])}")
                    continue
                r = rs[0]
                if r['kind'] not in ('duplicate-of', 'superseded-by'):
                    fails.append(f"{f}: ledger row for line {i + 1} has kind {r['kind']!r}, want duplicate-of or "
                                 f"superseded-by: {preview(a[i])}")
                k = f if r['kept in'] in ('', 'same') else r['kept in']
                try:
                    kept = {sha1(x) for x in read_lines(os.path.join(p2, k))}
                except OSError:
                    kept = set()
                if r['kept sha1'] not in kept:
                    fails.append(f"{f}: the ledger row for line {i + 1} names a kept line (sha1 {r['kept sha1'][:12]} "
                                 f"in {k}) that is not in the pass-2 tree: {preview(a[i])}")
    print(f"# {n_removed} lines removed or changed in pass 2, {len(rows)} ledger rows")
    return fails


# ---------------------------------------------------------------- main
def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = ap.add_subparsers(dest='mode', required=True)
    for name in ('pass1', 'headings'):
        p = sub.add_parser(name)
        p.add_argument('--map', required=True)
        p.add_argument('--base', required=True)
        p.add_argument('--head', required=True)
    p = sub.add_parser('size')
    p.add_argument('--root', required=True)
    p.add_argument('files', nargs='+', metavar='FILE[=MAX]')
    p = sub.add_parser('protect')
    p.add_argument('--map', required=True)
    p.add_argument('--root', required=True)
    p.add_argument('--out')
    p.add_argument('--check')
    p = sub.add_parser('dupes')
    p.add_argument('--map', required=True)
    p.add_argument('--root', required=True)
    p.add_argument('--top', type=int, default=60)
    p.add_argument('--min', type=int, default=70, help='overlap percent (default 70)')
    p = sub.add_parser('pass2')
    p.add_argument('--map', required=True)
    p.add_argument('--base', required=True)
    p.add_argument('--head', required=True)
    p.add_argument('--ledger', required=True)
    a = ap.parse_args(argv)
    try:
        if a.mode == 'pass1':
            return report(check_pass1(load_map(a.map), a.base, a.head))
        if a.mode == 'headings':
            return report(check_headings(load_map(a.map), a.base, a.head))
        if a.mode == 'size':
            return report(check_size(a.root, a.files))
        if a.mode == 'protect':
            return report(check_protect(load_map(a.map), a.root, a.out, a.check))
        if a.mode == 'dupes':
            return report(dupes(load_map(a.map), a.root, a.top, a.min))
        if a.mode == 'pass2':
            return report(check_pass2(load_map(a.map), a.base, a.head, a.ledger))
    except SetupError as e:
        print(f"trim-check: {e}", file=sys.stderr)
        return 2
    return 2


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
