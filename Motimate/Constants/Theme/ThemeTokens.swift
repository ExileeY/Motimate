import SwiftUI

struct ThemeTokens {
    let theme: Theme
    let palette: Palette

    let screenBgTokens: ScreenBgTokens
    let stageGlowTokens: StageGlowTokens
    let statusDotTokens: StatusDotTokens

    func screenBackground(_ mood: Mood) -> ScreenBackground {
        screenBgTokens.resolve(theme, mood)
    }

    func glow(_ mood: Mood) -> GlowSpec {
        stageGlowTokens.resolve(theme, mood)
    }

    func statusDot(_ mood: Mood) -> Color {
        statusDotTokens.resolve(theme, mood)
    }

    static let day = ThemeTokens(
        theme: .day,
        palette: .day,
        screenBgTokens: screenBackgroundData,
        stageGlowTokens: glowData,
        statusDotTokens: statusDotData
    )

    static let night = ThemeTokens(
        theme: .night,
        palette: .night,
        screenBgTokens: screenBackgroundData,
        stageGlowTokens: glowData,
        statusDotTokens: statusDotData
    )

    static func `for`(_ theme: Theme) -> ThemeTokens {
        theme == .night ? .night : .day
    }
}

#if DEBUG
#Preview("Theme tokens") {
    VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading, spacing: 4) {
            Text("Fredoka SemiBold").font(Fonts.heading(22)).foregroundColor(Colors.text)
            Text("Fredoka Medium").font(Fonts.headingMedium(18)).foregroundColor(Colors.pillText)
            Text("Nunito Regular — the quick brown fox").font(Fonts.bodyRegular(15)).foregroundColor(Colors.subtitle)
            Text("Nunito Bold — the quick brown fox").font(Fonts.bodyBold(15)).foregroundColor(Colors.text)
        }
        ForEach(Mood.allCases, id: \.self) { mood in
            let bg = ThemeTokens.day.screenBackground(mood)
            HStack(spacing: 12) {
                LinearGradient(
                    stops: zip(bg.colors, bg.locations).map { Gradient.Stop(color: $0, location: $1) },
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 120, height: 44)
                .cornerRadius(8)
                Circle().fill(ThemeTokens.day.glow(mood).color).frame(width: 28, height: 28)
                Circle().fill(ThemeTokens.day.statusDot(mood)).frame(width: 14, height: 14)
                Text(mood.rawValue).font(Fonts.bodyRegular(13)).foregroundColor(Colors.cardMeta)
            }
        }
    }
    .padding()
}
#endif
