# CLICKUP POST — 86bccndx6 custom company domain (after merge)

Role: finisher for the ClickUp post. Justin said "post clickup" on 2026-11-08 (`<evidence>/finisher/justin-publish.json`); the `leorna` rule holds the post until the PR is merged, and it now is: PR #115 merged by Justin-Leorna at 2026-11-09T00:56:08Z, merge commit `dadba89ec84aab28c386b3b9ede112471f1f605b`. Justin, 2026-11-08: "usually from before after I merge we post directly on clickup", so post right after the merge without waiting for main's push CI (run 42542855351, still running). Post the evidence comment and attachments on card 86bccndx6 now. **Don't** change the card's status or tick checkboxes (Justin does that), don't push, don't open PRs, don't touch Scaleway. No nested agents.

## Load these skills first
`leorna` (step 7.9 and the ClickUp sections), and read the shared note `/home/justin/.claude/projects/-Users-justin-Leorna-leorna-client/memory/clickup-evidence.md` in full (format, privacy check, upload path). `engineering-best-practices`.

## Inputs
- Draft: `~/.hermes/plans/leorna/evidence/86bccndx6/pr/clickup-evidence-draft-pr115.md` (placeholders for merge date, merge SHA and main's push CI). Fill them: merged 2026-11-09 00:56 UTC (2026-11-08 19:56 EST), merge SHA `dadba89`, and the PR's CI (green on e6ea3d7, run 42540909981). Don't mention main's push CI; drop that placeholder. The comment opens "✅ Merged and done" per the note. AC4 must say: owed (live check; needs a test domain), with the local rehearsal as supporting evidence only.
- Attachments: only the real PNGs the draft lists (the verifier's converted images and `pr/gates-e6ea3d7.png`). **Leave the rehearsal screenshot off** (it shows `/dev/login` and a tenant UUID), and never upload the AC tests' own JPEG-as-`.png` captures or any `.log`/`.txt`.
- Privacy check before upload (the note's step 2): view every image; no server domain, URL bar, tenant ID, token, email or `/dev/login` visible.

## Do
1. Confirm with ClickUp `clickup_get_user` / workspace members that the connected account is Justin's Leorna one, and that card 86bccndx6 has no earlier evidence comment from this story (don't post twice).
2. Upload the attachments by the note's proven upload path, then post the comment (`clickup_create_task_comment`), linking PR #115.
3. Re-read the card to confirm the comment and attachments are there.
4. Update the dated 86bccndx6 status line in `leorna-workflow.md` (merged in #115 at dadba89; ClickUp evidence posted; AC4 owed). This story-status line is allowed; the "never edit" rule below covers skill lessons only.

## Report
- The comment's text as posted, its link or id, each attachment's name and upload result, and the notes line.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none` or a one-line check proposal. Never edit skills or lessons yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
