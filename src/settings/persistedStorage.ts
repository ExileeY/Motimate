import AsyncStorage from '@react-native-async-storage/async-storage'

interface PersistedStorageConfig<T> {
  key: string
  decode: (value: string | null) => T
  encode: (value: T) => string
  normalize: (value: T) => T
  fallback: T
}

export interface PersistedStorage<T> {
  get: () => Promise<T>
  set: (value: T) => Promise<void>
  normalize: (value: T) => T
}

export const createPersistedStorage = <T>(config: PersistedStorageConfig<T>): PersistedStorage<T> => {
  const get = async (): Promise<T> => {
    try {
      return config.normalize(config.decode(await AsyncStorage.getItem(config.key)))
    } catch {
      return config.fallback
    }
  }

  const set = async (value: T): Promise<void> => {
    try {
      await AsyncStorage.setItem(config.key, config.encode(config.normalize(value)))
    } catch {
      // Do nothing
    }
  }

  return { get, set, normalize: config.normalize }
}
