import SwiftUI

struct WeeklyPlaceholderCard: View {
    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let palette = tokens.palette

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                thumbnail(palette)

                VStack(alignment: .leading, spacing: 2) {
                    Text("All collected")
                        .font(Fonts.headingMedium(17))
                        .foregroundColor(palette.text)

                    Text("Every accessory is yours")
                        .font(Fonts.bodyRegular(12))
                        .foregroundColor(palette.accent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text("New challenges arrive with new accessories")
                .font(Fonts.bodyBold(11.5))
                .foregroundColor(palette.cardMeta)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(palette.cardBg)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(palette.accent.opacity(0.5), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func thumbnail(_ palette: Palette) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(palette.pillBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(palette.cardBorder, lineWidth: 1)
                )

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(palette.accent)
        }
        .frame(width: 54, height: 54)
    }
}

#if DEBUG
#Preview("WeeklyPlaceholderCard") {
    WeeklyPlaceholderCard()
        .padding(22)
        .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
