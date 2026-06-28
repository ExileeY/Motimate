import React from 'react'
import { G, Path } from 'react-native-svg'
import { roundedBoxPath } from '@/components/pet/svgPath'

type SchnauzerBrowProps = {
  ox: number
  oy: number
  dx: number
  dy: number
  w: number
  h: number
  rotate: number // degrees, about the brow center
}

const SchnauzerBrow = ({ ox, oy, dx, dy, w, h, rotate }: SchnauzerBrowProps) => {
  const x = ox + dx
  const y = oy + dy
  const cx = x + w / 2
  const cy = y + h / 2

  return (
    <G transform={`rotate(${rotate} ${cx} ${cy})`}>
      <Path
        d={roundedBoxPath(x, y, w, h, [
          [0.62, 0.62],
          [0.62, 0.62],
          [0.5, 0.5],
          [0.5, 0.5],
        ])}
        fill="url(#sBrow)"
      />
    </G>
  )
}

export default SchnauzerBrow
