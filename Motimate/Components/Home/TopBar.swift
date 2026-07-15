import SwiftUI

func timeOfDay(hour: Int) -> String {
    if hour < 12 {
        return "Morning"
    }

    if hour < 18 {
        return "Afternoon"
    }

    return "Evening"
}

func formatClock(
    _ date: Date,
    calendar: Calendar = .current
) -> String {
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    return "\(hour):\(String(format: "%02d", minute))"
}

struct TopBar: View {
    let mood: Mood
    var onSettingsTap: () -> Void = {}
    var onPodiumTap: () -> Void = {}
    var onWardrobeTap: () -> Void = {}

    @Environment(\.themeTokens) private var tokens
    @State private var now = Date()

    private let timer = Timer.publish(
        every: 30,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        let palette = tokens.palette
        let dot = tokens.statusDot(mood)
        let hour = Calendar.current.component(.hour, from: now)

        HStack(alignment: .center) {
            PillBadge(
                text: timeOfDay(hour: hour),
                dotColor: dot,
                palette: palette,
                dotSize: 9,
                dotShadow: true,
                font: Fonts.bodyBold(12.5)
            )

            Spacer()

            HStack(spacing: 12) {
                Text(formatClock(now))
                    .font(Fonts.bodyBold(13))
                    .foregroundColor(palette.clock)

                Button(action: onPodiumTap) {
                    Image(systemName: "rosette")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(palette.clock)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .accessibilityLabel("Podium")

                Button(action: onWardrobeTap) {
                    Image(systemName: "tshirt")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(palette.clock)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .accessibilityLabel("Wardrobe")

                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(palette.clock)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .accessibilityLabel("Settings")
            }
        }
        .onReceive(timer) { date in
            now = date
        }
    }
}

#if DEBUG
#Preview("TopBar Moods") {
    VStack(spacing: 18) {
        ForEach(Mood.allCases, id: \.self) { mood in
            TopBar(mood: mood)
                .padding(22)
                .background(ThemeTokens.day.screenBackground(mood).colors[1])
        }
    }
    .padding()
}
#endif
