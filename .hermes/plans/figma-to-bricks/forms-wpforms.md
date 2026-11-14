# forms-wpforms: a scanned site's WPForms form becomes a working WPForms form (and the plugin gets the same choice)

Planner: 2026-11-13. Pipeline: Full. Base: `main` once site-no-div, site-shared-styles, importer-parity, plugin-parity
and shared-palette have merged (today `main` is `7f54b0a5`, Build 2026-11-12.3). Measured on a `git archive` of
`importer-parity-build` `48fe133c` (the newest importer head) and on Justin's 2026-11-11 scan of bdryswi.com's home
(read-only copy). Evidence: `~/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/planner/` (`<P>` below).
The builder copies this file to `docs/plans/<date>-forms-wpforms.md`.

## Playback

1. B-Dry's contact form is a WPForms form on the old site. Today the importer pastes it as drawn boxes that send
   nothing. Justin wants it to be a real WPForms form on his site that sends a visitor's message.
2. No tool writes a form into WordPress. The importer writes a WPForms import file from the scanned form; Justin
   imports it himself (WPForms → Tools → Import); the paste holds one element that shows that form, looking as on the
   old site.
3. The Figma plugin gets the same choice ("Forms become: Bricks form / WPForms"), made by the same code, so both tools
   make the same shape.

## Questions (⭐ = taken unless Justin says otherwise; "go with recommended" takes every ⭐)

1. **How the form gets onto the site.** ⭐ **A:** the tool writes `wpforms-<name>.json` beside the pastes; Justin
   imports it in WPForms → Tools → Import. Nothing writes to WPForms (WPForms has no route to create a form, and the
   standing rule is that tools only add media). B: none that keeps that rule.
2. **How the paste knows the form's number** (WPForms gives an imported form a new id). ⭐ **A:** `site:import` and
   `site:upload` read the site's form list (read-only) and match the file's title. If the form isn't there yet the
   command says "import this file now, then press Enter" and looks again; "skip" writes the paste with the number
   empty and the notes say where to type it. B: he always types the number in Bricks. C: he types it in the command.
3. **The look.** ⭐ **A:** WPForms' own theme carries what it can (label, field and button colours, sizes, corners:
   editable in WPForms → the form → Themes); only what a theme can't hold is custom CSS on one class in Bricks. B: all
   of it as custom CSS (WPForms' theme settings would then do nothing). C: WPForms' default look.
4. **A form that isn't WPForms on the old site** (a plain HTML form, Elementor's Form, Contact Form 7). ⭐ **A:** as
   importer-parity decides: a simple one is Bricks' Form, the rest stay drawn with their note. B: every form through
   WPForms (its boxes can't be drawn one to one with a site that never used WPForms).
5. **The Figma plugin.** ⭐ **A:** it gets "Forms become: Bricks form / WPForms" in this job (last milestone), and
   **Bricks form stays selected** at first, so nothing changes until he picks WPForms. B: its own job afterwards. C: in
   this job with WPForms selected at first.
6. **A field this job can't write** (file upload, date, address, payment, page breaks, show-if rules). ⭐ **A:** the
   form still becomes WPForms; that field is left out and named in the notes ("add it in WPForms' builder"). B: such a
   form stays drawn and sends nothing.
7. **Where a message goes.** ⭐ **A:** to the new site's admin address (`{admin_email}`), with WPForms' own texts,
   reply-to the visitor's email; he changes it in WPForms → Settings → Notifications. The old site's addresses can't
   be read from a page and nothing of the old site's sending is copied.
8. **reCAPTCHA.** ⭐ **A:** switched on in the file where the old form had it; WPForms shows it only once his own keys
   are in WPForms → Settings → CAPTCHA (read in its code); the old site's key is never copied. B: off.
9. **The phone picker (flags).** ⭐ **A:** kept as WPForms' "Smart" phone field; it needs WPForms Pro on the site
   (both his sites have it); its flag list is WPForms' own and isn't restyled. B: a plain phone box.
10. **Two things only Justin can give, neither blocks:** (a) his own copy of the Shortcode element that shows form 559
    on darksalmon (Bricks: copy the element, paste the text in a file) replaces the researched sample; (b) an export of
    form 559 (WPForms → Tools → Export) pins the file's shape against a real one. ⭐ The researched ones stand in.

## What was found (each read from source or measured; nothing from memory)

- **Bricks has no WPForms element.** Not in Bricks 2.2's GPL tree (no `includes/elements/wpforms.php`; GitHub 404),
  not in B-Dry staging's 2.4.2 builder script (only the icon name `fa-wpforms`; the element list holds `shortcode`).
  A WPForms form is shown by Bricks' **Shortcode** element: `name: "shortcode"`, one setting `shortcode` (the
  text), root `<div class="brxe-shortcode">`, CSS `.brxe-shortcode{width:100%}`, an empty result prints Bricks'
  placeholder "Shortcode content is empty" (`<P>/shortcode.php`, `<P>/shortcode.min.css`). Justin's team already shows
  form 559 this way (`reference/wpforms/README.md`).
- **WPForms' import** (Lite 2.0.4, `src/Admin/Tools/Import/Views/Forms/Page.php`): the file's name must end `.json`;
  the user needs `unfiltered_html` (an Administrator on a single site); the text must decode to a non-empty list of
  forms; each becomes a new post (title `settings.form_title`), **gets a new id**, and **keeps its field ids**.
