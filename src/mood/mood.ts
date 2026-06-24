export enum Mood {
  ENERGETIC = 'energetic',
  CALM = 'calm',
  TIRED = 'tired',
}

const MOOD_MAX_RATIO: Record<Mood, number> = {
  [Mood.ENERGETIC]: 0.2,
  [Mood.CALM]: 0.64,
  [Mood.TIRED]: Infinity,
}

export const StepsConvertor = {
  toMood(steps: number, goal: number): Mood {
    if (steps < MOOD_MAX_RATIO[Mood.ENERGETIC] * goal) return Mood.ENERGETIC
    if (steps < MOOD_MAX_RATIO[Mood.CALM] * goal) return Mood.CALM
    return Mood.TIRED
  },
  toProgress(steps: number, goal: number): number {
    return Math.min(steps / goal, 1)
  },
}
