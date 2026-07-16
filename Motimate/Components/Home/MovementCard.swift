import SwiftUI

func movementMeta(
    message: MessageSet,
    steps: Int,
    hasLiveSteps: Bool,
    locale: Locale = .current
) -> String {
    guard hasLiveSteps else { return message.meta }

    let formattedSteps = steps.formatted(
        .number
            .grouping(.automatic)
            .locale(locale)
    )
    return "\(formattedSteps) steps"
}

func progressFillFraction(_ progress: Double) -> CGFloat {
    let clamped = MathUtils.clamp01(progress)
    return CGFloat((clamped * 100).rounded() / 100)
}

struct MovementCard: View {
    let message: MessageSet
    let steps: Int
    let progress: Double
    let hasLiveSteps: Bool

    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let palette = tokens.palette

        return VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .center) {
                Text("Today's movement")
                    .font(Fonts.bodyBold(13))
                    .foregroundColor(palette.pillText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 12)

                Text(
                    movementMeta(
                        message: message,
                        steps: steps,
                        hasLiveSteps: hasLiveSteps
                    )
                )
                .font(Fonts.bodyRegular(12))
                .foregroundColor(palette.cardMeta)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(palette.barTrack)

                    LinearGradient(
                        colors: [
                            palette.barFrom,
                            palette.barTo
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: proxy.size.width * progressFillFraction(progress))
                    .clipShape(Capsule())
                }
            }
            .frame(height: 8)

            Text(message.footer)
                .font(Fonts.bodyRegular(12.5))
                .foregroundColor(palette.cardFooter)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(palette.cardBg)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(palette.cardBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#if DEBUG
private let movementCardPreviewMessage = MessageSet(
    headline: "Tiny steps, big heart",
    subtitle: "Mochi is ready when you are.",
    meta: "quiet so far",
    footer: "A little walk will brighten the day."
)

#Preview("MovementCard") {
    VStack(spacing: 20) {
        MovementCard(
            message: movementCardPreviewMessage,
            steps: 1_234,
            progress: 0.42,
            hasLiveSteps: true
        )

        MovementCard(
            message: movementCardPreviewMessage,
            steps: 0,
            progress: 0,
            hasLiveSteps: false
        )
    }
    .padding(22)
    .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
