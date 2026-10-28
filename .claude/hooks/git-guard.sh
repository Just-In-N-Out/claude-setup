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
# Needs python3; without it, or when it fails (macOS's /usr/bin/python3 stub with no developer tools exits 1),
# a git command passes with a visible systemMessage.
# Any bad input exits 0 with no output. Always exits 0.
# Tests: tests/harness-guards.test.sh (ac1-ac7, ac20)
input=
IFS= read -r -d '' input || true
# cheap pre-filter on the command alone (a description or a folder naming git must not wake the guard), as a
# plain substring test; with no jq (every hook needs it) the raw JSON is read instead
if command -v jq >/dev/null 2>&1; then
  cmd=$(jq -r '.tool_input.command | strings' <<<"$input" 2>/dev/null) || cmd=
else
  cmd=$input
fi
case $cmd in *git* | *gh* | *GIT_*) ;; *) exit 0 ;; esac
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


HEREDOC_RE = re.compile(r"<<(-?)[ \t]*(?:'([^'\n]*)'|\"([^\"\n]*)\"|(\\?)([^\s;&|()<>'\"]+))")
SHELLS = {"bash", "sh", "zsh", "dash", "ksh"}
PH = "\x01"  # a placeholder for a substitution or heredoc body: PH <index into subs> PH
PH_RE = re.compile("\x01([0-9]+)\x01")


def placeholder(subs, body):
    subs.append(body)
    return "%s%d%s" % (PH, len(subs) - 1, PH)


ANSI_C = {"a": "\a", "b": "\b", "e": "\x1b", "E": "\x1b", "f": "\f", "n": "\n", "r": "\r", "t": "\t", "v": "\v",
          "\\": "\\", "'": "'", '"': '"', "?": "?"}
ANSI_C_RE = re.compile(r"\\(?:([0-7]{1,3})|x([0-9A-Fa-f]{1,2})|u([0-9A-Fa-f]{1,4})|U([0-9A-Fa-f]{1,8})|c(.)|(.))", re.S)


def ansi_c(s):
    """The text of bash's $'…' quoting (s is what sits between the quotes): its escapes decoded, cut at a NUL."""
    def esc(m):
        octal, hx, u4, u8, ctrl, other = m.groups()
        if octal or hx:
            return chr(int(octal, 8) & 0xFF if octal else int(hx, 16))
        if u4 or u8:
            try:
                return chr(int(u4 or u8, 16))
            except (ValueError, OverflowError):
                return ""
        if ctrl is not None:
            return chr(ord(ctrl) & 0x1F)
        return ANSI_C.get(other, "\\" + other)
    return ANSI_C_RE.sub(esc, s).split("\0")[0].replace(PH, "\x7f")  # PH is the guard's own marker


def ansi_c_word(cmd, i):
    """cmd[i] opens $'…': (the decoded text as one single-quoted word, the index after its closing quote)."""
    j, n = i + 2, len(cmd)
    while j < n and cmd[j] != "'":
        j += 2 if cmd[j] == "\\" else 1
    text = ansi_c(cmd[i + 2:min(j, n)])
    return "'" + text.replace("'", "'\"'\"'") + ("'" if j < n else ""), j + 1


def substitution(cmd, i):
    """cmd[i] opens $( or a backtick: (the body, the index just after its end)."""
    if cmd[i] == "`":
        j, n = i + 1, len(cmd)
        while j < n and cmd[j] != "`":
            j += 2 if cmd[j] == "\\" else 1
        return re.sub(r"\\([\\`$])", r"\1", cmd[i + 1:j]), j + 1
    end = normalize(cmd, i + 2, [], closer=True)[1]
    return cmd[i + 2:end], end + 1


