import { roundedBoxPath } from '@/components/pet/svgPath'

describe('roundedBoxPath', () => {
  describe('square figure', () => {
    const corners: [number, number][] = [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ]
    const subject = roundedBoxPath(0, 0, 100, 100, corners)

    it('starts with a move command and ends closed', () => {
      expect(subject.startsWith('M ')).toBe(true)
      expect(subject.endsWith('Z')).toBe(true)
    })

    it('emits one cubic Bézier per corner (four)', () => {
      const curves = subject.match(/C /g) ?? []
      expect(curves).toHaveLength(4)
    })

    it('emits three straight edges between the corners', () => {
      const lines = subject.match(/L /g) ?? []
      expect(lines).toHaveLength(3)
    })
  })

  describe('other figure', () => {
    const corners: [number, number][] = [
      [0.5, 0.5],
      [0.5, 0.5],
      [0.2, 0.2],
      [0.2, 0.2],
    ]
    const subject = roundedBoxPath(10, 20, 80, 60, corners)

    it('produces a stable path for a known rounded box (snapshot)', () => {
      expect(subject).toMatchInlineSnapshot(`"M 10 50 C 10 33.431 27.908 20 50 20 L 50 20 C 72.092 20 90 33.431 90 50 L 90 68 C 90 74.6276 82.8368 80 74 80 L 26 80 C 17.1632 80 10 74.6276 10 68 Z"`)
    })
  })
})
