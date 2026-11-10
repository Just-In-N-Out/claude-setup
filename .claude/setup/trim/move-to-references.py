#!/usr/bin/env python3
"""move-to-references.py: apply a trim map (story dream-trim, ~/.hermes/plans/claude-setup/dream-trim.md).

  move-to-references.py --map maps/<name>.json --root <tree> [--dry-run]

<tree> is a folder with the setup repo's $HOME-relative layout (a worktree, a scratch export, or $HOME). For each
group in the map, the whole lines it names leave the main file and go, byte for byte and in order, into the group's
references/ file under the group's heading (a new file starts with the map's one-line header; an existing one only
gains lines at its end). A group can name parent lines to copy above its moved lines (a sub-bullet's parent stays in
the main file). Each group leaves one pointer line: after its `pointer_after` anchor line when the map gives one,
else where its last moved line was. Headings never move.

A line spec is {anchor, offset=0} plus count (default 1), through (the last line's anchor) or until_outdent (the
indented lines from there up to the next line at column 0: a bullet's nested lines). An anchor is the start of a
line (its first 60 characters, cut before text that changes on its own, like a build number) and must match exactly
one line, or the mover stops with exit 2 and writes nothing. So
a rerun on a tree it already moved stops at the first missing anchor, and a rerun on a newer base moves the same
lines wherever they now are. Proof that nothing was lost: trim-check.py pass1.
"""
import argparse
import json
import os
import sys


class MapError(Exception):
    pass


def read(path):
    with open(path, encoding='utf-8', newline='') as f:
        return f.read()


def find_one(lines, anchor, where):
    if not isinstance(anchor, str) or not anchor:
        raise MapError(f"{where}: empty anchor")
    hits = [i for i, l in enumerate(lines) if l.startswith(anchor)]
    if len(hits) != 1:
        raise MapError(f"{where}: anchor {'missing' if not hits else f'matches {len(hits)} lines'}: {anchor!r}")
    return hits[0]


def select(lines, spec, where):
    start = find_one(lines, spec.get('anchor'), where) + int(spec.get('offset', 0))
    if 'through' in spec:
        end = find_one(lines, spec['through'], where)
    elif spec.get('until_outdent'):  # a bullet's indented lines, up to the next line that starts at column 0
        end = start
        while end < len(lines) and lines[end].startswith(' '):
            end += 1
        end -= 1
    else:
        end = start + int(spec.get('count', 1)) - 1
    if start < 0 or end < start or end >= len(lines):
        raise MapError(f"{where}: {spec!r} selects no valid range")
    return list(range(start, end + 1))


def plan(m, root):
    """Everything the map would write, as {path: text}, or MapError before anything is written."""
    writes, blocks = {}, {}  # blocks: target -> [(heading, header, parent lines, moved lines)]
    mains = {e['path'] for e in m.get('files', [])}
    for entry in m.get('files', []):
        f = entry['path']
        try:
            text = read(os.path.join(root, f))
        except OSError as e:
            raise MapError(f"{f}: can't read: {e}")
        lines = text.split('\n')
        moved, at_moved, after = set(), {}, {}
        for gi, g in enumerate(entry.get('groups', [])):
            where = f"{f} group {gi + 1}"
            for k in ('target', 'heading', 'pointer'):
                if not isinstance(g.get(k), str) or not g[k]:
                    raise MapError(f"{where}: no {k}")
            if '\n' in g['pointer'] or not g['heading'].startswith('#'):
                raise MapError(f"{where}: the pointer must be one line and the heading a markdown heading")
            if g['target'] in mains:
                raise MapError(f"{where}: target {g['target']} is a main file")
            idx = sorted({i for spec in g.get('lines', []) for i in select(lines, spec, where)})
            if not idx:
                raise MapError(f"{where}: moves no lines")
            for i in idx:
                if i in moved:
                    raise MapError(f"{where}: line {i + 1} is moved by an earlier group too")
                if lines[i].startswith('#'):
                    raise MapError(f"{where}: line {i + 1} is a heading; headings stay: {lines[i][:60]!r}")
            moved.update(idx)
            parent = [lines[i] for spec in g.get('parent', []) for i in select(lines, spec, where + ' parent')]
            if g.get('pointer_after'):
                a = find_one(lines, g['pointer_after'], where + ' pointer_after')
                after.setdefault(a, []).append(g['pointer'])
            else:
                at_moved.setdefault(idx[-1], []).append(g['pointer'])
            blocks.setdefault(g['target'], []).append((g['heading'], g.get('header'), parent, [lines[i] for i in idx]))
        for a in after:
            if a in moved:
                raise MapError(f"{f}: a pointer_after anchor names a moved line (line {a + 1})")
        out = []
        for i, l in enumerate(lines):
            if i in moved:
                out += at_moved.get(i, [])
                continue
            out.append(l)
            out += after.get(i, [])
        writes[f] = '\n'.join(out)
    for t, bl in blocks.items():
        path = os.path.join(root, t)
        if os.path.exists(path):
            out = read(path).split('\n')
            if out and out[-1] == '':
                out.pop()
        else:
            header = next((h for _, h, _, _ in bl if h), None)
            if not header or '\n' in header or not header.startswith('# '):
                raise MapError(f"{t}: a new references file needs a one-line '# ' header in the map")
            out = [header]
        last = None
        for heading, _, parent, moved_lines in bl:
            if heading != last:
                out += ['', heading, '']
                last = heading
            out += parent + moved_lines
        writes[t] = '\n'.join(out) + '\n'
    return writes


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--map', required=True)
    ap.add_argument('--root', required=True)
    ap.add_argument('--dry-run', action='store_true', help='print what would change, write nothing')
    a = ap.parse_args(argv)
    try:
        with open(a.map, encoding='utf-8') as f:
            m = json.load(f)
        writes = plan(m, a.root)
    except (OSError, ValueError, MapError) as e:
        print(f"move-to-references: {e}; nothing written", file=sys.stderr)
        return 2
    for p, text in writes.items():
        path = os.path.join(a.root, p)
        before = len(read(path)) if os.path.exists(path) else 0
        print(f"{p}: {before} -> {len(text)} chars")
        if not a.dry_run:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, 'w', encoding='utf-8', newline='') as f:
                f.write(text)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
