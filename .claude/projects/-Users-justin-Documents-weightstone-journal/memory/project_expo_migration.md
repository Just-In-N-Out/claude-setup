---
name: Expo Migration Status
description: MinimaLog is being migrated from React+Vite+Capacitor to Expo+React Native in a separate project at /Users/justin/Documents/minimalog-rn/
type: project
---

MinimaLog Expo migration is in progress at `/Users/justin/Documents/minimalog-rn/`.

**Why:** Better performance, DX, native feel, and future-proofing. Native-only (no web target). Existing Supabase backend stays untouched.

**How to apply:** When working on the migration, reference existing code as spec but write fresh RN code. The full migration plan is at `/Users/justin/Documents/weightstone-journal/EXPO_MIGRATION_PLAN.md`.

**Phase 1 (Complete - 2026-04-04):** Project scaffold with routing, NativeWind, MMKV storage, quick-crypto, Supabase client, NetInfo network detection, eventemitter3 event bus, and 5-tab placeholder UI.

**Phase 2 (Complete - 2026-04-04):** Storage & Sync Engine -- expo-sqlite (sync API) with 11 tables, encrypted operation queue, sync engine with auto-sync (NetInfo + AppState), image caching via expo-file-system, temp ID resolution.

**Phase 3 (Complete - 2026-04-04):** Core Workout Flow -- Home (social feed), StartWorkout (check-in + template), WorkoutSession (all 6 hooks ported), WorkoutDetail (sharing). 91 total files. Full offline support.

**Phase 4 (Complete - 2026-04-04):** History, Progress & Navigation -- Calendar heatmap, exercise progress with custom SVG charts, monthly overview with staggered animations, share via view-shot. No new deps. Skipped swipeable tabs (standard tap navigation preferred on iOS).

**Phase 5 (Next):** Social, Profile & Subscription -- Apple Sign-In, RevenueCat, Paywall, PostCard rebuild, Profile settings, Follow/unfollow.

**Key decisions:**
- No ciphertext compatibility with old app (fresh start)
- MMKV API: `createMMKV()`, `remove()` not `delete()`
- All crypto is synchronous via Node.js-style quick-crypto APIs
- `@/*` path alias maps to `./src/*`
- expo-sqlite synchronous API (`openDatabaseSync`, `runSync`, `getAllSync`, etc.)
- `expo-file-system/legacy` import required for v19 (cacheDirectory, downloadAsync, etc.)
- Only `operations.data` encrypted in RN (blob fields are now file paths)
- Column name `tbl` in operations table (SQL reserved word avoidance)
- Custom SVG charts (react-native-svg) instead of chart library -- no victory-native/skia needed
- Standard tab navigation (no PagerView swipe-between-tabs)
- FeatureLock.onUpgrade shows toast until RevenueCat is wired in Phase 5
