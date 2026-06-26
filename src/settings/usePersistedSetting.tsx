import { useEffect, useState } from 'react'

import { PersistedStorage } from '@/settings/persistedStorage'

export interface PersistedSettingConfig<T, Extra extends object> {
  default: T
  storage: PersistedStorage<T>
  normalize?: (value: T) => T
  derive?: (value: T) => Extra
}

export type PersistedSettingValue<T, Extra extends object> = {
  value: T
  ready: boolean
  set: (value: T) => T
} & Extra

export const usePersistedSetting = <T, Extra extends object = {}>(config: PersistedSettingConfig<T, Extra>): PersistedSettingValue<T, Extra> => {
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
    const normalized = config.normalize ? config.normalize(next) : next

    setValue(normalized)
    config.storage.set(normalized)

    return normalized
  }

  const extra = config.derive ? config.derive(value) : ({} as Extra)

  return { value, ready, set, ...extra }
}