def dq_part(cmd, i, subs, closes=True):
    """Double-quoted text from cmd[i] (just after the opening quote): (text, index of the closing quote or
    len(cmd)). Each $(…) or `…` inside becomes a placeholder and its body goes to subs."""
    out, n = [], len(cmd)
    while i < n:
        c = cmd[i]
        if c == "\\" and i + 1 < n:
            out.append(cmd[i:i + 2])
            i += 2
        elif closes and c == '"':
            return "".join(out), i
        elif cmd.startswith("$(", i) or c == "`":
            body, i = substitution(cmd, i)
            out.append(placeholder(subs, body))
        else:
            out.append(c)
            i += 1
    return "".join(out), n


def heredoc_body(cmd, i, delim, dash):
    """The lines from cmd[i] up to the delimiter line: (body, the index after the delimiter line)."""
    lines, n = [], len(cmd)
    while i < n:
        j = cmd.find("\n", i)
        line = cmd[i:n if j < 0 else j]
        i = n if j < 0 else j + 1
        if (line.lstrip("\t") if dash else line) == delim:
            break
        lines.append(line)
    return "\n".join(lines), i


def normalize(cmd, i=0, subs=None, closer=False):
    """One quote-aware pass, so shlex sees one line: (text, end).
    - Unquoted newlines become ';', backslash-newline joins lines, unquoted '#' comments are dropped.
    - $'…' becomes the single-quoted word bash makes of it (escapes like \\x76 decoded); $"…" is a "…" string.
    - $(…) and `…` (unquoted or inside double quotes) run their body: each becomes a placeholder and the
      body goes to subs, to be scanned as a script of its own where the placeholder sits.
    - A heredoc body is a script only when a shell or eval reads it (bash <<EOF, cat <<EOF | sh); any other
      heredoc body (cat > f <<EOF, python3 - <<EOF, git commit -F - <<EOF) is data, except the $(…) and
      `…` in it when its delimiter is unquoted. Its placeholder sits where the << was.
    - With closer, the pass stops at the ')' that closes a $( and end is that index."""
    subs = [] if subs is None else subs
    out, n, pending, prev, start, depth = [], len(cmd), [], " ", 0, 0
    while i < n:
        c = cmd[i]
        if cmd.startswith("$$", i):  # the shell's pid: a quote after it is an ordinary one
            out.append("$$")
            prev = "x"
            i += 2
            continue
        if cmd.startswith("$'", i):  # ANSI-C quoting: its escapes decoded, as one single-quoted word
            word, i = ansi_c_word(cmd, i)
            out.append(word)
            prev = "'"
            continue
        if cmd.startswith('$"', i):  # locale quoting: an ordinary double-quoted string
            i += 1
            continue
        if c == "'":
            j = cmd.find("'", i + 1)
            j = n - 1 if j < 0 else j
            out.append(cmd[i:j + 1])
            prev = "'"
            i = j + 1
            continue
        if c == '"':
            text, end = dq_part(cmd, i + 1, subs)
            out.append('"' + text + ('"' if end < n else ""))
            prev = '"'
            i = end + 1
            continue
        if c == "\\":
            if not cmd.startswith("\\\n", i):
                out.append(cmd[i:i + 2])
                prev = "x"
            i += 2
            continue
        if cmd.startswith("$(", i) or c == "`":
            body, i = substitution(cmd, i)
            out.append(placeholder(subs, body))
            prev = "x"
            continue
        if c == "#" and prev in " \t\n;&|()":
            j = cmd.find("\n", i)
            i = n if j < 0 else j
            continue
        if cmd.startswith("<<", i) and not cmd.startswith("<<<", i):
            m = HEREDOC_RE.match(cmd, i)
            if m:
                out.append(" " + placeholder(subs, "") + " ")
                pending.append((m, start, len(subs) - 1))
                prev = " "
                i = m.end()
                continue
        if closer and c in "()":
            if c == "(":
                depth += 1
            elif depth == 0:
                return "".join(out), i
            else:
                depth -= 1
        if c == "\n":
            out.append(" ; ")
            prev = ";"
            i += 1
            for m, at, k in pending:
                delim = next(g for g in (m.group(2), m.group(3), m.group(5)) if g is not None)
                body, i = heredoc_body(cmd, i, delim, m.group(1) == "-")
                if feeds_shell("".join(out[at:])):
                    subs[k] = body
                elif m.group(5) is not None and not m.group(4):  # unquoted delimiter: $(…) and `…` still run
                    inner = []
                    dq_part(body, 0, inner, closes=False)
                    subs[k] = "\n".join(inner)
            pending = []
            start = len(out)
            continue
        out.append(c)
        prev = c
        i += 1
        if c in ";&|()":
            start = len(out)
    return "".join(out), n


