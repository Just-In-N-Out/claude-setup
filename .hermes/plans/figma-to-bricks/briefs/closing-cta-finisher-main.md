# FINISHER, after-merge release: closing-cta → section rhythm (FigmaToBricksV2)

Do exactly the after-merge steps in the main folder `/home/justin/Documents/FigmaToBricksV2` on `main`, then stop.
- **Yours:** this feature's release changes and records, and your evidence folder
  `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/finisher-main/`.
- **Don't:** rebase, merge, remove the worktree or branch, start other agents, or edit skills or memory.

## Accepted and merged
- **Accepted:** the orchestrator ran ac-check.sh on the round-2 verifier's and blind auditor's reports (base
  `b3addfb`). Last line: `READY FOR THE USER: 11 of 12 ACs proven on 9405a95; live ACs owed to the user: AC12`. Don't
  rerun or reinterpret the accepted gates.
- **Merged:** the orchestrator ran `git merge --ff-only worktree-closing-cta` in the main folder: `b3addfb` → `9405a95`.
  Main HEAD should be **`9405a95b00d6a3295524d6ca0028bb2bf9864325`**, clean, on `main`. If it isn't, or another session
  has committed since, stop and report. Don't mix releases.
- **Already done in the branch:** the ledger is at `docs/plans/2026-10-28-closing-cta-ledger.md`; the feature's HANDOFF
  section is on top; the paste check is **3bq**.
- **Plan:** approved copy `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`; in git
  `docs/plans/2026-10-28-closing-cta.md`. AC12 (live, 3bq) is owed to Justin.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `references/rules-summary.md`
   first (FINISHER role).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `github`.

## Release
1. **Check the state.** Confirm main is at `9405a95`, clean and on `main`. Other sessions are working: never stage,
   stash, reset or discard anything that isn't this feature's, and never bare `git stash`.
