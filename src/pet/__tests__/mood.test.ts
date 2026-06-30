import { Mood, MOOD_MAX_RATIO, MORNING_END_HOUR, StepsConvertor } from '@/pet/mood'
import { GameMode } from '@/settings/mode/storage'

const GOAL = 10_000
const ENERGETIC_MAX = GOAL * MOOD_MAX_RATIO[Mood.ENERGETIC]
const CALM_MAX = GOAL * MOOD_MAX_RATIO[Mood.CALM]


describe('StepsConvertor.toMood', () => {
  describe('step thresholds (STANDARD mode)', () => {
    const moodFor = (steps: number) => StepsConvertor.toMood(steps, GOAL, GameMode.STANDARD, 9)

    it('is ENERGETIC at zero steps', () => {
      expect(moodFor(0)).toBe(Mood.ENERGETIC)
    })

    it('is ENERGETIC just below the energetic cap', () => {
      expect(moodFor(ENERGETIC_MAX - 1)).toBe(Mood.ENERGETIC)
    })

    it('is CALM exactly at the energetic cap (cap is exclusive)', () => {
      expect(moodFor(ENERGETIC_MAX)).toBe(Mood.CALM)
    })

    it('is CALM just below the calm cap', () => {
      expect(moodFor(CALM_MAX - 1)).toBe(Mood.CALM)
    })

    it('is TIRED exactly at the calm cap (cap is exclusive)', () => {
      expect(moodFor(CALM_MAX)).toBe(Mood.TIRED)
    })

    it('is TIRED well past the goal', () => {
      expect(moodFor(GOAL * 5)).toBe(Mood.TIRED)
    })
  })

  describe('SAD overlay (REAL mode)', () => {
    it('turns an ENERGETIC pet SAD at/after the morning cutoff', () => {
      expect(StepsConvertor.toMood(0, GOAL, GameMode.REAL, MORNING_END_HOUR)).toBe(Mood.SAD)
    })

    it('keeps an ENERGETIC pet energetic before the morning cutoff', () => {
      expect(StepsConvertor.toMood(0, GOAL, GameMode.REAL, MORNING_END_HOUR - 1)).toBe(Mood.ENERGETIC)
    })

    it('does not apply SAD to CALM/TIRED moods even in the afternoon', () => {
      expect(StepsConvertor.toMood(CALM_MAX - 1, GOAL, GameMode.REAL, 18)).toBe(Mood.CALM)
      expect(StepsConvertor.toMood(CALM_MAX, GOAL, GameMode.REAL, 18)).toBe(Mood.TIRED)
    })

    it('never applies SAD in STANDARD mode, even energetic in the afternoon', () => {
      expect(StepsConvertor.toMood(0, GOAL, GameMode.STANDARD, 18)).toBe(Mood.ENERGETIC)
    })
  })
})

describe('StepsConvertor.toProgress', () => {
  it('is 0 at zero steps', () => {
    expect(StepsConvertor.toProgress(0, GOAL)).toBe(0)
  })

  it('is the raw ratio below the goal', () => {
    expect(StepsConvertor.toProgress(2_500, GOAL)).toBeCloseTo(0.25)
  })

  it('is 1 exactly at the goal', () => {
    expect(StepsConvertor.toProgress(GOAL, GOAL)).toBe(1)
  })

  it('clamps to 1 above the goal', () => {
    expect(StepsConvertor.toProgress(GOAL * 3, GOAL)).toBe(1)
  })
})
