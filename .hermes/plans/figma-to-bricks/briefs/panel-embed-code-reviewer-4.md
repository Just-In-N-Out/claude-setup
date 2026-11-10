# Role: reviewer (round 4, a narrow delta: fix round 3, the move onto main and two extended tests; report only): panel-embed-code

You are a fresh reviewer who never saw the build, the fixes or the move (**Opus 5.5, high**). Review only: change no
source or test, commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or
other worktrees (read them with `git show`). Never load bdryswi.com, B-Dry staging, a widget vendor's host or any live
site (local fixture servers and saved files only); never write to any WordPress site; no logins. Nothing may hide that
the importer's Chrome is automated.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3. **This job's guard: any path by which a pasted Code element carries code that is
not the widget's own (a tracking tag, a tag manager, a loader, another widget's script, a page script, a shared
library) is P0/P1.** The job has had three full review rounds (the project's cap); this is a delta review of what
changed since review 3, needed because nothing since then has been reviewed. Be exact: a real bug in the delta is a
finding; a recorded limit is not.

## What happened before you
- The job: on both importer routes a pasted Code element runs only a widget's own code. **Justin's rule for floating
  widgets** (chosen in a question, `evidence/panel-embed-code/review-2/justin.json`): paste a floating widget's code
  only when the exact file that drew it is a tag the old page served [and it drew the box by itself]; anything started
  by a starter script, a tag manager or the page's own script is listed with a plain note.
- Review 3 (at `6b115d3f`, on the old main `f708dfb6`) found R3-1 (P1): code with no file on the stack (a tag manager
  running a rule's injected inline script, `eval`, `new Function`) was skipped by the stack read, so the tag manager
  looked alone and its tag was pasted.
- **Fix round 3** (`6b115d3f..ca7d6046`): the stack is read from the wrapper's caller (`Error.captureStackTrace(holder,
  wrapper)`), and any frame whose place is not an `http(s)://` or `file://` address adds a marker (`about:inline-code`),
  so the box is listed `started` (or `page`); native frames (no line) and the tracker's own frames don't count. Also:
  an unknown `ownWhy` falls through to the unproven note (R3-4); the `page` note's words (R3-6); every pasted floating
  widget's note ends with a sentence that it runs that host's own file with whatever else the file loads (R3-2:
  wording only; whether to paste floating widgets at all is "to be confirmed with Justin": not a finding).
- **The move** (a rebase onto `main` `7eeca437ea100c821bcfb82cdbbe516a023ff097`, Build 2026-11-10.4; site-slider and
  staging-fit-renderer merged in between): one context-only conflict in `docs/HANDOFF.md`; no pin moved.
- **Two cited tests extended** (`085cc7ef`): the plan was amended (wording), and AC1's and AC7's cited tests now assert
  every clause of their amended sentences, under their unchanged names; a stale comment above `creatorTags` fixed.

## Inputs
- Approved plan (read-only; amended A1–A8, the Amendments list at its top):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md` (AC1–AC11; AC11 live).
- Branch `panel-embed-code-stack9`, head `8fd45d25f70eb6dbad796c1f512b77b3491cf836` (the ledger commit; the test
  commit is `085cc7ef`; the rebased head before them `906122e7`), base `main`
  `7eeca437ea100c821bcfb82cdbbe516a023ff097`. In your own worktree: `git checkout --detach
  8fd45d25f70eb6dbad796c1f512b77b3491cf836`, confirm HEAD and a clean status. **Your scope:** fix round 3 (`git diff
  6b115d3f ca7d6046`), the move (`git range-diff f708dfb6..ca7d6046 7eeca437..906122e7`) and `git diff 906122e7..HEAD`,
  read against `git diff 7eeca437...HEAD` where they meet the rest of the story.
- Review 3: `evidence/panel-embed-code/review-3/review.json`, probes `~/.cache/pec-r3/` (`scripts/probe3.ts`,
  `stacks.ts`, `cost.ts`). Fixer 3's receipts (read, don't trust): `evidence/panel-embed-code/fixer-3/` (`mutation.log`,
  `probes/`, `stacks-raw-base.log`). The move's record: `evidence/panel-embed-code/stack-9/` (`range-diff.txt`,
  `patch-ids.txt`, `conflicts.md`, `pins.md`, `meet/`, `probes/`, `logs/mutants.log`). Recorded limits (don't re-report
  unless you rate one higher, with a scenario): `evidence/panel-embed-code/follow-ups.md` and HANDOFF's "Known limits"
  in the job's section (R3-2: a served file that inserts a button as plain markup is pasted and may track — review 3's
  T2 —; R3-3: a served SDK the page inits that draws after an `await`; a vendor file that builds templates with `eval`
  is listed; a custom element's constructor inside a wrapped `innerHTML`; a page that leaves a `prepareStackTrace`
  returning call sites).

## Check hardest
1. **R3-1 is closed, and "code with no file counts" can't be dodged by a real loader shape.** Probe with the tracker
   injected the way the capture injects it (`Page.addScriptToEvaluateOnNewDocument`), on your own pages: a served tag
   manager whose rule draws a fixed box from an injected inline `<script>` (appended, `document.write`, `innerHTML` +
   re-created script, a `<script>` with a `blob:` / `data:` src), from `eval`, indirect `(0, eval)`, `new Function`,
   `setTimeout("string")`, a `javascript:` URL, an inline event-handler attribute it wrote (`onclick="…"`,
   `<img onerror=…>`), an `import()` of a `data:` module, a template compiled by a library; and **an async gap**: the
   rule's code awaits, or defers with `setTimeout(fn)` / a promise / `requestAnimationFrame` / a `MutationObserver`,
   where `fn` is a function **defined inside the no-file code** but called later with only native frames above it:
   what does the stack show then (the function's own frame is still `<anonymous>:L:C`: counted?) — and a function
   defined in the tag manager's file but invoked by no-file code. For each: is the tag manager's tag pasted? A real
   hole is P0/P1 with the shape and how common it is. Then draw each pasted footer on a fresh page, click it, and
   count what your servers received.
2. **The positive cases still paste, and nothing honest got listed that review 3 saw pasted for the right reason:** a
   served widget file drawing its launcher by itself at load, in `forEach`, in a promise, in its own timer, from its
   own `DOMContentLoaded` handler, from its own `requestAnimationFrame`, served twice; a widget file minified into one
   line; a file served with `type=module`; a widget whose own file uses `new Function` for a template (listed: the
   recorded safe side — say how the note reads).
3. **The stack read itself:** `Error.captureStackTrace(holder, wrapper)` on every wrapped way an element is made
   (`createElement`, `createElementNS`, `innerHTML` / `insertAdjacentHTML` setters, `cloneNode`, `new Image`,
   `document.write`, a custom element's constructor): is each wrapper passing itself (a missed one counts the
   tracker's own frames as no-file code and lists everything made that way: which widgets would that wrongly list?);
   the page's own `Error.stackTraceLimit`, `prepareStackTrace` and `captureStackTrace` behave as before for the page's
   code; the cost per element (`cost.ts`) and one timing of `npm run capture` on a heavy local fixture, main against
   head, twice each at the same load.
4. **The move:** your own `git range-diff`; the HANDOFF resolution (this job's block first, main's unchanged, the
   placeholders intact; `git diff 7eeca437 906122e7 -- docs/HANDOFF.md` adds lines only); outside `docs/`, `git diff
   ca7d6046 906122e7` holds only what `git diff f708dfb6 7eeca437` holds. Where the jobs meet: the stack fixer's probe
   (a carousel beside floating widgets: a slider's script-made slides, loop copies, arrows and bullets never read as
   a floating box; the code route byte for byte main's) — re-run one form of it yourself.
5. **The two extended cited tests** (`test/unit/embed-code.test.ts` for AC1; `test/web/panel-embed-code.test.ts` for
   AC7): each clause of the amended AC sentence is asserted, under the exact cited name; no assertion narrowed (`git
   diff 906122e7 085cc7ef -- test/`); two mutants of your own under the 4 GB cap (one per test, a clause the fixer's
   eight don't name); the hand-made "unread" capture is a shape a real capture makes.
6. **R3-4 and the notes:** a capture with an unknown reason converts (panel route, all parts) with the unproven note;
   the `page`, `started`, `frame`, `unread` and pasted notes: true, one plain sentence, something Justin can act on.
7. `npm run check` on head; the job's unit files with `F2B_UNCHANGED_SUMS=1`; `plugin-convert`; the panel's sandbox
   (`tsconfig.sandbox.json`).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md` (the embeds line: it ends with the safe rule and reviews 2 and 3's lessons), the repo
`CLAUDE.md` in the main folder ("Code Figma runs uses only the language's built-ins"; "Website captures"); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the delta for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-4/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   7eeca437ea100c821bcfb82cdbbe516a023ff097 /home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code` (exit
   2 means your file is wrong: fix it; if the script asks for a full review from the base because the earlier reviews
   sit on the old main, say so and review the whole story's diff `7eeca437...HEAD` for anything the three rounds
   could not have seen, keeping the focus above). Say whether R3-1 is closed.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-r4/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after (stop it by the PIDs of its own profile path; never `pkill -f
  <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive` scratch tree has neither `tsc` nor
  `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's
  `node_modules` in; a piped, chained or redirected git command is refused: `git archive -o <file> <sha>` in its own
  call, then untar). Scripts written with Write; probes and logs under `~/.cache/pec-r4/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (export
  variables first, no `--setenv=PATH`). Known flake: `capture-entrances` R8-1 under load. Waits under 115 s. The PC lost
  power twice this week and agents were stopped by a usage limit twice: keep notes and finished probe results on disk;
  when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), R3-1 closed or not, `verdict`, `ac_status` (per AC:
what the review saw), then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION: check and
save these skill_lessons now.`
