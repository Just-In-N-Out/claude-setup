# Rise — Student Hiring Platform

## Project Overview
A Next.js 16 / React 19 / Tailwind CSS 4 / TypeScript student hiring platform. UI-only prototype with mock data. Students upload profiles, companies search/filter/connect. Montreal-based.

## Tech Stack
- **Framework**: Next.js 16.1.7, React 19.2.3, TypeScript 5
- **Styling**: Tailwind CSS 4 (CSS-first config via `@theme inline` in globals.css, no tailwind.config)
- **Font**: DM Sans (single family, weights 400-700) — loaded via next/font/google
- **Animation**: framer-motion, motion (for testimonials), cobe (3D globe)
- **Icons**: lucide-react
- **Utilities**: clsx + tailwind-merge via `cn()` in `/lib/utils.ts`

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

## Key Design Decisions Made in This Session

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

## File Structure
```
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
/lib/mock-data.ts       — All mock data
/types/                 — TypeScript interfaces
/contexts/              — Auth, Toast
/hooks/                 — useAuth, useToast
/public/hero.mp4        — Landing page video
```

## Don't Restart the Dev Server
The user explicitly asked not to restart the dev server after changes — Next.js hot-reloads automatically.

#Communicate
Ask questions to the user whenever needed do not make assumptions
