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


# a heredoc's << (not <<=, arithmetic's shift-assign) and its delimiter word
HEREDOC_RE = re.compile(r"<<(?!=)(-?)[ \t]*(?:'([^'\n]*)'|\"([^\"\n]*)\"|(\\?)([^\s;&|()<>'\"]+))")
SHELLS = {"bash", "sh", "zsh", "dash", "ksh"}
UNKNOWN = "\x7f?"  # a folder the guard can't know (cd - with no cd before it in the command); a push there asks
PH = "\x01"  # a placeholder for a substitution or heredoc body: PH <index into subs> PH
PH_RE = re.compile("\x01([0-9]+)\x01")
HS = "\x02"  # marks a here-string's word in a segment (HS + the word): it is the command's stdin, not an arg
STDIN_FILES = {"/dev/stdin", "-", "/dev/fd/0", "/proc/self/fd/0"}
PRINTF_RE = re.compile(r"%%|%[-+ #0]*[0-9*]*(?:\.[0-9*]*)?([a-zA-Z])")


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
    return ANSI_C_RE.sub(esc, s).split("\0")[0].replace(PH, "\x7f").replace(HS, "\x7f")  # the guard's own marks


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
    - A heredoc body is a script only when a shell, eval or source /dev/stdin reads it (bash <<EOF,
      cat <<EOF | sh); any other heredoc body (cat > f <<EOF, python3 - <<EOF, git commit -F - <<EOF) is data,
      except the $(…) and `…` in it when its delimiter is unquoted. Its placeholder sits where the << was.
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
        if cmd.startswith("<<<", i):  # a here-string: its word is not a heredoc's delimiter
            out.append("<<<")
            prev = "<"
            i += 3
            continue
        if cmd.startswith("<<", i):
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
    """True when the command at the start of text (a heredoc's command, up to the end of its line) runs its
    stdin as a script (stdin_script), or pipes into one that does: then the heredoc body is a script, not data."""
    try:
        toks = lex(text)
    except ValueError:
        toks = lex(re.sub(r"[\\'\"]", "", text))
    words, nxt = [], []
    for k, t in enumerate(toks):
        if op_kind(t) == "sep":
            if t in ("|", "|&"):
                nxt = toks[k + 1:]
            break
        words.append(t)
    for w in (words, nxt):
        seg = next((x for x in segments(w) if isinstance(x, list)), [])
        if stdin_script(command_words(seg)):
            return True
    return False


def command_words(seg):
    """A segment's command and its args: no here-string words, no heredoc or substitution placeholders (a
    heredoc's sits where its << was), no leading assignments or wrappers."""
    w = [t for t in seg if t and not t.startswith(HS) and not PH_RE.fullmatch(t)]
    return w[split_prefix(w)[1]:]


def stdin_script(cmd):
    """True when cmd (a command and its args) runs what reaches its stdin as a script: a shell with no -c and no
    script file (or with -s), eval, or source/. of /dev/stdin (also -, /dev/fd/0, or no file)."""
    if not cmd:
        return False
    if os.path.basename(cmd[0]) in SHELLS:
        return shell_stdin(cmd[1:])
    if cmd[0] == "eval":
        return True
    if cmd[0] in ("source", "."):
        args = cmd[1:]
        while args and args[0] in ("--", "-p"):  # bash 5.3: source -p <path> <file>
            args = args[2:] if args[0] == "-p" else args[1:]
        return not args or args[0] in STDIN_FILES
    return False


def echoed(cmd):
    """The text echo or printf (cmd: a command and its args) writes, or None for any other command."""
    if not cmd:
        return None
    name, args = os.path.basename(cmd[0]), list(cmd[1:])
    if name == "echo":
        decode = False
        while args and re.fullmatch(r"-[neE]+", args[0]):
            for f in args.pop(0)[1:]:
                decode = {"e": True, "E": False}.get(f, decode)
        text = " ".join(args)
        return ansi_c(text) if decode else text
    if name != "printf":
        return None
    if args[:1] == ["--"]:
        args = args[1:]
    if not args or args[0] == "-v":  # printf -v <name>: into a variable, nothing written
        return None
    fmt, args, out = ansi_c(args[0]), args[1:], []

    def conv(m):
        if m.group(0) == "%%":
            return "%"
        a = args.pop(0) if args else ""
        return ansi_c(a) if m.group(1) == "b" else a
    for _ in range(100):  # the format is used again while arguments are left, as printf does
        left = len(args)
        out.append(PRINTF_RE.sub(conv, fmt))
        if not args or len(args) == left:
            break
    return "".join(out)


