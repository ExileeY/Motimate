import SwiftUI

struct SchnauzerBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let HEAD = (
        x: (SIZE - 152) / 2,
        y: CGFloat(24),
        w: CGFloat(152),
        h: CGFloat(144)
    )
    private static let EAR = (
        w: CGFloat(50),
        h: CGFloat(54)
    )
    private static let BEARD = (
        x: HEAD.x + (HEAD.w - 116) / 2,
        y: HEAD.y + 64,
        w: CGFloat(116),
        h: CGFloat(86)
    )

    var body: some View {
        let S = Self.SIZE

        ZStack {
            tail
            ears
            head
            beard
            SchnauzerFace(mood: mood, ox: 0, oy: 0)
            paws
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Tail

    private var tail: some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#8E8A81", 0),
                    GStop("#736F68", 1),
                ], cx: 0.38, cy: 0.3, r: 0.6, side: 44))
                .frame(width: 44, height: 21)

            Ellipse()
                .fill(radialGradient([
                    GStop("#464038", 0.5, 0),
                    GStop("#464038", 1, 0.3),
                ], cx: 0.5, cy: 1, r: 0.65, side: 44))
                .frame(width: 44, height: 21)
        }
        .rotationEffect(.degrees(-6))
        .position(x: 156, y: 131.5)
    }

    // MARK: - Ears

    private var ears: some View {
        ZStack {
            rotatedPath(
                Self.earPath(x: 20, y: 20),
                degrees: -3,
                about: CGPoint(x: 45, y: 47)
            )
            .fill(linearGradient([
                GStop("#605C54", 0),
                GStop("#45423B", 1),
            ], x1: 0, y1: 0, x2: 0.8, y2: 1))

            rotatedPath(
                Self.earPath(x: 110, y: 20),
                degrees: 3,
                about: CGPoint(x: 135, y: 47)
            )
            .fill(linearGradient([
                GStop("#605C54", 0),
                GStop("#45423B", 1),
            ], x1: 1, y1: 0, x2: 0.2, y2: 1))
        }
    }

    // MARK: - Head

    private var head: some View {
        let H = Self.HEAD
        let path = Self.headPath()

        return ZStack {
            path.fill(radialGradient([
                GStop("#ABA79F", 0),
                GStop("#807C76", 0.64),
                GStop("#605B54", 1),
            ], cx: 0.5, cy: 0.2, r: 1.15, side: H.w))

            path.fill(radialGradient([
                GStop("#322E28", 0.55, 0),
                GStop("#322E28", 1, 0.3),
            ], cx: 0.5, cy: 1, r: 0.6, side: H.w))

            path.fill(radialGradient([
                GStop("#E6E2DA", 0, 0.4),
                GStop("#E6E2DA", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.44, side: H.w))

            Self.capPath()
                .fill(verticalLinearGradient([
                    GStop("#3f3c36", 0, 0.26),
                    GStop("#3f3c36", 1, 0),
                ]))
        }
    }

    // MARK: - Beard

    private var beard: some View {
        let B = Self.BEARD
        let path = Self.beardPath()

        return ZStack {
            path.fill(radialGradient([
                GStop("#E8E3DA", 0),
                GStop("#CCC7BD", 0.7),
                GStop("#BBB6AC", 1),
            ], cx: 0.5, cy: 0.22, r: 0.7, side: B.w))

            path.fill(radialGradient([
                GStop("#FFFFFF", 0, 0.45),
                GStop("#FFFFFF", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.44, side: B.w))

            path.fill(radialGradient([
                GStop("#969086", 0.5, 0),
                GStop("#969086", 1, 0.4),
            ], cx: 0.5, cy: 1, r: 0.55, side: B.w))

            RoundedRectangle(cornerRadius: 1)
                .fill(Color(red: 160 / 255, green: 154 / 255, blue: 144 / 255).opacity(0.5))
                .frame(width: 2, height: 50)
                .position(x: B.x + B.w / 2, y: B.y + 26 + 25)

            beardStripe(
                x: B.x + 30,
                y: B.y + 34,
                rotate: 10
            )

            beardStripe(
                x: B.x + B.w - 32,
                y: B.y + 34,
                rotate: -10
            )

            Ellipse()
                .fill(radialGradient([
                    GStop("#3c372f", 0),
                    GStop("#231e1a", 1),
                ], cx: 0.4, cy: 0.28, r: 0.5, side: 28))
                .frame(width: 28, height: 18)
                .position(
                    x: B.x + B.w / 2,
                    y: B.y + 15
                )
        }
    }

    private func beardStripe(x: CGFloat, y: CGFloat, rotate: Double) -> some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(Color(red: 160 / 255, green: 154 / 255, blue: 144 / 255).opacity(0.4))
            .frame(width: 2, height: 34)
            .rotationEffect(.degrees(rotate))
            .position(x: x + 1, y: y + 17)
    }

    // MARK: - Paws

    private var paws: some View {
        ZStack {
            paw(cx: 68)
            paw(cx: 112)
        }
    }

    private func paw(cx: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#D8D3CA", 0),
                    GStop("#C2BDB3", 1),
                ], cx: 0.5, cy: 0.3, r: 0.6, side: 32))
                .frame(width: 32, height: 19)

            Ellipse()
                .fill(radialGradient([
                    GStop("#FFFFFF", 0, 0.5),
                    GStop("#FFFFFF", 1, 0),
                ], cx: 0.5, cy: 0, r: 0.6, side: 32))
                .frame(width: 32, height: 19)
        }
        .position(x: cx, y: 166.5)
    }

    // MARK: - Geometry

    private static func headPath() -> Path {
        let H = HEAD
        return roundedBoxPath(H.x, H.y, H.w, H.h, [
            (0.5, 0.54),
            (0.5, 0.54),
            (0.47, 0.46),
            (0.47, 0.46),
        ])
    }

    private static func capPath() -> Path {
        let H = HEAD
        return roundedBoxPath(H.x, H.y, H.w, 62, [
            (0.5, 0.5),
            (0.5, 0.5),
            (0.4, 0.4),
            (0.4, 0.4),
        ])
    }

    private static func earPath(x: CGFloat, y: CGFloat) -> Path {
        roundedBoxPath(x, y, EAR.w, EAR.h, [
            (0.32, 0.18),
            (0.32, 0.18),
            (0.5, 0.7),
            (0.5, 0.7),
        ])
    }

    private static func beardPath() -> Path {
        let B = BEARD
        return roundedBoxPath(B.x, B.y, B.w, B.h, [
            (0.42, 0.26),
            (0.42, 0.26),
            (0.46, 0.74),
            (0.46, 0.74),
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
#Preview("Schnauzer — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        SchnauzerBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#D8D3CA"))
}
#endif
