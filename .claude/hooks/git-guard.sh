#!/usr/bin/env bash
# git-guard: Claude Code PreToolUse hook on Bash, for the main session and subagents alike.
# It turns Justin's git rules (~/.claude/CLAUDE.md, "Git & GitHub Privacy" and "Git Commit Authorship")
# into a check the agent can't talk its way past:
#   deny  commit identity overrides (-c user.*/author.*/committer.*, --config-env, commit --author,
#         GIT_AUTHOR_*/GIT_COMMITTER_* assignments, git config writes of those keys);
#         gh auth switch / gh auth setup-git; git remote set-url and remote.<n>.url/pushurl writes;
#         credential.* writes and inline credential helpers (except the Leorna HTTPS fallback);
#         skipping the git hooks (--no-verify, commit -n, core.hooksPath changes other than
#         ~/.claude/githooks).
#   ask   any git push to a Leorna repo (folder under ~/Leorna/, or LeornaAI/ / github-leorna args):
#         Justin pushes only after he says "push" or "make a PR".
# The deny reason reaches the model; the ask reason is shown to Justin in the prompt.
# It reads the command text only: it is a seatbelt, not a sandbox (scripts, aliases and
# HOME=/GIT_CONFIG_GLOBAL= isolation are not seen). The git-level hooks in ~/.claude/githooks are
# the second layer for commits.
# Bash entry: a cheap pre-filter, then the Python below (one file, so the one *.sh syncs).
# Needs python3; without it a git command passes with a visible systemMessage.
# Any bad input exits 0 with no output. Always exits 0.
# Tests: tests/harness-guards.test.sh (ac1-ac7, ac20)
input=
IFS= read -r -d '' input || true
re='(^|[^A-Za-z0-9_])(git|gh)([^A-Za-z0-9_]|$)|GIT_'
[[ $input =~ $re ]] || exit 0
if ! command -v python3 >/dev/null 2>&1; then
  printf '%s\n' '{"systemMessage":"git-guard: python3 not found; git commands are not checked"}'
  exit 0
fi
GUARD_PY=
IFS= read -r -d '' GUARD_PY <<'PY' || true
import json, os, re, shlex, sys

IDENTITY_KEYS = {"user.email", "user.name", "author.email", "author.name", "committer.email", "committer.name"}
IDENTITY_ENV = {"GIT_AUTHOR_EMAIL", "GIT_AUTHOR_NAME", "GIT_COMMITTER_EMAIL", "GIT_COMMITTER_NAME"}
FALLBACK_HELPERS = {"", "!gh auth git-credential"}
FALLBACK_URL = "https://github.com/LeornaAI/"
REASONS = {
    "identity": "git-guard: never override commit identity (CLAUDE.md, Git Commit Authorship). Commit with plain "
                "`git commit` and let the repo's config pick the email (the folder decides: ~/Leorna/ is "
                "justin@leorna.com, everything else issajustin04@gmail.com).",
    "gh": "git-guard: never switch the gh account or let gh rewrite git's credential helper (CLAUDE.md, Git Commit "
          "Authorship: never run gh auth switch). Use the account that is active; if a push would go as the wrong "
          "account, stop and tell Justin.",
    "remote": "git-guard: never change a remote URL (CLAUDE.md, Git Commit Authorship). Leorna pushes use the "
              "github-leorna alias, or the documented HTTPS fallback; if neither works, stop and tell Justin.",
    "credential": "git-guard: never change a credential helper (CLAUDE.md, Git Commit Authorship). The only inline "
                  "helper allowed is the documented Leorna HTTPS fallback: git -c credential.helper= -c "
                  "'credential.helper=!gh auth git-credential' push|fetch https://github.com/LeornaAI/<repo>.git <refspec>.",
    "hooks": "git-guard: never skip the git hooks (--no-verify, commit -n, or changing core.hooksPath away from "
             "~/.claude/githooks) (CLAUDE.md, Git & GitHub Privacy and Git Commit Authorship). A hook refusal is "
             "the rule, not a bug to work around: fix what it names, or tell Justin.",
    "edit": "git-guard: git config --edit can change identity, remotes, credentials or core.hooksPath; set the one "
            "key you need with git config <key> <value> instead.",
}
ASK_REASON = ('Leorna push: Justin\'s rule is to push only after he says "push" or "make a PR". '
              "Approve only if he did.")
