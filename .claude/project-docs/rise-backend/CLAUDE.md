# Rise — Monorepo (backend + frontend)

## Git & remotes — READ FIRST

- **All backend AND frontend changes commit to this repo (`rise-backend`).** Push to `github.com/Just-In-N-Out/rise-backend` on `main`.
- **Never touch the `Rise---UI` remote again.** That repo (`github.com/Just-In-N-Out/Rise---UI`) is frozen at commit `4f29aa4` as a snapshot of the UI-only prototype. Do not push, force-push, branch, PR, or open issues against it.
- If you discover a stale local clone of `RISE-OFFICIAL` on disk (at `~/Desktop/RISE-OFFICIAL`), ignore it. The canonical frontend is `~/Desktop/rise-backend/frontend/`.
- Per global rules: never include `Co-Authored-By` lines for Claude/AI in commits, never override git author metadata, and never commit any `CLAUDE.md` file.

## Repo layout

- `./` — NestJS backend at the root (`src/`, `package.json`, `docker-compose.yml`, etc.)
- `./frontend/` — Next.js 16 app, wired to the backend API (its own `package.json`, `node_modules`, `.next`)
- `./PROGRESS.md` — living status doc. Update whenever significant backend or frontend work ships.
- Active roadmap + current sprint: `~/.claude/plans/alright-here-s-the-thing-functional-church.md`. Read before planning new work.

## Running locally

Backend: `npm run db:up && npm run migration:run && npm run seed && npm start` — serves on `:4000`.

Frontend: `cd frontend && npm install && npm run dev` — serves on `:3000`. Needs `frontend/.env.local` with `NEXT_PUBLIC_API_BASE_URL=http://localhost:4000/api` (not committed).

## Maintenance

When significant work ships in a session — new endpoints, new screens wired, migrations, major refactors, architecture decisions — update in the same session:
- This `CLAUDE.md` (monorepo-wide context, local-only, never committed).
- `./PROGRESS.md` — committed + pushed.
- The active roadmap at `~/.claude/plans/alright-here-s-the-thing-functional-church.md`.

They're living state, not an archive. The next Claude session reads them before touching code. If you shipped it, it goes here.

---

# Backend

NestJS 11 + TypeORM 0.3 + Postgres. JWT auth via `@nestjs/jwt` + `passport-jwt`. Served on `:4000`. Full shipped-work history lives in `PROGRESS.md`; this section is orientation only.

## Modules (`src/`)

- `auth/` — login, signup, JWT strategy. In `AUTH_MODE=local`, credentials live in `dev_credentials` (bcrypt). Flips to Cognito in Month 2.
- `students/` — profile CRUD, visibility toggle, view log (`/students/views`), self-delete.
- `companies/` — profile CRUD, admin-gated approval + tier.
- `search/` — `POST /search/students` filter engine (degree, city, gpa_min, skills, grad year, pagination). Triggers view fanout on `GET /students/:id`.
- `files/` — CV upload/download. `FILE_STORAGE=local` writes to disk; flips to S3 in Month 2.
- `notifications/` — list + mark-read. Fanned out from search views + admin actions.
- `admin/` — stats, student/company lists, approval + tier mutations. Role-gated.
- `subscriptions/` — tier model; wired but billing UI is Phase 2.
- `common/` — guards, decorators, shared DTO helpers.
- `config/` — `data-source.ts` (TypeORM CLI entry), app config.
- `migrations/` — TypeORM migrations. Current: `1776332817486-Init`, `1776333010162-DevCredentials`.
- `scripts/seed.ts` — dev seed data (runs via `npm run seed`).

## Runtime toggles (`.env`, see `.env.example`)

- `AUTH_MODE=local` → `dev_credentials` table. `AUTH_MODE=cognito` → AWS Cognito (Month 2).
- `FILE_STORAGE=local` → disk. `FILE_STORAGE=s3` → S3 (Month 2).
- `DB_PORT=5433` (docker-compose Postgres), `PORT=4000`, `JWT_SECRET`.

## Scripts

- `npm run db:up` / `db:down` — docker-compose Postgres.
- `npm run migration:generate -- src/migrations/<Name>` — generate from entity diff.
- `npm run migration:run` / `migration:revert` — apply / roll back.
- `npm run seed` — populate dev data.
- `npm test` — Jest unit; `npm run test:e2e` — e2e via `test/jest-e2e.json`.