2. **BUILD.** Read `BUILD` in `src/shared/build.ts` right before bumping it (expected `2026-10-28.4` →
   `2026-10-28.5`; use the real current value and today's date). This is the only source change allowed after
   acceptance.
3. **HANDOFF records.** Update this feature's HANDOFF section:
   - its build line, with the new BUILD;
   - "released", with the accepted head, and the round-2 verifier and auditor clean on `9405a95` against `b3addfb`;
   - add to its follow-ups, in plain words:
     - **(g) The decorated closing on phones:** with its top now `0` (AC8), a sparkle pinned to its top sits where Figma
       draws it, and from 478px down the wrapped heading runs 15px under it. Base does the same when no free gap is
       drawn above. J2's `lands()` checks only the bottom edge.
     - **(h) Services and Repairs:** under a photo hero, the phone buttons band's own 24px adds to S on phones
       (Services 80/64 where S is 56/40). Home has no such band. Base does the same.

   Keep it compact, like the neighbouring sections, and keep every other feature's section.
4. **Build.** `npm run build` in the main folder, so Figma loads the new `dist/`. Record the true exit, and confirm
   `dist/code.js` and `dist/ui.html` were rebuilt. If any real source or test change seems needed, stop and report it:
   it would have to go back through verification.
5. **Commit.**
   - Confirm HEAD is still `9405a95` plus nothing foreign, and the identity is `Justin <issajustin04@gmail.com>`
     (repo config and log; never override it).
   - Stage only this feature's release changes, by explicit path.
   - Check `git diff --cached --name-only`: no CLAUDE.md, no debug JSON.
   - `git commit -m "Build <BUILD>: closing-cta (section rhythm)"`, with no `Co-Authored-By` or AI lines.
6. **Push `main` only**, as Just-In-N-Out.
   - Read the remote and credential setup without exposing secrets. Never switch gh accounts or change a remote or
     helper, and never push the feature branch.
   - On this WSL machine, default SSH fails before authentication (permissions on
     `/etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf`). The verified route is to first confirm the account with:

     `ssh -F /home/justin/.ssh/config -o BatchMode=yes -o ConnectTimeout=10 -o GSSAPIAuthentication=yes -o HashKnownHosts=yes -o 'SendEnv=LANG LC_* COLORTERM NO_COLOR' -T git@github.com`

     It must greet **Just-In-N-Out**; exit 1 is GitHub's normal greeting. Then push with:

     `GIT_SSH_COMMAND='ssh -F /home/justin/.ssh/config -o BatchMode=yes -o ConnectTimeout=10 -o GSSAPIAuthentication=yes -o HashKnownHosts=yes -o "SendEnv=LANG LC_* COLORTERM NO_COLOR"' git push origin main`

     If the remote is HTTPS with the repo's own credential helper, use that as configured.
   - Record the true push exit, and check that `origin/main` equals local `main` afterwards. If authentication fails,
     report it exactly, with no workaround through another account or a token.
7. **Main CLAUDE.md** (`/home/justin/Documents/FigmaToBricksV2/CLAUDE.md`, excluded from git, never committed). Re-read
   it right before editing: other sessions edit it too. Keep its compact format: Status has a build line and one line
   per feature; no build narratives.
   - **Status:**
     - the build line → the new BUILD;
     - add on top: `**<.N> closing-cta (section rhythm):** between every two sections the page's section space (the
       space most sections draw) separates their words, stepping down on tablets and phones; no divider lines between
       them; buttons always get that space under them; the space beside a left-out site header/footer stays. Paste
       check **3bq** owed (re-paste Home with the ticks on).`
     - Make sure the photo-hotspots line (28.4, 3bp) is there; add it if it's missing.
     - The "Paste checks owed" line can name 3bq with the Home re-paste.
   - **Decisions → Layout:** add one compact entry, built from the plan's Task 8 amended for J1/J2:
     - **The same space between every two sections** (Justin, 2026-10-28: "Do it for every section, like in the photo
       … including the gap between sections … every call-to-action button"). Between two sections, the space from one
       section's words to the next one's is the page's section space S (the space most of its sections draw),
       stepping down like section padding.
     - No divider line there.
     - A painted section keeps its padding inside its paint.
     - These keep their own spacing: the page's top (its bars and the hero), painted bands that touch, tight strips
       without a call to action, and sections drawn without auto layout or at a fixed height.
     - **Buttons always get S under them** (Justin: "put it in a way where it looks more aesthetic"). A bar holding a
       call to action is never a tight strip. A section with a layer placed on it still gets S under its ending
       buttons, unless the layer would land on them or leave its edge (`understand/rhythm-buttons.ts`).
     - A page with no shared space converts as drawn (`understand/rhythm.ts`).
     - The rulings are not yet confirmed (HANDOFF).
   - **Website rules:** the line "The design stays as drawn except for the two label minimums below" also names the
     section rhythm.
   - **Working in this repo:** add `**Space drawn next to a part the site already has stays** (`designs.ts`
     `keepBeside`): leaving the header or footer out never takes the gap beside it.`
   - **Known open bugs:** one compact line: "Section rhythm: a drawing pinned beside a closing's buttons or to its top
     can land on full-width phone buttons or a wrapped heading from 478 down (base too; HANDOFF follow-ups)."
   - If the write is refused, put exactly those edits in
     `~/.hermes/plans/figma-to-bricks/closing-cta-claude-md-pending.md`. Don't retry it another way.
8. **Rules summary.** Don't edit skills. Return a proposed compact update for the project skill's
   `references/rules-summary.md`. The step-1 finisher proposed:
   - "- Section rhythm (Justin 2026-10-28; ⭐Q1–Q6 A unconfirmed): S=space≥40 most auto-layout unfixed sections draw (≥2
     share, larger tie); between two sections' words exactly S, stepping as section padding; lines between them go
     (inside/touching painted bands/kept site parts stay); paint keeps inside padding; page top/hero, non-CTA tight
     strips, free-drawn/fixed keep own, rhythm side tops up; buttons always get S under them (CTA bar never tight;
     placed layer still S under ending buttons unless it lands/leaves its edge); no shared S/drawn phone→as drawn."
   - "- Space drawn beside a site header/footer left out stays (designs.ts keepBeside): padding on page-colour sections,
     margin on painted ones."

   Check them against the code, tighten them, and return the exact text.
9. **Verify and report:** BUILD, main HEAD, `origin/main` equal to `main`, a clean git state, the rebuilt `dist/`, the
   docs state and live AC12 (3bq). Leave the worktree and branch in place.

## This machine
- **Node:** `/home/justin/.local/node-v22.23.3/bin` first on PATH.
- **Scratch:** your own fresh folder; use a short TMPDIR if a tool needs one.
- **Leave alone:** a headless Chrome (PID 232915) isn't yours.

## Report (your final message)
`{status: released|stopped, build, head, origin_main, push, docs, claude_md, rulings, live_acs, limits,
proposed_rules_summary_edit, skill_lessons[{skill, lesson, evidence}]}`. An empty skill_lessons list is normal; never
edit skills or memory. End with the line `MAIN SESSION: check and save these skill_lessons now.`
