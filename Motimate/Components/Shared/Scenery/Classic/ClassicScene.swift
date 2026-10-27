import SwiftUI

/// The Classic scenery view.
struct ClassicScene: View {
    let mood: Mood

    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let background = tokens.screenBackground(mood)

        ZStack {
            LinearGradient(
                stops: zip(background.colors, background.locations).map {
                    Gradient.Stop(color: $0, location: $1)
                },
                startPoint: .top,
                endPoint: .bottom
            )

            BackgroundEmitters(mood: mood)
        }
    }
}

#if DEBUG
#Preview("ClassicScene Moods") {
    VStack(spacing: 0) {
        ForEach(Mood.allCases, id: \.self) { mood in
            ClassicScene(mood: mood)
                .frame(height: 200)
        }
    }
}
#endif
