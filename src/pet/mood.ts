import { GameMode } from '@/settings/mode/storage'

export enum Mood {
  ENERGETIC = 'energetic',
  CALM = 'calm',
  TIRED = 'tired',
  SAD = 'sad',
}

/** Hour (0-23) at which "morning" ends — shared with TopBar's time-of-day. */
export const MORNING_END_HOUR = 12

/**
 * Step-derived moods only. SAD is NOT reachable from steps — it's an overlay the
 * Real game mode applies when the pet is energetic (barely moved) past morning.
 */
const MOOD_MAX_RATIO: Record<Exclude<Mood, Mood.SAD>, number> = {
  [Mood.ENERGETIC]: 0.2,
  [Mood.CALM]: 0.64,
  [Mood.TIRED]: Infinity,
}

const stepMood = (steps: number, goal: number): Mood => {
  if (steps < MOOD_MAX_RATIO[Mood.ENERGETIC] * goal) return Mood.ENERGETIC
  if (steps < MOOD_MAX_RATIO[Mood.CALM] * goal) return Mood.CALM
  return Mood.TIRED
}

export const StepsConvertor = {
  /**
   * Maps steps → mood. In Real mode, an energetic (inactive) pet past morning
   * turns SAD; otherwise the mood is purely step-derived. This is the only place
   * SAD is produced.
   */
  toMood(steps: number, goal: number, mode: GameMode, hour: number): Mood {
    const base = stepMood(steps, goal)
    if (mode === GameMode.REAL && base === Mood.ENERGETIC && hour >= MORNING_END_HOUR) {
      return Mood.SAD
    }
    return base
  },
  toProgress(steps: number, goal: number): number {
    return Math.min(steps / goal, 1)
  },
}
