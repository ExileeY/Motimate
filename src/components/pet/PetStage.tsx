/**
 * PetStage — composes the Glow halo + Mochi and drives the whole-body motion
 * that the mockup applies to the pet wrapper (bob/breathe/sway), per mood:
 *
 *   energetic → bob (3.3s) + breathe (3.3s) + bright glow + particles
 *   calm      → sway ±2.6° (5.5s) + breathe (4.5s) + soft glow
 *   tired     → static -3° tilt + breathe (5.5s) + dim glow + Zzz
 *
 * Body motion (bob/sway/breathe) is done with View-level Reanimated transforms
 * — cheaper than animating nested SVG groups and visually identical, since the
 * mockup also transforms the whole wrapper. Per-part SVG groups (ears/tail) are
 * reserved for finer motion later; the SVG structure in Mochi.tsx is ready.
 */
import React, { useEffect } from 'react'
import { StyleSheet } from 'react-native'
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withRepeat,
  withTiming,
  Easing,
} from 'react-native-reanimated'
import { Mood } from '@/mood/mood'
import Mochi from '@/components/pet/Mochi'
import Glow from '@/components/pet/Glow'

const easeInOut = Easing.inOut(Easing.ease)
const PET_SIZE = 180
const STAGE = 236 // halo-sized stage so the glow has room around the pet

const PetStage = ({ mood }: { mood: Mood }) => {
  const pulse = useSharedValue(0) // breathe 0↔1
  const motion = useSharedValue(0) // bob/sway 0↔1

  const breatheMs = mood === Mood.ENERGETIC ? 3300 : mood === Mood.CALM ? 4500 : 5500
  const motionMs = mood === Mood.ENERGETIC ? 3300 : 5500

  useEffect(() => {
    pulse.value = withRepeat(withTiming(1, { duration: breatheMs / 2, easing: easeInOut }), -1, true)
  }, [breatheMs, pulse])

  useEffect(() => {
    if (mood === Mood.TIRED) {
      motion.value = 0
      return
    }
    motion.value = withRepeat(withTiming(1, { duration: motionMs / 2, easing: easeInOut }), -1, true)
  }, [mood, motionMs, motion])

  const style = useAnimatedStyle(() => {
    const scale = 1 + 0.035 * pulse.value
    const transforms: any[] = [{ scale }]

    if (mood === Mood.ENERGETIC) {
      transforms.push({ translateY: -9 * motion.value }) // bob
    } else if (mood === Mood.CALM) {
      transforms.push({ rotate: `${-2.6 + 5.2 * motion.value}deg` }) // sway
    } else {
      transforms.push({ rotate: '-3deg' }) // tired static tilt
    }
    return { transform: transforms }
  })

  return (
    <Animated.View style={[styles.stage, style]}>
      <Glow
        mood={mood}
        size={STAGE}
      />

      <Mochi
        mood={mood}
        size={PET_SIZE}
      />
    </Animated.View>
  )
}

export default PetStage

const styles = StyleSheet.create({
  stage: {
    width: STAGE,
    height: STAGE,
    alignItems: 'center',
    justifyContent: 'center',
  },
})
