/**
 * useDailySteps — the app's single source of movement truth.
 *
 * Asks for permission, fetches today's step count, then subscribes to live
 * updates. Derives `mood` and `progress` via StepsConvertor so consumers get
 * everything they need from one hook. Failure modes (denied permission, no
 * pedometer) are surfaced as state, never thrown — the UI degrades gracefully.
 */
import { useEffect, useState } from 'react'
import { Mood, StepsConvertor } from '@/mood/mood'
import { stepSource, type PermissionState } from '@/steps/stepSource'

export interface DailySteps {
  steps: number
  mood: Mood
  progress: number // 0..1
  permission: PermissionState | 'pending'
  /** True until permission + first reading resolve. */
  loading: boolean
  error: string | null
}

export const useDailySteps = (): DailySteps => {
  const [permission, setPermission] = useState<PermissionState | 'pending'>('pending')
  const [steps, setSteps] = useState(0)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let unsubscribe: (() => void) | undefined
    let active = true

    ;(async () => {
      try {
        const state = await stepSource.requestPermission()
        if (!active) return
        setPermission(state)

        if (state !== 'granted') {
          setLoading(false)
          return
        }

        const initial = await stepSource.getTodaySteps()
        if (!active) return
        setSteps(initial)
        setLoading(false)

        unsubscribe = stepSource.subscribe((next) => {
          if (active) setSteps(next)
        })
      } catch (e) {
        if (!active) return
        setError(e instanceof Error ? e.message : 'Could not read movement data.')
        setLoading(false)
      }
    })()

    return () => {
      active = false
      unsubscribe?.()
    }
  }, [])

  return {
    steps,
    mood: StepsConvertor.toMood(steps),
    progress: StepsConvertor.toProgress(steps),
    permission,
    loading,
    error,
  }
}
