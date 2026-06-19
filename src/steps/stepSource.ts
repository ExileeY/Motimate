/**
 * Platform pedometer adapter. The rest of the app talks to this single
 * interface and never branches on OS.
 *
 *   requestPermission() → ask the user for motion access
 *   getTodaySteps()     → steps since local midnight (one-shot)
 *   subscribe(cb)        → live updates as the user walks; returns unsubscribe
 *
 * iOS: backed by expo-sensors `Pedometer` — `getStepCountAsync` gives today's
 *      total, `watchStepCount` streams deltas since subscription which we add
 *      on top of that baseline.
 *
 * Android: real step data needs Health Connect (`react-native-health-connect`),
 *      which requires a dev build — NOT Expo Go. Until that's wired, Android
 *      reports `unavailable` so the UI shows a clear message instead of crashing.
 *      The interface below is exactly what a Health Connect impl will satisfy.
 */
import { Platform } from 'react-native'
import { Pedometer } from 'expo-sensors'

export type PermissionState = 'granted' | 'denied' | 'unavailable'

export interface StepSource {
  requestPermission(): Promise<PermissionState>
  getTodaySteps(): Promise<number>
  subscribe(onSteps: (steps: number) => void): () => void
}

const startOfToday = (): Date => {
  const d = new Date()
  d.setHours(0, 0, 0, 0)
  return d
}

const iosSource: StepSource = {
  async requestPermission() {
    const available = await Pedometer.isAvailableAsync().catch(() => false)
    if (!available) return 'unavailable'
    const res = await Pedometer.requestPermissionsAsync()
    return res.granted ? 'granted' : 'denied'
  },

  async getTodaySteps() {
    const { steps } = await Pedometer.getStepCountAsync(startOfToday(), new Date())
    return steps
  },

  subscribe(onSteps) {
    // watchStepCount streams steps accrued *since subscription*; combine with
    // the day's baseline so callers always receive today's running total.
    let baseline = 0
    let cancelled = false

    Pedometer.getStepCountAsync(startOfToday(), new Date())
      .then((r) => {
        baseline = r.steps
        if (!cancelled) onSteps(baseline)
      })
      .catch(() => {
        /* baseline stays 0; live deltas still flow */
      })

    const sub = Pedometer.watchStepCount(({ steps }) => {
      onSteps(baseline + steps)
    })

    return () => {
      cancelled = true
      sub.remove()
    }
  },
}

/** Android / web / anything without a pedometer: cleanly unavailable. */
const unavailableSource: StepSource = {
  async requestPermission() {
    return 'unavailable'
  },
  async getTodaySteps() {
    return 0
  },
  subscribe() {
    return () => {}
  },
}

export const stepSource: StepSource =
  Platform.OS === 'ios' ? iosSource : unavailableSource
