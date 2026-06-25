# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

> Note: AGENTS.md points at the Expo v56 docs, but this project is pinned to **Expo SDK 54** (`expo: ~54.0.35` in package.json). Read the docs that match the installed SDK — https://docs.expo.dev/versions/v54.0.0/ — when the two disagree.

## Commands

```bash
npm start          # expo start — load on a physical device via Expo Go
npm run ios        # expo start --ios
npm run android    # expo start --android
npm run web        # expo start --web
npx tsc --noEmit   # typecheck (strict mode is on; there is no lint/test setup)
```

There is no test runner, linter, or build script configured — verification is manual (run the app on a device).

**Verifying mood visuals without walking:** in dev builds (`__DEV__`), tapping the pet cycles `ENERGETIC → CALM → TIRED` ([app/index.tsx:30-33](app/index.tsx#L30-L33)). The override is local UI state layered over live `useDailySteps()`, so you can preview every mood's gradient/face/glow on a Simulator that has no pedometer.

**Device requirements:** iOS step data works in Expo Go (real pedometer via `expo-sensors` `Pedometer`). The iOS Simulator has no pedometer, so the app reports `unavailable` and renders a resting state. Android real step data needs Health Connect (a dev build, not Expo Go) and is **not yet wired** — Android currently reports `unavailable` by design.

## Architecture

Motimate is an Expo app: an **anti-nagging movement companion** whose home screen *is* a virtual pet (one of six interchangeable pets — Mochi, Bulbashik, Dog, Octopus, Arutic, Khinklear; one is active at a time) whose mood is **inverted** from typical fitness apps — fewer steps → energetic pet ("Walk with me?"); moderate steps → calm; many steps → tired/asleep ("All worn out"), because rest is framed as the reward. There are two routes: the home screen ([app/index.tsx](app/index.tsx)) and a Settings screen ([app/settings.tsx](app/settings.tsx)) for the daily steps goal.

The entire home UI flows from **one source of truth**:

```
useDailySteps()  →  { steps, mood, progress, permission, loading, error }
                         │            (reads the active goal from GoalContext)
        StepsConvertor.toMood(steps, goal) / toProgress(steps, goal)
                         │
   mood (enum) fans out to every component via Record<Mood, …> lookup tables:
     PhoneCanvas (background gradient) · TopBar (status dot) · PetStage→pet/Glow
     (pose + animation) · MovementCard (bar %) · the active pet's MessageSet
```

Key conventions:

- **`Mood` is a 3-value string enum** (`ENERGETIC`/`CALM`/`TIRED`) used both as a runtime value and as the key type for `Record<Mood, …>` tables. To add per-mood behavior, add an entry to the relevant table (gradients/glow/dot specs in `tokens.ts`, per-pet text in `src/pet/<name>/messages.ts`) — don't branch on mood ad hoc.
- **All step→state conversion lives in `StepsConvertor`** ([src/pet/mood.ts](src/pet/mood.ts)). Thresholds are a single `MOOD_MAX_RATIO` map expressed as **fractions of the goal**, and both `toMood`/`toProgress` take `(steps, goal)`. This is the only place that maps numbers to moods.
- **The daily goal is app-wide state, not a constant.** [src/settings/GoalContext.tsx](src/settings/GoalContext.tsx) (`GoalProvider`/`useGoal`) hydrates the goal from AsyncStorage and persists edits via [src/settings/goalStorage.ts](src/settings/goalStorage.ts) (`GOAL_DEFAULT`/`GOAL_MIN`/`GOAL_MAX`, `normalizeGoal`, `readGoal`/`writeGoal`). `setGoal` clamps + returns the stored value so a UI field can snap to it. The provider wraps the app in `app/_layout.tsx`.
- **The active pet comes from the registry, not a direct import.** [src/pet/registry.ts](src/pet/registry.ts) maps each `PetId` enum value to a `PetDefinition` (`Body` SVG + `pickMessages`) in the `PETS` table; the screen reads the exported `activePet` rather than importing a specific pet. **To add a pet:** build its `Body` (mood-prop SVG) + `messages`, then add one `PETS` entry. **To switch the active pet:** change the single `export const activePet = PETS[PetId.…]` line (currently `KHINKLEAR`). The shared Glow is deliberately *not* part of a pet — it stays pet-agnostic in PetStage.
- **Per-pet copy is randomized once per launch.** `pickMessages(pools)` ([src/pet/messages.ts](src/pet/messages.ts)) picks one `MessageSet` (`headline`/`subtitle`/`meta`/`footer`) per mood from that pet's pools; the home screen calls it once at module load.
- **Platform pedometer access is behind one `StepSource` interface** ([src/steps/stepSource.ts](src/steps/stepSource.ts)) — `requestPermission` / `getTodaySteps` / `subscribe`. The screen never branches on OS. A real Android (Health Connect) implementation just has to satisfy this interface and replace `unavailableSource`.
- **Failure is state, never a throw.** `useDailySteps` surfaces denied/unavailable permission and errors as fields; the screen degrades to a resting pet + a small notice instead of crashing. `GoalContext` mirrors this with a `ready` flag instead of throwing on hydration.
- **Responsive sizing is one clamped scale factor.** [src/hooks/useResponsiveScale.ts](src/hooks/useResponsiveScale.ts) derives a 0.85–1.15 factor from window height (812pt reference) and feeds the pet sizing + heading caps; ~1 at the reference height.

### Pet rendering (the deliberate technical choice)

Pets are hand-authored in **`react-native-svg`**, not RN `View`s. The source mockups use `radial-gradient`, `filter:blur`, and elliptical `border-radius` — none supported by RN StyleSheet — which map **1:1** onto SVG `<RadialGradient>`, `<feGaussianBlur>`, `<Ellipse>`/`<Path>`. The rest of the screen (layout, text, linear-gradient backgrounds) uses plain RN + `expo-linear-gradient`. When editing pet visuals, read exact values from the reference mockups rather than eyeballing.

- Each pet is its own folder ([Mochi/](src/components/pet/Mochi/), [Bulbashik/](src/components/pet/Bulbashik/), and likewise `Dog/`, `Octopus/`, `Arutic/`, `Khinklear/`) exporting a `Body` that takes a `mood` (and optional `size`) prop. `index.tsx` renders the mood-independent body (e.g. for Mochi: head/ears/tail/feet, with `roundedBoxPath` from [svgPath.ts](src/components/pet/svgPath.ts) for asymmetric per-corner radii); `Face.tsx` renders the per-mood face and composes small `FaceItems/` primitives. These split into **cross-pet primitives in [shared/FaceItems/](src/components/pet/shared/FaceItems/)** (`Arc`, `Cheek`; plus `shared/types.ts`'s `OffsetProps`) and **per-pet primitives** in each pet's own `FaceItems/` — every pet carries its own eye primitive (`Mochi/FaceItems/RoundEye`, `Bulbashik/FaceItems/BulbEye`, `Dog/FaceItems/DogEye`, `Octopus/FaceItems/OctopusEye`, `Arutic/FaceItems/AruticEye`, `Khinklear/FaceItems/KhinklEye`). Animatable parts are separate named `<G>` groups.
- [PetStage.tsx](src/components/pet/PetStage.tsx) — composes Glow + the active pet body and drives **whole-body** motion (bob/breathe/sway) with cheap View-level Reanimated transforms (matches the mockup, which transforms the wrapper).
- **Two named animation hooks over one shared core:** [pet/hooks/useLoop.ts](src/components/pet/hooks/useLoop.ts) exports `usePingPong(durationMs, delayMs?, active?)` — a 0↔1↔0 oscillator (breathe/bob/sway/halo pulse; `durationMs` is the full round-trip, halved internally), and `useRise(durationMs, delayMs?)` — a 0→1 ramp that snaps back each cycle (the rising-and-fading emitters, with `delayMs` to stagger siblings). Both are thin wrappers over a private `useRepeatedTiming`; `active: false` (pingpong) holds at 0 so still moods (e.g. tired) sit at rest.
- [Glow/](src/components/pet/Glow/) — radial halo + mood-driven emitters, split into `Halo.tsx`, `Particles.tsx` (energetic), `Zzz.tsx` (tired), composed in `index.tsx`. [Glow/utils.ts](src/components/pet/Glow/utils.ts) holds the `'worklet'` math helpers (`linearInterpolate`, `calcTriangleOpacity`, `calcTransform`) that emitters call inside their animated SVG props.
- Pet sizing is centralized in [src/constants/pet/dimensions.ts](src/constants/pet/dimensions.ts) (`BOX_SIZE` / `PET_SIZE` / `BOX_CENTER`) — read these rather than hard-coding the SVG viewBox or pivot.

### Reanimated 4 / babel

This uses **Reanimated 4.1** (SDK 54). The babel plugin is `react-native-worklets/plugin` (not the old `react-native-reanimated/plugin`) and **must stay last** in [babel.config.js](babel.config.js). `app/_layout.tsx` imports `react-native-reanimated` first.

### Source layout

- `app/` — expo-router screens: `_layout.tsx` (root: `SafeAreaProvider` › `GoalProvider` › `Stack`), `index.tsx` (home), `settings.tsx` (goal editor).
- `src/pet/` — the pet domain: `mood.ts` (Mood enum + StepsConvertor), `messages.ts` (`MessageSet` + `pickMessages`), `registry.ts` (`PetId` enum + `PETS` table + `activePet`), and per-pet message data under `src/pet/<name>/messages.ts` (mochi, bulbashik, dog, octopus, arutic, khinklear). Pet *visuals* live in `src/components/pet/`.
- `src/settings/` — `GoalContext.tsx` (`GoalProvider`/`useGoal`), `goalStorage.ts` (AsyncStorage persistence + bounds).
- `src/steps/` — `stepSource.ts` (platform adapter), `useDailySteps.ts` (the hook).
- `src/hooks/` — `useAppFonts.ts` (Fredoka + Nunito loading; UI is gated on `useAppFonts()`), `useResponsiveScale.ts` (height-driven scale factor).
- `src/components/` — `PhoneCanvas`, `TopBar`, `MovementCard`, and `pet/` (one folder per pet: `Mochi/`, `Bulbashik/`, `Dog/`, `Octopus/`, `Arutic/`, `Khinklear/`, each with `Face.tsx` + a per-pet `FaceItems/`; plus `shared/` for cross-pet `FaceItems/`+`types.ts`, `svgPath.ts`, `PetStage.tsx`, `hooks/useLoop.ts`, `Glow/`).
- `src/constants/` — `tokens.ts` (colors, fonts, per-mood gradients/glow/dot, verbatim from mockups), `pet/dimensions.ts` (SVG box/pet/center sizing).
- `@/*` path alias → `./src/*` (tsconfig).

### Design source of truth

The mockups in `/Users/danila/Downloads/Mockups/` (HTML "deck" presentation slides, not app code) define the exact palette, fonts (Fredoka/Nunito), gradients, and animation keyframes. Values in `tokens.ts` are lifted verbatim from `Mockups/Emotions/Mochi/{happy,calm,tired}.dc.html`. When changing visuals, diff against these.
