import SwiftUI

extension Accessories {
    struct BabyMochi: View {
        let mood: Mood            // ignored — the baby is always cheerful
        var size: CGFloat = PET_SIZE
        var spread: CGFloat = 1   // unused; kept for the (Mood, CGFloat, CGFloat) registry signature

        private static let BASE: CGFloat = PET_SIZE
        private static let BABY: CGFloat = 64

        var body: some View {
            MochiBody(mood: .calm, size: Self.BABY)
                .frame(width: Self.BASE, height: Self.BASE)
                .scaleEffect(size / Self.BASE)
        }
    }
}

#if DEBUG
#Preview("BabyMochi") {
    ZStack {
        Color(hex: "#F6C49A")
        Accessories.BabyMochi(mood: .energetic)
            .frame(width: PET_SIZE, height: PET_SIZE)
            .border(Color.red.opacity(0.3))
    }
    .frame(width: 240, height: 240)
}
#endif
