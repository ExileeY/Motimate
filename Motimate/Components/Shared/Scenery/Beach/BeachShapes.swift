import SwiftUI

/// Where the Beach's sea and sand sit, in fractions of the scene's height.
enum BeachGeometry {
    static let horizonY: CGFloat = 0.40
    static let shorelineY: CGFloat = 0.566 // where the dry sand crosses the scene's center
    static let sandFadeDepth: CGFloat = 0.14 // from the shoreline to the pale ground

    private static let wetRise: CGFloat = 0.012
    private static let foamRise: CGFloat = 0.02

    static func sea(shift: CGFloat) -> RollingHill {
        RollingHill(startY: horizonY + shift, endY: horizonY + shift, peakRise: 0, valleyDepth: 0)
    }

    static func drySand(shift: CGFloat) -> RollingHill {
        shore(rise: 0, shift: shift)
    }

    static func wetSand(shift: CGFloat) -> RollingHill {
        shore(rise: wetRise, shift: shift)
    }

    static func foam(shift: CGFloat, lap: CGFloat) -> RollingHill {
        shore(rise: foamRise + lap, shift: shift)
    }

    private static func shore(rise: CGFloat, shift: CGFloat) -> RollingHill {
        RollingHill(
            startY: 0.555 - rise + shift,
            endY: 0.585 - rise + shift,
            peakRise: 0.03,
            valleyDepth: 0.02
        )
    }
}

// MARK: - Palm shapes (fractions of the palm's own box)

enum BeachPalmGeometry {
    static let crown = UnitPoint(x: 0.52, y: 0.18)
    static let baseX: CGFloat = 0.305 // center of the trunk's foot
    static let aspect: CGFloat = 0.8 // box width / height
    static let coconuts: [UnitPoint] = [
        UnitPoint(x: 0.47, y: 0.21),
        UnitPoint(x: 0.54, y: 0.225),
        UnitPoint(x: 0.58, y: 0.2),
    ]
}

struct BeachPalmTrunk: Shape {
    func path(in rect: CGRect) -> Path {
        let point = FractionalPath.point

        var path = Path()
        path.move(to: point(rect, 0.25, 1))
        path.addCurve(
            to: point(rect, 0.5, 0.18),
            control1: point(rect, 0.3, 0.65),
            control2: point(rect, 0.38, 0.35)
        )
        path.addLine(to: point(rect, 0.55, 0.19))
        path.addCurve(
            to: point(rect, 0.36, 1),
            control1: point(rect, 0.45, 0.38),
            control2: point(rect, 0.4, 0.68)
        )
        path.addQuadCurve(
            to: point(rect, 0.25, 1),
            control: point(rect, 0.305, 1.03)
        )
        path.closeSubpath()
        return path
    }
}

/// Crescents arching from the crown out to each tip.
struct BeachPalmFronds: Shape {
    struct Tip {
        let x: CGFloat
        let y: CGFloat
        let arch: CGFloat // how far the frond bows above its chord
    }

    static let back: [Tip] = [
        Tip(x: 0.08, y: 0.1, arch: 0.1),
        Tip(x: 0.92, y: 0.08, arch: 0.1),
        Tip(x: 0.14, y: 0.42, arch: 0.16),
        Tip(x: 0.88, y: 0.42, arch: 0.16),
    ]
    static let front: [Tip] = [
        Tip(x: 0, y: 0.28, arch: 0.14),
        Tip(x: 1, y: 0.26, arch: 0.14),
        Tip(x: 0.26, y: 0.52, arch: 0.18),
        Tip(x: 0.8, y: 0.52, arch: 0.18),
        Tip(x: 0.28, y: 0.02, arch: 0.08),
        Tip(x: 0.74, y: 0.01, arch: 0.08),
    ]

    private static let innerArchRatio: CGFloat = 0.5

    let tips: [Tip]

    func path(in rect: CGRect) -> Path {
        let point = FractionalPath.point
        let crown = BeachPalmGeometry.crown
        let start = point(rect, crown.x, crown.y)

        var path = Path()
        for tip in tips {
            let midX = (crown.x + tip.x) / 2
            let midY = (crown.y + tip.y) / 2

            path.move(to: start)
            path.addQuadCurve(
                to: point(rect, tip.x, tip.y),
                control: point(rect, midX, midY - tip.arch)
            )
            path.addQuadCurve(
                to: start,
                control: point(rect, midX, midY - tip.arch * Self.innerArchRatio)
            )
            path.closeSubpath()
        }
        return path
    }
}
