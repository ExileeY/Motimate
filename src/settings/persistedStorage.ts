import AsyncStorage from '@react-native-async-storage/async-storage'

interface PersistedStorageConfig<T> {
  key: string
  decode: (raw: string | null) => T
  encode: (value: T) => string
  fallback: T
}

export interface PersistedStorage<T> {
  get: () => Promise<T>
  set: (value: T) => Promise<void>
}

export const createPersistedStorage = <T>(
  config: PersistedStorageConfig<T>
): PersistedStorage<T> => {
  const get = async (): Promise<T> => {
    try {
      return config.decode(await AsyncStorage.getItem(config.key))
    } catch {
      return config.fallback
    }
  }

  const set = async (value: T): Promise<void> => {
    try {
      await AsyncStorage.setItem(config.key, config.encode(value))
    } catch {
      // Do nothing
    }
  }

  return { get, set }
}