- **A form's data** (`includes/templates/class-simple-contact-form.php` and the field classes): `{fields: {"<id>":
  {id, type, label, required, size, …}}, field_id, settings: {form_title, form_desc, submit_text,
  submit_text_processing, antispam_v3, ajax_submit, notification_enable, notifications, confirmations, recaptcha,
  themes}, meta}`.
- **The form list:** `GET /wp-json/wpforms/v1/forms/` (`src/Integrations/Gutenberg/RestApi.php:85-93`,
  `FormSelector.php:590-640`): `[{ID, post_title, …}]`, newest first, titles cut at 47 characters with "…" added at
  exactly 47; allowed to a user with WPForms' capability, else 401 `rest_forbidden` "This route is private.".
- **A shortcode form prints its own theme:** `src/Frontend/CSSVars.php:372-400` prints `#wpforms-<id>{--wpforms-…}`
  from the form's `settings.themes` (modern markup and "Base and form theme styling" only).
- **reCAPTCHA prints only with the site's own keys** and `settings.recaptcha === "1"` (`src/Frontend/Captcha.php:242-251`).
- **Justin's scan holds the form** (WPForms Pro, form 1756, modern markup) only inside the home page's pop-up
  (`web.code.opens[4]`): a first/last name, email, a Smart phone field, four required drop-downs, a message box,
  reCAPTCHA v3, "Submit", plus three spam-trap fields WPForms adds itself. `web.forms` is empty. `/contact-us/` has
  not been scanned.
- **The look probe** (`<P>/scripts/look-probe-typed.mjs`, numbers in `<P>/look-probe-typed.json`; Chrome for Testing,
  560 px wide, the widest range): of 3,009 declared values on the form's 54 elements, 2,820 (94%) are what WPForms
  Lite 2.0.4's own CSS gives with four theme values (label and sub-label white, field text #111111, button #FFA332).
  Drawn with only WPForms' CSS and that theme, every part is within 2 px of the scan's own looks except the phone
  field (24 px taller: the picker's CSS ships only with WPForms Pro) and what sits under it (moved by those 24 px);
  the send button's height matches (41 px). Bricks 2.4.2's CSS with the site reset changes nothing.
- **Not proven here, said plainly:** WPForms' real import and render were not run (no PHP, Docker gone after the
  session restart); the probe's reference page draws the scan's looks inline and has two known flaws (it wipes the
  boxes' borders and narrows the send button), so its 2 px numbers are a guide, not a receipt; the class CSS for the
  leftovers was not brought to a clean drawing. The builder's fixture site measures for real (M3).

## The design

Names: **W-rules** below are the importer's; the shared pieces live in `src/core/wpforms/` (pure, built-ins only, so
Figma's sandbox runs them) and both tools call them.

### 1. Recognising a WPForms form (W1)

By WPForms' own markup, on any site: an element whose classes hold `wpforms-container`, holding a `form` whose classes
hold `wpforms-form`, holding at least one element with the class `wpforms-field`. Shown at some width, or inside a box
a button opens (importer-parity's rule F1 leaves forms in opened boxes alone; W1 takes them). Nothing is keyed on a
site, a form id, a label or a word. The pick runs in `prepare`, before importer-parity's `formShape`, never over
another pick; a form W1 takes never reaches `formShape`.

### 2. Reading the form (W2) — `src/core/site/wpform-read.ts`

For each `.wpforms-field` box in page order:
- type from its class `wpforms-field-<type>`; id from `data-field-id`, else from `id="wpforms-<n>-field_<id>-container"`;
- label: the words of `.wpforms-field-label` without its `.wpforms-required-label` star; `label_hide` from
  `wpforms-label-hide`; `required` from the star or a `required` box; `description` from `.wpforms-field-description`;
- `size` from `wpforms-field-(small|medium|large)` on its box; `placeholder`; `css` = the box's classes that aren't
  WPForms' own generated ones (its column classes `wpforms-one-half`, `wpforms-first` … and the site's own);
- name: `format` from its row's parts (simple, first-last, first-middle-last), their placeholders, sub-labels
  (`sublabel_hide` when none shows); email: `confirmation` when it has the second box;
- select, radio, checkbox: `choices` in order (label; the value where the scan kept one; the chosen one where kept),
  a select's first empty choice as its `placeholder`, `style` classic or modern, `multiple`;
- phone: `format` `smart` (class `wpforms-smart-phone-field`), `us` (its mask), else `international`;
- supported types: text, textarea, select, radio, checkbox, number, name, email, phone, url. Any other type is left
  out and named (Q6). Never read as fields: WPForms' spam-trap fields (a hidden-from-everyone box with
  `aria-hidden="true"` and `tabindex="-1"`), its honeypot, hidden inputs, tokens, the phone picker's script-made
  wrappers and country list.
- form: `submit_text` from the send button's words; `ajax_submit` from `wpforms-ajax-form`; `recaptcha` from a
  `.wpforms-recaptcha-container`; title and description shown (`.wpforms-title`, `.wpforms-description`).

A form on the old site's **classic** markup (no `wpforms-render-modern`) is read the same way; its look is copied part
by part where the part exists in both markups and the notes say "the old site uses WPForms' classic markup: compare
the form after pasting" (not measured in this job; Deferred).

No capture format change: Justin's 2026-11-11 scan converts as it is.

### 3. The import file (W3) — `src/core/wpforms/file.ts`, `fields.ts`

`wpformsFile(forms)` returns the JSON text of a list of forms (WPForms' own keys only; key order fixed, so the same
scan gives the same bytes):
- `fields`: keyed by the **site's own field ids** (WPForms keeps them on import, so `data-field-id` stays the same and
  a rule for one field still finds it); `field_id`: the highest id + 1;
