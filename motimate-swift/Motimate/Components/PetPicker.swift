import SwiftUI

struct PetPicker: View {
    @EnvironmentObject private var settings: SettingsStore

    fileprivate static let previewSize: CGFloat = 64
    fileprivate static let cardSize: CGFloat = 96

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(PET_IDS, id: \.self) { id in
                PetTile(
                    id: id,
                    selected: id == settings.petId,
                    onSelect: { settings.setPet($0) }
                )
            }
        }
    }
}

private struct PetTile: View {
    let id: PetId
    let selected: Bool
    let onSelect: (PetId) -> Void

    var body: some View {
        let def = petDefinition(id)

        Button(action: { onSelect(id) }) {
            VStack(spacing: 7) {
                card(def)
                    .overlay(alignment: .topTrailing) {
                        if selected {
                            badge
                                .padding(7)
                        }
                    }

                Text(def.name)
                    .font(Fonts.headingMedium(13.5))
                    .foregroundColor(Colors.text)
                    .lineLimit(1)
            }
            // Center the fixed-size card within its flexible grid column.
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(def.name)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }

    private func card(_ def: PetDefinition) -> some View {
        // Pet bodies render in a fixed 180×180 canvas and only *visually* shrink
        // via `.scaleEffect` (their layout footprint stays 180); pin the scaled
        // body to `previewSize` and clip it. The card itself is a fixed square,
        // so the icon is centered with identical margin on every tile and neither
        // the icon nor the tile changes size when selected.
        def.body(.calm, PetPicker.previewSize)
            .frame(width: PetPicker.previewSize, height: PetPicker.previewSize)
            .clipped()
            .frame(width: PetPicker.cardSize, height: PetPicker.cardSize)
            .background(Colors.cardBg)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                // `strokeBorder` draws the border *inside* the fixed bounds (like
                // RN's border-box), so a thicker selected border grows inward and
                // never nudges layout.
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        selected ? Colors.accent : Colors.cardBorder,
                        lineWidth: selected ? 2.5 : 1.5
                    )
            )
    }

    private var badge: some View {
        ZStack {
            Circle()
                .fill(Colors.accent)
                .frame(width: 22, height: 22)

            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#if DEBUG
#Preview("PetPicker") {
    let settings = SettingsStore()
    return PetPicker()
        .environmentObject(settings)
        .padding(22)
        .background(Colors.cardBg)
}
#endif
