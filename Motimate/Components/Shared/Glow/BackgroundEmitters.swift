import SwiftUI

struct BackgroundEmitters: View {
    let mood: Mood

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if mood == .energetic {
                    BackgroundParticles(area: geo.size)
                }
                if mood == .tired {
                    CloudDrift(area: geo.size)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        .allowsHitTesting(false)
    }
}

#if DEBUG
#Preview("BackgroundEmitters") {
    BackgroundEmitters(mood: .energetic)
        .background(ThemeTokens.day.screenBackground(.energetic).colors[1])
        .ignoresSafeArea()
}
#endif
