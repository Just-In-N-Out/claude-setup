# 86bcm901z: follow-ups (one consolidated, de-duplicated list)

Sources:
- `evidence/86bcm901z/follow-ups.md`: review P3s, the finisher items and the rollback note;
- the 86bcm901z lines in `~/.hermes/plans/leorna/found-else.md`;
- the plan's "Follow-ups";
- what this finisher found.

Severity uses the review scale (P3 = cosmetic, docs, a hole only a deliberate evasion reaches, or no real-use scenario). "Card" marks a feature the plan deferred, not a defect. Nothing here blocks the PR.

## For the PR's Follow-ups section

| # | Severity | Follow-up | Source |
| --- | --- | --- | --- |
| 1 | Card | Edit supporting files in a variant, with a per-file merge (Justin chose Q4 A: files follow upstream). | plan |
| 2 | Card | A JSON API for variants (list, read, customise, edit, merge, ignore, delete) in OpenAPI. Today they are console-only, like the library catalog. | plan |
| 3 | Card | "Replace with upstream" in one click, and renaming a variant. | plan |
| 4 | Card | Tell admins when an update arrives (an admin-home badge or a message). Today "Update available" shows only on the Content library and the variant page, computed when the page is read. | plan |
| 5 | Card | Show the upstream's licence and source on a variant of an imported (MIT) item. The notice already ships in `THIRD_PARTY_NOTICES.md` and on the third-party content page. | plan |
| 6 | P3 | `internal/textdiff/textdiff.go:95`: in runs of identical lines (blank lines, repeated bullets), a clean three-way merge can drop one of the company's deletions, because LCS ties break toward insertion (3 in 23,059 Markdown-like probe cases). Fix: prefer deletion before insertion on ties and add the probe's cases as tests, or document the limit. | review 2, R2-2 |
| 7 | P3 | `internal/web/library_variants.go:263`: the 2,000-shown-lines cap per diff section has no test (removing both cap checks in `newDiffSection` leaves every test green). | review 1, R1-2 |
| 8 | P3 | Item editor, pre-existing: after a secret refusal, file paths are kept so a resubmit doesn't drop files, so a token typed into a supporting file's *path* is shown back in the path box. | review 3, R3-2 = fixer 2's found-else |
| 9 | P3 | Pre-existing, both pages: refusals that come before the secret scan show the typed text back unscanned: the variant edit's stale-version 409 (`internal/variant/service.go:63-68` checks the version before the gate) and the item editor's item-rule 422s. No secret is suspected on those paths, so AC4 holds. | fixer 2's found-else |
| 10 | P3 | Pre-existing, cosmetic: `itembuilder.validate` sorts `in.Files` and sets `Script` through a by-value `Input` (`internal/itembuilder/validate.go:70-88`), writing through the caller's shared slice. `DraftIssues` therefore changes its caller's files, and an edit-mode error page reached after validation passes (e.g. name taken) lists supporting files in path order, not typed order. Nothing is lost; this story clones slices. | planner + fixer 3 found-else (same root) |
| 11 | P3 docs | `docs/superpowers/plans/2026-10-28-create-item-templates-validation.md:56` (another story's dated plan) still says a secret refusal clears "that field"; this story clears every typed field. | fixer 2's found-else |

## Already handled or tracked elsewhere (don't open new cards)

- **Bringing main in** (R1-3 → R4-1): renumber migration 25 → 27 and resolve four text conflicts. This is the pending "bring main in" step in `integration.md`, not a follow-up.
- **Rollback order** (verifier 1): run the down migration first, then roll back the deploy. The PR's Rollback notes say so.
- **Item editor secret echo** (review 2's pre-existing finding): fixed in this story (Justin: "Fold into this fix"), with the cleared file boxes made `required` (Justin: "Mark cleared file boxes required").
- **`Library.Required` docs** (planner's found-else): on GitHub `main`, #102 fixed the README paragraph. The `internal/library/library.go:86-88` comment still says the pack builder reads `Requires` (only the starter packs and the quick start call `Library.Required`); #102 already lists it as its follow-up 16.
- **A future pack diff preview story** can reuse `internal/textdiff` for text previews (a note for that story, not a card).

## Outside this story (found by the finisher; for the main session)

- GitHub `main`'s `delivery/stories.json` entry for role-based starter packs (#102) still has an empty PR list, although #102 merged at `8aa32a1`. Per the `leorna` skill, `check-story-shippable.py` passes vacuously on an empty list, so that story's delivery check proves nothing until #102 is recorded. P3, record only; that story's to fix.
