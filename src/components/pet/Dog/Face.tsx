import React from 'react'
import { Rect, Ellipse, Path, RadialGradient, Stop, Defs } from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import DogEye from '@/components/pet/Dog/FaceItems/DogEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

const EYE_COLOR = '#4A352A'
const PHILTRUM = '#7a5a44'

const SNOUT = {
  cx: 90,
  top: 100,
  w: 74,
  h: 56,
}
const NOSE_TOP = SNOUT.top + 6

const Shared = ({ ox, oy }: OffsetProps) => (
  <>
    {/* Snout patch */}
    <Ellipse
      cx={ox + SNOUT.cx}
      cy={oy + SNOUT.top + SNOUT.h / 2}
      rx={SNOUT.w / 2}
      ry={SNOUT.h / 2}
      fill="url(#dSnout)"
    />

    {/* Nose */}
    <Ellipse
      cx={ox + SNOUT.cx}
      cy={oy + NOSE_TOP + 8}
      rx={12}
      ry={8}
      fill="#4A352A"
    />
  </>
)

const FACE: Record<Mood, React.FC<OffsetProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy }: OffsetProps) => (
    <>
      <DogEye
        ox={ox}
        oy={oy}
        dx={56}
        dy={72}
      />
      <DogEye
        ox={ox}
        oy={oy}
        dx={108}
        dy={72}
      />

      {/* Philtrum */}
      <Rect
        x={ox + SNOUT.cx - 1}
        y={oy + SNOUT.top + 21}
        width={2}
        height={9}
        rx={1}
        fill={PHILTRUM}
      />

      {/* Open smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={SNOUT.cx - 15}
        dy={SNOUT.top + 27}
        d="q 15 12 30 0"
        color={PHILTRUM}
      />

      {/* Tongue */}
      <Path
        d={`M ${ox + SNOUT.cx - 6.5} ${oy + SNOUT.top + 33} h 13 v 7 a 6.5 7 0 0 1 -13 0 Z`}
        fill="#F2938B"
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Closed happy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={57}
        dy={74}
        d="q 9 -9 18 0"
        color={EYE_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={105}
        dy={74}
        d="q 9 -9 18 0"
        color={EYE_COLOR}
      />

      {/* Philtrum */}
      <Rect
        x={ox + SNOUT.cx - 1}
        y={oy + SNOUT.top + 21}
        width={2}
        height={9}
        rx={1}
        fill={PHILTRUM}
      />

      {/* Smaller smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={SNOUT.cx - 11}
        dy={SNOUT.top + 27}
        d="q 11 10 22 0"
        color={PHILTRUM}
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy }: OffsetProps) => (
    <>
      {/* Flat sleepy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={57}
        dy={76}
        d="q 8 5 16 0"
        color={EYE_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={107}
        dy={76}
        d="q 8 5 16 0"
        color={EYE_COLOR}
      />

      {/* Shorter philtrum */}
      <Rect
        x={ox + SNOUT.cx - 1}
        y={oy + SNOUT.top + 21}
        width={2}
        height={8}
        rx={1}
        fill={PHILTRUM}
      />

      {/* Tiny mouth */}
      <Arc
        ox={ox}
        oy={oy}
        dx={SNOUT.cx - 7}
        dy={SNOUT.top + 26}
        d="q 7 5 14 0"
        color={PHILTRUM}
      />
    </>
  ),
  [Mood.SAD]: ({ ox, oy }: OffsetProps) => (
    <>
      <Arc
        ox={ox}
        oy={oy}
        dx={56}
        dy={72}
        d="q 9 9 18 0"
        color={EYE_COLOR}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={106}
        dy={72}
        d="q 9 9 18 0"
        color={EYE_COLOR}
      />

      {/* Philtrum */}
      <Rect
        x={ox + SNOUT.cx - 1}
        y={oy + SNOUT.top + 21}
        width={2}
        height={8}
        rx={1}
        fill={PHILTRUM}
      />

      {/* Frown */}
      <Arc
        ox={ox}
        oy={oy}
        dx={SNOUT.cx - 9}
        dy={SNOUT.top + 30}
        d="q 9 -7 18 0"
        color={PHILTRUM}
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
          id="dSnout"
          cx="50%"
          cy="35%"
          r="60%"
        >
          <Stop
            offset="0"
            stopColor="#F9ECD2"
          />
          <Stop
            offset="1"
            stopColor="#EEDAB2"
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
