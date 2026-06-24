/**
 * Settings screen.
 *
 * One section ("User goals") with one setting ("Steps") — the daily steps
 * objective that drives the home progress bar. The field is seeded from the
 * shared GoalContext; edits are kept as local text while typing and committed
 * (parsed → clamped → persisted) on blur / submit / leaving the screen.
 *
 * Background reuses PhoneCanvas with a fixed neutral mood so settings keeps the
 * warm-cream feel without coupling to live step data.
 */
import React, { useState } from 'react'
import { View, Text, TextInput, Pressable, StyleSheet } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import { useRouter } from 'expo-router'
import { Mood } from '@/mood/mood'
import { useGoal } from '@/goal/GoalContext'
import { GOAL_DEFAULT, GOAL_MIN, GOAL_MAX } from '@/goal/goalStorage'
import { colors, fonts } from '@/constants/tokens'
import PhoneCanvas from '@/components/PhoneCanvas'

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
})
