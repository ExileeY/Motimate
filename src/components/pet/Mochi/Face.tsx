import React from 'react'

import Arc from '@/components/pet/Mochi/FaceItems/Arc'
import Cheek from '@/components/pet/Mochi/FaceItems/Cheek'
import RoundEye from '@/components/pet/Mochi/FaceItems/RoundEye'

import { Mood } from '@/mood/mood'

export type OffsetProps = {
  ox: number
  oy: number
}

const Cheeks = ({ ox, oy, dy, opacity }: OffsetProps & { dy: number; opacity: number }) => (
  <>
    <Cheek
      ox={ox}
      oy={oy}
      dx={33}
      dy={dy}
      opacity={opacity}
    />
    <Cheek
      ox={ox}
      oy={oy}
      dx={115}
      dy={dy}
      opacity={opacity}
    />
  </>
)

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        dy={70 + 7.5}
        opacity={0.5}
      />

      <RoundEye
        ox={ox}
        oy={oy}
        dx={48}
        dy={60}
      />
      <RoundEye
        ox={ox}
        oy={oy}
        dx={100}
        dy={60}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={65}
        dy={80}
        d="q 9 11 18 0"
        color="#4A352A"
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        dy={72 + 7.5}
        opacity={0.5}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={39}
        dy={64}
        d="q 10 -11 20 0"
        color="#4A352A"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={89}
        dy={64}
        d="q 10 -11 20 0"
        color="#4A352A"
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={66}
        dy={84}
        d="q 7.5 9 15 0"
        color="#4A352A"
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        dy={74 + 6.5}
        opacity={0.45}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={41}
        dy={66}
        d="q 8.5 9 17 0"
        color="#6B4F3F"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={90}
        dy={66}
        d="q 8.5 9 17 0"
        color="#6B4F3F"
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={67.5}
        dy={88}
        d="q 6.5 8 13 0"
        color="#6B4F3F"
      />
    </>
  ),
}

const Face = ({ mood, ox, oy }: { mood: Mood } & OffsetProps) => {
  const MoodFace = FACE[mood]

  return <MoodFace
    ox={ox}
    oy={oy}
  />
}

export default Face
