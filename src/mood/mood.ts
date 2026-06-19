export enum Mood {
  ENERGETIC = 'energetic',
  CALM = 'calm',
  TIRED = 'tired',
}

const MOOD_MAX: Record<Mood, number> = {
  [Mood.ENERGETIC]: 2_500,
  [Mood.CALM]: 8_000,
  [Mood.TIRED]: Infinity,
}

const GOAL = 12_500

export const StepsConvertor = {
  toMood(steps: number): Mood {
    if (steps < MOOD_MAX[Mood.ENERGETIC]) return Mood.ENERGETIC
    if (steps < MOOD_MAX[Mood.CALM]) return Mood.CALM
    return Mood.TIRED
  },
  toProgress(steps: number): number {
    return Math.min(steps / GOAL, 1)
  },
}
