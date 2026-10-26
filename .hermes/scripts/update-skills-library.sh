#!/usr/bin/env bash
# Keep Hermes in sync with Justin's picks from the Leorna skills library.
#
#   ~/.hermes/scripts/update-skills-library.sh [--dry-run]
#
# 1. Pull the clone at $HERMES_HOME/skills-library, keeping local fixes:
#    uncommitted edits are saved to skills-library-local.patch and re-applied.
# 2. Link exactly the skills listed in skills-library-keep.txt, into the category
#    named there (never over a skill of Justin's own with the same name).
# 3. Remove every other link into the library (unlisted or deleted upstream).
# 4. Report skills that are new upstream; they are NOT installed automatically.
set -euo pipefail

HH="${HERMES_HOME:-$HOME/.hermes}"
LIB="$HH/skills-library"
SKILLS="$HH/skills"
KEEP="$HH/skills-library-keep.txt"
PATCH="$HH/skills-library-local.patch"
DRY=0
[[ "${1:-}" == "--dry-run" ]] && DRY=1
run() { if [[ $DRY -eq 1 ]]; then echo "  would: $*"; else "$@"; fi; }

[[ -d "$LIB/.git" ]] || { echo "error: no clone at $LIB" >&2; exit 1; }
[[ -f "$KEEP" ]] || { echo "error: no keep list at $KEEP" >&2; exit 1; }
LIB_REAL=$(cd "$LIB" && pwd -P)

# 1. pull, keeping local fixes
before=$(git -C "$LIB" rev-parse HEAD)
if [[ $DRY -eq 0 ]]; then
  edited=$(git -C "$LIB" diff --name-only)
  if [[ -n "$edited" ]]; then
    git -C "$LIB" diff > "$PATCH"
    git -C "$LIB" checkout -q -- .
  fi
  pull_ok=1
  git -C "$LIB" pull --ff-only --quiet || pull_ok=0
  failed=""
  for f in $edited; do   # per file, so one stale fix doesn't drop the others
    git -C "$LIB" apply --include="$f" "$PATCH" 2>/dev/null || failed="$failed $f"
  done
  if [[ -n "$failed" ]]; then
    keep_copy="$PATCH.failed-$(date +%Y%m%d-%H%M%S)"
    cp "$PATCH" "$keep_copy"
    echo "WARNING: local fixes no longer apply (upstream changed them):$failed" >&2
    echo "         Those skills now use the upstream text; the old fixes are in $keep_copy" >&2
  fi
  [[ $pull_ok -eq 1 ]] || { echo "error: git pull failed; links left unchanged" >&2; exit 1; }
fi
after=$(git -C "$LIB" rev-parse HEAD)

# "name category" pairs wanted
desired=$(grep -vE '^[[:space:]]*(#|$)' "$KEEP" | awk '{print $1" "$2}')

