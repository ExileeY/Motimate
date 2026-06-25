/**
 * Khinklear — the khinkali-dumpling companion, hand-authored in react-native-svg
 * from the exact mockup geometry (`mkps/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds Khinklear from absolutely-positioned <div>s inside a 188×196
 * wrapper. We author it in the shared `PET_SIZE` (180) square viewBox that every
 * pet uses, so a single square `size` (the same one PetStage feeds the others)
 * scales it undistorted. The mockup's 196-tall content maps into the 180 box by
 * the constant factor SCALE = 180/196; the 188-wide content is centred in the
 * square by adding the horizontal inset INSET_X = (196-188)/2 = 4 to every x.
 * Coordinate conversions mirror Arutic/index.tsx:
 *   left/top            → x·SCALE / y·SCALE  (x first shifted by INSET_X)
 *   right:R / bottom:B  → x = (188 - R - w) ; y = (196 - B - h)
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   transform:rotate    → group/shape rotation about the shape centre/pivot
 *   box-shadow inset    → explicit overlay gradient <Path> (SVG has no
 *                         box-shadow; same technique as Arutic's head shade/rim)
 *
 * Z-order from the mockup (DOM order = paint order): topknot → feet → body pouch
 * (pleats → blush → eyes → mouth) → bow. The face (eyes/mouth/blush) is the only
 * mood-varying part — it lives in ./Face.tsx, composed here inside the pouch
 * (after the pleats, before the bow).
 *
 * The body itself does NOT vary per mood (matching Arutic/Dog/etc.): the pouch
 * uses one gradient (the tired mockup's ~1-shade-darker pouch is negligible) and
 * the bow stays upright (the tired mockup's slight droop is dropped). Whole-body
 * motion (bob/breathe/sway) is driven from PetStage as View-level transforms;
 * Khinklear itself is static SVG.
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
import Face from '@/components/pet/Khinklear/Face'

const SIZE = PET_SIZE
const SCALE = SIZE / 196
const INSET_X = (196 - 188) / 2

const sx = (value: number) => (value + INSET_X) * SCALE
const sy = (value: number) => value * SCALE
const ss = (value: number) => value * SCALE

const CENTER = 188 / 2

const boxD = (
  x: number,
  y: number,
  w: number,
  h: number,
  corners: [number, number][],
) => roundedBoxPath(sx(x), sy(y), ss(w), ss(h), corners)

const POUCH = {
  x: CENTER - 152 / 2,
  y: 40,
  w: 152,
  h: 140,
}

const KNOT = {
  x: CENTER - 30 / 2,
  y: 0,
}

const BOW = {
  x: CENTER - 48 / 2,
  y: 30,
}

const PLEAT_ROTATIONS = [-42, -28, -14, 0, 14, 28, 42]

interface KhinklearProps {
  mood: Mood
  size?: number
}

const Khinklear = ({ mood, size = SIZE }: KhinklearProps) => (
  <Svg
    width={size}
    height={size}
    viewBox={`0 0 ${SIZE} ${SIZE}`}
  >
    <Defs>
      {/* Topknot */}
      <RadialGradient id="kKnotBase" cx="50%" cy="20%" r="80%">
        <Stop offset="0" stopColor="#FBF2E0" />
        <Stop offset="1" stopColor="#E7D5B4" />
      </RadialGradient>
      <RadialGradient id="kKnotTuft" cx="40%" cy="30%" r="70%">
        <Stop offset="0" stopColor="#FCF4E4" />
        <Stop offset="1" stopColor="#E2CFAC" />
      </RadialGradient>

      {/* Body pouch */}
      <RadialGradient id="kPouch" cx="48%" cy="24%" r="115%">
        <Stop offset="0" stopColor="#FCF4E4" />
        <Stop offset="0.64" stopColor="#EFE1C6" />
        <Stop offset="1" stopColor="#DECBA6" />
      </RadialGradient>
      {/* inset bottom shade (box-shadow inset 0 -12px 20px) */}
      <RadialGradient id="kPouchShade" cx="50%" cy="100%" r="62%">
        <Stop offset="0.5" stopColor="#967346" stopOpacity={0} />
        <Stop offset="1" stopColor="#967346" stopOpacity={0.26} />
      </RadialGradient>
      {/* inset top rim (box-shadow inset 0 6px 14px highlight) */}
      <RadialGradient id="kPouchRim" cx="50%" cy="0%" r="46%">
        <Stop offset="0" stopColor="#FFF8E8" stopOpacity={0.6} />
        <Stop offset="1" stopColor="#FFF8E8" stopOpacity={0} />
      </RadialGradient>

      {/* Pleat */}
      <LinearGradient id="kPleat" x1="0" y1="0" x2="0" y2="1">
        <Stop offset="0" stopColor="#96734680" />
        <Stop offset="0.82" stopColor="#96734600" />
      </LinearGradient>

      {/* Bow lobes */}
      <RadialGradient id="kBowL" cx="72%" cy="32%" r="70%">
        <Stop offset="0" stopColor="#F6B3C6" />
        <Stop offset="1" stopColor="#E68AA6" />
      </RadialGradient>
      <RadialGradient id="kBowR" cx="28%" cy="32%" r="70%">
        <Stop offset="0" stopColor="#F6B3C6" />
        <Stop offset="1" stopColor="#E68AA6" />
      </RadialGradient>
    </Defs>

    {/* ---------- Topknot ---------- */}
    <G>
      <Path
        d={boxD(KNOT.x, KNOT.y + 18, 30, 22, [
          [0.5, 0.5],
          [0.5, 0.5],
          [0.46, 0.46],
          [0.46, 0.46],
        ])}
        fill="url(#kKnotBase)"
      />
      <Path
        d={boxD(CENTER - 18 / 2, KNOT.y, 18, 24, [
          [0.54, 0.54],
          [0.54, 0.54],
          [0.5, 0.5],
          [0.5, 0.5],
        ])}
        fill="url(#kKnotTuft)"
        transform={`rotate(-8 ${sx(CENTER)} ${sy(KNOT.y + 12)})`}
      />
      <Rect
        x={sx(KNOT.x + 8)}
        y={sy(KNOT.y + 7)}
        width={ss(15)}
        height={ss(3)}
        rx={ss(1.5)}
        fill="rgba(150,115,70,0.3)"
        transform={`rotate(28 ${sx(KNOT.x + 8 + 7.5)} ${sy(KNOT.y + 7 + 1.5)})`}
      />
      <Rect
        x={sx(KNOT.x + 7)}
        y={sy(KNOT.y + 14)}
        width={ss(16)}
        height={ss(3)}
        rx={ss(1.5)}
        fill="rgba(150,115,70,0.26)"
        transform={`rotate(24 ${sx(KNOT.x + 7 + 8)} ${sy(KNOT.y + 14 + 1.5)})`}
      />
    </G>

    {/* ---------- Feet ---------- */}
    <Ellipse
      cx={sx(58 + 15)}
      cy={sy(196 - 6 - 17 / 2)}
      rx={ss(15)}
      ry={ss(8.5)}
      fill="#E6D2AC"
    />
    <Ellipse
      cx={sx(188 - 58 - 15)}
      cy={sy(196 - 6 - 17 / 2)}
      rx={ss(15)}
      ry={ss(8.5)}
      fill="#E6D2AC"
    />

    {/* ---------- Pouch ---------- */}
    <G>
      <Path
        d={boxD(POUCH.x, POUCH.y, POUCH.w, POUCH.h, [
          [0.48, 0.58],
          [0.48, 0.58],
          [0.5, 0.42],
          [0.5, 0.42],
        ])}
        fill="url(#kPouch)"
      />
      <Path
        d={boxD(POUCH.x, POUCH.y, POUCH.w, POUCH.h, [
          [0.48, 0.58],
          [0.48, 0.58],
          [0.5, 0.42],
          [0.5, 0.42],
        ])}
        fill="url(#kPouchShade)"
      />
      <Path
        d={boxD(POUCH.x, POUCH.y, POUCH.w, POUCH.h, [
          [0.48, 0.58],
          [0.48, 0.58],
          [0.5, 0.42],
          [0.5, 0.42],
        ])}
        fill="url(#kPouchRim)"
      />

      {/* Pleats */}
      {PLEAT_ROTATIONS.map((deg) => (
        <Rect
          key={deg}
          x={sx(CENTER - 2)}
          y={sy(POUCH.y + 2)}
          width={ss(4)}
          height={ss(58)}
          rx={ss(2)}
          fill="url(#kPleat)"
          transform={`rotate(${deg} ${sx(CENTER)} ${sy(POUCH.y + 2)})`}
        />
      ))}

      <Face
        mood={mood}
        ox={sx(POUCH.x)}
        oy={sy(POUCH.y)}
        scale={SCALE}
      />
    </G>

    {/* ---------- Bow ---------- */}
    <G>
      <Path
        d={boxD(BOW.x, BOW.y, 21, 21, [
          [0.64, 0.64],
          [0.28, 0.28],
          [0.64, 0.64],
          [0.28, 0.28],
        ])}
        fill="url(#kBowL)"
        transform={`rotate(-10 ${sx(BOW.x + 10.5)} ${sy(BOW.y + 10.5)})`}
      />
      <Path
        d={boxD(BOW.x + 48 - 21, BOW.y, 21, 21, [
          [0.28, 0.28],
          [0.64, 0.64],
          [0.28, 0.28],
          [0.64, 0.64],
        ])}
        fill="url(#kBowR)"
        transform={`rotate(10 ${sx(BOW.x + 48 - 21 + 10.5)} ${sy(BOW.y + 10.5)})`}
      />
      <Rect
        x={sx(CENTER - 11 / 2)}
        y={sy(BOW.y + 11 - 13 / 2)}
        width={ss(11)}
        height={ss(13)}
        rx={ss(4)}
        fill="#DD7A98"
      />
    </G>
  </Svg>
)

export default Khinklear
