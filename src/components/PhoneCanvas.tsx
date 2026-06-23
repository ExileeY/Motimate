/**
 * PhoneCanvas — the full-screen mood background + safe-area layout shell.
 *
 * In the mockups the screen is a phone-frame with a radial-gradient backdrop.
 * On-device the OS provides the frame, so we drop the bezel/notch and let the
 * mood gradient fill the whole canvas. The radial gradient is approximated as a
 * top-anchored vertical linear gradient (expo-linear-gradient), matching the
 * mockup's `at 50% ~30%` focal point closely enough for the warm-cream feel.
 */
import React from 'react'
import { StyleSheet } from 'react-native'
import { LinearGradient } from 'expo-linear-gradient'
import { SafeAreaView } from 'react-native-safe-area-context'
import { Mood } from '@/mood/mood'
import { screenBackground } from '@/constants/tokens'

const PhoneCanvas = ({ mood, children }: { mood: Mood; children: React.ReactNode }) => {
  const bg = screenBackground[mood]
  return (
    <LinearGradient
      colors={bg.colors}
      locations={bg.locations}
      start={{ x: 0.5, y: 0 }}
      end={{ x: 0.5, y: 1 }}
      style={styles.fill}
    >
      <SafeAreaView style={styles.safe}>{children}</SafeAreaView>
    </LinearGradient>
  )
}

export default PhoneCanvas

const styles = StyleSheet.create({
  fill: { flex: 1 },
  safe: {
    flex: 1,
    paddingHorizontal: 22,
    paddingTop: 8,
    paddingBottom: 24,
  },
})
