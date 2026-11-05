---
name: deliverable-first
description: Hand over something usable as soon as it works; 2026-10-31 he wants the website importer working and visible, not continuous building (review rounds now capped)
metadata:
  type: feedback
---

On 2026-10-29 the B-Dry header and after-FAQ jobs ran 6–7 review rounds each on the plugin's general header/footer
rules, every round finding real edge cases in other designers' files. Justin said that is good and to keep it going:
the iterations are wanted, not a problem. The B-Dry paste files were verified early and could be used before the
plugin work merged.

**Why:** he wants the plugin to handle any designer's file, so edge-case rounds are the point; he just likes knowing
what is already usable.

**How to apply:** don't cut review rounds below [[review-round-cap]] unless he asks. As soon as a deliverable he can use (a
paste file in Downloads) is verified, tell him it's ready and offer the paste steps while the loops continue, and give
short progress notes (what each round found, what's left). See [[run-without-stopping]].

**His limit (2026-10-29, header-bar):** after 8 review rounds and a second brake he answered the question, then cut in with "just merge": the remaining findings became known limits and the final verifier/auditor were skipped. At a brake after many rounds, always offer "stop fixing, merge as is" as an option; when he says it, merge (still rebase and run the checks) and record the limits and his unbuilt answer as a follow-up.

**Working and visible, not continuous building (2026-10-31, website importer, going to sleep):** "I do not want continuous building, I want this to actually get working and can see it … just keep going." After each merge (and before it when the code is combined and green), run a demo agent that uses the built tools end to end on the allowed real sites and leaves side-by-side shots (live vs copy at 390/768/1024/1440), a plain verdict naming which later job fixes each difference, and a paste file with steps; publish the shots as a page he can open. Brief: `~/.hermes/plans/figma-to-bricks/briefs/website-importer-demo-1.md`.

**Say what he can do at the end (2026-11-04, web-code-proof):** he expected the code-method proof to paste the whole bdry page and was frustrated that it pasted one section ("so this whole time we were building on something that had nothing to do with copying the whole page??"). Whenever a job is a proof, a slice or a step, say in the plan message, in one plain line, what he will and won't be able to do when it lands ("you'll paste one section, not the whole page; the whole page is the next job"), and repeat it at the merge.
