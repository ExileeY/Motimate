import SwiftUI

struct WardrobeTile: View {
    let name: String
    let accessoryId: AccessoryId
    let isEquipped: Bool
    let onToggle: () -> Void

    @Environment(\.themeTokens) private var tokens

    private static let thumbSize: CGFloat = 66

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
        Accessory.define(accessoryId).view(.calm, Self.thumbSize, 1)
            .frame(width: Self.thumbSize, height: Self.thumbSize)
            .clipped()
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(palette.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        isEquipped ? palette.accent : palette.cardBorder,
                        lineWidth: isEquipped ? 2 : 1.5
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
