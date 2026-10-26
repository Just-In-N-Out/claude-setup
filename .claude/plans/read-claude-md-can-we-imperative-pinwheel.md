# Call and email links (build 2026-10-19.7)

## Context

The user's Services page has "Call" buttons ("Emergency Call 24/7", "Call Today", "Call Us Now" ×2), a button that
shows the number itself, and phone numbers drawn as plain text in the header and footer. None has a link in Figma, so
in Bricks nothing dials. The user wants a general rule: the plugin finds the page's phone number and makes every call
button, and every number shown, a tap-to-call link. Their hand-built page (`ExampleBricks`) already links its number
button the same way: `link: {type: "external", url: "tel:8004573160"}`.

**The user's answers (2026-10-19, AskUserQuestion):**
- **Every number shown becomes a link:** header, footer, and inside a sentence. Only the number itself is linked, and
  it looks as drawn.
- **Which number a call button dials:**
  1. a number in its own card or row;
  2. else the number whose caption shares a word with the button;
  3. else the page's main number (shown most often; a tie goes to the one higher on the page).
- **No number on the page:** the button stays unlinked, and the panel's notes name it.
- **Emails work the same way:** "Email us" buttons, and every address shown, become `mailto:` links.

## How it works today (reused, not rebuilt)

- **Designer links:**
  - `normalise/links.ts` turns Figma's Open link / Navigate into `SceneNode.link`.
  - `safeUrl` already lets `tel:` and `mailto:` through.
- **Into the IR:** `understand/node.ts:54` sets `ir.link = linked ? null : n.link`. Links never nest (the `linked` flag).
- **Emit:**
  - `emit/elements.ts:73` writes `settings.link = {type: "external", url}`.
  - A Div or Block gets `tag: "a"`.
  - A Bricks Button keeps its own link.
- **Inline links:** `Run.link`, from Figma text hyperlinks, is drawn as `<a href>` in the text's HTML
  (`style/typography.ts:79`), and dropped inside a linked layer.
- **Phone copies:** the hero's "Phone buttons" copies carry the link (`understand/phone.ts:158-166`, `copyIR`).
- **Linked boxes:** they already get `color: inherit; text-decoration: none` (`style/style.ts:146`), and small ones get
  `tap-area`.

## Design

### 1. Finding numbers and addresses: new `src/core/normalise/contacts.ts` (pure)

`contactsIn(text)` returns each match with its `{start, end, kind: "tel"|"mail", href}`.

**Phone formats:**
- The North American format, with an optional leading 1 or +1: `(800) 457-3160`, `800-457-3160`, `800.457.3160`.
- A number written with `+`, 8 to 15 digits.
- A national number starting with 0, 9 to 12 digits in spaced groups (`020 7946 0958`).

**What never matches:**
- a number joined to letters or other digits;
- dates, times, serial numbers like `250-5862` and `109-6778 / 521-8442`, ZIP codes, prices, `24/7`;
- placeholders: a 555 area or exchange code, all one digit, `1234567890`.

**The links:**
- A phone link keeps the digits (and a leading `+`) as written: `tel:8004573160`, `tel:+18124731900`. This matches
  ExampleBricks.
- An email link is `mailto:` plus the address. Placeholder domains are skipped (`example.*`, `domain.com`,
  `yourdomain.*`, `email.com`).

### 2. Which layers get a link: a pass at the end of `normalise()`

The pass is `linkContacts(pages, warn)`. It runs **after** `lineRatios` (that measurement reads `runs.length === 1`).
It walks only the page trees, never the hover look trees.

**(a) Contact buttons get a new field, `SceneNode.contact: string | null`** (`tel:` or `mailto:`). It is kept apart
from `link` so that the checks that mean "the designer linked this" are unchanged:
- an FAQ list holding a Call button stays an accordion (`accordion.ts:14`);
- the drawn-link tests elsewhere still see only the designer's links.

