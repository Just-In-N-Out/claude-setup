# Brief: BUILDER for figma-to-bricks feature "card-link-words"

Build the approved plan `~/.hermes/plans/figma-to-bricks/card-link-words.md` (Justin: A1 B1 C2 + Title only + go = **D1**: a "Learn more →" pill whose words carry a link becomes ONE link with the words and the drawn arrow plain inside, looking as drawn). Model: **Sol 6.1 xhigh** (Justin's pick; whole pipeline on Sol). Don't re-plan.

In short (see plan): new normalise step `normalise/label-links.ts`, run just before linkContacts: when every word of a painted/outlined pill's label carries the same link (frame or typed), move the link onto the pill (link + linkFrame) and clear it from the words. A plain pill then becomes a Bricks Button with settings.link and plain words; a Call/Email pill goes where its words link (B1); the card is never linked whole (C2); linked titles stay linked words. Check-first items in the plan: Button text has no `<a`; what a Navigate-linked arrow pill emits today (D1 must look as drawn); B7's labels list picks up the Button's words.

- Load `skill_view('figma-to-bricks')` (BUILDER: Step 2 through Step 3, skip item 6), `skill_view('test-driven-development')`, `skill_view('systematic-debugging')` on surprises. Say you loaded them.
- Worktree `.claude/worktrees/card-link-words`, branch `worktree-card-link-words`, from main **2026-10-21.15** (text-link-followups just merged: page-addresses now collects native Button labels from ir.text; contact-links splits phone ranges across runs — re-read both before Task 1, refresh the plan's line anchors).
- Forms use buttonLabel (understand/form.ts:78,83,170): a form's linked send button must stay a Bricks Form button (test).
- Generic fixtures only; no keying on Justin's words/ids. Bricks Button link keys only from `reference/bricks/*.json` samples.
- Before/after: a card with a linked "Learn more →" pill and a linked plain pill, desktop + 390; pairs to `~/.hermes/plans/figma-to-bricks/shots/card-link-words/`, paths in `shots[]`; text proof of each element → href.
- In flight: hero-photo-blend (Opus; style/paint, picture, states), csv-list-pdfs (Opus; lists, ui), layout-floors (reviewing; adapt). Edit normalise.ts with one import + one call only. Whoever merges second rebases, keeps both HANDOFF sections, takes the next free paste check (3an, 3ao taken; check main).
- Plan copy, ledger, HANDOFF with the paste check owed. Docs & records: CLAUDE.md F4 "not yet confirmed" lines get replaced by Justin's ruling at merge (finisher). Leave BUILD and CLAUDE.md alone. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
- Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser`, `npm run corpus` no worse; not merged. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
- Plain words for WhatsApp.
