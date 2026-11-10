"""What the dream may edit (conf/targets.txt, DREAM.md section 5), the narrowest place for a finding
(section 6), the editor's copy and its diff (plan "One run", step 5)."""
import difflib
import fnmatch
import os
from pathlib import Path

from . import paths

SKIP_DIRS = {".hub", ".locks", ".git", "node_modules", "__pycache__"}


# ---------- projects ----------

def projects(env):
    rows = []
    for r in paths.read_tsv(env.conf / "projects.tsv"):
        if len(r) >= 4:
            rows.append({"glob": r[0], "name": r[1], "skill": r[2], "rm": r[3]})
    return rows


def project_of(env, folder):
    for r in projects(env):
        if fnmatch.fnmatchcase(folder, r["glob"]):
            return dict(r, folder=folder)
    return {"glob": folder, "name": folder, "skill": None, "rm": None, "folder": folder}


def general_rm(env):
    for r in projects(env):
        if r["name"] == "claude-setup":
            return r["rm"]
    return None


def rm_for_project(env, name):
    """The repeat-mistakes file of an evidence project (claude-setup and unknown projects: the general one)."""
    for r in projects(env):
        if r["name"] == name and name != "claude-setup":
            return r["rm"]
    return general_rm(env)


def skill_of_rm(rm):
    """The skill name a repeat-mistakes file belongs to (for enforce-backlog lines)."""
    parts = Path(rm).parts
    return parts[parts.index("references") - 1] if "references" in parts else Path(rm).parent.name


# ---------- the allowlist ----------

def load_rules(env):
    rules = {"allow": [], "append": [], "dream": [], "never": []}
    for r in paths.read_tsv(env.conf / "targets.txt"):
        if len(r) >= 2 and r[0] in rules:
            rules[r[0]].append(r[1])
    return rules


def kind_of(rules, real_rel):
    """allow, append or dream for a $HOME-relative REAL path; None when it is not writable (never wins)."""
    if any(paths.glob_match(g, real_rel) for g in rules["never"]):
        return None
    for k in ("allow", "append", "dream"):
        if any(paths.glob_match(g, real_rel) for g in rules[k]):
            return k
    return None


def through_link(env, rel):
    """True when a component of $HOME/<rel> (the file itself or a folder above it) is a symlink."""
    p = env.home
    for part in Path(rel).parts:
        p = p / part
        if p.is_symlink():
            return True
    return False


def is_library(rel):
    return rel.startswith(".hermes/skills-library/")


def library_skill(rel):
    parts = Path(rel).parts
    return parts[3] if len(parts) > 3 and parts[2] == "skills" else None


# ---------- the narrowest place ----------

def memory_dir(env, folder):
    return env.real_rel(".claude/projects/%s/memory" % folder)


def scope_for(env, finding):
    """$HOME-relative real prefixes a finding may change: its project's memory folder, project skill and
    project CLAUDE.md copy; ["*"] (anything allowed) when it is general or seen in two projects."""
    if finding.get("general") or finding.get("two_projects"):
        return ["*"]
    proj = project_of(env, finding["folder"])
    out = [memory_dir(env, finding["folder"]) + "/"]
    if proj.get("skill"):
        out.append(env.real_rel(proj["skill"]) + "/")
    doc = ".claude/project-docs/%s/CLAUDE.md" % proj["name"]
    if (env.home / doc).is_file():
        out.append(doc)
    return out


def in_scope(scope, rel):
    return "*" in scope or any(rel == s or (s.endswith("/") and rel.startswith(s)) for s in scope)


def _walk_md(env, rel_dir):
    root = env.home / rel_dir
    if not root.is_dir():
        return []
    real_root = Path(os.path.realpath(root))
    out = []
    for d, dirs, files in os.walk(real_root, followlinks=False):
        dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS and not os.path.islink(os.path.join(d, x)))
        for f in sorted(files):
            full = Path(d) / f
            if f.endswith(".md") and not full.is_symlink():
                out.append(env.real_rel(full))
    return out


def all_target_files(env, rules):
    found = set()
    if (env.home / ".claude/CLAUDE.md").is_file():
        found.add(env.real_rel(".claude/CLAUDE.md"))
    for d in sorted((env.home / ".claude/project-docs").glob("*/CLAUDE.md")):
        found.add(env.real_rel(d))
    for d in sorted(env.projects_dir.glob("*/memory")) if env.projects_dir.is_dir() else []:
        found.update(_walk_md(env, env.rel(d)))
    found.update(_walk_md(env, ".hermes/skills"))
    found.update(_walk_md(env, ".hermes/skills-library/skills"))
    return sorted(f for f in found if kind_of(rules, f) == "allow")


