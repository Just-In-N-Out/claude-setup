---
name: gh-personal-repos-hidden
description: "gh's active account on the desktop is Justin-Leorna, so personal private repos don't show; read them with the personal token, no auth switch"
metadata:
  node_type: memory
  type: reference
  originSessionId: 5080910a-9445-46fa-ad7e-bf7e748286b6
  modified: 2026-11-21T22:57:16.211Z
---

On the desktop, `gh` is logged in to both accounts with **Justin-Leorna active**, so `gh repo list Just-In-N-Out` hides private personal repos (e.g. `Just-In-N-Out/PersonalWebsite`, private, deployed at personal-website-gilt-five.vercel.app; projects.tsv desktop_path `/home/justin/JustinPersonalWebsite`, not cloned as of 2026-11-21).

Read them without `gh auth switch` (which CLAUDE.md forbids): `GH_TOKEN=$(gh auth token --user Just-In-N-Out) gh api 'user/repos?per_page=100&affiliation=owner' --paginate`.

Proven 2026-11-21: the plain listing missed PersonalWebsite; the token form found it.
