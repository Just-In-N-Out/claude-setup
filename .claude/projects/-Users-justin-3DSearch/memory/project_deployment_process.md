---
name: deployment-process
description: How the 3DSearch app is deployed - frontend via SCP, backend via git pull + service restart
type: project
---

Current deployment is a simplified process (no staging server) since there are no paying customers yet.

**Frontend:** Build locally, SCP files to server, copy to the correct folder. Changes go live automatically.

**Backend:** Push to GitHub, pull from GitHub on the server, restart the 4 backend services. Takes a few minutes total, mostly waiting on file transfers.

**Full process (not currently followed):** Set up staging server, verify it works, promote to live, tear down old server. Takes 15-60 minutes with multiple machines and many more steps. Will be used once there are paying customers.

**Why:** The simplified process saves significant time (~few mins vs 15-60 mins) and is acceptable risk given no paying customers are impacted by potential issues.

**How to apply:** When making changes that need deployment, be aware of this workflow. Backend changes require a git push + server-side pull + 4 service restarts. Frontend changes just need built files SCP'd to the server.
