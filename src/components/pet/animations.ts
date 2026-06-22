/**
 * Reanimated equivalents of the mockup CSS keyframes, applied to SVG <G>
 * groups via animated props. Each hook returns `animatedProps` you spread onto
 * an `Animated.G`. Durations come straight from the mockups.
 *
 * CSS keyframes reproduced here:
 *   glowPulse opacity .82↔1 + scale 1↔1.07
 *   floatUp  particle rise + fade (one-shot, looped with delay)
 *   zfloat   Zzz rise + drift + fade
 *
 * (Whole-body breathe/bobble/sway live in PetStage as View-level transforms.)
 *
 * SVG note: <G> has no transform-origin, so rotation/scale are expressed as a
 * matrix about an explicit pivot (cx, cy) passed by the caller.
 */
import { useEffect } from 'react'
import { useAnimatedProps, useSharedValue, withRepeat, withTiming, withDelay, Easing } from 'react-native-reanimated'

const easeInOut = Easing.inOut(Easing.ease)

/**
 * A normalized 0↔1↔0 value that smoothly oscillates forever (a "ping-pong").
 * `durationMs` is the *full* round-trip; it's halved internally because the
 * yoyo (`withRepeat(..., -1, true)`) replays the 1→0 return leg for free, so
 * one `withTiming` only needs to cover the 0→1 half. Callers map the returned
 * progress onto their own range (a scale, translateY, angle, opacity, …).
 *
 * `active` (default true) gates the loop: when false the value holds at 0 and
 * no animation runs — used for moods that should sit still (e.g. tired).
 */
export const usePingPong = (durationMs: number, delayMs = 0, active = true) => {
  const progress = useSharedValue(0)
  useEffect(() => {
    if (!active) {
      progress.value = 0 // reset so a later re-activation starts from rest
      return
    }
    progress.value = withDelay(
      delayMs,
      withRepeat(withTiming(1, { duration: durationMs / 2, easing: easeInOut }), -1, true),
    )
  }, [durationMs, delayMs, active, progress])
  return progress
}

/** glowPulse: opacity .82↔1 and scale 1↔1.07 about (cx, cy). */
export const useGlowPulse = (durationMs: number, cx: number, cy: number) => {
  const progress = usePingPong(durationMs)
  return useAnimatedProps(() => {
    const s = 1 + 0.07 * progress.value
    return {
      opacity: 0.82 + 0.18 * progress.value,
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
 *
 * The mockup's CSS `scale()` is about the glyph's own centre; an SVG <G> scale
 * is about the group origin (0,0), which would fling the glyph across the stage
 * since it sits ~166px from the origin. The caller passes the glyph anchor
 * (cx, cy) so we scale about it (translate→scale→translate-back), keeping the
 * letters put beside the head — matching the mockup.
 */
export const useZFloat = (durationMs: number, delayMs: number, cx: number, cy: number) => {
  const t = useSharedValue(0)
  useEffect(() => {
    t.value = withDelay(delayMs, withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false))
  }, [durationMs, delayMs, t])
  return useAnimatedProps(() => {
    const y = 8 - 38 * t.value // +8 → -30
    const x = 16 * t.value
    const s = 0.7 + 0.45 * t.value
    const opacity = t.value < 0.25 ? t.value / 0.25 : 1 - (t.value - 0.25) / 0.75
    return {
      opacity,
      transform: `translate(${x} ${y}) translate(${cx} ${cy}) scale(${s}) translate(${-cx} ${-cy})`,
    }
  })
}