def feeds_shell(text):
    """True when the command at the start of text (a heredoc's command, up to the end of its line) is a
    shell or eval, or pipes into one: then the heredoc body is a script, not data."""
    try:
        toks = lex(text)
    except ValueError:
        toks = lex(re.sub(r"[\\'\"]", "", text))
    words, nxt = [], []
    for k, t in enumerate(toks):
        if op_kind(t) == "sep":
            if t == "|":
                nxt = toks[k + 1:]
            break
        words.append(t)
    for w in (words, nxt):
        seg = next((x for x in segments(w) if isinstance(x, list)), [])
        rest = seg[split_prefix(seg)[1]:]
        if rest and os.path.basename(rest[0]) in SHELLS | {"eval"}:
            return True
    return False


def lex(s):
    lx = shlex.shlex(s, posix=True, punctuation_chars=True)
    lx.whitespace_split = True
    lx.commenters = ""
    return list(lx)


def tokens(cmd):
    """(tokens, subs) of a command line; subs[k] is the script behind placeholder k."""
    cmd = cmd.replace(PH, " ")
    subs = []
    try:
        return lex(normalize(cmd, 0, subs)[0]), subs
    except ValueError:  # an unbalanced quote: drop the quote characters and read it again
        subs = []
        return lex(normalize(re.sub(r"[\\'\"]", "", cmd), 0, subs)[0]), subs


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
    """The simple commands in tokens, split at ; & && | || ( ) and friends. Each '(' or ')' is also yielded,
    as that one-character string, so scan() can end a subshell's cd."""
    seg = []
    skip = False
    for t in tokens:
        if skip:
            skip = False
            if PH in t:  # a redirect target's substitution still runs
                seg.append("".join(m.group(0) for m in PH_RE.finditer(t)))
            continue
        k = op_kind(t)
        if k == "sep":
            if seg:
                yield seg
            seg = []
            for c in t:
                if c in "()":
                    yield c
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


def shell_c(args):
    """The command string of `bash -c '<string>'` (also -lc, -ec, -o x -c …), or None."""
    has_c = False
    i = 0
    while i < len(args):
        a = args[i]
        if a in ("-o", "+o", "-O", "+O"):
            i += 2
            continue
        if a == "--":
            i += 1
            break
        if len(a) > 1 and a[0] in "-+":
            if a[0] == "-" and not a.startswith("--") and "c" in a[1:]:
                has_c = True
            i += 1
            continue
        break
    return args[i] if has_c and i < len(args) else None


def no_verify(a):
    """--no-verify, or an abbreviation git accepts for it (--no-veri, --no-verif)."""
    return len(a) >= 9 and "--no-verify".startswith(a)


