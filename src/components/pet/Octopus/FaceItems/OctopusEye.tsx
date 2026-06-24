import React from 'react'
import { Ellipse, Circle } from 'react-native-svg'

type OctopusEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  irisX: number
  irisY: number
}

const SCLERA = { w: 32, h: 36 }
const IRIS = { w: 15, h: 17 }
const CATCHLIGHT = { dx: 3, dy: 3, r: 2.5 }

const OctopusEye = ({ ox, oy, dx, dy, irisX, irisY }: OctopusEyeProps) => {
  const x = ox + dx
  const y = oy + dy

  return (
    <>
      {/* Sclera */}
      <Ellipse
        cx={x + SCLERA.w / 2}
        cy={y + SCLERA.h / 2}
        rx={SCLERA.w / 2}
        ry={SCLERA.h / 2}
        fill="#FBF3EC"
      />

      {/* Iris */}
      <Ellipse
        cx={x + irisX + IRIS.w / 2}
        cy={y + irisY + IRIS.h / 2}
        rx={IRIS.w / 2}
        ry={IRIS.h / 2}
        fill="#4A352A"
      />

      {/* Catchlight */}
      <Circle
        cx={x + irisX + CATCHLIGHT.dx + CATCHLIGHT.r}
        cy={y + irisY + CATCHLIGHT.dy + CATCHLIGHT.r}
        r={CATCHLIGHT.r}
        fill="#fff"
      />
    </>
  )
}

export default OctopusEye
