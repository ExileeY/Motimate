import { PETS } from '@/pet/registry'
import { useSettings } from '@/settings/SettingsContext'

export const useActivePet = () => {
  const { petId, setPet, ready } = useSettings()
  return { petId, activePet: PETS[petId], setPet, ready }
}
