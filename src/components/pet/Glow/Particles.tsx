/**
 * Particles — the energetic mood's floating warm specks (`floatUp`). Each is a
 * small rounded square rotated 45°.
 *
 * Coords are authored directly in the 236 *stage* box (same frame as Zzz and
 * the Halo) and scaled by `size / BOX_SIZE`. Earlier these were authored in a
 * 180 *pet* box and scaled by size/180, which both over-spread the cluster and
 * dropped the (236-180)/2=28 centering inset — shifting every speck left of the
 * head.
 *
 * Unlike Zzz, the specks are NOT lifted verbatim from happy.dc.html: the mockup
 * is left-weighted (its biggest, most opaque speck sits far left), which read as
 * the whole cluster bunching left of the pet. Instead they're authored as two
 * mirrored pairs around the pet center (CENTER = 118 in the 236 stage box) so
 * they sit balanced left/right behind the pet — don't "restore" the mockup's
 * left/right values here.
 *
 * Crucial: Particles render BEHIND Mochi (Glow is drawn before Mochi in
 * PetStage), so any speck over the head silhouette is occluded. The head spans
 * roughly stage-x 44–192, stage-y 54–210 (the 148×140 head at pet (16,26),
 * +28 stage inset). The floatUp animation also lifts each speck up to ~40px, so
 * specks are kept in the empty band ABOVE the head (low y, ~32–58) and toward
 * the sides, where they stay visible across the whole rise — NOT directly over
 * the head/ear fills.
 */
import React, { useEffect } from 'react'
import { StyleSheet } from 'react-native'
import Svg, { G, Rect } from 'react-native-svg'
import Animated, { useAnimatedProps, useSharedValue, withRepeat, withTiming, withDelay, Easing } from 'react-native-reanimated'

const AG = Animated.createAnimatedComponent(G)

const easeInOut = Easing.inOut(Easing.ease)

const lerp = (min: number, max: number, progress: number) => {
  'worklet'
  return min + (max - min) * progress
}

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

const triangleOpacity = (progress: number) => {
  'worklet'
  return progress < FADE_IN ? progress / FADE_IN : 1 - (progress - FADE_IN) / (1 - FADE_IN)
}

/**
 * floatUp: a particle that rises ~40px while fading in then out, repeating.
 * Drives a single <G>; caller positions it. `delayMs` staggers particles.
 *
 * Like Zzz's zfloat: an SVG <G> scale() is about the group origin (0,0), so a
 * particle sitting at stage-x 118 would be pulled toward the origin (~118*0.6
 * left) for most of the cycle, drifting it left of where it's authored. The
 * caller passes the particle's scaled centre (cx, cy) so we scale about it
 * (translate→scale→translate-back), keeping it put.
 */
const useFloatUp = (durationMs: number, delayMs: number, cx: number, cy: number) => {
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
      transform: `translate(0 ${y}) translate(${cx} ${cy}) scale(${scale}) translate(${-cx} ${-cy})`,
    }
  })
}

const BOX_SIZE = 236
const BOX_CENTER = BOX_SIZE / 2

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

const Particle = ({ x, y, r, color, dur, delay, scale }: (typeof PARTICLES)[number] & { scale: number }) => {
  const cx = x * scale
  const cy = y * scale
  const animatedProps = useFloatUp(dur, delay, cx, cy)
  return (
    <AG animatedProps={animatedProps as any}>
      {/* small rounded square, rotated 45° like the mockup */}
      <Rect
        x={cx - r}
        y={cy - r}
        width={r * 2}
        height={r * 2}
        rx={r * 0.4}
        fill={color}
        transform={`rotate(45 ${cx} ${cy})`}
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
        scale={size / BOX_SIZE}
        {...props}
      />
    ))}
  </Svg>
)

export default Particles
