# Role: reviewer (Full round 1: the whole story; report only): media-avif-alt

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder or other worktrees (read them with `git show`). Never load any live site; no logins;
**never call the real alttext.ai**; never write to any WordPress site; run `site:upload`/`site:import` only against the tests'
127.0.0.1 stand-ins; touch nothing under `~/Downloads`.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real run hits (Justin's own `site:import`/`site:upload` against
his WordPress site, with his alttext.ai key), each with a concrete scenario; edge cases are P3. **Security is never an edge case:**
anything that could leak the WordPress Application Password or the alttext.ai key (to a file, output, argument, environment,
Chrome, another host, a log, the record, a paste) or write to WordPress beyond "add media items and fill an empty alt of an item it
uploaded itself" is P0/P1.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/plan-approved.md` (AC1–AC17;
  AC16, AC17 live).
- Branch `worktree-agent-a46af889d7ceb28a3`, head `23615bb9` (full SHA with `git rev-parse`), base main
  `0248176342c662b821629d462f4d15a2a2a1df98`. Review `git diff 02481763...HEAD`. Builder receipts (read, don't trust):
  `evidence/media-avif-alt/builder/` (logs, mutants, captures).
- Main has since moved (Build 2026-11-11.5: media-clickable and site-scroll-lock, neither in `tools/lib/site-upload/`); review
  against the job's own base.

## Check hardest
1. **Secrets** (load `security-best-practices`, `authorized-write-safety`): the key file (0600, its folder's mode, a symlink
   attack, a key file another user can read, replacing it with `--new-ai-key`), the scrubber (every encoding: URL, base64, JSON
   escaped), error paths (a thrown error's message or stack printing a request with the key), the encoder's Chrome
   (`--host-resolver-rules`, what it receives), the router (only alttext.ai's address; no redirect; `F2B_*` overrides loopback-only).
2. **WordPress writes:** only media creates and `{alt_text}` updates of items this tool uploaded (by the record) whose alt is empty
   now; never another item, never a non-empty alt; the typed `yes` still gates every write; `--dry-run` sends nothing.
3. **AVIF on real pictures:** EXIF orientation, CMYK JPEG, 16-bit PNG, a PNG with a palette and transparency, a huge picture
   (memory: the 2560 cap), an animated WebP/PNG detected, a corrupt file stops before any upload; the encoder files' SHA check
   and cache; first run with no network for jsDelivr (what Justin sees).
4. **Re-runs and the record:** his 34 already uploaded as served are not sent again; `--reupload-avif`; a stopped run resumes;
   the record keyed `-avif-max2560`.
5. **alttext.ai:** the real API shape as the panel's `src/ui/describe.ts` uses it; out of credits mid-run; a 401; a slow answer;
   the AltText.ai WordPress plugin already filling alts.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/review-1/review.json` (round 1, full SHA), self-checked with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
0248176342c662b821629d462f4d15a2a2a1df98 /home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt`. Load
`requesting-code-review` and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`; read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` under 31 characters (`~/.cache/mar/t1`; Chrome's
"Socket path too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start
(`pgrep -f '[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`.
Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run
--user --scope -p MemoryMax=4G -p MemorySwapMax=0`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom
--since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, the real-use scenario) or "none"; the secret and write audit; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