## Known backend gaps

- **`dev_credentials` orphan on student delete** — `DELETE /students/me` removes the student + children but leaves the `dev_credentials` row, so the email stays taken. Fix: `credentialRepo.delete({ cognito_sub })` in `StudentsService.deleteMe`. Moot once Cognito lands.
- **No endpoints yet for** bio persistence, password change, notification preferences, saved searches, company team management — all Phase 2.

---

# Frontend

## Project Overview

A Next.js 16 / React 19 / Tailwind CSS 4 / TypeScript student hiring platform. Landing page + student/company/admin dashboards. Montreal-based.

**Status:** Month 1 done. Phase A + Phase B of the current sprint done — frontend is fully wired to the local backend. Smoke-tested end-to-end on 2026-04-16: student login, profile, visibility, search gating, view fanout, notifications, admin approval, signup, delete all pass against the seeded data. Running `AUTH_MODE=local` + `FILE_STORAGE=local` (both flip to AWS values once provisioning is done in Month 2).

## Tech Stack

- **Framework**: Next.js 16.1.7, React 19.2.3, TypeScript 5
- **Styling**: Tailwind CSS 4 (CSS-first config via `@theme inline` in globals.css, no tailwind.config)
- **Font**: DM Sans (single family, weights 400-700) — loaded via next/font/google
- **Animation**: framer-motion, motion (for testimonials), cobe (3D globe)
- **Icons**: lucide-react
- **Utilities**: clsx + tailwind-merge via `cn()` in `/lib/utils.ts`

## API wiring (Phase B, shipped 2026-04-16)

- `lib/api/{client,cookies,auth,students,companies,search,files,notifications,admin}.ts` — single `apiFetch` helper + per-domain services. Role mapping `'company' ↔ 'company_user'` isolated to `lib/api/auth.ts`; every other layer stays on `'company'`.
- `contexts/auth-context.tsx` — real `login(email,password)`, `signup(dto)`, `logout()`. `rise_token` cookie holds the JWT; `rise_role` cookie mirrored alongside so `middleware.ts` doesn't need to decode. On mount, if token cookie exists, fetches `/students/me` or `/companies/me` to hydrate.
- `middleware.ts` — requires both `rise_token` + `rise_role` cookies for any `/student`, `/company`, or `/admin` route. Next 16 renamed this convention to `proxy.ts` (old name still works, just warns).
- Login page drops the role dropdown; redirect picks dashboard based on returned `user.role`.
- Signup student form requires: `degree`, `city` (default `'Montreal'`), `gpa` (0–4, one decimal), `graduation_year` (2024–2030), plus `policy_version: 'v1.0'` in the payload.
- `/company/results` deleted. `/company/search` now owns filter panel + results + sort + pagination, reads `{total, students}` from `POST /search/students`.
- `FilterPanel` emits single-value `{degree, city, graduation_year, gpa_min, skills, limit, offset}` matching the backend DTO (radio groups replaced the prior multi-select checkboxes).
- `VisibilityToggle` now takes an `onChange` prop — dashboard + settings wire it to `students.setVisibility`.
- `lib/mock-data.ts` pruned to four exports that stay: `topSkills`, `allSkills`, `universities`, `mockPricingTiers`. Billing and team pages inline their placeholder data (both pages are still Phase-2 mocks, no backend endpoints yet).
- Settings page: `DELETE /students/me` wired to the danger-zone flow. Password change + notification prefs remain toast-only stubs with a small italic "Coming soon" hint (no backend endpoints for those yet).
- Bio field is frontend-only until the backend adds it; edit UI carries a "Bio persistence coming soon" hint.

Base URL: `NEXT_PUBLIC_API_BASE_URL=http://localhost:4000/api` (lives in `frontend/.env.local`, uncommitted). CORS is already configured on the backend to allow `http://localhost:3000`.

Endpoints consumed:
- `POST /auth/signup` (requires `email, password, name, role, policy_version`, plus `student_details: {university, degree, city, gpa, graduation_year}` OR `company_details: {company_name, industry, size}`)
- `POST /auth/login` → `{access_token, role, email}`
- `GET/PATCH /students/me`, `PATCH /students/visibility`, `GET /students/views`, `DELETE /students/me`
- `POST /search/students`, `GET /students/:id` (company-facing, fanout-triggering)
- `POST /files/upload` (multipart), `GET /files/mine`, `GET /files/cv/:studentId`
- `GET/PATCH /companies/me`
- `GET /notifications`, `PATCH /notifications/:id/read`
- `GET /admin/stats`, `GET /admin/students`, `GET /admin/companies`, `PATCH /admin/companies/:id/approval`, `PATCH /admin/companies/:id/tier`

