# FIXER round 2: cortexos-memory-hook (claude-setup) — Mini pipeline

Role: FIXER. Verify each finding (`receiving-code-review`), fix test-first, commit, stop `ready-for-next-review`. Don't rebase.
- Approved plan (read-only contract): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
- Worktree /home/justin/.claude-setup-wt/cortexos-memory-hook, head 1118f2c6cec9d5b2eed01731147a69b72e6bad9c, story base dd80ac4a38c74caf156b9e786f299471cf6c513b.
- Evidence: ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/ (review-2/ holds the reviewer's probes: space-replay.out,
  ac3-window-probe.out, kw-fuzz.out, mutants.out). Write your logs to fixer-2/ (counts only; never copy real prompts or transcripts: it syncs).
- Never edit live $HOME files, don't push or sync, never write to CortexOS.

## Justin's rulings (2026-11-07, review-2/justin.json)
- R2-1: **fix it**: stop the parent walk at the cwd's own git repository (a linked worktree uses its main repo via
  `git -C "$cwd" rev-parse --path-format=absolute --git-common-dir`). Keep R1-2's worktree/subfolder/session-folder behaviour. A
  folder that is its own repo with no memory folder (e.g. ~/Leorna/cortexos, whose session folder is the home one) queries only
  claude-shared. Add a fixture repo nested under a folder that has memory. Keep the hook well inside its time budget (git calls must
  be bounded; it's fine to skip git when the cwd's own key has memory). Keep the early gates bash-3.2-safe.
- R2-2: **fix it**: keep linear time but produce exactly the plan's keyword output for any prompt: read tokens in order and stop at
  the 16th distinct keyword (no fixed 4000-character window changing the result). AC3 stays as approved. Keep R1-1's speed (≤ ~200 ms
  on 1 MB worst shapes) and the secret filter on whole tokens.
- R2-3: add the two tests it names (≈3900-character prompt with keywords near its end; a straddle fixture), or their equivalents
  once the window is gone, and prove the R2M1/R2M3-style mutants die.
- A planner is amending AC2's wording in parallel to state which folder counts (cwd's own, nearest parent within the same git repo /
  main repo, session folder, else claude-shared). Don't edit the plan; if your fix can't match that rule, stop `plan gap`.

## The referee's lines (verbatim)
R2-1  P1  .claude/hooks/cortexos-memory.sh:106  False AC2 (changed rule): the R1-2 fix's parent walk (lines 103-107) takes the nearest ancestor folder that has a memory folder even across a git-repository boundary, so a cwd in its own repo with no memory folder queries the parent folder's project space. AC2 says 'A cwd with no memory folder sends only the claude-shared request', and this case breaks it under every reading: the plan's key rule (key = cwd), Claude Code's own (one memory folder per git repo, linked worktrees share the main repo's) and the session's (transcript folder). Replay of 881 real typed main-session prompts through 8f168ca and 1118f2c with the real ~/.claude/projects layout (review-2/space-replay.out): 91 change; 70 are worktrees or subfolders whose ancestor is the cwd's own git repo or its main repo (R1-2 working as meant); 21 are cwd /home/justin/Leorna/cortexos (its own git repo, no ~/.claude/projects key at all, session -home-justin, whose MEMORY.md is the one Claude Code loads for that session) and now query claude-leorna (the non-repo parent ~/Leorna, 10 notes) plus claude-shared instead of claude-shared only. The new test cannot see it: its fixture folders are not repos. Fix: stop the walk at the cwd's git repository (for a linked worktree, the main repo of `git -C "$cwd" rev-parse --path-format=absolute --git-common-dir`), which keeps all 70 and drops the 21, with a fixture repo nested under a folder that has memory; and, since the worktree and session-folder cases R1-2 added also go past AC2's literal wording (Design: 'When ~/.claude/projects/<key>/memory doesn't exist, only claude-shared is queried'), have the planner amend AC2 for Justin to approve which folder counts.

R2-2  P1  .claude/hooks/cortexos-memory.sh:84  False AC3 (changed rule): the R1-1 fix builds keywords from the first 4000 characters only, so for a prompt with AC3's features (please, the, sk-abc123def456ghi789jkl, repeated words) 'every request's query equals the keyword jq's output' stops holding once the prompt passes 4000 characters and its first 4000 hold fewer than 16 distinct keywords. Real scripts against a stub (review-2/ac3-window-probe.out): AC3's sentence after 4000+ characters of 2-letter tokens: the plan jq and 8f168ca send 'see output below run stuck fix earlyoom kill check hook key', head sends 'see output below run stuck'; after a 4000+ character Arabic paste: the plan jq and 8f168ca send 'fix earlyoom kill check hook key', head sends no request at all. Head's query is always a prefix of the approved one (3000-prompt fuzz, review-2/kw-fuzz.out: 1882/1882 equal up to 4000 characters, 1118/1118 prefixes past it), so AC3's privacy properties hold, and no real prompt is affected (30 distinct real typed prompts over 4000 characters, at least 62 distinct keywords in each window, 30/30 equal: review-2/ac3-real-long-prompts.out). Fix: keep the plan's exact output in linear time (stream the tokens and stop at the 16th distinct keyword instead of cutting a fixed window), or have Justin amend AC3 to 'keywords from the first 4000 characters'.

R2-3  P3  .claude/hooks/tests/cortexos-memory.test.sh:428  The R1-1 test does not pin its window: on a scratch copy of head's script, mutant R2M3 (a 500-character window instead of 4000, so prompts of 500-4000 characters would stop matching the plan jq) and R2M1 (cut back only when character 4000 is a letter or digit, so a token cut at '-', '.' or '_' keeps its head as a keyword, e.g. 'sk-ant' of 'sk-ant-api03-...') survive all five search tests; R2M2 and R2M4 are killed, R2M5 is the equivalent the fixer removed (review-2/mutants.out). Fix: add a prompt of about 3900 characters whose keywords sit near its end, and a straddle fixture whose character 4000 is '-'.

## Rules
- Failing test first for each fix; whole offline suite and AC14's suites after (tallies equal base except the new tests).
- For each fixed finding, state `ac_rules_changed: none | [ACn…]`.
- Commits: plain `git commit -m`, personal identity, no AI/Co-Authored-By trailer, no CLAUDE.md.
- Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-fixer-2/` (mkdir, no -p); remove by literal path.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. jq global regex (scan/splits/gsub) is quadratic; --arg caps at 128 KB.

## Report
Return `{status: ready-for-next-review|stopped, head, findings[{id, outcome, ac_rules_changed, test, commit, evidence}], suites[], found_else[], skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
