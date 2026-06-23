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
 * Private core: a normalized value that repeats forever. `legMs` is the duration
 * of ONE `withTiming` pass; `yoyo` decides whether the repeat replays it in
 * reverse (0↔1↔0) or snaps back to 0 (0→1, 0→1). `active: false` holds at 0 and
 * runs no animation.
 *
 * SVG note: <G> has no transform-origin, so a caller turning this into a
 * rotation/scale must express it as a matrix about an explicit pivot.
 */
const useRepeatedTiming = (legMs: number, delayMs: number, yoyo: boolean, active: boolean) => {
  const progress = useSharedValue(0)

  useEffect(() => {
    if (!active) {
      progress.value = 0 // reset so a later re-activation starts from rest
      return
    }
    progress.value = withDelay(
      delayMs,
      withRepeat(withTiming(1, { duration: legMs, easing: easeInOut }), -1, yoyo),
    )
  }, [legMs, delayMs, yoyo, active, progress])

  return progress
}

export const usePingPong = (durationMs: number, delayMs = 0, active = true) =>
  useRepeatedTiming(durationMs / 2, delayMs, true, active)

export const useRise = (durationMs: number, delayMs = 0) =>
  useRepeatedTiming(durationMs, delayMs, false, true)
