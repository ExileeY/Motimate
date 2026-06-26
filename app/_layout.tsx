import 'react-native-reanimated'
import { Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import { GoalProvider } from '@/settings/GoalContext'
import { PetProvider } from '@/settings/PetContext'

const RootLayout = () => (
  <SafeAreaProvider>
    <GoalProvider>
      <PetProvider>
        <StatusBar style="dark" />
        <Stack screenOptions={{ headerShown: false }} />
      </PetProvider>
    </GoalProvider>
  </SafeAreaProvider>
)

export default RootLayout