## Design Context

### Users
- **Students**: Early-career job seekers uploading profiles to be discovered by companies. Process should feel effortless and empowering.
- **Companies/Recruiters**: Hiring managers searching, filtering, and connecting with student talent. Efficient discovery without noise.
- **Context**: Montreal-based. Users arrive with intent — students to be found, companies to find.

### Brand Personality
- **3 words**: Modern, confident, sharp
- **Voice**: Direct and assured. No fluff, no corporate-speak.
- **Emotional goals**: Confidence & trust — premium, reliable tool.

### Aesthetic Direction
- **Visual tone**: Clean, precise, polished. Generous whitespace, clear hierarchy.
- **References**: Notion, Stripe, Linear, Handshake (joinhandshake.com), Kling 3.0 feature page layout
- **Anti-references**: NOT generic job boards (Indeed/Monster), NOT social media feeds (LinkedIn)
- **Theme**: Light mode — white and soft teal palette. No dark teal sections on landing page (user explicitly removed them). Keep it white/teal-white/soft-teal.
- **Color palette**:
  - `teal-dark`: #0D3D3A (headings, used in cards but NOT as full section backgrounds on landing page)
  - `teal-brand`: #0F766E (primary actions, accents)
  - `teal-electric`: #2DD4BF (highlights — used sparingly, in animated hero rotating words)
  - `teal-white`: #F0FDFA (subtle section backgrounds)
  - `soft-teal`: #E2F0EE (light section backgrounds, borders)
  - `muted-teal`: #4A7C78 (secondary text)
  - Shadows use teal-tinted rgba values

### Design Principles
1. **Clarity over decoration** — Every element earns its place. Prefer whitespace over visual noise.
2. **Confident restraint** — Bold when it matters, quiet everywhere else.
3. **Craft in the details** — Smooth transitions, brand-tinted shadows, tight tracking on headings.
4. **Respect the user's time** — Scannable at a glance. Progressive disclosure.
5. **Two audiences, one standard** — Students and recruiters get equal care.

## Landing Page Architecture

The landing page tells a story: Problem → Flip → How It Works → Proof → Close.

### Current Section Order (top to bottom):
1. **Animated Hero** (`animated-hero.tsx`) — Rotating words "Student hiring is broken/slow/frustrating/outdated/over" with spring animation. Light bg (`teal-white`). Single "See how it works ↓" link below. No buttons.
2. **ContainerScroll Video** (`container-scroll-animation.tsx`) — 3D tilting video card that flattens as user scrolls. Video at `/public/hero.mp4`. White bg.
3. **Student Feature Rows** (`feature-rows.tsx`) — Kling 3.0 style sticky scroll. Text left (sticky, updates active step via IntersectionObserver), visual cards right (smaller, with lucide icons). 3 steps. Big "For Students" heading above.
4. **Radar** (`radar-effect.tsx`) — "How companies find you" with rotating sweep line and icon containers. Teal-white bg.
5. **Company Feature Rows** — Same component, `flipped` prop (cards left, text right). Big "For Companies" heading above.
6. **Globe** (`globe.tsx`) — Interactive 3D globe (cobe). "Hire student talent, everywhere." White bg.
7. **Testimonials** (`testimonials-columns.tsx`) — 3 auto-scrolling columns with anonymous reviews (initials, no photos, no company names). Teal-white bg.
8. **Final CTA** — "Ready to find your next match?" + two buttons. White bg.

### Navbar
- `grid-cols-3` layout for perfect centering
- Center links: "For Students" and "For Companies" (scroll to `#for-students` / `#for-companies`)
- No "How It Works" or "Pricing" links

## Key Design Decisions

### Typography
- **Single font**: DM Sans for everything (removed Inter and DM Mono)
- Body: 1rem (16px), `font-kerning: normal`
- All form labels normalized to: `text-[11px] font-semibold uppercase tracking-[0.06em] text-muted-teal`
- Input, Select, and FilterPanel all share identical border/radius/focus styling

