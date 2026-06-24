import 'react-native-reanimated'
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import { GoalProvider } from '@/settings/GoalContext'

const RootLayout = () => (
  <SafeAreaProvider>
    <GoalProvider>
      <StatusBar style="dark" />
      <Stack screenOptions={{ headerShown: false }} />
    </GoalProvider>
  </SafeAreaProvider>
)

export default RootLayout
