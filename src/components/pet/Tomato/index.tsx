/**
 * Tomato — the Spanish tomato companion, hand-authored in react-native-svg from
 * the exact mockup geometry (`mkps/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds the pet from absolutely-positioned <div>s inside a 196×196
 * wrapper. We author the artwork directly in those 196 mockup coordinates (so
 * every value maps 1:1 to the mockup), then render into the shared `PET_SIZE`
 * (180) viewBox every pet uses by wrapping the whole drawing in a single
 * `scale(PET_SIZE / 196)` group — Khinklear (same 196 mockup) scales the same
 * way. A single square `size` from PetStage then scales the result undistorted.
 * Coordinate conversions mirror Bulbashik/index.tsx:
 *   left/top            → x / y
 *   right:R / bottom:B  → x = 196 - R - w ; y = 196 - B - h
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   transform:rotate    → group/shape rotation about the shape center
 *   box-shadow inset    → explicit overlay gradient <Path> over the same shape
 *                         (SVG has no box-shadow; same technique as Bulbashik)
 *
 * Z-order from the mockup (calyx z3, leaf-arms z1, body z2): we paint
 * arms → body → calyx-stem-behind? No — the mockup stacks calyx (z3) above body
 * (z2) above arms (z1). We paint arms → body → face → calyx so the green crown
 * sits in front of the body's top, exactly as the mockup composites.
 *
 * The body (calyx/tomato/arms, plus the mood-independent lobe shading and
 * dimple) is identical across moods; only the brows/eyes/mustache/mouth vary —
 * those live in ./Face.tsx, composed here inside the same <Svg>.
 *
 * Whole-body motion (bob/breathe/sway) is driven from PetStage as View-level
 * transforms; Tomato itself is static SVG.
 */
