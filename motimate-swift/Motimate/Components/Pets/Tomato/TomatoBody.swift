import SwiftUI

struct TomatoBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let NATIVE_SIZE: CGFloat = 196
    private static let SCALE: CGFloat = SIZE / NATIVE_SIZE
    private static let CENTER: CGFloat = NATIVE_SIZE / 2
    private static let BODY = (
        x: (NATIVE_SIZE - 152) / 2,
        y: CGFloat(48),
        w: CGFloat(152),
        h: CGFloat(138)
    )

    private static func s(_ v: CGFloat) -> CGFloat { v * SCALE }

    var body: some View {
        let S = Self.SIZE
        ZStack {
            arms
            tomato
            topShadow
            sheen
            lobes
            TomatoFace(
                mood: mood,
                ox: Self.s(Self.BODY.x),
                oy: Self.s(Self.BODY.y),
                scale: Self.SCALE
            )
            calyx
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Leaf arms

    private var arms: some View {
        ZStack {
            rotatedPath(
                leafPath(
                    x: 8,
                    y: 118,
                    w: 30,
                    h: 20,
                    flip: false
                ),
                degrees: 28,
                about: point(8 + 15, 118 + 10)
            )
            .fill(radialGradient([
                GStop("#8AC153", 0),
                GStop("#5C8A30", 1),
            ], cx: 0.3, cy: 0.4, r: 0.8, side: Self.s(30)))

            rotatedPath(
                leafPath(
                    x: Self.NATIVE_SIZE - 8 - 30,
                    y: 118,
                    w: 30,
                    h: 20,
                    flip: true
                ),
                degrees: -28,
                about: point(Self.NATIVE_SIZE - 8 - 15, 118 + 10)
            )
            .fill(radialGradient([
                GStop("#8AC153", 0),
                GStop("#5C8A30", 1),
            ], cx: 0.7, cy: 0.4, r: 0.8, side: Self.s(30)))
        }
    }

    // MARK: - Body

    private var tomato: some View {
        let path = Self.bodyPath()
        let side = Self.s(Self.BODY.w)
        return ZStack {
            path.fill(radialGradient([
                GStop("#FF8468", 0),
                GStop("#E84A30", 0.54),
                GStop("#C0331F", 1),
            ], cx: 0.4, cy: 0.24, r: 1.16, side: side))

            path.fill(radialGradient([
                GStop("#781910", 0.45, 0),
                GStop("#781910", 1, 0.34),
            ], cx: 0.5, cy: 1, r: 0.64, side: side))

            path.fill(radialGradient([
                GStop("#FFCDB4", 0, 0.5),
                GStop("#FFCDB4", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.46, side: side))
        }
    }

    private var topShadow: some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#6E190F", 0, 0.5),
                GStop("#6E190F", 0.74, 0),
            ], cx: 0.5, cy: 0, r: 1, side: Self.s(56)))
            .frame(width: Self.s(56), height: Self.s(18))
            .position(x: Self.s(Self.CENTER), y: Self.s(Self.BODY.y - 4 + 9))
    }

    private var sheen: some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#FFE4D6", 0, 0.6),
                GStop("#FFE4D6", 0.7, 0),
            ], cx: 0.4, cy: 0.35, r: 0.6, side: Self.s(42)))
            .frame(width: Self.s(42), height: Self.s(32))
            .position(
                x: Self.s(Self.BODY.x + 28 + 21),
                y: Self.s(Self.BODY.y + 14 + 16)
            )
    }

    private var lobes: some View {
        let B = Self.BODY
        return ZStack {
            lobe(x: B.x + 46, y: B.y + 22)
            lobe(x: B.x + 152 - 46 - 5, y: B.y + 22)
        }
    }

    private func lobe(x: CGFloat, y: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: Self.s(2.5))
            .fill(radialGradient([
                GStop("#781E12", 0, 0.16),
                GStop("#781E12", 0.75, 0),
            ], cx: 0.5, cy: 0.5, r: 0.5, side: Self.s(84)))
            .frame(width: Self.s(5), height: Self.s(84))
            .position(x: Self.s(x + 2.5), y: Self.s(y + 42))
    }

    // MARK: - Calyx

    private var calyx: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Self.s(3))
                .fill(verticalLinearGradient([
                    GStop("#7BA844", 0),
                    GStop("#5C8233", 1),
                ]))
                .frame(width: Self.s(6), height: Self.s(30))
                .position(
                    x: Self.s(Self.CENTER),
                    y: Self.s(-2 + 66 - 18 - 30 + 15)
                )

            roundedBoxPath(Self.s(Self.CENTER - 7.5), Self.s(-2), Self.s(15), Self.s(18), [
                (0.6, 0.6),
                (0.6, 0.6),
                (0.5, 0.5),
                (0.5, 0.5),
            ])
            .fill(radialGradient([
                GStop("#ACD972", 0),
                GStop("#6FA23E", 1),
            ], cx: 0.5, cy: 0.3, r: 0.6, side: Self.s(15)))

            upperLeaf(
                x: 38 + 42,
                y: -2 + 18,
                w: 34,
                h: 22,
                deg: -32,
                flip: false,
                gradient: .a
            )
            upperLeaf(
                x: 38 + 120 - 42 - 34,
                y: -2 + 18,
                w: 34,
                h: 22,
                deg: 32,
                flip: true,
                gradient: .a
            )
            upperLeaf(
                x: 38 + 14,
                y: -2 + 30,
                w: 30,
                h: 18,
                deg: -58,
                flip: false,
                gradient: .b
            )
            upperLeaf(
                x: 38 + 120 - 14 - 30,
                y: -2 + 30,
                w: 30,
                h: 18,
                deg: 58,
                flip: true,
                gradient: .b
            )
        }
    }

    private enum LeafGradient {
        case a
        case b
    }

    private func upperLeaf(
        x: CGFloat,
        y: CGFloat,
        w: CGFloat,
        h: CGFloat,
        deg: Double,
        flip: Bool,
        gradient: LeafGradient
    ) -> some View {
        let stops: [GStop]
        switch gradient {
        case .a:
            stops = [
                GStop("#93C95B", 0),
                GStop("#5E9233", 1),
            ]
        case .b:
            stops = [
                GStop("#8AC153", 0),
                GStop("#57892E", 1),
            ]
        }
        return rotatedPath(
            leafPath(x: x, y: y, w: w, h: h, flip: flip),
            degrees: deg,
            about: point(x + w / 2, y + h / 2)
        )
        .fill(radialGradient(stops, cx: 0.32, cy: 0.3, r: 0.78, side: Self.s(w)))
    }

    // MARK: - Geometry

    private static func bodyPath() -> Path {
        roundedBoxPath(s(BODY.x), s(BODY.y), s(BODY.w), s(BODY.h), [
            (0.49, 0.45),
            (0.49, 0.45),
            (0.5, 0.55),
            (0.5, 0.55),
        ])
    }

    private func leafPath(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, flip: Bool) -> Path {
        roundedBoxPath(Self.s(x), Self.s(y), Self.s(w), Self.s(h), flip ? [
            (0.08, 0.08),
            (0.62, 0.62),
            (0.08, 0.08),
            (0.62, 0.62),
        ] : [
            (0.62, 0.62),
            (0.08, 0.08),
            (0.62, 0.62),
            (0.08, 0.08),
        ])
    }

    private func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: Self.s(x), y: Self.s(y))
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}

#if DEBUG
#Preview("Tomato - all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        TomatoBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#E84A30").opacity(0.2))
}
#endif
