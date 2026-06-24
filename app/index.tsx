/**
 * Home screen — the whole app, for now. The pet *is* the home screen.
 *
 * Single source of truth: useDailySteps() → mood/progress → everything below.
 * Layout (top→bottom): TopBar · pet (Glow + active pet body) · headline+subtitle ·
 * MovementCard. The active pet (Mochi/Bulbashik) comes from the pet registry.
 *
 * Degrades gracefully: while permission/first reading resolve we show a quiet
 * loader; if motion data is unavailable or denied we still render the pet
 * (defaulting to its energetic "quiet so far" state) with a small notice,
 * instead of crashing.
 */
import React, { useState } from 'react'
import { View, Text, ActivityIndicator, Pressable, StyleSheet } from 'react-native'
import { useAppFonts } from '@/hooks/useAppFonts'
import { useResponsiveScale } from '@/hooks/useResponsiveScale'
import { useDailySteps } from '@/steps/useDailySteps'
import { Mood } from '@/pet/mood'
import { activePet } from '@/pet/registry'
import { colors, fonts } from '@/constants/tokens'
import PhoneCanvas from '@/components/PhoneCanvas'
import TopBar from '@/components/TopBar'
import MovementCard from '@/components/MovementCard'
import PetStage from '@/components/pet/PetStage'

const MOOD_CYCLE = [Mood.ENERGETIC, Mood.CALM, Mood.TIRED]
const petMessages = activePet.pickMessages()

const Home = () => {
  const [fontsLoaded] = useAppFonts()
  const scale = useResponsiveScale()
  const live = useDailySteps()
  // Dev-only: tap the pet to preview each mood without walking (verification §3).
  const [override, setOverride] = useState<Mood | null>(null)
  const cycleMood = () =>
    setOverride((m) => MOOD_CYCLE[(MOOD_CYCLE.indexOf(m ?? live.mood) + 1) % MOOD_CYCLE.length])

  const { steps, progress, permission, loading, error } = live
  const mood = override ?? live.mood

  if (!fontsLoaded || loading) {
    return (
      <View style={styles.boot}>
        <ActivityIndicator color={colors.accent} />
      </View>
    )
  }

  const hasLiveSteps = permission === 'granted' && !error
  const message = petMessages[mood]
  const notice =
    permission === 'unavailable'
      ? 'Movement data unavailable on this device.'
      : permission === 'denied'
        ? 'Motion access off — showing a resting state.'
        : error

  return (
    <PhoneCanvas mood={mood}>
      <TopBar mood={mood} />

      <Pressable
        style={styles.petArea}
        onPress={__DEV__ ? cycleMood : undefined}
      >
        <PetStage mood={mood} />
      </Pressable>

      <View style={styles.copy}>
        <Text
          style={[styles.headline, { fontSize: Math.round(30 * scale) }]}
          maxFontSizeMultiplier={1.3}
        >
          {message.headline}
        </Text>
        <Text
          style={[styles.subtitle, { fontSize: Math.round(14.5 * scale * 10) / 10 }]}
          maxFontSizeMultiplier={1.3}
        >
          {message.subtitle}
        </Text>
      </View>

      <MovementCard
        message={message}
        steps={steps}
        progress={progress}
        hasLiveSteps={hasLiveSteps}
      />

      {notice ? <Text style={styles.notice}>{notice}</Text> : null}
    </PhoneCanvas>
  )
}

export default Home

const styles = StyleSheet.create({
  boot: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#F6E4D0',
  },
  petArea: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  copy: {
    alignItems: 'center',
  },
  headline: {
    fontFamily: fonts.heading,
    fontSize: 30,
    color: colors.text,
  },
  subtitle: {
    fontFamily: fonts.bodyRegular,
    fontSize: 14.5,
    color: colors.subtitle,
    marginTop: 6,
  },
  notice: {
    marginTop: 10,
    textAlign: 'center',
    fontFamily: fonts.bodyRegular,
    fontSize: 12,
    color: colors.cardMeta,
  },
})
