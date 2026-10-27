import SwiftUI

struct WardrobeTile: View {
    let name: String
    let isEquipped: Bool
    let onToggle: () -> Void
    private let thumbnail: AnyView

    @Environment(\.themeTokens) private var tokens

    static let cardSize: CGFloat = 96
    static let previewSize: CGFloat = 64

    init<Thumbnail: View>(
        name: String,
        isEquipped: Bool,
        onToggle: @escaping () -> Void,
        @ViewBuilder thumbnail: () -> Thumbnail
    ) {
        self.name = name
        self.isEquipped = isEquipped
        self.onToggle = onToggle
        self.thumbnail = AnyView(thumbnail())
    }

    var body: some View {
        let palette = tokens.palette

        return Button(action: onToggle) {
            VStack(spacing: 7) {
                card(palette)
                    .overlay(alignment: .topTrailing) {
                        if isEquipped {
                            badge(palette)
                                .padding(7)
                        }
                    }

                Text(name)
                    .font(Fonts.headingMedium(13.5))
                    .foregroundColor(palette.text)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(name)
        .accessibilityAddTraits(isEquipped ? [.isSelected] : [])
    }

    private func card(_ palette: Palette) -> some View {
        thumbnail
            .frame(width: Self.previewSize, height: Self.previewSize)
            .clipped()
            .frame(width: Self.cardSize, height: Self.cardSize)
            .background(palette.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        isEquipped ? palette.accent : palette.cardBorder,
                        lineWidth: isEquipped ? 2.5 : 1.5
                    )
            )
    }

    private func badge(_ palette: Palette) -> some View {
        ZStack {
            Circle()
                .fill(palette.accent)
                .frame(width: 22, height: 22)

            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#if DEBUG
#Preview("WardrobeTile") {
    HStack(spacing: 12) {
        WardrobeTile(
            name: "Cool Shades",
            isEquipped: false,
            onToggle: {}
        ) {
            Accessory.define(.coolShades).view(.calm, WardrobeTile.previewSize, 1)
        }
        WardrobeTile(
            name: "Meadow",
            isEquipped: true,
            onToggle: {}
        ) {
            MeadowScene(mood: .calm)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
    .padding(22)
    .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
