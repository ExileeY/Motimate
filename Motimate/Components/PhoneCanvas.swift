import SwiftUI

struct PhoneCanvas<Content: View>: View {
    let mood: Mood
    let scenery: SceneryId
    private let content: Content

    init(
        mood: Mood,
        scenery: SceneryId = .classic,
        @ViewBuilder content: () -> Content
    ) {
        self.mood = mood
        self.scenery = scenery
        self.content = content()
    }

    var body: some View {
        ZStack {
            backdrop
                .ignoresSafeArea()

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 22)
                .padding(.top, 8)
                .padding(.bottom, 24)
        }
    }

    private var backdrop: some View {
        sceneryDefinition(scenery).backdrop(mood)
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
