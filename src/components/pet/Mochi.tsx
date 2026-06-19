/**
 * Mochi — the cat companion, hand-authored in react-native-svg from the exact
 * mockup geometry (`Mockups/Emotions/Mochi/{happy,calm,tired}.dc.html`).
 *
 * The mockup builds Mochi from absolutely-positioned <div>s inside a 180×180
 * box. We mirror that into a `0 0 180 180` viewBox. Coordinate conversions:
 *   left/top            → x/y directly
 *   right:R / bottom:B  → x = 180 - R - w ; y = 180 - B - h
 *   elliptical radii    → <Ellipse rx ry> (the divs are pill/oval shapes)
 *   radial-gradient     → <RadialGradient>
 *   filter:blur         → <FeGaussianBlur> filter
 *   transform:rotate    → group/shape rotation about the shape center
 *
 * Animatable parts are isolated as named <G> groups so Reanimated can drive
 * them independently (see animations.ts): `tail`, `leftEar`, `rightEar`, the
 * whole pet bobs/sways from the parent (PetStage).
 *
 * Face features differ per mood:
 *   energetic → round open eyes + highlight, "w" smile, soft cheeks
 *   calm      → upward eye-arcs (content squint), small mouth
 *   tired     → downward lash-arcs (closed eyes), small mouth
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
  Circle,
  Rect,
} from 'react-native-svg'
import { Mood } from '@/mood/mood'

const SIZE = 180
const HEAD = {
  x: (SIZE - 148) / 2,
  y: 26,
  w: 148,
  h: 140
}
const HEAD_CX = HEAD.x + HEAD.w / 2 // 90
const HEAD_CY = HEAD.y + HEAD.h / 2 // 96

interface MochiProps {
  mood: Mood
  size?: number
}

const Mochi = ({ mood, size = SIZE }: MochiProps) => {
  return (
    <Svg width={size} height={size} viewBox={`0 0 ${SIZE} ${SIZE}`}>
      <Defs>
        {/* head body shading: radial-gradient(115% 115% at 50% 22%, ...) */}
        <RadialGradient id="head" cx="50%" cy="22%" r="115%">
          <Stop offset="0" stopColor="#F3BC92" />
          <Stop offset="0.68" stopColor="#E2935F" />
          <Stop offset="1" stopColor="#D27F4C" />
        </RadialGradient>
        {/* ears: radial-gradient(80% 80% at 50% 70%, #E89A6C, #DB8753) */}
        <RadialGradient id="ear" cx="50%" cy="70%" r="80%">
          <Stop offset="0" stopColor="#E89A6C" />
          <Stop offset="1" stopColor="#DB8753" />
        </RadialGradient>
        {/* muzzle highlight: radial(circle at 50% 40%, rgba(255,234,210,.85), 0 @70%) */}
        <RadialGradient id="muzzle" cx="50%" cy="40%" r="50%">
          <Stop offset="0" stopColor="#FFEAD2" stopOpacity={0.85} />
          <Stop offset="0.7" stopColor="#FFEAD2" stopOpacity={0} />
        </RadialGradient>
        <Filter id="soft" x="-50%" y="-50%" width="200%" height="200%">
          <FeGaussianBlur stdDeviation="1.2" />
        </Filter>
      </Defs>

      {/* ── tail ── right:8 bottom:30 w54 h24 rotate28; pill → ellipse rx27 ry12 */}
      <G id="tail">
        <Ellipse cx={145} cy={138} rx={27} ry={12} fill="#DE8E5B" transform="rotate(28 145 138)" />
      </G>

      {/* ── left ear ── left:36 top:4 w40 h52 rotate-15 */}
      <G id="leftEar" transform="rotate(-15 56 30)">
        <Ellipse cx={56} cy={30} rx={20} ry={26} fill="url(#ear)" />
        {/* inner ear: left:50% top:46% w16 h24, pinkish */}
        <Ellipse cx={56} cy={34} rx={8} ry={12} fill="#EFA9A0" opacity={0.8} />
      </G>

      {/* ── right ear ── right:36 top:4 w40 h52 rotate15 → x=104..144, cx=124 */}
      <G id="rightEar" transform="rotate(15 124 30)">
        <Ellipse cx={124} cy={30} rx={20} ry={26} fill="url(#ear)" />
        <Ellipse cx={124} cy={34} rx={8} ry={12} fill="#EFA9A0" opacity={0.8} />
      </G>

      {/* ── head ── rounded box 148×140 ≈ ellipse-ish; use rounded rect path */}
      <G id="head">
        <Rect
          x={HEAD.x}
          y={HEAD.y}
          width={HEAD.w}
          height={HEAD.h}
          rx={70}
          ry={74}
          fill="url(#head)"
        />
        {/* muzzle glow: left:50% bottom:14 w78 h62 */}
        <Ellipse cx={HEAD_CX} cy={HEAD.y + HEAD.h - 14 - 31} rx={39} ry={31} fill="url(#muzzle)" />

        <Face mood={mood} />

        {/* feet ── bottom:6 left:54 / right:54, w30 h18 → cy=180-6-9=165 */}
        <Ellipse cx={69} cy={165} rx={15} ry={9} fill="#E89A6C" />
        <Ellipse cx={111} cy={165} rx={15} ry={9} fill="#E89A6C" />
      </G>
    </Svg>
  )
}

