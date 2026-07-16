import SwiftUI

struct AccessoryCard: View {
    let name: String
    let petName: String
    let accessoryId: AccessoryId
    let isOwned: Bool
    let isEquipped: Bool
    let isPreviewing: Bool
    let steps: Int
    let goal: Int
    let progress: Double
    let onEquip: () -> Void
    let onPreview: () -> Void

    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let palette = tokens.palette

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                thumbnail(palette)

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(Fonts.headingMedium(17))
                        .foregroundColor(palette.text)

                    Text(statusLine)
                        .font(Fonts.bodyRegular(12))
                        .foregroundColor(isOwned ? palette.accent : palette.cardMeta)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if isOwned {
                Button(action: onEquip) {
                    Text(isEquipped ? "Unequip" : "Equip on \(petName)")
                        .font(Fonts.headingMedium(15))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(
                            LinearGradient(
                                colors: [palette.barFrom, palette.barTo],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                }
                .buttonStyle(.plain)
            } else {
                progressBlock(palette)
            }

            Text(previewFooter)
                .font(Fonts.bodyBold(11.5))
                .foregroundColor(palette.accent)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(palette.cardBg)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isOwned ? palette.accent.opacity(0.5) : palette.cardBorder, lineWidth: isOwned ? 1.5 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .contentShape(Rectangle())
        .onTapGesture(perform: onPreview)
    }

    private var statusLine: String {
        return isOwned
            ? "Unlocked · \(NumberFormat.grouped(goal)) steps this week"
            : "Walk \(NumberFormat.grouped(goal)) steps this week to unlock"
    }

    private var previewFooter: String {
        isPreviewing
            ? "Previewing — tap to remove"
            : "Tap to preview"
    }

    // MARK: - Pieces

    private func thumbnail(_ palette: Palette) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(palette.pillBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(palette.cardBorder, lineWidth: 1)
                )

            Accessory.define(accessoryId).view(.calm, 66, 1)
                .frame(width: 66, height: 66)
                .clipped()
        }
        .frame(width: 54, height: 54)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private func progressBlock(_ palette: Palette) -> some View {
        VStack(spacing: 7) {
            HStack {
                Text("Progress")
                    .font(Fonts.bodyBold(11.5))
                    .foregroundColor(palette.pillText)
                Spacer()
                Text("\(NumberFormat.grouped(min(steps, goal))) / \(NumberFormat.grouped(goal))")
                    .font(Fonts.bodyBold(11.5))
                    .foregroundColor(palette.pillText)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(palette.barTrack)

                    LinearGradient(
                        colors: [palette.barFrom, palette.barTo],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: proxy.size.width * progressFillFraction(progress))
                    .clipShape(Capsule())
                }
            }
            .frame(height: 8)
        }
    }
}

#if DEBUG
#Preview("AccessoryCard") {
    VStack(spacing: 16) {
        AccessoryCard(
            name: "Cool Shades",
            petName: "Mochi",
            accessoryId: .coolShades,
            isOwned: false,
            isEquipped: false,
            isPreviewing: false,
            steps: 4_200,
            goal: 8_000,
            progress: 0.52,
            onEquip: {},
            onPreview: {}
        )

        AccessoryCard(
            name: "Cool Shades",
            petName: "Mochi",
            accessoryId: .coolShades,
            isOwned: true,
            isEquipped: false,
            isPreviewing: true,
            steps: 8_000,
            goal: 8_000,
            progress: 1,
            onEquip: {},
            onPreview: {}
        )
    }
    .padding(22)
    .background(ThemeTokens.day.screenBackground(.calm).colors[1])
}
#endif
