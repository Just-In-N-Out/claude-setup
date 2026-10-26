# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MinimaLog is a mobile-first workout journal built with React, Vite, and Capacitor. It's designed as an **offline-first** application that works seamlessly without internet connectivity, syncing to Supabase when online. The app targets iOS primarily with Android support.

## Expo Migration (In Progress)

MinimaLog is being migrated to **Expo + React Native** in a fresh project at `/Users/justin/Documents/minimalog-rn/`. See `EXPO_MIGRATION_PLAN.md` for the full plan.

**Status:** Phase 1 (Project Scaffold & Foundation) complete. Phase 2 (Storage & Sync Engine) next.

**Key differences in RN project:**
- `react-native-mmkv` (`createMMKV()`) replaces localStorage/sessionStorage
- `react-native-quick-crypto` (Node.js-style `createCipheriv`) replaces WebCrypto
- `@react-native-community/netinfo` replaces Capacitor Network plugin
- `eventemitter3` replaces `window.dispatchEvent`/`CustomEvent`
- `expo-router` (file-based) replaces React Router v6
- `nativewind` v4 replaces Tailwind CSS (concrete color values, no CSS variables)
- `lucide-react-native` replaces `lucide-react`
- All crypto functions are synchronous (return `Buffer` not `CryptoKey`)
- Path alias `@/*` maps to `./src/*`
- Env vars use `EXPO_PUBLIC_*` prefix (not `VITE_*`)

## Development Commands

### Local Development
```bash
# Start Vite dev server (web development)
npm run dev

# Start with network host access (for testing on devices)
npm run dev:host
```

### Building
```bash
# Production build
npm run build

# Development build (includes sourcemaps, no console removal)
npm run build:dev
```

### iOS Development
```bash
# Sync web assets to iOS project
npm run ios:sync
# Equivalent: export LANG=en_US.UTF-8 && npx cap sync ios

# Open Xcode
npm run ios:open

# Full dev workflow (starts dev server, syncs, opens Xcode)
npm run ios:dev
```

### Android Development
```bash
# Sync web assets to Android project
npm run android:sync

# Open Android Studio
npm run android:open
```

### Linting
```bash
npm run lint
```

### Supabase Local Development
```bash
# Start local Supabase (requires Docker)
npx supabase start

# Stop local Supabase
npx supabase stop

# Push migrations to remote
npx supabase db push

# Create new migration
npx supabase migration new <migration_name>

# Connect to remote DB
npx supabase db remote exec "SELECT ..."

# Query specific function definition
npx supabase db remote exec "SELECT pg_get_functiondef(oid) FROM pg_proc WHERE proname = '<function_name>' AND pronamespace = 'public'::regnamespace;"
```

## Architecture Overview

### Offline-First Pattern: "Queue, Cache, Sync"

The app uses a three-layer architecture:

1. **Optimistic UI Layer**: All user actions update local state immediately using `React.startTransition`. Users see instant feedback regardless of network conditions.

2. **IndexedDB Storage Layer**: Nine object stores handle different aspects:
   - `workouts`: Complete denormalized workout state (includes exercises array)
   - `operations`: Encrypted append-only queue of pending mutations
   - `exercises`, `templates`, `prHistory`, `workout_history`: Read caches
   - `pendingPosts`: Social posts with image blobs awaiting upload
   - `avatar_cache`, `exercise_images`: Blob storage for offline media
   - `pendingImageDownloads`: Background download queue

3. **Sync Engine Layer**: Processes the operations queue sequentially, resolving temporary IDs to real UUIDs as it syncs with Supabase. Uses last-write-wins conflict resolution.

### Data Flow: UI → Local → Supabase

```
User action
  ↓
Optimistic UI update (immediate)
  ↓
Offline? → Queue operation in IndexedDB → Sync when network restores
Online?  → Direct Supabase mutation → Update with real ID
```

### Temp ID Resolution

Local operations use temporary IDs (e.g., `temp-ex-1234`) that get mapped to real UUIDs during sync:

```typescript
// Operation created offline
{ id: "temp-ex-1234", exercise_id: "uuid-abc" }
  ↓
// After sync, ID map built
"temp-ex-1234" → "uuid-xyz"
  ↓
// Subsequent operations automatically resolve
{ workout_exercise_id: "temp-ex-1234" }
  → { workout_exercise_id: "uuid-xyz" }
```

When deleting optimistic items, remove all queued operations referencing those temp IDs to prevent orphaned operations.

### State Management Philosophy

**No global state for workout data**—intentionally isolated in component-local state to prevent cross-component interference during active workout sessions.

- **Zustand**: Only for global app state (network status, debug flags)
- **TanStack Query**: For read queries (workout history, exercise library, user profiles)
  - `staleTime: 60s`, `gcTime: 5 minutes`
  - `refetchOnWindowFocus: false` (battery savings)
  - `refetchOnReconnect: true` (sync on network restore)
