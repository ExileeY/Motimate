import SwiftUI

struct SceneryPicker: View {
    @EnvironmentObject private var settings: SettingsStore

    @State private var sceneryAwaitingConfirmation: SceneryId? = nil

    fileprivate static let cardSize: CGFloat = 96

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(SCENERY_IDS, id: \.self) { id in
                SceneryTile(
                    id: id,
                    selected: id == settings.sceneryId,
                    onSelect: select
                )
            }
        }
        .alert(
            "Stop following system appearance?",
            isPresented: confirmingScenery,
            presenting: sceneryAwaitingConfirmation
        ) { id in
            Button("Cancel", role: .cancel) {}
            Button("Use scene") { settings.setScenery(id) }
        } message: { _ in
            Text("Scenes have their own look, so Follow system appearance will be turned off.")
        }
    }

    /// SwiftUI writes `false` here when any alert button dismisses it, which clears the pending scenery.
    private var confirmingScenery: Binding<Bool> {
        Binding(
            get: { sceneryAwaitingConfirmation != nil },
            set: { if !$0 { sceneryAwaitingConfirmation = nil } }
        )
    }

    private func select(_ id: SceneryId) {
        HapticsService.impact(.light, enabled: settings.hapticsTabEnabled)

        guard id != settings.sceneryId else { return }

        if settings.shouldConfirmDisablingAutoNight(for: id) {
            sceneryAwaitingConfirmation = id
            return
        }

        settings.setScenery(id)
    }
}

private struct SceneryTile: View {
    let id: SceneryId
    let selected: Bool
    let onSelect: (SceneryId) -> Void

    @Environment(\.themeTokens) private var tokens

    var body: some View {
        let def = sceneryDefinition(id)
        let palette = tokens.palette

        return Button(action: { onSelect(id) }) {
            VStack(spacing: 7) {
                card(def, palette)
                    .overlay(alignment: .topTrailing) {
                        if selected {
                            badge(palette)
                                .padding(7)
                        }
                    }

                Text(def.name)
                    .font(Fonts.headingMedium(13.5))
                    .foregroundColor(palette.text)
                    .lineLimit(1)
            }
            // Center the fixed-size card within its flexible grid column.
            .frame(maxWidth: .infinity)
            // Backdrops may opt out of hit testing (they're Home backgrounds), so the
            // tile defines its own tap area rather than relying on what the scene draws.
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(def.name)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }

    private func card(_ def: SceneryDefinition, _ palette: Palette) -> some View {
        // A scene is a backdrop, so it fills the whole card rather than sitting
        // inset like a pet icon; scenery layouts are fractions of their own frame.
        def.backdrop(.calm)
            .frame(width: SceneryPicker.cardSize, height: SceneryPicker.cardSize)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        selected ? palette.accent : palette.cardBorder,
                        lineWidth: selected ? 2.5 : 1.5
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
#Preview("SceneryPicker") {
    let settings = SettingsStore()
    return SceneryPicker()
        .environmentObject(settings)
        .padding(22)
        .background(Colors.cardBg)
}
#endif