def files_for(env, rules, findings, orders):
    """The files the editor gets in its copy: every file its findings may change (all targets when one is
    general), the global CLAUDE.md to search, and the files the orders name."""
    scopes = [scope_for(env, f) for f in findings]
    if any("*" in s for s in scopes):
        files = set(all_target_files(env, rules))
    else:
        files = set()
        for s in scopes:
            for prefix in s:
                if prefix.endswith("/"):
                    files.update(_walk_md(env, prefix.rstrip("/")))
                elif (env.home / prefix).is_file():
                    files.add(env.real_rel(prefix))
        if (env.home / ".claude/CLAUDE.md").is_file():
            files.add(env.real_rel(".claude/CLAUDE.md"))
    for o in orders:
        for k in ("file", "to"):
            if o.get(k) and (env.home / o[k]).is_file():
                files.add(env.real_rel(o[k]))
    return sorted(f for f in files if kind_of(rules, f) == "allow")


# ---------- the copy ----------

def copy_rel(live):
    parts = live.split("/")
    if parts[0].startswith("."):
        parts[0] = parts[0][1:]
    return "/".join(parts)


def live_rel(copy):
    parts = copy.split("/")
    parts[0] = "." + parts[0]
    return "/".join(parts)


def build_copy(env, run_dir, files):
    """Real files (no links) under <run>/copy and <run>/snap; map.tsv: copy path, live real path, sha256."""
    copy, snap = Path(run_dir) / "copy", Path(run_dir) / "snap"
    mapping = {}
    rows = []
    for rel in files:
        data = (env.home / rel).read_bytes()
        c = copy_rel(rel)
        for root in (copy, snap):
            f = root / c
            f.parent.mkdir(parents=True, exist_ok=True)
            f.write_bytes(data)
        sha = paths.sha256_bytes(data)
        mapping[c] = {"live": rel, "sha": sha}
        rows.append("%s\t%s\t%s" % (c, rel, sha))
    (copy / "_dream").mkdir(parents=True, exist_ok=True)
    (Path(run_dir) / "map.tsv").write_text("\n".join(rows) + ("\n" if rows else ""))
    return mapping


def _tree(root):
    out = {}
    links = []
    for d, dirs, files in os.walk(root, followlinks=False):
        rel_d = Path(d).relative_to(root)
        if rel_d.parts and rel_d.parts[0] == "_dream":
            dirs[:] = []
            continue
        for x in list(dirs):
            if os.path.islink(os.path.join(d, x)):
                links.append((rel_d / x).as_posix())
                dirs.remove(x)
        for f in files:
            full = Path(d) / f
            rel = (rel_d / f).as_posix()
            if full.is_symlink():
                links.append(rel)
            else:
                out[rel] = full.read_bytes()
    return out, links


class FileDiff:
    def __init__(self, copy, status, old, new):
        self.copy = copy
        self.live = live_rel(copy)
        self.status = status          # M, A or D
        self.old, self.new = old, new
        ol, nl = old.splitlines(), new.splitlines()
        self.added, self.removed = [], []
        for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, ol, nl, autojunk=False).get_opcodes():
            if tag in ("replace", "delete"):
                self.removed += ol[i1:i2]
            if tag in ("replace", "insert"):
                self.added += nl[j1:j2]
        self.unified = "".join(difflib.unified_diff(
            old.splitlines(True), new.splitlines(True), "a/" + self.live, "b/" + self.live, n=2))

    @staticmethod
    def nbytes(lines):
        return sum(len(x.encode()) + 1 for x in lines)


def diff_copy(run_dir):
    """Every changed, added or deleted file of the copy against its snapshot, and every link in the copy."""
    copy, links = _tree(Path(run_dir) / "copy")
    snap, _ = _tree(Path(run_dir) / "snap")
    out = []
    for rel in sorted(set(copy) | set(snap)):
        a, b = snap.get(rel), copy.get(rel)
        if a == b:
            continue
        status = "A" if a is None else "D" if b is None else "M"
        out.append(FileDiff(rel, status, (a or b"").decode("utf-8", "replace"), (b or b"").decode("utf-8", "replace")))
    return out, links
