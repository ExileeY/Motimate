/**
 * Arutic — the cowboy-on-horse companion, hand-authored in react-native-svg from
 * the exact mockup geometry (`mkps/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds Arutic from absolutely-positioned <div>s inside a 192×192
 * wrapper. We author it in the shared `PET_SIZE` (180) square viewBox that every
 * pet uses, so a single square `size` (the same one PetStage feeds Mochi) scales
 * it undistorted — no per-pet box or centering inset. The mockup's 192-wide
 * content is mapped into the 180 box by the constant factor SCALE = 180/192 =
 * 0.9375, so every value below is a mockup number × SCALE. Coordinate conversions
 * otherwise mirror Dog/index.tsx:
 *   left/top            → x·SCALE / y·SCALE
 *   right:R / bottom:B  → x = (192 - R - w)·SCALE ; y = (192 - B - h)·SCALE
 *   border-radius       → roundedBoxPath() (per-corner) or <Ellipse>
 *   radial/linear-grad  → <RadialGradient> / <LinearGradient>
 *   transform:rotate    → group/shape rotation about the shape center
 *   box-shadow inset    → explicit overlay gradient <Path> (SVG has no
 *                         box-shadow; same technique as Dog's head shade/rim)
 *
 * Z-order from the mockup (DOM order = paint order): horse body (saddle blanket,
 * studs, skirt corners, denim legs) → pommel → arms+reins → cowboy head (ears,
 * brow band, face, nose, bandana) → hat brim → hat crown → hatband. The face
 * (eyes/mouth) is the only mood-varying part — it lives in ./Face.tsx, composed
 * here inside the same <Svg> between the head body and the bandana.
 *
 * Whole-body motion (bob/breathe/sway) is driven from PetStage as View-level
 * transforms; Arutic itself is static SVG.
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
  Circle,
  Ellipse,
  Path,
  ClipPath,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Arutic/Face'

const SIZE = PET_SIZE
const SCALE = SIZE / 192 // 0.9375 — mockup wrapper is 192 wide
const scaled = (value: number) => value * SCALE

const CENTER = 192 / 2 // 96 — figure centerline

const COAT = {
  l: (192 - 168) / 2,
  r: (192 - 168) / 2 + 168,
  y: 192 - 82,
}

const SHIRT = {
  x: CENTER - 42 / 2,
  y: COAT.y + 6,
  w: 42,
}

const HEAD = {
  x: (192 - 124) / 2,
  y: 34,
  w: 124,
  h: 122,
}

const coatPathD = () =>
  roundedBoxPath(scaled(12), scaled(110), scaled(168), scaled(82), [
    [0.42, 0.64],
    [0.42, 0.64],
    [0.22, 0.36],
    [0.22, 0.36],
  ])

const headPathD = () =>
  roundedBoxPath(scaled(HEAD.x), scaled(HEAD.y), scaled(HEAD.w), scaled(HEAD.h), [
    [0.45, 0.5],
    [0.45, 0.5],
    [0.44, 0.5],
    [0.44, 0.5],
  ])

const boxD = (
  x: number,
  y: number,
  w: number,
  h: number,
  corners: [number, number][],
) => roundedBoxPath(scaled(x), scaled(y), scaled(w), scaled(h), corners)

interface AruticProps {
  mood: Mood
  size?: number
}

const Arutic = ({ mood, size = SIZE }: AruticProps) => (
  <Svg
    width={size}
    height={size}
    viewBox={`0 0 ${SIZE} ${SIZE}`}
  >
    <Defs>
      {/* Coat */}
      <RadialGradient
        id="aCoat"
        cx="50%"
        cy="0%"
        r="120%"
      >
        <Stop
          offset="0"
          stopColor="#5C4428"
        />
        <Stop
          offset="1"
          stopColor="#38280F"
        />
      </RadialGradient>

      {/* Shirt */}
      <LinearGradient
        id="aShirt"
        x1="0"
        y1="0"
        x2="0"
        y2="1"
      >
        <Stop
          offset="0"
          stopColor="#8A95A2"
        />
        <Stop
          offset="1"
          stopColor="#67727E"
        />
      </LinearGradient>

      {/* Coat panel (lower coat) */}
      <LinearGradient
        id="aCoatPanel"
        x1="0"
        y1="0"
        x2="0"
        y2="1"
      >
        <Stop
          offset="0"
          stopColor="#4A3620"
        />
        <Stop
          offset="1"
          stopColor="#2F2110"
        />
      </LinearGradient>

      {/* Hair */}
      <LinearGradient
        id="aHair"
        x1="0"
        y1="0"
        x2="0"
        y2="1"
      >
        <Stop
          offset="0"
          stopColor="#9A7038"
        />
        <Stop
          offset="1"
          stopColor="#6F4E26"
        />
      </LinearGradient>

      {/* Hair strand  */}
      <LinearGradient
        id="aHairStrand"
        x1="0"
        y1="0"
        x2="0"
        y2="1"
      >
        <Stop
          offset="0"
          stopColor="#8A6334"
        />
        <Stop
          offset="1"
          stopColor="#5E4220"
        />
      </LinearGradient>

      {/* Cowboy head body */}
      <RadialGradient
        id="aHead"
        cx="50%"
        cy="24%"
        r="115%"
      >
        <Stop
          offset="0"
          stopColor="#F0C49A"
        />
        <Stop
          offset="0.64"
          stopColor="#E0A878"
        />
        <Stop
          offset="1"
          stopColor="#CC9460"
        />
      </RadialGradient>
      <RadialGradient
        id="aHeadShade"
        cx="50%"
        cy="100%"
        r="60%"
      >
        <Stop
          offset="0.55"
          stopColor="#965F2D"
          stopOpacity={0}
        />
        <Stop
          offset="1"
          stopColor="#965F2D"
          stopOpacity={0.28}
        />
      </RadialGradient>
      <RadialGradient
        id="aHeadRim"
        cx="50%"
        cy="0%"
        r="44%"
      >
        <Stop
          offset="0"
          stopColor="#FFE4C4"
          stopOpacity={0.5}
        />
        <Stop
          offset="1"
          stopColor="#FFE4C4"
          stopOpacity={0}
        />
      </RadialGradient>

      {/* Beard */}
      <RadialGradient
        id="aBeard"
        cx="50%"
        cy="0%"
        r="90%"
      >
        <Stop
          offset="0"
          stopColor="#8A6334"
        />
        <Stop
          offset="0.78"
          stopColor="#6B4B26"
        />
        <Stop
          offset="1"
          stopColor="#6B4B26"
        />
      </RadialGradient>

      {/* Hat brim */}
      <RadialGradient
        id="aBrim"
        cx="50%"
        cy="0%"
        r="120%"
      >
        <Stop
          offset="0"
          stopColor="#5A4022"
        />
        <Stop
          offset="1"
          stopColor="#2E2012"
        />
      </RadialGradient>

      {/* Hat crown */}
      <RadialGradient
        id="aCrown"
        cx="50%"
        cy="30%"
        r="110%"
      >
        <Stop
          offset="0"
          stopColor="#523A1F"
        />
        <Stop
          offset="1"
          stopColor="#2A1D0F"
        />
      </RadialGradient>

      <Filter
        id="soft"
        x="-50%"
        y="-50%"
        width="200%"
        height="200%"
      >
        <FeGaussianBlur stdDeviation="1.08" />
      </Filter>
    </Defs>

    {/* ---------- Body ---------- */}
    <G>
      {/* Coat */}
      <Path
        d={coatPathD()}
        fill="url(#aCoat)"
      />

      {/* Shirt */}
      <Path
        d={boxD(SHIRT.x, SHIRT.y, SHIRT.w, 68, [
          [0.19, 0.12],
          [0.19, 0.12],
          [0, 0],
          [0, 0],
        ])}
        fill="url(#aShirt)"
      />

      {/* Button (shirt) */}
      <Circle
        cx={scaled(CENTER)}
        cy={scaled(COAT.y + 20 + 2 + 42)}
        r={scaled(2)}
        fill="#D9C9A0"
      />

      {/* Coat panels */}
      <Path
        d={boxD(COAT.l + 34, COAT.y + 4, 42, 70, [
          [0, 0],
          [0, 0],
          [0, 0],
          [1, 0.63],
        ])}
        fill="url(#aCoatPanel)"
        transform={`rotate(9 ${scaled(COAT.l + 34 + 21)} ${scaled(COAT.y + 4 + 35)})`}
      />
      <Path
        d={boxD(COAT.r - 34 - 42, COAT.y + 4, 42, 70, [
          [0, 0],
          [0, 0],
          [1, 0.63],
          [0, 0],
        ])}
        fill="url(#aCoatPanel)"
        transform={`rotate(-9 ${scaled(COAT.r - 34 - 21)} ${scaled(COAT.y + 4 + 35)})`}
      />
    </G>

    {/* ---------- Hair ---------- */}
    <Path
      d={boxD(24, 46, 38, 74, [
        [0.52, 0.46],
        [0.24, 0.6],
        [0.46, 0.4],
        [0.6, 0.54],
      ])}
      fill="url(#aHair)"
      transform={`rotate(-14 ${scaled(24 + 19)} ${scaled(46 + 37)})`}
    />
    <Path
      d={boxD(32, 58, 16, 58, [
        [0.5, 0.4],
        [0.4, 0.5],
        [0.5, 0.5],
        [0.5, 0.5],
      ])}
      fill="url(#aHairStrand)"
      transform={`rotate(-20 ${scaled(32 + 8)} ${scaled(58 + 29)})`}
    />
    <Path
      d={boxD(192 - 24 - 38, 46, 38, 74, [
        [0.24, 0.6],
        [0.52, 0.46],
        [0.6, 0.54],
        [0.46, 0.4],
      ])}
      fill="url(#aHair)"
      transform={`rotate(14 ${scaled(192 - 24 - 19)} ${scaled(46 + 37)})`}
    />
    <Path
      d={boxD(192 - 32 - 16, 58, 16, 58, [
        [0.4, 0.5],
        [0.5, 0.4],
        [0.5, 0.5],
        [0.5, 0.5],
      ])}
      fill="url(#aHairStrand)"
      transform={`rotate(20 ${scaled(192 - 32 - 8)} ${scaled(58 + 29)})`}
    />

    {/* ---------- Cowboy head ---------- */}
    <G>
      <Path
        d={headPathD()}
        fill="url(#aHead)"
      />
      <Path
        d={headPathD()}
        fill="url(#aHeadShade)"
      />
      <Path
        d={headPathD()}
        fill="url(#aHeadRim)"
      />

      {/* ---------- Ears ---------- */}
      <Ellipse
        cx={scaled(HEAD.x - 7 + 8)}
        cy={scaled(HEAD.y + 54 + 11)}
        rx={scaled(8)}
        ry={scaled(11)}
        fill="#E0A878"
      />
      <Ellipse
        cx={scaled(HEAD.x + HEAD.w + 7 - 8)}
        cy={scaled(HEAD.y + 54 + 11)}
        rx={scaled(8)}
        ry={scaled(11)}
        fill="#E0A878"
      />

      {/* ---------- Wrinkle ---------- */}
      <Rect
        x={scaled(HEAD.x + HEAD.w / 2 - 27)}
        y={scaled(HEAD.y + 50)}
        width={scaled(54)}
        height={scaled(5)}
        rx={scaled(2.5)}
        fill="rgba(150,100,60,0.3)"
      />
    </G>

    {/* ---------- Beard ---------- */}
    <G>
      <Path
        d={boxD(44, HEAD.y + 84, 104, 48, [
          [0, 0],
          [0, 0],
          [0.46, 1],
          [0.46, 1],
        ])}
        fill="url(#aBeard)"
      />
      <Path
        d={boxD(192 / 2 - 23, HEAD.y + 84 + 4, 46, 12, [
          [0, 0],
          [0, 0],
          [0.52, 1],
          [0.52, 1],
        ])}
        fill="#7A5730"
      />
      <Rect
        x={scaled(192 / 2 - 13)}
        y={scaled(HEAD.y + 84 + 15)}
        width={scaled(26)}
        height={scaled(3)}
        rx={scaled(1.5)}
        fill="#4A3526"
      />
    </G>

    {/* ---------- Face (mood-varying eyes/mouth + static brows/nose) ---------- */}
    <Face
      mood={mood}
      ox={scaled(HEAD.x)}
      oy={scaled(HEAD.y)}
      scale={SCALE}
    />

    {/* ---------- Hat brim ---------- */}
    <Ellipse
      cx={scaled(96)}
      cy={scaled(48 + 17)}
      rx={scaled(87)}
      ry={scaled(17)}
      fill="url(#aBrim)"
    />

    {/* ---------- Hat crown ---------- */}
    <G>
      <Path
        d={boxD(41, 6, 110, 58, [
          [0.46, 0.7],
          [0.46, 0.7],
          [0.38, 0.4],
          [0.38, 0.4],
        ])}
        fill="url(#aCrown)"
      />
      <Rect
        x={scaled(96 - 4.5)}
        y={scaled(6 + 5)}
        width={scaled(9)}
        height={scaled(36)}
        rx={scaled(4.5)}
        fill="rgba(20,12,4,0.34)"
      />
    </G>

    {/* ---------- Hatband ---------- */}
    <Defs>
      <ClipPath id="aBand">
        <Rect
          x={scaled(40)}
          y={scaled(52)}
          width={scaled(112)}
          height={scaled(9)}
          rx={scaled(4.5)}
        />
      </ClipPath>
    </Defs>
    <G clipPath="url(#aBand)">
      <Rect
        x={scaled(40)}
        y={scaled(52)}
        width={scaled(112)}
        height={scaled(9)}
        fill="#87662F"
      />
      {Array.from({ length: 28 }).map((_, i) => (
        <Rect
          key={i}
          x={scaled(40 - 12 + i * 10)}
          y={scaled(52 - 6)}
          width={scaled(5)}
          height={scaled(21)}
          fill="#B6925A"
          transform={`rotate(-25 ${scaled(40 - 12 + i * 10 + 2.5)} ${scaled(52 + 4.5)})`}
        />
      ))}
    </G>
  </Svg>
)

export default Arutic
