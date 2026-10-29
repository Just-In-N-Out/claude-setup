# Phase 5: Live check (when Justin says "pasted")

After he pastes a merged fix and replies **pasted <page>** (or **converted** for a Convert-only fix), an agent checks the live page so he doesn't have to (Justin, 2026-10-20).

1. Board → `checking`. If the page is new, a draft, or ambiguous, ask for its link in one line first.
2. Dispatch a **CHECKER**:
   - goal: `CHECKER (read only) for <project> feature "<name>": check the live <page>`.
   - context:
     - the page and the site (from the project skill);
     - the plan path and its paste check (what "fixed" looks like);
     - "Load the project skill, CHECKER role. Read only: never log in, purge caches or change the site/media. Compare ordinary and timestamp-query responses, retaining request times and actual cache headers; a query parameter alone does not prove a cache bypass. Use project-specific cache diagnostics only within their documented access restrictions and report what the responses actually establish."
     - "Check the fix concretely: follow each link and report where it lands; measure sizes in the browser (`browser_exec`, `getBoundingClientRect`) at desktop and phone widths. Take a screenshot of the fixed part with `capture_screenshot()` and return its file path. If the browser isn't available, check over HTTP and say no screenshot was taken."
   - output_schema: `{verdict: pass|fail|unsure, summary, findings[], screenshots[]}`.
3. On return, send `🔎 <name>: live check — pass` (or `fail`/`unsure`), one line per finding, and `MEDIA:` each screenshot.
   - Pass: board → `verified`.
   - Fail or unsure: preserve the verified source release but mark live acceptance failed/unproved. If observed responses support stale caching, request one targeted purge/recheck; do not keep recommending it after fresh responses reproduce the defect. When one saved element or pre-publication payload is needed, set `awaiting-answer` with that exact small artifact request. After it arrives, advance the board immediately and delegate bounded diagnosis of the first unresolved boundary; missing frontend metadata does not itself prove which producer/importer lost it. Do not automatically restart a full implementation/review/corpus pipeline or ask for another upload before root-cause evidence supports that step. A demonstrated code repair still requires its normal plan approval and release gates.
