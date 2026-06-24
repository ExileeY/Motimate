import React from 'react'
import { Ellipse, Circle } from 'react-native-svg'

type DogEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
}

const EYE = { w: 16, h: 20 }

const DogEye = ({ ox, oy, dx, dy }: DogEyeProps) => {
  const x = ox + dx
  const y = oy + dy

  return (
    <>
      <Ellipse
        cx={x + EYE.w / 2}
        cy={y + EYE.h / 2}
        rx={EYE.w / 2}
        ry={EYE.h / 2}
        fill="#4A352A"
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

export default DogEye
