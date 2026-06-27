import React from 'react'
import {
  G,
  Rect,
  Ellipse,
  Path,
  RadialGradient,
  Stop,
  Defs,
  ClipPath
} from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import TomatoEye from '@/components/pet/Tomato/FaceItems/TomatoEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'
import { roundedBoxPath } from '@/components/pet/svgPath'

const BROW = '#7A2A1C'
const BROW_TIRED = '#6E2618'
const NOSE = '#3A211A'
const MUSTACHE = '#3A211A'

const CX_BODY = 76 // body-box centre (152 / 2)

const MustacheHalf = ({ ox, oy, flip }: OffsetProps & { flip?: boolean }) => {
  const mirrorFactor = flip ? -1 : 1
  const cx = ox + CX_BODY
  const top = oy + 98
  const path =
    `M ${cx} ${top}` +
    ` C ${cx + mirrorFactor * -10} ${top - 1}, ${cx + mirrorFactor * -22} ${top + 3}, ${cx + mirrorFactor * -30} ${top + 6}` +
    ` C ${cx + mirrorFactor * -36} ${top + 9}, ${cx + mirrorFactor * -40} ${top + 6}, ${cx + mirrorFactor * -38} ${top + 3}` +
    ` C ${cx + mirrorFactor * -36} ${top + 1}, ${cx + mirrorFactor * -33} ${top + 1}, ${cx + mirrorFactor * -31} ${top + 4}` +
    ` C ${cx + mirrorFactor * -26} ${top + 7}, ${cx + mirrorFactor * -16} ${top + 6}, ${cx + mirrorFactor * -8} ${top + 4}` +
    ` C ${cx + mirrorFactor * -5} ${top + 3}, ${cx + mirrorFactor * -2} ${top + 3}, ${cx} ${top + 3} Z`

  return (
    <Path
      d={path}
      fill={MUSTACHE}
    />
  )
}

const mouthPath = (ml: number, mt: number, mw: number, mh: number) => {
  const mr = ml + mw
  const mb = mt + mh
  const cr = 15 // bottom corner radius (22 clamped to half-width 30/2)
  const sy = mt + (mh - cr) // y where the bottom corner arc begins
  return (
    `M ${ml} ${mt} L ${mr} ${mt} L ${mr} ${sy}` +
    ` A ${cr} ${cr} 0 0 1 ${mr - cr} ${mb}` +
    ` L ${ml + cr} ${mb}` +
    ` A ${cr} ${cr} 0 0 1 ${ml} ${sy} Z`
  )
}

const tonguePath = (tl: number, tw: number, mb: number) => {
  const tr = tl + tw
  const tTop = mb - 9
  const tr10 = 9
  return (
    `M ${tl} ${mb} L ${tl} ${tTop + tr10}` +
    ` A ${tr10} ${tr10} 0 0 1 ${tl + tr10} ${tTop}` +
    ` L ${tr - tr10} ${tTop}` +
    ` A ${tr10} ${tr10} 0 0 1 ${tr} ${tTop + tr10}` +
    ` L ${tr} ${mb} Z`
  )
}

