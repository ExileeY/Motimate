import { computeScale } from '@/hooks/useResponsiveScale'

const BASE_HEIGHT = 812
const MIN = 0.85
const MAX = 1.15

describe('computeScale', () => {
  it('is ~1 at the reference height', () => {
    expect(computeScale(BASE_HEIGHT)).toBeCloseTo(1)
  })

  it('scales down proportionally for shorter screens', () => {
    expect(computeScale(BASE_HEIGHT * 0.95)).toBeCloseTo(0.95)
  })

  it('clamps to MIN on very short screens', () => {
    expect(computeScale(400)).toBe(MIN)
  })

  it('clamps to MAX on very tall screens', () => {
    expect(computeScale(2_000)).toBe(MAX)
  })
})
