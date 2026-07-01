import SwiftUI

private struct ModeOption {
    let id: GameMode
    let title: String
    let icon: String
    let subtitle: String
    let isDefault: Bool
}

struct ModePicker: View {
    @EnvironmentObject private var settings: SettingsStore

    @State private var confirmingReal = false

    private let options: [ModeOption] = [
        ModeOption(
            id: .standard,
            title: "Standard",
            icon: "🍃",
            subtitle: "Your pet stays happy and safe, no matter your step count.",
            isDefault: true
        ),
        ModeOption(
            id: .real,
            title: "Real",
            icon: "🔥",
            subtitle: "Steps become food. Walk too little and your pet goes hungry.",
            isDefault: false
        ),
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(options, id: \.id) { option in
                ModeRow(
                    option: option,
                    selected: option.id == settings.gameMode,
                    onSelect: select
                )
            }
        }
        .alert("Your pet is in danger!", isPresented: $confirmingReal) {
            Button("Cancel", role: .cancel) {}
            Button("Enable", role: .destructive) {
                settings.setGameMode(.real)
            }
        } message: {
            Text("When this mode is enabled, your steps are converted into food for your pet. If the pet gets hungry, it will suffer.")
        }
    }

    private func select(_ id: GameMode) {
        if id == settings.gameMode { return }

        if id == .real {
            confirmingReal = true
            return
        }

        settings.setGameMode(id)
    }

    fileprivate struct ModeRow: View {
        let option: ModeOption
        let selected: Bool
        let onSelect: (GameMode) -> Void

        var body: some View {
            Button(action: { onSelect(option.id) }) {
                HStack(spacing: 13) {
                    iconTile

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 7) {
                            Text(option.title)
                                .font(Fonts.heading(16.5))
                                .foregroundColor(Colors.text)

                            if option.isDefault {
                                defaultPill
                            }
                        }

                        Text(option.subtitle)
                            .font(Fonts.bodyRegular(12))
                            .foregroundColor(Colors.subtitle)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    radio
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(Colors.cardBg)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            selected ? Colors.accent : Colors.cardBorder,
                            lineWidth: selected ? 2 : 1.5
                        )
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(option.title)
            .accessibilityAddTraits(selected ? [.isSelected] : [])
        }

        private var iconTile: some View {
            Text(option.icon)
                .font(.system(size: 22))
                .frame(width: 46, height: 46)
                .background(Colors.pillBg)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }

        private var defaultPill: some View {
            Text("Default")
                .font(Fonts.bodyBold(9.5))
                .kerning(0.5)
                .textCase(.uppercase)
                .foregroundColor(Colors.cardMeta)
                .padding(.vertical, 2)
                .padding(.horizontal, 7)
                .background(Colors.barTrack)
                .clipShape(Capsule())
        }

        private var radio: some View {
            ZStack {
                Circle()
                    .fill(selected ? Colors.accent : Color.clear)
                    .overlay(
                        Circle()
                            .stroke(
                                selected ? Color.clear : Colors.pillBorder,
                                lineWidth: 2
                            )
                    )
                    .frame(width: 24, height: 24)

                if selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#if DEBUG
#Preview("ModePicker") {
    let settings = SettingsStore()
    return ModePicker()
        .environmentObject(settings)
        .padding(22)
}
#endif
