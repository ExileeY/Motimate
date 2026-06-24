import React from 'react'
import { Ellipse } from 'react-native-svg'

type CheekProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  color?: string
  opacity: number
  rx?: number
  ry?: number
  filterId?: string
}

const Cheek = ({ ox, oy, dx, dy, color = "#F2938b", opacity, rx = 11, ry = 7.5, filterId }: CheekProps) => (
  <Ellipse
    cx={ox + dx}
    cy={oy + dy}
    rx={rx}
    ry={ry}
    fill={color}
    opacity={opacity}
    filter={filterId ? `url(#${filterId})` : undefined}
  />
)

export default Cheek
