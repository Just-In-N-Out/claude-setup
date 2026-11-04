# cta-names: CLAUDE.md lines for the finisher

Status line (build at the merge):

  - **<BUILD> cta-names:** every call to action that is its own control has an accessible name: a linked one in
    `link.ariaLabel`, an unlinked one as an `aria-label` custom attribute, none inside a link; vague words ("Learn
    more") add their card's title. Paste check **<id>** (AC6, live).

Under "Decisions the user made" → "Call-to-action buttons", one bullet:

    - **An accessible name on every CTA** (the designer, through Justin, 2026-11-04; ⭐ Q1A/Q2A not yet confirmed;
      HANDOFF "CTA names"): its visible words (a trailing arrow dropped), "<words> about <card title>" when they name
      nothing; in `link.ariaLabel` when linked, an `aria-label` custom attribute when not, none inside a link
      (`understand/cta-names.ts`, `emit/cta-names.ts`).
