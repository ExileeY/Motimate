import { useSettings } from '@/settings/SettingsContext'

export const useMode = () => {
  const { mode, setMode, ready } = useSettings()
  return { mode, setMode, ready }
}
