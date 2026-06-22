import React from 'react'
import { Ellipse } from 'react-native-svg'

type CheekProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  color?: string
  opacity: number
}

const Cheek = ({ ox, oy, dx, dy, color = "#F2938b", opacity }: CheekProps) => (
  <>
    <Ellipse
      cx={ox + dx}
      cy={oy + dy}
      rx={11}
      ry={7.5}
      fill={color}
      opacity={opacity}
      filter="url(#soft)"
    />
  </>
)

export default Cheek