def lex(s):
    lx = shlex.shlex(s, posix=True, punctuation_chars=True)
    lx.whitespace_split = True
    lx.commenters = ""
    return list(lx)


def tokens(cmd):
    """(tokens, subs) of a command line; subs[k] is the script behind placeholder k."""
    cmd = cmd.replace(PH, " ").replace(HS, " ")
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
    as that one-character string, so scan() can end a subshell's cd, and '|' after a command that pipes into the
    next one. A here-string's word stays in its segment as HS + the word."""
    seg = []
    skip = here = False
    for t in tokens:
        if skip:
            skip = False
            if here:
                seg.append(HS + t)
            elif PH in t:  # a redirect target's substitution still runs
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
            if t in ("|", "|&"):
                yield "|"
        elif k == "redir":
            if seg and seg[-1].isdigit():
                seg.pop()  # the fd number of 2>&1, 2>/dev/null
            skip = True  # the redirect's target
            here = t.endswith("<<<")
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


def shell_stdin(args):
    """True when a shell given args reads its script from stdin: no -c, and -s or no script file operand."""
    i, s = 0, False
    while i < len(args):
        a = args[i]
        if a in ("-o", "+o", "-O", "+O", "--rcfile", "--init-file"):
            i += 2
            continue
        if a == "--":
            i += 1
            break
        if len(a) > 1 and a[0] in "-+":
            if a[0] == "-" and not a.startswith("--"):
                if "c" in a[1:]:
                    return False
                s = s or "s" in a[1:]
            i += 1
            continue
        break
    return s or i >= len(args)


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


def no_verify(a, shortest=9):
    """--no-verify, or an abbreviation git accepts for it: --no-veri on (--no-ver is also --no-verbose there),
    --no-v for git am (shortest=6), which has no --verbose."""
    return len(a) >= shortest and "--no-verify".startswith(a)


def am_n(rest):
    """git am -n (its --no-verify), also in a short cluster (-3n); -C, -p and -S take the rest as their value."""
    for a in rest:
        if a == "--":
            break
        if a.startswith("-") and not a.startswith("--"):
            for c in a[1:]:
                if c == "n":
                    return True
                if c in "CpS":
                    break
    return False


def long_opts(negatable, plain=""):
    """A command's long options as git 2.53's -h lists them: --x and --no-x for each negatable one."""
    names = {"--" + n for n in (negatable + " " + plain).split()}
    return frozenset(names | {"--no-" + n for n in negatable.split()})


_CFG_FILE = "global system local worktree file blob "
_CFG_SHOW = "null name-only show-origin show-scope show-names "
_CFG_TYPES = "bool int bool-or-int bool-or-str path expiry-date"
CONFIG_OPTS = {  # git config: legacy mode (""), then each subcommand
    "": long_opts(_CFG_FILE + _CFG_SHOW + "type default comment fixed-value includes",
                  "get get-all get-regexp get-urlmatch replace-all add unset unset-all rename-section remove-section "
                  "list edit get-color get-colorbool " + _CFG_TYPES),
    "list": long_opts(_CFG_FILE + _CFG_SHOW + "type includes", _CFG_TYPES),
    "get": long_opts(_CFG_FILE + _CFG_SHOW + "all regexp value fixed-value url type includes default", _CFG_TYPES),
    "set": long_opts(_CFG_FILE + "type all value fixed-value comment append", _CFG_TYPES),
    "unset": long_opts(_CFG_FILE + "all value fixed-value"),
    "rename-section": long_opts(_CFG_FILE), "remove-section": long_opts(_CFG_FILE), "edit": long_opts(_CFG_FILE),
}
COMMIT_OPTS = long_opts("quiet verbose file author date message reedit-message reuse-message fixup squash "
                        "reset-author signoff template edit cleanup status gpg-sign all include interactive patch "
                        "only dry-run short branch ahead-behind porcelain long null amend untracked-files "
                        "pathspec-from-file pathspec-file-nul",
                        "trailer unified inter-hunk-context no-verify verify no-post-rewrite post-rewrite allow-empty "
                        "allow-empty-message")


def canon(a, names):
    """The long option git reads for a: a itself when exact, else the one option in names it abbreviates (the
    part before '=' is matched); an unknown or ambiguous one stays as it is (git refuses an ambiguous one)."""
    if not a.startswith("--") or a == "--":
        return a
    k, eq, v = a.partition("=")
    if k in names:
        return a
    hits = [x for x in names if x.startswith(k)]
    return hits[0] + eq + v if len(hits) == 1 else a


