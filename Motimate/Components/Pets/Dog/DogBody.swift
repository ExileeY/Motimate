import SwiftUI

struct DogBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let HEAD = (
        x: (SIZE - 148) / 2,
        y: CGFloat(26),
        w: CGFloat(148),
        h: CGFloat(140)
    )
    private static let EAR = (
        w: CGFloat(34),
        h: CGFloat(66)
    )

    var body: some View {
        let S = Self.SIZE

        ZStack {
            tail
            ears
            head
            DogFace(mood: mood, ox: 0, oy: 0)
            feet
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Tail

    private var tail: some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#E2A856", 0),
                    GStop("#DDA152", 1),
                ], cx: 0.5, cy: 0.35, r: 0.75, side: 50))
                .frame(width: 50, height: 22)

            Ellipse()
                .fill(radialGradient([
                    GStop("#AA6E28", 0.5, 0),
                    GStop("#AA6E28", 1, 0.25),
                ], cx: 0.5, cy: 1, r: 0.65, side: 50))
                .frame(width: 50, height: 22)
        }
        .rotationEffect(.degrees(-6))
        .position(x: 149, y: 133)
    }

    // MARK: - Ears

    private var ears: some View {
        ZStack {
            // Left ear
            rotatedPath(
                Self.earPath(x: 6, y: 54),
                degrees: -22,
                about: CGPoint(x: 23, y: 87)
            )
            .fill(radialGradient([
                GStop("#DCA456", 0),
                GStop("#C9913F", 1),
            ], cx: 0.5, cy: 0.30, r: 0.7, side: Self.EAR.w))

            // Right ear
            rotatedPath(
                Self.earPath(x: 140, y: 54),
                degrees: 22,
                about: CGPoint(x: 157, y: 87)
            )
            .fill(radialGradient([
                GStop("#DCA456", 0),
                GStop("#C9913F", 1),
            ], cx: 0.5, cy: 0.30, r: 0.7, side: Self.EAR.w))
        }
    }

    // MARK: - Head

    private var head: some View {
        let H = Self.HEAD
        let path = Self.headPath()
        return ZStack {
            // Base radial
            path.fill(radialGradient([
                GStop("#F2CB8C", 0),
                GStop("#E0A95C", 0.68),
                GStop("#CD9444", 1),
            ], cx: 0.5, cy: 0.22, r: 1.15, side: H.w))

            // Bottom core shade
            path.fill(radialGradient([
                GStop("#965F1E", 0.55, 0),
                GStop("#965F1E", 1, 0.28),
            ], cx: 0.5, cy: 1, r: 0.6, side: H.w))

            // Top rim highlight
            path.fill(radialGradient([
                GStop("#FFE8C4", 0, 0.55),
                GStop("#FFE8C4", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.44, side: H.w))
        }
    }

    // MARK: - Feet

    private var feet: some View {
        ZStack {
            foot(cx: 69)
            foot(cx: 111)
        }
    }

    private func foot(cx: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#E6B468", 0),
                    GStop("#DCA452", 1),
                ], cx: 0.5, cy: 0.6, r: 0.7, side: 30))
                .frame(width: 30, height: 18)

            Ellipse()
                .fill(radialGradient([
                    GStop("#FFE8C4", 0, 0.5),
                    GStop("#FFE8C4", 1, 0),
                ], cx: 0.5, cy: 0, r: 0.6, side: 30))
                .frame(width: 30, height: 18)
        }
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

    private static func earPath(x: CGFloat, y: CGFloat) -> Path {
        roundedBoxPath(x, y, EAR.w, EAR.h, [
            (0.48, 0.26),
            (0.48, 0.26),
            (0.5, 0.74),
            (0.5, 0.74),
        ])
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}

#if DEBUG
#Preview("Dog — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        DogBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#F1D9A8"))
}
#endif
