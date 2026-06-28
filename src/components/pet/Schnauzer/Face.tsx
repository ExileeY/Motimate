import React from 'react'
import { Path } from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import SchnauzerEye from '@/components/pet/Schnauzer/FaceItems/SchnauzerEye'
import SchnauzerBrow from '@/components/pet/Schnauzer/FaceItems/SchnauzerBrow'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

const MOUTH_COLOR = '#4A3F36'

// Beard origin (head.x + (head.w-116)/2, head.y + 64) — keep in sync with index.
const BEARD = { x: 32, y: 88 }
const MOUTH_CX = BEARD.x + 116 / 2

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={42}
        dy={64}
        w={32}
        h={14}
        rotate={-12}
      />
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={106}
        dy={64}
        w={32}
        h={14}
        rotate={12}
      />

      <SchnauzerEye
        ox={ox}
        oy={oy}
        dx={56}
        dy={72}
      />
      <SchnauzerEye
        ox={ox}
        oy={oy}
        dx={107}
        dy={72}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={MOUTH_CX - 15}
        dy={BEARD.y + 30}
        d="q 15 13 30 0"
        color={MOUTH_COLOR}
      />

      <Path
        d={`M ${ox + MOUTH_CX - 7} ${oy + BEARD.y + 36} h 14 v 6 a 7 7 0 0 1 -14 0 Z`}
        fill="#E78F86"
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={42}
        dy={66}
        w={32}
        h={14}
        rotate={-8}
      />
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={106}
        dy={66}
        w={32}
        h={14}
        rotate={8}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={57}
        dy={78}
        d="q 9 -9 18 0"
        color="#2D2823"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={105}
        dy={78}
        d="q 9 -9 18 0"
        color="#2D2823"
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={MOUTH_CX - 11}
        dy={BEARD.y + 31}
        d="q 11 10 22 0"
        color={MOUTH_COLOR}
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={42}
        dy={68}
        w={32}
        h={14}
        rotate={-6}
      />
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={106}
        dy={68}
        w={32}
        h={14}
        rotate={6}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={57}
        dy={80}
        d="q 8 5 16 0"
        color="#2D2823"
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={105}
        dy={80}
        d="q 8 5 16 0"
        color="#2D2823"
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={MOUTH_CX - 7}
        dy={BEARD.y + 32}
        d="q 7 5 14 0"
        color={MOUTH_COLOR}
      />
    </>
  ),
  [Mood.SAD]: ({ ox, oy }: OffsetProps) => (
    <>
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={43}
        dy={72}
        w={30}
        h={13}
        rotate={-16}
      />
      <SchnauzerBrow
        ox={ox}
        oy={oy}
        dx={107}
        dy={72}
        w={30}
        h={13}
        rotate={16}
      />

      <SchnauzerEye
        ox={ox}
        oy={oy}
        dx={56}
        dy={76}
      />
      <SchnauzerEye
        ox={ox}
        oy={oy}
        dx={107}
        dy={76}
      />

      {/* Tears */}
      <Path
        d={`M ${ox + 62} ${oy + 92} a 4.5 5 0 0 1 9 0 q 0 6 -4.5 8 q -4.5 -2 -4.5 -8 Z`}
        fill="#A6D2EE"
        opacity={0.9}
      />
      <Path
        d={`M ${ox + 109} ${oy + 92} a 4.5 5 0 0 1 9 0 q 0 6 -4.5 8 q -4.5 -2 -4.5 -8 Z`}
        fill="#A6D2EE"
        opacity={0.9}
      />

      <Arc
        ox={ox}
        oy={oy}
        dx={MOUTH_CX - 9}
        dy={BEARD.y + 36}
        d="q 9 -7 18 0"
        color={MOUTH_COLOR}
      />
    </>
  ),
}

const Face = ({ mood, ox, oy }: { mood: Mood } & OffsetProps) => {
  const MoodFace = FACE[mood]

  return (
    <MoodFace
      ox={ox}
      oy={oy}
    />
  )
}

export default Face
