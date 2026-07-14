import SwiftUI

struct PodiumStage: View {
    let mood: Mood
    var petId: PetId = PET_ID_DEFAULT
    var screenHeight: CGFloat = RESPONSIVE_BASE_HEIGHT
    var accessories: [AccessoryId] = []

    var body: some View {
        VStack(spacing: -14) {
            PetStage(
                mood: mood,
                petId: petId,
                screenHeight: screenHeight,
                accessories: accessories
            )

            plinth(scale: computeScale(screenHeight))
        }
    }

    private func plinth(scale: CGFloat) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#F6DEC2"), Color(hex: "#EBCDA4")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 15)

            LinearGradient(
                colors: [Color(hex: "#EBCDA4"), Color(hex: "#D8AC7C")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 62)
            .overlay(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "#F5CD86"), Color(hex: "#DD9F4E")],
                            center: UnitPoint(x: 0.4, y: 0.35),
                            startRadius: 0,
                            endRadius: 24
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#8A5A2F"))
                    )
            )
            .padding(.horizontal, 14)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .frame(width: 156 * scale)
    }
}

#if DEBUG
#Preview("PodiumStage") {
    PodiumStage(
        mood: .calm,
        petId: .mochi
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