### What Was Explicitly Rejected
- **Gradient text** — removed, never bring back
- **Blur circles / floating dots** — removed
- **Glassmorphism** — removed
- **Dark section backgrounds on landing page** — user explicitly said "let's not use the dark, dark teal. Let's keep it white, kind of green teal"
- **Liquid glass buttons** — tried and rejected ("doesn't look nice at all")
- **Large gradient transition bands between sections** — looked fuzzy, replaced with 2px bridges then removed entirely
- **Pricing section on landing page** — removed (doesn't drive signups)
- **Emoji in headings** — removed from student dashboard
- **Profile photos in testimonials** — use anonymous initials only, no company names

### Animation System
- `hero-load` classes for page-load stagger (0ms, 200ms, 400ms)
- `reveal-up`, `reveal-left`, `reveal-right`, `reveal-scale` — viewport-triggered via IntersectionObserver
- `prefers-reduced-motion` fully respected in globals.css
- Radar sweep: 4s rotation speed
- ContainerScroll: 3D tilt from 20deg → 0deg on scroll

### Component Library
- `/components/ui/` — Button, Card, Input, Select, Badge, Avatar, Modal, Toggle, Spinner, Tooltip, EmptyState, SkillTag, ProgressBar
- `/components/ui/animated-hero.tsx` — Rotating words hero
- `/components/ui/container-scroll-animation.tsx` — 3D scroll video card
- `/components/ui/feature-rows.tsx` — Kling-style sticky scroll rows with IntersectionObserver
- `/components/ui/radar-effect.tsx` — Scanning radar with icon containers
- `/components/ui/globe.tsx` — Interactive 3D globe (cobe)
- `/components/ui/testimonials-columns.tsx` — Auto-scrolling review columns
- `/components/ui/timeline.tsx` — Scroll-driven timeline (currently unused, replaced by feature-rows)
- `/components/ui/sticky-cards.tsx` — Stacking cards (currently unused, replaced by feature-rows)
- `/components/ui/cursor-glow.tsx` — Canvas cursor gradient (currently unused)

### Dashboard Layout
- **Student dashboard**: Profile completion first (actionable), then stats inline, then activity feed
- **Company dashboard**: Stats inline with header (smaller, 24px), search card is the primary content
- Stats are bare numbers on the page background — no cards, no left-border accents

## Frontend File Structure

```
/frontend
  /app
    /globals.css          — All design tokens, animations, custom elements
    /layout.tsx           — DM Sans font import, root layout
    /(public)/page.tsx    — Landing page (the main file being worked on)
    /(public)/auth/       — Login, signup
    /(authenticated)/     — Student, company, admin dashboards
  /components
    /ui/                  — All reusable UI components
    /layout/              — Navbar, Sidebar, Footer, Logo, MobileDrawer
    /student/             — ProfileCard, ProfileCompletionBar, VisibilityToggle
    /company/             — FilterPanel, StudentResultRow, SubscriptionBadge
  /lib/utils.ts           — cn() utility
  /lib/mock-data.ts       — Static form/landing helpers only (topSkills, allSkills, universities, mockPricingTiers)
  /lib/api/               — apiFetch + per-domain services (auth, students, companies, search, files, notifications, admin)
  /types/                 — TypeScript interfaces
  /contexts/              — Auth (real JWT), Toast
  /hooks/                 — useAuth, useToast
  /middleware.ts          — Cookie-gated route protection
  /public/hero.mp4        — Landing page video
```

## Known gaps (to revisit)

- **Orphaned `dev_credentials` on account deletion.** `DELETE /students/me` cascades the student + skills + notifications + consent records, but leaves the `dev_credentials` row behind so the email stays registered locally. Moot once Cognito is the credential store; until then, add a `credentialRepo.delete({ cognito_sub })` to `StudentsService.deleteMe`.
- **Bio, password change, notification preferences, saved searches, company team management** — all have UI stubs with "Coming soon" hints. Backend endpoints don't exist yet; Phase 2.
- **Admin student detail view** — no per-student admin page yet; the eye icon on `/admin/users` toasts "coming soon."

## Don't restart the dev server

The user explicitly asked not to restart the dev server after changes — Next.js hot-reloads automatically.

## Communicate

Ask questions to the user whenever needed. Do not make assumptions.