- **Component State**: For active workout session (fine-grained control needed)

### Authentication & Session Management

**OAuth Flow:**
- Native platforms use custom URL scheme: `com.minimalog.app://auth/callback`
- Web platforms use standard `/auth/callback` redirect
- URL validation whitelist: `/auth/reset`, `/auth/callback`, `/auth`
- PKCE flow requires code_verifier in same storage context (critical for native)

**Session Caching (Three-layer fallback):**
```typescript
getCachedUserId():
  1. Try JSON parse (unencrypted format)
  2. Try decryption (encrypted format - primary)
  3. Use raw string (legacy fallback)
  4. Emergency: 'emergency_user_id' in localStorage
```

This complexity handles WebCrypto unavailability in iOS WebView and enables offline mode with user ID available but no session token.

### Encryption Strategy

**Three encryption layers:**

1. **Session Tokens**: AES-GCM encrypted in localStorage (256-bit key)
2. **IndexedDB Sensitive Fields**: Selective encryption of `operations.data`, `user_profile.email`, blob fields
3. **Supabase Storage**: Managed server-side encryption

**Key Derivation:**
```
User ID → PBKDF2 (100k iterations) → SHA-256 salt → AES-GCM key
```

**Tradeoffs**: Deterministic keys (same user = same key) enable offline functionality without key storage, but less secure than random keys. No key rotation supported.

**Migration Support**: Detects unencrypted data and encrypts on next write. Falls back gracefully if WebCrypto unavailable.

### Subscription & Monetization

MinimaLog uses **RevenueCat** for subscription management with a freemium model:

**Tiers:**
- **Free**: Unlimited workouts, 1 template, limited features
- **Premium**: $1.99/week (no trial), $4.99/month (7-day trial), $39.99/year (7-day trial)

**Infrastructure:**
- `src/lib/revenuecat.ts`: RevenueCat SDK wrapper (iOS only via Capacitor plugin)
- `src/lib/subscriptionStore.ts`: Zustand store for subscription state
- `src/lib/subscriptionHelpers.ts`: Helper functions for limit checks
- `src/hooks/useSubscription.ts`: React hook exposing `{ isPremium, canCreateWorkout, workoutCountThisMonth, ... }`

**Database Schema:**
- `profiles` table: Added `subscription_tier`, `subscription_expires_at`, `trial_ends_at`, etc.
- `monthly_usage` table: Tracks workout counts per user per month (format: 'YYYY-MM')
- Trigger: Auto-increments `workout_count` on workout creation
- RLS Policies: Server-side enforcement of premium features (post creation, template limits)

**Feature Gating Pattern:**
```typescript
const { isPremium, canCreateWorkout } = useSubscription();
const [showPaywall, setShowPaywall] = useState(false);

if (!canCreateWorkout) {
  setShowPaywall(true);
  return;
}

<Paywall open={showPaywall} onClose={() => setShowPaywall(false)} feature="Unlimited Workouts" />
```

**Key Components:**
- `Paywall`: Purchase flow with 3 pricing tiers
- `FeatureLock`: Blur overlay for locked features
- `SubscriptionBadge`: Premium/Trial/Free badges
- `SubscriptionSettings`: Full management page at `/subscription`

**Offline Considerations:**
- Subscription status cached in Zustand store
- Syncs with RevenueCat on app foreground (when online)
- Falls back to Supabase `profiles.subscription_tier` for web platform
- Webhook syncs RevenueCat events → Supabase for server-side validation

**Implementation Status:**
- ✅ Phase 1 (Foundation) - Complete
- ✅ Phase 2 (Paywall UI) - Complete (using RevenueCat native paywall)
- ✅ Phase 3 (Feature Gating) - Complete
- ✅ Phase 4 (Webhook) - Complete & deployed
- ⏳ Phase 5 (Testing) - In progress (purchase flow debugging needed)
- See `REVENUECAT_IMPLEMENTATION_PLAN.md` and `SUBSCRIPTION_IMPLEMENTATION_SUMMARY.md` for full details

**Recent Changes:**
- Posts are now FREE for all users (not paywalled)
- Weekly subscription has NO trial (only monthly & yearly have 7-day trials)
- Workout deletion decrements monthly counter (migration: `20251117000000_decrement_workout_on_delete.sql`)
- Paywall shows after onboarding loading screen
- Exercise images reduced in size during workout session
- **Workouts are now UNLIMITED for all users (free and premium)** - Only templates are limited
- Fixed RevenueCat paywall to use `RevenueCatUI.presentPaywall()` from `@revenuecat/purchases-capacitor-ui`
- Added duplicate paywall prevention with `useRef` to prevent multiple simultaneous presentations
- Updated SubscriptionSettings page with compelling feature comparison table
- Added subscription status display in ProfileSettings above username
- Applied FeatureLock overlay pattern to History page (matching Progress page)

