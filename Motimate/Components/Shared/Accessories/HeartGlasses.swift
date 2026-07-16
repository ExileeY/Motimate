import SwiftUI

extension Accessories {
    struct HeartGlasses: View {
        let mood: Mood
        var size: CGFloat = PET_SIZE
        var spread: CGFloat = 1

        private static let BASE: CGFloat = PET_SIZE
        private static let CENTER = BASE / 2

        private static let lensW: CGFloat = 34
        private static let lensH: CGFloat = 30
        private static let lensDX: CGFloat = 24
        private static let lensDY: CGFloat = 0

        private static let frameColor = Color(hex: "#c22e6a")
        private static let lensTop = Color(hex: "#ff8fb4")
        private static let lensBottom = Color(hex: "#e84a86")

        var body: some View {
            let center = Self.CENTER
            let lensDX = Self.lensDX * spread
            let bridgeW = max(6, 2 * lensDX - Self.lensW * 0.66)

            ZStack {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(Self.frameColor)
                    .frame(width: bridgeW, height: 5)
                    .position(x: center, y: center + Self.lensDY - Self.lensH * 0.28)

                lens(dx: -lensDX)
                lens(dx: lensDX)
            }
            .frame(width: Self.BASE, height: Self.BASE)
            .scaleEffect(size / Self.BASE)
        }

        private func lens(dx: CGFloat) -> some View {
            let center = Self.CENTER
            return HeartShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Self.lensTop.opacity(0.6),
                            Self.lensBottom.opacity(0.6),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    HeartShape()
                        .stroke(Self.frameColor, lineWidth: 2.5)
                )
                .frame(width: Self.lensW, height: Self.lensH)
                .overlay(alignment: .topLeading) {
                    Ellipse()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 9, height: 6)
                        .rotationEffect(.degrees(-20))
                        .offset(x: 7, y: 6)
                }
                .position(x: center + dx, y: center + Self.lensDY)
        }
    }

    private struct HeartShape: Shape {
        func path(in rect: CGRect) -> Path {
            let w = rect.width
            let h = rect.height
            var path = Path()

            // Start at the bottom tip.
            path.move(to: CGPoint(x: w * 0.5, y: h))
            // Up the left side to the top of the left lobe.
            path.addCurve(
                to: CGPoint(x: 0, y: h * 0.3),
                control1: CGPoint(x: w * 0.16, y: h * 0.78),
                control2: CGPoint(x: 0, y: h * 0.55)
            )
            // Left lobe.
            path.addArc(
                center: CGPoint(x: w * 0.25, y: h * 0.3),
                radius: w * 0.25,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )
            // Right lobe.
            path.addArc(
                center: CGPoint(x: w * 0.75, y: h * 0.3),
                radius: w * 0.25,
                startAngle: .degrees(180),
                endAngle: .degrees(0),
                clockwise: false
            )
            // Down the right side back to the tip.
            path.addCurve(
                to: CGPoint(x: w * 0.5, y: h),
                control1: CGPoint(x: w, y: h * 0.55),
                control2: CGPoint(x: w * 0.84, y: h * 0.78)
            )
            path.closeSubpath()
            return path
        }
    }
}

#if DEBUG
#Preview("HeartGlasses") {
    ZStack {
        Color(hex: "#F6C49A")
        Accessories.HeartGlasses(mood: .energetic)
            .frame(width: PET_SIZE, height: PET_SIZE)
            .border(Color.red.opacity(0.3))
    }
    .frame(width: 240, height: 240)
}
#endif
