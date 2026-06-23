/**
 * Particles — the energetic mood's floating warm specks (`floatUp`). Each is a
 * small rounded square rotated 45° that rises ~40px while fading in then out.
 *
 * Coords are authored directly in the 236 *stage* box (same frame as Zzz and
 * the Halo) and scaled by `size / STAGE_SIZE`. Earlier these were authored in a
 * 180 *pet* box and scaled by size/180, which both over-spread the cluster and
 * dropped the (236-180)/2=28 centering inset — shifting every speck left of the
 * head.
 *
 * Unlike Zzz, the specks are NOT lifted verbatim from happy.dc.html: the mockup
 * is left-weighted (its biggest, most opaque speck sits far left), which read as
 * the whole cluster bunching left of the pet. Instead they're authored as two
 * mirrored pairs around the pet center (STAGE_CENTER = 118) so they sit balanced
 * left/right behind the pet — don't "restore" the mockup's left/right values.
 *
 * Crucial: Particles render BEHIND Mochi (Glow is drawn before Mochi in
 * PetStage), so any speck over the head silhouette is occluded. The head spans
 * roughly stage-x 44–192, stage-y 54–210 (the 148×140 head at pet (16,26),
 * +28 stage inset). The floatUp rise lifts each speck up to ~40px, so specks are
 * kept in the empty band ABOVE the head (low y, ~10–30) and toward the sides,
 * where they stay visible across the whole rise — NOT directly over the head.
 */
import React from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Rect } from 'react-native-svg'
import Animated, { useAnimatedProps } from 'react-native-reanimated'

import { BOX_SIZE, BOX_CENTER } from '@/constants/pet/dimensions'

import {
  calcTransform,
  calcTriangleOpacity,
  linearInterpolate
} from '@/components/pet/Glow/utils'

import useRise from '@/components/pet/hooks/useRise'

const TRANSLATE_Y = {
  min: 10,
  max: -40,
}

const SCALE = {
  min: 0.6,
  max: 1,
}

const FADE_IN = 0.28

const useFloatUp = (durationMs: number, delayMs: number, cx: number, cy: number) => {
  const progress = useRise(durationMs, delayMs)

  return useAnimatedProps(() => {
    const scale = linearInterpolate(SCALE.min, SCALE.max, progress.value)
    const translateY = linearInterpolate(TRANSLATE_Y.min, TRANSLATE_Y.max, progress.value)

    return {
      opacity: calcTriangleOpacity(progress.value, FADE_IN),
      transform: calcTransform(scale, cx, cy, 0, translateY)
    }
  })
}

const PARTICLES = [
  {
    x: BOX_CENTER - 70,
    y: 30,
    r: 9,
    color: '#F4A38C',
    dur: 3400,
    delay: 0
  },
  {
    x: BOX_CENTER + 70,
    y: 30,
    r: 9,
    color: '#F4A38C',
    dur: 4400,
    delay: 2600
  },
  {
    x: BOX_CENTER - 34,
    y: 10,
    r: 6,
    color: '#EF9A8E',
    dur: 3800,
    delay: 1800
  },
  {
    x: BOX_CENTER + 34,
    y: 10,
    r: 6,
    color: '#F6C07A',
    dur: 4000,
    delay: 900
  }
]

const AnimatedG = Animated.createAnimatedComponent(G)

const Particle = ({ x, y, r, color, dur, delay, scale }: (typeof PARTICLES)[number] & { scale: number }) => {
  const cx = x * scale
  const cy = y * scale
  const animatedProps = useFloatUp(dur, delay, cx, cy)
  return (
    <AnimatedG animatedProps={animatedProps as any}>
      <Rect
        x={cx - r}
        y={cy - r}
        width={r * 2}
        height={r * 2}
        rx={r * 0.4}
        fill={color}
        transform={`rotate(45 ${cx} ${cy})`}
      />
    </AnimatedG>
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
        scale={size / BOX_SIZE}
        {...props}
      />
    ))}
  </Svg>
)

export default Particles
