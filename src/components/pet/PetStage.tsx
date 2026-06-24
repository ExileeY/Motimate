import React from 'react'
import { StyleSheet } from 'react-native'
import Animated, { useAnimatedStyle } from 'react-native-reanimated'
import { Mood } from '@/mood/mood'
import { usePingPong } from '@/components/pet/hooks/useLoop'
import { useResponsiveScale } from '@/hooks/useResponsiveScale'
import { BOX_SIZE, PET_SIZE } from '@/constants/pet/dimensions'
import { activePet } from '@/pet/registry'
import Glow from '@/components/pet/Glow'

const { Body } = activePet

const BREATH_TIME = {
  [Mood.ENERGETIC]: 3300,
  [Mood.CALM]: 4500,
  [Mood.TIRED]: 5500,
}

const MOTION_TIME = {
  [Mood.ENERGETIC]: 3300,
  [Mood.CALM]: 5500,
  [Mood.TIRED]: 5500,
}

const breathe = (progress: number) => {
  'worklet'

  const BREATHE_DEPTH = 0.035

  return { scale: 1 + BREATHE_DEPTH * progress }
}

const bobble = (progress: number) => {
  'worklet'

  const BOBBLE_RISE = 9

  return { translateY: -BOBBLE_RISE * progress }
}

const sway = (progress: number) => {
  'worklet'

  const SWAY_DEG = 2.6

  return { rotate: `${-SWAY_DEG + 2 * SWAY_DEG * progress}deg` }
}
const tiredTilt = () => {
  'worklet'

  const TILT_DEG = -3

  return { rotate: `${TILT_DEG}deg` }
}

const PetStage = ({ mood }: { mood: Mood }) => {
  const scale = useResponsiveScale()
  const stage = Math.round(BOX_SIZE * scale)
  const pet = Math.round(PET_SIZE * scale)

  const pulse = usePingPong(BREATH_TIME[mood])
  const motion = usePingPong(MOTION_TIME[mood], 0, mood !== Mood.TIRED)

  const style = useAnimatedStyle(() => {
    const transforms: any[] = [breathe(pulse.value)]

    if (mood === Mood.ENERGETIC) { transforms.push(bobble(motion.value)) }

    if (mood === Mood.CALM) { transforms.push(sway(motion.value)) }
    
    if (mood === Mood.TIRED) { transforms.push(tiredTilt()) }

    return { transform: transforms }
  })

  return (
    <Animated.View style={[styles.stage, { width: stage, height: stage }, style]}>
      <Glow
        mood={mood}
        size={stage}
      />

      <Body
        mood={mood}
        size={pet}
      />
    </Animated.View>
  )
}

export default PetStage

const styles = StyleSheet.create({
  stage: {
    alignItems: 'center',
    justifyContent: 'center',
  },
})
