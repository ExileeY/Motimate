import SwiftUI

struct PillBadge: View {
    let text: String
    let dotColor: Color
    let palette: Palette
    var dotSize: CGFloat = 8
    var dotShadow: Bool = false
    var font: Font = Fonts.bodyBold(12)
    var spacing: CGFloat = 7
    var horizontalPadding: CGFloat = 12
    var verticalPadding: CGFloat = 6

    var body: some View {
        HStack(spacing: spacing) {
            Circle()
                .fill(dotColor)
                .frame(width: dotSize, height: dotSize)
                .shadow(
                    color: dotShadow ? dotColor.opacity(0.9) : .clear,
                    radius: dotShadow ? 4 : 0
                )

            Text(text)
                .font(font)
                .foregroundColor(palette.pillText)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(palette.pillBg)
        .overlay(
            Capsule().stroke(palette.pillBorder, lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}

#if DEBUG
#Preview("PillBadge") {
    VStack(spacing: 14) {
        PillBadge(
            text: "Morning",
            dotColor: Palette.day.accent,
            palette: .day,
            dotSize: 9,
            dotShadow: true,
            font: Fonts.bodyBold(12.5)
        )
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
    .padding()
}
#endif
