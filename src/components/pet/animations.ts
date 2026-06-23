/**
 * `usePingPong` — the one shared animation primitive: a normalized 0↔1↔0 value
 * that smoothly oscillates forever. Callers map it onto their own range (scale,
 * translateY, angle, opacity, …).
 *
 * (Whole-body breathe/bobble/sway live in PetStage as View-level transforms;
 * the per-emitter animations live inside each Glow/ component — the rising
 * emitters share their own primitives in Glow/animations.ts.)
 *
 * SVG note: <G> has no transform-origin, so when a caller turns this into a
 * rotation/scale it must express it as a matrix about an explicit pivot.
 */
import { useEffect } from 'react'
import {
  useSharedValue,
  withRepeat,
  withTiming,
  withDelay,
  Easing
} from 'react-native-reanimated'

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
