import React from 'react'
import Svg, {
  Defs,
  RadialGradient,
  LinearGradient,
  Stop,
  G,
  Ellipse,
  Path,
  Rect,
} from 'react-native-svg'
import { Mood } from '@/pet/mood'
import { PET_SIZE } from '@/constants/pet/dimensions'
import { roundedBoxPath } from '@/components/pet/svgPath'
import Face from '@/components/pet/Schnauzer/Face'

const SIZE = PET_SIZE
const HEAD = {
  x: (SIZE - 152) / 2, // (SIZE - WIDTH) / 2
  y: 24,
  w: 152,
  h: 144,
}

const headPathD = () =>
  roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
    [0.5, 0.54],
    [0.5, 0.54],
    [0.47, 0.46],
    [0.47, 0.46],
  ])

const capPathD = () =>
  roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, 62, [
    [0.5, 0.5],
    [0.5, 0.5],
    [0.4, 0.4],
    [0.4, 0.4],
  ])

const EAR = {
  w: 50,
  h: 54
}

const earPathD = (x: number, y: number) =>
  roundedBoxPath(x, y, EAR.w, EAR.h, [
    [0.32, 0.18],
    [0.32, 0.18],
    [0.5, 0.7],
    [0.5, 0.7],
  ])

const BEARD = {
  x: HEAD.x + (HEAD.w - 116) / 2, // (SIZE - WIDTH) / 2
  y: HEAD.y + 64,
  w: 116,
  h: 86,
}

const beardPathD = () =>
  roundedBoxPath(BEARD.x, BEARD.y, BEARD.w, BEARD.h, [
    [0.42, 0.26],
    [0.42, 0.26],
    [0.46, 0.74],
    [0.46, 0.74],
  ])

interface SchnauzerProps {
  mood: Mood
  size?: number
}

