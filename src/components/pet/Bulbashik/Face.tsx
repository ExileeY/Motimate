import React from 'react'
import {
  Rect,
  Ellipse,
  RadialGradient,
  Stop,
  Defs
} from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import BulbEye from '@/components/pet/Bulbashik/FaceItems/BulbEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

const EYE_COLOR = '#8A5A33'

const Shared = ({ ox, oy }: OffsetProps) => (
  <>
    {/* Brows */}
    <Rect
      x={ox + 38}
      y={oy + 42}
      width={24}
      height={6}
      rx={3}
      fill="#A37C44"
      transform={`rotate(-7 ${ox + 50} ${oy + 45})`}
    />
    <Rect
      x={ox + 90}
      y={oy + 42}
      width={24}
      height={6}
      rx={3}
      fill="#A37C44"
      transform={`rotate(7 ${ox + 102} ${oy + 45})`}
    />

    {/* Cheeks */}
    <Ellipse
      cx={ox + 35}
      cy={oy + 88}
      rx={15}
      ry={9}
      fill="url(#bCheek)"
    />
    <Ellipse
      cx={ox + 117}
      cy={oy + 88}
      rx={15}
      ry={9}
      fill="url(#bCheek)"
    />

    {/* Nose */}
    <Ellipse
      cx={ox + 76}
      cy={oy + 84.5}
      rx={8}
      ry={6.5}
      fill="url(#bNose)"
    />
  </>
)

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      <BulbEye
        ox={ox}
        oy={oy}
        dx={40}
        dy={50}
        irisInset={6}
      />
      <BulbEye
        ox={ox}
        oy={oy}
        dx={86}
        dy={50}
        irisInset={4}
      />

      {/* Smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={53}
        dy={96}
        d="q 23 22 46 0"
        color="#8A5A33"
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Closed happy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={41}
        dy={62}
        d="q 11 -11 22 0" color={EYE_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={89}
        dy={62}
        d="q 11 -11 22 0" color={EYE_COLOR}
      />

      {/* Smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={61}
        dy={96}
        d="q 15 9 30 0" color={EYE_COLOR}
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Flat sleepy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={41}
        dy={64}
        d="q 10 6 20 0" color={EYE_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={91}
        dy={64}
        d="q 10 6 20 0" color={EYE_COLOR}
      />

      {/* Tiny mouth */}
      <Arc
        ox={ox}
        oy={oy}
        dx={68}
        dy={98}
        d="q 8 7 16 0" color={EYE_COLOR}
      />
    </>
  ),
}

const Face = ({ mood, ox, oy }: { mood: Mood } & OffsetProps) => {
  const MoodFace = FACE[mood]

  return (
    <>
      <Defs>
        <RadialGradient
          id="bCheek"
          cx="50%"
          cy="50%"
          r="50%"
        >
          <Stop
            offset="0"
            stopColor="#F08278"
            stopOpacity={0.6}
          />
          <Stop
            offset="0.7"
            stopColor="#F08278"
            stopOpacity={0}
          />
        </RadialGradient>

        <RadialGradient
          id="bNose"
          cx="40%"
          cy="30%"
          r="70%"
        >
          <Stop
            offset="0"
            stopColor="#E2C083"
          />
          <Stop
            offset="1"
            stopColor="#C49E64"
          />
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
