# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Weightstone Journal (MinimaLog) is a fitness/workout tracking app built with React Native + Expo + TypeScript, using Supabase as the backend. It targets iOS and Android natively.

## Commands

- `npm start` — Start Expo dev server
- `npx expo run:ios` — Build and run on iOS simulator
- `npx expo run:android` — Build and run on Android emulator
- `npm run lint` — Run ESLint

No test framework is configured.

## Architecture

**Stack:** React Native 0.83, Expo SDK 55, TypeScript, NativeWind (Tailwind CSS), Supabase (PostgreSQL + Auth), Expo Router

**Path alias:** `@/*` maps to `src/*`

### Key directories

- `app/` — Expo Router file-based routes. `app/(tabs)/` contains the 5 main tab screens. Dynamic routes use `[param]` syntax.
- `src/components/` — Shared components. `components/ui/` contains React Native UI primitives (View/Text/Pressable-based, styled with NativeWind).
- `src/lib/` — Utilities: `supabase.ts` (auth helpers), `conversions.ts` (unit/1RM math), `prDetection.ts` (PR detection logic), `storage.ts` (Supabase auth storage adapter using expo-secure-store).
- `src/hooks/` — Custom hooks: `use-toast.ts` (Alert.alert wrapper), `use-mobile.tsx` (always returns true).
- `src/hooks/queries/` — TanStack React Query hooks for data fetching.
- `src/contexts/AuthContext.tsx` — Auth state management with Supabase onAuthStateChange.
- `src/integrations/supabase/` — Supabase client and auto-generated TypeScript types. `types.ts` is generated from the DB schema — don't edit by hand.
- `supabase/migrations/` — Database migration SQL files.

### Navigation pattern

The app uses Expo Router with file-based routing. The 5 main tabs (Home, History, Progress, PRs, Profile) are in `app/(tabs)/` with a `Tabs` navigator. Other routes (auth, onboarding, workout session, detail views) are Stack screens defined in `app/_layout.tsx`.

### Data fetching

Pages fetch data using TanStack React Query hooks in `src/hooks/queries/` or direct Supabase queries in `useEffect`. Real-time subscriptions (notifications, feed updates, likes) use `supabase.channel()`.

### Authentication

Auth uses Supabase Auth (email/password) with `AuthProvider` wrapping the app in `app/_layout.tsx`. Sessions persist in expo-secure-store (Keychain/Keystore). Auth helpers are in `src/lib/supabase.ts`.

### Styling

Monochrome design system using NativeWind (Tailwind CSS for React Native). Colors defined in `tailwind.config.ts`. UI components in `src/components/ui/` are lightweight React Native primitives (no third-party UI framework).

## Supabase

Environment variables are in `.env` (prefixed `EXPO_PUBLIC_SUPABASE_*`). The Supabase client is initialized in `src/integrations/supabase/client.ts` with expo-secure-store for auth session storage. Types in `src/integrations/supabase/types.ts` are auto-generated.

## TypeScript

TypeScript is configured with permissive settings (`noImplicitAny: false`, `strictNullChecks: false`). Extends `expo/tsconfig.base`. The `@/*` path alias resolves to `src/*`.
