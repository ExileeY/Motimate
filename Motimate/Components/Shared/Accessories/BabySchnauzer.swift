import SwiftUI

extension Accessories {
    struct BabySchnauzer: View {
        let mood: Mood
        var size: CGFloat = PET_SIZE
        var spread: CGFloat = 1

        private static let BASE: CGFloat = PET_SIZE
        private static let BABY: CGFloat = 64

        var body: some View {
            SchnauzerBody(mood: .calm, size: Self.BABY)
                .frame(width: Self.BASE, height: Self.BASE)
                .scaleEffect(size / Self.BASE)
        }
    }
}

#if DEBUG
#Preview("BabySchnauzer") {
    ZStack {
        Color(hex: "#F6C49A")
        Accessories.BabySchnauzer(mood: .energetic)
            .frame(width: PET_SIZE, height: PET_SIZE)
            .border(Color.red.opacity(0.3))
    }
    .frame(width: 240, height: 240)
}
#endif
