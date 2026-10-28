---
name: zsh-bash-tool-gotchas
description: "The Bash tool on Justin's Mac runs zsh with GNU coreutils first in PATH; commands that break and their fixes"
metadata:
  node_type: memory
  type: reference
  originSessionId: 2c0f653f-8021-4c94-84cf-9276a410e30a
  modified: 2026-10-26T11:47:53.475Z
---

The Bash tool runs zsh, with GNU coreutils ahead of the macOS tools in PATH (seen 2026-10-23):

- `echo =====` fails ("===== not found"): zsh expands `=word`. Use `echo '---'`.
- An unmatched glob aborts the command ("no matches found"), e.g. `ls ~/.hermes/*.yml` or `grep --include=*.py`. Quote the pattern, or check that it exists first.
- `stat -f '%Sm' …` fails because `stat` is GNU. Use `date -r <file> +%H:%M:%S` for a modification time.
- `sed` is still BSD `/usr/bin/sed` (coreutils' gnubin has no sed), so `sed -i "s#…#…#g" file` errors and the in-place edit (e.g. a redaction) silently doesn't happen. Use `perl -pi -e 's#…#…#g' file`, then grep the file to confirm (reproduced 2026-10-24). `sed -i -E '…'` is worse: BSD takes `-E` as the backup suffix, leaves an unredacted `<file>-E` copy and runs the regex as basic, so `{30,}` matches nothing (901u v3 verifier, 2026-10-24). BSD sed also ignores `\b`, so a word-boundary rename changes nothing; `perl -pi -e 's/\bold\b/new/g'` works (901u v3 fixer 6).
- zsh doesn't word-split an unquoted `$LIST`, so `git checkout <sha> -- $LIST` with newline-separated paths passes one bad pathspec. Use `${(f)LIST}` or run the loop in `/opt/homebrew/bin/bash` (901u v3 verifier, 2026-10-24). The same goes for a command kept in a variable: `D="docker exec leorna-test-pg psql …"; ID=$($D "SELECT …")` fails with "no such file or directory: docker exec …" and leaves `ID` empty, so a later headless-Chrome shot silently captures a 404 page. Use a shell function, and guard `[[ -n $ID ]] || exit 1` before any evidence capture (901v v3 merge verifier, 2026-10-24).
- `$VAR:path` applies a zsh modifier (`:s`, `:h`, `:t`, `:r`…), so `git rev-parse $PIN:skills/x` aborts the whole command with "bad substitution", or silently mangles the path with `:h`/`:t`. Write `"${PIN}:skills/x"` (seen 2026-10-24).

- `${PIPESTATUS[0]}` is empty (zsh's array is `$pipestatus`, indexed from 1), so a pipeline's recorded exit code comes out blank. Use `set -o pipefail` and read `$?`, or run the pipeline under `/opt/homebrew/bin/bash -c '…'` (reproduced 2026-10-24). Every zsh array starts at 1: an inline 0-based loop (`${cmds[$((n-1))]}`) runs nothing or the previous element and still logs `EXIT=0`, so a base-run log looks valid with no test run. Run such loops from a `#!/opt/homebrew/bin/bash` script (901u v3 verifier 4).
- In a gate script under `set -o pipefail`, `<cmd> | grep -q <pattern>` can exit 141 (SIGPIPE): `grep -q` stops at the first match and the producer dies writing to the closed pipe, so a passing test reads as a failed gate. Write the output to a file, then grep the file (901u v3 verifier 5). `| head -N` does the same, and under `set -e` the script quits silently on that line: setup sync committed 941 files and never pushed (2026-10-26). Use `sed -n '1,Np'`, or `grep … >/dev/null`, which read all their input. It only shows once the output passes the ~64 KB pipe buffer, so a test needs a big fixture (1500 long paths reproduced it; 60 didn't). An EXIT trap that reads a `local` variable (`local lock; trap 'rm -rf "$lock"' EXIT`) leaves the lock behind: the trap runs after the function returned and the local is gone. Keep paths an EXIT trap reads global (codex-parity planner smoke run, 2026-10-28).

Related: [[claude-code-hook-internals]]
