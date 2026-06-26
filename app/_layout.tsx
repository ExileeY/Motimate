import 'react-native-reanimated'
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import { SettingsProvider } from '@/settings/SettingsContext'

const RootLayout = () => (
  <SafeAreaProvider>
    <SettingsProvider>
      <StatusBar style="dark" />
      <Stack screenOptions={{ headerShown: false }} />
    </SettingsProvider>
  </SafeAreaProvider>
)

export default RootLayout
