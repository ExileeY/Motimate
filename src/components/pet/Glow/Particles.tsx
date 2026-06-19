/**
 * Particles — the energetic mood's floating warm specks (`floatUp`). Specs are
 * from the happy mockup (left/right + top → x,y in a 180 box, re-centered around
 * the pet); color/size/delay preserved. Each is a small rounded square rotated 45°.
 */
import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Rect } from 'react-native-svg'
import Animated from 'react-native-reanimated'
import { useFloatUp } from '@/components/pet/animations'

const AG = Animated.createAnimatedComponent(G)

const PARTICLES = [
  {
    x: 60,
    y: 80,
    r: 5.5,
    color: '#F4A38C',
    dur: 3400,
    delay: 0
  },
  {
    x: 122,
    y: 96,
    r: 4,
    color: '#F6C07A',
    dur: 4000,
    delay: 900
  },
  {
    x: 92,
    y: 60,
    r: 3.5,
    color: '#EF9A8E',
    dur: 3800,
    delay: 1800
  },
  {
    x: 96,
    y: 70,
    r: 4.5,
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
