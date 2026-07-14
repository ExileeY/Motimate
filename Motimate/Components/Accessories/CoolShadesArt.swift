import SwiftUI

struct CoolShadesArt: View {
    let mood: Mood
    var size: CGFloat = PET_SIZE
    var spread: CGFloat = 1

    private static let BASE: CGFloat = PET_SIZE
    private static let CENTER = BASE / 2

    private static let lensW: CGFloat = 33
    private static let lensH: CGFloat = 26
    private static let lensDX: CGFloat = 26
    private static let lensDY: CGFloat = -2

    private static let frameColor = Color(hex: "#14100b")
    private static let lensTop = Color(hex: "#4b3c33")
    private static let lensBottom = Color(hex: "#231a14")

    var body: some View {
        let center = Self.CENTER

        let lensDX = Self.lensDX * spread
        let bridgeW = 22 + (lensDX - Self.lensDX) * 2

        ZStack {
            brow(dx: -lensDX, rotation: -7)
            brow(dx: lensDX, rotation: 7)

            RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                .fill(Self.frameColor)
                .frame(width: bridgeW, height: 5)
                .position(x: center, y: center + Self.lensDY - 8)

            lens(dx: -lensDX)
            lens(dx: lensDX)
        }
        .frame(width: Self.BASE, height: Self.BASE)
        .scaleEffect(size / Self.BASE)
    }

    private func brow(dx: CGFloat, rotation: Double) -> some View {
        let center = Self.CENTER

        return RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(Self.frameColor)
            .frame(width: 14, height: 5)
            .rotationEffect(.degrees(rotation))
            .position(x: center + dx, y: center + Self.lensDY - 12)
    }

    private func lens(dx: CGFloat) -> some View {
        let center = Self.CENTER

        return RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Self.lensTop, Self.lensBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Self.frameColor, lineWidth: 2)
            )
            .frame(width: Self.lensW, height: Self.lensH)
            .overlay(alignment: .topLeading) {
                Ellipse()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 10, height: 7)
                    .rotationEffect(.degrees(-22))
                    .offset(x: 6, y: 5)
            }
            .position(x: center + dx, y: center + Self.lensDY)
    }
}

#if DEBUG
#Preview("CoolShadesArt") {
    ZStack {
        Color(hex: "#F6C49A")
        CoolShadesArt(mood: .energetic)
            .frame(width: PET_SIZE, height: PET_SIZE)
            .border(Color.red.opacity(0.3))
    }
    .frame(width: 240, height: 240)
}
#endif
