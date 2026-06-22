import React from 'react'
import {
  Circle,
  Ellipse
} from 'react-native-svg'

type RoundEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  color?: string
}

const RoundEye = ({ ox, oy, dx, dy, color = '#4A352A' }: RoundEyeProps) => (
  <>
    <Ellipse
      cx={ox + dx}
      cy={oy + dy}
      rx={8}
      ry={10}
      fill={color}
    />
    <Circle
      cx={ox + dx - 2}
      cy={oy + dy - 4}
      r={3}
      fill="#fff"
    />
  </>
)

export default RoundEye