# 3. remove library links that aren't wanted at exactly that place
removed=0
while IFS= read -r link; do
  [[ -n "$link" ]] || continue
  name=$(basename "$link")
  rel=${link#"$SKILLS"/}
  cat=$(dirname "$rel")
  if [[ -e "$link" ]] && grep -qx "$name $cat" <<< "$desired"; then continue; fi
  run rm -f -- "$link"
  removed=$((removed + 1))
  d=$(dirname "$link")   # tidy category folders the removal emptied
  while [[ $DRY -eq 0 && "$d" != "$SKILLS" ]] && rmdir "$d" 2>/dev/null; do d=$(dirname "$d"); done
done < <(find "$SKILLS" -type l \( -lname "$LIB/*" -o -lname "$LIB_REAL/*" \))

# 2. link the wanted ones
added=0; gone=""
while read -r name cat; do
  [[ -n "$name" ]] || continue
  src="$LIB/skills/$name"
  dest="$SKILLS/$cat/$name"
  if [[ ! -f "$src/SKILL.md" ]]; then gone="$gone $name"; continue; fi
  [[ -L "$dest" && -e "$dest" ]] && continue
  # find without -L skips library links, so this only sees Justin's own skills
  if [[ -n "$(find "$SKILLS" -path "*/$name/SKILL.md" -print -quit)" ]]; then
    echo "  skip $name: you already have your own skill with that name"; continue
  fi
  run mkdir -p "$SKILLS/$cat"
  run ln -s "$src" "$dest"
  added=$((added + 1))
done <<< "$desired"

# 4. new upstream skills (not installed; add them to the keep list if wanted)
new=""
if [[ "$before" != "$after" ]]; then
  new=$(comm -13 \
    <(git -C "$LIB" show "$before:catalog.tsv" | tail -n +2 | cut -f1 | sort) \
    <(tail -n +2 "$LIB/catalog.tsv" | cut -f1 | sort) | tr '\n' ' ')
fi

# 5. merged skills (local copies of the library text + Justin's additions): report upstream changes
MERGED="$HH/skills-library-merged.txt"
changed=""
if [[ "$before" != "$after" && -f "$MERGED" ]]; then
  while read -r name _; do
    [[ -n "$name" ]] || continue
    git -C "$LIB" diff --quiet "$before" "$after" -- "skills/$name" || changed="$changed $name"
  done < <(grep -vE '^[[:space:]]*(#|$)' "$MERGED")
fi

# 6. Claude Code links: ~/.claude/skills/<name> -> the Hermes skill folder
CLAUDE_LIST="$HH/skills-library-claude.txt"
CLAUDE_DIR="$HOME/.claude/skills"
cadded=0; cremoved=0
if [[ -f "$CLAUDE_LIST" ]]; then
  want=$(grep -vE '^[[:space:]]*(#|$)' "$CLAUDE_LIST" | awk '{print $1}')
  if [[ -d "$CLAUDE_DIR" ]]; then
    while IFS= read -r link; do
      [[ -n "$link" ]] || continue
      if [[ -e "$link" ]] && grep -qx "$(basename "$link")" <<< "$want"; then continue; fi
      run rm -f -- "$link"
      cremoved=$((cremoved + 1))
    done < <(find "$CLAUDE_DIR" -maxdepth 1 -type l \( -lname "$SKILLS/*" -o -lname "$LIB/*" -o -lname "$LIB_REAL/*" \))
  fi
  for n in $want; do
    src=$(find "$SKILLS" -mindepth 2 -maxdepth 2 -name "$n" | head -1)
    if [[ -z "$src" ]]; then echo "  claude: $n is not a Hermes skill, skipped"; continue; fi
    dest="$CLAUDE_DIR/$n"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then continue; fi
    if [[ -e "$dest" && ! -L "$dest" ]]; then echo "  claude: skip $n (Claude Code has its own)"; continue; fi
    run mkdir -p "$CLAUDE_DIR"
    run ln -sfn "$src" "$dest"
    cadded=$((cadded + 1))
  done
fi

linked=$(find "$SKILLS" -type l \( -lname "$LIB/*" -o -lname "$LIB_REAL/*" \) | wc -l | tr -d ' ')
echo "library: ${before:0:7} -> ${after:0:7}   linked: $linked   added: $added   removed: $removed   claude links: +$cadded -$cremoved"
[[ -z "$gone" ]] || echo "on your keep list but gone upstream:$gone"
[[ -z "$new" ]] || echo "new upstream (not installed; add to $KEEP if wanted): $new"
[[ -z "$changed" ]] || echo "library changed merged skills (ask Hermes to re-merge):$changed"
if [[ $DRY -eq 0 && -n "$(git -C "$LIB" status --porcelain --untracked-files=no)" ]]; then
  echo "local fixes in the clone: $(git -C "$LIB" diff --name-only | tr '\n' ' ')"
fi
if [[ $((added + removed)) -gt 0 ]]; then echo "changes show up in the next new session (WhatsApp: /new)"; fi
