import { createPersistedStorage } from '@/settings/persistedStorage'

const STORAGE_KEY = 'motimate.goal'

export const GOAL_DEFAULT = 12_500
export const GOAL_MIN = 1_000
export const GOAL_MAX = 50_000

const normalize = (goal: number): number =>
  Number.isFinite(goal)
    ? Math.min(Math.max(Math.round(goal), GOAL_MIN), GOAL_MAX)
    : GOAL_DEFAULT

export const goalStorage = createPersistedStorage<number>({
  key: STORAGE_KEY,
  decode: (goal) => goal == null ? GOAL_DEFAULT : Number(goal),
  encode: (goal) => String(goal),
  normalize: normalize,
  fallback: GOAL_DEFAULT
})

export const getGoal = goalStorage.get
export const setGoal = goalStorage.set
