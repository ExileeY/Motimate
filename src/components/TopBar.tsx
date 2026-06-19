import React, { useEffect, useState } from 'react'
import { View, Text, StyleSheet } from 'react-native'
import { Mood } from '@/mood/mood'
import { colors, fonts, statusDot } from '@/theme/tokens'

const timeOfDay = (hour: number): string => {
  if (hour < 12) return 'Morning'
  if (hour < 18) return 'Afternoon'
  return 'Evening'
}

const formatClock = (date: Date): string =>
  `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`

const TopBar = ({ mood }: { mood: Mood }) => {
  const [now, setNow] = useState(() => new Date())

  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 30_000)
    return () => clearInterval(id)
  }, [])

  const dot = statusDot[mood]

  return (
    <View style={styles.row}>
      <View style={styles.pill}>
        <View style={[styles.dot, { backgroundColor: dot, shadowColor: dot }]} />
        <Text style={styles.pillLabel}>{timeOfDay(now.getHours())}</Text>
      </View>
      <Text style={styles.clock}>{formatClock(now)}</Text>
    </View>
  )
}

export default TopBar

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  pill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 7,
    paddingVertical: 6,
    paddingHorizontal: 12,
    backgroundColor: colors.pillBg,
    borderRadius: 99,
    borderWidth: 1,
    borderColor: colors.pillBorder,
  },
  dot: {
    width: 9,
    height: 9,
    borderRadius: 4.5,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.9,
    shadowRadius: 4,
    elevation: 2,
  },
  pillLabel: {
    fontSize: 12.5,
    fontFamily: fonts.bodyBold,
    color: colors.pillText,
  },
  clock: {
    fontSize: 13,
    fontFamily: fonts.bodyBold,
    color: colors.clock,
  },
})
