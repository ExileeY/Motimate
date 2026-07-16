import SwiftUI

extension Accessories {
    struct ThreeDGlasses: View {
        let mood: Mood
        var size: CGFloat = PET_SIZE
        var spread: CGFloat = 1

        private static let BASE: CGFloat = PET_SIZE
        private static let CENTER = BASE / 2

        private static let lensW: CGFloat = 33
        private static let lensH: CGFloat = 26
        private static let lensDX: CGFloat = 26
        private static let lensDY: CGFloat = -2

        private static let cardboard = Color(hex: "#f4ede0")
        private static let cardboardEdge = Color(hex: "#c9bfa8")
        private static let redFilm = Color(hex: "#ff3b4d")
        private static let cyanFilm = Color(hex: "#25d0dd")

        var body: some View {
            let center = Self.CENTER
            let lensDX = Self.lensDX * spread
            let bridgeW = max(6, 2 * lensDX - Self.lensW)

            ZStack {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(Self.cardboard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .stroke(Self.cardboardEdge, lineWidth: 1)
                    )
                    .frame(width: bridgeW, height: 7)
                    .position(x: center, y: center + Self.lensDY)


                temple(dx: -(lensDX + Self.lensW / 2))
                temple(dx: lensDX + Self.lensW / 2)

                lens(dx: -lensDX, film: Self.redFilm)
                lens(dx: lensDX, film: Self.cyanFilm)
            }
            .frame(width: Self.BASE, height: Self.BASE)
            .scaleEffect(size / Self.BASE)
        }

        private func temple(dx: CGFloat) -> some View {
            let center = Self.CENTER
            return RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(Self.cardboard)
                .overlay(
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .stroke(Self.cardboardEdge, lineWidth: 1)
                )
                .frame(width: 8, height: 6)
                .position(x: center + dx, y: center + Self.lensDY)
        }

        private func lens(dx: CGFloat, film: Color) -> some View {
            let center = Self.CENTER
            return RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(film.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(Self.cardboard, lineWidth: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(Self.cardboardEdge, lineWidth: 1)
                )
                .frame(width: Self.lensW, height: Self.lensH)
                .overlay(alignment: .topLeading) {
                    Ellipse()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: 9, height: 6)
                        .rotationEffect(.degrees(-22))
                        .offset(x: 6, y: 5)
                }
                .position(x: center + dx, y: center + Self.lensDY)
        }
    }
}

#if DEBUG
#Preview("ThreeDGlasses") {
    ZStack {
        Color(hex: "#F6C49A")
        Accessories.ThreeDGlasses(mood: .energetic)
            .frame(width: PET_SIZE, height: PET_SIZE)
            .border(Color.red.opacity(0.3))
    }
    .frame(width: 240, height: 240)
}
#endif
