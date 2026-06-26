import { useSettings } from '@/settings/SettingsContext'

export const useActivePet = () => {
  const { petId, activePet, setPet, ready } = useSettings()
  return { petId, activePet, setPet, ready }
}
