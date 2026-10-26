---
name: SEO Improvements Needed
description: Homepage scored 40% SEO, model pages 60% — missing OG tags, canonical links, structured data improvements
type: project
---

## Homepage (3dsearch.org/) — 40% SEO score

- Add Open Graph tags (og:title, og:description, og:image, og:url, og:type) to `frontend/index.html`
- Add Twitter Card tags (twitter:card, twitter:title, twitter:description, twitter:image)
- Add `<link rel="canonical" href="https://3dsearch.org/">`
- Add Schema.org JSON-LD (WebSite type)

## Model Pages (3dsearch.org/model/{id}) — 60% SEO score

- Strip HTML from meta description fallback for unrewritten models in `model_page()` at `models_app/views.py:856`
- Add `<link rel="canonical" href="https://3dsearch.org/model/{id}">` to SSR template
- Add `<h1>` heading to SSR page
- Add logo to Schema.org JSON-LD
- Consider expanding page title with keywords (e.g. "Labyrinth Gift Box - Free 3D Model | 3DSearch")

**Why:** Improve search engine visibility and click-through rates.
**How to apply:** These are the next SEO tasks to tackle after the rewriter feature stabilizes.
