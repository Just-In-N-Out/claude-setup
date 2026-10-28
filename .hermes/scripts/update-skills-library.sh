#!/usr/bin/env bash
# Keep Hermes in sync with Justin's picks from the Leorna skills library.
#
#   ~/.hermes/scripts/update-skills-library.sh [--dry-run] [--links-only]
#
# 1. Pull the clone at $HERMES_HOME/skills-library, keeping local fixes:
#    uncommitted edits are saved to skills-library-local.patch and re-applied.
# 2. Link exactly the skills listed in skills-library-keep.txt, into the category
#    named there (never over a skill of Justin's own with the same name).
# 3. Remove every other link into the library (unlisted or deleted upstream).
# 4. Report skills that are new upstream; they are NOT installed automatically.
# 6. Link the skills in skills-library-claude.txt into ~/.claude/skills (Claude Code) and
#    ~/.agents/skills (Codex), so both tools see the same set. --links-only runs only this step
#    (setup-codex.sh, tests); it needs no library clone.
set -euo pipefail

HH="${HERMES_HOME:-$HOME/.hermes}"
LIB="$HH/skills-library"
SKILLS="$HH/skills"
KEEP="$HH/skills-library-keep.txt"
PATCH="$HH/skills-library-local.patch"
DRY=0; LINKS_ONLY=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY=1 ;;
    --links-only) LINKS_ONLY=1 ;;
    *) echo "usage: update-skills-library.sh [--dry-run] [--links-only]" >&2; exit 2 ;;
  esac
done
run() { if [[ $DRY -eq 1 ]]; then echo "  would: $*"; else "$@"; fi; }

if [[ $LINKS_ONLY -eq 0 ]]; then
  [[ -d "$LIB/.git" ]] || { echo "error: no clone at $LIB" >&2; exit 1; }
  [[ -f "$KEEP" ]] || { echo "error: no keep list at $KEEP" >&2; exit 1; }
fi
LIB_REAL=$(cd "$LIB" 2>/dev/null && pwd -P || echo "$LIB")
added=0; removed=0; before=""; after=""; new=""; changed=""; gone=""

if [[ $LINKS_ONLY -eq 0 ]]; then

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

fi # LINKS_ONLY

# 6. Links for Claude Code (~/.claude/skills/<name>) and Codex (~/.agents/skills/<name>), both to the
#    same Hermes skill folder, for exactly the names in skills-library-claude.txt.
CLAUDE_LIST="$HH/skills-library-claude.txt"
SYSTEM_SKILLS="${CODEX_HOME:-$HOME/.codex}/skills/.system"
want=""
[[ -f "$CLAUDE_LIST" ]] && want=$(grep -vE '^[[:space:]]*(#|$)' "$CLAUDE_LIST" | awk '{print $1}')
# link_dir <dir> <label>: sets ladded/lremoved. Removes links it made (into ~/.hermes/skills or the
# library) that are broken or no longer wanted; never touches folders or links pointing elsewhere.
# Codex only: a name Codex already ships in .system is skipped, so no skill is listed twice.
link_dir() {
  local dir=$1 label=$2 link n src dest wanted=$want
  ladded=0; lremoved=0
  if [[ $label == codex ]]; then
    wanted=$(for n in $want; do [[ -f "$SYSTEM_SKILLS/$n/SKILL.md" ]] || echo "$n"; done)
  fi
  if [[ -d "$dir" ]]; then
    while IFS= read -r link; do
      [[ -n "$link" ]] || continue
      if [[ -e "$link" ]] && grep -qx "$(basename "$link")" <<< "$wanted"; then continue; fi
      run rm -f -- "$link"
      lremoved=$((lremoved + 1))
    done < <(find "$dir" -maxdepth 1 -type l \( -lname "$SKILLS/*" -o -lname "$LIB/*" -o -lname "$LIB_REAL/*" \))
  fi
  for n in $want; do
    if [[ $label == codex && -f "$SYSTEM_SKILLS/$n/SKILL.md" ]]; then
      echo "  codex: skip $n (Codex ships its own in $SYSTEM_SKILLS)"; continue
    fi
    src=$(find "$SKILLS" -mindepth 2 -maxdepth 2 -name "$n" | head -1)
    if [[ -z "$src" ]]; then echo "  $label: $n is not a Hermes skill, skipped"; continue; fi
    dest="$dir/$n"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then continue; fi
    if [[ -e "$dest" && ! -L "$dest" ]]; then
      if [[ $label == claude ]]; then echo "  claude: skip $n (Claude Code has its own)"
      else echo "  codex: skip $n (a skill of your own is there)"; fi
      continue
    fi
    run mkdir -p "$dir"
    run ln -sfn "$src" "$dest"
    ladded=$((ladded + 1))
  done
}
cadded=0; cremoved=0; xadded=0; xremoved=0
if [[ -f "$CLAUDE_LIST" ]]; then
  link_dir "$HOME/.claude/skills" claude; cadded=$ladded; cremoved=$lremoved
  link_dir "$HOME/.agents/skills" codex; xadded=$ladded; xremoved=$lremoved
fi
links="claude links: +$cadded -$cremoved   codex links: +$xadded -$xremoved"
if [[ $LINKS_ONLY -eq 1 ]]; then echo "links only   $links"; exit 0; fi

linked=$(find "$SKILLS" -type l \( -lname "$LIB/*" -o -lname "$LIB_REAL/*" \) | wc -l | tr -d ' ')
echo "library: ${before:0:7} -> ${after:0:7}   linked: $linked   added: $added   removed: $removed   $links"
[[ -z "$gone" ]] || echo "on your keep list but gone upstream:$gone"
[[ -z "$new" ]] || echo "new upstream (not installed; add to $KEEP if wanted): $new"
[[ -z "$changed" ]] || echo "library changed merged skills (ask Hermes to re-merge):$changed"
if [[ $DRY -eq 0 && -n "$(git -C "$LIB" status --porcelain --untracked-files=no)" ]]; then
  echo "local fixes in the clone: $(git -C "$LIB" diff --name-only | tr '\n' ' ')"
fi
if [[ $((added + removed)) -gt 0 ]]; then echo "changes show up in the next new session (WhatsApp: /new)"; fi
