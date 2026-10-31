import SwiftUI

struct PhoneCanvas<Content: View>: View {
    let mood: Mood
    let scenery: SceneryId
    private let content: Content

    @State private var groundLine: CGFloat? = nil

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
        .onPreferenceChange(GroundLinePreferenceKey.self) { groundLine = $0 }
    }

    private var backdrop: some View {
        // The backdrop ignores safe areas, so the fraction is taken against its own
        // full-screen frame — the same frame the scene lays itself out in.
        GeometryReader { geo in
            sceneryDefinition(scenery).backdrop(
                mood,
                groundY: GroundLine.fraction(groundLine, in: geo.frame(in: .global))
            )
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
