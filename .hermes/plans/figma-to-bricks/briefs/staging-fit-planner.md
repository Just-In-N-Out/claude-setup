# Role: planner (Full pipeline): staging-fit (website importer) — why the real Bricks paste differs at tablet and phone

You are a fresh planner (Opus 5.5, high) for FigmaToBricksV2. Write an implementer-ready plan; change no source or test,
commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it, or use your
own worktree). **Never load bdryswi.com** (it has a bot check; Justin's own scan is the site's record). **Never write to
any WordPress site; GET/read only; never log in** (ask the main session first if a login seems needed). Nothing paid.

**Skills:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md`, `references/rendering-validation.md`),
`engineering-best-practices`, `implementation-planning`, `systematic-debugging` (a bug: prove each root cause with
file:line evidence before proposing a fix). Read the repo `CLAUDE.md` ("Build general logic": nothing keyed on B-Dry;
"The renderer only approximates Bricks. The live page is the final judge") and `reference/bricks/README.md`.

## The job (Justin, 2026-11-09)
Justin captured bdryswi.com (build 2026-11-09.1: `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, 48 widths,
16 ranges) and pasted the importer's output into B-Dry staging (Bricks 2.3.9). His words: "for desktop it does not look
bad … the real issue that I have is that for tablet, mobile, mobile landscape, it does not look good at all. Are you sure
the way we are capturing it is right?" — yet `npm run site:check` and our renderer (`test/browser/render.ts`) say the
paste is within ~2 px at every width. He now asks: compare the real site with what the copy-paste gave, and fix the
differences. He is pasting the **whole page in one paste** (header + page + footer, `--elementor`, build 2026-11-09.3),
made from that capture: `/home/justin/f2b-test/paste-el3/whole.json` (and `header.json`, `page.json`, `footer.json`,
`notes.txt` beside it) onto **`https://bdry.staging.growithgro.com/homev2/`** (public, logged out; Justin confirmed).
An earlier plain-route paste looked the same way on tablet and phones.

## Work
1. **Measure the real paste.** Read the staging page as a logged-out visitor (headless Chrome over CDP, the repo's
   `test/browser/chrome.ts`; add `?f2b=<random>` to pass LiteSpeed's cache) at the capture's widths, at least 1440, 1366,
   1024, 991, 834, 768, 767, 600, 479, 390, 360, 320. If it shows a login/password page or the paste isn't there yet (e.g.
   Justin hasn't saved), stop that step and say so — never log in. Save the HTML, the CSS Bricks served (inline and
   files), and per-width screenshots and element boxes under your evidence folder.
2. **Compare three things per width:** (a) the capture (the site's record: `web.boxes`, its renders); (b) our renderer's
   drawing of `whole.json` (as `site:check` does); (c) the real staging page. Map staging elements to capture elements by
   the paste's sources files / class names. List every difference over 2 px, worst first, by part, section and width.
3. **Find each root cause** where (c) differs from (b) (our renderer's model of Bricks is wrong or incomplete: Bricks'
   own front-end CSS, breakpoints, theme/Theme Style, `max-width:100%`, wrapping, the editor vs front end, CSS Bricks drops
   or rewrites on save, the order or specificity of printed CSS, missing classes, `@media` rules Bricks rewrites) and
   where (b) differs from (a) despite site:check (what it doesn't compare). Also check whether the **capture** itself is
   right at those widths (Justin's question): e.g. its per-range reading, the touch/mouse ranges, any range read from the
   wrong layout. Prove each cause with a minimal reproduction, file:line in our code, and (for Bricks) its CSS/PHP/JS from
   `reference/bricks/` or the served staging files.
4. **Plan general fixes** (the importer, and the renderer so our checks see what real Bricks does), each with numbered
   ACs **AC1, AC2…** marked **(proposed)**, one named test each (generic fixtures RED on main; B-Dry named-only on the
   saved capture; the plain route and Figma designs byte-identical unless a fix must change them — say so), `(live)` for
   Justin's re-paste on staging (a `(live)` AC also lets a later agent re-measure the staging page read-only after his
   re-paste). Questions at the top with a ⭐ answer each (the standing auto-go takes them). Split into separate jobs if
   the causes are independent, and say which first.

## Inputs
- Main: `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3). Evidence folder:
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/`. Write the plan to
  `~/.hermes/plans/figma-to-bricks/staging-fit.md`.
- Earlier jobs' plans and ledgers in `docs/plans/` (web-code-page, elementor-map, site-motion, capture-speed,
  elementor-phone-fit, elementor-footer-fit) and HANDOFF's sections for what the paste already does.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sf-p/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome you
  start. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run one `bash <file>` per Bash call (scripts
  written with Write).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry renders 8G). Waits under 115 s.

## Report (as text)
The plan path, the differences table (top 10, worst first), each root cause in two lines with its proof, the ACs one
line each (mark live ones), the questions with ⭐ answers, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
