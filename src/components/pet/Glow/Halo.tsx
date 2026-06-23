import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, {
  Circle,
  Defs,
  FeGaussianBlur,
  Filter,
  G,
  RadialGradient,
  Stop
} from 'react-native-svg'
import Animated, { useAnimatedProps } from 'react-native-reanimated'
import { Mood } from '@/mood/mood'
import { glow as glowTokens } from '@/theme/tokens'
import { usePingPong } from '@/components/pet/animations'

import { calcTransform, linearInterpolate } from '@/components/pet/Glow/utils'

const OPACITY = {
  min: 0.82,
  max: 1,
}

const SCALE = {
  min: 1,
  max: 1.07,
}

const useGlowPulse = (durationMs: number, cx: number, cy: number) => {
  const progress = usePingPong(durationMs)

  return useAnimatedProps(() => {
    const scale = linearInterpolate(SCALE.min, SCALE.max, progress.value)

    return {
      opacity: linearInterpolate(OPACITY.min, OPACITY.max, progress.value),
      transform: calcTransform(scale, cx, cy)
    }
  })
}

const AnimatedG = Animated.createAnimatedComponent(G)

const Halo = ({ mood, size }: { mood: Mood; size: number }) => {
  const spec = glowTokens[mood]
  const box = size // square SVG matching the pet stage
  const c = box / 2
  const r = (spec.size / 180) * (box / 2) // scale halo relative to 180-pet
  const animatedProps = useGlowPulse(spec.pulseDuration, c, c)
  return (
    <Svg
      width={box}
      height={box}
      style={StyleSheet.absoluteFill}
    >
      <Defs>
        <RadialGradient
          id="halo"
          cx="50%"
          cy="50%"
          r="50%"
        >
          <Stop
            offset="0"
            stopColor={spec.color}
            stopOpacity={spec.opacity}
          />
          <Stop
            offset="0.68"
            stopColor={spec.color}
            stopOpacity={0}
          />
        </RadialGradient>
        <Filter
          id="haloBlur"
          x="-50%"
          y="-50%"
          width="200%"
          height="200%"
        >
          <FeGaussianBlur stdDeviation="4" />
        </Filter>
      </Defs>

      <AnimatedG animatedProps={animatedProps as any}>
        <Circle
          cx={c}
          cy={c}
          r={r}
          fill="url(#halo)"
          filter="url(#haloBlur)"
        />
      </AnimatedG>
    </Svg>
  )
}

export default Halo
