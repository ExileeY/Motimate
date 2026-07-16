import SwiftUI

struct MochiBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let HEAD = (x: (SIZE - 148) / 2, y: CGFloat(26), w: CGFloat(148), h: CGFloat(140))

    var body: some View {
        let S = Self.SIZE
        let H = Self.HEAD

        ZStack {
            // Tail
            Ellipse()
                .fill(verticalLinearGradient([
                    GStop("#E29460", 0),
                    GStop("#DE8E5B", 0.6),
                    GStop("#C0703F", 1),
                ]))
                .frame(width: 54, height: 24)
                .rotationEffect(.degrees(28))
                .position(x: 145, y: 138)

            ear(
                outerX: 36,
                innerX: 48,
                rotation: -15,
                pivot: CGPoint(x: 56, y: 30)
            )
            ear(
                outerX: 104,
                innerX: 116,
                rotation: 15,
                pivot: CGPoint(x: 124, y: 30)
            )

            head

            // Muzzle highlight
            Ellipse()
                .fill(radialGradient([
                    GStop("#FFEAD2", 0, 0.85),
                    GStop("#FFEAD2", 0.7, 0),
                ], cx: 0.5, cy: 0.4, r: 0.5, side: 78))
                .frame(width: 78, height: 62)
                .position(x: H.x + H.w / 2, y: H.y + H.h - 14 - 31)

            MochiFace(
                mood: mood,
                ox: H.x,
                oy: H.y
            )

            foot(cx: 69)
            foot(cx: 111)
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Head

    private var head: some View {
        let H = Self.HEAD
        let path = Self.headPath()
        return ZStack {
            // Base radial
            path.fill(radialGradient([
                GStop("#F3BC92", 0),
                GStop("#E2935F", 0.68),
                GStop("#D27F4C", 1),
            ], cx: 0.5, cy: 0.22, r: 1.15, side: H.w))

            // Bottom core-shadow
            path.fill(radialGradient([
                GStop("#A55C32", 0.55, 0),
                GStop("#A55C32", 1, 0.32),
            ], cx: 0.5, cy: 1, r: 0.62, side: H.w))

            // Top rim highlight
            path.fill(radialGradient([
                GStop("#FFE0C4", 0, 0.6),
                GStop("#FFE0C4", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.48, side: H.w))
        }
    }

    // MARK: - Ears

    private func ear(outerX: CGFloat, innerX: CGFloat, rotation: Double, pivot: CGPoint) -> some View {
        ZStack {
            // Outer ear
            roundedBoxPath(outerX, 4, 40, 52, [
                (0.62, 0.8),
                (0.62, 0.8),
                (0.38, 0.26),
                (0.38, 0.26),
            ])
            .fill(radialGradient([
                GStop("#E89A6C", 0),
                GStop("#DB8753", 1),
            ], cx: 0.5, cy: 0.7, r: 0.8, side: 40))

            // Inner ear
            roundedBoxPath(innerX, 28, 16, 24, [
                (0.6, 0.75),
                (0.6, 0.75),
                (0.4, 0.25),
                (0.4, 0.25),
            ])
            .fill(Color(hex: "#EFA9A0").opacity(0.8))
        }
        .rotationEffect(.degrees(rotation), anchor: anchor(pivot))
    }

    // MARK: - Feet

    private func foot(cx: CGFloat) -> some View {
        Ellipse()
            .fill(verticalLinearGradient([
                GStop("#F6C8A6", 0),
                GStop("#E89A6C", 0.55),
                GStop("#E2935F", 1),
            ]))
            .frame(width: 30, height: 18)
            .position(x: cx, y: 165)
    }

    // MARK: - Geometry

    private static func headPath() -> Path {
        roundedBoxPath(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
            (0.5, 0.54),
            (0.5, 0.54),
            (0.47, 0.46),
            (0.47, 0.46),
        ])
    }

    /// Convert an SVG rotation pivot (canvas point) into the `UnitPoint` anchor
    /// `.rotationEffect` expects (fraction of the 180 canvas).
    private func anchor(_ p: CGPoint) -> UnitPoint {
        UnitPoint(
            x: p.x / Self.SIZE,
            y: p.y / Self.SIZE
        )
    }
}

#if DEBUG
#Preview("Mochi — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        MochiBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#F6C49A"))
}
#endif
