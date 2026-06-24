import React from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { LinearGradient } from 'expo-linear-gradient'
import { MessageSet } from '@/pet/messages'
import { colors, fonts } from '@/constants/tokens'

interface MovementCardProps {
  message: MessageSet
  steps: number
  progress: number
  hasLiveSteps: boolean
}

const MovementCard = ({ message, steps, progress, hasLiveSteps }: MovementCardProps) => {
  const meta = hasLiveSteps ? `${steps.toLocaleString()} steps` : message.meta

  return (
    <View style={styles.card}>
      <View style={styles.headerRow}>
        <Text
          style={styles.title}
          numberOfLines={1}
          maxFontSizeMultiplier={1.3}
        >
          Today's movement
        </Text>
        <Text
          style={styles.meta}
          numberOfLines={1}
          maxFontSizeMultiplier={1.3}
        >
          {meta}
        </Text>
      </View>
      <View style={styles.track}>
        <LinearGradient
          colors={[colors.barFrom, colors.barTo]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
          style={[styles.fill, { width: `${Math.round(progress * 100)}%` }]}
        />
      </View>
      <Text style={styles.footer}>
        {message.footer}
      </Text>
    </View>
  )
}

export default MovementCard

const styles = StyleSheet.create({
  card: {
    width: '100%',
    marginTop: 20,
    gap: 9,
    backgroundColor: colors.cardBg,
    borderWidth: 1,
    borderColor: colors.cardBorder,
    borderRadius: 20,
    paddingVertical: 14,
    paddingHorizontal: 16,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  title: {
    flexShrink: 1,
    fontSize: 13,
    fontFamily: fonts.bodyBold,
    color: colors.pillText,
  },
  meta: {
    flexShrink: 0,
    fontSize: 12,
    fontFamily: fonts.bodyRegular,
    color: colors.cardMeta,
  },
  track: {
    height: 8,
    borderRadius: 99,
    backgroundColor: colors.barTrack,
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    borderRadius: 99,
  },
  footer: {
    fontSize: 12.5,
    fontFamily: fonts.bodyRegular,
    color: colors.cardFooter,
  },
})
