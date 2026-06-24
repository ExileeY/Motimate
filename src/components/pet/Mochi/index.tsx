/**
 * Mochi — the cat companion, hand-authored in react-native-svg from the exact
 * mockup geometry (`Mockups/Emotions/Mochi/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds Mochi from absolutely-positioned <div>s inside a 180×180
 * box. We mirror that into a `0 0 180 180` viewBox. Coordinate conversions:
 *   left/top            → x/y directly
 *   right:R / bottom:B  → x = 180 - R - w ; y = 180 - B - h
 *   elliptical radii    → <Ellipse rx ry>, or for asymmetric per-corner
 *                         radii (head, ears) a <Path> via roundedBoxPath()
 *   radial-gradient     → <RadialGradient>
 *   filter:blur         → <FeGaussianBlur> filter
 *   transform:rotate    → group/shape rotation about the shape center
 *
 * Volume — the mockup gets its roundness from CSS `box-shadow`s, which SVG has
 * no equivalent for. We reproduce the *inset* shading explicitly (the outer
 * cast/drop shadow is intentionally omitted):
 *   head  inset 0 -12px 20px (165,92,50,.28)  → bottom core-shadow gradient
 *         inset 0 6px 14px   (255,224,196,.55) → top rim highlight gradient
 *   tail  inset 0 -4px 8px   (170,95,50,.25)   → bottom shade gradient
 *   feet  inset 0 3px 5px    (255,224,196,.5)  → top highlight gradient
 * Without these the shapes read as flat fills (the "cheap" look).
 *
 * Whole-body motion (bob/breathe/sway) is driven from the parent (PetStage) as
 * View-level transforms; Mochi itself is static SVG. Per-part SVG-group
 * animation is not currently used.
 *
 * This file renders the body; the per-mood face lives in ./Face.tsx, composed
 * here as <Face> inside the same <Svg> (so it can reference the #soft filter).
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
  Ellipse,
  Path,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Mochi/Face'

const SIZE = 180
const HEAD = {
  x: (SIZE - 148) / 2,
  y: 26,
  w: 148,
  h: 140
}

interface MochiProps {
  mood: Mood
  size?: number
}

const Mochi = ({ mood, size = SIZE }: MochiProps) => {
  const head = headPathD()

  return (
    <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
      <Defs>
        {/* Head */}
        <RadialGradient id="head" cx="50%" cy="22%" r="115%">
          <Stop offset="0" stopColor="#F3BC92" />
          <Stop offset="0.68" stopColor="#E2935F" />
          <Stop offset="1" stopColor="#D27F4C" />
        </RadialGradient>
        <RadialGradient id="headShade" cx="50%" cy="100%" r="62%">
          <Stop offset="0.55" stopColor="#A55C32" stopOpacity={0} />
          <Stop offset="1" stopColor="#A55C32" stopOpacity={0.32} />
        </RadialGradient>
        <RadialGradient id="headHighlight" cx="50%" cy="0%" r="48%">
          <Stop offset="0" stopColor="#FFE0C4" stopOpacity={0.6} />
          <Stop offset="1" stopColor="#FFE0C4" stopOpacity={0} />
        </RadialGradient>

        {/* Ears */}
        <RadialGradient id="ear" cx="50%" cy="70%" r="80%">
          <Stop offset="0" stopColor="#E89A6C" />
          <Stop offset="1" stopColor="#DB8753" />
        </RadialGradient>

        {/* Muzzle highlight */}
        <RadialGradient id="muzzle" cx="50%" cy="40%" r="50%">
          <Stop offset="0" stopColor="#FFEAD2" stopOpacity={0.85} />
          <Stop offset="0.7" stopColor="#FFEAD2" stopOpacity={0} />
        </RadialGradient>

        {/* Tail */}
        <LinearGradient id="tail" x1="0" y1="0" x2="0" y2="1">
          <Stop offset="0" stopColor="#E29460" />
          <Stop offset="0.6" stopColor="#DE8E5B" />
          <Stop offset="1" stopColor="#C0703F" />
        </LinearGradient>

        {/* Feets */}
        <LinearGradient id="foot" x1="0" y1="0" x2="0" y2="1">
          <Stop offset="0" stopColor="#F6C8A6" />
          <Stop offset="0.55" stopColor="#E89A6C" />
          <Stop offset="1" stopColor="#E2935F" />
        </LinearGradient>

        <Filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
          <FeGaussianBlur stdDeviation="1.2" />
        </Filter>
      </Defs>

      {/* Tail */}
      <Ellipse
        cx={145}
        cy={138}
        rx={27}
        ry={12}
        fill="url(#tail)"
        transform="rotate(28 145 138)"
      />

      {/* Ears */ }
      <G transform="rotate(-15 56 30)">
        <Path
          d={outerEarPathD(36, 4)}
          fill="url(#ear)"
        />
        <Path
          d={innerEarPathD(48, 28)}
          fill="#EFA9A0"
          opacity={0.8}
        />
      </G>
      <G transform="rotate(15 124 30)">
        <Path
          d={outerEarPathD(104, 4)}
          fill="url(#ear)"
        />
        <Path
          d={innerEarPathD(116, 28)}
          fill="#EFA9A0"
          opacity={0.8}
        />
      </G>

      {/* Head */}
      <G>
        <Path d={head} fill="url(#head)" />
        <Path d={head} fill="url(#headShade)" />
        <Path d={head} fill="url(#headHighlight)" />
      </G>

      {/* Muzzle */}
      <Ellipse
        cx={HEAD.x + HEAD.w / 2}
        cy={HEAD.y + HEAD.h - 14 - 31}
        rx={39}
        ry={31}
        fill="url(#muzzle)"
      />

      <Face
        mood={mood}
        ox={HEAD.x}
        oy={HEAD.y}
      />

      {/* Feets */}
      <G>
        <Ellipse cx={69} cy={165} rx={15} ry={9} fill="url(#foot)" />
        <Ellipse cx={111} cy={165} rx={15} ry={9} fill="url(#foot)" />
      </G>
    </Svg>
  )
}

export default Mochi

const headPathD = () =>
  roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
    [0.5, 0.54],
    [0.5, 0.54],
    [0.47, 0.46],
    [0.47, 0.46],
  ])

const OUTER_EAR_DIMENSIONS = { w: 40, h: 52 }
const INNER_EAR_DIMENSIONS = { w: 16, h: 24 }

const outerEarPathD = (x: number, y: number) =>
  roundedBoxPath(x, y, OUTER_EAR_DIMENSIONS.w, OUTER_EAR_DIMENSIONS.h, [
    [0.62, 0.8],
    [0.62, 0.8],
    [0.38, 0.26],
    [0.38, 0.26],
  ])

const innerEarPathD = (x: number, y: number) =>
  roundedBoxPath(x, y, INNER_EAR_DIMENSIONS.w, INNER_EAR_DIMENSIONS.h, [
    [0.6, 0.75],
    [0.6, 0.75],
    [0.4, 0.25],
    [0.4, 0.25],
  ])
