import React, { createContext, useContext } from 'react'

import { PetId } from '@/pet/registry'
import { GOAL_DEFAULT, goalStorage } from '@/settings/goal/storage'
import { GameMode, MODE_DEFAULT, modeStorage } from '@/settings/mode/storage'
import { PET_DEFAULT, petStorage } from '@/settings/pet/storage'
import { usePersistedSetting } from '@/settings/usePersistedSetting'

type GoalContext = {
  goal: number
  setGoal: (value: number) => number
}

type PetContext = {
  petId: PetId
  setPet: (id: PetId) => PetId
}

type ModeContext = {
  mode: GameMode
  setMode: (mode: GameMode) => GameMode
}

type SettingsContextValue = GoalContext & PetContext & ModeContext & { ready: boolean }
const SettingsContext = createContext<SettingsContextValue | null>(null)

export const SettingsProvider = ({ children }: { children: React.ReactNode }) => {
  const goalSetting = usePersistedSetting<number>({
    default: GOAL_DEFAULT,
    storage: goalStorage,
  })

  const petSetting = usePersistedSetting<PetId>({
    default: PET_DEFAULT,
    storage: petStorage,
  })

  const modeSetting = usePersistedSetting<GameMode>({
    default: MODE_DEFAULT,
    storage: modeStorage,
  })

  const value: SettingsContextValue = {
    ready: [goalSetting, petSetting, modeSetting].every((setting) => setting.ready),
    goal: goalSetting.value,
    petId: petSetting.value,
    mode: modeSetting.value,
    setGoal: goalSetting.set,
    setPet: petSetting.set,
    setMode: modeSetting.set,
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