- `settings`: `form_title` (below), `form_desc: ""`, `submit_text`, `submit_text_processing` and `antispam_v3` as
  WPForms' Simple Contact Form template writes them (`class-simple-contact-form.php:55-80`), `ajax_submit: "1"` where
  the site's form had it, `notification_enable: "1"`, `notifications["1"]` to `{admin_email}` with reply-to
  `{field_id="<id>"}` when the form has exactly one email field and message `{all_fields}`, `confirmations["1"]` the
  template's message, `recaptcha: "1"` where the site's form had one (Q8), `themes` (section 5);
- nothing of the old site's sending: no address, no form action, no token, no post id, no reCAPTCHA key.
- **Title** (it is how the form is found again, and what he sees in WPForms → All Forms): the form's own shown title
  when the old page shows one, else `<host> form <the site's form id>` (`bdryswi.com form 1756`), always at most 46
  characters (the form list cuts at 47). **Key** (for `forms.json` and the notes): `<host>#<the site's form id>`.
- File name: `wpforms-<title as a file name>.json` in the paste folder.

### 4. The paste's element (W4, W5) — `src/core/emit/shortcode-shape.ts`, `src/core/site/wpform.ts`

- One Bricks **Shortcode** element in place of the site's `div.wpforms-container` (which leaves the paste with
  everything inside it): `{ name: "shortcode", label: "WPForms form", settings: { shortcode: '[wpforms id="<N>"]',
  _cssGlobalClasses: [<the form's class>] } }`. `title="true"` / `description="true"` are added where the old page
  shows them. Keys only from `shortcode.php` (`reference/bricks/shortcode-researched.json`, made from it, until
  Justin's own copy replaces it).
- `<N>` comes from a forms map (`ConvertOptions.forms = { site, ids: { "<key>": N } }`, like `media`). No map or no
  entry: `[wpforms id=""]`, and the notes open with the numbered steps (import the file; WPForms → All Forms shows the
  form's shortcode; in Bricks click "WPForms form" and type the number between the quotes).
- It sits where the site's box sat: in its Block, or inside the Offcanvas of the box a button opens.
- The conversion's result gains `forms: Array<{ key, title, data }>`; the notes line `Natives:` gains
  `<k> WPForms form(s)`; today's "a form shows as drawn and sends nothing" is no longer printed for that form.
- A switch `natives.wpforms` (on by default, importer-parity's `natives` set) lets the unchanged-bytes tests compare.

### 5. The look (W6–W8) — `src/core/wpforms/theme.ts`, `defaults.ts`, `src/core/site/wpform-look.ts`

The pasted form is drawn by WPForms on the new site (its markup, its CSS, his version). The paste and the file only
carry **what the old site changed**:

- **W6, the theme.** For each of WPForms' theme settings (label colour and size, sub-label colour, error colour, field
  text, background, border colour, size, style and corners, field size, button background, text, border, corners and
  size: the keys of `CSSVars.php`'s shortcode route), a short fixed map says which part and property it draws
  (`.wpforms-field-label` `color` → `labelColor`, …; each line cites WPForms' CSS rule). A key is written into
  `settings.themes` only when **every** element of that part holds the same value at every width, the value fits the
  key (a colour, a px number, or one of WPForms' three named sizes when all of that size's values match) and it
  differs from WPForms' default. So a Bricks pro changes the form's colours in WPForms → the form → Themes.
- **W7, the leftovers.** `defaults.ts` is a table of WPForms' own declared look per part (label, sub-label,
  description, each box kind, row, field box, field container, send button and its box, error text), per state (rest,
  hover, focus) and per WPForms' own width bounds, generated by `tools/wpforms-defaults.ts` from the committed copy of
  WPForms' GPL front-end CSS by scanning a reference form with the importer's own capture (so its values have the
  same form as any scan's). A declared value of the scanned form that the table (with the theme's values and the few
  values WPForms derives from them, ported from `CSSVars.php`) doesn't give is a leftover. Leftovers go into the
  form's **one class** as custom CSS, grouped by part, under WPForms' own class names behind the class
  (`.cls div.wpforms-container-full .wpforms-form .wpforms-field-label { … }`), a single field's difference under
  `[data-field-id="<id>"]` (never an element id: the form's id changes on import). Width ranges go out as bounded
  media runs (`blocks.ts`), never `revert`. The class's selector must out-weigh WPForms' own rule for that property;
  the browser test proves each written value wins.
- **W8, the box around it.** The class sits on `div.brxe-shortcode`; WPForms draws its own container inside it, so
  the container's own look (its margin and padding) is a leftover under `.cls > div.wpforms-container-full`, never
  repeated on the element. Inherited text (family, colour) arrives from the ancestors as today.
- A form that looks like WPForms' default gets an empty theme and no custom CSS for its parts.
- The Smart phone picker's inner parts (`.iti …`) are WPForms Pro's own and are not restyled; the phone box itself is
  a box like the others (Q9).
- The new site must run WPForms with **Modern Markup** on and **Include Form Styling: Base and form theme styling**
  (WPForms → Settings → General); the notes name both. With either off the theme doesn't print (WPForms' code).

Fallback, if the table can't be made steady (stop condition, M3): every part's whole declared look goes into the
class's custom CSS, no theme. Still exact; longer; reported.

### 6. The form's number (W9) — `tools/lib/site-upload/forms.ts`

- After the login `site:upload` and `site:import` send **one kind of WPForms request, ever: `GET wpforms/v1/forms`**,
  through the guarded fetch (the typed site only, no redirect followed). Match: a number already in `forms.json` for
  this key that is still in the list (so a renamed form is still found); else the newest form whose title is the
  file's title (two with that title: the newest, named in a note).
- Not there: the file is written first, then the lines "1. Open <site>/wp-admin → WPForms → Tools → Import. 2. Choose
  `<file>`. 3. Press Import. Then press Enter here (or type skip)". Enter reads the list again; `skip`, or a list that
  still lacks it, writes the paste with the number empty.
- The list can't be read (404: WPForms isn't active; 401: this user may not see forms): one plain line, the number
  empty, never a stop (Justin's "Only real failures").
- `--dry-run` asks no password, reads nothing, writes the file and the paste with the number empty.
- `forms.json` beside `media.json`: `{ site, forms: { "<key>": { id, title } } }`. `npm run site … --forms
  <forms.json>` remakes the same pastes offline.
- `site:import`'s numbered next steps gain the form's lines (import, the two WPForms settings, CAPTCHA keys if the old
  form had one, send a test message).

### 7. What the notes say (W10)

One line per fact, in plain words: the form is WPForms form "<title>" (number N / number not known yet, with the
steps); messages go to the site's admin address (where to change it); fields left out (which, why); the Smart phone
field needs WPForms Pro; the old form had reCAPTCHA (add your keys, or it sends without); the two WPForms settings the
look needs; classic markup on the old site.

### 8. The Figma plugin (Q5 ⭐ A) — `src/core/emit/form-wpforms.ts`, the panel

- A new choice in the panel, "Forms become: Bricks form / WPForms", starting on **Bricks form** (`Settings.forms`,
  `ConvertOptions.forms`). On "Bricks form" every conversion is byte for byte as today.
- On "WPForms" a recognised drawn form (the plugin's own form reading, `understand/form.ts`, unchanged) becomes the
  same Shortcode element through `shortcode-shape.ts` and the same file through `wpformsFile`: each field's type,
  label, placeholder, required mark and choices; two fields drawn side by side get WPForms' column classes; the send
  button's words. Title: the design's page name + " form" (46 characters at most).
- The look: the drawn colours, sizes and corners as the file's theme (W6's map), the rest (label spacing, box
  heights, the gap between fields, the button's padding and width) as custom CSS on the form's one class under
  WPForms' class names, from the plugin's typed form look (`style/form.ts`).
- The panel shows "Save WPForms file" after such a conversion; connected to a site, it reads the same form list and
  fills the number; a box "WPForms form number" overrides; neither: `[wpforms id=""]` and the note with the steps.
- Needs: nothing from Justin to build. His export of form 559 and his Shortcode element (Q10) tighten the references.

### 9. How tests stand in for WPForms (no PHP, no live site)

- `reference/wpforms/frontend-2.0.4/`: WPForms Lite 2.0.4's own `wpforms-full.min.css` (modern), GPLv2+, with its
  source address and sha256 in the README.
- `test/fixtures/wpforms/render.ts`: prints a form's front-end markup from its data as WPForms' modern front end does
  (each function cites the PHP it is written from); `theme-vars.ts`: the root values and a shortcode form's
  `#wpforms-<id>{…}` block as `CSSVars.php` computes them; `import.ts`: WPForms' import steps (`Page.php`); 
  `field-keys.json`: the keys each field type's class reads, made by `tools/wpforms-field-keys.ts` from the unpacked
  source (version and sha256 inside).
- `test/fixtures/wpforms/real-form.json`: the real WPForms Pro render in Justin's scan (the form's own elements; the
  country list cut to three). The stand-in must print it again from the file read from it (the fourth criterion):
  that pins the reader and the stand-in to a real WPForms answer.
- `test/fixtures/wp-standin.ts` gains the form-list route answering as `FormSelector::get_form_list` does, and a
  test-only `importFile(text)` (it stands for Justin's own import; it is not a route).
- The test renderer prints a `shortcode` element as `shortcode.php` does, its content from the stand-in.
- Fixture sites: `wpforms-form` (the form inline on a page, restyled as an Elementor form widget restyles it: label
  colour, size and spacing, field text, button colour and corners, a smaller label on phones, a focus look; every
  supported field type) and `wpforms-popup` (the same form inside a box a button opens), served from the stand-in's
  markup and WPForms' own CSS.
- Optional, only if the builder's machine has Docker or PHP: record one real import and render in a throwaway local
  WordPress (127.0.0.1) under `reference/wpforms/recorded-2.0.4/` and compare the stand-ins with it; if not, the
  ledger says so and the live check is the first real import.

## The standard, point by point (CLAUDE.md "built like a skilled Bricks builder made it by hand")

1. **Structure.** The form is one element, Bricks' Shortcode, the element Bricks itself has for another plugin's
   form (there is no WPForms element; Justin's team builds it this way). No Div, no wrapper, no Code element, none of
   the form's fifty-odd drawn boxes. It is labelled "WPForms form" and sits in the Block (or Offcanvas) the site's
   form sat in.
2. **Classes.** One purpose-named class on the element (`<page>__form` today; `bd-form` once short-class-names
   merges, through its naming function). The same form on two pages (B-Dry's pop-up and its contact page) is the same
   key, so look-grouping gives both the one class. No class per field; nothing writes a property twice: a value is
   either the form's theme or one rule of the class.
3. **Settings before custom CSS.** The form's fields, labels, required marks, choices, send text, notification and
   confirmation are WPForms' own settings; its colours, sizes and corners are WPForms' theme; custom CSS holds only
   what neither has, grouped by part, on the class.
4. **Bricks' own behaviour.** Sending, checking, the spam trap, reCAPTCHA and the phone picker are WPForms' own; a
   pop-up form sits in Bricks' Offcanvas. No script is pasted.
5. **Editable content.** Every word of the form is in WPForms' builder; the form's number is in the Shortcode field.
6. **Looks stay true.** The form is measured within 2 px of the site at every captured width (fixture sites, Bricks
   2.4.2 and 2.3.9); where WPForms' theme can't give the exact value the class's CSS does, and the notes say what
   isn't copied (the picker's inner parts, a left-out field).

## Acceptance criteria (all proposed)

- AC1 (proposed): Given a scanned page holding a WPForms form (a hand-made capture fixture and the real render), the conversion's `forms` holds one form per WPForms form whose fields are in page order with the site's own field ids, each with its type, label, required mark, size, placeholder, description, hidden label, column classes, name format and sub-labels, phone format and choices in order, and holds no spam-trap field, honeypot, hidden input, token or picker wrapper. Test `test/unit/wpforms-read.test.ts` "a scanned WPForms form reads as its fields in page order with the site's field ids".
- AC2 (proposed): Given those forms, `wpformsFile` returns a JSON list whose every form has `fields` keyed by id, `field_id` one above the highest, a title of at most 46 characters, the send text, a notification to `{admin_email}` (reply-to the one email field), WPForms' confirmation, `recaptcha: "1"` only where the site's form had one, and no key outside WPForms' key list for its field type; the same scan gives the same bytes; no address, action, token, post id or reCAPTCHA key of the old site is in it. Test `test/unit/wpforms-file.test.ts` "the import file holds only WPForms' own keys and nothing of the old site's sending".
- AC3 (proposed): Given the file, WPForms' import steps (ported from `Page.php`) make one form per item with a new id, its title, and every field id kept, and refuse a file that isn't `.json`, isn't JSON, or is empty, as WPForms does. Test `test/unit/wpforms-import.test.ts` "WPForms' import steps accept the file and keep every field id".
- AC4 (proposed): Given the real WPForms render in `test/fixtures/wpforms/real-form.json`, the file read from it, printed by the stand-in, gives that render's elements again (tags, WPForms' classes, names, types, required marks, labels, choices, with only the form id changed), the spam traps, tokens, hidden inputs and the picker's script-made wrappers aside. Test `test/unit/wpforms-roundtrip.test.ts` "the file read from a real WPForms render prints that render again".
- AC5 (proposed): Given a page with a WPForms form (both routes, both text modes, inline and inside a box a button opens), the paste holds exactly one `shortcode` element for it, labelled, with one class, whose only own setting is `shortcode` (`[wpforms id="N"]` with a forms map, `[wpforms id=""]` without), sitting where the site's form sat (inside the Offcanvas for an opened box); none of the form's own elements, no Div and no Code element stands for it; `payloadProblems` passes; the result's `forms` and the `Natives:` line name it. Test `test/unit/site-wpform.test.ts` "a WPForms form pastes as one labelled Shortcode element pointing at the form".
- AC6 (proposed): Given a WPForms form with WPForms' default look, the file's theme is empty and the class holds no custom CSS for the form's parts; given a restyled one, each theme key is set only where every element of its part agrees at every width, the class's custom CSS holds only values the table and the theme don't give, written under WPForms' class names behind the class (one field's own under `[data-field-id]`), with no `revert`, no element id, no `display` on the element itself, and no part's property both in the theme and in the class. Test `test/unit/site-wpform-look.test.ts` "a default form needs no custom CSS and a restyled one keeps only what the theme can't hold".
- AC7 (proposed): Given the fixture site `wpforms-form`, its paste drawn with the stand-in (the imported file, WPForms 2.0.4's CSS, Bricks 2.4.2 and 2.3.9) has every field box, label, sub-label, input, drop-down, text area and the send button within 2 px of the site in place and size at every captured width, paired by field id, and a focused box holds the site's focus look. Test `test/web/site-wpform.test.ts` "the pasted form draws within 2 px of the site's at every captured width".
- AC8 (proposed): Given the fixture site `wpforms-popup`, the paste's opener opens an Offcanvas that holds the Shortcode element, and with the box open in Chrome on the site and on the drawn paste every part of the form is within 2 px of the site's, measured from the form's own corner. Test `test/web/site-wpform-open.test.ts` "a form inside a pop-up pastes inside its Offcanvas and draws as on the site".
- AC9 (proposed): Given the WordPress stand-in with WPForms' form list, `site:upload` and `site:import` put the listed form's number in the paste and in `forms.json` (by the recorded number first, else the newest form with the file's title, two named); a form not there yet is asked for once and found after Enter, or left empty after `skip`; a list that answers 404 or 401 gives one plain line and no stop; `--dry-run` asks and reads nothing; and the stand-in saw no request to a `wpforms` route but GET. Test `test/unit/site-upload-forms.test.ts` "the form's number is read from the site's form list and nothing is ever written to WPForms".
- AC10 (proposed): Given the `forms.json` an upload wrote, `npm run site … --forms <forms.json>` writes pastes byte for byte the upload's, and without `--forms` the same pastes with the number empty and the steps in the notes. Test `test/unit/site-forms-flag.test.ts` "a paste remade with --forms is byte for byte the one the upload wrote".
- AC11 (proposed): Given every code fixture and capture that holds no WPForms form (a plain HTML form and an Elementor Form among them), and every fixture with the `wpforms` switch off, the pastes, notes and written files are byte for byte the base's on both routes, both text modes, parts and sections. Test `test/unit/site-wpform-unchanged.test.ts` "pastes without a WPForms form are byte for byte the base's".
- AC12 (proposed): Given forms with a field type this job doesn't write, a Smart phone field, reCAPTCHA, the old site's classic markup, and no forms map, the notes hold one plain line for each (the field left out and why, WPForms Pro, your own keys, compare after pasting, the numbered import steps with the two WPForms settings), and the left-out field is in neither the file nor the paste. Test `test/unit/site-wpform-notes.test.ts` "every left-out field and every setting the form needs is named in the notes".
- AC13 (proposed): Given every Figma fixture and the five real files, with "Forms become" on Bricks form (the choice a new or saved setting starts on) the conversion, the replay and the panel's result are byte for byte the base's. Test `test/unit/plugin-forms-option.test.ts` "Forms become starts on Bricks form and is byte for byte the base".
- AC14 (proposed): Given a drawn form and "Forms become: WPForms", the conversion holds one `shortcode` element made by the importer's own shape function with one class, and a WPForms file made by the importer's own writer whose fields are the drawn fields in order (type, label, placeholder, required mark, choices, side-by-side fields as WPForms' columns) and which WPForms' import steps accept; plugin conversion and replay are byte-identical and the sandbox check passes. Test `test/unit/emit-form-wpforms.test.ts` "a drawn form becomes a Shortcode element and a WPForms file through the importer's own code".
- AC15 (proposed): Given the form fixtures (a contact form of one column, one with two fields side by side, one with choices) and "Forms become: WPForms", the paste drawn with the stand-in at the design width has every label, box and the send button within 2 px of the drawing, the colours, corners and type the drawing's, on Bricks 2.4.2 and 2.3.9. Test `test/browser/form-wpforms.test.ts` "a drawn form shown by WPForms draws within 2 px of the design at the design width".
- AC16 (proposed): Given the panel after such a conversion, "Save WPForms file" saves the writer's bytes under a `.json` name; connected to the stand-in site the form's number is read from its form list (GET only) and written into the copied paste; a typed "WPForms form number" wins over it; with neither the paste holds `[wpforms id=""]` and the panel shows the steps. Test `test/unit/panel-wpforms.test.ts` "the panel saves the WPForms file and fills the form's number from the connected site".
- AC17 (proposed) (live): Justin runs `npm run site:import` on a bdryswi.com page that holds the contact form against B-Dry staging, imports the written file in WPForms → Tools → Import when asked, pastes; the form looks as on bdryswi.com on desktop and phone, a test message arrives (the email and the entry in WPForms); changing the label colour in WPForms' Themes and the form class's spacing in Bricks each do what a Bricks pro expects.
- AC18 (proposed) (live): In Figma Justin sets "Forms become: WPForms", converts a design with a contact form, saves the WPForms file, imports it on darksalmon, pastes; the form looks as drawn at the design width, a test message arrives, and the same two edits do what a Bricks pro expects.

Two live checks, not one, because the two tools paste on two sites; if Justin answers Q5 with B, the criteria for the
plugin (the thirteenth to the sixteenth and the eighteenth) leave with milestone M5 by a plan amendment.

## Touched files (paths on the merged base; `+` new)

Shared core (sandbox-safe):
- `+ src/core/wpforms/types.ts`, `fields.ts`, `file.ts`, `theme.ts`, `defaults.ts` (generated), `title.ts`
- `+ src/core/emit/shortcode-shape.ts` (imports nothing; added to `test/unit/site-isolation.test.ts`'s allow-list)

Importer:
- `+ src/core/site/wpform.ts` (W1, the pick, notes), `wpform-read.ts` (W2), `wpform-look.ts` (W6–W8)
- `src/core/site/convert.ts` (`ConvertOptions.forms`, the pick before `formShape`, the result's `forms`, the
  `Natives:` line, the form note), `tree.ts` (only if `TreePick` needs a field for the absorbed parts' selectors),
  `classes.ts` (the form class's name through the naming in force), `open-paste.ts` / `opens.ts` (the pick inside an
  opened box), `parts.ts` (the result's `forms` per part)
- `tools/lib/site-write.ts` (the files, `forms.json`), `tools/site.ts` (`--forms`), `+ tools/lib/site-upload/forms.ts`,
  `tools/lib/site-upload/flow.ts`, `args.ts`, `summary.ts`, `tools/lib/site-import/next.ts`, `tools/site-upload.ts`,
  `tools/site-import.ts`
- `tools/site-check.ts`, `test/web/lib/site-check.ts` (the form stand-in and pairing by field id),
  `tools/site-live.ts` (a published Shortcode's content isn't "another element in its place")
- `+ tools/wpforms-defaults.ts`, `+ tools/wpforms-field-keys.ts`

Plugin:
- `src/ui/settings.ts`, `main.ts`, `index.html`, `+ src/ui/wpforms.ts` (the list read, the file save, the number box),
  `src/ui/run.ts`
- `src/core/convert.ts` (`ConvertOptions.forms`), `src/plugin/convert.ts`, `src/core/emit/form.ts` (the branch),
  `+ src/core/emit/form-wpforms.ts`, `tools/replay.ts` (the option), `test/fixtures/panel.ts`

Tests and references:
- `+ test/fixtures/wpforms/` (`render.ts`, `theme-vars.ts`, `import.ts`, `field-keys.json`, `real-form.json`),
  `test/fixtures/wp-standin.ts`, `+ test/fixtures/site-wpform-code.ts`, `+ test/fixtures/web/sites/wpforms-form/`,
  `wpforms-popup/`, `test/browser/render.ts` (+ `render-shortcode.ts`), the sixteen test files the criteria name
- `+ reference/wpforms/frontend-2.0.4/`, `reference/wpforms/README.md`, `+ reference/bricks/shortcode-researched.json`,
  `reference/bricks/README.md`
- Pins the job re-makes on its own tree where it changes site pastes on purpose: none expected (pastes without a
  WPForms form don't change); `site-no-revert`, `site-slider-unchanged`, `media-avif-untouched`,
  `site-import-figma-unchanged`, `site-scroll-lock-base`, `panel-embed-unchanged` are re-pinned for this job's `src/`
  files at merge prep, test-only.

## Tasks, in milestones (each task test first; commit after each passing task)

Before Task 1: `npm run check`, `npm run corpus`, and the whole unit suite on the base, into the ledger
(`.superpowers/sdd/forms-wpforms/progress.md`). Read `<project skill>/references/repeat-mistakes.md` and
`feature-dispatch/references/repeat-mistakes.md`.

**M1 — the shared pieces (a file WPForms accepts).**
- Task 1. Unpack WPForms Lite 2.0.4 from wordpress.org into its own empty folder under `~/.cache` (sha256
  `0417412b…5f7a`, checked); `tools/wpforms-field-keys.ts` → `field-keys.json`; copy the modern front-end CSS to
  `reference/wpforms/frontend-2.0.4/` with the README. No behaviour.
- Task 2 (third criterion). `test/fixtures/wpforms/import.ts` from `Page.php`, with its refusals. RED on a hand-made
  file, then GREEN.
- Task 3 (second criterion). `types.ts`, `fields.ts`, `title.ts`, `file.ts`; the key check against `field-keys.json`.
- Task 4. `shortcode-shape.ts`, `reference/bricks/shortcode-researched.json` and the README lines ("Shortcode
  element", "there is no WPForms element"); a key check against the sample as `emit-form.test.ts` does for Form.
- Task 5 (fourth criterion). `real-form.json` cut from the scan; `render.ts` from WPForms' front end; the round trip
  needs Task 6's reader, so its test goes green there. **Stop condition:** a difference between the stand-in and the
  real render is fixed in the stand-in from WPForms' source, never by loosening the comparison beyond the asides the
  criterion names; a difference that is WPForms Pro's own (code not readable here) is listed in the ledger and
  reported.
- Optional: the recorded real import (section 9), if the machine can.

**M2 — the importer makes the element and the file (usable at once with a typed number).**
- Task 6 (first criterion). `wpform-read.ts` on `site-wpform-code.ts` (`wpformCode(over?)`: the form, and one case per
  field type, per left-out type, classic markup, the spam traps) and on `real-form.json`.
- Task 7 (fifth criterion). `wpform.ts` W1 and the pick; `convert.ts`; the opened-box case. **Stop condition:** if a
  pick can't be made inside an opened box's tree without changing how opened boxes paste, stop and report with the
  code lines (the pop-up is where B-Dry's home holds the form).
- Task 8 (eleventh criterion). The unchanged-bytes test against the base's sums, the switch off included.
- Task 9 (twelfth criterion). The notes.
- Task 10 (tenth criterion, first half). `site-write.ts` writes the file(s); `tools/site.ts --forms`.

**M3 — the look.**
- Task 11. `theme-vars.ts` (from `CSSVars.php`), `render-shortcode.ts`, the renderer's `shortcode` case (unit first).
- Task 12. Fixture site `wpforms-form`; `tools/wpforms-defaults.ts` → `defaults.ts`; a web test that the committed
  table is what the tool makes.
- Task 13 (sixth criterion). `theme.ts` (the map, each line citing its CSS rule; a browser test sets one sentinel
  value per key and sees its mapped part change, so a wrong line fails), `wpform-look.ts`.
- Task 14 (seventh criterion). `site-check`'s form stand-in and pairing; the 2 px test, both Bricks versions, focus
  forced. Mutants: drop the theme, drop the leftovers, drop the weight prefix: each must fail it. **Stop condition:**
  not within 2 px with the table → the fallback of section 5 (whole looks in the class, no theme), measured and
  reported; never a wider tolerance.
- Task 15 (eighth criterion). Fixture site `wpforms-popup` and its test.

**M4 — the form's number.**
- Task 16. The stand-in's form-list route (each answer citing WPForms' source) and `importFile`.
- Task 17 (ninth criterion). `forms.ts`, the flow, the pause, `forms.json`, `--dry-run`, the next steps. The password
  rules hold: nothing new is saved, printed or sent anywhere but the typed site. Mutation: a POST to a `wpforms`
  route must fail the test.
- Task 18 (tenth criterion, second half). The offline remake is byte for byte the upload's.
- Task 19. `site:live` maps a published Shortcode's content to its element (unit test on a saved page text; no live
  site).

**M5 — the Figma plugin (Q5 ⭐ A).**
- Task 20 (thirteenth criterion). `Settings.forms`, `ConvertOptions.forms`, the panel's choice; byte for byte on
  "Bricks form".
- Task 21 (fourteenth criterion). `form-wpforms.ts`: fields, columns, the file through the shared writer.
- Task 22 (fifteenth criterion). The look from `style/form.ts` as theme and class CSS; the browser test. **Stop
  condition:** not within 2 px → report the measured boxes; no wider tolerance, no hidden second route.
- Task 23 (sixteenth criterion). The panel: Save WPForms file, the list read, the number box, the steps.

**M6 — close.**
- Task 24. `npm run check`, `npm run corpus`, `npm run test:browser` and `test:web` file by file by name against the
  base, the whole unit suite, `site-no-revert`, `site-slider-unchanged`; B-Dry's saved scan converted on both routes
  (the form's file, the paste with and without a forms map, the notes) into the evidence folder; a terminal capture
  or screenshot per criterion.
- Task 25. **Docs & records** (below). Stop at `ready-for-review`.

Rules for every task: no hardcoding from B-Dry's form (fixtures are generic; `real-form.json` is only a real
WPForms answer to compare with); CSS stays typed until emit; ids are deterministic; code under `src/core` uses only
the language's built-ins; agents never run `site:upload` or `site:import` against a live site, never load
bdryswi.com or a staging site, and test only against the stand-in and local fixture sites; a command that dies with
SIGTERM, 137 or 143 is checked against earlyoom before it is read as a result.

## Overlaps and order

Heads read on 2026-11-13: `main` 7f54b0a5; `site-no-div-final` cf4f887d (on main); `site-shared-styles-fix1`
7b7501bd; `importer-parity-build` 48fe133c (at its Task 15, video; its Form wave, Tasks 17–18, not built yet);
`plugin-parity-build` 89e41a0d; `shared-palette-build` 9070c50f and `shared-palette-fix1` fc32008b. The builder reads
them again before Task 1 and builds on `main` after all five have merged.

| Job | Shared files | What this job assumes from it |
|---|---|---|
| site-no-div | `site/convert.ts`, `tree.ts`, `kinds.ts`, the no-Div and label tests | every box is a Section, Container or Block with a label; this job's element adds "shortcode" to the labelled natives and never makes a Div |
| site-shared-styles | `site/classes.ts`, `convert.ts` (shared looks, `site-text`) | inherited text reaches the form through its ancestors' classes as today; the absorbed parts take no shared class |
| importer-parity | `site/convert.ts` (`prepare`'s order, the `natives` switch, `Natives:` line), `site/form.ts`, `emit/form-shape.ts`, `render-form.ts`, the isolation allow-list, the capture's kept attributes | rule F1 as approved (a simple form outside opened boxes is Bricks' Form); W1 runs before it. If its Form wave falls out (its own stop condition), non-WPForms forms stay drawn with today's note and the eleventh criterion compares with that base |
| plugin-parity | `emit/form.ts`, `nav.ts`, `video.ts` moved into shape modules | its final file layout; M5's branch in `emit/form.ts` is added after it |
| shared-palette | colours in settings and custom CSS, `palette.json`, `site:import`'s next steps (`next.ts`) | the class's custom CSS writes colours as that job writes them; the WPForms theme holds plain colour values (WPForms can't read Bricks' palette) |
| short-class-names (planned) | class names | the form's class is named through its naming function (`bd-form`); until it merges, `<page>__form` |
| look-grouping (planned) | which elements share a class | one key per form (`<host>#<id>`), so the same form on two pages shares one class |
| native-widgets (planned) | its counts of "form fields" kept as Code | a WPForms form's fields are no longer Code elements, so its count drops by them; it leaves forms to importer-parity and this job |
| clean-values (planned) | lengths in settings and custom CSS | the leftovers pass through its cleaning like any class CSS; theme values stay exact |

Whoever merges second rebases the `prepare` lines in `convert.ts` and the `next.ts` lines. This job needs none of the
planned four to build.

## Docs & records (Task 25)

- The plan's copy in `docs/plans/<date>-forms-wpforms.md`; the ledger moved to `docs/plans/<date>-forms-wpforms-ledger.md`
  at the finish.
- `docs/HANDOFF.md`, a new section at the top: what pastes now, the rules W1–W10 in short, the measured numbers, every
  ⭐ ruling "not yet confirmed" (Q1–Q10), "Deferred" (classic markup measured, the field types left out, the picker's
  inner look, radio and tick-box looks beyond the theme, WPForms versions other than 2.0.4, the form's title when he
  renames it on another computer), and the two paste checks with the next free ids on every local branch at the merge
  (after 3ei on `main`; 3ej and 3em are already named in other plans).
- `reference/wpforms/README.md`: the import file's shape, the form-list route, the theme route, the source version
  and sha256, what was and wasn't run for real. `reference/bricks/README.md`: "Shortcode element" and "There is no
  WPForms element".
- For the finisher, CLAUDE.md (or `forms-wpforms-claude-md-pending.md`): the Status line with the build and both paste
  checks; standing rules "**A WPForms form is shown by Bricks' Shortcode element** (Bricks has no WPForms element)",
  "**No tool writes a form to WordPress:** the tools write an import file Justin imports; the only WPForms request is
  the read of its form list", an added clause in "One uploader writes to WordPress" naming that read; Decisions: the
  importer's WPForms ruling and the plugin's "Forms become" choice (starts on Bricks form); "Waiting on the user":
  his Shortcode element copy and his export of form 559; the WPForms line there marked decided for both tools.
- `skill_lessons` in the builder's report, never an edit to a skill or memory.
