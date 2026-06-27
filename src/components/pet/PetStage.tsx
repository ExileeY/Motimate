import React from 'react'
import { StyleSheet } from 'react-native'
import Animated, { useAnimatedStyle } from 'react-native-reanimated'
import { Mood } from '@/pet/mood'
import { usePingPong } from '@/components/pet/hooks/useLoop'
import { useResponsiveScale } from '@/hooks/useResponsiveScale'
import { BOX_SIZE, PET_SIZE } from '@/constants/pet/dimensions'
import Glow from '@/components/pet/Glow'
import { useActivePet } from '@/settings/pet/useActivePet'

const BREATH_TIME = {
  [Mood.ENERGETIC]: 3300,
  [Mood.CALM]: 4500,
  [Mood.TIRED]: 5500,
  [Mood.SAD]: 3600,
}

const MOTION_TIME = {
  [Mood.ENERGETIC]: 3300,
  [Mood.CALM]: 5500,
  [Mood.TIRED]: 5500,
  [Mood.SAD]: 4600,
}

const QUIVER_TIME = 360

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

const QUIVER_PX = 0.5
const QUIVER_DEG = 0.4

const quiverShift = (progress: number) => {
  'worklet'

  return { translateX: -QUIVER_PX + 2 * QUIVER_PX * progress }
}

const quiverRotate = (progress: number) => {
  'worklet'

  return { rotate: `${-QUIVER_DEG + 2 * QUIVER_DEG * progress}deg` }
}

const PetStage = ({ mood }: { mood: Mood }) => {
  const { activePet } = useActivePet()
  const { Body } = activePet

  const scale = useResponsiveScale()
  const stage = Math.round(BOX_SIZE * scale)
  const pet = Math.round(PET_SIZE * scale)

  const pulse = usePingPong(BREATH_TIME[mood])
  const motion = usePingPong(MOTION_TIME[mood], 0, mood !== Mood.TIRED)
  const tremble = usePingPong(QUIVER_TIME, 0, mood === Mood.SAD)

  const style = useAnimatedStyle(() => {
    const transforms: any[] = [breathe(pulse.value)]

    if (mood === Mood.ENERGETIC) { transforms.push(bobble(motion.value)) }

    if (mood === Mood.CALM) { transforms.push(sway(motion.value)) }

    if (mood === Mood.TIRED) { transforms.push(tiredTilt()) }

    if (mood === Mood.SAD) {
      transforms.push(
        bobble(motion.value),
        quiverShift(tremble.value),
        quiverRotate(tremble.value)
      )
    }

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
