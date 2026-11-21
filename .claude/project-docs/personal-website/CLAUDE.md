# Personal Website — CLAUDE.md Spec

## Project Overview

Build a personal portfolio website for a software engineer specializing in secure infrastructure and AI/LLM security. The site should communicate a clear value proposition to **full-time employers and internship recruiters** in SWE and cybersecurity roles.

**First impression goal:** Visitor should feel within 3 seconds — "this person is a serious security engineer."

---

## Stack

- **Framework:** Next.js (App Router)
- **Styling:** Tailwind CSS
- **Fonts:** Load via `next/font` — use a clean, modern sans-serif (e.g. Geist, Inter, or DM Sans). Body text sharp and readable. No decorative fonts.
- **Animations:** Subtle only — fade-in on scroll via Intersection Observer. No flashy effects. Nothing that distracts.

---

## Design Principles

- **Minimal light theme.** White/off-white background (`#fafafa` or pure white). Dark text. Let whitespace breathe.
- No dark mode toggle needed for now.
- No gradients, no shadows on everything, no glassy cards. Flat and clean.
- Accent color: one single muted accent (suggestion: a desaturated slate-blue or neutral charcoal — pick what fits). Used sparingly on links, hover states, and section markers only.
- Mobile responsive. Every section must look great on 375px and up.
- Typography hierarchy must be clear: large confident headings, smaller muted body, mono font for code/tech labels.
- Sections separated by whitespace, not dividers or borders.

---

## Site Structure

### 1. Navigation
- Fixed top nav, minimal.
- Logo/name on the left: `Justin` — plain text, no logo graphic needed.
- Links on the right: `About`, `Projects`, `Skills`, `Contact`
- On mobile: hamburger or just hide links and rely on scroll.
- No background on nav until scroll — then subtle white with slight border-bottom.

---

### 2. Hero Section

**Headline (large, confident):**
> I build secure software infrastructure.

**Subheadline (smaller, muted):**
> Software engineer focused on secure systems design and AI/LLM security. Building backends and infrastructure that hold up under attack.

**CTA buttons (two):**
- Primary: `View Projects` → scrolls to #projects
- Secondary: `GitHub ↗` → opens `https://github.com/Just-In-N-Out` in new tab

No hero image. No background pattern. Full viewport height or close to it. Text left-aligned or centered — your call but stay consistent with the rest of the site.

---

### 3. About / Education Section

**Section label:** `About`

**Short bio (2–3 sentences, conversational but professional):**
> I'm a software engineering student at Arizona State University building at the intersection of secure infrastructure and AI systems. My focus is on designing software that's hard to break — from secure backend architecture to LLM pipeline hardening. I'm pursuing a Master's in Cybersecurity to go deeper on the systems and adversarial side.

**Education — display as two clean cards or a simple list:**

| Degree | School | Status |
|---|---|---|
| B.S. Software Engineering | Arizona State University | May 2026 |
| M.S. Cybersecurity | TBD | Pursuing |

Keep this simple. No icons needed. Just clear typography.

---

### 4. Projects Section

**Section label:** `Projects`

Display as a **card grid** (2 columns on desktop, 1 on mobile). Each card should show:
- Project name (bold)
- One-line description
- Tech stack tags (small pill labels, muted)
- GitHub link (icon + "GitHub" or just arrow)

Do **not** add a live demo link unless specified. Do **not** add star counts or fake metrics.

---

#### Project 1 — 3DSearch
**Description:**
A 3D model search aggregator that indexes results from Thingiverse, Sketchfab, and TurboSquid. Features a locally-hosted LLM (Ollama) for description rewriting with a three-layer prompt injection defense: input sanitization, structured prompt wrapping, and output validation.

**Tags:** `Next.js` `Django` `PostgreSQL` `React` `Docker` `Ollama` `LLM Security`

**GitHub:** `https://github.com/Just-In-N-Out`

---

#### Project 2 — LLM Vulnerability Scanner
**Description:**
A CLI and API tool for systematically testing deployed LLMs for security vulnerabilities — including prompt injection, jailbreaks, and system prompt extraction.

**Tags:** `Python` `FastAPI` `Typer` `LLM Security` `Red Teaming`

**GitHub:** `https://github.com/Just-In-N-Out`

---

#### Project 3 — MinimaLog
**Description:**
A minimalist workout tracking app implementing the nSuns 5/3/1 linear progression algorithm. Built mobile-first with a clean offline-capable UI.

