---
name: importer-whole-page-paste
description: "Justin wants a captured site page as ONE paste (header+page+footer together), not three template pieces; whole-page.json made by hand 2026-11-07"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a492f614-99ad-4c9d-89a6-3356eed047b1
  modified: 2026-11-08T01:30:02.475Z
---

On his first real test of the code method (2026-11-07), Justin pasted only `header.json` and said "i wanted the whole
page why did it only give this", then "i want the whole page give it to me". The main session joined `header.json`,
`page.json` and `footer.json` into `~/Downloads/bdry-paste/whole-page.json` (concatenated content, global classes
deduplicated by id; 1146 elements, 475 classes, no id clashes) and put it on his clipboard.

**Why:** he thinks of an imported site page as one thing to paste; the three-part split (Header/Footer templates) is the
plugin's choice, not his ask.
**How to apply:** when handing him importer pastes, give the whole page as one file first and the three parts as the
option; a `npm run site` output of a joined whole-page paste is a candidate small job (offer it). Related:
[[website-importer-paused]], [[deliverable-first]].
