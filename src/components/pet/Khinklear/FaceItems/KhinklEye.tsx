
import React from 'react'
import {
  G,
  Ellipse,
  Circle
} from 'react-native-svg'

type KhinklEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  scale: number
}

const EYE = { w: 15, h: 19 }
const HIGHLIGHT = { inset: 3, r: 3 }

const KhinklEye = ({ ox, oy, dx, dy, scale }: KhinklEyeProps) => {
  const x = ox + dx * scale
  const y = oy + dy * scale
  const cx = x + (EYE.w / 2) * scale
  const cy = y + (EYE.h / 2) * scale

  return (
    <G>
      <Ellipse
        cx={cx}
        cy={cy}
        rx={(EYE.w / 2) * scale}
        ry={(EYE.h / 2) * scale}
        fill="#4A352A"
      />
      <Circle
        cx={x + (HIGHLIGHT.inset + HIGHLIGHT.r) * scale}
        cy={y + (HIGHLIGHT.inset + HIGHLIGHT.r) * scale}
        r={HIGHLIGHT.r * scale}
        fill="#fff"
      />
    </G>
  )
}

export default KhinklEye
