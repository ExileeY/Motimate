import CoreGraphics

let RESPONSIVE_BASE_HEIGHT: CGFloat = 812
let RESPONSIVE_MIN_SCALE: CGFloat = 0.85
let RESPONSIVE_MAX_SCALE: CGFloat = 1.15

func computeScale(_ height: CGFloat) -> CGFloat {
    MathUtils.clamp(
        height / RESPONSIVE_BASE_HEIGHT,
        min: RESPONSIVE_MIN_SCALE,
        max: RESPONSIVE_MAX_SCALE
    )
}