ASSIGN_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=")
KEYWORDS = {"if", "then", "else", "elif", "do", "while", "until", "{", "!", "fi", "done", "}"}


def lex(s):
    lx = shlex.shlex(s, posix=True, punctuation_chars=True)
    lx.whitespace_split = True
    lx.commenters = ""
    return list(lx)


def op_kind(tok):
    """None for a word; 'sep' for ; & && | || ( ) and friends; 'redir' for < > >> >& &> <<…"""
    if not tok or tok.strip("();<>|&") != "":
        return None
    if any(c in tok for c in "();"):
        return "sep"
    if "<" in tok or ">" in tok:
        return "redir"
    return "sep"


def segments(tokens):
    seg = []
    skip = False
    for t in tokens:
        if skip:
            skip = False
            continue
        k = op_kind(t)
        if k == "sep":
            if seg:
                yield seg
            seg = []
        elif k == "redir":
            if seg and seg[-1].isdigit():
                seg.pop()  # the fd number of 2>&1, 2>/dev/null
            skip = True  # the redirect's target
        else:
            seg.append(t)
    if seg:
        yield seg


def expand_home(p, home):
    for pre in ("~", "$HOME", "${HOME}"):
        if p == pre:
            return home
        if p.startswith(pre + "/"):
            return home + p[len(pre):]
    return p


def lower(s):
    return s.lower()


def no_verify(a):
    """--no-verify, or an abbreviation git accepts for it (--no-veri, --no-verif)."""
    return len(a) >= 9 and "--no-verify".startswith(a)


