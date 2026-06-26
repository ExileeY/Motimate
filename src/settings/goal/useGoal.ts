import { useSettings } from '@/settings/SettingsContext'

export const useGoal = () => {
  const { goal, setGoal, ready } = useSettings()
  return { goal, setGoal, ready }
}
