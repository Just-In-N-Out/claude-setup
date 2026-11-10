# Role: reviewer (Full round 2, report only): staging-fit-renderer

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (`npm run site:check` and `npm run site:live` on a captured page pasted into Bricks 2.3.9 or 2.4.2, telling the truth
about the published page; browser and web tests still meaning what they meant; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/plan-approved.md`
  (AC1–AC5; AC5 live). The job: our checks see what real Bricks draws — the renderer prints a class's control CSS as
  `.cls.brxe-<element>` like Bricks; a new `npm run site:live` maps a published Bricks page to its paste by structure and
  measures it against the capture, read-only (GET, logged out, the old site's host never reached); `site:check --whole`
  draws header, page and footer together with other hosts' pictures from the capture; Bricks 2.4.2's front-end CSS is
  added beside 2.3.9 (`--bricks`); the flip-box face finding (R5) is explained. Q1 A / Q2 A taken.
- Branch `staging-fit-renderer-fix1`, head `b512ec6a4d0e5add0c29455190dbde3df8c1b9ff`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach b512ec6a…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/builder/`
  (the second builder's in `cont/`). Their deviations and findings (ledger, HANDOFF): the selector is built in
  `render-order.ts`; nvwzkg stands in from the site's img sizes; site:live recognises a swapped element by its classes
  only; the 48-width dry run against staging shows 451–4036 px at 768–991 (today's capture read that range without
  styles: judged only after Justin's re-capture). **site:live must never write to a site, log in, or reach the old site's
  host**: check that hard (every request it can make).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: the renderer's selectors or order now differing from real Bricks 2.3.9/2.4.2
   in another way (so checks pass or fail wrongly), existing browser/web receipts changing meaning, `site:live` mapping
   the wrong elements or passing a page that differs (or failing a matching one), any request other than GETs to the
   published page and its assets, `--whole` or other-host pictures hiding a real difference, Figma designs or pastes no
   longer byte-identical, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-renderer`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-r2/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`

## Round 2 note
Round 1 (`evidence/staging-fit-renderer/review-1/review.json`) found R1-1 P2 (a swapped element was left out and the run
said OK) and R1-2 P2 (a published page on a subdomain of the old site's host couldn't be read), and the main session
added Justin's "GET/read only" rule (R1-3, R1-4's WebSocket). Fixer 1 (`5cb8fdaf` and around it; receipts
`evidence/staging-fit-renderer/fixer-1/`, read, don't trust): a swapped element is named and compared and fails the run
unless within 2 px of the capture's box at a width where the capture holds one (**AC4's words "a named exception the
checks skip" are being amended by a planner right now: judge the behaviour, and say if the amendment should say more**);
`EXCLUDE <page host>` after the `MAP … ~NOTFOUND` rules; a new `tools/lib/read-only.ts` refuses every non-GET/HEAD/OPTIONS
request browser-wide (CDP Fetch on the browser target) and sends WebSockets to a refusing SOCKS end; `Browser.on` added to
`test/browser/chrome.ts` (every browser test uses that file: check nothing else changed for them). Its `found_else`: a
whitespace-only text inside `display: contents` wrappers is dropped by Chrome now and then, so `site-live.test.ts` flakes
at 5.09 px (older than the fix; a conversion follow-up); a page fetching part of itself by POST is read without that part.
Review the whole story again from `fd1986dc` and check those fixes hold (can any write still leave that Chrome: a form
auto-submit, `sendBeacon`, a service worker, `fetch` keepalive, a redirect turning GET into POST; does the guard break
reading a normal Bricks page). Keep probe scripts under `~/.cache/sfc-r2/`, never the `/tmp` scratchpad.
