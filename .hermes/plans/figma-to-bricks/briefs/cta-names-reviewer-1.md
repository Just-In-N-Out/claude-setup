# cta-names — Reviewer round 1 (Mini: full review + verifier AC work)

**Role:** fresh reviewer and AC verifier. You never saw the build. **Report only:** change no source, commit nothing; write only into the evidence folders named below.

**Worktree to review (read-only):** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a521d809739b08a2d`, branch `worktree-agent-a521d809739b08a2d`, head `86cd55dd` (get the full SHA with `git rev-parse HEAD`). Base: `31321bb4` (full SHA via `git rev-parse 31321bb4`). Review `git diff 31321bb4..HEAD`. Run checks in your own scratch copy if a command would write into that tree (e.g. `git worktree add` is not possible for you: instead copy with `git -C <worktree> archive HEAD | tar -x -C <scratch dir>` and symlink `node_modules`), or run read-only commands in place.

**Approved plan:** `~/.hermes/plans/figma-to-bricks/evidence/cta-names/plan-approved.md` (AC1–AC6; AC6 is live, owed to Justin). Builder receipts: `~/.hermes/plans/figma-to-bricks/evidence/cta-names/builder/` — don't trust them; re-run.

**What it does:** every call-to-action gets an accessible name: a linked CTA → `settings.link.ariaLabel`; an unlinked CTA → one `_attributes` `aria-label`; one inside a linked card → none. The name is the visible words (spaces collapsed, trailing arrow dropped); vague words ("Learn more") → "<words> about <card title>". The builder departed from the plan in one place (a title fallback to the nearest section box with words ≥1.25× the label when no card is drawn) and made rulings R1–R3 (HANDOFF "CTA names"): judge whether they are correct and whether the fallback picks wrong titles on real designs (check the replays of the corpus files and `figma-to-bricks-debug-page-1.json`; WCAG 2.5.3: the name must start with the visible words). Also check that 41 rewritten routing tests still pin what they pinned. Read the repo's `CLAUDE.md` (worktree copy) for the standing rules (CTA rules, nested links, page-addresses relink, byte-identical replay, architecture).

**Skills:** `requesting-code-review`, `code-review-practice`, plus read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (records) and `references/ac-verification.md` (verifier AC work, `ac.json` format).

**Project rule for reviews (Justin, 2026-10-31 "built fast"):** report bugs a real design or normal use hits as P0–P2 with a concrete 5+ word scenario; edge cases go in as P3. Severity scale: P0/P1 security hole, false AC, broken normal work; P2 a bug a real designer/site could plausibly hit, a test that can't fail, anything breaking an AC; P3 cosmetic/docs/deliberate-evasion-only.

**Do:**
1. Full review (round 1, scope `full`, `from` = full SHA of 31321bb4, `head` = full HEAD SHA). Write `~/.hermes/plans/figma-to-bricks/evidence/cta-names/review-1/review.json` per review-loop.md.
2. Verifier AC work per ac-verification.md: run `npm run check` (in a scratch copy if needed) and the browser suite on base and head, compared by test name (the builder did NOT run the full browser suite; note CHROME_PATH per `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`); run every non-live AC's check on head and on base (it should fail or not apply on base). Write `~/.hermes/plans/figma-to-bricks/evidence/cta-names/verifier/ac.json` and set `ac_status`.
3. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 31321bb4 ~/.hermes/plans/figma-to-bricks/evidence/cta-names` — exit 2 means fix your file.

**Memory rule:** mutation/big browser runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. Other agents use Chrome too: if a browser run is slow, wait rather than kill other processes.

**Return:** `verdict`, findings (id, severity, file:line, claim, scenario), `ac_status`, per-AC result, and `skill_lessons[{skill, lesson, evidence, enforce}]` (usually empty; never edit skills or memory). End with: `MAIN SESSION: check and save these skill_lessons now.`
