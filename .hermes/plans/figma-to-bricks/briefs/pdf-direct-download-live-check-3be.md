# CHECKER — pdf-direct-download failed live report

## Role

CHECKER/read-only diagnosis for the released `pdf-direct-download` feature. Justin reports that the PDF button still does not download and asks whether cache should be cleared. Do not build or change anything. Do not start another broad implementation/review cycle.

## Exact user message

> it did not work. Should i clear cache or something?

Read the existing plan at `/Users/justin/.hermes/plans/figma-to-bricks/pdf-direct-download.md`, specifically released build2026-10-22.7 and installed/live check3be. Load `figma-to-bricks` and follow CHECKER role; use selective project context to retrieve the live Services site's actual URL from main `CLAUDE.md` or existing evidence, not a guessed hostname. `references/link-validation.md` applies. This is read-only diagnosis, not implementation.

## Context

Release was parent-verified at977fcce7fc1e2fac834d3721c23050447f61e927, committed BUILD2026-10-22.7, main=origin=actual remote and actual dist hashes. Later releases may exist; don't misreport .7 as globally latest. Current source emits valueless `download` on structural PDF Button/linked Div/Block, preserving pictures/vectors/prose as viewing links. Fresh review and independent loop verifier passed. **Installed Bricks2.3.9 paste/save/copy-back and frontend download retention were explicitly not proved.** That unresolved boundary is now the primary diagnostic target, not another converter-only test exercise.

Affected UI: dark heavy-equipment inventory table, bottom-right outlined download icon button **DOWNLOAD FULL INVENTORY (PDF)** on Services. Previously live element `brxe-gcolzx`, a Div rendered as anchor; earlier published HTML lacked download, target and rel. Do not depend solely on this id if re-paste changed it; locate the visible label/link.

The original PDF under same-site `/wp-content/uploads/2026/10/...-pdf.pdf` previously returned direct200 application/pdf with no Content-Disposition. Recheck, do not assume unchanged. User accepted a narrow limitation: a same-origin PDF redirected off-site can replace the current page; current direct Services upload previously did not hit that condition. No server/script delivery fix is authorized.

## Checks

1. Read the published Services page and compare ordinary and timestamp-query requests, inspecting cache/age headers rather than assuming a nocache parameter guarantees a bypass. Inspect actual download-anchor href, download attribute, target, rel and handlers/overlays if relevant. Do not log in or purge any cache yourself.
2. Use a real browser if available. Inspect actual DOM attributes and rendered click target. Follow redirect/origin chain and PDF response headers with read-only requests. Determine what can be established about stale cached HTML versus the saved/published link not retaining the attribute. A public page alone may not distinguish old paste from Bricks dropping attributes—state that uncertainty.
3. If feasible, exercise the public PDF click with isolated download output under the task's scratch folder, capture actual completed download events/file bytes and page/tab behavior. No live-site writes. Keep the user's browser/profile untouched; isolated browser session only. Do not infer browser behavior solely from an HTTP GET.
4. Take a screenshot of the affected control (not the whole long page if avoidable). Save evidence durably under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/pdf-direct-download/live-check-3be/` with request time and exact URLs/headers/DOM/click receipts. Do not modify the shared board or plan.
5. Return the **smallest next action**: e.g. one LiteSpeed purge if stale HTML is evidenced; confirm reload+re-convert+re-paste occurred if the public page lacks the new output; or ask for the pasted button's Bricks Copy JSON to establish attribute retention. Don't ask for multiple large exports or claim a new code fix is needed without evidence.

## Boundaries and output

No login, credential handling, website/admin writes, purges, uploads, plugin/source/BUILD/records changes, commits or merges. Distinguish actual observation from inference. Preserve existing release/accepted-limit/font facts without re-running corpus or unit suites; those do not establish this installed boundary.

Return `verdict: pass|fail|unsure`, `summary`, `page_url`, `observed_anchor`, `cache_evidence[]`, `click_result`, `findings[]`, `smallest_next_action`, `evidence_paths[]`, `screenshots[]`. Report no universal browser/download guarantee. Aim at a bounded live diagnosis, not another feature pipeline.
