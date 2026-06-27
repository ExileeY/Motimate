import React from 'react'
import { Rect } from 'react-native-svg'

import { OffsetProps } from '@/components/pet/shared/types'

type FaceProps = OffsetProps & { scale: number }

const BROW = '#9A7038'

const FACE_WIDTH = 124
const BROW_Y = 58
const BROW_HEIGHT = 6

type BrowsProps = FaceProps & {
  inset: number
  width: number
  angle: number
}

const Brows = ({ ox, oy, scale, inset, width, angle }: BrowsProps) => {
  const rightX = FACE_WIDTH - inset - width
  const y = oy + BROW_Y * scale
  const pivotY = oy + (BROW_Y + BROW_HEIGHT / 2) * scale

  return (
    <>
      <Rect
        x={ox + inset * scale}
        y={y}
        width={width * scale}
        height={BROW_HEIGHT * scale}
        rx={(BROW_HEIGHT / 2) * scale}
        fill={BROW}
        transform={`rotate(${angle} ${ox + (inset + width / 2) * scale} ${pivotY})`}
      />
      <Rect
        x={ox + rightX * scale}
        y={y}
        width={width * scale}
        height={BROW_HEIGHT * scale}
        rx={(BROW_HEIGHT / 2) * scale}
        fill={BROW}
        transform={`rotate(${-angle} ${ox + (rightX + width / 2) * scale} ${pivotY})`}
      />
    </>
  )
}

export const NeutralBrows = (props: FaceProps) => (
  <Brows
    {...props}
    inset={28}
    width={24}
    angle={7}
  />
)

export const AngryBrows = (props: FaceProps) => (
  <Brows
    {...props}
    inset={30}
    width={26}
    angle={20}
  />
)
