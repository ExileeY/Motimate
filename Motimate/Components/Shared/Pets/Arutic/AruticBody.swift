import SwiftUI

struct AruticBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let SCALE: CGFloat = 180.0 / 192.0
    private static let CENTER: CGFloat = 192 / 2

    private static let COAT = (
        l: (192 - 168) / 2 as CGFloat,
        r: (192 - 168) / 2 + 168 as CGFloat,
        y: 192 - 82 as CGFloat
    )
    private static let SHIRT = (
        x: CENTER - 42 / 2,
        y: (192 - 82) + 6 as CGFloat,
        w: CGFloat(42)
    )
    private static let HEAD = (
        x: (192 - 124) / 2 as CGFloat,
        y: CGFloat(34),
        w: CGFloat(124),
        h: CGFloat(122)
    )

    private static func s(_ v: CGFloat) -> CGFloat { v * SCALE }

    var body: some View {
        let S = Self.SIZE

        ZStack {
            coat
            shirt
            button
            coatPanels

            hair

            head
            ears
            wrinkle

            beard

            AruticFace(
                mood: mood,
                ox: Self.s(Self.HEAD.x),
                oy: Self.s(Self.HEAD.y),
                scale: Self.SCALE
            )

            hatBrim
            hatCrown
            hatband
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Coat / shirt

    private var coat: some View {
        Self.box(12, 110, 168, 82, [
            (0.42, 0.64),
            (0.42, 0.64),
            (0.22, 0.36),
            (0.22, 0.36),
        ])
        .fill(radialGradient([
            GStop("#5C4428", 0),
            GStop("#38280F", 1),
        ], cx: 0.5, cy: 0, r: 1.2, side: Self.s(168)))
    }

    private var shirt: some View {
        Self.box(Self.SHIRT.x, Self.SHIRT.y, Self.SHIRT.w, 68, [
            (0.19, 0.12),
            (0.19, 0.12),
            (0, 0),
            (0, 0),
        ])
        .fill(verticalLinearGradient([
            GStop("#8A95A2", 0),
            GStop("#67727E", 1),
        ]))
    }

    private var button: some View {
        Circle()
            .fill(Color(hex: "#D9C9A0"))
            .frame(width: Self.s(4), height: Self.s(4))
            .position(x: Self.s(Self.CENTER), y: Self.s(Self.COAT.y + 20 + 2 + 42))
    }

    private var coatPanels: some View {
        ZStack {
            Self.rotated(
                Self.box(Self.COAT.l + 34, Self.COAT.y + 4, 42, 70, [
                    (0, 0),
                    (0, 0),
                    (0, 0),
                    (1, 0.63),
                ]),
                degrees: 9,
                about: CGPoint(x: Self.s(Self.COAT.l + 34 + 21), y: Self.s(Self.COAT.y + 4 + 35))
            )
            .fill(panelGradient)

            Self.rotated(
                Self.box(Self.COAT.r - 34 - 42, Self.COAT.y + 4, 42, 70, [
                    (0, 0),
                    (0, 0),
                    (1, 0.63),
                    (0, 0),
                ]),
                degrees: -9,
                about: CGPoint(x: Self.s(Self.COAT.r - 34 - 21), y: Self.s(Self.COAT.y + 4 + 35))
            )
            .fill(panelGradient)
        }
    }

    private var panelGradient: LinearGradient {
        verticalLinearGradient([
            GStop("#4A3620", 0),
            GStop("#2F2110", 1),
        ])
    }

    // MARK: - Hair

    private var hair: some View {
        let hairGrad = verticalLinearGradient([
            GStop("#9A7038", 0),
            GStop("#6F4E26", 1),
        ])
        let strandGrad = verticalLinearGradient([
            GStop("#8A6334", 0),
            GStop("#5E4220", 1),
        ])
        return ZStack {
            // Left patch
            Self.rotated(
                Self.box(24, 46, 38, 74, [
                    (0.52, 0.46),
                    (0.24, 0.6),
                    (0.46, 0.4),
                    (0.6, 0.54),
                ]),
                degrees: -14,
                about: CGPoint(x: Self.s(24 + 19), y: Self.s(46 + 37))
            )
            .fill(hairGrad)

            // Left strand
            Self.rotated(
                Self.box(32, 58, 16, 58, [
                    (0.5, 0.4),
                    (0.4, 0.5),
                    (0.5, 0.5),
                    (0.5, 0.5),
                ]),
                degrees: -20,
                about: CGPoint(x: Self.s(32 + 8), y: Self.s(58 + 29))
            )
            .fill(strandGrad)

            // Right patch
            Self.rotated(
                Self.box(192 - 24 - 38, 46, 38, 74, [
                    (0.24, 0.6),
                    (0.52, 0.46),
                    (0.6, 0.54),
                    (0.46, 0.4),
                ]),
                degrees: 14,
                about: CGPoint(x: Self.s(192 - 24 - 19), y: Self.s(46 + 37))
            )
            .fill(hairGrad)

            // Right strand
            Self.rotated(
                Self.box(192 - 32 - 16, 58, 16, 58, [
                    (0.4, 0.5),
                    (0.5, 0.4),
                    (0.5, 0.5),
                    (0.5, 0.5),
                ]),
                degrees: 20,
                about: CGPoint(x: Self.s(192 - 32 - 8), y: Self.s(58 + 29))
            )
            .fill(strandGrad)
        }
    }

    // MARK: - Head

    private var head: some View {
        let path = Self.headPath()
        let side = Self.s(Self.HEAD.w)
        return ZStack {
            path.fill(radialGradient([
                GStop("#F0C49A", 0),
                GStop("#E0A878", 0.64),
                GStop("#CC9460", 1),
            ], cx: 0.5, cy: 0.24, r: 1.15, side: side))

            path.fill(radialGradient([
                GStop("#965F2D", 0.55, 0),
                GStop("#965F2D", 1, 0.28),
            ], cx: 0.5, cy: 1, r: 0.6, side: side))

            path.fill(radialGradient([
                GStop("#FFE4C4", 0, 0.5),
                GStop("#FFE4C4", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.44, side: side))
        }
    }

    private var ears: some View {
        ZStack {
            ear(cx: Self.HEAD.x - 7 + 8)
            ear(cx: Self.HEAD.x + Self.HEAD.w + 7 - 8)
        }
    }

    private func ear(cx: CGFloat) -> some View {
        Ellipse()
            .fill(Color(hex: "#E0A878"))
            .frame(width: Self.s(16), height: Self.s(22))
            .position(x: Self.s(cx), y: Self.s(Self.HEAD.y + 54 + 11))
    }

    private var wrinkle: some View {
        RoundedRectangle(cornerRadius: Self.s(2.5))
            .fill(Color(hex: "#96643C").opacity(0.3))
            .frame(width: Self.s(54), height: Self.s(5))
            .position(
                x: Self.s(Self.HEAD.x + Self.HEAD.w / 2),
                y: Self.s(Self.HEAD.y + 50 + 2.5)
            )
    }

    // MARK: - Beard

    private var beard: some View {
        ZStack {
            Self.box(44, Self.HEAD.y + 84, 104, 48, [
                (0, 0),
                (0, 0),
                (0.46, 1),
                (0.46, 1),
            ])
            .fill(radialGradient([
                GStop("#8A6334", 0),
                GStop("#6B4B26", 0.78),
                GStop("#6B4B26", 1),
            ], cx: 0.5, cy: 0, r: 0.9, side: Self.s(104)))

            Self.box(192 / 2 - 23, Self.HEAD.y + 84 + 4, 46, 12, [
                (0, 0),
                (0, 0),
                (0.52, 1),
                (0.52, 1),
            ])
            .fill(Color(hex: "#7A5730"))

            RoundedRectangle(cornerRadius: Self.s(1.5))
                .fill(Color(hex: "#4A3526"))
                .frame(width: Self.s(26), height: Self.s(3))
                .position(
                    x: Self.s(192 / 2),
                    y: Self.s(Self.HEAD.y + 84 + 15 + 1.5)
                )
        }
    }

    // MARK: - Hat

    private var hatBrim: some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#5A4022", 0),
                GStop("#2E2012", 1),
            ], cx: 0.5, cy: 0, r: 1.2, side: Self.s(87 * 2)))
            .frame(width: Self.s(87 * 2), height: Self.s(17 * 2))
            .position(x: Self.s(96), y: Self.s(48 + 17))
    }

    private var hatCrown: some View {
        ZStack {
            Self.box(41, 6, 110, 58, [
                (0.46, 0.7),
                (0.46, 0.7),
                (0.38, 0.4),
                (0.38, 0.4),
            ])
            .fill(radialGradient([
                GStop("#523A1F", 0),
                GStop("#2A1D0F", 1),
            ], cx: 0.5, cy: 0.3, r: 1.1, side: Self.s(110)))

            RoundedRectangle(cornerRadius: Self.s(4.5))
                .fill(Color(hex: "#140C04").opacity(0.34))
                .frame(width: Self.s(9), height: Self.s(36))
                .position(x: Self.s(96), y: Self.s(6 + 5 + 18))
        }
    }

    private var hatband: some View {
        // Base band + 28 studs, clipped to a rounded-rect band (RN `<ClipPath>`).
        ZStack {
            RoundedRectangle(cornerRadius: Self.s(4.5))
                .fill(Color(hex: "#87662F"))
                .frame(width: Self.s(112), height: Self.s(9))
                .position(x: Self.s(40 + 56), y: Self.s(52 + 4.5))

            ForEach(0..<28, id: \.self) { i in
                let sx = Self.s(40 - 12 + CGFloat(i) * 10)
                let sy = Self.s(52 - 6)
                let w = Self.s(5)
                let h = Self.s(21)
                Rectangle()
                    .fill(Color(hex: "#B6925A"))
                    .frame(width: w, height: h)
                    .position(x: sx + w / 2, y: sy + h / 2)
                    .rotationEffect(
                        .degrees(-25),
                        anchor: UnitPoint(
                            x: Self.s(40 - 12 + CGFloat(i) * 10 + 2.5) / Self.SIZE,
                            y: Self.s(52 + 4.5) / Self.SIZE
                        )
                    )
            }
        }
        .frame(width: Self.SIZE, height: Self.SIZE)
        .mask(
            RoundedRectangle(cornerRadius: Self.s(4.5))
                .frame(width: Self.s(112), height: Self.s(9))
                .position(x: Self.s(40 + 56), y: Self.s(52 + 4.5))
                .frame(width: Self.SIZE, height: Self.SIZE)
        )
    }

    // MARK: - Geometry helpers

    private static func box(
        _ x: CGFloat,
        _ y: CGFloat,
        _ w: CGFloat,
        _ h: CGFloat,
        _ corners: [(CGFloat, CGFloat)]
    ) -> Path {
        roundedBoxPath(s(x), s(y), s(w), s(h), corners)
    }

    private static func headPath() -> Path {
        box(HEAD.x, HEAD.y, HEAD.w, HEAD.h, [
            (0.45, 0.5),
            (0.45, 0.5),
            (0.44, 0.5),
            (0.44, 0.5),
        ])
    }

    private static func rotated(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}

#if DEBUG
#Preview("Arutic — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        AruticBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#EAD9B8"))
}
#endif
