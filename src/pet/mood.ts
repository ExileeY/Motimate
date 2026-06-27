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
  if (steps < goal * MOOD_MAX_RATIO[Mood.ENERGETIC]) return Mood.ENERGETIC
  if (steps < goal * MOOD_MAX_RATIO[Mood.CALM]) return Mood.CALM
  return Mood.TIRED
}

export const StepsConvertor = {
  toMood(steps: number, goal: number, mode: GameMode, hour: number): Mood {
    const baseMood = stepMood(steps, goal)

    return mode === GameMode.REAL && baseMood === Mood.ENERGETIC && hour >= MORNING_END_HOUR
      ? Mood.SAD
      : baseMood
  },
  toProgress(steps: number, goal: number): number {
    return Math.min(steps / goal, 1)
  },
}
