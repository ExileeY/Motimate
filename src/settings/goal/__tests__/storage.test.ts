import { GOAL_DEFAULT, GOAL_MAX, GOAL_MIN, goalStorage } from '@/settings/goal/storage'

const normalize = goalStorage.normalize

describe('goal normalize', () => {
  it('passes through an in-range value unchanged', () => {
    const subject = (GOAL_MIN + GOAL_MAX) / 2
    expect(normalize(subject)).toBe(subject)
  })

  it('clamps below the minimum up to GOAL_MIN', () => {
    [-1000, 0, GOAL_MIN - 500].forEach((value) => {
      expect(normalize(value)).toBe(GOAL_MIN)
    })
  })

  it('clamps above the maximum down to GOAL_MAX', () => {
    expect(normalize(GOAL_MAX + 5_000)).toBe(GOAL_MAX)
  })

  it('keeps the bounds themselves', () => {
    expect(normalize(GOAL_MIN)).toBe(GOAL_MIN)
    expect(normalize(GOAL_MAX)).toBe(GOAL_MAX)
  })

  it('rounds fractional values', () => {
    expect(normalize(8_000.4)).toBe(8_000)
    expect(normalize(8_000.6)).toBe(8_001)
  })

  it('falls back to GOAL_DEFAULT for non-finite values', () => {
    expect(normalize(NaN)).toBe(GOAL_DEFAULT)
    expect(normalize(Infinity)).toBe(GOAL_DEFAULT)
    expect(normalize(-Infinity)).toBe(GOAL_DEFAULT)
  })
})
