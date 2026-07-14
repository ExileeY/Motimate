import SwiftUI

struct Glow: View {
    let mood: Mood
    let size: CGFloat

    var body: some View {
        ZStack {
            Halo(
                mood: mood,
                size: size
            )
        }
        .frame(width: size, height: size)
        .clipped()
        .allowsHitTesting(false)
    }
}

#if DEBUG
#Preview("Glow") {
    VStack(spacing: 16) {
        ForEach(Mood.allCases, id: \.self) { mood in
            Glow(
                mood: mood,
                size: BOX_SIZE
            )
            .background(ThemeTokens.day.screenBackground(mood).colors[1])
        }
    }
    .padding()
}
#endif
