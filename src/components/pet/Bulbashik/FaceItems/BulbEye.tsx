/**
 * BulbEye — Bulbashik's energetic round eye: a cream sclera (26×30) holding a
 * dark iris (17×19) with a small white catchlight. Authored verbatim from
 * `Bulbashik/happy.dc.html` line 62. (Mochi's RoundEye is a single 8×10 ellipse,
 * too small/shapeless to reuse here, so Bulbashik gets its own larger eye.)
 *
 * `(ox, oy)` is the bulb-body origin; `(dx, dy)` is the sclera top-left relative
 * to it, matching the mockup's left/top within the 152×152 bulb.
 */
import React from 'react'
import { G, Ellipse, Circle } from 'react-native-svg'

type BulbEyeProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  // iris horizontal offset inside the sclera (mockup: 6 left / 4 right)
  irisInset: number
}

const SCLERA = { w: 26, h: 30 }
const IRIS = { w: 17, h: 19 }

const BulbEye = ({ ox, oy, dx, dy, irisInset }: BulbEyeProps) => {
  const x = ox + dx
  const y = oy + dy
  const irisCx = x + irisInset + IRIS.w / 2
  const irisCy = y + 7 + IRIS.h / 2

  return (
    <G>
      <Ellipse
        cx={x + SCLERA.w / 2}
        cy={y + SCLERA.h / 2}
        rx={SCLERA.w / 2}
        ry={SCLERA.h / 2}
        fill="#FBF6EC"
      />
      <Ellipse
        cx={irisCx}
        cy={irisCy}
        rx={IRIS.w / 2}
        ry={IRIS.h / 2}
        fill="#5A3A20"
      />
      <Circle
        cx={irisCx + 1.5}
        cy={irisCy - 6}
        r={2.5}
        fill="#fff"
      />
    </G>
  )
}

export default BulbEye
