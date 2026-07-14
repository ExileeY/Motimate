import SwiftUI

struct ScreenHeader<Trailing: View>: View {
    let palette: Palette
    let title: String
    let onBack: () -> Void
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onBack) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(palette.text)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Back")

            Text(title)
                .font(Fonts.heading(24))
                .foregroundColor(palette.text)

            Spacer()

            trailing()
        }
    }
}

extension ScreenHeader where Trailing == EmptyView {
    init(palette: Palette, title: String, onBack: @escaping () -> Void) {
        self.init(
            palette: palette,
            title: title,
            onBack: onBack,
            trailing: { EmptyView() }
        )
    }
}

#if DEBUG
#Preview("ScreenHeader") {
    VStack(spacing: 24) {
        ScreenHeader(
            palette: .day,
            title: "Settings",
            onBack: {}
        )

        ScreenHeader(
            palette: .day,
            title: "Podium",
            onBack: {}
        ) {
            PillBadge(
                text: "10,234",
                dotColor: Palette.day.accent,
                palette: .day,
                dotSize: 7,
                font: Fonts.bodyBold(11.5),
                spacing: 6,
                horizontalPadding: 10
            )
        }
    }
    .padding()
}
#endif
