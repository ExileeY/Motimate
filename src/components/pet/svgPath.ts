/**
 * SVG path geometry shared by the hand-authored pet characters.
 *
 * The mockups build shapes from CSS `border-radius` (per-corner elliptical
 * radii), which `react-native-svg` has no direct equivalent for. These helpers
 * reconstruct that shape as an explicit path, so any character (not just Mochi)
 * can render a mockup-accurate rounded box. Pure string math — no React/SVG
 * component dependencies.
 */

// Standard constant for approximating a quarter-ellipse arc with a cubic Bézier:
// it places each control point this fraction of the way from the arc's endpoint
// toward the corner pivot. See https://spencermortensen.com/articles/bezier-circle/
const K = 0.5523

/**
 * One corner of the box as a cubic Bézier (`C ...`) command: a quarter-ellipse
 * sweeping from `from` to `to`, bulging toward the rectangle's `pivot` corner.
 * Each control point sits K of the way from an endpoint toward the pivot.
 */
type Point = { x: number; y: number }
const corner = (from: Point, pivot: Point, to: Point) => {
  const c1x = from.x + (pivot.x - from.x) * K
  const c1y = from.y + (pivot.y - from.y) * K
  const c2x = to.x + (pivot.x - to.x) * K
  const c2y = to.y + (pivot.y - to.y) * K
  return `C ${c1x} ${c1y} ${c2x} ${c2y} ${to.x} ${to.y}`
}

/**
 * A rounded-box outline whose four corners are independent elliptical arcs —
 * the SVG equivalent of CSS `border-radius: TLx TRx BRx BLx / TLy TRy BRy BLy`
 * expressed as fractions of w/h. A character's head and (pointy) ears are
 * exactly this shape in the mockup; rendering them as plain ellipses loses the
 * cat-ear point and the head's flatter chin, which read as "cheap".
 *
 * The perimeter is walked clockwise from the top-left corner's left edge:
 *   M → corner(TL) → L(top) → corner(TR) → L(right) → corner(BR) → L(bottom)
 *   → corner(BL) → Z
 */
export const roundedBoxPath = (
  x: number,
  y: number,
  w: number,
  h: number,
  // [topLeft, topRight, bottomRight, bottomLeft] as [rxFrac, ryFrac]
  corners: [number, number][],
) => {
  const [tl, tr, br, bl] = corners
  const l = x
  const r = x + w
  const t = y
  const b = y + h
  // Per-corner radii in absolute units (fraction × box width/height).
  const tlx = tl[0] * w, tly = tl[1] * h
  const trx = tr[0] * w, trh = tr[1] * h
  const brx = br[0] * w, brh = br[1] * h
  const blx = bl[0] * w, blh = bl[1] * h
  return [
    `M ${l} ${t + tly}`,
    corner({ x: l, y: t + tly }, { x: l, y: t }, { x: l + tlx, y: t }),
    `L ${r - trx} ${t}`,
    corner({ x: r - trx, y: t }, { x: r, y: t }, { x: r, y: t + trh }),
    `L ${r} ${b - brh}`,
    corner({ x: r, y: b - brh }, { x: r, y: b }, { x: r - brx, y: b }),
    `L ${l + blx} ${b}`,
    corner({ x: l + blx, y: b }, { x: l, y: b }, { x: l, y: b - blh }),
    `Z`,
  ].join(' ')
}
