import React, { createContext, useContext } from 'react'

import { PetId, PetDefinition, PETS } from '@/pet/registry'
import { GOAL_DEFAULT, goalStorage, normalizeGoal } from '@/settings/goal/storage'
import { PET_DEFAULT, petStorage } from '@/settings/pet/storage'
import { usePersistedSetting } from '@/settings/usePersistedSetting'

type GoalContext = {
  goal: number
  setGoal: (value: number) => number
}

type PetContext = {
  petId: PetId
  setPet: (id: PetId) => PetId
  activePet: PetDefinition
  ready: boolean
}

type SettingsContextValue = GoalContext & PetContext
const SettingsContext = createContext<SettingsContextValue | null>(null)

export const SettingsProvider = ({ children }: { children: React.ReactNode }) => {
  const goalSetting = usePersistedSetting<number>({
    default: GOAL_DEFAULT,
    storage: goalStorage,
    normalize: normalizeGoal,
  })

  const petSetting = usePersistedSetting<PetId, { activePet: PetDefinition }>({
    default: PET_DEFAULT,
    storage: petStorage,
    derive: (id) => ({ activePet: PETS[id] }),
  })

  const value: SettingsContextValue = {
    ready: [goalSetting, petSetting].every((setting) => setting.ready),
    goal: goalSetting.value,
    petId: petSetting.value,
    activePet: petSetting.activePet,
    setGoal: goalSetting.set,
    setPet: petSetting.set,
  }

  return (
    <SettingsContext.Provider value={value}>
      {children}
    </SettingsContext.Provider>
  )
}

export const useSettings = (): SettingsContextValue => {
  const context = useContext(SettingsContext)

  if (context) return context

  throw new Error('useSettings must be used within a SettingsProvider')
}
