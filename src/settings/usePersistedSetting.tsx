import { useEffect, useState } from 'react'

import { PersistedStorage } from '@/settings/persistedStorage'

export interface PersistedSettingConfig<T> {
  default: T
  storage: PersistedStorage<T>
}

export type PersistedSettingValue<T> = {
  value: T
  ready: boolean
  set: (value: T) => T
}

export const usePersistedSetting = <T,>(config: PersistedSettingConfig<T>): PersistedSettingValue<T> => {
  const [value, setValue] = useState<T>(config.default)
  const [ready, setReady] = useState(false)

  useEffect(() => {
    let active = true

    config.storage.get()
      .then((stored) => {
        if (active) {
          setValue(stored)
          setReady(true)
        }
      })

    return () => { active = false }
  }, [])

  const set = (next: T): T => {
    const normalized = config.storage.normalize(next)

    setValue(normalized)
    config.storage.set(normalized)

    return normalized
  }

  return { value, ready, set }
}
