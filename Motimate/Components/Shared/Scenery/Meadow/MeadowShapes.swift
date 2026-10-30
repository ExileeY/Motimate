import SwiftUI

// MARK: - Shapes (fractions of rect)

struct MeadowMountain: Shape {
    var baseShift: CGFloat = 0
    var peakShift: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let basePoints: [(CGFloat, CGFloat)] = FractionalPath.shifted([
            (1, 0.66),
            (0, 0.66)
        ], dy: baseShift)
        let ridgePoints: [(CGFloat, CGFloat)] = FractionalPath.shifted([
            (0, 0.56),
            (0.12, 0.50),
            (0.30, 0.36),
            (0.46, 0.49),
            (0.56, 0.46),
            (0.74, 0.40),
            (0.92, 0.52),
            (1, 0.55)
        ], dy: peakShift)

        return FractionalPath.polygon(rect, ridgePoints + basePoints)
    }
}

/// Caps sit exactly on the ridge lines of `MeadowMountain`'s two peaks.
struct MeadowSnowCaps: Shape {
    var yShift: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let snowCapPoints1: [(CGFloat, CGFloat)] = FractionalPath.shifted([
            (0.26, 0.391),
            (0.30, 0.36),
            (0.34, 0.3925),
            (0.32, 0.385),
            (0.30, 0.398),
            (0.28, 0.385)
        ], dy: yShift)
        let snowCapPoints2: [(CGFloat, CGFloat)] = FractionalPath.shifted([
            (0.70, 0.413),
            (0.74, 0.40),
            (0.78, 0.427),
            (0.76, 0.42),
            (0.745, 0.43),
            (0.72, 0.418)
        ], dy: yShift)

        var path = FractionalPath.polygon(rect, snowCapPoints1)
        path.addPath(FractionalPath.polygon(rect, snowCapPoints2))
        return path
    }
}

/// A rolling hill from `startY` (left edge) to `endY` (right edge), filled to the
/// bottom. `peakRise` raises the left bulge, `valleyDepth` lowers the right hollow.
struct MeadowHill: Shape {
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
