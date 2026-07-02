import SwiftUI

struct PhoneCanvas<Content: View>: View {
    let mood: Mood
    private let content: Content

    init(
        mood: Mood,
        @ViewBuilder content: () -> Content
    ) {
        self.mood = mood
        self.content = content()
    }

    var body: some View {
        let background = screenBackground[mood]!

        ZStack {
            LinearGradient(
                stops: zip(background.colors, background.locations).map {
                    Gradient.Stop(color: $0, location: $1)
                },
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            BackgroundEmitters(mood: mood)
                .ignoresSafeArea()

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 22)
                .padding(.top, 8)
                .padding(.bottom, 24)
        }
    }
}

#if DEBUG
#Preview("PhoneCanvas Moods") {
    VStack(spacing: 0) {
        ForEach(Mood.allCases, id: \.self) { mood in
            PhoneCanvas(mood: mood) {
                Text(mood.rawValue.capitalized)
                    .font(Fonts.heading(24))
                    .foregroundColor(Colors.text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 160)
        }
    }
}
#endif
