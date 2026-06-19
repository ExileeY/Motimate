/**
 * Zzz — the tired mood's rising "z z Z" glyphs (`zfloat`). Three glyphs of
 * growing size drift up on staggered delays; the last is a capital Z.
 */
import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Text as SvgText } from 'react-native-svg'
import Animated from 'react-native-reanimated'
import { useZFloat } from '@/components/pet/animations'

const AG = Animated.createAnimatedComponent(G)

const Z_SPECS = [
  {
    x: 132,
    y: 44,
    size: 13,
    delay: 0
  },
  {
    x: 141,
    y: 44,
    size: 17,
    delay: 1100
  },
  {
    x: 152,
    y: 44,
    size: 22,
    delay: 2200
  },
]

const ZGlyph = ({ x, y, size, delay, scale, label }: (typeof Z_SPECS)[number] & { scale: number; label: string }) => {
  const animatedProps = useZFloat(3400, delay)
  return (
    <AG animatedProps={animatedProps as any}>
      <SvgText
        x={x * scale}
        y={y * scale}
        fontFamily="Fredoka_600SemiBold"
        fontSize={size * scale}
        fill="#A9794F"
      >
        {label}
      </SvgText>
    </AG>
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
        label={index === 2 ? 'Z' : 'z'}
        scale={size / 180}
        {...zSpec}
      />
    ))}
  </Svg>
)

export default Zzz
