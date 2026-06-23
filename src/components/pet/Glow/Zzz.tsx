import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Text as SvgText } from 'react-native-svg'
import Animated, { useAnimatedProps } from 'react-native-reanimated'

import { BOX_SIZE, PET_SIZE } from '@/constants/pet/dimensions'

import {
  calcTransform,
  calcTriangleOpacity,
  linearInterpolate
} from '@/components/pet/Glow/utils'

import { useRise } from '@/components/pet/hooks/useLoop'

// zfloat animates these as the glyph rises and drifts over one cycle (0→1).
const TRANSLATE_X = {
  min: 0,
  max: 16,
}

const TRANSLATE_Y = {
  min: 8,
  max: -30,
}

const SCALE = {
  min: 0.7,
  max: 1.15,
}

const FADE_IN = 0.25

const useZFloat = (durationMs: number, delayMs: number, cx: number, cy: number) => {
  const progress = useRise(durationMs, delayMs)

  return useAnimatedProps(() => {
    const scale = linearInterpolate(SCALE.min, SCALE.max, progress.value)
    const translateX = linearInterpolate(TRANSLATE_X.min, TRANSLATE_X.max, progress.value)
    const translateY = linearInterpolate(TRANSLATE_Y.min, TRANSLATE_Y.max, progress.value)

    return {
      opacity: calcTriangleOpacity(progress.value, FADE_IN),
      transform: calcTransform(scale, cx, cy, translateX, translateY)
    }
  })
}

const PET_TOP_LEFT = (BOX_SIZE - PET_SIZE) / 2 // 28: pet body's top-left in the stage
const ZZZ_POSITION = {
  x: PET_TOP_LEFT + 150,
  y: PET_TOP_LEFT + 20
}

const Z_SPECS = [
  {
    label: 'z',
    offsetX: 0,
    fontSize: 20,
    delay: 0
  },
  {
    label: 'z',
    offsetX: 15,
    fontSize: 25,
    delay: 1100
  },
  {
    label: 'Z',
    offsetX: 30,
    fontSize: 30,
    delay: 2200
  },
]

const AnimatedG = Animated.createAnimatedComponent(G)

const ZGlyph = ({ offsetX, fontSize, delay, label, scale }: (typeof Z_SPECS)[number] & { scale: number }) => {
  const cx = (ZZZ_POSITION.x + offsetX) * scale
  const cy = (ZZZ_POSITION.y + fontSize) * scale
  const animatedProps = useZFloat(3400, delay, cx, cy)
  return (
    <AnimatedG animatedProps={animatedProps as any}>
      <SvgText
        x={cx}
        y={cy}
        fontFamily="Fredoka_600SemiBold"
        fontWeight="600"
        fontSize={fontSize * scale}
        fill="#A9794F"
      >
        {label}
      </SvgText>
    </AnimatedG>
  )
}

const Zzz = ({ size }: { size: number }) => (
  <Svg
    width={size}
    height={size}
    style={StyleSheet.absoluteFill}
    pointerEvents="none"
  >
    {Z_SPECS.map((zSpec, index) => (
      <ZGlyph
        key={index}
        scale={size / BOX_SIZE}
        {...zSpec}
      />
    ))}
  </Svg>
)

export default Zzz
