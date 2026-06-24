/**
 * Octopus — the eight-armed companion, hand-authored in react-native-svg from
 * the exact mockup geometry (`mkps/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds the Octopus from absolutely-positioned <div>s inside a
 * 180×180 wrapper — the same box every pet uses — so we mirror it 1:1 into a
 * `0 0 180 180` viewBox (K=1.0, no per-pet scaling). Coordinate conversions
 * mirror Dog/index.tsx:
 *   left/top            → x / y directly
 *   right:R / bottom:B  → x = 180 - R - w ; y = 180 - B - h
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   box-shadow inset    → explicit overlay gradient <Path> (SVG has no
 *                         box-shadow; same technique as Mochi's head shade/rim)
 *
 * Z-order from the mockup (tentacles z1, head z2): we paint tentacles → head →
 * face, so the head overlaps the tentacle tops. The mockup wiggles each tentacle
 * with its own keyframe; like every other pet here the Octopus is static SVG
 * (whole-body bob/breathe/sway is driven from PetStage), so the tentacles hold a
 * fixed pose.
 *
 * The body (tentacles/head) is identical across all moods; only the eyes/mouth
 * vary — those live in ./Face.tsx, composed here inside the same <Svg> so the
 * face can reference the #soft blur filter.
 */
import React from 'react'
import Svg, {
  Defs,
  RadialGradient,
  LinearGradient,
  Stop,
  Filter,
  FeGaussianBlur,
  G,
  Path,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Octopus/Face'

const SIZE = PET_SIZE

const HEAD = {
  x: (SIZE - 142) / 2, // left:50% → centered, 19
  y: 18,
  w: 142,
  h: 118,
}

const headPathD = () =>
  roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
    [0.48, 0.6],
    [0.48, 0.6],
    [0.44, 0.4],
    [0.44, 0.4],
  ])

// Six arms
const TENTACLE = { w: 20, gap: 2, y: 120 }
const TENTACLE_HEIGHTS = [40, 50, 46, 52, 44, 38]

const TENTACLE_BOX_W = TENTACLE_HEIGHTS.length * TENTACLE.w + (TENTACLE_HEIGHTS.length - 1) * TENTACLE.gap
const TENTACLE_START_X = (SIZE - TENTACLE_BOX_W) / 2

const tentaclePathD = (x: number, h: number) =>
  roundedBoxPath(x, TENTACLE.y, TENTACLE.w, h, [
    [0.4, 0.18],
    [0.4, 0.18],
    [0.5, 0.82],
    [0.5, 0.82],
  ])

const tentacles = () =>
  TENTACLE_HEIGHTS.map((h, i) => (
    <Path
      key={i}
      d={tentaclePathD(TENTACLE_START_X + i * (TENTACLE.w + TENTACLE.gap), h)}
      fill="url(#oArm)"
    />
  ))

interface OctopusProps {
  mood: Mood
  size?: number
}

const Octopus = ({ mood, size = SIZE }: OctopusProps) => (
  <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
    <Defs>
      {/* Tentacles */}
      <LinearGradient id="oArm" x1="0" y1="0" x2="0" y2="1">
        <Stop offset="0" stopColor="#E58A7B" />
        <Stop offset="1" stopColor="#D5715F" />
      </LinearGradient>

      {/* Head body */}
      <RadialGradient id="oHead" cx="50%" cy="24%" r="115%">
        <Stop offset="0" stopColor="#F4AE9D" />
        <Stop offset="0.66" stopColor="#E58A7B" />
        <Stop offset="1" stopColor="#D5715F" />
      </RadialGradient>
      <RadialGradient id="oHeadShade" cx="50%" cy="100%" r="60%">
        <Stop offset="0.55" stopColor="#A54637" stopOpacity={0} />
        <Stop offset="1" stopColor="#A54637" stopOpacity={0.28} />
      </RadialGradient>
      <RadialGradient id="oHeadRim" cx="50%" cy="0%" r="44%">
        <Stop offset="0" stopColor="#FFE0D4" stopOpacity={0.55} />
        <Stop offset="1" stopColor="#FFE0D4" stopOpacity={0} />
      </RadialGradient>

      <Filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
        <FeGaussianBlur stdDeviation="1.08" />
      </Filter>
    </Defs>

    {/* Tentacles */}
    <G>{tentacles()}</G>

    {/* Head */}
    <G>
      <Path
        d={headPathD()}
        fill="url(#oHead)"
      />
      <Path
        d={headPathD()}
        fill="url(#oHeadShade)"
      />
      <Path
        d={headPathD()}
        fill="url(#oHeadRim)"
      />
    </G>

    {/* Face */}
    <Face
      mood={mood}
      ox={0}
      oy={0}
    />
  </Svg>
)

export default Octopus
