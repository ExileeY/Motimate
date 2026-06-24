import React from 'react'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import Cheek from '@/components/pet/shared/FaceItems/Cheek'
import OctopusEye from '@/components/pet/Octopus/FaceItems/OctopusEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

const MOUTH_COLOR = '#4A352A'

const Cheeks = ({ ox, oy, opacity }: OffsetProps & { opacity: number }) => (
  <>
    <Cheek
      ox={ox}
      oy={oy}
      dx={28}
      dy={80.5}
      color="#E8736B"
      opacity={opacity}
      rx={10}
      ry={6.5}
      filterId="soft"
    />
    <Cheek
      ox={ox}
      oy={oy}
      dx={152}
      dy={80.5}
      color="#E8736B"
      opacity={opacity}
      rx={10}
      ry={6.5}
      filterId="soft"
    />
  </>
)

const OpenEyes = ({ ox, oy }: OffsetProps) => (
  <>
    <OctopusEye
      ox={ox}
      oy={oy}
      dx={24}
      dy={34}
      irisX={9}
      irisY={12}
    />
    <OctopusEye
      ox={ox}
      oy={oy}
      dx={124}
      dy={34}
      irisX={8}
      irisY={12}
    />
  </>
)

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        opacity={0.45}
      />

      <OpenEyes
        ox={ox}
        oy={oy}
      />

      {/* Open smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={81}
        dy={78}
        d="q 9 11 18 0"
        color={MOUTH_COLOR}
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        opacity={0.45}
      />

      <OpenEyes
        ox={ox}
        oy={oy}
      />

      {/* Smaller smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={82.5}
        dy={78}
        d="q 7.5 10 15 0"
        color={MOUTH_COLOR}
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      <Cheeks
        ox={ox}
        oy={oy}
        opacity={0.4}
      />

      {/* Closed sleepy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={26}
        dy={46}
        d="q 13 12 26 0"
        color={MOUTH_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={128}
        dy={46}
        d="q 13 12 26 0"
        color={MOUTH_COLOR}
      />

      {/* Tiny mouth */}
      <Arc
        ox={ox}
        oy={oy}
        dx={84}
        dy={80}
        d="q 6 7 12 0"
        color={MOUTH_COLOR}
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
