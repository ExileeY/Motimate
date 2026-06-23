import React from 'react'
import { StyleSheet } from 'react-native'
import Animated, { useAnimatedStyle } from 'react-native-reanimated'
import { Mood } from '@/mood/mood'
import { usePingPong } from '@/components/pet/hooks/useLoop'
import Mochi from '@/components/pet/Mochi'
import Glow from '@/components/pet/Glow'

const STAGE = 236
const PET_SIZE = 180

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
