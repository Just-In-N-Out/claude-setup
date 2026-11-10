# Role: reviewer (Full, round 3: the fix commits only, report only): staging-fit-renderer

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging or any live site (local stand-in servers and saved files
only); never write to any WordPress site; no logins. Nothing may hide that the tool's Chrome is automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a
real site or normal use hits (`npm run site:live -- <a published Bricks page> …` run by Justin or an agent on his
WordPress staging site; `npm run site:check`; the browser tests' renderer; Figma designs converting as before), each
with a concrete real-use scenario. Edge cases are P3. **Justin's rule "Never write to any WordPress site; GET/read only"
is this job's guard: anything but GET/HEAD/OPTIONS reaching the published site in normal use of `site:live` (a normal
end, a stop, an error, Ctrl+C) is P0/P1.** A tool killed outright (`kill -9`, the machine's earlyoom) is a known,
recorded limit: rate it by how a real run meets it.
**This is the last review round of this job** (the project caps review rounds at 3): what is not a real-use bug goes to
P3.

## Inputs
- Approved plan (read-only, amended 1–3): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`
  (AC2 as amended: "every other request (a POST, PUT, DELETE, a beacon) is refused before it leaves").
- Branch `staging-fit-renderer-fix2`, head `b6bccface956c47689d5f687d280a6707c489cd8` (code head `14cf9db2`; the last
  commit is HANDOFF and the ledger), on local `main` `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3).
  In your own worktree: `git checkout --detach b6bccface956c47689d5f687d280a6707c489cd8`, confirm `git rev-parse HEAD`
  and a clean status.
- **Scope: the fix commits `git diff b512ec6a4d0e5add0c29455190dbde3df8c1b9ff..HEAD` and what they touch:**
  - `tools/lib/read-only.ts`: `holdRequests` returns `Hold { leave(), end() }`; `leave()` closes each tab and each
    shared or service worker while the guard answers, and waits until they are gone and nothing has come for 300 ms
    (capped at 5 s); `end()` is `leave()` then a SIGKILL of Chrome's process group, never `Browser.close`.
  - `test/browser/chrome.ts` (additive): `Browser.kill()` / `killNow()`, `launchChrome({ group: true })`.
  - `tools/site-live.ts`: one `end()` from the run's `finally`, from SIGINT/SIGTERM/SIGHUP handlers and from a kill at
    process exit; the OK path calls `leave()` before the report.
  - New tests `test/web/site-live-closing.test.ts` (6) and `test/unit/read-only.test.ts` (+4); the in-repo plan brought
    to the approved copy; a comment in `test/browser/render-site-flip-face.test.ts`.
- Review 2 (`evidence/staging-fit-renderer/review-2/review.json`, probes `probe1`–`probe5` there) and the fixer's
  receipts (read, don't trust): `evidence/staging-fit-renderer/fixer-2/` (`red/`, `green/`, `mutants/README.txt`,
  `gates/summary.txt`, `gates/NOTES.txt`, `probes/README.txt`).
- Check hardest:
  - is R2-1 closed through `site:live` itself on every ending (OK, no paste on the page, a login page, an error
    mid-run, Ctrl+C, SIGTERM, output cut by `| head`): count what a stand-in server received at least 3 s after the
    tool's process is gone, with a page that beacons and keepalive-POSTs on `visibilitychange`, `pagehide`,
    `beforeunload`, `unload` and on a timer, from the page, a cross-site frame, a service worker and a shared worker;
  - the 300 ms quiet wait and the 5 s cap: a slow page or a busy machine (several Chrome jobs run here at once) letting
    a request out, or the cap ending the wait with requests still coming and Chrome then killed (is anything released
    by the kill?);
  - `chrome.ts` is shared by every browser test and by capture: the additive change alters nothing for other callers
    (`group: true` only where asked; no Chrome left running after other tools; the detached launch and the terminal's
    Ctrl+C for other tools);
  - the SIGHUP/SIGTERM handlers and the kill at exit: no orphan Chrome, no hang, exit codes as documented, a run under
    `nohup` or in the background behaving sensibly;
  - the reading itself unchanged (report.json equal to the reviewed head's apart from the fields that must differ);
  - the new tests can fail (read the mutant receipts; run one or two mutants of your own under the 4 GB cap). The
    fixer changed the OK-path cases to assert only that the run reached its last line, not exit 0, because of a known
    5.09 px flake in the fixture: is that an honest test, or one that can no longer fail on what it claims?
  - the fixer's `found_else`: `tools/site-check.ts` has no read-only guard (its Chrome draws the paste from a file and
    asks for whatever the paste names by address); capture ends with `browser.close()` and has no guard (it reads the
    old site as a visitor). Both are older than this job: say plainly what could reach whose site in normal use, and
    rate by the importer rule (P3 follow-ups unless this job's diff made them worse).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the line "Holding a Chrome to read-only"), the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope for real bugs (probe the reviewed head and the head side by side).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-3/review.json`, then
   self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree>
   --base fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfr-r3/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of
  your own at a time; check with `ps` by your profile path that none is left after each probe (this fix kills Chrome
  by process group: make sure a probe never signals a group other agents' Chromes are in). Worktree `node_modules` may
  lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written with Write; keep probes and
  logs under `~/.cache/sfr-r3/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