def split_prefix(w):
    """The leading assignments (NAME=value, also after env, export, declare, typeset, local and readonly) and
    wrappers (env, command, exec, nohup, builtin, time, timeout) of a segment: (assignments, index of the command
    word)."""
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
        elif t in ("export", "declare", "typeset", "local", "readonly"):  # their -x and other flags are skipped
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
        if not os.path.isabs(p) and UNKNOWN in (cwd, p):  # relative to an unknown folder: still unknown
            return UNKNOWN
        return os.path.normpath(os.path.join(cwd, p))

    # ---- shell ----
    def scan(self, cmd, cwd, depth, shenv=None, share=False):
        """shenv: the shell's variables (export NAME=value, or a bare NAME=value; OLDPWD after a cd), inherited
        by a nested shell; a subshell's changes to them and to the folder end at its ')'. With share, the script
        runs in this shell (eval): its changes to shenv stay, and the folder it ends in is returned."""
        shenv = {} if shenv is None else (shenv if share else dict(shenv))
        toks, subs = tokens(cmd)
        saved = []
        items = list(segments(toks))
        for k, seg in enumerate(items):
            if seg == "(":
                saved.append((cwd, dict(shenv)))
            elif seg == ")":
                if saved:
                    cwd, env = saved.pop()
                    shenv.clear()
                    shenv.update(env)
            elif seg != "|":
                cwd = self.segment(seg, cwd, depth, subs, shenv)
                # echo/printf piped into a shell (or source /dev/stdin): what it writes is that shell's script
                to = items[k + 2] if k + 2 < len(items) and items[k + 1] == "|" else None
                if depth < 3 and isinstance(to, list) and stdin_script(command_words(to)):
                    text = echoed(command_words([PH_RE.sub("", t) for t in seg]))
                    if text:
                        self.scan(text, cwd, depth + 1, shenv)
        return cwd

    def segment(self, w, cwd, depth, subs, shenv):
        if any(PH in t for t in w):  # the substitutions and heredoc scripts in it run first, here
            for t in w:
                for m in PH_RE.finditer(t):
                    k = int(m.group(1))
                    if depth < 3 and k < len(subs) and subs[k]:
                        self.scan(subs[k], cwd, depth + 1, shenv)
            w = [PH_RE.sub("", t) for t in w]
        here = [t[1:] for t in w if t.startswith(HS)]
        w = [t for t in w if not t.startswith(HS)]
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
        if depth < 3 and here and stdin_script([t for t in cmd if t]):  # bash <<< 'script', . /dev/stdin <<< …
            for h in here:
                self.scan(h, cwd, depth + 1, env)
        name = os.path.basename(cmd[0])
        if name in ("cd", "pushd"):
            args = [a for a in cmd[1:] if not a.startswith("-") or (a == "-" and name == "cd")]
            if not args:
                new = self.home or cwd
            elif args[0] == "-":  # back to $OLDPWD: known when this command set it, else unknown
                new = self.path(shenv["OLDPWD"], cwd) if shenv.get("OLDPWD") else UNKNOWN
            else:
                new = self.path(args[0], cwd)
            shenv["OLDPWD"] = cwd
            return new
        if name == "git":
            self.git(cmd[1:], cwd)
        elif name == "gh":
            self.gh(cmd[1:])
        elif depth < 3 and name in SHELLS:
            script = shell_c(cmd[1:])
            if script is not None:
                self.scan(script, cwd, depth + 1, env)
        elif depth < 3 and name == "eval":  # runs in this shell, like a { …; } group: its cd and variables stay
            shenv.update(env)
            return self.scan(" ".join(cmd[1:]), cwd, depth + 1, shenv, share=True)
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
        elif any(no_verify(a, 6 if sub == "am" else 9) for a in rest) or (sub == "am" and am_n(rest)):
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
        """d is in ~/Leorna, by its logical or its physical path (~/Leorna may be a link); an unknown folder may be."""
        if d == UNKNOWN:
            return True
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
            c = canon(a, COMMIT_OPTS)  # --auth=… is --author=…
            if c == "--author" or c.startswith("--author="):
                self.deny("identity")
            if no_verify(a):
                self.deny("hooks")
            if c in takes:
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
        opts = CONFIG_OPTS.get(rest[0] if rest else "", CONFIG_OPTS[""])  # a subcommand's options, or legacy mode's
        i = 0
        while i < len(rest):
            a = canon(rest[i], opts)  # --unset-a is --unset-all, --val is --value
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
