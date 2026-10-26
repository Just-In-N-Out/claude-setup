Hermes runs on Justin's MacBook (gateway under launchd, WhatsApp is the main channel). Gateway sessions start in /Users/justin, so a repo's AGENTS.md/CLAUDE.md never auto-loads; per-project skills cover that. Only the `default` profile exists (`thecoder` was deleted 2026-10-20). Local speech-to-text: faster-whisper (`stt-whisper` extra) was installed 2026-10-20; the gateway needs a /restart after dependency installs.
§
The WhatsApp gateway is the bridge (WHATSAPP_MODE=bot): no buttons, and clarify renders as a numbered list. Real buttons would need the WhatsApp Cloud API adapter. The ClickUp connector (clickup_mcp) is connected to the Leorna workspace as justin@leorna.com. Voice notes use local faster-whisper, with echo_transcripts off.
§
WhatsApp formatting: the adapter's format_message turns markdown *x* into italic _x_ and **x** into WhatsApp bold, for agent replies and cron output alike (plugins/platforms/whatsapp/adapter.py send). Bold needs **double asterisks**.
§
Open features live on the board ~/.hermes/plans/dispatch.json (feature-dispatch skill). After a chat reset, read it and ~/.hermes/plans/handoff-main-chat.md (the last main chat's handoff) before answering a "go", picks or "status". When no agent is running, Justin wants one prompt to reset the main chat with /new, to save usage.
§
Usage data: `hermes usage` shows the Claude plan's 5-hour and weekly limits; `hermes insights --days N` breaks tokens down by platform. delegate_task quirk: a batch (tasks=[a,b]) returns only when every child is done, so independent agents each get their own call.
§
No fallback provider is configured: the claude-subscription-directsdk provider dropped connections repeatedly on 2026-10-21 (ECONNRESET/gaierror), killing running subagents. `hermes fallback add` would add one.
§
Agent routing (Justin, 2026-10-22, all repos incl. Leorna): Opus 5.5 xhigh plans + reviews/verifies, Sol 6.1 xhigh builds/finishes. Opus at limit → ask Justin whether Sol proceeds. Every job starts with a Full/Mini pick; Mini = Opus plan, Sol build, one fresh Opus review, all xhigh. Details: feature-dispatch.