---
name: project-audit-2026-06
description: "June 2026 full audit of weightstone-journal — what was fixed, what's still pending (DB push, key rotation, prefill extraction)"
metadata: 
  node_type: memory
  type: project
  originSessionId: f952b628-e7d7-4b31-8ad9-0c30cd5780ca
---

Full audit + remediation done 2026-06-10 (plan: ~/.claude/plans/you-are-a-world-class-snoopy-wirth.md).

**Fixed in working tree (uncommitted):** vitest harness (35 tests: syncEngine, operationQueue, crypto, tempId, auth-config), GitHub Actions CI (lint/tsc/strict/test/build/CSP gate), tsconfig.strict.json ratchet for src/lib (0 errors), CSP injected at build via injectCsp plugin in vite.config.ts, server secrets removed from .env, syncPendingPosts failures surfaced via 'post-sync-failed' event + toast, temp-ID utils in src/lib/tempId.ts, fresh-install IndexedDB upgrade bug fixed (v2 branch guard), dead pages deleted, RELEASE.md checklist, bun.lockb removed.

**PENDING — user must do:**
1. Apply 2 security migrations to prod (no CLI auth on machine): `20260610000000_lock_down_premium_functions.sql` (CRITICAL: any authed user can grant/revoke premium via RPC) and `20260610000001_reenable_exercises_rls.sql` (RLS disabled since Nov 2025). Via `supabase login` + `db push`, or paste into Dashboard SQL editor.
2. Rotate SUPABASE_SERVICE_ROLE_KEY + GOOGLE_GEMINI_API_KEY (were in frontend .env).
3. Run fraud-audit query (in migration comments) for illegitimate premium grants.
4. TestFlight device test of CSP build before release.
5. Regenerate Supabase types (`supabase gen types`) — stale types forced `as any` casts in subscriptionHelpers.ts (marked with comments).

**M2.1 done (second commit):** prefill logic extracted to src/lib/workout/prefill.ts (pure, 18 tests) + aggregations moved to src/lib/workout/aggregations.ts (re-export shim at old path); both hooks consume it — needs on-device smoke test of add-set prefill + unilateral toggle before release. Branding ambiguity still open: "Minimalift" (index.html title, Info.tsx legal text) vs "MinimaLog" (package, app id, domain minimalog.fit) — asked user, no answer yet.

Related: [[project_expo_migration]] — RN rewrite makes god-file refactors low-value; Supabase fixes carry over.
