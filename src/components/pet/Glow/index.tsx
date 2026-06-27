import React from 'react'
import { View, StyleSheet } from 'react-native'
import { Mood } from '@/pet/mood'
import Halo from '@/components/pet/Glow/Halo'
import Particles from '@/components/pet/Glow/Particles'
import Zzz from '@/components/pet/Glow/Zzz'

const Glow = ({ mood, size }: { mood: Mood; size: number }) => (
  <View
    style={[StyleSheet.absoluteFill, styles.center]}
    pointerEvents="none"
  >
    <Halo
      mood={mood}
      size={size}
    />

    {mood === Mood.ENERGETIC && <Particles size={size} />}
    {mood === Mood.TIRED && <Zzz size={size} />}
  </View>
)

export default Glow

const styles = StyleSheet.create({
  center: { alignItems: 'center', justifyContent: 'center' },
})