const Shared = ({ ox, oy }: OffsetProps) => (
  <>
    {/* Nose */}
    <Ellipse
      cx={ox + CX_BODY}
      cy={oy + 90 + 9 / 2}
      rx={6}
      ry={4.5}
      fill={NOSE}
    />

    {/* Mustache */}
    <MustacheHalf
      ox={ox}
      oy={oy}
    />
    <MustacheHalf
      ox={ox}
      oy={oy}
      flip
    />

    {/* Cheeks */}
    <Ellipse
      cx={ox + 16 + 15}
      cy={oy + 84 + 9}
      rx={15}
      ry={9}
      fill="url(#tCheek)"
    />
    <Ellipse
      cx={ox + 152 - 16 - 15}
      cy={oy + 84 + 9}
      rx={15}
      ry={9}
      fill="url(#tCheek)"
    />
  </>
)

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Brows */}
      <Rect
        x={ox + 34}
        y={oy + 43}
        width={24}
        height={6}
        rx={3}
        fill={BROW}
        transform={`rotate(9 ${ox + 46} ${oy + 46})`}
      />
      <Rect
        x={ox + 152 - 34 - 24}
        y={oy + 43}
        width={24}
        height={6}
        rx={3}
        fill={BROW}
        transform={`rotate(-9 ${ox + 152 - 46} ${oy + 46})`}
      />

      {/* Eyes */}
      <TomatoEye
        ox={ox}
        oy={oy}
        dx={36}
        dy={52}
        irisInset={6}
      />
      <TomatoEye
        ox={ox}
        oy={oy}
        dx={152 - 36 - 26}
        dy={52}
        irisInset={3}
      />

      {/* Smile */}
      {(() => {
        const mouthW = 30
        const mouthH = 17
        const mouthL = ox + (152 - mouthW) / 2
        const mouthR = mouthL + mouthW
        const mouthT = oy + 108
        const mouthB = mouthT + mouthH
        
        const tongueW = 20
        const tongueL = ox + (152 - tongueW) / 2

        const mouthD = mouthPath(mouthL, mouthT, mouthW, mouthH)
        const tongueD = tonguePath(tongueL, tongueW, mouthB)

        return (
          <G>
            <Defs>
              <ClipPath id="tMouth">
                <Path d={mouthD} />
              </ClipPath>
            </Defs>
            <Path
              d={mouthD}
              fill="#7A2418"
            />
            <G clipPath="url(#tMouth)">
              <Path
                d={tongueD}
                fill="#F2887C"
              />
              <Path
                d={`M ${mouthL} ${mouthT + 2} L ${mouthR} ${mouthT + 2}`}
                stroke="rgba(40,12,8,0.45)"
                strokeWidth={3}
                strokeLinecap="round"
              />
            </G>
          </G>
        )
      })()}
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Brows */}
      <Rect
        x={ox + 34}
        y={oy + 46}
        width={23}
        height={5}
        rx={2.5}
        fill={BROW}
        transform={`rotate(5 ${ox + 45} ${oy + 48})`}
      />
      <Rect
        x={ox + 152 - 34 - 23}
        y={oy + 46}
        width={23}
        height={5}
        rx={2.5}
        fill={BROW}
        transform={`rotate(-5 ${ox + 152 - 45} ${oy + 48})`}
      />

      {/* Eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={36}
        dy={66}
        d="q 12 -11 24 0"
        color="#432418"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={152 - 36 - 24}
        dy={66}
        d="q 12 -11 24 0"
        color="#432418"
      />

      {/* Smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={(152 - 24) / 2}
        dy={110}
        d="q 12 9 24 0"
        color="#7A2418"
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Brows */}
      <Rect
        x={ox + 33}
        y={oy + 52}
        width={24}
        height={6}
        rx={3}
        fill={BROW_TIRED}
        transform={`rotate(-12 ${ox + 45} ${oy + 55})`}
      />
      <Rect
        x={ox + 152 - 33 - 24}
        y={oy + 52}
        width={24}
        height={6}
        rx={3}
        fill={BROW_TIRED}
        transform={`rotate(12 ${ox + 152 - 45} ${oy + 55})`}
      />

      {/* Eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={36}
        dy={66}
        d="q 11.5 9 23 0"
        color="#3A2018"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={152 - 36 - 23}
        dy={66}
        d="q 11.5 9 23 0"
        color="#3A2018"
      />

      {/* Under-eye shading */}
      <Path
        d={roundedBoxPath(ox + 38, oy + 76, 18, 5, [
          [0, 0],
          [0, 0],
          [0.44, 1],
          [0.44, 1],
        ])}
        fill="rgba(90,30,20,0.3)"
        transform={`rotate(6 ${ox + 47} ${oy + 78})`}
      />
      <Path
        d={roundedBoxPath(ox + 152 - 38 - 18, oy + 76, 18, 5, [
          [0, 0],
          [0, 0],
          [0.44, 1],
          [0.44, 1],
        ])}
        fill="rgba(90,30,20,0.3)"
        transform={`rotate(-6 ${ox + 152 - 47} ${oy + 78})`}
      />

      {/* Mouth */}
      <Path
        d={roundedBoxPath(ox + (152 - 13) / 2, oy + 110, 13, 9, [
          [0, 0],
          [0, 0],
          [0.54, 1],
          [0.54, 1],
        ])}
        fill="rgba(70,25,18,0.7)"
      />
    </>
  ),
  [Mood.SAD]: ({ ox, oy }: OffsetProps) => (
    <>
      <Rect
        x={ox + 34}
        y={oy + 48}
        width={24}
        height={6}
        rx={3}
        fill={BROW_TIRED}
        transform={`rotate(16 ${ox + 46} ${oy + 51})`}
      />
      <Rect
        x={ox + 152 - 34 - 24}
        y={oy + 48}
        width={24}
        height={6}
        rx={3}
        fill={BROW_TIRED}
        transform={`rotate(-16 ${ox + 152 - 46} ${oy + 51})`}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={36}
        dy={62}
        d="q 12 10 24 0"
        color="#3A2018"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={152 - 36 - 24}
        dy={62}
        d="q 12 10 24 0"
        color="#3A2018"
      />

      {/* Frown */}
      <Arc
        ox={ox}
        oy={oy}
        dx={(152 - 24) / 2}
        dy={114}
        d="q 12 -9 24 0"
        color="#7A2418"
      />
    </>
  ),
}

const Face = ({ mood, ox, oy }: { mood: Mood } & OffsetProps) => {
  const MoodFace = FACE[mood]

  return (
    <>
      <Defs>
        <RadialGradient id="tCheek" cx="50%" cy="50%" r="50%">
          <Stop offset="0" stopColor="#FF7862" stopOpacity={0.55} />
          <Stop offset="0.7" stopColor="#FF7862" stopOpacity={0} />
        </RadialGradient>
        <RadialGradient id="tIris" cx="40%" cy="32%" r="70%">
          <Stop offset="0" stopColor="#6B3320" />
          <Stop offset="1" stopColor="#38180E" />
        </RadialGradient>
      </Defs>

      <Shared
        ox={ox}
        oy={oy}
      />
      <MoodFace
        ox={ox}
        oy={oy}
      />
    </>
  )
}

export default Face
