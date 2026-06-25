import React from 'react'
import {
  G,
  Ellipse,
  Circle
} from 'react-native-svg'

type TomatoEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  irisInset: number
}

const SCLERA = { w: 26, h: 30 }
const IRIS = { w: 17, h: 20 }

const TomatoEye = ({ ox, oy, dx, dy, irisInset }: TomatoEyeProps) => {
  const x = ox + dx
  const y = oy + dy
  // iris div is offset `top:6` inside the sclera in the mockup
  const irisCx = x + irisInset + IRIS.w / 2
  const irisCy = y + 6 + IRIS.h / 2

  return (
    <G>
      <Ellipse
        cx={x + SCLERA.w / 2}
        cy={y + SCLERA.h / 2}
        rx={SCLERA.w / 2}
        ry={SCLERA.h / 2}
        fill="#FBF3EC"
      />
      <Ellipse
        cx={irisCx}
        cy={irisCy}
        rx={IRIS.w / 2}
        ry={IRIS.h / 2}
        fill="url(#tIris)"
      />
      {/* glint: `left:9 top:3` (5×5) inside the iris div */}
      <Circle
        cx={x + irisInset + 9 + 2.5}
        cy={y + 6 + 3 + 2.5}
        r={2.5}
        fill="#fff"
      />
    </G>
  )
}

export default TomatoEye