**Which layers count as a contact button:** a label box (`labelBox`: at most 120px tall; its layers in the flow are
short one-line texts and icons) that has no designer link on it, above it or inside it, and either:
- **its words hold a number or address:** it dials its own (the number button, the header's icon and number). Its
  icon is part of the link; or
- **its words invite a call or an email,** and it looks like a button: painted or outlined with its words centred (as
  `buttonLabel` and `pillBox`), or an unpainted icon beside the words.
  - Call words: the word "call", but not "book / schedule / request / arrange / join … a call", nor "callback".
  - Email words: "email us", "email Derek", "send us an email" and the like. A field label ("Email", "Email*",
    "Email address", "Your email") never counts.
  - The word lists are English, in one constant.

**Which contact a button gets:**
1. **Its own.**
2. **Closest:** climb from its parent, stopping below the page frame. The first box that shows contacts of its kind
   decides. If that box shows one, it is used. If it shows several, the one whose caption matches wins; otherwise the
   one shown most on the page.
3. **By name:** across the page, the contact whose caption shares the most meaningful words with the button's words.
   A caption is the other words beside the contact, up to the first box holding other words. Words like
   call/us/now/today/our/the/email are ignored. Only a single best match wins.
4. **The main one:** shown most often, then highest on the page (first design first).

**None anywhere:** no link, and a warning: `"Call Today": a call button, but the page shows no phone number to call;
link it in Bricks` (and the email equivalent).

**(b) Numbers and addresses in texts** become inline links. A text that is not inside a linked or contact layer has its
run split around each match, and the match's run gets `link: href`. A text that is only a number links its single run.
- Runs that already have a link are left alone.
- The split keeps each piece's style, so these are unaffected: `base`, `runLooks` (it dedupes looks),
  `keptSpaces`/`typedLines` (they read the joined text) and the hover-look comparison.
- Inline links leave the element tree alone, so accordions, headings, lists and arrows see no change.

### 3. Into the IR and emit

- `understand/node.ts:54`: `ir.link = linked ? null : (n.link ?? n.contact)`. From there everything already works:
  - no nested links;
  - phone copies;
  - Div `tag: "a"`, Button link;
  - linked-box CSS and `tap-area`.
- `style/typography.ts:79`: an inline link draws as Figma draws it. That is
  `<a href="…" style="color:inherit;text-decoration:inherit">`, so a site theme's link colour or underline can't
  restyle it. This applies to Figma's own text hyperlinks too, a ruling to report.

### 4. Small moves and fields

- **`labelBox`** moves from `understand/widgets.ts` to `normalise/text.ts`, beside `LABEL_MAX` and `oneLine`. It is
  re-exported from widgets, so `adapt/layout.ts`, `heading-rules.ts` and `sizing.ts` keep their imports.
- **"Painted or outlined, words centred":** the test `buttonLabel`, `pillBox` and `form.ts` repeat becomes one helper
  they share.
- **`contact: null`** is added wherever a `SceneNode` is built: `normalise.ts` (build) and `cut-node.ts:15`.

## Files

- **New:**
  - `src/core/normalise/contacts.ts` (detection, choosing a contact, the pass);
  - `test/unit/normalise-contacts.test.ts`.
- **Changed:**
  - `normalise/scene.ts` (the `contact` field);
  - `normalise/normalise.ts` (calls the pass after `lineRatios`);
  - `normalise/cut-node.ts`;
  - `normalise/text.ts` (`labelBox` and the painted/centred helper);
  - `understand/widgets.ts`;
  - `understand/node.ts`;
  - `style/typography.ts`;
  - `src/shared/build.ts` (`2026-10-19.7`).
- **Tests touched:**
  - `test/unit/style.test.ts:107` (the inline `<a>` now carries its style);
  - goldens if they change: `test/golden/files/convert-sample.json`, `render-basic.html`. Check each difference is
    only the new links before updating.
- **Docs:**
  - `docs/HANDOFF.md`: a new "Call and email links" section and paste check;
  - `CLAUDE.md`: a "Where things stand" entry, plus the user's decision under "Decisions the user made";
  - memory if needed.

## Process (CLAUDE.md "How each milestone runs"; the user said build straight through)

1. **Back up the repo:** `rsync -a --exclude node_modules --exclude corpus/out` to the scratchpad.
2. **Write the plan:** `docs/plans/2026-10-19-call-links.md` (writing-plans skill), with its ledger in
   `.superpowers/sdd/2026-10-19-call-links/progress.md`.
3. **Run `npm run corpus` before Task 1.**
4. **Tasks, test first:**
   1. detection;
   2. the label-box move and the shared helper;
   3. contact buttons and choosing the contact;
   4. inline links;
   5. IR, emit and the inline link's look;
   6. warnings.
5. **Run `npm run corpus` again**, then one fresh review on opus and one fix pass, each fix test first.
6. **Move the ledger** to `docs/plans/`, bump the build, and update the docs.

## Tests (generic fixtures from `test/fixtures/builders.ts`, never the user's file)

- **Detection:**
  - every phone and email format above matches;
  - dates, times, serials, ZIP codes, prices, `24/7` and placeholders don't.
- **Buttons:**
  - A painted "Call Today" pill with an icon, with a number elsewhere on the page, becomes a linked Div `tag: "a"`
    with `tel:`.
  - A one-label "Call Us Now" becomes a Bricks Button with the link.
- **Number and icon:**
  - A number button with an icon dials its own number.
  - An unpainted icon beside a number becomes a linked box.
- **Left alone:**
  - "Book a call" and "Schedule a call" get no link.
  - A designer's Open link on a "Call" button is kept.
- **Choosing:**
  - Two cards, each with its own number and a Call button, dial their own numbers.
  - "Call Sales" with captioned numbers "Sales" and "Service" dials Sales.
  - The main number: the most shown wins; in a tie, the higher one.
- **No number:** no link, and the warning names the button's words.
- **Inline:** a number inside a sentence becomes an `<a href="tel:…" style="color:inherit;text-decoration:inherit">`
  around the number only.
- **Emails:**
  - An "Email us" button gets the page's address.
  - An address in a text gets an inline `mailto:`.
  - An "Email*" field label in an outlined field gets nothing, and the form is still recognised.
- **Nothing else changes:**
  - An FAQ list with a Call button in an answer is still an accordion.
  - The hero's phone-copy call buttons carry the `tel:` link.
  - A hover component call button keeps CSS hover (no states).
  - A form's "(555) 123-4567" placeholder isn't linked.
- **Existing:**
  - `plugin-convert` stays byte-identical to replay.
  - The same snapshot gives the same payload, byte for byte.
- **Prove the tests catch the bug:** undo the pass in a scratch copy and watch them fail.

## Verification

1. **Run `npm run check`** (typecheck, build, unit tests) and `npm run test:browser`.
2. **Run `npm run corpus`:** no width worse.
   - Expected: page-1, hydraulics, design and final-design gain links. That includes final-design's
     "call +1 (812) 473-1900", where only the number is linked.
3. **Replay the user's file** (`figma-to-bricks-debug-page-1.json`) and check the links:
   - "Emergency Call 24/7" (and its Phone buttons copy), "Call Today" and both "Call Us Now" use `tel:8004573160`.
   - The CTA's number button and the header's icon and number are linked boxes.
   - The footer's (812) 430-5113 and (800) 457-3160 are inline links.
   - "Call Derek for appointment" stays plain text (it holds no number and isn't a button).
4. **Run `npm run snap`** on that file at 390/768/1024/1440/1728: the lint is the same as before and the shots look
   unchanged.
5. **The user's paste check (added to HANDOFF):**
   - paste, save, open the page on a phone;
   - tap a Call button and a footer number: the dialler opens with (800) 457-3160;
   - the numbers keep their colour;
   - LiteSpeed → Purge All after the paste.

## Rulings to report to the user (mine, not yet confirmed)

- "Book / schedule a call" is a booking, not a phone call.
- Placeholder numbers and addresses are never linked.
- A number inside a sentence links only the number.
- An icon beside a number is part of the link.
- The designer's own Figma link always wins.
- Inline links, Figma's own included, keep the drawn colour and underline.
- The call and email words are English only.
- A plain text like "Call Derek for appointment" (no number, not a button) stays unlinked.
