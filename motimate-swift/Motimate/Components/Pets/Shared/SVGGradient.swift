import SwiftUI

/// IMPORTANT (per-shape framing): a native gradient resolves `UnitPoint` /
/// `endRadius` against **the frame the shape is drawn in**, whereas SVG resolves
/// them against the *shape's own bounding box*. So a gradient-filled shape must
/// be drawn in a frame sized to that shape (see `MochiBody`, where small shapes
/// like ears/muzzle get their own `.frame(...).position(...)`), not the full
/// pet canvas — otherwise `cx=50%` lands at the canvas center, not the shape's.

/// One gradient stop as authored in the RN source: color, `offset` (0…1), and
/// the SVG `stopOpacity` (default 1) folded in.
struct GStop {
    let color: Color
    let offset: CGFloat
    var opacity: CGFloat = 1

    init(_ hex: String, _ offset: CGFloat, _ opacity: CGFloat = 1) {
        self.color = Color(hex: hex)
        self.offset = offset
        self.opacity = opacity
    }
}

private func gradient(_ stops: [GStop]) -> Gradient {
    Gradient(stops: stops.map {
        Gradient.Stop(color: $0.color.opacity($0.opacity), location: $0.offset)
    })
}

/// Port of an SVG `<RadialGradient cx cy r>` filling a shape whose bounding box
/// is `side × side`. `cx/cy/r` are fractions (SVG percents ÷ 100).
func radialGradient(
    _ stops: [GStop],
    cx: CGFloat,
    cy: CGFloat,
    r: CGFloat,
    side: CGFloat
) -> RadialGradient {
    RadialGradient(
        gradient: gradient(stops),
        center: UnitPoint(x: cx, y: cy),
        startRadius: 0,
        endRadius: r * side
    )
}

/// Port of a top→bottom SVG `<LinearGradient x1=0 y1=0 x2=0 y2=1>` (the only
/// linear direction the pets use — vertical). Maps straight to `.top`→`.bottom`.
func verticalLinearGradient(_ stops: [GStop]) -> LinearGradient {
    LinearGradient(
        gradient: gradient(stops),
        startPoint: .top,
        endPoint: .bottom
    )
}
