import React from 'react'
import { Rect } from 'react-native-svg'

import Arc from '@/components/pet/shared/FaceItems/Arc'
import Cheek from '@/components/pet/shared/FaceItems/Cheek'
import KhinklEye from '@/components/pet/Khinklear/FaceItems/KhinklEye'

import { Mood } from '@/pet/mood'
import { OffsetProps } from '@/components/pet/shared/types'

type FaceProps = OffsetProps & { scale: number }

const POUCH_WIDTH = 152
const INK_BASIC = '#4A352A'
const INK_TIRED = '#6B4F3F'
const BLUSH = '#EF9FB4'

type LashProps = FaceProps & {
  x: number
  y: number
  w: number
  deg: number
  color: string
}

const Lash = ({ ox, oy, scale, x, y, w, deg, color }: LashProps) => (
  <Rect
    x={ox + x * scale}
    y={oy + y * scale}
    width={w * scale}
    height={2.5 * scale}
    rx={2 * scale}
    fill={color}
    transform={`rotate(${deg} ${ox + (x + w / 2) * scale} ${oy + (y + 1.25) * scale})`}
  />
)

const Shared = ({ ox, oy, scale }: FaceProps) => (
  <>
    <Cheek
      ox={ox}
      oy={oy}
      dx={(16 + 12) * scale}
      dy={(72 + 7.5) * scale}
      color={BLUSH}
      opacity={0.55}
      rx={12 * scale}
      ry={7.5 * scale}
    />
    <Cheek
      ox={ox}
      oy={oy}
      dx={(POUCH_WIDTH - 16 - 12) * scale}
      dy={(72 + 7.5) * scale}
      color={BLUSH}
      opacity={0.55}
      rx={12 * scale}
      ry={7.5 * scale}
    />
  </>
)

const FACE: Record<Mood, React.FC<FaceProps>> = {
  [Mood.ENERGETIC]: ({ ox, oy, scale }: FaceProps) => (
    <>
      {/* Round open eyes */}
      <KhinklEye
        ox={ox}
        oy={oy}
        dx={42}
        dy={52}
        scale={scale}
      />
      <KhinklEye
        ox={ox}
        oy={oy}
        dx={POUCH_WIDTH - 42 - 15}
        dy={52}
        scale={scale}
      />

      {/* Eyelashes (4) */}
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={36}
        y={48}
        w={9}
        deg={-32} color={INK_BASIC}
      />
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={39} y={45}
        w={9}
        deg={-12} color={INK_BASIC}
      />
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={POUCH_WIDTH - 36 - 9}
        y={48}
        w={9}
        deg={32}
        color={INK_BASIC}
      />
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={POUCH_WIDTH - 39 - 9}
        y={45}
        w={9}
        deg={12}
        color={INK_BASIC}
      />

      {/* Open smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={(POUCH_WIDTH / 2 - 9) * scale}
        dy={82 * scale}
        d={`q ${9 * scale} ${11 * scale} ${18 * scale} 0`}
        color={INK_BASIC}
      />
    </>
  ),
  [Mood.CALM]: ({ ox, oy, scale }: FaceProps) => (
    <>
      {/* Content eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={40 * scale}
        dy={64 * scale}
        d={`q ${10 * scale} ${-11 * scale} ${20 * scale} 0`}
        color={INK_BASIC}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={(POUCH_WIDTH - 40 - 20) * scale}
        dy={64 * scale}
        d={`q ${10 * scale} ${-11 * scale} ${20 * scale} 0`}
        color={INK_BASIC}
      />

      {/* Eyelashes (2) */}
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={36}
        y={52}
        w={8}
        deg={-28}
        color={INK_BASIC}
      />
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={POUCH_WIDTH - 36 - 8}
        y={52}
        w={8}
        deg={28}
        color={INK_BASIC}
      />

      {/* Soft smile */}
      <Arc
        ox={ox}
        oy={oy}
        dx={(POUCH_WIDTH / 2 - 7.5) * scale}
        dy={82 * scale}
        d={`q ${7.5 * scale} ${9 * scale} ${15 * scale} 0`}
        color={INK_BASIC}
      />
    </>
  ),
  [Mood.TIRED]: ({ ox, oy, scale }: FaceProps) => (
    <>
      {/* Sleepy eyes */}
      <Arc
        ox={ox}
        oy={oy}
        dx={41 * scale}
        dy={62 * scale}
        d={`q ${8.5 * scale} ${9 * scale} ${17 * scale} 0`}
        color={INK_TIRED}
      />
      <Arc
        ox={ox}
        oy={oy}
        dx={(POUCH_WIDTH - 41 - 17) * scale}
        dy={62 * scale}
        d={`q ${8.5 * scale} ${9 * scale} ${17 * scale} 0`}
        color={INK_TIRED}
      />

      {/* Lashes (2, drooping outward) */}
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={38}
        y={64}
        w={7}
        deg={20}
        color={INK_TIRED}
      />
      <Lash
        ox={ox}
        oy={oy}
        scale={scale}
        x={POUCH_WIDTH - 38 - 7}
        y={64}
        w={7}
        deg={-20}
        color={INK_TIRED}
      />

      {/* Small mouth */}
      <Arc
        ox={ox}
        oy={oy}
        dx={(POUCH_WIDTH / 2 - 6.5) * scale}
        dy={84 * scale}
        d={`q ${6.5 * scale} ${8 * scale} ${13 * scale} 0`}
        color={INK_TIRED}
      />
    </>
  ),
}

const Face = ({ mood, ox, oy, scale }: { mood: Mood } & FaceProps) => {
  const MoodFace = FACE[mood]

  return (
    <>
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
