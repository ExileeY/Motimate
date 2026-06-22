import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Text as SvgText } from 'react-native-svg'
import Animated from 'react-native-reanimated'
import { useZFloat } from '@/components/pet/animations'

const AG = Animated.createAnimatedComponent(G)

const BOX_SIZE = 236 // 236×236 box: Stage
const PET_SIZE = 180 // 180×180 box: Pet

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

const ZGlyph = ({ offsetX, fontSize, delay, label, scale }: (typeof Z_SPECS)[number] & { scale: number }) => {
  const cx = (ZZZ_POSITION.x + offsetX) * scale
  const cy = (ZZZ_POSITION.y + fontSize) * scale
  const animatedProps = useZFloat(3400, delay, cx, cy)
  return (
    <AG animatedProps={animatedProps as any}>
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
        scale={size / BOX_SIZE}
        {...zSpec}
      />
    ))}
  </Svg>
)

export default Zzz
