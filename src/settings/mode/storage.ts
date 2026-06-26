import { createPersistedStorage } from '@/settings/persistedStorage'

const STORAGE_KEY = 'motimate.mode'

export enum GameMode {
  STANDARD = 'standard',
  REAL = 'real',
}

export const MODE_IDS = Object.values(GameMode)
export const MODE_DEFAULT = GameMode.STANDARD

const normalize = (value: GameMode): GameMode =>
  MODE_IDS.includes(value) ? value : MODE_DEFAULT

export const modeStorage = createPersistedStorage<GameMode>({
  key: STORAGE_KEY,
  decode: (mode) => (mode ?? MODE_DEFAULT) as GameMode,
  encode: (mode) => mode,
  normalize: normalize,
  fallback: MODE_DEFAULT
})

export const getMode = modeStorage.get
export const setMode = modeStorage.set
