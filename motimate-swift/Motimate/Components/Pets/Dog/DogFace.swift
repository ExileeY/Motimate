import SwiftUI

struct DogFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat

    private static let EYE_COLOR = Color(hex: "#4A352A")
    private static let PHILTRUM = Color(hex: "#7a5a44")

    private static let SNOUT = (
        cx: CGFloat(90),
        top: CGFloat(100),
        w: CGFloat(74),
        h: CGFloat(56)
    )
    private static var NOSE_TOP: CGFloat { SNOUT.top + 6 }

    var body: some View {
        ZStack {
            shared
            face
        }
    }

    // MARK: - Shared (all moods)

    private var shared: some View {
        let S = Self.SNOUT
        return ZStack {
            // Snout patch
            Ellipse()
                .fill(radialGradient([
                    GStop("#F9ECD2", 0),
                    GStop("#EEDAB2", 1),
                ], cx: 0.5, cy: 0.35, r: 0.6, side: S.w))
                .frame(width: S.w, height: S.h)
                .position(x: ox + S.cx, y: oy + S.top + S.h / 2)

            // Nose
            Ellipse()
                .fill(Color(hex: "#4A352A"))
                .frame(width: 24, height: 16)
                .position(x: ox + S.cx, y: oy + Self.NOSE_TOP + 8)
        }
    }

    // MARK: - Per-mood

    @ViewBuilder
    private var face: some View {
        let S = Self.SNOUT
        switch mood {
        case .energetic:
            DogEye(
                ox: ox,
                oy: oy,
                dx: 56,
                dy: 72
            )
            DogEye(
                ox: ox,
                oy: oy,
                dx: 108,
                dy: 72
            )

            philtrum(height: 9)

            // Smile
            Arc(
                ox: ox,
                oy: oy,
                dx: S.cx - 15,
                dy: S.top + 27,
                d: "q 15 12 30 0",
                color: Self.PHILTRUM
            )

            // Tongue
            SVGShape(d: "M \(ox + S.cx - 6.5) \(oy + S.top + 33) h 13 v 7 a 6.5 7 0 0 1 -13 0 Z")
                .fill(Color(hex: "#F2938B"))

        case .calm:
            // Eyes
            Arc(
                ox: ox,
                oy: oy,
                dx: 57,
                dy: 74,
                d: "q 9 -9 18 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 105,
                dy: 74,
                d: "q 9 -9 18 0",
                color: Self.EYE_COLOR
            )

            philtrum(height: 9)

            // Smile
            Arc(
                ox: ox,
                oy: oy,
                dx: S.cx - 11,
                dy: S.top + 27,
                d: "q 11 10 22 0",
                color: Self.PHILTRUM
            )

        case .tired:
            // Eyes
            Arc(
                ox: ox,
                oy: oy,
                dx: 57,
                dy: 76,
                d: "q 8 5 16 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 107,
                dy: 76,
                d: "q 8 5 16 0",
                color: Self.EYE_COLOR
            )

            philtrum(height: 8)

            // Mouth
            Arc(
                ox: ox,
                oy: oy,
                dx: S.cx - 7,
                dy: S.top + 26,
                d: "q 7 5 14 0",
                color: Self.PHILTRUM
            )

        case .sad:
            Arc(
                ox: ox,
                oy: oy,
                dx: 56,
                dy: 72,
                d: "q 9 9 18 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 106,
                dy: 72,
                d: "q 9 9 18 0",
                color: Self.EYE_COLOR
            )

            philtrum(height: 8)

            // Frown
            Arc(
                ox: ox,
                oy: oy,
                dx: S.cx - 9,
                dy: S.top + 30,
                d: "q 9 -7 18 0",
                color: Self.PHILTRUM
            )
        }
    }

    private func philtrum(height: CGFloat) -> some View {
        let S = Self.SNOUT
        return RoundedRectangle(cornerRadius: 1)
            .fill(Self.PHILTRUM)
            .frame(width: 2, height: height)
            .position(x: ox + S.cx, y: oy + S.top + 21 + height / 2)
    }
}