### Workout Session Lifecycle

**Start:**
- Create workout record in Supabase (or queue if offline)
- Navigate to `/workout/:id`
- Load exercises, sets, and last session data for prefill

**During (Hot Path):**
- **Add exercise**: Optimistic insert → Create workout_exercise → Fetch last session data
- **Add set**: Optimistic add with temp ID → Prefill from last session → User edits → Insert set
- **Edit set**: Debounced 400ms to aggregate rapid changes → Single update operation

**Complete:**
- Update `ended_at` timestamp
- Calculate session metrics (volume, duration)
- Async PR detection
- Navigate to workout detail

### Offline vs Online Modes

**Offline:**
- IndexedDB is source of truth
- Denormalized data (workouts contain exercises inline)
- Updates modify entire workout document
- Sync reconciles with normalized Supabase schema

**Online:**
- Queries Supabase directly
- Fallback to IndexedDB if empty (handles race conditions during sync)
- Enrichment: Fetches `image_url` separately if missing

### Network Detection

- **Zustand store** tracks connection via Capacitor Network plugin (native) or `navigator.onLine` (web)
- Only truly offline connections trigger offline mode
- Slow connections (3G) still use Supabase with loading states
- Debug toggle: `useNetworkStore.setDebugOfflineMode(true)`

## Key File Locations

### Core Application
- `src/main.tsx`: App entry point, React Query setup
- `src/App.tsx`: Root component, routing, network listeners
- `src/lib/session.ts`: Session management, encryption, user ID caching
- `src/lib/auth-config.ts`: OAuth configuration, URL validation

### Offline/Sync System
- `src/lib/db/indexedDB.ts`: IndexedDB schema and operations
- `src/lib/db/operationQueue.ts`: Queue management for pending mutations
- `src/lib/sync/syncEngine.ts`: Sync logic, temp ID resolution, conflict handling
- `src/lib/network.ts`: Network detection and state management
- `src/lib/crypto.ts`: Encryption/decryption utilities
- `src/lib/db/encryptedStorage.ts`: Encrypted IndexedDB wrapper

### Workout Session
- `src/pages/WorkoutSession/index.tsx`: Main workout session component
- `src/pages/WorkoutSession/hooks/useWorkoutData.ts`: Data loading, prefill logic
- `src/pages/WorkoutSession/hooks/useExerciseOperations.ts`: Add/delete/reorder exercises
- `src/pages/WorkoutSession/hooks/useSetOperations.ts`: Add/update/delete sets (debounced writes)
- `src/pages/WorkoutSession/hooks/useWorkoutCompletion.ts`: Metrics, PR detection

### Subscription System
- `src/lib/revenuecat.ts`: RevenueCat SDK wrapper and purchase methods (uses named import)
- `src/lib/subscriptionStore.ts`: Zustand store for subscription state (includes `setIsPremium` for web)
- `src/lib/subscriptionHelpers.ts`: Limit checks and usage tracking
- `src/hooks/useSubscription.ts`: React hook for subscription access
- `src/components/Paywall.tsx`: RevenueCat native paywall wrapper (~90 lines, refactored from custom UI)
- `src/components/FeatureLock.tsx`: Locked feature overlay component
- `src/components/SubscriptionBadge.tsx`: Premium/Trial/Free badges
- `src/pages/SubscriptionSettings.tsx`: Subscription management page
- `src/pages/LoadingScreen.tsx`: Shows paywall after onboarding (8-second animation)

### Supabase
- `supabase/migrations/`: SQL migrations (chronological)
  - `20251116000003_add_subscriptions.sql`: Subscription tables and RLS policies
  - `20251117000000_decrement_workout_on_delete.sql`: Decrement workout count on deletion
- `supabase/functions/`: Edge Functions
  - `generate-ai-tips/`: AI-powered workout tips
  - `delete-post/`: Post deletion handler
  - `cleanup-stale-workouts/`: Maintenance job
  - `generate-workout-suggestions/`: AI workout recommendations
  - `process-avatar/`: Avatar image processing
  - `revenuecat-webhook/`: ✅ RevenueCat webhook handler (deployed to production)

### Configuration
- `capacitor.config.ts`: Capacitor native config, debug mode control
- `vite.config.ts`: Build config, code splitting, Terser optimization
- `tsconfig.json`: TypeScript config with path aliases (`@/*`)

## Important Development Notes

### Path Aliases
Use `@/` prefix for all imports from `src/`:
```typescript
import { supabase } from '@/lib/supabase'
import { Button } from '@/components/ui/button'
```

