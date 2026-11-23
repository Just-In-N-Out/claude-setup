# Short 1 recording — Give every team the right AI context (86bd39xee)

Card: https://app.clickup.com/t/86bd39xee (assigned to Christian; list "v0.2 Shorts (Nov 2026)").
Not a code story: a demo-video task. Justin will record it on the MacBook with Claude doing the clicking and editing.

## Script (from the card)

| Time | On screen | Action | Caption |
|---|---|---|---|
| 0–2 s | Hook card | — | Same playbook in every AI tool |
| 2–8 s | Install montage at 8×: launch.bat, tiles turning green, "Leorna is ready" | — | Installed in our own cloud |
| 8–18 s | /admin/teams | Create Control Plane, Desktop Client, Release & Security; add Christian+Yan, Justin+Sharaan, Zayd | Teams in seconds |
| 18–26 s | /admin/projects | Create project Pilot Demos with an expiry date | Projects that expire on their own |
| 26–40 s | /admin/packs/assignments | Best Practices to every team, Go Skills → Control Plane, Code Review Agent → Desktop Client, Release Checklist → Release & Security | Each team gets its own context |
| 40–50 s | /admin/packs/overview | Pan across team × pack overview | Who gets what, at a glance |
| 50–55 s | End card | — | Leorna. One control plane for every AI coding tool. |

Done when: under 60 s, captions burned in, sensitive data blurred (emails, tokens, Scaleway billing), file attached to the card.
Recording rules (list description): 45–55 s, portrait 1080×1920, browser zoom 125–150%, one idea per beat, speed waits 4–8×, same hook/end cards.

## UI labels on leorna-control-plane main (e6a0fe2)

- /admin/teams: "Create a team" → Name → **Create team**; per team: email field/picker → **Add member**; **Delete team**.
- /admin/projects: "Create a project" → Name, Team, Expiry (UTC) → **Create project**.
- /admin/packs/assignments: "Assign a team default" → Team, Pack version → **Assign team default**; "Current assignments" table.
- /admin/packs/overview: "Pack overview".
- Packs are built at /admin/library (tick items, name, save) — the four packs must exist before recording.
- Admin pages need an admin session (403 otherwise).

## Blocker: one pack per team

migration 000016: unique index `pack_assignments_team_default ON pack_assignments (team_id) WHERE project_id IS NULL`, so a second team assignment replaces the first. The 26–40 s beat as written cannot show two packs per team.
Options: (a, recommended) build three combined team packs in /admin/library (Best Practices items + the team's extra pack items); (b) drop "Best Practices to every team" from the script. **Decision open — Justin/Christian.**

## Plan

1. Playwright (headed, portrait 1080×1920 viewport, slowMo, built-in video recording) drives DEV through the beats. Justin signs in once (Google OAuth); reuse via storageState. Inject a fake cursor + click highlight; CSS-blur email elements before filming. Script can also delete the three teams for a re-take.
2. ffmpeg: speed install clip 8×, burn captions per beat (drawtext/ASS), add 2 s hook + end cards, export portrait MP4 ≤ 55 s. Pull frames and check blur/captions.
3. Optional voiceover: Kokoro TTS (Apache 2.0, offline, CPU). Alternatives: ElevenLabs (paid, commercial ok, voice clone) or own voice. Avoid Coqui XTTS (non-commercial licence).
4. Justin approves the video; only then attach it to the card.

## Mac setup

```
brew install ffmpeg espeak-ng
npx playwright install chromium
python3 -m pip install kokoro soundfile   # only if voiceover wanted; Python 3.10–3.12
```

## Still needed from Justin

- DEV console URL
- Pack fix: (a) or (b)
- Voiceover: Kokoro / ElevenLabs / own voice / none
