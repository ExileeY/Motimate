/**
 * Halo — the soft radial-gradient glow behind the pet. A blurred circle that
 * `glowPulse`s, in its own absolutely-positioned SVG layer so it sits behind
 * Mochi and scales freely. Color/opacity/size come from `glow[mood]` tokens.
 */
import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { Defs, RadialGradient, Stop, Filter, FeGaussianBlur, G, Circle } from 'react-native-svg'
import Animated from 'react-native-reanimated'
import { Mood } from '@/mood/mood'
import { glow as glowTokens } from '@/theme/tokens'
import { useGlowPulse } from '@/components/pet/animations'

const AG = Animated.createAnimatedComponent(G)

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
      <AG animatedProps={animatedProps as any}>
        <Circle
          cx={c}
          cy={c}
          r={r}
          fill="url(#halo)"
          filter="url(#haloBlur)"
        />
      </AG>
    </Svg>
  )
}

export default Halo
