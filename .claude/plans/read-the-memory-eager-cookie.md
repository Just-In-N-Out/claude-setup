# 86bbu3xfw — Claude Code config transformer (leorna-client)

## Step 1 — Branch from updated main (Justin asked for this first)

Client repo (story lives here):
```
cd /Users/justin/Leorna/leorna-client
git checkout main
git pull --ff-only origin main        # local main c618eb9 -> origin 0b453fe (PR #7 merged)
git checkout -b feat/86bbu3xfw-claude-transformer
```

Control-plane repo (only for the later delivery/stories.json entry; leave untracked deploy/local/ alone):
```
cd /Users/justin/Leorna/leorna-control-plane
git checkout main
git pull --ff-only origin main
```

(Rest of plan pending exploration results.)