def split_prefix(w):
    """The leading assignments (NAME=value, also after env and export) and wrappers (env, command, exec,
    nohup, builtin, time, timeout) of a segment: (assignments, index of the command word)."""
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
        elif os.path.basename(t) == "timeout":
            i += 1
            while i < len(w) and w[i].startswith("-"):
                i += 2 if w[i] in ("-s", "--signal", "-k", "--kill-after") else 1
            i += 1  # the duration
        elif t == "export":
            i += 1
            for x in w[i:]:
                if ASSIGN_RE.match(x):
                    k, v = x.split("=", 1)
                    env[k] = v
            i = len(w)
        else:
            break
    return env, i


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
    def scan(self, cmd, cwd, depth, shenv=None):
        """shenv: the shell's variables (export NAME=value, or a bare NAME=value), inherited by a nested
        shell; a subshell's changes to them and to the folder end at its ')'."""
        shenv = {} if shenv is None else dict(shenv)
        toks, subs = tokens(cmd)
        saved = []
        for seg in segments(toks):
            if seg == "(":
                saved.append((cwd, dict(shenv)))
            elif seg == ")":
                if saved:
                    cwd, env = saved.pop()
                    shenv.clear()
                    shenv.update(env)
            else:
                cwd = self.segment(seg, cwd, depth, subs, shenv)
        return cwd

    def segment(self, w, cwd, depth, subs, shenv):
        if any(PH in t for t in w):  # the substitutions and heredoc scripts in it run first, here
            for t in w:
                for m in PH_RE.finditer(t):
                    k = int(m.group(1))
                    if depth < 3 and k < len(subs) and subs[k]:
                        self.scan(subs[k], cwd, depth + 1, shenv)
            w = [PH_RE.sub("", t) for t in w]
        env, i = split_prefix(w)
        for k in env:
            if k in IDENTITY_ENV:
                self.deny("identity")
        cmd = w[i:]
        if not cmd:  # export NAME=value, or a bare NAME=value: it stays for the later segments
            shenv.update(env)
        env = dict(shenv, **env)
        self.env_rules(env)
        if not cmd:
            return cwd
        name = os.path.basename(cmd[0])
        if name in ("cd", "pushd"):
            args = [a for a in cmd[1:] if not a.startswith("-")]
            if not args:
                return self.home or cwd
            return self.path(args[0], cwd)
        if name == "git":
            self.git(cmd[1:], cwd)
        elif name == "gh":
            self.gh(cmd[1:])
        elif depth < 3 and name in SHELLS:
            script = shell_c(cmd[1:])
            if script is not None:
                self.scan(script, cwd, depth + 1, env)
        elif depth < 3 and name == "eval":
            self.scan(" ".join(cmd[1:]), cwd, depth + 1, env)
        return cwd

    def env_rules(self, env):
        """git config set through the environment (GIT_CONFIG_COUNT/KEY_n/VALUE_n, GIT_CONFIG_PARAMETERS) reaches
        every git command run with it, so it is judged on every segment: no Leorna fallback exception here."""
        for k, v, how in self.env_configs(env):
            kl = lower(k)
            if kl in IDENTITY_KEYS:
                self.deny("identity")
            elif kl == "core.hookspath":
                self.deny("hooks")
            elif kl.startswith("credential."):
                self.deny("credential")

    # ---- gh ----
    def gh(self, args):
        pos = [a for a in args if not a.startswith("-")]
        if len(pos) >= 2 and pos[0] == "auth" and pos[1] in ("switch", "setup-git"):
            self.deny("gh")

    # ---- git ----
    def git(self, args, cwd):
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
        """d is in ~/Leorna, by its logical or its physical path (~/Leorna may be a link)."""
        if not self.home:
            return False
        logical = os.path.normpath(os.path.join(self.home, "Leorna"))
        roots = {logical, os.path.join(self.rhome, "Leorna"), os.path.realpath(logical)}
        return any(p == r or p.startswith(r + os.sep) for p in (os.path.normpath(d), os.path.realpath(d)) for r in roots)

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
out=$(printf '%s' "$input" | python3 -I -c "$GUARD_PY" 2>/dev/null); rc=$?
if [ "$rc" != 0 ]; then
  printf '{"systemMessage":"git-guard: python3 failed (exit %s); git commands are not checked"}\n' "$rc"
elif [ -n "$out" ]; then
  printf '%s\n' "$out"
fi
exit 0