export default Mochi

/**
 * Face features, relative to the head box origin (HEAD.x, HEAD.y).
 * Mockup offsets are within the 148×140 head; we add HEAD.x / HEAD.y.
 */
const Face = ({ mood }: { mood: Mood }) => {
  const ox = HEAD.x
  const oy = HEAD.y

  // Cheeks — common to all moods (blurred pink ovals).
  // happy: left:22 top:70 w22 h15 ; tired slightly smaller/higher-alpha tweak.
  const cheekY = mood === Mood.TIRED ? oy + 74 + 6.5 : oy + (mood === Mood.CALM ? 72 : 70) + 7.5
  const cheekOpacity = mood === Mood.TIRED ? 0.45 : 0.5
  const cheeks = (
    <G id="cheeks">
      <Ellipse cx={ox + 33} cy={cheekY} rx={11} ry={7.5} fill="#F2938B" opacity={cheekOpacity} filter="url(#soft)" />
      <Ellipse cx={ox + 115} cy={cheekY} rx={11} ry={7.5} fill="#F2938B" opacity={cheekOpacity} filter="url(#soft)" />
    </G>
  )

  if (mood === Mood.ENERGETIC) {
    // Open round eyes (w16 h20 at left/right:40, top:50) + white highlight.
    return (
      <G id="eyes">
        {cheeks}
        <Ellipse cx={ox + 48} cy={oy + 60} rx={8} ry={10} fill="#4A352A" />
        <Circle cx={ox + 46} cy={oy + 56} r={3} fill="#fff" />
        <Ellipse cx={ox + 100} cy={oy + 60} rx={8} ry={10} fill="#4A352A" />
        <Circle cx={ox + 98} cy={oy + 56} r={3} fill="#fff" />
        {/* "w" smile: small downward arc, left:50% top:80 w18 h11 */}
        <Path
          d={`M ${ox + 65} ${oy + 80} q ${9} ${11} ${18} 0`}
          stroke="#4A352A"
          strokeWidth={3}
          fill="none"
          strokeLinecap="round"
        />
      </G>
    )
  }

  if (mood === Mood.CALM) {
    // Content squint: upward arcs (border-top only, radius top) at top:58.
    return (
      <G id="eyes">
        {cheeks}
        <Path d={`M ${ox + 39} ${oy + 64} q 10 -11 20 0`} stroke="#4A352A" strokeWidth={3} fill="none" strokeLinecap="round" />
        <Path d={`M ${ox + 89} ${oy + 64} q 10 -11 20 0`} stroke="#4A352A" strokeWidth={3} fill="none" strokeLinecap="round" />
        {/* small mouth: top:82 w15 h9 downward arc */}
        <Path d={`M ${ox + 66} ${oy + 84} q 7.5 9 15 0`} stroke="#4A352A" strokeWidth={3} fill="none" strokeLinecap="round" />
      </G>
    )
  }

  // TIRED: closed eyes as downward lash-arcs (border-bottom) at top:62, darker.
  return (
    <G id="eyes">
      {cheeks}
      <Path d={`M ${ox + 41} ${oy + 66} q 8.5 9 17 0`} stroke="#6B4F3F" strokeWidth={3} fill="none" strokeLinecap="round" />
      <Path d={`M ${ox + 90} ${oy + 66} q 8.5 9 17 0`} stroke="#6B4F3F" strokeWidth={3} fill="none" strokeLinecap="round" />
      <Path d={`M ${ox + 67.5} ${oy + 88} q 6.5 8 13 0`} stroke="#6B4F3F" strokeWidth={3} fill="none" strokeLinecap="round" />
    </G>
  )
}
