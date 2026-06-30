import { GameMode, MODE_DEFAULT, modeStorage } from '@/settings/mode/storage'

const normalize = modeStorage.normalize

describe('mode normalize', () => {
  it('passes through both valid game modes', () => {
    expect(normalize(GameMode.STANDARD)).toBe(GameMode.STANDARD)
    expect(normalize(GameMode.REAL)).toBe(GameMode.REAL)
  })

  it('falls back to MODE_DEFAULT for an invalid value', () => {
    expect(normalize('arcade' as GameMode)).toBe(MODE_DEFAULT)
    expect(normalize(undefined as unknown as GameMode)).toBe(MODE_DEFAULT)
  })
})
