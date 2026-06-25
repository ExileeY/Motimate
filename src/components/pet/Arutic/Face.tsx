import React from 'react'
import {
  Defs,
  RadialGradient,
  Stop,
  Rect,
  Path
} from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import AruticEye from '@/components/pet/Arutic/FaceItems/AruticEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

type FaceProps = OffsetProps & { scale: number }

const BROW = '#9A7038'
const LID = '#4A3526'

const FACE_WIDTH = 124
const EYE_WIDTH = 22
const EYE_INSET = 31

const LEFT_EYE_DX = EYE_INSET
const RIGHT_EYE_DX = FACE_WIDTH - EYE_INSET - EYE_WIDTH

const Shared = ({ ox, oy, scale }: FaceProps) => (
  <>
    {/* Eyebrows */}
    <Rect
      x={ox + 28 * scale}
      y={oy + 58 * scale}
      width={24 * scale}
      height={6 * scale}
      rx={3 * scale}
      fill={BROW}
      transform={`rotate(7 ${ox + (28 + 12) * scale} ${oy + (58 + 3) * scale})`}
    />
    <Rect
      x={ox + (124 - 28 - 24) * scale}
      y={oy + 58 * scale}
      width={24 * scale}
      height={6 * scale}
      rx={3 * scale}
      fill={BROW}
      transform={`rotate(-7 ${ox + (124 - 28 - 12) * scale} ${oy + (58 + 3) * scale})`}
    />

    {/* Nose */}
    <Path
      d={`M ${ox + (62 - 6) * scale} ${oy + 80 * scale} h ${12 * scale} v ${(14 - 6) * scale} q 0 ${6 * scale} ${-6 * scale} ${6 * scale} q ${-6 * scale} 0 ${-6 * scale} ${-6 * scale} Z`}
      fill="rgba(170,110,65,0.32)"
    />
  </>
)

const FACE: Record<Mood, React.FC<FaceProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy, scale }: FaceProps) => (
    <>
      <AruticEye
        ox={ox}
        oy={oy}
        dx={LEFT_EYE_DX}
        dy={66}
        scale={scale}
        irisDx={5}
        lidTop={-7}
        id="aEyeL"
      />
      <AruticEye
        ox={ox}
        oy={oy}
        dx={RIGHT_EYE_DX}
        dy={66}
        scale={scale}
        irisDx={6}
        lidTop={-7}
        id="aEyeR"
      />

      {/* Smile */}
      <Path
        d={`M ${ox + (62 - 10) * scale} ${oy + 99 * scale} h ${20 * scale} v ${1 * scale} q 0 ${6 * scale} ${-10 * scale} ${6 * scale} q ${-10 * scale} 0 ${-10 * scale} ${-6 * scale} Z`}
        fill="#E9CFA8"
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy, scale }: FaceProps) => (
    <>
      <AruticEye
        ox={ox}
        oy={oy}
        dx={LEFT_EYE_DX}
        dy={66}
        scale={scale}
        irisDx={5}
        lidTop={-5}
        id="aEyeL"
      />
      <AruticEye
        ox={ox}
        oy={oy}
        dx={RIGHT_EYE_DX}
        dy={66}
        scale={scale}
        irisDx={6}
        lidTop={-5}
        id="aEyeR"
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy, scale }: FaceProps) => (
    <>
      {/* Closed sleepy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={33 * scale}
        dy={70 * scale}
        d={`q ${10 * scale} ${7 * scale} ${20 * scale} 0`}
        color={LID}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={(124 - 33 - 20) * scale}
        dy={70 * scale}
        d={`q ${10 * scale} ${7 * scale} ${20 * scale} 0`}
        color={LID}
      />
    </>
  ),
}

const Face = ({ mood, ox, oy, scale }: { mood: Mood } & FaceProps) => {
  const MoodFace = FACE[mood]

  return (
    <>
      <Defs>
        <RadialGradient
          id="aIris"
          cx="40%"
          cy="35%"
          r="70%"
        >
          <Stop
            offset="0"
            stopColor="#B9CDD6"
          />
          <Stop
            offset="1"
            stopColor="#8AA7B2"
          />
        </RadialGradient>
      </Defs>

      <Shared
        ox={ox}
        oy={oy}
        scale={scale}
      />
      <MoodFace
        ox={ox}
        oy={oy}
        scale={scale}
      />
    </>
  )
}

export default Face
