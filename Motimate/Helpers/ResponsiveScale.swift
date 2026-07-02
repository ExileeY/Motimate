import CoreGraphics

let RESPONSIVE_BASE_HEIGHT: CGFloat = 812
let RESPONSIVE_MIN_SCALE: CGFloat = 0.85
let RESPONSIVE_MAX_SCALE: CGFloat = 1.15

func computeScale(_ height: CGFloat) -> CGFloat {
    min(RESPONSIVE_MAX_SCALE, max(RESPONSIVE_MIN_SCALE, height / RESPONSIVE_BASE_HEIGHT))
}
