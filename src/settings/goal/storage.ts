import { createPersistedStorage } from '@/settings/persistedStorage'

const STORAGE_KEY = 'motimate.goal'

export const GOAL_DEFAULT = 12_500
export const GOAL_MIN = 1_000
export const GOAL_MAX = 50_000

export const normalizeGoal = (value: number): number =>
  Number.isFinite(value)
    ? Math.min(Math.max(Math.round(value), GOAL_MIN), GOAL_MAX)
    : GOAL_DEFAULT

export const goalStorage = createPersistedStorage<number>({
  key: STORAGE_KEY,
  decode: (raw) => raw == null ? GOAL_DEFAULT : normalizeGoal(Number(raw)),
  encode: String,
  fallback: GOAL_DEFAULT
})

export const getGoal = goalStorage.get
export const setGoal = goalStorage.set
