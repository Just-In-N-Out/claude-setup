# forms-wpforms: lines for the repo's CLAUDE.md (for the finisher; the builder doesn't edit CLAUDE.md)

Written by the forms-wpforms builder, 2026-11-14, per the plan's "Docs & records (Task 25)". The history is in
`docs/HANDOFF.md` ("A WPForms form pastes as a real WPForms form…"); only these lines belong in CLAUDE.md.

## Status (one line under the latest features; `<BUILD>` = the build the merge sets)

  - **<BUILD> forms-wpforms (website importer and Figma plugin):** a scanned page's WPForms form (shown or inside a
    box a button opens) pastes as one Bricks Shortcode element "WPForms form" (`[wpforms id="N"]`, one class
    `form-wpforms`) and the importer writes `wpforms-<title>.json` beside the pastes (the form's fields with the
    site's own ids, send text, a notification to `{admin_email}`, reCAPTCHA where it had one, its look as WPForms'
    theme, the rest on the class); Justin imports it (WPForms → Tools → Import); `site:upload`/`site:import` read the
    site's WPForms form list (GET only) for the number and write `forms.json` (`npm run site … --forms` remakes
    offline); the Figma panel's "Forms become: Bricks form / WPForms" (starts on Bricks form, byte for byte as before)
    makes the same element and file from a drawn form, with "Save WPForms file" and "WPForms form number"; pastes
    without a WPForms form byte for byte as before. Q1–Q10 ⭐ A and the builder's rulings not yet confirmed. Paste
    checks **3ek** (AC17, live: `site:import` a bdryswi.com page with the contact form against B-Dry staging, import
    the file when asked, paste, compare on desktop and phone, send a test message) and **3el** (AC18, live: in Figma
    "Forms become: WPForms", save and import the file on darksalmon, paste, compare at the design width, send a test
    message).

## Standing rules ("Working in this repo")

- **A WPForms form is shown by Bricks' Shortcode element** (Bricks has no WPForms element; `reference/bricks/README.md`
  "There is no WPForms element"): both tools write it through `src/core/emit/shortcode-shape.ts` and the import file
  through `src/core/wpforms/file.ts`, one code for both.
- **No tool writes a form to WordPress:** the tools write an import file Justin imports himself; the only WPForms
  request any tool or the panel sends is the read of its form list (`GET wpforms/v1/forms`), tested only against
  `test/fixtures/wp-standin.ts`.
- In "One uploader writes to WordPress", after "never touches pages, posts or settings": "; besides the media
  routes it reads only the site's WPForms form list (GET `wpforms/v1/forms`) to put a form's number in the paste".

## Decisions the user made

- **Forms on a scanned site that are WPForms forms** (Justin, 2026-11-13, "wpform"; job forms-wpforms, ⭐ answers not
  yet confirmed): a WPForms form pastes as a WPForms form (Shortcode element plus an import file he imports), its look
  WPForms' theme plus one class, messages to the new site's admin address, nothing of the old site's sending copied;
  a field type the job can't write is left out and named; reCAPTCHA on in the file, shown once his own keys are in.
- **"Forms become: Bricks form / WPForms" in the Figma panel** (forms-wpforms Q5 A, not yet confirmed): starts on
  Bricks form (every conversion byte for byte as before); on WPForms a drawn form is the importer's Shortcode element
  and file.

## Waiting on the user

- Replace the "WPForms:" line with: **WPForms:** decided for both tools (forms-wpforms): a scanned site's WPForms form
  and, with "Forms become: WPForms", a drawn form paste as a WPForms form. Still wanted (neither blocks): his own copy
  of the Shortcode element that shows form 559 on darksalmon (replaces `reference/bricks/shortcode-researched.json`)
  and his export of form 559 (WPForms → Tools → Export) to pin the file's shape.
