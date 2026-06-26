/**
 * Settings screen.
 *
 * Two sections: "User goals" (the daily steps objective that drives the home
 * progress bar) and "Pet" (which companion lives on the home screen). The steps
 * field is seeded from GoalContext; edits are kept as local text while typing
 * and committed (parsed → clamped → persisted) on blur / submit / leaving the
 * screen. The pet grid (PetPicker) is instant-apply via PetContext.
 *
 * Content scrolls (the pet grid can exceed the screen). Background reuses
 * PhoneCanvas with a fixed neutral mood so settings keeps the warm-cream feel
 * without coupling to live step data.
 */
import React, { useState } from 'react'
import { View, Text, TextInput, Pressable, ScrollView, StyleSheet } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import { useRouter } from 'expo-router'
import { Mood } from '@/pet/mood'
import { useGoal } from '@/settings/GoalContext'
import { GOAL_DEFAULT, GOAL_MIN, GOAL_MAX } from '@/settings/goalStorage'
import { colors, fonts } from '@/constants/tokens'
import PhoneCanvas from '@/components/PhoneCanvas'
import PetPicker from '@/components/PetPicker'

const Settings = () => {
  const router = useRouter()

  const { goal, setGoal } = useGoal()
  const [draft, setDraft] = useState(String(goal))

  const commit = () => {
    const trimmed = draft.trim()
    const parsed = trimmed === '' ? GOAL_DEFAULT : Number(trimmed)
    setDraft(String(setGoal(parsed)))
  }

  const goBack = () => {
    commit()
    router.canGoBack() ? router.back() : router.replace('/')
  }

  return (
    <PhoneCanvas mood={Mood.CALM}>
      <View style={styles.header}>
        <Pressable
          onPress={goBack}
          hitSlop={10}
          accessibilityRole="button"
          accessibilityLabel="Back"
        >
          <Ionicons
            name="chevron-back"
            size={24}
            color={colors.text}
          />
        </Pressable>
        <Text style={styles.title}>
          Settings
        </Text>
      </View>

      <ScrollView
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
      >
        <Text style={styles.sectionLabel}>
          User goals
        </Text>

        <View style={styles.card}>
          <View style={styles.rowText}>
            <Text style={styles.settingLabel}>
              Steps
            </Text>
            <Text style={styles.settingHelp}>
              Your daily movement objective
            </Text>
          </View>
          <TextInput
            style={styles.input}
            value={draft}
            onChangeText={setDraft}
            onBlur={commit}
            onSubmitEditing={commit}
            keyboardType="number-pad"
            returnKeyType="done"
            maxLength={6}
            selectTextOnFocus
            placeholder={String(GOAL_DEFAULT)}
            placeholderTextColor={colors.cardMeta}
          />
        </View>

        <Text style={styles.hint}>
          Between {GOAL_MIN.toLocaleString()} and {GOAL_MAX.toLocaleString()} steps.
        </Text>

        <View style={styles.petSection}>
          <Text style={styles.sectionLabel}>
            Pet
          </Text>
          <Text style={styles.petHeading}>
            Choose your companion
          </Text>
          <Text style={styles.petHelp}>
            Lives on your home screen. Switch any time.
          </Text>
          <View style={styles.petGrid}>
            <PetPicker />
          </View>
        </View>
      </ScrollView>
    </PhoneCanvas>
  )
}

export default Settings

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    marginBottom: 28,
  },
  title: {
    fontFamily: fonts.heading,
    fontSize: 24,
    color: colors.text,
  },
  sectionLabel: {
    fontFamily: fonts.bodyBold,
    fontSize: 12.5,
    letterSpacing: 0.5,
    textTransform: 'uppercase',
    color: colors.cardMeta,
    marginBottom: 10,
  },
  card: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
    paddingVertical: 16,
    paddingHorizontal: 18,
    backgroundColor: colors.cardBg,
    borderRadius: 18,
    borderWidth: 1,
    borderColor: colors.cardBorder,
  },
  rowText: {
    flex: 1,
  },
  settingLabel: {
    fontFamily: fonts.headingMedium,
    fontSize: 17,
    color: colors.text,
  },
  settingHelp: {
    fontFamily: fonts.bodyRegular,
    fontSize: 13,
    color: colors.subtitle,
    marginTop: 2,
  },
  input: {
    minWidth: 92,
    paddingVertical: 8,
    paddingHorizontal: 12,
    backgroundColor: colors.pillBg,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.pillBorder,
    fontFamily: fonts.bodyBold,
    fontSize: 17,
    color: colors.text,
    textAlign: 'right',
  },
  hint: {
    fontFamily: fonts.bodyRegular,
    fontSize: 12,
    color: colors.cardMeta,
    marginTop: 10,
    marginLeft: 4,
  },
  scrollContent: {
    paddingBottom: 24,
  },
  petSection: {
    marginTop: 32,
  },
  petHeading: {
    fontFamily: fonts.heading,
    fontSize: 24,
    color: colors.text,
    marginTop: 5,
  },
  petHelp: {
    fontFamily: fonts.bodyRegular,
    fontSize: 13,
    color: colors.subtitle,
    marginTop: 6,
  },
  petGrid: {
    marginTop: 16,
  },
})
