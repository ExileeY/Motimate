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
import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Rect } from 'react-native-svg'
import Animated from 'react-native-reanimated'
import { useFloatUp } from '@/components/pet/animations'

const AG = Animated.createAnimatedComponent(G)

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
