/**
 * Reanimated equivalents of the mockup CSS keyframes, applied to SVG <G>
 * groups via animated props. Each hook returns `animatedProps` you spread onto
 * an `Animated.G`. Durations come straight from the mockups.
 *
 * CSS keyframes reproduced here:
 *   breathe  scale 1 ↔ 1.035
 *   bob      translateY 0 ↔ -9
 *   sway     rotate -2.6° ↔ 2.6°   (transform-origin: bottom center)
 *   glowPulse opacity .82↔1 + scale 1↔1.07
 *   floatUp  particle rise + fade (one-shot, looped with delay)
 *   zfloat   Zzz rise + drift + fade
 *
 * SVG note: <G> has no transform-origin, so rotation/scale are expressed as a
 * matrix about an explicit pivot (cx, cy) passed by the caller.
 */
import { useEffect } from 'react'
import { useAnimatedProps, useSharedValue, withRepeat, withTiming, withDelay, Easing } from 'react-native-reanimated'

const easeInOut = Easing.inOut(Easing.ease)

/** A 0↔1↔0 triangle wave on a shared value, looping forever. */
const usePulse = (durationMs: number, delayMs = 0) => {
  const v = useSharedValue(0)
  useEffect(() => {
    v.value = withDelay(
      delayMs,
      withRepeat(withTiming(1, { duration: durationMs / 2, easing: easeInOut }), -1, true),
    )
  }, [durationMs, delayMs, v])
  return v
}

/** breathe: uniform scale about (cx, cy). */
export const useBreathe = (durationMs: number, cx: number, cy: number) => {
  const p = usePulse(durationMs)
  return useAnimatedProps(() => {
    const s = 1 + 0.035 * p.value
    return { transform: `translate(${cx} ${cy}) scale(${s}) translate(${-cx} ${-cy})` }
  })
}

/** bob: vertical translate 0 → -9. */
export const useBob = (durationMs: number) => {
  const p = usePulse(durationMs)
  return useAnimatedProps(() => ({ transform: `translate(0 ${-9 * p.value})` }))
}

/** sway: rotate ±deg about a bottom-center pivot. */
export const useSway = (durationMs: number, deg: number, cx: number, cy: number) => {
  const p = usePulse(durationMs)
  return useAnimatedProps(() => {
    const angle = -deg + 2 * deg * p.value // -deg → +deg
    return { transform: `rotate(${angle} ${cx} ${cy})` }
  })
}

/** glowPulse: opacity .82↔1 and scale 1↔1.07 about (cx, cy). */
export const useGlowPulse = (durationMs: number, cx: number, cy: number) => {
  const p = usePulse(durationMs)
  return useAnimatedProps(() => {
    const s = 1 + 0.07 * p.value
    return {
      opacity: 0.82 + 0.18 * p.value,
      transform: `translate(${cx} ${cy}) scale(${s}) translate(${-cx} ${-cy})`,
    }
  })
}

/**
 * floatUp: a particle that rises ~40px while fading in then out, repeating.
 * Drives a single <G>; caller positions it. `delayMs` staggers particles.
 */
export const useFloatUp = (durationMs: number, delayMs: number) => {
  const t = useSharedValue(0)
  useEffect(() => {
    t.value = withDelay(delayMs, withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false))
  }, [durationMs, delayMs, t])
  return useAnimatedProps(() => {
    // opacity: 0 → 1 (by 28%) → 0 ; translateY: +10 → -40 ; scale .6 → 1
    const y = 10 - 50 * t.value
    const s = 0.6 + 0.4 * t.value
    const opacity = t.value < 0.28 ? t.value / 0.28 : 1 - (t.value - 0.28) / 0.72
    return { opacity, transform: `translate(0 ${y}) scale(${s})` }
  })
}

/**
 * zfloat: a "Z" that rises ~30px, drifts +16px right, scales .7 → 1.15, fading.
 */
export const useZFloat = (durationMs: number, delayMs: number) => {
  const t = useSharedValue(0)
  useEffect(() => {
    t.value = withDelay(delayMs, withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false))
  }, [durationMs, delayMs, t])
  return useAnimatedProps(() => {
    const y = 8 - 38 * t.value // +8 → -30
    const x = 16 * t.value
    const s = 0.7 + 0.45 * t.value
    const opacity = t.value < 0.25 ? t.value / 0.25 : 1 - (t.value - 0.25) / 0.75
    return { opacity, transform: `translate(${x} ${y}) scale(${s})` }
  })
}
