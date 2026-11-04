# icon-buttons: CLAUDE.md lines for the finisher (queued by the builder; the copy's CLAUDE.md is never edited)

- **Status:** one line for the build, e.g. `<BUILD> icon-buttons: a pill of words and drawn icons is Bricks' own Button
  drawing its icons in CSS; a button-shaped box inside a link is a Button with no link; a label wholly linked makes a
  linked Button. Paste check **<id>** (AC8, live: hydraulics' hero).`
- **Decisions, "Native Buttons by shape alone"** — append: `A pill of words and one or two drawn SVG icons (one each side
  at most, beside the words, in its middle) is a Button too, its icons its ::before/::after from their Figma SVG
  (icon-buttons Q1 A, not yet confirmed; emit/button-icons.ts); inside a link it is a Button with no link (Q2 A). A pill
  under 44px whose own hover changes its icon or more than CSS draws stays a Div.`
- **Decisions, "Links to pages"** — replace the F4 sentence ("a pill whose label carries one is a Div with a linked
  text, not a Button (review F4, not yet confirmed by the user)") with: `a pill whose words are wholly the designer's
  link is a Button carrying it (icon-buttons Q3 A, not yet confirmed).`