const Schnauzer = ({ mood, size = SIZE }: SchnauzerProps) => (
  <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
    <Defs>
      {/* Tail */}
      <RadialGradient id="sTail" cx="38%" cy="30%" r="60%">
        <Stop offset="0" stopColor="#8E8A81" />
        <Stop offset="1" stopColor="#736F68" />
      </RadialGradient>
      <RadialGradient id="sTailShade" cx="50%" cy="100%" r="65%">
        <Stop offset="0.5" stopColor="#464038" stopOpacity={0} />
        <Stop offset="1" stopColor="#464038" stopOpacity={0.3} />
      </RadialGradient>

      {/* Ears */}
      <LinearGradient id="sEarL" x1="0%" y1="0%" x2="80%" y2="100%">
        <Stop offset="0" stopColor="#605C54" />
        <Stop offset="1" stopColor="#45423B" />
      </LinearGradient>
      <LinearGradient id="sEarR" x1="100%" y1="0%" x2="20%" y2="100%">
        <Stop offset="0" stopColor="#605C54" />
        <Stop offset="1" stopColor="#45423B" />
      </LinearGradient>

      {/* Head */}
      <RadialGradient id="sHead" cx="50%" cy="20%" r="115%">
        <Stop offset="0" stopColor="#ABA79F" />
        <Stop offset="0.64" stopColor="#807C76" />
        <Stop offset="1" stopColor="#605B54" />
      </RadialGradient>
      <RadialGradient id="sHeadShade" cx="50%" cy="100%" r="60%">
        <Stop offset="0.55" stopColor="#322E28" stopOpacity={0} />
        <Stop offset="1" stopColor="#322E28" stopOpacity={0.3} />
      </RadialGradient>
      <RadialGradient id="sHeadRim" cx="50%" cy="0%" r="44%">
        <Stop offset="0" stopColor="#E6E2DA" stopOpacity={0.4} />
        <Stop offset="1" stopColor="#E6E2DA" stopOpacity={0} />
      </RadialGradient>

      {/* Cap */}
      <LinearGradient id="sCap" x1="0%" y1="0%" x2="0%" y2="100%">
        <Stop offset="0" stopColor="#3f3c36" stopOpacity={0.26} />
        <Stop offset="1" stopColor="#3f3c36" stopOpacity={0} />
      </LinearGradient>

      {/* Beard */}
      <RadialGradient id="sBeard" cx="50%" cy="22%" r="70%">
        <Stop offset="0" stopColor="#E8E3DA" />
        <Stop offset="0.7" stopColor="#CCC7BD" />
        <Stop offset="1" stopColor="#BBB6AC" />
      </RadialGradient>
      <RadialGradient id="sBeardRim" cx="50%" cy="0%" r="44%">
        <Stop offset="0" stopColor="#FFFFFF" stopOpacity={0.45} />
        <Stop offset="1" stopColor="#FFFFFF" stopOpacity={0} />
      </RadialGradient>
      <RadialGradient id="sBeardShade" cx="50%" cy="100%" r="55%">
        <Stop offset="0.5" stopColor="#969086" stopOpacity={0} />
        <Stop offset="1" stopColor="#969086" stopOpacity={0.4} />
      </RadialGradient>

      {/* Brow */}
      <RadialGradient id="sBrow" cx="50%" cy="25%" r="70%">
        <Stop offset="0" stopColor="#E4DFD6" />
        <Stop offset="1" stopColor="#C7C2B8" />
      </RadialGradient>

      {/* Nose */}
      <RadialGradient id="sNose" cx="40%" cy="28%" r="50%">
        <Stop offset="0" stopColor="#3c372f" />
        <Stop offset="1" stopColor="#231e1a" />
      </RadialGradient>

      {/* Feet */}
      <RadialGradient id="sFoot" cx="50%" cy="30%" r="60%">
        <Stop offset="0" stopColor="#D8D3CA" />
        <Stop offset="1" stopColor="#C2BDB3" />
      </RadialGradient>
      <RadialGradient id="sFootHi" cx="50%" cy="0%" r="60%">
        <Stop offset="0" stopColor="#FFFFFF" stopOpacity={0.5} />
        <Stop offset="1" stopColor="#FFFFFF" stopOpacity={0} />
      </RadialGradient>
    </Defs>

    {/* Tail */}
    <G transform="rotate(-6 156 131.5)">
      <Ellipse
        cx={156}
        cy={131.5}
        rx={22}
        ry={10.5}
        fill="url(#sTail)"
      />
      <Ellipse
        cx={156}
        cy={131.5}
        rx={22}
        ry={10.5}
        fill="url(#sTailShade)"
      />
    </G>

    {/* Ears */}
    <G transform="rotate(-3 45 47)">
      <Path
        d={earPathD(20, 20)}
        fill="url(#sEarL)"
      />
    </G>
    <G transform="rotate(3 135 47)">
      <Path
        d={earPathD(110, 20)}
        fill="url(#sEarR)"
      />
    </G>

    {/* Head */}
    <G>
      <Path
        d={headPathD()}
        fill="url(#sHead)"
      />
      <Path
        d={headPathD()}
        fill="url(#sHeadShade)"
      />
      <Path
        d={headPathD()}
        fill="url(#sHeadRim)"
      />
      {/* darker cap */}
      <Path
        d={capPathD()}
        fill="url(#sCap)"
      />
    </G>

    {/* Beard */}
    <G>
      <Path
        d={beardPathD()}
        fill="url(#sBeard)"
      />
      <Path
        d={beardPathD()}
        fill="url(#sBeardRim)"
      />
      <Path
        d={beardPathD()}
        fill="url(#sBeardShade)"
      />
      <Rect
        x={BEARD.x + BEARD.w / 2 - 1}
        y={BEARD.y + 26}
        width={2}
        height={50}
        rx={1}
        fill="rgba(160,154,144,0.5)"
      />
      <G transform={`rotate(10 ${BEARD.x + 31} ${BEARD.y + 51})`}>
        <Rect
          x={BEARD.x + 30}
          y={BEARD.y + 34}
          width={2}
          height={34}
          rx={1}
          fill="rgba(160,154,144,0.4)"
        />
      </G>
      <G transform={`rotate(-10 ${BEARD.x + BEARD.w - 31} ${BEARD.y + 51})`}>
        <Rect
          x={BEARD.x + BEARD.w - 32}
          y={BEARD.y + 34}
          width={2}
          height={34}
          rx={1}
          fill="rgba(160,154,144,0.4)"
        />
      </G>

      {/* Nose */}
      <Ellipse
        cx={BEARD.x + BEARD.w / 2}
        cy={BEARD.y + 6 + 9}
        rx={14}
        ry={9}
        fill="url(#sNose)"
      />
    </G>

    {/* Face */}
    <Face
      mood={mood}
      ox={0}
      oy={0}
    />

    {/* Paws */}
    <G>
      <Ellipse
        cx={68}
        cy={166.5}
        rx={16}
        ry={9.5}
        fill="url(#sFoot)"
      />
      <Ellipse
        cx={68}
        cy={166.5}
        rx={16}
        ry={9.5}
        fill="url(#sFootHi)"
      />
      <Ellipse
        cx={112}
        cy={166.5}
        rx={16}
        ry={9.5}
        fill="url(#sFoot)"
      />
      <Ellipse
        cx={112}
        cy={166.5}
        rx={16}
        ry={9.5}
        fill="url(#sFootHi)"
      />
    </G>
  </Svg>
)

export default Schnauzer
