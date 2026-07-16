import SwiftUI

struct KhinklearBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let SCALE: CGFloat = SIZE / 196
    private static let INSET_X: CGFloat = (196 - 188) / 2
    private static let CENTER: CGFloat = 188 / 2

    private static func sx(_ v: CGFloat) -> CGFloat { (v + INSET_X) * SCALE }
    private static func sy(_ v: CGFloat) -> CGFloat { v * SCALE }
    private static func ss(_ v: CGFloat) -> CGFloat { v * SCALE }

    private static let POUCH = (
        x: CENTER - 152 / 2,
        y: CGFloat(40),
        w: CGFloat(152),
        h: CGFloat(140)
    )
    private static let KNOT = (
        x: CENTER - 30 / 2,
        y: CGFloat(0)
    )
    private static let BOW = (
        x: CENTER - 48 / 2,
        y: CGFloat(30)
    )
    private static let PLEAT_ROTATIONS: [Double] = [-42, -28, -14, 0, 14, 28, 42]

    var body: some View {
        let S = Self.SIZE
        ZStack {
            topknot
            feet
            pouch
            bow
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Topknot

    private var topknot: some View {
        let sx = Self.sx, sy = Self.sy, ss = Self.ss
        let K = Self.KNOT
        return ZStack {
            // Base
            roundedBoxPath(sx(K.x), sy(K.y + 18), ss(30), ss(22), [
                (0.5, 0.5),
                (0.5, 0.5),
                (0.46, 0.46),
                (0.46, 0.46),
            ])
            .fill(radialGradient([
                GStop("#FBF2E0", 0),
                GStop("#E7D5B4", 1),
            ], cx: 0.5, cy: 0.2, r: 0.8, side: ss(30)))

            // Tuft
            rotatedPath(
                roundedBoxPath(sx(Self.CENTER - 18 / 2), sy(K.y), ss(18), ss(24), [
                    (0.54, 0.54),
                    (0.54, 0.54),
                    (0.5, 0.5),
                    (0.5, 0.5),
                ]),
                degrees: -8, about: CGPoint(x: sx(Self.CENTER), y: sy(K.y + 12))
            )
            .fill(radialGradient([
                GStop("#FCF4E4", 0),
                GStop("#E2CFAC", 1),
            ], cx: 0.4, cy: 0.3, r: 0.7, side: ss(18)))

            // Shadow strokes
            RoundedRectangle(cornerRadius: ss(1.5))
                .fill(Color(red: 150 / 255, green: 115 / 255, blue: 70 / 255).opacity(0.3))
                .frame(width: ss(15), height: ss(3))
                .rotationEffect(.degrees(28))
                .position(x: sx(K.x + 8 + 7.5), y: sy(K.y + 7 + 1.5))

            RoundedRectangle(cornerRadius: ss(1.5))
                .fill(Color(red: 150 / 255, green: 115 / 255, blue: 70 / 255).opacity(0.26))
                .frame(width: ss(16), height: ss(3))
                .rotationEffect(.degrees(24))
                .position(x: sx(K.x + 7 + 8), y: sy(K.y + 14 + 1.5))
        }
    }

    // MARK: - Feet

    private var feet: some View {
        let sx = Self.sx, sy = Self.sy, ss = Self.ss
        let cy = sy(196 - 6 - 17 / 2)
        return ZStack {
            Ellipse()
                .fill(Color(hex: "#E6D2AC"))
                .frame(width: ss(30), height: ss(17))
                .position(x: sx(58 + 15), y: cy)
            Ellipse()
                .fill(Color(hex: "#E6D2AC"))
                .frame(width: ss(30), height: ss(17))
                .position(x: sx(188 - 58 - 15), y: cy)
        }
    }

    // MARK: - Pouch

    private var pouch: some View {
        let sx = Self.sx, sy = Self.sy, ss = Self.ss
        let P = Self.POUCH
        let corners: [(CGFloat, CGFloat)] = [
            (0.48, 0.58),
            (0.48, 0.58),
            (0.5, 0.42),
            (0.5, 0.42),
        ]
        let path = roundedBoxPath(sx(P.x), sy(P.y), ss(P.w), ss(P.h), corners)
        return ZStack {
            path.fill(radialGradient([
                GStop("#FCF4E4", 0),
                GStop("#EFE1C6", 0.64),
                GStop("#DECBA6", 1),
            ], cx: 0.48, cy: 0.24, r: 1.15, side: ss(P.w)))

            path.fill(radialGradient([
                GStop("#967346", 0.5, 0),
                GStop("#967346", 1, 0.26),
            ], cx: 0.5, cy: 1.0, r: 0.62, side: ss(P.w)))

            path.fill(radialGradient([
                GStop("#FFF8E8", 0, 0.6),
                GStop("#FFF8E8", 1, 0),
            ], cx: 0.5, cy: 0.0, r: 0.46, side: ss(P.w)))

            pleats

            KhinklearFace(
                mood: mood,
                ox: sx(P.x),
                oy: sy(P.y),
                scale: Self.SCALE
            )
        }
    }

    private var pleats: some View {
        let sx = Self.sx, sy = Self.sy, ss = Self.ss
        let pleatW = ss(4)
        let pleatH = ss(58)
        let pivotX = sx(Self.CENTER)
        let pivotY = sy(Self.POUCH.y + 2)
        return ZStack {
            ForEach(Self.PLEAT_ROTATIONS, id: \.self) { deg in
                RoundedRectangle(cornerRadius: ss(2))
                    .fill(verticalLinearGradient([
                        GStop("#967346", 0, 0.5),
                        GStop("#967346", 0.82, 0),
                    ]))
                    .frame(width: pleatW, height: pleatH)
                    .rotationEffect(.degrees(deg), anchor: .top)
                    .position(x: pivotX, y: pivotY + pleatH / 2)
            }
        }
    }

    // MARK: - Bow

    private var bow: some View {
        let sx = Self.sx, sy = Self.sy, ss = Self.ss
        let B = Self.BOW
        return ZStack {
            // Left lobe
            rotatedPath(
                roundedBoxPath(sx(B.x), sy(B.y), ss(21), ss(21), [
                    (0.64, 0.64),
                    (0.28, 0.28),
                    (0.64, 0.64),
                    (0.28, 0.28),
                ]),
                degrees: -10, about: CGPoint(x: sx(B.x + 10.5), y: sy(B.y + 10.5))
            )
            .fill(radialGradient([
                GStop("#F6B3C6", 0),
                GStop("#E68AA6", 1),
            ], cx: 0.72, cy: 0.32, r: 0.7, side: ss(21)))

            // Right lobe
            rotatedPath(
                roundedBoxPath(sx(B.x + 48 - 21), sy(B.y), ss(21), ss(21), [
                    (0.28, 0.28),
                    (0.64, 0.64),
                    (0.28, 0.28),
                    (0.64, 0.64),
                ]),
                degrees: 10, about: CGPoint(x: sx(B.x + 48 - 21 + 10.5), y: sy(B.y + 10.5))
            )
            .fill(radialGradient([
                GStop("#F6B3C6", 0),
                GStop("#E68AA6", 1),
            ], cx: 0.28, cy: 0.32, r: 0.7, side: ss(21)))

            // Center knot
            RoundedRectangle(cornerRadius: ss(4))
                .fill(Color(hex: "#DD7A98"))
                .frame(width: ss(11), height: ss(13))
                .position(x: sx(Self.CENTER), y: sy(B.y + 11 - 13 / 2 + 13 / 2))
        }
    }

    private func rotatedPath(_ path: Path, degrees: Double, about pivot: CGPoint) -> Path {
        let t = CGAffineTransform(translationX: pivot.x, y: pivot.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -pivot.x, y: -pivot.y)
        return path.applying(t)
    }
}

#if DEBUG
#Preview("Khinklear — all moods") {
    VStack(spacing: 20) {
        ForEach([[Mood.energetic, .calm], [.tired, .sad]], id: \.self) { row in
            HStack(spacing: 20) {
                ForEach(row, id: \.self) { mood in
                    VStack(spacing: 6) {
                        KhinklearBody(mood: mood)
                            .frame(width: PET_SIZE, height: PET_SIZE)
                        Text(mood.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }
    .padding()
    .background(Color(hex: "#EFE1C6"))
}
#endif
