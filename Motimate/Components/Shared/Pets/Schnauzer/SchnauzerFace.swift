import SwiftUI

struct SchnauzerFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat

    private static let MOUTH_COLOR = Color(hex: "#4A3F36")
    private static let EYE_COLOR = Color(hex: "#2D2823")
    private static let BEARD = (
        x: CGFloat(32),
        y: CGFloat(88)
    )
    private static let MOUTH_CX: CGFloat = BEARD.x + 116 / 2

    var body: some View {
        ZStack {
            face
        }
    }

    @ViewBuilder
    private var face: some View {
        switch mood {
        case .energetic:
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 42,
                dy: 64,
                w: 32,
                h: 14,
                rotate: -12
            )
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 106,
                dy: 64,
                w: 32,
                h: 14,
                rotate: 12
            )

            SchnauzerEye(
                ox: ox,
                oy: oy,
                dx: 56,
                dy: 72
            )
            SchnauzerEye(
                ox: ox,
                oy: oy,
                dx: 107,
                dy: 72
            )

            Arc(
                ox: ox,
                oy: oy,
                dx: Self.MOUTH_CX - 15,
                dy: Self.BEARD.y + 30,
                d: "q 15 13 30 0",
                color: Self.MOUTH_COLOR
            )

            SVGShape(d: "M \(ox + Self.MOUTH_CX - 7) \(oy + Self.BEARD.y + 36) h 14 v 6 a 7 7 0 0 1 -14 0 Z")
                .fill(Color(hex: "#E78F86"))

        case .calm:
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 42,
                dy: 66,
                w: 32,
                h: 14,
                rotate: -8
            )
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 106,
                dy: 66,
                w: 32,
                h: 14,
                rotate: 8
            )

            Arc(
                ox: ox,
                oy: oy,
                dx: 57,
                dy: 78,
                d: "q 9 -9 18 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 105,
                dy: 78,
                d: "q 9 -9 18 0",
                color: Self.EYE_COLOR
            )

            Arc(
                ox: ox,
                oy: oy,
                dx: Self.MOUTH_CX - 11,
                dy: Self.BEARD.y + 31,
                d: "q 11 10 22 0",
                color: Self.MOUTH_COLOR
            )

        case .tired:
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 42,
                dy: 68,
                w: 32,
                h: 14,
                rotate: -6
            )
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 106,
                dy: 68,
                w: 32,
                h: 14,
                rotate: 6
            )

            Arc(
                ox: ox,
                oy: oy,
                dx: 57,
                dy: 80,
                d: "q 8 5 16 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 105,
                dy: 80,
                d: "q 8 5 16 0",
                color: Self.EYE_COLOR
            )

            Arc(
                ox: ox,
                oy: oy,
                dx: Self.MOUTH_CX - 7,
                dy: Self.BEARD.y + 32,
                d: "q 7 5 14 0",
                color: Self.MOUTH_COLOR
            )

        case .sad:
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 43,
                dy: 72,
                w: 30,
                h: 13,
                rotate: -16
            )
            SchnauzerBrow(
                ox: ox,
                oy: oy,
                dx: 107,
                dy: 72,
                w: 30,
                h: 13,
                rotate: 16
            )

            SchnauzerEye(
                ox: ox,
                oy: oy,
                dx: 56,
                dy: 76
            )
            SchnauzerEye(
                ox: ox,
                oy: oy,
                dx: 107,
                dy: 76
            )

            SVGShape(d: "M \(ox + 62) \(oy + 92) a 4.5 5 0 0 1 9 0 q 0 6 -4.5 8 q -4.5 -2 -4.5 -8 Z")
                .fill(Color(hex: "#A6D2EE").opacity(0.9))
            SVGShape(d: "M \(ox + 109) \(oy + 92) a 4.5 5 0 0 1 9 0 q 0 6 -4.5 8 q -4.5 -2 -4.5 -8 Z")
                .fill(Color(hex: "#A6D2EE").opacity(0.9))

            Arc(
                ox: ox,
                oy: oy,
                dx: Self.MOUTH_CX - 9,
                dy: Self.BEARD.y + 36,
                d: "q 9 -7 18 0",
                color: Self.MOUTH_COLOR
            )
        }
    }
}
