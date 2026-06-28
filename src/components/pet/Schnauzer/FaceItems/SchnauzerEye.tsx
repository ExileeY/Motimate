import React from 'react'
import { Ellipse, Circle } from 'react-native-svg'

type SchnauzerEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
}

const EYE = { w: 17, h: 21 }

const SchnauzerEye = ({ ox, oy, dx, dy }: SchnauzerEyeProps) => {
  const x = ox + dx
  const y = oy + dy

  return (
    <>
      <Ellipse
        cx={x + EYE.w / 2}
        cy={y + EYE.h / 2}
        rx={EYE.w / 2}
        ry={EYE.h / 2}
        fill="#2D2823"
      />
      <Circle
        cx={x + 3 + 3}
        cy={y + 3 + 3}
        r={3}
        fill="#fff"
      />
    </>
  )
}

export default SchnauzerEye
