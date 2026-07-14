import SwiftUI

struct KhinklearFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat
    let scale: CGFloat

    private static let POUCH_WIDTH: CGFloat = 152
    private static let INK_BASIC = Color(hex: "#4A352A")
    private static let INK_TIRED = Color(hex: "#6B4F3F")
    private static let BLUSH = Color(hex: "#EF9FB4")

    var body: some View {
        ZStack {
            shared
            face
        }
    }

    // MARK: - Shared (all moods)

    private var shared: some View {
        let W = Self.POUCH_WIDTH
        return ZStack {
            Cheek(
                ox: ox,
                oy: oy,
                dx: (16 + 12) * scale,
                dy: (72 + 7.5) * scale,
                color: Self.BLUSH,
                opacity: 0.55,
                rx: 12 * scale,
                ry: 7.5 * scale
            )
            Cheek(
                ox: ox,
                oy: oy,
                dx: (W - 16 - 12) * scale,
                dy: (72 + 7.5) * scale,
                color: Self.BLUSH,
                opacity: 0.55,
                rx: 12 * scale,
                ry: 7.5 * scale
            )
        }
    }

    // MARK: - Lash

    private func lash(x: CGFloat, y: CGFloat, w: CGFloat, deg: Double, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 2 * scale)
            .fill(color)
            .frame(width: w * scale, height: 2.5 * scale)
            .rotationEffect(.degrees(deg))
            .position(
                x: ox + (x + w / 2) * scale,
                y: oy + (y + 1.25) * scale
            )
    }

    // MARK: - Per-mood

    @ViewBuilder
    private var face: some View {
        let W = Self.POUCH_WIDTH
        switch mood {
        case .energetic:
            ZStack {
                KhinklEye(
                    ox: ox,
                    oy: oy,
                    dx: 42,
                    dy: 52,
                    scale: scale
                )
                KhinklEye(
                    ox: ox,
                    oy: oy,
                    dx: W - 42 - 15,
                    dy: 52,
                    scale: scale
                )

                lash(
                    x: 36, 
                    y: 48, 
                    w: 9, 
                    deg: -32,
                    color: Self.INK_BASIC
                )
                lash(
                    x: 39, 
                    y: 45, 
                    w: 9, 
                    deg: -12,
                    color: Self.INK_BASIC
                )
                lash(
                    x: W - 36 - 9,
                    y: 48,
                    w: 9,
                    deg: 32,
                    color: Self.INK_BASIC
                )
                lash(
                    x: W - 39 - 9, 
                    y: 45, 
                    w: 9, 
                    deg: 12,
                    color: Self.INK_BASIC
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W / 2 - 9) * scale,
                    dy: 82 * scale,
                    d: "q \(9 * scale) \(11 * scale) \(18 * scale) 0",
                    color: Self.INK_BASIC
                )
            }
        case .calm:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 40 * scale,
                    dy: 64 * scale,
                    d: "q \(10 * scale) \(-11 * scale) \(20 * scale) 0",
                    color: Self.INK_BASIC
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 40 - 20) * scale,
                    dy: 64 * scale,
                    d: "q \(10 * scale) \(-11 * scale) \(20 * scale) 0",
                    color: Self.INK_BASIC
                )

                lash(
                    x: 36,
                    y: 52,
                    w: 8,
                    deg: -28,
                    color: Self.INK_BASIC
                )
                lash(
                    x: W - 36 - 8,
                    y: 52,
                    w: 8,
                    deg: 28,
                    color: Self.INK_BASIC
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W / 2 - 7.5) * scale,
                    dy: 82 * scale,
                    d: "q \(7.5 * scale) \(9 * scale) \(15 * scale) 0",
                    color: Self.INK_BASIC
                )
            }
        case .tired:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 41 * scale,
                    dy: 62 * scale,
                    d: "q \(8.5 * scale) \(9 * scale) \(17 * scale) 0",
                    color: Self.INK_TIRED
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 41 - 17) * scale,
                    dy: 62 * scale,
                    d: "q \(8.5 * scale) \(9 * scale) \(17 * scale) 0",
                    color: Self.INK_TIRED
                )

                lash(
                    x: 38,
                    y: 64,
                    w: 7,
                    deg: 20,
                    color: Self.INK_TIRED
                )
                lash(
                    x: W - 38 - 7,
                    y: 64,
                    w: 7,
                    deg: -20,
                    color: Self.INK_TIRED
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W / 2 - 6.5) * scale,
                    dy: 84 * scale,
                    d: "q \(6.5 * scale) \(8 * scale) \(13 * scale) 0",
                    color: Self.INK_TIRED
                )
            }
        case .sad:
            ZStack {
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: 41 * scale,
                    dy: 60 * scale,
                    d: "q \(8.5 * scale) \(9 * scale) \(17 * scale) 0",
                    color: Self.INK_BASIC
                )
                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W - 41 - 17) * scale,
                    dy: 60 * scale,
                    d: "q \(8.5 * scale) \(9 * scale) \(17 * scale) 0",
                    color: Self.INK_BASIC
                )

                lash(
                    x: 38,
                    y: 62,
                    w: 7,
                    deg: 22,
                    color: Self.INK_BASIC
                )
                lash(
                    x: W - 38 - 7,
                    y: 62,
                    w: 7,
                    deg: -22,
                    color: Self.INK_BASIC
                )

                Arc(
                    ox: ox,
                    oy: oy,
                    dx: (W / 2 - 7.5) * scale,
                    dy: 88 * scale,
                    d: "q \(7.5 * scale) \(-8 * scale) \(15 * scale) 0",
                    color: Self.INK_BASIC
                )
            }
        }
    }
}
