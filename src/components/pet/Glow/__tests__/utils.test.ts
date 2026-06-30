import { calcTransform, calcTriangleOpacity, linearInterpolate } from '@/components/pet/Glow/utils'

describe('linearInterpolate', () => {
  it('returns min at progress 0', () => {
    expect(linearInterpolate(10, 20, 0)).toBe(10)
  })

  it('returns max at progress 1', () => {
    expect(linearInterpolate(10, 20, 1)).toBe(20)
  })

  it('returns the midpoint at progress 0.5', () => {
    expect(linearInterpolate(10, 20, 0.5)).toBe(15)
  })

  it('extrapolates past the range', () => {
    expect(linearInterpolate(0, 10, 2)).toBe(20)
  })
})

describe('calcTriangleOpacity', () => {
  const fadeIn = 0.3

  it('ramps up linearly during the fade-in', () => {
    expect(calcTriangleOpacity(0, fadeIn)).toBe(0)
    expect(calcTriangleOpacity(fadeIn / 2, fadeIn)).toBeCloseTo(0.5)
  })

  it('peaks at 1 at the fade-in boundary', () => {
    expect(calcTriangleOpacity(fadeIn, fadeIn)).toBeCloseTo(1)
  })

  it('ramps back down to 0 by the end', () => {
    expect(calcTriangleOpacity(1, fadeIn)).toBeCloseTo(0)
    // Halfway through the fade-out segment.
    expect(calcTriangleOpacity(fadeIn + (1 - fadeIn) / 2, fadeIn)).toBeCloseTo(0.5)
  })
})

describe('calcTransform', () => {
  it('assembles a centered scale transform string', () => {
    expect(calcTransform(2, 50, 60)).toBe(
      'translate(0 0) translate(50 60) scale(2) translate(-50 -60)',
    )
  })

  it('includes the optional translate offset', () => {
    expect(calcTransform(1, 10, 20, 5, -7)).toBe(
      'translate(5 -7) translate(10 20) scale(1) translate(-10 -20)',
    )
  })
})
