import SwiftUI

struct WardrobeTile: View {
    let name: String
    let accessoryId: AccessoryId
    let isEquipped: Bool
    let onToggle: () -> Void

    @Environment(\.themeTokens) private var tokens

    static let cardSize: CGFloat = 96
    static let previewSize: CGFloat = 64

    var body: some View {
        let palette = tokens.palette

        return Button(action: onToggle) {
            VStack(spacing: 7) {
                thumbnail(palette)
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

    private func thumbnail(_ palette: Palette) -> some View {
        Accessory.define(accessoryId).view(.calm, Self.previewSize, 1)
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
            accessoryId: .coolShades,
            isEquipped: false,
            onToggle: {}
        )
        WardrobeTile(
            name: "Baby Mochi",
            accessoryId: .babyMochi,
            isEquipped: true,
            onToggle: {}
        )
    }
    .padding(22)
    .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
