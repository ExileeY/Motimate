import SwiftUI

struct BulbashikFace: View {
    let mood: Mood
    let ox: CGFloat
    let oy: CGFloat

    private static let EYE_COLOR = Color(hex: "#8A5A33")

    var body: some View {
        ZStack {
            shared
            face
        }
    }

    // MARK: - Shared (all moods)

    private var shared: some View {
        ZStack {
            brow(
                dx: 38,
                pivotDx: 50,
                rotation: -7
            )
            brow(
                dx: 90,
                pivotDx: 102,
                rotation: 7
            )

            cheek(
                cx: ox + 35,
                cy: oy + 88
            )
            cheek(
                cx: ox + 117,
                cy: oy + 88
            )

            // Nose
            Ellipse()
                .fill(radialGradient([
                    GStop("#E2C083", 0),
                    GStop("#C49E64", 1),
                ], cx: 0.4, cy: 0.3, r: 0.7, side: 16))
                .frame(width: 16, height: 13)
                .position(x: ox + 76, y: oy + 84.5)
        }
    }

    private func brow(dx: CGFloat, pivotDx: CGFloat, rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(hex: "#A37C44"))
            .frame(width: 24, height: 6)
            .position(x: ox + dx + 12, y: oy + 42 + 3)
            .rotationEffect(
                .degrees(rotation),
                anchor: UnitPoint(x: (ox + pivotDx) / BulbashikBody.SIZE, y: (oy + 45) / BulbashikBody.SIZE)
            )
    }

    private func cheek(cx: CGFloat, cy: CGFloat) -> some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#F08278", 0, 0.6),
                GStop("#F08278", 0.7, 0),
            ], cx: 0.5, cy: 0.5, r: 0.5, side: 30))
            .frame(width: 30, height: 18)
            .position(x: cx, y: cy)
    }

    @ViewBuilder
    private var face: some View {
        switch mood {
        case .energetic:
            BulbEye(
                ox: ox,
                oy: oy,
                dx: 40,
                dy: 50,
                irisInset: 6
            )
            BulbEye(
                ox: ox,
                oy: oy,
                dx: 86,
                dy: 50,
                irisInset: 4
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 53,
                dy: 96,
                d: "q 23 22 46 0",
                color: Self.EYE_COLOR
            )
        case .calm:
            Arc(
                ox: ox,
                oy: oy,
                dx: 41,
                dy: 62,
                d: "q 11 -11 22 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 89,
                dy: 62,
                d: "q 11 -11 22 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 61,
                dy: 96,
                d: "q 15 9 30 0",
                color: Self.EYE_COLOR
            )
        case .tired:
            Arc(
                ox: ox,
                oy: oy,
                dx: 41,
                dy: 64,
                d: "q 10 6 20 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 91,
                dy: 64,
                d: "q 10 6 20 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 68,
                dy: 98,
                d: "q 8 7 16 0",
                color: Self.EYE_COLOR
            )
        case .sad:
            Arc(
                ox: ox,
                oy: oy,
                dx: 40,
                dy: 60,
                d: "q 11 10 22 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 88,
                dy: 60,
                d: "q 11 10 22 0",
                color: Self.EYE_COLOR
            )
            Arc(
                ox: ox,
                oy: oy,
                dx: 61,
                dy: 100,
                d: "q 15 -9 30 0",
                color: Self.EYE_COLOR
            )
        }
    }
}
