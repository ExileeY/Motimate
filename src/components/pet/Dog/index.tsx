/**
 * Dog — the retriever companion, hand-authored in react-native-svg from the
 * exact mockup geometry (`mkps/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds the Dog from absolutely-positioned <div>s inside a 180×180
 * wrapper — the same box every pet uses — so we mirror it 1:1 into a
 * `0 0 180 180` viewBox (K=1.0, no per-pet scaling). Coordinate conversions
 * mirror Mochi/index.tsx:
 *   left/top            → x / y directly
 *   right:R / bottom:B  → x = 180 - R - w ; y = 180 - B - h
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   transform:rotate    → group/shape rotation about the shape center
 *   box-shadow inset    → explicit overlay gradient <Path> (SVG has no
 *                         box-shadow; same technique as Mochi's head shade/rim)
 *
 * Z-order from the mockup (tail z0, ears z1, head z2, feet z3): we paint
 * tail → ears → head → face → feet.
 *
 * The body (tail/ears/head/feet) is identical across all moods; only the
 * eyes/mouth vary — those live in ./Face.tsx, composed here inside the same
 * <Svg>. The mockup's happy tail has its own wiggle keyframe; like every other
 * pet here the Dog is static SVG (whole-body bob/breathe/sway is driven from
 * PetStage), so the tail holds the calm -6° pose for all moods.
 */
import React from 'react'
import Svg, {
  Defs,
  RadialGradient,
  Stop,
  Filter,
  FeGaussianBlur,
  G,
  Ellipse,
  Path,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Dog/Face'

const SIZE = PET_SIZE

const HEAD = {
  x: (SIZE - 148) / 2, // left:50% → centered, 16
  y: 26,
  w: 148,
  h: 140,
}

const headPathD = () =>
  roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
    [0.5, 0.54],
    [0.5, 0.54],
    [0.47, 0.46],
    [0.47, 0.46],
  ])

const EAR = { w: 34, h: 66 }
const earPathD = (x: number, y: number) =>
  roundedBoxPath(x, y, EAR.w, EAR.h, [
    [0.48, 0.26],
    [0.48, 0.26],
    [0.5, 0.74],
    [0.5, 0.74],
  ])

interface DogProps {
  mood: Mood
  size?: number
}

const Dog = ({ mood, size = SIZE }: DogProps) => (
  <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
    <Defs>
      {/* Ears */}
      <RadialGradient id="dEar" cx="50%" cy="30%" r="70%">
        <Stop offset="0" stopColor="#DCA456" />
        <Stop offset="1" stopColor="#C9913F" />
      </RadialGradient>

      {/* Head body */}
      <RadialGradient id="dHead" cx="50%" cy="22%" r="115%">
        <Stop offset="0" stopColor="#F2CB8C" />
        <Stop offset="0.68" stopColor="#E0A95C" />
        <Stop offset="1" stopColor="#CD9444" />
      </RadialGradient>
      {/* inset 0 -12px 20px rgba(150,95,30,.28) — bottom core shade */}
      <RadialGradient id="dHeadShade" cx="50%" cy="100%" r="60%">
        <Stop offset="0.55" stopColor="#965F1E" stopOpacity={0} />
        <Stop offset="1" stopColor="#965F1E" stopOpacity={0.28} />
      </RadialGradient>
      {/* inset 0 6px 14px rgba(255,232,196,.55) — top rim highlight */}
      <RadialGradient id="dHeadRim" cx="50%" cy="0%" r="44%">
        <Stop offset="0" stopColor="#FFE8C4" stopOpacity={0.55} />
        <Stop offset="1" stopColor="#FFE8C4" stopOpacity={0} />
      </RadialGradient>

      {/* Tail */}
      <RadialGradient id="dTail" cx="50%" cy="35%" r="75%">
        <Stop offset="0" stopColor="#E2A856" />
        <Stop offset="1" stopColor="#DDA152" />
      </RadialGradient>
      {/* inset 0 -4px 8px rgba(170,110,40,.25) — bottom shade */}
      <RadialGradient id="dTailShade" cx="50%" cy="100%" r="65%">
        <Stop offset="0.5" stopColor="#AA6E28" stopOpacity={0} />
        <Stop offset="1" stopColor="#AA6E28" stopOpacity={0.25} />
      </RadialGradient>

      {/* Feet */}
      <RadialGradient id="dFoot" cx="50%" cy="60%" r="70%">
        <Stop offset="0" stopColor="#E6B468" />
        <Stop offset="1" stopColor="#DCA452" />
      </RadialGradient>
      {/* inset 0 3px 5px rgba(255,232,196,.5) — top highlight */}
      <RadialGradient id="dFootHi" cx="50%" cy="0%" r="60%">
        <Stop offset="0" stopColor="#FFE8C4" stopOpacity={0.5} />
        <Stop offset="1" stopColor="#FFE8C4" stopOpacity={0} />
      </RadialGradient>

      <Filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
        <FeGaussianBlur stdDeviation="1.08" />
      </Filter>
    </Defs>

    {/* Tail */}
    <G transform="rotate(-6 149 133)">
      <Ellipse
        cx={149}
        cy={133}
        rx={25}
        ry={11}
        fill="url(#dTail)"
      />
      <Ellipse
        cx={149}
        cy={133}
        rx={25}
        ry={11}
        fill="url(#dTailShade)"
      />
    </G>

    {/* Ears */}
    <G transform="rotate(-22 23 87)">
      <Path
        d={earPathD(6, 54)}
        fill="url(#dEar)"
      />
    </G>
    <G transform="rotate(22 157 87)">
      <Path
        d={earPathD(140, 54)}
        fill="url(#dEar)"
      />
    </G>

    {/* Head */}
    <G>
      <Path
        d={headPathD()}
        fill="url(#dHead)"
      />
      <Path
        d={headPathD()}
        fill="url(#dHeadShade)"
      />
      <Path
        d={headPathD()}
        fill="url(#dHeadRim)"
      />
    </G>

    {/* Face */}
    <Face
      mood={mood}
      ox={0}
      oy={0}
    />

    {/* Feet */}
    <G>
      <Ellipse
        cx={69}
        cy={165}
        rx={15}
        ry={9}
        fill="url(#dFoot)"
      />
      <Ellipse
        cx={69}
        cy={165}
        rx={15}
        ry={9}
        fill="url(#dFootHi)"
      />
      <Ellipse
        cx={111}
        cy={165}
        rx={15}
        ry={9}
        fill="url(#dFoot)"
      />
      <Ellipse
        cx={111}
        cy={165}
        rx={15}
        ry={9}
        fill="url(#dFootHi)"
      />
    </G>
  </Svg>
)

export default Dog
