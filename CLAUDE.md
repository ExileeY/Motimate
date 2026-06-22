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

There is no test runner, linter, or build script configured — verification is manual (run the app on a device). See the "Verification" section of [plan.md](plan.md).

**Device requirements:** iOS step data works in Expo Go (real pedometer via `expo-sensors` `Pedometer`). The iOS Simulator has no pedometer, so the app reports `unavailable` and renders a resting state. Android real step data needs Health Connect (a dev build, not Expo Go) and is **not yet wired** — Android currently reports `unavailable` by design.

## Architecture

Motimate is a single-screen Expo app: an **anti-nagging movement companion** whose home screen *is* a virtual pet (Mochi the cat) whose mood is **inverted** from typical fitness apps — fewer steps → energetic pet ("Walk with me?"); moderate steps → calm; many steps → tired/asleep ("All worn out"), because rest is framed as the reward.

The entire UI flows from **one source of truth**:

```
useDailySteps()  →  { steps, mood, progress, permission, loading, error }
                         │
        StepsConvertor.toMood(steps) / toProgress(steps)
                         │
   mood (enum) fans out to every component via Record<Mood, …> lookup tables:
     PhoneCanvas (background gradient) · TopBar (status dot) · PetStage→Mochi/Glow
     (pose + animation) · MovementCard (bar %) · messages.ts (headline/subtitle)
```

Key conventions:

- **`Mood` is a 3-value string enum** (`ENERGETIC`/`CALM`/`TIRED`) used both as a runtime value and as the key type for `Record<Mood, …>` tables. To add per-mood behavior, add an entry to the relevant table (gradients in `tokens.ts`, messages in `messages.ts`, glow/dot specs in `tokens.ts`) — don't branch on mood ad hoc.
- **All step→state conversion lives in `StepsConvertor`** ([src/mood/mood.ts](src/mood/mood.ts)). Thresholds are a single `MOOD_MAX` map; `GOAL` drives the progress bar. This is the only place that maps numbers to moods.
- **Platform pedometer access is behind one `StepSource` interface** ([src/steps/stepSource.ts](src/steps/stepSource.ts)) — `requestPermission` / `getTodaySteps` / `subscribe`. The screen never branches on OS. A real Android (Health Connect) implementation just has to satisfy this interface and replace `unavailableSource`.
- **Failure is state, never a throw.** `useDailySteps` surfaces denied/unavailable permission and errors as fields; the screen degrades to a resting pet + a small notice instead of crashing.

### Pet rendering (the deliberate technical choice)

Pets are hand-authored in **`react-native-svg`**, not RN `View`s. The source mockups use `radial-gradient`, `filter:blur`, and elliptical `border-radius` — none supported by RN StyleSheet — which map **1:1** onto SVG `<RadialGradient>`, `<feGaussianBlur>`, `<Ellipse>`/`<Path>`. The rest of the screen (layout, text, linear-gradient backgrounds) uses plain RN + `expo-linear-gradient`. When editing pet visuals, read exact values from the reference mockups rather than eyeballing.

- [Mochi/](src/components/pet/Mochi/) — the cat in SVG; takes a `mood` prop. `index.tsx` renders the mood-independent body (head/ears/tail/feet, with `roundedBoxPath` from [svgPath.ts](src/components/pet/svgPath.ts) for asymmetric per-corner radii); [Face.tsx](src/components/pet/Mochi/Face.tsx) renders the per-mood face (eyes/mouth/cheeks differ per mood) and composes the small `FaceItems/` primitives (`Arc`, `Cheek`, `RoundEye`). Animatable parts are separate named `<G>` groups.
- [PetStage.tsx](src/components/pet/PetStage.tsx) — composes Glow + Mochi and drives **whole-body** motion (bob/breathe/sway) with cheap View-level Reanimated transforms (matches the mockup, which transforms the wrapper). [animations.ts](src/components/pet/animations.ts) holds only the shared `usePingPong` primitive (a 0↔1↔0 oscillator that PetStage and the Glow halo build on); each `Glow/` emitter's own animation hook lives inline in its component.
- [Glow/](src/components/pet/Glow/) — radial halo + mood-driven emitters, split into `Halo.tsx`, `Particles.tsx` (energetic), `Zzz.tsx` (tired), composed in `index.tsx`.

### Reanimated 4 / babel

This uses **Reanimated 4.1** (SDK 54). The babel plugin is `react-native-worklets/plugin` (not the old `react-native-reanimated/plugin`) and **must stay last** in [babel.config.js](babel.config.js). `app/_layout.tsx` imports `react-native-reanimated` first.

### Source layout

- `app/` — expo-router screens (`_layout.tsx` root, `index.tsx` is the only screen / the whole app).
- `src/mood/` — `mood.ts` (Mood enum + StepsConvertor), `messages.ts` (per-mood text).
- `src/steps/` — `stepSource.ts` (platform adapter), `useDailySteps.ts` (the hook).
- `src/theme/` — `tokens.ts` (colors, fonts, per-mood gradients/glow/dot, verbatim from mockups), `fonts.ts` (Fredoka + Nunito loading; UI is gated on `useAppFonts()`).
- `src/components/` — `PhoneCanvas`, `TopBar`, `MovementCard`, and `pet/` (`Mochi/`, `Face.tsx`, `FaceItems/`, `svgPath.ts`, `PetStage.tsx`, `animations.ts`, `Glow/`).
- `@/*` path alias → `./src/*` (tsconfig).

### Design source of truth

The mockups in `/Users/danila/Downloads/Mockups/` (HTML "deck" presentation slides, not app code) define the exact palette, fonts (Fredoka/Nunito), gradients, and animation keyframes. Values in `tokens.ts` are lifted verbatim from `Mockups/Emotions/Mochi/{happy,calm,tired}.dc.html`. When changing visuals, diff against these. [plan.md](plan.md) is the detailed implementation spec and records the design decisions; consult it before larger changes.
