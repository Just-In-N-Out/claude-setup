---
name: LLM Description Rewriter Feature
description: Implementation details for LLM-powered model description rewriting on branch JJISSA-S6 — architecture, services, prompt injection defense, and current state
type: project
---

Branch JJISSA-S6 implements LLM-powered description rewriting for 3D model listings.

**Why:** Improve SEO and readability of scraped model descriptions by rewriting them with an LLM.

## Architecture

- **Ollama** runs in Docker alongside the app; text generation model (tinyllama locally, phi3:mini on prod)
- **Celery task** `rewrite_model_description` processes individual models (3-min timeout, 2 retries)
- **Celery Beat** runs `rewrite_descriptions_batch` every 6 hours (picks 50 pending, fans out)
- **Management command** `rewrite_descriptions` with `--sync`, `--batch N`, `--reset` flags

## Key Files

- `models_app/services/description_rewriter.py` — 3-layer prompt injection defense (sanitize, delimiter-wrapped prompt, output validation) + `_trim_rambling` post-processing
- `models_app/models.py` — Model3D fields: `rewritten_description`, `rewrite_status` (pending/processing/done/failed/skipped), `rewritten_at`
- `scrapers/tasks.py` — Celery tasks with PostgreSQL advisory lock
- `scrapers/management/commands/rewrite_descriptions.py` — CLI tool
- `models_app/views.py` — API returns `description` (prefers rewritten), `description_raw`, `description_is_rewritten`; SSR uses rewritten in meta/OG/JSON-LD
- `frontend/src/api.ts` — `ModelDetailDto` updated
- `frontend/src/components/ModelDetail.tsx` / `ModelDetailPage.tsx` — "AI Rewritten" chip + toggle button

## Settings

- `OLLAMA_BASE_URL`, `OLLAMA_GENERATION_MODEL`, `OLLAMA_REQUEST_TIMEOUT` in `backend/settings.py`
- Default model changed to tinyllama locally (phi3:mini OOM-killed in 3.8GB Docker); use phi3:mini or llama3:8b on prod

## Rate Limiter Changes

- Sketchfab bucket size: 1→5 (sync), 4→8 (async); RPS: 1.0→2.0 in `scrapers/sketchfab/services/sketchfab_http_client.py`