**Tags:** `TypeScript` `React` `Capacitor` `Supabase` `Expo`

**GitHub:** `https://github.com/Just-In-N-Out`

---

### 5. Skills Section

**Section label:** `Skills`

Display as a **simple grouped list** — no progress bars, no percentages, no skill meters. Those look generic and communicate nothing real. Just clean category labels with items.

| Category | Skills |
|---|---|
| Languages | Python, TypeScript, JavaScript, C++, SQL |
| Frameworks & Tools | Next.js, React, Django, FastAPI, Docker, PostgreSQL |
| Security | Threat Modeling, Prompt Injection Defense, RBAC, OAuth, Row-Level Security |
| Concepts | LLM Security, Secure Architecture, CI/CD, REST APIs |
| Learning | TryHackMe, PicoCTF, Kali Linux |

Keep it scannable. Two or three columns on desktop. Mono font for the skill names looks clean.

---

### 6. Contact Section

**Section label:** `Contact`

Short line of text:
> Open to full-time and internship roles in software engineering and cybersecurity.

Then three icon+link items stacked or inline:
- **Email:** `[YOUR_EMAIL]` → `mailto:[YOUR_EMAIL]`
- **GitHub:** `github.com/Just-In-N-Out` → `https://github.com/Just-In-N-Out`
- **LinkedIn:** `[YOUR_LINKEDIN_URL]` → `[YOUR_LINKEDIN_URL]`

No contact form. No extra copy. Clean and direct.

---

### 7. Footer

One line, centered, muted small text:
> Justin © 2025

---

## Component Structure (suggested)

```
/app
  layout.tsx         ← font setup, metadata
  page.tsx           ← assembles all sections

/components
  Navbar.tsx
  Hero.tsx
  About.tsx
  Projects.tsx
  ProjectCard.tsx    ← reusable card
  Skills.tsx
  Contact.tsx
  Footer.tsx
```

---

## Metadata (for SEO)

In `layout.tsx`:
```ts
export const metadata = {
  title: 'Justin — Software Engineer & Security Researcher',
  description: 'Software engineer building secure infrastructure and AI systems. B.S. Software Engineering, ASU. Pursuing M.S. Cybersecurity.',
}
```

---

## Placeholders to Fill In Before Deploy

- `[YOUR_EMAIL]` — your professional email
- `[YOUR_LINKEDIN_URL]` — full LinkedIn profile URL
- Update project GitHub links once repos are public

---

## Blog

The site has a blog at `/blog` with three categories: **Projects**, **Security**, and **DSA** (Data Structures & Algorithms). The homepage shows a preview of the 3 most recent posts.

### How to Add a Blog Post

1. Create a new `.mdx` file in `content/blog/` (e.g. `content/blog/my-post-slug.mdx`)
2. The filename becomes the URL slug: `my-post-slug` → `/blog/my-post-slug`
3. Add frontmatter at the top of the file:

```mdx
---
title: "Your Post Title"
date: "2026-03-22"
category: "security"
description: "A one-line summary shown on cards and meta tags."
tags: ["Tag1", "Tag2"]
---

Your markdown content here. Supports all standard markdown:
headings, code blocks, lists, links, bold, italic, etc.
```

### Frontmatter Fields

| Field | Required | Description |
|---|---|---|
| `title` | Yes | Post title displayed on cards and the post page |
| `date` | Yes | ISO date string (`YYYY-MM-DD`). Posts sort newest-first |
| `category` | Yes | One of: `"projects"`, `"security"`, `"dsa"` |
| `description` | Yes | Short summary for cards and SEO |
| `tags` | No | Array of tag strings shown as pills (default: `[]`) |

### Blog Architecture

- `lib/blog.ts` — reads MDX files from `content/blog/`, parses frontmatter with `gray-matter`
- `app/blog/page.tsx` — blog listing, grouped by category (Projects, Security, DSA)
- `app/blog/[slug]/page.tsx` — individual post page, renders MDX via `next-mdx-remote`
- `components/BlogCard.tsx` — card component used on listing page and homepage preview
- `components/BlogPreview.tsx` — homepage section showing 3 most recent posts
- `components/BlogNavbar.tsx` — floating navbar for blog pages (category links)

---

## What NOT to Do

- No hero image or avatar photo (keep it text-forward)
- No skill percentage bars or rating stars
- No testimonials section
- No animations that delay content visibility
- No dark/light toggle for now
