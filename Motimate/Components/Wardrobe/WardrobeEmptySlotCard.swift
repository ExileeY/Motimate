import SwiftUI

struct WardrobeEmptySlotCard: View {
    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let palette = tokens.palette

        return Text("Nothing here yet — earn it on the podium")
            .font(Fonts.bodyRegular(12.5))
            .foregroundColor(palette.cardMeta)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(palette.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        palette.cardBorder,
                        style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])
                    )
            )
    }
}

#if DEBUG
#Preview("WardrobeEmptySlotCard") {
    WardrobeEmptySlotCard()
        .padding(22)
        .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
