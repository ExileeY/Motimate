import SwiftUI

struct DucklingBody: View {
    let mood: Mood
    var size: CGFloat? = nil

    private static let SIZE: CGFloat = 180
    private static let BW: CGFloat = 112
    private static let BH: CGFloat = 122
    private static let CX: CGFloat = 90
    private static let CY: CGFloat = 100

    var body: some View {
        let S = Self.SIZE

        ZStack {
            foot(cx: 74)
            foot(cx: 106)

            tuft

            torso
            belly

            wing(cx: 44, degrees: 16)
            wing(cx: 136, degrees: -16)

            face
        }
        .frame(width: S, height: S)
        .scaleEffect((size ?? S) / S)
    }

    // MARK: - Body

    private var torso: some View {
        let path = roundedBoxPath(0, 0, Self.BW, Self.BH, [
            (0.5, 0.5),
            (0.5, 0.5),
            (0.5, 0.46),
            (0.5, 0.46),
        ])
        return ZStack {
            // Base yellow radial
            path.fill(radialGradient([
                GStop("#FFE9A8", 0),
                GStop("#FDC64B", 0.62),
                GStop("#F3A62E", 1),
            ], cx: 0.5, cy: 0.30, r: 1.12, side: Self.BW))

            // Bottom core-shadow
            path.fill(radialGradient([
                GStop("#C9761A", 0.55, 0),
                GStop("#C9761A", 1, 0.30),
            ], cx: 0.5, cy: 1, r: 0.62, side: Self.BW))

            // Top rim highlight
            path.fill(radialGradient([
                GStop("#FFF4CE", 0, 0.65),
                GStop("#FFF4CE", 1, 0),
            ], cx: 0.5, cy: 0, r: 0.5, side: Self.BW))
        }
        .frame(width: Self.BW, height: Self.BH)
        .position(x: Self.CX, y: Self.CY)
    }

    private var belly: some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#FFF3D0", 0, 0.85),
                GStop("#FFF3D0", 0.7, 0),
            ], cx: 0.5, cy: 0.42, r: 0.5, side: 72))
            .frame(width: 72, height: 68)
            .position(x: Self.CX, y: 120)
    }

    // MARK: - Wings

    private func wing(cx: CGFloat, degrees: Double) -> some View {
        ZStack {
            Ellipse()
                .fill(radialGradient([
                    GStop("#FBBE3F", 0),
                    GStop("#ED9C27", 1),
                ], cx: 0.5, cy: 0.32, r: 0.8, side: 30))
                .frame(width: 30, height: 44)

            Ellipse()
                .fill(radialGradient([
                    GStop("#FFF0C4", 0, 0.5),
                    GStop("#FFF0C4", 1, 0),
                ], cx: 0.5, cy: 0, r: 0.55, side: 30))
                .frame(width: 30, height: 44)
        }
        .rotationEffect(.degrees(degrees))
        .position(x: cx, y: 112)
    }

    // MARK: - Head fluff

    private var tuft: some View {
        ZStack {
            fluff(x: 90, y: 38, degrees: 0)
            fluff(x: 77, y: 43, degrees: -24)
            fluff(x: 103, y: 43, degrees: 24)
        }
    }

    private func fluff(x: CGFloat, y: CGFloat, degrees: Double) -> some View {
        Ellipse()
            .fill(radialGradient([
                GStop("#FFE29A", 0),
                GStop("#F6B733", 1),
            ], cx: 0.5, cy: 0.25, r: 0.8, side: 14))
            .frame(width: 14, height: 30)
            .rotationEffect(.degrees(degrees))
            .position(x: x, y: y)
    }

    // MARK: - Face

    private var face: some View {
        ZStack {
            Cheek(ox: 0, oy: 0, dx: 66, dy: 104, opacity: 0.5, rx: 10, ry: 7, blur: 1.3)
            Cheek(ox: 0, oy: 0, dx: 114, dy: 104, opacity: 0.5, rx: 10, ry: 7, blur: 1.3)

            eye(x: 72)
            eye(x: 108)

            beak
        }
    }

    private func eye(x: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: "#3A2A1A"))
                .frame(width: 14, height: 17)
            Circle()
                .fill(Color.white)
                .frame(width: 5, height: 5)
                .offset(x: -2, y: -4)
        }
        .position(x: x, y: 92)
    }

    private var beak: some View {
        ZStack {
            svgPath("M 79 107 L 90 100 L 101 107 L 90 114 Z")
                .fill(Color(hex: "#F6A623"))
            svgPath("M 79 107 L 101 107 L 90 114 Z")
                .fill(Color(hex: "#E08C1C"))
        }
    }

    // MARK: - Feet

    private func foot(cx: CGFloat) -> some View {
        svgPath(
            "M \(cx) 156 "
            + "L \(cx - 11) 169 L \(cx - 4) 165 L \(cx) 170 "
            + "L \(cx + 4) 165 L \(cx + 11) 169 Z"
        )
        .fill(Color(hex: "#EFA436"))
    }
}

#if DEBUG
#Preview("Duckling") {
    ZStack {
        Color(hex: "#F6C49A")
        HStack(spacing: 20) {
            DucklingBody(mood: .calm)
                .frame(width: PET_SIZE, height: PET_SIZE)
                .border(Color.red.opacity(0.3))
            DucklingBody(mood: .calm, size: 64)
                .frame(width: 64, height: 64)
                .border(Color.red.opacity(0.3))
        }
    }
    .frame(width: 320, height: 240)
}
#endif
