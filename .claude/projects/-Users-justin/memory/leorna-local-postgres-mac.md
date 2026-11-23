---
name: leorna-local-postgres-mac
description: "On Justin's Mac the leorna-test-pg container differs from the getting-started guide (port 5432, own password)"
metadata:
  node_type: memory
  type: project
  originSessionId: 51bd1f8e-43d3-4a53-a378-0bbfa5b778bc
  modified: 2026-11-23T19:55:32.441Z
---

On the Mac, Docker container `leorna-test-pg` (postgres:18.6) publishes on `127.0.0.1:5432`, not the guide's 55432, and its POSTGRES_PASSWORD is not the guide's `local-test-only`. Using the guide's URL makes the control plane die with `begin migrations failed` (the error hides the auth/connection cause). Dev DB is `leorna_dev` (created 2026-11-23).

**Why:** container was created before the guide changed; recreating it would wipe its data.
**How to apply:** build LEORNA_DATABASE_URL from `docker inspect` (read POSTGRES_PASSWORD, URL-encode it, never print it) with port 5432, then `LEORNA_DEV_MODE=1 make run`. Related: [[leorna-short1-recording]].
