/**
 * GoalContext — the user's daily steps goal as app-wide state.
 *
 * Hydrates the stored goal on mount (falling back to GOAL_DEFAULT), exposes it
 * via useGoal(), and persists every change. `setGoal` normalizes (clamps to
 * GOAL_MIN..GOAL_MAX) and returns the stored value so callers can snap a UI
 * field to it. `ready` flips true once hydration resolves, mirroring the app's
 * "loading is state, never a throw" convention.
 */
import React, {
  createContext,
  useContext,
  useEffect,
  useState
} from 'react'

import {
  GOAL_DEFAULT,
  normalizeGoal,
  readGoal,
  writeGoal
} from '@/goal/goalStorage'

interface GoalContextValue {
  goal: number
  ready: boolean
  setGoal: (value: number) => number
}

const GoalContext = createContext<GoalContextValue | null>(null)

export const GoalProvider = ({ children }: { children: React.ReactNode }) => {
  const [goal, setGoalState] = useState(GOAL_DEFAULT)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    let active = true

    readGoal()
      .then((stored) => {
        if (active) {
          setGoalState(stored)
          setReady(true)
        }
      })

    return () => { active = false }
  }, [])

  const setGoal = (value: number): number => {
    const normalized = normalizeGoal(value)
    setGoalState(normalized)
    writeGoal(normalized)
    return normalized
  }

  return (
    <GoalContext.Provider value={{ goal, ready, setGoal }}>
      {children}
    </GoalContext.Provider>
  )
}

export const useGoal = () => {
  const context = useContext(GoalContext)

  if (context) return context

  throw new Error('useGoal must be used within a GoalProvider')
}
