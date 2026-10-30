# Away grant: Justin asleep (2026-10-29, night): website importer

Justin's words: "Okay, I'm gonna have to sleep, so just keep this going, keep it rolling. And when I wake up, let me
know."

**Scope:** the website importer: the proposal update (`website-importer-brainstorm.md`, Amendment 1 of
`briefs/website-importer-planner.md`), then wave one (J0 compare tool ∥ J1 capture core) through the full pipeline
(planner → builder → review/fix → verifier → auditor → ac-check → finish and local merge), then the next waves as the
proposal orders them. Justin chose "Go, exact everywhere" before sleeping.
**Ends:** when Justin writes again.

**While away (as `run-without-stopping` and the earlier away grant):**
- Take every ⭐ / recommended answer; record each as "taken under the away grant" in the plan and here.
- A review brake (`ASK JUSTIN`): take the recommended route, write `review-<n>/justin.json` with his away words.
- A lost agent researches and implements its best, its rulings recorded as not yet confirmed.
- Live ACs stay owed and are listed in the morning report.
- Merges into local `main` per the project's finish steps when `ac-check` says ALL ACCEPTED or READY FOR THE USER.
- Resume agents a usage limit stopped. Keep this log for the morning report.

## Log
- Away grant recorded. Running: the proposal planner, updating the proposal with Justin's one-to-one answers
  (Amendment 1) and splitting wave one into brief-ready sections.
- Proposal updated (765 lines; v1 kept in evidence/website-importer/planner/). Final plan: 11 jobs in 4 waves (M1: J0 compare, J1 capture, J2 per-tier layout, J3 ranges + stretchy sizes, J4 panel, J5 embeds/maps/floating extras; M2: J6 hover, J7 motion, J8 sliders/accordions, J9 forms, J10 flip/hotspots/pop-ups). Waves: 1 = J0 ∥ J1; 2 = J2 ∥ J4 ∥ J5; 3 = J3 ∥ J6 ∥ J8; 4 = J7 ∥ J9 ∥ J10. Planner rulings not yet confirmed: R1 a WordPress plugin's floating widget is listed "install <name>", not rebuilt; R2 the list of invisible website rules that stay, every visible plugin addition off; R3 each pop-up is its own paste. 28 proposed ACs (5 live). Justin to supply by wave 4: a Bricks Interaction sample (Enter viewport → Start animation, run once) and a "Show pop-up" on click. No skill_lessons.
- Wave one started, Full pipeline taken under the away grant (new subsystem): planners for `web-compare` (J0) and `web-capture` (J1), each in its own agent worktree; briefs in briefs/web-*-planner.md.
- web-compare (J0) plan back: `docs/plans/2026-10-29-web-compare.md` on branch worktree-agent-a45d032c643c19f8b @ 6ace671. `npm run compare -- <left> <right>` + `compare()` API (live URL / .html / bricks.json drawn in live Bricks' CSS order); pairs content by aligned words and picture fingerprints, reports section heights, boxes, arrangement, shown/hidden words, pictures, sideways scroll, fonts, overlays, embeds, plus a timing table; noise file from a self-compare. Nothing in src/; tooling only, so no BUILD bump and no paste check (ruling R6). 8 questions, ⭐ A taken under the away grant (tolerances as proposed; mouse at every width; freeze sliders on their first slide; renderer order opt-in; classes after elements; timing at 1440; pictures by pixel fingerprint; a pushed-down box reported once). 11 ACs, none live. Base on dea6296: check 2566 unit (2506 pass, 60 skip); browser 405 (392 pass, 12 font fails, 1 skip). Approved copy installed; builder dispatched. J1 planner told the shared test:web line and Page.cdp name. Lessons saved: live Bricks prints class CSS last as `.cls.brxe-<el>` (SKILL.md Hand-built paste CSS); `git archive | tar` refused in worktree sessions (testing-pitfalls).
