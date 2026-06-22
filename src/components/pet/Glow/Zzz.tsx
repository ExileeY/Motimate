import React, { useEffect } from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Text as SvgText } from 'react-native-svg'
import Animated, { useAnimatedProps, useSharedValue, withRepeat, withTiming, withDelay, Easing } from 'react-native-reanimated'

const AG = Animated.createAnimatedComponent(G)

const easeInOut = Easing.inOut(Easing.ease)

const lerp = (min: number, max: number, progress: number) =>
  min + (max - min) * progress

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

// Opacity is a triangle: it fades in until FADE_IN, then back out to 0.
const FADE_IN = 0.25

const triangleOpacity = (progress: number) =>
  progress < FADE_IN ? progress / FADE_IN : 1 - (progress - FADE_IN) / (1 - FADE_IN)

/**
 * zfloat: a "Z" that rises ~30px, drifts +16px right, scales .7 → 1.15, fading.
 *
 * The mockup's CSS `scale()` is about the glyph's own centre; an SVG <G> scale
 * is about the group origin (0,0), which would fling the glyph across the stage
 * since it sits ~166px from the origin. The caller passes the glyph anchor
 * (cx, cy) so we scale about it (translate→scale→translate-back), keeping the
 * letters put beside the head — matching the mockup.
 */
const useZFloat = (durationMs: number, delayMs: number, cx: number, cy: number) => {
  const progress = useSharedValue(0)
  useEffect(() => {
    progress.value = withDelay(delayMs, withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false))
  }, [durationMs, delayMs, progress])

  return useAnimatedProps(() => {
    const x = lerp(TRANSLATE_X.min, TRANSLATE_X.max, progress.value)
    const y = lerp(TRANSLATE_Y.min, TRANSLATE_Y.max, progress.value)
    const scale = lerp(SCALE.min, SCALE.max, progress.value)
    const opacity = triangleOpacity(progress.value)

    return {
      opacity,
      transform: `translate(${x} ${y}) translate(${cx} ${cy}) scale(${scale}) translate(${-cx} ${-cy})`,
    }
  })
}

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
