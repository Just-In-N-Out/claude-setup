# Brief: PLANNER for figma-to-bricks feature "csv-list-pdfs" (feature)

## The ask (rewritten)
Feature: when a design holds a list that the plugin fills from a CSV file the user uploads in the panel (each row an item, e.g. a parts/products/documents list), the panel should also ask for the PDF files that go with that list, so each row's "Download PDF" link works on the pasted page. Today, presumably, the CSV fills the list but its download-PDF links are empty, broken or point nowhere because the PDFs never reach WordPress.

Done = after uploading a CSV for a list whose items have a PDF/download link, the panel asks for the matching PDFs (one picker, multi-file), uploads them to WordPress media (WordPress connected) and each row's Download PDF link opens its own PDF on the live page. Rows without a PDF stay honest (named in the notes, no dead link).

Find first (don't guess):
- How CSV lists work today: the panel's CSV upload, which list/repeater element it fills, how the CSV columns map, and how a row's PDF/download link is filled now (column with a file name? URL? nothing?). Search src/ui/ and core for csv, list, repeater, query loop, download, pdf. Read the matching HANDOFF/plan/CLAUDE.md sections.
- How a row should be matched to its PDF: by a CSV column holding the file name, by row title, or by order. Make this question 1 with lettered options and a ⭐ (recommend matching by a file-name column when present, else by name similarity, with unmatched rows/PDFs listed in the notes).
- Upload path: reuse the existing WordPress media upload (src/ui/uploader.ts, wordpress.ts, safe filenames, slugs: link-upload-fixes .11 rules — explicit slug, never a page's address, `assertPayload` allows direct document links). Ask what happens with no WordPress connected (inline JSON mode): likely PDFs can't be embedded, so say so in the panel. Question if needed.
- Bricks side: the link setting on the row's download element must come from `reference/bricks/*.json` samples, never from memory.

## Constraints
- Load `skill_view('figma-to-bricks')` (PLANNER); say so. rules-summary first, then only the CLAUDE.md sections you need. No worktree, code or commit.
- Plan to `~/.hermes/plans/figma-to-bricks/csv-list-pdfs.md`: questions at the top (lettered, ⭐, options under ~60 chars), plan written as if ⭐ chosen, tasks test first, generic fixtures, end with the Docs & records task.
- Size: Justin picked Opus 5.5 medium builder; Opus xhigh reviewer. If it's really a big cross-pipeline capability, say so.
- In flight: layout-floors (Opus: adapt), text-link-followups (Sol: normalise/contact-links, style/rag, emit/page-addresses, emit/elements, ui/site-pages), google-font-hardening (ui/fonts.ts), photo-hover-glass planner, card-link-words (waiting for go; normalise/label-links.ts). Name file overlaps with each.
- Other bugs: `found_else`, don't fold in. Plain words for WhatsApp.

Justin's words: "Moreover, when there is a list for the plugin like when someone uploads a .CSV file make it so that the plugin also asks for a PDF so the download PDF links works for that list. Put this on opus 5.5 medium agent"
