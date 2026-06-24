import React from 'react'
import { Path } from 'react-native-svg'

type ArcProps = {
  ox: number,
  oy: number,
  dx: number,
  dy: number,
  d: string,
  color: string
}

const Arc = ({ ox, oy, dx, dy, d, color }: ArcProps) => (
  <Path
    d={`M ${ox + dx} ${oy + dy} ${d}`}
    stroke={color}
    strokeWidth={3}
    fill="none"
    strokeLinecap="round"
  />
)

export default Arc
