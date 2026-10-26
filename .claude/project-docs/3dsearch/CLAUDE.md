# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
docker compose build && docker compose up -d
docker compose run --rm web python manage.py migrate
docker compose exec web python manage.py setup_periodic_tasks
```

- Frontend: http://localhost:5173 | API: http://localhost:8080/api/ | Admin: http://localhost:8080/admin

```bash
cd frontend && npm install && npm run dev    # Frontend dev server
npm run build                                 # Production build
npm run lint                                  # ESLint
```

## Testing

```bash
pytest                                        # All tests
pytest -m smoke -v                            # Smoke tests only
pytest scrapers/tests/unit/                   # Unit tests only
docker compose exec web python manage.py test models_app  # Django test runner
```

- Config: `pytest.ini` (testpaths: `scrapers/tests`, `models_app/tests`, settings: `backend.settings`)
- HTTP mocking: respx | Time mocking: freezegun

## Architecture

**3DSearch** is a 3D model search engine that aggregates from multiple platforms (Thingiverse, Sketchfab, YouMagine, Cults3D, MyMiniFactory).

### Backend (Django 5.0+ / Python 3.12)

- **`backend/`** — Django project config (settings, ASGI routing, Celery app, URLs)
- **`models_app/`** — Core data models (`Model3D`, `Creator`, `Tag`, `File`, `Image`), DRF API views, WebSocket consumer, serializers
- **`scrapers/`** — Modular scraping system with per-platform subdirectories, each containing HTTP clients with rate limiting and extraction logic
  - `scrapers/common/` — Shared: `persist.py` (DB upsert + WebSocket notify), `types.py` (dataclasses), `rate_limiters.py`, `db_locks.py`
  - `scrapers/tasks.py` — All Celery tasks (scheduled refresh + on-demand search + LLM rewrite)
  - `scrapers/management/commands/` — CLI entry points for each scraper and utilities

### Frontend (React 18 / TypeScript / Vite)

- `frontend/src/api.ts` — HTTP client for all backend API calls
- `frontend/src/pages/` — Route pages (Home, Search, ModelDetail)
- `frontend/src/components/` — UI components (ModelCard, Header, Filter, ModelDetail with Three.js 3D viewer)
- Styling: Tailwind CSS + Radix UI + MUI icons

### Services (docker-compose.yml — 7 containers)

`web` (daphne ASGI), `db` (PostgreSQL 15), `redis`, `celery`, `celery-beat`, `frontend` (Vite/Nginx), `ollama` (embeddings + text gen)

## Key Patterns

### Search Flow
1. Frontend calls `/api/models/search/?query=X&mode=cached|active`
2. `cached` mode: full-text DB query only
3. `active` mode: also triggers `scrapers/services/scraper_trigger.py` → Celery tasks fan out to platform scrapers
4. Scrapers extract → `scrapers/common/persist.upsert_bundle()` saves and sends WebSocket notification
5. Frontend receives real-time updates via `/ws/search/{query_hash}` (Django Channels)

### Scraper Architecture
Each platform module follows: HTTP client (rate-limited) → extraction (JSON → `ModelCore` dataclass) → persistence (upsert). Management commands expose CLI. `IngestCursor` and `SearchOffset` models track pagination state for resumable ingestion.

### LLM Description Rewriting
`models_app/services/description_rewriter.py` rewrites model descriptions via Ollama with 3-layer prompt injection defense (input sanitization → delimiter-wrapped prompt → output validation). Status tracked on `Model3D.rewrite_status` (pending/processing/done/failed/skipped).

## Environment Variables

Key vars in `.env`: `DATABASE_URL`, `CELERY_BROKER_REDIS_URL`, `THINGIVERSE_TOKEN_READ`, `SKETCHFAB_API_KEY`, `OLLAMA_BASE_URL`, `OLLAMA_GENERATION_MODEL`, `SCRAPER_INTERVAL_HOURS`, `SLACK_WEBHOOK_URL`

## Management Commands

```bash
docker compose exec web python manage.py thingiverse_fetch --feed newest --pages 2 --write
docker compose exec web python manage.py test_sketchfab_db --search "robot"
docker compose exec web python manage.py youmagine_fetch --pages 2 --write
docker compose exec web python manage.py rewrite_descriptions --sync --batch 50
docker compose exec web python manage.py setup_periodic_tasks
```

## SSR Model Pages



`models_app/views.model_page()` serves server-rendered HTML at `/model/{id}` for SEO — includes meta tags, Open Graph, Twitter Cards, and JSON-LD structured data. The frontend SPA hydrates on top.