### TypeScript Configuration
The project uses relaxed TypeScript settings for rapid development:
- `noImplicitAny: false`
- `strictNullChecks: false`
- `noUnusedLocals: false`

Be mindful of potential type safety issues.

### Platform Detection
```typescript
import { Capacitor } from '@capacitor/core'

if (Capacitor.isNativePlatform()) {
  // Native iOS/Android
} else {
  // Web browser
}
```

### Debounced Operations
When updating sets or other frequently-changed data, use 400ms debounce to aggregate rapid changes into single operations. See `useSetOperations.ts` for pattern.

### IndexedDB Encryption
When adding new sensitive fields to IndexedDB:
1. Mark with `{ _encrypted: true, value: ... }` structure
2. Use `encryptValue()` before storage
3. Use `decryptValue()` when reading
4. Update `recordNeedsEncryption()` for migration support

### Capacitor Native Features

**iOS-specific:**
- WKWebView debugging disabled in production (security)
- Data Protection capability should be enabled in Xcode for production
- Custom URL scheme must match `Info.plist`

**Network Plugin:**
- Reports connection type: wifi, cellular, 3g, 4g, 5g, none
- iOS quirk: All cellular connections reported as 'cellular' (no sub-type)
- Fires `networkStatusChange` events (500ms debounce)

### Supabase Edge Functions

Edge functions are in TypeScript (Deno runtime). When testing locally:
```bash
npx supabase functions serve
```

Shared code in `supabase/functions/_shared/` is imported using relative paths.

### Build Optimization

The production build uses aggressive Terser minification:
- Removes all `console.*` statements except errors/warnings
- Two-pass compression
- Manual code splitting for optimal caching (vendor chunks)
- 600KB chunk size warning limit

For debugging production issues, use `npm run build:dev` to preserve console logs and sourcemaps.

### Security Considerations

**URL Validation:**
All OAuth/auth redirects are validated against whitelist. When adding new auth flows, update the whitelist in `src/lib/auth-config.ts`.

**Debug Mode:**
Debug mode is controlled by `NODE_ENV` and `BUILD_ENV`. Never deploy with debug enabled:
- Web debugging in iOS/Android
- Console output in production builds

**Encryption Keys:**
Keys are derived from user IDs. Never log or expose:
- Decrypted session tokens
- Raw encryption keys
- User email addresses

### Common Patterns

**Adding a new IndexedDB store:**
1. Update schema version in `indexedDB.ts`
2. Add store creation in `onUpgrade`
3. Create typed accessor functions
4. Update `clearAllData()` for logout cleanup

**Adding a new queued operation:**
1. Create optimistic UI update
2. Queue operation with `queueOperation()`
3. Handle temp ID if needed
4. Update sync engine to process new operation type
5. Add rollback logic for failures

**Adding a new Supabase table:**
1. Create migration SQL in `supabase/migrations/`
2. Add RLS policies (Row Level Security)
3. Update TypeScript types
4. Add IndexedDB cache store if needed for offline
5. Update sync engine if table participates in sync

## Testing Notes

**Network Conditions:**
Toggle debug offline mode in app settings or via:
```typescript
useNetworkStore.getState().setDebugOfflineMode(true)
```

**Clearing Local Data:**
Use app settings → "Clear All Local Data" or manually clear IndexedDB in browser DevTools.

**Inspecting Operation Queue:**
Open IndexedDB in browser DevTools → `minimalog_db` → `operations` store to see queued operations.

**iOS Simulator:**
Use Xcode's Network Link Conditioner to simulate poor connectivity (3G, Edge, etc.).

## Environment Variables

Required in `.env`:
```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_REVENUECAT_IOS_API_KEY=your-revenuecat-key  # For subscription management (iOS)
GOOGLE_GEMINI_API_KEY=your-gemini-api-key        # For AI tips and suggestions
```

Optional:
```
NODE_ENV=development|production
BUILD_ENV=development|production
VITE_ENABLE_AUTO_SYNC=false  # Disable auto-sync for TestFlight testing
```

## Performance Optimizations

The codebase includes several performance optimizations:
- **Lazy route loading**: Reduces initial bundle size 15-30%
- **Database-level filtering**: Inner joins vs client-side filtering saves 40-50% data transfer
- **Parallel Promise.all**: Sets loaded concurrently per exercise
- **React.startTransition**: Non-blocking UI updates during sync
- **Image blob caching**: Prevents repeated downloads
- **Debounced network detection**: 500ms prevents rapid toggling

When adding new features, maintain these patterns to preserve app responsiveness.
- Make sure to ask questions in case you are not sure how to implement certain features in a yes/no format or simple answer
- makes sure to approach every feature implementation witha  security first mindset
- Make sure to sync the project after every change npx cap sync ios