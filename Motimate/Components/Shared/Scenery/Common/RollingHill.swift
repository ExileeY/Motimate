import SwiftUI

/// A rolling hill from `startY` (left edge) to `endY` (right edge), filled to the
/// bottom. `peakRise` raises the left bulge, `valleyDepth` lowers the right hollow.
struct RollingHill: Shape {
    let startY: CGFloat
    let endY: CGFloat
    let peakRise: CGFloat
    let valleyDepth: CGFloat

    func path(in rect: CGRect) -> Path {
        let point = FractionalPath.point

        var path = Path()
        path.move(to: point(rect, 0, startY))
        path.addCurve(
            to: point(rect, 1, endY),
            control1: point(rect, 0.3, startY - peakRise),
            control2: point(rect, 0.65, endY + valleyDepth)
        )
        path.addLine(to: point(rect, 1, 1))
        path.addLine(to: point(rect, 0, 1))
        path.closeSubpath()
        return path
    }
}
