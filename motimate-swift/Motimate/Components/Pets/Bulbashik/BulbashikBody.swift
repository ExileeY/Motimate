import SwiftUI

struct BulbashikBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    static let SIZE: CGFloat = 180

    private static let BULB = (
        x: (SIZE - 136.8) / 2,
        y: CGFloat(32.4),
        w: CGFloat(136.8),
        h: CGFloat(136.8)
    )
    private static let POT = (
        x: CGFloat(12.6),
        y: CGFloat(126.0),
        w: CGFloat(158.4),
        h: CGFloat(55.8)
    )

    var body: some View {
        let S = Self.SIZE

        ZStack {
            sprout
            arms
            bulb
            face
            pot
            seamStripe
            potRim
            seed
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Sprout (stem, leaves + veins, bud)

    private var sprout: some View {
        let S = Self.SIZE
        return ZStack {
            // Stem
            roundedBoxPath((S - 4.5) / 2, 21.6, 4.5, 30.6, [
                (0.5, 0.09),
                (0.5, 0.09),
                (0.5, 0.09),
                (0.5, 0.09),
            ])
            .fill(verticalLinearGradient([
                GStop("#84AC50", 0),
                GStop("#5F8233", 1),
            ]))

            // Left leaf
            rotatedPath(
                roundedBoxPath(54.0, 3.6, 32.4, 23.4, [
                    (0.62, 0.62),
                    (0.08, 0.08),
                    (0.62, 0.62),
                    (0.08, 0.08),
                ]),
                degrees: -26, about: CGPoint(x: 70.2, y: 15.3)
            )
            .fill(radialGradient([
                GStop("#93C95B", 0),
                GStop("#5E9233", 1),
            ], cx: 0.32, cy: 0.30, r: 0.8, side: 32.4))

            vein("M 61.2 11.7 q 9.9 -3.15 19.8 0", degrees: -26, about: CGPoint(x: 70.2, y: 15.3))

            // Right leaf
            rotatedPath(
                roundedBoxPath(93.6, 3.6, 32.4, 23.4, [
                    (0.08, 0.08),
                    (0.62, 0.62),
                    (0.08, 0.08),
                    (0.62, 0.62),
                ]),
                degrees: 26, about: CGPoint(x: 109.8, y: 15.3)
            )
            .fill(radialGradient([
                GStop("#93C95B", 0),
                GStop("#5E9233", 1),
            ], cx: 0.68, cy: 0.30, r: 0.8, side: 32.4))

            vein("M 99.0 11.7 q 9.9 -3.15 19.8 0", degrees: 26, about: CGPoint(x: 109.8, y: 15.3))

            // Top bud
            roundedBoxPath((S - 15.3) / 2, -3.6, 15.3, 18.0, [
                (0.6, 0.6),
                (0.6, 0.6),
                (0.5, 0.5),
                (0.5, 0.5),
            ])
            .fill(radialGradient([
                GStop("#ACD972", 0),
                GStop("#6FA23E", 1),
            ], cx: 0.5, cy: 0.28, r: 0.6, side: 15.3))
        }
    }

    private func vein(_ d: String, degrees: Double, about pivot: CGPoint) -> some View {
        rotatedPath(svgPath(d), degrees: degrees, about: pivot)
            .stroke(
                Color(red: 40 / 255, green: 80 / 255, blue: 25 / 255).opacity(0.4),
                style: StrokeStyle(lineWidth: 1.8, lineCap: .round)
            )
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }

    // MARK: - Side arms

    private var arms: some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#DDC084", 0),
                    GStop("#C29E62", 1),
                ], cx: 0.4, cy: 0.3, r: 0.7, side: 27))
                .frame(width: 27, height: 30.6)
                .rotationEffect(.degrees(18))
                .position(x: 27.9, y: 130.5)

            Ellipse()
                .fill(radialGradient([
                    GStop("#DDC084", 0),
                    GStop("#C29E62", 1),
                ], cx: 0.6, cy: 0.3, r: 0.7, side: 27))
                .frame(width: 27, height: 30.6)
                .rotationEffect(.degrees(-18))
                .position(x: 152.1, y: 130.5)
        }
    }

    // MARK: - Bulb (3-layer shading + sheen cap)

    private var bulb: some View {
        let B = Self.BULB
        let path = Self.bulbPath()
        return ZStack {
            path.fill(radialGradient([
                GStop("#EDD8AD", 0),
                GStop("#D8BD8A", 0.58),
                GStop("#BFA06C", 1),
            ], cx: 0.42, cy: 0.26, r: 1.15, side: B.w))

            path.fill(radialGradient([
                GStop("#785A2D", 0.5, 0),
                GStop("#785A2D", 1, 0.3),
            ], cx: 0.5, cy: 1, r: 0.62, side: B.w))

            path.fill(radialGradient([
                GStop("#FFF0CD", 0, 0.5),
                GStop("#FFF0CD", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.46, side: B.w))

            // Top sheen cap
            Ellipse()
                .fill(radialGradient([
                    GStop("#785028", 0, 0.5),
                    GStop("#785028", 0.74, 0),
                ], cx: 0.5, cy: 0, r: 1.0, side: 45))
                .frame(width: 45, height: 16.2)
                .position(x: B.x + B.w / 2, y: 35.1)

            freckles
        }
    }

    private var freckles: some View {
        let f = Color(red: 120 / 255, green: 85 / 255, blue: 45 / 255)
        return ZStack {
            freckle(
                cx: 47.25,
                cy: 62.1,
                w: 8.1,
                h: 5.4,
                rotation: 20,
                color: f.opacity(0.4)
            )
            freckle(
                cx: 127.8,
                cy: 56.25,
                w: 7.2,
                h: 4.5,
                rotation: -15,
                color: f.opacity(0.4)
            )
            freckle(
                cx: 134.55,
                cy: 92.7,
                w: 8.1,
                h: 5.4,
                rotation: 30,
                color: f.opacity(0.38)
            )
            freckle(
                cx: 51.75,
                cy: 110.25,
                w: 6.3,
                h: 4.5,
                rotation: 0,
                color: f.opacity(0.36)
            )
        }
    }

    private func freckle(cx: CGFloat, cy: CGFloat, w: CGFloat, h: CGFloat, rotation: Double, color: Color) -> some View {
        Ellipse()
            .fill(color)
            .frame(width: w, height: h)
            .rotationEffect(.degrees(rotation))
            .position(x: cx, y: cy)
    }

    // MARK: - Face

    private var face: some View {
        BulbashikFace(mood: mood, ox: 24, oy: 36)
            .frame(width: 200, height: 200, alignment: .topLeading)
            .scaleEffect(Self.SIZE / 200, anchor: .topLeading)
            .frame(width: Self.SIZE, height: Self.SIZE, alignment: .topLeading)
    }

    // MARK: - Pot

    private var pot: some View {
        let path = Self.potPath()
        return ZStack {
            path.fill(radialGradient([
                GStop("#F3ECD8", 0),
                GStop("#DDD0B0", 1),
            ], cx: 0.5, cy: 0, r: 1.2, side: Self.POT.w))

            path.fill(radialGradient([
                GStop("#8C6E46", 0.6, 0),
                GStop("#8C6E46", 1, 0.18),
            ], cx: 0.5, cy: 1, r: 0.6, side: Self.POT.w))
        }
    }

    private var seamStripe: some View {
        let S = Self.SIZE
        let stripeY = Self.POT.y + 5.4
        let startX = (S - 135) / 2 // 135 wide, centered
        return ZStack {
            ForEach(0..<30, id: \.self) { i in
                Rectangle()
                    .fill(Color(hex: i % 2 == 0 ? "#B5503C" : "#7E9A4E"))
                    .frame(width: 4.5, height: 4.5)
                    .position(x: startX + CGFloat(i) * 4.5 + 4.5 / 2, y: stripeY + 4.5 / 2)
            }
        }
        .opacity(0.85)
    }

    private var potRim: some View {
        Rectangle()
            .fill(verticalLinearGradient([
                GStop("#7E5E36", 0),
                GStop("#5E4527", 1),
            ]))
            .frame(width: Self.POT.w, height: 9.9)
            .position(x: Self.POT.x + Self.POT.w / 2, y: 159.3 + 9.9 / 2)
    }

    private var seed: some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#E7C45E", 0),
                GStop("#B6892E", 1),
            ], cx: 0.4, cy: 0.35, r: 0.7, side: 16.2))
            .frame(width: 16.2, height: 16.2)
            .position(x: Self.SIZE / 2, y: 163.8)
    }

    // MARK: - Geometry

    private static func bulbPath() -> Path {
        roundedBoxPath(BULB.x, BULB.y, BULB.w, BULB.h, [
            (0.52, 0.57),
            (0.48, 0.57),
            (0.5, 0.43),
            (0.5, 0.43),
        ])
    }

    private static func potPath() -> Path {
        roundedBoxPath(POT.x, POT.y, POT.w, POT.h, [
            (0.4, 0.64),
            (0.4, 0.64),
            (0.28, 0.36),
            (0.28, 0.36),
        ])
    }

    private func anchor(_ p: CGPoint) -> UnitPoint {
        UnitPoint(
            x: p.x / Self.SIZE,
            y: p.y / Self.SIZE
        )
    }
}

#if DEBUG
#Preview("Bulbashik — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        BulbashikBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#CFE3B0"))
}
#endif
