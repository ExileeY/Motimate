/**
 * goalStorage — persistence + bounds for the daily steps goal.
 *
 * The goal is the only persisted user setting today; everything lives here so
 * the context stays a thin provider over these helpers. Reads/writes are
 * best-effort (a storage failure simply falls back to the default).
 */
import AsyncStorage from '@react-native-async-storage/async-storage'

export const GOAL_DEFAULT = 12_500
export const GOAL_MIN = 1_000
export const GOAL_MAX = 50_000

const STORAGE_KEY = 'motimate.goal'

export const normalizeGoal = (value: number): number =>
  Number.isFinite(value)
    ? Math.min(Math.max(Math.round(value), GOAL_MIN), GOAL_MAX)
    : GOAL_DEFAULT

export const readGoal = async (): Promise<number> => {
  try {
    const value = await AsyncStorage.getItem(STORAGE_KEY)
    return value == null ? GOAL_DEFAULT : normalizeGoal(Number(value))
  } catch {
    return GOAL_DEFAULT
  }
}

export const writeGoal = async (goal: number): Promise<void> => {
  try {
    await AsyncStorage.setItem(STORAGE_KEY, String(goal))
  } catch {
    // Do nothing
  }
}
