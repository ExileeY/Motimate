/**
 * Particles — the energetic mood's floating warm specks (`floatUp`). Each is a
 * small rounded square rotated 45°.
 *
 * Coords are authored in a 180 box and scaled to the stage (236). The pet body
 * fills roughly x∈[16,164] y∈[26,166] of that box, so the mockup's original
 * particle spots (x 60–122, y 60–96) sat *on top of* Mochi and were hidden.
 * We push them out into the halo margin — flanking the head left/right and
 * rising from above the shoulders — and scale them up so they read clearly.
 */
import React, { useEffect } from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Rect } from 'react-native-svg'
import Animated, { useAnimatedProps, useSharedValue, withRepeat, withTiming, withDelay, Easing } from 'react-native-reanimated'

const AG = Animated.createAnimatedComponent(G)

const easeInOut = Easing.inOut(Easing.ease)

const lerp = (min: number, max: number, progress: number) =>
  min + (max - min) * progress

// floatUp animates these as the particle rises over one cycle (progress 0→1).
const TRANSLATE_Y = {
  min: 10,
  max: -40,
}

const SCALE = {
  min: 0.6,
  max: 1,
}

// Opacity is a triangle: it fades in until FADE_IN, then back out to 0.
const FADE_IN = 0.28

const triangleOpacity = (progress: number) =>
  progress < FADE_IN ? progress / FADE_IN : 1 - (progress - FADE_IN) / (1 - FADE_IN)

/**
 * floatUp: a particle that rises ~40px while fading in then out, repeating.
 * Drives a single <G>; caller positions it. `delayMs` staggers particles.
 */
const useFloatUp = (durationMs: number, delayMs: number) => {
  const progress = useSharedValue(0)
  useEffect(() => {
    progress.value = withDelay(delayMs, withRepeat(withTiming(1, { duration: durationMs, easing: easeInOut }), -1, false))
  }, [durationMs, delayMs, progress])

  return useAnimatedProps(() => {
    const y = lerp(TRANSLATE_Y.min, TRANSLATE_Y.max, progress.value)
    const scale = lerp(SCALE.min, SCALE.max, progress.value)
    const opacity = triangleOpacity(progress.value)

    return {
      opacity,
      transform: `translate(0 ${y}) scale(${scale})`,
    }
  })
}

const PARTICLES = [
  {
    x: 24,
    y: 86,
    r: 8,
    color: '#F4A38C',
    dur: 3400,
    delay: 0
  },
  {
    x: 156,
    y: 96,
    r: 6.5,
    color: '#F6C07A',
    dur: 4000,
    delay: 900
  },
  {
    x: 40,
    y: 34,
    r: 6,
    color: '#EF9A8E',
    dur: 3800,
    delay: 1800
  },
  {
    x: 140,
    y: 30,
    r: 7,
    color: '#F4A38C',
    dur: 4400,
    delay: 2600
  },
]

const Particle = ({ x, y, r, color, dur, delay, scale }: (typeof PARTICLES)[number] & { scale: number }) => {
  const animatedProps = useFloatUp(dur, delay)
  return (
    <AG animatedProps={animatedProps as any}>
      {/* small rounded square, rotated 45° like the mockup */}
      <Rect
        x={x * scale - r}
        y={y * scale - r}
        width={r * 2}
        height={r * 2}
        rx={r * 0.4}
        fill={color}
        transform={`rotate(45 ${x * scale} ${y * scale})`}
      />
    </AG>
  )
}

const Particles = ({ size }: { size: number }) => (
  <Svg
    width={size}
    height={size}
    style={StyleSheet.absoluteFill}
    pointerEvents="none"
  >
    {PARTICLES.map((props, index) => (
      <Particle
        key={index}
        scale={size / 180}
        {...props}
      />
    ))}
  </Svg>
)

export default Particles