import React from 'react'
import Svg, {
  Defs,
  RadialGradient,
  LinearGradient,
  Stop,
  G,
  Rect,
  Ellipse,
  Path,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Tomato/Face'

const NATIVE_SIZE = 196
const SIZE = PET_SIZE
const SCALE = SIZE / NATIVE_SIZE
const CX = NATIVE_SIZE / 2

const BODY = {
  x: (NATIVE_SIZE - 152) / 2,
  y: 48,
  w: 152,
  h: 138,
}

const bodyPathD = () =>
  roundedBoxPath(BODY.x, BODY.y, BODY.w, BODY.h, [
    [0.49, 0.45],
    [0.49, 0.45],
    [0.5, 0.55],
    [0.5, 0.55],
  ])

type LeafProps = {
  x: number
  y: number
  w: number
  h: number
  deg: number
  fill: string
  flip?: boolean
}
const Leaf = ({ x, y, w, h, deg, fill, flip }: LeafProps) => (
  <Path
    d={roundedBoxPath(
      x,
      y,
      w,
      h,
      flip
        ? [
            [0.08, 0.08],
            [0.62, 0.62],
            [0.08, 0.08],
            [0.62, 0.62],
          ]
        : [
            [0.62, 0.62],
            [0.08, 0.08],
            [0.62, 0.62],
            [0.08, 0.08],
          ],
    )}
    fill={fill}
    transform={`rotate(${deg} ${x + w / 2} ${y + h / 2})`}
  />
)

interface TomatoProps {
  mood: Mood
  size?: number
}

const Tomato = ({ mood, size = SIZE }: TomatoProps) => (
  <Svg
    width={size}
    height={size}
    viewBox={`0 0 ${SIZE} ${SIZE}`}
  >
    <Defs>
      {/* body */}
      <RadialGradient id="tBody" cx="40%" cy="24%" r="116%">
        <Stop offset="0" stopColor="#FF8468" />
        <Stop offset="0.54" stopColor="#E84A30" />
        <Stop offset="1" stopColor="#C0331F" />
      </RadialGradient>
      {/* inset 0 -16px 26px rgba(120,25,15,.34) — bottom core shade */}
      <RadialGradient id="tBodyShade" cx="50%" cy="100%" r="64%">
        <Stop offset="0.45" stopColor="#781910" stopOpacity={0} />
        <Stop offset="1" stopColor="#781910" stopOpacity={0.34} />
      </RadialGradient>
      {/* inset 0 9px 16px rgba(255,205,180,.5) — top rim highlight */}
      <RadialGradient id="tBodyRim" cx="50%" cy="0%" r="46%">
        <Stop offset="0" stopColor="#FFCDB4" stopOpacity={0.5} />
        <Stop offset="1" stopColor="#FFCDB4" stopOpacity={0} />
      </RadialGradient>
      {/* top-left soft sheen (left:28 top:14 42×32 radial) */}
      <RadialGradient id="tSheen" cx="40%" cy="35%" r="60%">
        <Stop offset="0" stopColor="#FFE4D6" stopOpacity={0.6} />
        <Stop offset="0.7" stopColor="#FFE4D6" stopOpacity={0} />
      </RadialGradient>
      {/* top dimple shadow (top:-4 56×18 radial) */}
      <RadialGradient id="tDimple" cx="50%" cy="0%" r="100%">
        <Stop offset="0" stopColor="#6E190F" stopOpacity={0.5} />
        <Stop offset="0.74" stopColor="#6E190F" stopOpacity={0} />
      </RadialGradient>
      {/* faint vertical lobe-shading stripe */}
      <RadialGradient id="tLobe" cx="50%" cy="50%" r="50%">
        <Stop offset="0" stopColor="#781E12" stopOpacity={0.16} />
        <Stop offset="0.75" stopColor="#781E12" stopOpacity={0} />
      </RadialGradient>

      {/* calyx greens */}
      <LinearGradient id="tStem" x1="0" y1="0" x2="0" y2="1">
        <Stop offset="0" stopColor="#7BA844" />
        <Stop offset="1" stopColor="#5C8233" />
      </LinearGradient>
      <RadialGradient id="tBud" cx="50%" cy="30%" r="60%">
        <Stop offset="0" stopColor="#ACD972" />
        <Stop offset="1" stopColor="#6FA23E" />
      </RadialGradient>
      <RadialGradient id="tLeafA" cx="32%" cy="30%" r="78%">
        <Stop offset="0" stopColor="#93C95B" />
        <Stop offset="1" stopColor="#5E9233" />
      </RadialGradient>
      <RadialGradient id="tLeafB" cx="32%" cy="30%" r="78%">
        <Stop offset="0" stopColor="#8AC153" />
        <Stop offset="1" stopColor="#57892E" />
      </RadialGradient>

      {/* leaf arms */}
      <RadialGradient id="tArmL" cx="30%" cy="40%" r="80%">
        <Stop offset="0" stopColor="#8AC153" />
        <Stop offset="1" stopColor="#5C8A30" />
      </RadialGradient>
      <RadialGradient id="tArmR" cx="70%" cy="40%" r="80%">
        <Stop offset="0" stopColor="#8AC153" />
        <Stop offset="1" stopColor="#5C8A30" />
      </RadialGradient>
    </Defs>

    <G transform={`scale(${SCALE})`}>
    {/* Leaf arms */}
    <Path
      d={roundedBoxPath(8, 118, 30, 20, [
        [0.7, 0.7],
        [0.1, 0.1],
        [0.7, 0.7],
        [0.1, 0.1],
      ])}
      fill="url(#tArmL)"
      transform={`rotate(28 ${8 + 15} ${118 + 10})`}
    />
    <Path
      d={roundedBoxPath(NATIVE_SIZE - 8 - 30, 118, 30, 20, [
        [0.1, 0.1],
        [0.7, 0.7],
        [0.1, 0.1],
        [0.7, 0.7],
      ])}
      fill="url(#tArmR)"
      transform={`rotate(-28 ${NATIVE_SIZE - 8 - 15} ${118 + 10})`}
    />

    {/* Tomato body */}
    <G>
      <Path
        d={bodyPathD()}
        fill="url(#tBody)"
      />
      <Path
        d={bodyPathD()}
        fill="url(#tBodyShade)"
      />
      <Path
        d={bodyPathD()}
        fill="url(#tBodyRim)"
      />
    </G>

    {/* Top shadow */}
    <Ellipse
      cx={CX}
      cy={BODY.y - 4 + 9}
      rx={28}
      ry={9}
      fill="url(#tDimple)"
    />

    {/* Top left sheen */}
    <Ellipse
      cx={BODY.x + 28 + 21}
      cy={BODY.y + 14 + 16}
      rx={21}
      ry={16}
      fill="url(#tSheen)"
    />

    {/* Eye stripes */}
    <Rect
      x={BODY.x + 46}
      y={BODY.y + 22}
      width={5}
      height={84}
      rx={2.5}
      fill="url(#tLobe)"
    />
    <Rect
      x={BODY.x + 152 - 46 - 5}
      y={BODY.y + 22}
      width={5}
      height={84}
      rx={2.5}
      fill="url(#tLobe)"
    />

    <Face
      mood={mood}
      ox={BODY.x}
      oy={BODY.y}
    />

    {/* Stem + Top bud */}
    <Rect
      x={CX - 3}
      y={-2 + 66 - 18 - 30}
      width={6}
      height={30}
      rx={3}
      fill="url(#tStem)"
    />
    <Path
      d={roundedBoxPath(CX - 7.5, -2, 15, 18, [
        [0.6, 0.6],
        [0.6, 0.6],
        [0.5, 0.5],
        [0.5, 0.5],
      ])}
      fill="url(#tBud)"
    />

    {/* Upper leaves */}
    <Leaf
      x={38 + 42}
      y={-2 + 18}
      w={34}
      h={22}
      deg={-32}
      fill="url(#tLeafA)"
    />
    <Leaf
      x={38 + 120 - 42 - 34}
      y={-2 + 18}
      w={34}
      h={22}
      deg={32}
      fill="url(#tLeafA)"
      flip
    />
    <Leaf
      x={38 + 14}
      y={-2 + 30}
      w={30}
      h={18}
      deg={-58}
      fill="url(#tLeafB)"
    />
    <Leaf
      x={38 + 120 - 14 - 30}
      y={-2 + 30}
      w={30}
      h={18}
      deg={58}
      fill="url(#tLeafB)"
      flip
    />
    </G>
  </Svg>
)

export default Tomato
