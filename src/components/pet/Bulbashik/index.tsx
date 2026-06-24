/**
 * Bulbashik — the sprouting-bulb companion, hand-authored in react-native-svg
 * from the exact mockup geometry (`Bulbashik/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds Bulbashik from absolutely-positioned <div>s inside a 196×200
 * wrapper. We author it in the shared `PET_SIZE` (180) square viewBox that every
 * pet uses, so a single square `size` (the same one PetStage feeds Mochi) scales
 * it undistorted — no per-pet box or centering inset. The mockup's 196-wide
 * content is mapped into the 180 box by the constant factor K = 180/200 = 0.9
 * (with a +2px x baseline to center the 196-wide content first), so every value
 * below is a mockup number × 0.9. Coordinate conversions otherwise mirror
 * Mochi/index.tsx:
 *   left/top            → x / y (× K)
 *   right:R / bottom:B  → x = (196 - R - w) × K ; y = (200 - B - h) × K
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   transform:rotate    → group/shape rotation about the shape center
 *   box-shadow inset    → explicit overlay gradient <Path>/<Rect> (SVG has no
 *                         box-shadow; same technique as Mochi's head shade/rim)
 *
 * Z-order from the mockup (sprout z1, side-arms z1, bulb z2, pot z3): we paint
 * sprout → side-arms → bulb → face → pot, so the pot overlaps the bulb's base.
 *
 * The body (sprout/bulb/arms/pot, plus the mood-independent freckles and brows)
 * is identical across all moods; only the eyes/mouth vary — those live in
 * ./Face.tsx, composed here inside the same <Svg> so the face can reference the
 * #soft blur filter.
 *
 * Whole-body motion (bob/breathe/sway) is driven from PetStage as View-level
 * transforms; Bulbashik itself is static SVG.
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
  Rect,
  Ellipse,
  Path,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Bulbashik/Face'

const SIZE = PET_SIZE
const BULB = {
  x: (SIZE - 136.8) / 2, // (SIZE - w) / 2
  y: 32.4,
  w: 136.8,
  h: 136.8,
}

const bulbPathD = () =>
  roundedBoxPath(BULB.x, BULB.y, BULB.w, BULB.h, [
    [0.52, 0.57],
    [0.48, 0.57],
    [0.5, 0.43],
    [0.5, 0.43],
  ])

  const POT = {
    x: 12.6,
    y: 126.0,
    w: 158.4,
    h: 55.8,
  }

const potPathD = () =>
  roundedBoxPath(POT.x, POT.y, POT.w, POT.h, [
    [0.4, 0.64],
    [0.4, 0.64],
    [0.28, 0.36],
    [0.28, 0.36],
  ])

const seamStripe = () => {
  const stripeY = POT.y + 5.4
  const startX = (SIZE - 135) / 2 // 135 wide, centered
  const cells: React.ReactNode[] = []
  for (let i = 0; i < 30; i++) {
    cells.push(
      <Rect
        key={i}
        x={startX + i * 4.5}
        y={stripeY}
        width={4.5}
        height={4.5}
        fill={i % 2 === 0 ? '#B5503C' : '#7E9A4E'}
      />,
    )
  }
  return cells
}

interface BulbashikProps {
  mood: Mood
  size?: number
}

const Bulbashik = ({ mood, size = SIZE }: BulbashikProps) => (
  <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
    <Defs>
      {/* Sprout */}
      <LinearGradient id="bStem" x1="0" y1="0" x2="0" y2="1">
        <Stop offset="0" stopColor="#84AC50" />
        <Stop offset="1" stopColor="#5F8233" />
      </LinearGradient>
      <RadialGradient id="bLeafL" cx="32%" cy="30%" r="80%">
        <Stop offset="0" stopColor="#93C95B" />
        <Stop offset="1" stopColor="#5E9233" />
      </RadialGradient>
      <RadialGradient id="bLeafR" cx="68%" cy="30%" r="80%">
        <Stop offset="0" stopColor="#93C95B" />
        <Stop offset="1" stopColor="#5E9233" />
      </RadialGradient>
      <RadialGradient id="bBud" cx="50%" cy="28%" r="60%">
        <Stop offset="0" stopColor="#ACD972" />
        <Stop offset="1" stopColor="#6FA23E" />
      </RadialGradient>

      {/* Bulb body */}
      <RadialGradient id="bBulb" cx="42%" cy="26%" r="115%">
        <Stop offset="0" stopColor="#EDD8AD" />
        <Stop offset="0.58" stopColor="#D8BD8A" />
        <Stop offset="1" stopColor="#BFA06C" />
      </RadialGradient>
      {/* inset 0 -14px 22px rgba(120,90,45,.3) — bottom core shade */}
      <RadialGradient id="bBulbShade" cx="50%" cy="100%" r="62%">
        <Stop offset="0.5" stopColor="#785A2D" stopOpacity={0} />
        <Stop offset="1" stopColor="#785A2D" stopOpacity={0.3} />
      </RadialGradient>
      {/* inset 0 8px 16px rgba(255,240,205,.5) — top rim highlight */}
      <RadialGradient id="bBulbRim" cx="50%" cy="0%" r="46%">
        <Stop offset="0" stopColor="#FFF0CD" stopOpacity={0.5} />
        <Stop offset="1" stopColor="#FFF0CD" stopOpacity={0} />
      </RadialGradient>
      {/* top sheen cap */}
      <RadialGradient id="bCap" cx="50%" cy="0%" r="100%">
        <Stop offset="0" stopColor="#785028" stopOpacity={0.5} />
        <Stop offset="0.74" stopColor="#785028" stopOpacity={0} />
      </RadialGradient>

      {/* Side leaf-arms */}
      <RadialGradient id="bArmL" cx="40%" cy="30%" r="70%">
        <Stop offset="0" stopColor="#DDC084" />
        <Stop offset="1" stopColor="#C29E62" />
      </RadialGradient>
      <RadialGradient id="bArmR" cx="60%" cy="30%" r="70%">
        <Stop offset="0" stopColor="#DDC084" />
        <Stop offset="1" stopColor="#C29E62" />
      </RadialGradient>

      {/* Pot */}
      <RadialGradient id="bPot" cx="50%" cy="0%" r="120%">
        <Stop offset="0" stopColor="#F3ECD8" />
        <Stop offset="1" stopColor="#DDD0B0" />
      </RadialGradient>
      <RadialGradient id="bPotShade" cx="50%" cy="100%" r="60%">
        <Stop offset="0.6" stopColor="#8C6E46" stopOpacity={0} />
        <Stop offset="1" stopColor="#8C6E46" stopOpacity={0.18} />
      </RadialGradient>
      <LinearGradient id="bPotRim" x1="0" y1="0" x2="0" y2="1">
        <Stop offset="0" stopColor="#7E5E36" />
        <Stop offset="1" stopColor="#5E4527" />
      </LinearGradient>
      <RadialGradient id="bSeed" cx="40%" cy="35%" r="70%">
        <Stop offset="0" stopColor="#E7C45E" />
        <Stop offset="1" stopColor="#B6892E" />
      </RadialGradient>

      <Filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
        <FeGaussianBlur stdDeviation="1.08" />
      </Filter>
    </Defs>

    {/* Sprout */}
    {/* Stem */}
    <Path
      d={roundedBoxPath((SIZE - 4.5) / 2, 21.6, 4.5, 30.6, [
        [0.5, 0.09],
        [0.5, 0.09],
        [0.5, 0.09],
        [0.5, 0.09],
      ])}
      fill="url(#bStem)"
    />

    {/* Leafs */}
    <G transform="rotate(-26 70.2 15.3)">
      <Path
        d={roundedBoxPath(54.0, 3.6, 32.4, 23.4, [
          [0.62, 0.62],
          [0.08, 0.08],
          [0.62, 0.62],
          [0.08, 0.08],
        ])}
        fill="url(#bLeafL)"
      />
      <Path
        d="M 61.2 11.7 q 9.9 -3.15 19.8 0"
        stroke="rgba(40,80,25,0.4)"
        strokeWidth={1.8}
        fill="none"
        strokeLinecap="round"
      />
    </G>
    <G transform="rotate(26 109.8 15.3)">
      <Path
        d={roundedBoxPath(93.6, 3.6, 32.4, 23.4, [
          [0.08, 0.08],
          [0.62, 0.62],
          [0.08, 0.08],
          [0.62, 0.62],
        ])}
        fill="url(#bLeafR)"
      />
      <Path
        d="M 99.0 11.7 q 9.9 -3.15 19.8 0"
        stroke="rgba(40,80,25,0.4)"
        strokeWidth={1.8}
        fill="none"
        strokeLinecap="round"
      />
    </G>

    {/* Top bud */}
    <Path
      d={roundedBoxPath((SIZE - 15.3) / 2, -3.6, 15.3, 18.0, [
        [0.6, 0.6],
        [0.6, 0.6],
        [0.5, 0.5],
        [0.5, 0.5],
      ])}
      fill="url(#bBud)"
    />

    {/* Arms */}
    <Ellipse
      cx={27.9}
      cy={130.5}
      rx={13.5}
      ry={15.3}
      fill="url(#bArmL)"
      transform="rotate(18 27.9 130.5)"
    />
    <Ellipse
      cx={152.1}
      cy={130.5}
      rx={13.5}
      ry={15.3}
      fill="url(#bArmR)"
      transform="rotate(-18 152.1 130.5)"
    />

    {/* Bulbashik body */}
    <G>
      <Path
        d={bulbPathD()}
        fill="url(#bBulb)"
      />
      <Path
        d={bulbPathD()}
        fill="url(#bBulbShade)"
      />
      <Path
        d={bulbPathD()}
        fill="url(#bBulbRim)"
      />
    </G>

    {/* Top sheen cap */}
    <Ellipse
      cx={BULB.x + BULB.w / 2}
      cy={35.1}
      rx={22.5}
      ry={8.1}
      fill="url(#bCap)"
    />

    {/* Freckles */}
    <Ellipse
      cx={47.25}
      cy={62.1}
      rx={4.05}
      ry={2.7}
      fill="rgba(120,85,45,0.4)"
      transform="rotate(20 47.25 62.1)"
    />
    <Ellipse
      cx={127.8}
      cy={56.25}
      rx={3.6}
      ry={2.25}
      fill="rgba(120,85,45,0.4)"
      transform="rotate(-15 127.8 56.25)"
    />
    <Ellipse
      cx={134.55}
      cy={92.7}
      rx={4.05}
      ry={2.7}
      fill="rgba(120,85,45,0.38)"
      transform="rotate(30 134.55 92.7)"
    />
    <Ellipse
      cx={51.75}
      cy={110.25}
      rx={3.15}
      ry={2.25}
      fill="rgba(120,85,45,0.36)"
    />

    {/* Face */}
    <G transform={`scale(${SIZE / 200})`}>
      <Face
        mood={mood}
        ox={24}
        oy={36}
      />
    </G>

    {/* Pot */}
    <G>
      <Path
        d={potPathD()}
        fill="url(#bPot)"
      />
      <Path
        d={potPathD()}
        fill="url(#bPotShade)"
      />
    </G>

    {/* Seam stripe */}
    <G opacity={0.85}>
      {seamStripe()}
    </G>

    {/* Dark rim band */}
    <Rect
      x={POT.x}
      y={159.3}
      width={POT.w}
      height={9.9}
      fill="url(#bPotRim)"
    />

    {/* Golden seed */}
    <Ellipse
      cx={SIZE / 2}
      cy={163.8}
      rx={8.1}
      ry={8.1}
      fill="url(#bSeed)"
    />
  </Svg>
)

export default Bulbashik
