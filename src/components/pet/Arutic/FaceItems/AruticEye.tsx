import React from 'react'
import {
  Defs,
  ClipPath,
  Ellipse,
  Circle,
  Path
} from 'react-native-svg'

type AruticEyeProps = {
  id: string
  ox: number
  oy: number
  dx: number
  dy: number
  scale: number
  irisDx: number
  lidTop: number
}

const EYE = { w: 22, h: 13 }
const IRIS = { radius: 5.5 }
const PUPIL = { radius: 2.5 }
const LID = { w: 22, h: 8, radius: 12 }

const IRIS_MARGIN_Y = 2
const PUPIL_INSET = 3

const AruticEye = ({ ox, oy, dx, dy, scale, irisDx, lidTop, id }: AruticEyeProps) => {
  const x = ox + dx * scale
  const y = oy + dy * scale

  const scleraRx = (EYE.w / 2) * scale
  const scleraRy = (EYE.h / 2) * scale

  const irisCx = x + (irisDx + IRIS.radius) * scale
  const irisCy = y + (IRIS_MARGIN_Y + IRIS.radius) * scale

  return (
    <>
      <Defs>
        <ClipPath id={id}>
          <Ellipse
            cx={x + scleraRx}
            cy={y + scleraRy}
            rx={scleraRx}
            ry={scleraRy}
          />
        </ClipPath>
      </Defs>

      {/* Sclera */}
      <Ellipse
        cx={x + scleraRx}
        cy={y + scleraRy}
        rx={scleraRx}
        ry={scleraRy}
        fill="#F4ECDF"
      />

      {/* Iris + pupil + eyelid, clipped to the sclera */}
      <Circle
        cx={irisCx}
        cy={irisCy}
        r={IRIS.radius * scale}
        fill="url(#aIris)"
        clipPath={`url(#${id})`}
      />
      <Circle
        cx={x + (irisDx + PUPIL_INSET + PUPIL.radius) * scale}
        cy={y + (IRIS_MARGIN_Y + PUPIL_INSET + PUPIL.radius) * scale}
        r={PUPIL.radius * scale}
        fill="#2E2A28"
        clipPath={`url(#${id})`}
      />
      {/* Eyelid cap */}
      <Path
        d={`M ${x} ${y + lidTop * scale}
            h ${LID.w * scale}
            v ${(LID.h - LID.radius) * scale}
            q 0 ${LID.radius * scale} ${-LID.radius * scale} ${LID.radius * scale}
            h ${-(LID.w - 2 * LID.radius) * scale}
            q ${-LID.radius * scale} 0 ${-LID.radius * scale} ${-LID.radius * scale}
            Z`}
        fill="#E0A878"
        clipPath={`url(#${id})`}
      />
    </>
  )
}

export default AruticEye
