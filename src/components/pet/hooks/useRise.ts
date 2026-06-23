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
 * A normalized 0→1 ramp that waits `delayMs`, then repeats forever (no yoyo —
 * each cycle snaps back to 0 and rises again). Drives the rising-and-fading
 * emitters; `delayMs` staggers sibling emitters out of phase.
 */
const useRise = (durationMs: number, delayMs: number) => {
  const progress = useSharedValue(0)

  useEffect(() => {
    progress.value = withDelay(
      delayMs,
      withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false),
    )
  }, [durationMs, delayMs, progress])

  return progress
}

export default useRise
