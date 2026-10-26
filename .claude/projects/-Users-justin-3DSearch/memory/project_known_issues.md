---
name: Known Issues (as of 2026-03-31)
description: Active bugs and issues — LLM rewrite batch not yet fired, tinyllama quality, HTML in meta descriptions, ollama package not in Docker image
type: project
---

1. **Celery Beat rewrite task hasn't fired yet** — `last_run_at` is None. Containers were rebuilt and haven't hit the 6-hour interval. Run `docker-compose exec web python manage.py rewrite_descriptions --sync --batch 50` to process immediately. Only 1/42 models rewritten so far (Model ID 18).

2. **tinyllama quality is low** — hallucinates placeholder text like `[insert name]`, needs `_trim_rambling` to cut off instruction echoing. Switch to phi3:mini or llama3:8b on production.

3. **HTML leaks into meta descriptions** for unrewritten models — `model_page()` at `models_app/views.py:856` uses `html_mod.escape()` which escapes but doesn't strip HTML tags. Fix: strip HTML before escaping in SSR view.

4. **ollama Python package not in Docker image** — was manually pip-installed during testing. Must `docker-compose build web celery` before deploying so it's baked in.

5. **tinyllama must be re-pulled after container restarts** — only phi3:mini and embeddinggemma are in the Dockerfile.

**How to apply:** Check these before deploying or debugging rewriter issues.