class Guard:
    def __init__(self, home):
        self.home = home
        self.rhome = os.path.realpath(home) if home else ""
        self.denies = []
        self.ask = False

    def deny(self, rule):
        if rule not in self.denies:
            self.denies.append(rule)

    def result(self):
        if self.denies:
            return {"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
                    "permissionDecisionReason": "\n".join(REASONS[r] for r in self.denies)}}
        if self.ask:
            return {"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask",
                    "permissionDecisionReason": ASK_REASON}}
        return None

    def path(self, p, cwd):
        p = expand_home(p, self.home)
        return os.path.normpath(os.path.join(cwd, p))

    # ---- shell ----
    def scan(self, cmd, cwd, depth):
        for seg in segments(lex(cmd)):
            cwd = self.segment(seg, cwd, depth)
        return cwd

    def segment(self, w, cwd, depth):
        env = {}
        i = 0
        while i < len(w):
            t = w[i]
            if t in KEYWORDS:
                i += 1
            elif ASSIGN_RE.match(t):
                k, v = t.split("=", 1)
                env[k] = v
                i += 1
            elif os.path.basename(t) == "env":
                i += 1
                while i < len(w):
                    x = w[i]
                    if x in ("-u", "--unset"):
                        i += 2
                    elif x.startswith("-") or x == "--":
                        i += 1
                    elif ASSIGN_RE.match(x):
                        k, v = x.split("=", 1)
                        env[k] = v
                        i += 1
                    else:
                        break
            elif os.path.basename(t) in ("command", "exec", "nohup", "builtin"):
                i += 1
                while i < len(w) and w[i].startswith("-"):
                    i += 1
            elif t == "time":
                i += 1
                while i < len(w) and w[i].startswith("-"):
                    i += 1
            elif t == "export":
                i += 1
                for x in w[i:]:
                    if ASSIGN_RE.match(x):
                        k, v = x.split("=", 1)
                        env[k] = v
                i = len(w)
            else:
                break
        for k in env:
            if k in IDENTITY_ENV:
                self.deny("identity")
        cmd = w[i:]
        if not cmd:
            return cwd
        name = os.path.basename(cmd[0])
        if name in ("cd", "pushd"):
            args = [a for a in cmd[1:] if not a.startswith("-")]
            if not args:
                return self.home or cwd
            return self.path(args[0], cwd)
        if name == "git":
            self.git(cmd[1:], cwd, env)
        elif name == "gh":
            self.gh(cmd[1:])
        return cwd

    # ---- gh ----
    def gh(self, args):
        pos = [a for a in args if not a.startswith("-")]
        if len(pos) >= 2 and pos[0] == "auth" and pos[1] in ("switch", "setup-git"):
            self.deny("gh")

    # ---- git ----
    def git(self, args, cwd, env):
        configs = []  # (key, value, how)
        folder = cwd
        dirs = []
        i = 0
        while i < len(args):
            a = args[i]
            if a == "-C" and i + 1 < len(args):
                folder = self.path(args[i + 1], folder)
                i += 2
            elif a == "-c" and i + 1 < len(args):
                k, _, v = args[i + 1].partition("=")
                configs.append((k, v, "-c"))
                i += 2
            elif a.startswith("--config-env"):
                if a == "--config-env" and i + 1 < len(args):
                    spec = args[i + 1]
                    i += 2
                else:
                    spec = a.partition("=")[2]
                    i += 1
                configs.append((spec.partition("=")[0], None, "--config-env"))
            elif a in ("--git-dir", "--work-tree", "--namespace", "--exec-path", "--super-prefix") and i + 1 < len(args):
                if a in ("--git-dir", "--work-tree"):
                    dirs.append(self.path(args[i + 1], folder))
                i += 2
            elif a.startswith("-"):
                if a.startswith("--git-dir=") or a.startswith("--work-tree="):
                    dirs.append(self.path(a.partition("=")[2], folder))
                i += 1
            else:
                break
        sub = args[i] if i < len(args) else ""
        rest = args[i + 1:]
        configs += self.env_configs(env)
        for k, v, how in configs:
            kl = lower(k)
            if kl in IDENTITY_KEYS:
                self.deny("identity")
            elif kl == "core.hookspath":
                self.deny("hooks")
            elif kl.startswith("credential."):
                if not self.leorna_fallback(configs, sub, rest):
                    self.deny("credential")
        if sub == "commit":
            self.commit(rest)
        elif any(no_verify(a) for a in rest):
            self.deny("hooks")
        if sub == "push":  # asked unless something denies it (deny wins in result())
            here = [folder] + dirs
            if any(self.under_leorna(d) for d in here) or any(
                    "LeornaAI/" in a or a.startswith("github-leorna:") or a.startswith("git@github-leorna:")
                    for a in rest):
                self.ask = True
        elif sub == "config":
            self.config(rest)
        elif sub == "remote":
            pos = [a for a in rest if not a.startswith("-")]
            if pos and pos[0] == "set-url":
                self.deny("remote")

    def under_leorna(self, d):
        if not self.rhome:
            return False
        root = os.path.join(self.rhome, "Leorna")
        r = os.path.realpath(d)
        return r == root or r.startswith(root + os.sep)

    def hooks_path_ok(self, v):
        if v is None:
            return False
        v = v.rstrip("/")
        return v in ("~/.claude/githooks", "$HOME/.claude/githooks", "${HOME}/.claude/githooks") or (
            bool(self.home) and v in (self.home.rstrip("/") + "/.claude/githooks", self.rhome + "/.claude/githooks"))

    def env_configs(self, env):
        out = []
        try:
            n = int(env.get("GIT_CONFIG_COUNT", "0") or "0")
        except ValueError:
            n = 0
        for j in range(min(n, 100)):
            if "GIT_CONFIG_KEY_%d" % j in env:
                out.append((env["GIT_CONFIG_KEY_%d" % j], env.get("GIT_CONFIG_VALUE_%d" % j, ""), "env"))
        params = env.get("GIT_CONFIG_PARAMETERS")
        if params:
            for m in re.finditer(r"(?:^|\s)'([^']*)'", params):  # 'key'='value' or 'key=value' items
                out.append((m.group(1).partition("=")[0], None, "env"))
        return out

    def leorna_fallback(self, configs, sub, rest):
        for k, v, how in configs:
            kl = lower(k)
            if not kl.startswith("credential."):
                continue
            if how != "-c" or kl != "credential.helper" or v not in FALLBACK_HELPERS:
                return False
        if sub not in ("push", "fetch"):
            return False
        pos = self.positionals(rest, {"-o", "--push-option", "--receive-pack", "--exec", "--upload-pack", "--depth",
                                      "-j", "--jobs", "--refmap", "--server-option", "--shallow-since",
                                      "--shallow-exclude", "--deepen", "--negotiation-tip"})
        return bool(pos) and pos[0].startswith(FALLBACK_URL)

    @staticmethod
    def positionals(rest, takes_value):
        pos = []
        i = 0
        while i < len(rest):
            a = rest[i]
            if a == "--":
                pos += rest[i + 1:]
                break
            if a in takes_value:
                i += 2
                continue
            if a.startswith("-") and a != "-":
                i += 1
                continue
            pos.append(a)
            i += 1
        return pos

    def commit(self, rest):
        takes = {"-m", "-F", "-c", "-C", "-t", "--message", "--file", "--reuse-message", "--reedit-message",
                 "--template", "--author", "--date", "--trailer", "--fixup", "--squash", "--cleanup",
                 "--pathspec-from-file"}
        i = 0
        while i < len(rest):
            a = rest[i]
            if a == "--":
                break
            if a == "--author" or a.startswith("--author="):
                self.deny("identity")
            if no_verify(a):
                self.deny("hooks")
            if a in takes:
                i += 2
                continue
            if a.startswith("-") and not a.startswith("--") and len(a) > 1:
                # a short cluster (-anm): n before any value-taking letter is --no-verify; after one,
                # the rest of the cluster is that letter's value (-uno, -mfix)
                letters = a[1:]
                takes_next = False
                for j, c in enumerate(letters):
                    if c == "n":
                        self.deny("hooks")
                    elif c in "uS":
                        break
                    elif c in "mFcCt":
                        takes_next = j == len(letters) - 1
                        break
                if takes_next:
                    i += 2
                    continue
            i += 1

    def config(self, rest):
        takes = {"-f", "--file", "--blob", "-t", "--type", "--default", "--comment", "--value", "--url"}
        read_flags = {"--get", "--get-all", "--get-regexp", "--get-urlmatch", "-l", "--list", "--get-color",
                      "--get-colorbool"}
        write_flags = {"--add", "--unset", "--unset-all", "--replace-all", "--rename-section", "--remove-section",
                       "-e", "--edit"}
        flags, pos = set(), []
        i = 0
        while i < len(rest):
            a = rest[i]
            if a in takes:
                i += 2
                continue
            if a.startswith("-") and a != "-":
                flags.add(a.partition("=")[0])
                i += 1
                continue
            pos.append(a)
            i += 1
        writes = []  # (key, value or None)
        sections = []
        edit = False
        if pos and pos[0] in ("get", "list"):
            return
        if pos and pos[0] in ("set", "unset", "rename-section", "remove-section", "edit"):
            sub, args = pos[0], pos[1:]
            if sub == "set" and args:
                writes.append((args[0], args[1] if len(args) > 1 else None))
            elif sub == "unset" and args:
                writes.append((args[0], None))
            elif sub in ("rename-section", "remove-section"):
                sections += args[:1]
            elif sub == "edit":
                edit = True
        elif flags & write_flags:
            if flags & {"-e", "--edit"}:
                edit = True
            elif flags & {"--rename-section", "--remove-section"}:
                sections += pos[:1]
            elif flags & {"--unset", "--unset-all"}:
                if pos:
                    writes.append((pos[0], None))
            elif pos:
                writes.append((pos[0], pos[1] if len(pos) > 1 else None))
        elif flags & read_flags:
            return
        elif len(pos) >= 2:
            writes.append((pos[0], pos[1]))
        if edit:
            self.deny("edit")
        for k, v in writes:
            kl = lower(k)
            if kl in IDENTITY_KEYS:
                self.deny("identity")
            elif re.match(r"^remote\..+\.(url|pushurl)$", kl):
                self.deny("remote")
            elif kl.startswith("credential."):
                self.deny("credential")
            elif kl == "core.hookspath" and not self.hooks_path_ok(v):
                self.deny("hooks")
        for s in sections:
            sl = lower(s)
            if sl in ("user", "author", "committer"):
                self.deny("identity")
            elif sl == "credential" or sl.startswith("credential."):
                self.deny("credential")
            elif sl.startswith("remote."):
                self.deny("remote")
            elif sl == "core":
                self.deny("hooks")


def main():
    try:
        data = json.loads(sys.stdin.read())
    except Exception:
        return
    if not isinstance(data, dict) or data.get("tool_name") != "Bash":
        return
    ti = data.get("tool_input")
    cmd = ti.get("command") if isinstance(ti, dict) else None
    if not isinstance(cmd, str) or not cmd.strip():
        return
    cwd = data.get("cwd")
    if not isinstance(cwd, str) or not cwd:
        cwd = os.getcwd()
    g = Guard(os.environ.get("HOME", ""))
    g.scan(cmd, cwd, 0)
    out = g.result()
    if out:
        print(json.dumps(out))


try:
    main()
except Exception:
    pass
PY
printf '%s' "$input" | python3 -I -c "$GUARD_PY"
exit 0
