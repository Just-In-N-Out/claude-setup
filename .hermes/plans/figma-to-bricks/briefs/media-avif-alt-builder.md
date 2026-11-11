# Role: builder (Full): media-avif-alt — a scanned page's photos go up as AVIF, and pictures with no alt text get AI alt text

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline` (the key/password guards, the "only adds media and fills an empty alt of its own items"
guard), `security-best-practices`, `authorized-write-safety`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/planning-checks.md`). Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

**Hard rules:** never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any WordPress site;
never run `site:upload`/`site:import` against anything but the tests' own 127.0.0.1 stand-ins
(`test/fixtures/wp-standin.ts` and a new local alttext.ai stand-in that answers as alttext.ai does — read from
`src/ui/describe.ts`, the plan and alttext.ai's own WordPress plugin source, never from what the new code expects);
**never call the real alttext.ai**, never hold or ask for Justin's key or password; touch nothing under `~/Downloads`
(the planner's read of Justin's run is in its evidence). The AVIF encoder files may be fetched from jsDelivr once (the
pinned `@jsquash/avif@2.1.1` the panel already pins, hash-checked) — nothing else from the network.

## The plan (approved under Justin's standing auto-go and "go with recommended": Q1–Q13 ⭐)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/plan-approved.md` (read-only; AC1–AC17, AC16 and
AC17 live). Copy it to `docs/plans/2026-11-11-media-avif-alt.md` in your branch. Planner evidence and probes:
`~/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/planner/`. Build every AC test first (RED on the base, then
GREEN), each named exactly as the plan names it, one picture or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/builder/` (the command's own printed output for the prompts,
the `yes` question with counts and credits, the stops). No file under `src/` changes (AC15).

## Where
Your own worktree (starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch `media-avif-alt-build`. Files:
`tools/lib/site-upload/`, `tools/lib/site-import/`, `tools/site-upload.ts`, `tools/site-import.ts`, tests. Running at the
same time: media-clickable (reads `media.json`'s id/url/filename; `src/core/site/background.ts`), site-menu-motion,
site-sticky-header, site-scroll-lock, site-native-structure — none in your files; name any shared file you touch
(`docs/HANDOFF.md`, `test/web/site-import-others-unchanged.test.ts` moves to your AC14 test).

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close; the whole unit suite; the full `test:web` and `test:browser` file by file at the close under 4G
scopes (B-Dry files 8G), compared with main by name (known failing on main here: composition-clipping, fonts, hero-pair,
peer-sides, pill-holder; with `F2B_STORY_PINS=1`, site-media-upload's "AC4 without a media map every paste is byte for
byte as main makes it" already fails on main). Ledger in `.superpowers/sdd/2026-11-11-media-avif-alt/progress.md`;
HANDOFF section (newest first, `Build <set at merge>`, paste check "id at merge"); the CLAUDE.md uploader rule and media
decision changes (Q6 and Q8 reversed, the widened "fills an empty alt of its own items") go as exact lines in HANDOFF for
the merge finisher — don't edit CLAUDE.md. Commit after each passing task (plain `git commit -m`, no author override, no AI
lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/mab/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start: `pgrep -f
'[u]ser-data-dir=<your profile path>'`; never `pkill -f`. Piped/chained git commands may be refused: script files run
with `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s; long drivers with `setsid --fork`,
waiting on `^EXIT=`. 8 agents on the PC: one Chrome suite at a time under a 4G scope; SIGTERM/143/137/"Killed" may be
earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first
and rerun alone under a cap.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED evidence, GREEN, picture; gates against main by name; the secret-handling proof
(where the key and password can and can't go, with the mutants); `found_else`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons
now.`
