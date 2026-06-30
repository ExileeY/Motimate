/**
 * useResponsiveScale — one clamped scale factor driven by screen height.
 *
 * The home screen is a vertical column authored against an iPhone X/14-class
 * reference (812pt tall). Height is the real pressure point: the column overflows
 * top-to-bottom on short phones and floats lost on tall ones. We derive a single
 * factor from `useWindowDimensions().height`, clamped so the pet/type never get
 * absurdly small or large, and feed it through the pet sizing + heading caps.
 *
 * At the reference height the factor is ~1, so the design is unchanged there.
 */
import { useWindowDimensions } from 'react-native'

const BASE_HEIGHT = 812
const MIN = 0.85
const MAX = 1.15

export const computeScale = (height: number) =>
  Math.min(MAX, Math.max(MIN, height / BASE_HEIGHT))

export const useResponsiveScale = () => computeScale(useWindowDimensions().height)
